# FICTION.md — structural review of a novel

A novel is reviewed by four lenses: the reader it is written for, a structural editor, the keeper
of its continuity, and the genre it promises. Each reads alone. The panel reports; it never
repairs a contradiction, and it never stands in for the continuity and causality gates that run
after it.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with its brief
  (scene goals, `## Continuity facts`) in `planning/src/units/`.
- **One chapter:** step 4 of `manuscript/workflows/05-review-a-chapter/`. After this review the
  workflow runs V4.1 (`continuity`) and V4.2 (`causality`) in `standards/verification/FICTION.md`;
  this review may point at where they should look, but never stands in for them.
- **The whole novel, or a part:** `planning/workflows/09-review-the-whole-work/`.
- **Extra reads:** `standards/method/FICTION.md` (the story engine); `planning/src/causality.md`;
  `planning/src/timeline.md`; `planning/src/continuity.md`; the arcs of the point-of-view
  characters in `planning/src/arcs/`; `world/src/`; `manuscript/docs/reference/scene-craft.md`; and,
  where worldbuilding is installed, the quest files in the planning layer.

## Additions to the steps

- **Step 1 — also:** the genre is in `.claude/CLAUDE.md` Section 1, and the genre lens reads against
  it.
- **Step 2 — also read:** the chain in `planning/src/causality.md` for every beat in scope; each
  point-of-view character's arc (want, need, the lie and the truth); the continuity ledger and the
  timeline.
- **Step 4 — the panel, in this order:**
  1. *Reader* — a reader of this genre at the stated audience: where are they gripped, where
     confused, where would they put the book down, and what do they expect to happen next?
  2. *Editor* — does each scene have a goal, a conflict and an outcome; does each beat earn its
     place; what would a structural editor cut, merge or move; does the chapter do its job in the
     arc of the book?
  3. *Continuity* — does the chapter agree with the story bible? Every contradiction is listed with
     both locations, for the `continuity` skill to gate and the author to decide; nothing is
     repaired.
  4. *Genre* — what does the genre promise its readers, and does the chapter keep, subvert or
     forget those promises; is a convention used on purpose or by default? Comparable titles and
     market claims are claims to verify.
- **Step 5 — also:** every beat follows from a cause, and coincidence never resolves anything
  (`standards/method/FICTION.md` rules 1 and 7); every set-up planted is paid off or tracked; one
  point of view per scene; scene and sequel alternate.
- **Whole-novel scope — also:** does every arc complete or deliberately refuse to; is every set-up
  paid off; does the middle carry its own tension; does the ending follow from causes the reader has
  seen; is every subplot resolved; where worldbuilding is installed, is any quest left dangling?

## Domain rules

- **Contradictions are reported, never repaired,** in either direction; the author decides which
  side is canon.
- **Pacing is `pacing`'s.** The reader lens may say where attention flags; the scene-by-scene
  analysis of length and tension belongs to the pacing gate.
- **The story bible is the source of truth for the invented world**; real-world detail is a claim
  to verify, for `fact-check`.

## Examples

> **Verdict line (editor, blocking).** `the-turn`: the beat ends where it began; Maren still means
> to cross, and nothing has changed. Candidate for merging into `opening`, or for an outcome that
> costs her something.

> **Verdict line (continuity, significant).** `opening` line 3 makes Tam older than Maren;
> `planning/src/continuity.md` row F004 makes him younger. Listed for `continuity`; not repaired.

> **The honest dissent.** The reader lens finds the withheld reason for Tam's fear gripping; the
> genre lens finds it withheld too long for the genre's expectations. Both kept; open decision 1
> asks the author which effect they want.
