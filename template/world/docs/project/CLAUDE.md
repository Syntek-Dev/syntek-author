@./CONTEXT.md

# CLAUDE.md — world/docs/project/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/docs/CONTEXT.md` → `world/docs/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Hold the guidance that is particular to this book's world and recurs often enough to write
down once.

## How to work here

- **Routing:** before reading any guide in `world/docs/reference/`, look here for a file with
  the same name; if one exists, read it instead.
- **Model:** **Opus** for writing or revising a guide (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Confirm with the author that the guidance is wanted and that it recurs.
  2. Copy the reference guide's shape (routing frontmatter, title with a gloss, metadata
     header, **What it is.**, topic sections, `## How we apply it here`,
     `## Who implements it`, `## Governing standard`).
  3. To override a reference guide, use its exact filename; to extend one, use a new name and
     cite the reference guide.
- **Definition of done:** the author has read and agreed the guide, and it is 54–82 lines.

## Guardrails

- **Author-owned.** Write here only on the author's instruction, and never rewrite an
  existing guide without confirmation.
- **Facts go in `world/src/`, not here.** A guide says how this book decides; the decisions
  themselves are world files.
- **An override replaces the whole reference guide.** Carry across anything from the
  reference guide you still want.

## Output & naming

- **Hand-written:** `<question>.md`, kebab-case, named for the question it answers.
- **Generated:** nothing here.
