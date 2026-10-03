# syntek-author

**A Copier template that generates writing repositories — a theology book, a novel or a business document library — with their own folder system, standards and a Claude Code skill suite.**

![Version](https://img.shields.io/badge/version-0.1.0-blue)
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
| `business` | Business, legal and client documents | `library/` (documents) | The document register, review schedule, approvals, brand and disclaimers, LaTeX deliverables |

Every variant shares the same spine:

- **The authoring loop.** The AI drafts one small section (`draft-section`), or you draft and the AI proposes changes as a diff with a reason for each (`improve-section`); your notes drive targeted revisions (`adapt-section`); only your word moves a section into the unit (`promote-section`); and the template learns your voice from what you changed and rejected (`learn-voice`).
- **Provenance.** Every section keeps a ledger entry holding the AI's original and your final text. `make provenance` prints a per-unit disclosure table for publishers.
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
| `SEED_EXAMPLES` | all | on | One worked example unit (and, with the constructed-language kit, a tiny example language) |

---

## Requirements

| Tool | Needed for |
|---|---|
| [uv](https://docs.astral.sh/uv/) (`uvx`) | Running Copier without installing it. Copier 9.6.0 or newer. |
| git | Every project is a repository; updates are three-way merges. |
| Python 3.11 or newer | The scripts in `tooling/` (standard library only, TOML data files). |
| make | Every build and check (`make help` lists them). |
| Pandoc and XeLaTeX | `make pdf`, `make docx` and the book builds. |
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

## What `copier update` will and will not touch

Every file in a generated project belongs to one of four classes. Knowing which is which is the whole of updating safely.

**1. Template files — updated, and merged with your edits.**
The rules in `.claude/rules/syntek-author/`, the skills, the hook, every folder's `CONTEXT.md` and `CLAUDE.md` (apart from the seeded ones below), the reference guides in `docs/reference/`, the numbered workflows, the standards (apart from the seeds below), `tooling/` and the `Makefile`.
An update brings the template's improvements and keeps your local edits through a three-way merge; where both changed the same lines you get a conflict to resolve.
Better than editing them: put your own guide in `docs/project/` (a guide there with the same name overrides the reference guide), your own procedure in `workflows/local/` (a local workflow with the same name overrides the template's), and your own rules in `.claude/CLAUDE.md`.

**2. Seeds — written once if missing, then yours.**
`README.md`, `CONTEXT.md`, `.gitignore`, `.mcp.json`, `.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`, `.claude/settings.json`, the `CONTEXT.md` and `CLAUDE.md` of `.claude/skills/` and `.claude/hooks/`, the style sheet, voice notes, terminology and provenance table in `standards/style/`, the outline and the variant registers in `planning/src/`, the map index `planning/src/maps/CONTEXT.md`, the `CONTEXT.md` and `CLAUDE.md` of every `docs/project/` and `workflows/local/` (you add a row to them), the names register and the history's `eras.md`, the brand voice, brand guide and disclaimers, the permissions register, the page design and `book.tex` in `typeset/src/`, the proposal stubs and trackers, and `tooling/seed-refs.sql`.
An update never overwrites one that exists. If you delete one, the next update puts a fresh, empty copy back, because skills and rules read it by path.
The cost: once a seed exists it never receives the template's improvements. A release that must change a seed ships a migration that edits your copy only where exactly one change is correct.
**The one exception: turning an option off deletes every file that option generated, seeds included**, even ones you have filled in (see [Updating a project](#updating-a-project)).

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

Turning an option off removes every file that option generated, seeds included, even ones you have filled in — they survive only in your git history — and leaves every file you created yourself. Copy out and commit anything you need first: every update prints a list of what each option-off deletes before it asks its questions, and the generated `README.md` names the files for that project. After any option change, edit by hand the seeds that describe your options (`README.md`, `CONTEXT.md`, `.claude/CLAUDE.md` Section 1, `.claude/settings.json`, `.gitignore`), because an update never rewrites a seed.

`DOC_TYPE` cannot change: an update that answers it differently stops before touching a file, because the content layer holds your work and Copier only moves what it generated. A different variant is a new project.

A project rendered from a local clone at `HEAD` (see [Generating a project](#generating-a-project)) updates with `--vcs-ref=HEAD` added to the command above, until a newer release tag exists.

Commit `.copier-answers.syntek-author.yml` and never edit it by hand; it is the record every future update merges against.

---

## Adopting an existing repository

There is no `copier adopt`. Adoption is a `copier copy` over an existing repository, with seeds left alone because they already exist. What the copy cannot do is move anything, so the adoption scripts in `adopt/` do the moving first.

1. **In the repository you are adopting, make a branch.** Commit or stash anything outstanding, so `git diff` shows only the adoption.

   ```bash
   git switch -c adopt-syntek-author
   ```

2. **Run the advisory script** from a clone of this template. It reports what it would move and changes nothing:

   ```bash
   bash /path/to/syntek-author/adopt/theology.sh          # or fiction.sh, business.sh
   ```

   Then run it again with `--apply`. It performs only the moves that have exactly one correct destination — `workspace/handoffs` and `workspace/learning` to the root, `workspace/maps` to `planning/src/maps`, `voice-and-tone.md` to `voice-notes.md`, chapter files that are still stub briefs to `planning/src/units/`, flat `docs/*.md` guides to `docs/project/`, bespoke workflows to `workflows/local/`, `status: stub` to `outlined`, and the section sign to 'Section' in governance files — and reports everything else for you to decide. It never overwrites and never deletes, and a second run is a no-op. Review and commit the moves.

3. **Copy the template over the repository**, with an answers file you have edited from `adopt/examples/`:

   ```bash
   cp /path/to/syntek-author/adopt/examples/theology.answers.yml /tmp/answers.yml   # then edit every value
   uvx copier copy --trust --overwrite --data-file /tmp/answers.yml \
     --data SEED_EXAMPLES=false gh:Syntek-Dev/syntek-author .
   ```

   To adopt from a local clone instead, replace `gh:Syntek-Dev/syntek-author` with the clone's absolute path, such as `"$(realpath ../syntek-author)"`, and add `--vcs-ref=HEAD` (see [Generating a project](#generating-a-project)).
   `--overwrite` lets the copy replace the template's own files without stopping at each one. Your seeds (`.claude/CLAUDE.md`, `MEMORY.md`, `settings.json`, `README.md` and the rest of class 2) are not overwritten, because they already exist. `SEED_EXAMPLES=false` keeps an invented example out of a repository with real chapters.

4. **Review `git diff`.** Anything project-specific that a template file replaced — a paragraph in an old folder `CLAUDE.md`, a step in an old workflow — goes back into `docs/project/`, `workflows/local/` or `.claude/CLAUDE.md`. Because your seeds were kept, compare them with the template's: the adoption report names what a kept `settings.json`, `.claude/CLAUDE.md`, `MEMORY.md` or `.gitignore` lacks. In particular, a kept `.gitignore` with an unanchored `build/` (or `build`) line ignores every folder named `build`, including the `.claude/skills/build/` skill, which would then never be committed: change the line to `/build/`.

5. **Commit**, including `.copier-answers.syntek-author.yml`. From here, `copier update` works as above.

A manuscript laid out in two levels (sections holding chapters) is not supported in this release; the script reports it and moves nothing in it.

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
| `shipped-variants.sh <tree>` | The right skills, mode files, layers and gated folders in a rendered tree; no surviving token. |
| `byte-identity.sh` | Shared files are identical across the variants that ship them. |
| `docs-pairing.sh` | Every folder has its `CONTEXT.md` and `CLAUDE.md`, apart from the declared exceptions. |
| `doc-references.sh` | Every path a shipped file cites exists in that variant's tree. |
| `shipped-seeds.sh` | Seeds carry their headings and no entries, and every seed is in `_skip_if_exists`. |
| `skill-conformance.sh` | Skill frontmatter, sections, the mode contract and mode-file headings. |
| `line-cap.sh` | No instructional Markdown file exceeds 300 lines. |
| `update-test.sh` | A generated project survives `copier update` with the author's work intact; a changed `DOC_TYPE` is refused with nothing touched; the option-off warning is printed. |
| `adopt-test.sh` | Adoption over an anonymised fixture leaves seeds, sources and style untouched. |
| `coexist-test.sh` | A second template's files and answers coexist through updates of both. |
| `tooling-smoke.sh` | The `make` targets run in rendered trees, each tooling script passes its own `--self-test`, and a business section passes `make section-check` and fails it with one word changed. |
| `scrub.sh` | No personal data, source-repository names or absolute paths under `template/`. |
| `dev-isolation.sh` | Every template skill is denied at the root, and `claudeMdExcludes` is present. |

Run one, or all of them before a commit:

```bash
bash .github/scripts/check-template-tokens.sh
for s in .github/scripts/*.sh; do bash "$s" || echo "FAILED: $s"; done
```

`shipped-variants.sh` takes a rendered tree; `generate-all.sh` makes them.

---

## Working on the template

Read [`DESIGN.md`](DESIGN.md) first: it is the build contract, and where any other file disagrees with it, `DESIGN.md` wins. [`CONTEXT.md`](CONTEXT.md) maps this repository, and `.claude/CLAUDE.md` is the development manual — token discipline, how to add a skill, a mode file or a gated path, and what to run before committing. Changes are recorded in [`CHANGELOG.md`](CHANGELOG.md).
