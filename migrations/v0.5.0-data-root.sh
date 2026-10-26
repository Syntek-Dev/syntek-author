#!/usr/bin/env bash
#
# v0.5.0-data-root.sh — report what the data root and the provider question mean for this
#                       project; move nothing.
#
# Template v0.5.0 lets binary records and issued copies live outside the repository, under
# one data root per machine (DESIGN.md D50), and replaces the business-only Google Drive
# question with DATA_PROVIDER in every variant (D53). The update that crosses v0.5.0 records
# DATA_STORE (repo for an existing project, unless the other syntek template already records
# external) and delivers the resolver, but it moves no file: moving binaries out of Git is the
# owner's, through make files-plan. Several things the update cannot say, because they live in
# files it never rewrites or never reads, are listed here, in every variant:
#
#   1. the store and the provider this template's answers record, and the other syntek
#      template's, where its answers file exists ('not yet asked' where it holds no store);
#   2. the binary files Git tracks in each folder this template's data-root map
#      (.claude/syntek-author-dataroot.json) files, by extension, with counts and sizes: the
#      files a data-root ignore file would match, which stay tracked until the owner moves them;
#   3. under DATA_STORE repo, any file already at library/src/.gitignore, research/src/.gitignore
#      or proposal/src/.gitignore, which would become a conflict if the owner chose external;
#   4. whether .claude/settings.json wires the data-root guard (an update never wires it: new
#      projects only), and if not, the entry to add by hand;
#   5. the next command: make files-plan under external, or how to choose external under repo;
#   6. every tracked workflow under .github/workflows/ that names Google Drive's API while the
#      recorded answers ship no .github/ (not business, not google-drive, or not repo): it still
#      runs on GitHub, unmanaged, and under the external store its push would bin the Drive copy
#      of every file the owner untracks; and every such workflow HEAD holds without the store
#      guard step that this update deleted, because the update report offers to restore it from
#      refs/syntek-author/yours, and the restored copy would do the same (read from git's
#      objects at HEAD, never from the work tree);
#   7. every line of a seed the owner already has that still names the retired
#      INCLUDE_DRIVE_SYNC (README.md, CONTEXT.md, .claude/CLAUDE.md, 00-project.md), or still
#      counts the template's rules as 01- to 08- (README.md, .claude/CONTEXT.md,
#      .claude/CLAUDE.md), with file:line and the v0.5.0 text (for INCLUDE_DRIVE_SYNC, 'delete
#      this line' where the answers ship no .github/): an update never rewrites a seed.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v0.5.0, after the
# update has written the new tree and before the update report. Safe to run again from the
# project root: it reads and prints, so a second run prints the same report. The command it
# prints at the end clones the release and runs it.
#
# WHAT IT NEVER DOES:
#   - change, move, copy, untrack or delete any file, or write the index;
#   - read a git-ignored file (DESIGN.md D42): every file it reads is one git tracks or would
#     track, and it reads binary files' sizes from git's objects, never their contents;
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
MAP=".claude/syntek-author-dataroot.json"
SETTINGS=".claude/settings.json"
SCRIPT_BASENAME="v0.5.0-data-root.sh"
MAX_LIST=40

[[ -f "$ANSWERS" ]] || exit 0

IN_GIT=false
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && IN_GIT=true

# ── What may be read (D42) ───────────────────────────────────────────────────

declare -A READABLE=()
declare -a SCAN=()
if $IN_GIT; then
  mapfile -t SCAN < <(git ls-files -co --exclude-standard 2>/dev/null | LC_ALL=C sort -u)
else
  mapfile -t SCAN < <(find . -name .git -prune -o -type f -print 2>/dev/null | sed 's#^\./##' | LC_ALL=C sort)
fi
for f in "${SCAN[@]}"; do READABLE["$f"]=1; done
readable() { [[ -n "${READABLE[$1]:-}" && -f "$1" ]]; }

# ── The recorded answers ─────────────────────────────────────────────────────

# $1 = key, answers on stdin → its scalar value as YAML wrote it: a plain scalar folded over
# indented lines, or a single- or double-quoted one. Empty if the key is absent.
answer_from() {
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
    }' 2>/dev/null
}
answer() { answer_from "$1" < "$ANSWERS"; } # $1 = key → its value in the answers file now

