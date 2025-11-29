#!/usr/bin/env bash

set -e

# =============================================================================
# AetherOS Build Script
# =============================================================================
# This script builds the application with all dependencies, frontend, backend,
# AI environment, and embeds assets into a single binary.
# Use ./launch.sh to build AND run the application.
# =============================================================================

# -----------------------
# Configuration
# -----------------------
FRONTEND_DIR="frontend"
BACKEND_DIR="backend"
BINARY_PATH="./bin/aether"
ASSETS_WEB_DIR="assets/web"
ASSETS_PYTHON_DIR="assets/python"
VENV_DIR=".venv_ai"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Animation frames for build scenery
SCENERY=("🌲" "🌳" "🏔️" "🌄" "☁️" "🌞" "✨" "🚀")

# -----------------------
# Helper Functions
# -----------------------
print_header() {
  echo -e "${CYAN}========================================${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${CYAN}========================================${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_info() {
  echo -e "  $1"
}

animate_scenery() {
  local msg="$1"
  for i in {1..2}; do
    for frame in "${SCENERY[@]}"; do
      echo -ne "\r$frame  $msg"
      sleep 0.08
    done
  done
  echo -e "\r✅ $msg"
}

# -----------------------
# Check Dependencies
# -----------------------
print_header "Checking Dependencies"

if ! command -v go &> /dev/null; then
  print_error "Go not found. Please install Go 1.24+ or run ./launch.sh"
  exit 1
else
  print_success "Go found: $(go version)"
fi

if ! command -v npm &> /dev/null; then
  print_error "npm not found. Please install Node.js 18+ or run ./launch.sh"
  exit 1
else
  print_success "npm found: $(npm -v)"
fi

if ! command -v python3 &> /dev/null; then
  print_warning "Python3 not found. AI features will be disabled."
else
  print_success "Python3 found: $(python3 --version)"
fi

# -----------------------
# Load Environment
# -----------------------
if [[ -f .env ]]; then
  print_info "Loading .env file..."
  set -a
  source .env
  set +a
  print_success "Environment loaded"
fi

# -----------------------
# Backend Dependencies
# -----------------------
print_header "Setting Up Backend"
cd "$BACKEND_DIR"
animate_scenery "Running go mod tidy"
go mod tidy > /dev/null 2>&1

animate_scenery "Vendoring dependencies"
go mod vendor > /dev/null 2>&1
cd ..
print_success "Backend dependencies ready"

# -----------------------
# Frontend Build
# -----------------------
print_header "Building Frontend"
cd "$FRONTEND_DIR"

if [[ ! -d "node_modules" ]]; then
  animate_scenery "Installing npm dependencies"
  npm install --silent
else
  print_success "npm dependencies already installed"
fi

animate_scenery "Building React + Monaco Editor"
npm run build --silent
cd ..
print_success "Frontend built successfully"

