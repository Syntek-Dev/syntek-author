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
#                    Development MCP (DESIGN.md D54 and Section 7). The root .mcp.json runs
#                    code-review-graph for this repository in Claude Code. Its install, init and
#                    uninstall never run here: they rewrite the agent files and settings with an
#                    unpinned entry that exposes embed_graph_tool, and add skills, a Git hook and
#                    user configuration. With check 8 (no root .claude/skills/), these prove it:
#                     11. The root .mcp.json, where present, is a regular file whose mcpServers
#                         is exactly code-review-graph (no Scrapling in development): command
#                         uvx; args the pin, serve, --tools and the held 29-name list, never
#                         embed_graph_tool; env exactly the six blank keys, each ""; no other key.
#                     12. The root .claude/settings.json denies embed_graph_tool, asks before
#                         apply_refactor_tool and generate_wiki_tool, has no allow rule reaching
#                         either server, and sets neither enableAllProjectMcpServers nor
#                         enabledMcpjsonServers (either would start a server without asking).
#                     13. The root .gitignore holds the anchored /.code-review-graph/ as a line,
#                         and git, reading no global excludes file, ignores the path
#                         .code-review-graph/graph.db by it.
#                     14. No install artefact: no file Git tracks, or would add, holds one of
#                         _common.sh's install markers (each built there from two halves, so
#                         neither that file nor this script holds one whole; git-ignored files,
#                         such as the maintainer's handoffs, are never read); no hook names
#                         code-review-graph, in the root settings or in the Git hooks folder;
#                         and the root .codex/config.toml declares no mcp_servers (copied into
#                         the user config, a server there would start in every repository).
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
#                    under template/: that is the documented rule of check 9. Nor can it see what
#                    an install wrote outside this repository (the user configuration under ~).
#
# SELF-TEST. --self-test writes a fixture repository at runtime (a Git work tree holding copies
#            of _common.sh and this script), proves it clean, then applies one mutation per
#            check and asserts exactly one finding each.
#
# Requirements: bash 4+, python3 at _common.sh's SA_PYTHON_MIN or later (tomllib; the pin
#               refuses an older one), git (checks 13 and 14). No network. codex
#               and unshare optional (check 10).
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

set_paths() { # every path below SA_ROOT, again whenever SA_ROOT moves (the self-test)
  SETTINGS="$SA_ROOT/.claude/settings.json"
  SKILLS="$SA_ROOT/template/.claude/skills"
  CODEX="$SA_ROOT/.codex/config.toml"
  MCP_JSON="$SA_ROOT/.mcp.json"
  GITIGNORE="$SA_ROOT/.gitignore"
}
set_paths
EXCLUDES=("**/template/**/CLAUDE.md" "**/template/.claude/**")
ROOT_RULE="Start every session at the repository root"
ROOT_RULE_FILES=".claude/CLAUDE.md AGENTS.md"
CODEX_BIN="${CODEX_BIN:-codex}"
ON_DISK=0
NOTES=()

