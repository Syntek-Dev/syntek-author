# THEOLOGY.md — build, theology mode

The domain for building proofs of a work of Christian theology: the targets, the output names, and
what a theology proof is read for.

## Paths and unit

- **Procedure:** `manuscript/workflows/06-build-a-proof/`. The proposal layer's assembly procedure,
  where the proposal option is on, builds its package with the same targets.
- **Guide:** `manuscript/docs/reference/section-anatomy.md` (what a chapter file holds).
- **Scope:** one chapter, `SCOPE=manuscript/src/NN-kebab-title`, or any folder; `make book` builds
  the whole manuscript. Every Markdown file under the scope is built in sorted order, except
  `CONTEXT.md`, `CLAUDE.md`, `README.md` and everything under a drafts folder.
- **Targets:**

  | Target | Output | For |
  |---|---|---|
  | `make docx SCOPE=…` | `build/<scope>.docx` | editors and publishers |
  | `make pdf SCOPE=…` | `build/<scope>.pdf` | the quick Pandoc proof |
  | `make epub SCOPE=…` | `build/<scope>.epub` | reading as a reader would |
  | `make book` | the whole manuscript, `.docx` and `.pdf` | a full proof |
  | `make print` | the typeset book, through XeLaTeX | the print proof, once chapters are typeset |

  `<scope>` is the scope with each `/` turned into `__`. `make print` builds only what the `typeset`
  skill has produced; typesetting itself is that skill's job, never this one's.

## Additions to the steps

- **Step 1 — also** treat a bare 'build' as both `.docx` and `.pdf` of the named chapter.
- **Step 2 — also check claim currency.** Before an editorial export, run `fact-check` over any
  claim in scope whose evidence entry was last checked more than about twelve months ago, and
  every Scripture quotation whose check is not recorded.
- **Step 5 — also read the echoed list.** The Makefile prints every file it builds; a chapter or
  section missing from it is still in drafts.
- **Step 6 — also read for theology:** citations resolved, with no raw `[@key]`; the reference
  list present and complete (an entry that renders short is a record to complete, not a broken
  build); every footnote under the sentence it belongs to; Scripture references and the
  translation named where quoted; Greek and Hebrew rendered, with no missing-glyph boxes; small
  capitals for LORD where the style sheet asks for them; no section marker, internal note or
  claim-categories block visible.
- **Step 6 — also find the default translation in the reference list**, where the project keeps
  a citation database: its key is in the Project settings of `standards/style/style-sheet.md`.
  The build gives no warning when it is missing, so look for it; if it is absent, add the key
  with the add-reference skill and rebuild.

## Domain rules

- **The main text and the footnotes are read as two registers**
  (`manuscript/docs/reference/main-text-and-footnotes.md`): a footnote that has swallowed the
  argument is a finding for the section's procedure, not a build problem.
- **A raw `[@key]` is a reference problem**: the key is missing from the references, or
  `make refs` has not run. It is fixed in the reference record, never in the output.
- **A proof sent to an editor or publisher carries the chapter's status**; anything below `final`
  goes only on the author's recorded decision.

## Examples

An invented report:

```text
Built: build/manuscript__src__03-kebab-title.pdf and .docx (chapter 03, status draft; working proof).
Read: 14 pages. Citations resolved; reference list complete.
Defects:
1. Page 6: footnote 4 sits under the paragraph after its sentence. Owner: the section's procedure.
2. Page 9: a Hebrew word renders as boxes. Owner: the build fonts; reported, not patched.
```
