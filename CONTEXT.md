# CONTEXT.md — syntek-author/

The repository of a Copier template that generates writing repositories in three variants: `theology`, `fiction` and `business`.
It has two halves. **`template/` is the product**: everything a generated project receives, at its real path, rendered by Copier with the house delimiters.
**Everything else is the template's own state**: its contract, its questions, its audits, its adoption scripts, its development manual and its licence and community files — none of it ships.
Nobody drafts a book here; a generated project is where the writing happens.

## Directory Tree

```text
syntek-author/
├── CONTEXT.md                ← this file: the map of the repository
├── README.md                 ← the landing page: generating, the questions in short, updating, adopting, audits; the rest is in the user guide (template/how-to/)
├── DESIGN.md                 ← the build contract; where any file disagrees with it, DESIGN.md wins
├── copier.yml                ← questions, gated _exclude, _skip_if_exists, _tasks, _migrations
├── VERSION                   ← the template's release number (0.7.0)
├── CHANGELOG.md              ← the template's history, Keep a Changelog
├── LICENSE                   ← MIT, Copyright (c) 2026 Sam Bailey t/a Syntek: the template only, never an author's writing (never shipped)
├── CONTRIBUTING.md           ← the front door for changes to the template: issue first, DESIGN.md approval, run-all.sh, pull requests
├── SECURITY.md               ← the latest release only; reports through GitHub's private vulnerability reporting alone
├── CODE_OF_CONDUCT.md        ← Contributor Covenant 2.1, verbatim, with its enforcement contact
├── family-shared.json        ← the D48 manifest: source bytes of the files, the copier.yml blocks and rules 06's block shared with companion templates
├── .gitignore                ← the repository's own ignore rules (never shipped): /handoffs/, /.code-review-graph/ and /.claude/settings.local.json
├── .mcp.json                 ← development only (never shipped): code-review-graph for this repository, pinned and keyless, its graph in /.code-review-graph/ (D54)
├── handoffs/                 ← maintainer handoffs and working notes; git-ignored, never committed or shipped
├── AGENTS.md · GEMINI.md     ← development entrypoints for Codex, OpenCode, Gemini CLI and Antigravity (D47)
├── .codex/                   ← the user-config snippet disabling every product skill in Codex (D47)
├── .claude/                  ← the DEVELOPMENT manual and dev-isolation settings (never shipped)
│   ├── CLAUDE.md             ← how to work on the template: contract, tokens, recipes, audits
│   ├── CONTEXT.md            ← what this .claude/ folder holds
│   └── settings.json         ← denies every template skill; keeps template manuals out of sessions
├── .github/
│   ├── scripts/              ← the audits and tests (DESIGN.md Section 7)
│   ├── workflows/audit-template.yml   ← CI: every audit and shellcheck, on every push
│   ├── ISSUE_TEMPLATE/       ← the bug report and template improvement forms; config.yml turns blank issues off
│   ├── PULL_REQUEST_TEMPLATE.md   ← the pull-request summary, decision and checklist
│   └── CODEOWNERS            ← @Syntek-Studio reviews every path, the contract and governance files closely
├── migrations/               ← scripts copier update runs when a release moves author work (D44)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── agents-outside-link.py        ← every update: an .agents link outside the project held aside and restored (D44's exception; family-shared, D48)
│   ├── v0.2.0-business-families.sh   ← v0.1.0's business family folders → the D39 families
│   ├── v0.2.0-project-settings.sh    ← every variant: brief values the author changed → 00-project.md ## Brief
│   ├── v0.5.0-data-root.sh           ← every variant, report only: the store and provider, tracked binaries, the guard, Drive workflows, stale seed lines (D50, D53)
│   ├── v0.6.0-how-to.sh              ← every variant, report only: where the guide starts, how-to that is not a folder, files of yours there (D56)
│   ├── family-update.py              ← every update and copy: the update report, the shared-file refresh and the MCP servers added once (family-shared, D52, D54)
│   └── family-refresh.json           ← this template's refresh list, the settings.json entries it offers (hooks, deny and ask rules, autoCompactEnabled and idleCompaction) and the MCP servers (D51, D54)
├── adopt/                    ← adoption scripts and invented example answers
│   ├── CONTEXT.md · CLAUDE.md
│   ├── adopt.sh              ← moving: advisory, --apply for one-destination moves; --additive: report only
│   ├── theology.sh · fiction.sh · business.sh   ← adopt.sh with --kind filled in
│   └── examples/             ← theology · fiction · business .answers.yml (invented values)
└── template/                 ← EVERYTHING that ships, at its real path
    ├── .copier-answers.syntek-author.yml   ← renders the project's answers record
    ├── AGENTS.md · GEMINI.md · .agents/ · .codex/ · .gemini/ · opencode.json   ← other coding agents (copy-only, per AGENT_CLIENTS, family-shared, D47 D48)
    ├── README.md · CONTEXT.md · .gitignore · .mcp.json   ← seeds (written once if missing)
    ├── Makefile              ← build entry point (spine); reads tooling/project.mk (seed)
    ├── .claude/              ← CLAUDE.md, CONTEXT.md, MEMORY.md, settings.json (seeds) · hooks/ (the three hooks and the pair shared, D51, D56) · rules/syntek-author/ (00-project.md is a seed) · skills/ (seven shared SKILL.md, D51) · syntek-author-agents.md (the bridge, D47) · syntek-author-permissions.py (D49) · syntek-author-dataroot.py and its map syntek-author-dataroot.json (the data-root resolver, family-shared, and this template's filing folders, D50)
    ├── manuscript/           ← content layer, books (theology, fiction)
    ├── library/              ← content layer, business: one folder per document family chosen in BUSINESS_FAMILIES
    ├── planning/ · research/ ← production layers, every variant
    ├── proposal/             ← books with INCLUDE_PROPOSAL
    ├── world/                ← fiction: characters, places, names; worldbuilding and conlang kits
    ├── how-to/               ← the user guide (D56), read-only in a project: shared container pairs and chapters; this template's guides, chapters and procedures under syntek-author/
    ├── standards/ · tooling/ ← supporting layers (flat)
    ├── .github/              ← business with DATA_PROVIDER google-drive and DATA_STORE repo: the Drive push and pull workflows
    └── handoffs/ · learning/ · assets/   ← author-owned working folders (pair only)
```

