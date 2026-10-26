# <%PROJECT_NAME%>

> <%PROJECT_DESCRIPTION%>

<: if DOC_TYPE == 'theology' :>A Christian non-fiction book by <%AUTHOR_NAME%>, written in plain text under Git with Claude Code
as a drafting and checking partner.
<: elif DOC_TYPE == 'fiction' :>A novel by <%AUTHOR_NAME%>, written in plain text under Git with Claude Code as a drafting and
checking partner.
<: else :>The business, legal and client documents of <%TRADING_NAME%>, written by <%AUTHOR_NAME%> in plain text
and LaTeX under Git, with Claude Code as a drafting and checking partner.
<: endif :>Generated from the syntek-author template on <%DATE%>.

---

## Overview

<: if DOC_TYPE != 'business' :>- **Working title:** <%WORKING_TITLE%>
<: if SUBTITLE :>- **Subtitle:** <%SUBTITLE%>
<: endif :><: else :>- **Trading name:** <%TRADING_NAME%>
- **Jurisdiction:** <%JURISDICTION%>
- **Document families:** <% BUSINESS_FAMILIES | join(', ') %>
<: endif :>- **Author:** <%AUTHOR_NAME%>
- **Audience:** <%AUDIENCE%>
- **Reader test:** <%READER_TEST%>

The brief above is a starting point. The working versions, kept current, are the project brief in
`.claude/CLAUDE.md` and the settings in `.claude/rules/syntek-author/00-project.md`.

---

## How the repository is laid out

| Folder | Kind | Holds |
|---|---|---|
| `planning/` | production | The outline, one brief per <%UNIT_NOUN%>, decision maps and reviews |
| `research/` | production | Sources, verified evidence and research notes |
<: if DOC_TYPE != 'business' :>| `manuscript/` | production | The book: one folder per chapter, with a `drafts/` folder inside each |
<: endif :><: if DOC_TYPE == 'business' :>| `library/` | production | The documents, one folder per family (<% BUSINESS_FAMILIES | join(', ') %>), each with templates, client documents and drafts |
<: endif :><: if DOC_TYPE != 'business' :>| `typeset/` | production | The printed book: page design, the master file and each chapter styled for print |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `proposal/` | production | <: if DOC_TYPE == 'theology' :>The book proposal, endorsements and sample<: else :>The query letter, synopses, comparable titles, submissions and sample<: endif :> |
<: endif :><: if DOC_TYPE == 'fiction' :>| `world/` | production | The story bible: characters, places and the names register<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, peoples, cultures, world history and creatures<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, constructed languages<: endif :> |
<: endif :>| `standards/` | supporting | Style, voice, method, risk and verification rules |
| `tooling/` | supporting | The build and its scripts, and your build settings in `tooling/project.mk` |
| `handoffs/` | working | Notes that carry work from one session to the next |
| `learning/` | working | A practice workspace; nothing in it is the work |
| `assets/` | working | Images and other binaries |
| `how-to/` | reference | The user guide: how this project works, step-by-step procedures for updating and setting up, and a glossary. Read-only: every update puts it back |
| `.claude/` | config | Claude Code's manual, rules, memory, settings, hooks and skills |

Each production layer has `docs/` (guides), `src/` (the work) and `workflows/` (step-by-step
procedures). Every folder carries a `CONTEXT.md` (what is here) and a `CLAUDE.md` (how to work
here). The full map is `CONTEXT.md`.

---

## Your settings

Two files hold this project's settings. Both were written once from your answers, and an update
never overwrites them, so edit them whenever the project changes:

- **`.claude/rules/syntek-author/00-project.md`** is what Claude reads for anything particular to
  this project, and it outranks the template's rules:
  - the settings of the brief: the audience<: if DOC_TYPE == 'theology' :>, the reader test and the default Bible translation<: elif DOC_TYPE == 'fiction' :>, the reader test and the genre<: else :>, the reader test, the trading name, the voice, the jurisdiction and the currency<: endif :>
  - where you keep handoffs, decision maps and research notes<: if DOC_TYPE == 'business' :>, the brand files, the disclaimers, each client's facts, the approval records and the LaTeX skeleton<: endif :>
  - any other template path you keep somewhere else, as a redirect line
  - which heading of `.claude/MEMORY.md` means what
  - a workflow of your own to use instead of one of the template's
  - any template rule this project works without, and what it does instead
