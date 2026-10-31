#!/usr/bin/env bash
#
# adopt.sh — prepare an existing writing repository for `copier copy` from syntek-author.
#
# WHY THIS EXISTS. There is no `copier adopt`. Adoption is a `copier copy` into the existing
# repository (README.md, "Adopting an existing repository"), in one of two modes:
#
#   MOVING (the default): `copier copy --overwrite`, after this script has made the moves with
#   one correct destination. The template takes over its own paths; the repository's layout
#   moves to the template's.
#   ADDITIVE (--additive, DESIGN.md D41): `copier copy --skip '*' --skip-tasks`, which keeps
#   EVERY existing file exactly as it is and moves nothing; the template's files are added
#   beside the repository's own, and `.claude/rules/syntek-author/00-project.md` tells the
#   template where this repository keeps things. For a repository with established
#   conventions — its own skills, governance, numbering — that should not be reorganised.
#   --skip-tasks also skips the copy-time task that records the render for the update report
#   (D52), so the first update renders the old version itself; the report says so.
#
# A copy can do two things safely: write files that are missing, and replace files the
# template owns. It cannot MOVE anything. An existing repository keeps its author work where its own
# conventions put it — handoffs under workspace/, a chapter's brief inside the chapter file,
# guides flat in docs/, procedures numbered in the series the template now owns — and a copy
# over the top leaves that work where nothing routes to it, or merges a bespoke procedure
# into the template's folder of the same number.
#
# ADVISORY BY DEFAULT. Without --apply it prints what it would do and changes nothing.
#
# WHAT --apply DOES — only the moves with exactly one correct destination (DESIGN.md
# Section 8):
#   1. workspace/handoffs/* and workspace/learning/*  -> handoffs/ and learning/
#   2. workspace/maps/*                               -> planning/src/maps/
#   3. standards/style/voice-and-tone.md              -> standards/style/voice-notes.md
#   4. books: a chapter file still at status idea, stub or outlined
#      (<content layer>/src/NN-slug/NN-slug.md)       -> planning/src/units/NN-slug.md
#   5. flat <layer>/docs/*.md guides                  -> <layer>/docs/project/
#   6. a bespoke <layer>/workflows/<name>/            -> <layer>/workflows/local/<name>/
#   7. frontmatter `status: stub`                     -> `status: outlined` (unit briefs)
#   8. the section sign in governance Markdown        -> 'Section' (never under */src/,
#                                                        handoffs/, learning/ or workspace/)
# An emptied folder's own CONTEXT.md and CLAUDE.md are never moved: the template ships its
# own pair at the destination, and hidden files are reported rather than moved.
#
# NEVER. It never overwrites — an existing destination is a COLLISION, reported and left
# alone — never deletes, never edits prose under */src/, and never touches .git/.
#
# REPORT ONLY — the author decides each:
#   - a chapter file that already holds prose (its brief is split out by hand, DESIGN.md D9)
#   - a workflow that is a template workflow under an older number
#   - a two-level manuscript (sections holding chapters), not supported in v0.1
#   - .claude/agents/, .claude/commands/, .claude/workflows/, .zed/ and stray root files
#   - a production-shaped standards/ and flat research/*.md notes
#   - seeds the copy will KEEP because they exist (read from copier.yml's _skip_if_exists), and
#     what each lacks against the template — including a .gitignore whose unanchored build/
#     line would keep .claude/skills/build/ out of git
#   - template files the copy will REPLACE (when run from a clone that holds template/)
#   - an .agents that Copier cannot copy over (a real .agents/skills folder, or .agents itself
#     a link or a file), with the --exclude the printed copy command then carries; for an
#     .agents link to a folder outside the repository, the printed copy is wrapped in the two
#     mv lines that hold the link aside and put it back (never run by this script)
#   - how-to/ (DESIGN.md D56): how-to that is a file or a link (the copy would stop or write
#     through it), the repository's own files at the user guide's paths, and its other files
#     under how-to/
#
# THE DATA ROOT, both modes (DESIGN.md Section 8, D50). A fresh copy keeps binary files outside
# the repository (DATA_STORE external), but an adopted repository usually tracks its scans,
# figures and issued copies, so every copy command printed here passes --data DATA_STORE=repo
# and they stay in Git until the owner opts in — unless another syntek template's answers
# file here already records a store: the copy must take that one (copier.yml refuses a first
# answer that differs from the sibling's), so the command passes none, and the report says
# which file records what. The report also names every file of the repository's own at a path
# where a data-root ignore file would land (read from copier.yml's _exclude), a kept
# .claude/settings.json that does not wire the data-root guard, the MCP servers a kept .mcp.json
# or client file gains (D54) and a git-ignored one that nothing ever reads, and, for business,
# a kept Drive workflow in the DATA_PROVIDER wording (D53).
#
# Idempotent: a second --apply finds nothing left to move and reports only what still needs
# the author.
#
# --additive: REPORT ONLY, never --apply. It renders the template for this kind (with the
# answers file given by --answers, or the defaults) into a temporary folder and compares it
# with the repository, then names:
#   - the template source and ref it previewed: the copy must use the same, or the report is
#     not exact (a local clone at HEAD and a published tag can differ);
#   - what the copy will ADD (per folder) and what it will KEEP (every file at a template path),
#     each kept file marked 'kept, committed', 'kept, staged', 'kept, untracked' or 'kept,
#     ignored', so a file left from an earlier copy (the template's, not the repository's) is
#     seen before the copy keeps it as the repository's own;
#   - every same-named file: one the copy adds beside the repository's own file of that name in
#     a neighbouring folder of the same tree (its parent, a sibling or a child), such as the
#     template's library/docs/reference/X-standards.md beside the repository's
#     library/docs/X-standards.md, with the `## Overrides` redirect line that points every
#     template file at the repository's copy (D40);
#   - every template path the repository's ignore rules hide (git check-ignore, with the
#     matching source:line:pattern): git never commits it, and the next copier update deletes
#     it — an unanchored build/ hides .claude/skills/build/ this way — or replaces a kept file
#     of the repository's own there with the template's (an ignored seed is listed, as safe);
#   - every kept file at a family's or an option's path (read from copier.yml's _exclude
#     gates): unticking that family or turning that option off later deletes it;
#   - every kept .claude/skills/<name>/SKILL.md beside which the template writes a mode file:
#     the mode file is INERT unless that SKILL.md carries the Mode paragraph (D41);
#   - every kept index file (CONTEXT.md) whose folder gains template entries it does not name,
#     to be extended by hand, and every kept workflows/CONTEXT.md without the
#     'You want to… | Procedure' table (run-workflow then lists the folders directly);
#   - every template CONTEXT.md, CLAUDE.md or README.md added to a folder that already holds
#     the repository's own files, to check against its layout;
#   - two workflows that will share a number in one layer (cite each by full folder name);
#   - business: a kept google-drive-*.yml workflow, in the DATA_PROVIDER wording (D53), and a
#     kept workflow that syncs library/src/ without knowing the drafts/ folders the copy adds
#     (D37);
#   - the data root and the MCP servers, as above;
#   - the settings file the copy writes, `.claude/rules/syntek-author/00-project.md`.
# The preview meets the same peer rule as the copy: every other syntek template's answers file
# is copied into the preview folder before it renders, and it renders into a folder of this
# repository's own name (DATA_SLUG's default reads it). A DATA_STORE that the --answers file
# records is the copy's (--data would override it), so no --data DATA_STORE is printed then.
# Run it before the copy to preview, and after it to see what is left to extend.
#
# Requirements: bash 4+, find, awk; perl for step 8; git for --apply; uvx (or copier) and
# git for --additive; python3 to name the MCP servers (otherwise the report names none). No
# network, except uvx's first run.
#
# Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]
#        adopt.sh --kind theology|fiction|business --additive [--answers FILE] [TARGET]
#        TARGET defaults to the current directory. theology.sh, fiction.sh and business.sh
#        beside this script are this script with --kind filled in.
#
# Exit codes:  0 = report printed (and, with --apply, every safe move made)
#              1 = --apply: one or more moves failed and were left where they were
#              2 = usage error, --apply refused (not a git work tree, on main/master, or how-to
#                  a link or a file), or --additive could not render the template (no Copier, a
#                  bad answers file)

set -euo pipefail
shopt -s nullglob

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMPLATE_DIR="$SCRIPT_DIR/../template"

usage() {
  cat <<'EOF'
Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]
       adopt.sh --kind theology|fiction|business --additive [--answers FILE] [TARGET]

Moving adoption (the default): reports (or, with --apply, makes) the moves an existing
writing repository needs before `uvx --python '>=3.14' copier copy --trust --overwrite
--data-file <answers> --data SEED_EXAMPLES=false --data DATA_STORE=repo
gh:Syntek-Dev/syntek-author .` can adopt it. Advisory unless --apply is given. Never
overwrites, never deletes.

Both modes keep your binary files in Git (--data DATA_STORE=repo), unless another syntek
template's answers file here records a store: the copy then takes that one, and passes none.

Additive adoption (--additive, report only): what `uvx --python '>=3.14' copier copy
--trust --skip '*' --skip-tasks --data-file <answers> --data SEED_EXAMPLES=false <template> .`
will add and keep, the template paths your ignore rules hide, your files that unticking a
family or turning an option off would delete, the mode files it writes beside skills you keep
(inert), the files of yours with a template file's name in a neighbouring folder (and the
## Overrides redirect for each), whether each kept file is committed, untracked or ignored,
and the index files to extend by hand. It previews this clone at HEAD and prints that source
and ref: copy from the same. --answers names the answers file the copy will use.

TARGET defaults to the current directory.
EOF
}

die() { printf 'adopt.sh: %s\n' "$*" >&2; exit 2; }

KIND=""
APPLY=0
ADDITIVE=0
ANSWERS=""
TARGET="."
while [ $# -gt 0 ]; do
  case "$1" in
    --kind)
      [ $# -ge 2 ] || die "--kind needs a value: theology, fiction or business"
      KIND=$2
      shift 2
      ;;
    --kind=*) KIND=${1#--kind=}; shift ;;
    --apply) APPLY=1; shift ;;
    --additive) ADDITIVE=1; shift ;;
    --answers)
      [ $# -ge 2 ] || die "--answers needs a file"
      ANSWERS=$2
      shift 2
      ;;
    --answers=*) ANSWERS=${1#--answers=}; shift ;;
    -h | --help) usage; exit 0 ;;
    -*) die "unknown option: $1 (try --help)" ;;
    *) TARGET=$1; shift ;;
  esac
done

case "$KIND" in
  theology | fiction) CONTENT=manuscript; BOOK=1 ;;
  business) CONTENT=library; BOOK=0 ;;
  "") die "--kind is required: theology, fiction or business" ;;
  *) die "unknown kind '$KIND': use theology, fiction or business" ;;
esac

[ -d "$TARGET" ] || die "no such directory: $TARGET"
if [ -n "$ANSWERS" ]; then
  [ -f "$ANSWERS" ] || die "no such answers file: $ANSWERS"
  ANSWERS=$(cd "$(dirname "$ANSWERS")" && pwd)/$(basename "$ANSWERS")
  [ "$ADDITIVE" -eq 1 ] || die "--answers is read by --additive only; the moving report needs no answers"
fi
if [ "$ADDITIVE" -eq 1 ] && [ "$APPLY" -eq 1 ]; then
  die "--additive moves nothing, so it takes no --apply: the copy adds the template beside your files"
fi
cd "$TARGET"

if [ -f copier.yml ] && [ -d template ]; then
  die "this is the template repository; run from the repository you are adopting"
fi

if [ "$APPLY" -eq 1 ]; then
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || die "--apply needs a git work tree, so that git diff can show every move"
  BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)
  case "$BRANCH" in
    main | master) die "--apply will not run on '$BRANCH': git switch -c adopt-syntek-author first" ;;
  esac
  # The user guide (DESIGN.md D56): a copy stops on how-to as a file or a link outside the
  # repository, and writes the guide through a link inside it, so nothing is moved before then.
  if [ -L how-to ] || { [ -e how-to ] && [ ! -d how-to ]; }; then
    die "how-to is a link or a file, not a folder: a copy would stop, or write the user guide through it. Make it a real folder first (with the author); --apply moved nothing."
  fi
fi

MOVED=0
WOULD=0
COLLIDED=0
FAILED=0
NOTES=0
EDITED=0

