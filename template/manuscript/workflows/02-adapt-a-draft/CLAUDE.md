@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/02-adapt-a-draft/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Revise a section draft to the author's notes or edits, changing only what was flagged, offering
choices where the notes leave them open, and recording every choice.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `adapt-section`, whose mode file adds this project's domain rules; it is this
  procedure in skill form. `spelling` on the changed lines; `fact-check` for any new claim. Guides:
  `manuscript/docs/reference/drafting-with-ai.md`,
  `manuscript/docs/reference/the-status-ladders.md`.
- **Model:** **Opus** for reading the notes, revising and writing alternatives; the mechanical tier
  for logging and status changes (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** locate the draft and its record → collect the notes exactly → scope the change
  → revise only what was flagged → offer alternatives for open notes → adapt source material (only
  when asked) → check what you touched → record the decisions → hand back.
- **Definition of done:** every note is either applied, offered as alternatives, or raised as out of
  scope; nothing unflagged changed; the author's hand-edits survive verbatim; every choice is in the
  ledger; the draft is at `status: adapted` and still in drafts.

## Guardrails

- **Change only what was flagged.** Untouched sentences stay byte-for-byte as they were.
- **The author's own edits are decisions.** Keep them verbatim. Carry their logic into other lines
  only where the author asked.
- **Offer, do not choose,** where a note is open. Two or three alternatives, each different in kind,
  not three wordings of one idea.
- **Never alter a fact to fit a note.** Figures, dates, names, citation keys, quotations and flags
  stay as they are unless the note is about them; a new claim is checked or flagged `VERIFY`.
- **Preserve deliberate oddities**: a fragment, a dialect spelling, a repeated word that is doing
  work. When unsure whether something is deliberate, ask.
- **Quarry, never paste** when adapting source material: keep the spine, change the register, and
  read the source as read-only.
- **Never overwrite a draft** beyond the agreed changes, and **never promote**.

## Output & naming

- **Produces:** the revised `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`, at
  `status: adapted`.
- **Also writes:** rows in the ledger entry's `## Improvement decisions` table and its revisions;
  the section's status in the brief; evidence entries for any newly checked claim.
- **Generated:** nothing.
- **Does not touch:** the chapter file, the ledger's `## AI original` (unless step 6 writes a new
  one from source material), any standard, or the source material being adapted.
