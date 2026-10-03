# CONTEXT.md — syntek-author/

The repository of a Copier template that generates writing repositories in three variants: `theology`, `fiction` and `business`.
It has two halves. **`template/` is the product**: everything a generated project receives, at its real path, rendered by Copier with the house delimiters.
**Everything else is the template's own state**: its contract, its questions, its audits, its adoption scripts and its development manual — none of it ships.
Nobody drafts a book here; a generated project is where the writing happens.

## Directory Tree

```text
syntek-author/
├── CONTEXT.md                ← this file: the map of the repository
├── README.md                 ← the user guide: generating, the questions, updating, adopting, audits
├── DESIGN.md                 ← the build contract; where any file disagrees with it, DESIGN.md wins
├── copier.yml                ← questions, gated _exclude, _skip_if_exists, _tasks, _migrations
├── VERSION                   ← the template's release number (0.1.0)
├── CHANGELOG.md              ← the template's history, Keep a Changelog
├── .claude/                  ← the DEVELOPMENT manual and dev-isolation settings (never shipped)
│   ├── CLAUDE.md             ← how to work on the template: contract, tokens, recipes, audits
│   ├── CONTEXT.md            ← what this .claude/ folder holds
│   └── settings.json         ← denies every template skill; keeps template manuals out of sessions
├── .github/
│   ├── scripts/              ← the audits and tests (DESIGN.md Section 7)
│   └── workflows/audit-template.yml   ← CI: every audit, on every push
├── adopt/                    ← advisory adoption scripts and invented example answers
│   ├── CONTEXT.md · CLAUDE.md
│   ├── adopt.sh              ← the script: advisory by default, --apply for one-destination moves
│   ├── theology.sh · fiction.sh · business.sh   ← adopt.sh with --kind filled in
│   └── examples/             ← theology · fiction · business .answers.yml (invented values)
└── template/                 ← EVERYTHING that ships, at its real path
    ├── .copier-answers.syntek-author.yml   ← renders the project's answers record
    ├── README.md · CONTEXT.md · .gitignore · .mcp.json   ← seeds (written once if missing)
    ├── Makefile              ← build entry point (spine)
    ├── .claude/              ← CLAUDE.md, CONTEXT.md, MEMORY.md, settings.json (seeds) · hooks/ · rules/syntek-author/ · skills/
    ├── manuscript/           ← content layer, books (theology, fiction)
    ├── library/              ← content layer, business
    ├── planning/ · research/ ← production layers, every variant
    ├── proposal/             ← books with INCLUDE_PROPOSAL
    ├── world/                ← fiction: characters, places, names; worldbuilding and conlang kits
    ├── standards/ · tooling/ ← supporting layers (flat)
    ├── .github/              ← business with INCLUDE_DRIVE_SYNC: the Drive push and pull workflows
    └── handoffs/ · learning/ · assets/   ← author-owned working folders (pair only)
```

## What's here

- `DESIGN.md` — the decisions (D1–D38), the questions, the ownership classes and gating table, the generated tree, the skills and the formats. **Read the sections your change touches before changing anything**; comments in `copier.yml` cite it by section.
- `copier.yml` — the contract Copier executes. **Every gated path is one `_exclude` line whose gate is copied verbatim from DESIGN.md Section 3.5**, and the mode-file block between its `BEGIN`/`END generated mode excludes` markers is written by `.github/scripts/gen-mode-excludes.sh`, never by hand.
- `template/` — the product. **Every file in it is rendered**, so the delimiters `<%`, `<:` and `<~` appear only where a token is meant (token discipline: `.claude/CLAUDE.md` Section 4).
- `.claude/` — the development manual. Its settings deny every skill under `template/.claude/skills/` and exclude the template's `CLAUDE.md` files from development sessions, so the product's instructions never steer the people building it.
- `.github/scripts/` — the audits, each with a `--self-test`; `README.md` lists what each checks. CI runs all of them on every push.
- `adopt/` — prepares an existing repository for a `copier copy --overwrite`. **Advisory unless `--apply` is given, and it never overwrites.**
- `VERSION`, `CHANGELOG.md` — the template's own release state. A generated project starts its own history; nothing here is copied into it.
- There is no `migrations/` folder yet. The first release that renames a folder holding author work creates it (the rule is in `copier.yml`, under `_migrations`).

## Cross-references

- `README.md` — what a user of the template needs: the questions, the four ownership classes, updating with `-a`, adoption, a second template, the ElevenLabs note.
- `.claude/CLAUDE.md` — what a maintainer needs: dev isolation, token discipline, how to add a skill, a mode file, a gated path, a workflow, a seed or a question.
- `DESIGN.md` Section 3 — ownership classes and the gating table; Section 7 — this repository's root and audits; Section 8 — adoption.
