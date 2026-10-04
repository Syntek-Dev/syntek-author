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
#   - business: a kept google-drive-*.yml workflow, and a kept workflow that syncs library/src/
#     without knowing the drafts/ folders the copy adds (D37);
#   - the settings file the copy writes, `.claude/rules/syntek-author/00-project.md`.
# Run it before the copy to preview, and after it to see what is left to extend.
#
# Requirements: bash 4+, find, awk; perl for step 8; git for --apply; uvx (or copier) and
# git for --additive. No network, except uvx's first run.
#
# Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]
#        adopt.sh --kind theology|fiction|business --additive [--answers FILE] [TARGET]
#        TARGET defaults to the current directory. theology.sh, fiction.sh and business.sh
#        beside this script are this script with --kind filled in.
#
# Exit codes:  0 = report printed (and, with --apply, every safe move made)
#              1 = --apply: one or more moves failed and were left where they were
#              2 = usage error, --apply refused (not a git work tree, or on main/master), or
#                  --additive could not render the template (no Copier, a bad answers file)

set -euo pipefail
shopt -s nullglob

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMPLATE_DIR="$SCRIPT_DIR/../template"

usage() {
  cat <<'EOF'
Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]
       adopt.sh --kind theology|fiction|business --additive [--answers FILE] [TARGET]

Moving adoption (the default): reports (or, with --apply, makes) the moves an existing
writing repository needs before `uvx copier copy --trust --overwrite --data-file <answers>
--data SEED_EXAMPLES=false gh:Syntek-Dev/syntek-author .` can adopt it. Advisory unless
--apply is given. Never overwrites, never deletes.

Additive adoption (--additive, report only): what `uvx copier copy --trust --skip '*'
--skip-tasks --data-file <answers> --data SEED_EXAMPLES=false <template> .` will add and
keep, the template paths your ignore rules hide, your files that unticking a family or
turning an option off would delete, the mode files it writes beside skills you keep
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

# What git holds of a path, from the in_head and in_index sets additive_report fills: committed,
# staged (in the index, not yet in a commit), ignored or untracked; empty outside git.
kept_state() { # $1 = path
  [ "${in_git:-0}" -eq 1 ] || return 0
  if [ -n "${in_head[$1]:-}" ]; then echo committed
  elif [ -n "${in_index[$1]:-}" ]; then echo staged
  elif git check-ignore -q -- "$1" 2>/dev/null; then echo ignored
  else echo untracked; fi
}

# ── Additive adoption (DESIGN.md D41): report only ───────────────────────────
# Renders the template for this kind into a temporary folder — the exact tree the additive
# copy would write, options included when --answers names the answers file — and compares it
# with the repository. Nothing in the repository is written.