heading() { printf '\n▸ %s\n' "$1"; }
item() { printf '  %-11s %s\n' "$1" "$2"; }
note() { item report "$1"; NOTES=$((NOTES + 1)); }

# The .agents folder (DESIGN.md D47, Section 3.6). The template ships a REAL .agents/ holding
# a `skills -> ../.claude/skills` link and mcp_config.json, both copy-only: an existing
# .agents/skills link (of any target) or mcp_config.json is skipped, so a project that already
# has this layout, such as one generated by syntek-media 0.4.2, needs no exclusion (proved by
# render under Copier 9.17.1, 14/10/2026). Copier fails before its skip check in two shapes,
# so every copy command this script prints excludes the path there:
#   - .agents/skills is a real folder or a file (a link would land on it): --exclude /.agents/skills;
#   - .agents itself is a link or a file, as in the retired `.agents -> .claude` layout:
#     --exclude /.agents (a copy would otherwise write through the link into .claude/).
# A third shape fails even with that exclusion: an .agents link that resolves OUTSIDE the
# repository. Copier refuses every destination beneath it before it reads --exclude, so the
# link alone is moved aside for the copy and put back after it (DESIGN.md Section 3.6, D48):
#   mv .agents .agents.syntek-held, the copy with --exclude /.agents, mv .agents.syntek-held .agents
# The exclusion matters: without it the copy writes a real .agents/ folder, and the second mv
# would put the link inside it. Updates hold and restore the link themselves (the unversioned
# migrations/agents-outside-link.py pair); a copy runs no migration.
# Nothing is ever renamed, moved or removed; the report says what to do by hand, and for the
# retired link that is to replace it with the real folder before the copy (README.md).
AGX=""
AGHOLD=""
AGBACK=""
agents_outside() { # 0 when .agents is a link that resolves outside the current directory
  # Resolved as the migration resolves it (Python's realpath), so a link whose target is
  # missing, as in a fresh clone without the agent tree beside it, still counts: Copier
  # resolves the destinations beneath it the same way and refuses them.
  local root real
  [ -L .agents ] || return 1
  root=$(pwd -P)
  real=$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' .agents 2>/dev/null) \
    || real=$(realpath -m .agents 2>/dev/null) || real=$(readlink -f .agents 2>/dev/null) || return 1
  case "$real" in "$root" | "$root"/*) return 1 ;; esac
  return 0
}
# A copy command as printed: $1 = the indent of its continuation lines, $2 = the command. Where
# .agents links outside, the command is wrapped in the two mv lines.
copy_cmd() {
  if [ -n "$AGHOLD" ]; then printf '%s\n%s%s\n%s%s' "$AGHOLD" "$1" "$2" "$1" "$AGBACK"
  else printf '%s' "$2"; fi
}
agents_exclude() {
  AGX=""; AGHOLD=""; AGBACK=""
  if [ -L .agents ] || { [ -e .agents ] && [ ! -d .agents ]; }; then
    AGX=" --exclude /.agents"
    if agents_outside; then
      AGHOLD="mv .agents .agents.syntek-held"; AGBACK="mv .agents.syntek-held .agents"
      note ".agents is a link to $(readlink .agents), outside the repository: Copier refuses everything beneath it, even with --exclude. The copy below is wrapped to move the link alone aside and put it back, from the repository root: $AGHOLD, then the copy with --exclude /.agents, then $AGBACK. Its target is never touched. If the copy stops, run $AGBACK before anything else. Later updates hold and restore the link themselves."
    elif [ -L .agents ] && [ "$(readlink .agents)" = .claude ]; then
      note ".agents is a link to .claude, a retired layout that makes every sandboxed Codex command fail on Linux, and a copy would write through it. Before the copy, with the author, replace it with a real folder (rm .agents; mkdir .agents; ln -s ../.claude/skills .agents/skills; and git mv .claude/mcp_config.json .agents/ if that file exists), then run this report again. Until then the copy below excludes it (--exclude /.agents)."
    else
      note ".agents is not a folder: the copy below excludes it (--exclude /.agents). Keep it; set up the agents folder by hand with the author (.claude/syntek-author-agents.md, 'Enabling a client in an existing project')."
    fi
  elif [ -d .agents ]; then
    if [ -e .agents/skills ] && [ ! -L .agents/skills ]; then
      AGX=" --exclude /.agents/skills"
      note ".agents/skills is a real folder or file: the copy below excludes the template's skills link there (--exclude /.agents/skills). Keep it; with the author, either move its skills into .claude/skills and replace it with a link to ../.claude/skills, or leave it, and other clients will not see .claude/skills."
    elif [ -L .agents/skills ] && [ "$(readlink .agents/skills)" != ../.claude/skills ]; then
      note ".agents/skills links to $(readlink .agents/skills), not ../.claude/skills: the copy keeps it, so clients other than Claude Code will not see the template's skills until it points at ../.claude/skills."
    fi
    # The template's own bytes are read, never typed: since D54 they declare the MCP servers,
    # so a companion's older, empty file is now one the copy keeps (and adds the servers to).
    if [ -f .agents/mcp_config.json ] && ! cmp -s .agents/mcp_config.json "$TEMPLATE_DIR/.agents/mcp_config.json"; then
      item kept ".agents/mcp_config.json (yours already: the copy never overwrites it)"
    fi
  fi
  return 0
}

# ── Template knowledge ────────────────────────────────────────────────────────
# The workflow and reference-guide names of DESIGN.md Section 4.4, across every variant,
# unioned with whatever the template tree beside this script holds. A name from another
# variant can only matter if the adopted repository already has it, so the union is safe.

tpl_workflows() {
  case "$1" in
    manuscript) printf '%s' "01-draft-a-section 02-adapt-a-draft 03-improve-your-draft 04-promote-a-section 05-review-a-chapter 06-build-a-proof 07-learn-from-your-edits 10-steelman-the-objections" ;;
    library) printf '%s' "01-draft-a-section 02-adapt-a-draft 03-improve-your-draft 04-promote-a-section 05-review-a-document 06-build-a-proof 07-learn-from-your-edits 08-ingest-an-existing-document 10-create-a-business-document 11-create-a-legal-document 12-write-an-email 13-create-an-accounting-document 14-create-a-social-media-document 15-create-an-msp-scp-document" ;;
    planning) printf '%s' "01-plan-a-unit 02-map-the-argument 03-chart-the-causality 04-chart-a-character-arc 05-design-a-quest 06-run-a-review-cycle 07-record-an-approval 08-update-the-register 09-review-the-whole-work" ;;
    research) printf '%s' "01-ingest-a-source 02-verify-a-claim 03-map-a-contested-reading 05-handle-testimony-safely" ;;
    proposal) printf '%s' "01-assemble-the-proposal 02-approach-a-reader 03-update-the-tracker" ;;
    world) printf '%s' "01-create-a-character 02-create-a-place 03-name-something 04-create-a-creature 05-create-a-culture 06-build-a-language 07-add-a-word 08-design-a-script 09-record-a-pronunciation" ;;
  esac
  local d
  for d in "$TEMPLATE_DIR/$1"/workflows/[0-9][0-9]-*/; do
    d=${d%/}
    printf ' %s' "${d##*/}"
  done
}

tpl_guides() {
  case "$1" in
    manuscript) printf '%s' "section-anatomy.md drafting-with-ai.md the-status-ladders.md main-text-and-footnotes.md scene-craft.md" ;;
    library) printf '%s' "section-anatomy.md drafting-with-ai.md the-status-ladders.md document-anatomy.md latex-deliverables.md versioning-and-the-register.md business-standards.md legal-standards.md email-standards.md accounting-standards.md social-media-standards.md msp-scp-standards.md" ;;
    planning) printf '%s' "unit-briefs.md reviews-are-advice.md decision-maps.md argument-maps.md causality-chains.md character-arcs.md quest-design.md the-document-register.md" ;;
    research) printf '%s' "ingesting-sources.md vetting-evidence.md contested-readings.md real-world-detail.md handling-testimony.md" ;;
    proposal) printf '%s' "book-proposal-anatomy.md query-package-anatomy.md comp-titles.md approaching-readers.md" ;;
    world) printf '%s' "story-bible.md naming.md creatures.md cultures.md building-a-language.md lexicon-format.md writing-systems.md pronunciation.md" ;;
  esac
  local f
  for f in "$TEMPLATE_DIR/$1"/docs/reference/*.md; do
    printf ' %s' "${f##*/}"
  done
}

