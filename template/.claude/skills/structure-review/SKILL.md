---
name: structure-review
description: >-
  Run a multi-lens structural review of a unit, a part or the whole work (in a business project,
  also a document due its scheduled review, or the whole library) in a forked context, and write
  the synthesis as advice only to planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md: each lens's
  verdict by location, numbered open decisions with a recommendation each, next steps naming
  their procedures, claims to verify, and the honest dissent where lenses disagree. Changes
  nothing else. Use when the author says 'review the structure of chapter 4', 'does the book hang
  together?', 'run the panel on part one', 'what would an editor say?', 'review the proposal
  before I send it', 'this document is due its review' or 'where is the library fighting me?', or
  at the structural stage of a review. Not checking facts (`fact-check`), not reading line by line
  (`comprehension`, `flow`), not settling the decisions it raises (`grill-with-docs`), and not
  charting a body of open decisions (`wayfinder`).
context: fork
agent: general-purpose
background: false
model: opus
---

# Skill: Structure review (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

**Forked, and read-only apart from one file.** This skill runs in a separate context with no
conversation behind it: it cannot ask the author anything, and it is independent of the session
that drafted the work, which is the point of it. It reads the work through a panel of lenses,
writes one review file in `planning/src/reviews/`, and hands back. A review is advice: a decision
exists only when the author makes it and dates it, and the procedure that owns each artefact
makes the change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record; this skill is their review step in skill form.

- The content layer's review workflow, step 'Structural review' (the mode file names it) — one
  unit, gate V4 (`structural-review → fact-check`) in `standards/verification/verification.md`.
- `planning/workflows/09-review-the-whole-work/` — the whole work, a part, or a family of
  documents.
- `planning/docs/reference/reviews-are-advice.md` — **the review file's shape**, and the line
  between advice and a decision.
- `standards/verification/verification.md` V4, and any structural sub-gates its mode file adds,
  which the workflow runs after this review through their own skills.
