---
workflow: 03-retypeset-after-edits
phase: publish
skills: [typeset]
model: opus
---

# STEPS.md — re-typeset a chapter after edits

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for carrying a chapter's styling onto its revised words. Run from the
**repository root**. Each step names the skill and the guide it uses. **Run in order**: the merge
needs the old base, and `make tex` is what keeps it. Tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `typeset`
> skill is this procedure in skill form; read its mode file before step 1.

## 1. Confirm what changed

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

Name the chapter (`NN-kebab-title`). Confirm the revision is promoted in
`manuscript/src/NN-kebab-title/NN-kebab-title.md`, and that `typeset/src/units/NN-kebab-title.tex`
exists (if not, use `typeset/workflows/02-typeset-a-chapter/`). _Substantive._

## 2. Write the new base

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make tex SCOPE=manuscript/src/NN-kebab-title
```

It reports `updated`, keeps the old base as `build/typeset/NN-kebab-title.old-base.tex` and
prints the merge command. If it reports `unchanged`, the base was already brought up to date by an
earlier `make tex`: run `make tex-check UNIT=NN-kebab-title`, and stop if it passes; if it fails,
carry on, and step 3 finds the old base. _Mechanical._

## 3. Make sure the old base is the right one

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

The old base must be the base the styled file was made from. If `make tex` kept none (it ran
earlier, or `make clean` removed `build/`), take the base from the commit that last changed the
styled file, since the two are committed together:

```sh
c=$(git log -1 --format=%H -- typeset/src/units/NN-kebab-title.tex)
git show "$c:typeset/src/units/.base/NN-kebab-title.tex" > build/typeset/NN-kebab-title.old-base.tex
```

_Mechanical._

## 4. Carry the styling across

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
git merge-file --diff3 -L styled -L old-base -L new-base \
  typeset/src/units/NN-kebab-title.tex \
  build/typeset/NN-kebab-title.old-base.tex \
  typeset/src/units/.base/NN-kebab-title.tex
```

It rewrites the styled chapter in place and exits with the number of clashes (0 is a clean
merge). _Mechanical._

## 5. Resolve every clash from the new base

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Each clash shows three versions between `<<<<<<< styled`, `||||||| old-base`, `=======` and
`>>>>>>> new-base`. Keep the **new-base** lines, then re-apply the styling the `styled` lines
carried, by the same macros. Delete every marker. Never type a word: copy the new line. If a
styled line has no place in the new text (its sentence was cut), its styling goes with it.
_Substantive._

## 6. Prove the words

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-fidelity-check.md`

```sh
make tex-check UNIT=NN-kebab-title
```

It must pass against the revised Markdown; it also fails on any conflict marker left behind.
_Mechanical (a fix, when one is needed, is substantive)._

## 7. Print and read the changed pages

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make print
```

Read the pages around each change: an edit can undo a page-fit made earlier (a widow returns, a
nudge is no longer needed). Fix by `02-typeset-a-chapter` step 8, then check and print again.
_Substantive._

## 8. Tidy and report

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

Delete `build/typeset/NN-kebab-title.old-base.tex`. Report the number of clashes and how each was
resolved, the check's result and the proof's path; advise committing the new base and the styled
file together. _Mechanical._
