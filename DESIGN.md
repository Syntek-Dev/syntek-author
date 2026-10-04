# DESIGN.md — syntek-author

**Last Updated**: 04/10/2026 **Version**: 0.3.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

The build contract for `syntek-author`, a Copier template that generates writing repositories in three variants:
`theology` (Christian non-fiction books), `fiction` (novels, with optional worldbuilding and a constructed-language kit) and `business` (business, legal and client documents).
It generalises three hand-built repositories and follows the house Copier idiom of `syntek-base`.

This file is the template repository's own design record. It sits outside `template/`, so it is never rendered.
Where this file and the cross-check map disagree, **this file wins**. Every override is marked **(overrides cross-check)**.

**Source material** (read-only; never modify):

| Abbreviation | Source |
|---|---|
| AT | a hand-built theology book repository (private) — the most mature example of the house layer idiom |
| SC | a second, older theology book repository (private) — sensitive-content handling and the sections layout |
| BD | a hand-built business-documents repository (private) — the `library/` and `planning/` layers and LaTeX deliverables |
| SB | `syntek-base` (public, `gh:Syntek-Dev/syntek-base`) — the house Copier idiom |

The private sources are named and located only in the maintainer's local notes, never in this repository. Convention maps written from them during the build (house formats, verbatim skeletons, hazards) are kept outside the repository too.

---

## 1. Decisions