# Seeds: READ from the _skip_if_exists list of the copier.yml beside this script (DESIGN.md
# Section 3.1), never typed here. A hand-kept copy drifted by fifteen entries and told authors
# their proposal stubs, page design and book.tex would be REPLACED, which Copier never does.
# The leading slash of each anchored pattern is dropped; a templated entry (one holding a
# block) is skipped, because only Copier can evaluate it. Run from a clone without copier.yml
# (not a supported layout), the list is empty and the report says so.
COPIER_YML="$SCRIPT_DIR/../copier.yml"
read_seeds() { # $1 = copier.yml → one seed path per line
  awk '
    /^_skip_if_exists:/ { on = 1; next }
    on && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
    on && /^[[:space:]]*#/ { next }
    on && /^[[:space:]]+- / {
      s = $0
      sub(/^[[:space:]]+- /, "", s); sub(/[[:space:]]+#.*$/, "", s)
      gsub(/["\047]/, "", s); sub(/[[:space:]]+$/, "", s)
      if (s ~ /<:/) next
      sub(/^\//, "", s)
      if (s != "") print s
    }' "$1"
}
SEEDS=""
if [ -f "$COPIER_YML" ]; then
  SEEDS=$(read_seeds "$COPIER_YML" | tr '\n' ' ')
fi

in_words() { case " $2 " in *" $1 "*) return 0 ;; esac; return 1; }
is_seed() { in_words "$1" "$(printf '%s' "$SEEDS" | tr '\n' ' ')"; }

# The gates an update can CLOSE: READ from the "<: if not (GATE) :>/path<: endif :>" lines of
# copier.yml's _exclude (DESIGN.md Section 3.5), never typed here. One "<what closes it>\t<path>"
# per line whose gate names a family of BUSINESS_FAMILIES or an INCLUDE_* option: unticking
# that family, or turning that option off, on a later `copier update` deletes every file at
# the path, whoever wrote it. DOC_TYPE never changes (D35), so a DOC_TYPE-only gate is left
# out, and so are the seed-once examples (never rendered on an adoption). INCLUDE_CONLANG's
# question is asked only with INCLUDE_WORLDBUILDING, so turning that off takes the kit too.
read_gates() { # $1 = copier.yml → "<what closes it>\t<path>" per line
  awk '
    /^_exclude:/ { on = 1; next }
    on && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
    on && /^[[:space:]]+- "<: if not \(/ {
      s = $0
      sub(/^[[:space:]]+- "<: if not \(/, "", s)
      i = index(s, ") :>/")
      if (i == 0) next
      gate = substr(s, 1, i - 1); p = substr(s, i + 5)
      sub(/<: endif :>".*$/, "", p)
      t = ""; g = gate
      while (match(g, /\047[a-z-]+\047 in BUSINESS_FAMILIES/)) {
        f = substr(g, RSTART + 1, RLENGTH); sub(/\047.*$/, "", f)
        t = t (t == "" ? "" : " or ") "unticking " f " in BUSINESS_FAMILIES"
        g = substr(g, RSTART + RLENGTH)
      }
      g = gate
      while (match(g, /INCLUDE_[A-Z_]+/)) {
        o = substr(g, RSTART, RLENGTH)
        t = t (t == "" ? "" : " or ") "turning " o " off"
        if (o == "INCLUDE_CONLANG") t = t " (or INCLUDE_WORLDBUILDING, which takes the conlang kit with it)"
        g = substr(g, RSTART + RLENGTH)
      }
      if (t != "" && p != "") print t "\t" p
    }' "$1"
}

# Whether the moving copy would write each template path, from the same _exclude lines: every
# "<: if not (GATE) :>/path<: endif :>" ships the path only when GATE holds, and every generated
# mode-file line "<: if DOC_TYPE != 'x' :>/path<: endif :>" only for x. One "<ships when>\t<path>"
# per line (the path without its leading /).
read_ship_gates() { # $1 = copier.yml
  awk '
    /^_exclude:/ { on = 1; next }
    on && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
    on && /^[[:space:]]+- "<: if not \(/ {
      s = $0
      sub(/^[[:space:]]+- "<: if not \(/, "", s)
      i = index(s, ") :>/")
      if (i == 0) next
      gate = substr(s, 1, i - 1); p = substr(s, i + 5)
      sub(/<: endif :>".*$/, "", p)
      if (p != "") print gate "\t" p
      next
    }
    on && /^[[:space:]]+- "<: if DOC_TYPE != \047[a-z]+\047 :>\// {
      s = $0
      sub(/^[[:space:]]+- "<: if DOC_TYPE != \047/, "", s)
      k = s; sub(/\047.*$/, "", k)
      p = s; sub(/^[a-z]+\047 :>\//, "", p); sub(/<: endif :>".*$/, "", p)
      if (p != "") print "DOC_TYPE == \047" k "\047\t" p
    }' "$1"
}
# $1 = copier.yml, $2 = the kind, $3 = the store the printed copy takes; template paths on
# stdin → "ships\tpath", "closed\tpath" (the kind or the store never ships it) or
# "only\tpath\t<the rest of its gate>" (it ships only if the answers open that).
ship_verdicts() {
  awk -v kind="$2" -v store="$3" '
    BEGIN { FS = "\t" }
    FILENAME == ARGV[1] { cond[++n] = $1; gp[n] = $2; next }
    {
      p = $0; closed = 0; rest = ""
      for (i = 1; i <= n; i++) {
        if (!(p == gp[i] || index(p, gp[i] "/") == 1)) continue
        c = cond[i]
        if (match(c, /^DOC_TYPE (==|!=) \047[a-z]+\047/)) {
          t = substr(c, 1, RLENGTH); after = substr(c, RLENGTH + 1)
          if (after == "" || after ~ /^ and /) {
            k = t; sub(/^DOC_TYPE (==|!=) \047/, "", k); sub(/\047$/, "", k)
            if ((t ~ /==/) != (k == kind)) { closed = 1; break }
            c = after; sub(/^ and /, "", c)
          }
        }
        m = split(c, term, " and "); keep = ""
        for (j = 1; j <= m; j++) {
          x = term[j]
          if (store != "" && x ~ /^\(?DATA_STORE( \| default\(\047[a-z]+\047\))?\)? == \047[a-z]+\047$/) {
            v = x; sub(/^.*== \047/, "", v); sub(/\047$/, "", v)
            if (v != store) { closed = 1; break }
            continue
          }
          keep = keep (keep == "" ? "" : " and ") x
        }
        if (closed) break
        if (keep != "") rest = rest (rest == "" ? "" : " and ") keep
      }
      if (closed) print "closed\t" p
      else if (rest != "") print "only\t" p "\t" rest
      else print "ships\t" p
    }' <(if [ -f "$1" ]; then read_ship_gates "$1"; fi) -
}

# ── The data root (DESIGN.md Section 8, D50) ──────────────────────────────────
# A fresh copy defaults DATA_STORE to external, but an adopted repository usually tracks its
# binaries, so every printed copy passes --data DATA_STORE=repo. Not where another syntek
# template's answers file here already records a store: copier.yml's DATA_STORE takes the
# sibling's (_external_data.peer) as the first answer's default and refuses any other, so the
# copy passes none and the report names the file. "Records" is the validator's own test: the
# key holds a value. The peer's file name and the data-root ignore files are READ from
# copier.yml, never typed here: the ignore files are the _exclude lines gated on the external
# store, and a DOC_TYPE test in their gate says which kind can receive each.
read_peer() { # $1 = copier.yml → the sibling answers file _external_data.peer names
  awk '
    /^_external_data:/ { on = 1; next }
    on && /^[^[:space:]#]/ { exit }
    on && /^[[:space:]]+peer:/ {
      s = $0
      sub(/^[[:space:]]+peer:[[:space:]]*/, "", s); sub(/[[:space:]]+#.*$/, "", s)
      gsub(/["\047]/, "", s); sub(/[[:space:]]+$/, "", s)
      print s; exit
    }' "$1"
}
read_dataroot_ignores() { # $1 = copier.yml → "<gate>\t<path>" per data-root ignore file
  awk '
    /^_exclude:/ { on = 1; next }
    on && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
    on && /^[[:space:]]+- "<: if not \(/ {
      s = $0
      sub(/^[[:space:]]+- "<: if not \(/, "", s)
      i = index(s, ") :>/")
      if (i == 0) next
      gate = substr(s, 1, i - 1); p = substr(s, i + 5)
      sub(/<: endif :>".*$/, "", p)
      if (gate ~ /DATA_STORE == \047external\047/ && p ~ /(^|\/)\.gitignore$/) print gate "\t" p
    }' "$1"
}
answer_of() { # $1 = key, $2 = a Copier answers file → its value, unquoted; empty if none
  awk -v k="$1" '
    index($0, k ":") == 1 {
      s = substr($0, length(k) + 2)
      sub(/\r$/, "", s); sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+#.*$/, "", s); sub(/[[:space:]]+$/, "", s)
      if (s ~ /^".*"$/ || s ~ /^\047.*\047$/) s = substr(s, 2, length(s) - 2)
      if (s == "~" || s == "null") s = ""
      print s; exit
    }' "$2" 2>/dev/null
}

# Both modes. An unanchored `build/` (or `build`) also ignores .claude/skills/build/, so the
# proof skill every variant needs is never committed (the template's own seed writes /build/).
BUILD_UNANCHORED=".gitignore ignores every folder named build, including .claude/skills/build/; change it to /build/"
build_unanchored() { [ -f .gitignore ] && grep -Eq '^[[:space:]]*build/?[[:space:]]*$' .gitignore; }

# NUL-separated paths on stdin → "path<TAB>source:line:pattern" for each one git ignores. NUL
# both ways, as tooling/provenance.py reads it (source, line, pattern, path per match); a
# pattern opening with ! is a negation that re-includes the path, so it is not reported.
# git never reports a tracked file, so a kept file printed here is untracked too.
ignored_paths() {
  local src ln pat p
  { git check-ignore --stdin -z --verbose 2>/dev/null || true; } |
    while IFS= read -r -d '' src && IFS= read -r -d '' ln && IFS= read -r -d '' pat && IFS= read -r -d '' p; do
      case "$pat" in '!'*) continue ;; esac
      printf '%s\t%s:%s:%s\n' "$p" "$src" "$ln" "$pat"
    done
}

join_and() { # words → "a", "a and b", "a, b and c"
  local out="" i
  for ((i = 1; i <= $#; i++)); do
    if [ "$i" -eq 1 ]; then out=${!i}; elif [ "$i" -eq $# ]; then out="$out and ${!i}"; else out="$out, ${!i}"; fi
  done
  printf '%s' "$out"
}

if [ "$BOOK" -eq 1 ]; then
  LAYERS="$CONTENT planning research proposal"
  [ "$KIND" = fiction ] && LAYERS="$LAYERS world"
else
  LAYERS="$CONTENT planning research"
fi

PEER=""
STORE_ASKED=0
DR_IGNORES=""
if [ -f "$COPIER_YML" ]; then
  PEER=$(read_peer "$COPIER_YML")
  grep -q '^DATA_STORE:' "$COPIER_YML" && STORE_ASKED=1
  while IFS=$'\t' read -r t p; do
    case "$t" in
      *"DOC_TYPE == 'business'"*) [ "$BOOK" -eq 0 ] || continue ;;
      *"DOC_TYPE != 'business'"*) [ "$BOOK" -eq 1 ] || continue ;;
    esac
    DR_IGNORES="$DR_IGNORES $p"
  done < <(read_dataroot_ignores "$COPIER_YML")
fi
# Every other syntek template's answers file here; the additive preview copies them all in.
SIBLINGS=()
for f in .copier-answers.syntek-*.yml; do
  [ "$f" != .copier-answers.syntek-author.yml ] && [ -f "$f" ] && SIBLINGS+=("$f")
done
# STORE_DATA is what every printed copy carries; STORE the store that copy records; STORE_FROM
# the file it comes from (empty for the repo this script passes).
STORE_DATA=""
STORE=""
STORE_FROM=""
if [ "$STORE_ASKED" -eq 1 ]; then
  STORE_DATA=" --data DATA_STORE=repo"; STORE=repo
  for f in "${SIBLINGS[@]}"; do
    v=$(answer_of DATA_STORE "$f")
    [ -n "$v" ] || continue
    STORE_DATA=""
    # Copier reads the peer alone, so its store is the one the copy takes.
    if [ -z "$STORE_FROM" ] || [ "$f" = "$PEER" ]; then STORE=$v; STORE_FROM=$f; fi
  done
  # An --answers file that records a store is the copy's own answer: --data would override it.
  if [ -n "$ANSWERS" ]; then
    v=$(answer_of DATA_STORE "$ANSWERS")
    if [ -n "$v" ]; then
      if [ -n "$PEER" ] && [ "$STORE_FROM" = "$PEER" ] && [ "$v" != "$STORE" ]; then
        die "$ANSWERS records DATA_STORE $v, but $PEER records $STORE: one project keeps one store, so the copy would be refused. Remove DATA_STORE from $ANSWERS (the other template's store then applies), or change that template's answer first"
      fi
      STORE_DATA=""; STORE=$v; STORE_FROM=$ANSWERS
    fi
  fi
fi
is_dataroot_ignore() { in_words "$1" "$DR_IGNORES"; }

# The MCP servers (D54) and the files they are added to, READ from the refresh data the update
# script uses (migrations/family-refresh.json, its "mcp" key). Without python3 the list is empty
# and the report says nothing about them.
MCP_SERVERS=""
MCP_FILES=()
if [ -f "$SCRIPT_DIR/../migrations/family-refresh.json" ] && command -v python3 >/dev/null 2>&1; then
  mapfile -t MCP_FILES < <(python3 -I - "$SCRIPT_DIR/../migrations/family-refresh.json" 2>/dev/null <<'PY' || true
import json, sys
m = (json.load(open(sys.argv[1], encoding="utf-8")) or {}).get("mcp") or {}
s, f = m.get("servers"), m.get("files")
if isinstance(s, list) and s and isinstance(f, dict) and f:
    print(" ".join(str(x) for x in s))
    for k in sorted(f):
        print(k)
PY
  )
  if [ "${#MCP_FILES[@]}" -gt 1 ]; then
    read -r -a mcp_names <<<"${MCP_FILES[0]}"
    MCP_SERVERS=$(join_and "${mcp_names[@]}")
    MCP_FILES=("${MCP_FILES[@]:1}")
  else
    MCP_FILES=()
  fi
fi

# The top-level values the template offers a kept settings.json (D29, D51, D60), READ from the
# same refresh data's "settings" (each scalar key, with its value as JSON). Without python3 or
# the file, the three the seed sets: the two the handoff hooks assume, both false, and the house
# output style.
TOP_VALUES=()
if [ -f "$SCRIPT_DIR/../migrations/family-refresh.json" ] && command -v python3 >/dev/null 2>&1; then
  mapfile -t TOP_VALUES < <(python3 -I - "$SCRIPT_DIR/../migrations/family-refresh.json" 2>/dev/null <<'PY' || true
import json, re, sys
s = (json.load(open(sys.argv[1], encoding="utf-8")) or {}).get("settings") or {}
for k, v in (s.items() if isinstance(s, dict) else []):
    if isinstance(v, (bool, int, float, str)) and re.fullmatch(r"[A-Za-z0-9_]+", k):
        print("%s\t%s" % (k, json.dumps(v)))
PY
  )
fi
[ "${#TOP_VALUES[@]}" -gt 0 ] || TOP_VALUES=($'autoCompactEnabled\tfalse' $'idleCompaction\tfalse' $'outputStyle\t"Concise"')

# What git holds of a path, from the in_head and in_index sets additive_report fills: committed,
# staged (in the index, not yet in a commit), ignored or untracked; empty outside git.
kept_state() { # $1 = path
  [ "${in_git:-0}" -eq 1 ] || return 0
  if [ -n "${in_head[$1]:-}" ]; then echo committed
  elif [ -n "${in_index[$1]:-}" ]; then echo staged
  elif git check-ignore -q -- "$1" 2>/dev/null; then echo ignored
  else echo untracked; fi
}

# A template file as this clone holds it, for a report line that says where to copy from.
tpl_file() { # $1 = path in the template
  local d
  if d=$(cd "$TEMPLATE_DIR" 2>/dev/null && pwd); then printf '%s/%s' "$d" "$1"; else printf "the template's %s" "$1"; fi
}

# The data root, both modes (DESIGN.md Section 8, D50): the store the printed copy records,
# every sibling's, what the external store means for an adopted repository, every file of the
# repository's own where a data-root ignore file would land, and the guard a kept settings.json
# never gains. No line here holds the words of a copy command, which adopt-test.sh reads.
dataroot_report() { # $1 = moving or additive
  local f v m p
  [ "$STORE_ASKED" -eq 1 ] || return 0
  heading "The data root — where this repository's binary files are kept (DESIGN.md D50)"
  if [ -n "$STORE_DATA" ]; then
    m="the copy below passes --data DATA_STORE=repo, so your binary files (scans, figures, recordings, issued copies) stay in Git as they are, where a fresh copy would keep them outside the repository, under a data root (DATA_STORE external)"
    if [ "$1" = moving ]; then
      m="$m. It wins over a DATA_STORE in your answers file: to start under external instead, leave it out and answer DATA_STORE: external there"
    else
      m="$m. To start under external instead, answer DATA_STORE: external in your answers file and run this report again with --answers: the copy then takes your answer"
    fi
    note "$m. To move them out later, answer DATA_STORE=external on a copier update: it moves nothing, and make files-plan then lists what to file (.claude/rules/syntek-author/09-data-root.md, once the copy has written it)"
  elif [ -n "$ANSWERS" ] && [ "$STORE_FROM" = "$ANSWERS" ]; then
    note "$ANSWERS records DATA_STORE $STORE: the copy takes it, so the command below passes no DATA_STORE"
  fi
  for f in "${SIBLINGS[@]}"; do
    v=$(answer_of DATA_STORE "$f")
    if [ -z "$v" ]; then
      note "$f records no DATA_STORE (that template predates the data root): this copy records ${STORE:-repo}, and that template takes it when its own update first asks DATA_STORE"
      continue
    fi
    case "$v" in
      external | repo) ;;
      *) note "$f records DATA_STORE $v, a store this template does not offer: the copy is refused until that template records external or repo"; continue ;;
    esac
    m="$f records DATA_STORE $v: one project keeps one store, so the copy below passes no DATA_STORE and takes $v from it"
    [ "$v" != external ] || m="$m, with that template's data-root layout (DATA_AREA, DATA_SLUG and the four DATA_KIND_* folders)"
    if [ "$STORE_FROM" != "$ANSWERS" ] || [ -z "$ANSWERS" ]; then
      m="$m. An answers file must not answer them otherwise, or the copy is refused: if yours holds DATA_STORE: repo, as the example does, delete that line"
    fi
    if [ -n "$PEER" ] && [ "$f" != "$PEER" ]; then
      m="$m. This template reads only $PEER for that default, so give the copy --data DATA_STORE=$v yourself"
    fi
    note "$m"
  done
  if [ "$STORE" = external ]; then
    note "under DATA_STORE external the copy delivers the data-root ignore files and moves nothing: every binary git already tracks stays tracked until you file it. After the copy, name the data root on each machine in SYNTEK_DATA_ROOT and run make files-plan, which lists what to file (.claude/rules/syntek-author/09-data-root.md)"
  fi
  # A file of the repository's own at a data-root ignore path (R4 Section 1.7): kept under repo,
  # but the template's arrives there under external.
  for p in $DR_IGNORES; do
    [ -e "$p" ] || [ -L "$p" ] || continue
    if [ "$STORE" != external ]; then
      note "$p is where a data-root ignore file would land: under DATA_STORE repo the copy leaves it as yours. If you later answer DATA_STORE=external, that update brings the template's there with conflict markers: merge your lines with the template's by hand"
    elif [ "$1" = moving ]; then
      note "$p is where a data-root ignore file would land, and under DATA_STORE external this copy writes the template's there: --overwrite replaces yours, so after the copy take your own lines back from git diff and add them to the template's"
    else
      note "$p is where a data-root ignore file would land: --skip '*' keeps yours, so the template's rules, which keep every binary there out of Git under DATA_STORE external, are never added. Add them to yours by hand, from $(tpl_file "$p")"
    fi
  done
  # The seed alone wires the guard, so a kept settings.json never gains it (D50 Section 6).
  if [ -f .claude/settings.json ] && ! grep -q 'dataroot\.py' .claude/settings.json; then
    note ".claude/settings.json is kept as yours, and no copy or update adds the data-root guard to it (a PreToolUse hook that stops a session writing under a data root): copy the data-root guard's object (the one that runs .claude/syntek-*-dataroot.py) by hand into the \"PreToolUse\" list of its \"hooks\", from the template's seed, $(tpl_file .claude/settings.json)"
  fi
  return 0
}

# The user guide, both modes (DESIGN.md D56), read from the template/how-to/ of the clone this
# runs from: how-to that is not a folder (a copy stops on a file or a link outside the
# repository, and writes the guide through a link inside it); a root entry that differs from
# how-to only in letter case; the repository's own files at the guide's paths, which the copy
# keeps (a shared file, never written over) or replaces (this template's own, moving) and the
# first update restores; and its other files under how-to/, which no template ships and which
# from v0.6.0 the rules call the templates' read-only guide (git-listed, D42).
howto_report() { # $1 = moving or additive
  local p v e f name n=0
  local -a shared=() own=() sibs=() listed=()
  local -A shipped=()
  [ -d "$TEMPLATE_DIR/how-to" ] || return 0
  while IFS= read -r p; do
    shipped[$p]=1
    case "$p" in */syntek-author/*) own+=("$p") ;; *) shared+=("$p") ;; esac
  done < <(cd "$TEMPLATE_DIR" && find how-to -type f | LC_ALL=C sort)
  heading "The user guide — how-to/, read-only in every project (DESIGN.md D56)"
  if [ -L how-to ]; then
    note "how-to is a link to $(readlink how-to), not a folder: a copy writes the user guide through a link inside the repository, and stops (exit 1) on a file or a link outside it. Make how-to a real folder before the copy (move this one aside, with the author)."
    n=$((n + 1))
  elif [ -e how-to ] && [ ! -d how-to ]; then
    note "how-to is a file, not a folder: a copy writes the user guide through a link inside the repository, and stops (exit 1) on a file or a link outside it. Make how-to a real folder before the copy (move this one aside, with the author)."
    n=$((n + 1))
  fi
  for e in *; do
    if [ "$e" != how-to ] && [ "${e,,}" = how-to ]; then
      note "'$e' differs from how-to only in letter case: on a disk that ignores case the copy writes the user guide's files into it. Rename it, with the author, before the copy."
      n=$((n + 1))
    fi
  done
  if [ -d how-to ] && [ ! -L how-to ]; then
    for p in "${shared[@]}"; do
      if [ -f "$p" ] && [ ! -L "$p" ] && ! cmp -s -- "$p" "$TEMPLATE_DIR/$p"; then
        note "$p is kept by the copy (a shared file is never written over); the first copier update puts the template's text there, because how-to/ is read-only, and lists it; your text stays in git"
        n=$((n + 1))
      fi
    done
    # This template's own paths, but a variant chapter the kind never ships.
    while IFS=$'\t' read -r v p _; do
      [ "$v" != closed ] || continue
      if [ "$1" = moving ]; then
        note "$p is a template path: --overwrite replaces it with the template's"
      else
        note "$p is kept by the copy; the first update brings conflict markers into it, then puts the template's text back"
      fi
      n=$((n + 1))
    done < <(for p in "${own[@]}"; do if [ -e "$p" ] || [ -L "$p" ]; then printf '%s\n' "$p"; fi; done \
               | ship_verdicts "$COPIER_YML" "$KIND" "$STORE")
    # Another template's own folders, for each answers file at the root.
    for f in .copier-answers.*.yml; do
      [ "$f" != .copier-answers.syntek-author.yml ] || continue
      name=${f#.copier-answers.}; name=${name%.yml}
      sibs+=("how-to/docs/$name/" "how-to/src/TEMPLATE-GUIDE/$name/" "how-to/workflows/$name/")
    done
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      mapfile -t listed < <(git ls-files -co --exclude-standard -- how-to/ 2>/dev/null | LC_ALL=C sort -u)
    else
      mapfile -t listed < <(find how-to \( -type f -o -type l \) 2>/dev/null | LC_ALL=C sort)
    fi
    for p in "${listed[@]}"; do
      [ -z "${shipped[$p]:-}" ] || continue
      for f in "${sibs[@]}"; do
        case "$p" in "$f"*) continue 2 ;; esac
      done
      note "$p belongs to no template: from v0.6.0 how-to/ is the templates' read-only guide. Move it first: a guide to a layer's docs/project/, a procedure to its workflows/local/"
      n=$((n + 1))
    done
  fi
  [ "$n" -gt 0 ] || item clean "nothing of yours under how-to/: the copy writes the user guide there"
  return 0
}

# The MCP servers, both modes (D54): what a kept MCP file gains, and the git-ignored one that
# nothing ever reads, whose servers the author adds by hand.
mcp_report() { # $1 = moving or additive, $2 = the preview tree (additive)
  local f m found=0 agx ign=0
  [ -n "$MCP_SERVERS" ] || return 0
  agx=$(agents_exclude >/dev/null; printf '%s' "$AGX")
  heading "MCP servers — what the template adds to the files you keep (D54)"
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then ign=1; fi
  for f in "${MCP_FILES[@]}"; do
    [ -e "$f" ] || [ -L "$f" ] || continue
    case "$agx|$f" in " --exclude /.agents|.agents/"*) continue ;; esac
    # Additive: a client file the answers do not name is no template path, and gains nothing.
    if [ "$1" = additive ] && [ ! -e "$2/$f" ]; then continue; fi
    found=1
    if [ "$ign" -eq 1 ] && git check-ignore -q -- "$f" 2>/dev/null; then
      note "$f is ignored by git: copier update never reads it or adds the MCP servers to it, nor does the copy. To use $MCP_SERVERS, add them to it by hand, as the template's $f declares them"
    elif [ -L "$f" ] || [ ! -f "$f" ]; then
      note "$f is a link or not a regular file: the template never writes through it, so add $MCP_SERVERS to it by hand if you want them"
    elif [ "$1" = moving ]; then
      m=""; [ "$f" = .mcp.json ] || m=", where your answers name its client; until the file holds their ask rules they wait, and the copy's report says what to run"
      note "$f is kept as yours: the copy adds $MCP_SERVERS to it once each, into its own text, and changes nothing else$m"
    else
      m=""; [ "$f" = .mcp.json ] || m="; until the file holds their ask rules they wait, and that update's report says what to run"
      note "$f is kept as yours: your first copier update adds $MCP_SERVERS to it once each, into its own text, and changes nothing else (the additive copy runs no task)$m"
    fi
  done
  [ "$found" -eq 1 ] || item clean "no MCP file of yours at a template path: the copy writes the template's, with $MCP_SERVERS"
  return 0
}

# ── Additive adoption (DESIGN.md D41): report only ───────────────────────────
# Renders the template for this kind into a temporary folder — the exact tree the additive
# copy would write, options included when --answers names the answers file — and compares it
# with the repository. Nothing in the repository is written.

additive_report() {
  local tpl_root render copier log f n m mode dir name e p entries unmentioned kept_n add_n found with
  local ref tag dirty refdesc rule t where ans q step2 step3 ign_n=0 seed_ign=0 risk_n=0 checked=0
  local st loose=0 dup_n=0 b c own_dir in_git=0 agx pv pv_name
  local -a args=() rfiles=() held=() added=() ign=() order=() porder=() names=() drafts=() cands=() sibx=()
  local -A risk=() pdir=() atrisk=() in_head=() in_index=() dup_seen=() sibcopy=()
  tpl_root=$(cd "$SCRIPT_DIR/.." && pwd)
  [ -f "$tpl_root/copier.yml" ] || die "no copier.yml beside this script: run it from a clone of syntek-author"
  if [ -n "${COPIER_CMD:-}" ]; then copier=$COPIER_CMD
  # The minimum the shown commands ask for (D18): one word each, as $copier is split and never
  # parsed again, so the >= is never a redirection, and quotes would reach uv as part of it.
  elif command -v uvx >/dev/null 2>&1; then copier="uvx --python >=3.14 copier"
  elif command -v copier >/dev/null 2>&1; then copier="copier"
  else die "--additive renders the template to compare it with this repository, and needs uvx (or copier) on PATH"; fi
  render=$(mktemp -d "${TMPDIR:-/tmp}/adopt-additive.XXXXXX") || die "could not create a temporary folder"
  # shellcheck disable=SC2064 # expand now: the folder is this run's own
  trap "rm -rf -- '${render:?}'" EXIT
  # The preview folder takes this repository's own name, as the copy's destination does
  # (DATA_SLUG's default reads it under the external store), and holds every other syntek
  # template's answers file before it renders, so the preview meets the same peer rule as the
  # copy (D50). Those files are this repository's, so they are neither added nor kept.
  pv_name=$(basename "$(pwd -P)")
  case "$pv_name" in "" | / | . | ..) pv_name=p ;; esac
  pv="$render/preview/$pv_name"
  mkdir -p "$pv" || die "could not create a temporary folder"
  sibx=(-e .copier-answers.syntek-author.yml)
  for f in "${SIBLINGS[@]}"; do
    cp -- "$f" "$pv/$f" || die "could not copy $f into the preview folder"
    sibcopy[$f]=1; sibx+=(-e "$f")
  done
  args=(copy --trust --defaults --skip-tasks --data "DOC_TYPE=$KIND" --data SEED_EXAMPLES=false)
  [ -z "$STORE_DATA" ] || args+=(--data DATA_STORE=repo)
  if [ -n "$ANSWERS" ]; then
    args+=(--data-file "$ANSWERS")
  else
    args+=(--data "PROJECT_NAME=Adoption preview" --data "AUTHOR_NAME=Adoption Preview" --data "DATE=01/01/2000"
      --data "PROJECT_DESCRIPTION=A preview render that adopt.sh compares with the repository being adopted.")
  fi
  git -C "$tpl_root" rev-parse --git-dir >/dev/null 2>&1 && args+=(--vcs-ref=HEAD)
  log="$render/copier.log"
  # shellcheck disable=SC2086 # $copier is one or two words on purpose
  if ! $copier "${args[@]}" "$tpl_root" "$pv" </dev/null >"$log" 2>&1; then
    tail -5 "$log" >&2
    die "could not render the template for --kind $KIND${ANSWERS:+ with $ANSWERS}"
  fi

  mapfile -t rfiles < <(cd "$pv" && find . -name .git -prune -o \( -type f -o -type l \) -print \
    | sed 's#^\./##' | grep -vxF "${sibx[@]}" | LC_ALL=C sort)
  # Paths the printed copy excludes under .agents (agents_exclude, run in a subshell here so
  # its notes print once, in their place below) are neither added nor kept: the copy never
  # writes there, and a linked .agents would otherwise be counted through its link.
  agx=$(agents_exclude >/dev/null; printf '%s' "$AGX")
  for f in "${rfiles[@]}"; do
    case "$agx|$f" in " --exclude /.agents|.agents/"* | " --exclude /.agents/skills|.agents/skills") continue ;; esac
    if [ -e "$f" ] || [ -L "$f" ]; then held+=("$f"); else added+=("$f"); fi
  done
  kept_n=${#held[@]}; add_n=${#added[@]}

  # The source and ref this preview rendered. Copier renders a local clone at HEAD WITH its
  # uncommitted changes, while README.md's copy takes the latest published tag: the two trees
  # match only when this clone is clean at that tag, so the report names what it rendered and
  # step 3 below copies from exactly that.
  ref=""; tag=""; dirty=""
  if git -C "$tpl_root" rev-parse --git-dir >/dev/null 2>&1; then
    ref=$(git -C "$tpl_root" rev-parse --short HEAD 2>/dev/null) || ref=unknown
    tag=$(git -C "$tpl_root" describe --tags --exact-match HEAD 2>/dev/null) || tag=""
    [ -z "$(git -C "$tpl_root" status --porcelain 2>/dev/null)" ] || dirty=1
    refdesc="HEAD ($ref${tag:+, tagged $tag})${dirty:+ plus its uncommitted changes, which Copier renders too}"
  else
    refdesc="its files as they are (not a git clone, so Copier records no version)"
  fi

  heading "Additive adoption — every existing file is kept, nothing is moved (DESIGN.md D41)"
  item report "previewed $tpl_root at $refdesc: copy from the same source and ref (Next, step 3)"
  with="with its default options (pass --answers for yours)"
  [ -z "$ANSWERS" ] || with="with $ANSWERS"
  item report "rendered the $KIND template $with"

  heading "What the copy will ADD (it writes only paths that do not exist yet)"
  if [ "$add_n" -eq 0 ]; then
    item clean "nothing: every template path already exists here"
  else
    printf '%s\n' "${added[@]}" | awk -F/ '{ k = (NF > 1) ? $1 "/" : "the repository root"; c[k]++ } END { for (k in c) printf "%d\t%s\n", c[k], k }' \
      | LC_ALL=C sort -k2 | while IFS=$'\t' read -r n name; do item add "$n file(s) under $name"; done
  fi

  # What git holds of each kept file. A file at a template path that git does not hold — left
  # by an earlier copy that was never committed, say — is the template's, not the repository's,
  # yet the copy keeps it as the repository's own and every update then merges into it.
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    in_git=1
    while IFS= read -r -d '' f; do in_head[$f]=1; done < <(git ls-tree -r -z --name-only HEAD 2>/dev/null || true)
    while IFS= read -r -d '' f; do in_index[$f]=1; done < <(git ls-files -z 2>/dev/null || true)
  fi

  heading "What it will KEEP — your files at template paths, exactly as they are"
  if [ "$kept_n" -eq 0 ]; then item clean "none"; fi
  n=0
  for f in "${held[@]}"; do
    st=$(kept_state "$f")
    case "${f##*/}" in
      CONTEXT.md | CLAUDE.md) if [ -z "$st" ] || [ "$st" = committed ]; then n=$((n + 1)); continue; fi ;;
    esac
    case "$st" in
      "") item kept "$f" ;;
      committed) item kept "$f (kept, committed)" ;;
      staged) item kept "$f (kept, staged: added to git but not committed)"; loose=$((loose + 1)) ;;
      ignored) item kept "$f (kept, ignored: git never holds it)"; loose=$((loose + 1)) ;;
      *) item kept "$f (kept, untracked: git holds no copy)"; loose=$((loose + 1)) ;;
    esac
  done
  if [ "$n" -gt 0 ]; then
    if [ "$in_git" -eq 1 ]; then item kept "$n governance file(s) (CONTEXT.md and CLAUDE.md), all kept, committed: the index files among them are below"
    else item kept "$n governance file(s) (CONTEXT.md and CLAUDE.md): the index files among them are below"; fi
  fi
  if [ "$loose" -gt 0 ]; then
    note "$loose kept file(s) above are not committed. One left by an earlier copy is the template's, not yours, but the copy keeps it as yours and every copier update merges into it: before the copy, commit what is yours and remove the rest (git status --ignored lists them all; a seed you keep out of git on purpose can stay)"
  fi
  if [ "$in_git" -eq 0 ] && [ "$kept_n" -gt 0 ]; then
    item skipped "not a git work tree, so no kept file could be marked committed, untracked or ignored"
  fi

  # Same-named files (D40, D41). Template files cite the template's path, so beside a file of
  # the repository's own with the same name in a neighbouring folder — library/docs/X-standards.md
  # against the template's library/docs/reference/X-standards.md — a session reads the template's
  # generic copy and never the repository's. A redirect line under ## Overrides in 00-project.md
  # points every template file at the repository's copy instead. Names every folder holds
  # (pairs, skills, workflow files, mode files) are left out: there the name is the convention.
  heading "Same-named files — yours beside the template's, in a neighbouring folder"
  for f in "${added[@]}"; do
    b=${f##*/}
    case "$b" in
      CONTEXT.md | CLAUDE.md | README.md | SKILL.md | STEPS.md | CHECKLIST.md | THEOLOGY.md | FICTION.md | BUSINESS.md | .gitignore | .gitkeep) continue ;;
    esac
    case "$f" in */*) dir=${f%/*} ;; *) continue ;; esac
    case "$dir" in */*) own_dir=${dir%/*} ;; *) own_dir=. ;; esac
    cands=("$own_dir/$b" "$own_dir"/*/"$b" "$dir"/*/"$b")
    for c in "${cands[@]}"; do
      c=${c#./}
      [ "$c" != "$f" ] && [ -f "$c" ] || continue
      [ ! -e "$pv/$c" ] || continue
      [ -z "${dup_seen[$f|$c]:-}" ] || continue
      dup_seen[$f|$c]=1; dup_n=$((dup_n + 1))
      st=$(kept_state "$c")
      item 'same name' "$c (yours${st:+, $st}) beside the template's $f, which the copy adds"
      if [ "$st" = ignored ]; then
        printf '              no redirect: git ignores yours, and a redirect never points into an ignored path; move it to a tracked one first\n'
      else
        printf '              redirect: `%s` → `%s`\n' "$f" "$c"
      fi
    done
  done
  if [ "$dup_n" -gt 0 ]; then
    note "template files cite the template's path, so they read its generic copy, not yours. To keep yours, add each redirect above as a bullet under ## Overrides in .claude/rules/syntek-author/00-project.md, exactly as printed after 'redirect:' (D40): every template file then reads yours. Or keep the template's and retire yours"
  else
    item clean "no file of yours shares a name with a template file in a neighbouring folder"
  fi

  # The moving mode's .gitignore checks, made exact. `copier update` diffs the last render
  # against what git HOLDS, so a template file git ignores reads as one the author deleted:
  # the update deletes it, or rewrites it when that release changes it (both reproduced with an
  # unanchored build/ and .claude/skills/build/), and a kept file of the author's at such a
  # path is replaced by the template's, with no copy in git. A seed survives (reproduced with
  # an ignored .mcp.json): Copier never re-renders or deletes an existing seed, so an ignored
  # seed is listed but not counted — the author may well mean it.
  heading "Template paths your ignore rules hide — never committed, and deleted by the next copier update"
  found=0
  if ! command -v git >/dev/null 2>&1 || ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    item skipped "not a git work tree, so no ignore rule was checked: the copy and every update need git — run this report again once it is one"
  else
    checked=1
    [ "$add_n" -eq 0 ] || mapfile -t ign < <(printf '%s\0' "${added[@]}" | ignored_paths)
    for e in "${ign[@]}"; do
      p=${e%%$'\t'*}; rule=${e#*$'\t'}
      if is_seed "$p"; then
        item ignored "$p — $rule: never committed (a seed, so updates leave it as it is: fine if you meant it)"
        seed_ign=1
        continue
      fi
      found=1; ign_n=$((ign_n + 1))
      item ignored "$p — $rule: never committed, and deleted by the next copier update"
    done
    ign=()
    [ "$kept_n" -eq 0 ] || mapfile -t ign < <(printf '%s\0' "${held[@]}" | ignored_paths)
    for e in "${ign[@]}"; do
      p=${e%%$'\t'*}; rule=${e#*$'\t'}
      if is_seed "$p"; then
        item ignored "$p (yours, kept, ignored) — $rule: never committed (a seed, so updates leave it as it is: fine if you meant it)"
        seed_ign=1
        continue
      fi
      found=1; ign_n=$((ign_n + 1))
      item ignored "$p (yours, kept, ignored) — $rule: the next copier update replaces it with the template's or deletes it, and git holds no copy of yours"
    done
    if [ "$found" -eq 1 ]; then
      note "copier update reads a template file git does not hold as one you deleted: it deletes it, or rewrites it when that release changes it, and git never holds it. Before the copy, narrow each rule above (git check-ignore -v <path> names it), or re-include the paths with a !negation line after it"
    fi
  fi
  if build_unanchored; then
    found=1
    note "$BUILD_UNANCHORED"
  fi
  if [ "$found" -eq 0 ] && [ "$checked" -eq 1 ]; then
    if [ "$seed_ign" -eq 1 ]; then item clean "git ignores no template path an update manages (only the seeds above)"
    else item clean "git ignores no template path here"; fi
  fi

  # The gates come from copier.yml (read_gates), so a family or option added there is covered
  # here without an edit. Only a file at the gated path is at risk: Copier deletes what the
  # last render held and the new one does not, so the author's other files in the folder stay.
  heading "Your files at a family's or an option's paths — a later update that drops it deletes them"
  found=0
  if [ "$kept_n" -gt 0 ] && [ -f "$COPIER_YML" ]; then
    while IFS=$'\t' read -r t p; do
      for f in "${held[@]}"; do
        case "$f" in "$p" | "$p"/*) ;; *) continue ;; esac
        case ", ${risk[$t]:-}, " in *", $f, "*) continue ;; esac
        [ -n "${risk[$t]:-}" ] || order+=("$t")
        risk[$t]="${risk[$t]:+${risk[$t]}, }$f"
        [ -n "${atrisk[$f]:-}" ] || risk_n=$((risk_n + 1))
        atrisk[$f]=1
      done
    done < <(read_gates "$COPIER_YML")
  fi
  for t in "${order[@]}"; do
    found=1
    note "$t later deletes these files of yours: ${risk[$t]}; copy them out first (your files at other paths in those folders stay)"
  done
  [ "$found" -eq 1 ] || item clean "no file of yours sits at a family's or an option's path"

  heading "Skills you keep — and the mode files the template writes beside them"
  found=0
  for f in .claude/skills/*/SKILL.md; do
    name=${f#.claude/skills/}; name=${name%/SKILL.md}
    [ -d "$pv/.claude/skills/$name" ] || continue
    found=1
    mode=""
    for m in THEOLOGY.md FICTION.md BUSINESS.md; do
      [ -f "$pv/.claude/skills/$name/$m" ] && mode=$m
    done
    if [ -z "$mode" ]; then
      item kept "$f is yours: the template's $name skill is not installed, and yours answers to its own description"
    elif grep -q '\*\*Mode\.\*\*' "$f"; then
      note "$f carries the Mode paragraph, so the template's $mode beside it APPLIES: check its additions fit your steps, or delete it"
    else
      item inert ".claude/skills/$name/$mode is written beside your own SKILL.md and stays inert: a mode file applies only when its SKILL.md carries the Mode paragraph (D41). Delete it if you prefer"
    fi
    # A shared working-practice SKILL.md (D51) is copy-only and refreshed only where it equals a
    # render this project recorded, so the repository's own file there is never replaced. The
    # list is read from the template's own refresh data, never typed here.
    if [ -f "$tpl_root/migrations/family-refresh.json" ] &&
       grep -qF -e "\"$f\"" -e "\"/$f\"" "$tpl_root/migrations/family-refresh.json"; then
      item kept "$f sits at a shared skill's path: no update merges or replaces it, and each update report lists it under 'NOT UPDATED because you had changed them' when the template changes that skill (D51)"
    fi
  done
  [ "$found" -eq 1 ] || item clean "no skill of yours shares a name with a template skill"

  heading "Index files you keep — extend them by hand"
  found=0
  for f in "${held[@]}"; do
    [ "${f##*/}" = CONTEXT.md ] || continue
    dir=$(dirname "$f")
    unmentioned=""
    entries=$(cd "$pv/$dir" && find . -mindepth 1 -maxdepth 1 \( -type d -printf '%f/\n' -o -printf '%f\n' \) | LC_ALL=C sort)
    while IFS= read -r e; do
      [ -n "$e" ] || continue
      case "$e" in CONTEXT.md | CLAUDE.md | README.md) continue ;; esac
      [ "$dir" = . ] && p="$e" || p="$dir/$e"
      [ -e "${p%/}" ] && continue
      grep -qF -- "${e%/}" "$f" || unmentioned="$unmentioned ${e}"
    done <<<"$entries"
    if [ -n "$unmentioned" ]; then
      found=1
      item extend "$f — the copy adds, and it does not name:$unmentioned"
    fi
    case "$dir" in
      */workflows)
        if ! grep -q 'You want to' "$f"; then
          found=1
          note "$f has no 'You want to… | Procedure' table: run-workflow then lists the workflow folders directly (D41). To send a request to your own procedure instead of a template one, add a row to .claude/rules/syntek-author/00-project.md ## Workflow aliases"
        fi
        ;;
    esac
  done
  [ "$found" -eq 1 ] || item clean "no kept index file misses a template entry"

  # A template signpost describes the template's layout. Added to a folder that already holds
  # the repository's own entries — ones the template does not ship, so its What's here cannot
  # name them — its description and its rules may not fit them.
  heading "Template signposts added to folders that already hold your files"
  found=0
  for f in "${added[@]}"; do
    case "${f##*/}" in CONTEXT.md | CLAUDE.md | README.md) ;; *) continue ;; esac
    case "$f" in */*) dir=${f%/*} ;; *) dir=. ;; esac
    [ -d "$dir" ] || continue
    [ -n "${pdir[$dir]:-}" ] || porder+=("$dir")
    pdir[$dir]="${pdir[$dir]:+${pdir[$dir]} }${f##*/}"
  done
  for dir in "${porder[@]}"; do
    n=0
    for e in "$dir"/* "$dir"/.[!.]*; do
      [ "${e##*/}" != .git ] || continue
      { [ -e "$pv/${e#./}" ] && [ -z "${sibcopy[${e#./}]:-}" ]; } || n=$((n + 1))
    done
    [ "$n" -gt 0 ] || continue
    found=1
    if [ "$dir" = . ]; then where="the repository root"; else where="$dir/"; fi
    read -r -a names <<<"${pdir[$dir]}"
    note "the copy adds the template's $(join_and "${names[@]}") to $where, which already holds $n of your own files and folders: check its What's here and its rules against your layout, and record any difference in .claude/rules/syntek-author/00-project.md ## Overrides"
  done
  [ "$found" -eq 1 ] || item clean "every signpost the copy adds goes into a folder of its own"

  heading "Workflow numbers shared by your procedures and the template's"
  found=0
  for f in "${added[@]}"; do
    case "$f" in */workflows/[0-9][0-9]-*/STEPS.md) ;; *) continue ;; esac
    dir=${f%/STEPS.md}; name=${dir##*/}
    for e in "${dir%/*}/${name%%-*}"-*/; do
      e=${e%/}
      [ -d "$e" ] && [ "$e" != "$dir" ] || continue
      found=1
      note "${dir%/*}/ will hold two procedures numbered ${name%%-*}: yours (${e##*/}) and the template's ($name). Cite each by its full folder name, never by its number alone (D41)"
    done
  done
  [ "$found" -eq 1 ] || item clean "no number is shared"

  # D37: the Google Drive workflows never push drafts. The template's own exclude every drafts/
  # folder; a workflow of the repository's own does not know the ones the copy adds, whatever
  # DATA_PROVIDER says (a kept file of the template's name shadows the template's). The template
  # ships its Drive workflows only with DATA_PROVIDER google-drive and DATA_STORE repo (D53).
  if [ "$KIND" = business ]; then
    heading "Your GitHub workflows — Google Drive and drafts (DESIGN.md D37, D53)"
    found=0; names=()
    for f in "$pv"/.github/workflows/google-drive-*.yml; do names+=("${f##*/}"); done
    for f in .github/workflows/google-drive-*.yml; do
      found=1
      if [ -f "$pv/$f" ]; then
        if cmp -s "$f" "$pv/$f"; then item kept "$f (the template's own, unchanged)"; continue; fi
        note "$f is kept as yours, so the template's Drive workflow of that name, which DATA_PROVIDER=google-drive with DATA_STORE=repo installs, is never installed: yours runs, with its own rules for drafts and for files already on Drive, and every copier update merges the template's changes into it. For the template's (it pushes only issued documents, never overwrites the record and stops unless the store is repo), move yours aside before the copy"
      elif [ "${#names[@]}" -gt 0 ]; then
        note "$f is kept as yours, and the copy adds the template's $(join_and "${names[@]}") beside it (DATA_PROVIDER=google-drive with DATA_STORE=repo): both would sync library/src/ with Drive. Keep one: move yours aside before the copy, or answer DATA_PROVIDER with another value (none, if nothing keeps a copy of the data root)"
      elif [ "$STORE" = external ]; then
        note "$f is kept as yours: the template ships its Drive workflows only with DATA_PROVIDER=google-drive and DATA_STORE=repo, and this copy takes DATA_STORE external from $STORE_FROM, so it adds none and yours runs as it is. Yours does not know the data root: to keep a copy of the files filed there on Drive, point Google Drive for desktop at the data root (DATA_PROVIDER=google-drive), never at the repository"
      else
        note "$f is kept as yours: the template ships its Drive workflows only with DATA_PROVIDER=google-drive and DATA_STORE=repo, so with these answers it adds none, and yours runs as it is. For the template's (it pushes only issued documents and never overwrites the record), answer DATA_PROVIDER=google-drive with DATA_STORE=repo and move yours aside before the copy"
      fi
    done
    mapfile -t drafts < <(printf '%s\n' "${added[@]}" | awk -F/ '
      $1 == "library" && $2 == "src" {
        for (i = 3; i < NF; i++) if ($i == "drafts") { d = $1; for (j = 2; j <= i; j++) d = d "/" $j; print d "/"; break }
      }' | LC_ALL=C sort -u)
    if [ "${#drafts[@]}" -gt 0 ]; then
      for f in .github/workflows/*.yml .github/workflows/*.yaml; do
        [ -f "$pv/$f" ] && cmp -s "$f" "$pv/$f" && continue
        grep -q 'library/src' "$f" || continue
        found=1
        note "$f mentions library/src/: the copy adds drafts/ folders under library/src/ ($(join_and "${drafts[@]}")); your workflow will sync them unless it excludes */drafts/* (D37)"
      done
    fi
    [ "$found" -eq 1 ] || item clean "no Drive workflow of yours, and none that syncs library/src/"
  fi

  dataroot_report additive
  howto_report additive
  mcp_report additive "$pv"

  heading "The settings file — where the template reads this repository's conventions"
  f=.claude/rules/syntek-author/00-project.md
  if [ -e "$f" ]; then
    item kept "$f (yours already: the copy never overwrites it)"
  else
    note "the copy writes $f from your answers: fill in ## Paths (where this repository keeps each thing), ## Memory headings (your MEMORY.md headings), ## Workflow aliases and ## Overrides before the first session — template rules read project values from it alone"
  fi
  if [ -e tooling/project.mk ]; then
    item kept "tooling/project.mk (yours already: the copy never overwrites it)"
  else
    m="LOGO_DIRS (the logo folder documents embed, when logos come in several resolutions), FLAG_EXTRA_RE (any open-item placeholders of your own, so make flags counts them) and the fonts"
    [ "$KIND" != business ] || m="$m, BRAND_DIRS (where make flags looks for brand files, when yours are not in standards/brand), DOCX_CONVERTER (a Word converter you already use) and ISSUE_STATUSES (the statuses at which make pdf ISSUE=1 may issue)"
    note "the copy writes tooling/project.mk, the build settings the Makefile reads first (D43). Set them there, never in the Makefile: $m"
  fi
  if [ -e Makefile ] && [ -f "$pv/Makefile" ] && ! cmp -s Makefile "$pv/Makefile"; then
    note "Makefile is kept as yours, so the template's targets (make flags, make pdf ISSUE=1, the git-ignore filter of D42) are not installed. The Makefile is template-owned: to use them, move yours aside before the copy and put any project-only target in tooling/project.mk; a locally edited copy of the template's Makefile will conflict on every copier update"
  fi
  if [ -f .claude/CLAUDE.md ]; then
    note ".claude/CLAUDE.md is kept as yours. Template rules never read its numbered sections: whatever they need (the brief, the reader test, where things live) belongs in $f"
  fi

  heading "Summary"
  printf '  additive report: the copy adds %d file(s) and keeps %d of yours at template paths — nothing changed\n' "$add_n" "$kept_n"
  [ "$ign_n" -eq 0 ] || printf '  %d template path(s) your ignore rules hide: fix those rules before the copy\n' "$ign_n"
  [ "$risk_n" -eq 0 ] || printf '  %d file(s) of yours at family or option paths: a later untick deletes them\n' "$risk_n"
  [ "$loose" -eq 0 ] || printf '  %d kept file(s) not committed: commit what is yours, remove what an earlier copy left\n' "$loose"
  [ "$dup_n" -eq 0 ] || printf '  %d file(s) of yours beside a same-named template file: add the ## Overrides redirects\n' "$dup_n"

  # Step 3 copies from exactly what was previewed: a published tag only when this clone is
  # clean at it, otherwise this clone at HEAD (the command README.md gives for a local clone).
  ans="<answers>"; [ -z "$ANSWERS" ] || ans=$(printf '%q' "$ANSWERS")
  q=$(printf '%q' "$tpl_root")
  agents_exclude
  if [ -n "$ANSWERS" ]; then
    step2="    2. The answers file: $ANSWERS, the one this report previewed."
  else
    step2="    2. Copy and edit an answers file: $SCRIPT_DIR/examples/$KIND.answers.yml — then run this
       report again with --answers <that file>, so it previews your options, not the defaults."
    [ -z "$STORE_FROM" ] || step2="$step2
       Delete its DATA_STORE: repo line: the copy takes $STORE from $STORE_FROM."
  fi
  if [ -n "$tag" ] && [ -z "$dirty" ]; then
    step3="    3. Copy from the source and ref this report previewed, or it is not exact. This clone is
       clean at the tag $tag, so that published release is the same tree:
         $(copy_cmd "         " "uvx --python '>=3.14' copier copy --trust --skip '*' --skip-tasks$AGX --data-file $ans --data SEED_EXAMPLES=false$STORE_DATA --vcs-ref=$tag gh:Syntek-Dev/syntek-author .")
       (Or this clone: $q in place of gh:…, and --vcs-ref=HEAD.)"
  elif [ -n "$ref" ]; then
    step3="    3. Copy from the source and ref this report previewed, or it is not exact:
         $(copy_cmd "         " "uvx --python '>=3.14' copier copy --trust --skip '*' --skip-tasks$AGX --data-file $ans --data SEED_EXAMPLES=false$STORE_DATA --vcs-ref=HEAD $q .")
       Copier records that ABSOLUTE path for every later update.${dirty:+ This clone has uncommitted
       changes, which Copier copies too: commit them first, so the version it records is one
       this clone holds.} For a published release of gh:Syntek-Dev/syntek-author instead, check
       this clone out at that release's tag and run this report again."
  else
    step3="    3. Copy from the folder this report previewed, or it is not exact:
         $(copy_cmd "         " "uvx --python '>=3.14' copier copy --trust --skip '*' --skip-tasks$AGX --data-file $ans --data SEED_EXAMPLES=false$STORE_DATA $q .")
       It is not a git clone, so Copier records no version and no update can follow: prefer a
       clone of gh:Syntek-Dev/syntek-author at a release tag, and run this report from it."
  fi
  cat <<EOF

  Next:
    1. On a branch, with nothing outstanding: git switch -c adopt-syntek-author
$step2
$step3
       --skip '*' keeps every file that exists; --skip-tasks leaves your repository as it is,
       so run chmod +x .claude/hooks/*.sh yourself (and make init, with the references kit).
       --skip-tasks also skips the copy-time task that records the template's render for the
       update report (D52), so your first copier update renders the old version itself, once,
       to build its report: a few seconds slower, nothing else.
    4. Fill in .claude/rules/syntek-author/00-project.md, with each redirect named above
       under ## Overrides, then run this report again and extend the index files it names.
    5. git status shows only additions: review, then commit, including
       .copier-answers.syntek-author.yml. Later updates merge template changes into every
       file at a template path, the ones you kept included: a kept file the template changes
       comes back with conflict markers, so resolve each in favour of yours. An update that
       unticks a family or turns an option off deletes your files at its paths (named
       above): copy them out first.

EOF
  return 0
}

if [ "$ADDITIVE" -eq 1 ]; then
  additive_report
  exit 0
fi

# ── Primitives ────────────────────────────────────────────────────────────────

move_one() {
  local src=$1 dst=$2
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    item collision "$src -> $dst (destination exists; both left as they are)"
    COLLIDED=$((COLLIDED + 1))
    return 0
  fi
  if [ "$APPLY" -eq 1 ]; then
    if mkdir -p "$(dirname "$dst")" 2>/dev/null && mv "$src" "$dst" 2>/dev/null; then
      item moved "$src -> $dst"
      MOVED=$((MOVED + 1))
    else
      item failed "$src -> $dst (left where it was)"
      FAILED=$((FAILED + 1))
    fi
  else
    item 'would move' "$src -> $dst"
    WOULD=$((WOULD + 1))
  fi
}

# Every visible entry of a folder except its governance pair; hidden entries are reported.
move_children() {
  local from=$1 to=$2 e name
  [ -d "$from" ] || return 0
  for e in "$from"/*; do
    name=${e##*/}
    case "$name" in CONTEXT.md | CLAUDE.md) continue ;; esac
    move_one "$e" "$to/$name"
  done
  for e in "$from"/.[!.]*; do
    note "$e is hidden: not moved — decide whether $to/ needs it"
  done
}

