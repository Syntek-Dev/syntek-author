#!/usr/bin/env bash
#
# generate-all.sh — Render every variant and profile of the template, for the audits to read.
#
#                   A template defect is invisible until somebody generates, and whoever
#                   generates is not whoever broke it (SB rules 42–43). syntek-author renders
#                   three variants from one tree, each with options, so a mistake in one gate
#                   shows only in the render paths that open it — and the path nobody renders
#                   is the one that rots. So every audit that reads a render reads ALL of them.
#
#                   Renders, per DOC_TYPE (theology, fiction, business):
#                     defaults   only the answers that have no default
#                     all-on     every option the variant offers set true (business: every
#                                document family, msp-scp included)
#                     minimal    every option the variant offers set false — the negative path
#                                (business: BUSINESS_FAMILIES=[business], the one family that
#                                cannot be dropped)
#                     adoption   SEED_EXAMPLES=false, as `copier copy` into an existing repository
#                   plus, for fiction,
#                     conlang    FICTION_GENRE=literary with INCLUDE_WORLDBUILDING and
#                                INCLUDE_CONLANG set true explicitly, so the kit is proven to open
#                                on the answer and not only on the fantasy default.
#
#                   It renders from a SNAPSHOT: the working tree is copied with rsync (without
#                   .git), committed in a temporary repository, and rendered with
#                   `--vcs-ref=HEAD`. Copier reads a template over git, so rendering the real
#                   repository would render its last commit and silently ignore the work in
#                   front of you (SB rule 17). .gitignore is honoured, exactly as a commit would.
#
#                   Output: one directory per render, OUTDIR/<doc_type>-<profile>/, beside
#                     OUTDIR/<name>.log     Copier's output
#                     OUTDIR/<name>.expect  the answers DESIGN.md says that render should
#                                           record (shipped-variants.sh compares them)
#                   and one tree path per successful render on stdout. Progress goes to stderr.
#
#                   Two checks:
#                     1. Every requested render succeeds.
#                     2. Every render carries .copier-answers.syntek-author.yml — without it a
#                        project can never be updated, and no audit can tell what it holds.
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: anything about what the renders CONTAIN. That is the
#                   job of every per-tree audit (run-all.sh runs them over this output).
#
# SELF-TEST. --self-test builds a fixture template at runtime with an uncommitted file in it,
#            renders it, asserts the uncommitted file reached the render (the snapshot works),
#            then breaks the fixture once per check and asserts exactly one finding each.
#
# Requirements: bash 4.3+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#
# Usage: generate-all.sh [OUTDIR] [--root DIR] [--only NAME[,NAME…]] [--jobs N] [--list]
#                        [--quiet] [--self-test] [--help]
#        OUTDIR defaults to ${TMPDIR:-/tmp}/syntek-author-render.
#
# Exit codes:  0 = every render succeeded
#              1 = a render failed or is incomplete, or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, no copier.yml)

set -euo pipefail
SCRIPT_NAME="generate-all.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

OUT="${TMPDIR:-/tmp}/syntek-author-render"
ONLY=""
JOBS=4
LIST=false
SELF_TEST=false

