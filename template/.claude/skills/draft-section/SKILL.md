---
name: draft-section
description: >-
  Draft ONE section of a planned unit (typically 300–500 words: one argument step, one scene
  beat, one clause group) from its brief, in the author's voice, into the unit's drafts folder,
  with every unchecked claim and open decision flagged, and open the section's ledger entry
  with the AI original verbatim. Use when the author says 'draft the next section', 'write the
  scope section', 'have a go at section 3', 'draft the-turn for me', 'start chapter 4' or 'give
  me a first draft of the fees clause'. Never more than one section per request unless the
  author asks for more. Not for revising an existing draft from notes or edits
  (`adapt-section`). Not for suggestions on a section the author wrote (`improve-section`). Not
  for moving an approved draft into the unit (`promote-section`). Not for planning a unit or
  settling what a section is for (`grill-with-docs`).
---

# Skill: Draft Section (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The first move of the authoring loop: the AI drafts **one** section and <%AUTHOR_FIRST_NAME%>
decides what happens to it. A section is small on purpose: small enough to judge every sentence,
and small enough for the ledger's comparison of the AI original with the author's final text to
mean something. The draft lands in the unit's drafts folder, never in the unit itself, and its
ledger entry records the AI's words verbatim from the first minute, so that disclosure later is a
fact rather than a recollection.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/01-draft-a-section/` — this skill is that procedure in skill
  form; the mode file names its path. Run its `STEPS.md` with `CHECKLIST.md` open.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `.claude/rules/syntek-author/03-authorship.md` — section size (Section 3), never fabricate
  (Section 4), the two flags (Section 5) and provenance (Section 8).
- `standards/method/method.md` and its mode file — evidence before prose, and the doc-type method.
- `standards/style/voice-notes.md`, `standards/style/style-sheet.md`,
  `standards/style/terminology.md` and `standards/style/samples/` — the voice and the mechanics.
- `standards/style/ledger/CONTEXT.md` — the exact format of the ledger entry this skill opens.
- `standards/verification/verification.md` — `outlined → draft` has no gate of its own (V1 still
  holds); it happens when the unit's first section is drafted.
- The content layer's `docs/reference/section-anatomy.md` (the draft file and its frontmatter) and
  `docs/reference/drafting-with-ai.md` (the loop and the record).

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Fix the section.** Confirm the unit and the section with the author. 'The next section' is
   the first entry in the brief's `sections:` list, in order, that is neither promoted nor
   drafted. The file is `<NN>-<section-slug>.md`, `<NN>` being the section's `order`, two digits.
   If the unit has no brief in `planning/src/units/`, or the brief does not list the section,
   stop: the plan comes first (`planning/workflows/01-plan-a-unit/`). If the brief's status is
   `idea` (V1 not dated), stop: the brief is not agreed. If the section's purpose is too thin to
   draft from, settle its one job with `grill-with-docs` before going on.
   *Complete when:* the unit, the section slug, its order and the filename are confirmed.

2. **Read the plan, the voice and the method.** Read the brief whole: its scope, what the unit
   does, its sections, its settled-positions section, what it draws on and its draft notes. Read
   `standards/style/voice-notes.md` (its `## Learned` section above all), the samples, the style
   sheet and the terminology, then `standards/method/method.md` with its mode file. Read the
   sections either side of this one, promoted or drafted, so the new one joins them.
   *Complete when:* each of these is read, and an empty samples folder is noted for the hand-back.

3. **Gather the material first.** List what the section needs (sources, evidence, readings,
   established facts) and read each from `research/src/` and the plan, never from memory. If
   something the mode file requires before drafting is missing, stop and name the procedure that
   makes it; never draft around the gap.
   *Complete when:* everything the section needs is in hand, or the run has stopped on what is not.

4. **Check every claim before drafting.** Run each checkable claim the section will make through
   `fact-check`, which files its verdict in `research/src/evidence/`. A claim that cannot be
   checked now goes into the draft carrying `VERIFY`, or stays out; decide which against the
   brief. Never write a quotation, figure, date or reference from memory.
   *Complete when:* every claim has a verdict, or a decision to flag it or leave it out.

5. **Confirm nothing will be clobbered.** Check that neither the draft nor its ledger entry
   (`standards/style/ledger/<unit-slug>--<section-slug>.md`) exists, and that the unit holds no
   text for this section. If any does, stop and ask. A **redraft** (the author asked for the
   section to be drafted again, often from `adapt-section` step 4) replaces the draft file only
   on the author's word, and keeps its ledger entry (step 9). Create the unit's drafts folder if
   it is missing, with whatever else the mode file says a new unit needs.
   *Complete when:* both paths are free, or the author has confirmed a redraft over them, and the
   drafts folder exists.

