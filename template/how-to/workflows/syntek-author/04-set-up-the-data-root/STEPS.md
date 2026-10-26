---
workflow: 04-set-up-the-data-root
phase: plan
skills: []
model: opus
---

# STEPS.md — set up the data root

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for preparing this machine's data root and moving the binary files Git
holds out to it. Each step names the guide it uses. **Run in order**: nothing is copied before
the root is checked, and nothing leaves Git before its copy is verified. Work from the top folder
of the project, and tick `CHECKLIST.md` as you go. Every command runs exactly as written, in
bash, zsh or another POSIX shell.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). No skill runs
> this procedure. The author sets the root; a session never writes under it.

## 1. Read the store

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

This command checks this machine's data root and prints the store the answers record, where each
kind of file would go and the checklist for the service that keeps a copy; it changes nothing:

```bash
make root
```

Read its `store:` line. Where it says `external`, go on at step 2. Where it says `repo`, the
project keeps its binary files in Git, and there is nothing to set up: stop here, unless the
author decides to move them out. That decision is the author's alone, and goes through an
update: follow steps 1 to 3 of `how-to/workflows/syntek-author/01-update-the-template/`, then
the author runs this command in their own terminal in place of its step 4, answering the layout
questions Copier then asks, and follows its steps 5 to 8:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml --data DATA_STORE=external
```

It delivers the ignore files for the binary types and moves nothing. Then start this procedure
again at step 1. _Substantive._

## 2. Choose the root and the provider with the author

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

Agree with the author where this machine's data root lives: a folder outside every repository,
on a local disk or a mounted network share, never inside a repository and never holding one. A
sync service may keep a copy of the root, but the repository itself never sits in a folder a
sync service copies. One root can serve every project on the machine. Then
read with the author the provider checklist `make root` printed: the provider, the
`DATA_PROVIDER` answer, names the service that keeps a copy of the root, which the author
chooses, sets up and runs. Where the answer no longer matches the service, it changes through
an update (`how-to/workflows/syntek-author/01-update-the-template/`), never by hand.
_Substantive._

## 3. The author sets the variable and creates the marker

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

The author runs both commands in their own terminal; the session never writes under the root,
the marker included (`.claude/rules/syntek-author/06-global-rules.md` Section 12). This example
uses a folder called data-root in the author's home folder; they put the folder they chose in
its place:

```bash
export SYNTEK_DATA_ROOT="$HOME/data-root"
```

To keep it for every new terminal, they also add that line to their shell profile, `~/.zshrc`
or `~/.bashrc`; on Windows, they set it in the system's environment settings instead. Then this
command creates the folder, with the empty marker file at its top:

```bash
mkdir -p "$SYNTEK_DATA_ROOT" && touch "$SYNTEK_DATA_ROOT/.syntek-data-root"
```

Neither prints anything when it works. A session started before the variable was set does not
see it: the author restarts the session from a terminal where it is set. _Mechanical._

## 4. Check again

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

```bash
make root
```

Its `root:` line should now name the folder, its `origin:` line the environment variable
`SYNTEK_DATA_ROOT`, and its `marker:` line say `present`. Where it stops with a reason instead,
such as a root inside the repository or a missing marker, read the reason to the author, who
fixes it in their own terminal; then run it again. _Mechanical._

## 5. Plan the copies

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

This command lists every binary file Git still holds in a filing folder, where each would be
filed, the role it proposes, and every conflict; it changes nothing:

```bash
make files-plan
```

It ends with a line such as `plan: 2 to file, 0 filed already, 0 conflicts`. Read the list with
the author. A conflict is settled with them first; a file that needs a role other than the one
proposed is filed on its own first, with `make files-add` and its `FILE=` and `ROLE=`, as
`.claude/rules/syntek-author/09-data-root.md` Section 6 says. Then, only on the author's word
for this run, this command files a copy of each file without a conflict, and moves and untracks
nothing:

```bash
make files-plan COPY=1
```

It prints a `filed:` line for each copy, and ends with how many it copied and how many failed.
_Substantive._

## 6. Verify

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

This command checks every filed copy against the checksum in its manifest:

```bash
make files-verify
```

It should report `missing 0, changed 0, unlisted 0`. Then this command checks for files at
risk, such as binaries no manifest lists:

```bash
make files-status
```

Its `tracked:` line names how many binaries Git still holds. Where either command reports a
failure, read its own line to the author and stop; never work round it by copying, moving or
editing a file by hand. _Mechanical._

## 7. Commit the manifests

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/setting-up-the-data-root.md`

Each filing folder that now holds a copy has a new manifest, `external.toml`. This command
lists them, among any other changes:

```bash
git status --short
```

Each manifest is marked `??` where it is new, or `M` where it changed. This command commits
every manifest, and nothing else:

```bash
git add -- '*external.toml' && git commit -m 'File binary copies under the data root'
```

The binaries themselves stay in Git until the author decides otherwise. Only once
`make files-verify` passes on every machine that uses the project, and only on the author's
word, take each one out of Git with `git rm --cached` followed by its path: the file stays on
disk, where Git now ignores it. Commit that too. Taking a file out of Git deletes it from every
other clone when that clone next pulls. _Mechanical._
