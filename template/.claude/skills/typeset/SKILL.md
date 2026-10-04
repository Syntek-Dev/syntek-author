---
name: typeset
description: >-
  Set the book for print through LaTeX without retyping a word: Pandoc writes each promoted
  chapter's base (make tex), the skill styles a copy with house-class macros only, make tex-check
  proves the styled file still carries exactly the Markdown's words, and make print sets the book
  with XeLaTeX. After the Markdown changes, carries the styling onto the new words with a
  three-way git merge-file. Walks the author through page design (trim, typefaces, chapter
  opener, scene-break mark, footnotes, drop capitals), recommending and recording only what the
  author chooses. Use when the author says 'typeset chapter 3', 'set this for print', 'make the
  print PDF', 'chapter 2 changed, update the typeset version', 'what trim size should we use',
  'add a drop cap' or 'is the print version still word for word?'. Not the quick proof of the
  Markdown (`build`). Not changing the words themselves, which goes back through the loop
  (`adapt-section`). Not moving a section into its chapter so it can be printed
  (`promote-section`).
---

# Skill: Typeset (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Turns promoted chapters into the printed book. One rule governs everything here: **the words come
from Pandoc, never from you.** You add house macros to a copy of what Pandoc wrote, `make
tex-check` proves every word survived, and the author makes every page-design choice. A styling
session that changes a word has failed, however good the page looks.

## Governing procedures (route here — do not restate at length)

- `typeset/workflows/01-design-the-page/` — page-design choices, asked one at a time, recorded.
- `typeset/workflows/02-typeset-a-chapter/` — **the procedure of record** for a first typesetting.
- `typeset/workflows/03-retypeset-after-edits/` — the three-way carry-forward after edits.
- `typeset/workflows/04-typeset-the-book/` — the whole book, front matter to back.
- `typeset/docs/reference/the-typesetting-pipeline.md`, `typeset/docs/reference/the-house-class.md`,
  `typeset/docs/reference/the-fidelity-check.md`, `typeset/docs/reference/semantic-markdown.md` —
  the stages, the macros and options, the check, and the marks the Markdown carries.
- `.claude/rules/syntek-author/03-authorship.md` — the author's words and the author's decisions.
- `standards/verification/verification.md` Section 5 — proofs are ungated; release is not.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Route the request and read the state.** Name the procedure by its full folder name (one of the
   four above) and the chapter or chapters, by folder name (`NN-kebab-title`). Read
   `typeset/src/page-design.md` for the choices still open, the `Decisions` heading of
   `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`), and
   `planning/src/outline.md` for the running order. Settle whether this is a working proof or a
   release print: a release needs every chapter `final` and the author's explicit word.
   *Complete when:* the procedure, the chapters and the open page-design choices are known.

2. **Settle page design with the author, when asked or when a choice blocks the work.** One choice
   at a time, trim first: the options, a recommendation and its reason, then the author's answer.
   Check a typeface is installed before recommending it, and leave its licence to the author.
   Record each answer in `page-design.md` (value, reason, date, flag removed, a decisions row) and
   set the class option in `typeset/src/book.tex` in the same change.
   *Complete when:* every choice the author made is in both files, and the open ones keep their
   flags.

3. **Make the base.** Run `make tex SCOPE=manuscript/src/NN-kebab-title` (no `SCOPE` for the whole
   book) and read what it prints: `wrote`, `unchanged` or `updated` for each base, the merge
   command for an updated one, and any warning from the house filter.
   *Complete when:* each chapter in hand has a current base, and every warning is noted.

4. **Start the styled file, or carry it forward.** A chapter never styled: copy its base to
   `typeset/src/units/NN-kebab-title.tex`, the only way a styled file is ever made. A chapter whose
   base was `updated`: run the `git merge-file --diff3` command `make tex` printed, against the old
   base the styled file was made from, and resolve every clash by keeping the new base's lines and
   re-applying the styling the old lines carried. Never type a word; never overwrite a styled file
   with a fresh base.
   *Complete when:* the styled file exists, carries the current words, and holds no conflict
   marker.

5. **Style with house macros only.** Add what `the-house-class.md` lists under 'Macros the styling
   may add', around words already there, and the mode file's styling for this kind of book. Never
   add or remove a scene break, an epigraph or a section: those are the author's marks, made in
   the Markdown. Leave page-fitting until a proof shows the need. Read the difference from the
   base: every change must be a macro.
   *Complete when:* the styling is in, and every difference from the base is a house macro.

6. **Prove the words.** Run `make tex-check UNIT=NN-kebab-title` (no `UNIT` for every chapter). It
   must pass. On a failure, fix the styled file (undo the edit, or copy the line back from the
   base); never change the Markdown to match. Treat each warning as a question, and take out any
   command the house does not use.
   *Complete when:* the check passes for every chapter touched, and no warning is left unexplained.

7. **Put it in the book, print, and read.** Add `\houseinput{units/NN-kebab-title}` to `book.tex`
   in outline order. Run `make print`, read every warning it echoes, then read the proof: the
   opener, epigraphs and sources, scene breaks, drop capitals, footnotes, running heads, and the
   mode file's items. For a widow or a lone line, add one page-fitting command, then steps 6 and 7
   again.
   *Complete when:* the print succeeded and every page touched has been read.

8. **Report back.** Give the proof's path, the styling added, the check's result, every warning and
   open flag with what it means, any clash and how it was resolved, and the page-design choices
   still open. Advise committing each base with its styled file. A release goes out only on the
   author's explicit word.
   *Complete when:* the author has the report, and nothing was released or decided on their
   behalf.

## Anti-patterns

- Retyping a paragraph to 'clean up' Pandoc's output, or fixing a typo in the LaTeX. Report the
  typo; it is fixed in the Markdown and re-typeset.
- Changing the Markdown, or the base, so that `make tex-check` passes.
- Adding a scene break, an epigraph or a heading in LaTeX that the Markdown does not mark.
- Overwriting a styled file with a fresh base, and so throwing the styling away.
- Keeping the old words in a merge clash because the styling was on them.
- Raw LaTeX the house does not list (`\textbf`, `\vspace`, a new package) to get a look.
- Recording a default as a decision, or choosing a typeface because you like it.
- Composing a dedication, acknowledgements or a biography, or inventing an ISBN.
- Printing a chapter that has not passed the check, or reporting a proof as read when it was not.

## Cross-references

- `build` — the quick proofs (`make pdf`, `make docx`, `make epub`) and the references export.
- `promote-section` — the only way words reach a chapter, and so the print.
- `adapt-section` and `improve-section` — where a wording problem found in a proof is fixed.
- `tooling/latex/housebook.cls`, `tooling/pandoc/house.lua`, `tooling/texcheck.py` — the class, the
  filter and the check.
- `.claude/rules/syntek-author/04-build-pipeline.md` — the targets, and what each needs installed.
