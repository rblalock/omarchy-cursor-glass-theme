# Cursor Omarchy Agent Theme

## Why

Cursor Agents uses Cursor's newer **Glass** UI. It does **not** meaningfully follow normal VS Code/Cursor editor themes, so changing `workbench.colorTheme` or installing VS Code themes does not theme the Agent app.

Omarchy already has great system-wide themes. This tool makes the **Cursor Agents app** match the active Omarchy theme by generating CSS from the Omarchy palette and loading it into Cursor's Glass UI.

This is intentionally focused on **Cursor Agents only**. It does not try to theme the Cursor editor.

## Status / warning

This direct-patches Cursor's installed CSS bundle:

```text
/usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.css
```

During install, the script grants your user write access to that CSS file with `setfacl` so Omarchy theme hooks can update the patch without prompting for sudo each time.

Cursor may show a warning in the editor app saying the installation appears corrupt while the loader is installed. Restore the original Cursor CSS with:

```bash
cursor-omarchy-agent-theme restore
```

Cursor updates may overwrite the loader. Re-run `./install.sh` after Cursor updates.

## Install

```bash
git clone https://github.com/YOUR_USER/cursor-omarchy-theme.git
cd cursor-omarchy-theme
./install.sh
```

The installer:

1. Installs `~/.local/bin/cursor-omarchy-agent-theme`
2. Grants your user write access to Cursor's CSS bundle, using sudo
3. Direct-patches Cursor Agents Glass CSS from the current Omarchy theme
4. Hooks into `~/.config/omarchy/hooks/theme-set`

After install, fully quit and relaunch Cursor Agents.

## Usage

Apply the current Omarchy theme:

```bash
cursor-omarchy-agent-theme apply
```

Apply a specific Omarchy theme:

```bash
cursor-omarchy-agent-theme apply Kanagawa
cursor-omarchy-agent-theme apply "Rose Pine Dark"
```

Check status:

```bash
cursor-omarchy-agent-theme status
```

Restore Cursor's original CSS:

```bash
cursor-omarchy-agent-theme restore
```

After `apply`, fully quit and relaunch Cursor Agents to see changes.

## Omarchy theme hook

The installer adds this to:

```text
~/.config/omarchy/hooks/theme-set
```

```bash
if command -v cursor-omarchy-agent-theme >/dev/null 2>&1; then
  cursor-omarchy-agent-theme apply "$1" || true
fi
```

So when you run:

```bash
omarchy theme set Kanagawa
```

Cursor Agents CSS is direct-patched for that theme. Relaunch Cursor Agents to pick it up.

## Theme support

This is not hardcoded to Kanagawa. It supports any Omarchy theme that exists under:

```text
~/.config/omarchy/themes/<theme>
~/.local/share/omarchy/themes/<theme>
```

It prefers VS Code theme information when available:

1. `vscode.json` with inline `colors`
2. An installed VS Code/Cursor extension referenced by `vscode.json` (`extension` + `name`)
3. `colors.toml`
4. Fallback colors found in `waybar.css` and `hyprland.conf`

On a typical Omarchy system, many themes include a `vscode.json`, but most of those files reference an external theme extension rather than embedding colors directly. If that extension is installed in `~/.cursor/extensions` or `~/.vscode/extensions`, this tool will read its theme JSON and use those colors first. Otherwise it falls back to Omarchy's own palette files.

Best fallback results come from themes with a `colors.toml` containing keys like:

```toml
background = "#1f1f28"
foreground = "#dcd7ba"
accent = "#7e9cd8"
selection_background = "#2d4f67"
selection_foreground = "#c8c093"
color0 = "#090618"
color1 = "#c34043"
# ... color2 through color15
```

## How it works

The generated CSS targets Cursor's Glass UI selectors:

```css
body[data-cursor-glass-mode="true"]
body[data-cursor-glass-mode="true"] [data-component="agent-panel"]
body[data-cursor-glass-mode="true"] .composer-messages-container
body[data-cursor-glass-mode="true"] .ui-prompt-input__container
body[data-cursor-glass-mode="true"] .composer-human-message.standalone-glass
```

The patch is inserted between clear markers in Cursor's CSS bundle and replaced on each theme change.

## For your agent

Copy/paste this to a coding agent on an Omarchy machine:

```text
Install a Cursor Agents Omarchy theme patcher. Create ~/.local/bin/cursor-omarchy-agent-theme as an executable Python 3 script with commands apply [theme], install-loader, install-hook, status, and restore. It should read the current Omarchy theme via `omarchy theme current`, locate the theme under ~/.config/omarchy/themes or ~/.local/share/omarchy/themes, read colors.toml with fallbacks from waybar.css and hyprland.conf, then direct-patch /usr/share/cursor/resources/app/out/vs/workbench/workbench.desktop.main.css between clear markers with CSS targeting only Cursor Agents / Glass UI selectors like body[data-cursor-glass-mode="true"], [data-component="agent-panel"], .composer-messages-container, .ui-prompt-input__container, and .composer-human-message.standalone-glass. Back up the original file first and use setfacl to grant the current user write access so future theme changes do not need sudo. Add a hook to ~/.config/omarchy/hooks/theme-set that runs `cursor-omarchy-agent-theme apply "$1" || true`. Do not edit Cursor user settings or VS Code theme settings. Provide restore to restore the backup. Tell me to fully quit and relaunch Cursor Agents after applying.
```

## Uninstall

Restore Cursor's CSS:

```bash
cursor-omarchy-agent-theme restore
```

Remove the script:

```bash
rm -f ~/.local/bin/cursor-omarchy-agent-theme
```