- **`tooling/project.mk`** holds the build settings the `Makefile` reads:
  - extra open-item markers for `make flags` to count
  - the fonts for PDFs made from Markdown
  - the folders where logos are found first
<: if DOC_TYPE == 'business' :>  - the folders holding your brand files, which `make flags` also checks
  - a lossless LaTeX-to-Word converter, if you have one
  - the statuses at which a document may be issued
<: endif :>
Your own rules for the project go in `.claude/CLAUDE.md`, under 'Project-specific rules'.

---

## The authoring loop

The work is written one small section at a time, and you decide every step:

1. **Draft.** Claude drafts one section of 300 to 500 words from the plan, or you write it yourself.
2. **Adapt or improve.** Claude revises from your notes, or proposes changes to your own draft as a numbered list, each with a reason.
3. **Decide.** You accept or reject each change; nothing is applied that you have not seen.
4. **Promote.** On your word, the section moves into the <%UNIT_NOUN%> and its history is recorded.
5. **Learn.** Claude studies what you changed and rejected, and proposes additions to your voice notes for you to approve.

The ledger in `standards/style/ledger/` keeps each section's original (the AI's draft or yours),
every revision with who made it, and your final text, so `make provenance` can answer honestly
when anyone asks how AI was used, and `make compare` can show how each section moved from its
original to its final text. The full rules are in `.claude/rules/syntek-author/03-authorship.md`.

---

## Building

```sh
make help                 # every target, with a one-line description
<: if INCLUDE_REFERENCES :>make init                 # only if tooling/references.db is missing (generation built it, if sqlite3 was there)
make refs                 # export the references for Pandoc
<: endif :><: if DOC_TYPE != 'business' :>make pdf SCOPE=manuscript/src/<chapter-folder>     # a proof of one chapter
make book                 # the whole manuscript, as .docx and .pdf
make tex SCOPE=manuscript/src/<chapter-folder>     # a chapter's Pandoc base, for typesetting
make tex-check            # every styled chapter still carries exactly its Markdown's words
make print                # the printed book, from typeset/src/book.tex
<: else :>make pdf FILE=library/src/business/…/document.tex   # a proof of one document, in build/
<: if DATA_STORE == 'repo' :>make pdf FILE=… ISSUE=1   # issue it beside its source (final by default; never over an issued file)
<: endif :><: if DATA_STORE == 'external' :>make pdf FILE=… ISSUE=1   # issue it under the data root (final by default; never over an issued file)
<: endif :><: endif :>make flags                # every AUTHOR TO CONFIRM and VERIFY still open<: if DOC_TYPE == 'business' :>, and every [AWAITING USER INPUT]<: endif :>
make provenance           # the AI-disclosure table
make compare UNIT=<unit>  # each section's original, AI edit and final, marked by who changed what
make clean                # remove build/
```

Built files are generated: never edit one by hand; change the source and rebuild. The `build/`
folder is ignored by Git, and no target ever reads a file Git ignores.

**Requirements:** `git`; `make`; Python 3.14 or later, which every script here needs (on an older
Python each one stops and says so); `pandoc`; TeX Live with XeLaTeX (with the `xcolor`, `ulem`
and `paracol` packages for `make compare`)<: if INCLUDE_REFERENCES :>;
`sqlite3`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>; `espeak-ng` (optional, for pronunciation)<: endif :>; and `uv`, for Copier on Python 3.14 or later<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> and for building the script fonts (`make font`)<: endif :>.

---

<: if DATA_STORE == 'external' :>## Binary files and the data root

This project keeps its binary files (PDFs and scans, office documents, images, audio, video)
outside the repository, under each machine's data root, so that Git keeps the text. Each file
is filed under `<root>/<area>/<kind>/<slug>/`, at the path it would have in the repository,
and listed with its checksum in its folder's `external.toml`, which you commit with the work.
The rules are in `.claude/rules/syntek-author/09-data-root.md`.

**On each machine you work on, once:**

