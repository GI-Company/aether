# Aether: A Browser‑Native Operating Environment for AI‑Centric Development

Authors: Aether Contributors  
Version: 2025‑Q4 (Research Draft)

Abstract

We present Aether, a browser‑native operating environment that combines a web‑based desktop shell with a minimal Go kernel connected over a structured WebSocket message bus. Aether provides an AI‑augmented code editor, a WASM/WASI runtime (wazero), a unified `vm.*` compute abstraction with pluggable backends (including a browser‑embedded v86 preview), a per‑tab virtual file system (VFS) and a task graph engine. This paper formalizes the architecture, guardrails (permissions, rate limits, resource caps), and the error/telemetry surfaces. We evaluate performance characteristics, isolation properties, and developer UX implications, and outline a roadmap for rigorous multi‑tenant deployments.

1. Introduction

- Motivation: Lowering friction for AI‑assisted software development by co‑locating editing, compute, and storage near the developer (the browser), while retaining a small, debuggable kernel.
- Hypothesis: A transport‑centric OS with first‑class guardrails enables safe, responsive, cross‑platform developer experiences without agents.
- Contributions:
  1) A structured message bus (Envelopes, correlation, addressed delivery) aligning FE/BE.
  2) A unified compute abstraction (`vm.*`) spanning WASM/WASI and browser VM backends.
  3) A guardrails layer: topic permissions, per‑client/topic rate limits, and compute/task timeouts.
  4) A browser‑resident VFS with session scoping and a kernel relay.

2. Related Work

- Cloud IDEs (e.g., VS Code Remote, Theia): server‑centric with editor remoting; Aether inverts with browser‑resident storage and shared bus semantics.
- WASM platforms (e.g., Wasmtime/WASI, wasmCloud): focus on runtime; Aether treats runtime as a backend behind a unified bus.
- Web desktops (e.g., ChromeOS PWAs): OS‑scale; Aether is an app‑level OS focused on developer workflows and message contracts.

3. System Architecture

- Frontend: React/Vite desktop shell; WebSocket client; VFSProxy (IndexedDB); v86 adapter.
- Kernel: in‑proc bus; hub (/ws); services (AI, VFS relay, WASM runner, VM bridge, Task Engine).
- Transport: JSON Envelopes (`topic`, `from`, `to?`, `payload?`, `time`) with correlation via `_request_id`.
- Topics: Namespaces `ai.*`, `vm.*`, `vfs:*`, `task.*`, `wasm.*` (legacy bridge).
- Error surfaces: Derived error topics (`.error` / `:error`) and a uniform payload: `{ _request_id?, code, error, details? }`.

4. Guardrails Framework

4.1 Permissions
- Ordered allow/deny rules by `topic_prefix`; default‑deny when any rules exist; default‑allow when none exist.
- Admin binding via `Authorization: Bearer <token>` equals configured `admin_token` → `IsAdmin=true` bypasses checks (intended for trusted tools).

4.2 Rate Limiting
- Token buckets per (clientId, topic); time‑based refill; admin bypass.
- Config example:
  ```yaml
  rate_limits:
    - topic: "vm.spawn"
      limit: 5
      burst: 2
      window_ms: 60000
  ```

4.3 Compute/Task Resource Caps
- WASM (wazero) wall‑time and idle timeouts (this work); memory limits roadmap; structured `vm.error` on breach (`timeout`/`resource_exceeded`).
- Task Engine global run timeout; per‑node request timeouts; cancel on breach; `task.error` with details.

5. Implementation Details

- Hub: Gorilla WebSocket; per‑client identity; permission and rate‑limit gates before bus publish.
- Bus: in‑process pub/sub with correlation; Reply/EmitError helpers.
- WASM: `wazero` runtime; `_start` execution; stdout/stderr streaming; timeouts monitored.
- VFS: VFSProxy registers via `vfs:register { sessionId }`; kernel relays addressed requests.

5.1 Frontend Implementation

- Desktop shell (React/Vite): window manager, Dock, shortcuts. Windows are draggable/resizable and clamped to viewport; minimize preserves state.
- Bus client (`frontend/src/services/websocket.js`):
  - `on/off/subscribe` with reconnect + resubscribe semantics; wildcard fan‑out (suffix `*`).
  - `sendRequest(topic, payload, { replyTopic, errorTopic?, timeout? })` attaches `_request_id` and awaits the correlated reply; it auto‑derives the error topic (`:error` vs `.error`) to reject early on failures with `{ code, error }`.
- VFSProxy (`frontend/src/services/vfsProxy.ts`): registers `vfs:register { sessionId }`, serves `vfs:*` CRUD from IndexedDB, and replies with correlated `*:ack` / `*:resp` messages.
- v86 Adapter (`frontend/src/services/v86Adapter.js`): registers `compute:register { sessionId }` for addressed delivery; returns deterministic `runtime_pending` errors for `backend:"v86"` until the Worker runtime ships.
- Error surfacing (`frontend/src/services/toast.js` + `ToastContainer.jsx`): subscribes to `vm.*`, `vfs:*`, `ai.*`, `task.*` and shows toasts for any error topics (`code`, `error`).

Build & runtime:
- Dev: Vite hot‑reload; WS URL override via `VITE_WS_URL`.
- Prod: `npm run build`; assets embedded into the Go binary via `build.sh` and `go:embed`.

6. Evaluation

6.1 Performance
- Method: Measure end‑to‑end latency for `vm.spawn` → `vm.spawn:ack`, and sustained throughput under rate limits.
- Observation: Token buckets add O(1) overhead per ingress; negligible latency compared to network.

6.2 Isolation & Safety
- WASI constraints; no privileged host syscalls by default.
- Session‑scoped VFS addressing prevents cross‑tab handling.
- Default‑deny when rules exist reduces accidental exposure.

6.3 Developer UX
- Derived error topics + uniform payloads simplify client handling and enable toasts.
- Admin bypass improves operations tooling without changing code paths.

6.4 Frontend Performance & Resilience
- Time‑to‑interactive (TTI) for desktop shell and Monaco editor under embedded serving.
- Reconnect and resubscribe behavior under simulated network drops; verify pending `sendRequest` calls time out deterministically and that stream subscriptions (`vm.*`, `task.*`) recover.

7. Discussion

- Tradeoffs: Browser‑resident VFS vs server‑side storage; security posture implications for multi‑tenant deployments.
- Future backends: v86 Worker runtime; remote runners; sidecar compute planes.

8. Limitations & Future Work

- Memory/CPU capping in WASM runtime; process accounting for v86.
- Strong authentication/authorization (OIDC); topic roles; audit logs.
- CI‑grade integration tests; production packaging and upgrades.

9. Conclusion

Aether demonstrates that a transport‑centric, browser‑native OS with first‑class guardrails can provide a practical, safe foundation for AI‑assisted development. The architecture unifies compute backends behind a single bus while maintaining simple, inspectable surfaces.

Appendix A: Message Contracts (selected)

- `vm.spawn` → `vm.spawn:ack`, streams `vm.stdout|vm.stderr|vm.exit|vm.error`
- `vfs:write|read|list|delete|rename` with correlated acks/responses
- `task.define|run|cancel|status` with `task.event|task.done|task.error`
