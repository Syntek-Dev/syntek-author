# 09-data-root.md — where the binary files are kept: the store, the data root and its manifests

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

This file owns where the project's binary files are kept: scans, signed and received copies,
archives, issued copies, images, audio and video. Git keeps text well and binaries badly: every
version of a binary stays in the history for good, and no merge can compare two of them. The
data-root tool, `.claude/syntek-author-dataroot.py` (Python 3.14 or later), does every step,
and its map, `.claude/syntek-author-dataroot.json`, names this template's filing folders.

The steps that set up a machine and move files out: `how-to/workflows/syntek-author/04-set-up-the-data-root/`;
why the store exists: `how-to/src/TEMPLATE-GUIDE/the-data-root.md`, where the update has added it.

---

## 1. The store

<: if DATA_STORE == 'external' :>**This project keeps its binary files outside the repository** (`DATA_STORE` external). Each one
is filed under this machine's data root (Section 4) and listed, with its checksum, in a text
manifest that Git keeps (Section 5). The work tree keeps the text, and Git ignores the binary
types in the filing folders that hold records. Section 6 gives the commands.
<: endif :><: if DATA_STORE == 'repo' :>**This project keeps its binary files in the repository** (`DATA_STORE` repo), committed beside
their sources, as before. The data-root commands file nothing here: `make files-add` refuses and
says to commit the file instead, except for a generated file such as pronunciation audio, which
stays git-ignored in the work tree, and `make root` shows the state. Where a data root and this
repository contain one another, or a marker sits above the repository, every data command but
`make files-status`, which warns, stops with exit 2, filing a generated file included: the
author moves the repository or the marker.

