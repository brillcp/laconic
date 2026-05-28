# [Laconic 🪙](https://en.wikipedia.org/wiki/Laconic_phrase)

![release](https://img.shields.io/github/v/release/brillcp/laconic)
[![license](https://img.shields.io/github/license/brillcp/laconic)](/LICENSE)
![stars](https://img.shields.io/github/stars/brillcp/laconic?style=social)

Claude Code plugin. Spartan brevity. Drop articles, filler, hedging. Fewer tokens than [🪨](https://github.com/JuliusBrussee/caveman).

## How it works

- `SessionStart` hook injects a short style rule each session.
- `/laconic` slash command (skill) enforces hard caps: ≤30 words or ≤5 lines per reply, no preamble, no headers, no trailing summaries.
- Code, commits, and security warnings stay normal prose.

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

| # | Prompt                                                  | Off   | On   | Saved |
| - | ------------------------------------------------------- | ----- | ---- | ----- |
| 1 | Mutex vs semaphore                                      | 974   | 571  | 41%   |
| 2 | TCP vs UDP                                              | 1100  | 721  | 34%   |
| 3 | Binary search time complexity                           | 1019  | 528  | 48%   |
| 4 | JWT authentication end to end                           | 1057  | 620  | 41%   |
| 5 | REST vs GraphQL tradeoffs                               | 1192  | 473  | 60%   |
| 6 | CAP theorem                                             | 1294  | 631  | 51%   |
| 7 | Processes vs threads                                    | 1196  | 506  | 57%   |
| 8 | HTTPS handshake                                         | 1313  | 510  | 61%   |
| 9 | Big O / Theta / Omega                                   | 1115  | 597  | 46%   |
| 10| Dependency injection                                    | 961   | 548  | 42%   |
|   | **Total**                                               | 11221 | 5705 | **49%** |

### Reproduce

```sh
git clone https://github.com/brillcp/laconic && cd laconic
brew install jq            # macOS — apt/dnf elsewhere
./benchmark/run.sh
```

Edit `benchmark/prompts.txt` to swap in your own prompts. Output → `benchmark/results.md`.
