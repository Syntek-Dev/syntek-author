---
name: steelman
description: >-
  Audit a theology chapter for good faith and report three verdicts: every objection stated so its
  holders would recognise it (recognition, ease and missing-objection tests); every concession
  placed ahead of its response on the page; the 'you would say that' objection at full strength when
  the Decisions heading of .claude/MEMORY.md records the author's stake; the objection designated as
  left standing still unanswered; no sentence leaving a reader who decides differently defensive
  rather than thoughtful. Gate V4.4, and manuscript/workflows/10-steelman-the-objections/ in skill
  form. Use when the author says 'steelman the objections in chapter 4', 'is this objection fair?',
  'is this concession real?', 'am I arguing in good faith?' or 'is the standing objection still
  standing?'. Never rewrites the argument. Not the argument's structure (`argument-audit`); not how
  each tradition reads a passage (`tradition-check`); not claim categories (`category-check`); not
  polishing prose (`improve-section`).
---

# Skill: Steelman (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A work that asks its readers for honesty has to show its own. This skill audits a chapter against
those commitments: objections stated at full strength, costs conceded before they are answered,
the author's own stake faced squarely, the objection left standing still standing, and no sentence
written at a reader's expense. You are a **reviewer, not a rewriter**: report with exact locations
and suggested fixes, and never rewrite the author's argument or conclusions.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `manuscript/workflows/10-steelman-the-objections/` — the good-faith audit, step for step.
- `manuscript/workflows/05-review-a-chapter/` — the structural stage, where this skill is gate
  V4.4 (`standards/verification/THEOLOGY.md`), run after V4.1 to V4.3.
- If a layer's `workflows/local/` holds a folder with the same `NN-name` as a procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `standards/method/THEOLOGY.md` — rules 5 to 8 (concede before rebutting, the three tests, an
  objection left standing, bias declared) are the rules this skill applies.
- `standards/risk/THEOLOGY.md` — rule 1: examine the practice, never despise the practitioner.
- `manuscript/docs/reference/main-text-and-footnotes.md` — what a footnote can and cannot carry.

## How to run the good-faith audit

1. **Find what the chapter is committed to.** Read the brief's `## Claims and categories`, the
   argument map in `planning/src/arguments/` (its objections `O` and concessions `K`), and
   `.claude/MEMORY.md`: its `Decisions` heading (mapped in `00-project.md` `## Memory headings`)
   for any objection designated as left standing, and any stake the author has in the question,
   wherever it is recorded. Note when none is designated: leaving
   one standing is allowed by the method, not required. *Complete when:* the map's objections and
   concessions, the designated standing objection (or 'none designated') and any recorded stake are
   listed.

2. **List every objection the chapter raises.** Extract each in the chapter's own words, with its
   location, including objections raised implicitly ('some will say') and any the chapter answers
   without first stating. Compare with the map: an objection on the map but missing from the prose
   is noted. *Complete when:* every objection has a location and is matched to a map line, or
   marked as missing from one side.

3. **Apply the three tests to each objection.** **Recognition:** would someone who holds it say
   'yes, that is what I think'? Where the objection belongs to a tradition, use `tradition-check`
   for how its holders would state it. **Ease:** if the response came easily, the objection was
   too weak; flag any objection dispatched in a sentence. **Omission:** what is the strongest thing
   an opponent would say that the chapter does not mention at all? Name it, and name who holds it,
   with a source or a `VERIFY` flag. *Complete when:* every objection has three results, and the
   strongest missing objection is named or recorded as none found.

4. **Check the objection aimed at the author.** When `.claude/MEMORY.md` records a stake (a
   vocation, a tradition, an income, a history), the strongest form of 'you would say that' is
   stated at full strength wherever the chapter leans on that stake, and the stake is declared in
   the body, briefly, not assumed from an earlier unit (method rule 8). Flag both failures: hedging
   that turns a disclosure into a claim of objectivity, and a confession performed as a credential.
   Missing or softened here is blocking. *Complete when:* the stake check is passed, failed with
   locations, or recorded as not applicable because no stake is recorded.

