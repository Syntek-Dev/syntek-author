@./CONTEXT.md

# CLAUDE.md — library/src/marketing/client-docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/marketing/CONTEXT.md` → `library/src/marketing/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold marketing documents for each client in that client's own folder.

## How to work here

- **Routing:** documents are produced through `library/workflows/`; this folder only decides where
  they are filed. The client's facts come from
  `library/src/contracts/client-docs/<client-slug>/CONTEXT.md`.
- **Model:** the mechanical tier for creating folders and their pairs; **Opus** for anything
  written into a document or a client's facts.
- **Concrete steps:**
  1. When a client first appears, create its folder here with its pair, and create its folder
     in `library/src/contracts/client-docs/` (pair only) if that does not exist yet.
  2. Use the same `<client-slug>` as every other family; check the existing folders first.
  3. Add each new document to the client folder's `CONTEXT.md` when it is created.
- **Definition of done:** every client folder has its pair, every document in it is listed in its
  `CONTEXT.md`, and no client fact is copied here from the contracts family.

## Guardrails

- **One slug per client, everywhere.** Two spellings of a client are two places for facts to drift.
- **A client folder never holds another client's document**, not even as a precedent: quote the
  wording into a template instead, with every client detail removed.
- **No credential, password or bank login** is written into any file in any client folder.
- **Never delete a client folder or a document in it.** A finished relationship is recorded in the
  register, not by removing its record.

## Output & naming

- **Hand-written:** client folders `<client-slug>/` with their pairs; the documents in them follow
  their family's naming.
