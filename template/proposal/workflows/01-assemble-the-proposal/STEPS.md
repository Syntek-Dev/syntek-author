---
workflow: 01-assemble-the-proposal
phase: publish
skills: [build, research, fact-check, grill-with-docs, spelling, grammar]
model: opus
---

# STEPS.md — assemble the proposal

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for drafting the package's parts and building them into proofs. Each step
names the skill and guide it uses, and any `make` command. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then the package
> anatomy guide in `proposal/docs/reference/` and `proposal/docs/reference/comp-titles.md`. The
> `build` skill makes and reads the proofs.

## 1. Check what is decided, and what is blocked

> **Skill:** `grill-with-docs` · **Guide:** the package anatomy in `proposal/docs/reference/`

Read `.claude/MEMORY.md` (Decisions, Open questions). The sample, the positioning and the hook are
the author's decisions. Where one is open, put the question to the author; record only what the
author confirms. Do not decide it to unblock yourself. _Substantive._

## 2. Check what actually exists

> **Skill:** — · **Guide:** `proposal/src/sample/CONTEXT.md`

Look at `manuscript/src/` and the unit briefs, and note which units have every planned section
promoted. The sample can be named before it can be sent; never write a sentence implying more
exists than does. _Mechanical._

## 3. List the parts this package needs

> **Skill:** — · **Guide:** the package anatomy in `proposal/docs/reference/`

Read the anatomy guide and the table in `proposal/src/CONTEXT.md`. For each part, note its path,
what it must achieve, and whether it is empty, drafted or current. _Mechanical._

## 4. Draft the pitch

> **Skill:** — · **Guide:** the package anatomy in `proposal/docs/reference/`

The hook and the book in brief, with the author, in the voice of `standards/style/voice-notes.md`.
Honest before persuasive: promise no more certainty, drama or reach than the book delivers.
Replace each part's stub banner with the prose. _Substantive._

## 5. Research and verify the comparable titles

> **Skill:** `research` · **Guide:** `proposal/docs/reference/comp-titles.md`

Search by shelf, then confirm **author, title, publisher, year and that it is in print** at the
source. Each entry gets a one-line differentiator, not a summary. Be honest where a comparable
title is strong. _Substantive._

## 6. Write the book's summary for the reader

> **Skill:** — · **Guide:** the package anatomy in `proposal/docs/reference/`

The outline or the synopsis the anatomy calls for, written from the unit briefs in
`planning/src/units/` and the promoted manuscript, **for the reader who will receive it**, not
lifted from the briefs. Check it against the book as it stands. _Substantive._

## 7. Write the author section

> **Skill:** `fact-check` · **Guide:** the package anatomy in `proposal/docs/reference/`

The standing to write this book, not a follower count. Present tense for what the author does now,
past for what they did; every claim checked against `.claude/MEMORY.md` (Facts) or put to the
author. **Confirm before naming any employer, client or person.** _Substantive._

## 8. Source every claim

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Every market, 'why now', platform or reach claim goes through
`research/workflows/02-verify-a-claim/` and carries its verdict; anything `cannot-be-dated` or
`unsupported` is cut. _Substantive._

## 9. Point at the sample

> **Skill:** — · **Guide:** `proposal/src/sample/CONTEXT.md`

Recommend the sample with reasons; the author chooses. Add a row to
`proposal/src/sample/sample-index.md` for each unit the author chose (only units whose sections
are all promoted), and record the choice in `.claude/MEMORY.md` `## Decisions`. Never copy prose
into the package. _Substantive._

## 10. Proofread

> **Skill:** `spelling` · **Guide:** `standards/style/style-sheet.md`

Run `spelling` and `grammar` over every part as a supportive report: what, where, the offered
correction, recurring items grouped. Names, titles and figures checked against their sources.
Apply only what the author accepts. _Substantive._

## 11. Build and read the proof

> **Skill:** `build` · **Guide:** `.claude/rules/syntek-author/04-build-pipeline.md`

Build each part with the `SCOPE=` the table in `proposal/src/CONTEXT.md` gives, for example:

```sh
make docx SCOPE=proposal/src/<part>
```

Confirm the echoed file list matches the parts, then **read the proof**: a proof nobody has read
proves nothing. The build is mechanical; reading it is not. _Substantive._

## 12. Hand back

> **Skill:** `build` · **Guide:** the package anatomy in `proposal/docs/reference/`

Report the proof paths, what is drafted, **what is blocked and on whose decision**, and anything
needing the author's confirmation before submission. **Nothing is sent.** _Substantive._
