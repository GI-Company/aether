<div align="center">

# Aether — Browser‑Native OS

White Paper (Beta, 2025‑Q4)

</div>

---

## Executive Summary

Aether is a browser‑native operating environment: a desktop‑like user experience built with web technologies (React/Vite) that connects to a small Go "kernel" over a message bus (WebSocket). It delivers a developer workstation anywhere a browser runs: Monaco code editor with AI, a WASI/WASM compute sandbox (wazero), and a unified VM abstraction (`vm.*`) that supports pluggable backends, including a browser‑embedded v86 VM (preview). Beyond individual tasks, Aether implements intent‑first orchestration: the user states a goal, an AI planner returns a bounded, guardrailed DAG, and the kernel executes it with temporal memory (past/present/future). A Foundry module lets teams save and instantiate reusable DAG recipes.

This paper describes the architecture, protocols, security and isolation model, guardrails (permissions, rate limits, resource caps), performance characteristics, deployment models (single binary, container), and the completed intent‑first orchestration surface (planner/executor/memory) with Foundry recipes.

---

### Frontend Overview (at a glance)

The frontend is a desktop‑style web application (React/Vite) that connects to the kernel at `/ws`, registers browser services (VFSProxy and a preview v86 compute adapter), and uses a unified bus client with correlated requests and derived error topics. Guardrail errors (`permission_denied`, `rate_limited`, `timeout`, etc.) are surfaced via a global toast service for consistent UX.

---

## Problem & Motivation

- Developer velocity suffers when onboarding and environment setup are heavyweight or inconsistent.
- Enterprise control planes are complex: agents, per‑service APIs, and disparate ops tooling.
- Secure multi‑tenant compute near the developer (edge/browser) is under‑utilized, despite modern WASM capabilities.

Enter Aether: a singular desktop‑in‑the‑browser with a minimal server, a unified event bus, and sandboxed compute backends.

---

## Solution Overview

Core ideas:
- Browser‑native desktop UX with applications: Editor (Monaco+AI), WASM Runner, others.
- Message Bus over WebSocket using JSON Envelopes (publish/subscribe + request/response semantics).
- Unified compute layer (`vm.*`) with pluggable backends:
  - `wazero` (server‑side, WASI/WASM; default)
  - `v86` (client‑side browser VM; preview) routed via addressed delivery by `sessionId`.
- Task Engine (`task.*`) to orchestrate DAGs of bus actions with retries, timeouts, and events.
- VFS (browser IndexedDB) with session scoping and addressed delivery.

- Intent‑First Orchestration
  - Planner (`ai.intent.plan`) translates high‑level goals into bounded, validateable task graphs (DAGs) using standard node types (e.g., `mem.query`, `sense`, `ai.step`, `bus.request`).
  - Executor (`ai.intent.execute`) bridges plans into `task.*` runs and streams progress (`task.event/done/error`).
  - Temporal memory (`mem.past|present|future.*`) provides context (history, current signals, future checkpoints) over the same bus.

- Foundry (Recipes)
  - Recipes (`foundry.recipe.*`) persist parameterizable DAGs for reuse and sharing; they can be instantiated into plans and executed (with optional dry‑run).

---

## Architecture

High‑level components:
- Frontend (React/Vite): Desktop shell, apps, WebSocket client, VFSProxy (IndexedDB), v86 adapter.
- Kernel (Go): WebSocket hub, in‑process Bus, services (AI, VFS relay, WASM Runner, VM Bridge, Task Engine).
- Protocol: JSON Envelope with topics/payloads, optional addressed delivery, and `_request_id` for correlation.

Envelope:
```json
{
  "topic": "vm.spawn",
  "from": "client-123",
  "to": "client-456",
  "payload": { "_request_id": "..." },
  "time": "2025-11-22T00:00:00Z"
}
```

Topic namespaces:
- `ai.*` — AI autocomplete/chat; correlated replies & errors.
- `vm.*` — compute control (`spawn`, `stdin`, `kill`) and streams (`stdout`, `stderr`, `exit`, errors).
- `wasm.*` — legacy WASM control and streams (bridged to/from `vm.*`).
- `vfs:*` — VFS CRUD through the browser VFSProxy, session‑scoped.
- `task.*` — DAG define/run/cancel/status; events `task.event/done/error`.

