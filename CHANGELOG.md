# Changelog

**Last Updated**: 03/10/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

All notable changes to syntek-author are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Dates are DD/MM/YYYY. The design behind every entry is `DESIGN.md`; entries cite it by decision (D1–D38) or section.

---

## [Unreleased]

_Nothing yet._

## [0.1.0] - 03/10/2026

The first release: one Copier template generating writing repositories in three variants, built to the contract in `DESIGN.md`.

### Added

- **Three variants from one template** (`DOC_TYPE`, always asked, no default): `theology` (a Christian non-fiction book, content layer `manuscript/`), `fiction` (a novel, `manuscript/` plus `world/`) and `business` (business, legal and client documents, `library/`). Shared files are byte-identical across the variants that ship them; variant differences live in gated files and in one mode file beside each shared skill (D6).
- **Options**, each gating its layer, standard, workflows and skills together: `INCLUDE_PROPOSAL` (books), `INCLUDE_REFERENCES` (all; on for theology), `INCLUDE_SENSITIVE_CONTENT` (books), `INCLUDE_WORLDBUILDING` and `INCLUDE_CONLANG` (fiction), `INCLUDE_DRIVE_SYNC` (business), and `SEED_EXAMPLES` (all; adoption answers false).
- **`copier.yml` in the house idiom** (D2): `_subdirectory: template` (D1), the named answers file `.copier-answers.syntek-author.yml` (D3), the `<% %>` / `<: :>` / `<~ ~>` delimiters, every question with help written to the person answering, validators (kebab-case slug, DD/MM/YYYY date, a brief of at least a sentence) and `when:` gates that always carry their `DOC_TYPE` test; `AUDIENCE` offers choices by variant; `CONTENT_LAYER` and `UNIT_NOUN` are computed and never stored.
- **Four ownership classes, one Copier mechanism each** (D14, Section 3): template-owned files merged by `copier update`; seeds written once if missing (`_skip_if_exists`, every pattern anchored); seed-once examples that stay deleted (a copy-only `_exclude` gate); and author-owned folders that ship only their `CONTEXT.md` and `CLAUDE.md`.
- **One `_exclude` line per gated path**, each gate copied verbatim from `DESIGN.md` Section 3.5, and an empty generated block for the mode files, written by `.github/scripts/gen-mode-excludes.sh`.
- **Post-generation tasks**, all non-fatal: `git init` on copy where no repository exists (adoption-safe), `chmod +x` on the session hook, and `make init` on copy to build the references database where the pipeline ships.
- **The authoring loop** (D10): draft, adapt or improve, promote on the author's word, learn the author's voice from the ledger — with provenance recorded for every section (D12) and the two inline flags `AUTHOR TO CONFIRM` and `VERIFY` (D13).
- **Coexistence with later templates** (D17, Section 9): shared root files are seeds, the template's instructions live in `.claude/rules/syntek-author/`, and the answers file is named for the template.
- **Adoption** (Section 8): `adopt/adopt.sh` (with `theology.sh`, `fiction.sh` and `business.sh`) reports by default and, with `--apply`, makes only the moves with exactly one correct destination; it never overwrites, never deletes and is idempotent. `adopt/examples/` holds invented answers files for each variant.
- **The user guide** (`README.md`), the repository map (`CONTEXT.md`) and the development configuration in `.claude/`, with dev isolation: every template skill denied at the root, and the template's `CLAUDE.md` files excluded from development sessions (Section 7).
- **Self-audits** in `.github/scripts/` (Section 7), run by CI on every push.
- **Answers that would destroy work are guarded (D35).** `copier update` refuses a change of `DOC_TYPE` and touches nothing: `copier.yml` reads the previous answers through `_external_data`, at the cost of a harmless MissingFileWarning. Before every update a message names what turning each `INCLUDE_*` option off deletes, filled-in seeds included, and the generated `README.md` lists those files per variant.
- **Business sections are word-checked (D36).** `tooling/texcheck.py` now ships to every variant. `make section-check FILE=….tex SECTION=<slug> DRAFT=….md` proves the words between a section's marker pair are exactly the promoted draft's, and `promote-section` runs it before it writes the ledger. Citation keys work only in Markdown documents in business; promotion stops on a `[@` bound for a `.tex`.
- **An `author-note` decision in the ledger (D38).** `adapt-section` logs each author's note it applies as `author-note`; `make provenance` counts only `accepted` and `rejected` rows as AI suggestions, and `learn-voice` still mines the notes.
- **The worked example can be practised through review.** A seed-once, author-drafted ledger entry for the example chapter's `opening` section (Section 3.2) joins the-turn's, and `provenance.py check` reports the example's missing register rows as a warning rather than a failure.
- **New seeds (Section 3.1).** `standards/brand/brand-voice.md` and `brand-guide.md` (business), `planning/src/maps/CONTEXT.md`, and the `CONTEXT.md` and `CLAUDE.md` of every `docs/project/` and `workflows/local/` are now written once and never overwritten by `copier update`. The house marks of running copy move to `standards/method/BUSINESS.md` rule 10, and the brand files hold only the business's own entries.
- **Tooling self-tests.** `provenance.py`, `lexicon.py` and `script.py` gain a `--self-test` beside `texcheck.py`'s.
- **Audits.** `update-test.sh` proves the `DOC_TYPE` refusal and the option-off message, and that deleted example ledger entries stay deleted; `shipped-seeds.sh` checks index seeds (check 14) and brand seeds (check 15); `adopt-test.sh` checks the unanchored-`build/` advisory; `tooling-smoke.sh` runs every tooling self-test in every render, and in business a `make section-check` pass and a one-word mutation that must fail (checks 18 to 20).

