#!/usr/bin/env bash
#
# v0.6.0-how-to.sh — say where the user guide starts and that it is read-only, and name what
#                    already stood in how-to/; move nothing.
#
# Template v0.6.0 adds the user guide, how-to/, to every project and makes it read-only
# (DESIGN.md D56): Claude Code is denied edits there, a hook refuses them, and every update
# puts the template's text back on any file of the guide that differs. The update that crosses
# v0.6.0 writes this template's own guide files by Copier's merge and the shared ones through
# the update report's refresh, and moves nothing. What it cannot say, because the owner's files
# were there first or the folder is not what the guide expects, is listed here, in every
# variant:
#
#   1. where the guide starts, how to update from now on, and that the guide is read-only;
#   2. how-to where it is a link (the update wrote the guide through it, and the update report
#      restores no file beyond it), a root entry that differs from how-to only in letter case
#      (on a disk that ignores case the guide went into it), and a guide Git ignores;
#   3. the owner's files at paths the guide now takes: a shared guide file HEAD holds, or an
#      untracked one, whose bytes differ from the template's, and a file of this template's
#      own folders HEAD holds that the update merged or marked as a conflict; the update report
#      that follows puts the template's text on each (unless another syntek template wrote it,
#      or Git does not hold it), and the owner's text stays in Git;
#   4. every file under how-to/ that Git does not ignore and no template ships (not in this
#      release's template/how-to/, nor under a folder named for another template whose answers
#      file is at the project's root): from v0.6.0 the rules call how-to/ the templates' guide,
#      and make lint and make flags no longer read how-to/src unless SCOPE names it;
#   5. where opencode.json exists, the permissions script's --check, and --write, for the new
#      deny rule.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v0.6.0, after the
# update has written the new tree and before the update report. Safe to run again from the
# project root: it reads and prints, so a second run prints the same report, and once the
# update is committed it lists no file of the template's own. The command it prints at the end
# clones the release and runs it.
#
# WHAT IT NEVER DOES:
#   - change, move, copy, untrack or delete any file, or write the index;
#   - read a git-ignored file (DESIGN.md D42): it reads only the files
#     git ls-files -co --exclude-standard lists, git check-ignore and Git's objects at HEAD;
#   - read the data root, or SYNTEK_DATA_ROOT;
#   - fail the update: it always exits 0, because a non-zero exit aborts every migration
#     declared after it and leaves the project half-upgraded.
#
# Exit codes:  0 = always

set -uo pipefail

case "${1:-}" in
  -h | --help)
    sed -n '3,/^# Exit codes/p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

ANSWERS=".copier-answers.syntek-author.yml"
SCRIPT_BASENAME="v0.6.0-how-to.sh"
GUIDE="how-to"
MAX_LIST=40
# The template clone this runs from: the update's own copy, or the clone the rerun makes.
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

[[ -f "$ANSWERS" ]] || exit 0

IN_GIT=false
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && IN_GIT=true
HAS_HEAD=false
$IN_GIT && git rev-parse -q --verify HEAD >/dev/null 2>&1 && HAS_HEAD=true

# A full run: the update report that follows refreshes and restores (SYNTEK_UPDATE_REPORT=off
# skips both until the next update that runs without it).
FULL=true
report="${SYNTEK_UPDATE_REPORT:-}"
report="${report#"${report%%[![:space:]]*}"}"
report="${report%"${report##*[![:space:]]}"}"
[[ "${report,,}" == off ]] && FULL=false

# ── What may be read (D42) ───────────────────────────────────────────────────

declare -A READABLE=() UNTRACKED=()
declare -a LISTED=()
if $IN_GIT; then
  mapfile -t LISTED < <(git ls-files -co --exclude-standard 2>/dev/null | LC_ALL=C sort -u)
  while IFS= read -r f; do UNTRACKED["$f"]=1; done < <(git ls-files -o --exclude-standard 2>/dev/null)
fi
for f in "${LISTED[@]}"; do READABLE["$f"]=1; done
readable() { [[ -n "${READABLE[$1]:-}" && -f "$1" && ! -L "$1" ]]; }

# ── The recorded answers ─────────────────────────────────────────────────────

# $1 = key → its scalar value in the answers file, as YAML wrote it (plain or quoted).
answer() {
  awk -v key="$1" '
    on && /^[ \t]+[^ \t]/ { l = $0; sub(/^[ \t]+/, "", l); v = v " " l; next }
    on { exit }
    $0 ~ "^" key ":" { v = $0; sub("^" key ":[ \t]*", "", v); on = 1; next }
    END {
      if (!on) exit
      sub(/[ \t]+$/, "", v)
      q = substr(v, 1, 1)
      if (q == "\047") { v = substr(v, 2); sub(/\047$/, "", v); gsub(/\047\047/, "\047", v) }
      else if (q == "\"") { v = substr(v, 2); sub(/"$/, "", v); gsub(/\\"/, "\"", v); gsub(/\\\\/, "\\", v) }
      print v
    }' < "$ANSWERS" 2>/dev/null
}

# The command that runs this script again: a fresh clone of the release it belongs to.
rerun_cmd() { # $1 = script basename
  # shellcheck disable=SC2016  # ${TMPDIR:-/tmp} is printed for the author's shell, not expanded
  local src dir='"${TMPDIR:-/tmp}/syntek-author-v0.6.0"'
  src="$(answer _src_path)"
  case "$src" in
    gh:*) src="https://github.com/${src#gh:}"; src="${src%.git}.git" ;;
    gl:*) src="https://gitlab.com/${src#gl:}"; src="${src%.git}.git" ;;
  esac
  if [[ -z "$src" ]]; then
    src='<the syntek-author repository>'
  elif [[ ! "$src" =~ ^[A-Za-z0-9_./:@~+=-]+$ ]]; then
    src="'${src//\'/\'\\\'\'}'"
  fi
  printf '{ test -d %s || git clone --depth 1 --branch v0.6.0 %s %s; } && bash %s/migrations/%s' \
    "$dir" "$src" "$dir" "$dir" "$1"
}