Request/Response:
- Clients attach `_request_id` and listen for correlated replies on specific reply topics.
- Kernel provides helpers `Reply()` and `EmitError()` with a standard error schema.

Standardized error payload:
```json
{ "_request_id": "...", "code": "permission_denied|rate_limited|payload_too_large|timeout|...", "error": "...", "details": { } }
```

### Frontend System Design

The browser desktop is a first‑class component of the system. It is responsible for rendering the workspace UI, managing app windows, and acting as a well‑behaved client on the bus.

- Desktop shell (React/Vite):
  - Components under `frontend/src/desktop/` implement the window manager, Dock, and desktop shortcuts.
  - Windows are draggable/resizable and clamped to the viewport; minimize preserves state.
- Bus client (`frontend/src/services/websocket.js`):
  - Subscriptions with reconnect/resubscribe; wildcard fan‑out (suffix `*`).
  - `sendRequest()` helper attaches `_request_id`, awaits correlated reply, and auto‑derives the error topic to reject early on failures.
  - Error topic derivation mirrors the kernel: `:error` for coloned topics (e.g., `vfs:write:error`), `.error` for dotted topics (e.g., `vm.spawn.error`).
- VFSProxy (`frontend/src/services/vfsProxy.ts`):
  - Registers `vfs:register { sessionId }` and answers `vfs:*` requests using IndexedDB storage.
  - Correlated replies use `*:ack`/`*:resp` and echo `_request_id`.
- v86 adapter (`frontend/src/services/v86Adapter.js`):
  - Registers `compute:register { sessionId }` for addressed delivery.
  - For now returns a deterministic `runtime_pending` error for `backend:"v86"` spawns until the Worker runtime lands.
- Error toasts (`frontend/src/services/toast.js`):
  - A lightweight toast service subscribes to `vm.*`, `vfs:*`, `ai.*`, `task.*` and surfaces any error topics with their `code` and `error` fields.

- Orchestrator & Foundry (windows):
  - Orchestrator provides an intent input → plan preview (nodes/edges list) → execute with live `task.*` progress and a simple timeline view backed by `mem.*` queries.
  - Foundry lists recipes, shows details, supports save and instantiate flows (launching Orchestrator with parameters).

Frontend UX guidelines:
- Always use correlated requests for user‑initiated actions; display timeouts within 3–10s.
- Key UI should remain responsive even under back‑pressure (rate limits) and display actionable messages.
- Provide accessible controls and keyboard shortcuts (e.g., Ctrl/Cmd+S for Save to VFS).

---

## Compute Layer (`vm.*`)

Abstraction:
- Control topics: `vm.spawn`, `vm.stdin`, `vm.kill`.
- Stream topics: `vm.stdout`, `vm.stderr`, `vm.exit`, `vm.error`.
- Correlated ACK: `vm.spawn:ack { _request_id, instanceId, backend }`.

Backends:
- `wazero` (server‑side WASI/WASM)
  - Safe by design; supports capturing stdout/stderr and stdin; exit codes via `wazero/sys.ExitError`.
  - Guardrails: per‑instance memory/time/idle caps (Beta hardening).
- `v86` (browser VM; preview)
  - Routed by `sessionId` using addressed delivery to the correct tab.
  - MVP: stub returns `runtime_pending` until Worker runtime is enabled (feature‑flagged).

Compatibility:
- `wasm.*` topics remain for legacy; the VM Bridge mirrors to/from `vm.*` and annotates `backend`.

---

## Intent‑First Orchestration and Temporal Memory

Motivation: Instead of issuing imperative commands, users express goals. The system plans a DAG that is safe (bounded by caps), explainable (nodes/edges), and observable (events). The same guardrails (permissions, limits, timeouts) apply.

Topic contracts (request → reply; errors use derived error topics and standard payloads):

- Planner
  - `ai.intent.plan` → `{ _request_id, goal, context?, horizon?: { past?: bool, present?: bool, future?: bool }, constraints? }`
  - `ai.intent.plan:resp` → `{ _request_id, plan: { graphId, nodes: [...], edges: [...] }, notes? }`