# The value of `status:` in a file's leading YAML frontmatter, or nothing.
fm_status() {
  awk '
    NR == 1 { if ($0 !~ /^---[[:space:]]*\r?$/) exit; next }
    /^---[[:space:]]*\r?$/ { exit }
    /^status:/ {
      s = $0
      sub(/^status:[[:space:]]*/, "", s); sub(/[[:space:]]*#.*$/, "", s)
      gsub(/["\047\r]/, "", s); sub(/[[:space:]]+$/, "", s)
      print s; exit
    }' "$1"
}

# ── 1–2. workspace/ → root working folders and planning maps ─────────────────

heading "1–2. workspace/ — handoffs and learning to the root, maps to planning/src/maps/"
if [ -d workspace ]; then
  move_children workspace/handoffs handoffs
  move_children workspace/learning learning
  move_children workspace/maps planning/src/maps
  for e in workspace/*; do
    case "${e##*/}" in handoffs | learning | maps | CONTEXT.md | CLAUDE.md) ;; *) note "$e has no template home: decide where it belongs" ;; esac
  done
  note "workspace/ is not part of the template: once the moves are reviewed, delete what is left of it yourself"
else
  item clean "no workspace/ folder"
fi

# ── 3. The voice guide's new name ─────────────────────────────────────────────

heading "3. standards/style/voice-and-tone.md — renamed voice-notes.md"
if [ -f standards/style/voice-and-tone.md ]; then
  move_one standards/style/voice-and-tone.md standards/style/voice-notes.md
else
  item clean "no voice-and-tone.md"
fi

# ── 4. Chapter briefs out of the manuscript (books) ───────────────────────────

heading "4. Chapter briefs — stub chapter files to planning/src/units/ (DESIGN.md D9)"
if [ "$BOOK" -eq 1 ] && [ -d "$CONTENT/src" ]; then
  found=0
  for d in "$CONTENT"/src/[0-9][0-9]-*/; do
    d=${d%/}
    base=${d##*/}
    f="$d/$base.md"
    # -print -quit, not `| head`: under pipefail a SIGPIPE'd find would end the script.
    extra=$(find "$d" -mindepth 1 -maxdepth 1 \( \( -type f -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md ! -name "$base.md" \) -o \( -type d -name '[0-9][0-9]-*' \) \) -print -quit)
    if [ -n "$extra" ]; then
      note "$d/ holds more than one unit (a two-level layout?) — not supported in v0.1; nothing in it is moved"
      found=1
      continue
    fi
    [ -f "$f" ] || continue
    found=1
    st=$(fm_status "$f")
    case "$st" in
      idea | stub | outlined) move_one "$f" "planning/src/units/$base.md" ;;
      "") note "$f has no frontmatter status: decide whether it is a brief (planning/src/units/) or prose" ;;
      *) note "$f is at status '$st' and holds prose: split its brief into planning/src/units/$base.md by hand" ;;
    esac
  done
  [ "$found" -eq 1 ] || item clean "no NN-slug chapter files under $CONTENT/src/"
