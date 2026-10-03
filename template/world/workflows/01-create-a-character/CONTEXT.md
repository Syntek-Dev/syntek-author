# CONTEXT.md — world/workflows/01-create-a-character/

The procedure for bringing a significant character into the story bible: their job in the
story, their want and need, the wound and the lie behind them, their name, their voice, and
the people they are bound to. It ends with a character file, a registered name and an arc file
ready for planning.

## Directory Tree

```text
world/workflows/01-create-a-character/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- A character will speak, act on the plot, or carry a point of view, and has no file yet.
- A minor character has grown: they now have scenes of their own and a reason to change.
- The author has a character in mind and wants them pinned down before drafting a scene.

Reach for a **different** procedure when the character only needs a name
(`world/workflows/03-name-something/`), or when the character exists and what is needed is
their change across the book, beat by beat (`planning/workflows/04-chart-a-character-arc/`).

## What it produces, and where

- **A character file** at `world/src/characters/<slug>.md`, with frontmatter and the six
  sections: Want, Need, Wound and the lie, Voice markers, Relationships, Continuity facts.
- **A register row** in `world/src/names-register.md` (kind `character`), with IPA and a
  reader respelling.
- **An arc file** at `planning/src/arcs/<slug>.md`, opened with the arc type, the want, the
  need and the lie; its beats are mapped later in planning.
- **Open questions**, handed back as `AUTHOR TO CONFIRM` flags in the character file.

## The failure this procedure exists to prevent

A character invented in the middle of a scene. Prose drafted around an undecided character
fixes details by accident (an age, a scar, a sister) that the author never chose, and the next
chapter contradicts them. Deciding first, in one file, means every scene draws on the same
person, and `character-voice` has markers to check the dialogue against.

## Cross-references

- `world/docs/reference/story-bible.md` — what belongs in a character file.
- `world/docs/reference/naming.md` — choosing and registering the name.
- `planning/docs/reference/character-arcs.md` — want, need, the lie and the arc types.
- `world/src/characters/` — where the file lands, and its skeleton.
