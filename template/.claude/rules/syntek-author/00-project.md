# 00-project.md — this project's settings, read by every template rule and skill

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Project-owned.** Written once from the Copier answers and never overwritten by `copier update`: it is yours to edit. It outranks every other file in `.claude/rules/syntek-author/`.

The template's rules and skills read project-specific values from this file, by heading, and
from nowhere else: never from a numbered section of `.claude/CLAUDE.md`. Each heading below says
how it is read. Copier never rewrites this file, so when an answer changes, change it here by
hand (`.claude/rules/syntek-author/06-global-rules.md` Section 11).

---

## Brief

The settings every skill reads. The brief itself (the title, the <: if DOC_TYPE == 'theology' :>thesis<: elif DOC_TYPE == 'fiction' :>premise<: else :>purpose<: endif :> and the near-term goal) is
the human-written project brief, which `## Paths` locates.

- **Audience:** <%AUDIENCE%>
- **Reader test** (every `comprehension` pass reads as this person): <%READER_TEST%>
<: if DOC_TYPE == 'theology' :>- **Bible translation** (the default citation key): `<%BIBLE_TRANSLATION%>`
<: endif :><: if DOC_TYPE == 'fiction' :>- **Genre:** <%FICTION_GENRE%>
<: endif :><: if DOC_TYPE == 'business' :>- **Trading name** (exactly as every document prints it): <%TRADING_NAME%>
- **Voice:** first person <: if BUSINESS_VOICE_PERSON == 'plural' :>plural ('we')<: else :>singular ('I')<: endif :>
- **Jurisdiction:** <%JURISDICTION%>
- **Currency:** <%CURRENCY%>
<: endif :>
---

## Paths

Where this project keeps each thing the template's files name by role. A template file names the
default path; where the row here gives another, this row wins. Change the Path column only: the
Role names are what template files cite. A template path with no role here is moved by a
redirect line under `## Overrides` instead.

| Role | Path |
|---|---|
| Project brief | `.claude/CLAUDE.md`, under the heading 'Project' |
| Project rules | `.claude/CLAUDE.md`, under the heading 'Project-specific rules' |
| Handoffs | `handoffs/` |
| Handoff filename | `HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` |
| Decision maps | `planning/src/maps/`, each named `MAP-<TOPIC>.md` |
| Research notes | `research/src/notes/` |
| Approvals | <: if DOC_TYPE == 'business' :>`planning/src/approvals/`, each record named `approval-<doc-type>-DD-MM-YYYY.md`<: else :>not used: a book keeps no approval records<: endif :> |
| Ledger | `standards/style/ledger/` (fixed: `make provenance` and every draft's `ledger:` pointer read this path, so leave it as it is) |
<: if DOC_TYPE == 'business' :>| Brand folder | `standards/brand/` (moved? set `BRAND_DIRS` in `tooling/project.mk` to match) |
| Disclaimers | `standards/brand/disclaimers.md` |
| Client facts | `library/src/business/client-docs/<client-slug>/CONTEXT.md`, under the heading 'Facts' |
| LaTeX skeleton | `tooling/latex/skeleton.tex` |
<: endif :>
---

## Memory headings

The template's files name six headings of `.claude/MEMORY.md`. Read and write each under the
heading this table maps it to; several template headings may share one project heading. Never add
a template heading to `MEMORY.md` when this table maps it to another.

| Template heading | This project's heading |
|---|---|
| `## Facts` | `## Facts` |
| `## Decisions` | `## Decisions` |
| `## Feedback` | `## Feedback` |
| `## Status` | `## Status` |
| `## Open questions` | `## Open questions` |
| `## Sensitivities` | `## Sensitivities` |

---

## Workflow aliases

A template workflow this project replaces with a procedure of its own. `run-workflow`, and every
skill that carries out a workflow, checks this table first, then a same-slug folder in the
layer's `workflows/local/`, and only then the template's workflow. Name the template workflow by
its full folder path, never by its number alone, and the procedure to run instead by its path.

| Template workflow | Use instead |
|---|---|

_No aliases yet._

---

## Overrides

A template rule this project does not follow, and what it does instead. Each entry is a dated,
bold-led bullet naming the rule it replaces (the rules file and section, or the skill and step),
what applies instead, and why. An override changes behaviour, never files: the template-owned
file it overrides stays as shipped. A new rule that replaces nothing is a project rule, and goes
where `## Paths` says ('Project rules').

Projects commonly override, for example: the questioning style, such as one question at a time
instead of rounds (`06-global-rules.md` Section 8); the model fallback (`05-model-allocation.md`
Section 1); splitting `MEMORY.md` past 300 lines (`08-naming-and-memory.md` Section 4); or one
sentence per line for documents written before the template arrived (`06-global-rules.md`
Section 5). None of these is active until it is written below.

**Redirects.** A template path that has no role in `## Paths` (<: if DOC_TYPE == 'business' :>a family standard<: else :>the style sheet<: endif :>, a guide, a
drafts folder) is pointed at the project's own by a line of its own here, in the form
`` `<template path>` → `<project path>` ``. Every template file honours it: where a rule, skill,
guide or workflow names the template path (or, for a folder, any path beneath it), read and
write the project path instead (`01-layout-and-routing.md` Section 9). A redirect needs no date
or reason, and is never pointed into a folder Git ignores. For example, a project that keeps
<: if DOC_TYPE == 'business' :>its own standard for proposals and statements of work in a folder of its own writes:

```text
- `library/docs/reference/business-standards.md` → `docs/standards/client-work.md`
```
<: else :>its own style sheet in a folder of its own writes:

```text
- `standards/style/style-sheet.md` → `notes/house-style.md`
```
<: endif :>
_No overrides yet._
