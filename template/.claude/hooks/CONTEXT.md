# CONTEXT.md — .claude/hooks/

Shell hooks that Claude Code runs at fixed moments in a session, registered in
`.claude/settings.json`. The template ships one: `pre-compact-handoff.sh`, which turns the rule
"hand off, never compact" (`.claude/rules/syntek-author/07-session-boundaries.md`) from advice
into a guard. Judgement never lives here: a hook can measure, block and remind, but only a skill
can do the work.

## Directory Tree

```text
.claude/hooks/
├── CONTEXT.md                 ← this file
├── CLAUDE.md                  ← operating rules for hooks
└── pre-compact-handoff.sh     ← PreCompact: blocks auto-compaction, warns on /compact (template-owned)
```

## What's here

| Hook | Matcher | Script | Effect |
|---|---|---|---|
| `PreCompact` | `auto` | `pre-compact-handoff.sh auto` | Blocks compaction (exit 2) and steers the session to the `handoff` skill |
| `PreCompact` | `manual` | `pre-compact-handoff.sh manual` | Warns (exit 0); a deliberate `/compact` is not overridden |

It works as a pair with `"autoCompactEnabled": false` in `.claude/settings.json`: the setting
stops compaction starting on its own, and the hook catches any compaction that starts anyway.

**Exit codes.** `exit 0` lets the action go ahead, and anything on stderr is shown as a warning.
`exit 2` blocks the action, and stderr becomes the message. Any other exit is a non-blocking
error.

**Ownership.** This pair is the project's (seeded once, never updated). `pre-compact-handoff.sh`
is template-owned and updated by `copier update`. A hook added for this project gets its own
script here and its own entry in `.claude/settings.json`, which is also the project's.

**Conventions.** Every script is `bash` with `set -uo pipefail`, executable, and opens with a
header naming its `settings.json` entry, its matchers and its exit codes. Settings resolve each
script from the git root (`git rev-parse --show-toplevel`) and guard it with `[ -f … ]`, so a
missing script is a no-op rather than an error.

## Cross-references

- `.claude/rules/syntek-author/07-session-boundaries.md` — the rule the hook enforces, and why.
- `.claude/skills/handoff/SKILL.md` — the procedure the hook steers to.
- `.claude/settings.json` — where the hook is registered, beside `autoCompactEnabled`.
- `handoffs/` — where handoffs land.
