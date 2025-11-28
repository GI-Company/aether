all this is in that binary minus the python 
# AetherOS Quick Start — From Zero to OS in 60 Seconds

<div align="center">

**One command. One minute. One complete operating system in your browser.**

This is not a tutorial. This is a revolution.

</div>

---

## The 60-Second Experience

```bash
./launch.sh
```

Open `http://localhost:8080`

**That's it.** You're now running a complete desktop operating system in your browser.

---

## What Just Happened?

In those 60 seconds, AetherOS:

✅ Detected your system (macOS/Linux/Windows)
✅ Installed Go 1.24+ (if needed)
✅ Installed Node.js 18+ (if needed)
✅ Set up Python 3.8+ virtual environment
✅ Downloaded and configured local AI models
✅ Built React + Vite frontend (256KB bundle)
✅ Embedded Monaco Editor with 50+ language modes
✅ Compiled Go kernel with WebSocket bus
✅ Created 39MB single-binary executable
✅ Launched server on port 8080
✅ Loaded desktop shell with window manager

**No Docker. No VMs. No cloud. No API keys. No bullshit.**

---

## First Look — What You're Seeing

### The Desktop

Your browser now contains:

**Animated Background**
Deep space gradient with ambient lighting that breathes (30s cycle). Not a static image — a living environment.

**Dock (Bottom)**
Seven applications ready to launch:
- **Editor** — Monaco (VS Code engine) + AI
- **Files** — Full file system browser
- **WASM Runner** — Execute binaries safely
- **Compute** — VM control panel
- **AI Agent** — Chat with local models
- **Marketplace** — App discovery
- **Settings** — System configuration

**Taskbar (Top)**
- Current time (updates live)
- WebSocket status (green = connected)
- Window indicators

**Windows**
Click any dock icon. A window appears. Drag it. Resize it. Click another window — it comes to front. This is macOS-quality window management, **in a browser**.

---

## The 5-Minute Tour

### 1. Launch the Editor (10 seconds)

Click **Editor** in the dock.

**What you see:**
- Monaco Editor (same engine as VS Code)
- File tree panel (left sidebar)
- AI panel (right sidebar - "Ask AI")
- Run button (top toolbar)

**Try this:**
```javascript
// Type this slowly and watch AI autocomplete
function fibonacci(n) {
  if (n <= 1) return n;
  // Watch the AI suggest the recursive calls
}
```

**The AI is running locally.** No API call. No network request. Just a Python subprocess with HuggingFace models.

### 2. Save a File (10 seconds)

Press `Cmd/Ctrl+S` (or click Save).

**What happened:**
- File saved to browser IndexedDB
- VFS (Virtual File System) stored it with session scope
- WebSocket message sent: `vfs:write { path, content }`
- Kernel relayed to browser VFS proxy
- Received acknowledgment: `vfs:write:ack`
- All in <50ms

**No server-side storage.** Your data stays in your browser. Multi-tab safe. Session-isolated.

### 3. Open File Explorer (20 seconds)

Click **Files** in the dock.

**What you see:**
- List/Grid view toggle
- Search bar
- Sort options (name/date/size)
- File type icons (📁📜⚛️📘📋📝⚙️🐹🦀)
- Action buttons (preview, delete, new folder)

**Try this:**
- Click the file you just saved
- Click **Preview** — modal shows content
- Create a new folder: type name, click **Create Folder**
- Watch it appear instantly

**This is Dropbox-level UX**, running entirely in your browser with IndexedDB.

### 4. Run WebAssembly (30 seconds)

Click **WASM Runner** in the dock.

**Try this:**
- Click **Choose File** and upload any `.wasm` file (WASI-compatible)
- Click **Spawn**
- Watch stdout/stderr stream in real-time
- Type in stdin field, press Enter
- Click **Kill** to terminate

**What's happening:**
- Browser sends `vm.spawn` message with base64-encoded WASM
- Go kernel instantiates wazero runtime (pure-Go WASM interpreter)
- IO streams via WebSocket topics: `vm.stdout`, `vm.stderr`
- Process isolated with WASI sandbox (no file system, no network)
- Kill sends `vm.kill`, receives `vm.exit` with code

**This is Docker-level isolation**, without containers, running on a CPU sandbox.

### 5. Chat with Local AI (30 seconds)

Click **AI Agent** in the dock.

**Try this:**
```
You: Explain how message buses work

AI: [Real response from local model - no API call]
```

**What's different:**
- Ultra 50G model (local HuggingFace model)
- No OpenAI API key
- No rate limits
- No usage tracking
- Your code never leaves your machine

**This is privacy-first AI.**

### 6. Configure Everything (20 seconds)

Click **Settings** in the dock.

**Sections:**

**Appearance**
- Theme: Dark / Light / Auto
- Font Size: 10px - 24px slider

**Editor**
- Auto-save: On / Off
- AI Assistance: Enable / Disable

**System Info**
- Session ID: `abc-def-123-xyz`
- WebSocket: Connected ● ws://localhost:8080/ws
- Browser: Chrome 120.0.0.0
- Platform: macOS 14.0

**Data Management**
- 💾 Export Settings (downloads JSON)
- 📥 Import Settings (upload JSON)
- 🗑️ Clear All Data (with confirmation)

**Everything persists.** Close browser, come back tomorrow, settings intact.

---

## Mind Cell Orchestration (Advanced)

### What Are Mind Cells?

Mind Cells are **autonomous reasoning units with memory** that can orchestrate complex tasks through natural language. Think of them as intelligent agents that understand what you want and coordinate execution automatically.

### Quick Example

Open the browser console (`F12` → Console) and try:

```javascript
// Create a reasoning cell
const { cell } = await sendRequest('mindcell.create', {
  type: 'ReasoningCell',
  model: 'nemotron-1.5b',
  config: { temperature: 0.7 }
});

console.log('Cell created:', cell.id);

// Execute an intent in natural language
await sendRequest('intent.execute', {
  intent: "List all JavaScript files in the project",
  sessionId: sessionStorage.getItem('sessionId')
});

// System automatically:
// 1. Parses "list all JS files" → task graph
// 2. Creates tasks: query VFS, filter by .js extension
// 3. Validates DAG (no cycles, valid dependencies)
// 4. Executes in parallel where possible
// 5. Streams events back to you
// 6. Records full audit trail
```

### Cell Types

**ReasoningCell** (Nemotron 1.5B)
- Text generation and analysis
- Code completion and generation
- Mathematical reasoning
- R&D tasks

**KGCell** (ULTRA 50g)
- Knowledge graph reasoning
- Link prediction
- Graph-based inference
- Relationship discovery

**HybridCell** (Both models)
- Complex pipelines requiring both reasoning and graph logic
- Best for multi-stage analysis tasks

**MetaCell** (Orchestrator)
- Coordinates multiple cells
- Higher-order reasoning
- Multi-agent collaboration

### State Machine

Every execution is provably consistent:

```
CREATED → VALIDATED → QUEUED → EXECUTING → SUCCESS
    ↓         ↓           ↓          ↓          ↓
CANCELLED   FAILED    TIMEOUT   CANCELLED   FAILED
```

**Features:**
- Cannot skip states (formal guarantees)
- Complete audit trail with timestamps
- Deterministic replay from snapshots
- Session-based isolation

### WebSocket Topics

```javascript
// Cell management
await sendRequest('mindcell.create', {...})
await sendRequest('mindcell.list', { type: 'ReasoningCell' })
await sendRequest('mindcell.execute', { id: 'cell-123', input: {...} })
await sendRequest('mindcell.delete', { id: 'cell-123' })

// Intent orchestration
await sendRequest('intent.parse', { intent: "your goal here" })
await sendRequest('intent.execute', { intent: "...", sessionId: "..." })
await sendRequest('intent.status', { executionId: 'exec-789' })
await sendRequest('intent.cancel', { executionId: 'exec-789' })
```

### Real-World Example