- Executor
  - `ai.intent.execute` → `{ _request_id, plan: { graphId?, nodes, edges }, options?: { dryRun?: bool } }`
  - `ai.intent.execute:ack` → `{ _request_id, runId }`
  - Streams: `task.event`, `task.done`, `task.error` (optional `ai.intent.event` milestones)

- Memory (VFS‑backed)
  - `mem.past|present|future.put` → `:ack`
  - `mem.past|present|future.get` → `:resp { key, value, tags?, ts }`
  - `mem.past|present|future.query` → `:resp { items: [...] }`

Node taxonomy:

- Retrieval (`mem.query`) — query `mem.past` for relevant context.
- Sensing (`sense`) — gather present state (e.g., `vfs:list`, `task.status`).
- Reasoning (`ai.step`) — call `ai.chat`/`ai.complete` with bounded context to decide next steps.
- Actuation (`bus.request`/`bus.publish`) — execute side‑effects (e.g., `vfs:write`, `vm.spawn`).
- Guards (`guard`) — enforce policy checks or rate/permission preconditions and branch/fail early.

Guardrails:

- Permissions: default‑deny when rules exist; admin bypass for trusted tooling.
- Rate limits: per‑client/topic (e.g., `ai.intent.plan`, `ai.intent.execute`).
- Timeouts: per‑node and run‑level; prompt/context size caps; standardized errors with `{ code, error, details? }`.

End‑to‑end example:

Goal: "Update authentication module to latest security standards, test integration, summarize outcomes."

Plan (simplified): `mem.query(auth history)` → `sense(vfs:list auth/*)` → `ai.step(plan)` → `vfs:write(patches)` → `vm.spawn(tests)` → `ai.step(summary)` → `mem.future.put(checkpoints)`.

Execution: `ai.intent.execute` returns `{ runId }`; client observes `task.event/done/error` until completion; results are persisted into `mem.past`.

---

## Foundry (Reusable DAG Recipes)

Foundry promotes repeatability and sharing by storing DAGs as recipes, with optional parameter schemas and tags.

Topics:

- `foundry.recipe.create` → `:ack { id }`
- `foundry.recipe.list|query` → `:resp { items }`
- `foundry.recipe.instantiate` → `:ack { plan }`

Persistence: Recipes are stored via `mem.*` and indexed under `/recipes` for discovery. Instantiation returns a plan suitable for `ai.intent.execute` (or executes immediately when `autoRun`/policy allows).

Guardrails: Permissions and rate limits apply to `foundry.*`; dry‑run mode is recommended in regulated environments.

---

## Task Engine (`task.*`)

Define DAGs of actions that publish or request bus topics.

Topics:
- `task.define` → `{ _request_id, graphId, nodes: [...], edges: [...] }` → `task.define:ack`
- `task.run` → `{ _request_id, graphId }` → `task.run:ack { runId }`
- `task.cancel` → `{ _request_id, runId }` → `task.cancel:ack`
- `task.status` → `{ _request_id, runId }` → `task.status:resp`
- Streams: `task.event`, `task.done`, `task.error`

Execution (MVP): sequential with retries/timeouts; global run timeout; cancellation propagation.

---

## Guardrails: Permissions, Rate Limits, Resource Caps (2025-Q4)

This section formalizes the guardrails layer introduced in the Beta hardening phase. The goal is to provide principled safety and predictable behavior across all subsystems without changing public APIs.

### 1) Permissions (topic-level allow/deny)
- Model: ordered list of rules `{ topic_prefix, allow }` evaluated top-to-bottom.
- Default policy:
  - If the rule list is empty → default-allow (developer convenience).
  - If the rule list is non-empty → default-deny for non-matching topics (principle of least authority).
- Admin bypass: When a client connects with `Authorization: Bearer <admin_token>`, and the token matches the configured `admin_token`, the client is marked `IsAdmin=true` and bypasses permission checks (and rate limits). This is intended for trusted administrative tooling.
- Enforcement point: WebSocket hub (ingress) validates all client-originated publications before routing.

### 2) Rate limits (token buckets)
- Model: per-(clientId, topic) token buckets with time-based refill.
- Configuration (YAML):
  ```yaml
  rate_limits:
    - topic: "vm.spawn"
      limit: 5
      burst: 2
      window_ms: 60000
    - topic: "ai.chat"
      limit: 10
      burst: 5
      window_ms: 60000
  ```
