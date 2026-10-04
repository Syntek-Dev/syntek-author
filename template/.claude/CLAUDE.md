# CLAUDE.md — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>

@../CONTEXT.md

> Read this file first, then `.claude/MEMORY.md`, then the `CONTEXT.md` and `CLAUDE.md` of
> whichever folder you are about to work in — in that order — before editing anything. The
> template's rules in `.claude/rules/syntek-author/` load automatically with this file, and so
> does this project's settings file, `.claude/rules/syntek-author/00-project.md`.

---

## 1. Project

<: if DOC_TYPE == 'theology' :>**<%AUTHOR_NAME%>** is writing a Christian non-fiction book in this repository.
<: elif DOC_TYPE == 'fiction' :>**<%AUTHOR_NAME%>** is writing a novel in this repository.
<: else :>**<%AUTHOR_NAME%>** writes the business, legal and client documents of **<%TRADING_NAME%>** in this repository.
<: endif :>
- **Author:** <%AUTHOR_NAME%>
- **The author's name** is used in exactly the form above, full stops included, on every cover,
  title page, byline and signature block; never shorten, expand or re-punctuate it. In chat,
  address the author as <%AUTHOR_FIRST_NAME%>.
<: if DOC_TYPE != 'business' :>- **Working title:** <%WORKING_TITLE%>
- **Subtitle:** <: if SUBTITLE :><%SUBTITLE%><: else :>none yet <!-- AUTHOR TO CONFIRM: a subtitle, or confirm that the book has none. --><: endif :>
<: endif :><: if DOC_TYPE == 'theology' :>- **The thesis:** <%PROJECT_DESCRIPTION%>
<: elif DOC_TYPE == 'fiction' :>- **The premise:** <%PROJECT_DESCRIPTION%>
<: else :>- **The purpose:** <%PROJECT_DESCRIPTION%>
<: endif :>- **Near-term goal:** not yet set. <!-- AUTHOR TO CONFIRM: the near-term goal and its date, such as a proposal sample, a first full draft or a first signed document. -->

The settings every skill reads are in `.claude/rules/syntek-author/00-project.md`, not here:
<: if DOC_TYPE == 'theology' :>the audience, the reader test and the default Bible translation,
<: elif DOC_TYPE == 'fiction' :>the audience, the reader test and the genre,
<: else :>the audience, the reader test, the voice, the jurisdiction and the currency,
<: endif :>and where this project keeps things. Target length, delivery date and the running status
live in `.claude/MEMORY.md`.

---

## 2. Where the rules live

The rules are the nine files in `.claude/rules/syntek-author/`. Claude Code loads them at
launch, alongside this file, so there is no need to open them before working; open one when a
task turns on its subject.

| File | Owns |
|---|---|
| `.claude/rules/syntek-author/00-project.md` | **this project's settings**: the brief's settings, paths, memory headings, workflow aliases and overrides. Yours to edit; it outranks the eight files below |
| `.claude/rules/syntek-author/01-layout-and-routing.md` | the layers, the content layer and the unit, the folder pair, routing frontmatter, ownership, read order, precedence |
| `.claude/rules/syntek-author/02-skills.md` | the skill roster and the mode-file contract |
| `.claude/rules/syntek-author/03-authorship.md` | who decides what, the authoring loop, never fabricate, the two flags, provenance<: if DOC_TYPE != 'business' :>, typesetting without retyping a word<: endif :> |
| `.claude/rules/syntek-author/04-build-pipeline.md` | the build and its `make` targets<: if DOC_TYPE != 'business' :>, from the quick proof to the printed book<: else :>, issuing<: endif :>, and the build settings in `tooling/project.mk` |
| `.claude/rules/syntek-author/05-model-allocation.md` | which model does which work |
| `.claude/rules/syntek-author/06-global-rules.md` | locale, route not restate, never self-edit, never overwrite, proofreading, what Git ignores |
| `.claude/rules/syntek-author/07-session-boundaries.md` | hand off, never compact |
| `.claude/rules/syntek-author/08-naming-and-memory.md` | naming patterns, and what goes in `.claude/MEMORY.md` |

**The eight numbered files from `01-` on are template-owned: never edit them.** `copier update`
replaces them, so an edit there is lost or turned into a conflict. `00-project.md` is a seed:
written once and never overwritten, so change it freely. To change a setting, a path or a
template rule for this project, use `00-project.md`; to add a rule of the project's own, write
it under 'Project-specific rules' below; to change a guide or a procedure, add a same-named guide
in a layer's `docs/project/` or a same-slug workflow in its `workflows/local/`.

---

## 3. Project-specific rules

Add a rule as a bold-led bullet with its date and its reason. It applies to this project on top
of the template's rules files, and where the two conflict, this section wins. Only
`00-project.md` outranks it: a change to a setting, a path or one of the template's own rules
goes there instead.

_No project rules yet._
