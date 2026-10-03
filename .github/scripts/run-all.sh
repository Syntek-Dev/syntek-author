#!/usr/bin/env bash
#
# run-all.sh — Run every audit and test in DESIGN.md Section 7, rendering the template once.
#
#              Seventeen scripts, three kinds of input: the template source (tokens, mode
#              excludes, pairs, line cap, scrub, isolation, seeds, skills), the renders (shipped
#              variants, byte identity, references, pairs, seeds, skills, tooling), and their own
#              scratch projects (update, adoption, coexistence). Rendering is the expensive part,
#              so it happens once, and every per-tree audit reads the same thirteen renders.
#
#              Discipline, from SB: every script's --self-test runs FIRST, because a detector
#              nobody has seen fail is a detector nobody knows works (rule 38); failures
#              ACCUMULATE rather than stopping the run, so one broken gate never hides
#              another (rule 43); and a script that could not run is an error, never a pass
#              (rule 49).
#
#              Three checks, on the run itself:
#                1. An audit or test reported findings (exit 1).
#                2. An audit or test could not run (exit 2, or any other failure).
#                3. A self-test no longer separates good input from bad.
#
#              Numbers are stable identifiers. Append, never renumber.
#
#              What it CANNOT check: anything the seventeen cannot. It adds no check of its own
#              to the template; it only refuses to let one of theirs go unrun or unread.
#
# SELF-TEST. --self-test points the runner at stub scripts written at runtime, proves an
#            all-green run is green, then breaks one stub per check and asserts exactly one
#            finding naming it.
#
# Requirements: those of the scripts it runs (bash, git, rsync, uvx, python3, make; pandoc and
#               xelatex optional).
#
# Usage: run-all.sh [--out DIR] [--keep] [--no-self-test] [--skip-integration]
#                   [--require-pandoc] [--skip-pdf] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = every audit and test passed
#              1 = findings, or the self-test no longer separates
#              2 = something could not run (the run is incomplete — fix that first)

set -euo pipefail
SCRIPT_NAME="run-all.sh"
# shellcheck source=_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SCRIPTS="$SA_SCRIPTS_DIR"
OUT=""
KEEP=false
SELF_TESTS=true
INTEGRATION=true
SMOKE_ARGS=()
SELF_TEST=false

usage() {
  cat <<'EOF'
run-all.sh — Run every audit and test, rendering the template once

Usage: run-all.sh [--out DIR] [--keep] [--no-self-test] [--skip-integration]
                  [--require-pandoc] [--skip-pdf] [--quiet] [--self-test] [--help]

  --out DIR           Render into DIR (default: a temporary directory)
  --keep              Keep the renders afterwards
  --no-self-test      Skip each script's --self-test (faster; not for CI)
  --skip-integration  Skip update-test, adopt-test and coexist-test
  --require-pandoc    Passed to tooling-smoke.sh
  --skip-pdf          Passed to tooling-smoke.sh
  --quiet             Print only failing steps and the summary
  --self-test         Prove the runner reports what it runs, against stub scripts
  --help              Show this message

Exit codes: 0 = all passed  1 = findings  2 = something could not run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out)              [[ $# -gt 1 ]] || die "--out needs a value"; OUT="$2"; shift 2 ;;
    --keep)             KEEP=true; shift ;;
    --no-self-test)     SELF_TESTS=false; shift ;;
    --skip-integration) INTEGRATION=false; shift ;;
    --require-pandoc)   SMOKE_ARGS+=(--require-pandoc); shift ;;
    --skip-pdf)         SMOKE_ARGS+=(--skip-pdf); shift ;;
    --root)             [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)         QUIET=true; shift ;;
    --self-test)        SELF_TEST=true; shift ;;
    --help|-h)          usage; exit 0 ;;
    *)                  die "unknown argument: $1" ;;
  esac
done

STATIC=(check-template-tokens gen-mode-excludes docs-pairing line-cap scrub dev-isolation shipped-seeds skill-conformance)
PER_TREE=(shipped-variants byte-identity doc-references docs-pairing shipped-seeds skill-conformance tooling-smoke)
INTEGRATED=(update-test adopt-test coexist-test)
ALL_SCRIPTS=(check-template-tokens gen-mode-excludes generate-all shipped-variants byte-identity docs-pairing
             doc-references shipped-seeds skill-conformance line-cap update-test adopt-test coexist-test
             tooling-smoke scrub dev-isolation)

RESULTS=()   # "name<TAB>status"
ERRORS=0
STEP_SINK=""  # empty: steps print to the terminal; a path: they print there (the self-test)

emit() { if [[ -n "$STEP_SINK" ]]; then printf '%s\n' "$*" >> "$STEP_SINK"; else printf '%s\n' "$*"; fi; }
section() { if [[ -n "$STEP_SINK" ]]; then emit "━━ $1"; else bold "━━ $1"; fi; }

step() { # $1 = label, then the command — runs it, records it, never stops the run
  local label="$1" s=0 out
  shift
  out="$("$@" 2>&1)" || s=$?
  if [[ "$s" -eq 0 ]]; then
    $QUIET || emit "$out" ""
    RESULTS+=("$label"$'\t'"pass")
    return 0
  fi
  emit "$out" ""
  case "$s" in
    1) RESULTS+=("$label"$'\t'"findings")
       if [[ "$label" == *--self-test* ]]; then finding "check 3 — $label: the self-test no longer separates"
       else finding "check 1 — $label reported findings"; fi ;;
    *) RESULTS+=("$label"$'\t'"ERROR (exit $s)"); ERRORS=$((ERRORS + 1))
       finding "check 2 — $label could not run (exit $s)" ;;
  esac
}

