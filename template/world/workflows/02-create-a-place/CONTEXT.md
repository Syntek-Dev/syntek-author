# CONTEXT.md — world/workflows/02-create-a-place/

The procedure for adding a place to the story bible: its job in the story, where it sits and
how far it is from everywhere else the story goes, what it looks, sounds and smells like, its
history, who holds it, and its name. It ends with a place file and a registered name.

## Directory Tree

```text
world/workflows/02-create-a-place/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- A scene will be set somewhere that has no place file.
- The story travels between places and the journey matters to the timing.
- A place mentioned in passing has become a setting.

Reach for a **different** procedure when the place only needs a name that a character
mentions (`world/workflows/03-name-something/`), or when the question is a real-world fact
about a real place (`research/workflows/02-verify-a-claim/`).

## What it produces, and where

- **A place file** at `world/src/places/<slug>.md`, with frontmatter and the six sections:
  What it is, Geography and distances, Senses, History, Who holds it and its rules, Continuity
  facts.
- **A register row** in `world/src/names-register.md` (kind `place`).
- **Travel times** between this place and every place the story moves to or from it, stated in
  the units the story uses.
- **Open questions**, handed back as `AUTHOR TO CONFIRM` flags in the place file.

## The failure this procedure exists to prevent

The journey that takes two days in Chapter 4 and an afternoon in Chapter 11. Distances are the
continuity facts readers notice most and writers check least, because they are rarely stated
outright; they hide in how many meals a character eats on the road. Fixing them in the place
file, and checking them against the timeline, closes the commonest gap in a story bible.

## Cross-references

- `world/docs/reference/story-bible.md` — what belongs in a place file.
- `world/docs/reference/naming.md` — place names, usually older and more worn than people's.
- `research/docs/reference/real-world-detail.md` — when the place is drawn from a real one.
- `planning/src/timeline.md` — the dates the travel times must fit.
