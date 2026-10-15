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
#                 It then proves the ADDITIVE mode (DESIGN.md D41) on a second copy of the same
#                 repository, given its own skill of a template skill's name and its own skills
#                 index: adopt/theology.sh --additive reports, then `copier copy --skip '*'
#                 --skip-tasks` adds the template beside every existing file.
#
#                 Last, adopt/business.sh --additive reports on an anonymised business library
#                 with conventions of its own: its own skill and signpost at the msp-scp
#                 family's template paths, its own Drive workflow, a publishing workflow that
#                 uploads library/src/, documents of its own in library/src/business/, its own
#                 business standard flat in library/docs/, a template rule left untracked by an
#                 earlier copy and a seed it keeps out of git. An update that unticks a family
#                 deletes the library's files at that family's paths, a workflow that uploads
#                 library/src/ uploads the drafts/ folders the copy adds (D37), template files
#                 read the template's standard rather than the library's own (D40), and a file
#                 an earlier copy left is kept as the library's: the report is the author's only
#                 warning of each.
#
#                 Then an anonymised book whose .agents is a link to a folder outside it (the
#                 author's own agent tree beside the repository). Copier refuses every
#                 destination beneath such a link before it reads --exclude, and no migration
#                 runs on a copy, so adopt/theology.sh must print the copy wrapped in the two
#                 mv lines that hold the link aside and put it back, and following that plan
#                 must adopt the repository with the link and its target untouched.
#
#                 Thirty checks:
#                   1. The copy succeeds.
#                   2. .claude/MEMORY.md is byte-for-byte untouched.
#                   3. Every other existing seed is untouched: .claude/CLAUDE.md,
#                      .claude/settings.json, README.md, .gitignore (settings.json may gain
#                      the template's own entries, add-only: check 30).
#                   4. Every file under manuscript/src/ that existed is untouched.
#                   5. Every file under standards/style/ that existed is untouched.
#                   6. No seed-once example was added.
#                   7. The answers file was written, recording SEED_EXAMPLES: false.
#                   8. Template-owned files arrived (.claude/rules/syntek-author/).
#                   9. adopt/theology.sh --apply succeeded (when the script exists).
#                  10. When the kept .gitignore ignores .claude/skills/build/ (the fixture's
#                      unanchored `build/` line does), the adoption report said so — otherwise
#                      the proof skill every variant needs is silently never committed.
#                  11. Additive: the copy succeeds, and EVERY file that existed before it is
#                      byte for byte the same — none changed, none deleted.
#                  12. Additive: the template arrived beside them (its rules folder) with the
#                      answers file.
#                  13. Additive: the report named the mode file the copy writes beside the
#                      repository's own SKILL.md as inert — a session must never read it as
#                      an instruction for a skill that does not carry the Mode paragraph.
#                  14. Additive: the report named the kept skills index as an index file to
#                      extend by hand, because the copy adds skills it does not list.
#                  15. Additive: when the kept .gitignore hides the .claude/skills/build/SKILL.md
#                      the copy adds, the report named that path with its rule
#                      (.gitignore:1:build/) and the consequence — never committed, and deleted
#                      by the next copier update (git check-ignore, DESIGN.md D42).
#                  16. Additive: the report said the kept .gitignore's unanchored build/ ignores
#                      every folder named build, and to anchor it as /build/.
#                  17. Business, additive: adopt/business.sh --additive succeeded and wrote
#                      nothing in the repository it reported on.
#                  18. Business: the report warned that unticking msp-scp in BUSINESS_FAMILIES
#                      deletes the library's own .claude/skills/msp-scp-documents/SKILL.md,
#                      kept at that family's template path (read from copier.yml's gates).
#                  19. Business: the report named the kept .github/workflows/google-drive-push.yml.
#                  20. Business: the report warned that the kept publish.yml, which mentions
#                      library/src/, will sync the drafts/ folders the copy adds (D37).
#                  21. Business: the report named the template pair the copy adds to
#                      library/src/business/, which already holds the library's own documents.
#                  22. Business: the report named the library's own library/docs/business-
#                      standards.md beside the template's library/docs/reference/business-
#                      standards.md, with the ## Overrides redirect line between them (D40, D41).
#                  23. Business: the report marked the rule an earlier copy left untracked
#                      'kept, untracked', apart from a file the library committed ('kept,
#                      committed'), so a leftover is never kept as the library's own unseen.
#                  24. Business: the report marked the kept seed the library's .gitignore hides
#                      'kept, ignored'.
#                  25. Outside link: adopt/theology.sh printed the copy as the plan
#                      'mv .agents .agents.syntek-held', the copy with --exclude /.agents, then
#                      'mv .agents.syntek-held .agents', and left the link as it was.
#                  26. Outside link: following that plan, the copy succeeds, .agents is the
#                      same link again, no .agents.syntek-held is left, and every file in the
#                      folder it points to is byte for byte as it was.
#                  27. Outside link with a missing target (a clone without the agent tree
#                      beside it): adopt/theology.sh printed the same three-line plan, since
#                      Copier refuses the destinations beneath a dangling outside link too.
#                  28. Additive: where the template's migrations/family-refresh.json lists
#                      .claude/skills/grilling/SKILL.md (a shared working-practice skill,
#                      DESIGN.md D51), the report named the repository's own grilling SKILL.md
#                      as kept at a shared path, never merged or replaced on update.
#                  29. Additive: the report's closing steps said that --skip-tasks skips the
#                      copy-time record the update report compares against (D41, D52).
#                  30. Moving: the kept .claude/settings.json changed only by the add-only merge
#                      of the template's migrations/family-refresh.json settings (D17, D51):
#                      every key, value and list item it held is still there in its order,
#                      everything added is an entry of that file (a top-level value, such as
#                      "autoCompactEnabled": false, only where the author's file had the key
#                      not at all, and then with exactly the listed value), each hook command
#                      the file lists is wired exactly once, and each top-level value it lists
#                      is there, judged whether or not the file changed, so a hook never wired
#                      fails as surely as one wired twice. The author's fixture settings.json
#                      holds no autoCompactEnabled, so the copy must add it.
#                      (Check 3 covers its bytes when there is no refresh file.)
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
# shellcheck source=SCRIPTDIR/_common.sh
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
# The additive flow's state (checks 11–16).
ADD_RAN=false; ADD_PROJ=""; ADD_STATUS=0; ADD_REPORT=""; ADD_CHANGED=""; ADD_BUILD_IGNORED=false
INERT_NOTE="grilling/THEOLOGY.md is written beside your own SKILL.md and stays inert"
EXTEND_NOTE="extend      .claude/skills/CONTEXT.md"
IGNORE_NOTE=".claude/skills/build/SKILL.md — .gitignore:1:build/: never committed, and deleted by the next copier update"
# Checks 28–29 (D51, D52): the kept shared skill, and the copy-time record --skip-tasks skips.
ADD_SHARED_LISTED=false; ADD_REPORTED=false
SHARED_NOTE=".claude/skills/grilling/SKILL.md sits at a shared skill's path"
BASELINE_NOTE="skips the copy-time task that records the template's render"
# The business additive report's state (checks 17–24).
BIZ_RAN=false; BIZ_PROJ=""; BIZ_STATUS=0; BIZ_REPORT=""; BIZ_CHANGED=""
FAMILY_NOTE="unticking msp-scp in BUSINESS_FAMILIES later deletes these files of yours:"
FAMILY_FILE=".claude/skills/msp-scp-documents/SKILL.md"
DRIVE_NOTE=".github/workflows/google-drive-push.yml is kept as yours"
DRAFTS_NOTE=".github/workflows/publish.yml mentions library/src/: the copy adds drafts/ folders"
SIGNPOST_NOTE="to library/src/business/, which already holds"
OWN_STANDARD="library/docs/business-standards.md"
# shellcheck disable=SC2016  # the backticks are the redirect line's own, printed as written
DUP_NOTE='redirect: `library/docs/reference/business-standards.md` → `library/docs/business-standards.md`'
LEFTOVER_FILE=".claude/rules/syntek-author/01-layout-and-routing.md"
LEFTOVER_NOTE="$LEFTOVER_FILE (kept, untracked"
COMMITTED_NOTE="$FAMILY_FILE (kept, committed)"
IGNORED_KEPT_NOTE=".mcp.json (kept, ignored"
# The outside-link flow's state (checks 25–27).
OUT_RAN=false; OUT_PROJ=""; OUT_REPORT=""; OUT_TARGET=""; OUT_ADVISED_TARGET=""; OUT_COPY_STATUS=0
OUT_AFTER_TARGET=""; OUT_HELD_LEFT=false; OUT_SUMS_BEFORE=""; OUT_SUMS_AFTER=""
OUT_HELD=".agents.syntek-held"
OUT_PLAN_HOLD="3. mv .agents $OUT_HELD"
OUT_PLAN_COPY="uvx copier copy --trust --overwrite --exclude /.agents "
OUT_PLAN_BACK="mv $OUT_HELD .agents"
OUT_DANGLING_REPORT=""

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
  # The author's own settings.json holds no autoCompactEnabled: the copy adds the template's (check 30).
  printf '{\n  "model": "opus"\n}\n' > "$p/.claude/settings.json"
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

