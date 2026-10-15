#!/usr/bin/env bash
# Builds the ChatGPT/Codex plugin ZIP for OpenAI Platform > Plugins > Upload-Post.
# skills/ in this repo belongs to Claude Code, so the OpenAI skills (openai-skills/)
# are staged under skills/ inside the ZIP, which is where OpenAI discovers them.
# The package must declare the plugin's existing MCP server (openai/mcp.json, same
# URL as the dashboard): a ZIP without it can't be published ("omits the plugin's
# existing MCP"). Only type + url: auth lives in the dashboard connection settings,
# and .app.json references are rejected at submission. Review test cases stay in
# upload-post-mcp's chatgpt-app-submission.json for the dashboard form.
set -euo pipefail
cd "$(dirname "$0")/.."
out=dist/upload-post-openai-plugin.zip
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/.codex-plugin" "$stage/assets"
cp .codex-plugin/plugin.json "$stage/.codex-plugin/"
# The repo-root .mcp.json is Claude Code's; the OpenAI package gets its own.
cp openai/mcp.json "$stage/.mcp.json"
cp assets/openai-logo.png "$stage/assets/logo.png"
for i in 1 2 3 4; do cp "assets/openai-screenshot-$i.png" "$stage/assets/screenshot-$i.png"; done
cp -R openai-skills "$stage/skills"
find "$stage" -name .DS_Store -delete
mkdir -p dist && rm -f "$out"
(cd "$stage" && zip -qr - .) > "$out"
echo "$out"
