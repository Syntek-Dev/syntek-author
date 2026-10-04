# CONTEXT.md — adopt/

The tools for bringing an **existing** writing repository under the template.
There is no `copier adopt`: adoption is a `copier copy` into the repository, and a copy can write and replace files but never move them.
It comes in two modes. **Moving** adoption (`copier copy --overwrite`) lets the template take over its own paths, so this folder does the moving first.
**Additive** adoption (`copier copy --skip '*' --skip-tasks`, DESIGN.md D41) keeps every existing file exactly as it is and adds the template beside it, so this folder reports what the copy will add and keep and what to extend by hand.
It also supplies example answers for the copy.
It holds no real project's answers, names or paths: the example values are invented, and an author's real answers file stays outside this repository.

## Directory Tree

```text
adopt/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for changing the scripts
├── adopt.sh              ← the script: --kind theology|fiction|business [--apply | --additive [--answers FILE]] [TARGET]
├── theology.sh           ← adopt.sh --kind theology (DESIGN.md Section 8 names one per kind)
├── fiction.sh            ← adopt.sh --kind fiction
├── business.sh           ← adopt.sh --kind business
└── examples/
    ├── theology.answers.yml   ← invented answers for a theology book
    ├── fiction.answers.yml    ← invented answers for a novel with both fiction kits
    └── business.answers.yml   ← invented answers for a business library
```

## What's here

- `adopt.sh` (moving adoption, the default) — **advisory by default**: it prints what it would do and changes nothing. With `--apply`, on a branch other than `main` or `master` in a git work tree, it performs only the moves DESIGN.md Section 8 lists, each of which has exactly one correct destination: `workspace/{handoffs,learning,maps}` out of `workspace/`, `voice-and-tone.md` to `voice-notes.md`, stub chapter files to `planning/src/units/`, flat `docs/*.md` guides to `docs/project/`, bespoke workflows to `workflows/local/`, `status: stub` to `outlined`, and the section sign to 'Section' in governance Markdown. **It never overwrites and never deletes**; an existing destination is reported as a collision. A second run is a no-op.
- For business it also reports every `library/src/` folder that is not one of the document families (DESIGN.md D39), with the family the template files its documents in. Which family a folder belongs to is the author's call, so it is never moved.
- `adopt.sh --additive` (additive adoption) — **report only, never `--apply`**. It renders the template for the kind into a temporary folder (with the answers file named by `--answers`, or the defaults) and compares that tree with the repository. It names:
  - **the source and ref it previewed** (this clone at HEAD, its tag if it has one, and whether it is dirty); its closing step copies from exactly that, because a report on one tree is not exact for another;
  - what the copy will **add** (per folder) and **keep** (every file at a template path), each kept file marked **kept, committed**, **kept, staged**, **kept, untracked** or **kept, ignored**: a file an earlier copy left and nobody committed is the template's, not the repository's, so it is removed before the copy rather than kept as the repository's own;
  - every **same-named** file: one the copy adds beside the repository's own file of that name in a neighbouring folder of the same tree (its parent, a sibling or a child), such as the template's `library/docs/reference/X-standards.md` beside the repository's `library/docs/X-standards.md`, with the `## Overrides` redirect line `` `<template path>` → `<project path>` `` that points every template file at the repository's copy (D40);
  - every template path the repository's ignore rules hide, from `git check-ignore`, marked **ignored** with its `source:line:pattern`. Git never commits such a file, and the next `copier update` deletes it, or replaces a kept file of the repository's own there. The moving mode's unanchored `build/` advice runs here too;
  - every kept file at a family's or an option's template path, read from `copier.yml`'s `_exclude` gates: unticking that family or turning that option off later deletes it, so it must be copied out first;
  - every kept `.claude/skills/<name>/SKILL.md` beside which the template writes a mode file, marked **inert**, because a mode file applies only when its `SKILL.md` carries the Mode paragraph;
  - every kept `CONTEXT.md` whose folder gains template entries it does not name, to **extend** by hand, and every kept `workflows/CONTEXT.md` without the 'You want to… | Procedure' table;
  - every template `CONTEXT.md`, `CLAUDE.md` or `README.md` added to a folder that already holds the repository's own files, to check against its layout and record in `00-project.md` `## Overrides`;
  - two procedures that will share a workflow number in one layer;
  - for business, a kept `google-drive-*.yml` workflow, and a kept workflow that mentions `library/src/` and would sync the `drafts/` folders the copy adds (D37);
  - the settings files the copy writes, `.claude/rules/syntek-author/00-project.md` and `tooling/project.mk`, with the build settings a repository usually needs there: its logo folder, its own open-item marks, its Word converter;
  - a kept `Makefile` that differs from the template's, whose targets (the D42 filter, the D43 issue guard) are then not installed.

  Run it before the copy to preview, and after it to see what is left to extend. The repository is never written to.
- The moving report also names what the copy will **keep** (seeds that already exist, read from `copier.yml`'s `_skip_if_exists` at run time so the list cannot drift, and what each lacks against the template's seed, such as a `.gitignore` whose unanchored `build/` line would hide `.claude/skills/build/`) and what it will **replace** (files at template paths, when run from a clone that holds `template/`), plus everything only the author can decide: drafted chapters whose brief must be split out by hand, a workflow that is a template workflow under an older number, agents, a two-level manuscript, stray root files.
- `theology.sh`, `fiction.sh`, `business.sh` — the same script with `--kind` filled in.
- `examples/*.answers.yml` — the shape of a `--data-file` for `copier copy`: every question shown for that variant, with made-up values (business includes `BUSINESS_FAMILIES`). Copy one outside the repository being adopted and change every value.
- Exit codes: `0` report printed (and safe moves made); `1` one or more `--apply` moves failed and were left in place; `2` usage error, `--apply` refused, or `--additive` could not render the template.

## Which mode

- **Moving** when the repository is young, or already close to the template's layout, and the template should own its governance from now on.
- **Additive** when the repository has conventions of its own that work — its own skills, a project `CLAUDE.md`, workflows numbered in its own series, a Drive or issuing practice — or holds confidential material nobody should reorganise. The template then reads where things live from `00-project.md`. **Two costs (D41):** the project's own files at template paths count as template files to Copier, so unticking a family or turning an option off deletes them; and a kept file the template later changes comes back with conflict markers on update (keep the project's version).

## Cross-references

- `README.md`, "Adopting an existing repository" — the steps of each mode, from branch to commit, with the `copier copy` command.
- `DESIGN.md` Section 8 — the adoption design and the list of one-destination moves; D41 (additive adoption); D40 (`00-project.md`); D9 (unit briefs), D11 (status ladder), D26 (workflow numbering), D27 (`docs/project/` overrides).
- `copier.yml` `_skip_if_exists` — the seed list the report's "kept" section reads at run time.
- `copier.yml` `_exclude` — the gate lines the additive report reads to name the files a later untick deletes.
- `.github/scripts/adopt-test.sh` — builds anonymised fixtures at runtime. It proves the moving adoption leaves seeds, sources and style untouched. It proves the additive one leaves every existing file untouched, and that its report names the inert mode file, the index to extend and the build skill an unanchored `build/` hides. On a business library it proves the report writes nothing (committed, untracked or ignored, every file byte for byte) and names a kept file at a family path, a kept Drive workflow, the drafts a kept workflow would sync, a signpost added beside the library's own files, the library's own standard beside the template's with its redirect, and each kept file as committed, untracked or ignored.