else
  item clean "not a book, or no $CONTENT/src/"
fi

# ── 5. Flat guides to docs/project/ ───────────────────────────────────────────

heading "5. Flat docs/*.md guides — to docs/project/ (author-owned, DESIGN.md D27)"
found=0
for L in $LAYERS; do
  guides=$(tpl_guides "$L")
  for f in "$L"/docs/*.md; do
    name=${f##*/}
    case "$name" in CONTEXT.md | CLAUDE.md | README.md) continue ;; esac
    found=1
    move_one "$f" "$L/docs/project/$name"
    if in_words "$name" "$guides"; then
      note "$L/docs/project/$name has the name of a template reference guide, so it will override the template's: rename or delete it if you want the template's"
    fi
  done
done
[ "$found" -eq 1 ] || item clean "no flat guides"

# ── 6. Bespoke workflows to workflows/local/ ──────────────────────────────────

heading "6. Bespoke workflows — to workflows/local/ (DESIGN.md D26)"
found=0
kept=0
for L in $LAYERS; do
  tpl=$(tpl_workflows "$L")
  for d in "$L"/workflows/*/; do
    d=${d%/}
    name=${d##*/}
    [ "$name" = local ] && continue
    found=1
    if in_words "$name" "$tpl"; then
      kept=$((kept + 1))
      continue
    fi
    slug=${name#[0-9][0-9]-}
    match=""
    for t in $tpl; do
      if [ "${t#[0-9][0-9]-}" = "$slug" ]; then match=$t; fi
    done
    if [ -n "$match" ]; then
      note "$d/ is the template's $L/workflows/$match/ under an older number: delete it once the copy has written $match/, or move it to $L/workflows/local/ to keep it as a deliberate override"
      continue
    fi
    move_one "$d" "$L/workflows/local/$name"
  done
done
[ "$found" -eq 1 ] || item clean "no workflow folders"
if [ "$kept" -gt 0 ]; then
  note "$kept workflow folder(s) already carry a template name: the copy replaces their files, so recover anything project-specific from git diff into workflows/local/"
fi

# ── 7. status: stub → outlined ────────────────────────────────────────────────

heading "7. Unit status — 'stub' becomes 'outlined' (DESIGN.md D11)"
found=0
units="planning/src/units/*.md"
[ "$BOOK" -eq 1 ] && units="$units $CONTENT/src/[0-9][0-9]-*/[0-9][0-9]-*.md"
# shellcheck disable=SC2086 # the globs are meant to expand here
for f in $units; do
  [ -f "$f" ] || continue
  [ "$(fm_status "$f")" = stub ] || continue
  found=1
  if [ "$APPLY" -eq 1 ]; then
    tmp=$(mktemp)
    awk '
      NR == 1 && /^---[[:space:]]*\r?$/ { infm = 1; print; next }
      infm && /^---[[:space:]]*\r?$/ { infm = 0; print; next }
      infm && !done && /^status:/ { sub(/stub/, "outlined"); done = 1 }
      { print }' "$f" >"$tmp" && cat "$tmp" >"$f"
    rm -f "$tmp"
    item edited "$f (status: outlined)"
    EDITED=$((EDITED + 1))
  else
    item 'would edit' "$f (status: stub -> outlined)"
  fi
done
[ "$found" -eq 1 ] || item clean "no unit at status: stub"

# ── 8. The section sign in governance files ──────────────────────────────────

heading "8. The section sign — 'Section' in governance Markdown (DESIGN.md D23)"
SIGN=$'\xc2\xa7'
gov=$(find . \( -path ./.git -o -path ./build -o -path ./node_modules -o -path ./.venv \
  -o -path ./handoffs -o -path ./learning -o -path ./workspace -o -path '*/src' \) -prune \
  -o -type f -name '*.md' -print | LC_ALL=C sort)
found=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  LC_ALL=C grep -q "$SIGN" "$f" || continue
  found=1
  f=${f#./}
  if [ "$APPLY" -eq 1 ]; then
    command -v perl >/dev/null 2>&1 || { note "$f uses the section sign, but perl is missing: replace it by hand"; continue; }
    perl -pi -e 's/\xC2\xA7\xC2\xA7(?:\x20|\xC2\xA0)?(?=\S)/Sections /g; s/\xC2\xA7\xC2\xA7/Sections/g; s/\xC2\xA7(?:\x20|\xC2\xA0)?(?=\S)/Section /g; s/\xC2\xA7/Section/g' "$f"
    item edited "$f"
    EDITED=$((EDITED + 1))
  else
    item 'would edit' "$f"
  fi
done <<<"$gov"
[ "$found" -eq 1 ] || item clean "no section signs in governance files"
src_hits=$(find . -path ./.git -prune -o -type f -name '*.md' -path '*/src/*' -print 2>/dev/null | while IFS= read -r f; do LC_ALL=C grep -l "$SIGN" "$f" 2>/dev/null || true; done | wc -l | tr -d ' ')
if [ "$src_hits" -gt 0 ]; then
  note "$src_hits file(s) under */src/ use the section sign: that is prose, so it is the author's to change"
fi

# ── Report only ───────────────────────────────────────────────────────────────

heading "Report only — the author decides"
for p in .claude/agents .claude/commands; do
  [ -d "$p" ] && note "$p/ exists: the template is skills only — fold each file's rules into a skill or into .claude/CLAUDE.md, then delete it"
done
[ -d .claude/workflows ] && note ".claude/workflows/ is not part of the template: check it for absolute paths, then delete or ignore it"
[ -d .zed ] && note ".zed/ holds editor settings: check them for absolute paths; the template ships none"
for f in .copier-answers*.yml; do
  note "$f exists: another template's answers, or an earlier attempt — syntek-author writes .copier-answers.syntek-author.yml beside it"
done
for f in *.md; do
  case "$f" in README.md | CONTEXT.md | CHANGELOG.md | LICENSE.md | CONTRIBUTING.md | SECURITY.md) continue ;; esac
  note "$f sits at the root: decide where it belongs (a session summary is a handoff: handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md)"
done
for p in standards/docs standards/src standards/workflows; do
  [ -d "$p" ] && note "$p/ exists, but standards/ is flat in the template (topic folders such as standards/style/): move its files into topic folders by hand"
done
for f in research/*.md; do
  case "${f##*/}" in CONTEXT.md | CLAUDE.md | README.md) continue ;; esac
  note "$f is a flat research note: the template keeps notes under research/src/ — move it by hand"
