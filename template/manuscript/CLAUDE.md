@./CONTEXT.md

# CLAUDE.md — manuscript/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the layer's
shape and key concepts, imported above) → this file → the `CONTEXT.md` and `CLAUDE.md` of the
sublayer you are about to work in.

## Purpose (one line)

Turn each chapter's plan into finished prose, one small section at a time, with the author deciding
every word that reaches the chapter file.

## How to work here

- **Routing:** start every task from a procedure in `manuscript/workflows/`. The `run-workflow`
  skill resolves 'draft the next section' or 'review chapter 3' to one, looking in
  `manuscript/workflows/local/` first. Each procedure names its skill, its guide and its gates.
  The writing skills carry a mode file for this project's kind of book: the mode owns the domain,
  the procedure owns the order.
- **Model:** **Opus** for drafting, revising, reviewing and every judgement; the mechanical tier
  for creating files, running `make` and ticking checklists
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for a chapter:**
  1. Confirm the chapter's brief exists in `planning/src/units/` and lists its sections. If it
     does not, plan the chapter first (`planning/workflows/01-plan-a-unit/`).
  2. Get one section into the chapter's `drafts/`: the AI drafts it
     (`manuscript/workflows/01-draft-a-section/`) or the author writes it.
  3. Revise it with the author: `manuscript/workflows/02-adapt-a-draft/` when the author has notes
     on a draft, `manuscript/workflows/03-improve-your-draft/` when the author wrote it and wants
     suggestions.
  4. Promote it on the author's explicit word (`manuscript/workflows/04-promote-a-section/`).
  5. Repeat until every planned section is promoted, then run
     `manuscript/workflows/05-review-a-chapter/`.
  6. Proof whenever it helps (`manuscript/workflows/06-build-a-proof/`), and mine the ledger every
     few chapters (`manuscript/workflows/07-learn-from-your-edits/`).
- **Definition of done:** the chapter file holds every planned section in plan order, each promoted
  on the author's word with its provenance recorded; the chapter has passed every gate for its
  status; it reads as one voice to the reader named in `00-project.md` `## Brief`; the chapter
  proof-builds.

## Guardrails

- **One section at a time.** Draft one section per request unless the author asks for more. A
  section is small so the author can actually judge it; ten sections at once is a manuscript nobody
  has read. **Scaffolding is not progress:** when in doubt, produce a drafted section, not another
  plan or another empty folder.
- **The author's word promotes; nothing else does.** 'Looks fine' in passing is not the word. Ask,
  name the section, and wait.
- **Never draft straight into a chapter file.** Prose enters `NN-kebab-title.md` only through
  promotion, under its marker. Keep the plan out of the prose: the brief stays in `planning/`.
- **Never fabricate.** Quotations, page numbers, citations, references, original-language
  definitions, dates, figures and historical claims are checked or left out. A checkable claim not
  yet checked carries `<!-- VERIFY: … -->`; a decision only the author can make carries
  `<!-- AUTHOR TO CONFIRM: … -->`. `make flags` lists both, and a section with either is not
  promoted.
- **Report, then apply.** Suggestions are offered as a report or a numbered diff with reasons;
  only what the author accepts is applied. Preserve deliberate oddities in the author's prose.
- **One sentence per line in `manuscript/src/`**, applied to a paragraph when it is edited, never by mass
  reflow.
- **Never overwrite an existing draft or promoted text** without confirming with the author.

## Output & naming

- **Hand-written:** chapter files `manuscript/src/NN-kebab-title/NN-kebab-title.md`; section drafts
  `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`; the guides and the procedures.
- **Also written from this layer:** ledger entries in `standards/style/ledger/`, rows in
  `standards/style/ledger/provenance.md`, statuses in the chapter's brief, and dated lines in
  `.claude/MEMORY.md` Status (mapped in `00-project.md` `## Memory headings`).
- **Generated (never hand-edit):** everything under `build/`.
