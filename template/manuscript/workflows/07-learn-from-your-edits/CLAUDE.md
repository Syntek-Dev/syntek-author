@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/07-learn-from-your-edits/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Learn the author's voice from what the author actually changed and refused, and write it down only
with the author's approval.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `learn-voice`, whose mode file names the registers this kind of book has; it
  is this procedure in skill form. Guide: `manuscript/docs/reference/drafting-with-ai.md`.
- **Model:** **Opus** for reading the evidence, finding patterns and writing proposals; the
  mechanical tier for listing entries, appending approved entries and marking entries learned
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** gather the unlearned entries → read the voice notes, style sheet and
  terminology → walk each entry's record (the author's revisions, the gap to the author final;
  an entry without `format: 2`, its AI original beside its author final) → read the rejections,
  then the implicit ones → find the patterns worth a note → seed from samples (when the notes are
  empty) → propose → write only what is approved → mark the promoted entries learned → record and
  hand back.
- **Definition of done:** every proposed note cites the author's own before-and-after; only
  approved entries were written; every promoted entry read is marked `learned: true`, and no
  unpromoted one; any conflict with the style sheet went to the author.

## Guardrails

- **Never self-edit a standard.** `standards/style/voice-notes.md`, `standards/style/style-sheet.md`
  and `standards/style/terminology.md` change only with the author's approval of each entry.
- **Evidence, not impressions.** No note without at least two sections showing it, and no example
  that is not the author's own text.
- **The author's changes, not the AI's.** Words an `ai` or `author-note` revision brought in are
  not the author's evidence, even once accepted; an AI change the author later undid is an
  implicit rejection. A difference read from an entry without `format: 2` is weaker evidence.
- **Voice is not mechanics, and not content.** A spelling or punctuation habit is proposed for the
  style sheet; a corrected fact belongs in the evidence. Neither is a voice note.
- **In the voice notes, write only under `## Learned`.** The rest is the author's own writing; do
  not edit it without explicit instruction.
- **Never edit a ledger entry's texts.** Only the `learned` key changes, and only once the section
  is promoted.

## Output & naming

- **Produces:** approved notes under `## Learned` in `standards/style/voice-notes.md`, and approved
  rules and terms in `standards/style/style-sheet.md` and `standards/style/terminology.md`, each
  dated DD/MM/YYYY with its before-and-after.
- **Also writes:** `learned: true` in the promoted ledger entries read; a dated Decisions entry in
  `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`) when a note overturns an
  earlier voice decision.
- **Generated:** nothing.
- **Does not touch:** the manuscript, the drafts or the ledger's texts.