# The development MCP values (checks 11 and 12), read from _common.sh, never copied: the
# code-review-graph pin (read -a never globs, and another pin holds [ai]) and its two asks.
read -r -a _pins <<< "$SA_MCP_PINS"
CRG_PIN=""
for _p in "${_pins[@]}"; do [[ "$_p" == code-review-graph==* ]] && CRG_PIN="$_p"; done
read -r -a _asks <<< "$SA_MCP_ASKS"
CRG_ASKS=()
for _p in "${_asks[@]}"; do [[ "$_p" == mcp__code-review-graph__* ]] && CRG_ASKS+=("$_p"); done
unset _pins _asks _p
[[ -n "$CRG_PIN" && ${#CRG_ASKS[@]} -eq 2 ]] \
  || die "_common.sh holds no code-review-graph pin in SA_MCP_PINS, or not its two asks in SA_MCP_ASKS"

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

# Prints "D<TAB>entry" per deny entry, "K<TAB>entry" per ask entry and "X<TAB>pattern" per
# claudeMdExcludes entry; "A<TAB>rule" per allow rule that reaches either MCP server (by name,
# or a wildcard that matches one of its tools), "M<TAB>key" per key that starts project servers
# without asking, and "H<TAB>event" per hook event whose entries name code-review-graph; or
# "E<TAB>reason" when the file is not valid JSON.
read_settings() {
  python3 - "$SETTINGS" "$SA_MCP_SERVERS" <<'PY'
import fnmatch, json, sys
try:
    data = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception as exc:
    print(f"E\t{exc.__class__.__name__}: {exc}"); sys.exit(0)
if not isinstance(data, dict):
    print("E\tthe top level is not a JSON object"); sys.exit(0)
perms = data.get("permissions") or {}
for d in (perms.get("deny") or []):
    print(f"D\t{d}")
for k in (perms.get("ask") or []):
    print(f"K\t{k}")
for x in (data.get("claudeMdExcludes") or []):
    print(f"X\t{x}")
servers = sys.argv[2].split()
def reaches(rule, server):
    name = f"mcp__{server}"
    if rule == name or rule.startswith(name + "__"):
        return True
    return any(c in rule for c in "*?[") and any(
        fnmatch.fnmatchcase(t, rule) for t in (name, name + "__any_tool"))
for a in (perms.get("allow") or []):
    if isinstance(a, str) and any(reaches(a, s) for s in servers):
        print(f"A\t{a}")
for key in ("enableAllProjectMcpServers", "enabledMcpjsonServers"):
    if key in data:
        print(f"M\t{key}")
hooks = data.get("hooks")
if isinstance(hooks, dict):
    for event, entries in hooks.items():
        if "code-review-graph" in json.dumps(entries):
            print(f"H\t{event}")
elif hooks is not None and "code-review-graph" in json.dumps(hooks):
    print("H\t(hooks)")
PY
}

# Prints "S<TAB>path" per disabled [[skills.config]] path, "F<TAB>" when a fallback is set,
# "M<TAB>names" when it declares mcp_servers, or "E<TAB>reason" when the file is not valid TOML.
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
if "mcp_servers" in data:
    servers = data["mcp_servers"]
    print("M\t" + (", ".join(servers) if isinstance(servers, dict) and servers else "(empty)"))
PY
}

# Check 11's reader: one line per way the root .mcp.json departs from the development entry
# (DESIGN.md D54: code-review-graph alone, pinned, the held tool list, the six blank keys).
# Never prints a credential's value, only its key.
read_mcp() {
  python3 - "$MCP_JSON" "$CRG_PIN" "$SA_CRG_TOOLS" "$SA_CRG_BLANK_KEYS" <<'PY'
import json, sys
path, pin, tools, keys = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4].split()
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception as exc:
    print(f"is not valid JSON ({exc.__class__.__name__}: {exc})"); sys.exit(0)
servers = data.get("mcpServers") if isinstance(data, dict) else None
if not isinstance(servers, dict):
    print("has no mcpServers object"); sys.exit(0)
for name in servers:
    if name != "code-review-graph":
        print(f"declares the server {name} — development runs code-review-graph alone")
crg = servers.get("code-review-graph")
if not isinstance(crg, dict):
    print("does not declare code-review-graph as an object"); sys.exit(0)
other = sorted(set(crg) - {"command", "args", "env"})
if other:
    print("gives code-review-graph other keys (" + ", ".join(other) + "); only command, args and env belong there")
if crg.get("command") != "uvx":
    print(f"starts code-review-graph with {crg.get('command')!r}, not uvx")
args = crg.get("args")
if not (isinstance(args, list) and len(args) == 4 and all(isinstance(a, str) for a in args)):
    print(f"does not give code-review-graph exactly four arguments: {pin}, serve, --tools and the held list")
else:
    if args[0] != pin:
        print(f"runs {args[0]!r}, not the pinned {pin}")
    if args[1:3] != ["serve", "--tools"]:
        print("does not start code-review-graph as serve --tools <the held list>")
    if args[3] != tools:
        held, got = tools.split(","), args[3].split(",")
        more = [t for t in got if t not in held]
        less = [t for t in held if t not in got]
        parts = (["adds " + ", ".join(more)] if more else []) + (["drops " + ", ".join(less)] if less else [])
        print(f"gives code-review-graph a --tools list other than the held {len(held)} names ("
              + ("; ".join(parts) or "the same names, reordered or respaced") + ")")
env = crg.get("env")
if not isinstance(env, dict):
    print("gives code-review-graph no env object of the six blank keys")
else:
    parts = []
    more = sorted(set(env) - set(keys))
    less = [k for k in keys if k not in env]
    valued = sorted(k for k in env if k in keys and env[k] != "")
    if more:
        parts.append("other keys " + ", ".join(more))
    if less:
        parts.append("missing " + ", ".join(less))
    if valued:
        parts.append("a value in " + ", ".join(valued))
    if parts:
        print("has an env other than exactly the six blank keys (" + "; ".join(parts) + ")")
PY
}

# True when SA_ROOT is the top of a Git work tree (checks 13 and 14 ask Git; a copy that is not
# a work tree skips those parts, by name).
is_worktree() {
  command -v git >/dev/null 2>&1 || return 1
  [[ "$(git -C "$SA_ROOT" rev-parse --show-toplevel 2>/dev/null)" == "$(cd "$SA_ROOT" && pwd -P)" ]]
}

run_checks() {
  FINDINGS=()
  NOTES=()
  ON_DISK=0
  local kind val s x
  local -A denied=() asked=() excluded=() on_disk=()
  local allows=() starts=() hooked=() servers_in_codex=()
  if [[ ! -f "$SETTINGS" ]]; then
    finding "check 1 — there is no .claude/settings.json at the repository root — nothing isolates the template's skills"
    return 0
  fi
  while IFS=$'\t' read -r kind val; do
    case "$kind" in
      E) finding "check 1 — .claude/settings.json is not valid JSON ($val)"; return 0 ;;
      D) denied["$val"]=1 ;;
      K) asked["$val"]=1 ;;
      X) excluded["$val"]=1 ;;
      A) allows+=("$val") ;;
      M) starts+=("$val") ;;
      H) hooked+=("$val") ;;
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
        M) servers_in_codex+=("$val") ;;
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

  # ── Development MCP (D54): checks 11–14 ──
  local p
  if [[ -L "$MCP_JSON" ]]; then
    finding "check 11 — the root .mcp.json is a link (to $(readlink "$MCP_JSON")) — the development server entry must be this repository's own file"
  elif [[ -e "$MCP_JSON" && ! -f "$MCP_JSON" ]]; then
    finding "check 11 — the root .mcp.json is not a regular file"
  elif [[ -f "$MCP_JSON" ]]; then
    while IFS= read -r p; do
      [[ -n "$p" ]] && finding "check 11 — the root .mcp.json $p"
    done < <(read_mcp)
  else
    NOTES+=("check 11: there is no root .mcp.json, so no development MCP server to check")
  fi

  [[ -n "${denied[$SA_MCP_DENY]:-}" ]] \
    || finding "check 12 — the root .claude/settings.json does not deny $SA_MCP_DENY — it would compute embeddings, and accept cloud ones, from this repository"
  for p in "${CRG_ASKS[@]}"; do
    [[ -n "${asked[$p]:-}" ]] \
      || finding "check 12 — the root .claude/settings.json does not ask before $p — a tool that writes would run unasked"
  done
  for p in "${allows[@]}"; do
    finding "check 12 — the root .claude/settings.json allows $p — an allow rule lets an MCP server's tools run unasked here"
  done
  for p in "${starts[@]}"; do
    finding "check 12 — the root .claude/settings.json sets $p — Claude Code would start the repository's MCP servers without asking"
  done

  if [[ ! -f "$GITIGNORE" ]]; then
    finding "check 13 — there is no root .gitignore — code-review-graph's database under .code-review-graph/ could be committed"
  elif ! grep -qxF "$SA_CRG_IGNORE_LINE" "$GITIGNORE"; then
    finding "check 13 — the root .gitignore has no line $SA_CRG_IGNORE_LINE — code-review-graph's database could be committed"
  elif is_worktree; then
    git -C "$SA_ROOT" -c core.excludesFile=/dev/null check-ignore -q --no-index .code-review-graph/graph.db \
      || finding "check 13 — the root .gitignore holds $SA_CRG_IGNORE_LINE, yet git does not ignore .code-review-graph/graph.db — a later rule re-includes it"
  else
    NOTES+=("check 13: git's own ignore test skipped — the root is not the top of a Git work tree")
  fi

  local m f out st hooks_dir
  if is_worktree; then
    while IFS= read -r m; do
      [[ -z "$m" ]] && continue
      st=0; out="$(git -C "$SA_ROOT" grep -l -I --untracked -F -e "$m" -- 2>/dev/null)" || st=$?
      if [[ "$st" -gt 1 ]]; then
        finding "check 14 — git grep could not scan the repository for code-review-graph's install markers (exit $st)"
        break
      fi
      while IFS= read -r f; do
        [[ -n "$f" ]] && finding "check 14 — $f holds code-review-graph's install marker \"$m\" — its install ran here; remove what it wrote"
      done <<< "$out"
    done <<< "$SA_CRG_INSTALL_MARKERS"
    hooks_dir="$(git -C "$SA_ROOT" rev-parse --git-path hooks 2>/dev/null || true)"
    [[ -z "$hooks_dir" || "$hooks_dir" == /* ]] || hooks_dir="$SA_ROOT/$hooks_dir"
    if [[ -n "$hooks_dir" && -d "$hooks_dir" ]]; then
      for f in "$hooks_dir"/*; do
        [[ -f "$f" && "$f" != *.sample ]] || continue
        grep -qF "code-review-graph" "$f" 2>/dev/null \
          && finding "check 14 — the Git hook ${f#"$SA_ROOT"/} names code-review-graph — its install appends a pre-commit hook; remove that part"
      done
    fi
  else
    NOTES+=("check 14: the scan for install markers and Git hooks skipped — the root is not the top of a Git work tree")
  fi
  for p in "${hooked[@]}"; do
    finding "check 14 — the root .claude/settings.json's $p hooks name code-review-graph — its install writes them; remove them"
  done
  for p in "${servers_in_codex[@]}"; do
    finding "check 14 — the root .codex/config.toml declares mcp_servers ($p) — copied into the user config, a server there would start in every repository"
  done
  return 0
}

self_test() {
  local tmp real_root="$SA_ROOT" s m1 m2
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  command -v git >/dev/null 2>&1 || die "git is not installed (checks 13 and 14 need it)"
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  SA_ROOT="$tmp"; set_paths
  mkdir -p "$tmp/.claude" "$tmp/.codex" "$SKILLS/draft-section" "$SKILLS/grill-me" "$tmp/bin" \
           "$tmp/.github/scripts" "$tmp/handoffs"
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
  # The root settings: every skill denied, then the development MCP rules (check 12) from
  # _common.sh. ST_DENY (the deny), ST_ASK, ST_ALLOW and ST_EXTRA (more top-level members)
  # carry one mutation at a time and are restored after it.
  local asks_json
  asks_json="[$(printf '"%s", ' "${CRG_ASKS[@]}")"; asks_json="${asks_json%, }]"
  ST_DENY="\"$SA_MCP_DENY\""; ST_ASK="$asks_json"; ST_ALLOW='["Read(**)"]'; ST_EXTRA=""
  write_settings() { # $1 = names to leave out of deny, $2 = excludes JSON
    local first=true
    {
      printf '{\n  "claudeMdExcludes": %s,\n  "permissions": {\n    "deny": [' "$2"
      while read -r s _; do
        [[ -z "$s" || " $1 " == *" $s "* ]] && continue
        $first || printf ', '; first=false
        printf '"Skill(%s)"' "$s"
      done <<< "$SA_SKILLS"
      [[ -n "$ST_DENY" ]] && { $first || printf ', '; printf '%s' "$ST_DENY"; }
      printf '],\n    "ask": %s,\n    "allow": %s\n  }%s\n}\n' "$ST_ASK" "$ST_ALLOW" "$ST_EXTRA"
    } > "$SETTINGS"
  }
  local ok='["**/template/**/CLAUDE.md", "**/template/.claude/**"]'
  write_settings "" "$ok"
  # The development .mcp.json (check 11), built from _common.sh's held values; $1 is one
  # Python statement applied to it first (d = the code-review-graph entry).
  write_mcp() {
    python3 - "$MCP_JSON" "$CRG_PIN" "$SA_CRG_TOOLS" "$SA_CRG_BLANK_KEYS" "${1:-pass}" <<'PY'
import json, sys
path, pin, tools, keys, change = sys.argv[1:6]
servers = {"code-review-graph": {"command": "uvx", "args": [pin, "serve", "--tools", tools],
                                 "env": {k: "" for k in keys.split()}}}
d = servers["code-review-graph"]
exec(change)
with open(path, "w", encoding="utf-8") as out:
    json.dump({"mcpServers": servers}, out, indent=2)
    out.write("\n")
PY
  }
  write_mcp
  write_gitignore() { printf '/handoffs/\n\n# code-review-graph (development only).\n%s\n%s' "$SA_CRG_IGNORE_LINE" "${1:-}" > "$GITIGNORE"; }
  write_gitignore
  # Check 14 must stay quiet on _common.sh (each marker built there from two halves) and on
  # this script, so the fixture tracks copies of both; the markers come from _common.sh too.
  cp "$SA_SCRIPTS_DIR/_common.sh" "$SA_SCRIPTS_DIR/$SCRIPT_NAME" "$tmp/.github/scripts/"
  m1="$(sed -n 1p <<< "$SA_CRG_INSTALL_MARKERS")"; m2="$(sed -n 2p <<< "$SA_CRG_INSTALL_MARKERS")"
  [[ -n "$m1" && -n "$m2" ]] || die "_common.sh's SA_CRG_INSTALL_MARKERS does not hold two markers"
  # A Git work tree of its own, its hooks in its own .git/hooks whatever the global config says.
  if ! { sa_git "$tmp" init -q && sa_git "$tmp" config core.hooksPath .git/hooks && sa_git "$tmp" add -A; }; then
    die "could not make the fixture a Git work tree"
  fi
  st_baseline "a Git work tree whose root settings deny every skill, with the development MCP entry, tracking _common.sh and this script"

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

  write_mcp "servers['scrapling'] = {'command': 'uvx', 'args': ['scrapling', 'mcp']}"
  probe "check 11 fires when the development .mcp.json declares Scrapling" "check 11 — the root .mcp.json declares the server scrapling"
  write_mcp "d['args'][0] = 'code-review-graph'"
  probe "check 11 fires when code-review-graph is unpinned" "check 11 — the root .mcp.json runs 'code-review-graph', not the pinned"
  write_mcp "d['args'][3] += ',embed_graph_tool'"
  probe "check 11 fires when the tool list exposes embed_graph_tool" "check 11 — the root .mcp.json gives code-review-graph a --tools list other than the held 29 names (adds embed_graph_tool)"
  write_mcp "d['env']['VOYAGE_API_KEY'] = 'set'"
  probe "check 11 fires when a blank key carries a value" "check 11 — the root .mcp.json has an env other than exactly the six blank keys (a value in VOYAGE_API_KEY)"
  write_mcp "d['type'] = 'stdio'"
  probe "check 11 fires on another key in the entry" "check 11 — the root .mcp.json gives code-review-graph other keys (type)"
  rm "$MCP_JSON"; ln -s .claude/settings.json "$MCP_JSON"
  probe "check 11 fires when the .mcp.json is a link" "check 11 — the root .mcp.json is a link"
  rm "$MCP_JSON"
  probe_clean "check 11 accepts a repository with no development .mcp.json"
  write_mcp

  ST_DENY="";                                                         write_settings "" "$ok"
  probe "check 12 fires when the root settings stop denying embed_graph_tool" "check 12 — the root .claude/settings.json does not deny $SA_MCP_DENY"
  ST_DENY="\"$SA_MCP_DENY\""; ST_ASK="[\"${CRG_ASKS[0]}\"]";          write_settings "" "$ok"
  probe "check 12 fires when an ask is lost" "check 12 — the root .claude/settings.json does not ask before ${CRG_ASKS[1]}"
  ST_ASK="$asks_json"; ST_ALLOW='["Read(**)", "mcp__code-review-graph__*"]'; write_settings "" "$ok"
  probe "check 12 fires on an allow rule for code-review-graph's tools" "check 12 — the root .claude/settings.json allows mcp__code-review-graph__*"
  ST_ALLOW='["mcp__scrapling"]';                                      write_settings "" "$ok"
  probe "check 12 fires on an allow rule for the Scrapling server" "check 12 — the root .claude/settings.json allows mcp__scrapling"
  ST_ALLOW='["mcp__*"]';                                              write_settings "" "$ok"
  probe "check 12 fires on a wildcard allow that reaches both servers" "check 12 — the root .claude/settings.json allows mcp__*"
  ST_ALLOW='["Read(**)", "mcp__other__fetch"]';                       write_settings "" "$ok"
  probe_clean "check 12 accepts an allow rule for another server"
  ST_ALLOW='["Read(**)"]'; ST_EXTRA=', "enableAllProjectMcpServers": true'; write_settings "" "$ok"
  probe "check 12 fires when the settings start every project server" "check 12 — the root .claude/settings.json sets enableAllProjectMcpServers"
  ST_EXTRA=', "enabledMcpjsonServers": ["code-review-graph"]';        write_settings "" "$ok"
  probe "check 12 fires when the settings approve the server by name" "check 12 — the root .claude/settings.json sets enabledMcpjsonServers"
  ST_EXTRA=""; write_settings "" "$ok"

  printf '/handoffs/\n' > "$GITIGNORE"
  probe "check 13 fires when the .gitignore loses the line" "check 13 — the root .gitignore has no line $SA_CRG_IGNORE_LINE"
  printf '/handoffs/\n.code-review-graph\n' > "$GITIGNORE"
  probe "check 13 fires on the unanchored form install writes" "check 13 — the root .gitignore has no line $SA_CRG_IGNORE_LINE"
  write_gitignore "!/.code-review-graph/"$'\n'
  probe "check 13 fires when a later rule re-includes the folder" "check 13 — the root .gitignore holds $SA_CRG_IGNORE_LINE, yet git does not ignore"
  write_gitignore

  printf '\n%s\n' "$m1" >> "$tmp/.claude/CLAUDE.md"
  probe "check 14 fires on the install's CLAUDE.md marker in a tracked manual" "check 14 — .claude/CLAUDE.md holds code-review-graph's install marker"
  printf '# CLAUDE.md\n\n**Start every session at the repository root.**\n' > "$tmp/.claude/CLAUDE.md"
  printf '%s\n' "$m2" > "$tmp/new-notes.md"
  probe "check 14 fires on a marker in a file Git would add" "check 14 — new-notes.md holds code-review-graph's install marker"
  rm "$tmp/new-notes.md"
  printf '%s\n%s\n' "$m1" "$m2" > "$tmp/handoffs/notes.md"
  probe_clean "check 14 never reads a git-ignored handoff that quotes both markers"
  rm "$tmp/handoffs/notes.md"
  printf '#!/bin/sh\n%s\nuvx code-review-graph update\n' "$m2" > "$tmp/.git/hooks/pre-commit"
  probe "check 14 fires on the install's Git pre-commit hook" "check 14 — the Git hook .git/hooks/pre-commit names code-review-graph"
  rm "$tmp/.git/hooks/pre-commit"
  ST_EXTRA=', "hooks": {"PostToolUse": [{"matcher": "Edit", "hooks": [{"type": "command", "command": "code-review-graph update"}]}]}'
  write_settings "" "$ok"
  probe "check 14 fires on a settings hook that runs code-review-graph" "check 14 — the root .claude/settings.json's PostToolUse hooks name code-review-graph"
  ST_EXTRA=""; write_settings "" "$ok"
  write_codex "" $'[mcp_servers.code-review-graph]\ncommand = "uvx"\n'
  probe "check 14 fires when the Codex snippet declares a server" "check 14 — the root .codex/config.toml declares mcp_servers (code-review-graph)"
  write_codex "" ""
  probe_clean "the fixture is clean again after every mutation"
  CODEX_BIN="$real_codex"

  SA_ROOT="$real_root"; set_paths
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
  bold "✓ $ON_DISK template skill(s) on disk, every catalogued skill denied, both CLAUDE.md exclusions present; the Codex user-config snippet complete; development entrypoints in place, no root .agents, and the start-at-the-root rule written down; the development MCP entry, its rules and its ignore line held, and no code-review-graph install artefact."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
log ""
log "  Add Skill(<name>) to permissions.deny in the ROOT .claude/settings.json (never the one"
log "  under template/, which ships), and a [[skills.config]] entry (path .../<name>/SKILL.md,"
log "  enabled = false) to the root .codex/config.toml, the snippet for the user config. Start"
log "  every session at the repository root; never add a root .agents. Checks 11-14: the"
log "  development .mcp.json, its deny and asks and its ignore line are DESIGN.md Section 7's"
log "  (the maintainer's files); never run code-review-graph install, init or uninstall here,"
log "  and remove whatever one wrote."
exit 1
