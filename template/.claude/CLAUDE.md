# CLAUDE.md — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>

@../CONTEXT.md

> Read this file first, then `.claude/MEMORY.md`, then the `CONTEXT.md` and `CLAUDE.md` of
> whichever folder you are about to work in — in that order — before editing anything. The
> template's rules in `.claude/rules/syntek-author/` load automatically with this file.

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
<: elif DOC_TYPE == 'fiction' :>- **Genre:** <%FICTION_GENRE%>
- **The premise:** <%PROJECT_DESCRIPTION%>
<: else :>- **Trading name:** <%TRADING_NAME%>
- **The purpose:** <%PROJECT_DESCRIPTION%>
- **Jurisdiction and currency:** <%JURISDICTION%>; <%CURRENCY%>
- **Voice:** first person <: if BUSINESS_VOICE_PERSON == 'plural' :>plural ('we')<: else :>singular ('I')<: endif :>
<: endif :>- **Audience:** <%AUDIENCE%>
- **Reader test** (every `comprehension` pass reads as this person): <%READER_TEST%>
<: if DOC_TYPE == 'theology' :>- **Default Bible translation:** citation key `<%BIBLE_TRANSLATION%>`
<: endif :>- **Near-term goal:** not yet set. <!-- AUTHOR TO CONFIRM: the near-term goal and its date, such as a proposal sample, a first full draft or a first signed document. -->

Target length, delivery date and the running status live in `.claude/MEMORY.md`, not here.

---

## 2. Where the rules live

The template's rules are the eight files in `.claude/rules/syntek-author/`. Claude Code loads
them at launch, alongside this file, so there is no need to open them before working; open one
when a task turns on its subject.

| File | Owns |
|---|---|
| `.claude/rules/syntek-author/01-layout-and-routing.md` | the layers, the content layer and the unit, the folder pair, routing frontmatter, ownership, read order |
| `.claude/rules/syntek-author/02-skills.md` | the skill roster and the mode-file contract |
| `.claude/rules/syntek-author/03-authorship.md` | who decides what, the authoring loop, never fabricate, the two flags, provenance<: if DOC_TYPE != 'business' :>, typesetting without retyping a word<: endif :> |
| `.claude/rules/syntek-author/04-build-pipeline.md` | the build and its `make` targets<: if DOC_TYPE != 'business' :>, from the quick proof to the printed book<: endif :> |
| `.claude/rules/syntek-author/05-model-allocation.md` | which model does which work |
| `.claude/rules/syntek-author/06-global-rules.md` | locale, route not restate, never self-edit, never overwrite, proofreading |
| `.claude/rules/syntek-author/07-session-boundaries.md` | hand off, never compact |
| `.claude/rules/syntek-author/08-naming-and-memory.md` | naming patterns, and what goes in `.claude/MEMORY.md` |

**They are template-owned: never edit them.** `copier update` replaces them, so an edit there is
lost or turned into a conflict. To change or add a rule for this project, write it in Section 3
below; to change a guide or a procedure, add a same-named guide in a layer's `docs/project/` or a
same-slug workflow in its `workflows/local/`.

---

## 3. Project-specific rules

Add a rule as a bold-led bullet with its date and its reason; it applies to this project on top
of the template's rules, and where the two conflict, this section wins.

_No project rules yet._
