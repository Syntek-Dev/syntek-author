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
#                  For business it then proves the v0.2.0 migration (DESIGN.md D44) on a real
#                  upgrade: the repository is cloned with its tags, the working tree is
#                  committed on top and tagged with VERSION, a project is rendered at the
#                  v0.1.0 tag, the author plants a file in every v0.1.0 family folder (plus one
#                  whose destination they already used), and `copier update` runs to the tagged
#                  tree — so Copier itself decides that the migration applies. For each book
#                  variant it proves the every-variant settings migration the same way: a
#                  project rendered at v0.1.0, whose author kept the brief current where v0.1.0
#                  said to (the audience and the reader test in .claude/CLAUDE.md Section 1),
#                  crosses v0.2.0 re-answering the reader test on the way (--data), and the new
#                  seed 00-project.md must carry the hand-edited audience, not the old answer,
#                  and the reader test answered during the update, not the older hand edit.
#
#                  Twelve checks per DOC_TYPE, six more for business, and five more for each
#                  book variant:
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
#                       naming every INCLUDE_* option and BUSINESS_FAMILIES — the only warning
#                       an author gets before an option turned off deletes the seeds they
#                       filled in.
#                   13. Business: the update from v0.1.0 to the tree tagged VERSION succeeds,
#                       and the v0.2.0 migration runs.
#                   14. Every author file planted in a v0.1.0 family folder, and the kept
#                       example proposal, is at its D44 destination, byte for byte.
#                   15. Nothing is lost: every planted file's bytes are still in the project,
#                       the collision's two files included.
#                   16. The migration names the file it could not move (the collision):
#                       nothing is left behind silently.
#                   17. A second run of the migration exits 0 and changes nothing.
#                   18. With msp-scp chosen, policies/ goes to msp-scp/ (a hand run of the
#                       script in a scratch project, no Copier).
#                   19. Books: the update from v0.1.0 to the tree tagged VERSION succeeds, and
#                       the v0.2.0 project-settings migration runs.
#                   20. The audience the author changed in .claude/CLAUDE.md Section 1 is the
#                       audience in 00-project.md ## Brief (D40), not the recorded answer.
#                   21. A second run of the settings migration exits 0 and changes nothing.
#                   22. The reader test the author answered again during the update itself is
#                       the reader test in 00-project.md ## Brief: the older hand edit in
#                       .claude/CLAUDE.md Section 1 never overwrites a fresh answer (D44).
#                   23. The migration reported that older hand edit as a conflict, naming
#                       .claude/CLAUDE.md:<line> and its value, so the author can reconcile it.
#
#                  A fresh copy prints a MissingFileWarning (the template reads the previous
#                  answers through _external_data, and a new project has none). It is expected
#                  and never a finding: only exit statuses and files are judged.
#
#                  Numbers are stable identifiers. Append, never renumber.
#
#                  What it CANNOT check: an upgrade from any release but v0.1.0, or a migration
#                  the update does not reach (a later release's script needs its own flow here,
#                  written with the release that moves the folder: DESIGN.md D26, D44).
#
# SELF-TEST. --self-test runs the whole flow against a fixture template written at runtime,
#            proves the result clean, then mutates the result once per check and asserts
#            exactly one finding each. For checks 13–23 the fixture is given two tagged
#            releases — v0.1.0 with the six old family folders and an audience and a reader
#            test in .claude/CLAUDE.md Section 1, v0.2.0 with the families, the 00-project.md seed and
#            the real migrations/v0.2.0-business-families.sh and v0.2.0-project-settings.sh —
#            and both upgrades run for real.
#
# Requirements: bash 4+, git, rsync, uvx (or COPIER_CMD), and the v0.1.0 tag in the template
#               repository (CI checks out with fetch-depth 0). Network on the first uvx run only.
#
# Usage: update-test.sh [--root DIR] [--doc-type T[,T…]] [--quiet] [--self-test] [--help]
#        --doc-type defaults to theology,fiction,business.
#
# Exit codes:  0 = every promise held, for every DOC_TYPE tested
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, a template with nothing to update)

