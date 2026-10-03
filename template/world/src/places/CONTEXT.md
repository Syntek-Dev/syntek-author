# CONTEXT.md — world/src/places/

One file per place a scene happens in or depends on: a city, a river crossing, a room, a
region. Each records what the place is, how it strikes the senses, how it came to be, who
holds it, and what the prose has already fixed about it. When things happen there belongs in
`planning/src/timeline.md`; checked detail about a real place belongs in
`research/src/setting/`, and the place file cites it.

## Directory Tree

```text
world/src/places/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules and the file skeleton
└── <slug>.md           ← one place, named for the registered name in kebab-case
```

## What's here

Each `<slug>.md` carries frontmatter `name`, `ipa`, `kind` (settlement, building, room,
river, road, region, other), `within` (the larger place it sits in, if any) and
`first_appears`, then six sections in this order:

- `## What it is` — two or three sentences a stranger would need.
- `## Geography and distances` — where it sits, what is near, and **how long it takes to
  reach the places the story travels between**; journeys are where continuity breaks first.
- `## Senses` — what a point-of-view character notices: sight, sound, smell, weather, season.
- `## History` — only as deep as the book uses.
- `## Who holds it and its rules` — who lives here, who controls it, what is forbidden.
- `## Continuity facts` — fixed details, each with its section once promoted prose uses it.

## Cross-references

- `world/workflows/02-create-a-place/` — the procedure that writes these files.
- `research/docs/reference/real-world-detail.md` — checking a place drawn from a real one.
- `planning/src/timeline.md` — when each scene happens, and where.
- `world/docs/reference/naming.md` — place names, which are usually older than people's.