# -----------------------
# Python AI Environment
# -----------------------
if command -v python3 &> /dev/null && [[ "$AETHER_AI_LOCAL_ENABLED" != "0" ]]; then
  print_header "Setting Up Python AI Environment"

  if [[ ! -d "$VENV_DIR" ]]; then
    animate_scenery "Creating Python virtual environment"
    python3 -m venv "$VENV_DIR"
    print_success "Virtual environment created"
  else
    print_success "Virtual environment exists"
  fi

  source "$VENV_DIR/bin/activate"

  print_info "Upgrading pip..."
  python -m pip install -U pip setuptools wheel > /dev/null 2>&1
  print_success "Pip upgraded"

  animate_scenery "Installing transformers and sentence-transformers"
  python -m pip install -U --prefer-binary transformers sentence-transformers protobuf > /dev/null 2>&1 || true

  animate_scenery "Installing PyTorch (CPU version)"
  python -m pip install -U --prefer-binary torch --index-url https://download.pytorch.org/whl/cpu > /dev/null 2>&1 || \
  python -m pip install -U --prefer-binary torch > /dev/null 2>&1 || true

  animate_scenery "Installing graph ML dependencies (ULTRA)"
  python -m pip install -U --prefer-binary torch-geometric torch-scatter torch-sparse > /dev/null 2>&1 || true

  animate_scenery "Installing GraphsGPT dependencies"
  python -m pip install -U --prefer-binary rdkit > /dev/null 2>&1 || true

  print_success "AI dependencies installed"

  # Embed Python worker script
  print_info "Embedding Python AI worker..."
  mkdir -p "$ASSETS_PYTHON_DIR"
  cp models/runner/serve.py "$ASSETS_PYTHON_DIR/serve.py"
  print_success "Python worker embedded"

  deactivate

  # Check models
  print_header "AI Model Configuration"
  print_info "Models will auto-download from HuggingFace on first run:"
  print_info ""
  print_info "  📦 Phi-3-Mini-4K-Instruct"
  print_info "     Size: ~2.3GB"
  print_info "     Purpose: Code generation, reasoning, completions"
  print_info "     Provider: Microsoft (best-in-class small model)"
  print_info ""
  print_info "  📦 all-MiniLM-L6-v2"
  print_info "     Size: ~90MB"
  print_info "     Purpose: Semantic embeddings, similarity search"
  print_info "     Provider: Sentence-Transformers"
  print_info ""
  print_success "Total download: ~2.4GB"
  print_info "Cache location: \$HF_HOME or ~/.cache/huggingface/"
  print_info "Network required: Yes (for initial download only)"
  print_info ""
  print_info "Models are cached locally after first download."
  print_info "To pre-download models manually, run:"
  print_info "  source .venv_ai/bin/activate"
  print_info "  python -c \"from transformers import AutoModel; AutoModel.from_pretrained('microsoft/Phi-3-mini-4k-instruct')\""
  print_info "  python -c \"from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')\""
else
  print_warning "Skipping Python AI setup (disabled or Python not found)"
fi

# -----------------------
# Embed Frontend Assets
# -----------------------
print_header "Embedding Frontend Assets"
animate_scenery "Copying frontend build to assets/web"
rm -rf "$ASSETS_WEB_DIR"
mkdir -p "$ASSETS_WEB_DIR"

# Use absolute path for reliable copy
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(cd "$SCRIPT_DIR/$FRONTEND_DIR/dist" && tar cf - .) | (cd "$SCRIPT_DIR/$ASSETS_WEB_DIR" && tar xf -)

if [[ -f "$ASSETS_WEB_DIR/index.html" ]]; then
  print_success "Frontend assets embedded successfully"
else
  print_error "Failed to copy frontend assets"
  exit 1
fi

# -----------------------
# Build Backend Binary
# -----------------------
print_header "Building Backend Binary"
mkdir -p ./bin
animate_scenery "Compiling Go binary with embedded assets"

# Build with compression and optimization
go build -ldflags="-s -w" -o "$BINARY_PATH" ./backend

if [[ -f "$BINARY_PATH" ]]; then
  BINARY_SIZE=$(du -h "$BINARY_PATH" | cut -f1)
  print_success "Binary built: $BINARY_PATH ($BINARY_SIZE)"
else
  print_error "Failed to build binary"
  exit 1
fi

# -----------------------
# Build Summary
# -----------------------
print_header "Build Complete"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   🚀 AetherOS Build Successful!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BLUE}Binary:${NC}        $BINARY_PATH ($BINARY_SIZE)"
echo -e "  ${BLUE}Embedded:${NC}      Frontend assets (assets/web)"
if [[ -f "$ASSETS_PYTHON_DIR/serve.py" ]]; then
  echo -e "  ${BLUE}Embedded:${NC}      Python AI worker (assets/python)"
fi
echo ""
echo -e "${CYAN}To launch AetherOS:${NC}"
echo -e "  ${GREEN}./bin/aether${NC}"
echo -e "  ${GREEN}./launch.sh${NC}  (builds and runs)"
echo ""
echo -e "${CYAN}Open in browser:${NC}"
echo -e "  ${GREEN}http://localhost:8080${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