- Enforcement point: WebSocket hub prior to publishing onto the bus. Admins bypass checks.
- Behavior on exceed: publish a correlated error on the derived error topic with payload:
  ```json
  { "_request_id": "...", "code": "rate_limited", "error": "rate limit exceeded", "details": { "topic": "vm.spawn", "resetMs": 1234 } }
  ```

### 3) Resource caps (compute and tasks)
- Wazero (WASM): per-instance memory/page caps; wall-time and idle timeouts enforced via context deadlines. On breach, the instance is killed and a structured `vm.error` is produced (`timeout` or `resource_exceeded`).
- Task Engine: per-run/node timeouts; cancellation of downstream nodes on breach; structured `task.error` with `runId/nodeId` in `details`.

---

## Standardized Errors and Topics

To ensure consistent error handling and UX, Aether adopts a derived error-topic convention and a uniform error payload across subsystems.

### Error topic derivation
- If the request topic contains `:` (e.g., `vfs:write`) → error topic is `<topic>:error` (e.g., `vfs:write:error`).
- Else if the request topic contains `.` (e.g., `vm.spawn`) → error topic is `<topic>.error` (e.g., `vm.spawn.error`).
- Else → fallback `error`.

### Error payload schema
Examples (fields without `?` are always present in error envelopes; optional fields are shown in a separate example):

```json
{ "_request_id": "abc123", "code": "permission_denied", "error": "topic not allowed" }
```

```json
{ "_request_id": "abc123", "code": "rate_limited", "error": "rate limit exceeded", "details": { "topic": "vm.spawn", "resetMs": 1200 } }
```

### Canonical error codes
- `permission_denied`, `rate_limited`, `payload_too_large`, `timeout`, `resource_exceeded`, `not_found`, `internal_error`, `payload_invalid`, `missing_session`, `unsupported_backend`, `no_compute_handler`.

Frontend clients should key UX off of `code`, and display `error` as human-readable text; `details` is for diagnostics.

---

## Operational Configuration

The kernel reads `config.yaml` (override path via `AETHER_CONFIG_FILE`) and supports environment overrides for critical fields (`HTTP_PORT`, `AETHER_ADMIN_TOKEN`, etc.).

Key fields:
- `http_port`: listen port (default 8080)
- `ai_enabled`: start AI service if true and `GEMINI_API_KEY` is present
- `admin_token`: bearer token that grants admin privileges
- `permissions`: ordered allow/deny rules
- `rate_limits`: per-topic token buckets

These settings enable principled multi-tenant deployments and predictable behavior under load.

---

## Security Model (updated)

- Isolation:
  - Browser-side VFS per-tab with addressed delivery by `sessionId`.
  - WASM/WASI sandbox via `wazero`; explicit capability instantiation for host functions.
- Ingress controls:
  - Topic permissions (default-deny when configured); admin bypass.
  - Per-(client, topic) rate limits.
- Accountability:
  - Correlated request/response via `_request_id`.
  - Derived error topics with consistent payload shape.

---

## VFS (Browser IndexedDB)

Per‑tab `sessionId`. The VFSProxy registers `vfs:register { sessionId }` and handles CRUD with correlation:
- `vfs:write`, `vfs:read`, `vfs:list`, `vfs:delete`, `vfs:rename`.
Kernel relays requests to the correct tab using addressed delivery; defensive session checks prevent cross‑handling.

---

## Security, Isolation, and Guardrails

Isolation layers:
- WASI/WASM (wazero) sandboxing by default (no host‑privileged syscalls unless explicitly bridged).
- Session scoping for VFS and browser‑backed compute (v86) via addressed delivery.

Guardrails (Beta hardening):
- Permissions (topic guards): config‑driven allow/deny per topic group (`ai.*`, `vm.*`, `vfs:*`, `task.*`).
- Rate limits: per‑session token buckets (e.g., `vm.spawn`, `task.run`, `ai.chat`, `vfs:write`).
- Resource caps & timeouts:
  - Wazero per‑instance memory and wall/idle limits → `vm.error { code: resource_exceeded|timeout }`.
  - Task Engine global run timeout + per‑node defaults; cancel propagation.
