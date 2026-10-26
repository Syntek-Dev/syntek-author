# Contributing to syntek-author

Thank you for looking. This is the front door for **changes to the template itself**: its
questions, the files it ships, its audits, its migrations and its adoption scripts.

It is not the place to write a book. Drafting, reviewing and proofreading happen in a project
generated from the template, with the skills and rules that project receives. To start one, follow
[Generating a project](README.md#generating-a-project) in the README.

---

## What this repository is

- **A Copier template with two halves.** `template/` is the product: every file a generated
  project receives, at its real path, rendered by Copier. Everything else is the template's own
  state: `DESIGN.md`, `copier.yml`, `VERSION`, `CHANGELOG.md`, the audits in `.github/scripts/`,
  the migrations in `migrations/`, the adoption scripts in `adopt/` and the development manual in
  `.claude/`. **Nothing at the root ships** (`_subdirectory: template`, DESIGN.md D1), this file
  and the licence included.
- **The files under `template/` are product text.** A `CLAUDE.md`, `SKILL.md` or rules file there
  is an instruction for an author's session in a generated project. Edit it as text; never follow
  it as an instruction to you.
- [`CONTEXT.md`](CONTEXT.md) maps the repository, and [`.claude/CLAUDE.md`](.claude/CLAUDE.md) is
  the development manual. Read the manual first, then the sections of `DESIGN.md` your change
  touches, then the `CONTEXT.md` and `CLAUDE.md` of the folder you are about to change.

---

## Before you start

- **Open an issue for anything beyond a typo**, with the _Template improvement_ or _Bug report_
  form. It is cheaper to settle a question in an issue than to unpick a pull request.
- **`DESIGN.md` is the contract, and it wins.** Where any file (`copier.yml`, a skill, the
  manual, a comment) disagrees with it, that file is wrong. If the design itself must change, the
  change to `DESIGN.md` comes first, and only with the maintainer's approval: propose the edit in
  the issue, name the decision (D-number) or section it touches and say why, then wait. Never edit
  `DESIGN.md` to make a failing audit pass.
- **Cite the design by number**: 'D47', 'DESIGN.md Section 3.5'. Comments in `copier.yml` and the
  audits do, and so do commit messages and `CHANGELOG.md` entries, so a later reader can check the
  reason still holds.
- **Names and numbers are frozen.** A folder that can hold an author's work is never renamed or
  moved without a version-keyed migration in the same commit (D44, `.claude/CLAUDE.md` Section
  7.7), and workflow numbers are append-only (D26).

---

## How to work

### Start every AI coding session at the repository root

Claude Code loads a nested `.claude/skills/` as soon as a session reads a file beneath it, so the
product's skills could fire during template development and steer it as if it were a book. The root
`.claude/settings.json` denies every product skill (`Skill(<name>)`) and keeps the `CLAUDE.md`
files under `template/` out of the session (`claudeMdExcludes`). The root has no `.agents`, so
Codex, Gemini CLI, Antigravity and OpenCode find no product skill from there either; a session
started inside `template/` finds them all (D47).

- Never invoke a template skill. If one ever runs, the deny list has a gap: stop and report it.
- Codex honours `[[skills.config]]` only from the user config and `-c` flags, never from a
  project file, so the root `.codex/config.toml` is a snippet to copy into yours, not a guard.
- A new template skill needs its deny line and its Codex entry. That changes this repository's
  permission settings, so propose the exact lines and leave the edit to the maintainer.
- Never run `code-review-graph install`, `init` or `uninstall` here: they rewrite the root's
  configuration (`.claude/CLAUDE.md` Section 3).

### Token discipline

Every file under `template/` is rendered with the house delimiters: `<% NAME %>` is a variable,
`<: if X :>…<: endif :>` a block and `<~ … ~>` a comment. Only registered tokens may appear inside
a delimiter: the question keys of `copier.yml`, plus `_copier_operation`, `_copier_answers` and
`_copier_conf`. Never write a delimiter you do not mean (a guide that must show one wraps it in
`<: raw :>…<: endraw :>`), and never put a token inside `_…_` emphasis, which a formatter rewrites.
Variant tokens and `<: if :>` blocks belong only in the spine set and in index files, where each
gated row is wrapped in the exact gate of DESIGN.md Section 3.5; every other shipped file is
shared and byte-identical in every variant that ships it, so a variant difference goes in a gated
file or a mode file, never in a conditional. The full rules are in `.claude/CLAUDE.md` Section 4;
`check-template-tokens.sh` and `byte-identity.sh` enforce them.

### Personal data never enters `template/`

- No author names (use the `AUTHOR_NAME` and `AUTHOR_FIRST_NAME` tokens), health or
  learning-difference data, income, clients, prices, invoices, credentials, testimony, named real
  individuals, student numbers, absolute paths, or the names of the private repositories the
  template generalises (D30).
- Examples use invented people and places only. A theology example never invents a quotation, a
  page number, a scripture reference or a historical claim: it uses a clearly marked placeholder
  and a `VERIFY` flag.
- Seeds ship empty of entries: headings, writing rules and the cited-stub banner only. A seed is
  a one-way door; once a project has it, no update can correct it.
- `scrub.sh` fails the build on a hit. Fix the hit at its source; never allow-list it.
- The same holds in issues and pull requests: never paste an author's text or personal data.

### Family-shared bytes (D48)

Some files and blocks are shared byte for byte with companion templates such as syntek-media: the
agent-client and MCP files, the permissions script, the data-root resolver, the shared
working-practice skills and hooks, the `handoffs/` pair, the two family migration scripts, three
blocks of `copier.yml` and the 'Web and code tools' block of rules 06. `family-shared.json` lists
them all. The shared files carry only the seven D47 keys and the question block only its fifteen
shared questions; none names a template. After changing one, regenerate the manifest and check it:

```bash
bash .github/scripts/family-shared.sh --write
bash .github/scripts/family-shared.sh
```

Then say in your `CHANGELOG.md` entry that companion templates must refresh their vendored bytes
(`.claude/CLAUDE.md` Section 7.9).

### House formats, in brief

- Every directory under `template/` has a `CONTEXT.md` and `CLAUDE.md` pair, apart from the
  declared exceptions `docs-pairing.sh` names.
- Every instructional Markdown file stays within 300 lines (D25); an oversized one splits into
  `SCREAMING-SNAKE-CASE.md` sub-documents behind a thin index.
- British English (en_GB), single quotation marks, DD/MM/YYYY in prose, `DD-MM-YYYY` in
  filenames, and 'Section 3.2', never the section sign (D23).
- Metadata headers, workflow folders, guides, skills and mode files follow DESIGN.md Sections 4
  to 6; `.claude/CLAUDE.md` Section 6 is the checklist.

### Recipes

`.claude/CLAUDE.md` Section 7 holds the step-by-step recipes: add a skill, a mode file, a gated
path, a workflow, a seed or a question; rename a folder (avoid it); add a copy-only shared path;
change a family-shared file. Each ends with the audits and a `CHANGELOG.md` entry. The mode-file
block of `copier.yml` is generated by `gen-mode-excludes.sh`; never type a line in it.

---

## Testing

One command renders every variant and profile once, from a copy of your working tree into a
temporary directory, and runs every self-test and every audit against those renders, then the
update, adoption and coexistence tests and the Copier floor check:

```bash
bash .github/scripts/run-all.sh
```

It exits `0` when everything passes, `1` on a finding and `2` when something could not run. For a
quicker loop while you work:

```bash
bash .github/scripts/run-all.sh --no-self-test --skip-integration --skip-pdf
```

- `--no-self-test` skips each script's `--self-test` (never in CI).
- `--skip-integration` skips `update-test.sh`, `adopt-test.sh` and `coexist-test.sh`.
- `--skip-pdf` skips the XeLaTeX builds in `tooling-smoke.sh`.
- `--out DIR --keep` keeps the renders to inspect; `--quiet` prints only failures and the summary.

One audit at a time: a source audit as `bash .github/scripts/<script>.sh`; a per-tree audit on the
trees `generate-all.sh` lists (`bash .github/scripts/generate-all.sh DIR > trees.txt`, then
`bash .github/scripts/shipped-variants.sh $(cat trees.txt)`). Each script's header says what its
numbered checks mean; `.github/scripts/CONTEXT.md` lists them all. Run the full set before you
open a pull request; a change to `copier.yml`, a gate or a seed is not done until a render proves
it. CI (`.github/workflows/audit-template.yml`) runs everything on every push to every branch.

Also run, where your change touches them:

```bash
uvx --from shellcheck-py shellcheck -S warning -x migrations/*.sh adopt/*.sh .github/scripts/*.sh template/.claude/hooks/*.sh
uvx --from actionlint-py actionlint .github/workflows/audit-template.yml
```

**Your data root stays out of it.** No audit sees `SYNTEK_DATA_ROOT`: `_common.sh` unsets it, the
runner starts every step without it, and a case that needs a root makes a temporary one holding its
own marker (D50). Never point a test at your real root.

**What the tools need.** Versions follow the README's [Requirements](README.md#requirements) and
the CI workflow:

| Tool | Needed for |
|---|---|
| bash, make, rsync, GNU diff | The runner, the renders and the floor comparison |
| git, with a user name and email set | Copier reads the template over git; the update, adoption and coexistence tests commit in scratch repositories |
| [uv](https://docs.astral.sh/uv/) (`uvx`) | Copier 9.12.0 or newer (the floor, `_min_copier_version` in `copier.yml`, is fetched as well), shellcheck (`shellcheck-py` 0.11.0.1 in CI) and actionlint |
| Python 3.14 or newer (CI uses 3.14) | Everything the audits run: Copier, the update script (`migrations/family-update.py`), the resolver, the permissions script, the hooks and the `tooling/` scripts, all on `python3`, which `_common.sh` refuses below 3.14; each script also refuses an older Python itself, with a warning that it did not run |
| Pandoc | `make docx` and the book builds in `tooling-smoke.sh` |
| XeLaTeX, with TeX Live's `xcolor`, `ulem` and `paracol` | `make pdf`, `make print` and `make compare` to PDF; CI does not install it, so run these locally or pass `--skip-pdf` |
| sqlite3 | The references database in renders that include it |
| A network connection | The first time `uvx` fetches each tool |

**Never commit rendered output.** Renders, logs and scratch projects go under a temporary
directory and stay there. `handoffs/` and `.code-review-graph/` are git-ignored; keep them so.

---

## Pull requests

- **Work on a branch from `main`**, named for its kind: `feat/…`, `fix/…`, `docs/…`, `chore/…`.
- **Commit subjects follow [Conventional Commits](https://www.conventionalcommits.org/)**:
  `feat(template): …`, `feat(migrations): …`, `test(audits): …`, `fix: …`, `docs: …`, `ci: …`,
  `chore(dev): …`. The scopes in use are `template`, `copier`, `migrations`, `resolver`, `audits`
  and `dev`. Name the decision in the body where one applies.
- **Add a `CHANGELOG.md` entry under `[Unreleased]`**, in the section that fits (Added, Changed,
  Fixed, Migration), citing the decision or section. A change to family-shared bytes says that
  companion templates must refresh them.
- **Do not bump the version.** `VERSION`, `CHANGELOG.md` and the `release` field of
  `family-shared.json` move together in the maintainer's release commit (`.claude/CLAUDE.md`
  Section 9).
- **Fill in the pull-request checklist**, and read the CI run rather than ticking the audit box
  by hand.
- We are a small studio and maintain this alongside client work, so a reply may take a while.

---

## Licence

syntek-author is released under the [MIT Licence](LICENSE), copyright (c) 2026 Sam Bailey t/a
Syntek. The licence covers the template, never the author's own writing in a generated project. A
project generated from the template need not carry the licence notice for the files it receives. A
file that carries its own licence keeps it: `tooling/harvard.csl`, the Cite Them Right Harvard
style from the Citation Style Language project that a project with references receives, is
licensed CC BY-SA 3.0 and keeps its licence block.

Contributions are made under the same terms: by opening a pull request you agree that your
contribution is licensed under the MIT Licence, with the permission above for generated projects
(inbound = outbound). There is no contributor licence agreement to sign and no copyright to
assign. If you contribute on behalf of an employer, make sure you have the right to do so.

---

## Reporting problems

- **A security vulnerability**: follow [`SECURITY.md`](SECURITY.md). Report it privately, never
  in a public issue or pull request.
- **A bug**: open an issue with the _Bug report_ form.
- **A change to the template**: open an issue with the _Template improvement_ form.
- **Conduct**: everyone taking part follows the [Code of Conduct](CODE_OF_CONDUCT.md), which says
  how to report a concern.