# An anonymised business library with conventions of its own. Every name is invented.
build_business() { # $1 = dir
  local p="$1"
  mkdir -p "$p/.claude/skills/msp-scp-documents" "$p/library/src/msp-scp/example-client" \
    "$p/library/src/business/proposals" "$p/.github/workflows" "$p/library/docs"
  printf '/build/\n.mcp.json\n' > "$p/.gitignore"
  printf '# Example Library\n\nAn invented library of business documents.\n' > "$p/README.md"
  printf -- '---\nname: msp-scp-documents\ndescription: The library'\''s own managed-service document skill.\n---\n\n# Managed-service documents, our way\n' \
    > "$p/.claude/skills/msp-scp-documents/SKILL.md"
  printf '# CONTEXT.md — library/src/msp-scp/\n\nOur managed-service documents, one folder per client.\n' > "$p/library/src/msp-scp/CONTEXT.md"
  printf '# Backup policy — Example Client\n' > "$p/library/src/msp-scp/example-client/backup-policy.md"
  printf '# Proposal — Example Client\n' > "$p/library/src/business/proposals/proposal-example-client.md"
  printf 'name: Drive push (our own)\non: workflow_dispatch\njobs:\n  push:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo "push library/src/ to Drive"\n' \
    > "$p/.github/workflows/google-drive-push.yml"
  printf 'name: Publish\non: workflow_dispatch\njobs:\n  publish:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo "upload library/src/ to the document portal"\n' \
    > "$p/.github/workflows/publish.yml"
  printf '# Business standards — our own\n\nHow this library writes its proposals.\n' > "$p/$OWN_STANDARD"
  sa_git "$p" init -q && sa_git "$p" add -A && sa_git "$p" commit -q -m 'the library so far'
  sa_git "$p" checkout -q -b adopt-syntek-author
  # Never committed: a template rule an earlier copy left behind, and a seed git ignores.
  mkdir -p "$p/$(dirname "$LEFTOVER_FILE")"
  printf '# 01 — layout and routing\n\nLeft by an earlier copy.\n' > "$p/$LEFTOVER_FILE"
  printf '{"mcpServers": {"local": {}}}\n' > "$p/.mcp.json"
}

