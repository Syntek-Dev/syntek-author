---
workflow: 01-ingest-a-source
phase: research
skills: [research]
model: opus
---

# CHECKLIST.md — ingest a source

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `research/docs/reference/ingesting-sources.md` and the `research` skill. The evidence
> gate is set by `standards/verification/verification.md`; this list never restates it.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Read `research/docs/reference/ingesting-sources.md`. · _opus_
- [ ] **Routed the material with the table in `research/src/CONTEXT.md`**: a checkable claim sent to `02-verify-a-claim`, specialist material to its own procedure. · _opus_

## Execution Checklist

**Reading**

- [ ] **Primary source reached**, the chain followed back; any reliance on a secondary account noted in the note. · _opus_
- [ ] Bibliographic details captured in full, with the accessed date for anything online. · _sonnet_
- [ ] The note records what the work argues, not what it is about. · _opus_
- [ ] Quotable passages copied exactly, **with page numbers or locators**. · _opus_
- [ ] **Where the source disagrees with the work recorded**: how it would resist, not just that it might. · _opus_
- [ ] The units it serves named from `planning/src/units/`. · _opus_

**Filing**

- [ ] Note written in the source-note format; split across folders where needed, not duplicated. · _sonnet_
- [ ] No verdict smuggled into the note. · _opus_
- [ ] No existing note overwritten; superseded with a dated addition instead. · _sonnet_
- [ ] Key minted with the add-reference skill (collision-checked, never renamed) where the project keeps the citation database; otherwise bibliographic details confirmed complete. · _opus_
- [ ] `make dump` and `make refs` run where the citation database exists. · _sonnet_

## Done When

- [ ] **Nobody needs to read this source again to use it.** · _opus_
- [ ] The note says what it argues, what is quotable and where, which units it serves, and where it disagrees. · _opus_
- [ ] Handed back: key, location, units served, and the disagreement found. · _opus_
