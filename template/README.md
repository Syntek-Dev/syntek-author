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
<: endif :>- **Author:** <%AUTHOR_NAME%>
- **Audience:** <%AUDIENCE%>
- **Reader test:** <%READER_TEST%>

The brief above is a starting point. The working version, kept current, is `.claude/CLAUDE.md`
Section 1.

---

## How the repository is laid out

| Folder | Kind | Holds |
|---|---|---|
| `planning/` | production | The outline, one brief per <%UNIT_NOUN%>, decision maps and reviews |
| `research/` | production | Sources, verified evidence and research notes |
<: if DOC_TYPE != 'business' :>| `manuscript/` | production | The book: one folder per chapter, with a `drafts/` folder inside each |
<: endif :><: if DOC_TYPE == 'business' :>| `library/` | production | The documents, by family: templates, client documents and drafts |
<: endif :><: if DOC_TYPE != 'business' :>| `typeset/` | production | The printed book: page design, the master file and each chapter styled for print |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `proposal/` | production | <: if DOC_TYPE == 'theology' :>The book proposal, endorsements and sample<: else :>The query letter, synopses, comparable titles, submissions and sample<: endif :> |
<: endif :><: if DOC_TYPE == 'fiction' :>| `world/` | production | The story bible: characters, places and the names register<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, peoples, cultures, world history and creatures<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, constructed languages<: endif :> |
<: endif :>| `standards/` | supporting | Style, voice, method, risk and verification rules |
| `tooling/` | supporting | The build and its scripts |
| `handoffs/` | working | Notes that carry work from one session to the next |
| `learning/` | working | A practice workspace; nothing in it is the work |
| `assets/` | working | Images and other binaries |
| `.claude/` | config | Claude Code's manual, rules, memory, settings, hooks and skills |

Each production layer has `docs/` (guides), `src/` (the work) and `workflows/` (step-by-step
procedures). Every folder carries a `CONTEXT.md` (what is here) and a `CLAUDE.md` (how to work
here). The full map is `CONTEXT.md`.

---

## The authoring loop

The work is written one small section at a time, and you decide every step:

1. **Draft.** Claude drafts one section of 300 to 500 words from the plan, or you write it yourself.
2. **Adapt or improve.** Claude revises from your notes, or proposes changes to your own draft as a numbered list, each with a reason.
3. **Decide.** You accept or reject each change; nothing is applied that you have not seen.
4. **Promote.** On your word, the section moves into the <%UNIT_NOUN%> and its history is recorded.
5. **Learn.** Claude studies what you changed and rejected, and proposes additions to your voice notes for you to approve.

The ledger in `standards/style/ledger/` keeps the AI's original and your final text for every
section, so `make provenance` can answer honestly when anyone asks how AI was used. The full rules
are in `.claude/rules/syntek-author/03-authorship.md`.

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
<: else :>make pdf FILE=library/src/proposals/…/document.tex   # render one deliverable
<: endif :>make flags                # every AUTHOR TO CONFIRM and VERIFY still open
make provenance           # the AI-disclosure table
make clean                # remove build/
```

Built files are generated: never edit one by hand; change the source and rebuild. The `build/`
folder is ignored by Git.

**Requirements:** `git`; `make`; Python 3.11 or later; `pandoc`; TeX Live with XeLaTeX<: if INCLUDE_REFERENCES :>;
`sqlite3`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>; `espeak-ng` (optional, for pronunciation)<: endif :>; and `uv`, for Copier<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> and for building the script fonts (`make font`)<: endif :>.

---

## Working with Claude Code

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
uvx copier update --trust -a .copier-answers.syntek-author.yml
git diff                  # review every change before committing
```

Copier may print a `MissingFileWarning` about `.copier-answers.syntek-author.yml`. It is
expected and harmless: the template reads your previous answers so it can refuse a changed
`DOC_TYPE`.

- **What updates:** the template's own files: the rules in `.claude/rules/syntek-author/`, the
  skills, the reference guides, the template workflows, the standards and the tooling.
- **What never changes:** your work, and the files seeded for you once: this README,
  `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/MEMORY.md`, `.claude/settings.json`, the style
  files and the other seeds. If you delete a seed, the update brings back an empty one. If you
  delete the worked example, it stays deleted. **The one exception:** turning an option off
  deletes the seeds that option generated (below).
- **Never edit `.claude/rules/syntek-author/`**, or any other file the template owns: the next
  update overwrites the edit or turns it into a conflict. Put project rules in
  `.claude/CLAUDE.md` Section 3, your own guides in a layer's `docs/project/`, and your own
  procedures in its `workflows/local/`.
- **Never edit `.copier-answers.syntek-author.yml` by hand.** To change an answer, give it to
  the update, then make the same change by hand in the seeded files that quote it, such as
  `.claude/CLAUDE.md` Section 1:

  ```sh
  uvx copier update --trust -a .copier-answers.syntek-author.yml --data READER_TEST='…'
  ```

- **`DOC_TYPE` never changes.** An update refuses a different variant and touches nothing; a
  different variant is a new project.

### Turning an option off deletes its files

Answering an `INCLUDE_…` question `false` on an update deletes **every file that option
generated, seeds included, even ones you have filled in**. Git keeps the last committed copy,
but copy out anything you still need and commit before you run the update. Files you created
yourself are never deleted. In this project:

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
<: endif :><: if DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC :>- `INCLUDE_DRIVE_SYNC=false` deletes `.github/`, the Drive push and pull workflows.
<: endif :>- Turning any option off also deletes your edits to the template's own files for it.

**After any option change, edit the seeds that describe your options by hand**, because Copier
never rewrites a seed: this README, `CONTEXT.md`, `.claude/CLAUDE.md` Section 1,
`.claude/settings.json` and `.gitignore`.
