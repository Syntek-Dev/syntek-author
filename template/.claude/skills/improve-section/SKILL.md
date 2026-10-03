---
name: improve-section
description: >-
  The author drafted the section; propose improvements as a numbered diff, each change with its
  location, before and after, and a one-line reason, at the strength the author chooses: light
  (clarity, typos, slips), edit (rhythm, joins, order within the section) or rework (restructure,
  with the argument, the events or the obligations intact). Report first; apply only what the
  author accepts; log every accept and every reject in the section's ledger entry. Never alters
  a figure, date, citation key, quotation or commitment. Use when the author says 'I've written
  section 3, can you improve it?', 'give this a light edit', 'tighten my draft', 'what would you
  change here?' or 'rework this, but keep my argument'. Not for revising an AI draft from the
  author's notes (`adapt-section`). Not for a first draft (`draft-section`). Not for a whole-unit
  review (`structure-review`). Not a proofreading report (`grammar`, `spelling`).
---

# Skill: Improve Section (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

<%AUTHOR_FIRST_NAME%> wrote this section; the AI's job is to make it more itself, not more like
the AI. Every suggestion is a numbered proposal the author can accept or refuse one by one, at a
strength the author chose, with a reason short enough to judge at a glance. Nothing changes in the
file until the author has answered, and every answer, yes or no, goes into the ledger: a refused
suggestion is the clearest evidence of the author's voice there is.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/03-improve-your-draft/` — this skill is that procedure in skill
  form; the mode file names its path.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `.claude/rules/syntek-author/03-authorship.md` Section 6 — suggest, do not rewrite; preserve
  deliberate oddities.
- `.claude/rules/syntek-author/06-global-rules.md` Section 7 — proofreading is supportive, and a
  report.
- `standards/style/voice-notes.md` (its `## Learned` section above all),
  `standards/style/style-sheet.md` and `standards/style/terminology.md`.
- `standards/method/method.md` and its mode file — before cutting a hedge that may be doing
  honest work.
- `standards/style/ledger/CONTEXT.md` — the decision table every proposal is logged in.
- The content layer's `docs/reference/drafting-with-ai.md` and `docs/reference/section-anatomy.md`.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Put the draft on record.** Find the section in the unit's drafts folder. If the author pasted
   it in chat or wrote it without frontmatter, save it as `<NN>-<section-slug>.md` with the
   frontmatter in the content layer's `docs/reference/section-anatomy.md` (`status: author-draft`,
   `origin: author`), after checking nothing will be overwritten. If it has no ledger entry,
   create one with `origin: author` and `## AI original` left empty.
   *Complete when:* the draft and its ledger entry exist, and nothing was overwritten.

2. **Agree the strength.** Ask which strength the author wants: `light` (clarity, typos, slips),
   `edit` (rhythm, sentence order, the joins between paragraphs) or `rework` (restructure, keeping
   the section's one job and its substance). If the author names none, recommend `light`, say so,
   and work at `light` unless they choose otherwise.
   *Complete when:* the strength is named in the conversation.

3. **Read the brief, the voice and the neighbours.** Read the section's purpose in the unit brief,
   `standards/style/voice-notes.md`, the terminology, the author's samples and the sections either
   side. Read the ledger's earlier decisions, so a change the author has already refused is not
   proposed again. Then read the draft: does it do its one job? At `light` and `edit`, anything
   promised and missing, or present and unasked-for, becomes a one-line note, not a proposal.
   *Complete when:* the draft is read against its brief, and those notes are written down.

4. **Structural pass (`rework`; `edit` only where the mode file allows).** Propose any reordering,
   merging or splitting of paragraphs that would let the section do its job better, keeping its
   substance intact, and apply the structural checks the mode file adds. Each proposal names what
   moves and why. At `light`, a structural concern stays a note.
   *Complete when:* each structural proposal names what moves and why, or the strength rules the
   pass out.

5. **Line pass (`edit` and `rework`).** Run-ons, comma splices, sprawl, flat joins, repetition, and
   any line that leaves the section's register (the mode file says which registers apply). Keep the
   author's voice markers, deliberate fragments and dialect, and any hedge doing honest work (check
   `standards/method/method.md` before proposing a cut). Propose only where the text falls short of
   its own voice, never where it differs from how the AI would write it.
   *Complete when:* every line proposal has a reason grounded in the text, not in taste.

6. **Mechanics pass (every strength).** Run `grammar` and then `spelling` against the style sheet
   and the terminology: spelling, homophones, doubled words, punctuation, single quotation marks,
   dates, one sentence per line. Report what and where, offer each correction, and group
   recurring items so one answer settles them all. Nothing is changed yet.
   *Complete when:* the mechanics report is grouped and every item has its correction.

7. **Present the numbered diff.** One numbered proposal per change: its location, the line before,
   the line after, a one-line reason and its strength. List separately, as questions and never as
   proposals, anything outside the lane: a figure, a date, a citation key, a quotation, a
   commitment, and whatever else the mode file adds. Ask the author to accept all, none, or by
   number, and wait.
   *Complete when:* the author has the diff, the questions and the mechanics report, and has
   answered.

8. **Apply only what the author accepts.** Apply exactly the accepted proposals and corrections and
   nothing else, keeping one sentence per line. Never change meaning while changing form. If two
   accepted changes collide, ask.
   *Complete when:* the draft differs from step 1's text only by the accepted changes.

9. **Log every decision.** Add every proposal to the ledger entry's `## Improvement decisions`
   table: number, proposal, reason, `accepted` or `rejected`, and the author's own words where
   they gave a reason. Set `status: improved` (or leave the status as it was if nothing was
   accepted), set `last_updated`, and mirror the status in the brief's `sections:` list. If the
   unit is still `outlined`, the author's first draft moves it to `draft` (no gate of its own).
   *Complete when:* the table holds a row for every proposal, accepted or rejected.

10. **Hand back.** Report how many proposals were accepted and rejected, the questions still open,
    the notes from step 3, and every flag in the draft. Offer the next move: another pass at a
    different strength, or approval for promotion.
    *Complete when:* the author has the report, and the draft is still in its drafts folder.

## Anti-patterns

- Editing the draft before the author has answered the diff.
- Rewriting a sentence the author would not recognise as theirs, at any strength.
- Proposing a change because the AI would phrase it differently; 'different' is not 'better'.
- Sterilising the voice: cutting a fragment, a dialect word, a coined word or a repetition that is
  doing work.
- Tidying away a hedge that is doing honest work.
- Slipping a figure, date, citation key, quotation or commitment into the diff as if it were
  style.
- Remarking on the author rather than the text.
- Logging the accepted proposals and dropping the rejected ones.

## Cross-references

- `adapt-section` — revising an AI draft from the author's notes, with alternatives.
- `grammar` and `spelling` — the mechanics pass, reported, never silently applied.
- `promote-section` — the next move once the author approves the section.
- `learn-voice` — mines the decisions this skill logs; rejections teach it most.
- `structure-review` — the whole-unit structural review, which this skill does not replace.
- `standards/style/ledger/` — the entries, one per section.