1. Choose the data root, a folder outside every repository, and set the environment variable
   `SYNTEK_DATA_ROOT` to its absolute path (in your shell profile, or in the system's
   environment settings on Windows). No file in this project names it.
2. Create the empty marker file `.syntek-data-root` at the top of that folder: nothing is
   filed under a folder without it, which also catches a disk that is not mounted.
3. Run `make root`: it checks the root, and prints where each kind of file goes and the
   checklist for the service you chose to keep a copy of it.

```sh
make root                       # the root, the layout and your provider's checklist
make files-add FILE=… ROLE=…    # file a copy under the root and list it (AS=, SOURCE=, LABEL=)
make files-status               # the loss check: binaries Git ignores that no manifest lists
make files-verify               # check every listed file against its checksum
make files-pull                 # copy listed files into the work tree, where Git ignores them
make files-plan                 # tracked binaries and where each would go (COPY=1 copies them)
```

- **Text work needs no root.** Drafting, proofs, lint and `make flags` run without one;
  issuing and filing stop with the reason and never fall back to the repository.
<: if DOC_TYPE == 'business' :>- **Issuing files the PDF here.** `make pdf FILE=… ISSUE=1` files the issued copy under the
  root instead of beside its source; with `FORCE=1` it keeps the old copy, marked superseded.
<: endif :>- **Nothing filed is overwritten or deleted.** A file is copied, checked against its checksum
  and only then listed, and a manifest's rows are never removed. The data-root tool behind
  these targets is the one exception to 'no target reads a file Git ignores': it copies or
  hashes only a file you name or a manifest lists, and lists any other by name and size only.
- **Files Git already tracks stay tracked.** The nested `.gitignore` files keep new binaries
  out of Git; `make files-plan` lists the tracked ones, and moving them out is your decision.
- **Never put this repository inside a synced folder**, and never put the data root inside a
  repository: a sync service copies file by file and corrupts Git. Sync the data root only,
  with the service you named for `DATA_PROVIDER`. The template never installs, configures or
  runs it.
- **Never edit a filed file in place.** In Claude Code, the guard wired in
  `.claude/settings.json` refuses an edit or a write under a data root, and a search there
  where Claude Code has its own search tools. On macOS, Linux and WSL Claude Code searches
  through the shell, which the guard cannot see, so there, as in every other client, the rules
  alone keep a session out of the root.
- **Keep the layout answers.** `DATA_AREA`, `DATA_SLUG` and the four kind folders decide where
  files go, and any other syntek template in this project uses the same ones: the data-root
  commands stop while two disagree. A later change leaves the files already filed where they
  are, and `make root` names their folder. Answering `DATA_STORE` repo forgets these answers,
  so note them first.

---

<: endif :>## Working with Claude Code

- Open Claude Code at the root of this repository. `.claude/CLAUDE.md` and the template's rules
  load automatically.
- Say what you want in plain words ("draft the next section", <: if DOC_TYPE != 'business' :>"review chapter 3"<: else :>"review the services agreement"<: endif :>, "build a proof")
  and the skill for that job runs; a request no skill matches, or "what's next?", goes to the
  `run-workflow` skill, which finds the procedure. Skills can also be called by name, such as
  `/draft-section`.
- Anything Claude cannot settle on its own is left in the text as an `AUTHOR TO CONFIRM` or
  `VERIFY` flag. `make flags` lists them.
- When a session grows long, Claude writes a handoff to `handoffs/` and stops, rather than
  compacting. Run `/clear` and continue from the handoff.

---

## Other coding agents

