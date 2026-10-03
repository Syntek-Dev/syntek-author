# CONTEXT.md — research/workflows/

The research layer's ordered procedures: the recipes for getting material into the evidence base
properly. Where `research/docs/` explains the judgement calls and `research/src/` holds the result,
this folder holds the steps, with the skill and any `make` command named at each one and a
model-tagged checklist to tick. These procedures run **before** drafting: a unit drafted ahead of
its evidence keeps its unverified claims.

## Directory Tree

```text
research/workflows/
├── CONTEXT.md                      ← this file: the index
├── CLAUDE.md                       ← operating rules; 'You want to… | Procedure'
├── 01-ingest-a-source/             ← a work → a filed, keyed note
├── 02-verify-a-claim/              ← the route by which every checkable claim gets its verdict
<: if DOC_TYPE == 'theology' :>├── 03-map-a-contested-reading/     ← a passage read more than one way, mapped once
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>├── 05-handle-testimony-safely/     ← first-person material, with consent and care
<: endif :>└── local/                          ← your own procedures; a same-slug one overrides
```

## What's here

- `01-ingest-a-source/` — route a work, read it at its origin, note what it argues and where it
  disagrees, capture page numbers, key it: one pass.
- `02-verify-a-claim/` — isolate a claim, reach the primary source, record the basis and both
  dates, return one of the six verdicts. **The only route by which a claim gets a verdict;** it
  feeds V5 (fact-check → line-edit) in `standards/verification/verification.md`.
<: if DOC_TYPE == 'theology' :>- `03-map-a-contested-reading/` — state each reading so its holders would recognise it, say what
  turns on it, recommend the reading to adopt.
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>- `05-handle-testimony-safely/` — the safeguarding procedure for `research/src/testimony/`.
  **Consent is load-bearing.**
<: endif :>- `local/` — the author's procedures, in their own numbering. A local procedure with the same slug
  as a template one replaces it; `run-workflow` looks there first.

Every procedure folder holds four files: `CONTEXT.md` (when to reach for it), `CLAUDE.md` (how to
run it), `STEPS.md` (ordered and numbered) and `CHECKLIST.md` (model-tagged). **Numbering is frozen
and append-only**, unique across every variant the template generates, so gaps in this list are
expected.

## Cross-references

- `research/docs/reference/CONTEXT.md` — the guides these procedures cite.
- `research/src/CONTEXT.md` — the routing table, and where each procedure's output lands.
- `.claude/skills/run-workflow/SKILL.md` — resolves an intent to a procedure, local first.
- `standards/verification/verification.md` — the gates a unit passes; `02` feeds the fact-check
  gate.
