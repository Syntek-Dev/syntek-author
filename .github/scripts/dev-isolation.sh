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
#                    Codex, Gemini CLI, Antigravity and OpenCode (DESIGN.md D47) read none of
#                    those settings. They find project skills under .agents/skills, and Codex its
#                    project config, only between the repository root and the folder a session
#                    starts in, so what isolates every one of them is a session STARTED AT THE
#                    ROOT, where no .agents exposes a skill. A session started under template/
#                    loads every product skill through template/.agents, and nothing here can
#                    stop that: Codex reads [[skills.config]] only from the USER config and -c
#                    flags, never from a project file, and the parse failure of the unrendered
#                    template/.codex/config.toml stops only a trusted checkout. So the root's
#                    .codex/config.toml is a documented snippet for the maintainer's user config,
#                    not a guard, and the checks say so:
#                      5. The root .codex/config.toml (the user-config snippet) exists and is
#                         valid TOML.
#                      6. The snippet disables every skill folder under template/.claude/skills/
#                         as [[skills.config]] path = '../template/.claude/skills/<name>/SKILL.md',
#                         enabled = false — complete, so a maintainer who copies it misses none.
#                         It proves nothing about a session; check 9 does the work.
#                      7. It sets no project_doc_fallback_filenames: a CLAUDE.md fallback would
#                         load the product's manuals as development instructions.
#                      8. Root AGENTS.md and GEMINI.md exist; the root has no .agents at all (a
#                         link there also breaks Codex's Linux sandbox, and a folder would be a
#                         skill path); and the root .claude/ holds no skills/ folder.
#                      9. The rule that does the work is written down: "Start every session at
#                         the repository root" in .claude/CLAUDE.md and in root AGENTS.md.
#                     10. Optional, when codex is installed: `codex debug prompt-input` at the
#                         root, with a scratch CODEX_HOME and HOME and no network (unshare -rn),
#                         lists no skill root inside this repository. Skipped, by name, when
#                         codex or a network namespace is unavailable; never `codex doctor`,
#                         which contacts the network.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: that Claude Code, or any other client, honours the
#                    settings. Proving that
#                    needs a live session (`claude -p` asked to list its skills inside
#                    template/), which needs credentials CI does not hold; run that probe by hand
#                    after any Claude Code upgrade that touches skill discovery. The same holds
#                    for Gemini CLI's `/skills list` and OpenCode's skills; Codex's list is
#                    check 10, where codex is installed. Nor can it stop a session that starts
#                    under template/: that is the documented rule of check 9.
#
# SELF-TEST. --self-test writes a fixture repository at runtime, proves it clean, then applies
#            one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, python3 3.11+ (tomllib). No network. codex and unshare optional
#               (check 10).
#
# Usage: dev-isolation.sh [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = every template skill is isolated from development sessions
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, no python3)

set -euo pipefail
SCRIPT_NAME="dev-isolation.sh"
# shellcheck source=SCRIPTDIR/_common.sh
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
CODEX="$SA_ROOT/.codex/config.toml"
EXCLUDES=("**/template/**/CLAUDE.md" "**/template/.claude/**")
ROOT_RULE="Start every session at the repository root"
ROOT_RULE_FILES=".claude/CLAUDE.md AGENTS.md"
CODEX_BIN="${CODEX_BIN:-codex}"
ON_DISK=0
NOTES=()

# Check 10's probe: the skill roots `codex debug prompt-input` lists for a session started at
# $1, one per line, in a scratch CODEX_HOME and HOME with no network. Returns 3 when the probe
# cannot run (no codex, no network namespace), with the reason on stdout.
codex_skill_roots() { # $1 = directory to start in
  local scratch out status=0
  command -v "$CODEX_BIN" >/dev/null 2>&1 || { echo "codex is not installed"; return 3; }
  unshare -rn true 2>/dev/null || { echo "no unprivileged network namespace (unshare -rn) to keep codex off the network"; return 3; }
  scratch="$(sa_mktemp)"; mkdir -p "$scratch/home" "$scratch/tmp"
  out="$(cd "$1" && CODEX_HOME="$scratch/home" HOME="$scratch/home" TMPDIR="$scratch/tmp" \
         timeout 120 unshare -rn "$CODEX_BIN" debug prompt-input 2>/dev/null)" || status=$?
  rm -rf "$scratch"
  [[ "$status" -eq 0 ]] || { echo "codex debug prompt-input exited $status"; return 3; }
  printf '%s' "$out" | python3 -c '
import json, re, sys
try:
    text = json.dumps(json.load(sys.stdin))
except Exception:
    print("its output is not JSON"); sys.exit(3)
roots = re.findall(r"`r[0-9]+` = `([^`]+)`", text)
if not roots:
    print("it listed no skill root to read"); sys.exit(3)
print("\n".join(roots))'
}

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

