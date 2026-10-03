@./CONTEXT.md

# CLAUDE.md — planning/src/maps/

Read order: `.claude/skills/wayfinder/SKILL.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`planning/CONTEXT.md` → `planning/CLAUDE.md` → `planning/src/CONTEXT.md` →
`planning/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the decision maps that chart work too big for one sitting, and keep them indexes rather
than stores of answers.

## How to work here

- **Routing:** `wayfinder` owns this folder. Do not hand-write a map; run the skill. A grilling
  node is settled with `grill-with-docs`, a research node with `research` or `fact-check`, a
  prototype node with `prototype`.
- **Model:** **Opus** throughout; deciding what is a decision, and what blocks what, is
  judgement (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** chart in one session (destination, frontier, blocking edges, the map, the
  index row); resolve in later sessions, one batch of related nodes at a time, graduating each
  answer to its home.
- **Definition of done:** a chart session ends with every knowable decision on the map and the
  frontier ordered; a resolve session ends with one batch of related nodes settled, graduated and
  linked, and the frontier redrawn.

## Guardrails

- **Never resolve during a chart session.** The first node usually looks easy; settling it
  leaves the map half-drawn.
- **The map is an index, never a vault.** A map readable as a standalone document has absorbed
  content that will now drift from its real home.
- **Every resolved decision graduates** — to MEMORY, a brief, `research/src/` or
  `standards/style/terminology.md` — and the map keeps the link.
- **Ask nothing the repository can answer**, and settle no empirical question by asking the
  author.
- **Never draft prose from a map session**, and never delete a map's history.
- **Append to the index; never rewrite it.** `CONTEXT.md` here is a seed and belongs to the
  author: `wayfinder` adds one row per map and changes only that row's `Frontier open?`; any
  other edit to the file needs the author's word.

## Output & naming

- **Written by `wayfinder`:** `MAP-<TOPIC>.md` (upper-case topic) and its row, appended to the
  index in `CONTEXT.md`.
- **Ownership:** this `CLAUDE.md` is template-owned and updated by `copier update`; `CONTEXT.md`
  is a seed the template never overwrites; every map is the author's.
- **Not here:** the decisions themselves, prose, or evidence.
