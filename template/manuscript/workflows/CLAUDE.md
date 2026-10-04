@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → this folder's `CONTEXT.md` (the procedure index, imported above) → this
file → the chosen procedure's `CONTEXT.md`, `CLAUDE.md` and `STEPS.md`, with its `CHECKLIST.md`
open.

## Purpose (one line)

Make drafting, revising, promoting, reviewing and proofing a chapter happen the same way every
time, whoever runs them, so the author's decisions are asked for at the same points every time.

## How to work here

Two modes: **running** a procedure (the normal case) and **changing** one (rare, and the author's
call).

**Running one.** The `run-workflow` skill resolves the author's intent to a procedure, looking in
`manuscript/workflows/local/` first; a local folder with the same name as a template folder wins.

| You want to… | Procedure | Usually followed by |
|---|---|---|
| Draft the next section | `manuscript/workflows/01-draft-a-section/` | `02-adapt-a-draft`, or the author's own edits |
| Revise a draft from notes | `manuscript/workflows/02-adapt-a-draft/` | `02-adapt-a-draft` again, or `04-promote-a-section` |
| Improve a section you wrote | `manuscript/workflows/03-improve-your-draft/` | `03-improve-your-draft` again, or `04-promote-a-section` |
| Promote an approved section | `manuscript/workflows/04-promote-a-section/` | `01-draft-a-section` for the next section, or `05-review-a-chapter` when none remain |
| Review a whole chapter | `manuscript/workflows/05-review-a-chapter/` | the procedures its report names |
| Build and read a proof | `manuscript/workflows/06-build-a-proof/` | whichever procedure owns each fix |
| Teach the AI your voice | `manuscript/workflows/07-learn-from-your-edits/` | `01-draft-a-section` for the next section |
<: if DOC_TYPE == 'theology' :>| Audit a chapter's objections | `manuscript/workflows/10-steelman-the-objections/` | `02-adapt-a-draft` or `03-improve-your-draft` for the sections it flags |
<: endif :>
- **Routing:** read the procedure's `CONTEXT.md` → `CLAUDE.md` → `STEPS.md`, then work the steps in
  order with `CHECKLIST.md` open. Each step names its skill; the skill's mode file adds this
  project's domain steps.
- **Model:** the `_opus_` and `_sonnet_` tags in each checklist are authoritative. `opus` marks the
  substantive tier; `sonnet` marks the mechanical tier, whose model
  `.claude/rules/syntek-author/05-model-allocation.md` sets. Never lower.
- **Concrete steps (running):** pick the procedure → read its files → work `STEPS.md` in order →
  tick `CHECKLIST.md` → hand back with anything waived and why.
- **Concrete steps (changing one):** confirm with the author first, because a procedure change
  alters how every later chapter is made. A template procedure is changed by overriding it in
  `manuscript/workflows/local/` under the same folder name, never in place. Change all four files
  together, and date the decision in `.claude/MEMORY.md` Decisions (mapped in `00-project.md`
  `## Memory headings`).
- **Definition of done (running):** every checklist item ticked or explicitly waived with a reason;
  the artefact is where the procedure says; nothing promoted without the author's word.

## Guardrails

- **Order is load-bearing.** Checking comes before drafting, structure before line, line before
  mechanics. Reversing an order is how a procedure produces work that has to be redone.
- **Procedures cite rules; they never restate them.** If a `STEPS.md` is explaining why a rule
  exists, the explanation belongs in its standard. Gates are cited from
  `standards/verification/verification.md`, never copied.
- **Never skip the checking steps to save time.** A section drafted without its checks is not
  'nearly done'; it is unchecked.
- **Never overwrite a draft or promoted text** without the author's confirmation, and never promote
  without the author's explicit word.
- **A waived step is recorded, not silent.** Say which and why in the hand-back.
- **Numbering is frozen and append-only.** Never renumber or reuse a number here; template updates
  depend on it. New procedures for this book go in `manuscript/workflows/local/`.
- **Template-owned.** `copier update` merges over the numbered folders; edits made in place are
  lost or conflict.

## Output & naming

- **Template-owned:** the numbered procedure folders, `NN-verb-first-kebab-name/`, four files each.
- **Author-owned:** everything in `manuscript/workflows/local/` except its pair.
- **Procedures produce nothing here.** Drafts land in `manuscript/src/NN-kebab-title/drafts/`,
  prose in the chapter file, records in `standards/style/ledger/`, reviews in
  `planning/src/reviews/`, proofs in `build/`.
