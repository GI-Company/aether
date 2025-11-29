# Aether Standard (Draft) — AI‑Native Browser Operating Environment

Version: 2025‑Q4 (Draft for Review)

Status: This document is a draft specification describing the interfaces and behavioral requirements of an AI‑native browser operating environment powered by a kernel‑exposed message bus. While authored by the Aether project, the intent is implementation‑neutral. Vendors may implement compatible stacks as long as conformance requirements are met.

Frontend Overview (informative): Aether’s frontend is a desktop‑style web client (React/Vite) that connects to `/ws`, uses correlated requests with derived error topics, registers browser services (VFSProxy, preview v86), and surfaces guardrail errors via toasts. The normative parts of this document apply primarily to kernels, with Section 15 providing recommended frontend behaviors.

## 1. Scope and Goals

This standard specifies:
- The transport and envelope format for messages between browser clients and a kernel (server) over WebSocket.
- Topic naming, correlation, and addressed‑delivery conventions.
- Error topics and error payload schema.
- Session semantics and client identity propagation.
- Guardrails requirements: permissions (topic allow/deny), rate limiting, and resource caps/timeouts.
- Minimum conformance profiles for applications (Editor, Compute, VFS, Task Engine) and for kernels.

Non‑Goals:
- Prescribe a UI or window system; vendors may implement any desktop shell.
- Mandate a specific compute backend; WASM/WASI and browser VMs are examples.

## 2. Terminology

- Client: A browser tab or application instance connected over WebSocket.
- Kernel: A server exposing the `/ws` endpoint and managing an in‑process bus and services.
- Envelope: A JSON object carrying a message across the bus.
- Topic: Routing key (e.g., `vm.spawn`, `vfs:write`).
- Session: A logical partition of state, typically a per‑tab identifier.

## 3. Transport and Envelope

Transport: WebSocket (RFC 6455) over HTTP(S). TLS is RECOMMENDED in production deployments.

Envelope (JSON examples):
```json
{ "topic": "vm.spawn", "from": "client-123", "time": "2025-11-23T00:00:00Z" }
```
```json
{ "topic": "vfs:write", "from": "client-123", "to": "client-456", "payload": { "path": "/readme.md", "data": "..." }, "time": "2025-11-23T00:00:00Z" }
```

Requirements:
- The kernel MUST set `from` for messages it publishes (e.g., `"kernel"`).
- Clients MUST NOT rely on `from` as an authentication identifier.
- `payload` MUST be a JSON object when present.

## 4. Topics and Namespaces

This standard recognizes the following namespaces (non‑exclusive):
- `ai.*` — AI completion/chat and related responses.
- `vm.*` — Unified compute control (e.g., `vm.spawn`, `vm.stdin`, `vm.kill`) and streams (`vm.stdout`, `vm.stderr`, `vm.exit`, `vm.error`).
- `vfs:*` — Virtual file system requests (`vfs:write`, `vfs:read`, `vfs:list`, `vfs:delete`, `vfs:rename`) and correlated acks/responses.
- `task.*` — Task graphs and runs (`task.define`, `task.run`, `task.cancel`, `task.status`); streams (`task.event`, `task.done`, `task.error`).
- `wasm.*` — Legacy WASM runner topics; MAY be bridged by the kernel to/from `vm.*`.

Topic format:
- Dotted topics (e.g., `vm.spawn`) and colon‑separated topics (e.g., `vfs:write`) are both valid. Vendors SHOULD document their usage and remain consistent.

## 5. Correlation, Requests and Responses

Clients MAY send request messages by attaching a unique `_request_id` within `payload` and listening for a correlated response on a reply topic defined by the API (e.g., `vm.spawn:ack`).

Requirements:
- When a request is accepted and processed, the responder SHOULD publish a correlated reply including the same `_request_id`.
- On failure, responders MUST publish a correlated error as defined in Section 6.

## 6. Errors: Topics and Payload Schema

Error topic derivation:
- If the original topic contains `:`, the error topic MUST be `<topic>:error` (e.g., `vfs:write:error`).
- Else if it contains `.`, the error topic MUST be `<topic>.error` (e.g., `vm.spawn.error`).
- Else, the error topic MAY be `error`.

Error payload schema (examples):
```json
{ "code": "permission_denied", "error": "topic not allowed" }
```
```json
{ "_request_id": "abc123", "code": "rate_limited", "error": "rate limit exceeded", "details": { "resetMs": 1200 } }
```

Canonical error codes (non‑exhaustive):
- `permission_denied`, `rate_limited`, `payload_too_large`, `timeout`, `resource_exceeded`, `not_found`, `internal_error`, `payload_invalid`, `missing_session`, `unsupported_backend`, `no_compute_handler`.

## 7. Sessions and Addressed Delivery

Sessions:
- A session identifier (e.g., `sessionId`) MAY be used to scope per‑tab services like VFS or client‑side compute adapters. The kernel SHOULD route addressed messages accordingly.

