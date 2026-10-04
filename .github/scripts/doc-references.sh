#!/usr/bin/env bash
#
# doc-references.sh — Verify every path and skill a rendered project's docs cite exists there.
#
#                     The governance files route rather than restate (SB rule 51): a CLAUDE.md
#                     names the workflow, the STEPS.md names the skill and the guide, the guide
#                     names the standard. A citation that resolves to nothing is a dead end
#                     Claude walks into with full confidence. In syntek-author the risk has a
#                     shape the house template never had: a SHARED file is byte-identical in
#                     three variants, so a path it names must exist in all three — a shared
#                     skill citing `planning/src/arguments/` is right in theology and a dangling
#                     reference in fiction and business. DESIGN.md Section 2 answers that with
#                     index files that gate their rows; this script proves the answer held, on
#                     every render, in the tree each reader will actually have.
#
#                     Four checks, over every .md file in a render:
#                       1. A backticked repository path does not exist in THIS tree.
#                       2. A routing frontmatter `skills:` list names a skill this tree lacks.
#                       3. A `> **Skill:**` line names a skill this tree lacks.
#                       4. A backticked skill name (one DESIGN.md Section 5 lists) that this
#                          tree lacks — a shared file naming a variant's skill, or a skill's
#                          `description:` naming a boundary skill that is gated out (a business
#                          family's skill in a project without that family). The description is
#                          read whole, folded lines joined, and feeds check 4 only.
#
#                     A token is tested as a path when it has no spaces, contains a slash, and
#                     is not a placeholder: anything with < > { } * ? [ ] … | = ( ) $ % @ # , ;
#                     or the house placeholders NN, DD-MM-YYYY, YYYY; URLs; absolute paths
#                     (scrub.sh's); and generated output (build/, audio/, references.db). A
#                     trailing :N line anchor is peeled first. A path resolves if it exists
#                     from the tree root or from any ancestor of the citing file, so `src/`
#                     inside manuscript/CLAUDE.md means manuscript/src/. An unresolved path led
#                     by a generic folder name (`drafts/`, `docs/project/`, `workflows/local/`)
#                     names a class of folder, not a place, and is not a finding; one led by a
#                     top-level entry (`world/…`, `planning/…`) always is.
#
#                     Fenced code is skipped (format samples quote invented paths). A line is
#                     exempt when it, or the line above it, carries
#                       <!-- doc-references: variant-only -->   or
#                       <!-- doc-references: ignore — reason -->
#                     Use the first sparingly: a gated row in an index file is the real answer.
#
#                     Numbers are stable identifiers. Append, never renumber.
#
#                     What it CANNOT check: that a path that resolves is the RIGHT one; a
#                     citation written without backticks; or a mistyped relative path led by a
#                     generic folder name, which reads as a class name.
#
# SELF-TEST. --self-test builds a small tree at runtime, proves it clean (placeholders, a fenced
#            sample, a marker, a layer-relative path, generated output and a skill description
#            folded over two lines all pass), then applies one mutation per check, and a second
#            for check 4's description reading, and asserts exactly one finding each.
#
# Requirements: bash 4+, awk, find. No network. Pass trees that generate-all.sh produced.
#
# Usage: doc-references.sh [--quiet] [--self-test] [--help] <rendered-tree>...
#
# Exit codes:  0 = every citation resolves in its own tree
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="doc-references.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
doc-references.sh — Verify every path and skill a rendered project's docs cite exists there

Usage: doc-references.sh [--quiet] [--self-test] [--help] <rendered-tree>...

  --quiet      Print findings only
  --self-test  Prove the checks still fire against a tree built at runtime
  --help       Show this message

Exit codes: 0 = every citation resolves  1 = finding(s), or the self-test no longer
separates  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           TARGETS+=("$1"); shift ;;
  esac
done

TREE=""
TOKENS=0
PATH_TESTS=0
declare -A CATALOGUE=()
while read -r s _; do [[ -n "$s" ]] && CATALOGUE["$s"]=1; done <<< "$SA_SKILLS"

