# CONTEXT.md — manuscript/workflows/

The manuscript layer's ordered procedures: the recipes every task starts from. Where
`manuscript/docs/` explains how the work is done here and `manuscript/src/` holds the prose, this
folder holds the steps, in order, each naming its skill, its guide and any `make` command, with a
model-tagged checklist to tick. The numbered procedures are template-owned and updated by
`copier update`; the author's own procedures live in `manuscript/workflows/local/`. **Never draft
straight into `manuscript/src/`; start here.**

## Directory Tree

```text
manuscript/workflows/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules; running and changing a procedure
├── 01-draft-a-section/            ← the AI drafts one section from the chapter's plan
├── 02-adapt-a-draft/              ← the author's notes drive a targeted revision
├── 03-improve-your-draft/         ← the author drafted; the AI proposes a numbered diff
├── 04-promote-a-section/          ← on the author's word, into the chapter file
├── 05-review-a-chapter/           ← the review sequence and the chapter's status gates
├── 06-build-a-proof/              ← render a chapter or the book, and read the proof
├── 07-learn-from-your-edits/      ← mine the ledger; propose voice notes for approval
<: if DOC_TYPE == 'theology' :>├── 10-steelman-the-objections/    ← the good-faith audit of a chapter's objections
<: endif :>└── local/                         ← the author's own procedures; a same-named one wins
```

Each procedure folder holds four files: `CONTEXT.md` (when to reach for it), `CLAUDE.md` (how to
run it), `STEPS.md` (the ordered steps) and `CHECKLIST.md` (pre-conditions, execution and done-when,
each item tagged with its model tier).

## What's here

| You want to… | Procedure | Skill(s) |
|---|---|---|
| Have the AI draft the next section of a chapter | `manuscript/workflows/01-draft-a-section/` | `draft-section` |
| Revise a draft from your notes or your own edits | `manuscript/workflows/02-adapt-a-draft/` | `adapt-section` |
| Get suggestions on a section you wrote yourself | `manuscript/workflows/03-improve-your-draft/` | `improve-section` |
| Put an approved section into its chapter | `manuscript/workflows/04-promote-a-section/` | `promote-section` |
| Review a finished chapter and move it up the ladder | `manuscript/workflows/05-review-a-chapter/` | `structure-review` → `fact-check` → `comprehension` → `flow` → `grammar` → `spelling` |
| Render a `.docx`, `.pdf` or `.epub` and check it | `manuscript/workflows/06-build-a-proof/` | `build` |
| Teach the AI your voice from what you changed | `manuscript/workflows/07-learn-from-your-edits/` | `learn-voice` |
<: if DOC_TYPE == 'theology' :>| Check a chapter states its objections fairly | `manuscript/workflows/10-steelman-the-objections/` | `steelman` |
<: endif :>
**Numbering is frozen and append-only.** A number, once used, keeps its meaning; gaps are normal.
The author's procedures are numbered separately in `manuscript/workflows/local/`.

## Cross-references

- `manuscript/workflows/local/` — the author's procedures, and same-named overrides of these.
- `manuscript/docs/reference/drafting-with-ai.md` — how `01-draft-a-section` to
  `04-promote-a-section` and `07-learn-from-your-edits` fit together.
- `standards/verification/verification.md` — the gates the review procedure runs.
- `.claude/rules/syntek-author/05-model-allocation.md` — what the checklist model tags mean.
- `planning/workflows/` — the procedures that plan a chapter before anything here runs.