**Moving them out** is the author's decision, never a session's. The author re-answers through
an update with Git's automatic housekeeping off for the run, as `.claude/syntek-author-agents.md`
('Enabling a client', step 1) explains:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml --data DATA_STORE=external
```

It delivers the ignore files and asks for the layout answers
(`how-to/workflows/syntek-author/01-update-the-template/`). Then, on each machine, the author sets
`SYNTEK_DATA_ROOT`, creates the marker and runs `make root`. After that, `make files-plan` lists
the binaries still tracked and where each would go, and `make files-plan COPY=1` files a copy of
each one without a conflict. A copy never untracks a file: the author removes the tracked ones from
Git once `make files-verify` passes. This file then describes the external store.
<: endif :>
**One project, one store.** Every template applied to this project records its own answers, and
they must agree: the same store and, outside the repository, the same area, slug and kind
folders. While two answers files that both record a store disagree, every data command refuses
(exit 2) and names them, and text work goes on. A template whose answers record no store yet is
'not yet asked': one warning, never a refusal. A different provider is a warning only.

**Why this rule exists.** A binary committed once is carried by every clone for good, and a
project's records (a signed contract, a statement, a copy as it was sent) are the files it can
least afford to lose or to find silently changed. Kept outside, each is checked by its checksum;
kept inside, each is at least versioned. Two stores at once would lose track of both.

---

## 2. The data root stays out of the session

**Requirement.** A data root is a folder outside every repository that holds the marker file
`.syntek-data-root`; this machine's is the one the environment variable `SYNTEK_DATA_ROOT` names.
Whichever store this project uses, never search, list, browse, edit or write anything under a
data root, by any tool or shell command, and never create, move, rename or delete anything
there, the marker included. Reach its files only through the data-root commands. Open a file
there only at the path the tool prints for it
(`python3 .claude/syntek-author-dataroot.py path <its path in the repository>`), and only when
the work needs that one file, such as an original to read.

**The guard.** Where `.claude/settings.json` wires it (a new project's does; an older project
adds it by hand), Claude Code runs the tool's `guard` before each `Edit`, `Write`, `MultiEdit`,
`NotebookEdit`, `Grep` and `Glob` call, and blocks one aimed at or under a data root. It is a
backstop, not the rule. On macOS, Linux and WSL Claude Code searches through the shell, which
the guard does not read, so there this rule alone keeps a search out of the root; no other
client runs the guard at all. A blocked call is reported, never retried another way.

**Why this rule exists.** The files under a data root are records. A search or a listing prints
their names and contents into the session, and from there into a handoff or a commit. An edit in
place breaks the checksum that proves a record unchanged. And one root serves every project on
the machine, so a stray write can land among another project's records.

---

## 3. The provider

**The data root's provider.** The owner chooses and runs the service that keeps a copy of the
data root (`DATA_PROVIDER` in the answers file); the template never syncs, uploads or deletes
anything there, and neither do you. `make root` prints that provider's checklist. Never create
or move a repository inside a synced folder, and never put the data root inside a repository.
Before reading many files under the root, run the data-root status target
(`make files-status`): it reports online-only files, which a read downloads. A file the manifest
does not list is reported, with a hint where its name looks like a provider's conflict copy:
never rename or delete one; tell the owner.
<: if DATA_STORE == 'repo' :>
While this project keeps its files in the repository, the answer only tailors what `make root`
prints; it applies once the files move out.
<: endif :><: if DOC_TYPE == 'business' and (DATA_PROVIDER | default('google-drive')) == 'google-drive' and (DATA_STORE | default('repo')) == 'repo' :>
**The Google Drive workflows** in `.github/` are the one thing the template runs for a provider.
On GitHub's servers, with the owner's own secrets, the push sends issued documents to a Drive
folder and the pull adds new ones without overwriting any the repository holds; neither touches
a data root. They ship only while this project answers Google Drive and keeps its files in the
repository: another provider, or the external store, deletes them on the next update, edits
included.
<: endif :><: if DATA_STORE == 'external' :>
---

## 4. The root and the layout

**The root** is per machine: never a Copier answer, and never written in a tracked file. Each
machine sets `SYNTEK_DATA_ROOT` to the absolute path of a folder outside every repository, in
the environment Claude Code, `make` and the terminal start from (a shell profile, or the
system's environment settings on Windows). `tooling/project.mk` never sets it: an empty
assignment there hides the machine's value. The owner creates the marker once, at the top of
that folder (`touch "$SYNTEK_DATA_ROOT/.syntek-data-root"`). Its presence is enough, and its
absence is how the tool notices a disk that is not mounted; the tool never writes it.

**A root that is set but not valid** (empty, relative, not a folder, without the marker, inside
this repository or holding it, or with a marker in a folder above the repository) stops every
data command with exit 2 and the reason, except `make files-status`, which warns that it did not
check the copies; such a root is never passed over for another. With no root at
all, text work runs as usual (drafting, lint, flags, proofs, the comparison), while filing<: if DOC_TYPE == 'business' :>
and issuing<: endif :> stop with exit 2 and never fall back to writing into the repository.

**The layout.** Below the root, every file keeps the path it has in the repository:

```text
<root>/<% DATA_AREA %>/<kind folder>/<% DATA_SLUG %>/<the file's path in the repository>
```

The kind folders are `<% DATA_KIND_DOCS %>` (documents), `<% DATA_KIND_PHOTOS %>` (images), `<% DATA_KIND_AUDIO %>` (audio)
and `<% DATA_KIND_VIDEOS %>` (video): `make root` prints each in full for this machine. A frozen
name stays frozen there, so a reference keeps its path. In prose, a file kept there is named
`ext:<its path in the repository>`, such as `**Attachment:** ext:<path>/quote.pdf`
(`08-naming-and-memory.md` Section 1). A reader of a file looks in the work tree first, then at
the same path under the root.

**Changing an answer.** The area, the slug and the kind folders change only through
`copier update`, never by hand (`06-global-rules.md` Section 11), and a change moves no file.
Each manifest row records the folder its file was filed under, so the commands still find it,
and `make root` and `make files-status` name every folder that still holds files under older
answers; moving them is the author's. A change of case alone is refused. Leaving the external
store forgets these answers, so note them first.

---

## 5. Filing folders, kinds and the manifest

**The filing folders** are those the map names, where this project has them:

<: if DOC_TYPE == 'business' :>- `library/src/`: every file in it is a document, whatever its extension, so a scanned receipt
  stays with its record;
<: endif :>- `research/src/`: sources, scans and evidence;
<: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>- `proposal/src/`: what is sent out with the proposal;
<: endif :>- `assets/`: the images and other binaries the work uses. Its binaries stay tracked in this
  release, and `make files-status` warns about any file over 1 MiB there<: if DOC_TYPE == 'fiction' :>;
- `world/src/`: the story bible's binaries<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, generated pronunciation audio among them<: endif :><: endif :>.

**The kind** of a file follows its folder where the folder fixes one, otherwise its extension,
by the table the tool holds (`python3 .claude/syntek-author-dataroot.py --help`); an extension
the table does not list is a document.

**Git.** An ignore file in each folder that holds records
(<: if DOC_TYPE == 'business' and DATA_STORE == 'external' :>`library/src/.gitignore` and <: endif :><: if DATA_STORE == 'external' :>`research/src/.gitignore`<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL and DATA_STORE == 'external' :> and `proposal/src/.gitignore`<: endif :>)
keeps the binary types and the tool's `*.syntek-tmp` files out of Git, never a `README.md` or a
manifest. An ignore rule never untracks a file: a binary committed earlier stays tracked until
the author removes it from Git (`make files-plan`, Section 6).<: if DOC_TYPE == 'fiction' :> `world/src/.gitignore` keeps generated audio ignored, as before.<: endif :>

**The manifest.** A filing folder that holds a filed copy has an `external.toml`, which the tool
creates on its first `add` there. Each row gives a copy's path, kind, the folder it was filed
under, its role, its checksum, its size, the date and its state, with its source and any label
or former name. It is the author's content: commit it with the work, and never edit, reorder or
delete a row by hand. Rows are appended and never deleted; the one change in place is a row's
state, from `current` to `superseded` or `withdrawn`, which the tool makes when a copy is
superseded. `make files-verify` fails on a committed row that was removed or changed.

**Roles.** Each row has one: `issued` (a copy as sent), `signed`, `ingested` (an original taken
in), `received`, `archive`, `evidence`, `asset` or `generated` (made by a tool, such as audio).
`signed`, `evidence`, `ingested` and `received` are evidence: an evidence copy is never replaced
(`FORCE=1` refuses it), and a changed file is a failure, never an update. A role another
template's map adds belongs to that template's work.

---

## 6. The commands

| Command | What it does |
|---|---|
| `make root` | Checks this machine's root and marker, and prints the store, the layout per kind and the provider's checklist; changes nothing. Run it first on a new machine, and whenever a data command refuses |
| `make files-add FILE=… ROLE=…` | Files a copy, checked by its checksum before its row is written. `AS=` is the path in the repository it belongs at (default: `FILE`'s own), `SOURCE=` what it was made from, `LABEL=` where else a copy is kept (a label, never a link), `FORCE=1` supersedes a filed copy and keeps the old one. It never overwrites, and refuses a name that is not Windows-safe or that differs only in case from one already there |
| `make files-status` | The loss check: binaries Git ignores in a filing folder that no row lists, which exist on this machine only; files over a folder's size warning; folders holding files under older answers; online-only copies; and copies under the root that no row lists, with a hint where a name looks like a provider's conflict copy |
| `make files-verify` | Hashes every current copy against its row and fails on a missing, changed or unlisted one. `GLOB=` narrows it; an online-only copy is skipped unless `HYDRATE=1`, which downloads it |
| `make files-pull` | Copies filed copies into the work tree, where Git ignores them, checking each hash; never replaces a different file. `GLOB=` narrows it; reading an online-only copy downloads it |
| `make files-plan` | Lists the binaries still tracked in a filing folder, where each would be filed, the role it proposes from the name and every conflict; `COPY=1` files the ones without a conflict, and never moves or untracks one |
<: if DOC_TYPE == 'business' :>| `make pdf FILE=… ISSUE=1` | Issues a document: the copy is filed with role `issued` and the document as its source (`04-build-pipeline.md` Section 1) |
<: endif :>
**Exit codes** (the tool's; `make` shows them as `Error 1` or `Error 2`): `0` done; `1` a check
failed (a copy missing or changed, a binary not filed); `2` the command cannot act (no valid
root, answers that disagree, a refused name or role). Report a failure to the author with the
tool's own line, and never work round it by copying, moving or editing a file yourself.

- **File a copy only where a skill or a workflow step says so, or the author asks.** `FORCE=1`
  and `COPY=1` need the author's word for that run. `make files-plan` proposes `signed`,
  `ingested`, `issued`, `asset` or `archive` from each name: file a copy that needs another role
  with `make files-add` first.
- **A generated file** (pronunciation audio, say) is written into its git-ignored folder in the
  work tree, never straight under the root, then filed with `make files-add FILE=… ROLE=generated`.
<: if DOC_TYPE == 'business' :>- **A sent Word copy** is filed by hand:
  `make files-add FILE=build/<stem>.docx AS=<the document's path>.docx ROLE=issued`.
<: endif :>- **Run `make files-status` after filing, ingesting or pulling**, and before a handoff of that
  work. Report what it lists to the author; never delete, rename or tidy a file it names, a
  conflict copy included.
<: endif :>