DOC_TYPE="$(answer DOC_TYPE)"
STORE="$(answer DATA_STORE)"
PROVIDER="$(answer DATA_PROVIDER)"

# The command that runs this script again: a fresh clone of the release it belongs to.
rerun_cmd() { # $1 = script basename
  # shellcheck disable=SC2016  # ${TMPDIR:-/tmp} is printed for the author's shell, not expanded
  local src dir='"${TMPDIR:-/tmp}/syntek-author-v0.5.0"'
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
  printf '{ test -d %s || git clone --depth 1 --branch v0.5.0 %s %s; } && bash %s/migrations/%s' \
    "$dir" "$src" "$dir" "$dir" "$1"
}

human() { # $1 = bytes → 512 B, 3.4 KB, 1.2 MB, 2.0 GB
  awk -v b="$1" 'BEGIN {
    if (b < 1024) printf "%d B", b
    else if (b < 1048576) printf "%.1f KB", b / 1024
    else if (b < 1073741824) printf "%.1f MB", b / 1048576
    else printf "%.1f GB", b / 1073741824 }'
}

# ── 1. The store and the provider ────────────────────────────────────────────

store_words() { # $1 = DATA_STORE value
  case "$1" in
    external) printf 'external (binary files are filed under each machine'\''s data root)' ;;
    repo) printf 'repo (binary files stay in the repository)' ;;
    '') printf 'not recorded' ;;
    *) printf '%s (a value this release does not know)' "$1" ;;
  esac
}

declare -a SIBLINGS=()
for f in .copier-answers.syntek-*.yml; do
  [[ -f "$f" && "$f" != "$ANSWERS" ]] || continue
  readable "$f" || continue
  s="$(answer_from DATA_STORE < "$f")"
  p="$(answer_from DATA_PROVIDER < "$f")"
  if [[ -n "$s" ]]; then s="DATA_STORE $s"; else s="no DATA_STORE (not yet asked)"; fi
  if [[ -n "$p" ]]; then p="DATA_PROVIDER $p"; else p="no DATA_PROVIDER"; fi
  SIBLINGS+=("$f records $s, $p.")
done

# ── 2. Tracked binary files, by filing folder and extension ──────────────────

# The extensions a data-root ignore file matches (the resolver's kind table).
EXT_RE='^(pdf|docx?|xlsx?|pptx?|od[tsp]|zip|7z|tar|gz|eml|msg|png|jpe?g|tiff?|heic|webp|gif|psd|bmp|dng|exr|mp3|wav|flac|m4a|ogg|aac|aiff?|opus|pcm|mp4|mov|mkv|webm|mxf|m4v|mts|m2ts|avi|braw|r3d)$'