shq() { # $1 = a word → the word, single-quoted where the shell would split or expand it
  if [[ "$1" =~ ^[A-Za-z0-9_./:@+=-]+$ ]]; then
    printf '%s' "$1"
  else
    printf "'%s'" "${1//\'/\'\\\'\'}"
  fi
}

# ── What the template ships under how-to/ ────────────────────────────────────

# SHIPPED: every file of this release's template/how-to/, every variant's chapters included.
# SHARED: the ones no template owns (the container pairs and the shared chapters); OWN: the
# ones under this template's syntek-author/ folders.
declare -A SHIPPED=()
declare -a SHARED=() OWN=()
if [[ -d "$SRC_DIR/template/$GUIDE" ]]; then
  while IFS= read -r p; do
    SHIPPED["$p"]=1
    case "$p" in
      */syntek-author/*) OWN+=("$p") ;;
      *) SHARED+=("$p") ;;
    esac
  done < <(cd "$SRC_DIR/template" && find "$GUIDE" -type f 2>/dev/null | LC_ALL=C sort)
fi

# SIBS: the folders another template's guide files sit in, for each answers file at the root.
declare -a SIBS=()
for f in .copier-answers.*.yml; do
  [[ -f "$f" && "$f" != "$ANSWERS" ]] || continue
  name="${f#.copier-answers.}"
  name="${name%.yml}"
  [[ -n "$name" ]] || continue
  SIBS+=("$GUIDE/docs/$name/" "$GUIDE/src/TEMPLATE-GUIDE/$name/" "$GUIDE/workflows/$name/")
done
sibling_path() { # $1 = path → true where it lies under another template's how-to folder
  local s
  for s in "${SIBS[@]}"; do
    [[ "$1" == "$s"* ]] && return 0
  done
  return 1
}

# ── how-to itself ────────────────────────────────────────────────────────────

LINK=""
[[ -L "$GUIDE" ]] && LINK="$(readlink "$GUIDE" 2>/dev/null || printf '?')"

declare -a CASES=()
shopt -s nullglob
for e in *; do
  [[ "$e" != "$GUIDE" && "${e,,}" == "$GUIDE" ]] && CASES+=("$e")
done
shopt -u nullglob

# Whether a rule ignores the guide's files, tracked or not (--no-index). git check-ignore -q
# takes one path at a time.
IGNORED=false
if $IN_GIT; then
  for p in "$GUIDE/CONTEXT.md" "$GUIDE/src/TEMPLATE-GUIDE/syntek-author/01-overview.md"; do
    git check-ignore -q --no-index -- "$p" 2>/dev/null && IGNORED=true
  done
fi

# ── Files of the owner's at the guide's paths ────────────────────────────────

declare -a YOURS=()
declare -A YOURS_SEEN=()
yours() { # $1 = path, $2 = tracked|untracked
  [[ -n "${YOURS_SEEN[$1]:-}" ]] && return 0
  YOURS_SEEN["$1"]="$2"
  YOURS+=("$1")
}
if $IN_GIT; then
  # A shared file HEAD holds whose bytes differ from the template's (an update never renders
  # one, so this is the owner's, or another template's).
  if $HAS_HEAD; then
    for p in "${SHARED[@]}"; do
      git cat-file -e "HEAD:$p" 2>/dev/null || continue
      readable "$p" || continue
      cmp -s -- "$p" "$SRC_DIR/template/$p" || yours "$p" tracked
    done
  fi
  # A shared file Git does not hold yet, not ignored, whose bytes differ from the template's.
  for p in "${SHARED[@]}"; do
    [[ -n "${UNTRACKED[$p]:-}" ]] || continue
    readable "$p" || continue
    cmp -s -- "$p" "$SRC_DIR/template/$p" || yours "$p" untracked
  done
  # A file of this template's own folders that HEAD holds and the update changed: the owner's
  # committed file, which Copier has just merged or marked as a conflict. A file Copier wrote
  # new is untracked (HEAD lacks it), and once the update is committed HEAD equals the work
  # tree, so neither is ever listed.
  if $HAS_HEAD; then
    for p in "${OWN[@]}"; do
      git cat-file -e "HEAD:$p" 2>/dev/null || continue
      git diff --quiet HEAD -- "$p" 2>/dev/null || yours "$p" tracked
    done
  fi
fi

# ── Files under how-to/ that no template ships ───────────────────────────────

declare -a STRAY=()
if $IN_GIT; then
  while IFS= read -r p; do
    [[ -n "${SHIPPED[$p]:-}" ]] && continue
    # A .rej beside a guide file is this update's own: the report that follows prints its rm.
    [[ "$p" == *.rej && -n "${SHIPPED[${p%.rej}]:-}" ]] && continue
    sibling_path "$p" && continue
    STRAY+=("$p")
  done < <(git ls-files -co --exclude-standard -- "$GUIDE/" 2>/dev/null | LC_ALL=C sort -u)
fi

# ── Report ───────────────────────────────────────────────────────────────────

list() { # the paths given, at most MAX_LIST of them
  local i=0 p
  for p in "$@"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then
      printf '    … and %d more\n' "$(($# - MAX_LIST))"
      break
    fi
    printf '    %s\n' "$p"
  done
}

printf '\n▸ v0.6.0 migration — the user guide, how-to/ (DESIGN.md D56); report only\n'
printf '  This release adds the user guide. Start at\n'
printf '    how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md\n'
printf '  and update from now on with the steps in\n'
printf '    how-to/workflows/syntek-author/01-update-the-template/\n'
printf '  The guide is read-only: Claude Code is denied edits there, a hook refuses them, and every\n'
printf '  update puts the template'\''s text back on any file of it that differs and lists each in its\n'
printf '  report (what you had stays in Git). To work differently from it, record the departure in\n'
printf '  .claude/rules/syntek-author/00-project.md (## Overrides, or ## Workflow aliases for a\n'
printf '  procedure).\n'

if [[ -n "$LINK" ]]; then
  printf '\n  how-to is a link to %s: this update wrote the guide'\''s files through it, and the update report restores no file beyond it. Make how-to a real folder, with the author, and update again.\n' "$LINK"
fi

for e in "${CASES[@]}"; do
  printf '\n  '\''%s'\'' differs from how-to only in letter case: on a disk that ignores case the guide'\''s files went into it. Rename it, with the author, before the next update.\n' "$e"
done

if $IGNORED; then
  printf '\n  Git ignores files under how-to/ in this project (git check-ignore -v --no-index how-to/CONTEXT.md names the rule): an update never reads, restores or reports an ignored file, so the guide may not match this template version. Remove the rule, with the author.\n'
fi

if ! $IN_GIT; then
  printf '\n  Not a git repository, so the files under how-to/ are not listed.\n'
fi

if [[ ${#YOURS[@]} -gt 0 ]]; then
  if $FULL; then
    printf '\n  %d file(s) of yours stand where the guide now has files. The update report that follows puts\n' "${#YOURS[@]}"
    printf '  the template'\''s text there, unless another syntek template wrote the file (it stays that\n'
  else
    printf '\n  %d file(s) of yours stand where the guide now has files. The next update that runs without\n' "${#YOURS[@]}"
    printf '  SYNTEK_UPDATE_REPORT=off puts the template'\''s text there, unless another syntek template wrote the file (it stays that\n'
  fi
  printf '  template'\''s version) or Git does not hold yours (it is left, and named). Your text stays in Git:\n'
  i=0
  for p in "${YOURS[@]}"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then
      printf '    … and %d more\n' "$((${#YOURS[@]} - MAX_LIST))"
      break
    fi
    if [[ "${YOURS_SEEN[$p]}" == untracked ]]; then
      printf '    %s    (not in Git: commit or move it first)\n' "$p"
    else
      printf '    %s    git show %s\n' "$p" "$(shq "HEAD:$p")"
    fi
  done
fi

if [[ ${#STRAY[@]} -gt 0 ]]; then
  printf '\n  %d file(s) under how-to/ belong to no template. The rules now call how-to/ the templates'\''\n' "${#STRAY[@]}"
  printf '  read-only guide: no session may edit them, and make lint and make flags no longer read\n'
  printf '  how-to/src unless SCOPE names it. Nothing moves them; move each yourself, with git mv (or\n'
  printf '  mv, for a file Git does not track), to where your own work lives: a guide to a layer'\''s\n'
  printf '  docs/project/, a procedure to its workflows/local/, a note to research/src/notes/.\n'
  list "${STRAY[@]}"
fi

if [[ -e opencode.json || -L opencode.json ]]; then
  printf '\n  This update adds a deny rule for how-to/ to .claude/settings.json, where you have not\n'
  printf '  removed it. Then run, with the author'\''s agreement:\n'
  printf '    python3 .claude/syntek-author-permissions.py --check\n'
  printf '  and, where it reports opencode.json lacking it, the same with --write.\n'
fi

printf '\n  This script changed nothing. To run it again:\n'
printf '    %s\n\n' "$(rerun_cmd "$SCRIPT_BASENAME")"
exit 0
