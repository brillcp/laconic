#!/usr/bin/env bash
# laconic — Claude Code uninstaller.
# Removes the laconic marketplace and disables the plugin in ~/.claude/settings.json.

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"

say() { printf '[laconic] %s\n' "$*"; }

if [ ! -f "$SETTINGS" ]; then
  say "$SETTINGS not found — nothing to remove."
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
  say "python3 required. Aborting."
  exit 1
fi

cp "$SETTINGS" "$SETTINGS.laconic.bak"

python3 - "$SETTINGS" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as f:
    cfg = json.load(f)
cfg.get("extraKnownMarketplaces", {}).pop("laconic", None)
cfg.get("enabledPlugins", {}).pop("laconic@laconic", None)
for k in ("extraKnownMarketplaces", "enabledPlugins"):
    if k in cfg and not cfg[k]:
        del cfg[k]
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
PY

rm -f "$HOME/.claude/.laconic-statusline-hinted"

say "Uninstalled. Restart Claude Code. Backup: $SETTINGS.laconic.bak"
say "Note: cached plugin files may remain in ~/.claude/plugins/cache/laconic — safe to delete."
