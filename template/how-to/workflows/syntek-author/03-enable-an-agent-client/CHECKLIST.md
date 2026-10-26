---
workflow: 03-enable-an-agent-client
phase: plan
skills: []
model: opus
---

# CHECKLIST.md — enable an agent client

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `how-to/docs/syntek-author/enabling-an-agent-client.md`. No gate in
> `standards/verification/verification.md` applies: this procedure changes the template's files
> and the project's settings, never the text of the work.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The author has named the client to add, and the full list of clients the project keeps. · _opus_
- [ ] The tree is clean and committed, as step 1 of `01-update-the-template/` asks. · _sonnet_

## Execution Checklist

**Record**

- [ ] The client recorded through an update, run as `01-update-the-template/` runs it, with the whole `AGENT_CLIENTS` list and the five `GIT_CONFIG_*` variables; its report read and the update committed. · _sonnet_

**Fresh render**

- [ ] A fresh project rendered into a temporary folder from the recorded source and version, with the answers file as `--data-file`; never a copy over the real project. · _sonnet_

**Files**

- [ ] Only the missing client files the bridge's list names copied in, each on the author's word. · _opus_
- [ ] Every client file that already existed combined by hand with the author, never overwritten. · _opus_
- [ ] `.agents` settled: a real folder with its `skills` link where it was missing; every other case agreed with the author and left as the bridge says. · _opus_
- [ ] An existing `AGENTS.md` or `GEMINI.md` given the agreed line sending its client to every bridge. · _opus_

**Permissions and the client**

- [ ] The permissions script run with `--check`, with `--write` on the author's word, and `--check` again. · _sonnet_
- [ ] The client restarted from the project's top folder, trusted where it asks, and confirmed to read its entrypoint, the bridge, the rules, the memory and the skills. · _sonnet_

## Done When

- [ ] **No file the project already had was overwritten.** · _opus_
- [ ] The client recorded in `.claude/MEMORY.md`, the temporary folder deleted, and everything committed. · _sonnet_