6. **Draft the one section.** Write the frontmatter: `unit`, `section`, `order`,
   `status: ai-draft`, `origin: ai`, `words_target` (from the brief, or 400), `ledger` (the entry's
   path) and `last_updated`. Then the body: the section's one job, near its target, one sentence
   per line, in the voice of the notes and the samples, joining the sections either side. Apply
   the mode file's additions. Draft nothing beyond this section unless the author asked for more.
   *Complete when:* one draft file exists, doing the job the brief gives it, within 300–500 words
   unless the brief sets another target.

7. **Flag what is unchecked or undecided.** Put `<!-- VERIFY: … -->` at each claim not yet
   checked, saying what needs checking, and `<!-- AUTHOR TO CONFIRM: … -->` at each decision only
   the author can make, worded so it can be answered cold. Cite only citation keys that already
   exist (`[@authorYYYY]`) where the project keeps a citation database; never invent one. A
   deviation the author has authorised goes in `<!-- INTERNAL NOTE: … -->` under the frontmatter.
   *Complete when:* nothing uncertain in the draft reads as settled.

8. **Proofread your own text.** Run `spelling` over the draft (and `grammar`, where the mode file
   says) against the style sheet and the terminology, and apply the fixes directly: it is still
   the AI's text, and the author should be shown its best version.
   *Complete when:* the pass reports nothing left to fix.

9. **Open the ledger entry.** Create it in the format `standards/style/ledger/CONTEXT.md` gives:
   frontmatter `unit`, `section`, `origin: ai`, `drafted` (today, DD/MM/YYYY), empty `promoted`
   and `change_ratio`, and `learned: false`; under `## AI original`, the draft's body (everything
   below its frontmatter) exactly as it is handed back; `## Author final` empty; and
   `## Improvement decisions` holding only the table's two header rows. If the section's entry
   already exists (a redraft), move its `## AI original` text verbatim into a dated HTML comment
   (`<!-- superseded AI original, DD/MM/YYYY: … -->`) at the end of that section, writing each
   `-->` inside it as `--&gt;` so the comment cannot close early, and write the new draft as the
   live AI original; keep every decision row, and never open a second entry. Otherwise never
   edit the AI original afterwards, not even to correct it.
   *Complete when:* the entry exists, exactly one per section, and its live AI original matches
   the draft's body character for character.

10. **Update the brief and hand back.** Set the section's status in the brief's `sections:` list
    to `ai-draft`. If the unit's `status:` was `outlined` (V1 held), this first section moves it:
    set `status: draft`. `outlined → draft` has no gate of its own, so nothing is dated. Report
    the draft's path and its word count against the target, every flag with its question, the
    sources used, anything left unchecked, any step waived and why, and the author's options:
    notes (`adapt-section`), their own edits, or approval for promotion (`promote-section`).
    *Complete when:* the author has the report, and the draft is still in its drafts folder.

## Anti-patterns

- Drafting the next section too because it 'flows on' from this one. One section per request.
- Writing a quotation, verse, statute, price, date or source from memory, however sure it feels.
- Filling a gap with plausible prose instead of a flag. A fluent invention survives every later
  pass; a visible gap gets filled.
- Tidying the AI original in the ledger after the draft is handed back: it falsifies the
  disclosure and teaches `learn-voice` nothing.
- Writing into the unit file, or promoting because the author said the draft 'looks fine'.
- Overwriting an existing draft or ledger entry because it 'looked stale', or opening a second
  entry for a redraft.
- Imitating a voice borrowed from elsewhere. With no samples, say the voice is a guess.
- Shortening the work by dropping something the brief asked the section to do.

## Cross-references

- `adapt-section` and `improve-section` — the author's next move on the draft.
- `promote-section` — the only way the draft reaches the unit, on the author's word.
- `fact-check` and `research` — checking claims and gathering material before a word is drafted.
- `spelling` and `grammar` — the proofreading pass in step 8.
- `grill-with-docs` — settling a section's job when the brief is too thin.
- `learn-voice` — mines the ledger entry this skill opens, once the section is promoted.
- `tooling/provenance.py` — reads the ledger entry; `make provenance` prints the disclosure table.
- `planning/src/units/` — the briefs; `research/src/evidence/` — the verdicts behind each claim.
