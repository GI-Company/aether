#!/usr/bin/env bash
set -e

# -----------------------------
# AetherOS Lightweight Model Setup
# -----------------------------
MODELS_DIR="./models"

# Ensure models directory exists
mkdir -p "$MODELS_DIR"

echo "Downloading MiniLM-L6-v2 (embeddings)..."
cd "$MODELS_DIR"
git clone https://huggingface.co/sentence-transformers/MiniLM-L6-v2 MiniLM-L6-v2
cd MiniLM-L6-v2
git lfs pull
cd ..

echo "Downloading Mini Nemotron (lightweight reasoning)..."
git clone https://huggingface.co/yourusername/mini-nemotron MiniNemotron
cd MiniNemotron
git lfs pull
cd ..

echo "Downloading Any-to-Any 2B (graph reasoning)..."
git clone https://huggingface.co/deepseek-community/any-to-any-2B AnyToAny2B
cd AnyToAny2B
git lfs pull
cd ..

echo "Downloading CodeParrot-Small (code generation)..."
git clone https://huggingface.co/codeparrot/codeparrot-small CodeParrotSmall
cd CodeParrotSmall
git lfs pull
cd ..

echo "All lightweight models are downloaded and ready in $MODELS_DIR"
