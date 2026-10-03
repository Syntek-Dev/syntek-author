---
name: pacing
description: >-
  Report on the pacing of a chapter of fiction: the length of each scene and section, whether
  scenes and sequels alternate, what each scene's outcome changes, how tension rises across the
  chapter, where the story slows into summary, backstory or description, and whether the chapter
  ends on a question. A report only: it never cuts, merges or rewrites; the author answers every
  item. Runs gate V6.2 at line edit. Use when the author says 'is chapter 7 too slow?', 'check
  the pacing', 'this middle drags', 'does the tension build?', 'run the pacing pass', or 'are my
  scenes too long?'. Not whether beats have causes (`causality`), not the order of chapters
  across the book (`structure-review`), not transitions and rhythm between sentences (`flow`),
  not facts against the bible (`continuity`).
---

# Skill: Pacing (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Pacing is how fast the story feels against how much is happening. A scene whose outcome changes
nothing asks the reader for time and gives nothing back; a run of hard scenes with no pause leaves
the reader unable to feel any of them. This skill measures a chapter section by section, reads the
pattern, and reports what it finds with the reason it matters. It never cuts a word: every finding
is a question, and the author answers it.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `manuscript/workflows/05-review-a-chapter/` — the line-edit stage, where this skill runs gate V6.2
  (step 11).
- `standards/method/FICTION.md` — rule 3 (scene goal, conflict, outcome) is the rule this report
  serves; rule 4 (set-up and payoff) explains a slow stretch that is planting.
- `standards/verification/FICTION.md` — gate V6.2.
- `manuscript/docs/reference/scene-craft.md` — goal, conflict, outcome, and the scene and sequel
  alternation.

## How to report on pacing

1. **Fix the scope.** Agree the chapter with the author and the occasion (gate V6.2, or an earlier
   read of a draft). Read the chapter's brief for what the unit does and its sections' purposes, and
   its row in `planning/src/outline.md` for where the chapter sits in the book. *Complete when:* the
   chapter and the job its brief gives it are named back to the author.

2. **Measure each section.** For each section, in marker order: its word count (count the words
   between its `<!-- section: <slug> -->` marker and the next; a shell word count is enough);
   whether it is a scene (goal, conflict, outcome) or a sequel (reaction, dilemma, decision); its
   point-of-view character; its outcome (yes, no, yes-but, no-and); a tension rating from 1 to 5
   with a one-line reason; and how much story time it covers on the page against in summary.
   *Complete when:* every section has every measure filled in.

3. **Read the pattern.** Look for: three or more scenes with no sequel (breathless); two or more
   sequels in a row (sagging); a scene whose outcome leaves everything as it was (method rule 3); a
   section far longer or shorter than the chapter's others with no reason in the brief; long
   stretches of backstory, description or summary at a moment of high tension; tension that falls at
   the chapter's end, or an ending that hands no question to the next chapter. A slow passage that
   plants a set-up the chain tracks is noted as planting, not as drag. *Complete when:* each pattern
   has been tested and every hit is tied to the sections that show it.

4. **Report, and change nothing.** Deliver the measures as a table
   (`Section · Words · Scene or sequel · Outcome · Tension · Notes`), then the findings, the
   heaviest first:
   `# · Where · What the measures show · Why it matters to the reader · Question for the author`.
   Name the procedure that would own each fix (an adapt or improve pass on a section, a re-plan of
   the brief, a structural question for the whole book). Offer no rewritten text. *Complete when:*
   the report is delivered and nothing in the chapter or its plan has been edited.

5. **Record each answer, then hand the gate back.** The author answers each finding: accepted (and
   routed to its procedure), declined with a reason, or deferred to a later pass. Record a declined
   or deferred item, with its reason and the date, in the brief's `## Draft notes`, so the next pass
   does not raise it again. Gate V6.2 passes when every item has an answer; report the result to the
   review workflow, which dates the gate. *Complete when:* every finding carries a dated answer and
   the review workflow has the result.

## Anti-patterns

- **Cutting or merging.** Pacing reports; the author decides what goes, and a cut goes through the
  content layer's revision workflows.
- **Treating slow as wrong.** A quiet chapter after a violent one may be exactly the sequel the book
  needs. Measure against the brief's job for the chapter, not against speed.
- **Judging by word count alone.** A long section in which the outcome changes everything is not
  slow; a short one in which nothing changes is.
- **Reporting whole-book structure.** Chapter order, act shape and the book's overall rhythm belong
  to `structure-review`; this report stays inside its chapter.
- **Rating tension without a reason.** A number with no sentence behind it cannot be answered.
- **Restating the method.** Cite rule 3 of the method standard; do not lecture the author on scene
  and sequel.

## Cross-references

- `manuscript/docs/reference/scene-craft.md` — the craft the measures come from.
- `planning/src/outline.md` — where the chapter sits in the book.
- `.claude/skills/causality/SKILL.md` — whether each beat has a cause, gate V4.2.
- `.claude/skills/character-voice/SKILL.md` — the other line-edit gate, V6.1.
- `.claude/skills/flow/SKILL.md` — transitions and rhythm inside and between sections.
- `.claude/skills/structure-review/SKILL.md` — pacing across the whole book.
- `.claude/skills/improve-section/SKILL.md` — where an agreed tightening is proposed and made.
