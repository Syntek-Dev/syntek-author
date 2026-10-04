# syntek-author

**A Copier template that generates writing repositories — a theology book, a novel or a business document library — with their own folder system, standards and a Claude Code skill suite.**

![Version](https://img.shields.io/badge/version-0.3.0-blue)
![Template: Copier](https://img.shields.io/badge/template-copier-blue)

```bash
uvx copier copy --trust gh:Syntek-Dev/syntek-author my-book
```

Copier asks its questions, renders the tree for the variant you choose, runs `git init`, and (for a project with references) builds the citation database.
How many questions it asks depends on your answers: the fiction kits only appear for a novel, the business settings only for a library.

---

## Contents

- [What it generates](#what-it-generates)
- [Requirements](#requirements)
- [Generating a project](#generating-a-project)
- [The questions](#the-questions)
- [The project's settings: `00-project.md` and `project.mk`](#the-projects-settings-00-projectmd-and-projectmk)
- [What `copier update` will and will not touch](#what-copier-update-will-and-will-not-touch)
- [Updating a project](#updating-a-project)
- [Adopting an existing repository](#adopting-an-existing-repository)
- [Applying a second template](#applying-a-second-template)
- [Pronunciation audio for constructed languages](#pronunciation-audio-for-constructed-languages)
- [Running the audits](#running-the-audits)
- [Working on the template](#working-on-the-template)

---

## What it generates

One template, three variants. You choose the variant once, with `DOC_TYPE`, and it cannot be changed later.

| Variant | For | Content layer | What is particular to it |
|---|---|---|---|
| `theology` | A Christian non-fiction book | `manuscript/` (chapters) | The six claim categories, argument maps, contested readings, steelmanning; references on by default |
| `fiction` | A novel | `manuscript/` (chapters) | `world/` (characters, places, the names register), causality, timeline, continuity and character arcs |
| `business` | Business, legal and client documents | `library/` (documents) | The document families you choose (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`), each with its folder, standard, skill and create workflow; the document register, review schedule, approvals, brand and disclaimers, LaTeX deliverables |

Every variant shares the same spine:

- **The authoring loop.** The AI drafts one small section (`draft-section`), or you draft and the AI proposes changes as a diff with a reason for each (`improve-section`); your notes drive targeted revisions (`adapt-section`); only your word moves a section into the unit (`promote-section`); and the template learns your voice from what you changed and rejected (`learn-voice`).
- **Provenance.** Every section keeps a ledger entry holding its original (the AI's draft, or yours), every revision with who made it (an AI suggestion you accepted, the AI applying your own note, or your own edit) and your final text. `make provenance` prints a per-unit disclosure table for publishers, and `make compare` prints the three-stage comparison of each section — original, AI edit, final — as a PDF in `build/compare/`: a redline marking every added or removed word by who changed it, in colour-blind-safe colours with a line style of their own, so it reads in greyscale too, and a landscape page with the three stages side by side.
- **Review.** Structure, fact-check, comprehension, flow, grammar and spelling, plus the variant's own checks, run as a workflow against numbered verification gates.
- **Production layers** (`planning/`, `research/`, the content layer, and `proposal/` or `world/` where they apply), each with reference guides, numbered workflows and a place for your own procedures. **Supporting layers** (`standards/`, `tooling/`) and working folders (`handoffs/`, `learning/`, `assets/`).
- **Claude Code configuration.** Skills only, no agents; the rules in `.claude/rules/syntek-author/`; hand off, never compact.

Options add to a variant:

| Option | Offered for | Default | Adds |
|---|---|---|---|
| `INCLUDE_PROPOSAL` | books | on | `proposal/`: the book proposal and endorsements (theology), or the query package and submissions tracker (fiction) |
| `INCLUDE_REFERENCES` | all | theology only | A SQLite references database → CSL-JSON → Pandoc in Harvard style, and the `add-reference` skill |
| `INCLUDE_SENSITIVE_CONTENT` | books | off | The sensitive-content standard, the `sensitivity-pass` skill and safe handling for testimony |
| `INCLUDE_WORLDBUILDING` | fiction | on for fantasy and science fiction | Creatures, cultures and quests |
| `INCLUDE_CONLANG` | fiction with worldbuilding | on with worldbuilding | Constructed languages: phonology, grammar, lexicon, etymology, a writing system and pronunciation |
| `INCLUDE_DRIVE_SYNC` | business | off | GitHub workflows that push the library to Google Drive and pull it back |
| `BUSINESS_FAMILIES` | business | every family but `msp-scp` | One document family per choice: its folder in `library/src/` (with `templates/`, client folders and `drafts/`), its standard in `library/docs/reference/`, its `<family>-documents` skill and its create workflow. `business` is always included |
| `SEED_EXAMPLES` | all | on | One worked example unit (and, with the constructed-language kit, a tiny example language) |

---

## Requirements

| Tool | Needed for |
|---|---|
| [uv](https://docs.astral.sh/uv/) (`uvx`) | Running Copier without installing it. Copier 9.6.0 or newer. |
| git | Every project is a repository; updates are three-way merges. |
| Python 3.11 or newer | The scripts in `tooling/` (standard library only, TOML data files). |
| make | Every build and check (`make help` lists them). |
| Pandoc and XeLaTeX | `make pdf`, `make docx`, the book builds and `make compare`. |
| TeX Live packages for `make compare` | `xcolor` (collection latex-recommended), `ulem` (plain-generic), `paracol` (latex-extra) and `array` (part of LaTeX itself). `make compare FORMAT=tex` stops at the LaTeX and needs Pandoc alone. |
| sqlite3 | The references database (with `INCLUDE_REFERENCES`). |
| espeak-ng (optional) | Offline pronunciation fallback (with `INCLUDE_CONLANG`). |
| [Claude Code](https://code.claude.com/) | The skills, rules and workflows. |

---

## Generating a project

From the published template:

```bash
uvx copier copy --trust gh:Syntek-Dev/syntek-author my-book
```

From a local clone, rendering the checkout you have rather than the latest release tag:

```bash
uvx copier copy --trust --vcs-ref=HEAD "$(realpath ../syntek-author)" my-book
```

The template path must be absolute, as `"$(realpath ../syntek-author)"` makes it, because Copier records it in the answers file and every later update reads the template from there; a relative path makes every update fail with 'Updating is only supported in git-tracked templates'.
A project rendered from `HEAD` must also be updated with `--vcs-ref=HEAD` (still with `-a .copier-answers.syntek-author.yml`) until a newer release tag exists, because Copier refuses to move it back to the older tag.

**The `MissingFileWarning` is expected.** On a fresh copy, an adoption and (with Copier 9.18) every update, Copier may warn that `.copier-answers.syntek-author.yml` was not found. It is harmless. The template looks for your previous answers so that an update can refuse a changed `DOC_TYPE`; on a first copy there are none yet.

**Why `--trust`.** After rendering, the template runs three small tasks: `git init` (only where no repository exists), `chmod +x` on the session hook, and `make init` to build the references database. Copier treats any task as an unsafe feature and refuses to run one without `--trust`. Every task is non-fatal: if `sqlite3` or `make` is missing, the project is still complete and you run `make init` later.

Without prompts, for scripts and CI, pass every answer that has no default and accept the rest:

```bash
uvx copier copy --trust --defaults \
  --data DOC_TYPE=fiction \
  --data "PROJECT_NAME=The Salt Ferry" \
  --data "PROJECT_DESCRIPTION=A ferry pilot on a drowned coast must carry a stranger across the salt marsh before the spring tide." \
  --data "AUTHOR_NAME=Robin Example" \
  --data DATE=03/10/2026 \
  gh:Syntek-Dev/syntek-author the-salt-ferry
```

`DOC_TYPE` has no default on purpose: without it, `--defaults` stops with an error rather than quietly generating a theology book.

When generation finishes, open the project in Claude Code. The generated `README.md` and `CONTEXT.md` describe that project; `.claude/CLAUDE.md` holds its brief and points at the rules.

---

## The questions

| Question | Asked for | Default | What it means |
|---|---|---|---|
| `PROJECT_NAME` | all | — | The project's name: a working title, or a plain name such as 'Client Documents'. |
| `PROJECT_SLUG` | all | from the name | Kebab-case machine name (`^[a-z][a-z0-9-]+$`). Punctuation is dropped from the default. |
| `DOC_TYPE` | all | **none** | `theology`, `fiction` or `business`. Decides the whole tree. An update refuses a change. |
| `PROJECT_DESCRIPTION` | all | — | The brief: the thesis, the premise or the library's purpose, in at least one full sentence (40 characters or more). Every skill reads it first. |
| `AUTHOR_NAME` | all | — | Your name exactly as printed, full stops included. Settle its form now. |
| `AUTHOR_FIRST_NAME` | all | first word of your name | What skills call you in chat. Change it if your printed name opens with an initial or a title. |
| `AUDIENCE` | all | `lay` · `adult` · `client` | Theology: `lay`, `ministry-leaders`, `academic`. Fiction: `middle-grade`, `young-adult`, `adult`. Business: `client`, `staff`, `board`, `public`. The `comprehension` skill reads as this reader. |
| `READER_TEST` | all | one per variant | One sentence naming the reader every page must work for, such as 'a church leader reading on a Tuesday evening'. |
| `WORKING_TITLE` | books | the project name | The title the proof prints. |
| `SUBTITLE` | books | blank | The subtitle, if any. |
| `BIBLE_TRANSLATION` | theology | `niv2011` | The citation key of the translation you quote by default. |
| `FICTION_GENRE` | fiction | `fantasy` | Sets the worldbuilding default. |
| `INCLUDE_WORLDBUILDING` | fiction | on for fantasy and science fiction | See the options table. |
| `INCLUDE_CONLANG` | fiction with worldbuilding | on with worldbuilding | See the options table, and the pronunciation section below. |
| `TRADING_NAME` | business | the project name | The name your documents print. |
| `JURISDICTION` | business | England and Wales | The law your contracts and policies are written under. |
| `CURRENCY` | business | £ | The symbol your prices and fees use. |
| `BUSINESS_VOICE_PERSON` | business | `singular` | Speak as 'I' (`singular`) or 'we' (`plural`); the `tone` skill holds every document to it. |
| `BUSINESS_FAMILIES` | business | `business`, `legal`, `email`, `accounting`, `social-media` | Which document families the library holds (a multiple choice): `business` (proposals, statements of work, client guides, and each client's facts; always included), `legal` (contracts, NDAs, data processing agreements, terms), `email` (client and supplier correspondence), `accounting` (invoices, expenses, financial reports), `social-media` (plans, calendars, profiles) and `msp-scp` (IT policies, plans and reports for managed-service clients; opt-in). On the command line: `--data 'BUSINESS_FAMILIES=[business, legal]'`. |
| `INCLUDE_DRIVE_SYNC` | business | off | See the options table. The workflows need Google credentials as repository secrets. |
| `INCLUDE_PROPOSAL` | books | on | See the options table. |
| `INCLUDE_REFERENCES` | all | theology only | See the options table. |
| `INCLUDE_SENSITIVE_CONTENT` | books | off | See the options table. |
| `SEED_EXAMPLES` | all | on | Ships one worked example, once. Adoption answers `false`. |
| `MODEL_MECHANICAL` | all | `opus` for business, otherwise `sonnet` | The model for renames, ticks and builds. Substantive writing always uses Opus; Haiku is never used. |
| `TIMEZONE` | all | Europe/London | An IANA timezone name. |
| `DATE` | all | — | The baseline date in every metadata header, DD/MM/YYYY. Answered once and kept, so updates never churn your headers. |

Two values are computed and never asked: `CONTENT_LAYER` (`library` for business, otherwise `manuscript`) and `UNIT_NOUN` (`document` or `chapter`).

---

## The project's settings: `00-project.md` and `project.mk`

Every project gets two settings files, written once from your answers and never overwritten by `copier update`. They are where the project tells the template how it works.

**`.claude/rules/syntek-author/00-project.md`** sits with the template's rules, so Claude Code loads it at the start of every session, and it outranks every other file in that folder. The template's rules and skills read project-specific values from it, by heading, and from nowhere else:

| Heading | What it holds |
|---|---|
| `## Brief` | The audience, the reader test and the variant's answers: the Bible translation, the genre, or the trading name, voice, jurisdiction and currency. |
| `## Paths` | Where the project keeps each thing the template names by role: the project brief and rules, handoffs and their filename form, decision maps, research notes, the ledger, and for business the approval records, the brand folder, disclaimers, client facts and the LaTeX skeleton. Change the path, never the role. |
| `## Memory headings` | The six headings the template's files use in `.claude/MEMORY.md`, mapped to the headings this project uses. |
| `## Workflow aliases` | A template workflow, by its full folder name, and the project's own procedure to run instead. Empty until you add one. |
| `## Overrides` | A template rule this project does differently, such as how questions are asked; and **redirects**, one bullet each, `` `<template path>` → `<project path>` ``, for a template path with no role in `## Paths` (a family standard, a guide, a drafts folder): every template file then reads and writes the project's path instead. A redirect never points into a folder git ignores. Empty until you add one. |

When an answer changes later, change it here by hand: Copier never rewrites the file.

**`tooling/project.mk`** holds the build settings the `Makefile` reads before anything else: `LOGO_DIRS` (where TeX looks for a logo first), `FLAG_EXTRA_RE` (the project's own open-item marks, which `make flags` counts beside `AUTHOR TO CONFIRM` and `VERIFY`; business starts with `[AWAITING USER INPUT]` and `\fillme`), `MAINFONT`, `SANSFONT` and `MONOFONT` (the typefaces of a Markdown PDF), and for business `BRAND_DIRS` (where `make flags` looks for the brand files; `standards/brand` by default: point it at your own brand folder, or the template's brand seeds, which an update restores if deleted, keep their open slots counted for ever), `DOCX_CONVERTER` and `ISSUE_STATUSES` (the statuses at which `make pdf FILE=… ISSUE=1` may issue a document; `final` by default). A setting that differs from one project to the next belongs here, never in the `Makefile`.

Two build rules come with them. `make pdf FILE=… ISSUE=1` refuses to overwrite a PDF already issued beside its source unless you add `FORCE=1`, and refuses a document that still has an open flag whatever `FORCE` says; `ISSUE` and `FORCE` take only `1`, `yes` or `true`. And no `make` target reads a file git ignores: `make flags`, `make lint` and every other scan skip ignored folders, because they hold credentials and local-only material and the targets print what they find.

---

## What `copier update` will and will not touch

Every file in a generated project belongs to one of four classes. Knowing which is which is the whole of updating safely.

**1. Template files — updated, and merged with your edits.**
The rules in `.claude/rules/syntek-author/`, the skills, the hook, every folder's `CONTEXT.md` and `CLAUDE.md` (apart from the seeded ones below), the reference guides in `docs/reference/`, the numbered workflows, the standards (apart from the seeds below), `tooling/` and the `Makefile`.
An update brings the template's improvements and keeps your local edits through a three-way merge; where both changed the same lines you get a conflict to resolve.
Better than editing them: put your own guide in `docs/project/` (a guide there with the same name overrides the reference guide), your own procedure in `workflows/local/` (a local workflow with the same name overrides the template's), and your own rules in `.claude/CLAUDE.md`.

**2. Seeds — written once if missing, then yours.**
The project's settings, `.claude/rules/syntek-author/00-project.md` and `tooling/project.mk` (see above), `README.md`, `CONTEXT.md`, `.gitignore`, `.mcp.json`, `.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`, `.claude/settings.json`, the `CONTEXT.md` and `CLAUDE.md` of `.claude/skills/` and `.claude/hooks/`, the style sheet, voice notes, terminology and provenance table in `standards/style/`, the outline and the variant registers in `planning/src/`, the map index `planning/src/maps/CONTEXT.md`, the `CONTEXT.md` and `CLAUDE.md` of every `docs/project/` and `workflows/local/` (you add a row to them), the names register and the history's `eras.md`, the brand voice, brand guide and disclaimers, the permissions register, the page design and `book.tex` in `typeset/src/`, the proposal stubs and trackers, and `tooling/seed-refs.sql`.
An update never overwrites one that exists. If you delete one, the next update puts a fresh, empty copy back, because skills and rules read it by path.
The cost: once a seed exists it never receives the template's improvements. A release that must change a seed ships a migration that edits your copy only where exactly one change is correct, and lists the rest.
**The one exception: turning an option off deletes every file it generated, seeds included**, even ones you have filled in; dropping a document family deletes its template files (no family folder ships a seed) and, in an additively adopted repository, your own files at those template paths (see [Updating a project](#updating-a-project)).

**3. Examples — copied once, and they stay deleted.**
The example chapter or proposal, its brief, and the example language. They arrive on the first `copier copy` (unless `SEED_EXAMPLES` is false) and an update never renders them again: delete them when you are done and they never come back; keep and edit them and an update leaves them alone.

**4. Your folders — the template ships only the signposts.**
`docs/project/`, `workflows/local/`, the unit briefs in `planning/src/units/`, maps and reviews, every folder of sources, evidence and notes in `research/src/`, every folder in `world/src/`, the voice samples and ledger in `standards/style/`, `handoffs/`, `learning/` and `assets/`.
The template ships each folder's `CONTEXT.md` and `CLAUDE.md` and nothing else, so nothing you put there is ever touched. Where you add rows to the pair itself (`docs/project/`, `workflows/local/` and the map index), the pair is a seed (class 2), so an update never merges into your rows.

Your prose is never a template file: drafts, promoted sections and ledger entries are yours in every class above.

---

## Updating a project

Always on a branch, always with the answers file named:

```bash
git switch -c update-syntek-author
uvx copier update --trust -a .copier-answers.syntek-author.yml
git status && git diff     # review; resolve any conflict markers
git add -A && git commit -m 'Update from syntek-author'
```

**Why `-a`.** The answers file is called `.copier-answers.syntek-author.yml`, not Copier's default `.copier-answers.yml`, so that a second template can live in the same repository with its own (see below). Copier only finds a non-default answers file when you name it; without `-a` it stops and changes nothing.

**Changing an answer.** Pass it on the update, for example turning on the sensitive-content kit:

```bash
uvx copier update --trust -a .copier-answers.syntek-author.yml --data INCLUDE_SENSITIVE_CONTENT=true
```

Turning an option off removes every file that option generated, seeds included, even ones you have filled in — they survive only in your git history — and leaves every file you created yourself, except one at a path the option generates (which a repository adopted additively can have: copy it out first). Copy out and commit anything you need first: every update prints a list of what each option-off deletes before it asks its questions, and the generated `README.md` names the files for that project. After any option change, edit by hand the seeds that describe your options (`README.md`, `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/rules/syntek-author/00-project.md` under `## Brief`, `.claude/settings.json`, `.gitignore`), because an update never rewrites a seed.

The document families work the same way. Pass the whole list you want, for example adding `msp-scp`:

```bash
uvx copier update --trust -a .copier-answers.syntek-author.yml \
  --data 'BUSINESS_FAMILIES=[business, legal, email, accounting, social-media, msp-scp]'
```

A family you leave out of the list loses its template files — its folder's signposts, `library/docs/reference/<family>-standards.md` and its sub-documents (`EMAIL-ANATOMY-AND-NAMING.md`, `MSP-SCP-POLICY-SUITE.md`), its `<family>-documents` skill and its create workflow, including your edits to any of these files — and keeps every other document you wrote in its folder. No family folder ships a seed. In a repository adopted additively, a file of yours at the family's template path (its skill, its folder pairs) is deleted with it: copy it out first. `business` cannot be left out.

`DOC_TYPE` cannot change: an update that answers it differently stops before touching a file, because the content layer holds your work and Copier only moves what it generated. A different variant is a new project.

A project rendered from a local clone at `HEAD` (see [Generating a project](#generating-a-project)) updates with `--vcs-ref=HEAD` added to the command above, until a newer release tag exists.

**Migrations.** When a release moves a folder that can hold your work, or the place a setting you can change is read from, the update runs a migration script from the template after it has written the new tree. It moves a file, or writes a value into the seed the same release delivered, only where exactly one result is right and the destination is free; it never overwrites or deletes a file, and it prints what it moved or changed, what it left, and every line that still names an old path or gives old guidance. A migration runs only when the update crosses the release it belongs to, so it reaches you from that release's tag (an update to an untagged `HEAD` still numbered below it does not run it), and a later update, such as one that adds a family, does not run it again. The update's own copy of the template is gone when it ends, so each script ends by printing the command that runs it again from the project root: a clone of the release, then the script.

**Every project, updating from v0.1.0.** Brief values (audience, reader test and the variant's answers) are now read only from `.claude/rules/syntek-author/00-project.md` `## Brief`; the migration copies a value you changed in `.claude/CLAUDE.md` Section 1 where that is unambiguous and lists the rest. A brief question you answer again during the update itself (with `--data`, or a new answer at the prompt) keeps that answer in `## Brief`: an older hand edit is listed as a conflict, never written over it. `migrations/v0.2.0-project-settings.sh` compares `## Brief` with `.claude/CLAUDE.md` Section 1, the reader test in `.claude/MEMORY.md`, the trading name in `standards/brand/disclaimers.md` and the style sheet's `## Project settings`, and also lists each line of your seeds that still gives v0.1.0's guidance (a numbered section of `.claude/CLAUDE.md`, 'never edit' on the whole rules folder, the trading name's old home), with the v0.2.0 wording to put in its place. Change those lines by hand.

**Business, updating from v0.1.0.** v0.2.0 replaces v0.1.0's six folders under `library/src/` with the document families. The update asks `BUSINESS_FAMILIES` for the first time (`--defaults` takes every family but `msp-scp`), removes the old folders' signposts, and runs `migrations/v0.2.0-business-families.sh`, which moves what you wrote in them: `proposals/` → `business/`, `contracts/` → `legal/`, `policies/` → `business/` (or `msp-scp/` when you choose it), `correspondence/` → `email/` (a client's letters from `client-docs/` into `client-emails/`), `finance/` → `accounting/` and `marketing/` → `social-media/`, keeping each file's sub-path, so a kept example proposal lands in `library/src/business/drafts/example-proposal/`. A file whose destination already exists, whose family you did not choose, or which git ignores where it is but would not ignore where it would go, stays put and is named. The old folders' signposts are deleted even where you edited them; your lines remain in git history. The migration lists each one with the file in its family that takes your lines (`git show HEAD:<path>` recovers them), each moved client folder or template the new folder's `CONTEXT.md` does not yet name, and each email to file into its `client-emails/<client>/<family>/` folder. Afterwards, point each listed line (unit briefs, ledger entries, your notes) at its new path, and commit.

**Every project, updating from v0.2.0 or earlier.** From v0.3.0 the ledger records each section's original and every revision, and `make compare` prints them. A section worked before the update has no revision record: `make compare` shows it with the stages its entry holds — an AI-drafted section from its AI original to its final, every change unattributed and in grey; an author-drafted one as its final alone — and says the rest were not recorded. Nothing is migrated: no file moves, the new parts of an entry are optional, and an old entry is never backfilled, because nobody can say now who made each change. Such an entry keeps its decision rows and Author final as before; only a redraft of the section starts a new record. A section whose entry is first written after the update has its full record from the start.

Commit `.copier-answers.syntek-author.yml` and never edit it by hand; it is the record every future update merges against.

---

## Adopting an existing repository

There is no `copier adopt`. Adoption is a `copier copy` into the repository you already have, in one of two modes:

- **Moving adoption** (`copier copy --overwrite`): the template takes over its own paths, and the adoption script first moves your work into the template's layout. Choose it for a young repository, or one already close to the template's layout, whose governance the template should own from now on.
- **Additive adoption** (`copier copy --skip '*' --skip-tasks`): every file you have stays exactly as it is, nothing moves, and the template's files are added beside yours; `.claude/rules/syntek-author/00-project.md` then tells the template where your repository keeps things. Choose it for an established repository with conventions of its own that work — its own skills, a project `CLAUDE.md`, workflows numbered in its own series, a Drive or issuing practice — or one holding confidential material nobody should reorganise. **The caveat:** to Copier, a file you keep at a template path is a template file, so unticking a family or turning an option off on a later update deletes it, and a kept file the template later changes comes back with conflict markers (keep your version). Steps 5 and 6 below say how to meet both.

Either way, seeds you already have (`.claude/CLAUDE.md`, `MEMORY.md`, `settings.json`, `README.md` and the rest of class 2) are never overwritten, and `SEED_EXAMPLES=false` keeps an invented example out of a repository with real work in it.

### Moving adoption

1. **In the repository you are adopting, make a branch.** Commit or stash anything outstanding, so `git diff` shows only the adoption.

   ```bash
   git switch -c adopt-syntek-author
   ```

2. **Run the advisory script** from a clone of this template. It reports what it would move and changes nothing:

   ```bash
   bash /path/to/syntek-author/adopt/theology.sh          # or fiction.sh, business.sh
   ```

   Then run it again with `--apply`. It performs only the moves that have exactly one correct destination — `workspace/handoffs` and `workspace/learning` to the root, `workspace/maps` to `planning/src/maps`, `voice-and-tone.md` to `voice-notes.md`, chapter files that are still stub briefs to `planning/src/units/`, flat `docs/*.md` guides to `docs/project/`, bespoke workflows to `workflows/local/`, `status: stub` to `outlined`, and the section sign to 'Section' in governance files — and reports everything else for you to decide, including (business) every folder under `library/src/` that is not one of the document families. It never overwrites and never deletes, and a second run is a no-op. Review and commit the moves.

3. **Copy the template over the repository**, with an answers file you have edited from `adopt/examples/`:

   ```bash
   cp /path/to/syntek-author/adopt/examples/theology.answers.yml /tmp/answers.yml   # then edit every value
   uvx copier copy --trust --overwrite --data-file /tmp/answers.yml \
     --data SEED_EXAMPLES=false gh:Syntek-Dev/syntek-author .
   ```

   To adopt from a local clone instead, replace `gh:Syntek-Dev/syntek-author` with the clone's absolute path, such as `"$(realpath ../syntek-author)"`, and add `--vcs-ref=HEAD` (see [Generating a project](#generating-a-project)).
   `--overwrite` lets the copy replace the template's own files without stopping at each one.

4. **Review `git diff`.** Anything project-specific that a template file replaced — a paragraph in an old folder `CLAUDE.md`, a step in an old workflow — goes back into `docs/project/`, `workflows/local/` or `.claude/CLAUDE.md`. Because your seeds were kept, compare them with the template's: the adoption report names what a kept `settings.json`, `.claude/CLAUDE.md`, `MEMORY.md` or `.gitignore` lacks. In particular, a kept `.gitignore` with an unanchored `build/` (or `build`) line ignores every folder named `build`, including the `.claude/skills/build/` skill, which would then never be committed: change the line to `/build/`. Then fill in `.claude/rules/syntek-author/00-project.md`.

5. **Commit**, including `.copier-answers.syntek-author.yml`. From here, `copier update` works as above.

A manuscript laid out in two levels (sections holding chapters) is not supported in this release; the script reports it and moves nothing in it.

### Additive adoption

1. **Make a branch**, as above, from a clean tree. A file at a template path that git does not hold — left by an earlier attempt, say — is kept by the copy as if it were yours; the preview marks each kept file committed, untracked or ignored, so commit what is yours and remove the rest first.

2. **Preview the copy.** The script, with `--additive`, renders the template for your answers into a temporary folder, compares it with your repository and changes nothing:

   ```bash
   bash /path/to/syntek-author/adopt/business.sh --additive --answers /tmp/answers.yml
   ```

   It lists what the copy will add and what it will keep, and names three things to act on: a mode file (`THEOLOGY.md`, `FICTION.md` or `BUSINESS.md`) the template writes beside a `SKILL.md` you keep, which stays **inert** because a mode file applies only when its `SKILL.md` carries the Mode paragraph; each kept `CONTEXT.md` whose folder gains template entries it does not name, to **extend** by hand; and two procedures that will share a workflow number, to be cited by full folder name from then on. It also names every template path your ignore rules hide (with the rule that hides it), every file you keep that unticking a family or turning an option off would later delete, every template signpost added to a folder that already holds your own files, and a kept workflow that would sync the new `drafts/` folders. Every file it keeps is marked **kept, committed**, **kept, untracked** or **kept, ignored**. And it lists each **same-named** file: a template file the copy adds beside your own file of that name in a neighbouring folder, such as the template's `library/docs/reference/business-standards.md` beside your `library/docs/business-standards.md`, with the redirect line for `## Overrides` that makes every template file read yours. Its first line names the source and ref it previewed.

3. **Copy the template beside your files:**

   ```bash
   uvx copier copy --trust --skip '*' --skip-tasks --data-file /tmp/answers.yml \
     --data SEED_EXAMPLES=false gh:Syntek-Dev/syntek-author .
   ```

   To adopt from a local clone instead, replace `gh:Syntek-Dev/syntek-author` with the clone's absolute path, such as `"$(realpath ../syntek-author)"`, and add `--vcs-ref=HEAD` (see [Generating a project](#generating-a-project)). Preview and copy from the same source and ref, or the report is not exact: the script previews its own checkout at `HEAD`, and its closing note prints the copy command for that source.
   `--skip '*'` keeps every file that already exists; `--skip-tasks` leaves your repository's set-up alone, so run `chmod +x .claude/hooks/*.sh` yourself (and `make init` if you use the references kit). `git status` shows only additions.

4. **Fill in `.claude/rules/syntek-author/00-project.md`:** `## Paths` (where your repository keeps each thing), `## Memory headings` (your `MEMORY.md` headings), `## Workflow aliases` (your procedure in place of a template one) and `## Overrides`, with a redirect bullet for each same-named file the preview listed. For business, set `BRAND_DIRS` in `tooling/project.mk` if your brand files live outside `standards/brand/`. Then run the script again and extend the index files it names.

5. **Know what a later update can delete.** In a repository adopted additively, a file of yours at an unticked family's or option's template path (its skill, its folder pairs) is deleted with it: copy it out first. Before you untick a family or turn an option off, check whether any file you kept sits at one of its paths.

6. **Commit**, including `.copier-answers.syntek-author.yml`. In a repository adopted additively, a file you kept at a template path comes back with conflict markers whenever the template changed it: keep your version, and extend it by hand if you want the template's change.

---

## Applying a second template

syntek-author is built to share a repository with later templates (the first planned is `syntek-media`). Five rules make that safe:

1. Each template records its answers in its own file — this one's is `.copier-answers.syntek-author.yml`.
2. Each template keeps its instructions in its own folder, `.claude/rules/<template>/`. No template updates `.claude/CLAUDE.md`, which stays yours.
3. The shared root files (`README.md`, `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`, `.claude/settings.json`, `.mcp.json`, `.gitignore`, and the skills and hooks signposts) are seeds in every template: the first one writes them, and no template ever updates them. Each template's own ignore rules live in nested `.gitignore` files inside its own folders.
4. Skill and layer names never collide. The shared writing skills ship only from syntek-author.
5. Large binaries never sit in plain Git: generated audio and builds are ignored.

Apply the second template the same way, with its own answers file, and update each separately. Copier refuses to update a repository with uncommitted changes, so each command starts from a clean, committed tree:

```bash
uvx copier copy --trust gh:Syntek-Dev/syntek-media .
git add -A && git commit -m 'Apply syntek-media'
uvx copier update --trust -a .copier-answers.syntek-author.yml
git add -A && git commit -m 'Update from syntek-author'
uvx copier update --trust -a .copier-answers.syntek-media.yml
git add -A && git commit -m 'Update from syntek-media'
```

---

## Pronunciation audio for constructed languages

With `INCLUDE_CONLANG`, the IPA in each language's lexicon is the source of truth and audio is derived from it. The `pronounce` skill generates audio through an ElevenLabs MCP server named `elevenlabs`, and falls back to `espeak-ng` when the server is absent. It only generates audio when you ask, and it states the character count before any batch, because every call spends credits.

The template adds **nothing** to the project's `.mcp.json`. Add the server once, at **user** scope, so it is available to every project on your machine and its key lives in your own Claude Code configuration (`~/.claude.json`), never in a repository:

```bash
claude mcp add --env ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" --transport stdio --scope user \
  elevenlabs -- uvx elevenlabs-mcp
```

Export the key in your shell first rather than typing it on the command line, and never commit it. The server must be named `elevenlabs`: the skill calls its tools by that name (`mcp__elevenlabs__text_to_speech`). It saves audio under `ELEVENLABS_MCP_BASE_PATH` (default `~/Desktop`) unless you set that variable when adding it. In the project, each language's `audio/` folder is git-ignored.

---

## Running the audits

The template checks itself with the scripts in `.github/scripts/`, and CI runs every one on every push. Each prints what it checks, exits `0` when clean, `1` on a finding and `2` on a script error, and has a `--self-test` that proves each check can fail.

| Script | Checks |
|---|---|
| `check-template-tokens.sh` | Every token is well formed and registered; `<: :>` blocks pair up; variant tokens appear only in the spine set. |
| `gen-mode-excludes.sh [--check]` | Writes, or checks, the generated mode-file block of `_exclude` in `copier.yml`. |
| `generate-all.sh` | Renders every variant and profile from a copy of the working tree into a temporary directory. |
| `shipped-variants.sh <tree>` | The right skills, mode files, layers, gated folders and business document families in a rendered tree; no surviving token. |
| `byte-identity.sh` | Shared files are identical across the variants that ship them. |
| `docs-pairing.sh` | Every folder has its `CONTEXT.md` and `CLAUDE.md`, apart from the declared exceptions. |
| `doc-references.sh` | Every path a shipped file cites exists in that variant's tree. |
| `shipped-seeds.sh` | Seeds carry their headings and no entries (`00-project.md` and `project.mk` included), and every seed is in `_skip_if_exists`. |
| `skill-conformance.sh` | Skill frontmatter, sections, the mode contract and mode-file headings. |
| `line-cap.sh` | No instructional Markdown file exceeds 300 lines. |
| `update-test.sh` | A generated project survives `copier update` with the author's work intact; a changed `DOC_TYPE` is refused with nothing touched; the option-off warning is printed; a business project upgraded from `v0.1.0` has every file it kept in an old family folder moved to its family, nothing lost; a book project upgraded from `v0.1.0` keeps the audience its author changed in `.claude/CLAUDE.md` Section 1, now in `00-project.md` `## Brief`, and keeps a reader test answered again during the update, reporting the older hand edit as a conflict. |
| `adopt-test.sh` | Moving adoption over an anonymised fixture leaves seeds, sources and style untouched; additive adoption leaves every existing file untouched, and its report names the inert mode file and the index to extend; on a business library it also names the template paths an ignore rule hides, the kept files a family untick or option-off would delete, the signposts added beside the library's own files, and a kept workflow that would sync the new `drafts/` folders, each same-named file with its `## Overrides` redirect, and each kept file as committed, untracked or ignored. |
| `coexist-test.sh` | A second template's files and answers coexist through updates of both. |
| `tooling-smoke.sh` | The `make` targets run in rendered trees, each tooling script passes its own `--self-test`, a business section passes `make section-check` and fails it with one word changed, no git-ignored file reaches `make flags` or `make lint`, and no ignored language folder is found; `make flags` counts `\fillme`; `ISSUE=1` refuses to overwrite an issued PDF without `FORCE=1`, and refuses a document with open items even with it; `ISSUE` and `FORCE` refuse any value but `1`, `yes` or `true`; a file name git would quote still builds; `\houseclassification` prints its level in the header and footer of every page; and `make flags` reads the brand folder `BRAND_DIRS` names, and not `standards/brand/`, once `project.mk` points it elsewhere; `make compare FORMAT=tex` on a ledger entry planted with a multi-round revision chain writes LaTeX carrying each actor's macro, never prints a git-ignored entry, refuses `SECTION=` without `UNIT=`, says 'No sections to compare yet.' on an empty ledger, and builds the PDF where XeLaTeX exists. |
| `scrub.sh` | No personal data, source-repository names or absolute paths under `template/`. |
| `dev-isolation.sh` | Every template skill is denied at the root, and `claudeMdExcludes` is present. |

Run one, or all of them before a commit:

```bash
bash .github/scripts/check-template-tokens.sh
for s in .github/scripts/*.sh; do bash "$s" || echo "FAILED: $s"; done
```

`shipped-variants.sh` takes a rendered tree; `generate-all.sh` makes them. CI also runs shellcheck at warning level over every script (the same command locally: `uvx --from shellcheck-py shellcheck -S warning -x migrations/*.sh adopt/*.sh .github/scripts/*.sh template/.claude/hooks/*.sh`).

---

## Working on the template

Read [`DESIGN.md`](DESIGN.md) first: it is the build contract, and where any other file disagrees with it, `DESIGN.md` wins. [`CONTEXT.md`](CONTEXT.md) maps this repository, and `.claude/CLAUDE.md` is the development manual — token discipline, how to add a skill, a mode file or a gated path, and what to run before committing. Changes are recorded in [`CHANGELOG.md`](CHANGELOG.md).
