---
name: flow
description: >-
  Report on how a section, a unit or a run of units reads from one sentence to the next:
  transitions, paragraph order, rhythm and sentence variety, repetition of words, ideas and
  examples, and above all one voice across sections drafted at different times, in a different
  order or by different hands (the author's and the AI's). Reads the seams between sections first.
  Report only, by location, with a suggestion for each finding; the author decides every change.
  Use when the author says 'does this flow?', 'it feels choppy', 'check the joins between
  sections', 'does it sound like one writer?', 'am I repeating myself?' or 'read it for rhythm',
  or at the line-edit stage of a review. Not whether the reader can follow it (`comprehension`),
  not grammar and punctuation (`grammar`), not the unit's structure or argument
  (`structure-review`), and not a rewrite of the passage (`improve-section`).
---

# Skill: Flow (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Sections are drafted one at a time, out of order, some by the AI and some by the author, and
promoted into the unit at their markers. Each can pass its own checks and the unit can still read
as a patchwork. This pass reads the unit as one piece: the joins, the order, the rhythm, the
repetitions, and whether it sounds throughout like the author described in the voice notes. It
reports and suggests; it changes nothing, and it never smooths the author's voice towards a
generic one.

## Governing procedures (route here — do not restate at length)

These own the rules; this skill applies them and cites them.

- The content layer's review workflow, step 'Flow' (the mode file names it) — part of gate V6
  (`line-edit → final`) in `standards/verification/verification.md`.
- `standards/style/voice-notes.md` — the voice every section is held to, including `## Learned`.
- `standards/style/terminology.md` — one term, one sense, across every section.
- `.claude/rules/syntek-author/03-authorship.md` Section 6 — suggest, do not rewrite; preserve
  deliberate oddities, including a repetition doing work.
- `standards/style/ledger/CONTEXT.md` — each section's origin and promotion date, which locate the
  seams.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Fix the scope and read the voice.** Name what is being read. Read
   `standards/style/voice-notes.md` (the marks, the registers, `## Learned`), the unit brief's
   sections and their purposes in plan order, and, for each section, its ledger entry's `origin`
   and `promoted` date. Those tell you where the seams are and which sections were written apart.
   *Complete when:* the voice notes are read and every section in scope is listed with its origin
   and date.

2. **Read the seams first.** At every boundary between sections (the section markers in the unit
   file), read the last paragraph before it and the first after it together. Does the second follow
   from the first? Is a person, a term or a set-up introduced twice? Does the tense, person,
   register, terminology or cadence change at the join?
   *Complete when:* every seam in scope has been read and its findings noted.

3. **Read the transitions and the order.** Within each section and across the unit: does each
   paragraph follow from the one before; is there a paragraph that belongs elsewhere (name where);
   is a transition word doing no work ('moreover', 'furthermore'), or is one missing where the
   reader needs to know how two paragraphs relate?
   *Complete when:* every paragraph in scope has been read for its link to the one before.

4. **Read for rhythm.** Sentence length and shape: runs of sentences built the same way, a
   paragraph of uniformly long or short sentences, the same paragraph ending used again and again.
   Read the opening and closing paragraphs of the unit, and any passage the voice notes single out,
   as if aloud.
   *Complete when:* the rhythm of every section has been read, and each pattern found is noted with
   its locations.

5. **Find the repetition.** A word or phrase repeated close together (unless it is a deliberate
   refrain); the same idea, example or anecdote used in two sections, which drafting out of order
   produces; a fixed term drifting into near-synonyms, or a near-synonym standing for a fixed term.
   *Complete when:* every repetition found is recorded with all its locations, and each is marked
   accident or possible refrain.

6. **Check one voice.** Hold every section to the voice notes: the marks, the person and tense, the
   register. Compare sections of different origin and date: where one sounds unlike the author's
   own sections, say how, citing the voice note it departs from. The mode file adds what one voice
   means here.
   *Complete when:* every section has been compared with the voice notes and with its neighbours.

7. **Report and hand back; change nothing.** One report: **blocking** (a seam that misleads, a
   contradiction of tone the reader will notice), **friction**, **polish**; each with its location,
   the passage quoted briefly, what happens to the reader, a suggestion in a phrase, and the
   procedure that owns the fix. Hand the mode file's items to their owners. The author answers each
   finding; V6 needs every item answered. Accepted changes are made through the section procedures,
   as the content layer's review workflow sets out.
   *Complete when:* the author has the report, every finding has a location and an owner, and
   nothing in the work was changed by this pass.

## Anti-patterns

- **Rewriting for rhythm.** A suggestion names the problem and the kind of fix; the sentence is the
  author's.
- **Smoothing the voice.** Sanding a distinctive sentence into a generic one, or treating the
  AI-drafted sections as the standard the author's own must meet. The author's sections, and the
  voice notes drawn from them, are the standard.
- **Flagging a refrain,** a deliberate repetition, or the repetition of a fixed term where a
  synonym would change the meaning.
- **Reading section by section and missing the seams,** which are where drafting out of order shows.
- **Judging structure or argument.** A section in the wrong place in the outline is
  `structure-review`'s; a reader who cannot follow is `comprehension`'s.
- **A silent change,** or a pass that reports 'flows well' without saying what it checked.

## Cross-references

- `.claude/skills/comprehension/SKILL.md` — the pass before this one.
- `.claude/skills/grammar/SKILL.md` — the pass after this one.
- `.claude/skills/learn-voice/SKILL.md` — turns what the author accepts and declines into voice
  notes.
- `.claude/skills/improve-section/SKILL.md` — where an agreed change to a section is made.
- `standards/verification/verification.md` — V6, which needs every item in this report answered.
