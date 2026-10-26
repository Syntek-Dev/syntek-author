# CONTEXT.md — how-to/workflows/syntek-author/01-update-the-template/

The procedure for taking syntek-author's latest changes into this project: from a clean,
committed tree on a branch, through the update and its report, to a commit. It checks first for
the three things an update must handle with care (a held `.agents` link, an `.agents` link
outside the project, and `how-to` that is not a folder), settles any changed answer with the
author, runs the update with Git's housekeeping off, and reads the report with the author before
anything is committed.

## Directory Tree

```text
how-to/workflows/syntek-author/01-update-the-template/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this procedure
├── STEPS.md            ← ordered steps to execute, with every command
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- A newer release of the template is out, and the author wants its improvements.
- An answer must change: an option turned on or off, a document family added, a coding agent
  recorded, the place binary files are kept.
- The template asked for an update, such as a message after a copy or a migration's report.

Reach for a **different** procedure when: an update has already stopped part way with an error
(`02-recover-a-failed-update/`); a client's files must be added after it is recorded
(`03-enable-an-agent-client/`, which runs this update as its first step); or the job concerns a
companion template, which has its own procedure in its own folder under `how-to/workflows/`.

## What it produces, and where

- The template's newer version merged into the project, and
  `.copier-answers.syntek-author.yml` moved forward, committed together on the branch
  `update-syntek-author`.
- The user guide in `how-to/` put back to the template's text, and new settings entries and
  MCP servers added once each, as the report lists.
- Two records inside `.git` that keep the report and the project as it was before the update.

## The failure this procedure exists to prevent

An update run over uncommitted work, or committed half-finished. Copier may write over an
untracked file at one of the template's paths; a stopped update that is committed takes the new
version as already reached and skips the steps that version needed; and a report nobody reads
leaves conflicts, rejected hunks and edits the template put back unnoticed until they surface in
the work.

## Cross-references

- `how-to/docs/syntek-author/updating-the-template.md`: why each step is there.
- `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`: what an update does to each kind of
  file, and every section of the report.
- `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`: each answer, and what it costs to
  change.
- `how-to/workflows/syntek-author/02-recover-a-failed-update/`: when the update stops.
