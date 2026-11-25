#!/usr/bin/env bash
set -e

TOOLS_DIR="/workspaces/.tools"
mkdir -p "$TOOLS_DIR" /workspaces/samples

# 1. Download and extract the latest Ghidra release
if [ ! -d "$TOOLS_DIR/ghidra" ]; then
  echo "Downloading Ghidra..."
  GHIDRA_URL=$(curl -s https://github.com \
    | grep "browser_download_url" \
    | grep "_PUBLIC_.*\.zip" \
    | cut -d '"' -f 4)

  curl -L "$GHIDRA_URL" -o /tmp/ghidra.zip
  unzip -q /tmp/ghidra.zip -d "$TOOLS_DIR/ghidra-tmp"
  mv "$TOOLS_DIR/ghidra-tmp"/* "$TOOLS_DIR/ghidra"
  rm -rf "$TOOLS_DIR/ghidra-tmp" /tmp/ghidra.zip
fi

# Ensure GHIDRA_INSTALL_DIR is available in all shell sessions
grep -qxF 'export GHIDRA_INSTALL_DIR="/workspaces/.tools/ghidra"' ~/.bashrc || \
  echo 'export GHIDRA_INSTALL_DIR="/workspaces/.tools/ghidra"' >> ~/.bashrc

# 2. Install Gemini CLI and REA CLI
npm install -g @google/gemini-cli rea-agents

# 3. Connect REA to Gemini CLI automatically
npx rea-agents@latest setup --client gemini_cli

echo "Setup complete! Type 'gemini' in the terminal to get started."