### Changed

Refinements from the pre-release review, made before any project was generated:

- **Drive sync pushes only issued work and never overwrites the record (D37).** Push uploads the PDF beside a `.tex` marked `% status: final`, `.docx` and `.xlsx` files, and Markdown with `status: final` in its frontmatter, never drafts or ingest reading copies (now `<name>.reading.md`). Pull adds new files and writes a differing Drive copy beside the tracked one as `<name>.drive-DD-MM-YYYY.<ext>`, reported, and never pulls a PDF beside a `.tex`. The Drive folder must sit in a shared drive; the push checks that first.
- **The audio ignore rule lives in `world/src/.gitignore`** (`languages/*/audio/`), shipped with every fiction project, so turning the conlang kit off no longer un-ignores generated audio (Section 4.3).
- **A business document is registered at the end of its line edit**, before the issue proof, so V6.2 can pass (`library/workflows/05-review-a-document/` step 12; later steps renumber 13 to 16). A review cycle sends a new version through the same review.
- **The theology worked example argues an invented thesis** ('a welcome is not finished at the door; it is finished when the guest is expected back'), unrelated to any source book (Section 3.2, D15); the theology mode-file examples follow it.
- **Ledger rules.** A redraft keeps its entry, the superseded AI original moving into a dated comment; a re-promotion sets `learned: false`; a unit's name, number included (`03-the-ford`), names its ledger entries, its provenance rows and `UNIT=`.
- **Skill routing.** `run-workflow` owns 'what's next?', resuming from a handoff and any job no skill claims; a skill that carries out a workflow runs a same-named `workflows/local/` procedure instead; `spelling` owns 'proofread'; sharper boundaries between `grilling` and `grill-me`, `argument-audit` and building a map, `prototype` and `adapt-section`, `create-creature` and peoples, `approach-a-reader` and the proposal workflow. `grill-with-docs` dates V1, and drafting stops while a brief is still `idea`.
- **`make print`** builds each script's font on its own and goes on when one fails, then reports every character a font could not draw (a `final` print stops on one). `make flags` also reads `.claude/CLAUDE.md`; `make init` never overwrites the database; a theology project's default translation appears in every reference list (`build/nocite.yaml`).
- **`adopt.sh`** reads its seed list from `copier.yml`, and reports a `.gitignore` line that would ignore `.claude/skills/build/`.
- **Gates follow D11.** `standards/verification/verification.md`: V1 gates `idea → outlined`; `outlined → draft` has no gate of its own and happens when the first section is drafted (by `draft-section`, or the author's first draft through `improve-section`); V2 (every planned section promoted, zero flags) and V3 (a proof of the unit builds) together gate `draft → structural-review`; V4, V5 and V6 gate the three review transitions, and the variant sub-gates hang off V4 to V6. Every workflow, guide, skill and mode file that cites a gate now does so as 'V2 (draft → structural-review)'; the worked-example briefs move to `status: draft`, since their sections are drafted.
- **The house class is `tooling/latex/housebook.cls`** (was `book.cls`), so it never shadows LaTeX's standard `book` class; `typeset/src/book.tex`, the `Makefile`, `copier.yml`, the guides, the `typeset` skill, the rules and the audit catalogue follow.
- **`learn-voice` agrees everywhere with DESIGN.md Section 5.1**: proposals may target `voice-notes.md`, `style-sheet.md` and `terminology.md`, each written only after the author approves it; an entry not yet promoted may lend its improvement decisions but stays `learned: false`; an entry is marked learned only once its section is promoted and mined.
- **The `.claude/settings.json` seed** denies `Edit(typeset/src/units/.base/**)` in books and allows `Bash(uv run tooling/font.py *)` with the conlang (DESIGN.md Section 4.1). No migration: no release has shipped the seed.
- **`tooling/latex/skeleton.tex`** opens with `% unit: [unit-slug]` and closes each section with `% end section: <slug>`, as `promote-section` and the library guides expect.

### Fixed

Defects found by the pre-release review and its audits:

- **`make lint` no longer flags template text**: HTML comments, metadata headers, seed banners, LaTeX command names, list numbers and reference lists are skipped, and the seeds are one sentence per line, so every fresh render lints clean. `make lint` and `make flags` skip ingest reading copies and Drive copies, which are not the author's text.
- **`texcheck.py`** reads URLs, carets, tildes, repeated long-table heads and caption order as Pandoc writes them, compares footnote, scene-break, epigraph and quotation boundaries, and reports Markdown line numbers correctly.
- **Constructed languages:** every string read is NFC-normalised; roots and affixes are checked only against the inventory and forbidden sequences; glyph SVGs styled through CSS are refused; script samples draw positional forms at their own width; `house.lua` sets shared punctuation outside the native script.
- **Verification and review:** any agreed wording change after a gate is promoted again and re-reviewed; V4.4 covers method rules 5 to 8; a correction made in a `.tex` is mirrored into the section's draft and ledger and re-checked; `make docx` of a `.tex` needs the author's `DOCX_CONVERTER`, as every guide now says.
- **Fiction:** a culture registers its own name only when it differs from its people's; `pronounce` checks that `espeak-ng` exists before offering it; a stress mark is allowed where stress is lexical; the example research notes give literal access dates and treat Wikipedia as a lead, not a citation; promotion records `first_used` and `first_appears`.
- **Smaller agreements:** a brief's `version` key; the rules' seed list names every seed; the `make` targets table in `.claude/rules/syntek-author/04-build-pipeline.md` matches `make help`; `tone` reads the house marks from method rule 10; `provenance.py` reads an escaped `\|` as text; open set-ups live under `## Open setups` in `planning/src/causality.md` (`standards/method/FICTION.md`); a decision map resolves a batch of related nodes per session; the book-proposal guide names the master text for endorser approaches; `standards/risk/CONTEXT.md` names fiction risk rules 7 and 8; the chapter review runs the sensitivity pass before `final` where that option is on.
- `tooling/pandoc/house.lua` passes `--` before the word to `script.py transliterate`, so an affix such as `-ri` is not read as an option.
- Example words that no longer exist in the example lexicons (`vari`, `varilo`, `varillo`, `sennar`) replaced with real headwords (`hebo` /ˈheβo/, `hebori` /heˈβori/, `quaro`).
- `world/docs/reference/lexicon-format.md` lists every part of speech `lexicon.py` accepts, and says a daughter's roots, affixes and compounds may live in an ancestor's lexicon.
- Audits: `skill-conformance.sh` reads a block description once and numbers steps on the file's own lines; `docs-pairing.sh` exempts `typeset/src/units/.base/`; `shipped-seeds.sh` treats `world/src/history/eras.md` as a register seed and (check 13) holds each render's gated permissions; `tooling-smoke.sh` runs the book checks (`make tex`, `tex-check` and a one-word mutation, `print`) and the conlang checks (`derive`, `coverage`, `family`, `font`) of DESIGN.md Section 7. Each fix carries a self-test probe.

<!--
Record changes under [Unreleased]; at a release, retitle it with the version and date and open a
new empty [Unreleased] above it, so the newest release is always first. A release that renames or
moves a folder that can hold author work ships its migration in the same commit
(copier.yml, _migrations), and its entry says so.
-->