set -euo pipefail
SCRIPT_NAME="update-test.sh"
# shellcheck source=SCRIPTDIR/_common.sh
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
# What the warning must name: each option as `KEY=false`, and the family list by its key.
MESSAGE_NAMES="INCLUDE_PROPOSAL=false INCLUDE_WORLDBUILDING=false INCLUDE_CONLANG=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false INCLUDE_DRIVE_SYNC=false BUSINESS_FAMILIES"

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
    business) echo "library/src/business/drafts/example-proposal planning/src/units/example-proposal.md standards/style/ledger/example-proposal--scope.md" ;;
  esac
}

run_flow() { # $1 = template repo, $2 = DOC_TYPE, $3 = work dir — fills the state
  local src="$1" tpl="$3/tpl" e log="$3/flow.log" clone="$3/proj-switch"
  DOC="$2"; PROJ="$3/proj"; COPY_STATUS=0; UPDATE_STATUS=0; DELETED=(); FLOW_RAN=true
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
  if [[ "$DOC" == business ]]; then AUTHOR_FILE="library/src/business/client-docs/example-client/author-note.md"
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

# ── The v0.2.0 migration, on a real upgrade from v0.1.0 (business, checks 13–18) ──

MIGRATION_FROM="v0.1.0"
MIGRATION_SCRIPT="migrations/v0.2.0-business-families.sh"
MIGRATION_MARK="v0.2.0 migration — moving your files"
# Author files planted in the v0.1.0 family folders, each with its D44 destination (msp-scp is
# not chosen, so policies go to business). Invented names only.
MIG_PLANTS=$(cat <<'EOF'
library/src/proposals/templates/author-rate-card.md library/src/business/templates/author-rate-card.md
library/src/contracts/client-docs/example-client/author-msa.tex library/src/legal/client-docs/example-client/author-msa.tex
library/src/policies/author-policy.md library/src/business/author-policy.md
library/src/correspondence/client-docs/example-client/author-letter.md library/src/email/client-emails/example-client/author-letter.md
library/src/finance/templates/author-invoice.md library/src/accounting/templates/author-invoice.md
library/src/marketing/drafts/author-post.md library/src/social-media/drafts/author-post.md
EOF
)
# A collision: the author had already used the destination in v0.1.0 (legal/ was not a template
# folder then), so the old file must stay where it is, untouched, and be named.
MIG_COLLIDE_OLD="library/src/contracts/author-nda.md"
MIG_COLLIDE_NEW="library/src/legal/author-nda.md"

MIG_RAN=false; FLOW_RAN=false
MIG_PROJ=""; MIG_COPY_STATUS=0; MIG_UPDATE_STATUS=0; MIG_LOG=""; MIG_RERUN_STATUS=0; MIG_RERUN_DIRTY=""
MSP_RESULT=""
declare -A MIG_WANT=() MIG_SUMS=()

# The every-variant settings migration (D40): an invented audience, set where v0.1.0 told the
# author to keep it, must reach `## Brief`. No '|', '&' or '\' in it: sed writes it.
SETTINGS_SCRIPT="migrations/v0.2.0-project-settings.sh"
SETTINGS_MARK="v0.2.0 migration — project settings"
SETTINGS_FILE=".claude/rules/syntek-author/00-project.md"
SETTINGS_EDIT="Update-test audience, an invented reading group new to the subject"
# A reader test the author hand-edited under v0.1.0, then answered afresh during the update
# (D44: the fresh answer wins, and the hand edit is a conflict). Same limits as above.
READER_HAND="Update-test reader, an invented night-shift nurse reading on a break"
READER_FRESH="Update-test reader, an invented apprentice who answered again during the update"
READER_CONFLICT="conflict  Reader test"
SET_RAN=false
SET_DOC=""; SET_PROJ=""; SET_COPY_STATUS=0; SET_UPDATE_STATUS=0; SET_LOG=""; SET_RERUN_STATUS=0; SET_RERUN_DIRTY=""

sum_of() { sha1sum < "$1" | cut -d' ' -f1; }

# `- **Label:** value` and `- **Label** (a note): value` both read as the value.
brief_value() { # $1 = 00-project.md, $2 = label → the value of that bullet under ## Brief
  awk -v pre="- **$2" '
    /^## / { on = ($0 ~ /^## Brief[ \t]*$/); next }
    on && index($0, pre) == 1 {
      v = substr($0, length(pre) + 1)
      if (substr(v, 1, 3) == ":**") v = substr(v, 4)
      else if (substr(v, 1, 2) == "**") { v = substr(v, 3); sub(/^[ \t]*\([^)]*\)/, "", v); if (substr(v, 1, 1) != ":") next; v = substr(v, 2) }
      else next
      sub(/^[ \t]+/, "", v); print v; exit
    }' "$1" 2>/dev/null
}

