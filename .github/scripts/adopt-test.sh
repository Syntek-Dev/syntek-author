#!/usr/bin/env bash
#
# adopt-test.sh — Prove adopting an existing repository never touches the author's work.
#
#                 There is no `copier adopt`. An existing book becomes a syntek-author project
#                 by `copier copy --overwrite` into it (DESIGN.md Section 8), and --overwrite is
#                 exactly as dangerous as it sounds: it replaces every template-owned file that
#                 differs. What keeps the author's work safe is the ownership classes — a seed
#                 that already exists is skipped, the author's src/ is never a template path,
#                 and SEED_EXAMPLES=false keeps an invented chapter out of a real book. One
#                 wrong line in copier.yml and the copy writes over a MEMORY.md with two years
#                 of decisions in it, and reports success.
#
#                 So this test builds, at runtime, an anonymised repository shaped like a real
#                 theology book — a project brief, a memory with entries, settings, a README,
#                 a voice-and-tone file, chapters with prose, a workspace/ of handoffs and
#                 maps, flat docs — runs the advisory adopt/theology.sh --apply on a branch
#                 (when it exists), then `copier copy --overwrite --data SEED_EXAMPLES=false`,
#                 and compares.
#
#                 Ten checks:
#                   1. The copy succeeds.
#                   2. .claude/MEMORY.md is byte-for-byte untouched.
#                   3. Every other existing seed is untouched: .claude/CLAUDE.md,
#                      .claude/settings.json, README.md, .gitignore.
#                   4. Every file under manuscript/src/ that existed is untouched.
#                   5. Every file under standards/style/ that existed is untouched.
#                   6. No seed-once example was added.
#                   7. The answers file was written, recording SEED_EXAMPLES: false.
#                   8. Template-owned files arrived (.claude/rules/syntek-author/).
#                   9. adopt/theology.sh --apply succeeded (when the script exists).
#                  10. When the kept .gitignore ignores .claude/skills/build/ (the fixture's
#                      unanchored `build/` line does), the adoption report said so — otherwise
#                      the proof skill every variant needs is silently never committed.
#
#                 Numbers are stable identifiers. Append, never renumber.
#
#                 Copier prints a MissingFileWarning on this copy: the template reads the
#                 previous answers through _external_data (DESIGN.md D35), and an adopted
#                 repository has none yet. The warning is expected and never a finding; only
#                 the exit status of the copy is judged.
#
#                 What it CANNOT check: that the author's project-specific text the copy DID
#                 replace (a template-owned pair the repository had customised) was recovered —
#                 that is the review step of Section 8, done by a person reading `git diff`.
#
# SELF-TEST. --self-test runs the whole flow against a fixture template written at runtime,
#            proves it clean, then mutates the result once per check and asserts exactly one
#            finding each. The real adopt/ scripts are copied into the fixture at runtime, so
#            the advisory run (and its seed list, read from the fixture's copier.yml) is
#            exercised too.
#
# Requirements: bash 4+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#
# Usage: adopt-test.sh [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = adoption left every piece of the author's work as it was
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, no copier.yml)

set -euo pipefail
SCRIPT_NAME="adopt-test.sh"
# shellcheck source=_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false

