#!/usr/bin/env bash
#
# v0.2.0-business-families.sh — rescue author files stranded by the v0.2.0 business families.
#
# Template v0.2.0 replaced v0.1.0's six business family folders under library/src/ —
# proposals, contracts, policies, correspondence, finance, marketing — with the families an
# author chooses in BUSINESS_FAMILIES: business, legal, email, accounting, social-media and
# msp-scp (DESIGN.md D39). Copier deletes the signposts it generated in the old folders (their
# CONTEXT.md and CLAUDE.md pairs and drafts/README.md, even where the author added lines to
# them) and delivers the new ones, but every document, template, client folder and draft the
# AUTHOR created in an old folder was never a template file, so `copier update` leaves it
# behind in a folder nothing routes to any more. No conflict, no error, update reports
# success. This moves them across (DESIGN.md D44):
#
#   proposals      -> business
#   contracts      -> legal
#   policies       -> business, or msp-scp when msp-scp is chosen
#   correspondence -> email
#   finance        -> accounting
#   marketing      -> social-media
#
# Sub-paths are kept, so library/src/contracts/client-docs/<client>/msa.tex lands in
# library/src/legal/client-docs/<client>/msa.tex, and a kept example proposal in
# library/src/business/drafts/example-proposal/. One sub-path changes: the email family files
# a client's correspondence in client-emails/<client>/, not client-docs/, so
# correspondence/client-docs/ goes there (when the update delivered client-emails/).
#
# It also lists, for the author to act on: each old signpost the update deleted (with how to
# recover lines they added to it), each moved client folder or template the destination's
# CONTEXT.md does not name, and, from the tree on every run, client facts left in legal/,
# LaTeX letters under email/, emails not yet in their family leaf, and v0.1.0 family headings
# in the planning seeds.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v0.2.0, after the
# update has written the new tree. Safe to run again from the project root; it is idempotent.
# The command it prints clones the release and runs it (the update's own copy of the template
# is deleted when the update ends).
#
# WHAT IT NEVER DOES:
#   - overwrite: a destination that exists is reported and both files stay where they are;
#   - delete a file: only an old folder left EMPTY by its moves is removed;
#   - move into a family the update did not deliver: a family the author did not choose has no
#     library/src/<family>/CONTEXT.md, and its old folder's files are reported, not moved;
#   - touch an old folder that still holds its template CONTEXT.md: Copier has not retired it
#     (the script was run by hand before the update), so it is left alone rather than guessed;
#   - move a git-ignored file to a path git would NOT ignore: a rule written for the old path
#     (credentials, local-only client material) would stop applying and `git add -A` would
#     commit it. Such a file is reported with the rule it needs (DESIGN.md D42);
#   - read a git-ignored file: every file it reads is one git tracks or would track (outside a
#     git work tree, every file);
#   - fail the update: it always exits 0, because a non-zero exit aborts every migration
#     declared after it and leaves the project half-upgraded. Everything it could not do is
#     printed for a human instead.
#
# Exit codes:  0 = always

set -uo pipefail

case "${1:-}" in
  -h | --help)
    sed -n '3,/^# Exit codes/p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

LIB="library/src"
ANSWERS=".copier-answers.syntek-author.yml"
OLD_RE='library/src/(proposals|contracts|policies|correspondence|finance|marketing)/'
FAMILIES_RE='^(business|legal|email|accounting|social-media|msp-scp)$'
SCRIPT_BASENAME="v0.2.0-business-families.sh"
MAX_LIST=40

# ── Guards: a business project with a library ────────────────────────────────

