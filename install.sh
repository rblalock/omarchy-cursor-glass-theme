#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_src="$repo_dir/bin/cursor-omarchy-agent-theme"
bin_dst="$HOME/.local/bin/cursor-omarchy-agent-theme"

mkdir -p "$HOME/.local/bin"
install -m 0755 "$bin_src" "$bin_dst"

echo "Installed: $bin_dst"
echo "Granting write access to Cursor's CSS bundle so Omarchy theme hooks can update it (sudo may prompt)..."
"$bin_dst" grant-write-access
"$bin_dst" apply
"$bin_dst" install-hook

echo
echo "Done. Fully quit/relaunch Cursor Agents to see the current theme."
echo "Future 'omarchy theme set ...' calls will direct-patch Cursor Agents CSS from the selected theme."
echo "If Cursor is updated, rerun ./install.sh."