# The real repository as a template with history: its tags (v0.1.0) and the working tree
# committed on top, tagged with VERSION, so Copier sees a release to upgrade to.
tagged_template() { # $1 = template repository, $2 = dest
  local src="$1" dest="$2" ver
  git -C "$src" rev-parse -q --verify "refs/tags/$MIGRATION_FROM" >/dev/null 2>&1 \
    || die "$src has no $MIGRATION_FROM tag — the upgrade cannot be proven (git fetch --tags; CI needs fetch-depth: 0)"
  git clone -q --no-local "$src" "$dest" || die "could not clone $src"
  command -v rsync >/dev/null 2>&1 || die "rsync is not installed"
  rsync -a --delete --exclude '.git' "$src/" "$dest/" || die "could not copy the working tree"
  sa_git "$dest" add -A && sa_git "$dest" commit -q --allow-empty -m 'update-test: the working tree' || die "could not commit the working tree"
  ver="v$(tr -d '[:space:]' < "$dest/VERSION" 2>/dev/null)"
  [[ "$ver" != v ]] || die "no VERSION in $src"
  sa_git "$dest" tag -f "$ver" >/dev/null
}

run_migration_flow() { # $1 = template repository WITH the two tags, $2 = work dir
  local tpl="$1" w="$2" log="$2/mig-flow.log" from to f rel
  MIG_RAN=true; MIG_PROJ="$w/mig-proj"; MIG_COPY_STATUS=0; MIG_UPDATE_STATUS=0; MIG_LOG="$w/mig-update.log"
  MIG_RERUN_STATUS=0; MIG_RERUN_DIRTY=""; MIG_WANT=(); MIG_SUMS=(); : > "$MIG_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$MIGRATION_FROM" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data DOC_TYPE=business \
    "$tpl" "$MIG_PROJ" </dev/null >>"$log" 2>&1 || MIG_COPY_STATUS=$?
  [[ "$MIG_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$MIG_PROJ/.git" ]] || sa_git "$MIG_PROJ" init -q
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'generated at v0.1.0' >>"$log" 2>&1

  # The author at work in the old folders.
  while read -r from to; do
    [[ -z "$from" ]] && continue
    mkdir -p "$(dirname "$MIG_PROJ/$from")"
    printf '# Written by the author in %s\n\nA document no upgrade may lose.\n' "$from" > "$MIG_PROJ/$from"
    MIG_WANT["$from"]="$to"; MIG_SUMS["$from"]="$(sum_of "$MIG_PROJ/$from")"
  done <<< "$MIG_PLANTS"
  for f in "$MIG_COLLIDE_OLD" "$MIG_COLLIDE_NEW"; do
    mkdir -p "$(dirname "$MIG_PROJ/$f")"
    printf '# The author'\''s own copy at %s\n' "$f" > "$MIG_PROJ/$f"
    MIG_SUMS["$f"]="$(sum_of "$MIG_PROJ/$f")"
  done
  # The kept example proposal travels with its family (Section 3.2).
  while IFS= read -r f; do
    rel="${f#library/src/proposals/}"
    MIG_WANT["$f"]="library/src/business/$rel"; MIG_SUMS["$f"]="$(sum_of "$MIG_PROJ/$f")"
  done < <(cd "$MIG_PROJ" && find library/src/proposals/drafts/example-proposal -type f 2>/dev/null | LC_ALL=C sort)
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'the author at work' >>"$log" 2>&1

  sa_update "$MIG_PROJ" >"$MIG_LOG" 2>&1 || MIG_UPDATE_STATUS=$?
  cat "$MIG_LOG" >>"$log"

  # A second run by hand, on the committed result, must change nothing.
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'upgraded' >>"$log" 2>&1 || true
  (cd "$MIG_PROJ" && bash "$tpl/$MIGRATION_SCRIPT") >>"$log" 2>&1 || MIG_RERUN_STATUS=$?
  MIG_RERUN_DIRTY="$(git -C "$MIG_PROJ" status --porcelain 2>/dev/null)"

  # With msp-scp chosen, policies go to msp-scp (D44): a hand run, no Copier needed.
  mkdir -p "$w/msp/library/src/business" "$w/msp/library/src/msp-scp" "$w/msp/library/src/policies"
  printf 'DOC_TYPE: business\nBUSINESS_FAMILIES:\n- business\n- msp-scp\n' > "$w/msp/$SA_ANSWERS_FILE"
  printf '# x\n' > "$w/msp/library/src/business/CONTEXT.md"; printf '# x\n' > "$w/msp/library/src/msp-scp/CONTEXT.md"
  printf '# An IT policy\n' > "$w/msp/library/src/policies/author-policy.md"
  (cd "$w/msp" && bash "$tpl/$MIGRATION_SCRIPT") >>"$log" 2>&1 || true
  MSP_RESULT="$(cd "$w/msp" && find library/src -type f -name author-policy.md | LC_ALL=C sort | paste -sd' ' -)"
}

