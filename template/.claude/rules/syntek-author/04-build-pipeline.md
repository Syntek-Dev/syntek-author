# 04-build-pipeline.md — how sources become proofs, and the make targets

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

Markdown<: if DOC_TYPE == 'business' :> and LaTeX<: endif :> in `src/` folders is the only writing surface; everything else is
an export. The `Makefile` at the root is the single entry point, and `make help` lists every
target with its one-line description. **Where this file and `make help` disagree, `make help` is
right**, and this file is reported to the author as stale.

---

## 1. The pipeline

<: if DOC_TYPE != 'business' :>```text
<: if INCLUDE_REFERENCES :>tooling/references.db   (the SQLite master: edit here, never in build/)
  └─► tooling/export_refs.py ──► build/references.json   (CSL-JSON)
<: endif :>manuscript/src/**/*.md  (drafts/ and governance files excluded)
tooling/defaults.yaml   (title, subtitle, author, language en-GB)
tooling/pandoc/house.lua   (the house filter: epigraphs, scene breaks, small capitals<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, conlang words<: endif :>)
        │
        ▼
Pandoc<: if INCLUDE_REFERENCES :> --citeproc, with tooling/harvard.csl<: endif :>
        ├─► build/<scope>.docx   (for editors and publishers)
        ├─► build/<scope>.pdf    (XeLaTeX proof, laid out by tooling/book.latex)
        ├─► build/<scope>.epub   (a reading proof)
        └─► typeset/src/units/.base/NN-kebab-title.tex   (make tex: Pandoc's LaTeX; never hand-edited)
                │  copied once, then styled with house-class macros only (the typeset skill)
                ▼
            typeset/src/units/NN-kebab-title.tex ──► make tex-check (every word still the Markdown's)
                │
                ▼
            typeset/src/book.tex + tooling/latex/housebook.cls ──► XeLaTeX, twice ──► build/typeset/book.pdf
```

**Two routes to a PDF.** `make pdf` is the quick proof: any scope, at any status, laid out by
Pandoc. `make print` is the printed book: the chapters set in `typeset/` with the house class, as
a publisher will see them. Both take their words from the same Markdown; the second never
retypes them (`.claude/rules/syntek-author/03-authorship.md` Section 10).
<: else :>```text
library/src/<family>/**/*.tex ──► XeLaTeX, run twice so every \ref resolves ──► the matching .pdf
        (house preamble: tooling/latex/house-preamble.tex; skeleton: tooling/latex/skeleton.tex)
library/src/<family>/**/*.md  ──► Pandoc (tooling/defaults.yaml, tooling/pandoc/house.lua) ──► .docx or .pdf
<: if INCLUDE_REFERENCES :>tooling/references.db ──► tooling/export_refs.py ──► build/references.json (CSL-JSON, for Pandoc)
<: endif :>```

**A section reaches a `.tex` word for word.** `promote-section` checks each promoted section
against its Markdown draft with `make section-check` (`tooling/texcheck.py` in its section mode)
before the ledger is written. Citation keys (`[@key]`) resolve only in Markdown documents, through Pandoc; a `.tex`
deliverable carries each reference written out in full
(`.claude/rules/syntek-author/03-authorship.md` Section 10).
<: endif :>
---

## 2. The targets

