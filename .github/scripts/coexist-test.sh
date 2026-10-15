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
#                   Seventeen checks:
#                     1. The second template applies over the project without --overwrite —
#                        nothing it ships collides with what is there.
#                     2. Both answers files exist, under different names.
#                     3. syntek-author's update succeeds and delivers its change.
#                     4. The second template's update succeeds and delivers its change.
#                     5. Each template's own files survive the other's update.
#                     6. No file is owned by both: a path syntek-author renders and does not
#                        seed is never shipped by the second template, and the reverse.
#                     7. No conflict is left behind (no *.rej file, no conflict marker).
#                     8. The copy-only agent files syntek-author wrote (DESIGN.md D47, Section
#                        3.6: AGENTS.md, GEMINI.md, .codex/, .gemini/, opencode.json, the
#                        .agents/skills link and .agents/mcp_config.json) are byte for byte what
#                        it wrote, and .agents/skills still links to ../.claude/skills, after
#                        the second template's copy and both updates. The dummy ships the same
#                        paths copy-only, with its own bridge beside syntek-author's. That
#                        follows syntek-media: its D73 makes AGENTS.md, GEMINI.md, .agents and
#                        the .codex/ files copy-only, and its 0.4.2 (D76) replaces the .agents
#                        link with the real .agents/ folder holding the skills link and
#                        mcp_config.json; media does not yet ship .gemini/ or opencode.json.
#                     9. The other order, as a project that took syntek-media 0.4.2 first: the
#                        dummy's real .agents/ (skills link, 23-byte mcp_config.json) is there
#                        before syntek-author's copy, which then succeeds with no --exclude and
#                        leaves .agents a real folder, .agents/skills the link to
#                        ../.claude/skills, mcp_config.json the same 23 bytes, and both bridges.
#                    10. The family-shared contract (DESIGN.md D48), in that media-first
#                        project: the dummy vendors every token-free source family-shared.json
#                        lists, as a sibling template would, so each such file in the project
#                        (the permissions script under both templates' names) carries the
#                        manifest's sha256, and each listed link its target, whichever template
#                        wrote it. Skipped, by name, when the repository has no
#                        family-shared.json.
#                    11. Each template keeps its own render record (DESIGN.md D52), in both
#                        orders: after both copies the project holds refs/syntek-author/template
#                        and refs/dummy-media/template, and after both updates each template's
#                        refs/<template>/yours as well. The dummy runs the same family-shared
#                        migrations/family-update.py, block and task, with its own
#                        family-refresh.json, as a sibling template does.
#                    12. The shared working practice (D51) across templates: syntek-author's
#                        update refreshes a shared skill both copies wrote, and the dummy's later
#                        update, whose own release changed that file differently, leaves
#                        syntek-author's bytes and reports the file under "NOT UPDATED because
#                        the file holds syntek-author's version" (the sibling attribution).
#                    13. Each report is its own: every path syntek-author's report lists is in
#                        its own render record, every path the dummy's lists in the dummy's, and
#                        neither lists a conflict or a rejected hunk the other template's update
#                        left (there are none in this flow).
#
#                   A sibling at the D48 set only (syntek-media 0.5.0: the agent files, none of
#                   the D51 shared working practice, no family-update.py), in both orders,
#                   which then adopts the shared set in a later release (syntek-media 0.6.0):
#                    14. syntek-author's update beside it succeeds, prints one report, refreshes
#                        the shared skill, keeps only syntek-author's refs, and wires each hook
#                        of family-refresh.json exactly once (and holds each top-level value it
#                        lists, autoCompactEnabled, once, with that value).
#                    15. Sibling first: syntek-author's copy over the sibling's own
#                        settings.json (tab-indented, no hooks, no autoCompactEnabled) wires each
#                        hook exactly once, adds autoCompactEnabled false once, and keeps the
#                        sibling's lines as they were.
#                    16. The sibling's later update to its release with the shared set (whose
#                        family-refresh.json and seed carry autoCompactEnabled false too)
#                        succeeds, records refs/dummy-media/template and yours, leaves no
#                        conflict, wires no hook twice, writes no key twice and leaves the shared
#                        skill's bytes as they were.
#                    17. The sibling's own MEDIA-*.md mode file beside a shared skill arrives,
#                        and is neither in syntek-author's record nor in either report.
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: the real syntek-media. The dummy follows Section 9's
#                   rules and media 0.4.2's .agents/ layout; family-shared.sh --sibling compares
#                   a real syntek-media checkout's vendored sources.
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
# shellcheck source=SCRIPTDIR/_common.sh
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
B_BRIDGE=".claude/dummy-media-agents.md"
B_MODE="MEDIA-BUSINESS.md"   # the sibling's own mode file beside each shared skill (its names are MEDIA-*)
SH_MARK_A="<!-- coexist-test: syntek-author's next revision of a shared file -->"
SH_MARK_B="<!-- coexist-test: dummy-media's own next revision of a shared file -->"
SH_FILE=""; A_LOG=""; B_LOG=""; SH_A_SUM=""; B_FIRST=""

PROJ=""; A_RULE=""; A_COPY=0; B_COPY=0; A_UPDATE=0; B_UPDATE=0
A_OWNED=(); A_ALL=(); B_OWNED=(); B_ALL=()
declare -A A_KEPT=()
MF=""; MF_B_COPY=0; MF_A_COPY=0; MANIFEST=""; MF_RAN=false
NOTES=()

