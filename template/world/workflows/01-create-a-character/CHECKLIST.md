---
workflow: 01-create-a-character
phase: produce
skills: [create-name, chart-character-arc]
model: opus
---

# CHECKLIST.md — create a character

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/story-bible.md`, `world/docs/reference/naming.md` and the
> `chart-character-arc` and `create-name` skills. Gates cite
> `standards/verification/verification.md` by number; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The character's job in the story agreed with the author: role, chapters, the gap they fill. · _opus_
- [ ] Confirmed the character needs more than a name; otherwise routed to `world/workflows/03-name-something/`. · _opus_

## Execution Checklist

**Before inventing anything**

- [ ] **Read the register, the existing character files, the relevant places, `planning/src/continuity.md` and `planning/src/timeline.md`.** · _opus_
- [ ] Constraints listed, and any existing character this one would echo named for the author. · _opus_

**The character**

- [ ] Want, need, wound and the lie offered as options; the author chose each. · _opus_
- [ ] Want and need pull against each other, or the author was told they do not. · _opus_
- [ ] Three to five name options given, with reasoning, IPA and respelling, clash-checked against the register. · _opus_
- [ ] The author chose the name. · _opus_
- [ ] Three to six testable voice markers written, each with an invented example line marked as an example. · _opus_
- [ ] Relationships linked to existing files or register rows; continuity facts limited to what the book will use. · _opus_
- [ ] Every undecided detail flagged `AUTHOR TO CONFIRM`, not filled. · _opus_

**Writing it down**

- [ ] Checked `world/src/characters/<slug>.md` does not exist; if it did, stopped and asked. · _sonnet_
- [ ] Character file written from the skeleton, one sentence per line, `first_appears` empty. · _sonnet_
- [ ] Register row added: kind `character`, IPA, respelling, language, meaning. · _sonnet_
- [ ] Arc file `planning/src/arcs/<slug>.md` opened with arc type, want, need and lie, and linked from the character file. · _opus_

## Done When

- [ ] **A scene with this character could be drafted without inventing anything about them.** · _opus_
- [ ] The name is registered, and no look-alike or sound-alike clash was left unreported. · _opus_
- [ ] Handed back: files written, open flags, echoes and contradictions with both locations, and the pointer to `planning/workflows/04-chart-a-character-arc/` for the beats. · _opus_