# Records per file: L<TAB>line<TAB>S|T<TAB>token  for backticked tokens outside fences and
# markers (S = on a Skill line), F<TAB>line<TAB>-<TAB>name for each frontmatter skill, and
# D<TAB>line<TAB>-<TAB>token for each backticked token in the frontmatter description (line =
# the description: key, since a folded block is joined before it is read).
EXTRACT='
function flushdesc(   s, i, rest, j, tok) {
  if (!indesc) return
  indesc = 0; s = desc
  while ((i = index(s, "`")) > 0) {
    rest = substr(s, i + 1); j = index(rest, "`")
    if (!j) break
    tok = substr(rest, 1, j - 1)
    if (tok != "") print "D\t" dline "\t-\t" tok
    s = substr(rest, j + 1)
  }
}
NR == 1 && $0 == "---" { infm = 1; next }
infm && /^---[[:space:]]*$/ { flushdesc(); infm = 0; next }
infm {
  if (indesc && $0 ~ /^[[:space:]]/) { desc = desc " " $0; next }
  flushdesc()
  if ($0 ~ /^description:/) { indesc = 1; dline = NR; desc = $0; sub(/^description:[[:space:]]*/, "", desc); inlist = 0 }
  else if ($0 ~ /^skills:[[:space:]]*\[/) {
    s = $0; sub(/^skills:[[:space:]]*\[/, "", s); sub(/\].*$/, "", s)
    n = split(s, a, ",")
    for (i = 1; i <= n; i++) { v = a[i]; gsub(/[[:space:]"\047]/, "", v); if (v != "") print "F\t" NR "\t-\t" v }
  } else if ($0 ~ /^skills:[[:space:]]*$/) { inlist = 1 }
  else if (inlist && $0 ~ /^[[:space:]]+-[[:space:]]/) { v = $0; sub(/^[[:space:]]+-[[:space:]]*/, "", v); gsub(/[[:space:]"\047]/, "", v); print "F\t" NR "\t-\t" v }
  else inlist = 0
  next
}
/^[[:space:]]*```/ { fence = !fence; next }
fence { next }
{
  exempt = (prevmark || $0 ~ /doc-references: *(variant-only|ignore)/)
  prevmark = ($0 ~ /doc-references: *(variant-only|ignore)/)
  if (exempt) next
  kind = ($0 ~ /^> \*\*Skill:\*\*/) ? "S" : "T"
  line = $0
  while ((i = index(line, "`")) > 0) {
    rest = substr(line, i + 1)
    j = index(rest, "`")
    if (!j) break
    tok = substr(rest, 1, j - 1)
    if (tok != "") print "L\t" NR "\t" kind "\t" tok
    line = substr(rest, j + 1)
  }
}
END { flushdesc() }'

is_pathlike() { # sets P to the testable path, or returns 1
  local t="$1"
  [[ "$t" =~ ^(.+):[0-9]+(:[0-9]+|-[0-9]+)?$ ]] && t="${BASH_REMATCH[1]}"
  [[ "$t" == */* ]] || return 1
  case "$t" in
    *[[:space:]]*|/*|-*|~*|http*|*://*|www.*) return 1 ;;
    *'<'*|*'>'*|*'{'*|*'}'*|*'*'*|*'?'*|*'['*|*']'*|*'…'*|*'|'*|*'='*|*'('*|*')'*) return 1 ;;
    *'$'*|*'%'*|*'@'*|*'#'*|*','*|*';'*|*"'"*|*'"'*|*'\'*|*'+'*|*'!'*|*':'*) return 1 ;;
    *NN*|*DD-MM-YYYY*|*YYYY*|*XXX*) return 1 ;;
    build|build/*|*/build/*|tooling/references.db|*/audio|*/audio/*|.git/*|*node_modules*|.claude/settings.local.json) return 1 ;;
  esac
  [[ "$t" =~ ^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*/?$ ]] || return 1
  # Abbreviations, not paths: N/A, I/O, and/or — every segment two letters or fewer, or a
  # conjunction pair.
  [[ "${t%/}" =~ ^[A-Za-z]{1,2}(/[A-Za-z]{1,2})+$ || "$t" == and/or || "$t" == either/or ]] && return 1
  P="$t"
}

# A path whose first segment is a top-level entry of SOME variant is anchored: it must resolve,
# and a gated layer (world/ in a theology project) is exactly the case to catch. Any other path
# is relative to the citing file; unresolved, it is a dead end — unless it is led by a generic
# folder name, in which case it names a CLASS of folder ("each `drafts/`", "every
# `docs/project/`"), not a place.
TOPLEVEL=" .claude .github manuscript library planning research proposal world standards tooling handoffs learning assets README.md CONTEXT.md Makefile .gitignore .mcp.json $SA_ANSWERS_FILE "
GENERIC=" docs src workflows drafts local reference project samples ledger LESSONS sources evidence notes templates client-docs script glyphs audio "

is_class_name() { # $1 = unresolved path
  local first="${1%%/*}"
  [[ "$TOPLEVEL" == *" $first "* ]] && return 1
  [[ "$GENERIC" == *" $first "* ]]
}

resolves() { # $1 = path, $2 = citing file (tree-relative)
  local p="${1%/}" d
  [[ -e "$TREE/$p" ]] && return 0
  d="$(dirname "$2")"
  while :; do
    [[ "$d" == . ]] && break
    [[ -e "$TREE/$d/$p" ]] && return 0
    d="$(dirname "$d")"
  done
  return 1
}

run_checks() {
  FINDINGS=()
  TOKENS=0; PATH_TESTS=0
  local f rec ln kind tok P
  local -A skills=()
  if [[ -d "$TREE/.claude/skills" ]]; then
    while IFS= read -r s; do skills["$s"]=1; done < <(find "$TREE/.claude/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
  fi
  while IFS= read -r -d '' f; do
    f="${f#./}"
    while IFS=$'\t' read -r rec ln kind tok; do
      case "$rec" in
        F)
          [[ -n "${skills[$tok]:-}" ]] || finding "check 2 — $f:$ln routes to skill '$tok', which this project does not have" ;;
        D)
          TOKENS=$((TOKENS + 1))
          if [[ "$tok" =~ ^[a-z0-9-]+$ && -n "${CATALOGUE[$tok]:-}" && -z "${skills[$tok]:-}" ]]; then
            finding "check 4 — $f:$ln description names the skill '$tok', which this project does not have"
          fi ;;
        L)
          TOKENS=$((TOKENS + 1))
          if [[ "$kind" == S && "$tok" =~ ^[a-z0-9-]+$ ]]; then
            [[ -n "${skills[$tok]:-}" ]] || finding "check 3 — $f:$ln names skill '$tok' on its Skill line; this project does not have it"
            continue
          fi
          if [[ "$tok" =~ ^[a-z0-9-]+$ ]]; then
            if [[ -n "${CATALOGUE[$tok]:-}" && -z "${skills[$tok]:-}" ]]; then
              finding "check 4 — $f:$ln names the skill '$tok', which this project does not have"
            fi
            continue
          fi
          if is_pathlike "$tok"; then
            PATH_TESTS=$((PATH_TESTS + 1))
            resolves "$P" "$f" || is_class_name "$P" \
              || finding "check 1 — $f:$ln cites \`$tok\`, which does not exist in this project"
          fi ;;
      esac
    done < <(awk "$EXTRACT" "$TREE/$f")
  done < <(cd "$TREE" && find . \( -name .git -o -name build -o -name node_modules \) -prune -o -type f -name '*.md' -print0 | sort -z)
}

# ── Self-test ────────────────────────────────────────────────────────────────

self_test() {
  local tmp t g wf
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  t="$tmp/gen"; TREE="$t"
  g="$t/manuscript/docs/reference/guide.md"
  wf="$t/manuscript/workflows/01-draft-a-section"
  mkdir -p "$t/.claude/skills/flow" "$t/.claude/skills/research" "$t/manuscript/docs/reference" "$t/manuscript/src" "$wf" "$t/planning/src/units"
  cat > "$t/.claude/skills/flow/SKILL.md" <<'EOF'
---
name: flow
description: >-
  Read the transitions as `00-project.md
  ## Brief` sets the reader. Not a fact check (`research`).
---

# Skill: Flow
EOF
  cat > "$g" <<'EOF'
---
type: guide
skills: [flow, research]
model: opus
---

# Guide — what it is

See `manuscript/src/` and `planning/src/units/` and `.claude/skills/flow/SKILL.md:3`.
Placeholders are not citations: `planning/src/arcs/<slug>.md`, `NN-kebab-title/NN-kebab-title.md`,
`handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, `world/src/*/`, `https://example.com/a/b`.
Generated output is not a citation: `build/proof.pdf`, `tooling/references.db`.
Commands are not citations: `make pdf SCOPE=manuscript/src/02-x`. Nor are `N/A` or `and/or`.
The `flow` skill and the `research` skill both ship.

```yaml
ledger: standards/style/ledger/03-the-ford--crossing-at-night.md
```

<!-- doc-references: variant-only -->
- `planning/src/arguments/` — theology only, marked.
EOF
  cat > "$wf/STEPS.md" <<'EOF'
---
workflow: 01-draft-a-section
skills: [flow]
---

## 1. Draft

> **Skill:** `flow` · **Guide:** `docs/reference/guide.md`
EOF
  st_baseline "a tree whose citations all resolve"

  printf 'Read `planning/src/missing.md` first.\n' >> "$g"
  probe "check 1 fires on a path that does not exist" "check 1"
  sed -i '$d' "$g"

  sed -i 's/^skills: \[flow\]/skills: [flow, continuity]/' "$wf/STEPS.md"
  probe "check 2 fires on frontmatter routing to an absent skill" "check 2"
  sed -i 's/^skills: \[flow, continuity\]/skills: [flow]/' "$wf/STEPS.md"

  printf '\n## 2. Check\n\n> **Skill:** `continuity` · **Guide:** none\n' >> "$wf/STEPS.md"
  probe "check 3 fires on a Skill line naming an absent skill" "check 3"
  head -n -4 "$wf/STEPS.md" > "$tmp/s" && cat "$tmp/s" > "$wf/STEPS.md"

  printf 'Each `drafts/` carries a README; every `docs/project/` is yours.\n' >> "$g"
  probe_clean "a generic folder-class name is not a citation"
  sed -i '$d' "$g"

  printf 'Characters live in `world/src/characters/`.\n' >> "$g"
  probe "check 1 fires on a gated layer this tree does not ship" "check 1 — manuscript/docs/reference/guide.md"
  sed -i '$d' "$g"

  printf 'Then run the `continuity` skill.\n' >> "$g"
  probe "check 4 fires on prose naming a variant skill this tree lacks" "check 4"
  sed -i '$d' "$g"

  sed -i 's/(`research`)/(`continuity`)/' "$t/.claude/skills/flow/SKILL.md"
  probe "check 4 fires on a folded description naming a skill this tree lacks" \
    "check 4 — .claude/skills/flow/SKILL.md:3 description"
  sed -i 's/(`continuity`)/(`research`)/' "$t/.claude/skills/flow/SKILL.md"

  st_finish "a tree whose citations resolve from one with dead ends"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ ${#TARGETS[@]} -gt 0 ]] || die "no rendered tree given — citations are checked in the tree each reader will have (see generate-all.sh)"

bold "▸ $SCRIPT_NAME"
STATUS=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREE="$(cd "$target" && pwd)"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $TREE — $TOKENS backticked token(s), $PATH_TESTS tested as paths, all resolve"
  else
    bold "✗ $TREE — ${#FINDINGS[@]} finding(s) ($TOKENS token(s), $PATH_TESTS tested as paths):"
    print_findings
    STATUS=1
  fi
done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ Every citation resolves in the tree that carries it."
  exit 0
fi
log "  A shared file may only name what every variant ships. Gate the row in its index file"
log "  (DESIGN.md Section 2), name the path in the mode file instead, or fix the path. A"
log "  description naming a gated-out skill names it in words, without backticks."
exit 1
