---
workflow: 02-typeset-a-chapter
phase: publish
skills: [typeset]
model: opus
---

# STEPS.md — typeset a chapter

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for setting one chapter for print for the first time. Run from the
**repository root**: every `make` command and path is relative to it. Each step names the skill
and the guide it uses. **Run in order**: the check comes before the print. Tick `CHECKLIST.md` as
you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `typeset`
> skill is this procedure in skill form; read its mode file before step 1.

## 1. Confirm the chapter and the page design

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

Name the chapter (`NN-kebab-title`) with the author. Its sections should be promoted: the base is
made from `manuscript/src/NN-kebab-title/NN-kebab-title.md` as it stands, and drafts never print.
Confirm `typeset/src/units/NN-kebab-title.tex` does **not** exist (if it does, use
`typeset/workflows/03-retypeset-after-edits/`). Note any page-design choice still open in
`typeset/src/page-design.md`; the class default stands in for it. _Substantive._

## 2. Make the base

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make tex SCOPE=manuscript/src/NN-kebab-title
```

Read what it prints: `wrote typeset/src/units/.base/NN-kebab-title.tex` and the next step. A
warning from the house filter (a native-script word with no glyph, say) is reported to the author.
_Mechanical._

## 3. Start the styled file from the base

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
cp typeset/src/units/.base/NN-kebab-title.tex typeset/src/units/NN-kebab-title.tex
```

This copy is the only way a styled file is ever created. _Mechanical._

## 4. Style it with house macros only

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Add only what the house-class guide lists under 'Macros the styling may add', placed around words
that are already there, and follow the mode file's additions for this kind of book. Never type,
reorder or correct a word; never add or remove a scene break or an epigraph. Leave page-fitting
for step 8. Then read the difference from the base: every changed line must differ only by
macros. _Substantive._

## 5. Prove the words

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-fidelity-check.md`

```sh
make tex-check UNIT=NN-kebab-title
```

It must pass. A difference means the styled file is wrong: undo the edit that caused it, or copy
the line back from the base, and run it again. Never change the Markdown to make it pass. Read
every warning: a command the house does not use comes out. _Mechanical (a fix, when one is
needed, is substantive)._

## 6. Add the chapter to the book

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Add `\houseinput{units/NN-kebab-title}` to the main matter of `typeset/src/book.tex`, in the order
of `planning/src/outline.md`. _Mechanical._

## 7. Print and read the proof

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make print
```

Read the warnings it echoes (a missing typeface or character, an open flag, a file left out), then
the chapter: the opener, the epigraph and its source, every scene break, the drop capital,
footnotes under their sentences, and anything the mode file adds. _Substantive._

## 8. Fit the pages, if the proof needs it

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

For a widow, an orphan or a lone line at a chapter's end: one page-fitting command at a time,
then steps 5 and 7 again. Skip this step for a working proof. _Substantive._

## 9. Report back

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

Give the proof's path, the styling added, the check's result, every warning and what it means,
and any open page-design choice the proof relied on. Advise committing the base and the styled
file together. _Substantive._
