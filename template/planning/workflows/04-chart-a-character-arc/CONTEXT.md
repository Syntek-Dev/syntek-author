# CONTEXT.md — planning/workflows/04-chart-a-character-arc/

The procedure for planning how one character changes across the story: the arc's type, the lie
they believe and the truth they reach, refuse or hold, the turn where the lie can no longer
stand, and each shift mapped to the chapter and section that carries it and the causality beat
that forces it. It writes `planning/src/arcs/<slug>.md` beside the character's entry in
`world/src/characters/`.

## Directory Tree

```text
planning/workflows/04-chart-a-character-arc/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- When a character who will change is created (`world/workflows/01-create-a-character/` hands
  on to this procedure), and before the chapter carrying their first shift is drafted.
- When a character's change no longer convinces: an editor or a review says the turn comes from
  nowhere, or too late.
- When the outline moves a chapter that carries one of the character's beats.

Reach for a **different** procedure when: the character does not yet have an entry
(`world/workflows/01-create-a-character/` first); the problem is a single beat's cause
(`03-chart-the-causality`); or the problem is how the character sounds (`character-voice`, at
the content layer's review workflow).

## What it produces, and where

- `planning/src/arcs/<slug>.md` — the arc, named for the character's entry.
- The character entry's `arc:` frontmatter, pointing at the arc.
- New causality beats, where a shift has no cause yet, charted through
  `03-chart-the-causality`.

## The failure this procedure exists to prevent

A change the reader does not believe. The character is one person in chapter 3 and another in
chapter 19, and nothing on the page in between made them so. Mapping every shift to a section
and a cause shows the gap while it can still be filled with a scene rather than an explanation.

## Cross-references

- `planning/docs/reference/character-arcs.md` — arc types and the arc's shape.
- `world/src/characters/` — who the character is: want, need, wound and voice.
- `standards/method/FICTION.md` — want against need, and the story engine.