The same rules, skills and memory serve every client; `.claude/` is the one source.
<: if AGENT_CLIENTS | length > 0 :>
<: if 'codex' in AGENT_CLIENTS :>- **Codex** starts from `AGENTS.md` and reads `.codex/config.toml` once you trust the project.
<: endif :><: if 'gemini-cli' in AGENT_CLIENTS :>- **Gemini CLI** starts from `GEMINI.md` and reads `.gemini/settings.json` once you trust the folder.
<: endif :><: if 'antigravity' in AGENT_CLIENTS :>- **Antigravity** starts from `GEMINI.md` (and reads `AGENTS.md` where present); its MCP servers go in `.agents/mcp_config.json`.
<: endif :><: if 'opencode' in AGENT_CLIENTS :>- **OpenCode** starts from `AGENTS.md`; <: if 'opencode' in AGENT_CLIENTS and OPENCODE_PROVIDER not in ['user', 'named'] :>`opencode.json` names its model and the local server at <% OPENCODE_BASE_URL.rstrip('/') %>: start the server first<: elif 'opencode' in AGENT_CLIENTS and OPENCODE_PROVIDER == 'named' :>`opencode.json` names its model<: else :>it uses the model in your own OpenCode settings<: endif :>.
<: endif :>
Each entrypoint sends the client to every `.claude/syntek-*-agents.md` present, which gives the
read order these clients cannot load by themselves, and `.agents/skills` links to
`.claude/skills` so every client finds the same skills. The model each client uses is in
`.claude/rules/syntek-author/05-model-allocation.md`. Hand off rather than compact in every
client: only Claude Code enforces it.

These files are written once and are yours: an update never adds a missing one or brings back
one you deleted, and changes them only by adding each of the template's two MCP servers once to
a file that lacks it. After changing `.claude/settings.json`, run
`python3 .claude/syntek-author-permissions.py --check` to see which client files need the change.
<: endif :>
To add a client later, follow 'Enabling a client in an existing project' in
`.claude/syntek-author-agents.md`.

---

## Conventions

- British English (en_GB); single quotation marks; dates DD/MM/YYYY; 24-hour time.
- Write "Section 3.2", never the section sign.
- In `src/` folders, one sentence per line (it renders identically and makes changes easy to
  review).
- Work in progress lives in `drafts/` folders, which no build includes.

---

## Updating from the template

The template improves over time. To take its changes, commit or stash your own work first, then:

```sh
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml
git diff                  # review every change before committing
```

The five `GIT_CONFIG_*` variables (bash, zsh and other POSIX shells) turn Git's background
housekeeping off for that one command, which can otherwise stop an update with
`OSError: [Errno 39] Directory not empty`; give them to every update command below too. Never
commit what such an update left: syntek-author's own `README.md`, 'Updating a project', gives
the recovery, and so does `how-to/workflows/syntek-author/02-recover-a-failed-update/`.
`--python '>=3.14'` runs Copier on Python 3.14 or later, which the update report needs: left to
itself, `uvx` may run Copier on an older Python it already has. Keep the quotes, or the shell
reads `>` as a redirection.

The steps, with every command: `how-to/workflows/syntek-author/01-update-the-template/`; what
each answer means and costs to change: `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`.

Copier may print a `MissingFileWarning` about `.copier-answers.syntek-author.yml`, and another
about `.copier-answers.syntek-media.yml`. Both are expected and harmless: the template reads
your previous answers so it can refuse a changed `DOC_TYPE`, and the other syntek template's
answers so that both keep one data-root layout; without that template there are none.

- **What updates:** the template's own files: the rules in `.claude/rules/syntek-author/`, the
  skills, the reference guides, the template workflows, the standards and the tooling, and the
  user guide in `how-to/`, which every update puts back where it differs.
- **What never changes:** your work, and the files seeded for you once: this README,
  `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/MEMORY.md`, `.claude/settings.json`,
  `.claude/rules/syntek-author/00-project.md`, `tooling/project.mk`, the style files and the
  other seeds. If you delete a seed, the update brings back an empty one. If you
  delete the worked example, it stays deleted. **The exceptions:** turning an option off
  deletes the seeds that option generated, and in a repository adopted additively, your own
  files at its template paths (below). An update also adds, once each and into your own text,
  the hook entries and permission rules the template lists to `.claude/settings.json`, and its
  two MCP servers to `.mcp.json` and each client file you have, never one you removed.
- **In a repository adopted additively,** a file you kept at a template path comes back with
  conflict markers whenever the template changed it: keep your version, and extend it by hand
  if you want the template's change.
- **Never edit the rules from `01-` to `09-` in `.claude/rules/syntek-author/`**, or any other
  file the template owns: the next update overwrites the edit or turns it into a conflict. Put
  settings and overrides in `00-project.md`, project rules under 'Project-specific rules' in
  `.claude/CLAUDE.md`, your own guides in a layer's `docs/project/`, and your own procedures in
  its `workflows/local/`.
