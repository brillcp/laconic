---
name: benchmark
description: Run the laconic benchmark and print results in the CLI. Use when the user invokes /laconic benchmark or asks to benchmark token savings.
---

Run the laconic benchmark from anywhere — locate the script in the installed plugin and execute it.

## Steps

1. **Locate** the plugin install path. Try in order:
   - `$CLAUDE_PLUGIN_ROOT` (set when this skill runs)
   - `~/.claude/plugins/cache/laconic/laconic/*` (newest match)
   - The current repo if `pwd` is the laconic repo
   Fail with a clear message if `benchmark/run.sh` cannot be found.

2. **Check prerequisites**: `claude` and `jq` on `PATH`. If missing, tell the user how to install.

3. **Run** the benchmark via Bash. Honor an optional `RUNS` argument from the user (default 3). Stream stderr so the user sees per-prompt progress. The script writes `benchmark/results.md` inside the plugin path.

4. **Print results** to chat: read `benchmark/results.md` and show the full markdown table. Include the total saved % on the first line of the reply.

## Rules

- Don't truncate the results table — user wants the full picture.
- If a run errors out (no `claude` CLI, no `jq`, no prompts file), stop and report — don't fake numbers.
- Long-running. Warn upfront if `RUNS` × number of prompts × 2 modes will take more than a couple of minutes.
- Don't push or commit changes to `results.md` — that's the user's call.
