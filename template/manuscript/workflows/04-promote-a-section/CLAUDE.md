@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/04-promote-a-section/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Move one approved section into its chapter, on the author's explicit word, with its provenance
recorded in the same act.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `promote-section`, whose mode file adds this project's extra records; it is
  this procedure in skill form. `build` for the optional proof. Guides:
  `manuscript/docs/reference/section-anatomy.md`,
  `manuscript/docs/reference/the-status-ladders.md`.
- **Model:** **Opus** for confirming the word, judging the gates and reading the section in place;
  the mechanical tier for inserting text, updating records and building
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** confirm the author's word → check the gates and the flags → check the chapter
  file and the marker → insert the section → record provenance → update the statuses → read it in
  place → hand back.
- **Definition of done:** the section's prose sits under its marker in plan order and nowhere else;
  the draft is `promoted`; the ledger, the provenance table, the brief and `.claude/MEMORY.md` all
  agree; the chapter's own status has not moved.

## Guardrails

- **No word, no promotion.** The author must name, or plainly confirm, this section. When in doubt,
  ask: 'Promote `<section-slug>` into chapter NN?'
- **No flags, no promotion.** A section carrying `AUTHOR TO CONFIRM` or `VERIFY` is not promoted.
  The author may settle an `AUTHOR TO CONFIRM` there and then; a `VERIFY` is checked or the claim
  removed first.
- **Promotion never moves the chapter.** Only `manuscript/workflows/05-review-a-chapter/` and the
  author's word make a chapter `final`.
- **Touch only this section's span.** Nothing above its marker or from the next marker down
  changes. Never reflow, retitle or tidy the rest of the chapter while you are in the file.
- **Never overwrite promoted text silently.** When re-promoting, show what will be replaced and
  confirm first.
- **When the brief and the markers disagree, stop and report.** Do not guess which is right.

## Output & naming

- **Produces:** the updated chapter file `manuscript/src/NN-kebab-title/NN-kebab-title.md`.
- **Also writes:** the draft's `status`; the ledger entry's author final, date and change ratio;
  a row in `standards/style/ledger/provenance.md`; the brief's section status; the chapter's line
  under Status in `.claude/MEMORY.md`.
- **Generated (never hand-edit):** the optional proof under `build/`.
- **Does not touch:** the brief's chapter `status:`, the ledger's `## AI original`, other sections'
  text, or any standard.
