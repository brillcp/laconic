# Laconic 🪙

Claude Code plugin. Spartan brevity. Drop articles, filler, hedging. Even fewer tokens than [caveman](https://github.com/JuliusBrussee/caveman).

## How it works

- `SessionStart` hook injects a short style rule each session.
- `/laconic` slash command (skill) enforces hard caps: ≤30 words or ≤5 lines per reply, no preamble, no headers, no trailing summaries.
- Code, commits, and security warnings stay normal prose.
- Toggle off: say "normal" or "stop laconic".

## Install

```sh
/plugin marketplace add <your-username>/laconic
/plugin install laconic@laconic
```

Then `/reload-plugins` (or restart Claude Code).

## Use

- `/laconic <prompt>` — one-shot terse reply
- Or say "laconic", "terse", "brief" — skill auto-activates
- `/laconic:audit` — list enabled plugins, flag unused ones, prompt before disabling to cut more tokens

## Update

```sh
/plugin update laconic
```
