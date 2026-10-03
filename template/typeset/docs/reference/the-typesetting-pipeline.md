---
type: guide
skills: [typeset, build]
model: opus
---

# The typesetting pipeline — from Markdown to the printed page, and back

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The author writes Markdown; the printed book is LaTeX. Between them sits a
pipeline built so that the AI can style the page without ever retyping a word: Pandoc writes the
words, the AI adds only house macros, and a check proves the words survived.

## The stages

```text
manuscript/src/NN-kebab-title/NN-kebab-title.md         the author's words (promoted sections)
  └─ make tex ──► typeset/src/units/.base/NN-kebab-title.tex   Pandoc's LaTeX: the base
       └─ copy once, then style ──► typeset/src/units/NN-kebab-title.tex   the styled file
            └─ make tex-check ──► the styled file's words = the Markdown's words, or it fails
                 └─ make print ──► typeset/src/book.tex with XeLaTeX ──► build/typeset/book.pdf
```

`make tex` never touches a styled file. It writes the base, and says what to do next: copy the
base the first time, or carry the styling forward when the base has changed.

## Two proofs, two jobs

| Command | Reads | For |
|---|---|---|
| `make pdf SCOPE=…` | the Markdown, directly | a quick look at any stage, from any status |
| `make print` | `typeset/src/book.tex` and the styled chapters | the book as a printer receives it |

Both are proofs, and proofs are ungated. Sending the print PDF to a printer or publisher is a
release, and a release waits for `final`.

## After the Markdown changes

A promoted section is revised, so the chapter's words change. Re-typesetting never starts again
from scratch, which would throw the styling away; it carries the styling across:

1. `make tex` writes the new base and keeps the old one in `build/typeset/`.
2. `git merge-file` applies the change from old base to new base onto the styled file.
3. Where a changed line also carried styling, the merge marks a clash. The new base's words win;
   the styling is put back on them.
4. `make tex-check` proves the result, and the old base in `build/typeset/` is deleted.

One sentence per line in the Markdown is what makes this work: Pandoc keeps the line breaks, so a
changed sentence is a changed line, and most styling sits on lines the edit never touched.

## How we apply it here

- Typeset a chapter once its sections are promoted; re-typeset whenever its Markdown changes.
- Commit a base and its styled file together, so the next carry-forward has the right ancestor.
- Run `make tex-check` before every `make print`, and read every warning `make print` echoes.

## Who implements it

- **Skills:** `typeset` runs every stage; `build` runs the quick proofs.
- **Workflows:** `typeset/workflows/02-typeset-a-chapter/`,
  `typeset/workflows/03-retypeset-after-edits/`, `typeset/workflows/04-typeset-the-book/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns the rule that the author's words are the
author's; `standards/verification/verification.md` Section 5 owns proofs and release;
`.claude/rules/syntek-author/04-build-pipeline.md` owns the targets. The rules own the
requirements; this guide owns the order of the stages.
