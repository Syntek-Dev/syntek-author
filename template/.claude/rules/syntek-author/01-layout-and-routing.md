# 01-layout-and-routing.md — where everything lives, and how work finds its folder

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

This file owns the repository's shape: its layers, the sublayers inside them, the folder-pair rule,
routing frontmatter, who owns which files, the order in which to read before working, and which
rule wins when two conflict (Section 9). Every other file that needs a path routes here rather
than restating it.

---

## 1. Layers

| Layer | Kind | Purpose |
|---|---|---|
| `.claude/` | config | The manual (`CLAUDE.md`), these rules with the project's settings (`00-project.md`), `MEMORY.md`, settings, hooks and skills |
| `planning/` | production | The plan of the work: the outline, one brief per <%UNIT_NOUN%>, decision maps, reviews (advice only) |
| `research/` | production | The evidence base: sources, verified evidence entries, question-led notes |
<: if DOC_TYPE != 'business' :>| `manuscript/` | production | The book itself: one folder per chapter, each holding its promoted prose and a `drafts/` folder |
<: endif :><: if DOC_TYPE == 'business' :>| `library/` | production | The documents themselves, by family: templates, client documents and drafts |
<: endif :><: if DOC_TYPE != 'business' :>| `typeset/` | production | The printed book: the page design, the master file, front and back matter, and each styled chapter beside its Pandoc base |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `proposal/` | production | The package that sells the book: <: if DOC_TYPE == 'theology' :>book proposal, endorsements, sample<: else :>query letter, synopses, comparable titles, submissions, sample<: endif :> |
<: endif :><: if DOC_TYPE == 'fiction' :>| `world/` | production | The story bible: characters, places, the names register<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, peoples, cultures, world history and creatures<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, constructed languages<: endif :> |
<: endif :>| `standards/` | supporting | The rules the prose answers to: style, method, risk, verification<: if INCLUDE_REFERENCES :>, referencing<: endif :><: if DOC_TYPE == 'business' :>, brand<: endif :> |
| `tooling/` | supporting | The build: Pandoc metadata and the house filter, the LaTeX house files, the scripts behind `make`, and this project's build settings (`tooling/project.mk`) |
| `handoffs/` | working | Session bridges written by the `handoff` skill; pruned once the work resumes |
| `learning/` | working | The `teach` workspace; nothing in it is the work |
| `assets/` | working | Images and other binaries the work uses |
<: if DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC :>| `.github/` | config | The Google Drive push and pull workflows |
<: endif :>| `build/` | generated | Everything `make` produces; git-ignored, never hand-edited |

---

## 2. The kinds of layer

- **Production layers** hold content made through repeatable, multi-step procedures, so each one
  splits into the same sublayers (Section 3). A production layer is where the work happens.
- **Supporting layers** (`standards/`, `tooling/`) are consulted or run, not produced inside.
  They stay flat, with topic subfolders; their procedures live in skills.
- **Working folders** (`handoffs/`, `learning/`, `assets/`) sit at the root, outside every build.
  Nothing in `handoffs/` or `learning/` is the work; anything durable they produce graduates to
  `.claude/MEMORY.md`, a unit brief, `research/src/` or `standards/`, and the copy left behind is a
  link, not the answer.
- **Generated** output (`build/`) is derived from sources and never edited by hand.

---

## 3. Sublayers of a production layer

| Sublayer | Holds | Read it for |
|---|---|---|
| `docs/reference/` | Guides shipped by the template, replaced by `copier update` | how this kind of work is done |
| `docs/project/` | The author's own guides; a same-named file here overrides the reference guide | how this project departs |
| `src/` | The artefact: the prose, the plans, the evidence | the work itself |
| `workflows/NN-name/` | Template procedures: `CONTEXT.md` + `CLAUDE.md` + `STEPS.md` + `CHECKLIST.md` | the steps to follow |
| `workflows/local/NN-name/` | The author's procedures, in their own numbering; a same-slug folder overrides the template's | the author's steps |

Template workflow numbers are **frozen and append-only**: a number is never reused or renumbered,
because other files and the author's habits cite it. Gaps are deliberate. The `run-workflow` skill
resolves an intent to a procedure: it checks `00-project.md` `## Workflow aliases` first, then
`workflows/local/`, and every skill that carries out a workflow runs the alias or the same-slug
local procedure instead, where one exists. **Cite a workflow by its full folder name**
(`01-draft-a-section`), never by its number alone: a project that kept its own procedures may
have two folders with one number.

---

## 4. The content layer and the unit

**The content layer in this project is `<%CONTENT_LAYER%>/`, and the unit is a <%UNIT_NOUN%>.**
Shared skills and guides say "the content layer" and "the unit"; this section is what they mean.

