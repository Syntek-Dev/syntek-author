@./CONTEXT.md

# CLAUDE.md — standards/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file → the target standard's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

Keep each rule the work is written against in exactly one place, so that every skill applies the
same rule and a change to it is one deliberate, author-confirmed edit.

## How to work here

You are usually **reading** a standard to apply it elsewhere, not editing it.

- **Routing:**
  - `style/` → `spelling`, `grammar` (the style sheet), `learn-voice` (the voice notes),
    `grill-with-docs` (a settled term enters `terminology.md`), `promote-section` (the ledger).
  - `method/` → `fact-check` (with `research` for delegated search); the mode file names the
    variant skills that enforce the rest.
  - `risk/` → `structure-review` (its risk lens) and `fact-check`; the mode file adds the domain.
  - `verification/` → the review workflow (05) in the content layer, which runs the gates in
    order.<: if INCLUDE_REFERENCES :>
  - `referencing/` → `add-reference` (a source becomes a row with a key) and `build`.<: endif :><: if DOC_TYPE == 'business' :>
  - `brand/` → `tone` (the voice at line edit) and `draft-section` (disclaimer by class).<: endif :>
- **Model:** **Opus** for any change to a standard and any judgement against one; the mechanical
  tier only for a typo in a rule or a table's formatting
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (changing a standard):**
  1. Read the read-order files and the standard's own `CONTEXT.md` and `CLAUDE.md`.
  2. Search the content layer and `planning/src/` for units the new rule would break.
  3. Draft the rule prescriptively: the requirement, a right and a wrong example, and why the
     rule exists. No preferences, no invented facts.
  4. **Confirm with the author.** A standards change has repository-wide reach.
  5. Record the decision, dated, in `.claude/MEMORY.md` `## Decisions`, and flag the units that
     need a conformity pass.
- **Definition of done:** the rule is unambiguous and testable; it agrees with every other
  standard and with `tooling/`; existing units comply or are listed for a pass; the change is
  author-confirmed and recorded in `MEMORY.md`.

## Guardrails

- **Never self-edit.** No skill rewrites a standard without the author's explicit instruction; a
  standards change is author-confirmed, always.
- **Never loosen a standard to make a unit easier.** If a unit cannot meet a rule, the unit
  changes, or the rule changes openly with the author and the reason is recorded.
- **Route, do not restate.** A rule lives in one file here; skills, guides and checklists cite it
  by path and number. Two wordings of one rule drift apart, and then nobody knows which is right.
- **Prescriptive voice.** Write 'must' and 'never', not 'should' and 'consider'. A rule that
  cannot be failed cannot be checked.
- **The seeds are the author's.** The style trio and `style/ledger/provenance.md`<: if DOC_TYPE == 'business' :> (and
  the three files of `brand/`)<: endif :>
  grow only by entries the author approved; a skill proposes, the author decides.

## Output & naming

- **Hand-written:** every file here; nothing in `standards/` is generated.
- **Standard format:** `# <file>.md — <gloss>`, the metadata header, a paragraph naming the
  skill that enforces it, a locale line, `---`, then `## N. <Rule>` sections that each open
  `**Requirement.**` and carry `**Why this rule exists.**`; examples as right and wrong
  blockquotes.
- **Mode files** are named `THEOLOGY.md`, `FICTION.md` or `BUSINESS.md`; exactly one ships in
  each moded folder.
- New standards: kebab-case `.md`, at most 300 lines; split an oversized one into
  `SCREAMING-SNAKE-CASE.md` sub-documents behind a thin index.