run_checks() {
  FINDINGS=(); RESULTS=(); ERRORS=0
  local s out trees=() gen=0
  if $SELF_TESTS; then
    section "Self-tests"
    for s in "${ALL_SCRIPTS[@]}"; do step "$s --self-test" bash "$SCRIPTS/$s.sh" --self-test; done
  fi

  section "The template source"
  for s in "${STATIC[@]}"; do
    case "$s" in
      gen-mode-excludes) step "$s --check" bash "$SCRIPTS/$s.sh" --check --root "$SA_ROOT" ;;
      dev-isolation|scrub|check-template-tokens) step "$s" bash "$SCRIPTS/$s.sh" --root "$SA_ROOT" ;;
      *) step "$s (template/)" bash "$SCRIPTS/$s.sh" --root "$SA_ROOT" ;;
    esac
  done

  section "Rendering"
  out="$OUT"
  [[ -n "$out" ]] || out="$(sa_mktemp)/renders"
  mapfile -t trees < <(bash "$SCRIPTS/generate-all.sh" "$out" --root "$SA_ROOT" --quiet 2>"$out.gen-err") || gen=$?
  case "$gen" in
    0) RESULTS+=("generate-all"$'\t'"pass") ;;
    1) RESULTS+=("generate-all"$'\t'"findings"); emit "$(cat "$out.gen-err")"; finding "check 1 — generate-all: a render failed" ;;
    *) RESULTS+=("generate-all"$'\t'"ERROR (exit $gen)"); ERRORS=$((ERRORS + 1)); emit "$(cat "$out.gen-err" 2>/dev/null)"
       finding "check 2 — generate-all could not run (exit $gen)" ;;
  esac
  $QUIET || emit "  ${#trees[@]} render(s) in $out" ""

  if [[ ${#trees[@]} -gt 0 ]]; then
    section "The renders"
    for s in "${PER_TREE[@]}"; do
      case "$s" in
        byte-identity)
          if [[ ${#trees[@]} -ge 2 ]]; then step "$s (renders)" bash "$SCRIPTS/$s.sh" --root "$SA_ROOT" "${trees[@]}"; fi ;;
        tooling-smoke)
          step "$s (renders)" bash "$SCRIPTS/$s.sh" "${SMOKE_ARGS[@]}" "${trees[@]}" ;;
        shipped-variants|doc-references)
          step "$s (renders)" bash "$SCRIPTS/$s.sh" "${trees[@]}" ;;
        *)
          step "$s (renders)" bash "$SCRIPTS/$s.sh" --root "$SA_ROOT" "${trees[@]}" ;;
      esac
    done
  fi

  if $INTEGRATION; then
    section "Update, adoption, coexistence"
    for s in "${INTEGRATED[@]}"; do step "$s" bash "$SCRIPTS/$s.sh" --root "$SA_ROOT"; done
  fi

  if [[ -z "$OUT" ]] && ! $KEEP; then rm -rf "$(dirname "$out")"; fi
  rm -f "$out.gen-err" 2>/dev/null || true
}

summary() {
  local r
  printf '\033[1m━━ Summary\033[0m\n'   # always printed, --quiet or not
  for r in "${RESULTS[@]}"; do
    printf '  %-44s %s\n' "${r%%$'\t'*}" "${r#*$'\t'}"
  done
}

# ── Self-test ────────────────────────────────────────────────────────────────

write_stubs() { # $1 = dir. Each stub obeys STUB_FAIL="<name>:<run|self>:<code>".
  local d="$1" s
  mkdir -p "$d"
  for s in "${ALL_SCRIPTS[@]}"; do
    cat > "$d/$s.sh" <<EOF
#!/usr/bin/env bash
mode=run; for a in "\$@"; do [ "\$a" = --self-test ] && mode=self; done
if [ "\${STUB_FAIL:-}" = "$s:\$mode:1" ]; then echo "$s: a finding"; exit 1; fi
if [ "\${STUB_FAIL:-}" = "$s:\$mode:2" ]; then echo "$s: cannot run"; exit 2; fi
if [ "$s" = generate-all ] && [ "\$mode" = run ]; then
  out="\$1"; mkdir -p "\$out/theology-defaults" "\$out/fiction-defaults"
  echo "\$out/theology-defaults"; echo "\$out/fiction-defaults"
fi
exit 0
EOF
  done
}

self_test() {
  local tmp real_scripts="$SCRIPTS"
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  write_stubs "$tmp/stubs"
  SCRIPTS="$tmp/stubs"; OUT="$tmp/out"; STEP_SINK="$tmp/sink"
  export STUB_FAIL=""
  st_baseline "a run of stubs that all pass"
  STUB_FAIL="scrub:run:1";         probe "check 1 fires when an audit reports findings" "check 1 — scrub reported findings"
  STUB_FAIL="byte-identity:run:2"; probe "check 2 fires when an audit cannot run" "check 2 — byte-identity (renders) could not run"
  STUB_FAIL="line-cap:self:1";     probe "check 3 fires when a self-test stops separating" "check 3 — line-cap --self-test"
  STUB_FAIL=""
  SCRIPTS="$real_scripts"; OUT=""; STEP_SINK=""
  st_finish "a run that reports every failure from one that hides them"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
bold "▸ $SCRIPT_NAME — $SA_ROOT"
log ""
run_checks
summary
log ""
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  printf '\033[1m✓ Every audit and test passed.\033[0m\n'
  exit 0
fi
printf '\033[1m✗ %d failing step(s):\033[0m\n' "${#FINDINGS[@]}"
print_findings
[[ "$ERRORS" -gt 0 ]] && exit 2
exit 1
