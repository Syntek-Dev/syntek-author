# THEOLOGY.md — grill-with-docs, theology mode

Where a theology book's decisions are recorded: the brief, the argument map, the contested-reading
maps and the evidence base.

## Paths and unit

- **Brief:** `planning/src/units/NN-kebab-title.md`; its settled-positions slot is
  `## Claims and categories`.
- **Argument map:** `planning/src/arguments/NN-kebab-title.md` (claim → supporting claims →
  evidence → objections → concessions).
- **Contested readings:** `research/src/contested-readings/<kebab-passage>.md`, made through
  `research/workflows/03-map-a-contested-reading/`.
- **Evidence:** `research/src/evidence/`, through `fact-check`.

## Additions to the steps

- **Step 1 — also read the argument map and any contested-reading map** the unit leans on, so a
  reading already mapped opens the round as a `Settled` line.
- **Step 3 — also record the book's rows:**

| When a decision… | Record it in |
|---|---|
| settles a claim and its category | a row of the brief's `## Claims and categories` table (ID `C1`, `C2`…, claim, category), the same ID as the argument map; its basis under `## Draws on` |
| settles a move in the argument, an objection or a concession | the argument map, in its place in the chain |
| settles how a contested passage is read | the contested-reading map for that passage; the brief cites it |
| settles what the evidence supports | an evidence entry in `research/src/evidence/`, through `fact-check` |
| pins a contested term | `standards/style/terminology.md`: the adopted reading in **Meaning**, the others in **Use** |
| designates the objection the book leaves standing, or changes it | `.claude/MEMORY.md`, the `Decisions` heading (mapped in `00-project.md` `## Memory headings`), moved out of the `Open questions` heading, dated |
| settles the bias disclosure: what it says and where it is restated | `.claude/MEMORY.md`, the `Decisions` heading, and the brief of each unit that restates it |
| chooses chapters for a proposal sample, where a proposal is in hand | `.claude/MEMORY.md`, the `Decisions` heading; it also sets the drafting order |

- **Step 4 — also treat the standing commitments as gate-passing by nature.** The objection left
  standing and the bias disclosure cut across every unit: once settled they are hard to reverse
  and surprising without context, so they always reach `Decisions`.

## Domain rules

- **Never let a conclusion land without its category.** A position recorded in the brief names
  which of the six categories it is (`standards/method/THEOLOGY.md` Section 1), so `category-check`
  can later hold the prose to it.
- **A contested reading is recorded as a map, not a verdict.** The map states each reading so its
  holders would recognise it; the brief records which one the book adopts and why.
- **A standards change is author-confirmed, always.** `standards/method/` is the book's argument
  about itself; a grilling session that wants to change it proposes the wording and waits.
- **Scripture and original-language claims are recorded only with their evidence entry**
  (Section 9 of the same standard), never from the session's memory.

## Examples

```markdown
## Claims and categories

| ID | Claim | Category |
|---|---|---|
| C1 | The commandment grounds rest in creation, not in productivity. <!-- VERIFY: evidence entry pending --> | Interpretive inference |
| C2 | Rest is commended to Christians, not commanded. | The author's theological conclusion |

## Draws on

- C1: the text of the commandment, in the default translation (evidence entry pending).
- C2: the argument map, claims C1 to C4.
```

Under the `Decisions` heading of `.claude/MEMORY.md`: `- **03/10/2026** — **The objection left
standing: rest as privilege.** Chapter 6 names it and does not answer it. Rejected: answering it
in Chapter 7, which would undercut the concession in Chapter 3.`