- `standards/method/method.md` and its mode file — the structural rules the lenses read against.
- `.claude/rules/syntek-author/08-naming-and-memory.md` Section 3 — the memory gate the caller
  applies to the author's decisions.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Take the brief.** The caller settles with the author, before dispatch, the scope (a unit, a
   part, `whole-work`, or a scope the mode file adds), the question the author most wants
   answered, and the lenses (by default the mode file's full panel). If any of these is missing,
   make the narrowest reasonable call and write it down as an assumption for the review's header;
   never stop to ask. Name the scope as the file will.
   *Complete when:* the scope, the question and the lens list are fixed, with every assumption
   written down.

2. **Read the plan and the record.** The project brief (the 'Project brief' row of `00-project.md`
   `## Paths` locates it) and the stated reader (`00-project.md` `## Brief`); the `Decisions` and
   `Open questions` headings of `.claude/MEMORY.md` (mapped in `00-project.md`
   `## Memory headings`), so that no dated decision is re-argued unawares;
   `planning/src/outline.md`; every unit brief in scope in `planning/src/units/` (scope, what the
   unit does, each section's purpose, the settled positions); the plans the mode file names; the
   most recent review of the same scope in `planning/src/reviews/`, and what the author decided
   about it.
   *Complete when:* every artefact in scope has been read, the decisions this review must respect
   are listed, and the earlier review (if any) is noted.

3. **Read the work, in full and in order.** Read every unit in scope as prose, in the outline's
   order, not sampled; for a unit not yet written, read its brief and say so. Write a one-line map:
   section by section (or unit by unit), what it does, set against what its brief says it should do.
   *Complete when:* the map exists, and every gap between plan and prose is noted by location.

4. **Run each lens in turn, and fix each verdict before the next.** For each lens in the panel:
   state in one line what it reads for; read the work as that lens; record what works and what does
   not, by location (unit, section, paragraph), each finding marked blocking, significant or minor.
   Write each lens's verdict in full before starting the next, and never revise an earlier verdict
   in the light of a later lens: their disagreement is information for step 6.
   *Complete when:* every lens in the panel has a written verdict with locations, none edited after
   the next lens began.

5. **Apply the structural tests.** Across the whole scope: the **purpose test** (does each section,
   or unit, do the job its brief gave it?); the **deletion test** (if it were deleted, would
   anything be lost, or does its content already have one obvious home elsewhere?); the **order
   test** (would it read better elsewhere, and what would that break?); the **promise test** (does
   the close deliver what the opening promised?). Then the mode file's tests.
   *Complete when:* each test has a result for every section or unit in scope, by location.

6. **Synthesise, keeping the dissent.** Where lenses agree, state the finding once and name the
   lenses behind it. Where they disagree, record both under the honest dissent; never average them
   into a verdict no lens gave. Turn each finding that needs the author into a numbered open
   decision, with the options and a recommended answer with its reason. Turn each remedy into a next
   step naming the procedure that would carry it out. List every claim brought in from outside the
   repository (a market, a comparable work, a legal point) under claims to verify, flagged
   `VERIFY`, for `fact-check`.
   *Complete when:* every finding is a single statement, an open decision, a next step, a claim to
   verify or a recorded dissent.

7. **Write the review file.** `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, in the shape
   `planning/docs/reference/reviews-are-advice.md` gives: the header with subject, scope, date, any
   assumption from step 1 and the line **Status: Advice only — nothing in the repository was
   changed**; the lenses; the verdicts; the open decisions; the next steps; the claims to verify;
   the honest dissent; the provenance (which lenses ran, when, in a forked context). Name the
   earlier review it supersedes. Never edit an earlier review; if a file of that name already
   exists, choose a distinct scope name rather than overwrite it, and say so in the header.
   *Complete when:* the file exists with every part of the shape, and nothing else in the
   repository changed.

8. **Hand back.** Return to the caller: the review file's path, the three findings that matter most,
   the open decisions in order with their recommendations, and the claims to verify. The caller
   puts the decisions to the author and records what passes the memory gate through
   `grill-with-docs`; the workflow, not this skill, moves a unit's status when V4's gates pass.
   *Complete when:* the caller has the path, the top findings, the ordered decisions and the claims
   to verify, and this skill has written nothing but the review file.

## Anti-patterns

- **Editing anything but the review file:** the work, a brief, the outline, a register, MEMORY, a
  standard. The review advises; the owning procedure acts.
- **Averaging the lenses,** or running them as one blended pass ('the panel feels…'). Each lens
  reads alone; dissent is kept.
- **Re-arguing a dated decision unawares.** If a finding contradicts a decision under the
  `Decisions` heading, say so in the finding and give the reason it is worth reopening, or leave it out.
- **Reviewing the plan instead of the page.** The work is judged as written; a gap between plan and
  prose is a finding, not something to read past.
- **Line editing in a structural review.** Commas, word choice and rhythm are for `comprehension`,
  `flow`, `grammar` and `spelling`, later.
- **Outside facts stated as findings.** A claim about a market, a comparable work or the law goes
  under claims to verify, never into a verdict as fact.
- **A silent pass.** A review that finds nothing says what it checked and how.
- **Stopping to ask.** A fork cannot; it states its assumption and carries on.

## Cross-references

- `planning/src/reviews/` — every review, kept as dated advice.
- `.claude/skills/grill-with-docs/SKILL.md` — records the decisions the author makes about a review.
- `.claude/skills/wayfinder/SKILL.md` — when the open decisions are too many to settle in one session.
- `.claude/skills/fact-check/SKILL.md` — the claims to verify, and the review stage after this one.
- `planning/docs/reference/unit-briefs.md` — what a brief promises, which the purpose test reads.
- `.claude/rules/syntek-author/03-authorship.md` Section 1 — who decides what.
