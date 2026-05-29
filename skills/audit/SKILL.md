---
name: audit
description: Audit enabled Claude Code plugins for token cost. Lists each plugin's footprint (tools/skills/hooks/MCP servers), flags candidates to disable, asks user before editing settings. Use when user says "audit plugins", "what plugins cost me tokens", or invokes /laconic audit.
---

Goal: help the user reduce per-turn token spend by disabling plugins they don't use.

## Steps

1. Read `~/.claude/settings.json` → list `enabledPlugins` (only `true` entries).
2. For each enabled plugin, read `~/.claude/plugins/installed_plugins.json` to find its `installPath`.
3. From `installPath`, read `plugin.json` for description; enumerate: skills (`skills/*/SKILL.md`), agents (`agents/*.md`), commands (`commands/*.md`), hooks (entries in `plugin.json`), MCP servers (`mcpServers` in plugin.json).
4. **Estimate token cost per plugin.** For each loaded-every-turn artifact, sum the bytes that ride in the system prompt and divide by 4 (≈ chars/token):
   - skills: each skill's frontmatter `name:` + `description:` only (body loads on invoke — exclude).
   - agents: full `description:` block in frontmatter.
   - commands: command header + `description:`.
   - hooks: typical `SessionStart` output bytes (read first line of hook script if shell, else 50 token default).
   - MCP servers: tool listings — count tools × ~30 tokens (name + short desc).
   Sum → `est_tokens` per plugin per turn. Compute total across all enabled plugins.
5. Present a table:
   - Plugin · skills · agents · commands · hooks · MCP · ~tokens · recommendation
   - Recommendation = "keep" if used recently (check shell history / recent transcripts if available) or core (laconic itself), else "disable".
   - Sort by `~tokens` descending — biggest savings first.
6. **Ask user** which to disable. Never edit settings unprompted.
7. On confirmation, edit `~/.claude/settings.json` to set `enabledPlugins.<name>` = `false`. Do not uninstall — disable is reversible.

## Rules

- Never disable laconic itself.
- Never disable plugins the user just installed (<24h).
- Never touch `extraKnownMarketplaces` or `installed_plugins.json`.
- Report findings laconic-style: one line per plugin, no preamble.

## Output format

```
plugin              skills agents cmds hooks mcp  ~tokens  rec
caveman             3      0      1    1     0    420      disable (overlaps laconic)
figma               0      0      0    0     1    340      disable (web MCP covers)
gitkraken-hooks     0      0      0    2     0    120      disable (no recent git ops)
laconic             2      0      0    1     0    180      keep

total ~tokens/turn: 1060 → disable 3 → save ~880/turn
```

Then: "Disable [caveman, figma, gitkraken-hooks]? (y/n)"