## What's here

- `DESIGN.md` — the decisions (D1–D59), the questions, the ownership classes and gating table, the generated tree, the skills and the formats. **Read the sections your change touches before changing anything**; comments in `copier.yml` cite it by section.
- `copier.yml` — the contract Copier executes. **Every gated path is one `_exclude` line whose gate is copied verbatim from DESIGN.md Section 3.5** (a business document family's read `DOC_TYPE == 'business' and '<family>' in BUSINESS_FAMILIES`), and the mode-file block between its `BEGIN`/`END generated mode excludes` markers is written by `.github/scripts/gen-mode-excludes.sh`, never by hand.
- `template/` — the product. **Every file in it is rendered**, so the delimiters `<%`, `<:` and `<~` appear only where a token is meant (token discipline: `.claude/CLAUDE.md` Section 4).
- `AGENTS.md`, `GEMINI.md`, `.codex/` — the development entrypoints for the other coding agents. They route to the development manual and say to start every session at the repository root, which has no `.agents`, so no client loads a product skill (D47). `.codex/config.toml` is a snippet to copy into the Codex user config; Codex ignores its skill list in a project file.
- `family-shared.json` — the D48 manifest: the size and hash of every file (the agent files with the five MCP files, the permissions script, the data-root resolver `template/.claude/syntek-author-dataroot.py` but never its map, the shared working-practice skills, the hooks with their pair, the `handoffs/` pair, the 13 shared how-to files and the guide guard, and the two family migration scripts), and of the `copier.yml` question, migrations and update blocks and the `rules-web-tools` block of rules 06 (the lines between its markers), that companion templates such as `syntek-media` vendor byte for byte. `.github/scripts/family-shared.sh --write` regenerates it; nothing at the root ships.
- `.claude/` — the development manual. Its settings deny every skill under `template/.claude/skills/` and exclude the template's `CLAUDE.md` files from development sessions, so the product's instructions never steer the people building it.
- `.mcp.json` — development only, never shipped: code-review-graph for this repository, syntek-media's development file byte for byte, its embedding tool denied and its two writing tools asked in `.claude/settings.json`. Never run its `install`, `init` or `uninstall` here (`.claude/CLAUDE.md` Section 3). The two servers the product ships are `template/` text (D54).
- `.github/scripts/` — the audits, each with a `--self-test`; its `CONTEXT.md` lists what each checks. CI runs all of them on every push, with `SYNTEK_DATA_ROOT` unset.
- `.github/ISSUE_TEMPLATE/` — two issue forms, a bug report (template version, `DOC_TYPE`, a second template, what went wrong and what was expected, the Copier and git versions, the command and its full output where a command was run, and no personal data) and a template improvement (the problem, the proposal, the decision it touches, the variants), with `config.yml` turning blank issues off and linking private security reporting and the README.
- `.github/PULL_REQUEST_TEMPLATE.md` — the summary, the decision cited or approved, and the checklist: `run-all.sh`, a `CHANGELOG.md` entry, `DESIGN.md` only with approval, `family-shared.sh --write` for shared bytes, no rendered output, no personal data, British English; and, under 'Licence', the contributor's box agreeing that the contribution is under the MIT Licence, inbound = outbound, as `CONTRIBUTING.md` ('Licence') says.
- `.github/CODEOWNERS` — `@Syntek-Studio` on every path, with closer reads named for the contract (`copier.yml`, `DESIGN.md`, `template/.claude/`), `migrations/`, `family-shared.json` and the governance files.
- `migrations/` — one script per release that moved a folder holding author work, run by `copier update` through `copier.yml`'s `_migrations` when the update crosses that release (D44). Each is idempotent, never overwrites or deletes a file, and always exits `0`; v0.5.0's moves nothing and only reports what the data root and the provider question mean for the project (D50, D53), and v0.6.0's only reports where the user guide starts and what of the owner's stands in `how-to/` (D56). Two family-shared scripts are unversioned and run on every update: `agents-outside-link.py` (D48) and `family-update.py` (D52), which prints the update report, refreshes the shared files the author has not changed, restores the read-only user guide, `how-to/`, where it differs from the template's text (D56), and offers the settings entries in `family-refresh.json` once each, on copy over an existing `settings.json` and on update (D51), and the two MCP servers to the project's `.mcp.json` and client files the same way (D54).
- `adopt/` — prepares an existing repository for adoption: a moving `copier copy --overwrite` (**advisory unless `--apply` is given, and it never overwrites**), or an additive `copier copy --skip '*' --skip-tasks` (`--additive`: a report only, D41).
- `VERSION`, `CHANGELOG.md` — the template's own release state. A generated project starts its own history; nothing here is copied into it.
- `LICENSE` — the MIT Licence alone, 'Copyright (c) 2026 Sam Bailey t/a Syntek', byte for byte syntek-base's, so GitHub detects it; `README.md` ('Licence') and `CONTRIBUTING.md` ('Licence') add that it covers the template, never an author's writing, that a generated project need not carry its notice, and that a file with its own licence keeps it (`tooling/harvard.csl`, CC BY-SA 3.0).
- `CONTRIBUTING.md` — the front door for changes to the template: an issue first, `DESIGN.md` approval, starting every session at the root, token discipline, personal data, family-shared bytes, house formats, `run-all.sh` and pull requests; contributions under the same licence, no CLA.
- `SECURITY.md` — the latest release alone is supported; reports go only through GitHub's private vulnerability reporting; in scope is the template's code that runs on an author's machine or in their repository, never Copier, the clients or the MCP servers' own code.
- `CODE_OF_CONDUCT.md` — the Contributor Covenant 2.1, verbatim, and the one place the repository names the enforcement contact.

## Cross-references

- `README.md` — the landing page for a user of the template: what it generates, the user guide's chapters, generating a project, the questions in short, updating with `-a`, both adoption modes, a second template and the other clients, the audits, the licence. The rest (the settings files, the data root and its providers, what an update does to each kind of file, the migrations) is in the user guide, `template/how-to/`.
- `.claude/CLAUDE.md` — what a maintainer needs: dev isolation, token discipline, how to add a skill, a mode file, a gated path, a workflow, a seed or a question.
- `DESIGN.md` Section 3 — ownership classes and the gating table; Section 7 — this repository's root and audits; Section 8 and D41 — adoption; D39 and D44 — the business families and their migration; D47–D49 — the other coding agents, the family-shared contract and the permissions script; D50, D53 and D54 — the data root, its provider and the two MCP servers; D55 and Section 7 — the licence and community files; D56 — the user guide, read-only, and its restore.