done
if [ "$BOOK" -eq 1 ] && [ -d library ]; then note "library/ exists, but --kind $KIND expects manuscript/: is this a business library?"; fi
if [ "$BOOK" -eq 0 ] && [ -d manuscript ]; then note "manuscript/ exists, but --kind business expects library/: is this a book?"; fi
# The document families (DESIGN.md D39). Which family a folder of documents belongs to is the
# author's call (the v0.2.0 migration's map is a guide for v0.1.0's own folders), so a folder
# that is not one is reported, never moved.
if [ "$BOOK" -eq 0 ] && [ -d library/src ]; then
  for d in library/src/*/; do
    d=${d%/}
    case "${d##*/}" in
      business | legal | email | accounting | social-media | msp-scp) ;;
      proposals) note "$d/ holds proposals: the template files them in library/src/business/ (DESIGN.md D39): move them by hand" ;;
      contracts) note "$d/ holds contracts: the template files them in library/src/legal/: move them by hand" ;;
      policies) note "$d/ holds policies: the template files IT policies for managed-service clients in library/src/msp-scp/ (if you choose that family) and the rest in library/src/business/: move them by hand" ;;
      correspondence) note "$d/ holds correspondence: the template files it in library/src/email/ (client-emails/, supplier-emails/): move it by hand" ;;
      finance) note "$d/ holds finance documents: the template files them in library/src/accounting/: move them by hand" ;;
      marketing) note "$d/ holds marketing: the template files it in library/src/social-media/: move it by hand" ;;
      *) note "$d/ is not one of the template's document families (business, legal, email, accounting, social-media, msp-scp): choose its family in BUSINESS_FAMILIES and move its documents there by hand, or keep it with an additive adoption" ;;
    esac
  done