# The family-shared files a sibling template vendors into its template/: every token-free file
# family-shared.json lists with the project scope, at its destination path ("<template>" filled
# with $3), and every listed link. A "repository" entry sits at the template repository's root
# and never reaches a project. Prints
# "F<TAB>path<TAB>sha256<TAB>source" and "L<TAB>path<TAB>target" lines.
manifest_entries() { # $1 = syntek-author repo, $2 = manifest, $3 = template name
  python3 - "$1" "$2" "$3" <<'PY'
import hashlib, json, sys
root, man, name = sys.argv[1], sys.argv[2], sys.argv[3]
for f in json.load(open(man, encoding="utf-8")).get("files", []):
    if f.get("scope", "project") != "project":
        continue  # a template-repository file (the migration script): never in a project
    path = f["path"].replace("<template>", name)
    if f.get("kind") == "symlink":
        print(f"L\t{path}\t{f['target']}"); continue
    data = open(f"{root}/{f['source']}", "rb").read()
    if any(d in data for d in (b"<%", b"<:", b"<~")):
        continue  # rendered from answers: identical only for identical answers
    print(f"F\t{path}\t{f['sha256']}\t{f['source']}")
PY
}

# The second template, as DESIGN.md Section 9 requires one to be written, with syntek-media
# 0.4.2's .agents/ layout, vendoring the family-shared sources when $2 has a manifest.
# $3 = d48: a sibling at the D48 set only (syntek-media 0.5.0): none of the shared working
# practice (D51), no family-update.py, no block and no task, and a settings.json of its own
# (tab-indented, no hooks). Otherwise the sibling ships the shared set too, with a MEDIA-*.md
# mode file of its own beside each shared skill and the shared hooks wired in its settings.
build_dummy() { # $1 = dir, $2 = the syntek-author repo it vendors from (optional), $3 = d48 (optional)
  local b="$1" src="${2:-}" mode="${3:-}" s kind path sum source shared="" refresh=""
  mkdir -p "$b/template/.claude/rules/dummy-media" "$b/template/.claude/skills/dummy-media-clip" "$b/template/media" "$b/migrations"
  # The shared working practice the sibling ships too (D51): what syntek-author refreshes.
  if [[ -n "$src" && -f "$src/migrations/family-refresh.json" ]]; then
    refresh="$(python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1]))["refresh"]))' "$src/migrations/family-refresh.json")"
    [[ "$mode" == d48 ]] || shared="$refresh"
  fi
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
    for s in $SHARED_ROOT $SA_COPY_ONLY $shared; do printf '  - /%s\n' "$s"; done
    printf '_preserve_symlinks: true\n_exclude:\n  - .git\n'
    for s in $SA_COPY_ONLY $SA_COPY_ONLY_DIRS $shared; do printf '  - "<: if %s :>/%s<: endif :>"\n' "$SA_COPY_ONLY_GATE" "$s"; done
    printf 'PROJECT_NAME:\n  type: str\n'
    # The family-shared update script, its block and its task, as a sibling carries them (D52).
    if [[ "$mode" != d48 && -n "$src" && -f "$src/migrations/family-update.py" ]] && grep -qF "$SA_UPD_END" "$src/copier.yml"; then
      printf '_migrations:\n'
      awk -v b="$SA_UPD_BEGIN" -v e="$SA_UPD_END" '$0 == b { on = 1 } on { print } $0 == e { on = 0 }' "$src/copier.yml"
      printf '_tasks:\n  - command: "[ -d .git ] || git init --initial-branch=main"\n    when: "<%% _copier_operation == %s %%>"\n' "'copy'"
      grep -A1 -F 'migrations/family-update.py" baseline' "$src/copier.yml"
    fi
  } > "$b/copier.yml"
  if [[ "$mode" != d48 && -n "$src" && -f "$src/migrations/family-update.py" ]]; then
    cp "$src/migrations/family-update.py" "$b/migrations/family-update.py"
    # Its own refresh list and the shared hooks' settings entries, as a sibling carries them.
    python3 - "$b/migrations/family-refresh.json" "$shared" "$src/migrations/family-refresh.json" <<'PY'
import json, sys
want = json.load(open(sys.argv[3], encoding="utf-8")).get("settings") or {}
top = {k: v for k, v in want.items() if k not in ("hooks", "permissions")}
json.dump({"format": 1, "template": "dummy-media", "refresh": sys.argv[2].split(),
           "settings": {**top, "hooks": want.get("hooks") or {}, "permissions": {"deny": [], "ask": []}}},
          open(sys.argv[1], "w", encoding="utf-8"), indent=2)
PY
  fi
  printf '<%% _copier_answers|to_nice_yaml -%%>\n' > "$b/template/$B_ANSWERS"
  printf '# 01 — media\n\nTemplate-owned by dummy-media.\n' > "$b/template/$B_RULE"
  printf -- '---\nname: dummy-media-clip\ndescription: Clip a recording.\n---\n' > "$b/template/.claude/skills/dummy-media-clip/SKILL.md"
  printf '# CONTEXT.md — media/\n' > "$b/template/media/CONTEXT.md"
  printf '@./CONTEXT.md\n\n# CLAUDE.md — media/\n' > "$b/template/media/CLAUDE.md"
  for s in $SHARED_ROOT $SA_COPY_ONLY; do
    [[ "$s" == .agents/skills ]] && continue
    mkdir -p "$(dirname "$b/template/$s")"; printf '# seeded by dummy-media\n' > "$b/template/$s"
  done
  ln -s "$SA_AGENTS_LINK_TARGET" "$b/template/.agents/skills"
  # Its settings.json seed is JSON of its own: tab-indented; the G sibling wires the shared hooks.
  python3 - "$b/template/.claude/settings.json" "$src/migrations/family-refresh.json" "$mode" <<'PY'