tree_sums() { # $1 = dir → every file but .git/, with its checksum, sorted
  (cd "$1" && find . -name .git -prune -o -type f -print0 | LC_ALL=C sort -z | xargs -0 sha1sum) 2>/dev/null
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
  SETTINGS_BEFORE="$2/settings.before.json"; REFRESH_JSON="$1/migrations/family-refresh.json"
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
  cp "$PROJ/.claude/settings.json" "$SETTINGS_BEFORE"
  sa_render "$tpl" "$PROJ" theology --overwrite --data SEED_EXAMPLES=false >>"$log" 2>&1 || COPY_STATUS=$?
  if sa_git "$PROJ" check-ignore -q .claude/skills/build/SKILL.md 2>/dev/null; then BUILD_IGNORED=true; fi
}

# Additive adoption (D41): the same repository, with its own grilling skill (no Mode paragraph)
# and its own skills index, gets the template beside every file it already has.
run_additive() { # $1 = template repo, $2 = work dir — fills the additive state
  local tpl="$2/tpl" log="$2/additive.log" f
  ADD_RAN=true; ADD_PROJ="$2/addproj"; ADD_STATUS=0; ADD_REPORT="$2/additive-report.log"; ADD_CHANGED=""; ADD_BUILD_IGNORED=false
  : > "$ADD_REPORT"
  build_existing "$ADD_PROJ" >>"$log" 2>&1
  mkdir -p "$ADD_PROJ/.claude/skills/grilling"
  printf -- '---\nname: grilling\ndescription: The repository'\''s own questioning skill.\n---\n\n# Grilling, our way\n' > "$ADD_PROJ/.claude/skills/grilling/SKILL.md"
  printf '# CONTEXT.md — .claude/skills/\n\n- `grilling/` — our questioning skill\n' > "$ADD_PROJ/.claude/skills/CONTEXT.md"
  sa_git "$ADD_PROJ" add -A && sa_git "$ADD_PROJ" commit -q -m 'our own skill' >>"$log" 2>&1
  ADD_SHARED_LISTED=false; ADD_REPORTED=false
  if [[ -f "$tpl/adopt/theology.sh" ]]; then
    ADD_REPORTED=true
    bash "$tpl/adopt/theology.sh" --additive "$ADD_PROJ" >"$ADD_REPORT" 2>&1 || true
    cat "$ADD_REPORT" >>"$log"
  fi
  grep -qF '.claude/skills/grilling/SKILL.md"' "$tpl/migrations/family-refresh.json" 2>/dev/null && ADD_SHARED_LISTED=true
  sa_render "$tpl" "$ADD_PROJ" theology --skip '*' --skip-tasks --data SEED_EXAMPLES=false >>"$log" 2>&1 || ADD_STATUS=$?
  ADD_CHANGED="$(git -C "$ADD_PROJ" status --porcelain 2>/dev/null | grep -v '^??' || true)"
  if [[ -f "$ADD_PROJ/.claude/skills/build/SKILL.md" ]] \
    && sa_git "$ADD_PROJ" check-ignore -q .claude/skills/build/SKILL.md 2>/dev/null; then ADD_BUILD_IGNORED=true; fi
}

# The business report (D39, D37, D41): report only, with an answers file that ticks msp-scp,
# so the library's own files at that family's paths are at risk on a later untick.
run_business() { # $1 = template repo, $2 = work dir — fills the business state
  local tpl="$2/tpl" log="$2/business.log" answers="$2/business.answers.yml"
  BIZ_RAN=true; BIZ_PROJ="$2/bizproj"; BIZ_STATUS=0; BIZ_REPORT="$2/business-report.log"; BIZ_CHANGED=""
  : > "$BIZ_REPORT"
  build_business "$BIZ_PROJ" >>"$log" 2>&1
  tree_sums "$BIZ_PROJ" > "$2/business.before"
  printf 'PROJECT_NAME: "%s"\nPROJECT_DESCRIPTION: "%s"\nAUTHOR_NAME: "%s"\nDATE: "%s"\nBUSINESS_FAMILIES:\n  - business\n  - msp-scp\nINCLUDE_DRIVE_SYNC: false\n' \
    "$SA_RENDER_NAME" "$SA_RENDER_DESCRIPTION" "$SA_RENDER_AUTHOR" "$SA_RENDER_DATE" > "$answers"
  if [[ -f "$tpl/adopt/business.sh" ]]; then
    bash "$tpl/adopt/business.sh" --additive --answers "$answers" "$BIZ_PROJ" >"$BIZ_REPORT" 2>&1 || BIZ_STATUS=$?
    cat "$BIZ_REPORT" >>"$log"
  else
    BIZ_STATUS=127; printf 'no adopt/business.sh in %s\n' "$tpl" >"$BIZ_REPORT"
  fi
  # Every file, committed, untracked or ignored, byte for byte as it was.
  BIZ_CHANGED="$(tree_sums "$BIZ_PROJ" | diff "$2/business.before" - | grep '^[<>]' || true)"
}

