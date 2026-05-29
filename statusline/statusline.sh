#!/usr/bin/env bash
# laconic statusline — shows live token savings for current session.
# Reads stdin JSON from Claude Code (session_id, transcript_path, ...).
# Estimates tokens saved by laconic vs normal-mode baseline.

set -u

input="$(cat 2>/dev/null || true)"
transcript=""

if [ -n "$input" ] && command -v python3 >/dev/null 2>&1; then
  transcript="$(printf '%s' "$input" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("transcript_path",""))
except: pass' 2>/dev/null)"
fi

if [ -z "$transcript" ] || [ ! -f "$transcript" ]; then
  printf "🪙 LACONIC"
  exit 0
fi

# Sum assistant text chars → tokens (chars/4) → savings (×1.0 saved, factor 2.0)
saved=$(python3 - "$transcript" <<'PY' 2>/dev/null
import json, sys
path = sys.argv[1]
chars = 0
with open(path, encoding="utf-8", errors="ignore") as f:
    for line in f:
        try:
            msg = json.loads(line)
        except Exception:
            continue
        if msg.get("type") != "assistant":
            continue
        content = msg.get("message", {}).get("content", [])
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and c.get("type") == "text":
                    chars += len(c.get("text", ""))
        elif isinstance(content, str):
            chars += len(content)
tokens = chars // 4
# bench factor 1.74 → saved = tokens × 0.74
saved = int(tokens * 0.74)
print(saved)
PY
)

if [ -n "${saved:-}" ] && [ "$saved" -gt 0 ] 2>/dev/null; then
  printf "🪙 LACONIC · ~%s tokens saved" "$saved"
else
  printf "🪙 LACONIC"
fi
