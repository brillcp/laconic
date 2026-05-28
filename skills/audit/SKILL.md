---
name: audit
description: Audit enabled Claude Code plugins for token cost. Lists each plugin's footprint (tools/skills/hooks/MCP servers), flags candidates to disable, asks user before editing settings. Use when user says "audit plugins", "what plugins cost me tokens", or invokes /laconic audit.
---

Goal: help the user reduce per-turn token spend by disabling plugins they don't use.

## Steps

1. Read `~/.claude/settings.json` → list `enabledPlugins` (only `true` entries).
2. For each enabled plugin, read `~/.claude/plugins/installed_plugins.json` to find its `installPath`.
3. From `installPath`, read `plugin.json` for description; count: skills (`skills/*/SKILL.md`), agents (`agents/*.md`), commands (`commands/*.md`), hooks (entries in `plugin.json`), MCP servers (`mcpServers` in plugin.json).
4. Estimate token cost: sum of skill descriptions + agent frontmatter + command headers + MCP instructions. Rough heuristic — report counts, not exact tokens.
5. Present a table:
   - Plugin · skills · agents · commands · hooks · MCP · recommendation
   - Recommendation = "keep" if used recently (check shell history / recent transcripts if available) or core (laconic itself), else "disable".
6. **Ask user** which to disable. Never edit settings unprompted.
7. On confirmation, edit `~/.claude/settings.json` to set `enabledPlugins.<name>` = `false`. Do not uninstall — disable is reversible.

## Rules

- Never disable laconic itself.
- Never disable plugins the user just installed (<24h).
- Never touch `extraKnownMarketplaces` or `installed_plugins.json`.
- Report findings laconic-style: one line per plugin, no preamble.

## Output format

```
plugin              skills agents cmds hooks mcp  rec
caveman             3      0      1    1     0    disable (overlaps laconic)
gitkraken-hooks     0      0      0    2     0    disable (no recent git ops)
figma               0      0      0    0     1    disable (web MCP covers)
laconic             2      0      0    1     0    keep
```

Then: "Disable [caveman, gitkraken-hooks, figma]? (y/n)"
