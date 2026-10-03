---
name: argument-audit
description: >-
  Audit a theology chapter's argument against its argument map in planning/src/arguments/
  (thesis → claims → supporting claims → evidence → objections → concessions): flag unsupported
  moves, missing premises, conclusions stated beyond their evidence, and moves in the prose that
  the map does not carry. Runs on an existing map (planning workflow 02) and on the prose at
  structural review (gate V4.1). Use when the author says 'audit the argument in chapter 3',
  'does this chapter's argument hold?', 'is a premise missing here?', 'am I concluding more than
  I have shown?', 'check the prose against the map' or 'audit my argument map'. Reports, and
  never repairs the argument. Not building a new map (`planning/workflows/02-map-the-argument/`,
  through `run-workflow`); not labelling claim categories (`category-check`); not how other
  traditions read a passage (`tradition-check`); not whether objections are stated fairly or
  concessions placed first (`steelman`); not whether a fact or quotation is true (`fact-check`).
---

# Skill: Argument audit (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

An argument drafted straight into prose hides its missing premises in good sentences. This skill
walks a chapter's argument from its thesis down to its evidence, on the map before drafting and
in the prose at structural review, and reports every place where the support stops short. It is a
**reviewer, not a rewriter**: it says where the argument is open and why, and the author decides
how the argument changes.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `planning/workflows/02-map-the-argument/` — laying out and auditing a map before drafting
  (this skill runs its steps 1, 2 and 5 to 8, and hands back at step 10).
- `manuscript/workflows/05-review-a-chapter/` — the structural stage, where this skill is gate
  V4.1 (`standards/verification/THEOLOGY.md`).
- `standards/method/THEOLOGY.md` — rule 3 (argue from a map) is the rule this skill enforces;
  rules 4, 5 and 7 govern the readings, concessions and standing objections it checks for.
- `planning/docs/reference/argument-maps.md` — the map's shape and the IDs (`C`, `R`, `O`, `K`).

## How to audit the argument

1. **Fix the scope and the use.** Agree with <%AUTHOR_FIRST_NAME%> which chapter, and which use:
   a **map audit** (the map, before or between drafting) or a **prose audit** (the promoted chapter
   against its map, gate V4.1). Read the chapter's brief in `planning/src/units/`, its map in
   `planning/src/arguments/` (named exactly as the brief), `standards/method/THEOLOGY.md` rules 3
   to 7, and `.claude/MEMORY.md` `## Decisions` for anything binding the chapter, above all an
   objection designated as left standing. Either audit with no map stops here: there is nothing
   to audit, and the map is built first, through `planning/workflows/02-map-the-argument/` (run
   by `run-workflow`). *Complete when:* the scope, the use and the map's path are stated, and
   every file above has been read, or the run has stopped for want of a map.

2. **Read the thesis.** The thesis is one sentence saying what the chapter lands. If it takes two,
   the chapter argues two things; raise it, and let the author decide whether to split it. For a
   prose audit, find the sentence in the chapter that lands the thesis and compare it word for
   word with the map. *Complete when:* the thesis is quoted from the map, with its location in the
   prose for a prose audit, or a two-thesis finding is recorded.

3. **Walk the support down.** For every claim (`C1` …), name what supports it (other claims, a
   passage, an entry in `research/src/evidence/`, a note in `research/src/sources/`) and open each
   to confirm it exists and says what the claim needs. A claim supported by nothing, by a file that
   does not exist, or only by a claim below it in a circle, is an **open move**. A reference,
   quotation or attribution not yet checked carries `<!-- VERIFY: … -->`; never supply one from
   memory to close a gap. *Complete when:* every claim has a support line that resolves, or is
   listed as an open move with the reason.

4. **Check the readings and the objections on the map.** Every passage the chapter leans on that
   Christians read in more than one way has an `R` ID and a map in
   `research/src/contested-readings/`; a claim resting on an unmapped reading is unsupported, and
   the route is `research/workflows/03-map-a-contested-reading/`. Every objection (`O`) names who
   holds it and where it is answered, or that it is left standing; every concession (`K`) names
   the section that states it, ahead of the section that answers it. *Complete when:* each `R`,
   `O` and `K` line resolves, or is listed as an open move.

