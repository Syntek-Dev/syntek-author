@./CONTEXT.md

# CLAUDE.md — how-to/workflows/syntek-author/04-set-up-the-data-root/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/CLAUDE.md` → `how-to/workflows/CONTEXT.md` → `how-to/workflows/CLAUDE.md` →
`how-to/workflows/syntek-author/CONTEXT.md` → `how-to/workflows/syntek-author/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Prepare this machine's data root and move the binary files Git holds out to it as checked
copies, losing none and changing none.

## How to work here

- **Routing:** no skill; this is a command-and-check procedure. Guide
  `how-to/docs/syntek-author/setting-up-the-data-root.md`; the rules and every command are in
  `.claude/rules/syntek-author/09-data-root.md`.
- **Model:** **Opus** for the store, the root and the provider, and for every decision to copy
  or untrack; the mechanical tier only for running a check the author has agreed
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go. A session
  started before the author set `SYNTEK_DATA_ROOT` does not see it: the author restarts it from
  a terminal where it is set.
- **Definition of done:** `make root` shows this machine's root with its marker; every binary
  the author chose is filed and verified; the manifests are committed; nothing left Git without
  the author's word.

## Guardrails

- **The session never searches, lists, browses, edits or writes anything under a data root**,
  the marker included (`.claude/rules/syntek-author/06-global-rules.md` Section 12). The author
  sets the variable and makes the marker, in their own terminal.
- **`COPY=1` and every `git rm --cached` need the author's word for that run.**
- **A refusal is reported with the tool's own line**, and never worked round by copying, moving
  or editing a file by hand.
- **Never edit, reorder or delete a manifest row**; commit each `external.toml` as the tool
  wrote it.
- **The store changes only through an update**, on the author's decision, never by editing
  `.copier-answers.syntek-author.yml`.

## Output & naming

- **Writes:** copies under the root and the `external.toml` manifests, through the data-root
  commands; the commit of the manifests; the author's own changes to their shell profile.
- **Does not touch:** the text of the work, or any file the tool does not name.
