# CONTEXT.md — world/src/peoples/

The peoples of the world: one file per race, species or kind of people the story depicts. A
people file records what they are rather than how they live: their bodies (above all whatever
shapes how they speak and hear), how long they live, how many there are, where they live and
have lived, and how they stand towards the other peoples. How a group of them lives is a culture,
in `world/src/cultures/`, and one people may hold several cultures. The events that moved, mixed
or divided peoples are in `world/src/history/`.

## Directory Tree

```text
world/src/peoples/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules and the file skeleton
├── example-people.md     ← seeded once at generation: an invented example; yours to delete
└── <slug>.md             ← one people, named for its registered name in kebab-case
```

## What's here

Each `<slug>.md` carries frontmatter `name`, `ipa`, `kind`, `homelands` and `first_appears`,
a depiction note directly under it, and eight sections in this order:

- `## What they are` — the people in a paragraph: human or not, and what sets them apart.
- `## Body and speech` — **the physiology that constrains speech and hearing: mouth, teeth,
  breath, voice and ears, and the sounds they cannot make or hear. Language work reads this
  section before it proposes a single sound**; 'human, no constraint' is a full answer.
- `## Lifespan and generations` — how long they live and how long a generation is, which sets
  how fast their speech and customs change.
- `## Numbers and spread` — how many, and how thinly or densely they live.
- `## Homelands and movements` — where they live now and where they came from; each move the
  story relies on is an event file in `world/src/history/`.
- `## Relations to other peoples` — alliance, trade, rivalry, conquest, intermarriage.
- `## Role in the story` — the scenes the people shapes.
- `## Continuity facts` — fixed details, each with its section once promoted prose uses it.

A new project may hold `example-people.md`, seeded once when the project was generated: an
invented people with every section filled, cited by the example culture beside it. **It is
yours to delete; `copier update` never brings it back.**

## Cross-references

- `world/workflows/10-create-a-people/` — the procedure that writes these files.
- `world/docs/reference/peoples.md` — why body and speech come first, and the depiction rules.
- `world/src/cultures/` — how each people lives; a culture file names its people.
- `world/src/history/` — the migrations, conquests and contact that moved or mixed peoples.
- `standards/risk/FICTION.md` — depiction risk, including a people the story casts as hostile.
