---
name: promote-section
description: >-
  On the author's explicit word, move one approved section from its drafts folder into the unit:
  check the section's gate and that it carries zero flags, insert it at its section marker in
  plan order, strip draft-only comments, record the author's final text and the change ratio in
  the ledger (python3 tooling/provenance.py), add the provenance row, set the section to
  promoted in the draft and the unit brief, and bring MEMORY.md Status up to date. Never moves
  the unit's own status. Use when the author says 'promote section 2', 'that one's ready, put it
  in the chapter', 'move the scope section into the proposal', 'yes, promote the-turn' or
  'approved, add it to the document'. A casual 'looks fine' is not the word: ask. Not for revising
  the draft first (`adapt-section`). Not for reviewing or finalising the whole unit
  (`structure-review`). Not for building a proof (`build`).
---

# Skill: Promote Section (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The only door from drafts into the work. A section crosses it on <%AUTHOR_FIRST_NAME%>'s explicit
word, with no open flag, into the place its unit's plan reserves for it, and the crossing is
recorded: the text the author approved, how far it moved from the AI's first draft, and when.
Promotion moves a section; it never moves the unit. A unit becomes `final` only through the review
workflow and the author's word.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/04-promote-a-section/` — this skill is that procedure in skill
  form; the mode file names its path.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `.claude/rules/syntek-author/03-authorship.md` — the two flags (Section 5), provenance and AI
  disclosure (Section 8), promotion and `final` (Section 9).
- `standards/verification/verification.md` — V2 (draft → structural-review), whose section-level
  terms (the author's word, zero flags, a complete ledger entry) every promotion meets, and
  Section 2 (no skill sets `final`).
- `standards/style/ledger/CONTEXT.md` and `standards/style/ledger/CLAUDE.md` — the entry, the
  register and the steps at promotion.
- The content layer's `docs/reference/section-anatomy.md`, `docs/reference/the-status-ladders.md`
  and `docs/reference/drafting-with-ai.md`.
- `.claude/rules/syntek-author/08-naming-and-memory.md` — how a `MEMORY.md` Status line is
  superseded, never deleted.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Confirm the author's word.** The author must name the section, or plainly confirm it when
   asked. A general request ('promote what's ready') or a casual one ('looks fine') gets a
   question naming each candidate: 'Promote `<section-slug>` into `<unit-slug>`?' Approval of an
   earlier version, or of another section, is not the word. Note whose word it was and when.
   *Complete when:* the author has named or confirmed this section, in words, in this session.

2. **Check the gate and the flags.** Run `make flags SCOPE=<the draft's path>` and read the draft
   for anything else the mode file names. Any flag stops the promotion: the author may settle an
   `AUTHOR TO CONFIRM` there and then (apply the answer, remove the flag, log it in the ledger); a
   `VERIFY` goes through `fact-check`, or the claim comes out, and the author confirms again.
   Confirm the draft's frontmatter is complete and its ledger entry exists with every key, then
   check any section gate `standards/verification/verification.md` and its mode file set. Never
   delete a flag to pass a gate.
   *Complete when:* the flags list for the draft is empty, and every check above passes.

3. **Find the unit file and the section's marker.** Locate the unit's file as the mode file
   describes, creating it from the brief if it does not yet exist: one marker per entry in the
   brief's `sections:` list, in the same order. If this section's marker is missing, or the
   markers disagree with the brief in name or order, stop and report; never guess which is right.
   If text already sits at the marker, this is a re-promotion: show the author exactly what will
   be replaced, and confirm.
   *Complete when:* the marker is found, in plan order, and any replacement is confirmed.

4. **Prepare the promoted text.** Take the draft's body without its frontmatter, without its
   internal note (unless the mode file moves it into the unit), and without every working comment
   the mode file marks as draft-only. Every word the author approved arrives, and nothing is added.
   Apply the mode file's conversion, if it has one.
   *Complete when:* the text is ready, and a word-by-word comparison with the draft's prose shows
   nothing added or lost.

5. **Insert it at the marker.** Put the text at the section's marker, as the mode file describes,
   ending before the next section's marker, with one blank line either side. Change nothing else
   in the file: never reflow, retitle or tidy another section while you are in it.
   *Complete when:* the section sits at its marker, and a diff of the unit file shows no other
   change.

6. **Record provenance.** In the ledger entry, put the promoted text under `## Author final` (the
   mode file says which form), set `promoted` to today (DD/MM/YYYY), then run
   `python3 tooling/provenance.py ratio <unit-slug>--<section-slug> --write`; for an author-drafted
   section it prints `n/a` and the ratio stays empty. Add or update the section's row in
   `standards/style/ledger/provenance.md` (Unit, Section, Origin, Change ratio, Promoted; an
   author-drafted section shows `—`), then run `python3 tooling/provenance.py check`. On a
   re-promotion, set the entry's `learned: false`, so `learn-voice` mines the new edits.
   *Complete when:* `check` reports no problems, the ratio came from the tool, never an estimate,
   and a re-promoted entry is unlearned.

7. **Update the statuses and memory.** Set the draft's `status: promoted` and `last_updated`; the
   draft stays in its drafts folder as the record of the section. Set the section's entry in the
   brief's `sections:` list to `promoted`. **Leave the unit's own `status:` where it is.** Bring
   the unit's line under `## Status` in `.claude/MEMORY.md` up to date (for example, 'three of
   five sections promoted'), superseding the previous line rather than deleting it. Apply any
   further records the mode file names.
   *Complete when:* the draft, the brief, the ledger, the provenance register and `MEMORY.md` all
   agree, and the unit's status has not moved.

8. **Read it in place.** Read the promoted section in the unit alongside its neighbours: does it
   join them? Report a seam rather than fixing it; joins are judged at review. Apply the mode
   file's proof step if it has one; otherwise a proof is optional and ungated (`build`).
   *Complete when:* the section has been read in place, and any seam is noted for the hand-back.

9. **Hand back.** Report what was promoted and on whose word, the change ratio, any seam noticed,
   and how many of the unit's planned sections remain. When every planned section is promoted,
   say so: V2 (draft → structural-review) can now be judged, with V3 (a proof of the whole unit)
   beside it, and the content layer's review procedure (the mode file names it) is the next move.
   *Complete when:* the author has the report, and nothing beyond this section changed.

## Anti-patterns

- Promoting on 'looks fine', on approval of a different version, or on silence.
- Promoting a section with a flag in it, or deleting the flag to get past the gate.
- Moving the unit's status, or calling the unit `final`, because the last section went in.
- Guessing where a section goes when the markers and the brief disagree.
- Tidying, reflowing or retitling another section while the unit file is open.
- Estimating a change ratio, or recording one by hand.
- Overwriting promoted text without showing the author what will be replaced.
- Deleting the draft after promotion; it is the section's record.
- Carrying a draft-only comment (an internal note, a working block) into the unit.

## Cross-references

- `adapt-section` and `improve-section` — where a section goes back to when a check fails.
- `fact-check` — clears a `VERIFY` before promotion.
- `build` — the optional proof after promotion.
- `structure-review` — opens the unit's review once every section is promoted.
- `learn-voice` — mines the ledger entry this skill completes.
- `tooling/provenance.py` — computes the ratio (`ratio … --write`) and checks the register
  (`check`); `make provenance` prints the disclosure table.
- `standards/style/ledger/provenance.md` — the register this skill keeps.