<: if DOC_TYPE != 'business' :>- **A chapter** is a folder `manuscript/src/NN-kebab-title/` holding `NN-kebab-title.md` (the
  promoted prose) and a `drafts/` folder (work in progress, excluded from every build). Folder
  numbers set the running order.
- **Sections** are promoted into the chapter file in plan order, each anchored by a
  `<!-- section: <slug> -->` marker.
- **The printed book** is set in `typeset/` from the promoted chapter files: `make tex` writes
  each chapter's Pandoc base to `typeset/src/units/.base/`, and the `typeset` skill styles a copy
  in `typeset/src/units/` without retyping a word (`.claude/rules/syntek-author/03-authorship.md`
  Section 10).
<: else :>- **A document** lives in a family folder, `library/src/<family>/`, which holds `templates/`,
  `drafts/` and<: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>, except in email,<: endif :> `client-docs/<client-slug>/`. The
  families in this project:
  - `library/src/business/`: proposals, statements of work, client guides and the business's
    internal policies<: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :> on HR and staff conduct<: endif :> (every project).
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>  - `library/src/legal/`: contracts, non-disclosure and data processing agreements, and terms.
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>  - `library/src/email/`: client and supplier correspondence. The email family files by
    correspondent instead: `client-emails/<client-slug>/<family>/` and
    `supplier-emails/<matter-slug>/`.
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>  - `library/src/accounting/`: invoices, expenses and financial reports.
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>  - `library/src/social-media/`: social media plans, content calendars and profiles.
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>  - `library/src/msp-scp/`: IT and information-security policies, plans and reports for
    managed-service clients and for the business itself.
<: endif :>- **Each family has a standard, a skill and a create workflow**: its conventions in
  `library/docs/reference/<family>-standards.md`, its skill `<family>-documents`
  (`.claude/rules/syntek-author/02-skills.md` Section 5) and its workflow in `library/workflows/`.
  The families were chosen with the Copier answer `BUSINESS_FAMILIES`; one is added or removed
  through `copier update` (`README.md`, "Updating from the template"), never by hand.
- **A client's facts live once**, in the file `00-project.md` `## Paths` names ('Client facts'; by
  default `library/src/business/client-docs/<client-slug>/CONTEXT.md`, under `## Facts`). Every
  family reads them there. Never copy them into another family, and never create a client folder
  in another family just to hold them.
- **Deliverables** are LaTeX built on the house preamble, started from the LaTeX skeleton
  `00-project.md` `## Paths` names; correspondence is Markdown. Sections are promoted into a
  `.tex` document between `% section: <slug>` markers, in plan order.
<: endif :>- **A section** is a small passage inside a unit, typically 300 to 500 words: one argument step, one
  scene beat, one clause group (`.claude/rules/syntek-author/03-authorship.md` Section 3).
- **The unit's plan** is its brief in `planning/src/units/`. The brief holds the scope, the
  sections in plan order, the unit's status and its verified gates; the prose never holds the plan.

---

## 5. The folder pair

**Every directory carries a `CONTEXT.md` and a `CLAUDE.md`.** `CONTEXT.md` is orientation: what
is here and why, as a directory tree with `←` notes, then what's here and cross-references. It
would stay true if nobody worked here again. `CLAUDE.md` is operating rules: it opens with
`@./CONTEXT.md`, then a `Read order:` line naming every ancestor pair, then exactly four sections:
`## Purpose (one line)`, `## How to work here` (**Routing**, **Model**, **Concrete steps**,
**Definition of done**), `## Guardrails` and `## Output & naming`.

The exceptions, and why each is exempt:

- `build/` and `.git/` are generated; nothing in them is read for guidance.
- `.claude/rules/` holds rules only: Claude Code loads every Markdown file there at launch, so a
  `CONTEXT.md` placed there would load as a rule.
- The inside of each `.claude/skills/<skill>/` folder: a skill is its own manual.
- Each `drafts/` folder carries only a `README.md`; its parent's pair governs it.
<: if DOC_TYPE != 'business' :>- `typeset/src/units/.base/` carries only a `README.md`: it holds the Pandoc bases `make tex`
  writes, which are never hand-edited, and its parent's pair governs it.
<: endif :>
The repository root's operating file is `.claude/CLAUDE.md`, not a root `CLAUDE.md`.

---

## 6. Routing frontmatter

Guides and workflow files say which skill and model the work needs, in YAML frontmatter above the
H1. **Read it first and obey it.**

| File | Keys |
|---|---|
| Guide (`docs/**/*.md`) | `type: guide` · `skills: [..]` · `model:` |
| `STEPS.md` and `CHECKLIST.md` | `workflow:` · `phase:` · `skills: [..]` · `model:` |
| `CONTEXT.md` and `CLAUDE.md` | none: the pair is navigation, not routing |