# An .agents link to a folder outside the repository (D48, Section 3.6): the advisory report,
# then the copy exactly as it prints it — the link held aside, the copy, the link put back.
run_outside() { # $1 = template repo, $2 = work dir (holding the snapshot run_flow made) — fills the outside state
  local tpl="$2/tpl" log="$2/outside.log" out="$2/outside-agents"
  OUT_RAN=true; OUT_PROJ="$2/outproj"; OUT_REPORT="$2/outside-report.log"; OUT_COPY_STATUS=0; OUT_HELD_LEFT=false
  : > "$OUT_REPORT"
  build_existing "$OUT_PROJ" >>"$log" 2>&1
  rm -rf "$out"; mkdir -p "$out/skills"
  printf "The author's own agent tree, outside the repository.\n" > "$out/note.md"
  OUT_SUMS_BEFORE="$(tree_sums "$out")"
  ln -s ../outside-agents "$OUT_PROJ/.agents"
  sa_git "$OUT_PROJ" add -A && sa_git "$OUT_PROJ" commit -q -m 'our own agent tree, linked' >>"$log" 2>&1
  OUT_TARGET="$(readlink "$OUT_PROJ/.agents")"
  if [[ -f "$tpl/adopt/theology.sh" ]]; then
    bash "$tpl/adopt/theology.sh" "$OUT_PROJ" >"$OUT_REPORT" 2>&1 || true
    cat "$OUT_REPORT" >>"$log"
  fi
  OUT_ADVISED_TARGET="$(readlink "$OUT_PROJ/.agents" 2>/dev/null || printf 'not a link')"
  # The plan as printed. The second mv runs whatever the copy did, as the report says.
  mv "$OUT_PROJ/.agents" "$OUT_PROJ/$OUT_HELD"
  sa_render "$tpl" "$OUT_PROJ" theology --overwrite --exclude /.agents --data SEED_EXAMPLES=false >>"$log" 2>&1 || OUT_COPY_STATUS=$?
  mv "$OUT_PROJ/$OUT_HELD" "$OUT_PROJ/.agents" >>"$log" 2>&1 || true
  OUT_AFTER_TARGET="$(readlink "$OUT_PROJ/.agents" 2>/dev/null || printf 'not a link')"
  if [[ -e "$OUT_PROJ/$OUT_HELD" || -L "$OUT_PROJ/$OUT_HELD" ]]; then OUT_HELD_LEFT=true; fi
  OUT_SUMS_AFTER="$(tree_sums "$out")"
  # The same repository in a clone without the agent tree: the link's target does not exist.
  OUT_DANGLING_REPORT="$2/outside-dangling-report.log"; : > "$OUT_DANGLING_REPORT"
  build_existing "$2/outdangling" >>"$log" 2>&1
  ln -s ../gone/agents "$2/outdangling/.agents"
  sa_git "$2/outdangling" add -A && sa_git "$2/outdangling" commit -q -m 'a dangling agent link' >>"$log" 2>&1
  if [[ -f "$tpl/adopt/theology.sh" ]]; then
    bash "$tpl/adopt/theology.sh" "$2/outdangling" >"$OUT_DANGLING_REPORT" 2>&1 || true
    cat "$OUT_DANGLING_REPORT" >>"$log"
  fi
}

outside_checks() {
  local line
  for line in "$OUT_PLAN_HOLD" "$OUT_PLAN_COPY" "$OUT_PLAN_BACK"; do
    grep -qF -- "$line" "$OUT_REPORT" 2>/dev/null \
      || finding "check 25 — the report on an .agents link outside the repository did not print '$line' — the copy fails on the link without the plan"
  done
  [[ "$OUT_ADVISED_TARGET" == "$OUT_TARGET" ]] \
    || finding "check 25 — the advisory report changed the outside .agents link (it is '$OUT_ADVISED_TARGET', it was '$OUT_TARGET')"
  if [[ "$OUT_COPY_STATUS" -ne 0 ]]; then
    finding "check 26 — the copy with the outside .agents link held aside failed (exit $OUT_COPY_STATUS)"
  else
    [[ "$OUT_AFTER_TARGET" == "$OUT_TARGET" ]] \
      || finding "check 26 — after the plan .agents is '$OUT_AFTER_TARGET', not the link to '$OUT_TARGET' it was"
    $OUT_HELD_LEFT && finding "check 26 — the plan left $OUT_HELD behind"
  fi
  [[ "$OUT_SUMS_AFTER" == "$OUT_SUMS_BEFORE" ]] \
    || finding "check 26 — the adoption wrote into the folder outside the repository that .agents links to"
  local missing=""
  for line in "$OUT_PLAN_HOLD" "$OUT_PLAN_COPY" "$OUT_PLAN_BACK"; do
    grep -qF -- "$line" "$OUT_DANGLING_REPORT" 2>/dev/null || missing="${missing:+$missing, }'$line'"
  done
  [[ -z "$missing" ]] \
    || finding "check 27 — the report on an .agents link to a missing folder outside the repository did not print $missing — the copy fails on the link without the plan"
  return 0
}

