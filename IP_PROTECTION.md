# Aether IP Protection Policy (2025-Q4)

This document describes how Aether protects intellectual property (IP) across code, assets, models, and user data. It also clarifies contributor terms and third‑party dependencies.

## 1. Licensing and ownership
- Code: The Aether codebase is released under the MIT License. See `LICENSE`.
- Trademarks/brand: The names “Aether”, “Aether OS”, associated logos, and product marks are trademarks of their respective owners. Trademark rights are not granted by the MIT license. Do not use the marks in ways that imply endorsement.
- Assets: Images, icons, and brand assets within `frontend/public/` are provided for use within Aether distributions. Redistribution outside Aether must preserve attribution and must not misrepresent origin.

## 2. Contributor terms
- By submitting code, issues, or documentation, you affirm that you have the right to contribute the material and that it is provided under the MIT License.
- Avoid submitting proprietary secrets (API keys, credentials) or third‑party code that you do not have rights to license under MIT.

## 3. Third‑party dependencies
- We use open‑source dependencies with permissive licenses compatible with MIT. Each dependency’s license remains applicable. See `go.mod`, `package.json`, and `vendor`.
- If a dependency’s license imposes NOTICE requirements, we include them in this repository.

## 4. Models and AI providers
- AI features integrate with third‑party providers (e.g., Google Gemini). Your API key and usage are governed by the provider’s terms. Aether does not claim any rights over third‑party models.
- When sending prompts or code to an AI provider, ensure you have rights to process such data and that it does not violate confidentiality obligations.

## 5. User data and isolation
- VFS is per‑tab and stored in the browser (IndexedDB). The kernel relays VFS requests; it does not harvest user data.
- Compute workloads (WASM/WASI) execute with sandboxing; files and streams are only transmitted as requested by the user/app.

## 6. Export controls and compliance
- You are responsible for complying with applicable laws and export controls when distributing Aether or connecting cloud services.

## 7. Reporting IP concerns
- If you believe any part of Aether infringes rights or includes material that must be removed or credited differently, please open a private security issue or contact the maintainers with details.

## 8. Roadmap
- SPDX identifiers in all source files for clarity.
- Optional provenance metadata in release artifacts (SLSA‑aligned build info).
