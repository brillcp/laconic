---
name: stats
description: Estimate token savings from laconic mode in the current session. Use when user invokes /laconic stats or asks "how many tokens have I saved".
---

Estimate output tokens saved by laconic this session.

## Method

1. Scan assistant responses in this session.
2. For each response, count actual output tokens (≈ chars / 4 or words / 0.75).
3. Estimate "normal mode" length: multiply each laconic response by avg expansion factor `2.4` (from `benchmark/results.md`: 10172 / 5835 ≈ 1.74; conservatively use 2.0).
4. Savings = estimated_normal - actual_laconic.

## Output

Single line:
```
Saved ~N tokens across M replies (~X%). Approx based on bench factor 2.0.
```

If no laconic responses yet: `No laconic replies this session.`

## Rules

- One line only. No table, no breakdown unless asked.
- Approximate — label as estimate.
- Skip non-laconic turns (e.g. before /laconic invoked, code blocks excluded).