| Target | What it does |
|---|---|
| `make help` | Lists every target with its description (the default target) |
<: if INCLUDE_REFERENCES :>| `make init` | Builds `tooling/references.db` from `tooling/schema.sql` and `tooling/seed-refs.sql`; does nothing if the database exists (never overwrites it) |
| `make refs` | Exports the references to CSL-JSON in `build/` for Pandoc<: if DOC_TYPE == 'theology' :>, and writes `build/nocite.yaml`, which lists the default translation in every reference list<: endif :> |
| `make dump` | Writes a text snapshot of the database; commit it with the database |
<: endif :><: if DOC_TYPE != 'business' :>| `make docx SCOPE=…` | Builds a `.docx` of the files under `SCOPE` |
| `make pdf SCOPE=…` | Builds a PDF proof of the files under `SCOPE` |
| `make epub SCOPE=…` | Builds an EPUB of the files under `SCOPE` |
| `make book` | Builds the whole manuscript as `.docx` and `.pdf` |
| `make tex SCOPE=…` | Writes the Pandoc base of each chapter under `SCOPE` to `typeset/src/units/.base/`; never touches a styled chapter, and prints the `git merge-file` command when a base changes under one |
| `make tex-check` | Proves each styled chapter in `typeset/src/units/` carries exactly its Markdown's words, and fails on any difference; `UNIT=` narrows it to one chapter |
| `make print` | Sets `typeset/src/book.tex` with XeLaTeX, twice, into `build/typeset/book.pdf`<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, building the script fonts first, one language at a time (a font that fails is reported and the print goes on)<: endif :>, then reports every character a font could not draw (it prints as nothing; a `final` print stops on one) |
<: else :>| `make pdf FILE=…` | Renders one deliverable with XeLaTeX, twice, so cross-references resolve |
| `make docx FILE=<x>.md` | Converts Markdown copy to `.docx` with Pandoc. A `.tex` converts only with `DOCX_CONVERTER='<command>'` (a lossless converter the author chose), and otherwise refuses by design: send the PDF |
| `make section-check` | `FILE=….tex SECTION=<slug> DRAFT=….md`: proves the text between the section's marker pair carries exactly the promoted draft's words; fails on any difference |
<: endif :>| `make flags` | Lists every `AUTHOR TO CONFIRM` and `VERIFY` flag, by file and line; with no `SCOPE`, the project brief `.claude/CLAUDE.md` too |
| `make lint` | Flags lines in `src/` that hold more than one sentence, en_US spellings<: if DOC_TYPE == 'business' :>, and em dashes in client copy<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, and paragraphs with more than three unglossed constructed-language words<: endif :> |
| `make provenance` | Prints the per-unit AI-disclosure table from the ledger, counting only `accepted` and `rejected` decisions as AI suggestions (an `author-note` row is the author's own) |
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `make lexicon` | Checks every language (inventory, phonotactics, romanisation against IPA, roots, missing fields, a missing real-world model) and the names register against them |
| `make derive` | Re-derives each daughter language from its parent through its ordered sound changes, and reports every word that differs |
| `make coverage` | Lists the core concepts and pronouns each language has no word for yet |
| `make family` | Prints every language family tree, with each branch's real-world models |
| `make glossary` | Writes a glossary and pronunciation guide for each language into `build/` |
| `make font` | Builds each script's font into `build/fonts/<slug>.otf`, run through `uv` |
| `make script-sample` | Renders sample text in a language's native script into `build/` |
<: endif :>| `make clean` | Removes `build/`; never touches a source<: if INCLUDE_REFERENCES :> or the database<: endif :> |

<: if DOC_TYPE != 'business' :>**`SCOPE`** is any folder (the default is `manuscript/src`). The build takes every Markdown file
under it, sorted, so the numeric folder prefixes set the running order, and leaves out
`CONTEXT.md`, `CLAUDE.md`, `README.md` and everything under a `drafts/` folder. The output is
named after the scope with `/` turned into `__`, so `make pdf SCOPE=manuscript/src/03-the-ford`
writes `build/manuscript__src__03-the-ford.pdf`.<: if INCLUDE_REFERENCES :> A bibliography scopes itself: Pandoc prints only the
works cited in the files it is given.<: endif :>
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>
**`LANG=<slug>`** narrows `lexicon`, `derive`, `coverage`, `glossary` and `font` to one language
in `world/src/languages/`; without it they run on every language. `script-sample` needs it when
more than one language has a script.
<: endif :><: else :>**`FILE`** names one document. A `.tex` deliverable is rendered twice because LaTeX resolves
`\ref` and `\pageref` on the second pass; a single pass leaves question marks in the proof.
<: endif :>
---

## 3. Rules

- **`build/` is generated.** Never edit anything in it, or any rendered PDF; change the source and
  rebuild. Settings deny those edits. The rule that creates `build/` also writes
  `build/.gitignore`, so nothing in it is ever committed.
- **Drafts never reach a build.** Work in progress lives in `drafts/` folders, which every build
  excludes by path.
- **Every Pandoc run passes through the house filter**, `tooling/pandoc/house.lua`, so a marked
  passage means the same in every output.<: if DOC_TYPE != 'business' :> In a book, a horizontal rule is a scene break;
  `typeset/docs/reference/semantic-markdown.md` lists what may be marked and what each mark becomes.
- **The printed book never retypes a word.** A base in `typeset/src/units/.base/` is Pandoc's
  output and is never edited; a styled chapter changes only by house-class macros, and
  `make tex-check` passes before a `make print` is read as the book. After the Markdown changes,
  `make tex` writes the new base, and the styled chapter is carried forward with the
  `git merge-file` command it prints (`typeset/workflows/03-retypeset-after-edits/`).<: endif :>
<: if INCLUDE_REFERENCES :>- **Edit the database, never the export.** `tooling/references.db` is the master; add a work with
  the `add-reference` skill and regenerate with `make refs`. Run `make dump` and commit the
  database and its snapshot together, because a database that was never added to Git is lost
  with the machine.
- **Citation keys are `authorYYYY`, lower-case, with `a`, `b`, `c` to disambiguate, and are never
  renamed**: the prose cites them, and a renamed key breaks every citation silently.
<: endif :>- **Proofs are ungated.** A proof can be built at any status, so the author can read the work as a
  reader will. Gates govern promotion and `final`, not builds.
- **Read the proof before reporting it.** The `build` skill confirms the file list `make` echoed,
  opens the output, and reports what it found. A build that succeeded is not a proof that was read.
- **Never hand over a lossy conversion as the deliverable.** If a conversion drops a table, a
  footnote or a cross-reference, report it rather than ship it.
- **Keep the tooling minimal.** Every script in `tooling/` uses the Python standard library only
  (Python 3.11 or later), and any data file a script reads is TOML.<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> The one exception is
  `tooling/font.py`, which declares fontTools inline and runs through `uv run`, so nothing is
  installed globally.<: endif :> Resist turning the pipeline into a project of its own.

---

## 4. What the build needs

| Tool | For |
|---|---|
| `make`, `python3` (3.11 or later) | every target |
| `pandoc` | <: if DOC_TYPE == 'business' :>`make docx`, `make pdf` of a Markdown document, and `make section-check`<: else :>`make docx`, `make pdf`, `make epub`, `make book`, `make tex`, `make tex-check`<: endif :> |
| XeLaTeX (TeX Live) | `make pdf`<: if DOC_TYPE != 'business' :>, `make book`, `make print`<: endif :> |
<: if INCLUDE_REFERENCES :>| `sqlite3` | `make init`, `make dump` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `uv` | `make font`, and the script fonts `make print` builds |
| `espeak-ng` (optional) | the pronunciation fallback when no speech service is configured |
<: endif :>
If a tool is missing, say which one and which target it blocks. Never report a target as passed
when it could not run.