- Error schema & correlation standardized across services.

AuthN/AuthZ (roadmap):
- Pluggable auth providers (OIDC), signed sessions, and per‑topic policies.

---

## Performance & Scalability

Targets (Beta):
- Control‑plane latency: 2–15 ms round‑trip on localhost; <100 ms typical over LAN.
- WASM cold start (wazero): tens of ms for small modules; stream stdout/stderr with low latency.
- v86 (preview): boot in 3–5 s on modern laptops for minimal images (subject to Worker integration).

Throughput:
- The in‑proc Bus supports thousands of pub/sub messages per second on commodity servers; metrics for published/dropped messages and active subscribers provide visibility.

Backpressure:
- Client send buffers guarded; drops counted; logs indicate topics/clients under pressure.

---

## Deployment & Packaging

Single Binary (recommended):
- Use `go:embed` to ship the frontend within the backend; one executable serves UI (`/`) and WebSocket hub (`/ws`).
- Build helper (`build.sh`) compiles the frontend, copies into `assets/web/`, and produces `./bin/aether`.

Container (roadmap):
- Multi‑stage Dockerfile builds the frontend and embeds assets; ships a single image with minimal runtime surface.

Ingress & TLS:
- Place behind an ingress/proxy with TLS termination or enable in‑process TLS; configure allowed origins for WS.

---

## Extensibility

Add new services by subscribing to topics on the bus. Patterns:
- New compute backends: implement `ComputeManager`, expose via `vm.*` control + stream topics.
- AI providers: add adapters behind `ai.*` with streaming (`ai.stream`/`ai.done`) and cancellation.
- Storage backends: replace browser VFS with server/remote VFS by handling `vfs:*` on the kernel and honoring correlation.

---

## Roadmap (Next 2–3 Milestones)

1) Guardrails GA
- Permissions, rate limits, wazero caps/timeouts, standardized errors & UX surfacing, metrics endpoint.

2) v86 Worker MVP → GA
- Worker integration for minimal images; IO streaming; resource hints; feature flag; progressive hardening.

3) Developer Experience
- Editor workspace polish (File Tree, quick open, preferences), streaming AI (`ai.stream`/`ai.done`), Ask panel edits (diff/LSP edits with preview/apply).

4) Packaging & CI
- Multi‑stage Dockerfile; CI for `go test` and frontend lint/build; demo scripts; sample WASI projects.

---

## Governance, Compliance & Licensing

- License: Apache 2.0 (see `LICENSE`).
- Third‑party dependencies: pinned and vendored where appropriate; WASM runtime via `wazero`; AI client via Google GenAI SDK.
- Compliance: logging, metrics, and RBAC/permissions hooks designed for enterprise controls; privacy model defers to configured AI endpoints and in‑browser storage boundaries.

---

## Glossary

- Envelope — JSON message: `{ topic, from, to?, payload, time }`.
- Correlation — `_request_id` request/response matching across topics.
- Addressed Delivery — using `to` field to route to a specific client by id.
- Session — per‑tab identifier used for VFS and browser‑resident compute routing.
- `vm.*` — unified compute control/streams across backends; `wazero` (WASM/WASI), `v86` (browser VM).

---

## Appendix: Topic Reference (Selected)

Compute (vm.*):
```text
# Request
{ "_request_id": "...", "backend": "wazero|v86", "wasm_b64": "...", "args": ["..."], "sessionId": "..." }
# Reply
{ "_request_id": "...", "instanceId": "...", "backend": "wazero" }
```

AI (ai.*):
```text
# ai.complete
{ "_request_id": "...", "doc": { "uri": "...", "languageId": "...", "text": "...", "position": {"line":1,"column":1} }, "context": { "cursorPrefix": "...", "cursorSuffix": "..." } }
# ai.chat
{ "_request_id": "...", "prompt": "...", "context": { "files": [{"uri":"...","text":"..."}] } }
```

VFS (vfs:*):
```text
# write/read/list/delete/rename with { _request_id, sessionId, ... }
```

Task Engine (task.*):
```text
# see README for the full shape; define/run/cancel/status with event streams
```
