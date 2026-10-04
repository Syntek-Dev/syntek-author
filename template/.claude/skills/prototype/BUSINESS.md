# BUSINESS.md — prototype, business mode

The two branches for business documents, SUBSTANCE and PRESENTATION, and what each relaxes.

## Paths and unit

- **Where a spike lives:** `library/src/<family>/drafts/<unit-slug>/SPIKE-<slug>.md`, or
  `SPIKE-<slug>.tex` for a PRESENTATION spike, beside the document's section drafts, in one of the
  families this project selected (`business`, `legal`, `email`, `accounting`, `social-media`,
  `msp-scp`).
- **Reads (step 1):** `.claude/MEMORY.md`, the folder's `CONTEXT.md`, the family's skill
  (`<family>-documents`), the document's previous version and its row in
  `planning/src/document-register.md`.
- **The unit's guide:** `library/docs/reference/document-anatomy.md`; PRESENTATION spikes also
  `library/docs/reference/latex-deliverables.md`.

## Additions to the steps

- **Step 2 — also name the branch: SUBSTANCE or PRESENTATION.** SUBSTANCE asks 'does this
  argument or structure land?'; PRESENTATION asks 'what should this look like rendered?' Anything
  about wording, order or argument is SUBSTANCE; anything about layout, pagination or visual
  weight is PRESENTATION.
- **Step 4 — also, SUBSTANCE:** plain Markdown: the headings, plus the one or two sections that
  carry the weight written out in full, and `[stub]` everywhere else. Real context where the
  question depends on it. Then read it cold, as the recipient would, and say what it does.
- **Step 4 — also, PRESENTATION:** two or three variants of **one** page or section in `.tex`, each
  from the LaTeX skeleton in `00-project.md` `## Paths` (by default `tooling/latex/skeleton.tex`),
  rendered with `make pdf FILE=…` into `build/`, never issued, and laid side by side. Vary one
  dimension at a time (a table against prose, one page against two, ordered by price against ordered
  by scope), or the comparison proves nothing.
- **Step 4 — also, what relaxes:** the disclaimer, the required-sections list, the register entry,
  the versioned filename, the house-style pass (em dashes included) and the brand audit. Every
  one is mandatory again the moment the real document is written.
- **Step 5 — also** route the verdict through `grill-with-docs` to its home: the document's
  internal note for a drafting decision confined to it, the brief, the folder's `CLAUDE.md` for a
  local rule on the author's word, or the `Decisions` heading of `.claude/MEMORY.md` (mapped in
  `00-project.md` `## Memory headings`) for a house rule.

## Domain rules

- **A spike is never registered, never given a `DOC-NNN`, never sent, attached or shown to a
  client**, and never synced anywhere: the template's sync takes only issued copies. If the
  project has a sync of its own that takes `drafts/`, say so and ask where the spike goes first.
- **No version number on a spike.** A spike that looks versioned will one day be mistaken for a
  real document.
- **A real client's figures enter a spike only where the question turns on them**, and the spike
  is deleted the same day it is answered.

## Examples

```markdown
# SPIKE — two packages or three?

Question: does the support proposal read as a clear choice with two packages rather than three?
Branch: SUBSTANCE.

## Packages (written out)
…
## Verdict
Two: the middle package was the old retainer under a new name. Recorded in the brief's draft
notes, 03/10/2026. Spike deleted.
```