# The add-only settings merge (D17, D51): $1 the file before, $2 after, $3 family-refresh.json.
# Prints the first departure and fails; silent and 0 when $2 is $1 plus refresh entries only.
settings_add_only() {
  python3 - "$1" "$2" "$3" <<'PY'
import json, sys
try:
    b, a = (json.load(open(f, encoding="utf-8-sig")) for f in sys.argv[1:3])
except ValueError as e:
    print("it no longer parses as JSON (%s)" % e); sys.exit(1)
ref = json.load(open(sys.argv[3], encoding="utf-8")).get("settings", {})
def within(x, r):  # x is made only of what r holds
    if isinstance(x, dict):
        return isinstance(r, dict) and all(k in r and within(v, r[k]) for k, v in x.items())
    if isinstance(x, list):
        return isinstance(r, list) and all(any(within(i, j) for j in r) for i in x)
    return json.dumps(x) == json.dumps(r)  # false is never 0
def keeps(b, a, r, path):  # a keeps b, in order; whatever a adds is within r
    if isinstance(b, dict):
        if not isinstance(a, dict):
            return "%s is no longer an object" % path
        ka = [k for k in a if k in b]
        if ka != list(b):
            return "%s lost a key or changed their order" % path
        for k in a:
            if k in b:
                e = keeps(b[k], a[k], r.get(k) if isinstance(r, dict) else None, path + "." + k)
                if e: return e
            elif r is None or not isinstance(r, dict) or k not in r or not within(a[k], r[k]):
                return "%s.%s was added and is not a template entry" % (path, k)
        return None
    if isinstance(b, list):
        if not isinstance(a, list):
            return "%s is no longer a list" % path
        i = 0
        for item in a:
            if i < len(b) and item == b[i]:
                i += 1
            elif i < len(b) and isinstance(item, dict) and isinstance(b[i], dict) \
                    and not keeps(b[i], item, _pick(b[i], r), path + "[]"):
                i += 1
            elif r is None or not any(within(item, j) for j in r):
                return "%s gained an item that is not a template entry" % path
        return None if i == len(b) else "%s lost an item or changed their order" % path
    return None if a == b else "%s changed its value" % path
def _pick(x, r):
    for j in (r or []):
        if isinstance(j, dict) and all(j.get(k) == v for k, v in x.items() if not isinstance(v, (list, dict))):
            return j
    return None
e = keeps(b, a, ref, "settings")
if e:
    print(e); sys.exit(1)
cmds = [h.get("command") for g in sum(ref.get("hooks", {}).values(), []) for h in g.get("hooks", [])]
have = [h.get("command") for g in sum(a.get("hooks", {}).values(), []) for h in g.get("hooks", [])]
for c in cmds:
    if have.count(c) != 1:
        print("a hook of the template is wired %d times, not once: %s" % (have.count(c), c)); sys.exit(1)
# A top-level value the refresh file lists (autoCompactEnabled) is added where the author had none.
for k, v in ref.items():
    if k not in ("hooks", "permissions") and isinstance(v, (bool, int, float, str)) and k not in b and k not in a:
        print("settings.%s, which the refresh file lists, was not added to a file that had none" % k); sys.exit(1)
PY
}

