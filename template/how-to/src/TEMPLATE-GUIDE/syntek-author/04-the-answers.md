# The answers — every question Copier asks, and changing one later

When the project was made, Copier asked a series of questions, and your answers decided what it generated.
This chapter explains each question, how to answer without being prompted, and how to change an answer later.
Your own answers are recorded in `.copier-answers.syntek-author.yml`, the answers file at the top of the project.

## The questions

Some questions are asked only for one variant, or only when an earlier answer calls for them.
'Books' means the theology and fiction variants.
A word in the table you do not know is explained in the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

| Question | Asked for | Default | What it means |
|---|---|---|---|
| `PROJECT_NAME` | every project | none | The project's name: a working title, or a plain name such as 'Client Documents'. |
| `PROJECT_SLUG` | every project | made from the name | The project's machine name, in lower-case words joined by hyphens; punctuation is dropped from the default. |
| `DOC_TYPE` | every project | none, on purpose | `theology`, `fiction` or `business`. It decides the whole project, and an update refuses a change. |
| `PROJECT_DESCRIPTION` | every project | none | The brief: the thesis, the premise or the library's purpose, in at least one full sentence. Every skill reads it first. |
| `AUTHOR_NAME` | every project | none | Your name exactly as it is printed, full stops included. |
| `AUTHOR_FIRST_NAME` | every project | the first word of your name | What the skills call you in conversation. Change it if your printed name opens with an initial or a title. |
| `AUDIENCE` | every project | `lay`, `adult` or `client` | Who reads the work. Theology: `lay`, `ministry-leaders` or `academic`. Fiction: `middle-grade`, `young-adult` or `adult`. Business: `client`, `staff`, `board` or `public`. The `comprehension` skill reads as this reader. |
| `READER_TEST` | every project | one for each variant | One sentence naming the reader every page must work for, such as 'a church leader reading on a Tuesday evening'. |
| `WORKING_TITLE` | books | the project's name | The title a proof prints. |
| `SUBTITLE` | books | blank | The subtitle, if there is one. |
| `BIBLE_TRANSLATION` | theology | `niv2011` | The citation key of the Bible translation you quote by default. |
| `FICTION_GENRE` | fiction | `fantasy` | The novel's genre. It sets the default for the worldbuilding kit. |
| `INCLUDE_WORLDBUILDING` | fiction | on for fantasy and science fiction | Adds peoples, cultures, world history, creatures and quests to the story bible. |
| `INCLUDE_CONLANG` | fiction with worldbuilding | on with worldbuilding | Adds the constructed-language kit: sounds, grammar, words and their history, a writing system and pronunciation. |
| `TRADING_NAME` | business | the project's name | The name your documents print. |
| `JURISDICTION` | business | England and Wales | The law your contracts and policies are written under. |
| `CURRENCY` | business | £ | The currency symbol your prices and fees use. |
| `BUSINESS_VOICE_PERSON` | business | `singular` | Whether the business speaks as 'I' (`singular`) or 'we' (`plural`). The business tone check holds every document to it. |
| `BUSINESS_FAMILIES` | business | every family but `msp-scp` | The document families the library holds: `business` (proposals, statements of work, client guides and each client's facts; always included), `legal` (contracts, NDAs, data processing agreements and terms), `email` (client and supplier correspondence), `accounting` (invoices, expenses and financial reports), `social-media` (plans, calendars and profiles) and `msp-scp` (IT policies, plans and reports for managed-service clients). |
| `INCLUDE_PROPOSAL` | books | on | Adds the proposal layer: the book proposal and endorsements for theology, or the query package and submissions tracker for fiction. |
| `INCLUDE_REFERENCES` | every project | on for theology only | Adds the citation database, which prints your reference lists in Harvard style, and the skill that adds a work to it. |
| `INCLUDE_SENSITIVE_CONTENT` | books | off | Adds the sensitive-content standard, a sensitivity check and safe handling for testimony. |
| `SEED_EXAMPLES` | every project | on | Ships one worked example, once. An adoption answers off. |
| `MODEL_MECHANICAL` | every project | `opus` for business, otherwise `sonnet` | The AI model for mechanical work, such as renames, ticks and builds. Substantive writing always uses Opus. |
| `AGENT_CLIENTS` | every project | all four on a new project; none on the update that first asks it; in either case, the other template's clients where another template in the project records them | Which coding agents besides Claude Code the project is set up for: `codex`, `gemini-cli`, `antigravity` and `opencode`. Claude Code is always included. Ticking a client on an update records it, but adds none of its files. Taking the other template's clients means this template, applied second, writes no client file the first left out. An update that takes them adds no client file: the model table follows the answer, and the update may add the two MCP servers, once, to the client files the other template wrote. |
| `CODEX_MODEL` | with Codex | blank, or the other template's answer | Codex's model for substantive work, written to `config.toml` in `.codex`. Blank keeps Codex's own default. |
| `GEMINI_MODEL` | with Gemini CLI | blank, or the other template's answer | Gemini CLI's model for substantive work, written to `settings.json` in `.gemini`. Blank keeps its own default. |
| `OPENCODE_PROVIDER` | with OpenCode | `user`, or the other template's answer | Where OpenCode's model comes from: `user` (your own OpenCode settings), `named` (a model you name, written `<provider>/<model>`), or a server on your own machine: `llama-cpp`, `ollama`, `vllm`, `lmstudio` or `openai-compatible`. |
| `OPENCODE_BASE_URL` | with OpenCode and a local server | the other template's answer where it chose the same server; otherwise each server's usual address on your own machine, and none for `openai-compatible` | The server's address, starting `http://` or `https://` and ending `/v1`. |
| `OPENCODE_MODEL` | with OpenCode, unless `user` | the other template's answer where it chose the same provider; otherwise blank | The model's name as the server lists it, or `<provider>/<model>` for `named`. Required for a local server. |
| `OPENCODE_CONTEXT` | with OpenCode and a local server | the other template's answer where it chose the same server; otherwise it depends on the server | How much text, counted in tokens, the server can hold in mind at once. Never more than the server's own setting. |
| `DATA_STORE` | every project | `external` on a new project; `repo` on the update that first asks it | Where binary files are kept: `external`, outside the repository under each machine's data root, or `repo`, inside the repository as before. Every template in the project gives the same answer. |
| `DATA_AREA` | with `external` | `business`, or the other template's answer | The first folder under the data root that holds this project's files, named as you want it on disk. |
| `DATA_SLUG` | with `external` | the project folder's name, in lower-case words joined by hyphens | This project's own folder inside each kind folder. Never change it once files are filed under it. |
| `DATA_KIND_DOCS`, `DATA_KIND_PHOTOS`, `DATA_KIND_AUDIO`, `DATA_KIND_VIDEOS` | with `external` | `docs`, `photos`, `audio`, `videos` | The folder under the area for each kind of file: documents, images, audio and video. |
| `DATA_PROVIDER` | every project | `none`, or the other template's answer | Which service keeps a copy of the data root: `none`, `google-drive`, `onedrive`, `dropbox`, `other-cloud` or `nas`. You set it up and run it yourself, and the answer only tailors the checks, except in business with Google Drive and the files kept in the repository, where it also ships the Drive workflows. |
| `TIMEZONE` | every project | Europe/London | Your time zone, as a name such as Europe/London. |
| `DATE` | every project | none | The date in every file's header, written DD/MM/YYYY. It is answered once and kept, so updates never change your headers. |

Two more values are worked out from your answers and never asked.
`CONTENT_LAYER` is the folder of the content layer, and `UNIT_NOUN` is what the project calls a unit: a chapter or a document.

## Answering without prompts

Copier normally asks each question in turn, but a script can give the answers instead.
`--defaults` accepts the default of every question that has one.
`--data` gives one answer, written `KEY=value`, and can be repeated for each answer you give.
A script that makes a new project passes both, with `--data` for every question that has no default.
`DOC_TYPE` has no default on purpose, so `--defaults` alone stops with an error rather than quietly choosing a variant.
The README at the template's source gives the full command that makes a new project, with an example.
The source is the `_src_path` line of your answers file; this guide never writes the command, because it needs that address.

## Your own defaults

Copier can read your own defaults from a user settings file, in Copier's folder of your user settings.
On Linux and in WSL the file is `~/.config/copier/settings.yml`, and on macOS it is `~/Library/Application Support/copier/settings.yml`.
On Windows it is settings.yml in the folder AppData\Local\copier inside your user folder.
On any system, Copier reads instead the file the environment variable `COPIER_SETTINGS_PATH` names.
The file holds a `defaults:` map, so a choice you make on every project, such as your local model server, lives there and no template hard-codes it.
One file serves every template that asks a question of the same name.
An answer given with `--data`, and an answer already recorded in the project, both win over it.
On an update it fills in only the questions that are new to the project.
The least the file may hold is `defaults: {}`, because an empty file has crashed Copier.
A value that is not one of a question's choices makes every copy fail, even one that never asks that question.
Never put `AGENT_CLIENTS` there: it would record coding agents whose files the project never received.
Never put `DATA_STORE` or `DATA_SLUG` there either, because a value there replaces their careful defaults, which follow another template's recorded answers and the project's own folder.
Set `DATA_AREA` or a kind folder there only where it equals every other template's recorded answer.
Set a model answer or an OpenCode answer there only where it equals every other template's recorded answer too, because a value there replaces the default that follows another template's answers.
Leave `DATA_PROVIDER` out as well, because there it replaces the answer an older project's update works out for itself.

## Changing an answer later

You change an answer by giving it to an update, which renders the template's files again with the new answer.
Run the update the way `how-to/workflows/syntek-author/01-update-the-template/` says: on a branch, with everything committed first.
This example changes the model for mechanical work to Opus; put your own question and answer after `--data`:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml --data MODEL_MECHANICAL=opus
```

The five settings in front turn Git's background housekeeping off for that one run, so the update does not stop part way.
The update prints its report when it ends, and records the new answer in the answers file.
Then make the same change by hand in the files that quote the answer, such as `.claude/rules/syntek-author/00-project.md` under `## Brief` and the project brief in `.claude/CLAUDE.md`.
An update never rewrites those files, because they are seeds: written once, then yours.
Never edit the answers file by hand: every later update works from it.
`DOC_TYPE` never changes: an update that answers it differently stops before touching a file, because a different variant is a new project.
An answer that is a list, such as `BUSINESS_FAMILIES` or `AGENT_CLIENTS`, is given whole, with every value you want to keep.
For example, `--data 'BUSINESS_FAMILIES=[business, legal]'` keeps those two families and drops every other.
Ticking a coding agent on an update records it, and `how-to/workflows/syntek-author/03-enable-an-agent-client/` then adds its files.
In a script, add `--defaults` as well, so a question that is new to the project takes its default instead of waiting for you.

## Turning an option off

Answering an option off, or unticking a document family, deletes every file that option generated.
That includes the seeds it generated, even ones you have filled in, and your edits to the template's own files for it.
Git keeps the last committed copy of each, but copy out anything you still need, and commit, before you run the update.
Before it asks its questions, every update prints the list of what each option deletes, so read it first.
A change of data store or data provider can delete files too, and the list says which.
Your own files are never deleted, except in a repository that adopted the template additively.
There, a file of yours at one of the option's template paths is deleted with it, so copy it out first.
After any option change, edit by hand the seeds that describe your options: `README.md`, `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/rules/syntek-author/00-project.md`, `.claude/settings.json` and `.gitignore`.

## The shared questions

The questions about coding agents and about the data root are shared by every template of the family, word for word.
So a project that carries two templates answers them the same way in each.
The data-root answers must agree between templates: a first answer that differs from another template's recorded one is refused.
`how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains the coding agents and their files.
`how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains the data root and its layout.

## Where the rules live

- `.claude/rules/syntek-author/06-global-rules.md` Section 11: answers change through Copier, and what turning an option off deletes.
- `.claude/rules/syntek-author/00-project.md` `## Brief`: the settings that quote your answers, which you update by hand.
- `how-to/docs/syntek-author/updating-the-template.md`: what an update changes, and why it is run as it is.
- `how-to/workflows/syntek-author/01-update-the-template/`: the update, with every command.
- `how-to/workflows/syntek-author/03-enable-an-agent-client/`: adding a coding agent's files after you tick it.

## Next

- What your answers generated, and what an update does to each file → `how-to/src/TEMPLATE-GUIDE/syntek-author/05-what-gets-generated.md`
- Adding a coding agent → `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`
- Keeping binary files outside the repository → `how-to/src/TEMPLATE-GUIDE/the-data-root.md`