usage() {
  cat <<'EOF'
adopt-test.sh — Prove adopting an existing repository never touches the author's work

Usage: adopt-test.sh [--root DIR] [--quiet] [--self-test] [--help]

  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture template
  --help       Show this message

Exit codes: 0 = untouched  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

PROJ=""; COPY_STATUS=0; ADOPT_STATUS=skipped; ADOPT_REPORT=""; BUILD_IGNORED=false
BUILD_NOTE="ignores every folder named build"
declare -A BEFORE=()

# An anonymised repository in the shape of a hand-built theology book. Every name is invented.
build_existing() { # $1 = dir
  local p="$1"
  mkdir -p "$p/.claude" "$p/standards/style" "$p/manuscript/src/01-the-lantern/drafts" \
    "$p/manuscript/src/02-the-road" "$p/workspace/handoffs" "$p/workspace/maps" "$p/docs"
  printf '# CLAUDE.md — The Lantern Road\n\nThe project brief, written by the author over two years.\n' > "$p/.claude/CLAUDE.md"
  cat > "$p/.claude/MEMORY.md" <<'EOF'
# MEMORY.md — the-lantern-road

## Facts

- **01/02/2026** — **Working title settled.** The Lantern Road, after a long argument.

## Decisions

- **14/03/2026** — **Chapter two leads with the parable.** The history waits until chapter three.
EOF
  printf '{\n  "model": "opus",\n  "autoCompactEnabled": false\n}\n' > "$p/.claude/settings.json"
  printf '# The Lantern Road\n\nA book in progress, by an invented author.\n' > "$p/README.md"
  printf 'build/\n.claude/settings.local.json\n' > "$p/.gitignore"
  printf '# Voice and tone\n\nShort sentences. Questions the reader is already asking.\n' > "$p/standards/style/voice-and-tone.md"
  printf '# Style sheet\n\n- Organise, never organize.\n' > "$p/standards/style/style-sheet.md"
  printf -- '---\ntitle: "The lantern"\nstatus: draft\n---\n\n# The lantern\n\nThe first paragraph the author wrote, and kept.\n' \
    > "$p/manuscript/src/01-the-lantern/01-the-lantern.md"
  printf '# Work in progress\n' > "$p/manuscript/src/01-the-lantern/drafts/README.md"
  printf -- '---\ntitle: "The road"\nstatus: stub\n---\n\n# The road\n\nNotes for a chapter not yet written.\n' \
    > "$p/manuscript/src/02-the-road/02-the-road.md"
  printf '# HANDOFF — lantern road\n' > "$p/workspace/handoffs/HANDOFF-LANTERN-ROAD-01-02-2026.md"
  printf '# MAP — the argument\n' > "$p/workspace/maps/MAP-ARGUMENT.md"
  printf '# House notes\n' > "$p/docs/house-notes.md"
  sa_git "$p" init -q && sa_git "$p" add -A && sa_git "$p" commit -q -m 'the book so far'
  sa_git "$p" checkout -q -b adopt-syntek-author
}

protected() { # the files whose bytes must not change, as they stand before the copy
  (cd "$PROJ" && {
    for f in .claude/MEMORY.md .claude/CLAUDE.md .claude/settings.json README.md .gitignore; do [[ -f "$f" ]] && echo "$f"; done
    find manuscript/src standards/style -type f 2>/dev/null | grep -vE '^(manuscript/src|standards/style)/(CONTEXT|CLAUDE)\.md$'
  } | sort -u)
}

run_flow() { # $1 = template repo, $2 = work dir — fills the state
  local tpl="$2/tpl" log="$2/flow.log" script f
  PROJ="$2/proj"; COPY_STATUS=0; ADOPT_STATUS=skipped; ADOPT_REPORT="$2/adopt.log"; BUILD_IGNORED=false; BEFORE=()
  : > "$ADOPT_REPORT"
  sa_snapshot "$1" "$tpl" >>"$log" 2>&1 || die "could not snapshot $1"
  build_existing "$PROJ" >>"$log" 2>&1
  script="$1/adopt/theology.sh"
  if [[ -f "$script" ]]; then
    ADOPT_STATUS=0
    bash "$script" --apply "$PROJ" >"$ADOPT_REPORT" 2>&1 || ADOPT_STATUS=$?
    cat "$ADOPT_REPORT" >>"$log"
    sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'adopt: safe moves' >>"$log" 2>&1 || true
  fi
  while IFS= read -r f; do BEFORE["$f"]="$(sha1sum < "$PROJ/$f")"; done < <(protected)
  sa_render "$tpl" "$PROJ" theology --overwrite --data SEED_EXAMPLES=false >>"$log" 2>&1 || COPY_STATUS=$?
  if sa_git "$PROJ" check-ignore -q .claude/skills/build/SKILL.md 2>/dev/null; then BUILD_IGNORED=true; fi
}

run_checks() {
  FINDINGS=()
  local f e now n
  if [[ "$COPY_STATUS" -ne 0 ]]; then
    finding "check 1 — copier copy --overwrite into the existing repository failed (exit $COPY_STATUS)"
    return 0
  fi
  for f in "${!BEFORE[@]}"; do
    now="$( [[ -f "$PROJ/$f" ]] && sha1sum < "$PROJ/$f" || echo gone)"
    [[ "$now" == "${BEFORE[$f]}" ]] && continue
    case "$f" in
      .claude/MEMORY.md) n=2 ;;
      manuscript/src/*)  n=4 ;;
      standards/style/*) n=5 ;;
      *)                 n=3 ;;
    esac
    finding "check $n — adoption changed the author's $f"
  done
  for e in $SA_EXAMPLES; do
    [[ -e "$PROJ/$e" ]] && finding "check 6 — adoption added the example $e (SEED_EXAMPLES=false)"
  done
  if [[ ! -f "$PROJ/$SA_ANSWERS_FILE" ]]; then
    finding "check 7 — no $SA_ANSWERS_FILE after adoption — the project can never be updated"
  elif [[ "$(answer_value SEED_EXAMPLES "$PROJ/$SA_ANSWERS_FILE")" != false ]]; then
    finding "check 7 — $SA_ANSWERS_FILE does not record SEED_EXAMPLES: false"
  fi
  [[ -n "$(find "$PROJ/.claude/rules/syntek-author" -type f 2>/dev/null | head -1)" ]] \
    || finding "check 8 — no template-owned rules arrived in .claude/rules/syntek-author/"
  [[ "$ADOPT_STATUS" == skipped || "$ADOPT_STATUS" == 0 ]] \
    || finding "check 9 — adopt/theology.sh --apply failed (exit $ADOPT_STATUS)"
  if $BUILD_IGNORED && ! grep -qF "$BUILD_NOTE" "$ADOPT_REPORT" 2>/dev/null; then
    finding "check 10 — the kept .gitignore ignores .claude/skills/build/ and the adoption report did not say so — the build skill would never be committed"
  fi
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/fixture" >/dev/null
  cp -R "$SA_ROOT/adopt" "$tmp/fixture/adopt"
  run_flow "$tmp/fixture" "$tmp"
  $BUILD_IGNORED || { printf '\033[31m  ✗ the fixture .gitignore no longer hides the build skill — check 10 would never be exercised\033[0m\n' >&2; exit 2; }
  st_baseline "a real adoption by the fixture template"

  COPY_STATUS=1; probe "check 1 fires when the copy fails" "check 1"; COPY_STATUS=0
  cp "$PROJ/.claude/MEMORY.md" "$tmp/h"; printf 'overwritten\n' > "$PROJ/.claude/MEMORY.md"
  probe "check 2 fires when MEMORY.md is overwritten" "check 2"; cp "$tmp/h" "$PROJ/.claude/MEMORY.md"
  cp "$PROJ/README.md" "$tmp/h"; printf 'overwritten\n' > "$PROJ/README.md"
  probe "check 3 fires when the README is overwritten" "check 3 — adoption changed the author's README.md"; cp "$tmp/h" "$PROJ/README.md"
  cp "$PROJ/manuscript/src/01-the-lantern/01-the-lantern.md" "$tmp/h"; printf 'rewritten\n' >> "$PROJ/manuscript/src/01-the-lantern/01-the-lantern.md"
  probe "check 4 fires when a chapter changes" "check 4"; cp "$tmp/h" "$PROJ/manuscript/src/01-the-lantern/01-the-lantern.md"
  cp "$PROJ/standards/style/style-sheet.md" "$tmp/h"; printf 'replaced\n' > "$PROJ/standards/style/style-sheet.md"
  probe "check 5 fires when the style sheet changes" "check 5"; cp "$tmp/h" "$PROJ/standards/style/style-sheet.md"
  mkdir -p "$PROJ/manuscript/src/01-example-chapter"; probe "check 6 fires when an example is added" "check 6"; rmdir "$PROJ/manuscript/src/01-example-chapter"
  mv "$PROJ/$SA_ANSWERS_FILE" "$tmp/h"; probe "check 7 fires when no answers file is written" "check 7"; mv "$tmp/h" "$PROJ/$SA_ANSWERS_FILE"
  mv "$PROJ/.claude/rules" "$tmp/h"; probe "check 8 fires when no template-owned file arrives" "check 8"; mv "$tmp/h" "$PROJ/.claude/rules"
  ADOPT_STATUS=1; probe "check 9 fires when the adoption script fails" "check 9"; ADOPT_STATUS=0
  cp "$ADOPT_REPORT" "$tmp/h"; grep -vF "$BUILD_NOTE" "$tmp/h" > "$ADOPT_REPORT" || true
  probe "check 10 fires when the report misses the unanchored build/ line" "check 10"; cp "$tmp/h" "$ADOPT_REPORT"
  st_finish "an adoption that leaves the author's work alone from one that does not"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
copier_init
bold "▸ $SCRIPT_NAME"
work="$(sa_mktemp)"
run_flow "$SA_ROOT" "$work"
run_checks
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  log "  ✓ ${#BEFORE[@]} author file(s) byte-identical after adoption; no example added; answers written"
  if [[ "$ADOPT_STATUS" == skipped ]]; then log "  (adopt/theology.sh not found — the copy alone was tested)"
  else log "  adopt/theology.sh --apply ran first and succeeded, and reported the unanchored build/ line"; fi
  rm -rf "$work"
  bold "✓ Adoption leaves every piece of the author's work as it was."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s) (work kept in $work; output in $work/flow.log):"
print_findings
log ""
log "  An existing seed must be in _skip_if_exists; an example needs its copy-only gate"
log "  (DESIGN.md Sections 3.1, 3.2 and 8)."
exit 1