`phase` is one of `plan`, `research`, `produce`, `review`, `publish`, `convert` or `author`. The
template's files carry no `agent:` key: the template uses skills only. A file the project wrote
before the template arrived may carry one; obey it there. Section drafts and unit briefs carry no
`model:` key; the model tiers are defined once in `.claude/rules/syntek-author/05-model-allocation.md`.

---

## 7. Who owns which files

| Class | What `copier update` does | Files |
|---|---|---|
| **Template-owned** | merges the template's changes in | `.claude/rules/syntek-author/**` (except `00-project.md`), `.claude/skills/<skill>/**`, `.claude/hooks/*.sh`, every `docs/reference/`, every `workflows/NN-name/`, the governance pairs (except the seeded ones below), `standards/` (except the seeds), `tooling/` (except the seeds), `Makefile`, nested `.gitignore` files |
| **Seed-if-missing** | creates the file only if it is absent, then never touches it | listed below |
| **Seed-once example** | ships at generation only; once deleted, stays deleted | the worked example, when one was generated |
| **Author-owned** | never touches | everything you write: `src/` content, the guides in `docs/project/`, the procedures in `workflows/local/`, and what you put in `handoffs/`, `learning/` and `assets/` (their `CONTEXT.md` and `CLAUDE.md` are template-owned) |

