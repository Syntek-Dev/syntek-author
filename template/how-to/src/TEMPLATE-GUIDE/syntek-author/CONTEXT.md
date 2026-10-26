# CONTEXT.md — how-to/src/TEMPLATE-GUIDE/syntek-author/

The chapters of syntek-author's user guide: how this project works, in plain English, for the
person whose project it is. They are numbered from 01 and grouped below by when you need them,
from before you generate a project to the day something breaks, and the table under 'What's
here' gives the order to read them in. Like the rest of `how-to/`, this folder is read-only:
read it, and never edit it.

## Directory Tree

```text
how-to/src/TEMPLATE-GUIDE/syntek-author/
├── CONTEXT.md                     ← this file: the chapters, and the order to read them in
├── CLAUDE.md                      ← how to answer a question from the chapters
│ ── Before you generate ──
├── 01-overview.md                 ← what a syntek-author project is, and how this guide is laid out
├── 02-prerequisites.md            ← the tools to install first
├── 03-quickstart.md               ← your first hour
├── 04-the-answers.md              ← every question Copier asks, and changing one later
│ ── What you received ──
├── 05-what-gets-generated.md      ← the kinds of file, and what an update does to each
├── 06-a-tour-of-the-project.md    ← the layers, the folder pair and your two settings files
<: if DOC_TYPE == 'theology' :>├── 14-a-theology-book.md          ← a theology book: arguments, claims and traditions
<: endif :><: if DOC_TYPE == 'fiction' :>├── 15-a-novel.md                  ← a novel: causes, continuity and the story bible
<: endif :><: if DOC_TYPE == 'business' :>├── 16-business-documents.md       ← business documents: families, the register and issuing
<: endif :>│ ── Working ──
├── 07-the-writing-loop.md         ← from a plan to a promoted section
├── 08-building-proofs.md          ← turning your text into something to read
├── 09-customising.md              ← making the project work your way without breaking updates
│ ── Living with it ──
├── 10-a-second-template.md        ← sharing the project with a companion template
├── 11-adopting.md                 ← after the template was added to an existing repository
│ ── When it breaks ──
├── 12-troubleshooting.md          ← what to do, grouped by when it breaks
│ ── Reference ──
├── 13-a-guide-to-skills.md        ← which skill does which job
└── 17-glossary.md                 ← the words this guide uses, in plain English
```

## What's here

| You are… | Read |
|---|---|
| New to the project | `how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md`, then `how-to/src/TEMPLATE-GUIDE/syntek-author/03-quickstart.md`, then `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md` |
<: if DOC_TYPE == 'theology' :>| Writing a theology book | `how-to/src/TEMPLATE-GUIDE/syntek-author/14-a-theology-book.md` |
<: endif :><: if DOC_TYPE == 'fiction' :>| Writing a novel | `how-to/src/TEMPLATE-GUIDE/syntek-author/15-a-novel.md` |
<: endif :><: if DOC_TYPE == 'business' :>| Writing business documents | `how-to/src/TEMPLATE-GUIDE/syntek-author/16-business-documents.md` |
<: endif :>| Meeting a word you do not know | `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md` |
| Installing the tools | `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` |
| Choosing or changing answers | `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`, then `how-to/workflows/syntek-author/01-update-the-template/` |
| Finding your way round | `how-to/src/TEMPLATE-GUIDE/syntek-author/06-a-tour-of-the-project.md` |
| Building a proof | `how-to/src/TEMPLATE-GUIDE/syntek-author/08-building-proofs.md` |
| Updating | `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`, `how-to/src/TEMPLATE-GUIDE/syntek-author/05-what-gets-generated.md`, `how-to/workflows/syntek-author/01-update-the-template/` |
| An update stopped | `how-to/workflows/syntek-author/02-recover-a-failed-update/` |
| Adding a coding agent | `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`, `how-to/workflows/syntek-author/03-enable-an-agent-client/` |
| Filing binary files | `how-to/src/TEMPLATE-GUIDE/the-data-root.md`, `how-to/workflows/syntek-author/04-set-up-the-data-root/` |
| Making the project work your way | `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` |
| Adding a companion template | `how-to/src/TEMPLATE-GUIDE/syntek-author/10-a-second-template.md` |
| Finishing an adoption | `how-to/src/TEMPLATE-GUIDE/syntek-author/11-adopting.md` |
| Stuck | `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md` |
| Looking for the skill for a job | `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md` |

- **A chapter explains; the rules decide.** Each chapter ends with 'Where the rules live', which
  names the rules, guides and procedures behind what it explains, and 'Next', which names what
  to read after it.
- **One variant chapter.** A project carries the chapter for its own kind of work only: a
  theology book, a novel or business documents.
- **Numbers are frozen and append-only**, unique across every kind of project, so a gap in the
  sequence is a chapter that belongs to another kind of project, not a missing one.

**Ownership.** Every chapter here is syntek-author's own, written one sentence per line for you
to read. Every update of the template puts these chapters back as it wrote them, a deleted one
included, and lists each in its report; what you had stays in Git. Only the template's update,
its recovery and the commands its report prints change a file here. To work differently from a
chapter, record the difference in `.claude/rules/syntek-author/00-project.md`, under
`## Overrides` or `## Workflow aliases`.

## Cross-references

- `how-to/src/TEMPLATE-GUIDE/CONTEXT.md`: where reading the guide starts, for every template in
  the project.
- `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`, `how-to/src/TEMPLATE-GUIDE/the-data-root.md`
  and `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`: the shared chapters, which explain
  what every template of the family has in common.
- `how-to/docs/syntek-author/`: this template's guides, one practice each.
- `how-to/workflows/syntek-author/`: this template's procedures, with every command.
- `.claude/rules/syntek-author/`: the rules, which decide wherever a chapter only explains.
