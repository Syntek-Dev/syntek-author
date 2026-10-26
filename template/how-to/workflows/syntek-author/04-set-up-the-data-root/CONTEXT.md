# CONTEXT.md — how-to/workflows/syntek-author/04-set-up-the-data-root/

The procedure for keeping the project's binary files (scans, signed and received copies,
images, audio) outside the repository on this machine. It reads the store the answers record,
settles the root and the provider with the author, has the author set the root and its marker
in their own terminal, checks the root, files a copy of each binary Git still holds, verifies
every copy, and commits the manifests; the binaries leave Git only afterwards, on the author's
word.

## Directory Tree

```text
how-to/workflows/syntek-author/04-set-up-the-data-root/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this procedure
├── STEPS.md            ← ordered steps to execute, with every command
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- A new machine will work on a project that keeps its binary files outside the repository.
- A project that kept its binaries in Git is moving them out, on the author's decision.
- A data command refused because there is no valid root on this machine.

Reach for a **different** procedure when: a single file is to be filed while working (the
data-root commands in `.claude/rules/syntek-author/09-data-root.md` Section 6, through the
skill or workflow step that asks for it); or an answer about the layout or the provider is to
change (`01-update-the-template/`, with that answer).

## What it produces, and where

- `SYNTEK_DATA_ROOT` set in the author's shell profile, and the empty marker
  `.syntek-data-root` at the top of the root, both made by the author.
- A checked copy of each binary under the root, at its repository path below the area, kind and
  slug folders `make root` prints.
- An `external.toml` manifest in each filing folder that holds a copy, committed with the work.
- The originals taken out of Git, where the author chose to, once verify passed on every machine.

## The failure this procedure exists to prevent

A binary lost or silently changed in the move. A file taken out of Git before its copy was
verified, or before every machine had a root, is deleted from every other clone at its next
pull; a root inside a repository, or a repository in a synced folder, corrupts one or the other;
and a session that writes under the root breaks the checksums that prove each copy unchanged.

## Cross-references

- `how-to/docs/syntek-author/setting-up-the-data-root.md`: why each step is there.
- `how-to/src/TEMPLATE-GUIDE/the-data-root.md`: the stores, the root, the layout, the manifests
  and the providers, explained.
- `.claude/rules/syntek-author/09-data-root.md`: the rules and every data command.
- `how-to/workflows/syntek-author/01-update-the-template/`: the update that changes an answer.
