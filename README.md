# [Laconic 🪙](https://en.wikipedia.org/wiki/Laconic_phrase)

![release](https://img.shields.io/github/v/release/brillcp/laconic)
[![license](https://img.shields.io/github/license/brillcp/laconic)](/LICENSE)
![stars](https://img.shields.io/github/stars/brillcp/laconic?style=social)

Claude Code plugin. Spartan brevity. Drop articles, filler, hedging. Inspired by [🪨 caveman](https://github.com/JuliusBrussee/caveman) — same goal, measured savings (see [Benchmarks](#benchmarks)).

## How it works

- `/laconic` slash command (skill) enforces hard caps: ≤20 words or ≤3 lines per reply, no preamble, no headers, no trailing summaries.
- Only active when invoked — no per-session token cost.

## Install

```sh
/plugin marketplace add brillcp/laconic
/plugin install laconic@laconic
```

Then `/reload-plugins` (or restart Claude Code).

## Use

- `/laconic <prompt>` — one-shot terse reply
- `/laconic:audit` — list enabled plugins, flag unused ones, prompt before disabling to cut more tokens

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
