---
workflow: 04-set-up-the-data-root
phase: plan
skills: []
model: opus
---

# CHECKLIST.md — set up the data root

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `how-to/docs/syntek-author/setting-up-the-data-root.md`. No gate in
> `standards/verification/verification.md` applies: this procedure changes the template's files
> and the project's settings, and where its binary files are kept, never the text of the work.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The author is at hand, with a terminal of their own, to set the root and decide each copy. · _opus_

## Execution Checklist

**The store**

- [ ] `make root` read: `store: external`, or, under `repo`, the author's decision to stop or to move the files out through an update. · _opus_
- [ ] Where the store changed, the update run as `01-update-the-template/` runs it, ending `--data DATA_STORE=external`, its report read and the update committed. · _sonnet_

**The root**

- [ ] The root agreed with the author: outside every repository and holding none, with no repository in a folder a sync service copies. · _opus_
- [ ] The provider checklist read with the author, and the `DATA_PROVIDER` answer matching the service, or changed through an update. · _opus_
- [ ] `SYNTEK_DATA_ROOT` set and the marker created by the author, in their own terminal; the session wrote nothing under the root. · _sonnet_
- [ ] `make root` shows the root, its origin as the environment variable, and `marker: present`. · _sonnet_

**The copies**

- [ ] `make files-plan` read with the author; every conflict settled, and every `role ?` row and every file needing another role filed with `make files-add` on the author's choice of role. · _opus_
- [ ] `make files-plan COPY=1` run only on the author's word for this run. · _sonnet_
- [ ] `make files-verify` reports nothing missing, changed or unlisted, and `make files-status` was read to the author. · _sonnet_

## Done When

- [ ] **Every manifest committed as the tool wrote it**, with no row edited by hand. · _sonnet_
- [ ] **No binary left Git without the author's word**, and none before verify passed on every machine that uses the project. · _opus_