mig_checks() {
  local from to f found
  local -A have=()
  if [[ "$MIG_COPY_STATUS" -ne 0 ]]; then
    finding "check 13 — [business] the project did not render at $MIGRATION_FROM (exit $MIG_COPY_STATUS)"
    return 0
  fi
  if [[ "$MIG_UPDATE_STATUS" -ne 0 ]]; then
    finding "check 13 — [business] copier update from $MIGRATION_FROM failed (exit $MIG_UPDATE_STATUS)"
  elif ! grep -qF "$MIGRATION_MARK" "$MIG_LOG" 2>/dev/null; then
    finding "check 13 — [business] the update from $MIGRATION_FROM did not run the v0.2.0 migration (is VERSION past 0.1.0, and _migrations keyed v0.2.0?)"
  fi
  for from in "${!MIG_WANT[@]}"; do
    to="${MIG_WANT[$from]}"
    if [[ ! -f "$MIG_PROJ/$to" || "$(sum_of "$MIG_PROJ/$to")" != "${MIG_SUMS[$from]}" ]]; then
      finding "check 14 — [business] $from is not at $to byte for byte after the upgrade"
    fi
  done
  while IFS= read -r -d '' f; do have["$(sum_of "$f")"]=1; done \
    < <(find "$MIG_PROJ" -name .git -prune -o -type f -print0 2>/dev/null)
  for f in "${!MIG_SUMS[@]}"; do
    [[ -n "${have[${MIG_SUMS[$f]}]:-}" ]] || finding "check 15 — [business] what the author wrote in $f is nowhere in the project after the upgrade"
  done
  grep -qF "$MIG_COLLIDE_OLD" "$MIG_LOG" 2>/dev/null \
    || finding "check 16 — [business] the migration did not name $MIG_COLLIDE_OLD, which it could not move ($MIG_COLLIDE_NEW exists)"
  if [[ "$MIG_RERUN_STATUS" -ne 0 || -n "$MIG_RERUN_DIRTY" ]]; then
    found="$(printf '%s\n' "$MIG_RERUN_DIRTY" | grep -c . || true)"
    finding "check 17 — [business] a second run of the migration was not a no-op (exit $MIG_RERUN_STATUS, $found path(s) changed)"
  fi
  [[ "$MSP_RESULT" == "library/src/msp-scp/author-policy.md" ]] \
    || finding "check 18 — [business] with msp-scp chosen, policies/author-policy.md went to '${MSP_RESULT:-nowhere}', not library/src/msp-scp/"
}

# ── The v0.2.0 settings migration, on a real upgrade from v0.1.0 (books, checks 19–21) ──

