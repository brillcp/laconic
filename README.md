# [Laconic 🪙](https://en.wikipedia.org/wiki/Laconic_phrase)


*from Laconia (Sparta). Spartan speech style: maximum meaning, minimum words.*

![release](https://img.shields.io/github/v/release/brillcp/laconic)
[![license](https://img.shields.io/github/license/brillcp/laconic)](/LICENSE)
![stars](https://img.shields.io/github/stars/brillcp/laconic?style=social)

Claude Code plugin. Spartan brevity. Inspired by [🪨 caveman](https://github.com/JuliusBrussee/caveman) — same goal, measured savings (see [Benchmarks](#benchmarks)).

## How it works

- `SessionStart` hook (bash) injects the rule once per session — laconic mode auto-active.
- `/laconic` skill reinforces caps if needed: ≤20 words or ≤3 lines, no preamble, no headers, no trailing summaries.
- Exit with `stop laconic` or `normal`.

## Install

### One-liner

```sh
curl -fsSL https://raw.githubusercontent.com/brillcp/laconic/main/install.sh | bash
```

Adds the marketplace and enables the plugin in `~/.claude/settings.json`. Restart Claude Code — laconic auto-activates every session via the `SessionStart` hook. No `/laconic` needed.

### Manual

```sh
/plugin marketplace add brillcp/laconic
/plugin install laconic@laconic
```

Then `/reload-plugins` (or restart Claude Code).

## Use

- `/laconic <prompt>` — reinforce mode mid-session
- `/laconic:stats` — estimate tokens saved this session
- `/laconic:audit` — list enabled plugins, flag unused ones, prompt before disabling

## Statusline indicator

Optional. Add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/plugins/cache/laconic/laconic/<sha>/statusline/statusline.sh"
}
```

Shows `🪙 LACONIC · ~N tokens saved` live in the status bar — counter reads the session transcript and applies the measured `1.74` expansion factor to estimate savings vs normal mode.

## Further token-saving tips

Laconic trims output tokens. To trim more:

- **Default to Haiku** for routine tasks (~5× cheaper than Opus). Set `"model": "claude-haiku-4-5-20251001"` in `~/.claude/settings.json`. Switch mid-session with `/model opus`.
- **Audit plugins** with `/laconic:audit` — every enabled plugin loads tool/skill metadata each turn.
- **Trim** verbose `CLAUDE.md` files, skill `description:` fields, and hook output — they ride every request.
- **Read narrowly**: `Grep -n pattern file` or `Read offset:100 limit:50` over reading whole files. Use sub-agents for noisy searches so their context stays isolated.

## Update

```sh
/plugin update laconic
```

## Benchmarks

Measured output tokens for 10 language-agnostic prompts. Claude Code, Opus 4.7.

| #  | Prompt                        | Off   | On   | Saved |
| -- | ----------------------------- | ----- | ---- | ----- |
| 1  | Mutex vs semaphore            | 773   | 488  | 36%   |
| 2  | TCP vs UDP                    | 1510  | 538  | 64%   |
| 3  | Binary search time complexity | 1382  | 427  | 69%   |
| 4  | JWT authentication end to end | 957   | 549  | 42%   |
| 5  | REST vs GraphQL tradeoffs     | 1039  | 540  | 48%   |
| 6  | CAP theorem                   | 851   | 1103 | -29%  |
| 7  | Processes vs threads          | 1015  | 542  | 46%   |
| 8  | HTTPS handshake               | 937   | 557  | 40%   |
| 9  | Big O / Theta / Omega         | 823   | 564  | 31%   |
| 10 | Dependency injection          | 885   | 527  | 40%   |
|    | **Total**                     | 10172 | 5835 | **42%** |

Note: single-run results have variance (see prompt 6). Multi-run median would be more stable.

### Reproduce

```sh
git clone https://github.com/brillcp/laconic && cd laconic
brew install jq            # macOS — apt/dnf elsewhere
./benchmark/run.sh
```

Edit `benchmark/prompts.txt` to swap in your own prompts. Output → `benchmark/results.md`.
