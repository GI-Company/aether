# Aether for Academia: Usage, Citation, and Reproducibility

Version: 2025‑Q4

## Overview
Aether is a browser‑native operating environment for AI‑centric development and computational experiments. It combines a web‑based desktop, an event bus over WebSocket, a WASM/WASI runtime (wazero), a unified compute abstraction (`vm.*`), a browser‑resident VFS (IndexedDB), and a task engine (`task.*`). This document provides guidance for academic use: how to cite Aether, run reproducible experiments, share artifacts, and respect ethics/compliance.

## Intended academic use cases
- Teaching: zero‑install coding labs and interactive systems courses using WASM workloads.
- Research prototyping: rapid iteration on language/tooling UX with live metrics and guardrails.
- Reproducible demos: portable desktops with embedded datasets and deterministic WASM executables.

## Citation
If you reference Aether in academic work, please cite both the software and the research paper.

Software (MIT licensed):
```
@software{aether_os,
  author       = {Aether Contributors},
  title        = {Aether: A Browser-Native Operating Environment},
  year         = {2025},
  license      = {MIT},
  url          = {https://github.com/<org>/aether}
}
```

Research paper:
```
@inproceedings{aether_research_2025,
  author    = {Aether Contributors},
  title     = {Aether: A Browser-Native Operating Environment for AI-Centric Development},
  booktitle = {Proceedings of the Web Systems and Tooling Conference},
  year      = {2025},
  url       = {https://github.com/<org>/aether/blob/main/RESEARCH-PAPER.md}
}
```

## Reproducibility guidelines
- Pin versions:
  - Record Aether commit SHA; lock Go and Node versions via `go.mod` and `package-lock.json`/`pnpm-lock.yaml`.
  - Persist `config.yaml` alongside experiments.
- Capture environments:
  - Prefer the embedded build (`./build.sh`) to produce a single binary that serves the FE and `/ws`.
  - Export environment variables used (e.g., `HTTP_PORT`, `AETHER_ADMIN_TOKEN`, `GEMINI_API_KEY` if AI is required).
  - For frontend‑only experiments, run Vite dev server and point WS to the kernel using `VITE_WS_URL=ws://localhost:8080/ws`.
- Freeze datasets and binaries:
  - Package input datasets inside the browser VFS or serve immutable URLs.
  - Store WASM modules as content‑addressed artifacts; verify SHA256 before spawning.
- Deterministic runs:
  - Use `task.define` graphs to encode experiment pipelines; prefer `bus.request` nodes with explicit timeouts.
  - Capture all replies and `task.event/task.done/task.error` streams to a log with timestamps.
- Seeds and randomness:
  - If workloads rely on PRNGs, pass explicit seeds in the payload and log them.

## Artifact sharing
- Provide a tarball or repository including:
  - `config.yaml`, pinned versions, and a README with quickstart instructions.
  - Frontend build artifacts (`frontend/dist`), or instructions to rebuild with `npm run build` and the exact Node/Vite versions.
  - WASM binaries, input datasets (or pointers), and `task.*` graphs.
  - Logs of the runs and metrics (if any).
- For long‑lived artifacts, publish a Docker image that runs the embedded frontend + kernel and preloads datasets.

## Ethics and compliance
- Do not upload proprietary or sensitive data into third‑party AI providers via `ai.*` unless your IRB/ethics and contractual policies allow it.
- Use anonymized datasets and respect licenses and attribution requirements.
- Ensure students and participants understand data flows (browser storage, WebSocket transport, and any cloud calls).

## Limitations
- Browser performance may limit very large experiments; offload heavy compute to remote backends and stream results over the bus.
- v86 (browser VM) is preview quality; WASM/WASI (wazero) is the recommended backend for reproducibility.

## Getting help
- Open issues with minimal reproducible examples.
- For security or compliance concerns, contact maintainers privately.
