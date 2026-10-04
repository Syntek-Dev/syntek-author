---
name: comprehension
description: >-
  Read a section, a unit or the whole work as its stated reader (the audience and reader test in
  00-project.md ## Brief, narrowed by any reader a unit brief names) and report, by location, where
  that reader would stumble: an undefined or unexplained term, a leap they must make alone,
  knowledge the text assumes, a point buried under its qualifications, lost orientation, a sentence
  they would have to read twice. Report only, most serious first, each with a suggested remedy; the
  author decides every change. Use when the author asks 'will my reader follow this?', 'is this too
  technical?', 'read it as a client would', 'where would someone get lost?' or 'does this assume too
  much?', or at the line-edit stage of a review. Not grammar or spelling (`grammar`, `spelling`),
  not transitions and rhythm (`flow`), and not whether the structure or the argument holds
  (`structure-review`).
---

# Skill: Comprehension (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Read the work as the person it is written for, not as its author and not as an expert, and report
every place that person would slow down, stop or misread. The reader is named once, in
`00-project.md` `## Brief`; this skill never restates them in its own words. It reports and
suggests; it changes nothing. It never makes the work simpler than its reader needs: a term the
stated audience already owns is not a finding.

## Governing procedures (route here — do not restate at length)

These own the rules; this skill applies them and cites them.

- The content layer's review workflow, step 'Comprehension' (the mode file names it) — part of gate
  V6 (`line-edit → final`) in `standards/verification/verification.md`.
- `.claude/rules/syntek-author/00-project.md` `## Brief` — the audience and the reader test this
  pass reads as.
- `standards/style/terminology.md` — the terms the work uses in a fixed sense.
- `planning/src/units/` — each unit brief's `audience_note`, which narrows the reader for one unit.
- `standards/method/method.md` and its mode file — what the work must say plainly in the body.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Fix the scope and the reader.** Name what is being read. Read `00-project.md` `## Brief` (the
   audience and the reader test) and, for a unit, the unit brief's `audience_note`, which narrows
   the reader for that unit and wins for it. Write the reader at the head of the report in one
   sentence, taken from those files, not invented. Then establish what this reader has already been
   told: the units before this one in reading order (`planning/src/outline.md`), not in the order
   they were drafted.
   *Complete when:* the reader is stated from its source, and the reading order before the scope
   is known.

2. **Read once straight through, as the reader.** No notes beyond a mark at every place the reader
   would stop, go back, or lose the thread. Read in the order the reader will, footnotes and
   sidebars where they fall.
   *Complete when:* the first reading is finished and every stumble is marked by location.

3. **Check the terms.** Every technical term, abbreviation, acronym, piece of jargon and in-group
   word: is it defined or glossed at its first appearance in reading order, in words the reader can
   use; is it used in one sense throughout, as `standards/style/terminology.md` fixes it; is a term
   the reader will not know used where a plain word would do?
   *Complete when:* every such term in scope is either known to this reader, glossed in time, or
   recorded as a finding.

4. **Check the line of thought.** Leaps (a step the reader must supply alone); assumed knowledge (a
   person, event, text, process or earlier argument the reader has not been given); a point buried
   under its qualifications or at the end of a long paragraph; a reference back to something the
   reader has not yet read, which drafting out of order produces; a conclusion that arrives before
   its reason, where the reader needs the reason first.
   *Complete when:* each paragraph's point can be stated in a sentence, and every place it cannot
   is a finding.

5. **Check orientation and load.** At the start of each section the reader knows where they are
   and why; no sentence must be read twice (stacked clauses, long chains of nouns, double
   negatives); no figure must be worked out by the reader to follow the point; the mode file's
   orientation rule holds.
   *Complete when:* every section opening and every marked stumble has been checked for
   orientation and load.

6. **Report by location.** One report: the reader in one sentence; then **blocking** (the reader
   would stop or misread), **friction** (they would slow down), **polish**. Each finding: location
   (file, section, line), the passage quoted briefly, what the reader lacks, a suggested remedy (a
   gloss, a reorder, a split, a sentence brought up from a note), and the procedure that would make
   it. Say briefly what works, and what was checked: a report that finds nothing must say what it
   looked for.
   *Complete when:* the author has the report, and every finding has a location, the reader's need
   and a remedy.

7. **Hand back; change nothing.** The author answers each finding (accepted or declined); V6 needs
   every item answered. Accepted remedies are made through the section procedures, as the content
   layer's review workflow sets out; a term the author settles is recorded in
   `standards/style/terminology.md` through `grill-with-docs`, never by this skill.
   *Complete when:* the author has answered every finding, and nothing in the work was changed by
   this pass.

## Anti-patterns

- **Reading as an expert, or as the author,** who knows what every sentence means because they
  meant it.
- **Talking down.** Flagging a term the stated audience owns, or recommending a gloss that insults
  the reader's intelligence.
- **Inventing the reader.** The reader comes from `00-project.md` `## Brief` and the unit brief,
  never from this skill's idea of a typical reader.
- **Rewriting.** A remedy is suggested in a phrase; the wording is the author's.
- **Judging the argument.** Whether a claim is right or the structure holds is
  `structure-review`'s; this pass asks only whether the reader can follow it.
- **Reading in drafting order.** The reader meets the units in the outline's order; what an earlier
  unit has not yet said, the reader does not know.

## Cross-references

- `.claude/skills/flow/SKILL.md` — transitions and rhythm, the pass after this one.
- `.claude/skills/structure-review/SKILL.md` — whether the order and the argument hold.
- `.claude/skills/grill-with-docs/SKILL.md` — records a term the author settles.
- `planning/src/outline.md` — the reading order.
- `standards/verification/verification.md` — V6, which needs every item in this report answered.