# The filing folders: this template's map as the update delivered it, else the v0.5.0 list.
declare -a FOLDERS=()
if readable "$MAP"; then
  mapfile -t FOLDERS < <(grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' "$MAP" 2>/dev/null \
    | sed 's/.*:[[:space:]]*"\(.*\)"$/\1/' | grep -E '^[A-Za-z0-9._/-]+$' | grep -vE '(^|/)\.\.?(/|$)')
fi
[[ ${#FOLDERS[@]} -gt 0 ]] || FOLDERS=(library/src research/src proposal/src assets world/src)

declare -a BINARIES=()
TRACKED_TOTAL=0
if $IN_GIT; then
  for folder in "${FOLDERS[@]}"; do
    # mode, blob and path of each tracked file under the folder; sizes come from git's objects.
    rows="$(git ls-files -s -z -- "$folder/" 2>/dev/null | tr '\0' '\n' | awk -v re="$EXT_RE" '
      { split($0, a, "\t"); path = a[2]; split(a[1], m, " "); n = split(path, parts, ".")
        if (n < 2) next
        ext = tolower(parts[n]); if (ext !~ re) next
        print m[2] "\t" ext }')"
    [[ -n "$rows" ]] || continue
    summary="$(paste <(cut -f1 <<< "$rows" | git cat-file --batch-check='%(objectsize)' 2>/dev/null) <(cut -f2 <<< "$rows") \
      | awk -F'\t' '{ c[$2]++; b[$2] += $1; n++; t += $1 }
        END { printf "%d\t%d", n, t; for (e in c) printf "\t%s\t%d\t%d", e, c[e], b[e] }')"
    IFS=$'\t' read -r -a parts <<< "$summary"
    count="${parts[0]}"; bytes="${parts[1]}"
    TRACKED_TOTAL=$((TRACKED_TOTAL + count))
    detail=""
    while IFS=$'\t' read -r e c b; do
      detail+="${detail:+, }$e $c ($(human "$b"))"
    done < <(for ((i = 2; i + 2 < ${#parts[@]}; i += 3)); do printf '%s\t%s\t%s\n' "${parts[i]}" "${parts[i + 1]}" "${parts[i + 2]}"; done | LC_ALL=C sort)
    BINARIES+=("$(printf '%-14s %d file%s, %s: %s' "$folder" "$count" "$([[ $count -eq 1 ]] || printf s)" "$(human "$bytes")" "$detail")")
  done
fi

# ── 3. Files at a data-root ignore path (repo) ───────────────────────────────

declare -a AT_IGNORE=()
if [[ "$STORE" == repo ]]; then
  for f in library/src/.gitignore research/src/.gitignore proposal/src/.gitignore; do
    [[ -e "$f" || -L "$f" ]] && AT_IGNORE+=("$f")
  done
fi

# ── 4. The data-root guard ───────────────────────────────────────────────────

GUARD=missing
if readable "$SETTINGS"; then
  if grep -q '"PreToolUse"' "$SETTINGS" 2>/dev/null && grep -qE 'dataroot\.py.*guard' "$SETTINGS" 2>/dev/null; then
    GUARD=wired
  else
    GUARD=unwired
  fi
elif [[ -e "$SETTINGS" || -L "$SETTINGS" ]]; then
  GUARD=unread
fi

# ── 6. Google Drive workflows the answers do not ship ────────────────────────

ships_github=false
[[ "$DOC_TYPE" == business && "$PROVIDER" == google-drive && "$STORE" == repo ]] && ships_github=true
declare -a DRIVE=()
if ! $ships_github; then
  for f in "${SCAN[@]}"; do
    case "$f" in .github/workflows/*.yml | .github/workflows/*.yaml) ;; *) continue ;; esac
    readable "$f" || continue
    grep -qF 'googleapis.com/auth/drive' "$f" 2>/dev/null && DRIVE+=("$f")
  done
fi
# The ones this update deleted: HEAD still holds them until the owner commits. A copy from
# before the store guard, restored from the update report, would run unmanaged and unguarded.
GUARD_STEP='Stop unless the documents are kept in the repository'
declare -a DRIVE_GONE=()
if ! $ships_github && $IN_GIT && git rev-parse -q --verify HEAD >/dev/null 2>&1; then
  while IFS= read -r -d '' f; do
    case "$f" in .github/workflows/*.yml | .github/workflows/*.yaml) ;; *) continue ;; esac
    [[ -e "$f" || -L "$f" ]] && continue
    body="$(git cat-file blob "HEAD:$f" 2>/dev/null)" || continue
    grep -qF 'googleapis.com/auth/drive' <<< "$body" || continue
    grep -qF "$GUARD_STEP" <<< "$body" && continue
    DRIVE_GONE+=("$f")
  done < <(git ls-tree -r -z --name-only HEAD -- .github/workflows/ 2>/dev/null)
fi

# ── 7. Seed lines a v0.5.0 seed words differently ────────────────────────────

R_DRIVE="DATA_PROVIDER replaces INCLUDE_DRIVE_SYNC: '- Choosing a provider other than Google Drive, or keeping files outside the repository (\`DATA_STORE\` external), deletes \`.github/\`, the Drive push and pull workflows, including your edits.'"
# v0.5.0's README says that only where the answers ship .github/; otherwise it has no such line.
$ships_github || R_DRIVE="delete this line: these answers (DOC_TYPE ${DOC_TYPE:-not recorded}, DATA_PROVIDER ${PROVIDER:-not recorded}, DATA_STORE ${STORE:-not recorded}) ship no \`.github/\`, so v0.5.0 has no such line"
R_RULES="the rules now run from \`01-\` to \`09-\`: v0.5.0 adds \`.claude/rules/syntek-author/09-data-root.md\` (nine numbered files; ten with \`00-project.md\`)"

declare -a STALE=()
declare -A SEEN=()
stale() { # $1 = file, $2 = line number, $3 = replacement
  local key="$1:$2" text
  [[ -n "${SEEN[$key]:-}" ]] && return 0
  SEEN["$key"]=1
  text="$(sed -n "${2}p" "$1" 2>/dev/null | sed -E 's/^[[:space:]]+//' | cut -c1-110)"
  STALE+=("$key  $text"$'\n'"        v0.5.0: $3")
}
grep_lines() { # $1 = file, then grep arguments → matching line numbers
  local f="$1"; shift
  readable "$f" || return 0
  grep -n "$@" -- "$f" 2>/dev/null | cut -d: -f1
}

R_TREE="make this line '├── 08-naming-and-memory.md' and add '└── 09-data-root.md' after it"
# v0.4.0 counted 'the nine files in' the rules folder (00- to 08-) and 'eight' numbered ones;
# v0.5.0's 'nine files below' and 'nine numbered files' (01- to 09-) are correct, so not stale.
RANGE='01[^[:space:]]*[[:space:]]+to[[:space:]]+[^[:space:]]*08|(^|[^[:alnum:]])eight[[:space:]]([^.]*[[:space:]])?files|(^|[^[:alnum:]])nine[[:space:]]+files[[:space:]]+in[[:space:]]'
for f in README.md CONTEXT.md .claude/CONTEXT.md .claude/CLAUDE.md .claude/rules/syntek-author/00-project.md; do
  readable "$f" || continue
  drive="$(grep_lines "$f" -F 'INCLUDE_DRIVE_SYNC')"
  range="" tree=""
  case "$f" in
    README.md | .claude/CONTEXT.md | .claude/CLAUDE.md)
      range="$(grep_lines "$f" -iE "$RANGE")"
      grep -qF '09-data-root' "$f" 2>/dev/null || tree="$(grep_lines "$f" -E '└── 08-naming-and-memory\.md')"
      ;;
  esac
  for n in $(printf '%s\n' "$drive" "$range" "$tree" | grep -E '^[0-9]+$' | LC_ALL=C sort -n -u); do
    if grep -qx "$n" <<< "$drive"; then
      stale "$f" "$n" "$R_DRIVE"
    elif grep -qx "$n" <<< "$tree"; then
      stale "$f" "$n" "$R_TREE"
    elif ! sed -n "${n}p" "$f" | grep -qE '09|ten files'; then
      stale "$f" "$n" "$R_RULES"
    fi
  done
done

# ── Report ───────────────────────────────────────────────────────────────────

printf '\n▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n'
printf '  Nothing was moved, copied, untracked or changed.\n\n'
printf '  This template records DATA_STORE %s, DATA_PROVIDER %s.\n' "$(store_words "$STORE")" "${PROVIDER:-not recorded}"
for s in "${SIBLINGS[@]}"; do printf '  The other syntek template'\''s answers file %s\n' "$s"; done

if ! $IN_GIT; then
  printf '\n  Not a git repository, so the tracked binary files are not listed.\n'
elif [[ ${#BINARIES[@]} -eq 0 ]]; then
  folders="$(printf '%s, ' "${FOLDERS[@]}")"
  printf '\n  Git tracks no binary file in the folders the data root files (%s).\n' "${folders%, }"
else
  printf '\n  Git tracks %d binary file(s) in the folders the data root files. They stay tracked\n' "$TRACKED_TOTAL"
  printf '  until you move them; an ignore rule never untracks a file:\n\n'
  for b in "${BINARIES[@]}"; do printf '    %s\n' "$b"; done
fi

if [[ ${#AT_IGNORE[@]} -gt 0 ]]; then
  printf '\n  These files sit where the external store would deliver a data-root ignore file, so\n'
  printf '  choosing external would turn each into a conflict. Compare it with the template'\''s\n'
  printf '  before you choose:\n\n'
  for f in "${AT_IGNORE[@]}"; do printf '    %s\n' "$f"; done
fi

case "$GUARD" in
  wired) printf '\n  .claude/settings.json wires the data-root guard.\n' ;;
  unread) printf '\n  .claude/settings.json is ignored by git or not a file, so it was not read: check by hand\n  that its hooks hold a PreToolUse entry that runs .claude/syntek-*-dataroot.py guard.\n' ;;
  *)
    if [[ "$GUARD" == missing ]]; then
      printf '\n  There is no .claude/settings.json, so the data-root guard is not wired.'
    else
      printf '\n  .claude/settings.json does not wire the data-root guard: an update never adds it, and\n  new projects have it.'
    fi
    printf ' It stops Claude Code editing or writing a file under a\n'
    printf '  data root (on macOS, Linux and WSL it stops edits and writes, not searches). To wire\n'
    printf '  it, add this object to the "PreToolUse" list under "hooks" in .claude/settings.json\n'
    printf '  (create the list, "PreToolUse": [ ], where there is none):\n\n'
    cat <<'ENTRY'
      {
        "matcher": "Edit|Write|MultiEdit|NotebookEdit|Grep|Glob",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0; for f in \"$ROOT\"/.claude/syntek-*-dataroot.py; do [ -f \"$f\" ] && exec python3 \"$f\" guard; done; exit 0'",
            "timeout": 10
          }
        ]
      }
ENTRY
    ;;
esac

case "$STORE" in
  external)
    printf '\n  Next: set SYNTEK_DATA_ROOT and run make root, then make files-plan, which lists each\n'
    printf '  tracked binary file with its place under the data root; make files-plan COPY=1 copies\n'
    printf '  them there. Untracking the originals is yours, after make files-verify.\n'
    ;;
  repo)
    printf '\n  To keep binary files outside the repository instead, update with\n'
    printf '    GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \\\n'
    printf '      uvx --python %s copier update --trust -a %s --data DATA_STORE=external\n' "'>=3.14'" "$ANSWERS"
    printf '  then run make files-plan.\n'
    ;;
esac

if [[ ${#DRIVE[@]} -gt 0 ]]; then
  printf '\n  These workflows name Google Drive'\''s API, and the recorded answers ship no .github/.\n'
  printf '  Each runs on GitHub and is not managed by the template; under the external store its\n'
  printf '  push bins the Drive copy of every file you untrack: disable or delete it first.\n\n'
  for f in "${DRIVE[@]}"; do printf '    %s\n' "$f"; done
fi

if [[ ${#DRIVE_GONE[@]} -gt 0 ]]; then
  printf '\n  This update deleted these workflows, which name Google Drive'\''s API. Your copies\n'
  printf '  predate the store guard, so one restored from the update report (git restore\n'
  printf '  --source=syntek-author/yours) runs on GitHub unmanaged and, under the external store,\n'
  printf '  its push bins the Drive copy of every file you untrack. Restore one only to disable\n'
  printf '  it, or first add the step '\''%s'\''\n  from a v0.5.0 render:\n\n' "$GUARD_STEP"
  for f in "${DRIVE_GONE[@]}"; do printf '    %s\n' "$f"; done
fi

if [[ ${#STALE[@]} -gt 0 ]]; then
  printf '\n  %d line(s) in seeds you already have still give v0.4.0'\''s wording. An update never\n' "${#STALE[@]}"
  printf '  rewrites a seed, so change each by hand to say what v0.5.0 says:\n\n'
  i=0
  for s in "${STALE[@]}"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then
      printf '    … and %d more\n' "$(( ${#STALE[@]} - MAX_LIST ))"
      break
    fi
    printf '    %s\n' "$s"
  done
fi

printf '\n  This script changed nothing. To run it again:\n'
printf '    %s\n' "$(rerun_cmd "$SCRIPT_BASENAME")"
if [[ "$GUARD" == missing || "$GUARD" == unwired ]]; then
  # The v0.5.0 release this command clones prints the guard as a whole "PreToolUse" key; a
  # project past v0.6.0 already has that key, and JSON keeps only the last of two.
  printf '  That copy prints the guard as a whole "PreToolUse" key: where .claude/settings.json\n'
  printf '  already has a "PreToolUse" list, add only the object above to it, never a second key.\n'
fi
printf '\n'
exit 0
