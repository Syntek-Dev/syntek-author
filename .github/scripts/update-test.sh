#!/usr/bin/env bash
#
# update-test.sh — Prove `copier update` keeps the author's work and delivers the template's.
#
#                  A generated project lives for years and takes template improvements by
#                  `copier update`. Each ownership class (DESIGN.md D14) is a promise about
#                  what an update does: a seed the author edited is kept, and one they deleted
#                  comes back; a seed-once example they deleted stays deleted; their own files
#                  are never touched; a template-owned file takes the new version. Every one of
#                  those promises rests on a line in copier.yml, and none of them fails loudly
#                  when the line is wrong — the update reports success either way. So this test
#                  performs a real update, the way an author would meet it:
#
#                    1. snapshot the working tree as a template and render a project from it;
#                    2. act as the author: add a MEMORY.md entry, add a style-sheet rule,
#                       delete the seed-once example, delete voice-notes.md, write a unit of
#                       their own; commit;
#                    3. change a template-owned skill in the template; commit;
#                    4. `copier update` (naming the answers file, which is not Copier's default);
#                    5. commit, clone the project, and in the clone try an update that changes
#                       DOC_TYPE, which the template must refuse (DESIGN.md D35);
#                    6. assert.
#
#                  Twelve checks, per DOC_TYPE:
#                    1. The project renders.
#                    2. `copier update` succeeds.
#                    3. The author's MEMORY.md entry survives.
#                    4. The author's style-sheet rule survives.
#                    5. The deleted example stays deleted.
#                    6. The deleted voice-notes.md comes back (skills cite it).
#                    7. The author's own unit is byte-for-byte untouched.
#                    8. The template-owned skill carries the template's change.
#                    9. No conflict is left behind (no *.rej file, no conflict marker).
#                   10. An update that changes DOC_TYPE is refused, by DOC_TYPE's own validator
#                       (D35), not by some other failure such as a dirty tree.
#                   11. The refused update touched nothing: the clone's work tree is clean and
#                       its answers file still records the original DOC_TYPE.
#                   12. The update printed the option-off warning (_message_before_update),
#                       naming every INCLUDE_* option — the only warning an author gets before
#                       an option turned off deletes the seeds they filled in.
#
#                  A fresh copy prints a MissingFileWarning (the template reads the previous
#                  answers through _external_data, and a new project has none). It is expected
#                  and never a finding: only exit statuses and files are judged.
#
#                  Numbers are stable identifiers. Append, never renumber.
#
#                  What it CANNOT check: a migration between real releases (this changes one
#                  file between two commits), or an update that moves a folder holding author
#                  work — that needs a _migrations entry, written with the release that moves
#                  it (DESIGN.md D26, SB rule 33).
#
# SELF-TEST. --self-test runs the whole flow against a fixture template written at runtime,
#            proves the result clean, then mutates the result once per check and asserts
#            exactly one finding each.
#
# Requirements: bash 4+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#
# Usage: update-test.sh [--root DIR] [--doc-type T[,T…]] [--quiet] [--self-test] [--help]
#        --doc-type defaults to theology,fiction,business.
#
# Exit codes:  0 = every promise held, for every DOC_TYPE tested
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, a template with nothing to update)

set -euo pipefail
SCRIPT_NAME="update-test.sh"
# shellcheck source=_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

DOC_TYPES="theology,fiction,business"
SELF_TEST=false

usage() {
  cat <<'EOF'
update-test.sh — Prove `copier update` keeps the author's work and delivers the template's

Usage: update-test.sh [--root DIR] [--doc-type T[,T…]] [--quiet] [--self-test] [--help]

  --root DIR       The template repository (default: this repository)
  --doc-type LIST  Which variants to test (default: theology,fiction,business)
  --quiet          Print findings only
  --self-test      Prove the checks still fire against a fixture template
  --help           Show this message

Exit codes: 0 = every promise held  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --doc-type)  [[ $# -gt 1 ]] || die "--doc-type needs a value"; DOC_TYPES="$2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

MEMORY_MARK="Update-test entry"
STYLE_MARK="Update-test: an author's own style rule."
TEMPLATE_MARK="<!-- update-test: a template change -->"
DOCTYPE_REFUSAL="DOC_TYPE cannot change on update"
MESSAGE_MARK="Before you answer: turning an option off deletes"
OPTIONS="INCLUDE_PROPOSAL INCLUDE_WORLDBUILDING INCLUDE_CONLANG INCLUDE_REFERENCES INCLUDE_SENSITIVE_CONTENT INCLUDE_DRIVE_SYNC"

# State the checks read. --self-test mutates it.
DOC=""; PROJ=""; COPY_STATUS=0; UPDATE_STATUS=0; AUTHOR_FILE=""; AUTHOR_SUM=""; TARGET_REL=""
UPDATE_LOG=""; SWITCH_STATUS=0; SWITCH_LOG=""; SWITCH_DIRTY=""; SWITCH_RECORDED=""
DELETED=()

other_doc() { # the variant a DOC_TYPE change is attempted to
  case "$1" in theology) echo fiction ;; fiction) echo business ;; *) echo theology ;; esac
}