Addressed delivery:
- When `to` is set to a client identifier, the kernel MUST deliver the envelope only to that client.

## 8. Permissions (Topic Allow/Deny)

Kernels SHOULD implement a permissions layer evaluating ordered rules (`topic_prefix`, `allow`).

Requirements:
- Default policy: If no rules are configured → default‑allow. If any rules are configured → default‑deny for non‑matching topics.
- Admin bypass: Kernels MAY grant administrative bypass to clients presenting a configured bearer token via `Authorization: Bearer <token>`.

## 9. Rate Limiting

Kernels SHOULD support per‑(client, topic) token buckets.

Requirements:
- Limits: `(limit, burst, window_ms)` MUST be configurable per topic.
- On exhaustion: Publish a correlated error (`code=rate_limited`) including `{ resetMs }` in `details`.
- Admin bypass: If an admin bypass exists, admins SHOULD be exempt.

## 10. Resource Caps and Timeouts

- Compute backends SHOULD implement per‑instance wall‑time timeouts; kernels SHOULD enforce idle timeouts where applicable.
- On breach, kernels MUST publish a structured error on the appropriate error topic (`code=timeout` or `resource_exceeded`).
- Task engines SHOULD support per‑run and per‑node timeouts and publish `task.error` with details on breach.

## 11. Conformance Profiles

Profile A (Kernel Minimal):
- Transport and envelope compliance; error topic derivation; correlation; permissions default policy.

Profile B (Kernel Guarded):
- Profile A plus: per‑topic rate limiting; admin bypass; compute timeouts; task engine timeouts.

Profile C (Desktop Shell & Apps):
- A desktop shell with at least: Editor (bus‑driven), WASM Runner (vm.* or wasm.*), VFS integration, and Task Engine UI.
- Frontend MUST surface guardrail errors (toasts or equivalent) keyed off `code`.

## 12. Security Considerations

- Use TLS for `/ws` in production.
- Do not treat `from` as authenticated identity; bind identity separately.
- Avoid logging sensitive payload details; redact AI prompts if needed.

## 13. IANA Considerations

None.

## 14. References

- RFC 6455 (WebSocket), WASI/WASM runtimes, Gorilla WebSocket, Wazero.

---

## 15. Frontend Client Requirements (Informative)

This section is non‑normative guidance for browser clients that interoperate with kernels implementing this standard. It documents recommended behavior so that applications provide a consistent, predictable user experience.

### 15.1 Connection and Reconnection
- The client SHOULD derive the WebSocket URL from the current origin, defaulting to `ws[s]://<host>/ws`, with a build‑time override when developing locally.
- On connection loss, the client SHOULD reconnect and re‑subscribe previously requested topics (including wildcards with `*`).

### 15.2 Correlation and Errors
- For request/response flows, clients SHOULD attach a unique `_request_id` to the `payload` and listen on the documented reply topic.
- Clients SHOULD also subscribe to the derived error topic as specified in Section 6 and treat a matching `_request_id` as a terminal failure for that request.
- Clients SHOULD surface structured errors with at least `code` and `error` fields to the user (e.g., a non‑blocking toast).

### 15.3 Sessions and Addressing
- A per‑tab `sessionId` is RECOMMENDED for services that must be addressed to a specific browser context (e.g., VFS proxy, client‑side compute adapters).
- Clients SHOULD register session‑scoped services at startup (e.g., `vfs:register { sessionId }`, `compute:register { sessionId }`).
- When sending requests that expect addressed responses, clients SHOULD include `sessionId` where applicable so the kernel can route messages correctly.

### 15.4 Topic Subscriptions
- Clients SHOULD explicitly subscribe (`bus.subscribe`) to topics they need, including stream topics (`vm.stdout`, `vm.stderr`, `task.event`) and reply topics (e.g., `vm.spawn:ack`).
- For convenience and resilience, clients MAY use wildcard subscriptions (e.g., `vm.*`) and filter client‑side.

### 15.5 Timeouts and Limits
- For interactive UX, clients SHOULD apply request timeouts of 3–10 seconds by default and allow longer timeouts for known long‑running operations.
- For large payloads (e.g., base64‑encoded WASM modules), clients SHOULD apply size guards and provide user feedback when limits are exceeded.

### 15.6 Example Frontend Components
- Bus Client: subscribe/publish helpers with a `sendRequest` utility that attaches `_request_id`, listens on reply and derived error topics, and cleans up handlers on resolution.
- VFS Proxy: subscribes to `vfs:*`, registers a `sessionId`, serves CRUD from IndexedDB, and replies with correlated `*:ack`/`*:resp` envelopes.
- Compute Adapter (browser VM preview): registers `compute:register { sessionId }` and handles addressed `vm.*` control; until a full runtime exists, it SHOULD reply with a deterministic, correlated error (e.g., `runtime_pending`).

These practices help ensure that multiple independent frontend implementations remain compatible while allowing innovation in the desktop shell and application UX.