import json, os, sys
d = {"model": "sonnet"}
if sys.argv[3] != "d48" and os.path.isfile(sys.argv[2]):
    want = json.load(open(sys.argv[2], encoding="utf-8")).get("settings") or {}
    d.update({k: v for k, v in want.items() if k not in ("hooks", "permissions")})
    if want.get("hooks"):
        d["hooks"] = want["hooks"]
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent="\t") + "\n")
PY
  # Media's own mode files beside each shared skill (MEDIA-BUSINESS.md and its kind).
  for s in $shared; do
    [[ "$s" == */SKILL.md ]] || continue
    mkdir -p "$b/template/$(dirname "$s")"
    printf '# Mode: media business

Template-owned by dummy-media.
' > "$b/template/$(dirname "$s")/$B_MODE"
  done
  printf '%s' "$SA_AGENTS_MCP" > "$b/template/.agents/mcp_config.json"
  printf '# dummy-media bridge\n\nTemplate-owned by dummy-media.\n' > "$b/template/$B_BRIDGE"
  if [[ -n "$src" && -f "$src/family-shared.json" ]]; then
    while IFS=$'\t' read -r kind path sum source; do
      mkdir -p "$(dirname "$b/template/$path")"
      if [[ "$kind" == L ]]; then rm -rf "${b:?}/template/$path"; ln -s "$sum" "$b/template/$path"
      else cp "$src/$source" "$b/template/$path"; fi
    done < <(manifest_entries "$src" "$src/family-shared.json" dummy-media | awk -F'\t' -v skip=" $refresh " -v d48="$mode" \
               'd48 != "d48" || index(skip, " " $2 " ") == 0')
  fi
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
  A_FIRST="$(git -C "$a" rev-parse HEAD)"   # syntek-author before its change: where the D48 flows copy
  build_dummy "$b" "$a" >>"$log" 2>&1
  B_FIRST="$(git -C "$b" rev-parse HEAD)"   # the dummy's first release, which the media-first copy takes
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init

  sa_render "$a" "$PROJ" theology >>"$log" 2>&1 || A_COPY=$?
  [[ "$A_COPY" -eq 0 ]] || return 0
  [[ -d "$PROJ/.git" ]] || sa_git "$PROJ" init -q
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'syntek-author' >>"$log" 2>&1
  while read -r kind path; do
    if [[ "$kind" == O ]]; then A_OWNED+=("$path"); else A_ALL+=("$path"); fi
  done < <(owned_and_all "$PROJ" "$a/copier.yml" "$SA_ANSWERS_FILE")
  A_KEPT=()
  for path in $SA_COPY_ONLY; do
    if [[ -L "$PROJ/$path" ]]; then A_KEPT["$path"]="link:$(readlink "$PROJ/$path")"
    elif [[ -f "$PROJ/$path" ]]; then A_KEPT["$path"]="$(sha256sum < "$PROJ/$path")"; fi
  done

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$w/b-alone" </dev/null >>"$log" 2>&1 || true
  while read -r kind path; do
    if [[ "$kind" == O ]]; then B_OWNED+=("$path"); else B_ALL+=("$path"); fi
  done < <(owned_and_all "$w/b-alone" "$b/copier.yml" "$B_ANSWERS")

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$PROJ" </dev/null >>"$log" 2>&1 || B_COPY=$?
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'dummy-media' >>"$log" 2>&1 || true

  A_RULE=".claude/skills/run-workflow/SKILL.md"
  [[ -f "$a/template/$A_RULE" ]] || A_RULE=".claude/rules/syntek-author/01-layout-and-routing.md"
  [[ -f "$a/template/$A_RULE" ]] || die "the template has neither run-workflow/SKILL.md nor the layout rule — nothing template-owned to update"
  printf '\n%s\n' "$A_MARK" >> "$a/template/$A_RULE"
  # A shared skill both templates ship: each template's next release changes it its own way
  # (version skew), so the dummy's update meets syntek-author's newer bytes (check 12).
  SH_FILE=""
  if [[ -f "$a/migrations/family-refresh.json" ]]; then
    SH_FILE="$(python3 -c 'import json,sys; print(next((p for p in json.load(open(sys.argv[1]))["refresh"] if p.endswith("SKILL.md")), ""))' "$a/migrations/family-refresh.json")"
  fi
  if [[ -n "$SH_FILE" && -f "$a/template/$SH_FILE" && -f "$b/template/$SH_FILE" ]]; then
    printf '\n%s\n' "$SH_MARK_A" >> "$a/template/$SH_FILE"; printf '\n%s\n' "$SH_MARK_B" >> "$b/template/$SH_FILE"
  else
    SH_FILE=""
  fi
  sa_git "$a" add -A && sa_git "$a" commit -q -m change >>"$log" 2>&1
  printf '\n%s\n' "$B_MARK" >> "$b/template/$B_RULE"; sa_git "$b" add -A && sa_git "$b" commit -q -m change >>"$log" 2>&1

  A_LOG="$w/a-update.log"; B_LOG="$w/b-update.log"
  sa_update "$PROJ" >"$A_LOG" 2>&1 || A_UPDATE=$?
  cat "$A_LOG" >>"$log"
  SH_A_SUM=""; [[ -n "$SH_FILE" ]] && SH_A_SUM="$(sha256sum < "$PROJ/$SH_FILE")"
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'update syntek-author' >>"$log" 2>&1 || true
  (cd "$PROJ" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$B_ANSWERS" </dev/null) >"$B_LOG" 2>&1 || B_UPDATE=$?
  cat "$B_LOG" >>"$log"

  # The other order: the dummy (syntek-media 0.4.2's layout) first, then syntek-author, with no
  # --exclude.
  MF="$w/media-first"; MF_B_COPY=0; MF_A_COPY=0; MF_RAN=true
  MANIFEST=""; [[ -f "$a/family-shared.json" ]] && MANIFEST="$a/family-shared.json"
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$B_FIRST" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$MF" </dev/null >>"$log" 2>&1 || MF_B_COPY=$?
  [[ -d "$MF/.git" ]] || sa_git "$MF" init -q
  sa_git "$MF" add -A && sa_git "$MF" commit -q -m 'dummy-media first' >>"$log" 2>&1 || true
  sa_render "$a" "$MF" theology >>"$log" 2>&1 || MF_A_COPY=$?
  MF_SRC="$a"

  # A sibling at the D48 set only, in both orders, which later adopts the shared set.
  run_d48_flow "$a" "$w"
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
  local now
  for p in "${!A_KEPT[@]}"; do
    now=""
    if [[ -L "$PROJ/$p" ]]; then now="link:$(readlink "$PROJ/$p")"
    elif [[ -f "$PROJ/$p" ]]; then now="$(sha256sum < "$PROJ/$p")"; fi
    [[ "$now" == "${A_KEPT[$p]}" ]] || finding "check 8 — the copy-only $p syntek-author wrote did not survive the second template and both updates unchanged"
  done
  [[ -z "${A_KEPT[.agents/skills]:-}" || "${A_KEPT[.agents/skills]}" == "link:$SA_AGENTS_LINK_TARGET" ]] \
    || finding "check 8 — syntek-author's .agents/skills links to ${A_KEPT[.agents/skills]#link:}, not $SA_AGENTS_LINK_TARGET"
  $MF_RAN && media_first_checks
  report_checks
  $D48_RAN && d48_checks
  return 0
}

