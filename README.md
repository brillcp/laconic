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

### Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/brillcp/laconic/main/uninstall.sh | bash
```

Removes the marketplace + disables the plugin in `~/.claude/settings.json`. Backup written as `settings.json.laconic.bak`.

## Use

- `/laconic <prompt>` — reinforce mode mid-session
- `/laconic:stats` — estimate tokens saved this session
- `/laconic:audit` — list enabled plugins, flag unused ones, prompt before disabling
- `/laconic:benchmark` — run the benchmark from anywhere and print the full results table in the CLI (pass `RUNS=N` for more samples)

## Statusline indicator

Optional. Add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/plugins/cache/laconic/laconic/<sha>/statusline/statusline.sh"
}
```

Shows `🪙 LACONIC · ~N tokens saved` live in the status bar — counter reads the session transcript and applies a `1.74` expansion factor (measured on earlier Opus runs) to estimate savings vs normal mode. The factor varies by model (Haiku is already concise, so its real factor is closer to 1.3); re-run the benchmark with higher `RUNS` to update.

## Further token-saving tips

Laconic trims output tokens. To trim more:

- **Match the model to the task.** Opus output costs ~15× Haiku per token, so each saved token saves more dollars on Opus — laconic + Opus = the biggest absolute savings if you need Opus's reasoning. For trivial work (renames, doc tweaks), `/model haiku` is plenty. Set the default in `~/.claude/settings.json` (`"model": "claude-opus-4-7"`, etc.) and switch mid-session with `/model`.
- **Audit plugins** with `/laconic:audit` — every enabled plugin loads tool/skill metadata each turn.
- **Trim** verbose `CLAUDE.md` files, skill `description:` fields, and hook output — they ride every request.
- **Read narrowly** *(built-in)*: laconic's rule already steers Claude to `Grep -n pattern file` first, then `Read offset:N limit:M` around the match — instead of reading whole files. Sub-agents recommended for noisy searches so their context stays isolated.
- **Push back, don't comply blindly** *(built-in)*: the rule weighs performance and best practices and pushes back on bad designs tersely, so brevity doesn't trade away architectural judgment.

## Update

```sh
/plugin update laconic
```

## Benchmarks

Output tokens for 10 language-agnostic prompts. Claude Code, Haiku 4.5, `RUNS=1` (single run — re-run with higher `RUNS` for median).

| #  | Prompt                        | Off  | On   | Saved |
| -- | ----------------------------- | ---- | ---- | ----- |
| 1  | Mutex vs semaphore            | 973  | 691  | 28%   |
| 2  | TCP vs UDP                    | 1141 | 399  | 65%   |
| 3  | Binary search time complexity | 864  | 661  | 23%   |
| 4  | JWT authentication end to end | 1387 | 715  | 48%   |
| 5  | REST vs GraphQL tradeoffs     | 784  | 775  | 1%    |
| 6  | CAP theorem                   | 489  | 575  | -17%  |
| 7  | Processes vs threads          | 317  | 1204 | -279% |
| 8  | HTTPS handshake               | 392  | 1099 | -180% |
| 9  | Big O / Theta / Omega         | 1525 | 556  | 63%   |
| 10 | Dependency injection          | 1843 | 759  | 58%   |
|    | **Total**                     | 9715 | 7434 | **23%** |

Note: previous totals were single-run and showed variance (e.g. prompt 6 spiked to -29%). The benchmark now:
- runs each prompt `RUNS` times per mode (default 3) and reports the **median**, which damps single-run noise.
- isolates the rule's effect with `LACONIC_BENCH=1` (skips the `SessionStart` hook for the **Off** runs) and `--append-system-prompt` for the **On** runs — apples-to-apples, no live-settings mutation.

Expected savings depend on the model: Opus is more verbose by default, so it has more to trim (~40%); Haiku is already concise (~20-25%). Re-run with your model to refresh `results.md`.

### Reproduce

```sh
git clone https://github.com/brillcp/laconic && cd laconic
brew install jq            # macOS — apt/dnf elsewhere
RUNS=5 ./benchmark/run.sh  # 5 samples per prompt per mode → median
```

Edit `benchmark/prompts.txt` to swap in your own prompts. Output → `benchmark/results.md`. Default `RUNS=3` if unset.
