#!/usr/bin/env bash
# Builds the ChatGPT/Codex plugin ZIP for OpenAI Platform > Plugins > Upload-Post.
# skills/ in this repo belongs to Claude Code, so the OpenAI skills (openai-skills/)
# are staged under skills/ inside the ZIP, which is where OpenAI discovers them.
set -euo pipefail
cd "$(dirname "$0")/.."
out=dist/upload-post-openai-plugin.zip
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/.codex-plugin" "$stage/assets"
cp .codex-plugin/plugin.json "$stage/.codex-plugin/"
cp assets/openai-logo.png "$stage/assets/logo.png"
for i in 1 2 3 4; do cp "assets/openai-screenshot-$i.png" "$stage/assets/screenshot-$i.png"; done
cp -R openai-skills "$stage/skills"
find "$stage" -name .DS_Store -delete
mkdir -p dist && rm -f "$out"
(cd "$stage" && zip -qr - .) > "$out"
echo "$out"