# The paths one report lists, from the last report for $2 in a log.
report_paths() { # $1 = log, $2 = template name
  python3 - "$1" "$2" <<'PY'
import re, sys
lines = open(sys.argv[1], encoding="utf-8", errors="replace").read().splitlines()
starts = [i for i, l in enumerate(lines) if l.startswith(f"▸ {sys.argv[2]} update report")]
cur = None
for l in (lines[starts[-1]:] if starts else []):
    if re.match(r"  [A-Z]{2}", l):
        cur = l.strip()
    elif re.match(r"    \S", l) and cur and not l.strip().startswith("…"):
        print(cur + "\t" + l.strip())
    elif l and not l.startswith((" ", "▸")):
        break
PY
}

report_checks() {
  local r t log p sec
  [[ "$A_COPY" -eq 0 && "$B_COPY" -eq 0 ]] || return 0
  [[ -f "$MF_SRC/migrations/family-update.py" ]] || { NOTES+=("checks 11–13 skipped — the repository has no migrations/family-update.py"); return 0; }
  for r in refs/syntek-author/template refs/dummy-media/template refs/syntek-author/yours refs/dummy-media/yours; do
    git -C "$PROJ" rev-parse -q --verify "$r" >/dev/null 2>&1 || finding "check 11 — after both copies and both updates the project has no $r — each template keeps its own render record"
  done
  if [[ "$MF_A_COPY" -eq 0 && "$MF_B_COPY" -eq 0 ]]; then
    for r in refs/syntek-author/template refs/dummy-media/template; do
      git -C "$MF" rev-parse -q --verify "$r" >/dev/null 2>&1 || finding "check 11 — media first: after both copies the project has no $r"
    done
  fi
  [[ -n "$SH_FILE" ]] || NOTES+=("check 12 skipped — no shared SKILL.md that both templates ship")
  if [[ -n "$SH_FILE" && "$A_UPDATE" -eq 0 && "$B_UPDATE" -eq 0 ]]; then
    if ! grep -qF "$SH_MARK_A" "$PROJ/$SH_FILE" 2>/dev/null || [[ "$(sha256sum < "$PROJ/$SH_FILE")" != "$SH_A_SUM" ]]; then
      finding "check 12 — the shared $SH_FILE does not hold syntek-author's refreshed revision after both updates — the dummy's update overwrote or merged it, or syntek-author's never refreshed it"
    fi
    sec="$(report_paths "$B_LOG" dummy-media | awk -F'\t' -v p="$SH_FILE" '$2 == p { print $1; exit }')"
    [[ "$sec" == "NOT UPDATED because the file holds syntek-author's version"* ]] \
      || finding "check 12 — the dummy's report lists $SH_FILE under '${sec:-nothing}', not as holding syntek-author's version"
  fi
  for t in syntek-author dummy-media; do
    log="$A_LOG"; [[ "$t" == dummy-media ]] && log="$B_LOG"
    while IFS=$'\t' read -r sec p; do
      [[ -z "$p" ]] && continue
      case "$sec" in CONFLICT*|REJECTED*) finding "check 13 — $t's report lists a conflict ($p) in an update that left none of its own" ;; esac
      git -C "$PROJ" cat-file -e "refs/$t/template:$p" 2>/dev/null || git -C "$PROJ" cat-file -e "refs/$t/template^:$p" 2>/dev/null \
        || finding "check 13 — $t's report lists $p, which $t does not render — a report holds only its own template's files"
    done < <(report_paths "$log" "$t")
  done
  return 0
}

