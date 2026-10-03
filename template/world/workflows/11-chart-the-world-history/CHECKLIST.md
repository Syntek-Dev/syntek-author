---
workflow: 11-chart-the-world-history
phase: produce
skills: [grill-with-docs, wayfinder, create-name]
model: opus
---

# CHECKLIST.md — chart the world history

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/world-history.md` and the `grill-with-docs` and `wayfinder`
> skills. Gates cite `standards/verification/verification.md` by number; this list never
> restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] What the story needs from the history agreed with the author. · _opus_

## Execution Checklist

**Before charting**

- [ ] Read the eras and events, the peoples, the cultures, the places, the timeline's Calendar and the continuity ledger; assumed movements listed. · _opus_
- [ ] Decided with the author whether a decision map is needed; if so, charted in `planning/src/maps/` with the order of the eras first. · _opus_

**Eras**

- [ ] Reckoning settled and recorded in `eras.md`. · _opus_
- [ ] **Eras settled oldest first, one row each, with no cell guessed.** · _opus_

**Events**

- [ ] Only events whose consequences reach the page or a language chosen, each placed in its era. · _opus_
- [ ] Checked each event file does not exist; if one did, stopped and asked. · _sonnet_
- [ ] Each file created from the skeleton and its slug added to its era's Events cell. · _sonnet_
- [ ] What happened, causes, and who it changed settled and recorded as each resolved. · _opus_
- [ ] Linguistic consequences stated for every event, 'none' where none; language work listed, no language file changed. · _opus_
- [ ] Each people's memory recorded as belief, apart from the record. · _opus_

**Checking and recording**

- [ ] Eras and events compared with peoples, cultures, places, timeline and continuity; every contradiction reported with both locations. · _opus_
- [ ] Invented era and event names chosen through `create-name` and registered with kind `event`. · _sonnet_

## Done When

- [ ] **Every event belongs to one era, and every era and event recorded was settled by the author.** · _opus_
- [ ] Handed back: eras, event files, map, language work, contradictions, open flags. · _opus_