BOOK_LEDGER="standards/style/ledger/01-example-chapter--the-turn.md standards/style/ledger/01-example-chapter--opening.md"
examples_for() { # the seed-once examples a DOC_TYPE receives
  case "$1" in
    theology) echo "manuscript/src/01-example-chapter planning/src/units/01-example-chapter.md planning/src/arguments/01-example-chapter.md $BOOK_LEDGER" ;;
    fiction)  echo "manuscript/src/01-example-chapter planning/src/units/01-example-chapter.md $BOOK_LEDGER" ;;
    business) echo "library/src/proposals/drafts/example-proposal planning/src/units/example-proposal.md standards/style/ledger/example-proposal--scope.md" ;;
  esac
}

run_flow() { # $1 = template repo, $2 = DOC_TYPE, $3 = work dir — fills the state
  local src="$1" tpl="$3/tpl" e log="$3/flow.log" clone="$3/proj-switch"
  DOC="$2"; PROJ="$3/proj"; COPY_STATUS=0; UPDATE_STATUS=0; DELETED=()
  UPDATE_LOG="$3/update.log"; SWITCH_STATUS=0; SWITCH_LOG="$3/switch.log"; SWITCH_DIRTY=""; SWITCH_RECORDED=""
  : > "$UPDATE_LOG"; : > "$SWITCH_LOG"
  sa_snapshot "$src" "$tpl" >>"$log" 2>&1 || die "could not snapshot $src"

  sa_render "$tpl" "$PROJ" "$DOC" >>"$log" 2>&1 || COPY_STATUS=$?
  [[ "$COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$PROJ/.git" ]] || sa_git "$PROJ" init -q
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'generated' >>"$log" 2>&1

  # The author at work.
  printf -- '- **01/01/2027** — **%s.** An author decision that must survive every update.\n' "$MEMORY_MARK" >> "$PROJ/.claude/MEMORY.md"
  printf '\n%s\n' "$STYLE_MARK" >> "$PROJ/standards/style/style-sheet.md"
  for e in $(examples_for "$DOC"); do
    [[ -e "$PROJ/$e" ]] && { rm -rf "${PROJ:?}/$e"; DELETED+=("$e"); }
  done
  rm -f "$PROJ/standards/style/voice-notes.md"
  if [[ "$DOC" == business ]]; then AUTHOR_FILE="library/src/policies/author-policy.md"
  else AUTHOR_FILE="manuscript/src/02-author-unit/02-author-unit.md"; fi
  mkdir -p "$(dirname "$PROJ/$AUTHOR_FILE")"
  printf '# Written by the author\n\nA paragraph no update may touch.\n' > "$PROJ/$AUTHOR_FILE"
  AUTHOR_SUM="$(sha1sum < "$PROJ/$AUTHOR_FILE")"
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'the author at work' >>"$log" 2>&1

  # The template moves on. A template-owned skill every variant ships; a rule file if the
  # skills are not written yet.
  TARGET_REL=".claude/skills/run-workflow/SKILL.md"
  [[ -f "$tpl/template/$TARGET_REL" ]] || TARGET_REL=".claude/rules/syntek-author/01-layout-and-routing.md"
  [[ -f "$tpl/template/$TARGET_REL" ]] || die "the template has neither run-workflow/SKILL.md nor the layout rule — nothing template-owned to update"
  printf '\n%s\n' "$TEMPLATE_MARK" >> "$tpl/template/$TARGET_REL"
  sa_git "$tpl" add -A && sa_git "$tpl" commit -q -m 'a template change' >>"$log" 2>&1

  sa_update "$PROJ" >"$UPDATE_LOG" 2>&1 || UPDATE_STATUS=$?
  cat "$UPDATE_LOG" >>"$log"

  # A changed DOC_TYPE, tried in a clone so checks 3–9 judge the real update alone. The clone
  # starts clean and committed, so a refusal can only come from the template.
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'updated' >>"$log" 2>&1 || true
  git clone -q "$PROJ" "$clone" >>"$log" 2>&1 || die "could not clone $PROJ"
  sa_update "$clone" --data "DOC_TYPE=$(other_doc "$DOC")" >"$SWITCH_LOG" 2>&1 || SWITCH_STATUS=$?
  cat "$SWITCH_LOG" >>"$log"
  SWITCH_DIRTY="$(git -C "$clone" status --porcelain 2>/dev/null)"
  SWITCH_RECORDED="$(answer_value DOC_TYPE "$clone/$SA_ANSWERS_FILE")"
}

