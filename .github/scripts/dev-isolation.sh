#!/usr/bin/env bash
#
# dev-isolation.sh — Verify the template's own skills cannot fire while the template is built.
#
#                    template/.claude/ is a live Claude Code configuration that happens to sit
#                    inside this repository. Claude Code loads a nested .claude/skills/ folder the
#                    first time it reads a file beneath it, and nested CLAUDE.md files on demand
#                    (cross-check Section 6.2, verified against the 2.1.288 documentation). So a
#                    session building the template would, the moment it opened a skill to edit
#                    it, be offered `draft-section` and `promote-section` as tools — and a
#                    generated project's rules ("never overwrite a draft", the authoring loop)
#                    would start governing work on the template itself. `_subdirectory` keeps
#                    template/ out of renders; it does nothing for development sessions.
#
#                    Two layers in the ROOT .claude/settings.json close that (DESIGN.md Section 7):
#                      permissions.deny lists Skill(<name>) for every template skill — an
#                      unqualified deny also blocks the nested template:<name> form;
#                      claudeMdExcludes keeps the generated project's manuals out.
#
#                    Four checks:
#                      1. The root .claude/settings.json exists and is valid JSON.
#                      2. Every skill folder under template/.claude/skills/ is denied as
#                         Skill(<name>).
#                      3. Every skill DESIGN.md Section 5 names is denied too, so a skill is
#                         isolated before its folder is written.
#                      4. claudeMdExcludes carries "**/template/**/CLAUDE.md" and
#                         "**/template/.claude/**".
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: that Claude Code honours the settings. Proving that
#                    needs a live session (`claude -p` asked to list its skills inside
#                    template/), which needs credentials CI does not hold; run that probe by hand
#                    after any Claude Code upgrade that touches skill discovery.
#
# SELF-TEST. --self-test writes a fixture repository at runtime, proves it clean, then applies
#            one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, python3. No network.
#
# Usage: dev-isolation.sh [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = every template skill is isolated from development sessions
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, no python3)

set -euo pipefail
SCRIPT_NAME="dev-isolation.sh"
# shellcheck source=_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false

usage() {
  cat <<'EOF'
dev-isolation.sh — Verify the template's own skills cannot fire while the template is built

Usage: dev-isolation.sh [--root DIR] [--quiet] [--self-test] [--help]

  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture written at runtime
  --help       Show this message

Exit codes: 0 = isolated  1 = finding(s), or the self-test no longer separates
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

SETTINGS="$SA_ROOT/.claude/settings.json"
SKILLS="$SA_ROOT/template/.claude/skills"
EXCLUDES=("**/template/**/CLAUDE.md" "**/template/.claude/**")
ON_DISK=0

# Prints "D<TAB>entry" per deny entry and "X<TAB>pattern" per claudeMdExcludes entry, or
# "E<TAB>reason" when the file is not valid JSON.
read_settings() {
  python3 - "$SETTINGS" <<'PY'
import json, sys
try:
    data = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception as exc:
    print(f"E\t{exc.__class__.__name__}: {exc}"); sys.exit(0)
for d in ((data.get("permissions") or {}).get("deny") or []):
    print(f"D\t{d}")
for x in (data.get("claudeMdExcludes") or []):
    print(f"X\t{x}")
PY
}

run_checks() {
  FINDINGS=()
  ON_DISK=0
  local kind val s x
  local -A denied=() excluded=() on_disk=()
  if [[ ! -f "$SETTINGS" ]]; then
    finding "check 1 — there is no .claude/settings.json at the repository root — nothing isolates the template's skills"
    return 0
  fi
  while IFS=$'\t' read -r kind val; do
    case "$kind" in
      E) finding "check 1 — .claude/settings.json is not valid JSON ($val)"; return 0 ;;
      D) denied["$val"]=1 ;;
      X) excluded["$val"]=1 ;;
    esac
  done < <(read_settings)

  if [[ -d "$SKILLS" ]]; then
    while IFS= read -r s; do
      on_disk["$s"]=1; ON_DISK=$((ON_DISK + 1))
      [[ -n "${denied["Skill($s)"]:-}" ]] || finding "check 2 — template skill $s is not denied as Skill($s) — it can fire in a development session"
    done < <(find "$SKILLS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | LC_ALL=C sort)
  fi
  while read -r s _; do
    [[ -z "$s" || -n "${on_disk[$s]:-}" ]] && continue
    [[ -n "${denied["Skill($s)"]:-}" ]] || finding "check 3 — DESIGN.md names the skill $s, and it is not denied — it would fire the day its folder lands"
  done <<< "$SA_SKILLS"
  for x in "${EXCLUDES[@]}"; do
    [[ -n "${excluded[$x]:-}" ]] || finding "check 4 — claudeMdExcludes does not carry \"$x\""
  done
}

self_test() {
  local tmp real_root="$SA_ROOT" s
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  SA_ROOT="$tmp"; SETTINGS="$tmp/.claude/settings.json"; SKILLS="$tmp/template/.claude/skills"
  mkdir -p "$tmp/.claude" "$SKILLS/draft-section" "$SKILLS/grill-me"
  write_settings() { # $1 = names to leave out of deny, $2 = excludes JSON
    local first=true
    {
      printf '{\n  "claudeMdExcludes": %s,\n  "permissions": {"deny": [' "$2"
      while read -r s _; do
        [[ -z "$s" || " $1 " == *" $s "* ]] && continue
        $first || printf ', '; first=false
        printf '"Skill(%s)"' "$s"
      done <<< "$SA_SKILLS"
      printf ']}\n}\n'
    } > "$SETTINGS"
  }
  local ok='["**/template/**/CLAUDE.md", "**/template/.claude/**"]'
  write_settings "" "$ok"
  st_baseline "a root settings file that denies every skill"

  printf '{ "permissions": ' > "$SETTINGS";                         probe "check 1 fires on settings that are not JSON" "check 1"
  write_settings "grill-me" "$ok";                                    probe "check 2 fires when a skill on disk is not denied" "check 2 — template skill grill-me"
  write_settings "pronounce" "$ok";                                   probe "check 3 fires when a catalogued skill is not denied" "check 3 — DESIGN.md names the skill pronounce"
  write_settings "" '["**/template/**/CLAUDE.md"]';                   probe "check 4 fires when an exclusion is lost" "check 4"

  SA_ROOT="$real_root"; SETTINGS="$SA_ROOT/.claude/settings.json"; SKILLS="$SA_ROOT/template/.claude/skills"
  st_finish "an isolated template from a leaking one"
}

command -v python3 >/dev/null 2>&1 || die "python3 is not installed"
if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ $SCRIPT_NAME"
run_checks
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ $ON_DISK template skill(s) on disk and every catalogued skill denied; both CLAUDE.md exclusions present."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
log ""
log "  Add Skill(<name>) to permissions.deny in the ROOT .claude/settings.json (never the one"
log "  under template/, which ships)."
exit 1