run_checks() {
  FINDINGS=()
  $ADD_RAN && additive_checks
  $BIZ_RAN && business_checks
  $OUT_RAN && outside_checks
  [[ -n "$PROJ" ]] || return 0
  local f e now n
  if [[ "$COPY_STATUS" -ne 0 ]]; then
    finding "check 1 — copier copy --overwrite into the existing repository failed (exit $COPY_STATUS)"
    return 0
  fi
  for f in "${!BEFORE[@]}"; do
    now="$( [[ -f "$PROJ/$f" ]] && sha1sum < "$PROJ/$f" || echo gone)"
    # The kept settings.json is judged whether or not it changed: a hook the refresh file lists
    # and the adoption never wired is a finding too ('wired 0 times').
    if [[ "$f" == .claude/settings.json && -f "$REFRESH_JSON" && -f "$PROJ/$f" ]]; then
      e="$(settings_add_only "$SETTINGS_BEFORE" "$PROJ/$f" "$REFRESH_JSON")" \
        || finding "check 30 — adoption changed the author's .claude/settings.json beyond adding the template's entries: $e"
      continue
    fi
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

additive_checks() {
  if [[ "$ADD_STATUS" -ne 0 ]]; then
    finding "check 11 — the additive copy (--skip '*' --skip-tasks) failed (exit $ADD_STATUS)"
    return 0
  fi
  [[ -z "$ADD_CHANGED" ]] || finding "check 11 — the additive copy changed or removed a file that existed: $(printf '%s' "$ADD_CHANGED" | head -3 | tr '\n' ' ')"
  if [[ -z "$(find "$ADD_PROJ/.claude/rules/syntek-author" -type f 2>/dev/null | head -1)" || ! -f "$ADD_PROJ/$SA_ANSWERS_FILE" ]]; then
    finding "check 12 — the additive copy did not add the template's rules and the answers file beside the existing files"
  fi
  grep -qF "$INERT_NOTE" "$ADD_REPORT" 2>/dev/null \
    || finding "check 13 — the additive report did not name .claude/skills/grilling/THEOLOGY.md as inert beside the repository's own SKILL.md"
  grep -qF "$EXTEND_NOTE" "$ADD_REPORT" 2>/dev/null \
    || finding "check 14 — the additive report did not name the kept .claude/skills/CONTEXT.md as an index to extend"
  if $ADD_SHARED_LISTED && ! grep -qF "$SHARED_NOTE" "$ADD_REPORT" 2>/dev/null; then
    finding "check 28 — the additive report did not name the repository's own grilling SKILL.md as kept at a shared skill's path (D51): the author would expect an update to merge it"
  fi
  if $ADD_REPORTED && ! grep -qF "$BASELINE_NOTE" "$ADD_REPORT" 2>/dev/null; then
    finding "check 29 — the additive report did not say that --skip-tasks skips the copy-time record the update report compares against (D41, D52)"
  fi
  if $ADD_BUILD_IGNORED && ! grep -qF "$IGNORE_NOTE" "$ADD_REPORT" 2>/dev/null; then
    finding "check 15 — the kept .gitignore hides the .claude/skills/build/SKILL.md the copy added, and the additive report did not name it with its rule — it is never committed, and the next copier update deletes it"
  fi
  if grep -Eq '^[[:space:]]*build/?[[:space:]]*$' "$ADD_PROJ/.gitignore" 2>/dev/null \
    && ! grep -qF "$BUILD_NOTE" "$ADD_REPORT" 2>/dev/null; then
    finding "check 16 — the kept .gitignore has an unanchored build/ line and the additive report did not say to anchor it as /build/"
  fi
}

business_checks() {
  if [[ "$BIZ_STATUS" -ne 0 ]]; then
    finding "check 17 — adopt/business.sh --additive failed on a business library (exit $BIZ_STATUS)"
    return 0
  fi
  [[ -z "$BIZ_CHANGED" ]] || finding "check 17 — adopt/business.sh --additive wrote in the repository it reported on: $(printf '%s' "$BIZ_CHANGED" | head -3 | tr '\n' ' ')"
  grep -F "$FAMILY_NOTE" "$BIZ_REPORT" 2>/dev/null | grep -qF "$FAMILY_FILE" \
    || finding "check 18 — the additive report did not warn that unticking msp-scp deletes the library's own $FAMILY_FILE"
  grep -qF "$DRIVE_NOTE" "$BIZ_REPORT" 2>/dev/null \
    || finding "check 19 — the additive report did not name the kept .github/workflows/google-drive-push.yml"
  grep -qF "$DRAFTS_NOTE" "$BIZ_REPORT" 2>/dev/null \
    || finding "check 20 — the additive report did not warn that the kept publish.yml will sync the drafts/ folders the copy adds (D37)"
  grep -qF "$SIGNPOST_NOTE" "$BIZ_REPORT" 2>/dev/null \
    || finding "check 21 — the additive report did not name the template pair added to library/src/business/ beside the library's own documents"
  grep -qF "$DUP_NOTE" "$BIZ_REPORT" 2>/dev/null \
    || finding "check 22 — the additive report did not name $OWN_STANDARD beside the template's library/docs/reference/business-standards.md with its ## Overrides redirect"
  if ! grep -qF "$LEFTOVER_NOTE" "$BIZ_REPORT" 2>/dev/null || ! grep -qF "$COMMITTED_NOTE" "$BIZ_REPORT" 2>/dev/null; then
    finding "check 23 — the additive report did not tell the untracked $LEFTOVER_FILE ('kept, untracked') from the committed $FAMILY_FILE ('kept, committed')"
  fi
  grep -qF "$IGNORED_KEPT_NOTE" "$BIZ_REPORT" 2>/dev/null \
    || finding "check 24 — the additive report did not mark the kept .mcp.json, which .gitignore hides, 'kept, ignored'"
}

# The shared fixture has no document family, no Drive workflow and no build skill. This copy of
# it gets the real template's shape for each, so checks 15–24 run against the fixture too: the
# msp-scp family and the Drive workflows gated as copier.yml gates them, a drafts/ folder in the
# business family, the business standard in library/docs/reference/, and a build skill, with
# the template's own .gitignore anchored (as the real one is) so that git holds the skill.
extend_fixture() { # $1 = fixture template repo, $2 = scratch dir
  local t="$1" y="$1/copier.yml" d="$1/template" f
  cat > "$2/gates" <<'EOF'
  - "<: if not (DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES) :>/library/src/msp-scp<: endif :>"
  - "<: if not (DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES) :>/.claude/skills/msp-scp-documents<: endif :>"
  - "<: if not (DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC) :>/.github<: endif :>"
EOF
  awk -v g="$2/gates" '{ print } /^_exclude:/ { while ((getline l < g) > 0) print l }' "$y" > "$2/copier.yml"
  cat "$2/copier.yml" > "$y"
  cat >> "$y" <<'EOF'
BUSINESS_FAMILIES:
  type: str
  multiselect: true
  choices: [business, legal, email, accounting, social-media, msp-scp]
  default: [business]
  when: "<% DOC_TYPE == 'business' %>"
INCLUDE_DRIVE_SYNC:
  type: bool
  default: false
  when: "<% DOC_TYPE == 'business' %>"
EOF
  mkdir -p "$d/.claude/skills/build" "$d/.claude/skills/msp-scp-documents" "$d/library/src/msp-scp" \
    "$d/library/src/business/drafts" "$d/.github/workflows" "$d/library/docs/reference"
  printf '/build/\n' > "$d/.gitignore"
  printf -- '---\nname: build\ndescription: Build a proof.\n---\n\n# Skill: build (<%%PROJECT_NAME%%>)\n' > "$d/.claude/skills/build/SKILL.md"
  printf -- '---\nname: msp-scp-documents\ndescription: Create a managed-service document.\n---\n\n# Skill: msp-scp-documents\n' \
    > "$d/.claude/skills/msp-scp-documents/SKILL.md"
  for f in library/src/msp-scp library/src/business library/docs library/docs/reference; do
    printf '# CONTEXT.md — %s/\n' "$f" > "$d/$f/CONTEXT.md"
    printf '@./CONTEXT.md\n\n# CLAUDE.md — %s/\n' "$f" > "$d/$f/CLAUDE.md"
  done
  printf '# drafts/ — work in progress, never synced to Drive\n' > "$d/library/src/business/drafts/README.md"
  printf '# Business standards — the template'\''s\n' > "$d/library/docs/reference/business-standards.md"
  printf 'name: Drive push\non: workflow_dispatch\n' > "$d/.github/workflows/google-drive-push.yml"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture: a family, Drive sync and the build skill'
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
  extend_fixture "$tmp/fixture" "$tmp" >/dev/null
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
  # Check 30: the add-only settings merge, against a refresh file of the real shape.
  local held_refresh="$REFRESH_JSON"; REFRESH_JSON="$tmp/family-refresh.json"
  printf '%s\n' '{"format": 1, "template": "fixture", "refresh": [], "settings": {"autoCompactEnabled": false, "hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": "bash hook.sh", "timeout": 10}]}]}, "permissions": {"deny": ["AskUserQuestion"], "ask": []}}}' > "$REFRESH_JSON"
  cp "$PROJ/.claude/settings.json" "$tmp/s"
  python3 - "$SETTINGS_BEFORE" "$PROJ/.claude/settings.json" '{"autoCompactEnabled": false, "hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": "bash hook.sh", "timeout": 10}]}]}, "permissions": {"deny": ["AskUserQuestion"]}}' <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d.update(json.loads(sys.argv[3]))
open(sys.argv[2], "w").write(json.dumps(d, indent=2) + "\n")
PY
  probe_clean "check 30 accepts the template's entries added to the kept settings.json"
  sed -i 's/"opus"/"sonnet"/' "$PROJ/.claude/settings.json"
  probe "check 30 fires when a value the author set changes" "check 30 — adoption changed the author's .claude/settings.json beyond"
  sed -i 's/"sonnet"/"opus"/; s/"AskUserQuestion"/"AskUserQuestion", "Bash(rm:*)"/' "$PROJ/.claude/settings.json"
  probe "check 30 fires when an entry not in the refresh file is added" "check 30 — adoption changed the author's .claude/settings.json beyond"
  sed -i 's/, "Bash(rm:\*)"//; s/"AskUserQuestion"\]/"AskUserQuestion"]/' "$PROJ/.claude/settings.json"
  python3 - "$PROJ/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["hooks"]["UserPromptSubmit"] *= 2
open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")
PY
  probe "check 30 fires when a template hook is wired twice" "check 30 — adoption changed the author's .claude/settings.json beyond"
  python3 - "$PROJ/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["hooks"]["UserPromptSubmit"] = d["hooks"]["UserPromptSubmit"][:1]; d["autoCompactEnabled"] = 0
open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")
PY
  probe "check 30 fires when a top-level value is added with another value" "check 30 — adoption changed the author's .claude/settings.json beyond adding the template's entries: settings.autoCompactEnabled was added"
  python3 - "$PROJ/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); del d["autoCompactEnabled"]
open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")
PY
  probe "check 30 fires when the top-level value is not added" "settings.autoCompactEnabled, which the refresh file lists, was not added"
  python3 - "$PROJ/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["autoCompactEnabled"] = False; d["hooks"]["UserPromptSubmit"] *= 2
open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")
PY
  python3 - "$PROJ/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); del d["model"]
open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")
PY
  probe "check 30 fires when a key the author had is removed" "check 30 — adoption changed the author's .claude/settings.json beyond"
  cp "$SETTINGS_BEFORE" "$PROJ/.claude/settings.json"
  probe "check 30 fires when the adoption wired no hook (the file unchanged)" "wired 0 times"
  cp "$tmp/s" "$PROJ/.claude/settings.json"; REFRESH_JSON="$held_refresh"
  cp "$ADOPT_REPORT" "$tmp/h"; grep -vF "$BUILD_NOTE" "$tmp/h" > "$ADOPT_REPORT" || true
  probe "check 10 fires when the report misses the unanchored build/ line" "check 10"; cp "$tmp/h" "$ADOPT_REPORT"

  run_additive "$tmp/fixture" "$tmp"
  $ADD_BUILD_IGNORED || { printf '\033[31m  ✗ the additive copy no longer adds an ignored build skill — check 15 would never be exercised\033[0m\n' >&2; exit 2; }
  st_baseline "an additive adoption by the fixture template"
  ADD_STATUS=1; probe "check 11 fires when the additive copy fails" "check 11 — the additive copy (--skip"; ADD_STATUS=0
  ADD_CHANGED=" M .claude/MEMORY.md"; probe "check 11 fires when the additive copy changes a file" "check 11 — the additive copy changed"; ADD_CHANGED=""
  mv "$ADD_PROJ/.claude/rules" "$tmp/held-rules"; probe "check 12 fires when the template does not arrive" "check 12"; mv "$tmp/held-rules" "$ADD_PROJ/.claude/rules"
  cp "$ADD_REPORT" "$tmp/h"; grep -vF "$INERT_NOTE" "$tmp/h" > "$ADD_REPORT" || true
  probe "check 13 fires when the inert mode file is not named" "check 13"; cp "$tmp/h" "$ADD_REPORT"
  cp "$ADD_REPORT" "$tmp/h"; grep -vF "$EXTEND_NOTE" "$tmp/h" > "$ADD_REPORT" || true
  probe "check 14 fires when the kept index is not named" "check 14"; cp "$tmp/h" "$ADD_REPORT"
  cp "$ADD_REPORT" "$tmp/h"; grep -vF "$IGNORE_NOTE" "$tmp/h" > "$ADD_REPORT" || true
  probe "check 15 fires when the ignored build skill is not named" "check 15"; cp "$tmp/h" "$ADD_REPORT"
  cp "$ADD_REPORT" "$tmp/h"; grep -vF "$BUILD_NOTE" "$tmp/h" > "$ADD_REPORT" || true
  probe "check 16 fires when the unanchored build/ line is not named" "check 16"; cp "$tmp/h" "$ADD_REPORT"
  if $ADD_SHARED_LISTED; then
    cp "$ADD_REPORT" "$tmp/h"; grep -vF "$SHARED_NOTE" "$tmp/h" > "$ADD_REPORT" || true
    probe "check 28 fires when the kept shared skill is not named" "check 28"; cp "$tmp/h" "$ADD_REPORT"
  fi
  if $ADD_REPORTED; then
    cp "$ADD_REPORT" "$tmp/h"; grep -vF "$BASELINE_NOTE" "$tmp/h" > "$ADD_REPORT" || true
    probe "check 29 fires when the copy-time record note is missing" "check 29"; cp "$tmp/h" "$ADD_REPORT"
  fi
  ADD_RAN=false

  run_business "$tmp/fixture" "$tmp"
  st_baseline "an additive report on a business library by the fixture template"
  BIZ_STATUS=1; probe "check 17 fires when the business report fails" "check 17 — adopt/business.sh --additive failed"; BIZ_STATUS=0
  BIZ_CHANGED="?? stray.txt"; probe "check 17 fires when the report writes in the repository" "check 17 — adopt/business.sh --additive wrote"; BIZ_CHANGED=""
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$FAMILY_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 18 fires when a kept file at a family path is not named" "check 18"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$DRIVE_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 19 fires when the kept Drive workflow is not named" "check 19"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$DRAFTS_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 20 fires when the drafts warning is missing" "check 20"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$SIGNPOST_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 21 fires when the added signpost is not named" "check 21"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$DUP_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 22 fires when the same-named standard is not named with its redirect" "check 22"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$LEFTOVER_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 23 fires when the leftover is not marked untracked" "check 23"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; sed 's/(kept, committed)/(kept)/' "$tmp/h" > "$BIZ_REPORT"
  probe "check 23 fires when a committed file is not marked committed" "check 23"; cp "$tmp/h" "$BIZ_REPORT"
  cp "$BIZ_REPORT" "$tmp/h"; grep -vF "$IGNORED_KEPT_NOTE" "$tmp/h" > "$BIZ_REPORT" || true
  probe "check 24 fires when the ignored kept seed is not marked ignored" "check 24"; cp "$tmp/h" "$BIZ_REPORT"
  BIZ_RAN=false

  run_outside "$tmp/fixture" "$tmp"
  st_baseline "an adoption over an .agents link outside the repository, by the printed plan"
  local held_line
  for held_line in "$OUT_PLAN_HOLD" "$OUT_PLAN_COPY" "$OUT_PLAN_BACK"; do
    cp "$OUT_REPORT" "$tmp/h"; grep -vF -- "$held_line" "$tmp/h" > "$OUT_REPORT" || true
    probe "check 25 fires when the plan misses '$held_line'" "check 25 — the report on an .agents link"; cp "$tmp/h" "$OUT_REPORT"
  done
  OUT_ADVISED_TARGET="not a link"; probe "check 25 fires when the report moves the link" "check 25 — the advisory report changed"; OUT_ADVISED_TARGET="$OUT_TARGET"
  OUT_COPY_STATUS=1; probe "check 26 fires when the copy fails" "check 26 — the copy with the outside"; OUT_COPY_STATUS=0
  OUT_AFTER_TARGET="not a link"; probe "check 26 fires when the link is not put back" "check 26 — after the plan"; OUT_AFTER_TARGET="$OUT_TARGET"
  OUT_HELD_LEFT=true; probe "check 26 fires when the held link is left" "check 26 — the plan left"; OUT_HELD_LEFT=false
  local held_sums="$OUT_SUMS_AFTER"; OUT_SUMS_AFTER="$held_sums"$'\n'"x  ./mcp_config.json"
  probe "check 26 fires on a write into the outside folder" "check 26 — the adoption wrote"; OUT_SUMS_AFTER="$held_sums"
  cp "$OUT_DANGLING_REPORT" "$tmp/h"; grep -vF -- "$OUT_PLAN_HOLD" "$tmp/h" > "$OUT_DANGLING_REPORT" || true
  probe "check 27 fires when the plan is missing for a dangling outside link" "check 27 — the report on an .agents link to a missing folder"; cp "$tmp/h" "$OUT_DANGLING_REPORT"
  OUT_RAN=false
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
run_additive "$SA_ROOT" "$work"
run_business "$SA_ROOT" "$work"
run_outside "$SA_ROOT" "$work"
run_checks
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  log "  ✓ ${#BEFORE[@]} author file(s) byte-identical after adoption; no example added; answers written"
  if [[ "$ADOPT_STATUS" == skipped ]]; then log "  (adopt/theology.sh not found — the copy alone was tested)"
  else log "  adopt/theology.sh --apply ran first and succeeded, and reported the unanchored build/ line"; fi
  log "  additive: every existing file byte-identical after copy --skip '*' --skip-tasks; the report named the inert mode file and the index to extend"
  if $ADD_BUILD_IGNORED; then log "  additive: the report named the build skill the kept .gitignore hides, with its rule"
  else log "  (check 15 not exercised: the copy added no build skill that the kept .gitignore hides)"; fi
  log "  business: the additive report wrote nothing, and named the kept file at a family path, the kept Drive workflow, the drafts a workflow would sync, the added signpost, the same-named standard with its redirect, and each kept file as committed, untracked or ignored"
  log "  outside link: the report printed the hold, the copy with --exclude /.agents and the restore; following it adopted the repository with the link and its target untouched; a link to a missing outside folder got the same plan"
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