run_checks() {
  FINDINGS=()
  local e f
  if [[ "$COPY_STATUS" -ne 0 ]]; then
    finding "check 1 — [$DOC] the project did not render (exit $COPY_STATUS)"
    return 0
  fi
  [[ "$UPDATE_STATUS" -eq 0 ]] || finding "check 2 — [$DOC] copier update failed (exit $UPDATE_STATUS)"
  grep -qF "$MEMORY_MARK" "$PROJ/.claude/MEMORY.md" 2>/dev/null \
    || finding "check 3 — [$DOC] the author's MEMORY.md entry did not survive the update"
  grep -qF "$STYLE_MARK" "$PROJ/standards/style/style-sheet.md" 2>/dev/null \
    || finding "check 4 — [$DOC] the author's style-sheet rule did not survive the update"
  if [[ ${#DELETED[@]} -eq 0 ]]; then
    finding "check 5 — [$DOC] the render shipped no seed-once example to delete, so 'stays deleted' was never tested"
  fi
  for e in "${DELETED[@]}"; do
    [[ -e "$PROJ/$e" ]] && finding "check 5 — [$DOC] the deleted example $e came back on update"
  done
  [[ -f "$PROJ/standards/style/voice-notes.md" ]] \
    || finding "check 6 — [$DOC] the deleted voice-notes.md was not recreated — skills cite it"
  [[ -f "$PROJ/$AUTHOR_FILE" && "$(sha1sum < "$PROJ/$AUTHOR_FILE")" == "$AUTHOR_SUM" ]] \
    || finding "check 7 — [$DOC] the author's own $AUTHOR_FILE changed or vanished"
  grep -qF "$TEMPLATE_MARK" "$PROJ/$TARGET_REL" 2>/dev/null \
    || finding "check 8 — [$DOC] $TARGET_REL did not take the template's change"
  while IFS= read -r f; do
    finding "check 9 — [$DOC] conflict left behind: ${f#"$PROJ"/}"
  done < <( { find "$PROJ" -name .git -prune -o -name '*.rej' -print; \
              grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$PROJ" 2>/dev/null; } | sort -u || true)
  if [[ "$SWITCH_STATUS" -eq 0 ]]; then
    finding "check 10 — [$DOC] an update changing DOC_TYPE to $(other_doc "$DOC") was accepted — it must be refused (DESIGN.md D35)"
  elif ! grep -qF "$DOCTYPE_REFUSAL" "$SWITCH_LOG" 2>/dev/null; then
    finding "check 10 — [$DOC] the DOC_TYPE change failed (exit $SWITCH_STATUS), but not with DOC_TYPE's validator message — see $SWITCH_LOG"
  fi
  if [[ -n "$SWITCH_DIRTY" || "$SWITCH_RECORDED" != "$DOC" ]]; then
    finding "check 11 — [$DOC] the refused DOC_TYPE change touched the project ($(printf '%s\n' "$SWITCH_DIRTY" | grep -c . || true) path(s) changed; the answers record '$SWITCH_RECORDED')"
  fi
  if ! grep -qF "$MESSAGE_MARK" "$UPDATE_LOG" 2>/dev/null; then
    finding "check 12 — [$DOC] copier update printed no option-off warning (_message_before_update)"
  else
    for e in $OPTIONS; do
      grep -qF "$e=false" "$UPDATE_LOG" || finding "check 12 — [$DOC] the option-off warning does not name $e"
    done
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
  run_flow "$tmp/fixture" theology "$tmp"
  st_baseline "a real update of the fixture template"

  COPY_STATUS=1;   probe "check 1 fires when the render fails" "check 1"; COPY_STATUS=0
  UPDATE_STATUS=1; probe "check 2 fires when the update fails" "check 2"; UPDATE_STATUS=0
  cp "$PROJ/.claude/MEMORY.md" "$tmp/h"; grep -vF "$MEMORY_MARK" "$tmp/h" > "$PROJ/.claude/MEMORY.md"
  probe "check 3 fires when the MEMORY entry is lost" "check 3"; cp "$tmp/h" "$PROJ/.claude/MEMORY.md"
  cp "$PROJ/standards/style/style-sheet.md" "$tmp/h"; grep -vF "$STYLE_MARK" "$tmp/h" > "$PROJ/standards/style/style-sheet.md"
  probe "check 4 fires when the style rule is lost" "check 4"; cp "$tmp/h" "$PROJ/standards/style/style-sheet.md"
  mkdir -p "$PROJ/${DELETED[0]}"; probe "check 5 fires when an example comes back" "check 5"; rm -rf "${PROJ:?}/${DELETED[0]}"
  mv "$PROJ/standards/style/voice-notes.md" "$tmp/h"; probe "check 6 fires when voice-notes.md is not recreated" "check 6"; mv "$tmp/h" "$PROJ/standards/style/voice-notes.md"
  cp "$PROJ/$AUTHOR_FILE" "$tmp/h"; printf 'tidied\n' >> "$PROJ/$AUTHOR_FILE"; probe "check 7 fires when the author's unit changes" "check 7"; cp "$tmp/h" "$PROJ/$AUTHOR_FILE"
  cp "$PROJ/$TARGET_REL" "$tmp/h"; grep -vF "$TEMPLATE_MARK" "$tmp/h" > "$PROJ/$TARGET_REL"
  probe "check 8 fires when the template change does not arrive" "check 8"; cp "$tmp/h" "$PROJ/$TARGET_REL"
  printf 'x\n' > "$PROJ/README.md.rej"; probe "check 9 fires on a rejected hunk" "check 9"; rm -f "$PROJ/README.md.rej"
  SWITCH_STATUS=0; probe "check 10 fires when a DOC_TYPE change is accepted" "check 10"; SWITCH_STATUS=1
  cp "$SWITCH_LOG" "$tmp/h"; grep -vF "$DOCTYPE_REFUSAL" "$tmp/h" > "$SWITCH_LOG" || true
  probe "check 10 fires when the update failed for another reason" "check 10 — [theology] the DOC_TYPE change failed"; cp "$tmp/h" "$SWITCH_LOG"
  SWITCH_DIRTY=" M README.md"; probe "check 11 fires when the refused update touched a file" "check 11"; SWITCH_DIRTY=""
  SWITCH_RECORDED=fiction; probe "check 11 fires when the answers record the new DOC_TYPE" "check 11"; SWITCH_RECORDED=theology
  cp "$UPDATE_LOG" "$tmp/h"; grep -vF "$MESSAGE_MARK" "$tmp/h" > "$UPDATE_LOG" || true
  probe "check 12 fires when the option-off warning is not printed" "check 12"; cp "$tmp/h" "$UPDATE_LOG"
  grep -vF "INCLUDE_DRIVE_SYNC=false" "$tmp/h" > "$UPDATE_LOG" || true
  probe "check 12 fires when the warning leaves an option out" "check 12 — [theology] the option-off warning does not name INCLUDE_DRIVE_SYNC"; cp "$tmp/h" "$UPDATE_LOG"
  st_finish "an update that keeps its promises from one that breaks them"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
copier_init
bold "▸ $SCRIPT_NAME"
STATUS=0
for doc in ${DOC_TYPES//,/ }; do
  case "$doc" in theology|fiction|business) ;; *) die "unknown DOC_TYPE: $doc" ;; esac
  work="$(sa_mktemp)"
  run_flow "$SA_ROOT" "$doc" "$work"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $doc — edits kept, example still gone, voice-notes.md recreated, author unit untouched, $TARGET_REL updated; DOC_TYPE change refused untouched; option-off warning printed"
    rm -rf "$work"
  else
    bold "✗ $doc — ${#FINDINGS[@]} finding(s) (work kept in $work; Copier's output in $work/flow.log):"
    print_findings
    STATUS=1
  fi
done
log ""
[[ "$STATUS" -eq 0 ]] && { bold "✓ copier update keeps every ownership promise."; exit 0; }
log "  Each promise rests on one copier.yml line: _skip_if_exists for seeds, the copy-only"
log "  _exclude gate for examples (DESIGN.md Sections 3.1–3.2), DOC_TYPE's validator with"
log "  _external_data, and _message_before_update (D35)."
exit 1
