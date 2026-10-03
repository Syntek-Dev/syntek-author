# FICTION.md — build, fiction mode

The domain for building proofs of a novel: the targets, the output names, and what a fiction proof
is read for.

## Paths and unit

- **Procedure:** `manuscript/workflows/06-build-a-proof/`. The proposal layer's assembly procedure,
  where the proposal option is on, builds the query package with the same targets.
- **Guide:** `manuscript/docs/reference/section-anatomy.md` (what a chapter file holds).
- **Scope:** one chapter, `SCOPE=manuscript/src/NN-kebab-title`, or any folder; `make book` builds
  the whole manuscript. Every Markdown file under the scope is built in sorted order, except
  `CONTEXT.md`, `CLAUDE.md`, `README.md` and everything under a drafts folder.
- **Targets:**

  | Target | Output | For |
  |---|---|---|
  | `make docx SCOPE=…` | `build/<scope>.docx` | editors and agents |
  | `make pdf SCOPE=…` | `build/<scope>.pdf` | the quick Pandoc proof |
  | `make epub SCOPE=…` | `build/<scope>.epub` | reading as a reader would |
  | `make book` | the whole manuscript, `.docx` and `.pdf` | a full proof |
  | `make print` | the typeset book, through XeLaTeX | the print proof, once chapters are typeset |

  `<scope>` is the scope with each `/` turned into `__`. `make print` builds only what the `typeset`
  skill has produced; typesetting itself is that skill's job, never this one's. Where the project
  has constructed languages, `make help` also lists their glossary and script-sample targets.

## Additions to the steps

- **Step 1 — also** treat a bare 'build' as both `.docx` and `.pdf` of the named chapter; offer
  `.epub` when the author wants to read the chapter as a reader would.
- **Step 2 — also check real-world detail.** Before an editorial export, run `fact-check` over any
  real-world detail in scope whose evidence was last checked more than about twelve months ago,
  and confirm every epigraph or quotation has its permission recorded
  (`research/src/permissions.md`).
- **Step 5 — also read the echoed list.** The Makefile prints every file it builds; a chapter or
  beat missing from it is still in drafts.
- **Step 6 — also read for fiction:** chapter order and chapter titles as planned; scene breaks
  where the author put them, rendered as breaks; epigraphs set as epigraphs; constructed words
  rendered from their spans (romanised and italic), with no raw `{.conlang …}` markup visible;
  dialogue punctuation consistent; no section marker or internal note visible.

## Domain rules

- **A proof is read as a reader would**: a jump in time, place or knowledge noticed while reading
  is a finding for `continuity` or `causality`, reported with its page, never fixed here.
- **Permissions before export**: an epigraph or quoted lyric without a recorded permission does not
  leave the author's hands.
- **A proof sent to an editor or agent carries the chapter's status**; anything below `final` goes
  only on the author's recorded decision.

## Examples

An invented report:

```text
Built: build/manuscript__src.epub (whole manuscript; working proof).
Read: chapters 01–04 in order; three scene breaks rendered.
Defects:
1. Chapter 03, second scene: a constructed word shows its raw span markup. Owner: the beat's
   procedure (the span is malformed in the source).
2. Chapter 04 opens on a different morning from chapter 03's last line with no transition.
   Owner: continuity, at review.
```
