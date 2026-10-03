# CONTEXT.md — world/workflows/05-create-a-culture/

The procedure for describing a culture, the way one people lives: the land they live on and the
work it demands, what they value and fear, what they believe, how they are governed and how they
reckon kin, their customs, how they name things, and how they differ among themselves and from
their neighbours. What the people are is settled first, by `world/workflows/10-create-a-people/`.
It ends with a culture file whose naming customs `create-name` can follow.

## Directory Tree

```text
world/workflows/05-create-a-culture/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- Characters from the same people will appear, and need to behave as if raised alike.
- Names from a people are about to be coined, and need a shared sound and custom.
- A scene turns on a custom, a taboo or a rite.

Reach for a **different** procedure when only the people's name is needed
(`world/workflows/03-name-something/`), or when the job is one person from the culture
(`world/workflows/01-create-a-character/`).

## What it produces, and where

- **A culture file** at `world/src/cultures/<slug>.md`, with frontmatter (including `people`,
  the people's file in `world/src/peoples/`) and the nine sections: Land and livelihood, Values and taboos, Beliefs and rites, Power and kinship,
  Customs, Naming customs, Variety and neighbours, Role in the story, Continuity facts.
- **Register rows** in `world/src/names-register.md`: the culture's own name (kind `culture`),
  only when it differs from its people's registered name, which is never registered twice; and
  any sample names the author decides the book will use.
- **A depiction note**, an `<!-- INTERNAL NOTE: … -->` directly under the file's frontmatter,
  recording what the culture borrows from real peoples, if anything, and the outcome of the
  risk check.

## The failure this procedure exists to prevent

The costume culture: a set of hats, foods and festivals with no reason behind them, whose
people all think alike. A culture built from the ground up (land, then values, then customs)
can answer questions nobody has asked yet, and a character can break its customs in ways that
mean something, because the reader knows why the custom exists.

## Cross-references

- `world/docs/reference/cultures.md` — from ground to custom; no monocultures; borrowing.
- `world/docs/reference/naming.md` — sound palettes and naming customs.
- `world/src/cultures/` — where the file lands, and its skeleton.
- `world/src/peoples/` — what the culture's people are; build that file first.
- `standards/risk/FICTION.md` — depiction risk.
