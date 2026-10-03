#!/usr/bin/env bash
#
# adopt.sh — prepare an existing writing repository for `copier copy` from syntek-author.
#
# WHY THIS EXISTS. There is no `copier adopt`. Adoption is a `copier copy --overwrite` into
# the existing repository (README.md, "Adopting an existing repository"), and a copy can do
# two things safely: write files that are missing, and replace files the template owns. It
# cannot MOVE anything. An existing repository keeps its author work where its own
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
# Requirements: bash, find, awk; perl for step 8; git for --apply. No network.
#
# Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]
#        TARGET defaults to the current directory. theology.sh, fiction.sh and business.sh
#        beside this script are this script with --kind filled in.
#
# Exit codes:  0 = report printed (and, with --apply, every safe move made)
#              1 = --apply: one or more moves failed and were left where they were
#              2 = usage error, or --apply refused (not a git work tree, or on main/master)

set -euo pipefail
shopt -s nullglob

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMPLATE_DIR="$SCRIPT_DIR/../template"

usage() {
  cat <<'EOF'
Usage: adopt.sh --kind theology|fiction|business [--apply] [TARGET]

Reports (or, with --apply, makes) the moves an existing writing repository needs before
`uvx copier copy --trust --overwrite --data-file <answers> --data SEED_EXAMPLES=false
gh:Syntek-Dev/syntek-author .` can adopt it. Advisory unless --apply is given. Never
overwrites, never deletes. TARGET defaults to the current directory.
EOF
}

die() { printf 'adopt.sh: %s\n' "$*" >&2; exit 2; }

KIND=""
APPLY=0
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
    library) printf '%s' "01-draft-a-section 02-adapt-a-draft 03-improve-your-draft 04-promote-a-section 05-review-a-document 06-build-a-proof 07-learn-from-your-edits 08-ingest-an-existing-document" ;;
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
    library) printf '%s' "section-anatomy.md drafting-with-ai.md the-status-ladders.md document-anatomy.md latex-deliverables.md versioning-and-the-register.md" ;;
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

if [ "$BOOK" -eq 1 ]; then
  LAYERS="$CONTENT planning research proposal"
  [ "$KIND" = fiction ] && LAYERS="$LAYERS world"
else
  LAYERS="$CONTENT planning research"
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
  # Anchored only. An unanchored `build/` also ignores .claude/skills/build/, so the proof skill
  # every variant needs would never be committed (the template's own seed writes /build/).
  if grep -Eq '^[[:space:]]*build/?[[:space:]]*$' .gitignore; then
    note ".gitignore ignores every folder named build, including .claude/skills/build/; change it to /build/"
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

EOF

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