| # | Decision | Notes |
|---|---|---|
| D1 | **`_subdirectory: template`.** Everything that ships lives at its real path under `template/`. The repository root holds the template's own state, design, audits and adoption scripts. | Cross-check Section 6.1. |
| D2 | **House Copier idiom from SB:** `_min_copier_version: "9.6.0"`, `_templates_suffix: ""`, `_preserve_symlinks: true`, `_envops` delimiters `<% %>` / `<: :>` / `<~ ~>`, anchored `_exclude` patterns, one templated `_exclude` line per gated path, UPPER_SNAKE question names, `>-` help text. | No `<%`, `<:` or `<~` occurs in any source text file. |
| D3 | **Answers file `_answers_file: .copier-answers.syntek-author.yml`.** The template file is literally `template/.copier-answers.syntek-author.yml` containing `<% _copier_answers\|to_nice_yaml -%>` under SB's header comment. | **(overrides cross-check)**: enables coexistence with `syntek-media` (Section 9). **Every `copier update` must pass `-a .copier-answers.syntek-author.yml`** (verified on Copier 9.18.2: without it the update refuses), and `copier copy` takes an absolute template path; every instruction that shows either command says so. |
| D4 | **Template instructions live in `.claude/rules/syntek-author/*.md`** (template-owned, updated by `copier update`). Claude Code loads every `.claude/rules/**/*.md` without `paths` frontmatter at launch with the same priority as `.claude/CLAUDE.md`. **`.claude/CLAUDE.md` is a seed-if-missing project file** holding the project brief and a pointer to the rules. | **(overrides cross-check)** which made `.claude/CLAUDE.md` template-owned. `.claude/rules/` is exempt from the folder-pair rule: a `CONTEXT.md` there would load as a rule. |
| D5 | **Skills only.** No `.claude/agents/`, no `.claude/commands/`. Persona rules from AT and BD agents fold into skills and mode files; use `context: fork` where a subagent is wanted. | Cross-check D7. |
| D6 | **Shared skills are byte-identical across variants**; each carries exactly one gated mode file beside `SKILL.md`: `THEOLOGY.md`, `FICTION.md` or `BUSINESS.md`. Mode files use four H2s: `## Paths and unit` · `## Additions to the steps` · `## Domain rules` · `## Examples`. | Cross-check Section 1.1(g). |
| D7 | **Layer names follow the existing repositories:** `manuscript/` (theology, fiction) or `library/` (business); `planning/`; `research/`; `proposal/` (books, optional); `world/` (fiction); `standards/` (supporting, flat); `tooling/` (supporting, flat); root `handoffs/`, `learning/`, `assets/`. | `world/` is new, for the fiction kit. |
| D8 | **The style trio lives at `standards/style/`**: `style-sheet.md`, `voice-notes.md`, `terminology.md`, plus `samples/` (the author's own writing) and `ledger/` (the evidence `learn-voice` mines). | Cross-check Section 5.1, extended. |
| D9 | **A unit and its sections.** A *unit* is a chapter (books) or a document (business). A *section* is a small passage inside a unit, typically 300–500 words: one argument step, one scene beat, one clause group. The unit's **plan** lives in `planning/src/units/NN-kebab-title.md`; the unit's **prose** lives in the content layer and is assembled from promoted sections. | **(overrides cross-check 1.1(i))**: the stub's brief moves out of the manuscript file, so promotion never mixes plan and prose. |
| D10 | **The authoring loop**, as designed in conversation: `draft-section` (the AI drafts one small section) → `adapt-section` (the author's notes, or edits, drive a targeted revision with alternatives for contested lines) **or** `improve-section` (the author drafts; the AI proposes changes as a diff with a one-line reason each, at strength `light`, `edit` or `rework`) → `promote-section` (the author's word moves the approved section into the unit and records provenance) → `learn-voice` (mines the ledger and proposes voice-note additions the author approves). | **(overrides cross-check 4.1)**, which redefined `adapt-section` as source adaptation. |
| D11 | **Two status vocabularies.** The **unit** status ladder: `idea · outlined · draft · structural-review · fact-check · line-edit · final` (in the unit brief's frontmatter; `stub` is an accepted alias of `outlined`). The **section** status: `ai-draft · author-draft · adapted · improved · author-revised · promoted`. A unit becomes `final` only through the review workflow and the author's word, never through `promote-section`. Gates (`standards/verification/verification.md`): **V1** brief agreed (gates `idea → outlined`); `outlined → draft` needs only V1 held and happens when the first section is drafted; **V2** every planned section promoted with zero flags, and **V3** the unit proof builds (together gate `draft → structural-review`); **V4** structure review (gates `structural-review → fact-check`); **V5** fact-check (gates `fact-check → line-edit`); **V6** comprehension, flow, grammar and spelling passes plus the author's word (gates `line-edit → final`). Variant sub-gates hang off V4–V6. Workflows cite a gate as `V2 (draft → structural-review)`. | |
| D12 | **Provenance and AI disclosure.** Every section has a ledger entry at `standards/style/ledger/<unit-slug>--<section-slug>.md`, holding the AI original verbatim (when AI-drafted), the author's final text at promotion, and every improvement accepted or rejected. `tooling/provenance.py` (stdlib `difflib`) computes the author's change ratio, and `make provenance` prints a per-unit disclosure table for publishers. From v0.3.0 the entry also records the author's original and every revision, and `make compare` prints them (D45). | |
| D13 | **Two inline flags**, both listed by `make flags`: `AUTHOR TO CONFIRM` (a decision only the author can make) and `VERIFY` (a checkable claim not yet verified). Markdown form `<!-- AUTHOR TO CONFIRM: … -->` / `<!-- VERIFY: … -->`; LaTeX form `\dnote{AUTHOR TO CONFIRM: …}`. The `final` gate requires zero of both. | Cross-check row 20, plus `VERIFY` from the conversation. |
| D14 | **Ownership classes** (one Copier mechanism each): template-owned (merged by `copier update`); seed-if-missing (`_skip_if_exists`); seed-once examples (copy-only templated `_exclude` with `SEED_EXAMPLES`); author-owned pair-only folders. See Section 3. | Cross-check Section 6.5, adjusted for D4 and D17. |
| D15 | **Theology method is generic.** The theology variant ships the **six claim categories** (Biblical text · textual observation · interpretive inference · historical interpretation · the author's theological conclusion · pastoral application), argument maps, contested readings and steelmanning. **A source book's own thesis framework, and the skills built only to apply it, never ship.** | **(overrides cross-check 4.2)** sources for `argument-audit` and `category-check`. |
| D16 | **Fiction kit.** All fiction projects get `world/` (characters, places, names register), character arcs and naming. `INCLUDE_WORLDBUILDING` adds creatures, cultures and quests. `INCLUDE_CONLANG` adds constructed languages: phonology, grammar, lexicon, etymology, a writing system and pronunciation. | From conversation, 03/10/2026. |
| D17 | **Coexistence with future templates** (`syntek-media`): shared root files are seed-if-missing, never updated (`README.md`, root `CONTEXT.md`, `.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`, `.claude/settings.json`, `.mcp.json`, `.gitignore`, and the `.claude/skills/` and `.claude/hooks/` pairs). Template-specific ignore rules go in nested `.gitignore` files inside this template's own folders; the Makefile writes `build/.gitignore` (`*`) when it creates `build/`. | **(overrides cross-check 6.5)** which made `settings.json`, `.gitignore` and `.mcp.json` template-owned. Changes to seeded settings ship as `_migrations`. |
| D18 | **Data files a script reads are TOML** (`tomllib`, standard library, Python ≥ 3.11). Every script in `tooling/` is standard-library only, **with one exception**: `tooling/font.py` declares `fonttools` as PEP 723 inline script metadata and runs through `uv run`, so nothing is installed globally. | The conversation said YAML; TOML keeps "one small script, no dependencies". |
| D19 | **Pronunciation audio is derived, never canonical.** IPA in the lexicon is the source of truth; `pronounce` sends the **surface** IPA (allophone rules and stress applied by `tooling/lexicon.py surface`). The `pronounce` skill uses the **user-scope** MCP server named `elevenlabs` (`mcp__elevenlabs__text_to_speech`, Eleven v4 with inline IPA between slashes, model ID discovered with `mcp__elevenlabs__list_models` and recorded per language) and falls back to `espeak-ng`. It generates audio only when the author asks, because every call spends credits. Audio is git-ignored. The template adds **nothing** to `.mcp.json`. | From conversation; ElevenLabs is configured at user scope. |
| D20 | **SVG → font in v0.1.** `tooling/font.py build <lang>` compiles `script/glyphs.toml` + `script/glyphs/*.svg` into `build/fonts/<lang>.otf` (CFF outlines via fontTools `FontBuilder` and `svgLib`). Glyph SVGs are **filled outlines, never strokes**, on the em grid declared in `glyphs.toml` `[meta]`. Each glyph maps to a Private Use Area code point (ConScript Unicode Registry convention): an explicit `codepoint` wins; missing ones are assigned deterministically after the highest explicit one, in file order, by one shared function used by both `font.py` and `script.py`. `font.py assign <lang>` prints the TOML lines to pin them. Positional forms ship as `calt` contextual alternates when `forms` are present. | From conversation, 03/10/2026. |
| D31 | **Books typeset through LaTeX.** The author writes Markdown; the `typeset` skill turns a promoted unit into `typeset/src/units/NN-kebab-title.tex` by (1) running Pandoc with the house Lua filter to produce the base — **the words come from Pandoc, never retyped by the AI** — saved as `typeset/src/units/.base/NN-kebab-title.tex`; (2) applying styling with house-class macros only; (3) `make tex-check` (`tooling/texcheck.py`, stdlib) compares the styled file's words against the Markdown's words and fails on any difference. After the Markdown changes, re-typesetting runs `git merge-file styled old-base new-base` to carry styling onto the new text; conflicts are resolved by the skill and re-checked. `make print` builds `typeset/src/book.tex` with XeLaTeX. `make pdf` stays as the quick Pandoc proof. | From conversation, 03/10/2026. |
| D32 | **The conlang method** (author's 23 rules) is the governing method for `build-language`, `add-word`, `design-script`, `create-name` and the conlang tooling: world first (each language links to a culture; vocabulary depth follows what its speakers value); proto-language first, daughters derived by ordered regular sound changes (Tolkien method); 20–35 phonemes; IPA first, separate readable romanisation (no apostrophe soup, sparing diacritics, one spelling per sound with documented exceptions); phonotactics carry the flavour; one stress rule; a few allophones; word order and morphology type chosen together; decide what the language marks and what it ignores; irregularity in the most frequent words; core list first (about 200 core concepts plus pronouns); derive from roots, affixes and compounds; word histories (root → sound-shifted form → semantic drift); loanwords adapted to phonotactics; imperfect overlap with English; irregularity emerges from sound change rather than hand insertion; dictionary and grammar from day one, under version control; names consistent with the language; restraint on the page; test pronounceability aloud. The full text lives in `world/docs/reference/building-a-language.md`. | From conversation, 03/10/2026. |
| D33 | **Every language has real-world models**, as Tolkien's do (Quenya: Finnish, Latin, Greek; Sindarin: Welsh; Khuzdul: Semitic). `language.toml` carries one or more `[[inspiration]]` entries (language, period, family, weight, what is borrowed, sources). The inspiration is chiefly about **how the language sounds** — phonology, phonotactics, stress and rhythm, and so how readers hear its names — with morphology type, syntax and naming habits as optional extras. Borrow **structure and flavour**, not vocabulary: words are still built from the language's own roots; a deliberate echo of a real word is recorded in the word's `echo` field with the real word, its verified meaning and a source. Every claim about a real language is researched and cited (`research` skill → `research/src/setting/`), never asserted from memory. Related peoples share or descend from related models, so a family reads as a family (`make family` prints the tree with each branch's models). Safeguards: a false-friend check for prominent words (unintended meanings in the model languages or English slang), and respect for living languages (taking a minority, Indigenous or sacred language's feel is acceptable; lifting its words, sacred terms or caricaturing it is flagged — the rule lives in `standards/risk/FICTION.md`, `build-language`, `add-word`, `create-name` and `design-script` apply it every time, and `sensitivity-pass` adds a dedicated pass when that option is on). Three layers are decided separately: **sound** (always modelled on the inspiration), **romanisation** (a reader-facing choice: English-friendly by default, with only a few model-flavoured spellings, because readers pronounce with English habits), and **native script** (optional, with its own inspiration in `script/glyphs.toml` `[meta.inspiration]`, which may come from a real script family unrelated to the sound model — Sindarin sounds Welsh but is written in Tengwar — taking its structure without copying its glyphs). `make lexicon` warns when a language has no inspiration. The grilling skills open language and word work with the inspiration and its point in history (Section 5.2). | From conversation, 03/10/2026. |
| D34 | **The AI proposes models from the world, then gives its opinion.** Before proposing a sound model, a script or a name style, `build-language`, `design-script`, `create-name` and the grilling skills read the world files: the **people** (`world/src/peoples/`: physiology that constrains speech), the **culture** (values → where vocabulary runs deep; social structure → honorifics; religion → sacred registers; technology and materials → the script's medium), the **world history** (`world/src/history/`: eras, migrations, conquests and contact → proto/daughter splits, loanwords, when sound changes happened) and the **places** (climate, terrain, neighbours). They then present **two or three options**, each with a real-world language (or script family) and period, the reasoning tied to named world files, what readers will associate it with, a few sample names, and risks — and **state a recommendation with its reason**. If the world files are too thin to justify a choice, they say what is missing rather than guess. Always flagged: modelling a hostile or 'evil' people's language on a real ethnic group's language (readers carry the association back to real people; harsh-consonant stereotypes are a trap) — suggest ancient or extinct models, or blends, for antagonists. **Scripts take real-world inspiration by default** (recommended, not mandatory), chosen from the culture's medium and tool and the script's origin (native invention, borrowed from a neighbour, or adapted — awkward fits create authentic spelling quirks), taking a real family's structure and stroke logic, never its glyphs. | From conversation, 03/10/2026. |
| D35 | **Answers that destroy work are guarded.** `DOC_TYPE` cannot change on update: `copier.yml` reads the previous answers through `_external_data` (`prev: .copier-answers.syntek-author.yml`) and DOC_TYPE's validator refuses a change (`<: if (_external_data.prev.DOC_TYPE \| default(DOC_TYPE, true)) != DOC_TYPE :>…<: endif :>`); the cost, a MissingFileWarning on fresh copies, is accepted. Turning an `INCLUDE_*` option off on update deletes that option's template files, including filled seeds: a `_message_before_update` names exactly what each option-off removes and tells the author to copy anything they need first. `update-test.sh` proves both. | Wave 3 review, 03/10/2026. |
| D36 | **Business sections are word-checked too.** `tooling/texcheck.py` ships to every variant. Its section mode compares the words between each `% section: <slug>` / `% end section: <slug>` pair in a `.tex` deliverable with `pandoc -t plain` of the promoted Markdown draft; `promote-section` (business) runs it before writing the ledger, and fails on any difference. Citation keys (`[@key]`) work only in Markdown documents in business v0.1: `promote-section` stops on a draft bound for a `.tex` that still contains `[@`, and the author writes the reference in full (biblatex deferred, Section 11). | Wave 3 review, 03/10/2026. |
| D37 | **Drive sync never pushes drafts or unfinished work and never overwrites the record.** Push uploads only issued artefacts: the PDF beside a `.tex` whose leading block reads `% status: final`, `.docx`/`.xlsx`, and `.md` with frontmatter `status: final`; ingest reading copies live outside `library/src` or carry a suffix the filter excludes. Pull never overwrites a tracked file whose content differs: it writes `<basename>.drive-DD-MM-YYYY.<ext>` beside it and reports it, and always skips a PDF beside a `.tex`. | Wave 3 review, 03/10/2026. |
| D38 | **Author notes are not AI suggestions.** The ledger decision column takes `accepted · rejected · author-note`. `adapt-section` logs each applied author note as `author-note`; `provenance.py` counts only `accepted` and `rejected` as AI suggestions; `learn-voice` still mines author notes as voice evidence. The same three words name who made each revision in the D45 chain, `accepted` becoming the kind `ai`. A row still open keeps its decision cell empty: `adapt-section` writes no fourth word such as `pending`. | Wave 3 review, 03/10/2026; extended v0.3.0, 04/10/2026. |
| D39 | **Business document families are chosen per project** (`BUSINESS_FAMILIES`, multi-select): `business` (always; proposals, statements of work, client guides), `legal` (contracts, NDAs, DPAs, terms), `email` (client and supplier correspondence), `accounting` (invoices, expenses, financial reports), `social-media` (plans, calendars, profiles) and `msp-scp` (IT policies, plans and reports for managed-service clients; opt-in). Each selected family ships its folder `library/src/<family>/` (with `templates/`, `client-docs/` and `drafts/`; `email` files by correspondent instead, in `client-emails/` and `supplier-emails/`), its standard `library/docs/reference/<family>-standards.md`, its skill `<family>-documents` and its create workflow; all are generalised from the business repository the variant was extracted from, with every business- and client-specific detail removed. They replace v0.1.0's `proposals · contracts · policies · correspondence · finance · marketing`, which a v0.2.0 migration moves (D44). | v0.2.0, 03/10/2026. |
| D40 | **One project-owned settings file.** `.claude/rules/syntek-author/00-project.md` is a seed (written once from the answers, never overwritten, loaded at launch with the rules). It holds `## Brief` (audience, reader test and the variant's answers such as voice person, trading name, jurisdiction, currency, Bible translation, genre), `## Paths` (brand folder, disclaimers, client facts, LaTeX skeleton, handoffs and their filename form, decision maps, research notes, ledger, and where project rules live), `## Memory headings` (the template's six headings mapped to the project's own), `## Workflow aliases` (a template workflow and the project procedure to use instead) and `## Overrides` (for example the questioning style). Template rules and skills read project-specific values **only** from it, never from a numbered section of `.claude/CLAUDE.md`, and it outranks every other file in `.claude/rules/syntek-author/`. `## Paths` includes an **Approvals** role. A template path with no role of its own is redirected by an `## Overrides` line of the form `` `<template path>` → `<project path>` ``, which every template file honours (rule 01), so an adopter can point, say, the family standards or the drafts folders at its own without the template re-citing them. Build settings live beside it in the seed `tooling/project.mk` (D43). | v0.2.0, 03/10/2026. |
| D41 | **Additive adoption is a supported mode.** Adopting an existing repository is `copier copy --skip '*' --skip-tasks` (every existing file kept, nothing moved) followed by filling in `00-project.md`. To make that safe: a mode file applies only when its `SKILL.md` carries the Mode paragraph (a project's own skill of the same name ignores it); `run-workflow` lists workflow folders directly when an index has no 'You want to… \| Procedure' table, and resolves `## Workflow aliases` first; template files cite workflows by full folder name, never by number alone. `adopt.sh` documents and reports this mode, including same-basename duplicates (a project's own guide or standard beside the template's) and the ignore rules that would hide a template path. **Caveat, stated wherever adoption is described:** an additive adopter's own files at a template path are template files to Copier, so unticking a family or turning an option off on update deletes them, and a kept file the template later changes comes back with conflict markers (resolve in favour of the project's version). | v0.2.0, 03/10/2026. |
| D42 | **No tooling reads what git ignores.** `make flags`, `make lint` and every other scan filter their file lists through `git check-ignore`, keeping only paths git does not ignore (or that a negation re-includes), because ignored folders hold credentials and local-only material and the targets print matching lines verbatim. Outside a git work tree they fall back to the plain list. | v0.2.0, 03/10/2026; found in the business-repository adoption review. |
| D43 | **Issuing and project build settings.** `make pdf ISSUE=1` refuses to overwrite an existing file beside the source unless `FORCE=1`, and issues only at a status in `ISSUE_STATUSES` (default `final`). `ISSUE=1` also refuses while the document has an open flag, with no `FORCE` bypass, and `ISSUE`/`FORCE` accept only `1`, `yes` or `true`. `tooling/project.mk` (seed, included by the Makefile with `-include`) sets `BRAND_DIRS` (where `make flags` looks for brand files; default `standards/brand`), `LOGO_DIRS` (searched first in `TEXINPUTS`), `DOCX_CONVERTER`, `FLAG_EXTRA_RE` (extra open-item patterns `make flags` counts; business default `\[AWAITING USER INPUT\]` and `\fillme`), `ISSUE_STATUSES`, and `MAINFONT` / `SANSFONT` / `MONOFONT` for Pandoc. `tooling/latex/symbol-fallback.tex` ships so Markdown PDFs keep symbol glyphs. `texcheck.py` treats list options (`enumitem`) and table colour and span macros as layout, not words. | v0.2.0, 03/10/2026. |
| D44 | **Releases that move author work ship a migration.** v0.2.0's `migrations/v0.2.0-business-families.sh` moves anything an author created under v0.1.0's family folders to the D39 families (`proposals`→`business`, `contracts`→`legal`, `policies`→`business` (or `msp-scp` when selected), `correspondence`→`email`, `finance`→`accounting`, `marketing`→`social-media`), only where the destination is free, idempotently, never deleting, and reports what it left. A second v0.2.0 migration, `migrations/v0.2.0-project-settings.sh` (every variant), carries brief values the author edited by hand under v0.1.0 into `00-project.md` `## Brief` only where the value is unambiguous, lists conflicting or stale seed lines for the author, never overwrites a value the author re-answered during the update itself, and edits nothing else. In business, `correspondence/client-docs/<slug>/` moves to `email/client-emails/<slug>/`. Migration scripts live in the template repository's root `migrations/` and run through `_migrations`. | v0.2.0, 03/10/2026. |
| D45 | **Three-stage comparison of every section.** The ledger records how each section moved from its original to its final text, and `make compare` prints that record. **The record.** An entry written from v0.3.0 carries `format: 2` and two optional sections between `## AI original` and `## Author final`: `## Author original` (the text the loop started from when the AI did not draft it, written by the first skill to revise an author-drafted section; empty for AI-drafted entries) and `## Revisions`, an ordered chain of full-text states, oldest first, each opened by one marker comment `<!-- revision N · <kind> · DD/MM/YYYY · <skill> (<strength>) · rows a–b -->`. The kind names who made the change from the state before it, in D38's words: `ai` (an AI suggestion the author accepted: `improve-section` proposals, `adapt-section` alternatives, accepted proofreading corrections), `author-note` (the AI applying the author's own notes or flag answers) or `author` (the author's hand-edits, which every skill finds by comparing the draft with the last recorded state before it changes anything). The difference between the last state and the Author final is the author's. Every skill that changes a draft's words appends a revision; a re-promotion or a correction after promotion first moves the previous Author final into the chain; a redraft moves the live chain, with a promoted section's Author final, into the superseded-original comment, after which the section is a draft again (`promoted` and `change_ratio` cleared, its `provenance.md` row removed); two states are equal when they match word for word and paragraph for paragraph, comments aside, and a state equal to the one before it is never written. A promoted section that has changed since without being promoted again is reopened (a revision reads `promoted <its promoted date>`, or is dated after it): its Author final is the previous final, so its chain, `make compare` and `learn-voice` stop at its last revision until it is promoted again. Entries are never backfilled: an entry without `format: 2` predates the record and is shown as such. **The output.** `make compare [UNIT=…] [SECTION=…]` (every variant) writes `build/compare/<unit>.pdf`, or `build/compare/<unit>--<section>.pdf` with `SECTION=`, so a one-section comparison never overwrites the unit's: a cover with the key and the unit's disclosure table, then, for each section in the brief's plan order, a portrait **redline** (the final text, each added word marked by who added it, each removed word struck by who removed it) and a landscape **three-column** page (Original · AI edit · Final, aligned by paragraph; the AI edit is the state after the last `ai` or `author-note` revision). The comparison follows words, not passages: a passage a step moved shows as removed where it stood and added where it went, both marked by the step that moved it. Each actor has a colour-blind-safe Okabe–Ito colour and its own line style, so the page reads in greyscale: the AI blue, dashed underline and cross-out; `author-note` green, dotted underline and double strike; the author vermillion, solid underline and single strike; a change in an entry written before the record grey, wavy underline and wavy strike, shown but never assigned. `tooling/compare.py` (stdlib; imports `provenance.py`'s reader) builds a Pandoc AST through the house Lua filter with `tooling/compare.yaml` and `tooling/latex/compare.tex`; the Makefile runs XeLaTeX twice with the missing-character report; `FORMAT=tex` stops at LaTeX, which is what CI proves. Comparison output is never issued, committed or synced. No migration: nothing moves, every addition is optional, and a v0.2.0 entry renders with the stages it has. | v0.3.0, 04/10/2026. |
| D21 | **References** (`INCLUDE_REFERENCES`, default on for theology): SQLite master `tooling/references.db` → `export_refs.py` → CSL-JSON → Pandoc `--citeproc` + `harvard.csl`; citation keys `authorYYYY[a-c]`, lower-case, never renamed. The `.db` is never shipped (binary); `make init` builds it from `schema.sql` + `seed-refs.sql`. | AT pipeline; drop AT's vestigial `appearances` table. |
| D22 | **Supportive proofreading is the default for every author**: a report, not a rewrite; say what and where; offer the correction; group recurring items. No health question, no diagnosis in any file. | Cross-check row 28. |
| D23 | **Locale.** en_GB; single quotation marks; DD/MM/YYYY in prose; `DD-MM-YYYY` in filenames; ISO 8601 only in database columns; 24-hour time; write "Section 3.2", never the section sign. | |
| D24 | **One sentence per line in `src/` artefacts only**, applied when a paragraph is edited, never by mass reflow. Governance files keep the house hard wrap. | Cross-check Section 5.5. |
| D25 | **300-line cap** on every instructional `.md` (docs, workflows, `.claude/**`, pairs, skills, mode files). Oversized files split into `SCREAMING-SNAKE-CASE.md` sub-docs behind a thin index. `src/` artefacts and `README.md` are exempt. | |
| D26 | **Workflow numbering is frozen and append-only**, unique within a layer across variants (gaps tolerated). Author procedures live in `workflows/local/NN-name/` (own numbering); a same-slug local workflow overrides the template's. `run-workflow` resolves local first. | Cross-check Section 5.7. |
| D27 | **Guides split `docs/reference/` (template-owned) and `docs/project/` (author-owned, pair-only).** A same-named project guide overrides the reference guide. | Cross-check Section 5.6. |
| D28 | **Never self-edit.** No skill rewrites a skill, standard, rules file or `CLAUDE.md` without the author's explicit instruction; a standards change is always author-confirmed. Drafts and promoted files are never overwritten without confirmation. | |
| D29 | **Hand off, never compact**: `autoCompactEnabled: false` + `PreCompact` hook (auto → exit 2; manual → warn, exit 0). The hook cites `.claude/rules/syntek-author/07-session-boundaries.md`. Handoffs go to `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`. | |
| D30 | **Personal data never enters `template/`**: no author names, health data, income, clients, prices, testimony, named individuals, student numbers, absolute paths or source-repository names. Enforced by `scrub.sh`. Example content uses invented people and places only. | |

---

## 2. Copier questions

House style: UPPER_SNAKE keys, `>-` help written to the person answering, validators as `<: if bad :>message<: endif :>`, every variant-dependent question gated with `when:`.

| Key | Type | Shown when | Default | Help / notes |
|---|---|---|---|---|
| `PROJECT_NAME` | str | always | — | Human name of the project, e.g. a working title or `Client Documents`. |
| `PROJECT_SLUG` | str | always | kebab of `PROJECT_NAME` | Validator: `^[a-z][a-z0-9-]+$`. |
| `PROJECT_DESCRIPTION` | str | always | — | The brief: thesis (theology), premise (fiction) or purpose (business). Keep SB's "a tagline is not a brief" validator (≥ 40 characters). |
| `AUTHOR_NAME` | str | always | — | The exact name as printed on the cover or document, full stops included. Never change its form later. |
| `AUTHOR_FIRST_NAME` | str | always | first word of `AUTHOR_NAME` | How skills address the author in chat. |
| `DATE` | str | always | — | DD/MM/YYYY validator. |
| `TIMEZONE` | str | always | `Europe/London` | |
| `DOC_TYPE` | str | always | **none** | `choices: [theology, fiction, business]`. Always asked. |
| `WORKING_TITLE` | str | books | `PROJECT_NAME` | |
| `SUBTITLE` | str | books | `""` | |
| `AUDIENCE` | str | always | theology `lay`; fiction `adult`; business `client` | Dynamic choices: theology `lay · ministry-leaders · academic`; fiction `middle-grade · young-adult · adult`; business `client · staff · board · public`. Drives `comprehension`. |
| `READER_TEST` | str | always | per doc type | One sentence naming the lowest-common-denominator reader, e.g. "a church leader reading on a Tuesday evening". |
| `BIBLE_TRANSLATION` | str | theology | `niv2011` | The citation key of the default translation. |
| `FICTION_GENRE` | str | fiction | `fantasy` | `choices: [fantasy, science-fiction, historical, literary, crime, romance, other]`. |
| `INCLUDE_WORLDBUILDING` | bool | fiction | `DOC_TYPE == 'fiction' and FICTION_GENRE in ['fantasy', 'science-fiction']` | Creatures, cultures and quests. |
| `INCLUDE_CONLANG` | bool | fiction and `INCLUDE_WORLDBUILDING` | `INCLUDE_WORLDBUILDING` | Constructed languages, writing systems, pronunciation. |
| `TRADING_NAME` | str | business | `PROJECT_NAME` | |
| `JURISDICTION` | str | business | `England and Wales` | |
| `CURRENCY` | str | business | `£` | |
| `BUSINESS_VOICE_PERSON` | str | business | `singular` | `choices: [singular, plural]` ("I" or "we"). |
| `BUSINESS_FAMILIES` | str, multi-select | business | `[business, legal, email, accounting, social-media]` | D39. `business` is required (validator). `msp-scp` is opt-in. |
| `INCLUDE_DRIVE_SYNC` | bool | business | `false` | Google Drive push/pull GitHub workflows. |
| `INCLUDE_PROPOSAL` | bool | books | `true` | Theology: book proposal and endorsements. Fiction: query package and submissions. |
| `INCLUDE_REFERENCES` | bool | always | `DOC_TYPE == 'theology'` | The SQLite citation pipeline. |
| `INCLUDE_SENSITIVE_CONTENT` | bool | books | `false` | Sensitive-content standard, `sensitivity-pass`, testimony handling. |
| `SEED_EXAMPLES` | bool | always | `true` | One worked example unit (and, with the conlang, one example language). Adoption passes `false`. |
| `MODEL_MECHANICAL` | str | always | business `opus`, otherwise `sonnet` | `choices: [sonnet, opus]`. Never Haiku. |
| `CONTENT_LAYER` | computed (`when: false`) | — | `library` if business else `manuscript` | |
| `UNIT_NOUN` | computed (`when: false`) | — | `document` if business else `chapter` | |

Every gate expression includes its `DOC_TYPE` test, so a default computed for a hidden question can never open a gate.

**Token discipline.** Variant tokens (`DOC_TYPE`, `CONTENT_LAYER`, `UNIT_NOUN`, `FICTION_GENRE`, `INCLUDE_*`, `AUDIENCE`, `READER_TEST`, and every other variant answer) and `<: if … :>` blocks may appear only in the **spine set**:

- the root spine: `.claude/CLAUDE.md`, `.claude/rules/syntek-author/*.md`, root `CONTEXT.md`, `README.md`, `Makefile`, `tooling/defaults.yaml`, `.claude/settings.json`;
- every seed (Section 3.1) and every seed-once example (Section 3.2), because they render once and are never merged;
- **index files**: any `CONTEXT.md` or `CLAUDE.md` whose folder contains gated children. Such a file wraps each gated row, tree line or cross-reference in a `<: if <gate> :>…<: endif :>` block using exactly the gate in Section 3.5, so no shipped file ever names a path that is absent from its variant.

Every other shipped file is **shared** and byte-identical in every variant that ships it; variant differences live in gated files and mode files instead.
Identity and locale tokens (`PROJECT_NAME`, `AUTHOR_NAME`, `AUTHOR_FIRST_NAME`, `DATE`, `TIMEZONE`, `PROJECT_SLUG`) may appear anywhere.
Shared files elsewhere say "the content layer (see `.claude/rules/syntek-author/01-layout-and-routing.md`)"; the mode file names the concrete path.
Never put a token inside `_…_` emphasis (Prettier mangles it).

---

## 3. Ownership classes and gating

### 3.1 Seed-if-missing (`_skip_if_exists`)

`.claude/rules/syntek-author/00-project.md` (D40) · `tooling/project.mk` (D43) · `README.md` · `CONTEXT.md` · `.gitignore` · `.mcp.json` (`{"mcpServers": {}}`) · `.claude/CLAUDE.md` · `.claude/CONTEXT.md` · `.claude/MEMORY.md` · `.claude/settings.json` · `.claude/skills/CONTEXT.md` · `.claude/skills/CLAUDE.md` · `.claude/hooks/CONTEXT.md` · `.claude/hooks/CLAUDE.md` ·
`standards/style/style-sheet.md` · `standards/style/voice-notes.md` · `standards/style/terminology.md` · `standards/style/ledger/provenance.md` ·
`planning/src/outline.md` ·
fiction: `planning/src/causality.md` · `planning/src/timeline.md` · `planning/src/continuity.md` · `world/src/names-register.md` · worldbuilding: `world/src/history/eras.md` ·
business: `planning/src/document-register.md` · `planning/src/review-schedule.md` · `planning/src/precedence.md` · `standards/brand/disclaimers.md` · `standards/brand/brand-voice.md` · `standards/brand/brand-guide.md` (the author fills them; their house principles are writing rules, not entries) ·
author-filled index pairs: `planning/src/maps/CONTEXT.md` (wayfinder appends to it) and the `CONTEXT.md` + `CLAUDE.md` of every `docs/project/` and `workflows/local/` (the author adds rows) ·
references: `tooling/seed-refs.sql` (header only, no rows) ·
books: `typeset/src/page-design.md` · `typeset/src/book.tex` ·
proposal (books + `INCLUDE_PROPOSAL`): `endorsements/tracker.md` and `submissions/tracker.md`, `sample/sample-index.md`, the eight theology `book-proposal/` section stubs and the four fiction query-package files (`query-letter.md`, `synopsis-short.md`, `synopsis-long.md`, `comp-titles.md`) ·
worldbuilding: `world/src/history/eras.md` ·
fiction: `research/src/permissions.md`.

Seed files ship **empty of entries**: headings, writing rules and SB's "cited stub" banner only. Their emptiness is audited, not trusted.

### 3.2 Seed-once examples (copy only; stay deleted)

`<: if _copier_operation == 'update' or not SEED_EXAMPLES :>…<: endif :>`, one line per path:

- books: `manuscript/src/01-example-chapter` and `planning/src/units/01-example-chapter.md`; theology adds `planning/src/arguments/01-example-chapter.md`. The theology example argues an **invented thesis unrelated to any source book** (never a source book's method or engine).
- business: `library/src/business/drafts/example-proposal` (folder) and `planning/src/units/example-proposal.md`.
- books: `standards/style/ledger/01-example-chapter--the-turn.md` (AI-drafted) and `standards/style/ledger/01-example-chapter--opening.md` (author-drafted, promoted, `Author final` filled, so the example can be practised through V2; from v0.3.0 it also carries an invented `## Author original` and one recorded `improve-section` revision, so `make compare UNIT=01-example-chapter` shows all three stages, D45), and business: `standards/style/ledger/example-proposal--scope.md` — the example drafts' ledger entries (AI original = the example draft's text), so the example `ledger:` pointers resolve and `learn-voice` has something to practise on.
- worldbuilding: `world/src/peoples/example-people.md` and `world/src/cultures/example-culture.md` (they ship with worldbuilding, conlang or not).
- conlang: `world/src/languages/example-proto` and `world/src/languages/example-tongue` (a proto-language with a handful of roots and affixes, and one daughter of about a dozen entries including a loan and a deliberate irregular, plus the glyphs needed to write them) and one `research/src/setting/example-model-*.md` note per real-world inspiration — they double as the tooling smoke-test fixture.

### 3.3 Author-owned, pair-only folders

The template ships only `CONTEXT.md` + `CLAUDE.md` in: every `docs/project/`, every `workflows/local/`, `standards/style/samples/`, `standards/style/ledger/` (plus the seeded `provenance.md`), `planning/src/units/`, `planning/src/maps/`, `planning/src/reviews/`, theology `planning/src/arguments/`, fiction `planning/src/arcs/`, `planning/src/quests/` (worldbuilding), every `world/src/*/` folder, every `research/src/*/` folder, business `planning/src/approvals/`, `handoffs/`, `learning/`, `assets/`.

### 3.4 Template-owned

Everything else: every other governance pair, `docs/reference/**`, `workflows/NN-*/**`, `.claude/rules/**`, `.claude/hooks/*.sh`, `.claude/skills/<skill>/**`, `standards/{method,risk,verification,referencing,brand}/**` (except seeds), `tooling/**` (except seeds), `Makefile`, nested `.gitignore` files, `.github/**` (business, Drive sync).

### 3.5 Gating table

| Path | Ships when |
|---|---|
| `manuscript/` | `DOC_TYPE != 'business'` |
| `library/` | `DOC_TYPE == 'business'` |
| `proposal/` | `DOC_TYPE != 'business' and INCLUDE_PROPOSAL` |
| `world/` | `DOC_TYPE == 'fiction'` |
| `world/src/creatures`, `world/src/cultures`, `world/src/peoples`, `world/src/history`, `planning/src/quests`, worldbuilding workflows and guides | fiction and `INCLUDE_WORLDBUILDING` |
| `world/src/languages`, conlang workflows and guides, `tooling/lexicon.py`, `tooling/script.py`, `tooling/font.py`, `tooling/conlang_common.py` (the shared code-point and TOML helpers), `tooling/data/` (core concepts), `typeset/docs/reference/conlang-in-print.md`, the example language family and its `research/src/setting/example-model-*.md` notes | fiction and `INCLUDE_CONLANG` |
| `typeset/`, skill `typeset`, `tooling/latex/housebook.cls` | `DOC_TYPE != 'business'` |
| `tooling/texcheck.py` | always (books: unit fidelity; business: section fidelity, D36) |
| `tooling/pandoc/house.lua` | always (business uses it for Markdown proofs of correspondence) |
| `planning/src/arguments`, theology workflows and guides | `DOC_TYPE == 'theology'` |
| `planning/src/{causality,timeline,continuity}.md`, `planning/src/arcs` | `DOC_TYPE == 'fiction'` |
| `planning/src/{document-register,review-schedule,precedence}.md`, `planning/src/approvals`, business workflows | `DOC_TYPE == 'business'` |
| `standards/referencing`, `tooling/{schema.sql,seed-refs.sql,export_refs.py,harvard.csl}`, skill `add-reference` | `INCLUDE_REFERENCES` |
| `standards/brand`, `tooling/latex/house-preamble.tex`, `tooling/latex/skeleton.tex` | business |
| `library/src/<family>/`, `library/docs/reference/<family>-standards.md` (and its sub-documents, e.g. `EMAIL-ANATOMY-AND-NAMING.md`, `MSP-SCP-POLICY-SUITE.md`), skill `<family>-documents`, the family's create workflow | business and `'<family>' in BUSINESS_FAMILIES` (`business` always) |
| `tooling/latex/` pair | always (index pair: its rows are gated per file) |
| `standards/risk/sensitive-content.md`, `research/src/testimony`, research workflow 05, skill `sensitivity-pass` | books and `INCLUDE_SENSITIVE_CONTENT` |
| `.github/` | business and `INCLUDE_DRIVE_SYNC` |
| `tooling/book.latex` | books |
| Variant-only skills and their mode files | Section 5 |

The mode-file block of `_exclude` (three lines per moded skill and per moded standards folder) is **generated** by `.github/scripts/gen-mode-excludes.sh` between the markers `# BEGIN generated mode excludes` and `# END generated mode excludes`; `--check` fails on drift.

---

## 4. The generated tree

### 4.1 Root and `.claude/`

```text
<project>/
├── .copier-answers.syntek-author.yml   ← Copier answers (do not hand-edit)
├── README.md            ← seed: what this project is, how to build, how to update
├── CONTEXT.md           ← seed: repository orientation, imported by .claude/CLAUDE.md
├── Makefile             ← template-owned build entry point
├── .gitignore           ← seed
├── .mcp.json            ← seed: {"mcpServers": {}}
├── .claude/
│   ├── CLAUDE.md        ← seed: Section 1 Project brief (from answers) + where the rules live
│   ├── CONTEXT.md       ← seed
│   ├── MEMORY.md        ← seed: six empty H2s
│   ├── settings.json    ← seed: model opus, autoCompactEnabled false, PreCompact hook, denies, allow-list
│   ├── hooks/           ← pair (seed) + pre-compact-handoff.sh (template-owned)
│   ├── rules/syntek-author/   ← template-owned rules, loaded at launch; NO pair here
│   └── skills/          ← pair (seed) + one folder per skill (template-owned)
├── handoffs/ · learning/ · assets/     ← author-owned, pair-only
├── standards/ · tooling/               ← supporting layers (flat)
└── planning/ · research/ · manuscript|library/ · typeset/ · proposal/ · world/   ← production layers
```

**`.claude/rules/syntek-author/`** (each ≤ 300 lines, no `paths` frontmatter, each opening with a one-line note that it is template-owned and updated by `copier update`, and that project-specific rules belong in `.claude/CLAUDE.md`):

| File | Content |
|---|---|
| `00-project.md` | **Seed, project-owned (D40).** Brief, paths, memory-heading map, workflow aliases and overrides; outranks the other rules files. |
| `01-layout-and-routing.md` | Layer table (Layer \| Kind \| Purpose) for this variant; sublayer table; pair rule and its exceptions (`build/`, `.git/`, `.claude/rules/`, the inside of each skill folder, each `drafts/` and each `typeset/src/units/.base/`, which carry only `README.md`); routing frontmatter; ownership classes; read order. |
| `02-skills.md` | Skill tables by family (Skill \| What it does \| Mode): shared writing, variant, working practice, options. The mode-file contract. "Skills only — no commands, no agents." |
| `03-authorship.md` | The authoring constitution: who decides what; the loop (D10); section size; never fabricate (quotations, page numbers, citations, original-language definitions, scripture references, statutes, prices, historical claims); the two flags (D13); prefer suggested changes to rewrites; preserve deliberate oddities; theology's six categories never silently collapsed; fiction contradictions reported, not repaired; provenance (D12). |
| `04-build-pipeline.md` | Diagram and `make` targets for this variant. |
| `05-model-allocation.md` | AT's table: Opus for everything substantive; `<%MODEL_MECHANICAL%>` for renames, ticks and builds; never Haiku; fallback "never lower". |
| `06-global-rules.md` | Locale (D23); route, do not restate; never self-edit (D28); never overwrite; one sentence per line (D24); line cap (D25); supportive proofreading (D22); design work opens with a grilling pass. |
| `07-session-boundaries.md` | Hand off, never compact (D29). The hook cites this file. |
| `08-naming-and-memory.md` | Naming conventions; what goes in `MEMORY.md` against a folder file; the memory gate; supersede, never delete. |

**`.claude/CLAUDE.md` (seed)**: metadata header; `@../CONTEXT.md`; read-order blockquote; `## 1. Project` (title, subtitle, brief, audience, reader test, near-term goal placeholder, author name in its exact form); `## 2. Where the rules live` (the rules folder is loaded automatically; template-owned; never edit — put overrides here); `## 3. Project-specific rules` (empty, with a one-line instruction).

**`.claude/settings.json` (seed)**: `"model": "opus"`, `"autoCompactEnabled": false`, `PreCompact` hooks for `auto` and `manual` calling the hook with SB's self-locating `bash -c` form; `permissions.deny`: `AskUserQuestion`, `Edit(**/*.pdf)`, `Edit(build/**)`, and for books `Edit(typeset/src/units/.base/**)` (Pandoc bases are never hand-edited); `permissions.allow`: `Bash(make *)`, `Bash(python3 tooling/*.py *)`, `WebSearch`, `WebFetch`, plus `Bash(sqlite3 tooling/references.db *)` when references are on and `Bash(uv run tooling/font.py *)` with the conlang. No owner-specific keys.

### 4.2 `standards/` (supporting, flat; template-owned unless seeded)

```text
standards/
├── style/          ← style-sheet.md · voice-notes.md · terminology.md (seeds) · samples/ · ledger/ (+ provenance.md seed)
├── method/         ← method.md (shared) + THEOLOGY.md | FICTION.md | BUSINESS.md
├── risk/           ← risk.md (shared) + mode file; sensitive-content.md (option)
├── verification/   ← verification.md (gates V1…Vn, shared) + mode file
├── referencing/    ← option: Harvard (Cite Them Right), keys, the pipeline
└── brand/          ← business: brand-voice.md, brand-guide.md, disclaimers.md (seed)
```

- **Theology `method/THEOLOGY.md`**: the six claim categories; contested readings named in the body; concede before rebut (concession positioned ahead of the response); steelman recognition test; at least one objection may be left standing; bias declared, not neutralised. Nothing from any source book's own thesis framework.
- **Fiction `method/FICTION.md`**: the story engine: causality ("because / therefore", never "and then"); want against need; scene goal, conflict, outcome; setup and payoff; POV discipline; the story bible is the source of truth.
- **Business `method/BUSINESS.md`**: drafting principles (BD): specificity over superlatives; shorten the writing, never the obligation; stated precedence; defined terms defined once.
- **`verification/verification.md`**: numbered gates V1…Vn for each unit status transition (`outlined → draft`, `draft → structural-review`, … `line-edit → final`), each naming the skill that runs it; the per-unit record lives in the unit brief's frontmatter `verified:` map. Mode files add the variant gates (theology: `argument-audit`, `category-check`, `tradition-check`, `steelman` at structural review; fiction: `continuity`, `causality` at structural review, `character-voice`, `pacing` at line edit; business: `clause-consistency`, `obligation-check` at fact check, `tone` at line edit).
- **Style seeds**: `style-sheet.md` (mechanics as data: spelling list, punctuation, numbers, dates, capitalisation; variant examples belong in the mode files of `spelling` and `grammar`, not here); `voice-notes.md` (AT's provenance caveat verbatim: a voice guide with borrowed examples is a hypothesis; sections for marks, registers, do and don't, and a `## Learned` section that `learn-voice` appends to after the author approves); `terminology.md` (term · meaning · use · avoid).

### 4.3 `tooling/` and `Makefile`

| Path | Gate | Purpose |
|---|---|---|
| `Makefile` (root) | always | `help` (self-documenting), `init`, `refs`, `dump` (references), `docx`, `pdf`, `epub` (books), `book` (books), `tex SCOPE=` (Pandoc base into `typeset/src/units/.base/`), `tex-check`, `print` (XeLaTeX on `typeset/src/book.tex`, twice) (books), `flags`, `lint` (sentences per line, en_US spellings, em dashes in business copy, conlang density in fiction), `provenance`, `compare UNIT= SECTION= FORMAT=tex` (D45), `lexicon`, `derive`, `coverage`, `family`, `glossary`, `font`, `script-sample` (conlang), `clean`. `SCOPE=` selects files; `SRC` excludes `CONTEXT.md`, `CLAUDE.md`, `README.md` and `*/drafts/*`. The rule that creates `build/` also writes `build/.gitignore` containing `*`. Business: `pdf FILE=…` / `docx FILE=…` render LaTeX twice for `\ref`. |
| `tooling/defaults.yaml` | always | Pandoc metadata: title, subtitle, author, lang `en-GB`. |
| `tooling/project.mk` | always (seed, D43) | The project's build settings: `LOGO_DIRS`, `FLAG_EXTRA_RE`, `MAINFONT` / `SANSFONT` / `MONOFONT`; business also `BRAND_DIRS`, `DOCX_CONVERTER`, `ISSUE_STATUSES`. |
| `tooling/latex/symbol-fallback.tex` | always | Keeps symbol glyphs in Pandoc PDFs (D43). |
| `tooling/book.latex` | books | AT's widow, orphan and footnote penalties; fix the stale first line. |
| `tooling/export_refs.py`, `schema.sql`, `seed-refs.sql`, `harvard.csl` | references | AT pipeline; `harvard.csl` keeps its `<info>` licence block. |
| `tooling/latex/house-preamble.tex`, `tooling/latex/skeleton.tex` | business | BD house preamble (`\dnote`, clause lists, `\ctitle`, `\fillme`, `\ins`/`\del`/`\cmt`) with no client data. |
| `tooling/provenance.py` | always | Reads the ledger (including the D45 `## Author original` and `## Revisions`); prints the disclosure table. |
| `tooling/compare.py` | always | D45: reads the ledger through `provenance.py`, attributes each word along the revision chain, orders sections by the brief, and writes the comparison as a Pandoc AST for `make compare`; `--self-test` needs no TeX. |
| `tooling/compare.yaml` | always | Pandoc defaults for the comparison PDF (article class, its own geometry), so `-V` never fights `defaults.yaml`. |
| `tooling/latex/compare.tex` | always | The comparison's header include: `xcolor`, `ulem`, `paracol`, `array`, the namespaced attribution macros, the key, and a true landscape page size (pdflscape cannot turn paracol's pages). Its macros never enter a document, so `texcheck.py` never learns them. |
| `tooling/lexicon.py` | conlang | `check <lang>` (inventory size warning outside 20–35; romanisation one spelling per sound unless listed in `[romanisation.exceptions]`; apostrophe and diacritic density warnings; every headword and loanword parses under the phonotactics; stress consistent; roots referenced exist; duplicates; missing fields), `derive <lang>` (daughters: apply `sound-changes.toml` in order to each parent form — only the rules after `entered_after` for loans and late coinages — and report every entry whose IPA differs from the derivation unless `irregular = true`; list parent words with no reflex and their derived candidates), `surface <lang> <ipa>` (allophone rules + stress → phonetic IPA), `coverage <lang>` (core concepts and pronouns without a word), `glossary <lang>` (Markdown glossary and pronunciation guide into `build/`), `names` (cross-check `names-register.md` against each source language's phonotactics), `family` (print every language family tree with kind, parent and each branch's real-world inspirations; warn on any language with none), `density <file.md>` (restraint check: paragraphs with more than three unglossed conlang words). |
| `tooling/script.py` | conlang | `transliterate <lang> "text"` (greedy longest match over `glyphs.toml`; `--pua` emits the font's Private Use Area characters), `render <lang> "text" --out build/x.svg` (composes glyph SVGs honouring direction). |
| `tooling/font.py` | conlang | PEP 723 (`fonttools`), run via `uv run`: `build <lang>` → `build/fonts/<lang>.otf`; `assign <lang>` prints code-point pins; `check <lang>` validates SVGs (filled paths, inside the em box). |
| `tooling/data/core-concepts.toml` | conlang | About 200 core concepts (Swadesh-style, written fresh for this template, not copied from any published list) plus the pronoun grid. |
| `tooling/pandoc/house.lua` | always | Maps semantic Markdown to house macros: `::: epigraph`, `::: scene-break` (or a lone `* * *`), `[word]{.conlang lang=<slug>}` (romanised, italic) and `[word]{.conlang-native lang=<slug>}` (native script through `script.py transliterate --pua` via `pandoc.pipe`), `[text]{.smallcaps}`. |
| `tooling/latex/housebook.cls` | books | House book class (named so it never shadows LaTeX's standard `book` class): trim size, fonts, chapter openers, epigraph, scene break, drop cap, footnote style, `\conlang` and `\conlangnative` (loads `build/fonts/<lang>.otf` when present, falls back to romanised italic with a warning). Page-design choices are class options recorded in `typeset/src/page-design.md`. |
| `tooling/texcheck.py` | always | Fidelity check: strip LaTeX to words; compare with `pandoc -t plain` of the Markdown source; report every insertion, deletion or change with line numbers; exit 1 on any difference. Books: unit mode (`make tex-check`). Business: section mode between `% section:` / `% end section:` markers (`make section-check FILE=… SECTION=… DRAFT=…`, D36). |
| `.gitignore` files | — | `world/src/.gitignore` (`languages/*/audio/`) — template-owned and shipped with every fiction project, so no option change removes it and generated audio can never be committed. |

### 4.4 Production layers

Every production layer: `<layer>/{CONTEXT.md, CLAUDE.md}`, `docs/{pair}`, `docs/reference/{pair, guides…}`, `docs/project/{pair}`, `src/{pair, …}`, `workflows/{pair}` (index table "You want to… | Procedure"), `workflows/local/{pair}`, and `workflows/NN-name/{CONTEXT.md, CLAUDE.md, STEPS.md, CHECKLIST.md}`.

**Guides** follow AT's format (54–82 lines): routing frontmatter (`type: guide`, `skills: […]`, `model: opus`) → `# Title — gloss` → metadata header → `**What it is.**` → 2–5 topic H2s → `## How we apply it here` → `## Who implements it` → `## Governing standard`.

#### `manuscript/` (theology, fiction) and `library/` (business)

`src/`: books `NN-kebab-title/{NN-kebab-title.md, drafts/README.md}`, with `<!-- section: <slug> -->` markers in the unit file anchoring each promoted section in plan order. Business: BD families `library/src/<family>/{templates/, client-docs/<client-slug>/, drafts/}` with the families chosen in `BUSINESS_FAMILIES` (D39: `business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`), each with its pair, `templates/`, `client-docs/` and `drafts/`; a client's facts live once, in `library/src/business/client-docs/<client-slug>/CONTEXT.md` under `## Facts` (or where `00-project.md` says) and the house LaTeX deliverables.

| # | Workflow | Variants | Skill(s) |
|---|---|---|---|
| 01 | `01-draft-a-section` | all | `draft-section` |
| 02 | `02-adapt-a-draft` | all | `adapt-section` |
| 03 | `03-improve-your-draft` | all | `improve-section` |
| 04 | `04-promote-a-section` | all | `promote-section` |
| 05 | `05-review-a-chapter` (books) / `05-review-a-document` (business) | all | `structure-review` → `fact-check` → `comprehension` → `flow` → `grammar` → `spelling`, plus the variant gates from `standards/verification/` |
| 06 | `06-build-a-proof` | all | `build` |
| 07 | `07-learn-from-your-edits` | all | `learn-voice` |
| 08 | `08-ingest-an-existing-document` | business | `adapt-section` (BD's convert-to-Markdown) |
| 10 | `10-steelman-the-objections` | theology | `steelman` |
| 10 | `10-create-a-business-document` | business | `business-documents` |
| 11 | `11-create-a-legal-document` | business + `legal` | `legal-documents` |
| 12 | `12-write-an-email` | business + `email` | `email-documents` |
| 13 | `13-create-an-accounting-document` | business + `accounting` | `accounting-documents` |
| 14 | `14-create-a-social-media-document` | business + `social-media` | `social-media-documents` |
| 15 | `15-create-an-msp-scp-document` | business + `msp-scp` | `msp-scp-documents` |

Guides (`docs/reference/`): `section-anatomy.md`, `drafting-with-ai.md` (the loop, who decides, provenance), `the-status-ladders.md`; theology `main-text-and-footnotes.md`; fiction `scene-craft.md`; business `document-anatomy.md`, `latex-deliverables.md`, `versioning-and-the-register.md`.

#### `planning/` (all)

`src/`: `outline.md` (seed), `units/` (unit briefs), `maps/` (wayfinder), `reviews/` (advice only); theology `arguments/`; fiction `causality.md`, `timeline.md`, `continuity.md`, `arcs/`, `quests/` (worldbuilding); business `document-register.md`, `review-schedule.md`, `precedence.md`, `approvals/`.

| # | Workflow | Variants | Skill(s) |
|---|---|---|---|
| 01 | `01-plan-a-unit` | all | `grill-with-docs` |
| 02 | `02-map-the-argument` | theology | `argument-audit`, `category-check` |
| 03 | `03-chart-the-causality` | fiction | `causality` |
| 04 | `04-chart-a-character-arc` | fiction | `chart-character-arc` |
| 05 | `05-design-a-quest` | fiction + worldbuilding | `design-quest` |
| 06 | `06-run-a-review-cycle` | business | `structure-review` |
| 07 | `07-record-an-approval` | business | — |
| 08 | `08-update-the-register` | business | — |
| 09 | `09-review-the-whole-work` | all | `structure-review` (whole-work lenses) |

Guides: `unit-briefs.md`, `reviews-are-advice.md`, `decision-maps.md`; theology `argument-maps.md`; fiction `causality-chains.md`, `character-arcs.md`; worldbuilding `quest-design.md`; business `the-document-register.md`.

#### `research/` (all)

`src/`: `sources/`, `evidence/`, `notes/` (question-led notes from the `research` skill); theology `contested-readings/`; fiction `setting/`, `permissions.md` (seed-if-missing; epigraphs and quotations); sensitive `testimony/`.

| # | Workflow | Variants | Skill(s) |
|---|---|---|---|
| 01 | `01-ingest-a-source` | all | `research` |
| 02 | `02-verify-a-claim` | all | `fact-check` |
| 03 | `03-map-a-contested-reading` | theology | `tradition-check` |
| 05 | `05-handle-testimony-safely` | books + sensitive | `sensitivity-pass` |

Guides: `ingesting-sources.md`, `vetting-evidence.md`; theology `contested-readings.md`; fiction `real-world-detail.md`; sensitive `handling-testimony.md`.

#### `proposal/` (books + `INCLUDE_PROPOSAL`)

`src/`: theology `book-proposal/`, `endorsements/tracker.md`, `sample/sample-index.md`; fiction `query-letter.md`, `synopsis-short.md`, `synopsis-long.md`, `comp-titles.md`, `submissions/tracker.md` (status `to query · queried · requested · passed · offer · withdrawn · lapsed`), `sample/sample-index.md`. Ship trackers and indexes as empty seeds (`_skip_if_exists`).

| # | Workflow | Skill(s) |
|---|---|---|
| 01 | `01-assemble-the-proposal` | `build` |
| 02 | `02-approach-a-reader` (endorser or agent) | `approach-a-reader` |
| 03 | `03-update-the-tracker` | — |

Guides: theology `book-proposal-anatomy.md`; fiction `query-package-anatomy.md`; both `comp-titles.md`, `approaching-readers.md`.

#### `typeset/` (theology, fiction)

`src/`: `page-design.md` (seed: trim size, fonts, chapter opener, scene-break glyph, footnote style — each an `AUTHOR TO CONFIRM` until chosen), `book.tex` (seed: master file using `tooling/latex/housebook.cls`, `\input`s front matter, units in order, back matter), `frontmatter/` and `backmatter/` (pairs), `units/` (pair; styled `NN-kebab-title.tex` files) and `units/.base/` (Pandoc bases, never hand-edited; carries only a `README.md` like `drafts/`).

| # | Workflow | Gate | Skill(s) |
|---|---|---|---|
| 01 | `01-design-the-page` | books | `typeset` (records the author's choices in `page-design.md`) |
| 02 | `02-typeset-a-chapter` | books | `typeset` → `make tex-check` → `make print` |
| 03 | `03-retypeset-after-edits` | books | `typeset` (three-way carry-forward) → `make tex-check` |
| 04 | `04-typeset-the-book` | books | `typeset`, `build` |

Guides: `the-typesetting-pipeline.md`, `the-house-class.md` (every macro and when to use it), `the-fidelity-check.md` (the author's words are never retyped), `semantic-markdown.md` (what the author may mark in Markdown and what each becomes); conlang `conlang-in-print.md`.

#### `world/` (fiction)

`src/`: `names-register.md` (seed), `characters/`, `places/`; worldbuilding `peoples/` (races and species: physiology that affects speech, lifespan, numbers, homelands), `cultures/`, `history/` (`eras.md` seed + one file per major event: migrations, conquests, contact), `creatures/`; conlang `languages/` (generated audio is ignored by the fiction-wide `world/src/.gitignore`, Section 4.3). Each language links to its culture (`language.toml` `culture`), and a daughter names its parent; the example ships as a family: `example-proto/` (kind `proto`) and `example-tongue/` (kind `daughter`), so `make derive` has something real to check.

| # | Workflow | Gate | Skill(s) |
|---|---|---|---|
| 01 | `01-create-a-character` | fiction | `create-name`, `chart-character-arc` |
| 02 | `02-create-a-place` | fiction | `create-name` |
| 03 | `03-name-something` | fiction | `create-name` |
| 04 | `04-create-a-creature` | worldbuilding | `create-creature` |
| 05 | `05-create-a-culture` | worldbuilding | `create-name` |
| 06 | `06-build-a-language` | conlang | `build-language` |
| 07 | `07-add-a-word` | conlang | `add-word` |
| 08 | `08-design-a-script` | conlang | `design-script` |
| 09 | `09-record-a-pronunciation` | conlang | `pronounce` |
| 10 | `10-create-a-people` | worldbuilding | `grill-with-docs`, `create-name` |
| 11 | `11-chart-the-world-history` | worldbuilding | `grill-with-docs`, `wayfinder` |

Guides: `story-bible.md`, `naming.md`; worldbuilding `peoples.md`, `world-history.md`, `creatures.md`, `cultures.md`; conlang `building-a-language.md`, `lexicon-format.md`, `writing-systems.md`, `pronunciation.md`.

---

## 5. Skills

Frontmatter and body follow SB conformance: `name` equals the folder; `description` ≤ 1,024 characters naming the job, its triggers, and `Not X (`other-skill`)` boundaries; H1 `# Skill: <Name> (<%PROJECT_NAME%>)`; locale line `Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.`; `## Governing procedures (route here — do not restate at length)`; steps each ending `*Complete when:*`; `## Anti-patterns`; `## Cross-references` last. ≤ 300 lines including the mode file's share of the job.

Every moded `SKILL.md` carries this paragraph verbatim before step 1:

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

### 5.1 Shared writing skills (all variants, moded unless marked)

| Skill | Job | Writes | Reports or edits |
|---|---|---|---|
| `run-workflow` (no mode) | The router: resolve the author's intent ("review chapter 3", "what's next?", "pick up where we left off") to a workflow — `00-project.md` `## Workflow aliases` first, then `workflows/local/<slug>/`, then the layer index (listing the folders directly when an index has no 'You want to… \| Procedure' table); load `STEPS.md` with `CHECKLIST.md` open; obey gates; bias towards producing prose ("scaffolding is not progress"). | — | — |
| `draft-section` | Draft **one** section of 300–500 words from the unit brief, the variant plan (argument map, scene metadata, document brief), `voice-notes.md` and `samples/`. Never more than one section per request unless asked. Theology labels each move with its claim category in a trailing comment block and flags claims `VERIFY`; fiction reads the story bible first. | `drafts/<NN>-<section-slug>.md` (`status: ai-draft`, `origin: ai`); a new ledger entry with the AI original (`format: 2`; a redraft moves the live revision chain, and a promoted section's final, into the superseded-original comment, D45) | edits (new file) |
| `adapt-section` | Revise a draft from the author's notes or direct edits: change only what was flagged; offer two or three alternatives for contested lines; never rewrite the whole section. Also handles adapting source material (dissertation → accessible prose; template → client instrument) when asked. | the draft (`status: adapted`); ledger, with its revisions (D45) | edits |
| `improve-section` | The author drafted; propose improvements as a numbered diff, one-line reason each, at strength `light` (clarity, typos), `edit` (rhythm, structure) or `rework` (restructure, argument intact). Apply only what the author accepts; log every accept and reject to the ledger. Never alter a figure, date, citation key or commitment. | the draft (`status: improved`); ledger: the `## Author original` on the first pass and its revisions (D45) | report, then agreed edits |
| `promote-section` | On the author's explicit word: check the section's gates and zero flags, insert it into the unit file at its `<!-- section: slug -->` marker in plan order, set `status: promoted`, record the author's final text and change ratio in the ledger, update the unit brief and `MEMORY.md` Status. Business: insert into the `.tex` document between `% section: slug` markers. | unit file, ledger (a flag answer is an `author-note` revision; a re-promotion moves the previous final into the chain, D45), unit brief | edits |
| `learn-voice` | Mine ledger entries with `learned: false`: what the author changed in AI drafts and which improvements they rejected (rejections are the clearest signal). From v0.3.0 it reads the D45 chain: the author's evidence is the `author` revisions and the gap to the final, never AI text the author accepted, and an AI change the author later undoes counts as an implicit rejection. Propose voice-note additions with real before/after examples (and, where the pattern is mechanical or a term, `style-sheet.md` or `terminology.md` entries); write each only after the author approves it; mark an entry `learned: true` only once its section is promoted and mined (improvement decisions may be mined earlier, but the entry stays unlearned until promotion). Also seeds voice notes from `samples/`. | `voice-notes.md`, `style-sheet.md`, `terminology.md`, ledger | proposal, then agreed edits |
| `fact-check` | Sweep a unit or section for checkable claims and verify each: isolate it, name the basis, go to the primary source and follow the chain, record two dates, say what a study was not about, name jurisdiction and date for legal claims, keep contested evidence contested. One verdict vocabulary: `verified · verified-with-caveat · contested · thin · cannot-be-dated · unsupported`. Never marks anything verified without a real source. Uses `research` (`context: fork`) for delegated search. | `research/src/evidence/`, `VERIFY` flags; a ledger revision (D45) for accepted corrections to a draft | report |
| `spelling` | en_GB spelling against `style-sheet.md` and `terminology.md`; supportive report grouped by recurring item; fixes applied as a diff only when accepted. Fiction reads `names-register.md` and every `lexicon.toml` headword as known words and flags near-misses of them. | a ledger revision (D45) for accepted corrections to a draft | report, then agreed edits |
| `grammar` | Grammar and punctuation per the style sheet (single quotation marks); respects deliberate fragments and dialect. | a ledger revision (D45) for accepted corrections to a draft | report, then agreed edits |
| `comprehension` | Read as the stated reader (`AUDIENCE`, `READER_TEST`): undefined terms, leaps, buried points, by location. | — | report |
| `flow` | Transitions, paragraph order, rhythm, repetition, one-voice consistency across sections drafted out of order. | — | report |
| `structure-review` | Multi-lens structural review (`context: fork`); synthesis written as advice only to `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`; decisions enter `MEMORY.md` only when the author dates them. Business whole-library mode absorbs BD's `improve-document-library`. | review file | report |
| `build` | `make refs` (references) → `make <format> SCOPE=…` → confirm the file list → read the proof → report. Proofs are ungated. | `build/` | — |

### 5.2 Working-practice skills (all variants)

Vendor SB's copies (newest) with AT and BD adaptations; replace developer tokens with `<%AUTHOR_FIRST_NAME%>` / `<%AUTHOR_NAME%>`; strip code, story, ADR, `GAPS.md` and `DEFERRED.md` paths. Moded: `grilling`, `grill-with-docs`, `handoff`, `prototype`, `teach`, `wayfinder`, `research`. Not moded: `grill-me`, `wait-what` (ship only if generic after stripping; otherwise strip its cross-references).

**Language and word surfaces (fiction, conlang).** When `grilling`, `grill-me`, `grill-with-docs` or `wayfinder` is used on a language, a name or a word, the questions open with **the real-world inspiration and its point in history** before anything else, because they gate phonology, spelling and naming:
- *Which* real-world language or languages, and *which period* (for example Old English c. 900 against Middle English c. 1350 against modern English) — the period must sit sensibly with the language's place in its family (a proto-language leans older than its daughters).
- *What it should sound like*: what is borrowed from each model — sounds, syllable shapes, stress and rhythm first; grammar type and naming habits optionally — and *how strongly* (primary, secondary, accent).
- Only after the sound is settled, and as separate questions: the **romanisation** (how it is spelt in English prose; English-friendly by default) and, in `design-script`, the **native script** and its own optional inspiration.
- For a word or name: which model language and period gives it its flavour or echo; whether it is inherited, an early loan, a late loan or a fresh coinage; and *when in the world's own history* it entered the language (which sound changes it has been through: `stratum` and `entered_after`).
Each question carries a recommended answer with its reason, as the grilling engine requires. Facts about real languages are never settled by grilling: they go to `research` and are cited. Answers are recorded where they live: `language.toml` `[[inspiration]]`; the lexicon entry's `echo`, `stratum` and `entered_after`; `MEMORY.md` Decisions for anything hard to reverse. `grill-me` (stateless) asks the same questions and offers `grill-with-docs` when an answer is load-bearing. `wayfinder` charts unresolved model-and-period choices as the first frontier of a language map, since everything else depends on them. This lives in each skill's `FICTION.md` mode file; the shared `SKILL.md` stays byte-identical.

### 5.3 Variant-only skills (gated whole; no mode file)

| Variant | Skill | Job |
|---|---|---|
| theology | `argument-audit` | Check prose against `planning/src/arguments/<unit>.md`: claim → supporting claims → evidence → objections → concessions; flag unsupported moves, missing premises and conclusions stated beyond their evidence. |
| theology | `category-check` | Label every substantive sentence with one of the six claim categories; flag silent collapses (inference presented as text, conclusion as history, application as exegesis) and unsignalled moves from exegesis to systematic theology. |
| theology | `tradition-check` | How readers from other traditions (Reformed, Catholic, Orthodox, Wesleyan, Pentecostal, Anabaptist, as relevant) would push back; each reading stated so its holders would recognise it; named in the body, not a footnote. |
| theology | `steelman` | Recognition, ease and missing-objection tests; concession positioned ahead of the response; report, never rewrite. |
| fiction | `continuity` | Prose against `continuity.md`, `timeline.md`, `world/src/**`, `names-register.md` and the lexicon; contradictions reported, never silently repaired; new facts proposed for the ledger with section references. |
| fiction | `character-voice` | Dialogue and POV narration against each character's voice markers; flags drift. |
| fiction | `causality` | Every beat cites its cause in `causality.md`; flags coincidence-driven advancement. |
| fiction | `pacing` | Scene length, scene and sequel alternation, tension per chapter; report only. |
| fiction | `create-name` | Character, place, creature and culture names: three to five options with reasoning, using the conlang's phonotactics and its real-world models' naming habits where one exists; a false-friend check against the model languages and English; checks the register for clashes and look-alike or sound-alike names; registers the chosen name with IPA, a reader respelling, origin language, meaning and first appearance. |
| fiction | `chart-character-arc` | Arc type (positive, negative, flat); want against need; the lie believed and the truth reached; wound; beats mapped to chapters and sections; writes `planning/src/arcs/<slug>.md`. |
| fiction + worldbuilding | `create-creature` | Bestiary entry: ecology, anatomy, behaviour, lore and names, role in the story, rules and limits, weaknesses; checked against the world's established rules. |
| fiction + worldbuilding | `design-quest` | Goal, stakes, trigger, obstacles, reversals, cost, reward, arc tie-ins and causality links, so no quest is left dangling; writes `planning/src/quests/<slug>.md`. |
| fiction + conlang | `build-language` | Follows D32 in order, one subsystem per session step, each settled with the author before the next: the speakers (culture link, what they value, where vocabulary must be deep) → the real-world models (D33–D34: read the people, culture, history and places files; present two or three options with period, reasoning, reader associations, sample names and risks; recommend one; choose with the author; research how each actually works with the `research` skill and cite it in `research/src/setting/`, record `[[inspiration]]`) → proto or daughter (a daughter starts from its parent plus ordered sound changes) → phonology (20–35 phonemes in IPA, phonotactics, stress, a few allophones) → orthography (readable romanisation, one spelling per sound) → grammar (word order with morphology type, what it marks and ignores, irregular frequent words, pronouns) → core lexicon (core concepts first, built from roots) → `make lexicon` and `make derive` clean. Writes `language.toml`, `phonology.toml`, `sound-changes.toml`, `grammar.md`, `lexicon.toml`. |
| fiction + conlang | `add-word` | Coin one word (or a small requested batch): from roots, affixes or compounds first, inventing a new root only when none fits; headword, phonemic IPA, part of speech, senses (not one-to-one with English), etymology (root → sound-shifted form → semantic drift), loan source when borrowed (adapted to the phonotactics), any deliberate `echo` of a real word (verified and cited), a false-friend check for prominent words (D33), native-script spelling from the transliteration rules; validate with `make lexicon` (and `make derive` for daughters). Mirrors `add-reference`. |
| fiction + conlang | `design-script` | The writing system: script type (alphabet, abjad, abugida, syllabary, logographic, featural) chosen to fit the phonology and the culture's history, taking real-world inspiration by default (D34): from the culture's medium and tool and the script's origin, present two or three real script families with period and reasoning, recommend one, and record it in `glyphs.toml` `[meta.inspiration]` — a separate question from the sound model, asked on its own — taking structure and stroke logic, never glyphs; direction and layout; glyph inventory in `glyphs.toml` with stroke order and positional forms; one **filled-outline** SVG per glyph on the declared em grid; numerals, punctuation, diacritics; optional ceremonial hand; script history tied to etymology; transliteration rules in both directions as the single source of truth for romanised spellings; then `make font LANG=…` and a rendered sample. |
| fiction + conlang | `pronounce` | Audio from the **surface** IPA (`lexicon.py surface`) for a word, name or sample sentence: ElevenLabs via `mcp__elevenlabs__text_to_speech` (Eleven v4, IPA between slashes, the language's recorded voice and model), falling back to `espeak-ng`; states the character count before any batch; never generates unasked. Also the "read it aloud" pronounceability test for new names. |
| books | `typeset` (moded `THEOLOGY.md`, `FICTION.md`) | D31: Pandoc base → house-class styling → fidelity check → three-way carry-forward after edits → XeLaTeX proof. Never retypes a word; styling uses only `housebook.cls` macros; page-design choices are the author's. Theology mode: footnotes, scripture references, Greek and Hebrew fonts, small caps for LORD. Fiction mode: scene breaks, epigraphs, chapter openers, conlang words in native script, maps. |
| business | `clause-consistency` | Every defined term defined once and bolded once; every cross-reference resolves; near-synonyms disambiguated; terms consistent across the document family; precedence stated. |
| business | `tone` | House voice and plain English; register map (legal stays formal); never changes a figure, date, scope or commitment; accepted corrections to a draft are a ledger revision (D45). |
| business | `obligation-check` | shall / may / must intentional; every commitment traced to an instrument clause or flagged new; no unbounded "will"; prices, dates and service levels flagged `VERIFY`. |
| business + family | `business-documents`, `legal-documents`, `email-documents`, `accounting-documents`, `social-media-documents`, `msp-scp-documents` | One per selected family (D39): the family's document types, required sections, house conventions and checks, routing to its standard and create workflow; generalised from the source business repository (no business or client specifics). `msp-scp-documents` keeps its two required-sections sub-documents. |

### 5.4 Option skills

| Skill | Gate | Modes |
|---|---|---|
| `add-reference` | `INCLUDE_REFERENCES` | none |
| `approach-a-reader` | books + `INCLUDE_PROPOSAL` | `THEOLOGY.md` (endorsers), `FICTION.md` (agents) |
| `sensitivity-pass` | books + `INCLUDE_SENSITIVE_CONTENT` | `THEOLOGY.md`, `FICTION.md` |

---

## 6. Formats

**Section draft** (`drafts/<NN>-<section-slug>.md`):

```yaml
---
unit: 03-the-ford
section: crossing-at-night
order: 4
status: ai-draft        # ai-draft | author-draft | adapted | improved | author-revised | promoted
origin: ai              # ai | author
words_target: 400
ledger: standards/style/ledger/03-the-ford--crossing-at-night.md
last_updated: DD/MM/YYYY
---
```

**Unit brief** (`planning/src/units/NN-kebab-title.md`): frontmatter `title`, `slug`, `number` (business: `DOC-NNN` once registered), `version` (business: `vMAJOR.MINOR`; books leave it empty), `status` (unit ladder), `audience_note`, `sources: []`, `verified: {}` (keyed by gate, e.g. `V1: DD/MM/YYYY`), `sections:` (list of `{slug, purpose, status}`); body `## Scope` · `## What this unit does` · `## Sections` · the mode's settled-positions slot (theology `## Claims and categories`; fiction `## Continuity facts`; business `## Obligations and defined terms`) · `## Draws on` · `## Draft notes`.

**Ledger entry** (`standards/style/ledger/<unit-slug>--<section-slug>.md`): frontmatter `unit`, `section`, `origin`, `drafted`, `promoted`, `change_ratio`, `learned: false`, and from v0.3.0 `format: 2`; body `## AI original` (verbatim; empty for author-drafted sections), then optionally `## Author original` (the text the loop started from when the AI did not draft it) and `## Revisions` (the D45 chain of full-text states, each opened by its `<!-- revision N · kind · date · skill · rows -->` marker), `## Author final` (filled at promotion), `## Improvement decisions` (table: # · proposal · reason · decision (`accepted` · `rejected` · `author-note`, D38) · author's note).

**`provenance.md`** (seed): a table `Unit | Section | Origin | Change ratio | Promoted` maintained by `promote-section`; `make provenance` summarises it.

**Names register** (`world/src/names-register.md`): table `Name | Kind | IPA | Respelling | Language | Meaning | First appears | Notes`.

**Character** (`world/src/characters/<slug>.md`): frontmatter `name`, `ipa`, `role`, `first_appears`, `arc: planning/src/arcs/<slug>.md`; sections `## Want` · `## Need` · `## Wound and the lie` · `## Voice markers` · `## Relationships` · `## Continuity facts`. Places, creatures and cultures follow the same pattern with their own sections (Section 5.3).

**Language** (`world/src/languages/<lang>/`):

```text
<lang>/
├── CONTEXT.md · CLAUDE.md
├── language.toml         ← name, slug, kind (proto | daughter | isolate), parent, culture, typology
├── phonology.toml        ← inventory, classes, phonotactics, stress, allophones, romanisation
├── sound-changes.toml    ← daughters only: ordered [[rule]] from the parent
├── grammar.md            ← word order, morphology, what it marks and ignores, irregulars, pronouns
├── lexicon.toml          ← [[word]] entries (roots are entries with pos = "root")
├── pronunciation.md      ← narrator voice, model ID, settings, date chosen
├── script/
│   ├── script.md         ← type, direction, history, design principles
│   ├── glyphs.toml       ← [meta] + [[glyph]] entries
│   ├── glyphs/*.svg
│   ├── transliteration.md
│   └── numerals-and-punctuation.md
└── audio/                ← generated, git-ignored
```

```toml
# language.toml
name = "Example Tongue"
slug = "example-tongue"
kind = "daughter"            # proto | daughter | isolate
parent = "example-proto"     # daughters only
culture = "world/src/cultures/example-culture.md"  # empty when worldbuilding is off
speakers = ""                # who, where, when
values = []                  # domains where vocabulary runs deep, e.g. ["wind", "rope", "kinship"]
word_order = "SOV"           # SOV | SVO | VSO | VOS | OVS | OSV | free
morphology = "agglutinative" # isolating | agglutinative | fusional | polysynthetic
marks = []                   # e.g. ["case", "evidentiality", "dual"]
ignores = []                 # e.g. ["grammatical gender", "tense"]

[[inspiration]]              # one or more; D33 — borrow structure and flavour, not words
language = "Middle Welsh"
period = "medieval"          # ancient | classical | medieval | early-modern | modern
family = "Celtic"
weight = "primary"           # primary | secondary | accent
borrows = ["phonology", "phonotactics", "prosody"]   # sound first; optional: morphology | syntax | naming | aesthetic (script inspiration lives in glyphs.toml)
sources = ["research/src/setting/middle-welsh-phonology.md"]
notes = ""
```

```toml
# phonology.toml
[inventory]                  # phonemic IPA; 20–35 phonemes is the healthy range (warned outside it)
consonants = ["p", "t", "k", "m", "n", "r", "s", "v", "l"]
vowels = ["a", "e", "i", "o"]
[classes]                    # single capital letters usable in phonotactics and sound changes
C = ["p", "t", "k", "m", "n", "r", "s", "v", "l"]
V = ["a", "e", "i", "o"]
[phonotactics]
syllable = "(C)V(C)(C)"     # a string, or a list of alternative templates
onset_clusters = []          # permitted clusters, e.g. ["tr", "kl"]
coda_clusters = ["rn"]
forbidden = []               # forbidden sequences anywhere, e.g. ["tl"]
[stress]
rule = "penultimate"         # initial | penultimate | final | lexical
[[allophone]]                # ordered; applied by `lexicon.py surface`
phoneme = "t"
surface = "θ"
env = "V_V"
[romanisation]               # phoneme → grapheme(s); identity when absent; must be one-to-one
"ʃ" = "sh"
[romanisation.exceptions]    # documented departures from one-to-one, with reasons
```

```toml
# sound-changes.toml (daughters only) — applied in order to the parent's phonemic forms
[[rule]]
from = "w"
to = "v"
env = "#_"                   # _ = the target; # = word boundary; C, V and other class letters allowed
note = "word-initial w > v"
[[rule]]
from = "p"
to = "f"
env = "_V"
note = ""
```

```toml
# lexicon.toml
[meta]
language = "Example Tongue"
slug = "example-tongue"

[[word]]
headword = "varn"            # romanised; canonical in prose
ipa = "varn"                 # phonemic IPA, no slashes
pos = "noun"                 # noun | verb | adjective | … | root | affix | pronoun | name
senses = ["river", "the flow of time (poetic)"]   # not one-to-one with English
concept = "river"            # core-concept key when it fills one (for `make coverage`)
roots = ["war"]
affixes = ["-n"]
compound_of = []
proto_form = "warn"          # daughters: the parent form it descends from
drift = "'flowing' → 'river'; poetic 'time' from a proverb"
loan_from = ""               # language slug when borrowed
loan_source = ""             # the form in the source language
irregular = false            # true only with a note: the derivation is deliberately not regular
stratum = "inherited"        # inherited | early-loan | late-loan | coinage
entered_after = 0            # daughters: index of the last sound-change rule the word did NOT undergo (0 = inherited, undergoes all)
echo = ""                    # deliberate echo of a real word: "Old Norse vindr 'wind' (source: …)"; verified, never from memory
derived = ["varnel"]
native = ""                  # empty: derived by tooling/script.py from glyphs.toml
first_used = ""
notes = ""
```

```toml
# script/glyphs.toml
[meta]
type = "abugida"             # alphabet | abjad | abugida | syllabary | logographic | featural
direction = "ltr"            # ltr | rtl | ttb
units_per_em = 1000          # SVG viewBox is 0 0 <advance> 1000; y grows downwards
ascender = 800               # baseline sits at y = 800 in the SVG
descender = -200
default_advance = 600
[meta.inspiration]            # recommended (D34); independent of the sound model
medium = ""                  # stone | wood | clay | palm-leaf | parchment | paper | metal | other
tool = ""                    # chisel | knife | stylus | reed-pen | brush | quill | other
origin = ""                  # native | borrowed:<culture or script> | adapted:<culture or script>
script_family = ""           # e.g. "Elder Futhark runes", "Brahmic abugidas", "Ogham", or "" for none
period = ""
borrows = []                 # structure | direction | stroke-style | layout — never the glyphs themselves
sources = []
[[glyph]]
id = "va"
romanisation = "va"
ipa = "va"
name = ""
description = ""
strokes = []                 # stroke order, described in words (for the reader and the calligraphic hand)
svg = "glyphs/va.svg"        # ONE filled path (fill="currentColor"), no strokes, inside the em box
advance = 0                  # 0 = default_advance
forms = {}                   # isolated | initial | medial | final → svg
codepoint = ""               # optional pin in the Private Use Area, e.g. "U+E000"
```

---

## 7. The template repository root

```text
syntek-author/
├── copier.yml · DESIGN.md · README.md · CONTEXT.md · CHANGELOG.md · VERSION
├── .claude/              ← development manual + settings.json (dev isolation)
├── .github/
│   ├── scripts/          ← audits and tests (SB house shape)
│   └── workflows/audit-template.yml
├── adopt/                ← advisory adoption scripts + example answers files (no personal data)
└── template/             ← everything that ships
```

**Dev isolation** (root `.claude/settings.json`): `permissions.deny` lists `Skill(<name>)` for every skill under `template/.claude/skills/`; `"claudeMdExcludes": ["**/template/**/CLAUDE.md", "**/template/.claude/**"]`.

**Audits** (`.github/scripts/`, each with SB's header, numbered checks, what it cannot check, `--self-test`, exit codes 0/1/2):

| Script | Checks |
|---|---|
| `check-template-tokens.sh` | Malformed or unregistered tokens; paired `<: :>`; variant tokens only in the spine set. |
| `gen-mode-excludes.sh [--check]` | Generates or checks the mode-file `_exclude` block. |
| `generate-all.sh` | Renders every variant × profile (defaults; all options on; fiction with worldbuilding and conlang; adoption with `SEED_EXAMPLES=false`) from a temporary copy of the working tree, into a temporary directory. |
| `shipped-variants.sh <tree>` | Right skills present, others absent; exactly one mode file per moded skill; content layer `manuscript/` xor `library/`; gated folders correct; no surviving token. |
| `byte-identity.sh` | Shared non-spine files identical across variant trees. |
| `docs-pairing.sh` | Every directory has its pair except the declared exceptions. |
| `doc-references.sh` | Every backticked path in a shipped file exists in that variant's tree (markers `variant-only` exempt). |
| `shipped-seeds.sh` | Seeds have their headings and no entries; every seed is in `_skip_if_exists`. |
| `skill-conformance.sh` | Frontmatter, sections, mode contract paragraph, mode H2s, line cap. |
| `line-cap.sh` | 300-line cap. |
| `update-test.sh` | Generate at a baseline commit in a scratch clone → author edits MEMORY and style, deletes the example, deletes `voice-notes.md`, adds a section → template change committed → `copier update` → author edits kept, example still gone, `voice-notes.md` recreated, author section untouched, template-owned skill updated. |
| `adopt-test.sh` | Anonymised fixture shaped like AT built at runtime → `copier copy --overwrite --data SEED_EXAMPLES=false` → seeds, `src/` and style untouched; no example added. |
| `coexist-test.sh` | Apply a dummy second template with its own answers file and its own rules file over a generated project → both update cleanly; no file owned by both. |
| `tooling-smoke.sh` | In a conlang tree: `make lexicon`, `make derive`, `make coverage`, `make glossary`, `make font` (when `uv` is available), `make script-sample`; in every book tree: `make tex SCOPE=…` on the example, `make tex-check` (and a mutation proving it fails on a changed word), `make print` where XeLaTeX exists; in every tree: `make help`, `make flags`, `make provenance`, and `make compare FORMAT=tex` on a planted D45 entry (a multi-round chain; a git-ignored entry never reaches the output; `SECTION=` without `UNIT=` exits 2), with `make compare` to PDF where XeLaTeX exists; `make pdf`/`make docx` where Pandoc and XeLaTeX exist.; every `tooling/*.py --self-test`; and in business, the example section converted into a copy of `skeleton.tex` passing `make section-check`, with a one-word mutation failing it. |
| `scrub.sh` | Fails on personal data, source-repository names and absolute paths under `template/`. |
| `dev-isolation.sh` | Every template skill denied at the root; `claudeMdExcludes` present. |

CI runs every audit on every push, with no path filter, `permissions: contents: read`, renders in a shell loop, and never contains a literal `${{` beyond the workflow's own expressions.

---

## 8. Adoption (existing repositories)

There is no `copier adopt`. On a branch in the target repository: run the advisory `adopt/<kind>.sh` from this repository (report by default; `--apply` performs only moves with exactly one correct destination: `workspace/{handoffs,learning}` → root; `workspace/maps` → `planning/src/maps`; `standards/style/voice-and-tone.md` → `standards/style/voice-notes.md`; chapter stub briefs → `planning/src/units/`; flat `docs/*.md` → `docs/project/`; bespoke workflows → `workflows/local/`; `status: stub` → `outlined`; `§` → `Section`), then
`uvx copier copy --trust --overwrite --data-file <answers> --data SEED_EXAMPLES=false <template> .`, review `git diff`, recover any project text into `docs/project/`, `workflows/local/` or `.claude/CLAUDE.md`, and commit the answers file.
Seeds (`.claude/CLAUDE.md`, `MEMORY.md`, `settings.json`, `README.md` and the rest of Section 3.1) are never overwritten, because they already exist.
`adopt/` holds anonymised example answers files only.

---

## 9. Coexistence rules (for `syntek-media` and any later template)

1. Each template sets its own `_answers_file`.
2. Each template's instructions live in `.claude/rules/<template>/`; no template updates `.claude/CLAUDE.md`.
3. Shared root files are seed-if-missing (D17).
4. Skill and layer names never collide; the shared writing skills ship only from `syntek-author`.
5. Large binaries never sit in plain Git: generated audio and renders are git-ignored.

---

## 10. Hazards

Never template: author identity or health data; income; clients, prices, invoices, credentials; testimony or named individuals; student numbers; the academic archive; absolute paths; source-repository names; project state written into skills. Ship empty: seeds, `refs`, registers. Fix rather than copy: AT's `appearances` table, conflicting confidence vocabularies, BD's conflicting disclaimers, BD's "we" against "I" (answered by `BUSINESS_VOICE_PERSON`), SC's builds that include `drafts/`, AT's `proposal.md` SCOPE concatenation bug, stale first lines naming another repository.

---

## 11. Deferred (not in v0.1)

biblatex for business `.tex` citations (D36); SC's support directory (`add-organisation`, `verify-support`, `gen_support.py`); SC's two-level `sections` manuscript layout (`MANUSCRIPT_STRUCTURE`); `AGENTS.md` and multi-host entry points (`.ai/`, `.agents/`, `.codex/`); a fiction `reference.docx` (binary under an empty template suffix); a `course` doc type; `syntek-media`.
