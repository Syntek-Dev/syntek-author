---
type: guide
skills: []
model: opus
---

# Setting up the data root — preparing a machine and moving binary files out of Git

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Git keeps text well and binary files badly: every version of a scan, a signed
copy, an image or a recording stays in its history for good. So a project whose `DATA_STORE`
answer is `external` keeps those files in one folder outside the repository on each machine,
the data root, and keeps in Git only a manifest, `external.toml`, that lists each copy with its
checksum. A project answered `repo` keeps them in Git, as before, until the author moves them
out. Setting up the data root prepares one machine; moving files out copies the binaries Git
already holds to it, checks them, and only then takes them out of Git.

## One root per machine

The data root is a folder the author chooses on each machine, outside every repository and
holding none. A sync service may keep a copy of it, but never of a repository, which a service
copying file by file can corrupt. The environment variable `SYNTEK_DATA_ROOT` names the root,
never a file in the project, so each machine can keep it in a different place. An empty marker
file, `.syntek-data-root`, at its top proves it is there: a network disk that is not mounted
shows an empty folder, and the missing marker gives it away. The tool never creates the marker,
and a session never writes under the root, the marker included. `make root` checks the root and
the marker, and prints the store, where each kind of file goes and the checklist for the
service that keeps a copy. Text work needs no root at all: drafting, proofs and checks run
without one.

## Moving files out

Moving is a copy, never a move. `make files-plan` lists every binary Git still holds in a filing
folder, where each would go and its role, and changes nothing. A role it cannot show from
evidence is marked `?`: the author chooses it and files that file with `make files-add`. With
`COPY=1`, it files a copy of each one that has a role and no conflict and writes its row in that
folder's `external.toml`. `make files-verify`
then checks every filed copy against its checksum. Only once verify passes, on every machine
that will use the files, does the author take the originals out of Git with `git rm --cached`,
which leaves them on disk, where Git now ignores them. Taking a file out of Git deletes it from
every other clone when that clone next pulls, which is why every machine is set up and checked
first.

## How we apply it here

- The author sets `SYNTEK_DATA_ROOT` and creates the marker, in their own terminal; a session
  never searches, lists or writes anything under a data root.
- `make root` runs first on a new machine, and again whenever a data command refuses.
- `COPY=1`, and taking a binary out of Git, happen only on the author's word, each time.
- A refusal is reported with the tool's own line, and never worked round by copying, moving or
  editing a file by hand.
- Each `external.toml` is committed with the work it lists, and never edited by hand.
- A project answered `repo` moves its files out only through an update that re-answers
  `DATA_STORE`, which is the author's decision.

## Who implements it

- `how-to/workflows/syntek-author/04-set-up-the-data-root/`: every step, with its commands.
- No skill runs it; follow it by hand, or through `run-workflow`.
- `how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains why the store exists, and how every
  template in a project shares one layout.

## Governing standard

`.claude/rules/syntek-author/09-data-root.md` owns the store, the root, the layout, the manifest
and every command; `.claude/rules/syntek-author/06-global-rules.md` Section 12 keeps the root
out of the session. The rules own the requirement; this guide owns the order of the setting up.