```javascript
// Complex multi-step task
await sendRequest('intent.execute', {
  intent: `
    Analyze all JavaScript files for security issues,
    check dependencies for vulnerabilities,
    generate a markdown report with recommendations
  `,
  sessionId: sessionStorage.getItem('sessionId')
});

// System creates DAG:
// 1. List JS files (parallel)
// 2. Analyze each file (parallel after #1)
// 3. Check dependencies (parallel with #2)
// 4. Aggregate results (after #2 and #3)
// 5. Generate report (after #4)
// 6. Store report in VFS (after #5)

// Track progress
const { status } = await sendRequest('intent.status', {
  executionId: 'exec-789'
});
// Returns: { progress: 0.6, status: "executing", events: [...] }
```

---

## How This Actually Works

### Architecture in Plain English

**Frontend (React + Vite)**
- Renders desktop shell (windows, dock, taskbar)
- Monaco Editor for code editing
- WebSocket client connects to `ws://localhost:8080/ws`
- VFS Proxy uses IndexedDB for file storage
- Sends/receives JSON messages on topics

**Backend (Go Kernel)**
- HTTP server on port 8080
- WebSocket hub for message routing
- Message bus with pub/sub + request/response
- Services: AI orchestrator, WASM runner, VFS relay, task engine
- 39MB single binary (includes embedded frontend)

**AI Worker (Python)**
- Subprocess managed by Go kernel
- HuggingFace Transformers + PyTorch
- Two local models: Nemotron 1.5B (reasoning), ULTRA 50G (knowledge graph)
- Listens on stdin, responds on stdout (JSON)

**Communication Protocol**
```json
{
  "topic": "ai.complete",
  "from": "client-abc",
  "to": "kernel",
  "payload": {
    "_request_id": "req-123",
    "doc": { "text": "function fib(", "position": {"line": 1, "column": 14} }
  },
  "time": "2025-11-25T20:00:00Z"
}
```

**Response:**
```json
{
  "topic": "ai.complete:resp",
  "from": "kernel",
  "to": "client-abc",
  "payload": {
    "_request_id": "req-123",
    "completion": "n) {\n  if (n <= 1) return n;\n  return fib(n-1) + fib(n-2);\n}"
  },
  "time": "2025-11-25T20:00:01Z"
}
```

---

## Keyboard Shortcuts

### Editor
- `Cmd/Ctrl + S` — Save to VFS
- `Cmd/Ctrl + P` — Quick open file picker
- `Cmd/Ctrl + /` — Toggle comment
- `Tab` — Accept AI suggestion
- `Esc` — Dismiss AI suggestion

### Desktop
- `Click` — Bring window to front
- `Drag` — Move window
- `Resize` — Drag bottom-right corner
- `Minimize` — Click minimize button in titlebar

---

## Configuration

### Default Configuration

AetherOS launches with sensible defaults:

```yaml
# config.yaml
http_port: 8080
ai_enabled: true
ai_local:
  enabled: true
  python_path: ".venv_ai/bin/python"
  models:
    complete_primary: "models/ultra/ultra_50g"
    complete_alt: "models/graphsgpt/graphsgpt-4w"
    embed: "sentence-transformers/all-MiniLM-L6-v2"
```

### Environment Variables

Create `.env` to override:

```bash
# Use local AI (default)
AETHER_AI_LOCAL_ENABLED=1
AETHER_AI_USE_GEMINI=0

# Or use Gemini API instead
AETHER_AI_USE_GEMINI=1
GEMINI_API_KEY=your_key_here

# Change port
HTTP_PORT=3000
```

### Model Configuration

Local AI models expected at:
- `models/ultra/ultra_50g` (symlink or directory)
- `models/graphsgpt/graphsgpt-4w` (symlink or directory)

If models missing:
```bash
# Disable local AI, use Gemini
export AETHER_AI_LOCAL_ENABLED=0
export AETHER_AI_USE_GEMINI=1
export GEMINI_API_KEY=your_key

./launch.sh
```

---

## Troubleshooting

### Port 8080 Already in Use

Edit `config.yaml`:
```yaml
http_port: 8081
```

Or set environment variable:
```bash
HTTP_PORT=8081 ./launch.sh
```

### Monaco Editor Not Loading

Rebuild frontend:
```bash
cd frontend
npm run build
cd ..
./build.sh
```

### AI Not Responding

Check model paths:
```bash
ls -la models/ultra/ultra_50g
ls -la models/graphsgpt/graphsgpt-4w
```

Rebuild AI environment:
```bash
rm -rf .venv_ai
export AETHER_AI_LOCAL_ENABLED=1
./launch.sh
```

### WebSocket Disconnected

Check server logs:
```bash
./bin/aether
# Look for "WebSocket client connected" messages
```

Browser console (F12):
```javascript
// Should see:
WS connected: ws://localhost:8080/ws
```

### Browser Storage Full

Settings → Data Management → Clear All Data

Or manually:
```javascript
// Browser console
localStorage.clear();
indexedDB.deleteDatabase('aetherVFS');
location.reload();
```

---

## Performance

### Build Stats
- Frontend bundle: **256.82 KB** (79.74 KB gzipped)
- Monaco workers: **8.3 MB** (loaded lazily)
- Backend binary: **39 MB** (includes all assets)
- Total modules: **111**

### Runtime Performance
- Cold start: **<10 seconds** (includes AI model load)
- Hot reload: **<1 second**
- Message latency: **2-15ms** localhost
- Monaco load time: **<500ms**
- Window render: **60fps** (hardware accelerated)
- AI completion: **200-500ms** (local model)

### Resource Usage
- Memory: **~200MB** frontend + **~150MB** backend + **~500MB** AI worker
- CPU: **<5%** idle, **20-40%** during AI inference
- Disk: **39MB** binary + **~2GB** AI models + **variable** VFS data

---

## Next Steps

### Learn the Architecture
Read **[WHITEPAPER.md](WHITEPAPER.md)** for deep technical details:
- Message bus protocol
- Session isolation
- Security model
- Guardrails (permissions, rate limits, resource caps)

### Explore Advanced Features
- **Intent-First Orchestration** — State goals, get DAGs, execute safely
- **Foundry** — Save and share automation recipes
- **Task Engine** — Define and run complex workflows
- **Temporal Memory** — Context-aware AI with past/present/future

### Build Applications
- Create new window components in `frontend/src/windows/`
- Register apps in `backend/apps.go`
- Use WebSocket topics for communication
- Follow patterns from existing apps (Editor, Files, WASM Runner)

### Join the Community
- **GitHub Issues** — Report bugs, request features
- **Discussions** — Ask questions, share projects
- **Contributing** — Submit PRs, improve docs

---

## What Makes This Special

### Technical Excellence
- **Real architecture** — Message bus, session isolation, correlation IDs
- **Production patterns** — Guardrails, error handling, resource management
- **Modern stack** — Go + React + WASM + AI
- **Single binary** — No dependencies, no installation hell

### Development Model
- **AI-assisted** — Built by one person with AI tools
- **Rapid iteration** — Features in hours, not weeks
- **Quality first** — Production-grade code, comprehensive docs
- **Open source** — MIT license, contribute freely

### User Experience
- **Zero install** — Runs in any modern browser
- **Instant start** — One command, one minute
- **Native feel** — 60fps animations, smooth interactions
- **Privacy-first** — Local AI, browser storage, no tracking

---

## The Bottom Line

**In 60 seconds, you launched a complete operating system in your browser.**

No complex setup. No cloud dependencies. No privacy concerns.

Just a 39MB binary, a browser, and the future of computing.

**This is AetherOS.**

---

<div align="center">

**Ready to explore?**

