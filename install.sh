#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_src="$repo_dir/bin/cursor-omarchy-agent-theme"
bin_dst="$HOME/.local/bin/cursor-omarchy-agent-theme"

mkdir -p "$HOME/.local/bin"
install -m 0755 "$bin_src" "$bin_dst"

echo "Installed: $bin_dst"
echo "Installing one-time Cursor CSS loader (sudo may prompt)..."
"$bin_dst" install-loader
"$bin_dst" apply
"$bin_dst" install-hook

echo
echo "Done. Fully quit/relaunch Cursor Agents to see the current theme."
echo "Future 'omarchy theme set ...' calls will regenerate ~/.config/omarchy/cursor-agent.css."
echo "If Cursor is updated, rerun ./install.sh to reinstall the loader."