run_settings_flow() { # $1 = template repository WITH the two tags, $2 = work dir, $3 = book DOC_TYPE
  local tpl="$1" w="$2" log="$2/set-flow.log"
  SET_RAN=true; SET_DOC="$3"; SET_PROJ="$w/set-proj"; SET_COPY_STATUS=0; SET_UPDATE_STATUS=0
  SET_LOG="$w/set-update.log"; SET_RERUN_STATUS=0; SET_RERUN_DIRTY=""; : > "$SET_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$MIGRATION_FROM" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=$SET_DOC" \
    "$tpl" "$SET_PROJ" </dev/null >>"$log" 2>&1 || SET_COPY_STATUS=$?
  [[ "$SET_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$SET_PROJ/.git" ]] || sa_git "$SET_PROJ" init -q
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'generated at v0.1.0' >>"$log" 2>&1

  # The author keeps the brief current where v0.1.0 said to: .claude/CLAUDE.md Section 1.
  sed -i "s|^- \*\*Audience:\*\* .*|- **Audience:** $SETTINGS_EDIT|" "$SET_PROJ/.claude/CLAUDE.md" 2>>"$log" || true
  sed -i "s|^\(- \*\*Reader test\*\*[^:]*:\) .*|\1 $READER_HAND|" "$SET_PROJ/.claude/CLAUDE.md" 2>>"$log" || true
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'the author changes the audience and the reader test' >>"$log" 2>&1 || true

  # The upgrade, answering the reader test again on the way (D44: that answer must stand).
  sa_update "$SET_PROJ" --data "READER_TEST=$READER_FRESH" >"$SET_LOG" 2>&1 || SET_UPDATE_STATUS=$?
  cat "$SET_LOG" >>"$log"

  # A second run by hand, on the committed result, must change nothing.
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'upgraded' >>"$log" 2>&1 || true
  (cd "$SET_PROJ" && bash "$tpl/$SETTINGS_SCRIPT") >>"$log" 2>&1 || SET_RERUN_STATUS=$?
  SET_RERUN_DIRTY="$(git -C "$SET_PROJ" status --porcelain 2>/dev/null)"
}

set_checks() {
  local got found
  if [[ "$SET_COPY_STATUS" -ne 0 ]]; then
    finding "check 19 — [$SET_DOC] the project did not render at $MIGRATION_FROM (exit $SET_COPY_STATUS)"
    return 0
  fi
  if [[ "$SET_UPDATE_STATUS" -ne 0 ]]; then
    finding "check 19 — [$SET_DOC] copier update from $MIGRATION_FROM failed (exit $SET_UPDATE_STATUS)"
  elif ! grep -qF "$SETTINGS_MARK" "$SET_LOG" 2>/dev/null; then
    finding "check 19 — [$SET_DOC] the update from $MIGRATION_FROM did not run the v0.2.0 project-settings migration (is its _migrations entry keyed v0.2.0, with no DOC_TYPE test?)"
  fi
  got="$(brief_value "$SET_PROJ/$SETTINGS_FILE" Audience)"
  [[ "$got" == "$SETTINGS_EDIT" ]] \
    || finding "check 20 — [$SET_DOC] $SETTINGS_FILE ## Brief gives the audience as '${got:-nothing}', not the one the author set in .claude/CLAUDE.md Section 1"
  if [[ "$SET_RERUN_STATUS" -ne 0 || -n "$SET_RERUN_DIRTY" ]]; then
    found="$(printf '%s\n' "$SET_RERUN_DIRTY" | grep -c . || true)"
    finding "check 21 — [$SET_DOC] a second run of the settings migration was not a no-op (exit $SET_RERUN_STATUS, $found path(s) changed)"
  fi
  got="$(brief_value "$SET_PROJ/$SETTINGS_FILE" "Reader test")"
  [[ "$got" == "$READER_FRESH" ]] \
    || finding "check 22 — [$SET_DOC] $SETTINGS_FILE ## Brief gives the reader test as '${got:-nothing}', not the one the author answered during the update ($READER_FRESH)"
  if ! grep -qF "$READER_CONFLICT" "$SET_LOG" 2>/dev/null \
     || ! grep -F '.claude/CLAUDE.md:' "$SET_LOG" 2>/dev/null | grep -qF "$READER_HAND"; then
    finding "check 23 — [$SET_DOC] the settings migration did not report the older reader test in .claude/CLAUDE.md ('$READER_HAND') as a conflict with its file:line"
  fi
}

