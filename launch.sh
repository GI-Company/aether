#!/usr/bin/env bash
set -e

# =============================================================================
# AetherOS Unified Launch Script
# Builds everything and launches the live system in a connected terminal
# =============================================================================

FRONTEND_DIR="frontend"
BACKEND_DIR="backend"
BINARY_PATH="./bin/aether"
VENV_DIR=".venv_ai"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear

echo -e "${CYAN}"
echo "   █████╗ ███████╗████████╗██╗  ██╗███████╗██████╗  ██████╗ ███████╗"
echo "  ██╔══██╗██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗██╔═══██╗██╔════╝"
echo "  ███████║█████╗     ██║   ███████║█████╗  ██████╔╝██║   ██║█████╗  "
echo "  ██╔══██║██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗██║   ██║██╔══╝  "
echo "  ██║  ██║███████╗   ██║   ██║  ██║███████╗██║  ██║╚██████╔╝███████╗"
echo "  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚══════╝"
echo -e "${NC}"
echo -e "${BLUE}AetherOS Unified Build + Launch${NC}"
echo ""

# ----------------------------
# 1. BUILD SYSTEM
# ----------------------------
echo -e "${CYAN}▶ Building AetherOS...${NC}"
if ./build.sh; then
  echo -e "${GREEN}✓ Build complete${NC}"
else
  echo -e "${RED}✗ Build failed${NC}"
  exit 1
fi
echo ""

# ----------------------------
# 2. PYTHON AI ENV
# ----------------------------
if [[ -d "$VENV_DIR" ]]; then
  echo -e "${CYAN}▶ Initializing AI Runtime${NC}"
  source "$VENV_DIR/bin/activate"
  echo -e "${GREEN}✓ Python virtual environment activated${NC}"
  echo ""
fi

# ----------------------------
# 3. LAUNCH KERNEL
# ----------------------------
if [[ ! -f "$BINARY_PATH" ]]; then
  echo -e "${RED}✗ Binary missing: $BINARY_PATH${NC}"
  echo -e "${YELLOW}Try running ./build.sh first${NC}"
  exit 1
fi

# Check if binary is executable
if [[ ! -x "$BINARY_PATH" ]]; then
  chmod +x "$BINARY_PATH"
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🚀  AetherOS Kernel Online${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Dashboard:${NC} http://localhost:8080"
echo -e "${BLUE}WebSocket:${NC} ws://localhost:8081"
echo ""
echo -e "${YELLOW}Note:${NC} AI models will auto-download on first use (~2.4GB)"
echo -e "       - Phi-3-Mini-4K-Instruct (2.3GB)"
echo -e "       - all-MiniLM-L6-v2 (90MB)"
echo ""
echo -e "${CYAN}Press CTRL+C to shut down AetherOS${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ----------------------------
# 4. LIVE SYSTEM CONSOLE
# ----------------------------
"$BINARY_PATH"