usage() {
  cat <<'EOF'
generate-all.sh — Render every variant and profile of the template

Usage: generate-all.sh [OUTDIR] [--root DIR] [--only NAME[,NAME…]] [--jobs N] [--list]
                       [--quiet] [--self-test] [--help]

  OUTDIR       Where the renders go (default: ${TMPDIR:-/tmp}/syntek-author-render)
  --root DIR   The template repository (default: this repository)
  --only LIST  Render only these, e.g. theology-defaults,fiction-conlang
  --jobs N     Renders to run at once (default 4)
  --list       Print the render names and exit
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture template
  --help       Show this message

Prints one rendered tree path per line on stdout.
Exit codes: 0 = every render succeeded  1 = a render failed  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --only)      [[ $# -gt 1 ]] || die "--only needs a value"; ONLY="$2"; shift 2 ;;
    --jobs)      [[ $# -gt 1 && "$2" =~ ^[1-9][0-9]*$ ]] || die "--jobs needs a positive number"; JOBS="$2"; shift 2 ;;
    --list)      LIST=true; shift ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           OUT="$1"; shift ;;
  esac
done

# ── The render matrix ────────────────────────────────────────────────────────
#
# name · extra --data answers. Only options the variant SHOWS are passed: a hidden question's
# value comes from its default, which is exactly what a real generation sees. A list answer is
# a YAML flow list with no spaces (fields split on whitespace), which Copier parses as a list.
RENDERS=$(cat <<'EOF'
theology-defaults
theology-all-on      INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true
theology-minimal     INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false
theology-adoption    SEED_EXAMPLES=false
fiction-defaults
fiction-all-on       INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-minimal      FICTION_GENRE=literary INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false INCLUDE_WORLDBUILDING=false
fiction-conlang      FICTION_GENRE=literary INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-adoption     SEED_EXAMPLES=false
business-defaults
business-all-on      INCLUDE_REFERENCES=true INCLUDE_DRIVE_SYNC=true BUSINESS_FAMILIES=[business,legal,email,accounting,social-media,msp-scp]
business-minimal     INCLUDE_REFERENCES=false INCLUDE_DRIVE_SYNC=false BUSINESS_FAMILIES=[business]
business-adoption    SEED_EXAMPLES=false
EOF
)

render_names() { awk '{ print $1 }' <<< "$RENDERS"; }
render_data()  { awk -v n="$1" '$1 == n { for (i = 2; i <= NF; i++) print $i }' <<< "$RENDERS"; }

# What DESIGN.md Section 2 says the render should record: the variant's defaults, then the
# profile's answers on top. A literary novel defaults the worldbuilding kit off.
expect_for() { # $1 = name → KEY=value lines
  local name="$1" doc="${1%%-*}" kv k v
  local -A e=([DOC_TYPE]="$doc" [INCLUDE_PROPOSAL]=false [INCLUDE_REFERENCES]=false
              [INCLUDE_SENSITIVE_CONTENT]=false [INCLUDE_WORLDBUILDING]=false [INCLUDE_CONLANG]=false
              [INCLUDE_DRIVE_SYNC]=false [SEED_EXAMPLES]=true [MODEL_MECHANICAL]=sonnet)
  case "$doc" in
    theology) e[INCLUDE_PROPOSAL]=true; e[INCLUDE_REFERENCES]=true; e[AUDIENCE]=lay ;;
    fiction)  e[INCLUDE_PROPOSAL]=true; e[AUDIENCE]=adult; e[INCLUDE_WORLDBUILDING]=true; e[INCLUDE_CONLANG]=true ;;
    business) e[MODEL_MECHANICAL]=opus; e[AUDIENCE]=client; e[BUSINESS_FAMILIES]="${SA_FAMILIES_DEFAULT// /,}" ;;
  esac
  while IFS= read -r kv; do
    [[ -z "$kv" ]] && continue
    k="${kv%%=*}"; v="${kv#*=}"
    if [[ "$k" == FICTION_GENRE && "$v" != fantasy && "$v" != science-fiction ]]; then
      e[INCLUDE_WORLDBUILDING]=false; e[INCLUDE_CONLANG]=false
    fi
    [[ "$k" == FICTION_GENRE ]] && continue
    # A list answer is expected as its values joined by commas, as shipped-variants.sh reads it.
    [[ "$v" == '['*']' ]] && { v="${v#[}"; v="${v%]}"; }
    e["$k"]="$v"
  done < <(render_data "$name")
  # INCLUDE_CONLANG defaults to INCLUDE_WORLDBUILDING and is hidden without it.
  if [[ "${e[INCLUDE_WORLDBUILDING]}" == false ]]; then e[INCLUDE_CONLANG]=false; fi
  for k in DOC_TYPE INCLUDE_PROPOSAL INCLUDE_REFERENCES INCLUDE_SENSITIVE_CONTENT INCLUDE_WORLDBUILDING \
           INCLUDE_CONLANG INCLUDE_DRIVE_SYNC SEED_EXAMPLES MODEL_MECHANICAL AUDIENCE BUSINESS_FAMILIES; do
    [[ -n "${e[$k]:-}" ]] && printf '%s=%s\n' "$k" "${e[$k]}"
  done
  # The last key is unset outside business; that must not be this function's status (set -e).
  return 0
}

