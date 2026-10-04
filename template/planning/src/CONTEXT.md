# CONTEXT.md — planning/src/

The plans themselves. The outline orders the units, each unit has one brief, and the doc
type's own plans and registers sit beside them. Maps and review reports live here too, because
they are *about* the work. Nothing here is built into the finished work, and no section prose
lives here: that is the content layer's job.

## Directory Tree

```text
planning/src/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── outline.md              ← seed: the order of the units, one line each
<: if DOC_TYPE == 'fiction' :>├── causality.md            ← seed: the because/therefore chain, beat by beat
├── timeline.md             ← seed: in-story time, event by event
├── continuity.md           ← seed: established facts, each with its section reference
<: endif :><: if DOC_TYPE == 'business' :>├── document-register.md    ← seed: every registered document, by DOC-NNN
├── review-schedule.md      ← seed: when each document is next reviewed
├── precedence.md           ← seed: which instrument prevails, per family
<: endif :>├── units/                  ← one brief per unit
<: if DOC_TYPE == 'theology' :>├── arguments/              ← one argument map per chapter
<: endif :><: if DOC_TYPE == 'fiction' :>├── arcs/                   ← one arc per character who changes
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── quests/                 ← one plan per quest
<: endif :><: if DOC_TYPE == 'business' :>├── approvals/              ← one record per approval event
<: endif :>├── maps/                   ← decision maps, written by `wayfinder`
└── reviews/                ← review reports, advice only, written by `structure-review`
```

## What's here

- `outline.md` — **the one place the order of the whole work lives.** One row per unit; the
  plan itself is in the unit's brief.
- `units/` — one brief per unit, `<unit>.md`, named for the unit in the content layer.
<: if DOC_TYPE == 'theology' :>- `arguments/` — one argument map per chapter, beside its brief: thesis, claims with their
  categories, support, objections and concessions.
<: endif :><: if DOC_TYPE == 'fiction' :>- `causality.md`, `timeline.md`, `continuity.md` — the story bible's planning half: why each
  beat happens, when it happens in story time, and what the prose has already established.
- `arcs/` — one arc per character who changes, beside the character's entry in
  `world/src/characters/`.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `quests/` — one plan per quest: goal, stakes, cost, reward and its ties to arcs and causality.
<: endif :><: if DOC_TYPE == 'business' :>- `document-register.md`, `review-schedule.md`, `precedence.md` — **the publication record**
  for every document in the library, from its registration at the end of line edit onwards.
- `approvals/` — one record per approval event: who approved what, when, and how. It is the
  default Approvals path; `00-project.md` `## Paths` may name another.
<: endif :>- `maps/` — decision maps for bodies of work too big for one sitting, indexed in
  `maps/CONTEXT.md` (a seed: yours once generated, and `wayfinder` appends its rows).
- `reviews/` — review reports, **advice only**; a decision exists only once the author dates it
  in `.claude/MEMORY.md`.

The seeds ship with headings and writing rules but no entries. `copier update` recreates a seed
you delete and never touches one you have edited.

## Cross-references

- `planning/docs/reference/CONTEXT.md` — the guide behind each file and folder here.
- `planning/workflows/CLAUDE.md` — the procedure that writes each one.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the content layer these plans serve.