additive_report() {
  local tpl_root render copier log f n m mode dir name e p entries unmentioned kept_n add_n found with
  local ref tag dirty refdesc rule t where ans q step2 step3 ign_n=0 seed_ign=0 risk_n=0 checked=0
  local st loose=0 dup_n=0 b c own_dir in_git=0
  local -a args=() rfiles=() held=() added=() ign=() order=() porder=() names=() drafts=() cands=()
  local -A risk=() pdir=() atrisk=() in_head=() in_index=() dup_seen=()
  tpl_root=$(cd "$SCRIPT_DIR/.." && pwd)
  [ -f "$tpl_root/copier.yml" ] || die "no copier.yml beside this script: run it from a clone of syntek-author"
  if [ -n "${COPIER_CMD:-}" ]; then copier=$COPIER_CMD
  elif command -v uvx >/dev/null 2>&1; then copier="uvx copier"
  elif command -v copier >/dev/null 2>&1; then copier="copier"
  else die "--additive renders the template to compare it with this repository, and needs uvx (or copier) on PATH"; fi
  render=$(mktemp -d "${TMPDIR:-/tmp}/adopt-additive.XXXXXX") || die "could not create a temporary folder"
  # shellcheck disable=SC2064 # expand now: the folder is this run's own
  trap "rm -rf -- '${render:?}'" EXIT
  args=(copy --trust --defaults --skip-tasks --data "DOC_TYPE=$KIND" --data SEED_EXAMPLES=false)
  if [ -n "$ANSWERS" ]; then
    args+=(--data-file "$ANSWERS")
  else
    args+=(--data "PROJECT_NAME=Adoption preview" --data "AUTHOR_NAME=Adoption Preview" --data "DATE=01/01/2000"
      --data "PROJECT_DESCRIPTION=A preview render that adopt.sh compares with the repository being adopted.")
  fi
  git -C "$tpl_root" rev-parse --git-dir >/dev/null 2>&1 && args+=(--vcs-ref=HEAD)
  log="$render/copier.log"
  # shellcheck disable=SC2086 # $copier is one or two words on purpose
  if ! $copier "${args[@]}" "$tpl_root" "$render/p" </dev/null >"$log" 2>&1; then
    tail -5 "$log" >&2
    die "could not render the template for --kind $KIND${ANSWERS:+ with $ANSWERS}"
  fi

  mapfile -t rfiles < <(cd "$render/p" && find . -name .git -prune -o \( -type f -o -type l \) -print \
    | sed 's#^\./##' | grep -vx '.copier-answers.syntek-author.yml' | LC_ALL=C sort)
  for f in "${rfiles[@]}"; do
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
      [ ! -e "$render/p/$c" ] || continue
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
    [ -d "$render/p/.claude/skills/$name" ] || continue
    found=1
    mode=""
    for m in THEOLOGY.md FICTION.md BUSINESS.md; do
      [ -f "$render/p/.claude/skills/$name/$m" ] && mode=$m
    done
    if [ -z "$mode" ]; then
      item kept "$f is yours: the template's $name skill is not installed, and yours answers to its own description"
    elif grep -q '\*\*Mode\.\*\*' "$f"; then
      note "$f carries the Mode paragraph, so the template's $mode beside it APPLIES: check its additions fit your steps, or delete it"
    else
      item inert ".claude/skills/$name/$mode is written beside your own SKILL.md and stays inert: a mode file applies only when its SKILL.md carries the Mode paragraph (D41). Delete it if you prefer"
    fi
  done
  [ "$found" -eq 1 ] || item clean "no skill of yours shares a name with a template skill"

  heading "Index files you keep — extend them by hand"
  found=0
  for f in "${held[@]}"; do
    [ "${f##*/}" = CONTEXT.md ] || continue
    dir=$(dirname "$f")
    unmentioned=""
    entries=$(cd "$render/p/$dir" && find . -mindepth 1 -maxdepth 1 \( -type d -printf '%f/\n' -o -printf '%f\n' \) | LC_ALL=C sort)
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
      [ -e "$render/p/${e#./}" ] || n=$((n + 1))
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

  # D37: Drive sync never pushes drafts. The template's own workflows exclude every drafts/
  # folder; a workflow of the repository's own does not know the ones the copy adds, whatever
  # INCLUDE_DRIVE_SYNC says (a kept file of the template's name shadows the template's).
  if [ "$KIND" = business ]; then
    heading "Your GitHub workflows — Drive sync and drafts (DESIGN.md D37)"
    found=0; names=()
    for f in "$render/p"/.github/workflows/google-drive-*.yml; do names+=("${f##*/}"); done
    for f in .github/workflows/google-drive-*.yml; do
      found=1
      if [ -f "$render/p/$f" ]; then
        if cmp -s "$f" "$render/p/$f"; then item kept "$f (the template's own, unchanged)"; continue; fi
        note "$f is kept as yours, so the template's Drive workflow of that name is never installed: yours runs, with its own rules for drafts and for files already on Drive, and every copier update merges the template's changes into it. For the template's (it pushes only issued documents and never overwrites the record), move yours aside before the copy"
      elif [ "${#names[@]}" -gt 0 ]; then
        note "$f is kept as yours, and the copy adds the template's $(join_and "${names[@]}") beside it: both would sync library/src/ with Drive. Keep one: move yours aside before the copy, or answer INCLUDE_DRIVE_SYNC=false"
      else
        note "$f is kept as yours: with INCLUDE_DRIVE_SYNC=false the template adds no Drive workflow, and yours runs as it is. For the template's (it pushes only issued documents and never overwrites the record), answer INCLUDE_DRIVE_SYNC=true and move yours aside before the copy"
      fi
    done
    mapfile -t drafts < <(printf '%s\n' "${added[@]}" | awk -F/ '
      $1 == "library" && $2 == "src" {
        for (i = 3; i < NF; i++) if ($i == "drafts") { d = $1; for (j = 2; j <= i; j++) d = d "/" $j; print d "/"; break }
      }' | LC_ALL=C sort -u)
    if [ "${#drafts[@]}" -gt 0 ]; then
      for f in .github/workflows/*.yml .github/workflows/*.yaml; do
        [ -f "$render/p/$f" ] && cmp -s "$f" "$render/p/$f" && continue
        grep -q 'library/src' "$f" || continue
        found=1
        note "$f mentions library/src/: the copy adds drafts/ folders under library/src/ ($(join_and "${drafts[@]}")); your workflow will sync them unless it excludes */drafts/* (D37)"
      done
    fi
    [ "$found" -eq 1 ] || item clean "no Drive workflow of yours, and none that syncs library/src/"
  fi

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
  if [ -e Makefile ] && [ -f "$render/p/Makefile" ] && ! cmp -s Makefile "$render/p/Makefile"; then
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
  if [ -n "$ANSWERS" ]; then
    step2="    2. The answers file: $ANSWERS, the one this report previewed."
  else
    step2="    2. Copy and edit an answers file: $SCRIPT_DIR/examples/$KIND.answers.yml — then run this
       report again with --answers <that file>, so it previews your options, not the defaults."
  fi
  if [ -n "$tag" ] && [ -z "$dirty" ]; then
    step3="    3. Copy from the source and ref this report previewed, or it is not exact. This clone is
       clean at the tag $tag, so that published release is the same tree:
         uvx copier copy --trust --skip '*' --skip-tasks --data-file $ans --data SEED_EXAMPLES=false --vcs-ref=$tag gh:Syntek-Dev/syntek-author .
       (Or this clone: $q in place of gh:…, and --vcs-ref=HEAD.)"
  elif [ -n "$ref" ]; then
    step3="    3. Copy from the source and ref this report previewed, or it is not exact:
         uvx copier copy --trust --skip '*' --skip-tasks --data-file $ans --data SEED_EXAMPLES=false --vcs-ref=HEAD $q .
       Copier records that ABSOLUTE path for every later update.${dirty:+ This clone has uncommitted
       changes, which Copier copies too: commit them first, so the version it records is one
       this clone holds.} For a published release of gh:Syntek-Dev/syntek-author instead, check
       this clone out at that release's tag and run this report again."
  else
    step3="    3. Copy from the folder this report previewed, or it is not exact:
         uvx copier copy --trust --skip '*' --skip-tasks --data-file $ans --data SEED_EXAMPLES=false $q .
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
  grep -Eq '"autoCompactEnabled"[[:space:]]*:[[:space:]]*false' .claude/settings.json || lacks .claude/settings.json '"autoCompactEnabled": false (hand off, never compact)'
  grep -q 'PreCompact' .claude/settings.json || lacks .claude/settings.json 'the PreCompact hook'
  grep -q 'AskUserQuestion' .claude/settings.json || lacks .claude/settings.json 'the AskUserQuestion deny'
  if grep -Eq '"(enabledPlugins|effortLevel)"' .claude/settings.json; then
    note ".claude/settings.json holds owner-specific keys (plugins, effort level): they belong in your user settings, not the project's"
  fi
fi
if [ "$BOOK" -eq 0 ]; then
  for f in .github/workflows/google-drive-*.yml; do
    note "$f exists: answer INCLUDE_DRIVE_SYNC=true to take the template's Drive workflows, which the copy will then replace it with"
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
  pairs=0
  others=0
  while IFS= read -r p; do
    p=${p#./}
    [ -e "$p" ] || continue
    is_seed "$p" && continue
    case "${p##*/}" in
      CONTEXT.md | CLAUDE.md) pairs=$((pairs + 1)) ;;
      *) item replace "$p"; others=$((others + 1)) ;;
    esac
  done < <(cd "$TEMPLATE_DIR" && find . -type f ! -name '.copier-answers.syntek-author.yml' | LC_ALL=C sort)
  if [ "$pairs" -gt 0 ]; then
    item replace "$pairs governance file(s) (CONTEXT.md and CLAUDE.md) at template paths"
  fi
  [ $((pairs + others)) -gt 0 ] || item clean "none: nothing at a template path yet"
else
  item skipped "no template/ beside this script: run it from a clone of syntek-author to see this list"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

heading "Summary"
if [ "$APPLY" -eq 1 ]; then
  printf '  moved %d, edited %d, collisions %d, failed %d, for the author %d\n' "$MOVED" "$EDITED" "$COLLIDED" "$FAILED" "$NOTES"
else
  printf '  advisory run: would move %d, collisions %d, for the author %d — nothing changed\n' "$WOULD" "$COLLIDED" "$NOTES"
  printf '  Run again with --apply to make the moves.\n'
fi
cat <<EOF

  Next:
    1. Review with \`git add -A && git diff --cached -M\`, then commit on this branch.
    2. Copy and edit an answers file: $SCRIPT_DIR/examples/$KIND.answers.yml
    3. uvx copier copy --trust --overwrite --data-file <answers> --data SEED_EXAMPLES=false gh:Syntek-Dev/syntek-author .
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