# A two-release fixture for the self-test: v0.1.0 with the six old family folders and an
# audience in .claude/CLAUDE.md Section 1, v0.2.0 with the D39 families, the 00-project.md seed
# and the real migration scripts, each tagged.
mig_fixture() { # $1 = dest
  local t="$1" old
  sa_fixture_template "$t" >/dev/null
  sed -i 's#/library/src/business/drafts/example-proposal<#/library/src/proposals/drafts/example-proposal<#' "$t/copier.yml"
  mv "$t/template/library/src/business" "$t/template/library/src/proposals"
  for old in proposals contracts policies correspondence finance marketing; do
    mkdir -p "$t/template/library/src/$old"; printf '# CONTEXT.md — library/src/%s/\n' "$old" > "$t/template/library/src/$old/CONTEXT.md"
  done
  # v0.1.0 kept the brief, the audience and reader test included, in .claude/CLAUDE.md
  # Section 1 (a seed), with the reader test's note as v0.1.0 wrote it.
  printf '# CLAUDE.md — <%%PROJECT_NAME%%>\n\n## 1. Project\n\n- **Audience:** <%%AUDIENCE%%>\n- **Reader test** (every `comprehension` pass reads as this person): <%%READER_TEST%%>\n\n## 3. Project-specific rules\n' > "$t/template/.claude/CLAUDE.md"
  printf 'AUDIENCE:\n  type: str\n  default: invented general readers\nREADER_TEST:\n  type: str\n  default: an invented reader at the end of a working day\n' >> "$t/copier.yml"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture v0.1.0' && sa_git "$t" tag v0.1.0
  sed -i 's#/library/src/proposals/drafts/example-proposal<#/library/src/business/drafts/example-proposal<#' "$t/copier.yml"
  mkdir -p "$t/template/library/src/business/drafts"
  mv "$t/template/library/src/proposals/drafts/example-proposal" "$t/template/library/src/business/drafts/"
  for old in proposals contracts policies correspondence finance marketing; do rm -rf "${t:?}/template/library/src/$old"; done
  for f in business legal email accounting social-media email/client-emails; do
    mkdir -p "$t/template/library/src/$f"; printf '# CONTEXT.md — library/src/%s/\n' "$f" > "$t/template/library/src/$f/CONTEXT.md"
  done
  mkdir -p "$t/migrations" "$t/template/.claude/rules/syntek-author"
  cp "$SA_ROOT/$MIGRATION_SCRIPT" "$t/$MIGRATION_SCRIPT" || die "no $MIGRATION_SCRIPT in $SA_ROOT"
  cp "$SA_ROOT/$SETTINGS_SCRIPT" "$t/$SETTINGS_SCRIPT" || die "no $SETTINGS_SCRIPT in $SA_ROOT"
  printf '# 00-project.md\n\n## Brief\n\n- **Audience:** <%%AUDIENCE%%>\n- **Reader test** (every `comprehension` pass reads as this person): <%%READER_TEST%%>\n\n## Paths\n' > "$t/template/$SETTINGS_FILE"
  cat >> "$t/copier.yml" <<'EOF'
BUSINESS_FAMILIES:
  type: str
  multiselect: true
  choices: [business, legal, email, accounting, social-media, msp-scp]
  default: [business, legal, email, accounting, social-media]
  when: "<% DOC_TYPE == 'business' %>"
_migrations:
  - version: v0.2.0
    command: bash "<% _copier_conf.src_path %>/migrations/v0.2.0-business-families.sh"
    when: "<% _stage == 'after' and DOC_TYPE == 'business' %>"
  - version: v0.2.0
    command: bash "<% _copier_conf.src_path %>/migrations/v0.2.0-project-settings.sh"
    when: "<% _stage == 'after' %>"
EOF
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture v0.2.0' && sa_git "$t" tag v0.2.0
}

