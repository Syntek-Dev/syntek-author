---
workflow: 02-create-a-place
phase: produce
skills: [create-name]
model: opus
---

# CHECKLIST.md — create a place

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/story-bible.md`, `world/docs/reference/naming.md` and the
> `create-name` skill. Gates cite `standards/verification/verification.md` by number; this list
> never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The place's job in the story agreed with the author: which scenes, and what it does for them. · _opus_

## Execution Checklist

**Before inventing anything**

- [ ] Read the register, the existing place files, the characters tied to the place, `planning/src/timeline.md` and `planning/src/continuity.md`. · _opus_
- [ ] Every existing journey that must fit this place listed. · _opus_

**The place**

- [ ] Kind and containing place settled with the author. · _opus_
- [ ] **Travel times fixed to every connected place, and each tested against `planning/src/timeline.md`.** · _opus_
- [ ] Any clash with the timeline reported with both locations, not adjusted. · _opus_
- [ ] Three to five name options given, with reasoning, IPA and respelling, clash-checked against the register. · _opus_
- [ ] The author chose the name. · _opus_
- [ ] Senses recorded from a point-of-view character's arrival; history limited to what scenes use. · _opus_
- [ ] Who holds it and its rules recorded, with people linked to their files or rows. · _opus_
- [ ] Real-world details verified, or flagged `VERIFY`. · _opus_

**Writing it down**

- [ ] Checked `world/src/places/<slug>.md` does not exist; if it did, stopped and asked. · _sonnet_
- [ ] Place file written from the skeleton, one sentence per line, `first_appears` empty. · _sonnet_
- [ ] Register row added: kind `place`, IPA, respelling, language, meaning. · _sonnet_

## Done When

- [ ] **A scene could be set here, and a journey made to it, without inventing anything.** · _opus_
- [ ] The name is registered, and no clash was left unreported. · _opus_
- [ ] Handed back: file written, travel times, timeline clashes, open flags, unverified details. · _opus_
