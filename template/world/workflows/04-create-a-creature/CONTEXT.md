# CONTEXT.md — world/workflows/04-create-a-creature/

The procedure for adding a creature to the bestiary: its job in the story, its ecology and
body, how it behaves, the rules and limits the plot will rely on, its weaknesses and where they
are set up, and what each people believes about it and calls it. It ends with a bestiary entry
checked against the rest of the world, and registered names.

## Directory Tree

```text
world/workflows/04-create-a-creature/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- A creature will appear on the page, or the plot will depend on what it can or cannot do.
- A creature mentioned in lore is about to become real in a scene.
- A quest needs a creature as obstacle, guide, prize or threat.

Reach for a **different** procedure when the creature only needs a name in passing
(`world/workflows/03-name-something/`), when the question is how the creature's part in a
quest unfolds (`planning/workflows/05-design-a-quest/`), or when it is a people, race or
speaking species, whose file belongs in `world/src/peoples/`
(`world/workflows/10-create-a-people/`).

## What it produces, and where

- **A bestiary entry** at `world/src/creatures/<slug>.md`, with frontmatter and the eight
  sections: Ecology, Anatomy, Behaviour, Lore and names, Role in the story, Rules and limits,
  Weaknesses, Continuity facts.
- **Register rows** in `world/src/names-register.md` (kind `creature`), one per name a people
  uses for it.
- **Set-up links:** each weakness the plot will use, linked to where `planning/src/causality.md`
  plants it.
- **Open questions**, handed back as `AUTHOR TO CONFIRM` flags in the entry.

## The two failures this procedure prevents

The creature that can do whatever the scene needs, and the weakness that appears exactly when
the hero needs it. Both break the reader's trust in every other rule of the world. Fixing the
limits before the powers, and linking each weakness to its set-up, makes the creature a source
of tension rather than a convenience.

## Cross-references

- `world/docs/reference/creatures.md` — ecology first, rules and limits, lore against truth.
- `world/src/creatures/` — where the entry lands, and its skeleton.
- `planning/src/quests/` — quests the creature takes part in.
- `planning/src/causality.md` — where each weakness is set up.
