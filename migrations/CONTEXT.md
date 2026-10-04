# CONTEXT.md — migrations/

The scripts `copier update` runs when a project crosses a release that moved something an author may have written in, or moved where a value the author set is read.
Copier only tracks what it generated: when a release renames or retires a folder, the update takes the template's own files to the new place and leaves the author's documents behind, in a folder nothing routes to, with no conflict and no error. When a release reads a setting from a new seed, the update writes that seed from the answers, and a value the author changed in the old place silently reverts.
A migration moves the files across, or carries the value, where exactly one result is correct, and reports everything else.
Nothing here ships: `_subdirectory: template` keeps this folder out of every generated project, and `copier.yml` runs each script from the template clone through `_copier_conf.src_path`.

## Directory Tree

```text
migrations/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for writing a migration
├── v0.2.0-business-families.sh       ← v0.1.0's six business family folders → the D39 families
└── v0.2.0-project-settings.sh        ← every variant: brief values the author changed → 00-project.md ## Brief (never over a fresh answer)
```

## What's here

- `v0.2.0-business-families.sh` — **business projects only.** v0.2.0 replaced `library/src/{proposals,contracts,policies,correspondence,finance,marketing}/` with the families chosen in `BUSINESS_FAMILIES` (DESIGN.md D39). The script moves every file an author created in an old folder to its D44 destination — `proposals` → `business`, `contracts` → `legal`, `policies` → `business` (or `msp-scp` when it is chosen), `correspondence` → `email` (`client-docs/` into `client-emails/`), `finance` → `accounting`, `marketing` → `social-media` — keeping sub-paths, so a kept example proposal lands in `library/src/business/drafts/example-proposal/`.
  It moves a file only into a family the update delivered (its `CONTEXT.md` is there), only where the destination is free, and never moves a git-ignored file to a path git would not ignore (D42). It reports every file it left, and every line in a tracked file that still names an old folder, with file and line.
  It also lists what the update itself lost or the author must decide: each old signpost the update deleted (edits included; the lines are recovered with `git show HEAD:<path>`), each moved client folder or template its new folder's `CONTEXT.md` does not name, and, worked out from the tree on every run, a client's `## Facts` left in `legal/` (v0.2.0 reads facts from `business/client-docs/`), a LaTeX letter under `email/` (a letter under an instrument is a legal type now), an email not yet in its `client-emails/<client>/<family>/` leaf, and the v0.1.0 family headings left in the planning seeds (`document-register.md`, `review-schedule.md`, `precedence.md`). It never overwrites, never deletes a file, is idempotent, and always exits `0`.
- `v0.2.0-project-settings.sh` — **every variant.** v0.2.0's skills read the audience, the reader test and the variant's answers (Bible translation; genre; trading name, voice, jurisdiction, currency) from `.claude/rules/syntek-author/00-project.md` `## Brief` alone (D40), a seed the update writes from the answers. v0.1.0 kept them current in `.claude/CLAUDE.md` Section 1, with the reader test also in `MEMORY.md`, the trading name in `standards/brand/disclaimers.md` and the style sheet's `## Project settings`. Where a `## Brief` bullet still reads the recorded answer and those files hold exactly one other value, the script writes that value into `## Brief` and prints the change; every other difference is listed with file and line. An answer the author gave **during the update itself** is never overwritten: where the recorded answer differs from the one in the answers file before the project crossed v0.2.0 (found in git history, so a run after the upgrade is committed decides the same), `## Brief` keeps it and each older value in those files, a hand edit or the old answer, is listed as a **conflict** with file and line.
  It then lists, never rewrites, each seed line that still gives v0.1.0's guidance — a numbered section of `.claude/CLAUDE.md` cited anywhere, 'eight files' and 'never edit them' in `.claude/CLAUDE.md`, the rules tree line in `CONTEXT.md` and `.claude/CONTEXT.md`, the rules line in `README.md`, the reader-test line in `MEMORY.md`, the trading-name pointer in `brand-voice.md` and 'change them here' in the style sheet — each with the v0.2.0 text that replaces it. It edits no file but `00-project.md`, reads no git-ignored file, is idempotent, and always exits `0`.
- **How each runs.** One `_migrations` entry per script in `copier.yml`, keyed by `version:` and run at `_stage == 'after'`. Copier runs it only when the update crosses that version, read from the template's git tags; an update to an untagged `HEAD` still numbered below the version does not run it, and a later update (choosing a family, say) does not run it again.
- **By hand.** The update's own copy of the template is deleted when the update ends, so each script ends by printing the command that runs it again from the project root: a clone of the release from the source in the answers file, then the script, `{ test -d "${TMPDIR:-/tmp}/syntek-author-v0.2.0" || git clone --depth 1 --branch v0.2.0 <source> "${TMPDIR:-/tmp}/syntek-author-v0.2.0"; } && bash "${TMPDIR:-/tmp}/syntek-author-v0.2.0"/migrations/<script>.sh`. `--help` prints its header.

## Cross-references

- `DESIGN.md` D44 — releases that move author work ship a migration; D39 — the business families; D40 — `00-project.md`; D42 — no tooling reads a git-ignored file; D26 — why names and numbers are frozen.
- `copier.yml` `_migrations` — the entries, and the house shape every script follows.
- `.github/scripts/update-test.sh` — renders a business project at the `v0.1.0` tag, plants author files in every old family folder, updates to the working tree tagged with `VERSION`, and proves each file moved and nothing was lost; renders each book variant at `v0.1.0`, edits the audience and the reader test in `.claude/CLAUDE.md` Section 1, updates while re-answering the reader test, and proves `## Brief` took the audience edit, kept the fresh reader test with the hand edit reported as a conflict, and a second run changes nothing.
- `README.md`, "Updating a project" — what an author sees when an update runs a migration.
