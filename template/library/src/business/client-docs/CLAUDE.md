@./CONTEXT.md

# CLAUDE.md — library/src/business/client-docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/business/CONTEXT.md` → `library/src/business/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold each client's business documents in that client's own folder, and the one authoritative
record of the client's facts.

## How to work here

- **Routing:** documents are produced through `library/workflows/`; this folder decides where they
  are filed and holds the facts. Where `00-project.md ## Paths` names a different home for client
  facts, that home wins and this folder holds documents only.
- **Model:** the mechanical tier for creating folders and their pairs; **Opus** for anything
  written into a document or a client's facts.
- **Concrete steps:**
  1. When a client first appears in any family, confirm the slug with the author, then create its
     folder here with its pair, and fill `## Facts` from the public register (through
     `fact-check`) and the author, each fact with its date and source.
  2. Use the same `<client-slug>` as every other family; check the existing folders first.
  3. Add each new document to the client folder's `CONTEXT.md` when it is created.
- **Definition of done:** the client's facts are recorded once, here, with the date and source of
  each check, and every document in the folder is listed in its `CONTEXT.md`.

## Guardrails

- **One slug per client, everywhere.** Two spellings of a client are two places for facts to drift.
- **Facts come from the public register and the author,** never from the client's own website or
  from memory. A fact not yet checked carries a `VERIFY` flag.
- **A client folder never holds another client's document**, not even as a precedent: quote the
  wording into a template instead, with every client detail removed.
- **No credential, password or bank login** is written into any file in any client folder.
- **Never delete a client folder or a document in it.** A finished relationship is recorded in the
  register, not by removing its record.

## Output & naming

- **Hand-written:** client folders `<client-slug>/` (and `<client-slug>/<unit-slug>/`) with their
  pairs; the documents in them follow `library/docs/reference/business-standards.md`.
