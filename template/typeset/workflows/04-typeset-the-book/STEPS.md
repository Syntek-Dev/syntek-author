---
workflow: 04-typeset-the-book
phase: publish
skills: [typeset, build]
model: opus
---

# STEPS.md — typeset the book

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for assembling, proving and printing the whole book. Run from the
**repository root**. Each step names the skill and the guide it uses. **Run in order**: every
chapter is current and checked before the print that is read. Tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `typeset`
> skill is this procedure in skill form; read its mode file before step 1.

## 1. Take stock

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

List the chapters in `planning/src/outline.md` with their status from each brief, and say whether
this is a working proof or a release print. For a release, every chapter must be `final`
(`standards/verification/verification.md` Section 5). Run `make flags SCOPE=typeset/src` for
page-design choices still open. Report gaps before going on. _Substantive._

## 2. Bring every chapter up to date

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make tex
```

With no `SCOPE`, it writes a base for every chapter in `manuscript/src/`. For each chapter it
reports with no styled file, run `typeset/workflows/02-typeset-a-chapter/` from step 3; for each it
reports `updated`, run `typeset/workflows/03-retypeset-after-edits/` from step 4. _Mechanical
(each chapter's styling is substantive)._

## 3. Set the front and back matter

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Ask the author for the words of every page `book.tex` names in `typeset/src/frontmatter/` and
`typeset/src/backmatter/` (copyright, dedication, acknowledgements, about the author) and set each
as its folder's `CLAUDE.md` says. A page the author has not supplied stays out, and the print
warns. _Substantive (the words are the author's)._

## 4. Put the book in order

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Check `typeset/src/book.tex`: one `\houseinput{units/NN-kebab-title}` per chapter, in outline
order; the example chapter's line removed if the example is gone. For a release print, and with the
author's word, uncomment the `final` class option. _Substantive._

## 5. Prove every chapter

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-fidelity-check.md`

```sh
make tex-check
```

With no `UNIT`, it checks every styled chapter. All must pass. _Mechanical (a fix, when one is
needed, is substantive)._

## 6. Print

> **Skill:** `build` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make print
```

Where the project keeps references, it exports them and sets the reference list first. Read every
warning it echoes, a missing character above all (it prints as nothing); with `final` set, an
open flag or a missing character stops the print with its text. _Mechanical._

## 7. Read the whole book

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Every page, in order: the front matter, the contents against the chapter titles, each chapter
opener, running heads, folios, scene breaks, footnotes, the back matter, and anything the mode
file adds. Note widows, orphans and lone lines for step 8. _Substantive._

## 8. Fit the pages, and prove them again

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

One page-fitting command at a time, in the styled chapter concerned; then steps 5 and 6 again,
and a read of the pages that moved. _Substantive._

## 9. Report back

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

Give the PDF's path, its page count, every warning and open flag, any chapter not yet `final`,
and any page-design choice still open. A release goes out only on the author's explicit word.
_Substantive._
