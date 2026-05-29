#!/usr/bin/env bash
# laconic — universal installer
# Detects AI coding agents on this machine and installs laconic rules.
# Safe to re-run. Skips missing agents.

set -euo pipefail

LACONIC_RULE='LACONIC MODE. Drop articles/filler/hedging. Fragments OK. Hard cap ≤20 words or ≤3 lines. First line = answer. No preamble/summary/next-steps. No code blocks in chat — apply edits via Edit/Write tools. Commits/security: normal prose. Off: "normal" or "stop laconic".'

MARK_START='# >>> laconic >>>'
MARK_END='# <<< laconic <<<'

INSTALLED=()
SKIPPED=()

say() { printf '[laconic] %s\n' "$*"; }

has_marker() { grep -qF "$MARK_START" "$1" 2>/dev/null; }

inject_block() {
  local file="$1" comment="${2:-#}"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if has_marker "$file"; then return 0; fi
  cp "$file" "$file.laconic.bak" 2>/dev/null || true
  {
    printf '\n%s\n' "$MARK_START"
    printf '%s %s\n' "$comment" "$LACONIC_RULE"
    printf '%s\n' "$MARK_END"
  } >> "$file"
}

# 1. Claude Code — plugin install via marketplace
install_claude_code() {
  if ! command -v claude >/dev/null 2>&1; then
    SKIPPED+=("claude-code (CLI not found)"); return
  fi
  if [ -d "$HOME/.claude/plugins/cache/laconic" ]; then
    INSTALLED+=("claude-code (already installed)")
  else
    say "Install via Claude Code: /plugin marketplace add brillcp/laconic && /plugin install laconic@laconic"
    INSTALLED+=("claude-code (manual step printed)")
  fi
}

# 2. Cursor — global rule file
install_cursor() {
  if [ ! -d "$HOME/.cursor" ] && [ ! -d "$HOME/Library/Application Support/Cursor" ]; then
    SKIPPED+=("cursor (not found)"); return
  fi
  local f="$HOME/.cursor/rules/laconic.mdc"
  mkdir -p "$(dirname "$f")"
  if [ -f "$f" ] && has_marker "$f"; then
    INSTALLED+=("cursor (already)"); return
  fi
  cat > "$f" <<EOF
---
description: Laconic mode — spartan brevity
alwaysApply: true
---
$MARK_START
$LACONIC_RULE
$MARK_END
EOF
  INSTALLED+=("cursor")
}

# 3. Windsurf — global memory file
install_windsurf() {
  local dir="$HOME/.codeium/windsurf/memories"
  if [ ! -d "$HOME/.codeium/windsurf" ]; then
    SKIPPED+=("windsurf (not found)"); return
  fi
  inject_block "$dir/global_rules.md" "<!--"
  INSTALLED+=("windsurf")
}

# 4. Codex CLI — instructions file
install_codex() {
  if [ ! -d "$HOME/.codex" ]; then
    SKIPPED+=("codex (not found)"); return
  fi
  inject_block "$HOME/.codex/instructions.md" "<!--"
  INSTALLED+=("codex")
}

# 5. Aider — global config
install_aider() {
  if ! command -v aider >/dev/null 2>&1 && [ ! -f "$HOME/.aider.conf.yml" ]; then
    SKIPPED+=("aider (not found)"); return
  fi
  local f="$HOME/.aider.conf.yml"
  if [ -f "$f" ] && has_marker "$f"; then
    INSTALLED+=("aider (already)"); return
  fi
  touch "$f"
  cp "$f" "$f.laconic.bak" 2>/dev/null || true
  {
    printf '\n%s\n' "$MARK_START"
    printf '# laconic rule appended to chat history\n'
    printf 'chat-history-file: ~/.aider.chat.history.md\n'
    printf '%s\n' "$MARK_END"
  } >> "$f"
  INSTALLED+=("aider")
}

# 6. Continue (VS Code) — manual hint, JSON edits risky
install_continue() {
  if [ ! -d "$HOME/.continue" ]; then
    SKIPPED+=("continue (not found)"); return
  fi
  say "Continue detected. Add to ~/.continue/config.json systemMessage manually: $LACONIC_RULE"
  INSTALLED+=("continue (manual step printed)")
}

# 7. Generic AGENTS.md global
install_agents_md() {
  inject_block "$HOME/AGENTS.md" "<!--"
  INSTALLED+=("AGENTS.md (global)")
}

main() {
  say "Detecting agents..."
  install_claude_code
  install_cursor
  install_windsurf
  install_codex
  install_aider
  install_continue
  install_agents_md

  echo
  say "Installed:"
  for x in "${INSTALLED[@]:-}"; do [ -n "$x" ] && printf '  ✓ %s\n' "$x"; done
  if [ "${#SKIPPED[@]}" -gt 0 ]; then
    say "Skipped:"
    for x in "${SKIPPED[@]}"; do printf '  · %s\n' "$x"; done
  fi
  echo
  say "Done. Re-run anytime — idempotent."
}

main "$@"
