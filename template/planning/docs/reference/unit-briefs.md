---
type: guide
skills: [grill-with-docs, draft-section, promote-section]
model: opus
---

# Unit briefs — the plan a unit is drafted from

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A unit is a chapter or a document; a section is one passage of roughly 300–500
words inside it. Every unit has exactly one brief, at `planning/src/units/<unit>.md`, named for
the unit's folder or file in the content layer. The brief is the only place the unit's plan
lives; the prose lives in the content layer, assembled from promoted sections, so plan and prose
never share a file and promotion never mixes them.

## The frontmatter

| Key | Holds |
|---|---|
| `title` | The working title, as the author wants it printed. |
| `slug` | The unit's name without its number: `the-ford` for `03-the-ford`. |
| `number` | A chapter's quoted position (`"03"`); a document's `DOC-NNN` once registered, else `""`. |
| `version` | A document's `vMAJOR.MINOR` in progress; books leave it `""`. |
| `status` | The unit's place on the status ladder (below). |
| `audience_note` | How this unit's reader differs from the stated reader, or `""`. |
| `sources` | Citation keys, or source-note slugs, the unit already leans on. |
| `verified` | One entry per gate passed, keyed by its number and dated: `{V1: DD/MM/YYYY}`. |
| `sections` | One `{slug, purpose, status}` per section, in plan order. |

The ledger, the provenance register and `UNIT=` use the unit's name with its number (its folder
and brief name, `03-the-ford`), never `slug`; a document's name has no number to add.

## The body

`## Scope` (what is in, what is out, and where the out goes) · `## What this unit does` (the
reader outcome) · `## Sections` (one numbered line per section: what it carries, what it hands
on) · the settled-positions slot · `## Draws on` · `## Draft notes`.

The settled-positions slot records what the unit has committed to, so a section drafted later
cannot quietly contradict one drafted earlier. Its name follows the doc type:
`## Claims and categories` (theology), `## Continuity facts` (fiction),
`## Obligations and defined terms` (business).

## Two ladders, never merged

The **unit** moves `idea · outlined · draft · structural-review · fact-check · line-edit · final`
(`stub` is accepted as an alias of `outlined` and rewritten on first touch). Each **section**
moves `ai-draft · author-draft · adapted · improved · author-revised · promoted`; a planned
section not yet drafted carries `status: ""`. Promoting every section does not make a unit
`final`: only the review workflow and the author's word do. The content layer's
`the-status-ladders.md` guide reads both ladders in detail.

## How we apply it here

- Plan the next unit to be drafted, not the whole work at once; the outline holds the rest as
  one line each until its turn comes.
- Cut sections by job, not by length: one argument step, one scene beat, one clause group. A
  section that needs two lines to describe is two sections.
- Never rename a unit's file or a section's slug once that section has a ledger entry in
  `standards/style/ledger/`; the ledger is keyed by both.
- Write only agreed positions into the slot. Anything undecided is an
  `<!-- AUTHOR TO CONFIRM: … -->` flag; anything checkable and unchecked carries
  `<!-- VERIFY: … -->`. The `final` gate requires zero of both.
- One sentence per line in the body, applied when a paragraph is edited, never by mass reflow.

## Who implements it

- **Workflow:** `planning/workflows/01-plan-a-unit/` writes the brief; the doc type's companion
  planning procedure, where one exists, writes the structural plan beside it.
- **Skills:** `grill-with-docs` settles the scope, the positions and the sections;
  `draft-section`, `adapt-section`, `improve-section` and `promote-section` keep each section's
  `status` current; the verification gates write `verified`.

## Governing standard

`standards/verification/verification.md` owns the gates (V1, for idea → outlined, passes when the
author agrees the brief) and the `verified` record; `.claude/rules/syntek-author/03-authorship.md` owns who
decides what. The standard owns the requirement; this guide owns the shape of the brief and how
it is kept honest.
