---
name: adapt-section
description: >-
  Revise one section draft from the author's notes or hand-edits: change only the lines a note
  reaches, keep the author's own edits verbatim, offer two or three alternatives for a contested
  or open line, never rewrite the whole section, and log every choice in the section's ledger
  entry. Also adapts source material when asked: the author's earlier writing into a section, a
  template into one client's document, an existing document brought into the house form. Use
  when the author says 'here are my notes on section 2', 'make the opening less formal', 'I've
  edited the draft, work around my changes', 'try that last line another way', 'cut the second
  paragraph' or 'turn the services template into a contract for this client'. Not for proposing
  changes to a section the author drafted themselves (`improve-section`). Not for a first draft
  (`draft-section`). Not for moving the revised draft into the unit (`promote-section`). Not a
  throwaway test of a passage not yet planned (`prototype`).
---

# Skill: Adapt Section (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The author's notes drive the revision; the AI changes what was flagged and nothing else. Every
untouched sentence stays exactly as it was, the author's own hand-edits are decisions to keep, and
where a note names a problem without naming a fix, the author chooses between alternatives rather
than receiving one. Each choice goes into the ledger: an applied note as the author's own
(`author-note`), an alternative as `accepted` or `rejected`, because what the author turns down
is the clearest record of their voice.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/02-adapt-a-draft/` — this skill is that procedure in skill form;
  the mode file names its path and any other procedure that uses this skill.
- If a layer's `workflows/local/` holds a folder with the same `NN-name` as a procedure named
  here or in the mode file, follow that procedure instead: the author's local procedure replaces
  the template's (`run-workflow`, step 2).
- `.claude/rules/syntek-author/03-authorship.md` — who decides (Section 1), never fabricate
  (Section 4), suggest rather than rewrite and preserve deliberate oddities (Section 6).
- `standards/style/voice-notes.md` and `standards/style/style-sheet.md` — the voice and mechanics
  every revised line keeps.
- `standards/style/ledger/CONTEXT.md` — the decision table every choice is logged in.
- The content layer's `docs/reference/drafting-with-ai.md`, `docs/reference/section-anatomy.md`
  and `docs/reference/the-status-ladders.md` (`author-revised` and `adapted`).

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Locate the draft, its record and the job.** Open the draft, its ledger entry (the draft's
   `ledger:` key), the section's line in the unit brief and any internal note under the draft's
   frontmatter: a deviation recorded there is deliberate. Read the ledger's earlier decisions, so
   a change already rejected is not offered again. Confirm which job this is: notes on a draft, a
   draft the author has edited by hand, or source material to adapt (the mode file lists the kinds
   this project has).
   *Complete when:* the draft, its record and the kind of job are named.

2. **Record the author's own edits first.** If the author has edited the draft since the last AI
   pass, compare it with the last recorded text (the ledger's AI original, the last AI pass, or
   the last commit) and list exactly what changed. Those changes are decisions: keep them
   verbatim, set `status: author-revised`, and treat that text as the new baseline.
   *Complete when:* every hand-edit is listed and the status says whose hand was last on it.

3. **Number the notes, exactly.** Notes may come in chat, as comments in the draft, or as the
   edits listed in step 2. Restate each as a numbered item. Where a note's reach is unclear ('make
   it warmer'), ask one question with your reading of it as the recommended answer. A note that
   asks you to decide something only the author can decide goes back to them as a question.
   *Complete when:* every note is numbered and unambiguous, or put back to the author.

4. **Scope each note to its lines.** Mark the sentences each note reaches; everything else is out
   of scope and stays byte for byte. If a note would change what the section is for, or move
   material to another section, stop: that is a change to the brief, and the author decides it
   there. If the notes together amount to a rewrite, ask whether to redraft with `draft-section`.
   *Complete when:* each note maps to named sentences, and nothing else is in play.

5. **Revise only what was flagged.** Change the marked sentences and nothing else. Keep every fact,
   figure, date, name, citation key, quotation and flag unless a note is about it; where the
   author supplied a fact in a note, write it in exactly and remove the flag it answers. Write in
   the voice of the notes, one sentence per line, and apply the mode file's additions.
   *Complete when:* every applicable note is applied, and a comparison shows no other change.

6. **Offer alternatives for open and contested lines.** Where a note names a problem but no fix
   ('this is flat'), or a line carries weight, offer two or three alternatives in chat, numbered,
   each with one line on what it does differently. Make them differ in kind (shorter, plainer,
   more concrete, a stronger or weaker commitment), not three wordings of one idea. Keep the
   holding line the mode file names in the draft until the author chooses, then apply the choice.
   *Complete when:* every open note has its alternatives, and every choice made is applied.

7. **Adapt source material, only when asked.** Treat the source as read-only. Quarry it, never
   paste it: keep its spine (the argument, the events or the terms), change the register to the
   reader named in `00-project.md` `## Brief`, and cut what this section's one job does not
   need. Name the source (path and date) in an `<!-- INTERNAL NOTE: … -->` under the frontmatter.
   Read the result against the source: nothing in it may claim more than the source did. The mode
   file says what kinds of source this project adapts, and how each is recorded.
   *Complete when:* the section does its job, the source is untouched and named, and the
   fidelity read found no claim the source does not make.

8. **Check what you touched.** Run `spelling` over the changed lines. Any new checkable claim goes
   through `fact-check` or carries `VERIFY`. Confirm every flag that was in the draft is still
   there, or was answered by the author's own note. Apply the mode file's checks of what must not
   change.
   *Complete when:* the changed lines are clean and no flag was lost.

9. **Record every choice.** Add rows to the ledger entry's `## Improvement decisions` table:
   number, proposal, reason, decision, and the author's own words where they gave any. A note
   the author gave (or a hand-edit from step 2) that you applied is logged `author-note`: the
   change was the author's call, so `make provenance` never counts it as an AI suggestion. Each
   alternative you offered is logged `accepted` or `rejected`; one still awaiting a choice is
   logged `pending` and updated once chosen. Set `status: adapted` and `last_updated`, and mirror
   the status in the brief's `sections:` list. Never touch `## AI original`.
   *Complete when:* every note and alternative has its row with the right decision, and the draft
   and the brief agree.

10. **Hand back.** Report what changed, note by note; the alternatives still waiting for a choice;
    anything raised as outside the section's scope; every open flag. Offer the next move: more
    notes, `improve-section` for a line-level pass, or approval for promotion.
    *Complete when:* the author has the report, and the draft is still in its drafts folder.

## Anti-patterns

- Rewriting the whole section because the notes 'pointed that way'.
- Tidying an untouched sentence while applying a note to its neighbour.
- Smoothing over the author's hand-edits, or carrying their logic into lines they did not touch.
- Offering three wordings of the same idea as if they were alternatives.
- Changing a fact, figure, date, citation key or quotation to make a note's change read better.
- Pasting from the source material instead of quarrying it, or letting the adaptation claim more
  than the source did.
- Logging only the accepted changes. A rejected alternative is the most useful row in the table.
- Logging an applied author note as `accepted`, which counts the author's change as an AI
  suggestion in the disclosure.
- Editing `## AI original` so the ledger matches the revision.

## Cross-references

- `draft-section` — the first draft this skill revises, and the fresh redraft when notes amount to
  a rewrite.
- `improve-section` — the line-level pass on a section the author wrote, with a numbered diff.
- `promote-section` — the next move once the author approves the revision.
- `spelling` and `fact-check` — the checks on what this skill touched.
- `learn-voice` — mines the decisions this skill records.
- `standards/style/ledger/` — the entries, one per section.