**Seeds** (yours from the moment they exist; deleting one brings back the empty seed on the next
update; turning its option off deletes it): `.claude/rules/syntek-author/00-project.md` (this
project's settings), `tooling/project.mk` (its build settings), `README.md`, `CONTEXT.md`,
`.gitignore`, `.mcp.json`, `.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`,
`.claude/settings.json`, the `.claude/skills/` and `.claude/hooks/` pairs,
`standards/style/style-sheet.md`, `standards/style/voice-notes.md`, `standards/style/terminology.md`,
`standards/style/ledger/provenance.md`, `planning/src/outline.md`, the map index
`planning/src/maps/CONTEXT.md`, the `CONTEXT.md` and `CLAUDE.md` of every layer's `docs/project/`
and `workflows/local/` (you add a row to them)<: if DOC_TYPE == 'fiction' :>, `planning/src/causality.md`,
`planning/src/timeline.md`, `planning/src/continuity.md`, `world/src/names-register.md`,
`research/src/permissions.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>,
`world/src/history/eras.md`<: endif :><: if DOC_TYPE != 'business' :>, `typeset/src/page-design.md`,
`typeset/src/book.tex`<: endif :><: if DOC_TYPE == 'theology' and INCLUDE_PROPOSAL :>, the eight
section stubs in `proposal/src/book-proposal/`, `proposal/src/endorsements/tracker.md`,
`proposal/src/sample/sample-index.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_PROPOSAL :>,
`proposal/src/query-letter.md`, `proposal/src/synopsis-short.md`, `proposal/src/synopsis-long.md`,
`proposal/src/comp-titles.md`, `proposal/src/submissions/tracker.md`,
`proposal/src/sample/sample-index.md`<: endif :><: if DOC_TYPE == 'business' :>,
`planning/src/document-register.md`, `planning/src/review-schedule.md`,
`planning/src/precedence.md`, `standards/brand/disclaimers.md`, `standards/brand/brand-voice.md`,
`standards/brand/brand-guide.md`<: endif :><: if INCLUDE_REFERENCES :>, `tooling/seed-refs.sql`<: endif :>.
Before an update turns an option off, see `README.md`, "Turning an option off deletes its files".

<: if SEED_EXAMPLES :>**The worked example** (seed-once; delete it when you no longer need it):

<: if DOC_TYPE != 'business' :>- the example chapter, `manuscript/src/01-example-chapter/`, and its brief,
  `planning/src/units/01-example-chapter.md`<: if DOC_TYPE == 'theology' :>, with its argument map,
  `planning/src/arguments/01-example-chapter.md`<: endif :>;
- the ledger entries of its two sections: the AI-drafted
  `standards/style/ledger/01-example-chapter--the-turn.md`, and the author-drafted, promoted
  `standards/style/ledger/01-example-chapter--opening.md`<: else :>- the example proposal, `library/src/business/drafts/example-proposal/`, and its brief,
  `planning/src/units/example-proposal.md`;
- the ledger entry of its AI-drafted section, `standards/style/ledger/example-proposal--scope.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>;
- the example people and culture, `world/src/peoples/example-people.md` and
  `world/src/cultures/example-culture.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>;
- the example language family, `world/src/languages/example-proto/` and its daughter
  `world/src/languages/example-tongue/`, which is also the tooling's test fixture;
- the research notes on their real-world models,
  `research/src/setting/example-model-classical-latin.md`,
  `research/src/setting/example-model-old-spanish.md` and
  `research/src/setting/example-model-ogham.md`<: endif :>.

<: endif :>**Never edit a template-owned file.** The next update either overwrites the edit or turns it into
a merge conflict. Override instead: a same-named guide in `docs/project/`, a same-slug workflow in
`workflows/local/`, a row in `00-project.md` `## Workflow aliases` or `## Overrides`, or a
project rule where `00-project.md` `## Paths` says ('Project rules').

---

## 8. Read order

Before editing anything, read in this order:

1. `.claude/CLAUDE.md`: the project brief. It imports the root `CONTEXT.md`, and these rules load
   with it, `00-project.md` (the project's settings) among them.
2. `.claude/MEMORY.md`: facts, decisions, feedback, status, open questions and sensitivities,
   under the headings `00-project.md` `## Memory headings` maps them to.
3. Each ancestor folder's `CONTEXT.md` then `CLAUDE.md`, from the top down.
4. The target folder's `CONTEXT.md` (imported by its `CLAUDE.md`), then its `CLAUDE.md`.
5. The routing frontmatter of the file you are about to open (Section 6).

Every folder `CLAUDE.md` repeats this chain in its own `Read order:` line, so a session that
starts deep in the tree still climbs it.

---

## 9. Project settings, precedence and adoption

**This project's settings live in one file**, `.claude/rules/syntek-author/00-project.md`:
project-owned, written once from the Copier answers, and loaded at launch with these rules. A
template file that needs a project-specific value reads it there, by heading:

| Heading | Read it for |
|---|---|
| `## Brief` | the audience, the reader test and the variant's answers |
| `## Paths` | where each thing a template file names by role lives; where a row differs from the default path a template file names, the row wins |
| `## Memory headings` | the `.claude/MEMORY.md` heading that a template file's heading means here |
| `## Workflow aliases` | a project procedure to run instead of a template workflow; checked first |
| `## Overrides` | a template rule this project does not follow, and what it does instead; a redirect of a template path |

**Precedence**, highest first, when two rules conflict:

1. `00-project.md`.
2. The project rules, where `00-project.md` `## Paths` says ('Project rules'; by default
   `.claude/CLAUDE.md`, under the heading 'Project-specific rules').
3. The template's rules files, `01-layout-and-routing.md` to `08-naming-and-memory.md`.
4. A folder's `CLAUDE.md`, which adds to the rules and never relaxes them; then a skill; then its
   mode file, where the procedure wins over the mode.

Follow the higher rule, and report the conflict to the author with both locations, so it is
settled once rather than met again.

**Redirects.** A template path with no role in `## Paths` (<: if DOC_TYPE == 'business' :>a family standard<: else :>the style sheet<: endif :>, a guide, a drafts
folder, a seed) is moved by a line of its own under `00-project.md` `## Overrides`, in the form
`` `<template path>` → `<project path>` ``. Every template file honours it without being edited:

- wherever a rule, skill, mode file, guide, workflow or index names the template path, read and
  write the project path instead; a redirected folder carries every path beneath it;
- the template's own file at that path stays as shipped, and is not read in place of the
  project's;
- **a redirect never sends a write into a folder Git ignores**: where the project path is
  ignored, write nothing there and tell the author, and read it only as
  `06-global-rules.md` Section 12 allows;
- a role in `## Paths` moves in its row, never by a redirect;
- **the `Makefile` and `tooling/` read fixed paths and ignore redirects**: a build leaves out only
  folders named `drafts/`, so redirect drafts only to a folder of that name or outside the content layer.

**Additive adoption.** A repository that existed before the template can adopt it without moving
anything: `copier copy --skip '*' --skip-tasks`, given the template's absolute path, adds only
the files the repository lacked, and the author then records in `00-project.md` where the
project already keeps each thing. In such a project:

- a file the project already had at a template path (a `SKILL.md`, an index pair, a guide) is
  the project's own, and its text governs that path;
- on `copier update`, a file the project kept at a template path comes back with conflict markers
  whenever the template changed it: keep the project's version (its text governs that path), tell
  the author which files were resolved and what the template changed, and extend a file only on
  their word;
- <: if DOC_TYPE == 'business' :>unticking a family or <: endif :>turning an option off on update deletes the project's own files at its
  template paths too (`06-global-rules.md` Section 11): have the author copy them out first;
- a mode file beside a project's own `SKILL.md` is ignored, because only a `SKILL.md` that carries
  the Mode paragraph reads one (`.claude/rules/syntek-author/02-skills.md` Section 2);
- `run-workflow` lists the workflow folders directly where an index file has no
  'You want to… | Procedure' table, after checking `## Workflow aliases`;
- where the project keeps its own version of a template file at another path (the adoption
  report lists files that share a name), a redirect makes the project's version the one read;
- a difference between the template's defaults and the project's practice goes in
  `00-project.md`, never into a template-owned file.
