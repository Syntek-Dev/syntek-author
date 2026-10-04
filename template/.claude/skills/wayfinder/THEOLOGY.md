# THEOLOGY.md — wayfinder, theology mode

What a theology book charts with a map, and where its settled nodes go.

## Paths and unit

- **Map files:** in the decision maps folder `00-project.md` `## Paths` names (by default
  `planning/src/maps/MAP-<TOPIC>.md`), for example `MAP-PART-TWO.md` or `MAP-CHAPTER-4-EVIDENCE.md`.
- **Reads (step 5):** `planning/src/outline.md`, the briefs in `planning/src/units/`, the argument
  maps in `planning/src/arguments/`, `research/src/contested-readings/`, `research/src/evidence/`
  and `research/src/notes/`.
- **Procedures that chart with a map:** none require one; `planning/workflows/02-map-the-argument/`
  reaches for a map when several chapters share an argument.

## Additions to the steps

- **Step 1 — also** read the `Decisions` heading of `.claude/MEMORY.md` (mapped in `00-project.md`
  `## Memory headings`) for the book's standing commitments: whether the objection left standing
  has been designated, and how the bias disclosure is handled.
- **Step 5 — also surface the standing commitments as the first frontier nodes** when they are
  undecided. The objection the book leaves standing, and which chapters form a proposal sample
  (where a proposal is in hand), block large parts of any map of the book; chart them first rather
  than mapping around them.
- **Step 5 — also** make each contested passage that more than one chapter leans on a single
  research node, so it is mapped once (through `research/workflows/03-map-a-contested-reading/`)
  rather than re-argued per chapter.
- **Step 11 — also** run a contested reading's research leg before any grilling node that depends
  on which reading the book adopts.

## Domain rules

| A settled decision that is… | Graduates to… |
|---|---|
| a claim and its category | the brief's `## Claims and categories` |
| a move in an argument, an objection or a concession | the argument map in `planning/src/arguments/` |
| how a contested passage is read | its map in `research/src/contested-readings/` |
| the objection left standing, or the bias disclosure | `.claude/MEMORY.md`, the `Decisions` heading, out of the `Open questions` heading |
| the chapters in a proposal sample | `.claude/MEMORY.md`, the `Decisions` heading; it also sets the drafting order |

- **Variant anti-pattern:** charting the manuscript before the standing commitments are settled;
  a chapter drafted on one side of an undecided commitment is a defect waiting to be found.

## Examples

```text
# MAP-CHAPTER-4-EVIDENCE — what chapter 4 can claim about rest and work

## Frontier
1. [research] The commandment's verb: its range in a standard lexicon (blocks 3)
2. [research] What the two studies on rest measured, and what they did not (blocks 4)
3. [grilling] Which reading of the commandment the chapter adopts (blocked by 1)
4. [grilling] Whether the studies support the chapter's claim or only illustrate it (blocked by 2)
5. [task] Obtain the second study's full text

## Out of scope
- The history of Sunday legislation: chapter 6's question, not this one.
```
