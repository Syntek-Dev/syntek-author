---
name: spelling
description: >-
  Check the spelling of a section, a unit or any passage against British English (en_GB), the
  project's style sheet and its terminology, and report it supportively: what and where, the
  correction offered, recurring items grouped so one decision fixes many, and nothing applied until
  the author accepts it. Finds misspellings, US spellings, homophones (practice and practise,
  their and there), transposed letters, doubled words, one word spelt two ways, capitals against
  the house list, and near-misses of the project's own names and terms. Use when the author says
  'spell-check this', 'proofread chapter 2', 'any typos?', 'check the spelling before I send it'
  or 'have I spelt the names consistently?', or at the line-edit stage of a review. Owns
  'proofread …': for a proofread, run `grammar` first, then this pass, and deliver one report.
  Not grammar and punctuation alone (`grammar`), not whether the reader can follow it
  (`comprehension`), and not rewording a passage (`improve-section`).
---

# Skill: Spelling (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A supportive spelling report, not a rewrite. It says what and where, offers the correction, groups
recurring items, and changes nothing until the author accepts it. It comments on the text, never on
the person who wrote it, and asks no question about why an error was made. This is the default for
every author. The style sheet and the terminology win over every default this skill holds.

## Governing procedures (route here — do not restate at length)

These own the rules; this skill applies them and cites them.

- The content layer's review workflow, step 'Spelling' (the mode file names it) — part of gate V6
  (`line-edit → final`) in `standards/verification/verification.md`.
- `.claude/rules/syntek-author/06-global-rules.md` Sections 1 and 7 — the locale, and proofreading
  that is supportive and a report.
- `standards/style/style-sheet.md` and `standards/style/terminology.md` — the project's own
  decisions, which override this skill's defaults.
- `.claude/rules/syntek-author/03-authorship.md` Section 6 — suggest, do not rewrite; preserve
  deliberate oddities.
- `standards/style/ledger/CONTEXT.md` — where accepted and rejected corrections are logged.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Fix the scope and read the house list.** Name what is being checked: a section draft, a unit,
   or a passage the author pasted. If the author asked to proofread it, run `grammar` over the
   same scope first, up to its report, and carry its findings into step 6 (accepted grammar items
   are applied and logged as `grammar` says). Read `standards/style/style-sheet.md` (Spelling,
   Capitalisation, Project settings), `standards/style/terminology.md`, the `## Learned` section
   of `standards/style/voice-notes.md`, and the internal note of the file being checked, which
   records any authorised deviation.
   *Complete when:* the scope is named, every house decision that applies to it is in hand, and
   for a proofread the grammar findings are ready.

2. **Build the known-word list.** Every term in `standards/style/terminology.md` in its exact form,
   every spelling the style sheet settles, and the project's own words the mode file names. A word
   on this list is never reported as a misspelling, whatever a dictionary says.
   *Complete when:* the list is built and each of its sources is named in the report's opening.

3. **Run the mechanical pass, then read every line.** `make lint SCOPE=<path>` lists the en_US
   spellings it knows; it is a floor, not the check. Then read every line in scope, notes
   included: misspellings, US forms, homophones, transposed and missing letters, doubled words,
   one word spelt or hyphenated two ways, capitals against the house list, and numbers and dates
   written two ways. Quoted text keeps its source's spelling and is never corrected; a quotation
   that seems not to match its source goes to `fact-check`. Citation keys, file paths and markup
   are not prose.
   *Complete when:* every line in scope has been read once, start to end, not sampled.

4. **Check near-misses of the project's own words.** Compare each word that is neither standard
   English nor on the known-word list with every word on the list, by edit distance: the number of
   single-letter insertions, deletions or substitutions between them. Report a distance of 1, and a
   distance of 2 when both words have at least five letters, as 'did you mean …?'. The mode file
   says where the project's own words come from and what tooling helps.
   *Complete when:* every unknown word has been compared with the list, and each near-miss is
   recorded with the known word it is close to.

5. **Set aside what is deliberate.** Dialect, a coinage, a character's own misspelling, an archaic
   form in a quotation, a client's own spelling of its name, and any oddity recorded in the voice
   notes or the internal note are not errors. A feature that might be deliberate and is not
   recorded is asked about once, as a question in the report, never listed as a mistake.
   *Complete when:* each finding is marked error, house-style inconsistency, or question.

6. **Group and report.** One report, in this order: for a proofread, the grammar findings
   first; then inconsistencies with the house list, misspellings, near-misses and questions.
   Group every recurring item ('"practise" as a verb: five places, listed'); give each its
   location (file, section, line), the word as written and the correction offered. Where a
   recurring choice is not yet settled, propose a style-sheet or terminology entry for the author
   to approve; never write one unasked.
   *Complete when:* the author has the report, every item has a location and an offered
   correction, and no item is repeated outside its group.

7. **Apply only what is accepted.** The author accepts or declines by item or by group. Apply
   accepted corrections exactly, where the content layer's review workflow allows them to go (the
   mode file says where), and log each decision, declined ones included, as a row in the section's
   ledger entry. Never change meaning while correcting form, and never touch a line the author did
   not accept. An approved style-sheet or terminology entry is added dated, as that file says.
   *Complete when:* every accepted correction is applied and logged, every declined one is logged,
   and nothing else changed.

## Anti-patterns

- **A silent fix,** or a fix the author did not accept, or a tidy of an untouched line nearby.
- **Correcting what is not an error:** a quotation, a dialect spelling, a character's voice, a
  coined word, a name in the register, a proper name with its own spelling (the World Health
  Organization keeps its z).
- **Thirty separate findings for one recurring item.** Group it, and list the places.
- **A remark about the writer**: 'you often…', 'careless', a tally offered as a judgement, or any
  question about why a mistake happens.
- **Relying on `make lint` alone.** It knows a list; it does not read.
- **Writing a style-sheet or terminology entry without the author's approval.**
- **Correcting a figure or a date as a spelling slip.** Whether a number is right is
  `fact-check`'s; spelling reports only that it is written two ways.

## Cross-references

- `.claude/skills/grammar/SKILL.md` — grammar and punctuation, run just before this pass, and
  first in a proofread, whose one report this skill delivers.
- `.claude/skills/learn-voice/SKILL.md` — learns from the corrections the author declines.
- `.claude/skills/fact-check/SKILL.md` — quotations against their sources; figures and dates.
- `standards/style/voice-notes.md` — the deliberate features already recorded.
- `standards/verification/verification.md` — V6, which needs every item in this report answered.