answer() { # $1 = key → the scalar value recorded in the answers file, unquoted
  awk -v key="$1" '$0 ~ "^" key ":" { v = $0; sub("^" key ":[ \t]*", "", v); gsub(/["\047]/, "", v); sub(/[ \t]+$/, "", v); print v; exit }' "$ANSWERS" 2>/dev/null
}
families() { # every value of BUSINESS_FAMILIES, one per line (block or flow list)
  awk '
    /^BUSINESS_FAMILIES:/ {
      v = $0; sub(/^BUSINESS_FAMILIES:[ \t]*/, "", v)
      if (v ~ /^\[/) { gsub(/[][ \t"\047]/, "", v); n = split(v, a, ","); for (i = 1; i <= n; i++) if (a[i] != "") print a[i]; exit }
      on = 1; next
    }
    on && /^[ \t]*- / { v = $0; sub(/^[ \t]*- [ \t]*/, "", v); gsub(/["\047]/, "", v); print v; next }
    on { exit }' "$ANSWERS" 2>/dev/null
}

# The command that runs this script again: a fresh clone of the release it belongs to.
rerun_cmd() { # $1 = script basename
  # shellcheck disable=SC2016  # ${TMPDIR:-/tmp} is printed for the author's shell, not expanded
  local src dir='"${TMPDIR:-/tmp}/syntek-author-v0.2.0"'
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
  # A clone left by an earlier run is reused: both v0.2.0 scripts print the same folder.
  printf '{ test -d %s || git clone --depth 1 --branch v0.2.0 %s %s; } && bash %s/migrations/%s' \
    "$dir" "$src" "$dir" "$dir" "$1"
}

[[ -f "$ANSWERS" ]] || exit 0
[[ "$(answer DOC_TYPE)" == business ]] || exit 0
[[ -d "$LIB" ]] || exit 0

IN_GIT=false
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && IN_GIT=true

POLICIES_TO=business
CHOSEN="$(families)"
grep -qx 'msp-scp' <<< "$CHOSEN" && POLICIES_TO=msp-scp
RERUN="$(rerun_cmd "$SCRIPT_BASENAME")"

MAP="proposals:business
contracts:legal
policies:$POLICIES_TO
correspondence:email
finance:accounting
marketing:social-media"

# Ignored as git sees it today: untracked and matched by an ignore rule. A tracked file is never
# "ignored", and a destination that does not exist yet is judged by the rules alone.
ignored() { $IN_GIT && git check-ignore -q -- "$1" 2>/dev/null; }

# Where a file under library/src/<old>/ belongs: sets DEST_REL (below the family) and DEST.
DEST_REL=""; DEST=""
dest_of() { # $1 = old family, $2 = new family, $3 = path under library/src/<old>/
  DEST_REL="$3"
  if [[ "$1" == correspondence && "$DEST_REL" == client-docs/* && -f "$LIB/email/client-emails/CONTEXT.md" ]]; then
    DEST_REL="client-emails/${DEST_REL#client-docs/}"
  fi
  DEST="$LIB/$2/$DEST_REL"
}

MOVED=0
LEFT=0
declare -a LEFTOVERS=()
declare -a NOTES=()
declare -a MOVED_TO=()
declare -A UNCHOSEN=()
IGNORE_RULES=0
HEADED=false
head_once() {
  $HEADED && return 0
  printf '\n▸ v0.2.0 migration — moving your files into the business families (DESIGN.md D44)\n'
  HEADED=true
}

leave() { # $1 = path, $2 = why
  LEFTOVERS+=("$1 — $2")
  LEFT=$((LEFT + 1))
}

# ── The signposts the update deleted ─────────────────────────────────────────
#
# Copier removes the pairs it generated in each old folder, edits and all. Read before any
# move, from git alone, so only the update's own deletions are listed: the v0.1.0 signpost
# paths, deleted from the work tree since the last commit.

declare -a SIGNPOSTS=()
if $IN_GIT && git rev-parse -q --verify HEAD >/dev/null 2>&1; then
  while IFS=: read -r old new; do
    [[ -n "$old" ]] || continue
    while IFS= read -r p; do
      [[ "$p" =~ ^$LIB/$old/((client-docs|templates)/)?(CONTEXT|CLAUDE)\.md$ || "$p" == "$LIB/$old/drafts/README.md" ]] || continue
      dest_of "$old" "$new" "${p#"$LIB/$old"/}"
      # A later commit touching the signpost is the likeliest sign the author added lines.
      edited=""
      [[ "$(git rev-list --count HEAD -- "$p" 2>/dev/null)" -gt 1 ]] 2>/dev/null && edited="  (changed in a later commit: check it)"
      if [[ -f "$LIB/$new/CONTEXT.md" ]]; then
        SIGNPOSTS+=("$p  → add your lines to $DEST$edited")
      else
        SIGNPOSTS+=("$p  (the $new family is not in this project)$edited")
      fi
    done < <(git diff --diff-filter=D --name-only HEAD -- "$LIB/$old/" 2>/dev/null | LC_ALL=C sort)
  done <<< "$MAP"
fi

move_file() { # $1 = old family, $2 = new family, $3 = file under library/src/<old>/
  local old="$1" new="$2" f="$3"
  dest_of "$old" "$new" "${f#"$LIB/$old"/}"
  if [[ -e "$DEST" || -L "$DEST" ]]; then
    leave "$f" "$DEST already exists; reconcile the two by hand"
    return 0
  fi
  if ignored "$f" && ! ignored "$DEST"; then
    leave "$f" "git ignores it here but would not ignore $DEST; add an ignore rule for $DEST (see below)"
    IGNORE_RULES=$((IGNORE_RULES + 1))
    return 0
  fi
  if mkdir -p "$(dirname "$DEST")" 2>/dev/null && mv "$f" "$DEST" 2>/dev/null; then
    head_once
    printf '  moved  %s -> %s\n' "${f#"$LIB"/}" "$new/$DEST_REL"
    MOVED=$((MOVED + 1))
    MOVED_TO+=("$new/$DEST_REL")
  else
    leave "$f" "the move to $DEST failed; it is still where it was"
  fi
}

# ── The moves ────────────────────────────────────────────────────────────────

while IFS=: read -r old new; do
  [[ -n "$old" && -d "$LIB/$old" ]] || continue

  # A folder whose template CONTEXT.md is still there has not been retired by Copier.
  if [[ -f "$LIB/$old/CONTEXT.md" ]]; then
    head_once
    NOTES+=("$LIB/$old/ still holds its template CONTEXT.md, so Copier has not retired it yet: nothing in it was moved. Run this again after the update to v0.2.0.")
    continue
  fi

  # Collect the folder's files: nested .gitignore files first, so the rules they carry are at
  # the destination before the ignored files they protect are judged.
  mapfile -t files < <(find "$LIB/$old" \( -type f -o -type l \) -name .gitignore 2>/dev/null | LC_ALL=C sort
                       find "$LIB/$old" \( -type f -o -type l \) ! -name .gitignore 2>/dev/null | LC_ALL=C sort)
  [[ ${#files[@]} -gt 0 ]] || { find "$LIB/$old" -depth -type d -empty -delete 2>/dev/null; continue; }

  if [[ ! -f "$LIB/$new/CONTEXT.md" ]]; then
    for f in "${files[@]}"; do
      leave "$f" "the $new family is not in this project (see below)"
    done
    UNCHOSEN["$new"]="${UNCHOSEN[$new]:+${UNCHOSEN[$new]}, }$LIB/$old/"
    continue
  fi

  for f in "${files[@]}"; do
    move_file "$old" "$new" "$f"
  done

  # Drop the husk: only folders the moves left empty.
  find "$LIB/$old" -depth -type d -empty -delete 2>/dev/null || true
  if [[ "$old" == policies && "$new" == msp-scp && -d "$LIB/msp-scp" ]]; then
    NOTES+=("policies/ went to msp-scp/ because msp-scp is chosen. A policy that is not an IT policy for a managed-service client belongs in business/: move it by hand.")
  fi
done <<< "$MAP"

for new in "${!UNCHOSEN[@]}"; do
  list="$(printf '%s\n' "$CHOSEN" "$new" | grep -v '^$' | paste -sd, - | sed 's/,/, /g')"
  NOTES+=("The $new family is not in this project, so the files in ${UNCHOSEN[$new]} stayed where they are. Choose it with \`uvx copier update --trust -a $ANSWERS --data 'BUSINESS_FAMILIES=[$list]'\`, commit, then run:"$'\n'"    $RERUN"$'\n'"  Or move them by hand.")
done
if [[ $IGNORE_RULES -gt 0 ]]; then
  NOTES+=("For each file above that git ignores where it is, add an ignore rule that covers its destination (.gitignore), commit, then run:"$'\n'"    $RERUN")
fi

# ── What may be read (D42) ───────────────────────────────────────────────────
#
# Listed after the moves, so a moved file is judged at its new path.

declare -A READABLE=()
declare -a SCAN=()
if $IN_GIT; then
  mapfile -t SCAN < <(git ls-files -co --exclude-standard 2>/dev/null | LC_ALL=C sort -u)
else
  mapfile -t SCAN < <(find . -name .git -prune -o -type f -print 2>/dev/null | sed 's#^\./##' | LC_ALL=C sort)
fi
for f in "${SCAN[@]}"; do READABLE["$f"]=1; done
readable() { [[ -n "${READABLE[$1]:-}" && -f "$1" ]]; }

note_list() { # $1 = heading, then the paths → one NOTES entry, the list capped at MAX_LIST
  local n="$1" i=0 p
  shift
  for p in "$@"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then n+=$'\n'"    … and $(( $# - MAX_LIST )) more"; break; fi
    n+=$'\n'"    $p"
  done
  NOTES+=("$n")
}

# ── Moved entries their new index does not name ──────────────────────────────
#
# A moved client folder or template lands in a folder whose CONTEXT.md (v0.2.0's signpost)
# lists none of the author's entries.

declare -A UNNAMED=()
for m in "${MOVED_TO[@]}"; do
  IFS=/ read -r -a parts <<< "$m"
  if [[ ${#parts[@]} -ge 3 ]]; then idx="$LIB/${parts[0]}/${parts[1]}/CONTEXT.md"; entry="${parts[2]}"
  else idx="$LIB/${parts[0]}/CONTEXT.md"; entry="${parts[1]}"; fi
  [[ "$entry" =~ ^(CONTEXT\.md|CLAUDE\.md|README\.md|\.gitignore)$ ]] && continue
  readable "$idx" || continue
  grep -qF -- "$entry" "$idx" 2>/dev/null && continue
  UNNAMED["${idx%/CONTEXT.md}/$entry"]=1
done
if [[ ${#UNNAMED[@]} -gt 0 ]]; then
  mapfile -t un < <(printf '%s\n' "${!UNNAMED[@]}" | LC_ALL=C sort)
  note_list "These moved client folders and templates are not named in the CONTEXT.md of the folder they moved into. Add a tree line for each there (the old folder's signpost that listed them is gone):" "${un[@]}"
fi

# ── Work still open, read from the tree on every run ─────────────────────────

# Client facts: v0.1.0 kept them in contracts/client-docs/<client>/CONTEXT.md, which moved to
# legal/; v0.2.0 reads them from business/client-docs/<client>/CONTEXT.md.
declare -a FACTS=()
for f in "${SCAN[@]}"; do
  [[ "$f" =~ ^$LIB/legal/client-docs/([^/]+)/CONTEXT\.md$ ]] || continue
  slug="${BASH_REMATCH[1]}"; biz="$LIB/business/client-docs/$slug/CONTEXT.md"
  readable "$f" && grep -qE '^## Facts[[:space:]]*$' "$f" 2>/dev/null || continue
  readable "$biz" && grep -qE '^## Facts[[:space:]]*$' "$biz" 2>/dev/null && continue
  FACTS+=("$f")
done
if [[ ${#FACTS[@]} -gt 0 ]]; then
  note_list "These client folders under legal/ hold a ## Facts section, but v0.2.0 reads a client's facts from library/src/business/client-docs/<client>/CONTEXT.md (the 'Client facts' row of .claude/rules/syntek-author/00-project.md ## Paths), which has none. Move each ## Facts there by hand (one home per client, never a copy), or point that row at the legal path:" "${FACTS[@]}"
fi

# LaTeX letters: a letter under an instrument (a notice, a payment plan) is a legal type now.
declare -a LETTERS=()
if [[ -f "$LIB/legal/CONTEXT.md" ]]; then
  for f in "${SCAN[@]}"; do
    [[ "$f" == "$LIB/email/client-emails/"*.tex ]] && LETTERS+=("$f")
  done
fi
if [[ ${#LETTERS[@]} -gt 0 ]]; then
  note_list "These LaTeX files are under email/. A letter under an instrument (a notice, a payment plan) belongs in library/src/legal/client-docs/<client>/ in v0.2.0; move any that are by hand:" "${LETTERS[@]}"
fi

# Emails outside their family leaf: v0.2.0 files each one at <client>/<family>/ (or
# <client>/<unit>/<family>/), and correspondence/client-docs/<client>/ had no such level.
declare -a LEAFLESS=()
for f in "${SCAN[@]}"; do
  [[ "$f" == "$LIB/email/client-emails/"*/* ]] || continue
  IFS=/ read -r -a parts <<< "${f#"$LIB/email/client-emails/"}"
  n=${#parts[@]}
  if [[ $n -eq 2 ]]; then
    [[ "${parts[1]}" =~ ^(CONTEXT|CLAUDE)\.md$ ]] && continue
  else
    [[ "${parts[1]}" =~ $FAMILIES_RE ]] && continue
    [[ $n -eq 3 && "${parts[2]}" =~ ^(CONTEXT|CLAUDE)\.md$ ]] && continue
    [[ $n -ge 4 && "${parts[2]}" =~ $FAMILIES_RE ]] && continue
  fi
  LEAFLESS+=("$f")
done
if [[ ${#LEAFLESS[@]} -gt 0 ]]; then
  note_list "v0.2.0 files each email under client-emails/<client>/<family>/ (business/ unless another family's engagement owns the matter); move each into its leaf by hand:" "${LEAFLESS[@]}"
fi

# ── Old family headings in the planning seeds ────────────────────────────────
#
# The register, the review schedule and the precedence file are seeds, so the update never
# rewrites them, and they keep v0.1.0's family headings. Renaming one is not always a single
# answer (Policies is business or msp-scp), so the headings are listed, never edited.

declare -a HEADINGS=()
for seed in planning/src/document-register.md planning/src/review-schedule.md planning/src/precedence.md; do
  readable "$seed" || continue
  while IFS= read -r h; do HEADINGS+=("$seed:$h"); done < <(grep -nE '^## (Proposals|Contracts|Policies|Correspondence|Finance|Marketing)[[:space:]]*$' "$seed" 2>/dev/null || true)
done
if [[ ${#HEADINGS[@]} -gt 0 ]]; then
  note_list "These planning seeds still group rows under v0.1.0 family headings. Rename each to its v0.2.0 family (Business, Legal, Email, Accounting, Social Media, MSP-SCP) and move its rows by hand:" "${HEADINGS[@]}"
fi

# ── Old paths still cited ────────────────────────────────────────────────────
#
# Unit briefs, ledger entries, draft frontmatter and the author's own notes may still name an
# old folder. Which new path each citation wants is the author's call (a moved file, or one
# left behind), so they are listed with file and line, never rewritten.

declare -a CITES=()
mapfile -t cite_scan < <(printf '%s\n' "${SCAN[@]}" | grep -E '\.(md|tex|toml|ya?ml|txt)$' | grep -v '^\.copier-answers' || true)
if [[ ${#cite_scan[@]} -gt 0 ]]; then
  mapfile -t CITES < <(printf '%s\0' "${cite_scan[@]}" | xargs -0 grep -nHE "$OLD_RE" -- 2>/dev/null | cut -c1-160 || true)
fi

# ── Report ───────────────────────────────────────────────────────────────────

if [[ $MOVED -eq 0 && $LEFT -eq 0 && ${#NOTES[@]} -eq 0 && ${#CITES[@]} -eq 0 && ${#SIGNPOSTS[@]} -eq 0 ]]; then
  exit 0
fi
head_once
[[ $MOVED -gt 0 ]] && printf '\n  %d file(s) moved into the v0.2.0 families.\n' "$MOVED"

if [[ ${#SIGNPOSTS[@]} -gt 0 ]]; then
  printf '\n  The update deleted the old folders'\'' signposts, even where you had added lines to them.\n'
  printf '  Recover any line you added with `git show HEAD:<path>` and add it to the new folder'\''s file:\n\n'
  for s in "${SIGNPOSTS[@]}"; do printf '    %s\n' "$s"; done
fi

if [[ $LEFT -gt 0 ]]; then
  printf '\n  %d file(s) could NOT be moved and are still where they were:\n\n' "$LEFT"
  for l in "${LEFTOVERS[@]}"; do printf '    %s\n' "$l"; done
fi

for n in "${NOTES[@]}"; do printf '\n  %s\n' "$n"; done

if [[ ${#CITES[@]} -gt 0 ]]; then
  printf '\n  %d line(s) still name a v0.1.0 family folder. Point each at its new home by hand:\n\n' "${#CITES[@]}"
  if $IN_GIT; then more="git grep -nE --untracked '$OLD_RE'"; else more="grep -rnE '$OLD_RE' ."; fi
  i=0
  for c in "${CITES[@]}"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then printf '    … and %d more (%s)\n' "$(( ${#CITES[@]} - MAX_LIST ))" "$more"; break; fi
    printf '    %s\n' "$c"
  done
fi

if [[ ${#SIGNPOSTS[@]} -gt 0 ]]; then
  printf '\n  This script overwrote and deleted nothing; the update itself removed the old folders'\''\n'
  printf '  signposts (listed above). The update was not interrupted.\n'
else
  printf '\n  This script overwrote and deleted nothing, and the update was not interrupted.\n'
fi
printf '  Review with `git status`, then commit. To run this script again:\n'
printf '    %s\n\n' "$RERUN"
exit 0
