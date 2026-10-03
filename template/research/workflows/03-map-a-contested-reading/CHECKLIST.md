---
workflow: 03-map-a-contested-reading
phase: research
skills: [tradition-check, category-check, research]
model: opus
---

# CHECKLIST.md — map a contested reading

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `research/docs/reference/contested-readings.md`, `standards/method/THEOLOGY.md` and the
> `tradition-check` skill. The structural-review gates are set by
> `standards/verification/verification.md`; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Read `research/docs/reference/contested-readings.md` and `standards/method/THEOLOGY.md`. · _opus_
- [ ] **Checked whether the map already exists**; if it does, extending it rather than starting again. · _sonnet_

## Execution Checklist

**The readings**

- [ ] Passage set out in the default translation, quoted from the translation itself, with enough context that the dispute is visible. · _opus_
- [ ] Readings named as their holders name them; no pejorative labels. · _opus_
- [ ] **Recognition test passed for every reading**; where it could not be, someone holding that view was read first. · _opus_
- [ ] Who holds each reading, and where, recorded from sources read; **no position attributed without a source**. · _opus_

**What turns on it**

- [ ] **What each reading does to the book's argument stated**, against the claim in `planning/src/arguments/` that rests on it. · _opus_
- [ ] Where the readings agree recorded. · _opus_
- [ ] Passage read whole; nothing taken by halves. · _opus_
- [ ] Every Hebrew and Greek term glossed from a source, philology kept separable; any unsourced gloss flagged `VERIFY`. · _opus_

**The recommendation**

- [ ] A reading recommended with a reason someone could argue with, labelled as interpretation; no false balance. · _opus_
- [ ] What would change if another reading were right stated. · _opus_
- [ ] `adopted:` left empty and an `AUTHOR TO CONFIRM` flag added until the author decides. · _opus_
- [ ] `tradition-check` run over the map; failures of the recognition test revised. · _opus_

**Filing**

- [ ] Map written to `research/src/contested-readings/<passage>.md`; no existing map overwritten. · _sonnet_
- [ ] Sources keyed and `make dump` and `make refs` run, where the citation database exists. · _sonnet_

## Done When

- [ ] **Every reading would be recognised by someone who holds it.** · _opus_
- [ ] What turns on each reading is explicit, and the agreements are named. · _opus_
- [ ] The recommendation and its reason are stated, and the decision sits with the author. · _opus_
- [ ] The map serves every chapter that needs it, not only the one that commissioned it. · _opus_
