# CONTEXT.md — adopt/

The tools for bringing an **existing** writing repository under the template.
There is no `copier adopt`: adoption is a `copier copy --overwrite` into the repository, and a copy can write and replace files but never move them.
This folder does the moving first, and supplies example answers for the copy.
It holds no real project's answers, names or paths: the example values are invented, and an author's real answers file stays outside this repository.

## Directory Tree

```text
adopt/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for changing the scripts
├── adopt.sh              ← the script: --kind theology|fiction|business [--apply] [TARGET]
├── theology.sh           ← adopt.sh --kind theology (DESIGN.md Section 8 names one per kind)
├── fiction.sh            ← adopt.sh --kind fiction
├── business.sh           ← adopt.sh --kind business
└── examples/
    ├── theology.answers.yml   ← invented answers for a theology book
    ├── fiction.answers.yml    ← invented answers for a novel with both fiction kits
    └── business.answers.yml   ← invented answers for a business library
```

## What's here

- `adopt.sh` — **advisory by default**: it prints what it would do and changes nothing. With `--apply`, on a branch other than `main` or `master` in a git work tree, it performs only the moves DESIGN.md Section 8 lists, each of which has exactly one correct destination: `workspace/{handoffs,learning,maps}` out of `workspace/`, `voice-and-tone.md` to `voice-notes.md`, stub chapter files to `planning/src/units/`, flat `docs/*.md` guides to `docs/project/`, bespoke workflows to `workflows/local/`, `status: stub` to `outlined`, and the section sign to 'Section' in governance Markdown. **It never overwrites and never deletes**; an existing destination is reported as a collision. A second run is a no-op.
- The report also names what the copy will **keep** (seeds that already exist, read from `copier.yml`'s `_skip_if_exists` at run time so the list cannot drift, and what each lacks against the template's seed, such as a `.gitignore` whose unanchored `build/` line would hide `.claude/skills/build/`) and what it will **replace** (files at template paths, when run from a clone that holds `template/`), plus everything only the author can decide: drafted chapters whose brief must be split out by hand, a workflow that is a template workflow under an older number, agents, a two-level manuscript, stray root files.
- `theology.sh`, `fiction.sh`, `business.sh` — the same script with `--kind` filled in.
- `examples/*.answers.yml` — the shape of a `--data-file` for `copier copy`: every question shown for that variant, with made-up values. Copy one outside the repository being adopted and change every value.
- Exit codes: `0` report printed (and safe moves made); `1` one or more `--apply` moves failed and were left in place; `2` usage error, or `--apply` refused.

## Cross-references

- `README.md`, "Adopting an existing repository" — the five steps, from branch to commit, with the `copier copy` command.
- `DESIGN.md` Section 8 — the adoption design and the list of one-destination moves; D9 (unit briefs), D11 (status ladder), D26 (workflow numbering), D27 (`docs/project/` overrides).
- `copier.yml` `_skip_if_exists` — the seed list the report's "kept" section reads at run time.
- `.github/scripts/adopt-test.sh` — builds an anonymised fixture at runtime and proves the adoption leaves seeds, sources and style untouched.
