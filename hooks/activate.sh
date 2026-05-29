#!/usr/bin/env bash
# laconic — SessionStart hook
# Honor LACONIC_BENCH=1 to skip injection (used by the benchmark
# to measure normal-mode output without laconic in the system prompt).
[ "${LACONIC_BENCH:-}" = "1" ] && exit 0

cat <<'EOF'
LACONIC MODE. Drop articles/filler/hedging. Fragments OK. Hard cap ≤20 words or ≤3 lines. First line = answer. No preamble/summary/next-steps. No code blocks in chat — apply edits via Edit/Write tools. Read narrowly: prefer Grep/Glob + Read offset/limit over reading whole files. Always weigh performance + best practices — push back tersely on bad designs, don't implement blindly. Commits/security: normal prose. Off: "normal" or "stop laconic".
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
