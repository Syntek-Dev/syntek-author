@./CONTEXT.md

# CLAUDE.md — library/workflows/01-draft-a-section/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Draft one section of a business document from its brief, with every fact gathered first and every
gap flagged rather than filled.

## How to work here

- **Routing:** the `draft-section` skill (with its `BUSINESS.md` mode file) is this procedure in
  skill form. `grill-with-docs` settles the five questions; `fact-check` gathers every figure
  before drafting; `spelling` checks the result. Guides: `section-anatomy.md`,
  `drafting-with-ai.md` and `document-anatomy.md` in `library/docs/reference/`.
- **Model:** follow the checklist tags: **Opus** for every judgement and every word of the draft;
  the mechanical tier for creating files and ticking boxes.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** one draft of about the brief's word target sits in the document's drafts
  folder at `ai-draft`, doing the job the brief gave it; every fact in it came from the author, the
  client's facts or a verified source; every gap is flagged; its ledger entry holds the AI
  original; and nothing has been promoted.

## Guardrails

- **One section per request** unless the author asks for more. A batch drafted in one pass has no
  useful record and no real approval.
- **Facts before prose.** Gather and verify every figure, date and entity detail before drafting
  (steps 3–4); prose written around an unverified figure tends to survive the discovery that the
  figure was wrong.
- **Prices, dates and service levels come from the author.** Never supply one; flag it.
- **Never invent a statute, a section number, a certification or a client's detail.**
- **The formal register stays formal.** Brand voice applies to proposals, letters and marketing;
  it never softens an instrument or a policy.
- **Never overwrite an existing draft or ledger entry** (step 5 exists to catch this), and never
  promote: that is workflow 04, on the author's word.

## Output & naming

- **Produces:** `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`.
- **Also writes:** the ledger entry; evidence entries; the five answers and the section's status in
  the unit brief.
- **Does not touch:** the deliverable `.tex`, the register, any standard or any other section.