# Prints "S<TAB>path" per disabled [[skills.config]] path, "F<TAB>" when a fallback is set, or
# "E<TAB>reason" when the file is not valid TOML.
read_codex() {
  python3 - "$CODEX" <<'PY'
import sys, tomllib
try:
    data = tomllib.load(open(sys.argv[1], "rb"))
except Exception as exc:
    print(f"E\t{exc.__class__.__name__}: {exc}"); sys.exit(0)
for entry in ((data.get("skills") or {}).get("config") or []):
    if isinstance(entry, dict) and entry.get("enabled") is False and entry.get("path"):
        print(f"S\t{entry['path']}")
if "project_doc_fallback_filenames" in data:
    print("F\t")
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

  local -A disabled=()
  local codex_ok=true
  if [[ ! -f "$CODEX" ]]; then
    finding "check 5 — there is no .codex/config.toml at the repository root — Codex can load every product skill"
  else
    while IFS=$'\t' read -r kind val; do
      case "$kind" in
        E) finding "check 5 — .codex/config.toml is not valid TOML ($val)"; codex_ok=false ;;
        S) disabled["$val"]=1 ;;
        F) finding "check 7 — .codex/config.toml sets project_doc_fallback_filenames — Codex would read the product's CLAUDE.md manuals as instructions" ;;
      esac
    done < <(read_codex)
    $codex_ok && for s in "${!on_disk[@]}"; do
      [[ -n "${disabled["../template/.claude/skills/$s/SKILL.md"]:-}" ]] \
        || finding "check 6 — template skill $s is not disabled in .codex/config.toml — Codex can load it in a development session"
    done
  fi
  [[ -f "$SA_ROOT/AGENTS.md" ]] || finding "check 8 — there is no root AGENTS.md — Codex and OpenCode get no development instructions"
  [[ -f "$SA_ROOT/GEMINI.md" ]] || finding "check 8 — there is no root GEMINI.md — Gemini CLI and Antigravity get no development instructions"
  if [[ -L "$SA_ROOT/.agents" ]]; then
    finding "check 8 — the root .agents is a link (to $(readlink "$SA_ROOT/.agents")) — it breaks Codex's Linux sandbox and does no isolation work; remove it"
  elif [[ -e "$SA_ROOT/.agents" ]]; then
    finding "check 8 — the root has a .agents folder — a skill path at the root, where every development session starts; remove it"
  fi
  [[ ! -e "$SA_ROOT/.claude/skills" ]] || finding "check 8 — the root .claude/ holds a skills/ folder — Claude Code would load it in every development session"

  local f
  for f in $ROOT_RULE_FILES; do
    grep -qiF "$ROOT_RULE" "$SA_ROOT/$f" 2>/dev/null \
      || finding "check 9 — $f does not say \"$ROOT_RULE\" — the one rule that keeps product skills out of Codex, Gemini CLI, Antigravity and OpenCode sessions is not written down"
  done

  local roots status=0 r
  roots="$(codex_skill_roots "$SA_ROOT")" || status=$?
  if [[ "$status" -eq 3 ]]; then
    NOTES+=("check 10 skipped — $roots")
  else
    while IFS= read -r r; do
      [[ -z "$r" ]] && continue
      [[ "$r" == "$SA_ROOT"/* || "$r" == "$SA_ROOT" ]] \
        && finding "check 10 — a Codex session started at the root loads skills from ${r#"$SA_ROOT"/} — product skills reach development sessions"
    done <<< "$roots"
  fi
  return 0
}

self_test() {
  local tmp real_root="$SA_ROOT" s
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  SA_ROOT="$tmp"; SETTINGS="$tmp/.claude/settings.json"; SKILLS="$tmp/template/.claude/skills"
  CODEX="$tmp/.codex/config.toml"
  mkdir -p "$tmp/.claude" "$tmp/.codex" "$SKILLS/draft-section" "$SKILLS/grill-me" "$tmp/bin"
  printf '# dev\n\nStart every session at the repository root, never inside template/.\n' > "$tmp/AGENTS.md"
  printf '# dev\n' > "$tmp/GEMINI.md"
  printf '# CLAUDE.md\n\n**Start every session at the repository root.**\n' > "$tmp/.claude/CLAUDE.md"
  # A stand-in for codex (check 10): it lists the system skill root, and a product skill root
  # when STUB_LEAK is set. The real one is probed on the real root, where it is installed.
  cat > "$tmp/bin/codex" <<'STUB'
#!/usr/bin/env bash
roots='- `r0` = `'"$CODEX_HOME"'/skills/.system`'
[ -n "${STUB_LEAK:-}" ] && roots="$roots"'\n- `r1` = `'"$PWD"'/template/.claude/skills`'
printf '[{"type": "message", "content": [{"text": "### Skill roots\\n%s"}]}]\n' "$roots"
STUB
  chmod +x "$tmp/bin/codex"
  local real_codex="$CODEX_BIN"; CODEX_BIN="$tmp/bin/codex"; export STUB_LEAK=""
  write_codex() { # $1 = skill to leave enabled, $2 = extra TOML
    { printf '%s\n' "$2"
      for s in draft-section grill-me; do
        [[ "$s" == "$1" ]] && continue
        printf "[[skills.config]]\npath = '../template/.claude/skills/%s/SKILL.md'\nenabled = false\n" "$s"
      done; } > "$CODEX"
  }
  write_codex "" ""
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
  write_settings "" "$ok"
  printf '[[skills.config\n' > "$CODEX";                               probe "check 5 fires on a Codex config that is not TOML" "check 5"
  write_codex "grill-me" "";                                          probe "check 6 fires when a skill is not disabled for Codex" "check 6 — template skill grill-me"
  write_codex "" "project_doc_fallback_filenames = ['CLAUDE.md']";   probe "check 7 fires on a CLAUDE.md fallback" "check 7"
  write_codex "" ""
  rm "$tmp/GEMINI.md";                                                probe "check 8 fires without a development GEMINI.md" "check 8 — there is no root GEMINI.md"
  printf '# dev\n' > "$tmp/GEMINI.md"
  ln -s .claude "$tmp/.agents";                                      probe "check 8 fires on a root .agents link" "check 8 — the root .agents is a link"
  rm "$tmp/.agents"; mkdir -p "$tmp/.agents";                         probe "check 8 fires on a root .agents folder" "check 8 — the root has a .agents folder"
  rmdir "$tmp/.agents"
  printf '# dev\n' > "$tmp/AGENTS.md";                                 probe "check 9 fires when AGENTS.md drops the start-at-the-root rule" "check 9 — AGENTS.md"
  printf '# dev\n\nStart every session at the repository root, never inside template/.\n' > "$tmp/AGENTS.md"
  printf '# dev\n' > "$tmp/.claude/CLAUDE.md";                         probe "check 9 fires when the manual drops the start-at-the-root rule" "check 9 — .claude/CLAUDE.md"
  printf '# CLAUDE.md\n\n**Start every session at the repository root.**\n' > "$tmp/.claude/CLAUDE.md"
  if unshare -rn true 2>/dev/null; then
    STUB_LEAK=1;                                                      probe "check 10 fires when Codex lists a product skill root" "check 10 — a Codex session started at the root loads skills from template/.claude/skills"
    STUB_LEAK=""
  else
    log "  - check 10's probe skipped: no unprivileged network namespace (unshare -rn) here"
  fi
  CODEX_BIN="$real_codex"

  SA_ROOT="$real_root"; SETTINGS="$SA_ROOT/.claude/settings.json"; SKILLS="$SA_ROOT/template/.claude/skills"
  CODEX="$SA_ROOT/.codex/config.toml"
  st_finish "an isolated template from a leaking one"
}

command -v python3 >/dev/null 2>&1 || die "python3 is not installed"
if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ $SCRIPT_NAME"
run_checks
for n in "${NOTES[@]}"; do log "  - $n"; done
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ $ON_DISK template skill(s) on disk, every catalogued skill denied, both CLAUDE.md exclusions present; the Codex user-config snippet complete; development entrypoints in place, no root .agents, and the start-at-the-root rule written down."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
log ""
log "  Add Skill(<name>) to permissions.deny in the ROOT .claude/settings.json (never the one"
log "  under template/, which ships), and a [[skills.config]] entry (path .../<name>/SKILL.md,"
log "  enabled = false) to the root .codex/config.toml, the snippet for the user config. Start"
log "  every session at the repository root; never add a root .agents."
exit 1