5. **Find the missing premises.** For each step from supporting claims to the claim they carry,
   ask what else must be true for the step to hold. A premise the argument needs but never states
   is an open move, even when it seems obvious; a premise the author would state differently from
   the one implied is a question for the author, not a guess. *Complete when:* every inference on
   the map has been tested and each unstated premise is written out as one sentence.

6. **Find conclusions beyond their evidence.** Compare each conclusion's scope and certainty with
   its support: 'all' from 'some', 'always' from 'once', 'Scripture teaches' from one reading of
   one passage, 'the Church holds' from one writer. The conclusion may be right; the finding is
   that the support does not yet reach it. *Complete when:* every claim in the categories of
   inference, conclusion and application has been compared with its support, and each overreach
   is listed with the words that overreach.

7. **Prose audit only: hold the prose to the map.** Walk the chapter section by section and assign
   each argumentative paragraph to the claim it makes. Every claim on the map is argued somewhere;
   every move in the prose appears on the map; no section answers an objection the map says is
   left standing. A move in the prose missing from the map is reported, not judged wrong: where
   drafting found a better argument, the map changes first, with the author (method rule 3).
   *Complete when:* every map claim has a prose location, and every unmapped prose move is listed
   with its location.

8. **Report, record and hand back.** Deliver the report below. For a map audit, write the agreed
   open moves under the map's `## Open moves`, as `planning/workflows/02-map-the-argument/` step 8
   sets; for a prose audit, change nothing in the chapter. Run as gate V4.1, hand the verdict to
   the review workflow, which dates the gate in the brief's `verified:` map once every blocking
   finding is resolved (`manuscript/workflows/05-review-a-chapter/` step 5). Decisions the author
   makes go to `.claude/MEMORY.md` through `grill-with-docs`. *Complete when:* the report is
   delivered, the author has the next step, and the review workflow has the verdict.

## The report

A prioritised list, **blocking first**. A finding is blocking when a claim the thesis depends on
is unsupported, a conclusion overreaches, or a standing objection has been answered. For each:

- **Location** — the map line (`C4`, `O2`) and, for a prose audit, the unit file and section
  marker, with the opening words of the sentence.
- **Kind** — unsupported claim · missing premise · conclusion beyond its evidence · unmapped
  reading · objection or concession not placed · prose move missing from the map · map claim not
  argued in the prose.
- **Why** — one or two sentences: what the step needs and what it has.
- **Options** — what would close it, put as choices for the author (find evidence through
  `research`, add the premise, narrow the conclusion, change the map), never as rewritten prose.
- **Owner** — the procedure that makes the fix: `planning/workflows/02-map-the-argument/` for the
  map, `manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`
  for the prose, `research/workflows/03-map-a-contested-reading/` for a reading.

Close with a verdict: **V4.1 pass or fail**, naming the weakest link in the chain.

## Anti-patterns

- **Repairing the argument.** Writing the missing premise into the prose, or softening a
  conclusion to fit its evidence, makes a decision that belongs to the author.
- **Inventing support.** A source, a passage or a reading offered from memory to close an open
  move is a fabrication (`.claude/rules/syntek-author/03-authorship.md` Section 4).
- **Auditing prose with no map.** Without the map there is nothing to hold the prose to; the
  audit becomes a matter of taste.
- **Treating a confident sentence as support.** 'Clearly', 'of course' and 'the text plainly
  says' carry no weight; only the support line does.
- **Answering the standing objection.** It is the author's designation, and the map records it;
  never re-designate it or argue it down.
- **Judging the truth of the evidence.** Whether a source is right is `fact-check`'s question;
  this skill asks only whether the support reaches the claim.

## Cross-references

- `standards/method/THEOLOGY.md` — rules 3 to 7.
- `standards/verification/THEOLOGY.md` — gate V4.1 and the order within V4.
- `planning/docs/reference/argument-maps.md` — the map's shape and IDs.
- `planning/src/arguments/` — where maps live; `planning/src/units/` — the briefs they serve.
- `research/src/contested-readings/` · `research/src/evidence/` · `research/src/sources/` — the
  support a map links to.
- `.claude/skills/category-check/SKILL.md` — labels each claim's category; runs beside this at V4.
- `.claude/skills/steelman/SKILL.md` — whether objections and concessions are fair on the page.
- `.claude/skills/tradition-check/SKILL.md` — whether each reading is stated so its holders would
  recognise it.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricate; suggest, do not rewrite.