- **Never edit `.copier-answers.syntek-author.yml` by hand.** To change an answer, give it to
  the update, then make the same change by hand in the seeded files that quote it, such as
  `00-project.md` and the project brief in `.claude/CLAUDE.md`:

  ```sh
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml --data READER_TEST='…'
  ```

- **`DOC_TYPE` never changes.** An update refuses a different variant and touches nothing; a
  different variant is a new project.

### Turning an option off deletes its files

Answering an `INCLUDE_…` question `false` on an update deletes **every file that option
generated, seeds included, even ones you have filled in**. Git keeps the last committed copy,
but copy out anything you still need and commit before you run the update. Your own files are
never deleted, except in one case: in a repository adopted additively, a file of yours at
an <: if DOC_TYPE == 'business' :>unticked family's or <: endif :>option's template path (its skill, its folder
pairs) is deleted with it, so copy it out first. In this project:

<: if DOC_TYPE == 'theology' and INCLUDE_PROPOSAL :>- `INCLUDE_PROPOSAL=false` deletes the proposal stubs `proposal/src/book-proposal/01-overview-and-hook.md`
  to `proposal/src/book-proposal/08-sample-chapters.md`, `proposal/src/endorsements/tracker.md` and
  `proposal/src/sample/sample-index.md`, with the rest of `proposal/`.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_PROPOSAL :>- `INCLUDE_PROPOSAL=false` deletes `proposal/src/query-letter.md`, `proposal/src/synopsis-short.md`,
  `proposal/src/synopsis-long.md`, `proposal/src/comp-titles.md`, `proposal/src/submissions/tracker.md`
  and `proposal/src/sample/sample-index.md`, with the rest of `proposal/`.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `INCLUDE_WORLDBUILDING=false` deletes `world/src/history/eras.md` and the rest of the
  worldbuilding kit<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, and turns the constructed-language kit off with it (its
  scripts, guides, workflows and skills; the languages you built stay, and their generated
  audio stays ignored by `world/src/.gitignore`)<: endif :>.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>- `INCLUDE_CONLANG=false` deletes the constructed-language kit: `tooling/lexicon.py`,
  `tooling/script.py`, `tooling/font.py`, its guides, workflows and skills. The languages you
  built stay; `make lexicon` and its fellows stop working until you turn it back on.
<: endif :><: if INCLUDE_REFERENCES :>- `INCLUDE_REFERENCES=false` deletes `tooling/seed-refs.sql` and the rest of the citation
  pipeline; `tooling/references.db` is yours and stays.
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>- `INCLUDE_SENSITIVE_CONTENT=false` deletes `standards/risk/sensitive-content.md`, the
  testimony workflow and the `sensitivity-pass` skill; your testimony records stay.
<: endif :><: if DOC_TYPE == 'business' and (DATA_PROVIDER | default('google-drive')) == 'google-drive' and (DATA_STORE | default('repo')) == 'repo' :>- Choosing a provider other than Google Drive, or keeping files outside the repository
  (`DATA_STORE` external), deletes `.github/`, the Drive push and pull workflows, including your
  edits.
<: endif :><: if DOC_TYPE == 'business' :>- Unticking a family in `BUSINESS_FAMILIES` deletes its folder's signposts (the `CONTEXT.md` and
  `CLAUDE.md` of `library/src/<family>/` and its sub-folders, and `drafts/README.md`), its
  standard `library/docs/reference/<family>-standards.md` and the standard's sub-documents
  (`EMAIL-ANATOMY-AND-NAMING.md` for email, `MSP-SCP-POLICY-SUITE.md` for msp-scp), its
  `<family>-documents` skill and its create workflow, including your edits to any of these files.
  No family folder ships a seed. Your own documents elsewhere in its folder stay. Ticking a
  family brings all of them in.
<: endif :>- Turning any option off also deletes your edits to the template's own files for it.

**After any option change, edit the seeds that describe your options by hand**, because Copier
never rewrites a seed: this README, `CONTEXT.md`, `.claude/CLAUDE.md`,
`.claude/rules/syntek-author/00-project.md`, `.claude/settings.json` and `.gitignore`.
