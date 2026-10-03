@./CONTEXT.md

# CLAUDE.md — world/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/docs/CONTEXT.md` → `world/docs/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Explain the everyday calls of world-building for any novel made from this template, without
holding a single fact about this book's world.

## How to work here

- **Routing:** read the guide the current workflow names. Check `world/docs/project/` for a
  same-named file first; if one exists, it replaces the guide here.
- **Model:** **Opus** when applying a guide's judgement; nothing here calls for the mechanical
  tier, because these files are read, never edited (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Open the guide the workflow step names (the `**Guide:**` half of the step's dispatch line).
  2. Apply its `## How we apply it here` rules to the job in hand.
  3. Follow `## Governing standard` when a guide and a standard seem to disagree: the standard
     wins, and the disagreement is reported to the author.
- **Definition of done:** the job was done the way the guide describes, or the departure was
  agreed with the author and recorded in `world/docs/project/`.

## Guardrails

- **Template-owned: never edit these files.** `copier update` overwrites them and the edit is
  lost. Put the change in `world/docs/project/` under the same filename.
- **A guide never outranks a standard.** It explains how a requirement is met day to day.
- **Guides hold no world facts.** If you find yourself writing a name or a fact about this
  book into a guide, it belongs in `world/src/`.

## Output & naming

- **Hand-written:** nothing; the template writes these files. The table below shows which
  guides ship with which kit chosen when the project was generated.
- **Generated:** nothing here.

| Guide | Ships with |
|---|---|
| `story-bible.md`, `naming.md` | every novel |
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| `peoples.md`, `cultures.md`, `world-history.md`, `creatures.md` | the worldbuilding kit |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `building-a-language.md`, `lexicon-format.md`, `writing-systems.md`, `pronunciation.md` | the constructed-language kit |
<: endif :>