fi

# ── The data root and the MCP servers (D50, D54) ─────────────────────────────

dataroot_report moving
howto_report moving
mcp_report moving

# ── Seeds the copy will keep ─────────────────────────────────────────────────

heading "Seeds the copy will KEEP because they exist (never overwritten)"
found=0
for p in $SEEDS; do
  [ -e "$p" ] || continue
  found=1
  item kept "$p"
done
if [ -z "$SEEDS" ]; then
  item skipped "no copier.yml beside this script: run it from a clone of syntek-author to see which seeds the copy keeps"
elif [ "$found" -eq 0 ]; then
  item clean "none yet: the copy will write every seed"
fi
lacks() { note "$1 lacks $2 — compare it with the template's seed"; }
if [ -f .claude/settings.json ]; then
  # The top-level values the template offers (TOP_VALUES, read above): for D29, an idle
  # compaction is an automatic one, so both autoCompactEnabled and idleCompaction are false;
  # outputStyle is the house output style (D60). Each note names who relies on the value.
  top_list=()
  for kv in "${TOP_VALUES[@]}"; do
    top_key=${kv%%$'\t'*}; top_val=${kv#*$'\t'}
    top_list+=("\"$top_key\": $top_val")
    top_re=$(printf '%s' "$top_val" | sed 's/[][\.*^$+?(){}|/]/\\&/g')
    case $top_key in
      autoCompactEnabled|idleCompaction) top_why="the handoff hooks assume $top_val"; top_them=them ;;
      outputStyle) top_why="the template's output style is $top_val"; top_them=it ;;
      *) top_why="the template's settings assume $top_val"; top_them=them ;;
    esac
    if ! grep -Eq "\"$top_key\"[[:space:]]*:" .claude/settings.json; then
      note ".claude/settings.json lacks \"$top_key\": $top_val, which the template's settings set: the moving copy, or your first copier update after an additive one, adds it"
    elif ! grep -Eq "\"$top_key\"[[:space:]]*:[[:space:]]*$top_re([[:space:]]*[,}]|[[:space:]]*\$)" .claude/settings.json; then
      note ".claude/settings.json sets $top_key to another value than $top_val: it is kept and reported, never changed; $top_why, so set it to $top_val to use $top_them"
    fi
  done
  grep -q 'PreCompact' .claude/settings.json || lacks .claude/settings.json 'the PreCompact hook'
  grep -Eq 'pre-compact-handoff\.sh[^,]*compacted' .claude/settings.json || lacks .claude/settings.json 'the SessionStart hook for the note after a /compact'
  grep -q 'context-threshold-handoff' .claude/settings.json || lacks .claude/settings.json 'the UserPromptSubmit hand-off hook'
  grep -q 'AskUserQuestion' .claude/settings.json || lacks .claude/settings.json 'the AskUserQuestion deny'
  note ".claude/settings.json is kept, and gains only the hook entries and deny and ask rules the template lists, and $(join_and "${top_list[@]}") where each key is absent (D51): the moving copy adds the missing ones into your file's own text; the additive copy (--skip-tasks) adds none, and your first copier update does. Nothing is removed or changed: a rule you allow, or a top-level value you set, is reported, never changed"
  if grep -Eq '"(enabledPlugins|effortLevel)"' .claude/settings.json; then
    note ".claude/settings.json holds owner-specific keys (plugins, effort level): they belong in your user settings, not the project's"
  fi
