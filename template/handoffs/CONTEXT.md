# CONTEXT.md — handoffs/

Session bridges. Each file carries the live thread of one session (where the work stands, what is
half-done, and the next move) so that a fresh session can resume cleanly after `/clear`. This is
the project's alternative to letting a session compact
(`.claude/rules/syntek-author/07-session-boundaries.md`). It is a transient bridge, not a memory
store, and nothing in it is the work.

## Directory Tree

```text
handoffs/
├── CONTEXT.md                            ← this file
├── CLAUDE.md                             ← operating rules
└── HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md    ← one per handed-over session; pruned once resumed
```

## What's here

- `HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` — written by the `handoff` skill. The descriptor names
  **the work, not the session**: `HANDOFF-OPENING-SECTIONS-03-10-2026.md`, never
  `HANDOFF-TUESDAY-03-10-2026.md`.
- Each handoff carries the goal, what landed, what is in flight (with `path:line` anchors), the
  part the skill's mode file says this kind of project must never drop, the next move, the skills
  to load, and every artefact by path.
- The folder is empty apart from this pair until the first handoff, and it returns to empty as
  handoffs are pruned.

**Durable knowledge is not kept here.** It is recorded in its real home before the handoff is
written: decisions and facts in `.claude/MEMORY.md`, a unit's decisions in its brief in
`planning/src/units/`, a folder rule in that folder's `CLAUDE.md`. Work that spans many sessions
by design belongs in a decision map in `planning/src/maps/`.

## Cross-references

- `.claude/skills/handoff/SKILL.md` — the skill that writes these files, and their format.
- `.claude/rules/syntek-author/07-session-boundaries.md` — why the project hands off instead of
  compacting.
- `.claude/hooks/pre-compact-handoff.sh` — the hook that blocks compaction and points here.
- `.claude/MEMORY.md` — the durable memory a handoff deliberately does not duplicate.
