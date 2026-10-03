#!/usr/bin/env bash
#
# coexist-test.sh — Prove a second template can share a project with syntek-author.
#
#                   syntek-author is the first of a family: syntek-media is planned to sit in
#                   the SAME repositories (DESIGN.md Section 9). Two templates in one project
#                   work only if neither can overwrite the other: each keeps its own answers
#                   file, its own rules folder and its own skills, and every file both would
#                   ship — README.md, CONTEXT.md, .claude/CLAUDE.md, the settings, the
#                   .gitignore — is a seed in both, written by whichever came first and updated
#                   by neither (D17). A shared root file that one of them OWNS is a file the two
#                   fight over on every update, and the loser is whatever the author wrote.
#
#                   The test renders a project, applies a dummy second template built at
#                   runtime (its own answers file, its own rules file, its own skill, and the
#                   D17 root files as seeds), changes both templates, updates both, and checks.
#
#                   Seven checks:
#                     1. The second template applies over the project without --overwrite —
#                        nothing it ships collides with what is there.
#                     2. Both answers files exist, under different names.
#                     3. syntek-author's update succeeds and delivers its change.
#                     4. The second template's update succeeds and delivers its change.
#                     5. Each template's own files survive the other's update.
#                     6. No file is owned by both: a path syntek-author renders and does not
#                        seed is never shipped by the second template, and the reverse.
#                     7. No conflict is left behind (no *.rej file, no conflict marker).
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: the real syntek-media, which does not exist yet. The
#                   dummy follows Section 9's rules; when syntek-media is written, point this
#                   test at it.
#
# SELF-TEST. --self-test runs the whole flow with a fixture syntek-author, proves it clean, then
#            mutates the result once per check and asserts exactly one finding each.
#
# Requirements: bash 4+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#
# Usage: coexist-test.sh [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = the two templates share the project cleanly
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, no copier.yml)

set -euo pipefail
SCRIPT_NAME="coexist-test.sh"
# shellcheck source=_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false

