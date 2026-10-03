@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/01-draft-a-section/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Draft one section of a planned chapter, in the author's voice, from checked material, into the
chapter's drafts folder, and hand it back with everything uncertain flagged.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `draft-section`, whose mode file adds this project's domain steps; it is this
  procedure in skill form. `grill-with-docs` when the section's purpose is too thin to draft from;
  `research` and `fact-check` before drafting; `spelling` on the result. Guides:
  `manuscript/docs/reference/section-anatomy.md`, `manuscript/docs/reference/drafting-with-ai.md`
  and the guide for this kind of book listed in `manuscript/docs/reference/CONTEXT.md`.
- **Model:** **Opus** for every judgement and every sentence of prose; the mechanical tier only for
  creating files, copying text into the ledger and ticking boxes
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the section → read the plan, the voice and the method → gather the
  material → check the claims → confirm no clobber → draft one section → flag what is unchecked or
  undecided → spelling pass → write the ledger entry → update the brief and hand back.
- **Definition of done:** one file at `status: ai-draft` sits in the chapter's drafts folder, within
  its target length and doing the one job the brief gives it; it sounds like the voice notes and the
  samples rather than like a model; every checkable claim is backed by an evidence entry or flagged
  `VERIFY`; every author decision is flagged `AUTHOR TO CONFIRM`; the ledger holds the AI original
  verbatim; nothing was promoted.

## Guardrails

- **Gather and check before you draft** (steps 3 and 4). Prose written around an unchecked claim
  tends to survive the discovery that the claim was wrong.
- **One section per request**, unless the author explicitly asks for more. Never draft a whole
  chapter in one go.
- **Never fabricate.** No invented quotation, page number, citation, reference, original-language
  definition, date, figure or historical claim. Flag it `VERIFY` or leave it out, and say which in
  the hand-back.
- **Never invent a citation key** and never hand-format a reference. When the references option is
  on, a missing work is added with the add-reference skill; otherwise the claim is flagged.
- **The voice comes from the author's own writing.** If `standards/style/samples/` is empty, say so
  in the hand-back: until it holds real samples, the draft's voice is a guess.
- **Never overwrite an existing draft** (step 5 exists to catch it), and **never promote**, even if
  the author says in passing that it looks fine. Promotion is its own procedure.
- **A waived step is recorded in the hand-back**, with its reason.

## Output & naming

- **Produces:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`, where `<NN>` is the
  section's `order` in the brief, two digits.
- **Also writes:** the ledger entry; evidence entries; the section's status in the brief; for a new
  chapter folder, its pair and `drafts/README.md`.
- **Generated:** nothing.
- **Does not touch:** the chapter file `NN-kebab-title.md`, any standard, or `build/`.