5. **Check every concession by its position on the page.** Concessionary words prove nothing. For
   each cost the chapter answers, confirm it is stated in the body, not a footnote; in its own
   passage, before the response begins, never in the same sentence; in its holders' terms, not the
   author's summary; and in units that do not make it look small (method rule 5). *Complete when:*
   every concession is marked placed or inverted, with the location of the cost and of its answer.

6. **Fold in the readings and the categories.** Run `tradition-check` on the passages the chapter
   leans on (named in the body, not only a footnote) and `category-check` on the answers to
   objections (an exegetical objection met with application, a reading defended as the plain
   sense). Fold their findings into this report rather than restating their work. *Complete when:*
   both checks have run over the same scope and their findings are in the report.

7. **Check anything left standing is still standing.** If an objection is designated as left
   standing, sweep the chapter for anything that answers it: in part, in a footnote, or by
   implication. A chapter that quietly answers it is a defect in that chapter, not a win. If it has
   been answered, **report and stop**: do not resolve it and do not re-designate it; the author
   decides whether the chapter or the designation changes, and the decision is dated under the
   `Decisions` heading of `.claude/MEMORY.md`. *Complete when:* the standing objection is confirmed still
   standing, reported as answered at a named location, or recorded as none designated.

8. **Check the charity of every sentence.** Read for the reader who decides differently. Flag any
   sentence that would leave them defensive rather than thoughtful: sneering, a knowing aside,
   pity, a joke at the other view's expense, a permissive answer hedged where a restrictive one is
   stated plainly. These are defects however well turned (`standards/risk/THEOLOGY.md` rule 1).
   *Complete when:* every such sentence is listed by location with the reader it would lose.

9. **Report, give the three verdicts, and hand back.** Deliver the report below. Change nothing
   in the chapter. When the audit runs as gate V4.4 and the author has resolved every blocking
   finding, date `V4.4: DD/MM/YYYY` in the brief's `verified:` map, as step 10 of the workflow
   sets. *Complete when:* the report
   and all three verdicts are delivered, even where they pass, and any gate date recorded matches
   a pass the report supports.

## The report

A prioritised list, **blocking first**: exact location (file, section marker, opening words), the
check it fails, why, a suggested fix, and the procedure that owns the fix. Group recurring patterns
so one decision fixes many. The fix for a weak steelman is a stronger statement of the objection,
never a softer statement of the response.

Then the three verdicts, stated explicitly even when they pass:

- **Steelman:** pass or fail, naming the weakest objection.
- **Conceded before rebutted:** pass or fail, naming any inversion.
- **Left standing:** still standing, answered at a named location, or none designated.

## Anti-patterns

- **Rewriting the author's conclusions.** You report; the author decides. This is firmest for
  anything marked as the author's own conviction.
- **Weakening the argument to make it fairer.** Strengthen the objection instead.
- **Inventing objections nobody holds.** A steelman is the best version of a view someone actually
  has, with a source, not the hardest sentence that can be constructed.
- **Counting concessionary words.** 'Of course', 'admittedly' and 'to be fair' prove nothing; only
  the order on the page does.
- **Resolving the standing objection.** Report it answered and stop; never re-designate it.
- **Softening the stake objection.** When a stake is recorded, the objection aimed at the author is
  the one the chapter can least afford to duck.

## Cross-references

- `standards/method/THEOLOGY.md` — rules 5 to 8; `standards/risk/THEOLOGY.md` — rule 1.
- `standards/verification/THEOLOGY.md` — gate V4.4 and the order within V4.
- `planning/src/arguments/` — the objections and concessions on the chapter's map.
- `.claude/MEMORY.md` — the `Decisions` heading (mapped in `00-project.md` `## Memory headings`):
  the standing objection and the author's recorded stake.
- `.claude/skills/tradition-check/SKILL.md` — readings as their holders state them.
- `.claude/skills/category-check/SKILL.md` — answers kept in the right category.
- `.claude/skills/argument-audit/SKILL.md` — the support behind each answer.
- `.claude/skills/grill-with-docs/SKILL.md` — records the author's decisions on what the report
  finds.
