#!/usr/bin/env bash
#
# byte-identity.sh — Verify shared files are byte-identical in every render that ships them.
#
#                    DESIGN.md Section 2 ("Token discipline") makes one promise that holds
#                    the three variants together: outside the spine set, a file that ships in
#                    two variants is the SAME file in both. That is what lets a skill be fixed
#                    once, reviewed once and updated everywhere, and it is what makes
#                    "variant differences live in gated files and mode files" true rather than
#                    aspirational. check-template-tokens.sh polices the SOURCE for the tokens
#                    and blocks that would break the promise; this script checks the promise
#                    itself, on the renders — so a difference that arrives some other way (a
#                    Copier variable, a filter, a profile option leaking into a shared file) is
#                    caught where it actually shows.
#
#                    One check:
#                      1. A file outside the spine set differs between two renders that both
#                         ship it.
#
#                    Compared: every file present in at least two renders. Skipped: .git/,
#                    the answers file, build/, audio/, __pycache__/ and tooling/references.db
#                    (generated after rendering, by `make init`), and the spine set — the root
#                    spine, every seed, every seed-once example and every index file (computed
#                    in _common.sh from DESIGN.md and copier.yml).
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: the spine set itself. A spine file may differ, but
#                    only on lines whose template source carries a variant token or block;
#                    proving that needs a line-level map from render to source that Jinja does
#                    not provide. check-template-tokens.sh keeps the spine set small instead.
#
# SELF-TEST. --self-test builds three small renders at runtime — a shared file, a spine file
#            that legitimately differs, a file only one render ships — proves them clean,
#            then changes the shared file in one render and asserts exactly one finding.
#
# Requirements: bash 4+, sha1sum, awk, find. No network.
#
# Usage: byte-identity.sh [--root DIR] [--quiet] [--self-test] [--help] <tree> <tree>...
#
# Exit codes:  0 = every shared file is identical wherever it ships
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (fewer than two trees, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="byte-identity.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
byte-identity.sh — Verify shared files are byte-identical in every render that ships them

Usage: byte-identity.sh [--root DIR] [--quiet] [--self-test] [--help] <tree> <tree>...

  --root DIR   The template repository whose copier.yml defines the spine set
  --quiet      Print findings only
  --self-test  Prove the check still fires against renders built at runtime
  --help       Show this message

Exit codes: 0 = identical  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           TARGETS+=("$1"); shift ;;
  esac
done

TREES=()
COMPARED=0
SPINE_SKIPPED=0

hash_tree() { # $1 = index, $2 = tree → index<TAB>hash<TAB>rel
  (cd "$2" && find . \( -name .git -o -name build -o -name audio -o -name __pycache__ \) -prune -o -type f -print0 \
     | xargs -0 -r sha1sum) \
    | awk -v i="$1" '{ h = $1; $1 = ""; sub(/^ +/, ""); sub(/^\.\//, ""); print i "\t" h "\t" $0 }' \
    | grep -v -e $'\t'"$SA_ANSWERS_FILE"'$' -e $'\ttooling/references.db$' || true
}

run_checks() {
  FINDINGS=()
  COMPARED=0; SPINE_SKIPPED=0
  local i rel groups name
  local -a names=()
  for i in "${!TREES[@]}"; do names+=("$(basename "${TREES[$i]}")"); done
  while IFS=$'\t' read -r rel groups; do
    [[ -z "$rel" ]] && continue
    if [[ "$groups" == SAME ]]; then
      if spine_kind "$rel" >/dev/null; then SPINE_SKIPPED=$((SPINE_SKIPPED + 1)); else COMPARED=$((COMPARED + 1)); fi
      continue
    fi
    if spine_kind "$rel" >/dev/null; then SPINE_SKIPPED=$((SPINE_SKIPPED + 1)); continue; fi
    COMPARED=$((COMPARED + 1))
    # groups: "0,1|2" — tree indexes sharing one version, versions separated by |
    name=""
    while IFS= read -r -d '|' g; do
      local members="" idx
      for idx in ${g//,/ }; do members+="${members:+, }${names[$idx]}"; done
      name+="${name:+  ≠  }{$members}"
    done <<< "$groups|"
    finding "check 1 — $rel differs between renders: $name"
  done < <(for i in "${!TREES[@]}"; do hash_tree "$i" "${TREES[$i]}"; done | awk -F'\t' '
      { key = $3; if (!(key in seen)) { seen[key] = 1; order[++n] = key }
        cnt[key]++
        if (!((key SUBSEP $2) in hv)) { hv[key SUBSEP $2] = ++nv[key]; vlist[key, nv[key]] = $2 }
        v = hv[key SUBSEP $2]; mem[key, v] = mem[key, v] (mem[key, v] == "" ? "" : ",") $1 }
      END {
        for (k = 1; k <= n; k++) {
          key = order[k]
          if (cnt[key] < 2) continue
          if (nv[key] == 1) { print key "\tSAME"; continue }
          out = ""
          for (v = 1; v <= nv[key]; v++) out = out (v > 1 ? "|" : "") mem[key, v]
          print key "\t" out
        }
      }')
}

# ── Self-test ────────────────────────────────────────────────────────────────

self_test() {
  local tmp t
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  build_sets ""
  TREES=()
  for t in theology fiction business; do
    mkdir -p "$tmp/$t/.claude/skills/flow" "$tmp/$t/.git"
    printf '# Skill: flow\n\nShared, word for word.\n' > "$tmp/$t/.claude/skills/flow/SKILL.md"
    printf '# A %s project\n' "$t" > "$tmp/$t/README.md"
    printf 'DOC_TYPE: %s\n' "$t" > "$tmp/$t/$SA_ANSWERS_FILE"
    printf 'ref: %s\n' "$t" > "$tmp/$t/.git/HEAD"
    TREES+=("$tmp/$t")
  done
  mkdir -p "$tmp/fiction/world"; printf '# World\n' > "$tmp/fiction/world/CONTEXT.md"
  st_baseline "three renders that differ only in the spine"

  printf '# Skill: flow\n\nShared, word for word — except here.\n' > "$tmp/business/.claude/skills/flow/SKILL.md"
  probe "check 1 fires when a shared skill differs in one render" "check 1 — .claude/skills/flow/SKILL.md differs"
  printf '# Skill: flow\n\nShared, word for word.\n' > "$tmp/business/.claude/skills/flow/SKILL.md"

  printf 'a different spine line\n' >> "$tmp/business/README.md"
  probe_clean "a spine file may differ between renders"

  st_finish "identical shared files from a shared file that varies"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ ${#TARGETS[@]} -ge 2 ]] || die "give at least two rendered trees — identity is a comparison"
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREES+=("$(cd "$target" && pwd)")
done
build_sets "$SA_ROOT/copier.yml"

bold "▸ $SCRIPT_NAME — ${#TREES[@]} render(s)"
run_checks
log "  compared $COMPARED shared file(s) present in two or more renders; $SPINE_SKIPPED spine file(s) exempt"
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ Every shared file is byte-identical wherever it ships."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
log ""
log "  A shared file must not vary by variant or option (DESIGN.md Section 2). Move the"
log "  difference into a gated file or a mode file, or — if the file is an index — gate its rows."
exit 1