SELECTED=()
select_renders() {
  local n
  SELECTED=()
  if [[ -z "$ONLY" ]]; then
    mapfile -t SELECTED < <(render_names)
    return 0
  fi
  for n in ${ONLY//,/ }; do
    render_names | grep -qxF "$n" || die "no such render: $n (see --list)"
    SELECTED+=("$n")
  done
}

# ── Rendering ────────────────────────────────────────────────────────────────

SNAP=""
render_one() { # $1 = name — writes OUT/name, OUT/name.log, OUT/name.status, OUT/name.expect
  local name="$1" doc="${1%%-*}" args=() kv status=0
  while IFS= read -r kv; do [[ -n "$kv" ]] && args+=(--data "$kv"); done < <(render_data "$name")
  rm -rf "${OUT:?}/$name" "$OUT/$name.log" "$OUT/$name.status" "$OUT/$name.expect"
  expect_for "$name" > "$OUT/$name.expect"
  sa_render "$SNAP" "$OUT/$name" "$doc" "${args[@]}" > "$OUT/$name.log" 2>&1 || status=$?
  printf '%s\n' "$status" > "$OUT/$name.status"
}

generate() {
  local name running=0 work
  mkdir -p "$OUT"
  OUT="$(cd "$OUT" && pwd)"
  work="$(sa_mktemp)"
  SNAP="$work/snapshot"
  $QUIET || note "  snapshotting $SA_ROOT (working tree, .gitignore honoured)…"
  sa_snapshot "$SA_ROOT" "$SNAP" >/dev/null || { rm -rf "$work"; die "could not snapshot $SA_ROOT"; }
  for name in "${SELECTED[@]}"; do
    $QUIET || note "  rendering $name…"
    render_one "$name" &
    running=$((running + 1))
    if [[ "$running" -ge "$JOBS" ]]; then wait -n || true; running=$((running - 1)); fi
  done
  wait || true
  rm -rf "$work"
}

run_checks() {
  FINDINGS=()
  local name status err
  for name in "${SELECTED[@]}"; do
    status="$(cat "$OUT/$name.status" 2>/dev/null || echo 'did not run')"
    if [[ "$status" != 0 ]]; then
      err="$(grep -v '^[[:space:]]*$' "$OUT/$name.log" 2>/dev/null | tail -1 || true)"
      finding "check 1 — $name did not render (exit $status): ${err:-no output} — see $OUT/$name.log"
      continue
    fi
    [[ -f "$OUT/$name/$SA_ANSWERS_FILE" ]] \
      || finding "check 2 — $name has no $SA_ANSWERS_FILE — it can never be updated"
  done
}

# ── Self-test ────────────────────────────────────────────────────────────────

self_test() {
  local tmp real_root="$SA_ROOT" real_out="$OUT" real_only="$ONLY"
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/tpl" >/dev/null
  SA_ROOT="$tmp/tpl"; OUT="$tmp/out"
  printf '# Uncommitted\n' > "$SA_ROOT/template/UNCOMMITTED.md"

  ONLY="theology-defaults,business-defaults"; select_renders; generate 2>/dev/null
  st_baseline "the fixture template, rendered twice"
  [[ -f "$OUT/theology-defaults/UNCOMMITTED.md" ]] || {
    printf '\033[31m  ✗ an uncommitted file did not reach the render — the snapshot is not the working tree\033[0m\n' >&2; exit 2; }
  log "  ✓ an uncommitted file reached the render — the snapshot is the working tree"

  printf '<: if DOC_TYPE == :>broken\n' > "$SA_ROOT/template/library/src/BROKEN.md"
  generate 2>/dev/null
  probe "check 1 fires when one variant fails to render" "check 1 — business-defaults"
  rm -f "$SA_ROOT/template/library/src/BROKEN.md"

  mv "$SA_ROOT/template/$SA_ANSWERS_FILE" "$tmp/held"
  ONLY="theology-defaults"; select_renders; generate 2>/dev/null
  probe "check 2 fires when the answers file is not rendered" "check 2"
  mv "$tmp/held" "$SA_ROOT/template/$SA_ANSWERS_FILE"

  SA_ROOT="$real_root"; OUT="$real_out"; ONLY="$real_only"
  st_finish "a template that renders from one that does not"
}

if $LIST; then render_names; exit 0; fi
if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
command -v git >/dev/null 2>&1 || die "git is not installed"
copier_init
select_renders

$QUIET || note "▸ $SCRIPT_NAME — ${#SELECTED[@]} render(s) into $OUT"
generate
run_checks

for name in "${SELECTED[@]}"; do
  [[ "$(cat "$OUT/$name.status" 2>/dev/null)" == 0 ]] && printf '%s\n' "$OUT/$name"
done

if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  $QUIET || note "✓ ${#SELECTED[@]} render(s), every one complete."
  exit 0
fi
{
  printf '✗ %d finding(s):\n' "${#FINDINGS[@]}"
  print_findings
} >&2
exit 1