[Read the full README](README.md) • [Dive into the whitepaper](WHITEPAPER.md) • [Star on GitHub](https://github.com/yourusername/aetherOS)

*Built by one person. Powered by AI. Running everywhere.*

</div>

# AetherOS Engineering Blueprint — v1.0

**Scope:** Define architecture, model integration, and Mind Cell orchestration for an AI-native OS with embedded reasoning and graph intelligence.

**Status:** Design Document
**Version:** 1.0
**Last Updated:** 2025-11-25
**Authors:** AetherOS Core Team

---

## Table of Contents

1. [High-Level Architecture](#1-high-level-architecture)
2. [Model Integration](#2-model-integration)
3. [Mind Cell Factory](#3-mind-cell-factory)
4. [Orchestrated Intent](#4-orchestrated-intent)
5. [Mind Cell Types](#5-mind-cell-types)
6. [Formal State Machine](#6-formal-state-machine)
7. [Backend & Asset Integration](#7-backend--asset-integration)
8. [API Reference](#8-api-reference)
9. [Implementation Roadmap](#9-implementation-roadmap)
10. [Developer Guidelines](#10-developer-guidelines)
11. [Advantages](#11-advantages)

---

## 1. High-Level Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                      User Interface Layer                      │
│            (Desktop PWA / Browser / Future: Electron)          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Monaco     │  │     File     │  │   Settings   │       │
│  │   Editor     │  │   Explorer   │  │   & Config   │  ...  │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└───────────────────────────────┬───────────────────────────────┘
                                │ WebSocket (JSON Envelopes)
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                    Orchestrated Intent Layer                   │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  Intent Parser → DAG Builder → State Machine Validator  ││
│  │  - Natural language understanding                        ││
│  │  - Task decomposition (goal → sub-goals)                ││
│  │  - Mind Cell selection & sequencing                     ││
│  │  - Formal state transition enforcement                  ││
│  │  - Cycle detection & dependency validation              ││
│  │  - Error recovery & fallback strategies                 ││
│  └──────────────────────────────────────────────────────────┘│
└───────────────────────────────┬───────────────────────────────┘
                                │ DAG Contract
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                      Mind Cell Factory                         │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────┐│
│  │  Reasoning Cells │  │  KG Cells        │  │ Hybrid      ││
│  │  (Nemotron)      │  │  (ULTRA)         │  │ Cells       ││
│  │                  │  │                  │  │             ││
│  │  - Code gen      │  │  - Link predict  │  │  N + U      ││
│  │  - Math solve    │  │  - Graph reason  │  │  Chains     ││
│  │  - R&D tasks     │  │  - KG inference  │  │             ││
│  └──────────────────┘  └──────────────────┘  └─────────────┘│
│  ┌──────────────────────────────────────────────────────────┐│
│  │            State Machine & Execution Engine              ││
│  │  - Execution: CREATED→VALIDATED→QUEUED→EXECUTING        ││
│  │  - Nodes: PENDING→RUNNING→COMPLETE/FAILED               ││
│  │  - Session-based isolation & authorization               ││
│  │  - Lifecycle management (create→active→executing→done)   ││
│  │  - Output verification gates before memory storage       ││
│  │  - Complete audit trail with state history               ││
│  └──────────────────────────────────────────────────────────┘│
│  ┌──────────────────────────────────────────────────────────┐│
│  │               Knowledge Retention Store (SQLite)         ││
│  │  - Cell definitions & configurations                     ││
│  │  - Execution history with results                        ││
│  │  - Result caching & reuse                                ││
│  │  - Evolution tracking                                    ││
│  └──────────────────────────────────────────────────────────┘│
└───────────────────────────────┬───────────────────────────────┘
                                │ Model Invocation
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                         Model Layer                            │
│  ┌────────────────────────┐      ┌────────────────────────┐  │
│  │  Nemotron-1.5B         │      │  ULTRA 50g             │  │
│  │  (Text Generation)     │      │  (Graph ML)            │  │
│  │                        │      │                        │  │
│  │  Path: models/         │      │  Path: models/         │  │
│  │  Nemotron-Research-    │      │  ultra_50g             │  │
│  │  Reasoning-Qwen-1.5B   │      │                        │  │
│  │                        │      │  - KG reasoning        │  │
│  │  - ProRL trained       │      │  - Link prediction     │  │
│  │  - Math, code, STEM    │      │  - 50 graph training   │  │
│  │  - 1.5B params         │      │  - 169k params         │  │
│  └────────────────────────┘      └────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │            Sentence Transformers                       │  │
│  │            (all-MiniLM-L6-v2)                          │  │
│  │            - Text embeddings for semantic search       │  │
│  └────────────────────────────────────────────────────────┘  │
└───────────────────────────────┬───────────────────────────────┘
                                │ Python Worker (serve.py)
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                   Backend / Data Layer (Go)                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  HTTP Server │  │  Message Bus │  │  Task Engine │       │
│  │  (Gin/Echo)  │  │  (WebSocket) │  │  (DAG Exec)  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  VFS Relay   │  │  AI Orch.    │  │  Foundry     │       │
│  │  (IndexedDB) │  │  (Intent)    │  │  (Recipes)   │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Embedded Assets (go:embed)                          │   │
│  │  - Frontend (React + Monaco) in assets/web/          │   │
│  │  - Python worker in assets/python/serve.py           │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Storage Layer                                        │   │
│  │  - VFS metadata (SQLite/BoltDB)                      │   │
│  │  - Mind Cell memory (temporal store)                 │   │
│  │  - Intent logs (analytics)                           │   │
│  └──────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────┘
```

---

## 2. Model Integration

### 2.1 Model Specifications

| Component      | Model                               | Path                                      | Size   | Purpose                                                                  |
|----------------|-------------------------------------|-------------------------------------------|--------|--------------------------------------------------------------------------|
| Reasoning Cell | Nemotron-Research-Reasoning-Qwen-1.5B | `models/Nemotron-Research-Reasoning-Qwen-1.5B` | 1.5B   | General reasoning, code generation, math, R&D, logical puzzles          |
| KG Cell        | ULTRA 50g                           | `models/ultra_50g`                        | 169K   | Knowledge graph reasoning, link prediction, relational inference        |
| Embedding      | all-MiniLM-L6-v2                    | (HuggingFace cache)                       | 22.7M  | Text embeddings, semantic search, similarity matching                   |

### 2.2 Model Selection Logic

Mind Cells select models dynamically based on **task type**:

```python
def select_model(task_type: str) -> str:
    """
    Task Type → Model Mapping
    """
    if task_type in ["code_generation", "math", "reasoning", "text"]:
        return "nemotron-1.5b"  # Text generation

    elif task_type in ["graph_reasoning", "link_prediction", "kg_inference"]:
        return "ultra_50g"  # Graph ML

    elif task_type in ["semantic_search", "similarity", "clustering"]:
        return "embeddings"  # Sentence transformers

    elif task_type in ["hybrid", "composite"]:
        return "nemotron-1.5b+ultra_50g"  # Chain both

    else:
        return "nemotron-1.5b"  # Default fallback
```

### 2.3 Model Loading Strategy

**Lazy Loading:**
- Models loaded on first use
- Cached in `_PIPES` dict for reuse
- Memory management via LRU eviction (future)

**Error Handling:**
- Graceful degradation if model missing
- Fallback to simpler model
- Informative error messages

**Performance:**
- Nemotron: ~200-500ms inference (CPU)
- ULTRA: ~50-100ms for KG queries
- Embeddings: ~10-50ms per batch

---

## 3. Mind Cell Factory

### 3.1 Mind Cell Lifecycle

```
┌─────────────┐
│  Creation   │  ← Triggered by Orchestrated Intent
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Activation  │  ← Load relevant model(s)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Execution   │  ← Process input, generate output
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Persistence │  ← Store results in cell memory
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Evolution  │  ← Update with new observations
└─────────────┘
```

### 3.2 Cell Structure

```go
type MindCell struct {
    ID          string                 // Unique identifier
    Type        CellType               // Reasoning, KG, Hybrid, Meta
    Model       string                 // nemotron-1.5b, ultra_50g, etc.
    CreatedAt   time.Time
    LastUsed    time.Time
    UseCount    int                    // Usage statistics
    Memory      map[string]interface{} // Stored outputs, context
    InputSchema  Schema                // Expected input format
    OutputSchema Schema                // Output format
    Metadata    map[string]string      // Tags, description, etc.
}

type CellType int
const (
    ReasoningCell CellType = iota  // Nemotron-backed
    KGCell                          // ULTRA-backed
    HybridCell                      // Nemotron + ULTRA
    MetaCell                        // Composite/orchestrator
)
```

### 3.3 Factory Methods

```go
// Create a new Mind Cell
func (f *MindCellFactory) Create(cellType CellType, config CellConfig) (*MindCell, error)

// Activate a cell (load model)
func (c *MindCell) Activate() error

// Execute cell with input
func (c *MindCell) Execute(input interface{}) (interface{}, error)

// Store cell output in memory
func (c *MindCell) Persist(output interface{}) error

// Update cell with new data
func (c *MindCell) Evolve(feedback interface{}) error

// Deactivate cell (unload model)
func (c *MindCell) Deactivate() error
```

### 3.4 Knowledge Retention

**Storage Backend:**
- SQLite/BoltDB for metadata
- VFS for large outputs
- In-memory LRU cache for hot cells

**Schema:**
```sql
CREATE TABLE mind_cells (
    id TEXT PRIMARY KEY,
    type INTEGER NOT NULL,
    model TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    use_count INTEGER DEFAULT 0,
    memory_blob BLOB,  -- JSON-encoded memory
    metadata_json TEXT
);

CREATE INDEX idx_cells_type ON mind_cells(type);
CREATE INDEX idx_cells_last_used ON mind_cells(last_used);
```

---

## 4. Orchestrated Intent

### 4.1 Intent Parser

**Input:** Natural language user query or structured intent

**Output:** Task graph (DAG) with Mind Cell nodes

**Example:**
```json
{
  "intent": "Plan a chemical experiment and validate pathways",
  "parsed": {
    "goal": "chemical_experiment_planning",
    "tasks": [
      {
        "id": "task-1",
        "type": "graph_reasoning",
        "cell": "KGCell",
        "model": "ultra_50g",
        "input": {
          "query": "predict feasible reaction paths for compound X"
        }
      },
      {
        "id": "task-2",
        "type": "code_generation",
        "cell": "ReasoningCell",
        "model": "nemotron-1.5b",
        "input": {
          "prompt": "Generate experimental procedure and simulation code",
          "context": "{{ task-1.output }}"
        },
        "depends_on": ["task-1"]
      },
      {
        "id": "task-3",
        "type": "composite",
        "cell": "HybridCell",
        "input": {
          "graph_result": "{{ task-1.output }}",
          "code_result": "{{ task-2.output }}"
        },
        "depends_on": ["task-1", "task-2"]
      }
    ]
  }
}
```

### 4.2 Task Prioritizer

**Strategies:**
- **Dependency-based:** Execute prerequisite tasks first
- **Resource-aware:** Consider model availability, memory
- **User-priority:** Honor explicit priorities
- **Deadline-driven:** Meet time constraints

### 4.3 Execution Scheduler

**Features:**
- Parallel execution where possible
- Sequential chaining for dependencies
- Error recovery with retries
- Fallback strategies (model → simpler model)
- Progress tracking and cancellation

**Topics:**
- `intent.parse` → `intent.parse:resp`
- `intent.execute` → `intent.execute:ack`
- `intent.status` → `intent.status:resp`
- `task.event`, `task.done`, `task.error`

---

## 5. Mind Cell Types

### 5.1 Reasoning Cell (Nemotron)

**Model:** Nemotron-Research-Reasoning-Qwen-1.5B
**Capabilities:**
- Code generation (Python, Go, JS, Rust, etc.)
- Mathematical problem solving
- Logical puzzles and reasoning
- Scientific R&D tasks
- Natural language understanding

**Use Cases:**
- Editor autocomplete
- AI chat assistant
- Problem decomposition
- Experiment design

**Example:**
```python
cell = ReasoningCell(model="nemotron-1.5b")
output = cell.execute({
    "prompt": "Write a Python function to compute Fibonacci",
    "max_tokens": 256
})
# Output: Generated code with explanation
```

### 5.2 KG Cell (ULTRA)

**Model:** ULTRA 50g
**Capabilities:**
- Link prediction on knowledge graphs
- Graph traversal and inference
- Relational reasoning
- Zero-shot KG completion

**Use Cases:**
- Scientific knowledge discovery
- Drug interaction prediction
- Concept relationship mapping
- Data integration

**Example:**
```python
cell = KGCell(model="ultra_50g")
output = cell.execute({
    "query": "(Aspirin, treats, ?)",
    "graph": "medical_kg"
})
# Output: Ranked list of diseases/conditions
```

### 5.3 Hybrid Cell (Nemotron + ULTRA)

**Models:** Both
**Capabilities:**
- Structured + unstructured reasoning
- Graph-augmented text generation
- Knowledge-grounded code generation

**Use Cases:**
- Scientific literature + KG synthesis
- Code generation with API knowledge
- Multi-modal problem solving

**Example:**
```python
cell = HybridCell(models=["nemotron-1.5b", "ultra_50g"])
output = cell.execute({
    "task": "generate_drug_synthesis_code",
    "compound": "Ibuprofen",
    "steps": [
        "ultra: predict reaction pathway",
        "nemotron: generate simulation code"
    ]
})
# Output: Graph + Code synthesis
```

### 5.4 Meta Cell (Composite)

**Models:** Orchestrates other cells
**Capabilities:**
- Multi-step workflows
- Cell chaining and composition
- Higher-order reasoning

**Use Cases:**
- Complex research pipelines
- Multi-agent collaboration
- Autonomous task execution

---

## 6. Formal State Machine

### 6.1 Execution State Machine

Every execution follows a **provably consistent** state transition model:

```
CREATED ──────────► VALIDATED ──────────► QUEUED
   │                    │                    │
   │                    │                    │
   ▼                    ▼                    ▼
CANCELLED          FAILED            EXECUTING
                                         │
                                         ▼
                          ┌──────────────┴──────────────┐
                          │                             │
                          ▼                             ▼
                      SUCCESS                      FAILED/CANCELLED/TIMEOUT
```

**Valid Transitions:**
- `CREATED` → `VALIDATED`, `FAILED`, `CANCELLED`
- `VALIDATED` → `QUEUED`, `CANCELLED`
- `QUEUED` → `EXECUTING`, `CANCELLED`, `TIMEOUT`
- `EXECUTING` → `SUCCESS`, `FAILED`, `CANCELLED`, `TIMEOUT`
- **Terminal states** (no transitions out): `SUCCESS`, `FAILED`, `CANCELLED`, `TIMEOUT`

**Guarantees:**
- Cannot skip states (e.g., cannot go CREATED → EXECUTING directly)
- Cannot transition from terminal states
- Every transition is recorded with timestamp and reason
- Complete audit trail for compliance

### 6.2 Node State Machine

Each DAG node (task) has its own state machine:

```
PENDING ────────► READY ────────► RUNNING ────────► COMPLETE
   │                │                 │
   │                │                 │
   ▼                ▼                 ▼
SKIPPED         BLOCKED            FAILED
                   │
                   │
                   ▼
               READY/FAILED/SKIPPED
```

**Valid Transitions:**
- `PENDING` → `READY`, `BLOCKED`, `SKIPPED`
- `READY` → `RUNNING`, `BLOCKED`, `SKIPPED`
- `RUNNING` → `COMPLETE`, `FAILED`, `BLOCKED`
- `BLOCKED` → `READY`, `FAILED`, `SKIPPED`
- **Terminal states**: `COMPLETE`, `FAILED`, `SKIPPED`

**Guarantees:**
- Tasks only run when all dependencies are `COMPLETE`
- Failed dependencies cause downstream tasks to `SKIP`
- Blocked tasks can recover to `READY` state
- Each transition tracked for debugging

### 6.3 DAG Contract

The **DAG Contract** enforces structural and behavioral guarantees:

```go
type DAGContract struct {
    ExecutionID  string
    IntentID     string
    Nodes        map[string]*NodeStateMachine
    Edges        map[string][]string
    StateMachine *ExecutionStateMachine
}
```

**Validation Checks:**
- **Cycle Detection**: DFS-based algorithm prevents circular dependencies
- **Dependency Existence**: All referenced nodes must exist in graph
- **State Consistency**: Node states must be valid for current execution state

**Operations:**
```go
// Validate graph structure before execution
func (dc *DAGContract) Validate() error

// Get nodes ready to execute (all deps complete)
func (dc *DAGContract) GetReadyNodes() []string

// Create deterministic snapshot for replay
func (dc *DAGContract) Snapshot() DAGSnapshot

// Get complete audit log with state history
func (dc *DAGContract) GetAuditLog() AuditLog
```

### 6.4 Audit Trail

Every execution produces a complete audit log:

```go
type AuditLog struct {
    ExecutionID      string
    IntentID         string
    ExecutionHistory []StateTransition  // All execution state changes
    NodeHistories    map[string][]NodeTransition  // Per-node transitions
    CurrentSnapshot  DAGSnapshot  // Final state snapshot
    CreatedAt        time.Time
    LastUpdated      time.Time
}
```

**Use Cases:**
- **Compliance**: Prove execution correctness for audits
- **Debugging**: Trace exactly when and why failures occurred
- **Replay**: Restore execution from any snapshot
- **Analysis**: Understand performance bottlenecks via timing data

### 6.5 Production Hardening

**Session-Based Authorization:**
- Each execution tagged with `sessionId`
- Only owner can view/cancel executions
- Multi-tenant safe isolation

**Lifecycle Management:**
```go
type CellLifecycleState int
const (
    CellCreated
    CellActive
    CellExecuting   // CANNOT DELETE in this state
    CellDraining
    CellDeleted
)
```

**Output Verification:**
- Validation gate before memory writes
- Size limits (1MB max per output)
- Schema validation for structured outputs
- Prevents corrupted data from being persisted

**Safety Gates:**
- Hard timeout (15 minutes max per execution)
- Automatic cancellation on context timeout
- Goroutine leak prevention
- Atomic event streaming (no race conditions)

---

## 7. Backend & Asset Integration

### 7.1 Go Kernel

**Responsibilities:**
- HTTP/HTTPS server (Gin/Echo)
- WebSocket hub for message bus
- Mind Cell lifecycle management
- Model invocation orchestration
- VFS relay to browser
- Task engine (DAG executor)

**Key Services:**
```go
// backend/services/
- ai/orchestrator.go      // Intent parsing & execution
- ai/mind_cells.go        // Cell factory & management
- ai/local.go             // Python worker interface
- compute/vm.go           // WASM runner
- task/engine.go          // DAG executor
- vfs/relay.go            // IndexedDB bridge
- foundry/recipes.go      // DAG templates
```

### 6.2 Python Worker

**Path:** `models/runner/serve.py`
**Protocol:** JSON lines over stdin/stdout
**Operations:**
- `complete` — Text generation (Nemotron)
- `kg_query` — Graph reasoning (ULTRA) [future]
- `embed` — Text embeddings
- `health` — Status check
- `models` — List available models

**Example:**
```json
// Request
{"op": "complete", "model": "nemotron-1.5b", "prompt": "...", "max_new_tokens": 128}

// Response
{"ok": true, "text": "generated output..."}
```

### 6.3 Frontend (React + Vite)

**Path:** `frontend/src/`
**Components:**
- Desktop shell (windows, dock, taskbar)
- Monaco Editor with AI autocomplete
- File Explorer (VFS browser)
- Settings panel
- AI Chat (Mind Cell interface)

**Services:**
- `websocket.js` — Bus client
- `vfsProxy.ts` — IndexedDB VFS
- `toast.js` — Error notifications

**Embedded:** Built frontend → `assets/web/` → Go binary

### 6.4 Storage Layer

**VFS (Virtual File System):**
- Browser: IndexedDB (per-session)
- Backend: VFS relay (session-addressed delivery)
- Metadata: SQLite for file listings

**Mind Cell Memory:**
- SQLite for cell metadata
- VFS for large outputs
- In-memory cache for hot data

**Intent Logs:**
- SQLite for analytics
- JSON-formatted execution traces
- Used for cell evolution

---

## 7. API Reference

### 7.1 Mind Cell API

**Create Cell:**
```
POST /api/mind-cells
{
  "type": "reasoning|kg|hybrid|meta",
  "model": "nemotron-1.5b|ultra_50g",
  "config": { ... }
}
Response: { "id": "cell-abc123" }
```

**Execute Cell:**
```
POST /api/mind-cells/{id}/execute
{
  "input": { ... }
}
Response: { "output": { ... }, "time_ms": 450 }
```

**List Cells:**
```
GET /api/mind-cells?type=reasoning&limit=20
Response: [ { "id": "...", "type": "...", ... }, ... ]
```

### 7.2 Intent API

**Parse Intent:**
```
POST /api/intent/parse
{
  "intent": "natural language query",
  "context": { ... }
}
Response: { "tasks": [ ... ], "graph": { ... } }
```

**Execute Intent:**
```
POST /api/intent/execute
{
  "tasks": [ ... ],
  "options": { "dry_run": false }
}
Response: { "run_id": "run-xyz789" }
```

**Status:**
```
GET /api/intent/{run_id}/status
Response: {
  "state": "running|completed|failed",
  "progress": 0.75,
  "tasks": [ ... ]
}
```

### 7.3 WebSocket Topics

**Mind Cells:**
- `mind.cell.create` → `mind.cell.create:ack`
- `mind.cell.execute` → `mind.cell.execute:resp`
- `mind.cell.list` → `mind.cell.list:resp`

**Intent:**
- `ai.intent.plan` → `ai.intent.plan:resp`
- `ai.intent.execute` → `ai.intent.execute:ack`
- `task.event`, `task.done`, `task.error`

**AI:**
- `ai.complete` → `ai.complete:resp`
- `ai.chat` → `ai.chat:resp`
- `ai.embed` → `ai.embed:resp`

---

## 8. Implementation Roadmap

### Phase 1: Foundation (Current)
- ✅ Nemotron + ULTRA model integration
- ✅ Python worker with model loading
- ✅ Basic frontend (Editor, Files, Settings)
- ✅ WebSocket message bus
- ✅ VFS (IndexedDB)

### Phase 2: Mind Cells (Q1 2025)
- [ ] Mind Cell factory (Go)
- [ ] Cell types: Reasoning, KG, Hybrid
- [ ] Cell memory storage (SQLite)
- [ ] Cell API endpoints
- [ ] Frontend: Cell manager UI

### Phase 3: Orchestrated Intent (Q2 2025)
- [ ] Intent parser (NLP → tasks)
- [ ] Task prioritizer & scheduler
- [ ] DAG execution with dependencies
- [ ] Error recovery & fallbacks
- [ ] Intent logs & analytics

### Phase 4: Foundry (Q2 2025)
- [ ] Recipe creation (save DAGs)
- [ ] Recipe instantiation (templates)
- [ ] Recipe marketplace
- [ ] Composite cell recipes
- [ ] Community sharing

### Phase 5: Advanced Features (Q3-Q4 2025)
- [ ] Multi-model support (add more models)
- [ ] Distributed execution (WebRTC mesh)
- [ ] Offline-first PWA
- [ ] Mobile support (iOS/Android)
- [ ] AGI orchestration layer

---

## 9. Developer Guidelines

### 9.1 Adding a New Mind Cell Type

1. **Define Cell Type:**
```go
// backend/services/ai/mind_cells.go
type MyCustomCell struct {
    BaseMindCell
    CustomField string
}

func (c *MyCustomCell) Execute(input interface{}) (interface{}, error) {
    // Your logic here
}
```

2. **Register in Factory:**
```go
factory.RegisterCellType("custom", func(config CellConfig) MindCell {
    return &MyCustomCell{ ... }
})
```

3. **Update API:**
```go
// backend/api/mind_cells.go
router.POST("/mind-cells", createMindCellHandler)
```

4. **Frontend Integration:**
```jsx
// frontend/src/services/mindCells.js
export async function executeCell(cellId, input) {
    return sendRequest('mind.cell.execute', { cellId, input }, {
        replyTopic: 'mind.cell.execute:resp'
    });
}
```

### 9.2 Model Update Process

**Add New Model:**
1. Clone model to `models/new_model/`
2. Update `models/runner/serve.py`:
```python
elif model_key == "new_model":
    path = os.path.join("models", "new_model")
    # Load model...
```
3. Update `config.yaml`:
```yaml
models:
  complete_primary: "new_model"
```
4. Restart system

**Benchmark:**
```bash
python benchmark.py --model new_model --tasks math,code,reasoning
```

### 9.3 Debugging Mind Cells

**Enable Logging:**
```bash
export AETHER_LOG_LEVEL=debug
./launch.sh
```

**Trace Execution:**
```go
// backend/services/ai/mind_cells.go
log.Printf("[MindCell] %s executing with input: %+v", c.ID, input)
```

**Replay Cell:**
```bash
curl -X POST http://localhost:8080/api/mind-cells/{id}/replay \
  -d '{"execution_id": "exec-123"}'
```

---

## 10. Advantages

### 10.1 Technical Excellence

✅ **Modular & Scalable**
- Mind Cells grow as new models/tasks are introduced
- Factory pattern for cell creation
- Composable cell types

✅ **Hybrid Intelligence**
- Unstructured reasoning (Nemotron)
- Structured graph reasoning (ULTRA)
- Best of both worlds

✅ **Persistent Knowledge**
- Cells retain and evolve knowledge
- Memory survives restarts
- Learning from past executions

✅ **Orchestration Ready**
- Foundry assembles complex pipelines
- DAG execution with dependencies
- Error recovery built-in

### 10.2 Performance

✅ **Optimized Models**
- Nemotron: 1.5B params, ~200-500ms CPU
- ULTRA: 169K params, ~50-100ms
- Efficient resource usage

✅ **Lazy Loading**
- Models loaded on demand
- Memory-efficient caching
- LRU eviction (future)

✅ **Parallel Execution**
- Independent tasks run concurrently
- WebSocket for low-latency messaging
- Async/await patterns throughout

### 10.3 Developer Experience

✅ **Simple APIs**
- RESTful + WebSocket
- JSON everywhere
- Well-documented

✅ **Extensible**
- Plugin architecture for new cells
- Model swapping without code changes
- Community recipes

✅ **Observable**
- Intent logs for analytics
- Cell execution traces
- Performance metrics

### 10.4 User Experience

✅ **Intelligent**
- AI understands user intent
- Automatic task decomposition
- Context-aware responses

✅ **Fast**
- <500ms AI responses
- 60fps UI rendering
- Optimistic updates

✅ **Reliable**
- Error recovery & fallbacks
- Graceful degradation
- Offline-capable (future)

---

## Conclusion

This blueprint provides a **complete engineering roadmap** for AetherOS with:

- **Nemotron** as generalist reasoning engine
- **ULTRA** as knowledge graph reasoning engine
- **Orchestrated Intent** for task decomposition
- **Mind Cell Factory** for autonomous memory & reasoning
- **Foundry** for reusable automation recipes
- **Full-stack integration** (Go backend + React frontend + Python AI)

**Next Steps:**
1. Implement Mind Cell factory (Phase 2)
2. Build Orchestrated Intent parser (Phase 3)
3. Deploy Foundry recipes (Phase 4)
4. Scale to production (Phase 5)

**The future of computing is not just intelligent — it's orchestrated, autonomous, and self-improving.**

---

*AetherOS — Built by one person. Powered by AI. Running everywhere.*

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

<div align="center">

# AetherOS — The Browser-Native Operating System

**A complete desktop OS that runs in your browser. Built entirely by a solo developer with AI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status: Beta](https://img.shields.io/badge/Status-Beta-orange.svg)](https://github.com)
[![Version: 1.0](https://img.shields.io/badge/Version-1.0-green.svg)](CHANGELOG.md)

[Quick Start](#-quickstart) • [Features](#-what-youre-looking-at) • [Architecture](#-architecture) • [Documentation](#-documentation)

</div>

---

## 🚀 The Story

This is what happens when one person, a vision, and modern AI tools come together.

**AetherOS is a fully functional operating system that runs entirely in your browser** — complete with a Monaco-powered code editor, AI-driven development tools, WASM compute engine, file management, and a desktop environment that rivals native applications.

**Every line of code was architected through AI-assisted development.** This isn't just a prototype or a tech demo. It's a production-grade system that proves what's possible when human creativity meets AI capability.

### What Makes This Different

- **Zero install** — Runs anywhere a browser can run
- **Full OS experience** — Desktop shell, window manager, dock, applications
- **AI-native** — Built with AI, powered by AI, designed for AI workflows
- **Production-ready** — Real architecture, real protocols, real security
- **Solo-built** — One person + AI = Full operating system

This is the future of software development. Not AI replacing developers — AI **amplifying** developers.

---

## ⚡ Quickstart

```bash
./launch.sh
```

Open `http://localhost:8080` and experience a complete OS in your browser.

That's it. No Docker, no VMs, no complex setup. Just run.

**First time setup:**
- Automatically installs Go 1.24+ if needed
- Automatically installs Node.js 18+ if needed
- Sets up Python environment for local AI models
- Builds 39MB single-binary with embedded frontend
- Launches in under 10 seconds

**What you'll see:**
- Animated desktop with glassmorphic UI
- Monaco Editor with AI autocomplete
- File Explorer with full CRUD operations
- WASM Runner for executing binaries
- Settings panel with theme/config
- AI Chat for code assistance
- All running at 60fps in your browser

---

## 🎯 What You're Looking At

### A Real Desktop OS
- **Window Manager** — Drag, resize, minimize, z-index stacking like macOS
- **Dock** — Launch applications with smooth animations and icon magnification
- **Taskbar** — Real-time clock, WebSocket status, system indicators
- **Desktop** — Animated gradient background with ambient lighting effects

### Professional Development Tools
- **Monaco Editor** — The same engine that powers VS Code
  - Syntax highlighting for 50+ languages
  - AI-powered autocomplete (local models, no API calls)
  - IntelliSense, snippets, multi-cursor editing
  - VFS integration with Cmd/Ctrl+S and Cmd/Ctrl+P
  - Run WASM binaries directly from editor

- **File Explorer** — Full-featured file management
  - Browse IndexedDB-backed virtual file system
  - List/Grid view modes with file type icons
  - Search, sort, preview, delete, create folders
  - Drag-and-drop ready architecture

- **Settings** — Complete system configuration
  - Theme selection (Dark/Light/Auto)
  - Font size customization
  - AI toggle and preferences
  - Export/Import settings as JSON
  - System info dashboard

### Compute Layer That Actually Works
- **WASM Runner** — Execute WebAssembly binaries safely
  - Upload .wasm files (WASI-compatible)
  - Live stdout/stderr streaming
  - Interactive stdin
  - Process isolation via wazero

- **VM Abstraction** — Pluggable compute backends
  - Default: wazero (server-side WASI/WASM)
  - Preview: v86 (client-side x86 emulation)
  - Unified `vm.*` API for all backends
  - Session-scoped isolation

### AI Integration Done Right
- **Local Models** — No API keys, no rate limits, no privacy concerns
  - **Phi-3-Mini-4K-Instruct** (3.8B params, ~2.3GB):
    - Microsoft's SOTA small model
    - Best-in-class code generation & reasoning
    - Chat, autocomplete, Mind Cell orchestration
  - **all-MiniLM-L6-v2** (~90MB) - Embeddings
  - Runs in Python subprocess, isolated
  - Advanced generation params prevent hallucination

- **AI Features**
  - Inline autocomplete with debouncing
  - Context-aware suggestions (cursor position, file type)
  - Ask AI panel for code explanation
  - Chat history with context preservation
  - File/selection context injection

- **Mind Cell System** — Autonomous reasoning units with memory
  - Graph-based DAG orchestration for complex tasks
  - Intent-to-execution pipeline (natural language → task graph)
  - Multiple cell types: ReasoningCell, KGCell, HybridCell, MetaCell
  - Formal state machine guarantees (provably consistent execution)
  - Session-based isolation with lifecycle management
  - Production-hardened with output verification gates
  - Complete audit trail for compliance and replay

---

## 🏗️ Architecture

### The Genius of Simplicity

```
┌─────────────────────────────────────────────────────────────┐
│                        Browser Tab                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  React Desktop Shell (Vite + Monaco Editor)          │  │
│  │  • Window Manager  • Dock  • Applications            │  │
│  │  • VFS Proxy (IndexedDB)  • v86 Adapter              │  │
│  └──────────────────────────────────────────────────────┘  │
│                           ▲                                 │
│                           │ WebSocket (JSON Envelopes)     │
│                           ▼                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Go Kernel (Single 39MB Binary)                      │  │
│  │  • Message Bus  • AI Orchestrator  • Task Engine     │  │
│  │  • WASM Runtime  • VFS Relay  • Session Manager      │  │
│  └──────────────────────────────────────────────────────┘  │
│                           ▲                                 │
│                           │ Subprocess                      │
│                           ▼                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Python AI Worker (.venv_ai)                         │  │
│  │  • HuggingFace Transformers  • Local Models          │  │
│  │  • PyTorch CPU  • Ultra Package                      │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Why This Works

**Message Bus Architecture**
- Everything communicates via WebSocket topics
- JSON envelopes with correlation IDs (`_request_id`)
- Pub/sub + request/response patterns unified
- Wildcard subscriptions (`vm.*`, `vfs:*`)
- Addressed delivery for multi-tab safety
- Standardized error schema across all services

**Session Isolation**
- Each browser tab gets unique `sessionId`
- VFS scoped per-session (no cross-tab leaks)
- Compute instances tagged with sessionId
- Addressed message delivery prevents collisions
- True multi-tenant safety in browser

**Security Model**
- WASI sandbox via wazero (capability-based security)
- Permission rules (default-deny when configured)
- Rate limiting per-client, per-topic
- Resource caps on compute instances
- No network access from WASM by default
- Admin token bypass for trusted automation

**Performance**
- Frontend: 256KB bundle, 79KB gzipped
- Backend: 39MB binary (includes all assets)
- Cold start: <10 seconds including AI model load
- Hot reload: <1 second
- Message latency: 2-15ms localhost, <100ms LAN
- Monaco loads in <500ms with full LSP features

---

## 📚 Core Concepts

### Message Envelope
Every interaction is a JSON message:
```json
{
  "topic": "vm.spawn",
  "from": "client-abc123",
  "to": "client-def456",
  "payload": { "_request_id": "req-789", "wasm_b64": "..." },
  "time": "2025-11-25T20:00:00Z"
}
```

### Topics (The Language of AetherOS)
- `ai.*` — Autocomplete, chat, intent planning
- `mindcell.*` — Cell create/execute/list/delete
- `intent.*` — Parse/execute/status/cancel DAG orchestration
- `vm.*` — Compute spawn/stdin/kill, stdout/stderr/exit
- `vfs:*` — File write/read/list/delete/rename
- `task.*` — DAG define/run/cancel/status
- `mem.*` — Temporal memory (past/present/future)
- `foundry.*` — Recipe create/list/instantiate

### Request/Response Correlation
Client attaches `_request_id`, service echoes it back:
```javascript
const { payload } = await sendRequest('vfs:read',
  { sessionId, path: '/code/main.js' },
  { replyTopic: 'vfs:read:resp', timeout: 5000 }
);
```

Errors go to derived error topics:
- `vfs:write` → `vfs:write:error`
- `vm.spawn` → `vm.spawn.error`

Standard error payload:
```json
{
  "_request_id": "req-789",
  "code": "permission_denied",
  "error": "topic not allowed",
  "details": { "topic": "system.exec" }
}
```

---

## 🎨 Applications

### Monaco Editor
VS Code in the browser, but better:
- AI autocomplete that actually understands context
- VFS integration (save/load from IndexedDB)
- Multi-language support (Go, Rust, Python, JS/TS, WASM)
- Run button that executes WASM directly
- Ask AI panel for code help
- Keyboard shortcuts: Cmd/Ctrl+S (save), Cmd/Ctrl+P (quick open)

### File Explorer
Dropbox-level file management:
- List and Grid view modes
- Search with live filtering
- Sort by name/date/size
- File preview modal
- Create folders, delete files
- File type icons for 15+ extensions
- Breadcrumb navigation
- Session-scoped isolation

### WASM Runner
Execute WebAssembly binaries safely:
- Upload .wasm files (WASI-compatible)
- Live stdout/stderr in color-coded output
- Interactive stdin
- Kill processes anytime
- Process isolation via wazero
- Multiple instances supported

### Settings
Control everything:
- Appearance (theme, font size)
- Editor preferences (auto-save, AI toggle)
- System info (session ID, WebSocket status, browser details)
- Data management (export/import settings, clear data)
- About section with version and docs links

### AI Agent (Chat)
Conversational code assistant:
- Context-aware responses
- File and selection context injection
- Chat history with scrollback
- Markdown rendering
- Powered by local models (no API calls)

### Marketplace
Discover and launch apps:
- Fetches available apps from `/apps` endpoint
- Grid layout with icons and descriptions
- Click to open any application
- Extensible architecture for third-party apps

---

## 🔐 Security & Guardrails

### Permission System
Topic-level allow/deny rules:
```yaml
permissions:
  - topic_prefix: "vfs:"
    allow: true
  - topic_prefix: "vm."
    allow: true
  - topic_prefix: "system."
    allow: false
```
- Default-allow if no rules configured (dev mode)
- Default-deny when rules exist (production mode)
- Admin bypass with bearer token

### Rate Limiting
Per-client, per-topic token buckets:
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
- Graceful degradation (errors include `resetMs`)
- Admin accounts bypass limits

### Resource Caps
- WASM instances: memory limits, wall-time timeouts
- Task engine: per-node and run-level timeouts
- VFS: session-scoped (no cross-tab access)
- AI: token limits, prompt size caps

---

## 🚀 Advanced Features

### Mind Cell Orchestration
Natural language → autonomous task graph execution:

```javascript
// Create a reasoning cell
const { cell } = await sendRequest('mindcell.create', {
  type: 'ReasoningCell',  // or KGCell, HybridCell, MetaCell
  model: 'phi3',  // Phi-3-Mini-4K-Instruct (3.8B params)
  config: { temperature: 0.7 }
});

// Execute intent with natural language
await sendRequest('intent.execute', {
  intent: "Analyze codebase for security issues, generate report",
  sessionId: "session-123"
});

// System automatically:
// 1. Parses intent → task graph (DAG)
// 2. Validates DAG structure (cycle detection)
// 3. Creates state machine with formal transitions
// 4. Executes tasks in parallel (respecting dependencies)
// 5. Streams events: state_transition, task_start, task_complete
// 6. Records full audit trail with timestamps

// Track execution progress
const { status } = await sendRequest('intent.status', {
  executionId: "exec-789"
});
// Returns: { status: "executing", progress: 0.6, events: [...] }

// Get audit log for compliance
const { auditLog } = await sendRequest('intent.audit', {
  executionId: "exec-789"
});
// Returns: complete state history for replay/analysis
```

### Intent-First Orchestration
State a goal, get a plan, execute with safety:

```javascript
// User: "Refactor auth module to use bcrypt, run tests, summarize"
await sendRequest('ai.intent.plan', {
  goal: "Refactor auth to bcrypt, test, summarize",
  horizon: { past: true, present: true }
});

// System returns DAG:
// mem.query(auth history) → sense(vfs:list) → ai.step(plan)
// → vfs:write(patches) → vm.spawn(tests) → ai.step(summary)

await sendRequest('ai.intent.execute', { plan });
// Streams: task.event → task.done with results
```

Node types: `mem.query`, `sense`, `ai.step`, `bus.request`, `guard`

### Foundry (DAG Recipes)
Save and share automation:
```javascript
// Create recipe
await sendRequest('foundry.recipe.create', {
  name: "Deploy to Production",
  nodes: [...],
  edges: [...],
  paramsSchema: { branch: "string", env: "string" }
});

// Instantiate with params
const { plan } = await sendRequest('foundry.recipe.instantiate', {
  id: "recipe-123",
  params: { branch: "main", env: "prod" }
});

// Execute
await sendRequest('ai.intent.execute', { plan });
```

### Task Engine
Define and run DAGs:
```javascript
await sendRequest('task.define', {
  graphId: "build-test-deploy",
  nodes: [
    { id: "build", type: "bus.request", topic: "vm.spawn", payloadTemplate: {...} },
    { id: "test", type: "bus.request", topic: "vm.spawn", payloadTemplate: {...} },
    { id: "deploy", type: "bus.publish", topic: "deploy.trigger", payloadTemplate: {...} }
  ],
  edges: [
    { from: "build", to: "test" },
    { from: "test", to: "deploy" }
  ]
});

const { runId } = await sendRequest('task.run', { graphId: "build-test-deploy" });
// Observe: task.event, task.done, task.error
```

### Temporal Memory
Remember past, sense present, plan future:
```javascript
// Store checkpoint
await sendRequest('mem.future.put', {
  sessionId,
  key: "/checkpoints/v2.0-release",
  value: { goals: [...], blockers: [...] },
  tags: ["release", "milestone"]
});

// Query history
const { items } = await sendRequest('mem.past.query', {
  sessionId,
  tags: ["auth", "security"],
  topK: 10
});

// Sense current state
const { items } = await sendRequest('mem.present.query', {
  sessionId,
  prefix: "/tasks/active"
});
```

---

## 🛠️ Development

### Project Structure
```
aetherOS/
├── frontend/              # React + Vite + Monaco
│   ├── src/
│   │   ├── main.jsx      # Bootstrap (VFS, v86, toasts)
│   │   ├── App.jsx       # Desktop shell + routing
│   │   ├── desktop/      # Window manager, Dock
│   │   ├── windows/      # Applications
│   │   ├── services/     # WebSocket, VFS, AI, toasts
│   │   └── styles/       # CSS (desktop, windows, dock)
│   └── public/           # Static assets (icons, logos)
│
├── backend/              # Go kernel
│   ├── main.go           # Entry point, HTTP server
│   ├── server/           # WebSocket hub, bus, correlation
│   ├── ai/               # Orchestrator, planner, executor
│   ├── mindcell/         # Mind Cell system (DAG orchestration)
│   │   ├── types.go      # Core data structures
│   │   ├── factory.go    # Cell lifecycle management
│   │   ├── executor.go   # DAG execution engine
│   │   ├── state_machine.go  # Formal state transitions
│   │   ├── intent.go     # Natural language parsing
│   │   ├── models.go     # Model abstraction layer
│   │   ├── api_hardened.go   # Production API with guards
│   │   └── integration.go    # Orchestrator wiring
│   ├── compute/          # VM bridge, wazero, v86 relay
│   ├── task/             # DAG engine
│   ├── memory/           # Temporal memory (VFS-backed)
│   └── foundry/          # Recipe manager
│
├── models/               # AI models (symlinked)
│   ├── runner/           # Python worker (serve.py)
│   ├── ultra/            # Ultra 50G model
│   └── graphsgpt/        # GraphsGPT-4W model
│
├── assets/               # Embedded assets
│   ├── web/              # Frontend build output
│   └── embed.go          # go:embed directive
│
├── config.yaml           # Server configuration
├── .env                  # Environment variables
├── launch.sh             # Build + launch (recommended)
├── build.sh              # Build only
└── bin/
    └── aether            # Compiled binary (39MB)
```

### Build Process
```bash
# Development (hot reload)
cd frontend && npm run dev
# Open http://localhost:5173

cd backend && go run main.go
# WebSocket at ws://localhost:8080/ws

# Production (single binary)
./launch.sh
# or
./build.sh && ./bin/aether
```

### Adding New Applications
1. Create `frontend/src/windows/YourAppWindow.jsx`
2. Export from `frontend/src/windows/index.js`
3. Add case in `frontend/src/App.jsx`
4. Register in `backend/apps.go`
5. Use `services/websocket.js` for bus interactions

Example:
```jsx
import { useState, useEffect } from 'react';
import { sendRequest } from '../services/websocket';

export default function YourAppWindow() {
  const [data, setData] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      const result = await sendRequest('your.topic', {},
        { replyTopic: 'your.topic:resp', timeout: 5000 }
      );
      setData(result.payload);
    };
    fetchData();
  }, []);

  return <div>Your app content: {JSON.stringify(data)}</div>;
}
```

### Extending the Bus
Add new services by subscribing to topics:
```go
func NewMyService(bus *server.BusServer) *MyService {
    s := &MyService{bus: bus}
    bus.Subscribe("my.service.*", s.handleRequest)
    return s
}

func (s *MyService) handleRequest(env server.Envelope) {
    switch env.Topic {
    case "my.service.action":
        // Handle request
        s.bus.Reply("my.service.action:resp", requestID, payload)
    }
}
```

---

## 📖 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** — Get running in 60 seconds
- **[WHITEPAPER.md](WHITEPAPER.md)** — Architecture, protocols, guardrails
- **[RESEARCH-PAPER.md](RESEARCH-PAPER.md)** — Formal methodology and evaluation
- **[ACADEMIC.md](ACADEMIC.md)** — Citation, reproducibility, ethics
- **[STANDARD.md](STANDARD.md)** — AI-Native Browser OS specification
- **[IP_PROTECTION.md](IP_PROTECTION.md)** — Licensing and contributor terms

---

## 🎓 What This Proves

### Technical Achievement
- **Full-stack OS in browser** — Not just a webapp, an actual OS
- **Production architecture** — Message bus, session isolation, guardrails
- **AI integration** — Local models, no API dependencies
- **Performance** — 39MB binary, <10s cold start, 60fps UI
- **Security** — WASI sandboxing, permissions, rate limits, resource caps

### Development Model
- **Solo developer + AI** — One person orchestrated, AI implemented
- **Rapid iteration** — Major features in hours, not weeks
- **Quality output** — Production-grade code, comprehensive docs
- **AI as amplifier** — Human vision × AI execution = 10x productivity

### What's Possible Now
- Build entire operating systems solo
- Ship complex systems in days
- Maintain enterprise-grade security
- Iterate at unprecedented speed
- Focus on vision, let AI handle implementation

**This is not the future. This is now.**

---

## 🚀 Roadmap

### Near-term (Q1 2025)
- v86 Worker runtime (full x86 emulation in browser)
- Streaming AI responses (`ai.stream`, `ai.done`)
- Editor LSP integration (Go, Rust, TypeScript)
- File upload/download from local filesystem
- Extended browser storage (quota API)

### Mid-term (Q2 2025)
- Multi-user collaboration (CRDT-based)
- Cloud sync for VFS (optional)
- Plugin marketplace
- Docker container deployment
- Kubernetes operator

### Long-term (Q3-Q4 2025)
- Mobile support (iOS/Android)
- Offline-first PWA
- Distributed compute (WebRTC mesh)
- Blockchain integration (trustless execution)
- AGI orchestration layer

---

## 🤝 Contributing

This project proves what's possible with AI-assisted development. Contributions welcome:

- **Bug reports** — File issues with reproduction steps
- **Feature requests** — Describe the use case
- **Pull requests** — Include tests and docs
- **Documentation** — Improve guides and examples

### Development Setup
```bash
git clone https://github.com/yourusername/aetherOS.git
cd aetherOS
./launch.sh
```

### Code Style
- Go: `gofmt`, `golint`, follow standard library patterns
- JavaScript: Prettier, ESLint, React best practices
- Python: Black, mypy, PEP 8

### Testing
```bash
# Frontend
cd frontend && npm test

# Backend
cd backend && go test ./...

# Integration
./test/integration.sh
```

---

## 📜 License

MIT License — see [LICENSE](LICENSE)

**Free to use, modify, distribute. Give credit where credit is due.**

---

## 🙏 Acknowledgments

Built with:
- **Go** — Backend kernel, WebSocket hub, compute layer
- **React + Vite** — Frontend framework and build tool
- **Monaco Editor** — VS Code engine
- **wazero** — Pure-Go WASM runtime
- **HuggingFace Transformers** — AI model infrastructure
- **IndexedDB** — Browser-based file system
- **Claude AI** — Primary development assistant

Special thanks to the open-source community for the tools that made this possible.

---

## 💬 Support & Community

- **Issues** — [GitHub Issues](https://github.com/yourusername/aetherOS/issues)
- **Discussions** — [GitHub Discussions](https://github.com/yourusername/aetherOS/discussions)
- **Twitter** — [@aetherOS](https://twitter.com/aetherOS)
- **Discord** — [Join the community](https://discord.gg/aetherOS)

---

<div align="center">

**Built by one person. Powered by AI. Running everywhere.**

[Try it now](http://localhost:8080) • [Read the whitepaper](WHITEPAPER.md) • [Join the discussion](https://github.com/yourusername/aetherOS/discussions)

---

*"The best way to predict the future is to build it. The fastest way to build it is with AI."*

</div>

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

I did this
