---
type: guide
skills: []
model: opus
---

# Updating the template — taking the template's improvements safely, and getting back from an update that stopped

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** An update brings syntek-author's later improvements into this project. Copier,
the tool that made the project, renders the template's newer version with the answers recorded
in `.copier-answers.syntek-author.yml` and merges it into your files. A script that ships with
the template then refreshes the shared files, adds new settings entries, puts the user guide
back and prints a report of every file it did not simply deliver. An update starts from a
committed tree, on a branch, one template at a time. It can stop part way; then it is undone
and run again.

## What an update changes

- **The template's own files** (the rules, skills, guides, workflows, standards and tooling)
  are merged with any edits. Where you and the template changed the same lines, both versions
  stay in the file between conflict markers.
- **Seeds**, the files written once for you to fill in, are never overwritten; one you delete
  comes back empty. **Copy-only files**, such as each client's settings, are never written
  again, but for the two MCP servers, added once.
- **Shared files**, the ones every template of the family ships alike, are refreshed only
  where you have not changed them.
- **The user guide in `how-to/` is read-only.** The update puts the template's text back on
  every file of it that differs, your edits and deletions included, and lists each under
  `RESTORED`; what you had stays in Git. A file it cannot safely put back, such as another
  template's newer version or a copy Git does not hold, is listed under `LEFT AS IT IS`, with
  the reason.

`how-to/src/TEMPLATE-GUIDE/syntek-author/05-what-gets-generated.md` explains each kind of file;
`how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md` explains the report, section by section.

## When an update stops

An update can stop after Copier has written the new version's files and moved the answers file
forward, but before the report and the refresh have run. These errors mean this:
`OSError: [Errno 39] Directory not empty`, when Git's background housekeeping collides with
Copier deleting a temporary folder; `FileExistsError: [Errno 17]` or `NotADirectoryError`
naming `how-to`, when `how-to` in the project is a file rather than a folder; and
`ForbiddenPathError` naming a path in `how-to`, when `how-to` is a link that leads outside the
project. What it left is never committed: an update run over it takes the new version as
already reached, and skips the steps that version needed. It is discarded, after a dry run
lists what the discard would delete, and the update is run again, which delivers what an
update that never stopped delivers.

## How we apply it here

- One template at a time, on a branch, each update committed with its answers file.
- Every file is committed before the update, untracked ones included, or moved out: where Git
  hides untracked files, Copier may write over one. `how-to` must be a real folder.
- Every update command runs `uvx --python '>=3.14' copier`, so the report runs on Python 3.14
  or later, and carries the five `GIT_CONFIG_*` variables, which turn Git's housekeeping off
  for that one run (Git 2.31 or later; bash, zsh or another POSIX shell).
- The report is read with the author, every section of it, before anything is committed.
- A conflict or a `.rej` file under `how-to/` is settled by taking the template's version,
  with the commands the report prints, never by editing the file. A departure from the guide
  goes in `.claude/rules/syntek-author/00-project.md` `## Overrides` or `## Workflow aliases`.
- Where the update added deny or ask rules to `.claude/settings.json`, the permissions script
  carries them to the other clients, on the author's word.

## Who implements it

- `how-to/workflows/syntek-author/01-update-the-template/`: an update, from a clean tree to a
  commit.
- `how-to/workflows/syntek-author/02-recover-a-failed-update/`: an update that stopped part way.
- No skill runs either; follow them by hand, or through `run-workflow`.

## Governing standard

`.claude/rules/syntek-author/06-global-rules.md` Section 11 owns how an answer changes, and
Section 3 why the guide is read-only; `.claude/rules/syntek-author/01-layout-and-routing.md`
Section 7 owns which files are the template's and which are yours. The rules own the
requirement; this guide owns the everyday way through an update.
