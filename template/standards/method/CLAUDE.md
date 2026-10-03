@./CONTEXT.md

# CLAUDE.md — standards/method/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → `method.md`,
then the mode file beside it.

## Purpose (one line)

Define and keep true the rules that make the work honest about what it claims, so a reader who
checks one claim finds the rest were checked too.

## How to work here

Two kinds of work touch this folder, and they are very different.

- **Routing (applying the method, the normal case):**
  - A checkable claim is about to be stated → `fact-check`, against `method.md`; it calls
    `research` for delegated search.<: if DOC_TYPE == 'theology' :>
  - A unit is being planned or reviewed → `argument-audit` against the argument map and
    `category-check` against the six categories; a contested passage → `tradition-check`; a
    unit nearly done → `steelman` (all against `THEOLOGY.md`).<: endif :><: if DOC_TYPE == 'fiction' :>
  - A beat is being planned or reviewed → `causality`; prose against the story bible →
    `continuity`; at line edit → `character-voice` and `pacing` (all against `FICTION.md`).<: endif :><: if DOC_TYPE == 'business' :>
  - An instrument is being reviewed → `clause-consistency` (terms, cross-references,
    precedence) and `obligation-check` (shall, may, must; every commitment traced); at line
    edit → `tone` (all against `BUSINESS.md`).<: endif :>
- **Model:** **Opus** for everything here. Judging whether a claim's basis is adequate, or an
  objection fairly stated, is never mechanical.
- **Concrete steps (changing the method, rare and never casual):**
  1. Read the read-order files.
  2. Search the content layer and `planning/src/` for units the new rule would break, and for
     files that restate the rule instead of citing it.
  3. Draft the rule: requirement, a right and a wrong example, why the rule exists.
  4. **Confirm with the author**, and record the decision in `.claude/MEMORY.md`.
- **Definition of done (applying):** every checkable claim carries its basis and a verdict;
  contested evidence is reported as contested; the mode file's rules hold for the unit.

## Guardrails

- **These rules bind the author, not just the prose.** Saying where the evidence is thin, and
  conceding what the argument costs, constrain what the work may claim for itself. Enforcing them
  against the author's convenience is the job, not an overreach.
- **A claim without its basis is cut, not hedged.** 'Roughly' and 'some say' do not repair a
  figure or a quotation with no source.
- **Never settle an empirical question by argument.** A question of fact goes to `fact-check`,
  however confident everyone in the conversation is.
- **Never invent an objection nobody holds, a source, or a quotation**; the fix for a weak case
  is a better statement of the real one.
- **Never weaken a rule to make a unit easier.** The unit changes, or the rule changes openly
  with the author.

## Output & naming

- **Hand-written:** `method.md`, the mode file and this pair. Nothing here is generated.
- **Enacted, not restated, elsewhere:** skills and checklists cite these files by path and rule
  number (for example 'method.md rule 3'); they never copy a rule's wording.
- This folder holds no evidence and no prose; verdicts live in `research/src/evidence/`.