# ── A sibling at the D48 set only, then adopting the shared working practice (checks 14–17) ──

# Judges a project's settings.json against syntek-author's family-refresh.json: prints "ok", or
# each hook entry that is not wired exactly once, and each top-level value it lists
# (autoCompactEnabled) that the file's text does not hold exactly once with that value (a key
# written twice parses silently to the last). $3 = tabs: the file must still be the sibling's
# own, tab-indented with its own first key.
hooks_once() { # $1 = settings.json, $2 = family-refresh.json, $3 = tabs (optional)
  python3 - "$1" "$2" "${3:-}" <<'PY'
import json, re, sys
path, data, keep = sys.argv[1:]
try:
    text = open(path, encoding="utf-8").read()
    st = json.loads(text)
except (OSError, ValueError) as e:
    print(f"settings.json unreadable ({e})"); sys.exit(0)
settings = json.load(open(data, encoding="utf-8")).get("settings") or {}
want = settings.get("hooks") or {}
scripts = lambda e: set(re.findall(r"\.claude/hooks/([A-Za-z0-9._-]+)", json.dumps(e.get("hooks"))))
bad = []
for event, entries in want.items():
    for w in entries:
        n = sum(1 for e in (st.get("hooks") or {}).get(event) or []
                if e.get("matcher", "") == w.get("matcher", "") and scripts(w) <= scripts(e))
        if n != 1:
            bad.append(f"{event} {w.get('matcher', '')} {','.join(sorted(scripts(w)))} wired {n} time(s)")
for key, value in settings.items():
    if key in ("hooks", "permissions") or isinstance(value, (dict, list)) or value is None:
        continue
    n = len(re.findall(r'"%s"\s*:' % re.escape(key), text))
    if n != 1 or json.dumps(st.get(key)) != json.dumps(value):
        bad.append(f"{key} written {n} time(s), value {json.dumps(st.get(key))}, not {json.dumps(value)} once")
if keep == "tabs" and (any(l.startswith(" ") for l in text.splitlines()) or list(st)[:1] != ["model"]):
    bad.append("the sibling's tab indentation or key order was not kept")
print("; ".join(bad) or "ok")
PY
}
conflicts_in() { # $1 = project → its .rej files and conflict markers, space-separated
  { find "$1" -name .git -prune -o -name '*.rej' -print; grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$1" 2>/dev/null; } \
    | sort -u | sed "s|^$1/||" | paste -sd' ' - || true
}

D48_RAN=false; A_FIRST=""
declare -A D48=()
run_d48_flow() { # $1 = syntek-author snapshot (with A_FIRST and its change), $2 = work dir
  local a="$1" w="$2/d48" log="$2/d48-flow.log" b="$2/d48/dummy" order p sum
  D48=(); D48_RAN=true
  [[ -f "$a/migrations/family-update.py" ]] || { D48_RAN=false; NOTES+=("checks 14–17 skipped — the repository has no migrations/family-update.py"); return 0; }
  mkdir -p "$w"
  build_dummy "$b" "$a" d48 >>"$log" 2>&1
  local first; first="$(git -C "$b" rev-parse HEAD)"
  # The sibling's later release adopts the shared working practice: the same bytes, its own
  # family-update.py, block, task, refresh list and MEDIA-* mode files.
  build_dummy "$w/dummy-g" "$a" >>"$log" 2>&1
  rsync -a --delete --exclude .git "$w/dummy-g/" "$b/" >>"$log" 2>&1
  sa_git "$b" add -A && sa_git "$b" commit -q -m 'dummy-media adopts the shared working practice' >>"$log" 2>&1
  for order in author-first d48-first; do
    p="$w/$order"
    if [[ "$order" == author-first ]]; then
      a_copy_at "$a" "$A_FIRST" "$p" >>"$log" 2>&1 || D48[$order.a_copy]=$?
      [[ -d "$p/.git" ]] || sa_git "$p" init -q
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'syntek-author' >>"$log" 2>&1 || true
      "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$first" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$p" </dev/null >>"$log" 2>&1 || D48[$order.b_copy]=$?
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'dummy-media at D48' >>"$log" 2>&1 || true
    else
      "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$first" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$p" </dev/null >>"$log" 2>&1 || D48[$order.b_copy]=$?
      [[ -d "$p/.git" ]] || sa_git "$p" init -q
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'dummy-media at D48' >>"$log" 2>&1 || true
      a_copy_at "$a" "$A_FIRST" "$p" >>"$log" 2>&1 || D48[$order.a_copy]=$?
      D48[$order.copied]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json" tabs)"
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'syntek-author' >>"$log" 2>&1 || true
    fi
    sa_update "$p" >"$w/$order-a.log" 2>&1 || D48[$order.a_update]=$?
    cat "$w/$order-a.log" >>"$log"
    D48[$order.a_report]="$(grep -c '^▸ syntek-author update report' "$w/$order-a.log" || true)"
    D48[$order.a_refreshed]=true
    [[ -z "$SH_FILE" ]] || grep -qF "$SH_MARK_A" "$p/$SH_FILE" 2>/dev/null || D48[$order.a_refreshed]=false
    D48[$order.a_refs]="$(git -C "$p" for-each-ref --format='%(refname)' 'refs/syntek-author/' 'refs/dummy-media/' | paste -sd' ' -)"
    D48[$order.a_hooks]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json")"
    sa_git "$p" add -A && sa_git "$p" commit -q -m 'update syntek-author' >>"$log" 2>&1 || true
    sum="$(cd "$p" && for f in $SH_FILE; do sha256sum "$f"; done)"
    (cd "$p" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$B_ANSWERS" </dev/null) >"$w/$order-b.log" 2>&1 || D48[$order.b_update]=$?
    cat "$w/$order-b.log" >>"$log"
    D48[$order.b_refs]="$(git -C "$p" for-each-ref --format='%(refname)' 'refs/dummy-media/' | paste -sd' ' -)"
    D48[$order.b_hooks]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json")"
    D48[$order.b_conflicts]="$(conflicts_in "$p")"
    D48[$order.b_shared_kept]=true
    [[ "$sum" == "$(cd "$p" && for f in $SH_FILE; do sha256sum "$f"; done)" ]] || D48[$order.b_shared_kept]=false
    D48[$order.b_mode]="missing"
    if [[ -n "$SH_FILE" ]]; then
      local mode_file; mode_file="$(dirname "$SH_FILE")/$B_MODE"
      if [[ ! -f "$p/$mode_file" ]]; then D48[$order.b_mode]="missing"
      elif git -C "$p" cat-file -e "refs/syntek-author/template:$mode_file" 2>/dev/null; then D48[$order.b_mode]="in syntek-author's record"
      elif grep -qxF "    $mode_file" "$w/$order-a.log" "$w/$order-b.log"; then D48[$order.b_mode]="listed in a report"
      else D48[$order.b_mode]="ok"; fi
    else
      D48[$order.b_mode]="ok"
    fi
  done
}

a_copy_at() { # $1 = syntek-author repo, $2 = ref, $3 = dest
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$2" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=theology" \
    "$1" "$3" </dev/null
}

d48_checks() {
  local o L
  for o in author-first d48-first; do
    L="[D48-only sibling, $o]"
    if [[ "${D48[$o.a_copy]:-0}" -ne 0 || "${D48[$o.b_copy]:-0}" -ne 0 ]]; then
      finding "check 14 — $L a copy failed (syntek-author exit ${D48[$o.a_copy]:-0}, the sibling exit ${D48[$o.b_copy]:-0})"; continue
    fi
    if [[ "${D48[$o.a_update]:-0}" -ne 0 || "${D48[$o.a_report]:-0}" -ne 1 ]]; then
      finding "check 14 — $L syntek-author's update failed (exit ${D48[$o.a_update]:-0}) or printed ${D48[$o.a_report]:-0} report(s), not one"
    fi
    ${D48[$o.a_refreshed]} || finding "check 14 — $L syntek-author's update did not refresh the shared $SH_FILE"
    [[ "${D48[$o.a_refs]}" == "refs/syntek-author/template refs/syntek-author/yours" ]] \
      || finding "check 14 — $L after syntek-author's update the refs are '${D48[$o.a_refs]}', not syntek-author's two alone"
    [[ "${D48[$o.a_hooks]}" == ok ]] || finding "check 14 — $L after syntek-author's update: ${D48[$o.a_hooks]}"
    if [[ "$o" == d48-first ]]; then
      [[ "${D48[$o.copied]}" == ok ]] || finding "check 15 — $L syntek-author's copy over the sibling's settings.json: ${D48[$o.copied]}"
    fi
    [[ "${D48[$o.b_update]:-0}" -eq 0 ]] || finding "check 16 — $L the sibling's update to its release with the shared set failed (exit ${D48[$o.b_update]})"
    [[ "${D48[$o.b_refs]}" == "refs/dummy-media/template refs/dummy-media/yours" ]] \
      || finding "check 16 — $L after the sibling adopted the shared set its refs are '${D48[$o.b_refs]}'"
    [[ "${D48[$o.b_hooks]}" == ok ]] || finding "check 16 — $L after the sibling adopted the shared set: ${D48[$o.b_hooks]}"
    [[ -z "${D48[$o.b_conflicts]}" ]] || finding "check 16 — $L the sibling's update left a conflict: ${D48[$o.b_conflicts]}"
    ${D48[$o.b_shared_kept]} || finding "check 16 — $L the sibling's update changed the shared $SH_FILE"
    [[ "${D48[$o.b_mode]}" == ok ]] || finding "check 17 — $L the sibling's $B_MODE beside the shared skill is ${D48[$o.b_mode]}"
  done
  return 0
}

MF_SRC=""
media_first_checks() {
  local kind path sum source now
  if [[ "$MF_B_COPY" -ne 0 ]]; then finding "check 9 — the dummy second template did not render on its own (exit $MF_B_COPY)"; return 0; fi
  if [[ "$MF_A_COPY" -ne 0 ]]; then
    finding "check 9 — syntek-author's copy over a project with syntek-media 0.4.2's .agents/ failed (exit $MF_A_COPY) — it must succeed with no --exclude"
    return 0
  fi
  if [[ -L "$MF/.agents" || ! -d "$MF/.agents" ]]; then
    finding "check 9 — after both copies .agents is not a real folder"
  elif [[ ! -L "$MF/.agents/skills" || "$(readlink "$MF/.agents/skills")" != "$SA_AGENTS_LINK_TARGET" ]]; then
    finding "check 9 — after both copies .agents/skills is not the link to $SA_AGENTS_LINK_TARGET"
  elif [[ "$(cat "$MF/.agents/mcp_config.json" 2>/dev/null; printf x)" != "${SA_AGENTS_MCP}x" ]]; then
    finding "check 9 — after both copies .agents/mcp_config.json is not the 23 bytes both templates ship"
  fi
  [[ -f "$MF/$B_BRIDGE" && -f "$MF/.claude/syntek-author-agents.md" ]] \
    || finding "check 9 — after both copies the project does not hold both bridges ($B_BRIDGE and .claude/syntek-author-agents.md)"

  if [[ -z "$MANIFEST" ]]; then
    NOTES+=("check 10 skipped — the repository has no family-shared.json")
    return 0
  fi
  while IFS=$'\t' read -r kind path sum source; do
    if [[ "$kind" == L ]]; then
      [[ -L "$MF/$path" && "$(readlink "$MF/$path")" == "$sum" ]] \
        || finding "check 10 — $path in the media-first project is not the link to $sum family-shared.json lists"
      continue
    fi
    local -a names=("$path")
    [[ "$path" == *dummy-media* ]] && names+=("${path/dummy-media/syntek-author}")
    for now in "${names[@]}"; do
      [[ -f "$MF/$now" ]] || continue
      [[ "$(sha256sum < "$MF/$now" | cut -d' ' -f1)" == "$sum" ]] \
        || finding "check 10 — $now in the media-first project does not carry the sha256 family-shared.json lists for $source"
    done
  done < <(manifest_entries "$MF_SRC" "$MANIFEST" dummy-media)
  return 0
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/fixture" >/dev/null
  # The real update script, block and task, and a shared skill and hook (checks 11–13).
  sa_add_update "$tmp/fixture" syntek-author ".claude/skills/wait-what/SKILL.md .claude/hooks/context-threshold-handoff.sh" \
    || die "could not give the fixture the update script"
  # The fixture's settings.json wires the hook its family-refresh.json offers, as the real seed does.
  python3 - "$tmp/fixture/template/.claude/settings.json" "$tmp/fixture/migrations/family-refresh.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
d["hooks"] = json.load(open(sys.argv[2], encoding="utf-8"))["settings"]["hooks"]
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
  sa_git "$tmp/fixture" add -A && sa_git "$tmp/fixture" commit -q -m 'fixture: the update script'
  # A family-shared manifest for the fixture (check 10): its token-free entrypoint, its link
  # and its MCP file, as family-shared.sh --write records them.
  python3 - "$tmp/fixture" <<'PY'
import hashlib, json, sys
root = sys.argv[1]
def f(p):
    b = open(f"{root}/template/{p}", "rb").read()
    return {"path": p, "source": f"template/{p}", "kind": "file", "bytes": len(b), "sha256": hashlib.sha256(b).hexdigest()}
files = [f(".agents/mcp_config.json"),
         {"path": ".agents/skills", "source": "template/.agents/skills", "kind": "symlink", "target": "../.claude/skills"},
         f("AGENTS.md"), f(".claude/skills/wait-what/SKILL.md"), f(".claude/hooks/context-threshold-handoff.sh")]
json.dump({"format": 1, "owner": "syntek-author", "release": "unreleased", "files": files, "blocks": []},
          open(f"{root}/family-shared.json", "w"), indent=2)
PY
  run_flow "$tmp/fixture" "$tmp"
  st_baseline "the fixture template sharing a project with a dummy second template, both orders"

  B_COPY=1;   probe "check 1 fires when the second template collides" "check 1"; B_COPY=0
  mv "$PROJ/$B_ANSWERS" "$tmp/h"; probe "check 2 fires when an answers file is missing" "check 2"; mv "$tmp/h" "$PROJ/$B_ANSWERS"
  A_UPDATE=1; probe "check 3 fires when syntek-author's update fails" "check 3"; A_UPDATE=0
  cp "$PROJ/$B_RULE" "$tmp/h"; grep -vF "$B_MARK" "$tmp/h" > "$PROJ/$B_RULE"
  probe "check 4 fires when the second template's change is lost" "check 4"; cp "$tmp/h" "$PROJ/$B_RULE"
  mv "$PROJ/$B_RULE" "$tmp/h"; probe "check 5 fires when one template's file vanishes" "check 5"; mv "$tmp/h" "$PROJ/$B_RULE"
  A_OWNED+=("README.md"); probe "check 6 fires on a root file syntek-author owns" "check 6 — README.md"; unset 'A_OWNED[-1]'
  printf 'x\n' > "$PROJ/CONTEXT.md.rej"; probe "check 7 fires on a rejected hunk" "check 7"; rm -f "$PROJ/CONTEXT.md.rej"
  printf '# yours\n' > "$PROJ/AGENTS.md"; A_KEPT[AGENTS.md]="not-this"
  probe "check 8 fires when a copy-only file was overwritten" "check 8 — the copy-only AGENTS.md"; unset 'A_KEPT[AGENTS.md]'; rm -f "$PROJ/AGENTS.md"
  MF_A_COPY=1; probe "check 9 fires when the copy over media's .agents/ fails" "check 9 — syntek-author's copy over a project"; MF_A_COPY=0
  mv "$MF/$B_BRIDGE" "$tmp/h"
  probe "check 9 fires when a bridge is missing after both copies" "check 9 — after both copies the project does not hold both bridges"
  mv "$tmp/h" "$MF/$B_BRIDGE"
  cp "$MF/AGENTS.md" "$tmp/h"; printf 'x\n' >> "$MF/AGENTS.md"
  probe "check 10 fires when a vendored shared file differs from the manifest" "check 10 — AGENTS.md in the media-first project"
  cp "$tmp/h" "$MF/AGENTS.md"
  local held_ref; held_ref="$(git -C "$PROJ" rev-parse refs/dummy-media/yours)"
  git -C "$PROJ" update-ref -d refs/dummy-media/yours
  probe "check 11 fires when a template's record is missing" "check 11 — after both copies and both updates the project has no refs/dummy-media/yours"
  git -C "$PROJ" update-ref refs/dummy-media/yours "$held_ref"
  cp "$PROJ/$SH_FILE" "$tmp/h"; printf '%s\n' "$SH_MARK_B" > "$PROJ/$SH_FILE"
  probe "check 12 fires when the dummy's update replaced syntek-author's revision" "check 12 — the shared $SH_FILE does not hold"
  cp "$tmp/h" "$PROJ/$SH_FILE"
  cp "$B_LOG" "$tmp/h"; grep -vxF "    $SH_FILE" "$tmp/h" > "$B_LOG"
  probe "check 12 fires when the sibling attribution is missing" "check 12 — the dummy's report lists"; cp "$tmp/h" "$B_LOG"
  cp "$A_LOG" "$tmp/h"; printf '▸ syntek-author update report, 1 → 2\n  NOT UPDATED because you had changed them (1):\n    media/CONTEXT.md\n' >> "$A_LOG"
  probe "check 13 fires when a report lists the other template's file" "check 13 — syntek-author's report lists media/CONTEXT.md"; cp "$tmp/h" "$A_LOG"
  local held
  held="${D48[author-first.a_report]}"; D48[author-first.a_report]=0
  probe "check 14 fires when the update beside a D48-only sibling prints no report" "check 14 — [D48-only sibling, author-first] syntek-author's update failed"
  D48[author-first.a_report]="$held"
  D48[d48-first.a_refreshed]=false
  probe "check 14 fires when the shared skill is not refreshed beside a D48-only sibling" "check 14 — [D48-only sibling, d48-first] syntek-author's update did not refresh"
  D48[d48-first.a_refreshed]=true
  held="${D48[d48-first.copied]}"; D48[d48-first.copied]="UserPromptSubmit  context-threshold-handoff.sh wired 0 time(s)"
  probe "check 15 fires when the copy over the sibling's settings.json does not wire the hooks" "check 15"; D48[d48-first.copied]="$held"
  held="${D48[d48-first.b_hooks]}"; D48[d48-first.b_hooks]="UserPromptSubmit  context-threshold-handoff.sh wired 2 time(s)"
  probe "check 16 fires when the sibling's adoption duplicates a hook" "check 16 — [D48-only sibling, d48-first] after the sibling adopted"; D48[d48-first.b_hooks]="$held"
  # The judge itself: a top-level value written twice, missing, or another value, is named.
  printf '{"settings": {"autoCompactEnabled": false}}\n' > "$tmp/rf.json"
  local judged=""
  printf '{\n  "autoCompactEnabled": false,\n  "autoCompactEnabled": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == "autoCompactEnabled written 2 time(s)"* ]] || judged+=" twice"
  printf '{\n  "model": "opus"\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == "autoCompactEnabled written 0 time(s)"* ]] || judged+=" missing"
  printf '{\n  "autoCompactEnabled": true\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == *"value true"* ]] || judged+=" true"
  printf '{\n  "autoCompactEnabled": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == ok ]] || judged+=" once"
  if [[ -n "$judged" ]]; then
    printf '\033[31m  ✗ hooks_once misjudges a top-level value:%s\033[0m\n' "$judged" >&2; exit 2
  fi
  held="${D48[author-first.b_refs]}"; D48[author-first.b_refs]=""
  probe "check 16 fires when the sibling keeps no record" "check 16 — [D48-only sibling, author-first] after the sibling adopted the shared set its refs"; D48[author-first.b_refs]="$held"
  D48[author-first.b_conflicts]="README.md.rej"
  probe "check 16 fires when the sibling's update leaves a conflict" "check 16 — [D48-only sibling, author-first] the sibling's update left"; D48[author-first.b_conflicts]=""
  D48[d48-first.b_mode]="in syntek-author's record"
  probe "check 17 fires when the sibling's MEDIA-* mode file is counted as syntek-author's" "check 17"; D48[d48-first.b_mode]=ok
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
for n in "${NOTES[@]}"; do log "  - $n"; done
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  log "  ✓ both templates applied, both updated, ${#A_OWNED[@]} syntek-author-owned file(s) and ${#B_OWNED[@]} second-template-owned file(s) disjoint"
  log "  ✓ media first: syntek-author's copy over media 0.4.2's .agents/ succeeded with no --exclude; the family-shared files carry the manifest's bytes"
  log "  ✓ each template keeps its own render record in both orders; a shared skill refreshed by syntek-author keeps its bytes through the dummy's update, which attributes it; each report lists only its own files"
  $D48_RAN && log "  ✓ a sibling at the D48 set only, in both orders: syntek-author's report and refresh work beside it, its copy wires the hooks once into the sibling's settings.json, and the sibling's later adoption of the shared set converges (its own refs, no conflict, no hook twice, its MEDIA-* mode file its own)"
  rm -rf "$work"
  bold "✓ A second template shares the project cleanly."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s) (work kept in $work; output in $work/flow.log):"
print_findings
log ""
log "  DESIGN.md Section 9: own answers file, own rules folder, shared root files seeded in both,"
log "  agent entrypoints and client settings copy-only in both (D47), family-shared bytes (D48)."
exit 1