fi
if [ "$BOOK" -eq 0 ]; then
  for f in .github/workflows/google-drive-*.yml; do
    if [ "$STORE" = external ]; then
      note "$f exists: the template ships its Drive workflows only with DATA_PROVIDER=google-drive and DATA_STORE=repo, and this copy takes DATA_STORE external from $STORE_FROM, so it adds none and keeps yours. Yours does not know the data root: to keep a copy of the files filed there on Drive, point Google Drive for desktop at the data root (DATA_PROVIDER=google-drive), never at the repository"
    else
      note "$f exists: answer DATA_PROVIDER=google-drive with DATA_STORE=repo to take the template's Drive workflows, which the copy will then replace it with; with any other DATA_PROVIDER the copy adds none and keeps yours"
    fi
  done
fi
if [ -f .claude/CLAUDE.md ] && ! grep -q 'rules/syntek-author' .claude/CLAUDE.md; then
  lacks .claude/CLAUDE.md 'its pointer to .claude/rules/syntek-author/ (where the template rules live)'
fi
if [ -f .claude/MEMORY.md ]; then
  missing=""
  for h in Facts Decisions Feedback Status 'Open questions' Sensitivities; do
    grep -q "^## $h" .claude/MEMORY.md || missing="$missing '$h'"
  done
  [ -z "$missing" ] || lacks .claude/MEMORY.md "the headings$missing"
fi
if [ -f .gitignore ]; then
  grep -q 'settings.local.json' .gitignore || lacks .gitignore '.claude/settings.local.json'
  if build_unanchored; then
    note "$BUILD_UNANCHORED"
  elif ! grep -Eq '^/build/?[[:space:]]*$' .gitignore; then
    lacks .gitignore '/build/'
  fi
fi
if [ -f standards/style/voice-notes.md ] && ! grep -q '^## Learned' standards/style/voice-notes.md; then
  lacks standards/style/voice-notes.md "the '## Learned' section learn-voice appends to"
fi
if [ -f .mcp.json ] && grep -q '"/' .mcp.json; then
  note ".mcp.json names an absolute path: it will not work on another machine"
fi

# ── Template files the copy will replace ─────────────────────────────────────

heading "Template files the copy will REPLACE (review them in git diff afterwards)"
if [ -d "$TEMPLATE_DIR" ]; then
  # A path whose _exclude gate the kind (or the store the copy takes) shuts is never written,
  # so it is not listed; one whose gate depends on an answer is listed with that gate.
  pairs=0
  gated_pairs=0
  others=0
  while IFS=$'\t' read -r v p c; do
    [ "$v" = closed ] && continue
    case "${p##*/}" in
      CONTEXT.md | CLAUDE.md) if [ "$v" = only ]; then gated_pairs=$((gated_pairs + 1)); else pairs=$((pairs + 1)); fi ;;
      *) if [ "$v" = only ]; then item replace "$p, only if the answers give: $c"; else item replace "$p"; fi
         others=$((others + 1)) ;;
    esac
  done < <( (cd "$TEMPLATE_DIR" && find . -type f ! -name '.copier-answers.syntek-author.yml') | sed 's#^\./##' | LC_ALL=C sort \
             | while IFS= read -r p; do
                 [ -e "$p" ] || continue
                 is_seed "$p" && continue
                 if is_dataroot_ignore "$p" && [ "$STORE" != external ]; then continue; fi # the data-root section names it
                 printf '%s\n' "$p"
               done | ship_verdicts "$COPIER_YML" "$KIND" "$STORE")
  if [ "$pairs" -gt 0 ]; then
    item replace "$pairs governance file(s) (CONTEXT.md and CLAUDE.md) at template paths"
  fi
  if [ "$gated_pairs" -gt 0 ]; then
    item replace "$gated_pairs more governance file(s) at template paths an option or family gates, only if the answers open it"
  fi
  [ $((pairs + gated_pairs + others)) -gt 0 ] || item clean "none: nothing at a template path yet"
else
  item skipped "no template/ beside this script: run it from a clone of syntek-author to see this list"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

heading "Summary"
agents_exclude
if [ "$APPLY" -eq 1 ]; then
  printf '  moved %d, edited %d, collisions %d, failed %d, for the author %d\n' "$MOVED" "$EDITED" "$COLLIDED" "$FAILED" "$NOTES"
else
  printf '  advisory run: would move %d, collisions %d, for the author %d — nothing changed\n' "$WOULD" "$COLLIDED" "$NOTES"
  printf '  Run again with --apply to make the moves.\n'
fi
cat <<EOF

  Next:
    1. Review with \`git add -A && git diff --cached -M\`, then commit on this branch.
    2. Copy and edit an answers file: $SCRIPT_DIR/examples/$KIND.answers.yml$( [ -z "$STORE_FROM" ] || printf '\n       Delete its DATA_STORE: repo line: the copy takes %s from %s.' "$STORE" "$STORE_FROM")
    3. $(copy_cmd "       " "uvx --python '>=3.14' copier copy --trust --overwrite$AGX --data-file <answers> --data SEED_EXAMPLES=false$STORE_DATA gh:Syntek-Dev/syntek-author .")
       (From a local clone: its ABSOLUTE path in place of gh:…, plus --vcs-ref=HEAD. Copier
       records the path for every later update, and a relative one breaks them all.)
    4. Review git diff: recover project text the copy replaced into docs/project/,
       workflows/local/ or .claude/CLAUDE.md.
    5. Commit, including .copier-answers.syntek-author.yml.

  To keep every file where it is instead, and add the template beside it, run this script
  with --additive (README.md, 'Adopting an existing repository').

EOF

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