usage() {
  cat <<'EOF'
coexist-test.sh — Prove a second template can share a project with syntek-author

Usage: coexist-test.sh [--root DIR] [--quiet] [--self-test] [--help]

  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture template
  --help       Show this message

Exit codes: 0 = coexist cleanly  1 = finding(s), or the self-test no longer separates
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

B_ANSWERS=".copier-answers.dummy-media.yml"
B_RULE=".claude/rules/dummy-media/01-media.md"
A_MARK="<!-- coexist-test: syntek-author change -->"
B_MARK="<!-- coexist-test: dummy-media change -->"
SHARED_ROOT="README.md CONTEXT.md .gitignore .mcp.json .claude/CLAUDE.md .claude/CONTEXT.md .claude/MEMORY.md .claude/settings.json .claude/skills/CONTEXT.md .claude/skills/CLAUDE.md .claude/hooks/CONTEXT.md .claude/hooks/CLAUDE.md"

PROJ=""; A_RULE=""; A_COPY=0; B_COPY=0; A_UPDATE=0; B_UPDATE=0
A_OWNED=(); A_ALL=(); B_OWNED=(); B_ALL=()

# The second template, as DESIGN.md Section 9 requires one to be written.
build_dummy() { # $1 = dir
  local b="$1" s
  mkdir -p "$b/template/.claude/rules/dummy-media" "$b/template/.claude/skills/dummy-media-clip" "$b/template/media"
  {
    cat <<'EOF'
_min_copier_version: "9.6.0"
_subdirectory: template
_answers_file: .copier-answers.dummy-media.yml
_templates_suffix: ""
_envops:
  variable_start_string: "<%"
  variable_end_string: "%>"
  block_start_string: "<:"
  block_end_string: ":>"
  comment_start_string: "<~"
  comment_end_string: "~>"
  keep_trailing_newline: true
_skip_if_exists:
EOF
    for s in $SHARED_ROOT; do printf '  - /%s\n' "$s"; done
    printf 'PROJECT_NAME:\n  type: str\n'
  } > "$b/copier.yml"
  printf '<%% _copier_answers|to_nice_yaml -%%>\n' > "$b/template/$B_ANSWERS"
  printf '# 01 — media\n\nTemplate-owned by dummy-media.\n' > "$b/template/$B_RULE"
  printf -- '---\nname: dummy-media-clip\ndescription: Clip a recording.\n---\n' > "$b/template/.claude/skills/dummy-media-clip/SKILL.md"
  printf '# CONTEXT.md — media/\n' > "$b/template/media/CONTEXT.md"
  printf '@./CONTEXT.md\n\n# CLAUDE.md — media/\n' > "$b/template/media/CLAUDE.md"
  for s in $SHARED_ROOT; do mkdir -p "$(dirname "$b/template/$s")"; printf '# seeded by dummy-media\n' > "$b/template/$s"; done
  sa_git "$b" init -q && sa_git "$b" add -A && sa_git "$b" commit -q -m 'dummy-media'
}

owned_and_all() { # $1 = rendered dir, $2 = copier.yml, $3 = answers file → "O path" / "A path"
  local f s seed
  local -a skips=()
  while IFS= read -r s; do [[ -n "$s" ]] && skips+=("${s#/}"); done < <(yaml_list _skip_if_exists "$2")
  while IFS= read -r -d '' f; do
    f="${f#./}"
    [[ "$f" == "$3" ]] && continue
    echo "A $f"
    seed=false
    for s in "${skips[@]}"; do
      # shellcheck disable=SC2053  # _skip_if_exists entries may be globs
      [[ "$f" == $s ]] && { seed=true; break; }
    done
    $seed || echo "O $f"
  done < <(cd "$1" && find . -name .git -prune -o -type f -print0)
}

run_flow() { # $1 = syntek-author repo, $2 = work dir
  local w="$2" a="$2/a" b="$2/b" log="$2/flow.log" kind path
  PROJ="$w/proj"; A_COPY=0; B_COPY=0; A_UPDATE=0; B_UPDATE=0
  A_OWNED=(); A_ALL=(); B_OWNED=(); B_ALL=()
  sa_snapshot "$1" "$a" >>"$log" 2>&1 || die "could not snapshot $1"
  build_dummy "$b" >>"$log" 2>&1
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init

  sa_render "$a" "$PROJ" theology >>"$log" 2>&1 || A_COPY=$?
  [[ "$A_COPY" -eq 0 ]] || return 0
  [[ -d "$PROJ/.git" ]] || sa_git "$PROJ" init -q
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'syntek-author' >>"$log" 2>&1
  while read -r kind path; do
    if [[ "$kind" == O ]]; then A_OWNED+=("$path"); else A_ALL+=("$path"); fi
  done < <(owned_and_all "$PROJ" "$a/copier.yml" "$SA_ANSWERS_FILE")

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$w/b-alone" </dev/null >>"$log" 2>&1 || true
  while read -r kind path; do
    if [[ "$kind" == O ]]; then B_OWNED+=("$path"); else B_ALL+=("$path"); fi
  done < <(owned_and_all "$w/b-alone" "$b/copier.yml" "$B_ANSWERS")

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$PROJ" </dev/null >>"$log" 2>&1 || B_COPY=$?
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'dummy-media' >>"$log" 2>&1 || true

  A_RULE=".claude/skills/run-workflow/SKILL.md"
  [[ -f "$a/template/$A_RULE" ]] || A_RULE=".claude/rules/syntek-author/01-layout-and-routing.md"
  [[ -f "$a/template/$A_RULE" ]] || die "the template has neither run-workflow/SKILL.md nor the layout rule — nothing template-owned to update"
  printf '\n%s\n' "$A_MARK" >> "$a/template/$A_RULE"; sa_git "$a" add -A && sa_git "$a" commit -q -m change >>"$log" 2>&1
  printf '\n%s\n' "$B_MARK" >> "$b/template/$B_RULE"; sa_git "$b" add -A && sa_git "$b" commit -q -m change >>"$log" 2>&1

  sa_update "$PROJ" >>"$log" 2>&1 || A_UPDATE=$?
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'update syntek-author' >>"$log" 2>&1 || true
  (cd "$PROJ" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$B_ANSWERS" </dev/null) >>"$log" 2>&1 || B_UPDATE=$?
}

run_checks() {
  FINDINGS=()
  local p f
  local -A a_owned=() a_all=() b_owned=() b_all=()
  if [[ "$A_COPY" -ne 0 ]]; then finding "check 1 — syntek-author itself did not render (exit $A_COPY)"; return 0; fi
  [[ "$B_COPY" -eq 0 ]] || finding "check 1 — the second template could not apply over the project without --overwrite (exit $B_COPY) — something it ships collides"
  if [[ ! -f "$PROJ/$SA_ANSWERS_FILE" || ! -f "$PROJ/$B_ANSWERS" ]]; then
    finding "check 2 — the project does not hold both $SA_ANSWERS_FILE and $B_ANSWERS"
  fi
  # A file that vanished is check 5's; 3 and 4 judge delivery to a file that is there.
  if [[ "$A_UPDATE" -ne 0 ]]; then finding "check 3 — syntek-author's update failed (exit $A_UPDATE)"
  elif [[ -f "$PROJ/$A_RULE" ]] && ! grep -qF "$A_MARK" "$PROJ/$A_RULE"; then finding "check 3 — syntek-author's change did not reach $A_RULE"; fi
  if [[ "$B_UPDATE" -ne 0 ]]; then finding "check 4 — the second template's update failed (exit $B_UPDATE)"
  elif [[ -f "$PROJ/$B_RULE" ]] && ! grep -qF "$B_MARK" "$PROJ/$B_RULE"; then finding "check 4 — the second template's change did not reach $B_RULE"; fi
  [[ -f "$PROJ/$A_RULE" ]] || finding "check 5 — syntek-author's $A_RULE did not survive the second template's update"
  [[ -f "$PROJ/$B_RULE" ]] || finding "check 5 — the second template's $B_RULE did not survive syntek-author's update"
  for p in "${A_OWNED[@]}"; do a_owned["$p"]=1; done
  for p in "${A_ALL[@]}";   do a_all["$p"]=1; done
  for p in "${B_OWNED[@]}"; do b_owned["$p"]=1; done
  for p in "${B_ALL[@]}";   do b_all["$p"]=1; done
  for p in "${!a_owned[@]}"; do
    [[ -n "${b_all[$p]:-}" ]] && finding "check 6 — $p is template-owned by syntek-author and shipped by the second template — seed it in both (DESIGN.md D17)"
  done
  for p in "${!b_owned[@]}"; do
    [[ -n "${a_all[$p]:-}" ]] && finding "check 6 — $p is template-owned by the second template and shipped by syntek-author"
  done
  while IFS= read -r f; do
    finding "check 7 — conflict left behind: ${f#"$PROJ"/}"
  done < <( { find "$PROJ" -name .git -prune -o -name '*.rej' -print; \
              grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$PROJ" 2>/dev/null; } | sort -u || true)
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/fixture" >/dev/null
  run_flow "$tmp/fixture" "$tmp"
  st_baseline "the fixture template sharing a project with a dummy second template"

  B_COPY=1;   probe "check 1 fires when the second template collides" "check 1"; B_COPY=0
  mv "$PROJ/$B_ANSWERS" "$tmp/h"; probe "check 2 fires when an answers file is missing" "check 2"; mv "$tmp/h" "$PROJ/$B_ANSWERS"
  A_UPDATE=1; probe "check 3 fires when syntek-author's update fails" "check 3"; A_UPDATE=0
  cp "$PROJ/$B_RULE" "$tmp/h"; grep -vF "$B_MARK" "$tmp/h" > "$PROJ/$B_RULE"
  probe "check 4 fires when the second template's change is lost" "check 4"; cp "$tmp/h" "$PROJ/$B_RULE"
  mv "$PROJ/$B_RULE" "$tmp/h"; probe "check 5 fires when one template's file vanishes" "check 5"; mv "$tmp/h" "$PROJ/$B_RULE"
  A_OWNED+=("README.md"); probe "check 6 fires on a root file syntek-author owns" "check 6 — README.md"; unset 'A_OWNED[-1]'
  printf 'x\n' > "$PROJ/CONTEXT.md.rej"; probe "check 7 fires on a rejected hunk" "check 7"; rm -f "$PROJ/CONTEXT.md.rej"
  st_finish "templates that coexist from templates that collide"
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
  log "  ✓ both templates applied, both updated, ${#A_OWNED[@]} syntek-author-owned file(s) and ${#B_OWNED[@]} second-template-owned file(s) disjoint"
  rm -rf "$work"
  bold "✓ A second template shares the project cleanly."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s) (work kept in $work; output in $work/flow.log):"
print_findings
log ""
log "  DESIGN.md Section 9: own answers file, own rules folder, shared root files seeded in both."
exit 1
