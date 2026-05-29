#!/usr/bin/env bash
# laconic — Claude Code one-line installer.
# Adds the laconic marketplace + enables the plugin in ~/.claude/settings.json.
# After install, SessionStart hook auto-activates laconic for every new session.

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
REPO="brillcp/laconic"

say() { printf '[laconic] %s\n' "$*"; }

if [ ! -d "$HOME/.claude" ]; then
  say "~/.claude not found — install Claude Code first: https://claude.com/code"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  say "python3 required for safe JSON edit. Aborting."
  exit 1
fi

mkdir -p "$HOME/.claude"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "$SETTINGS.laconic.bak"

python3 - "$SETTINGS" "$REPO" <<'PY'
import json, sys
path, repo = sys.argv[1], sys.argv[2]
with open(path) as f:
    cfg = json.load(f)
cfg.setdefault("extraKnownMarketplaces", {})["laconic"] = {
    "source": {"source": "github", "repo": repo}
}
cfg.setdefault("enabledPlugins", {})["laconic@laconic"] = True
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
PY

say "Installed. Restart Claude Code — laconic auto-activates every session."
say "Backup: $SETTINGS.laconic.bak"
