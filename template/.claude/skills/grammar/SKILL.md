---
name: grammar
description: >-
  Check the grammar and punctuation of a section, a unit or any passage against the project's style
  sheet, and report it supportively: agreement, tense and person, sentence boundaries, pronoun
  reference, misplaced modifiers, parallel lists, and punctuation in the house style (single
  quotation marks with double inside, the style sheet's rules for dashes, commas and closing marks,
  one sentence per line in src/ files). Recurring items are grouped, each correction is offered
  with its reason, and nothing is applied until the author accepts it; deliberate fragments,
  dialect and a character's voice are respected. Use when the author says 'check the grammar',
  'proofread the punctuation', 'is this sentence right?', 'sort out the commas' or 'tidy the
  quotation marks', or at the line-edit stage of a review. Not spelling (`spelling`), not whether
  the reader can follow it (`comprehension`), not transitions and rhythm (`flow`), and not
  rewording for style (`improve-section`).
---

# Skill: Grammar (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A supportive grammar and punctuation report, not a rewrite. It names what and where, offers the
correction with the rule behind it, groups recurring items, and changes nothing until the author
accepts it. It comments on the text, never on the person who wrote it. It holds the text to the
house style and to grammar, not to superstitions: a split infinitive, a sentence that begins with
'and' or 'but', or one that ends with a preposition is not an error in British English.

## Governing procedures (route here — do not restate at length)

These own the rules; this skill applies them and cites them.

- The content layer's review workflow, step 'Grammar' (the mode file names it) — part of gate V6
  (`line-edit → final`) in `standards/verification/verification.md`.
- `standards/style/style-sheet.md` — Punctuation, Numbers, Dates and times: the project's
  decisions, which override this skill's defaults.
- `.claude/rules/syntek-author/06-global-rules.md` Sections 1, 5 and 7 — the locale, one sentence
  per line in `src/` only, and proofreading that is supportive and a report.
- `.claude/rules/syntek-author/03-authorship.md` Section 6 — suggest, do not rewrite; preserve
  deliberate oddities.
- `standards/style/ledger/CONTEXT.md` — where accepted and declined corrections are logged.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Fix the scope and read the house style.** Name what is being checked. Read
   `standards/style/style-sheet.md`, the registers and the `## Learned` section of
   `standards/style/voice-notes.md`, and the internal note of the file being checked. Where the
   style sheet is silent, the house defaults in `.claude/rules/syntek-author/06-global-rules.md`
   Section 1 apply.
   *Complete when:* the scope is named and every house decision that applies to it is in hand.

2. **Run the mechanical check.** `make lint SCOPE=<path>` reports lines in `src/` files that hold
   two sentences, and the further checks the mode file names. Report a two-sentence line as a
   finding, but fix line breaks only inside a paragraph whose correction the author accepts: never
   reflow a whole file.
   *Complete when:* the lint output for the scope has been read and its findings carried into the
   report.

3. **Read every sentence for grammar.** Subject and verb agreement; tense held within a passage;
   person held (I, we, you); pronouns whose reference is unclear; dangling and misplaced modifiers;
   run-on sentences and comma splices; fragments; lists whose items do not each complete their
   lead-in; a sentence that loses its subject.
   *Complete when:* every sentence in scope has been read once, notes included, not sampled.

4. **Read every mark of punctuation.** Quotation marks (single, with double inside single) and the
   position of punctuation at a closing mark; apostrophes; hyphens, en dashes in ranges and dashes
   as the style sheet sets them; commas, including the serial comma as the style sheet settles it;
   colons, semicolons, brackets and ellipses; numbers, dates and times in one format.
   *Complete when:* every mark in scope has been checked against the style sheet or its default.

5. **Set aside what is deliberate.** A fragment for rhythm, dialect grammar, a register the voice
   notes record, a repetition doing work, and any deviation recorded in the internal note are not
   errors. A feature that might be deliberate and is not recorded is asked about once, as a
   question, never listed as a mistake.
   *Complete when:* each finding is marked error, house-style inconsistency, or question.

6. **Group and report.** One report: errors first, then inconsistencies with the house style, then
   questions. Group recurring items; give each its location (file, section, line), the text as
   written, the correction offered and the rule in a phrase. Where a recurring choice is not yet
   settled (the serial comma, a dash, words or figures for numbers), propose a style-sheet entry
   for the author to approve; never write one unasked.
   *Complete when:* the author has the report, and every item has a location, an offered
   correction and its reason.

7. **Apply only what is accepted.** The author accepts or declines by item or by group. Each
   accepted correction goes by the route the content layer's review workflow sets for it (the mode
   file says which corrections may be applied directly and which go back through the section's own
   procedures), and every decision, declined ones included, is logged as a row in the section's
   ledger entry. Never apply a correction in passing, and never change meaning while correcting
   form.
   *Complete when:* every accepted correction is applied or routed, every decision is logged, and
   nothing else changed.

## Anti-patterns

- **Rewriting a sentence to fix a comma,** or tidying an untouched line while applying an accepted
  correction.
- **Correcting a deliberate fragment, a dialect form or a character's grammar.**
- **Enforcing a rule the house does not hold:** the split infinitive, the closing preposition, the
  opening 'and' or 'but', or double quotation marks for the house style.
- **Mass reflow** of a file to one sentence per line; only a paragraph being corrected is broken.
- **A silent fix,** or one the author did not accept.
- **A remark about the writer,** or a question about why errors happen.
- **Changing a word that carries meaning to fix grammar:** a hedge, a modal verb, a defined term, a
  first-person marker. Report it instead; the mode file names the ones that matter most here.

## Cross-references

- `.claude/skills/spelling/SKILL.md` — the spelling pass that follows this one.
- `.claude/skills/flow/SKILL.md` — transitions and rhythm, the pass before this one.
- `.claude/skills/learn-voice/SKILL.md` — learns from the corrections the author declines.
- `.claude/skills/improve-section/SKILL.md` — where a correction that needs rewording is made.
- `standards/style/voice-notes.md` — the registers and the deliberate features already recorded.