run_checks() {
  FINDINGS=()
  $FLOW_RAN && flow_checks
  $MIG_RAN && mig_checks
  $SET_RAN && set_checks
  return 0
}

flow_checks() {
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
    for e in $MESSAGE_NAMES; do
      grep -qF "$e" "$UPDATE_LOG" || finding "check 12 — [$DOC] the option-off warning does not name ${e%=false}"
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

  # Checks 13–18: a real upgrade between the fixture's two tagged releases.
  FLOW_RAN=false
  mig_fixture "$tmp/mig-tpl"
  mkdir -p "$tmp/mig"; run_migration_flow "$tmp/mig-tpl" "$tmp/mig"
  st_baseline "a real upgrade of the fixture from v0.1.0 to v0.2.0"
  local first to
  MIG_COPY_STATUS=1; probe "check 13 fires when the project does not render at v0.1.0" "check 13"; MIG_COPY_STATUS=0
  MIG_UPDATE_STATUS=1; probe "check 13 fires when the upgrade fails" "check 13 — [business] copier update"; MIG_UPDATE_STATUS=0
  cp "$MIG_LOG" "$tmp/h"; grep -vF "$MIGRATION_MARK" "$tmp/h" > "$MIG_LOG" || true
  probe "check 13 fires when the migration did not run" "check 13 — [business] the update from v0.1.0 did not run"; cp "$tmp/h" "$MIG_LOG"
  first="library/src/finance/templates/author-invoice.md"; to="${MIG_WANT[$first]}"
  mkdir -p "$(dirname "$MIG_PROJ/$first")"; mv "$MIG_PROJ/$to" "$MIG_PROJ/$first"
  probe "check 14 fires when a planted file stays in its old folder" "check 14 — [business] $first"
  mv "$MIG_PROJ/$first" "$MIG_PROJ/$to"
  mv "$MIG_PROJ/$MIG_COLLIDE_OLD" "$tmp/h"
  probe "check 15 fires when the collision's old file is lost" "check 15 — [business] what the author wrote in $MIG_COLLIDE_OLD"
  mv "$tmp/h" "$MIG_PROJ/$MIG_COLLIDE_OLD"
  cp "$MIG_LOG" "$tmp/h"; grep -vF "$MIG_COLLIDE_OLD" "$tmp/h" > "$MIG_LOG" || true
  probe "check 16 fires when the leftover is not named" "check 16"; cp "$tmp/h" "$MIG_LOG"
  MIG_RERUN_DIRTY=" M library/src/business/author-policy.md"; probe "check 17 fires when a second run changes a file" "check 17"; MIG_RERUN_DIRTY=""
  MSP_RESULT="library/src/business/author-policy.md"; probe "check 18 fires when policies ignore msp-scp" "check 18"; MSP_RESULT="library/src/msp-scp/author-policy.md"
  MIG_RAN=false

  # Checks 19–23: a book project's upgrade between the same two releases.
  mkdir -p "$tmp/set"; run_settings_flow "$tmp/mig-tpl" "$tmp/set" theology
  st_baseline "a real upgrade of a book project from v0.1.0 to v0.2.0, its audience changed in Section 1 and its reader test re-answered"
  SET_COPY_STATUS=1; probe "check 19 fires when the project does not render at v0.1.0" "check 19"; SET_COPY_STATUS=0
  SET_UPDATE_STATUS=1; probe "check 19 fires when the upgrade fails" "check 19 — [theology] copier update"; SET_UPDATE_STATUS=0
  cp "$SET_LOG" "$tmp/h"; grep -vF "$SETTINGS_MARK" "$tmp/h" > "$SET_LOG" || true
  probe "check 19 fires when the settings migration did not run" "check 19 — [theology] the update from v0.1.0 did not run"; cp "$tmp/h" "$SET_LOG"
  cp "$SET_PROJ/$SETTINGS_FILE" "$tmp/h"
  sed -i "s|^- \*\*Audience:\*\* .*|- **Audience:** invented general readers|" "$SET_PROJ/$SETTINGS_FILE"
  probe "check 20 fires when ## Brief keeps the old answer" "check 20"; cp "$tmp/h" "$SET_PROJ/$SETTINGS_FILE"
  SET_RERUN_DIRTY=" M $SETTINGS_FILE"; probe "check 21 fires when a second run changes a file" "check 21"; SET_RERUN_DIRTY=""
  SET_RERUN_STATUS=1; probe "check 21 fires when a second run fails" "check 21"; SET_RERUN_STATUS=0
  cp "$SET_PROJ/$SETTINGS_FILE" "$tmp/h"
  sed -i "s|^\(- \*\*Reader test\*\*[^:]*:\) .*|\1 $READER_HAND|" "$SET_PROJ/$SETTINGS_FILE"
  probe "check 22 fires when the older hand edit overwrites the fresh answer" "check 22"; cp "$tmp/h" "$SET_PROJ/$SETTINGS_FILE"
  cp "$SET_LOG" "$tmp/h"; grep -vF "$READER_CONFLICT" "$tmp/h" > "$SET_LOG" || true
  probe "check 23 fires when the conflict is not reported" "check 23"; cp "$tmp/h" "$SET_LOG"
  grep -vF "$READER_HAND" "$tmp/h" > "$SET_LOG" || true
  probe "check 23 fires when the conflict does not name the hand edit" "check 23"; cp "$tmp/h" "$SET_LOG"
  SET_RAN=false
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

# The tagged template every variant's upgrade runs against: cloned once per run, removed at exit.
TAGGED=""; TAGGED_DIR=""
tagged_once() {
  [[ -n "$TAGGED" ]] && return 0
  TAGGED_DIR="$(sa_mktemp)"; TAGGED="$TAGGED_DIR/tagged"
  tagged_template "$SA_ROOT" "$TAGGED" >>"$TAGGED_DIR/tagged.log"
}
trap 'if [[ -n "$TAGGED_DIR" ]]; then rm -rf "$TAGGED_DIR"; fi' EXIT

for doc in ${DOC_TYPES//,/ }; do
  case "$doc" in theology|fiction|business) ;; *) die "unknown DOC_TYPE: $doc" ;; esac
  work="$(sa_mktemp)"
  MIG_RAN=false; SET_RAN=false
  run_flow "$SA_ROOT" "$doc" "$work"
  tagged_once
  if [[ "$doc" == business ]]; then
    run_migration_flow "$TAGGED" "$work"
    cat "$work/mig-flow.log" >> "$work/flow.log" 2>/dev/null || true
  else
    run_settings_flow "$TAGGED" "$work" "$doc"
    cat "$work/set-flow.log" >> "$work/flow.log" 2>/dev/null || true
  fi
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $doc — edits kept, example still gone, voice-notes.md recreated, author unit untouched, $TARGET_REL updated; DOC_TYPE change refused untouched; option-off warning printed"
    $MIG_RAN && log "  ✓ $doc — upgrade from $MIGRATION_FROM: every author file moved to its family byte for byte, the collision kept and named, a second run a no-op, msp-scp honoured"
    $SET_RAN && log "  ✓ $doc — upgrade from $MIGRATION_FROM: the audience set in .claude/CLAUDE.md Section 1 reached 00-project.md ## Brief, the reader test answered during the update kept with the older hand edit reported as a conflict, a second run a no-op"
    rm -rf "$work"
  else
    bold "✗ $doc — ${#FINDINGS[@]} finding(s) (work kept in $work; Copier's output in $work/flow.log):"
    print_findings
    # On a CI runner the work directory is gone once the job ends, so show Copier's output here.
    if [[ "${GITHUB_ACTIONS:-}" == true ]]; then
      echo "::group::Copier output for $doc (last 80 lines of flow.log)"
      tail -n 80 "$work/flow.log" 2>/dev/null || true
      echo "::endgroup::"
    fi
    STATUS=1
  fi
done
log ""
[[ "$STATUS" -eq 0 ]] && { bold "✓ copier update keeps every ownership promise."; exit 0; }
log "  Each promise rests on one copier.yml line: _skip_if_exists for seeds, the copy-only"
log "  _exclude gate for examples (DESIGN.md Sections 3.1–3.2), DOC_TYPE's validator with"
log "  _external_data, _message_before_update (D35), and the _migrations entries (D44)."
exit 1
