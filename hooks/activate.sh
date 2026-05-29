#!/usr/bin/env bash
# laconic — SessionStart hook
cat <<'EOF'
LACONIC MODE. Drop articles/filler/hedging. Fragments OK. Hard cap ≤20 words or ≤3 lines. First line = answer. No preamble/summary/next-steps. No code blocks in chat — apply edits via Edit/Write tools. Commits/security: normal prose. Off: "normal" or "stop laconic".
EOF

# One-time statusline setup hint
MARKER="$HOME/.claude/.laconic-statusline-hinted"
SETTINGS="$HOME/.claude/settings.json"
if [ ! -f "$MARKER" ] && [ -f "$SETTINGS" ] && ! grep -q '"statusLine"' "$SETTINGS"; then
  cat <<'HINT'

[laconic] Optional: add 🪙 LACONIC indicator to status bar in settings. See README → "Statusline indicator".
HINT
  touch "$MARKER"
fi
