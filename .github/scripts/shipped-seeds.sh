#!/usr/bin/env bash
#
# shipped-seeds.sh — Verify the seeds ship empty, wired, and only where they belong.
#
#                    A seed (`_skip_if_exists`) is written once and never again: the author's
#                    copy is never overwritten, and a deleted one comes back on the next
#                    update. That makes a polluted seed a one-way door (SB rule 21) — an entry
#                    that ships in the template's MEMORY.md or names register lands in every
#                    project and no update can retract it — so emptiness is AUDITED, not trusted
#                    (DESIGN.md Section 3.1). Seed-once examples are the opposite contract: copied
#                    on `copy`, excluded on `update`, so an example the author deleted stays
#                    deleted (Section 3.2). And the author-owned folders ship their pair and
#                    nothing else (Section 3.3), because anything else in them is the template
#                    writing into the author's space.
#
#                    Twenty-six checks:
#                      1. Every DESIGN.md seed is listed in copier.yml's _skip_if_exists.
#                      2. Every _skip_if_exists entry names a file under template/.
#                      3. Every seed-once example has its copy-only _exclude line, gated
#                         "_copier_operation == 'update' or not SEED_EXAMPLES".
#                      4. Every seed-once example exists under template/.
#                      5. .claude/MEMORY.md carries the six H2s: Facts · Decisions · Feedback ·
#                         Status · Open questions · Sensitivities.
#                      6. .claude/MEMORY.md carries no entry (a "- **" bullet).
#                      7. A register or index seed carries no entry: a filled table row, a dated
#                         bullet, or (tooling/seed-refs.sql) an INSERT; a brand seed carries no
#                         dated bullet (its tables are structure: role, preamble name, an
#                         AUTHOR TO CONFIRM value).
#                      8. voice-notes.md carries a '## Learned' section, and it is empty.
#                      9. A register or style seed lacks the seeded-stub banner. Index pairs and
#                         brand guides carry none: a pair is navigation, and a brand guide ships
#                         as a structure whose open slots say the same thing.
#                     10. .mcp.json declares exactly the two D54 servers (code-review-graph and
#                         scrapling, DESIGN.md D19 as amended by D54): in the template it is byte
#                         for byte the 1308 shared bytes .agents/mcp_config.json also holds; in a
#                         render it parses to the same servers.
#                     11. A pair-only folder holds something other than its pair, a nested
#                         .gitignore, a declared seed or a seed-once example.
#                     12. .claude/settings.json breaks DESIGN.md Section 4.1: model opus,
#                         autoCompactEnabled false, idleCompaction false (an idle compaction
#                         fires PreCompact auto, which the hook blocks, so it stays off even
#                         where an owner keeps autoCompactEnabled true; D29), outputStyle
#                         "Concise" (the house output style, D60), PreCompact hooks for auto
#                         and manual,
#                         denies AskUserQuestion, Edit(**/*.pdf), Edit(build/**) and D54's
#                         mcp__code-review-graph__embed_graph_tool, asks for exactly D54's eight
#                         tools in their order, and no owner-specific key (effortLevel,
#                         ultracode, enabledPlugins, disable*); its D29 hooks (UserPromptSubmit,
#                         PreCompact, and SessionStart for the note after a compaction) are the
#                         entries migrations/family-refresh.json offers, unchanged, and neither
#                         a D29 event nor any of the three top-level values is missing from
#                         that file's settings (check 22 compares the values; an entry the seed
#                         alone holds never reaches an existing project); and exactly
#                         one PreToolUse entry runs the data-root guard
#                         (its command is the guard's, or names a dataroot.py), it is the
#                         first PreToolUse entry, and it is the merged seed's (DESIGN.md D50:
#                         matcher Edit|Write|MultiEdit|NotebookEdit|Grep|Glob, the
#                         self-locating command, timeout 10). Any other PreToolUse entry is
#                         check 26's. Read in a render, and in the template with its
#                         gates removed (every `<: if :>` block cut out), which must parse as
#                         JSON too.
#                     13. In a render, .claude/settings.json carries exactly the gated
#                         permissions of DESIGN.md Section 4.1 for its answers: books deny
#                         Edit(typeset/src/units/.base/**) (Pandoc bases are never hand-edited);
#                         references allow Bash(sqlite3 tooling/references.db *); the conlang
#                         allows Bash(uv run tooling/font.py *). Each is absent where its gate is
#                         false. This is also where a broken block in the seed shows: the file
#                         must parse as JSON in every profile.
#                     14. An index seed (the map index, a docs/project/ or workflows/local/ pair)
#                         lists an entry in its directory tree: a line naming anything but the
#                         pair, a workflow's four files or a placeholder (<…>, NN-…, kebab-…).
#                     15. A brand seed (brand-voice.md, brand-guide.md) has no open
#                         `AUTHOR TO CONFIRM` slot: every brand fact is the author's call, so a
#                         brand seed with none left has shipped somebody's brand.
#                     16. .claude/rules/syntek-author/00-project.md (DESIGN.md D40) carries its
#                         five H2s — Brief · Paths · Memory headings · Workflow aliases ·
#                         Overrides — and no entry under Workflow aliases or Overrides (a filled
#                         table row or a dated bullet). Brief, Paths and Memory headings hold
#                         answer-rendered values and the template's defaults; the last two are
#                         the project's alone, and a row shipped there is an instruction that
#                         outranks every rule in every project.
#                     17. tooling/project.mk (D43) assigns only the D43 build settings
#                         (BRAND_DIRS, LOGO_DIRS, DOCX_CONVERTER, FLAG_EXTRA_RE, ISSUE_STATUSES,
#                         MAINFONT, SANSFONT, MONOFONT), defines no make rule, and names no
#                         absolute path: the Makefile -includes it in every build, so anything
#                         else in it is a project's build shipped to every project. Nor does any
#                         line of it name SYNTEK_DATA_ROOT or a data-root answer (DATA_STORE,
#                         DATA_AREA, DATA_SLUG, DATA_KIND_*, DATA_PROVIDER; DESIGN.md D50): each
#                         machine names its root in its own environment, and the resolver reads
#                         the answers file, so a copy here is a machine's path in Git, or stale.
#
#                     18. Every copy-only shared path of DESIGN.md Section 3.6 (D47: the other
#                         coding agents' entrypoints, the .agents/skills link, Antigravity's
#                         .agents/mcp_config.json, the client settings; D51: the shared skills,
#                         hooks and handoffs pair; D56: the guide guard and the shared how-to
#                         files) has its anchored
#                         _skip_if_exists line, its _exclude line gated
#                         "_copier_operation == 'update'", and a file (or, for .agents/skills, a
#                         link) under template/. Without the skip a copy overwrites the author's
#                         file; without the exclusion an update re-renders it, or brings back
#                         one the author deleted.
#                     19. Every folder that holds copy-only paths (.agents, .codex, .gemini) has
#                         an _exclude line of its own gated on the update. Copier 9.17.1 creates
#                         an EMPTY folder on an update that crosses the release introducing it,
#                         even when every path inside is excluded.
#                     20. The .agents layout (D47, P1 of the follow-up): template/.agents is a
#                         real folder, never a link (a linked .agents breaks Codex's Linux
#                         sandbox); template/.agents/skills is a link to exactly
#                         ../.claude/skills, never a copy; template/.agents/mcp_config.json is
#                         byte for byte .mcp.json, the 1308 shared bytes that declare the two
#                         D54 servers (D48: syntek-media ships the same bytes from its 0.5.0);
#                         and the retired template/.claude/mcp_config.json is gone.
#
#                     21. The shared working practice (D51) and the shared how-to files (D56):
#                         every shared skill, hook (the guide guard among them), handoffs file
#                         and shared how-to file (check 18 holds each to its copy-only lines) is
#                         listed in migrations/family-refresh.json, which lists nothing else;
#                         each hook is
#                         executable under template/ (Copier compares the bit, so a copy over the
#                         sibling's 755 copy would conflict); and no _skip_if_exists or
#                         update-gated _exclude line names a folder above one of them, which
#                         would freeze or hide this template's own mode files beside it.
#                     22. In a render, .claude/settings.json wires every hook entry
#                         migrations/family-refresh.json lists (the context-threshold hook on
#                         UserPromptSubmit, the PreCompact handoff for auto and manual, its
#                         SessionStart note for compact): the
#                         refresh adds an entry to an existing project only where the new
#                         render's settings.json holds it, so a seed without it never wires it.
#                         And, in the template, the seed template/.claude/settings.json holds
#                         every permissions.deny and permissions.ask rule that file lists (a
#                         variant-gated rule still appears in the seed's source), and every
#                         top-level value it lists ("autoCompactEnabled": false,
#                         "idleCompaction": false and "outputStyle": "Concise") with the same
#                         value, for the same reason: an entry listed in family-refresh.json
#                         alone is never offered. The MCP asks and deny of D54 are among those
#                         rules. family-refresh.json never lists the data-root guard (an entry
#                         whose command is the guard's or names a dataroot.py): it is
#                         deliberately seed-only (D50, D51), so no update and no copy over an
#                         existing settings.json wires it. It may list the guide guard (D56).
#                     23. The seed .gitignore ignores code-review-graph's local map (D54): it
#                         holds the anchored line /.code-review-graph/ outside every block, and
#                         `git check-ignore --no-index .code-review-graph/graph.db` succeeds
#                         against it (no later rule re-includes it). The map is a database of
#                         the project's code, rebuilt on demand, and never committed.
#                     24. The seed .gitignore carries the data-root pointer (its heading
#                         '# Binary records — filed under the data root (DATA_STORE external);
#                         none ignored here') exactly where the store says (D50): in the template
#                         once, inside a `<: if DATA_STORE == 'external' :>` block, an equality
#                         like every store test; in a render once under external and not at all
#                         under repo.
#                     25. No folder lines under how-to/ (D56): no _skip_if_exists entry and no
#                         _exclude entry gated on the update names /how-to, or any path under it
#                         other than the shared how-to files. Each how-to folder also holds this
#                         template's own files under its syntek-author/ folder, which stay
#                         template-owned: a folder line would freeze or hide them, and an
#                         update would never restore them.
#                     26. The guide guard in the seed (D56), the first problem of: the seed
#                         .claude/settings.json has exactly one PreToolUse entry whose command
#                         names .claude/hooks/how-to-read-only.sh; that entry's matcher is
#                         Edit|Write|MultiEdit|NotebookEdit, with one hook of type command,
#                         its command exactly the self-locating form that exits 0 where there
#                         is no git root or no script, and timeout 10; it equals the entry
#                         migrations/family-refresh.json offers; permissions.deny holds
#                         Edit(/how-to/**) directly after Edit(build/**). Read in a render, and
#                         in the template with its gates removed. The guard's executable bit is
#                         check 21's.
#                     27. The seed .gitignore ignores the handoff hooks' markers (D29): `git
#                         check-ignore --no-index .claude/compaction-marker-abc123.tmp` succeeds
#                         against it, so no session's marker shows in git status or is
#                         committed.
#                     28. Chapter 12 of the guide (how-to/src/TEMPLATE-GUIDE/syntek-author/
#                         12-troubleshooting.md), where the tree ships it, gives as its
#                         `"command":` lines naming a handoff hook exactly the D29 commands
#                         migrations/family-refresh.json offers (and check 12 holds the seed's
#                         to), each a JSON string, so its switch to the silent form by hand is
#                         never stale text.
#
#                    Checks 1–4, 18–21 and 25 read copier.yml and template/ (static, once).
#                    Checks 5–17, 22–24 and 26–28 read every tree given — template/ by
#                    default, or renders — and skip a seed the tree does not ship.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: that a writing rule in a seed is generic rather than
#                    one author's preference. "No entries" is decidable; "no personal
#                    preferences" is not — scrub.sh catches the names, a reviewer the rest.
#
# SELF-TEST. --self-test writes a fixture repository at runtime with every seed in shape,
#            proves it clean, then applies one mutation per check and asserts exactly one
#            finding each.
#
# Requirements: bash 4+, grep, awk, git (checks 23 and 27), python3 (checks 10, 12, 22, 24 and 28). No
#               network.
#
# Usage: shipped-seeds.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]
#
# Exit codes:  0 = every seed is wired and empty, every pair-only folder clean
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, no copier.yml, no python3)

set -euo pipefail
SCRIPT_NAME="shipped-seeds.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
shipped-seeds.sh — Verify the seeds ship empty, wired, and only where they belong

Usage: shipped-seeds.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]

  <tree>       A render to check as well (checks 5–17, 22–24, 26); template/ is always checked
  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture written at runtime
  --help       Show this message

Exit codes: 0 = clean  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           TARGETS+=("$1"); shift ;;
  esac
done

COPIER="$SA_ROOT/copier.yml"
TPL="$SA_ROOT/template"
TREE=""

REGISTER_SEEDS="standards/style/terminology.md standards/style/ledger/provenance.md planning/src/outline.md planning/src/causality.md planning/src/timeline.md planning/src/continuity.md world/src/names-register.md planning/src/document-register.md planning/src/review-schedule.md planning/src/precedence.md standards/brand/disclaimers.md research/src/permissions.md proposal/src/endorsements/tracker.md proposal/src/submissions/tracker.md proposal/src/sample/sample-index.md world/src/history/eras.md"
STYLE_SEEDS="standards/style/style-sheet.md standards/style/voice-notes.md"
# The author-filled index pairs and the business brand guides (DESIGN.md Section 3.1), from the
# catalogue in _common.sh.
INDEX_SEEDS="$SA_INDEX_SEEDS"
BRAND_SEEDS="$SA_BRAND_SEEDS"
MEMORY_H2S=("Facts" "Decisions" "Feedback" "Status" "Open questions" "Sensitivities")
PROJECT_SEED=".claude/rules/syntek-author/00-project.md"
PROJECT_H2S=("Brief" "Paths" "Memory headings" "Workflow aliases" "Overrides")
PROJECT_EMPTY_H2S=("Workflow aliases" "Overrides")
PROJECT_MK="tooling/project.mk"
REFRESH_DATA="migrations/family-refresh.json"
CH12="how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md"
PROJECT_MK_KEYS="BRAND_DIRS LOGO_DIRS DOCX_CONVERTER FLAG_EXTRA_RE ISSUE_STATUSES MAINFONT SANSFONT MONOFONT"

# Block delimiters removed, fenced code and HTML comments dropped: what an entry would look like.
readable() {
  sed -E 's/<:([^:]|:[^>])*:>//g' "$1" | awk '
    /^[[:space:]]*```/ { f = !f; next }
    f { next }
    /<!--/ && !/-->/ { c = 1; next }
    c && /-->/ { c = 0; next }
    c { next }
    { gsub(/<!--.*-->/, ""); print }'
}

register_entries() { # prints one line per entry found
  readable "$1" | awk '
    function placeholder(c) {
      gsub(/^[ \t]+|[ \t]+$/, "", c)
      return (c == "" || c ~ /^(—|-|–|…|\.\.\.|TBD|_[^_]*_|\*[^*]*\*|<[^>]*>|\[AWAITING USER INPUT\])$/)
    }
    /^[[:space:]]*\|/ {
      if ($0 ~ /^[[:space:]]*\|[[:space:]:|-]+\|[[:space:]]*$/ && $0 ~ /---/) { body = 1; next }
      if (!body) next
      n = split($0, cells, "|"); filled = 0
      for (i = 2; i < n; i++) if (!placeholder(cells[i])) filled = 1
      if (filled) print "table row: " substr($0, 1, 60)
      next
    }
    { body = 0 }
    /^[-*] (\*\*)?[0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]/ { print "dated entry: " substr($0, 1, 60) }'
}

# The names an index seed's directory tree lists, other than the pair, a workflow's four files
# and placeholders. Tree lines live in fenced code, which readable() drops, so this reads the
# fences themselves. awk alternation, not a bracket class, for the box-drawing bytes (mawk).
tree_entries() { # $1 = file → one listed name per line
  sed -E 's/<:([^:]|:[^>])*:>//g' "$1" | awk '
    /^[[:space:]]*```/ { f = !f; next }
    !f { next }
    /(├|└)── / {
      line = $0; sub(/^.*(├|└)── /, "", line); split(line, a, /[ \t]+/); n = a[1]
      if (n ~ /^(CONTEXT|CLAUDE|STEPS|CHECKLIST)\.md$/ || n ~ /</ || n ~ /^NN-/ || n ~ /^kebab-/) next
      print n
    }'
}

static_checks() {
  local s e cond path
  local -A skip=() copy_only=()
  while IFS= read -r s; do [[ -n "$s" && "$s" != *'<:'* ]] && skip["${s#/}"]=1; done < <(yaml_list _skip_if_exists "$COPIER")

  # ── 1 and 2. _skip_if_exists against DESIGN.md and the disk ─────────────────
  for s in $SA_SEEDS; do
    [[ -n "${skip[$s]:-}" ]] || finding "check 1 — $s is a seed (DESIGN.md Section 3.1) but _skip_if_exists does not list it — the next update overwrites the author's copy"
  done
  for s in "${!skip[@]}"; do
    [[ "$s" == *[*?[]* ]] && continue
    [[ -e "$TPL/$s" ]] || finding "check 2 — _skip_if_exists lists /$s, which is not under template/"
  done

  # ── 3 and 4. Seed-once examples ─────────────────────────────────────────────
  while IFS=$'\t' read -r cond path; do
    [[ "$(norm_expr "$cond")" == "$SA_EXAMPLE_GATE" ]] && copy_only["$path"]=1
  done < <(exclude_gates "$COPIER")
  for e in $SA_EXAMPLES; do
    [[ -n "${copy_only[$e]:-}" ]] || finding "check 3 — the example $e has no copy-only _exclude line ($SA_EXAMPLE_GATE) — a deleted example would come back"
    [[ -e "$TPL/$e" ]] || finding "check 4 — the example $e is not under template/"
  done

  # ── 18. Copy-only shared paths (D47) ────────────────────────────────────────
  local -A on_update=()
  while IFS=$'\t' read -r cond path; do
    [[ "$(norm_expr "$cond")" == "$SA_COPY_ONLY_GATE" ]] && on_update["$path"]=1
  done < <(exclude_gates "$COPIER")
  for s in $SA_COPY_ONLY $SA_SHARED_REFRESH; do
    [[ -n "${skip[$s]:-}" ]] || finding "check 18 — the copy-only $s is not in _skip_if_exists — a copy over a project overwrites the author's file"
    [[ -n "${on_update[$s]:-}" ]] || finding "check 18 — the copy-only $s has no _exclude line gated on the update — an update re-renders it, or brings back a deleted one"
    [[ -e "$TPL/$s" || -L "$TPL/$s" ]] || finding "check 18 — the copy-only $s is not under template/"
  done

  # ── 19. The folders that hold copy-only paths ───────────────────────────────
  for s in $SA_COPY_ONLY_DIRS; do
    [[ -d "$TPL/$s" ]] || continue
    [[ -n "${on_update[$s]:-}" ]] || finding "check 19 — the folder $s/ has no _exclude line gated on the update — an update across the release that adds it creates an empty $s/ in every project"
  done

  # ── 20. The .agents layout ──────────────────────────────────────────────────
  if [[ -L "$TPL/.agents" ]]; then
    finding "check 20 — template/.agents is a link (to $(readlink "$TPL/.agents")) — it must be a real folder; a linked .agents breaks Codex's Linux sandbox"
  elif [[ -d "$TPL/.agents" ]]; then
    if [[ ! -L "$TPL/.agents/skills" ]]; then
      finding "check 20 — template/.agents/skills is not a link — it must link to $SA_AGENTS_LINK_TARGET, never copy the skills"
    elif [[ "$(readlink "$TPL/.agents/skills")" != "$SA_AGENTS_LINK_TARGET" ]]; then
      finding "check 20 — template/.agents/skills links to $(readlink "$TPL/.agents/skills"), not $SA_AGENTS_LINK_TARGET"
    fi
    if [[ -f "$TPL/.agents/mcp_config.json" && "$(cat "$TPL/.agents/mcp_config.json"; printf x)" != "${SA_MCP_SHARED}x" ]]; then
      finding "check 20 — template/.agents/mcp_config.json is not the same bytes as .mcp.json (the 1308 bytes that declare the two D54 servers; D48, D54)"
    fi
  fi
  [[ -e "$TPL/.claude/mcp_config.json" ]] \
    && finding "check 20 — template/.claude/mcp_config.json is retired (Antigravity's file is .agents/mcp_config.json) and must not ship"

  # ── 21. The shared working practice (D51) ───────────────────────────────────
  local listed d
  listed="$(python3 -c 'import json,sys; print(" ".join(sorted(json.load(open(sys.argv[1])).get("refresh") or [])))' "$SA_ROOT/$REFRESH_DATA" 2>/dev/null || printf '?')"
  # shellcheck disable=SC2086  # one word per path
  [[ "$listed" == "$(printf '%s\n' $SA_SHARED_REFRESH | LC_ALL=C sort | paste -sd' ' -)" ]] \
    || finding "check 21 — $REFRESH_DATA does not refresh exactly the shared working practice and how-to files (it lists: ${listed:-nothing}) — a file it leaves out is never refreshed"
  for s in $SA_SHARED_HOOKS; do
    [[ ! -f "$TPL/$s" || -x "$TPL/$s" ]] || finding "check 21 — template/$s is not executable (mode 755) — a copy over the sibling's copy would see a conflict"
  done
  for s in $SA_SHARED_REFRESH; do
    d="${s%/*}"
    while [[ "$d" == */* || -n "$d" ]]; do
      if [[ -n "${skip[$d]:-}" || -n "${on_update[$d]:-}" ]]; then
        finding "check 21 — copier.yml names the folder $d copy-only — the shared lines are file-level, so $s's folder keeps its template-owned files"
      fi
      [[ "$d" == */* ]] && d="${d%/*}" || d=""
    done
  done
  # ── 22 (template). The seed holds every rule the refresh lists ──────────────
  # The data-root guard is deliberately seed-only (D50, D51): family-refresh.json never lists it,
  # so the refresh never wires it into an existing project's settings.json.
  while IFS= read -r line; do finding "check 22 — $line"; done \
    < <(rules_missing "$TPL/.claude/settings.json" "$SA_ROOT/$REFRESH_DATA" "$SA_GUARD_CMD")

  # ── 25. No folder lines under how-to/ (D56) ─────────────────────────────────
  # Only the shared how-to files are copy-only; every other how-to path is template-owned and
  # restored on update, so neither list may name /how-to or anything else under it.
  local -A howto_shared=()
  for s in $SA_SHARED_HOWTO; do howto_shared["$s"]=1; done
  for s in "${!skip[@]}"; do
    [[ "$s" == how-to || "$s" == how-to/* ]] || continue
    [[ -n "${howto_shared[$s]:-}" ]] \
      || finding "check 25 — _skip_if_exists names /$s — under how-to/ only the shared how-to files are copy-only; every other path there is template-owned and restored on update (D56)"
  done
  while IFS=$'\t' read -r cond path; do
    [[ "$cond" == *_copier_operation* ]] || continue
    [[ "$path" == how-to || "$path" == how-to/* ]] || continue
    [[ -n "${howto_shared[$path]:-}" ]] \
      || finding "check 25 — an _exclude line gated on the update names /$path — under how-to/ only the shared how-to files are copy-only; every other path there is template-owned and restored on update (D56)"
  done < <(exclude_gates "$COPIER")
  return 0
}

# The permission rules and top-level values of family-refresh.json the seed settings.json source
# does not hold (check 22): the refresh offers an entry only where the new render's
# settings.json holds it (a top-level value, with the same value).
rules_missing() { # $1 = template/.claude/settings.json (source), $2 = family-refresh.json, $3 = the guard
  python3 - "$1" "$2" "$3" <<'PY'
import json, re, sys
try:
    text = open(sys.argv[1], encoding="utf-8").read()
    settings = json.load(open(sys.argv[2], encoding="utf-8")).get("settings") or {}
    perms = settings.get("permissions") or {}
except Exception:
    sys.exit(0)  # check 21 reports a refresh file that is missing or does not parse
hooks = settings.get("hooks") if isinstance(settings.get("hooks"), dict) else {}
# The guide guard (D56) may be listed; only an entry that runs the data-root guard is refused.
if any(isinstance(h, dict) and (h.get("command") == sys.argv[3] or "dataroot.py" in str(h.get("command", "")))
       for entries in hooks.values() if isinstance(entries, list)
       for e in entries if isinstance(e, dict) for h in (e.get("hooks") or [])):
    print("migrations/family-refresh.json lists the data-root guard — it is seed-only: no update and no copy over an existing settings.json may wire it (D50, D51)")
for key, value in settings.items():
    if key in ("hooks", "permissions") or not isinstance(value, (bool, int, float, str)):
        continue
    if not re.search(r"^  %s:\s*%s,?$" % (re.escape(json.dumps(key)), re.escape(json.dumps(value))), text, re.M):
        print(f"template/.claude/settings.json does not hold the top-level {json.dumps(key)}: {json.dumps(value)} that migrations/family-refresh.json lists — the refresh offers a value only where the new render's settings.json holds it, so it is never added")
for kind in ("deny", "ask"):
    for rule in perms.get(kind) or []:
        if json.dumps(rule) not in text:
            print(f"template/.claude/settings.json does not hold the {kind} rule {rule} that migrations/family-refresh.json lists — the refresh offers a rule only where the new render's settings.json holds it, so it is never added")
PY
}

# The hook entries of family-refresh.json a render's settings.json does not wire (check 22).
hooks_missing() { # $1 = settings.json, $2 = family-refresh.json
  python3 - "$1" "$2" <<'PY'
import json, re, sys
try:
    data = json.load(open(sys.argv[1], encoding="utf-8"))
    want = (json.load(open(sys.argv[2], encoding="utf-8")).get("settings") or {}).get("hooks") or {}
except Exception:
    sys.exit(0)  # check 12 reports a settings file that does not parse; check 21 a missing list
script = re.compile(r"\.claude/hooks/[A-Za-z0-9._-]+")
def names(e):
    return {n for h in (e.get("hooks") or []) for n in script.findall(str(h.get("command", "")))}
for event, entries in want.items():
    have = [e for e in ((data.get("hooks") or {}).get(event) or []) if isinstance(e, dict)]
    for e in entries:
        if not any(x.get("matcher", "") == e.get("matcher", "") and names(e) <= names(x) for x in have):
            print(f"does not wire the {event} hook{' for ' + e['matcher'] if e.get('matcher') else ''} running {', '.join(sorted(names(e)))}")
PY
}

json_check() { # $1 = mode (mcp|settings), $2 = file, then the mode's expectations → one problem per line
  python3 - "$@" <<'PY'
import json, sys
mode, path = sys.argv[1], sys.argv[2]
try:
    with open(path, encoding="utf-8") as fh:
        data = json.load(fh)
except Exception as exc:
    print(f"is not valid JSON ({exc.__class__.__name__})"); sys.exit(0)
if mode == "mcp":
    if data != json.loads(sys.argv[3]):
        found = sorted((data.get("mcpServers") or {}) if isinstance(data, dict) and isinstance(data.get("mcpServers"), dict) else [])
        print(f"does not declare exactly the two D54 servers as the template ships them (it declares {', '.join(found) or 'none'}; DESIGN.md D19, D54)")
    sys.exit(0)
refresh, guard_cmd, guard_matcher, guard_timeout, mcp_deny, mcp_asks = sys.argv[3:9]
if not isinstance(data, dict):
    print("is not a JSON object"); sys.exit(0)
if data.get("model") != "opus":
    print(f"model is {data.get('model')!r}, not 'opus'")
if data.get("autoCompactEnabled") is not False:
    print("autoCompactEnabled is not false — hand off, never compact (DESIGN.md D29)")
if data.get("idleCompaction") is not False:
    print("idleCompaction is not false — an idle compaction fires PreCompact auto, which the hook blocks (DESIGN.md D29)")
if data.get("outputStyle") != "Concise":
    print(f"outputStyle is {data.get('outputStyle')!r}, not 'Concise' — the house output style (DESIGN.md D60)")
hooks = data.get("hooks") if isinstance(data.get("hooks"), dict) else {}
matchers = {h.get("matcher") for h in (hooks.get("PreCompact") or []) if isinstance(h, dict)}
for m in ("auto", "manual"):
    if m not in matchers:
        print(f"has no PreCompact hook for '{m}'")
perms = data.get("permissions") if isinstance(data.get("permissions"), dict) else {}
deny = set(perms.get("deny") or [])
for d in ("AskUserQuestion", "Edit(**/*.pdf)", "Edit(build/**)", mcp_deny):
    if d not in deny:
        print(f"does not deny {d}")
if list(perms.get("ask") or []) != mcp_asks.split():
    print("does not ask for exactly the eight D54 tools, in their order (Scrapling's six fetching tools, then "
          "code-review-graph's apply_refactor_tool and generate_wiki_tool)")
for k in data:
    if k in ("effortLevel", "ultracode", "enabledPlugins") or k.startswith("disable"):
        print(f"carries the owner-specific key {k}")
# The D29 hooks unchanged: each event the seed wires holds exactly what family-refresh.json offers.
try:
    with open(refresh, encoding="utf-8") as fh:
        listed = json.load(fh).get("settings") or {}
    offered, read = listed.get("hooks") or {}, True
except Exception:
    listed, offered, read = {}, {}, False  # check 21 reports a refresh file that is missing or does not parse
for event in ("UserPromptSubmit", "PreCompact", "SessionStart"):
    if event in hooks and read and event not in offered:
        print(f"wires the D29 {event} hook, which migrations/family-refresh.json does not offer — an existing project would never gain it")
    elif event in hooks and event in offered and hooks[event] != offered[event]:
        print(f"changes the D29 {event} hook — the seed holds it exactly as migrations/family-refresh.json offers it")
for key in ("autoCompactEnabled", "idleCompaction", "outputStyle"):
    if key in data and read and key not in listed:
        print(f"sets {key}, which migrations/family-refresh.json does not list — an existing project would never be offered it (DESIGN.md D29, D51, D60)")
# The data-root guard: exactly one PreToolUse entry runs it, the first, exactly the merged seed's.
# Any other PreToolUse entry (the guide guard, D56) is check 26's.
pre = hooks.get("PreToolUse")
pre = pre if isinstance(pre, list) else []
want = {"matcher": guard_matcher, "hooks": [{"type": "command", "command": guard_cmd, "timeout": int(guard_timeout)}]}
def runs_guard(e):
    return isinstance(e, dict) and any(isinstance(h, dict) and (h.get("command") == guard_cmd or "dataroot.py" in str(h.get("command", "")))
                                       for h in (e.get("hooks") or []) if isinstance(e.get("hooks"), list))
at = [i for i, e in enumerate(pre) if runs_guard(e)]
if len(at) != 1:
    print(f"has {len(at)} PreToolUse entries that run the data-root guard — the seed has exactly one (DESIGN.md D50)")
elif at[0] != 0:
    print(f"wires the data-root guard as PreToolUse entry {at[0] + 1}, not the first")
elif pre[0].get("matcher") != guard_matcher:
    print(f"wires its PreToolUse entry for {pre[0].get('matcher')!r}, not for {guard_matcher!r} — the data-root guard covers every tool that edits, writes or searches")
elif pre[0] != want:
    print("does not wire the data-root guard exactly as the merged seed does (DESIGN.md D50: the self-locating "
          "command that runs the first .claude/syntek-*-dataroot.py guard, timeout 10)")
PY
}

# The guide guard in a settings.json (check 26): the first problem, or nothing (D56).
guide_guard_problem() { # $1 = settings.json, $2 = family-refresh.json
  python3 - "$1" "$2" "$SA_HOWTO_GUARD" "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" <<'PY'
import json, sys
path, refresh, script, matcher, cmd, deny = sys.argv[1:7]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    sys.exit(0)  # check 12 reports a settings file that does not parse
if not isinstance(data, dict):
    sys.exit(0)
hooks = data.get("hooks") if isinstance(data.get("hooks"), dict) else {}
pre = hooks.get("PreToolUse") if isinstance(hooks.get("PreToolUse"), list) else []
def names(e):
    return isinstance(e, dict) and isinstance(e.get("hooks"), list) and any(
        isinstance(h, dict) and script in str(h.get("command", "")) for h in e["hooks"])
mine = [e for e in pre if names(e)]
want = {"matcher": matcher, "hooks": [{"type": "command", "command": cmd, "timeout": 10}]}
try:
    offered = (((json.load(open(refresh, encoding="utf-8")).get("settings") or {}).get("hooks") or {}).get("PreToolUse")) or []
except Exception:
    offered = None  # check 21 reports a refresh file that is missing or does not parse
offered = [e for e in offered if names(e)] if isinstance(offered, list) else None
perms = data.get("permissions") if isinstance(data.get("permissions"), dict) else {}
denies = perms.get("deny") if isinstance(perms.get("deny"), list) else []
if len(mine) != 1:
    print(f"has {len(mine)} PreToolUse entries that run {script} — the seed wires the guide guard exactly once (DESIGN.md D56)")
elif mine[0] != want:
    print(f"does not wire the guide guard exactly as DESIGN.md D56 does (matcher {matcher}, one command hook in the self-locating "
          f"form that exits 0 where there is no git root or no script, timeout 10)")
elif offered is not None and mine[0] not in offered:
    print(f"wires the guide guard otherwise than migrations/family-refresh.json offers it — the refresh adds an entry only where the "
          f"new render's settings.json holds that entry, so an existing project would never be offered it")
elif "Edit(build/**)" not in denies or denies.index("Edit(build/**)") + 1 >= len(denies) or denies[denies.index("Edit(build/**)") + 1] != deny:
    print(f"does not deny {deny} directly after Edit(build/**) (DESIGN.md D56: one anchored Edit rule covers every file-writing tool)")
PY
}

# The source with every `<: if … :>…<: endif :>` block cut out, innermost first: what a profile
# with every gate shut renders (check 12 reads the seed settings.json this way).
strip_blocks() { # $1 = file
  python3 - "$1" <<'PY'
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
block = re.compile(r"<:-?\s*if\b(?:(?!<:-?\s*if\b).)*?<:-?\s*endif\s*-?:>", re.S)
while True:
    cut = block.sub("", text)
    if cut == text:
        break
    text = cut
sys.stdout.write(text)
PY
}

# The data-root pointer and the code-review-graph line in the seed .gitignore (checks 23 and 24).
# In the template, which block each sits in; in a render, how often each occurs.
gitignore_problems() { # $1 = file, $2 = source|external|repo|unknown → "check N — …" lines
  python3 - "$1" "$2" "$SA_CRG_IGNORE_LINE" "$SA_GITIGNORE_DATAROOT_LINE" <<'PY'
import re, sys
path, mode, crg, pointer = sys.argv[1:5]
text = open(path, encoding="utf-8").read()
TAG = re.compile(r"<:-?\s*(if|elif|else|endif)\b(.*?)-?:>", re.S)
def norm(c):
    return " ".join(c.replace('"', "'").split())
def at(pos):
    stack = []
    for m in TAG.finditer(text, 0, pos):
        kind, cond = m.group(1), norm(m.group(2))
        if kind == "if":
            stack.append(("if", cond))
        elif kind in ("elif", "else") and stack:
            stack[-1] = (kind, cond)
        elif kind == "endif" and stack:
            stack.pop()
    return stack
def where(line):
    return [m.start(1) for m in re.finditer(r"(?m)^(?:<:.*?:>)*(" + re.escape(line) + r")[ \t]*$", text)]
c, ptr = where(crg), where(pointer)
if not c:
    print(f"check 23 — .gitignore does not hold the anchored line {crg} — code-review-graph's map of the code would be committed (D54)")
elif mode == "source" and all(at(x) for x in c):
    print(f"check 23 — .gitignore holds {crg} only inside a block ({' and '.join(b[1] for b in at(c[0]))}) — every project ignores the map (D54)")
gate = "DATA_STORE == 'external'"
if mode == "source":
    if len(ptr) != 1:
        print(f"check 24 — .gitignore carries the data-root pointer {len(ptr)} times — it carries it once, gated on {gate} (D50)")
    else:
        inner = at(ptr[0])
        if not inner or inner[-1] != ("if", gate):
            print(f"check 24 — .gitignore's data-root pointer is not inside a <: if {gate} :> block (it sits under "
                  f"{(inner[-1][0] + ' ' + inner[-1][1]) if inner else 'no block'}) — it shows under external only, and a store test is an equality")
elif mode in ("external", "repo"):
    want = 1 if mode == "external" else 0
    if len(ptr) != want:
        print(f"check 24 — .gitignore carries the data-root pointer {len(ptr)} times under DATA_STORE {mode}; it carries it "
              f"{'once' if want else 'never'} there (D50)")
PY
}

# Whether a .gitignore ignores code-review-graph's map, asked of git itself in a scratch
# repository, so no other ignore file, global or local, takes part (check 23).
crg_ignored() { # $1 = .gitignore
  local scratch ok=0
  scratch="$(sa_mktemp)"
  git -c init.defaultBranch=main init -q "$scratch" 2>/dev/null && cp "$1" "$scratch/.gitignore" \
    && git -C "$scratch" -c core.excludesFile=/dev/null check-ignore -q --no-index .code-review-graph/graph.db || ok=1
  rm -rf "${scratch:?}"
  return "$ok"
}

# Whether a .gitignore ignores a handoff hook's marker, asked of git the same way (check 27).
marker_ignored() { # $1 = .gitignore
  local scratch ok=0
  scratch="$(sa_mktemp)"
  git -c init.defaultBranch=main init -q "$scratch" 2>/dev/null && cp "$1" "$scratch/.gitignore" \
    && git -C "$scratch" -c core.excludesFile=/dev/null check-ignore -q --no-index .claude/compaction-marker-abc123.tmp || ok=1
  rm -rf "${scratch:?}"
  return "$ok"
}

# Chapter 12's "command": lines that name a handoff hook, against the D29 commands
# family-refresh.json offers (check 28): one problem per line, or nothing.
chapter_commands() { # $1 = the chapter, $2 = family-refresh.json
  python3 - "$1" "$2" <<'PY'
import json, re, sys
try:
    text = open(sys.argv[1], encoding="utf-8").read()
    hooks = (json.load(open(sys.argv[2], encoding="utf-8")).get("settings") or {}).get("hooks") or {}
except Exception:
    sys.exit(0)  # check 21 reports a refresh file that is missing or does not parse
want = {h.get("command") for event in ("UserPromptSubmit", "PreCompact", "SessionStart") for e in hooks.get(event) or []
        if isinstance(e, dict) for h in e.get("hooks") or [] if isinstance(h, dict) and "-handoff.sh" in str(h.get("command"))}
if len(want) != 4:
    sys.exit(0)  # a D29 entry missing from the refresh data is check 12's or check 22's finding
got = set()
for m in re.finditer(r'^[ \t]*"command": ("(?:[^"\\]|\\.)*")[ \t]*,?[ \t]*$', text, re.M):
    try:
        c = json.loads(m.group(1))
    except ValueError:
        print(f"gives a \"command\": line that is not a JSON string ({m.group(1)[:60]})"); continue
    if "-handoff.sh" in c:
        got.add(c)
if got != want:
    gone, odd = sorted(want - got), sorted(got - want)
    print(f"does not give exactly the {len(want)} D29 commands migrations/family-refresh.json offers"
          + (f": {len(gone)} missing, the first {gone[0][:90]!r}" if gone else "")
          + (f"; {len(odd)} not offered, the first {odd[0][:90]!r}" if odd else "")
          + " — the switch to the silent form by hand would be stale")
PY
}

json_gated() { # $1 = file, then specs "+deny X" (must be there) or "-allow X" (must not be)
  python3 - "$@" <<'PY'
import json, sys
path, specs = sys.argv[1], sys.argv[2:]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception:
    sys.exit(0)  # check 12 reports a file that does not parse
perms = data.get("permissions") or {}
for spec in specs:
    sign, kind, rule = spec[0], spec[1:].split(" ", 1)[0], spec[1:].split(" ", 1)[1]
    have = rule in (perms.get(kind) or [])
    if sign == "+" and not have:
        print(f"does not {kind} {rule}, which this variant's answers require")
    elif sign == "-" and have:
        print(f"{kind}s {rule}, which this variant's answers do not ship")
PY
}

# One line per thing tooling/project.mk must not carry (check 17). Block delimiters are removed
# first, so a source seed is read as the line it renders to.
project_mk_problems() { # $1 = file
  sed -E 's/<:([^:]|:[^>])*:>//g' "$1" | awk -v keys=" $PROJECT_MK_KEYS " '
    /^[[:space:]]*(#|$)/ { next }
    /SYNTEK_DATA_ROOT/ { print "names SYNTEK_DATA_ROOT — each machine names its data root in its own environment, never in a project file (D50)"; next }
    match($0, /DATA_(STORE|AREA|SLUG|KIND_[A-Z]+|PROVIDER)/) {
      printf "names the data-root answer %s — the resolver reads it from the answers file, and a copy here goes stale (D50)\n", substr($0, RSTART, RLENGTH); next
    }
    /^\t/ { next }
    /^[[:space:]]*(export[[:space:]]+|override[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*(:::|::|:|\?|\+|!)?=/ {
      k = $0; sub(/^[[:space:]]*(export[[:space:]]+|override[[:space:]]+)?/, "", k); sub(/[[:space:]]*(:::|::|:|\?|\+|!)?=.*$/, "", k)
      if (index(keys, " " k " ") == 0) printf "assigns %s, which is not a D43 setting\n", k
      if ($0 ~ /(=|[[:space:]])(\/home\/|\/Users\/|\/root\/|[A-Za-z]:\\)/) printf "names an absolute path in %s\n", k
      next
    }
    /^[^[:space:]#][^=]*:/ { r = $0; sub(/:.*/, "", r); printf "defines the make rule %s\n", r; next }'
}

tree_checks() { # on TREE
  local f s h line rel d ok e base
  # ── 5 and 6. MEMORY ─────────────────────────────────────────────────────────
  f="$TREE/.claude/MEMORY.md"
  if [[ -f "$f" ]]; then
    for h in "${MEMORY_H2S[@]}"; do
      grep -qx "## $h" "$f" || finding "check 5 — .claude/MEMORY.md has no '## $h' heading"
    done
    while IFS= read -r line; do
      finding "check 6 — .claude/MEMORY.md carries an entry: ${line:0:60}"
    done < <(readable "$f" | grep -E '^[-*] \*\*' || true)
  fi

  # ── 7 and 9. Register seeds ─────────────────────────────────────────────────
  for s in $REGISTER_SEEDS $INDEX_SEEDS; do
    [[ -f "$TREE/$s" ]] || continue
    while IFS= read -r line; do
      finding "check 7 — $s carries an entry ($line) — a seed ships empty"
    done < <(register_entries "$TREE/$s")
  done
  for s in $BRAND_SEEDS; do
    [[ -f "$TREE/$s" ]] || continue
    while IFS= read -r line; do
      finding "check 7 — $s carries an entry ($line) — a seed ships empty"
    done < <(register_entries "$TREE/$s" | grep '^dated entry' || true)
  done
  if [[ -f "$TREE/tooling/seed-refs.sql" ]]; then
    grep -v '^[[:space:]]*--' "$TREE/tooling/seed-refs.sql" | grep -qi '^[[:space:]]*insert' \
      && finding "check 7 — tooling/seed-refs.sql carries an INSERT — the seed ships with its header only"
  fi
  for s in $REGISTER_SEEDS $STYLE_SEEDS; do
    [[ -f "$TREE/$s" ]] || continue
    grep -qiE '^>.*(seeded|cited) stub' "$TREE/$s" || finding "check 9 — $s has no seeded-stub banner"
  done

  # ── 8. voice-notes.md ## Learned ────────────────────────────────────────────
  f="$TREE/standards/style/voice-notes.md"
  if [[ -f "$f" ]]; then
    if ! grep -qx '## Learned' "$f"; then
      finding "check 8 — standards/style/voice-notes.md has no '## Learned' section for learn-voice"
    else
      line="$(readable "$f" | awk '/^## Learned$/ { on = 1; next } on && /^## / { exit } on && /^[-*] |^[0-9]+\. |^### / { print; exit }')"
      [[ -z "$line" ]] || finding "check 8 — the '## Learned' section of voice-notes.md is not empty: ${line:0:60}"
    fi
  fi

  # ── 10. .mcp.json: the two D54 servers ──────────────────────────────────────
  if [[ -f "$TREE/.mcp.json" ]]; then
    if [[ "$TREE" == "$TPL" ]]; then
      [[ "$(cat "$TREE/.mcp.json"; printf x)" == "${SA_MCP_SHARED}x" ]] \
        || finding "check 10 — .mcp.json is not byte for byte the two D54 servers (code-review-graph and scrapling: the 1308 bytes .agents/mcp_config.json shares; DESIGN.md D19, D54)"
    else
      while IFS= read -r line; do finding "check 10 — .mcp.json $line"; done < <(json_check mcp "$TREE/.mcp.json" "$SA_MCP_SHARED")
    fi
  fi

  # ── 23 and 24. The seed .gitignore: code-review-graph's map, the data-root pointer ──
  f="$TREE/.gitignore"
  if [[ -f "$f" ]]; then
    local gmode=unknown
    if [[ "$TREE" == "$TPL" ]]; then gmode=source
    elif load_answers "$TREE/$SA_ANSWERS_FILE"; then gmode="$A_STORE"; fi
    while IFS= read -r line; do finding "$line"; done < <(gitignore_problems "$f" "$gmode")
    if grep -qxF "$SA_CRG_IGNORE_LINE" "$f" && ! crg_ignored "$f"; then
      finding "check 23 — .gitignore does not ignore .code-review-graph/graph.db (git check-ignore) — a later rule re-includes code-review-graph's map (D54)"
    fi
    # ── 27. The handoff hooks' markers ignored (D29) ──
    marker_ignored "$f" \
      || finding "check 27 — .gitignore does not ignore .claude/compaction-marker-abc123.tmp (git check-ignore) — a handoff hook's marker would show in git status and could be committed (D29)"
  fi

  # ── 28. Chapter 12's hand switch: the commands the template offers (D29) ────
  if [[ -f "$TREE/$CH12" && -f "$SA_ROOT/$REFRESH_DATA" ]]; then
    while IFS= read -r line; do finding "check 28 — $CH12 $line"; done < <(chapter_commands "$TREE/$CH12" "$SA_ROOT/$REFRESH_DATA")
  fi

  # ── 11. Pair-only folders ───────────────────────────────────────────────────
  while IFS= read -r -d '' f; do
    rel="${f#./}"; d="$(dirname "$rel")"; base="${rel##*/}"
    ok=false
    for g in $SA_PAIR_ONLY_GLOBS; do
      # shellcheck disable=SC2053  # glob match on purpose
      [[ "$d" == $g ]] && { ok=true; break; }
    done
    $ok || continue
    case "$base" in CONTEXT.md|CLAUDE.md|.gitignore) continue ;; esac
    is_seed "$rel" && continue
    is_example "$rel" && continue
    finding "check 11 — $rel sits in $d/, an author-owned folder that ships its pair only (DESIGN.md Section 3.3)"
  done < <(cd "$TREE" && find . -name .git -prune -o -type f -print0 | sort -z)
  # A pair-only folder may hold a sub-folder only when that is a seed-once example.
  while IFS= read -r -d '' d; do
    rel="${d#./}"
    [[ "$rel" == */* ]] || continue
    is_example "$rel" && continue
    for g in $SA_PAIR_ONLY_GLOBS; do
      # shellcheck disable=SC2053
      if [[ "${rel%/*}" == $g ]]; then
        finding "check 11 — $rel/ is a sub-folder of ${rel%/*}/, which ships its pair only"
        break
      fi
    done
  done < <(cd "$TREE" && find . -name .git -prune -o -type d -print0 | sort -z)

  # ── 14. Index seeds list no entry in their tree ─────────────────────────────
  for s in $INDEX_SEEDS; do
    [[ -f "$TREE/$s" ]] || continue
    while IFS= read -r line; do
      finding "check 14 — $s lists '$line' in its tree — an index seed ships with no entries, only placeholders"
    done < <(tree_entries "$TREE/$s")
  done

  # ── 15. Brand seeds keep their open slots ───────────────────────────────────
  for s in $BRAND_SEEDS; do
    [[ -f "$TREE/$s" ]] || continue
    grep -q 'AUTHOR TO CONFIRM' "$TREE/$s" \
      || finding "check 15 — $s has no open AUTHOR TO CONFIRM slot — a brand seed ships the structure, and every brand fact is the author's call"
  done

  # ── 16. 00-project.md: the five headings, and the project's two sections empty ──
  f="$TREE/$PROJECT_SEED"
  if [[ -f "$f" ]]; then
    for h in "${PROJECT_H2S[@]}"; do
      grep -qx "## $h" "$f" || finding "check 16 — $PROJECT_SEED has no '## $h' heading (DESIGN.md D40)"
    done
    for h in "${PROJECT_EMPTY_H2S[@]}"; do
      awk -v h="## $h" '$0 == h { on = 1; next } on && /^## / { exit } on { print }' "$f" > "$f.section.$$"
      while IFS= read -r line; do
        finding "check 16 — $PROJECT_SEED carries an entry under '## $h' ($line) — that section is the project's to fill"
      done < <(register_entries "$f.section.$$")
      rm -f "$f.section.$$"
    done
  fi

  # ── 17. project.mk: the D43 settings only ───────────────────────────────────
  f="$TREE/$PROJECT_MK"
  if [[ -f "$f" ]]; then
    while IFS= read -r line; do
      finding "check 17 — $PROJECT_MK $line"
    done < <(project_mk_problems "$f")
  fi

  # ── 12. settings.json (in the template, with its gates removed) ─────────────
  f="$TREE/.claude/settings.json"
  if [[ -f "$f" ]] && ! grep -q '<:' "$f"; then
    while IFS= read -r line; do finding "check 12 — .claude/settings.json $line"; done \
      < <(json_check settings "$f" "$SA_ROOT/$REFRESH_DATA" "$SA_GUARD_CMD" "$SA_GUARD_MATCHER" "$SA_GUARD_TIMEOUT" "$SA_MCP_DENY" "$SA_MCP_ASKS")
  elif [[ -f "$f" && "$TREE" == "$TPL" ]]; then
    while IFS= read -r line; do finding "check 12 — .claude/settings.json, its gates removed, $line"; done \
      < <(json_check settings <(strip_blocks "$f") "$SA_ROOT/$REFRESH_DATA" "$SA_GUARD_CMD" "$SA_GUARD_MATCHER" "$SA_GUARD_TIMEOUT" "$SA_MCP_DENY" "$SA_MCP_ASKS")
  fi

  # ── 26. The guide guard and its deny in the seed (D56) ──────────────────────
  if [[ -f "$f" ]] && ! grep -q '<:' "$f"; then
    while IFS= read -r line; do finding "check 26 — .claude/settings.json $line"; done \
      < <(guide_guard_problem "$f" "$SA_ROOT/$REFRESH_DATA")
  elif [[ -f "$f" && "$TREE" == "$TPL" ]]; then
    while IFS= read -r line; do finding "check 26 — .claude/settings.json, its gates removed, $line"; done \
      < <(guide_guard_problem <(strip_blocks "$f") "$SA_ROOT/$REFRESH_DATA")
  fi

  # ── 22. settings.json wires every hook the refresh would add ───────────────
  if [[ -f "$f" ]] && ! grep -q '<:' "$f" && [[ -f "$SA_ROOT/$REFRESH_DATA" ]]; then
    while IFS= read -r line; do finding "check 22 — .claude/settings.json $line"; done < <(hooks_missing "$f" "$SA_ROOT/$REFRESH_DATA")
  fi

  # ── 13. settings.json: the gated permissions, in a render ───────────────────
  if [[ -f "$f" ]] && ! grep -q '<:' "$f" && load_answers "$TREE/$SA_ANSWERS_FILE"; then
    local -a want=()
    if gate_true books;   then want+=("+deny Edit(typeset/src/units/.base/**)"); else want+=("-deny Edit(typeset/src/units/.base/**)"); fi
    if gate_true refs;    then want+=("+allow Bash(sqlite3 tooling/references.db *)"); else want+=("-allow Bash(sqlite3 tooling/references.db *)"); fi
    if gate_true conlang; then want+=("+allow Bash(uv run tooling/font.py *)"); else want+=("-allow Bash(uv run tooling/font.py *)"); fi
    while IFS= read -r line; do finding "check 13 — .claude/settings.json $line"; done < <(json_gated "$f" "${want[@]}")
  fi
}

run_checks() {
  FINDINGS=()
  build_sets "$COPIER"
  [[ "$TREE" == "$TPL" ]] && static_checks
  tree_checks
}

# ── Self-test ────────────────────────────────────────────────────────────────

write_fixture() { # $1 = repo root
  local r="$1" t="$1/template" s banner
  banner='> **This file is a seeded stub, and it is deliberately unfinished.** It ships so the guides that route here point at something real.'
  mkdir -p "$t"
  {
    printf '_exclude:\n  - .git\n'
    for s in $SA_EXAMPLES; do printf '  - "<: if %s :>/%s<: endif :>"\n' "$SA_EXAMPLE_GATE" "$s"; done
    for s in $SA_COPY_ONLY $SA_COPY_ONLY_DIRS $SA_SHARED_REFRESH; do printf '  - "<: if %s :>/%s<: endif :>"\n' "$SA_COPY_ONLY_GATE" "$s"; done
    printf '_skip_if_exists:\n'
    for s in $SA_SEEDS $SA_COPY_ONLY $SA_SHARED_REFRESH; do printf '  - /%s\n' "$s"; done
    printf 'PROJECT_NAME:\n  type: str\n'
  } > "$r/copier.yml"
  for s in $SA_SEEDS; do mkdir -p "$(dirname "$t/$s")"; printf '# %s\n' "${s##*/}" > "$t/$s"; done
  for s in $SA_COPY_ONLY $SA_SHARED_REFRESH; do
    [[ "$s" == .agents/skills ]] && continue
    mkdir -p "$(dirname "$t/$s")"; printf '{}\n' > "$t/$s"
  done
  for s in $SA_SHARED_HOOKS; do chmod +x "$t/$s"; done
  # This template's own how-to folders (D56), template-owned: a chapter in each.
  for s in $SA_HOWTO_OWN; do mkdir -p "$t/$s"; printf '# A chapter — of this template\n' > "$t/$s/01-a.md"; done
  mkdir -p "$r/migrations"
  python3 - "$r/$REFRESH_DATA" "$SA_SHARED_REFRESH" "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" "$t/$CH12" <<'JSON'
import json, sys
hook = lambda name, arg="": [{"type": "command", "command": f"bash .claude/hooks/{name}{arg}"}]
json.dump({"format": 1, "template": "syntek-author", "refresh": sys.argv[2].split(), "restore": ["how-to"],
           "settings": {"hooks": {"PreCompact": [{"matcher": "auto", "hooks": hook("pre-compact-handoff.sh", " auto")},
                                                 {"matcher": "manual", "hooks": hook("pre-compact-handoff.sh", " manual")}],
                                  "PreToolUse": [{"matcher": sys.argv[3], "hooks": [{"type": "command", "command": sys.argv[4], "timeout": 10}]}],
                                  "SessionStart": [{"matcher": "compact", "hooks": hook("pre-compact-handoff.sh", " compacted")}],
                                  "UserPromptSubmit": [{"hooks": hook("context-threshold-handoff.sh")}]},
                        "permissions": {"deny": [sys.argv[5]], "ask": []},
                        "autoCompactEnabled": False, "idleCompaction": False, "outputStyle": "Concise"}}, open(sys.argv[1], "w"), indent=2)
d = json.load(open(sys.argv[1]))["settings"]["hooks"]
lines = ['"command": %s,' % json.dumps(h["command"]) for ev in ("UserPromptSubmit", "PreCompact", "SessionStart") for e in d[ev] for h in e["hooks"]]
with open(sys.argv[6], "w", encoding="utf-8") as f:
    f.write("# Troubleshooting\n\nReplace each with the line below:\n\n```text\n" + "\n".join(lines) + "\n```\n")
JSON
  ln -s "$SA_AGENTS_LINK_TARGET" "$t/.agents/skills"
  printf '%s' "$SA_MCP_SHARED" > "$t/.agents/mcp_config.json"
  for s in $REGISTER_SEEDS; do
    printf '# %s\n\n%s\n\n## Register\n\n| Name | Notes |\n|---|---|\n| _No entries yet._ | |\n' "${s##*/}" "$banner" > "$t/$s"
  done
  printf '# Style sheet\n\n%s\n\n## Spelling\n\n- Use -ise endings.\n' "$banner" > "$t/standards/style/style-sheet.md"
  printf '# Voice notes\n\n%s\n\n## Marks\n\n- A rule.\n\n## Learned\n\n_Nothing learned yet._\n' "$banner" > "$t/standards/style/voice-notes.md"
  { printf '# MEMORY.md\n\nTo add an entry: `- **DD/MM/YYYY** — **Headline.** Body.`\n\n'
    for s in "${MEMORY_H2S[@]}"; do printf '## %s\n\n_No entries yet._\n\n' "$s"; done; } > "$t/.claude/MEMORY.md"
  printf -- '-- seed-refs.sql: header only.\n' > "$t/tooling/seed-refs.sql"
  for s in $BRAND_SEEDS; do
    printf '# %s\n\n## Colour\n\n| Role | Preamble name | Value |\n|---|---|---|\n| Body | `housebody` | <!-- AUTHOR TO CONFIRM: hex --> |\n' "${s##*/}" > "$t/$s"
  done
  cat > "$t/$PROJECT_SEED" <<'EOF'
# 00-project.md — Probe Project

## Brief

| Setting | Value |
|---|---|
| Audience | client |

## Paths

| What | Where |
|---|---|
| Brand folder | `standards/brand/` |

## Memory headings

| Template heading | This project's heading |
|---|---|
| Facts | Facts |

## Workflow aliases

| Template workflow | Use instead |
|---|---|
| — | — |

## Overrides

| Rule | Override |
|---|---|
| — | — |
EOF
  printf '# project.mk — build settings.\nLOGO_DIRS ?= assets//\nFLAG_EXTRA_RE ?=\nISSUE_STATUSES ?= final\nMAINFONT ?=\n' > "$t/$PROJECT_MK"
  printf '# CONTEXT.md\n\n```text\nplanning/workflows/local/\n├── CONTEXT.md\n├── CLAUDE.md\n└── NN-verb-first-name/   ← one folder per procedure\n    └── STEPS.md\n```\n\n| You want to… | Procedure |\n|---|---|\n| *(no local procedures yet)* | — |\n' > "$t/planning/workflows/local/CONTEXT.md"
  printf '# CONTEXT.md\n\n```text\nplanning/docs/project/\n├── CONTEXT.md\n└── <question>.md\n```\n' > "$t/planning/docs/project/CONTEXT.md"
  printf '%s' "$SA_MCP_SHARED" > "$t/.mcp.json"
  # The seed settings.json: the D29 hooks as family-refresh.json offers them, D54's deny and asks,
  # the data-root guard as the first PreToolUse entry (D50), and the guide guard as the second,
  # with its deny straight after Edit(build/**) (D56).
  python3 - "$t/.claude/settings.json" "$SA_GUARD_MATCHER" "$SA_GUARD_CMD" "$SA_MCP_DENY" "$SA_MCP_ASKS" \
    "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" <<'JSON'
import json, sys
path, matcher, guard, deny, asks, gmatcher, gcmd, gdeny = sys.argv[1:9]
hook = lambda c: [{"type": "command", "command": c}]
json.dump({"model": "opus", "autoCompactEnabled": False, "idleCompaction": False, "outputStyle": "Concise",
           "hooks": {"UserPromptSubmit": [{"hooks": hook("bash .claude/hooks/context-threshold-handoff.sh")}],
                     "PreCompact": [{"matcher": "auto", "hooks": hook("bash .claude/hooks/pre-compact-handoff.sh auto")},
                                    {"matcher": "manual", "hooks": hook("bash .claude/hooks/pre-compact-handoff.sh manual")}],
                     "SessionStart": [{"matcher": "compact", "hooks": hook("bash .claude/hooks/pre-compact-handoff.sh compacted")}],
                     "PreToolUse": [{"matcher": matcher, "hooks": [{"type": "command", "command": guard, "timeout": 10}]},
                                    {"matcher": gmatcher, "hooks": [{"type": "command", "command": gcmd, "timeout": 10}]}]},
           "permissions": {"deny": ["AskUserQuestion", "Edit(**/*.pdf)", "Edit(build/**)", gdeny, deny], "ask": asks.split(),
                           "allow": ["Bash(make *)"]}},
          open(path, "w", encoding="utf-8"), indent=2)
JSON
  # The seed .gitignore: code-review-graph's map ignored in every project, and the data-root
  # pointer under external only.
  { printf 'build/\n\n<: if INCLUDE_REFERENCES :># the references database\n<: else :># a database\n<: endif :>*.db-journal\n\n'
    printf '%s\n\n/.claude/compaction-marker-*.tmp\n\n' "$SA_CRG_IGNORE_LINE"
    printf "<: if DATA_STORE == 'external' :># ----\n%s\n# the binaries are filed under the data root\n\n<: endif :># ----\n.DS_Store\n" "$SA_GITIGNORE_DATAROOT_LINE"
  } > "$t/.gitignore"
  for s in $SA_EXAMPLES; do
    case "$s" in *.md) mkdir -p "$(dirname "$t/$s")"; printf '# Example\n' > "$t/$s" ;;
                 *) mkdir -p "$t/$s"; printf '# Example\n' > "$t/$s/CONTEXT.md" ;; esac
  done
  mkdir -p "$t/handoffs" "$t/learning"; printf '# x\n' > "$t/handoffs/CONTEXT.md"; printf '# x\n' > "$t/handoffs/CLAUDE.md"
}

self_test() {
  local tmp real_root="$SA_ROOT" real_tpl="$TPL" real_copier="$COPIER" t
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  command -v python3 >/dev/null 2>&1 || die "python3 is not installed"
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  write_fixture "$tmp"
  SA_ROOT="$tmp"; TPL="$tmp/template"; COPIER="$tmp/copier.yml"; TREE="$TPL"; SA_SETS_FOR=""
  t="$TPL"
  st_baseline "a fixture with every seed in shape"

  cp "$COPIER" "$tmp/c"
  grep -vxF '  - /planning/src/outline.md' "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 1 fires when a seed leaves _skip_if_exists" "check 1 — planning/src/outline.md"
  cp "$tmp/c" "$COPIER"
  awk '/^_skip_if_exists:/ { print; print "  - /planning/src/ghost.md"; next } { print }' "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 2 fires on a seed that is not on disk" "check 2 — _skip_if_exists lists /planning/src/ghost.md"
  cp "$tmp/c" "$COPIER"
  grep -vF '/world/src/languages/example-tongue<' "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 3 fires when an example loses its copy-only line" "check 3 — the example world/src/languages/example-tongue"
  cp "$tmp/c" "$COPIER"
  grep -vxF '  - /opencode.json' "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 18 fires when a copy-only path loses its skip line" "check 18 — the copy-only opencode.json is not in _skip_if_exists"
  cp "$tmp/c" "$COPIER"
  grep -vF "'update' :>/GEMINI.md<" "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 18 fires when a copy-only path loses its update exclusion" "check 18 — the copy-only GEMINI.md has no _exclude line"
  cp "$tmp/c" "$COPIER"
  grep -vF "'update' :>/.agents<" "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 19 fires when a copy-only folder loses its update exclusion" "check 19 — the folder .agents/"
  cp "$tmp/c" "$COPIER"; SA_SETS_FOR=""
  mv "$t/.agents" "$t/.agents-real"; ln -s .agents-real "$t/.agents"
  probe "check 20 fires when .agents is a link" "check 20 — template/.agents is a link"
  rm "$t/.agents"; mv "$t/.agents-real" "$t/.agents"
  rm "$t/.agents/skills"; mkdir "$t/.agents/skills"; printf 'x\n' > "$t/.agents/skills/CONTEXT.md"
  probe "check 20 fires when .agents/skills is a copy" "check 20 — template/.agents/skills is not a link"
  rm -rf "$t/.agents/skills"; ln -s "$SA_AGENTS_LINK_TARGET" "$t/.agents/skills"
  printf '%s' "$SA_MEDIA04_AGENTS_MCP" > "$t/.agents/mcp_config.json"
  probe "check 20 fires when Antigravity's MCP file is not .mcp.json's bytes" "check 20 — template/.agents/mcp_config.json is not the same bytes as .mcp.json"
  printf '%s' "$SA_MCP_SHARED" > "$t/.agents/mcp_config.json"
  printf '%s' "$SA_MCP_SHARED" > "$t/.claude/mcp_config.json"
  probe "check 20 fires when the retired .claude/mcp_config.json ships" "check 20 — template/.claude/mcp_config.json is retired"
  rm -f "$t/.claude/mcp_config.json"
  cp "$COPIER" "$tmp/c"; grep -vxF '  - /.claude/skills/wayfinder/SKILL.md' "$tmp/c" > "$COPIER"; SA_SETS_FOR=""
  probe "check 18 fires when a shared skill loses its skip line" "check 18 — the copy-only .claude/skills/wayfinder/SKILL.md is not in _skip_if_exists"
  cp "$tmp/c" "$COPIER"; SA_SETS_FOR=""
  chmod -x "$t/.claude/hooks/context-threshold-handoff.sh"
  probe "check 21 fires on a shared hook that is not executable" "check 21 — template/.claude/hooks/context-threshold-handoff.sh is not executable"
  chmod +x "$t/.claude/hooks/context-threshold-handoff.sh"
  sed -i 's#^_skip_if_exists:$#&\n  - /.claude/skills/handoff#' "$COPIER"; SA_SETS_FOR=""
  probe "check 21 fires on a folder-level copy-only line" "check 21 — copier.yml names the folder .claude/skills/handoff copy-only"
  cp "$tmp/c" "$COPIER"; SA_SETS_FOR=""; cp "$SA_ROOT/$REFRESH_DATA" "$tmp/rd"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["refresh"].remove("handoffs/CLAUDE.md"); json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 21 fires when family-refresh.json leaves a shared file out" "check 21 — $REFRESH_DATA does not refresh exactly"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"; cp "$t/.claude/settings.json" "$tmp/h"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["hooks"]["UserPromptSubmit"]; json.dump(d,open(sys.argv[1],"w"),indent=2)' "$t/.claude/settings.json"
  probe "check 22 fires when the seed settings do not wire the threshold hook" "check 22 — .claude/settings.json does not wire the UserPromptSubmit hook running .claude/hooks/context-threshold-handoff.sh"
  cp "$tmp/h" "$t/.claude/settings.json"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["hooks"]["SessionStart"]; json.dump(d,open(sys.argv[1],"w"),indent=2)' "$t/.claude/settings.json"
  probe "check 22 fires when the seed settings do not wire the note after a compaction" "check 22 — .claude/settings.json does not wire the SessionStart hook for compact running .claude/hooks/pre-compact-handoff.sh"
  cp "$tmp/h" "$t/.claude/settings.json"; cp "$SA_ROOT/$REFRESH_DATA" "$tmp/rd"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["permissions"]["deny"].append("Bash(git push --force *)"); json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 22 fires when family-refresh.json lists a rule the seed does not hold" "check 22 — template/.claude/settings.json does not hold the deny rule Bash(git push --force *)"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["autoCompactEnabled"]=True; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 22 fires when family-refresh.json lists a top-level value the seed does not hold" "check 22 — template/.claude/settings.json does not hold the top-level \"autoCompactEnabled\": true"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["idleCompaction"]=True; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 22 fires when family-refresh.json lists an idleCompaction the seed does not hold" "check 22 — template/.claude/settings.json does not hold the top-level \"idleCompaction\": true"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["settings"]["idleCompaction"]; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 12 fires when family-refresh.json does not list the seed's idleCompaction" "check 12 — .claude/settings.json sets idleCompaction, which migrations/family-refresh.json does not list"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["settings"]["outputStyle"]; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 12 fires when family-refresh.json does not list the seed's outputStyle" "check 12 — .claude/settings.json sets outputStyle, which migrations/family-refresh.json does not list"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["outputStyle"]="Explanatory"; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 22 fires when family-refresh.json lists an outputStyle the seed does not hold" "check 22 — template/.claude/settings.json does not hold the top-level \"outputStyle\": \"Explanatory\""
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["settings"]["hooks"]["SessionStart"]; json.dump(d,open(sys.argv[1],"w"))' "$SA_ROOT/$REFRESH_DATA"
  probe "check 12 fires when family-refresh.json does not offer the seed's SessionStart entry" "check 12 — .claude/settings.json wires the D29 SessionStart hook, which migrations/family-refresh.json does not offer"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  cp "$t/$CH12" "$tmp/ch12"; sed -i 's/ compacted",$/ compact",/' "$t/$CH12"
  probe "check 28 fires when chapter 12 gives a stale command" "check 28 — $CH12 does not give exactly the 4 D29 commands migrations/family-refresh.json offers: 1 missing"
  cp "$tmp/ch12" "$t/$CH12"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["hooks"]["PreToolUse"].append({"matcher": sys.argv[2], "hooks": [{"type": "command", "command": sys.argv[3], "timeout": 10}]}); json.dump(d,open(sys.argv[1],"w"))' \
    "$SA_ROOT/$REFRESH_DATA" "$SA_GUARD_MATCHER" "$SA_GUARD_CMD"
  probe "check 22 fires when family-refresh.json lists the data-root guard" "check 22 — migrations/family-refresh.json lists the data-root guard"
  cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  probe_clean "family-refresh.json may list the guide guard's PreToolUse entry (D56)"
  cp "$COPIER" "$tmp/c"; sed -i 's#^_skip_if_exists:$#&\n  - /how-to/src/TEMPLATE-GUIDE/syntek-author#' "$COPIER"; SA_SETS_FOR=""
  probe "check 25 fires on a folder line under how-to/" "check 25 — _skip_if_exists names /how-to/src/TEMPLATE-GUIDE/syntek-author"
  cp "$tmp/c" "$COPIER"; SA_SETS_FOR=""
  mv "$t/planning/src/units/example-proposal.md" "$tmp/h"
  probe "check 4 fires when an example is missing" "check 4"
  mv "$tmp/h" "$t/planning/src/units/example-proposal.md"

  cp "$t/.claude/MEMORY.md" "$tmp/h"
  sed -i '/^## Sensitivities$/d' "$t/.claude/MEMORY.md";      probe "check 5 fires when a MEMORY heading is lost" "check 5"; cp "$tmp/h" "$t/.claude/MEMORY.md"
  printf -- '- **01/01/2030** — **Robin prefers tabs.** Not so.\n' >> "$t/.claude/MEMORY.md"; probe "check 6 fires on a MEMORY entry" "check 6"; cp "$tmp/h" "$t/.claude/MEMORY.md"
  cp "$t/world/src/names-register.md" "$tmp/h"
  printf '| Varn | river |\n' >> "$t/world/src/names-register.md"; probe "check 7 fires on a filled register row" "check 7 — world/src/names-register.md"; cp "$tmp/h" "$t/world/src/names-register.md"
  printf "INSERT INTO refs VALUES ('x');\n" >> "$t/tooling/seed-refs.sql"; probe "check 7 fires on a seeded reference row" "check 7 — tooling/seed-refs.sql"; printf -- '-- header only.\n' > "$t/tooling/seed-refs.sql"
  cp "$t/standards/style/voice-notes.md" "$tmp/h"
  printf -- '- Prefers short sentences.\n' >> "$t/standards/style/voice-notes.md"; probe "check 8 fires on a learned entry in the seed" "check 8"; cp "$tmp/h" "$t/standards/style/voice-notes.md"
  sed -i '/seeded stub/d' "$t/planning/src/outline.md";       probe "check 9 fires when a banner is lost" "check 9 — planning/src/outline.md"
  printf '# outline.md\n\n> **This file is a seeded stub, and it is deliberately unfinished.**\n\n## Register\n' > "$t/planning/src/outline.md"
  printf '{"mcpServers": {"elevenlabs": {}}}\n' > "$t/.mcp.json";  probe "check 10 fires on a server in .mcp.json" "check 10 — .mcp.json is not byte for byte the two D54 servers"; printf '%s' "$SA_MCP_SHARED" > "$t/.mcp.json"
  printf '# a handoff\n' > "$t/handoffs/HANDOFF-X-01-01-2027.md";  probe "check 11 fires on a file in a pair-only folder" "check 11 — handoffs/HANDOFF-X"; rm -f "$t/handoffs/HANDOFF-X-01-01-2027.md"
  mkdir -p "$t/learning/a-topic";                                   probe "check 11 fires on a sub-folder in a pair-only folder" "check 11 — learning/a-topic/"; rmdir "$t/learning/a-topic"
  cp "$t/.claude/settings.json" "$tmp/h"
  # The refresh data offers the same value, so only check 12's rule (false, D29) is broken.
  cp "$SA_ROOT/$REFRESH_DATA" "$tmp/rd"
  sed -i 's/"autoCompactEnabled": false/"autoCompactEnabled": true/' "$t/.claude/settings.json" "$SA_ROOT/$REFRESH_DATA"; probe "check 12 fires when compaction is switched on" "check 12"; cp "$tmp/h" "$t/.claude/settings.json"; cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  sed -i 's/"idleCompaction": false/"idleCompaction": true/' "$t/.claude/settings.json" "$SA_ROOT/$REFRESH_DATA"; probe "check 12 fires when idle compaction is switched on" "check 12 — .claude/settings.json idleCompaction is not false"; cp "$tmp/h" "$t/.claude/settings.json"; cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  # The seed with another style, offered the same by the refresh data (only check 12's pin breaks),
  # and the seed and the refresh data without one (only check 12's pin again).
  sed -i 's/"outputStyle": "Concise"/"outputStyle": "Explanatory"/' "$t/.claude/settings.json" "$SA_ROOT/$REFRESH_DATA"; probe "check 12 fires when the seed's output style is not Concise" "check 12 — .claude/settings.json outputStyle is 'Explanatory', not 'Concise'"; cp "$tmp/h" "$t/.claude/settings.json"; cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d.pop("outputStyle", None); d.get("settings", {}).pop("outputStyle", None); json.dump(d,open(sys.argv[1],"w"),indent=2)' "$t/.claude/settings.json"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"].pop("outputStyle", None); json.dump(d,open(sys.argv[1],"w"),indent=2)' "$SA_ROOT/$REFRESH_DATA"
  probe "check 12 fires when the seed sets no output style" "check 12 — .claude/settings.json outputStyle is None, not 'Concise'"; cp "$tmp/h" "$t/.claude/settings.json"; cp "$tmp/rd" "$SA_ROOT/$REFRESH_DATA"
  settings_edit() { python3 -c "import json, sys; d = json.load(open(sys.argv[1])); $1; json.dump(d, open(sys.argv[1], 'w'), indent=2)" "$t/.claude/settings.json" "${@:2}"; }
  settings_edit 'h = d["hooks"]["PreToolUse"][0]["hooks"][0]; h["command"] = h["command"].replace(" || exit 0", "")'
  probe "check 12 fires when the guard is not the merged seed's command" "check 12 — .claude/settings.json does not wire the data-root guard exactly"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["hooks"]["PreToolUse"].append(d["hooks"]["PreToolUse"][0])'
  probe "check 12 fires on a second PreToolUse entry that runs the data-root guard" "check 12 — .claude/settings.json has 2 PreToolUse entries that run the data-root guard"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'p = d["hooks"]["PreToolUse"]; p[0], p[1] = p[1], p[0]'
  probe "check 12 fires when the data-root guard is not the first PreToolUse entry" "check 12 — .claude/settings.json wires the data-root guard as PreToolUse entry 2, not the first"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'h = d["hooks"]["PreToolUse"][1]["hooks"][0]; h["command"] = h["command"].replace("|| exit 0", "&&", 1)'
  probe "check 26 fires when the guide guard's command is not the self-locating form" "check 26 — .claude/settings.json does not wire the guide guard exactly"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["hooks"]["PreToolUse"][1]["hooks"][0]["timeout"] = 5'
  probe "check 26 fires when the guide guard's timeout changes" "check 26 — .claude/settings.json does not wire the guide guard exactly"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'x = d["permissions"]["deny"]; x.remove(sys.argv[2]); x.insert(x.index("Edit(build/**)"), sys.argv[2])' "$SA_HOWTO_DENY"
  probe "check 26 fires when the guide's deny is not straight after Edit(build/**)" "check 26 — .claude/settings.json does not deny $SA_HOWTO_DENY directly after Edit(build/**)"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["hooks"]["PreToolUse"][0]["matcher"] = "Edit|Write"'
  probe "check 12 fires when the guard misses the search tools" "check 12 — .claude/settings.json wires its PreToolUse entry for 'Edit|Write'"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'a = d["permissions"]["ask"]; a[0], a[1] = a[1], a[0]'
  probe "check 12 fires when the asks lose their order" "check 12 — .claude/settings.json does not ask for exactly the eight D54 tools"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["permissions"]["deny"].remove(sys.argv[2])' "$SA_MCP_DENY"
  probe "check 12 fires when the embedding tool is not denied" "check 12 — .claude/settings.json does not deny $SA_MCP_DENY"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["hooks"]["UserPromptSubmit"][0]["hooks"][0]["command"] += " --quiet"'
  probe "check 12 fires when a D29 hook changes" "check 12 — .claude/settings.json changes the D29 UserPromptSubmit hook"
  cp "$tmp/h" "$t/.claude/settings.json"
  settings_edit 'd["hooks"]["SessionStart"][0]["hooks"][0]["command"] = d["hooks"]["SessionStart"][0]["hooks"][0]["command"].replace(" compacted", " manual")'
  probe "check 12 fires when the note after a compaction changes" "check 12 — .claude/settings.json changes the D29 SessionStart hook"
  cp "$tmp/h" "$t/.claude/settings.json"
  python3 - "$t/.claude/settings.json" <<'GATE'
import sys
p = sys.argv[1]
text = open(p).read().replace('"Edit(build/**)",', '"Edit(build/**)",<: if DOC_TYPE != \'business\' :>\n      "Edit(typeset/src/units/.base/**)",<: endif :>', 1)
open(p, "w").write(text)
GATE
  probe_clean "check 12 reads the seed source with its gates removed"
  python3 - "$t/.claude/settings.json" <<'GATE'
import sys
# The comma moved inside the gate: the profile that shuts it renders two list items with none
# between them (the source reads '"Edit(build/**)"<: if … :>,' and '…)"<: endif :>').
p = sys.argv[1]
text = open(p).read()
text = text.replace('"Edit(build/**)",<: if DOC_TYPE', '"Edit(build/**)"<: if DOC_TYPE', 1)
text = text.replace(" :>\n      \"Edit(typeset/src/units/.base/**)\",<: endif :>", " :>,\n      \"Edit(typeset/src/units/.base/**)\"<: endif :>", 1)
open(p, "w").write(text)
GATE
  probe "check 12 fires when the seed source does not parse with its gates removed" "check 12 — .claude/settings.json, its gates removed, is not valid JSON"
  cp "$tmp/h" "$t/.claude/settings.json"
  printf 'DOC_TYPE: business\nINCLUDE_REFERENCES: false\n' > "$t/$SA_ANSWERS_FILE"
  probe_clean "check 13 holds a business render that carries none of the gated permissions"
  sed -i 's/^DOC_TYPE: business/DOC_TYPE: theology/' "$t/$SA_ANSWERS_FILE"
  probe "check 13 fires when a book render does not deny edits to the Pandoc bases" "check 13 — .claude/settings.json does not deny Edit(typeset/src/units/.base/**)"
  sed -i 's/^DOC_TYPE: theology/DOC_TYPE: business/' "$t/$SA_ANSWERS_FILE"
  settings_edit 'd["permissions"]["allow"].append("Bash(uv run tooling/font.py *)")'
  probe "check 13 fires on the font allow outside the conlang" "check 13 — .claude/settings.json allows Bash(uv run tooling/font.py *)"
  cp "$tmp/h" "$t/.claude/settings.json"; rm -f "$t/$SA_ANSWERS_FILE"
  cp "$t/planning/workflows/local/CONTEXT.md" "$tmp/h"
  printf '| prepare a reading | `01-prepare-a-reading/` |\n' >> "$t/planning/workflows/local/CONTEXT.md"
  probe "check 7 fires on a filled row in an index seed" "check 7 — planning/workflows/local/CONTEXT.md"; cp "$tmp/h" "$t/planning/workflows/local/CONTEXT.md"
  cp "$t/planning/docs/project/CONTEXT.md" "$tmp/h"
  sed -i 's/^└── <question>.md$/├── <question>.md\n└── house-notes.md/' "$t/planning/docs/project/CONTEXT.md"
  probe "check 14 fires on a guide listed in an index seed's tree" "check 14 — planning/docs/project/CONTEXT.md lists 'house-notes.md'"; cp "$tmp/h" "$t/planning/docs/project/CONTEXT.md"
  cp "$t/standards/brand/brand-guide.md" "$tmp/h"
  sed -i 's/<!-- AUTHOR TO CONFIRM: hex -->/#1A2B3C/' "$t/standards/brand/brand-guide.md"
  probe "check 15 fires on a brand seed with every slot filled" "check 15 — standards/brand/brand-guide.md"; cp "$tmp/h" "$t/standards/brand/brand-guide.md"
  cp "$t/$PROJECT_SEED" "$tmp/h"
  sed -i '/^## Overrides$/d' "$t/$PROJECT_SEED"
  probe "check 16 fires when 00-project.md loses a heading" "check 16 — $PROJECT_SEED has no '## Overrides'"; cp "$tmp/h" "$t/$PROJECT_SEED"
  awk '/^## Workflow aliases$/ { on = 1 } on && /^\| — \| — \|$/ { print "| 05-review-a-document | our-review-procedure |"; on = 0; next } { print }' "$tmp/h" > "$t/$PROJECT_SEED"
  probe "check 16 fires on a workflow alias shipped in the seed" "check 16 — $PROJECT_SEED carries an entry under '## Workflow aliases'"; cp "$tmp/h" "$t/$PROJECT_SEED"
  cp "$t/$PROJECT_MK" "$tmp/h"
  printf 'CLIENT_NAME := Example Client Ltd\n' >> "$t/$PROJECT_MK"
  probe "check 17 fires on a setting D43 does not name" "check 17 — $PROJECT_MK assigns CLIENT_NAME"; cp "$tmp/h" "$t/$PROJECT_MK"
  printf 'publish:\n\t@echo sent\n' >> "$t/$PROJECT_MK"
  probe "check 17 fires on a make rule in the seed" "check 17 — $PROJECT_MK defines the make rule publish"; cp "$tmp/h" "$t/$PROJECT_MK"
  printf 'MAINFONT := /home/someone/fonts/body.otf\n' >> "$t/$PROJECT_MK"
  probe "check 17 fires on an absolute path" "check 17 — $PROJECT_MK names an absolute path"; cp "$tmp/h" "$t/$PROJECT_MK"
  printf 'SYNTEK_DATA_ROOT ?= /srv/data-root\n' >> "$t/$PROJECT_MK"
  probe "check 17 fires when project.mk sets the data root" "check 17 — $PROJECT_MK names SYNTEK_DATA_ROOT"; cp "$tmp/h" "$t/$PROJECT_MK"
  printf 'LOGO_DIRS ?= assets/<%% DATA_SLUG %%>\n' >> "$t/$PROJECT_MK"
  probe "check 17 fires when project.mk carries a data-root answer" "check 17 — $PROJECT_MK names the data-root answer DATA_SLUG"; cp "$tmp/h" "$t/$PROJECT_MK"

  cp "$t/.gitignore" "$tmp/h"
  grep -vxF "$SA_CRG_IGNORE_LINE" "$tmp/h" > "$t/.gitignore"
  probe "check 23 fires when the seed .gitignore does not ignore code-review-graph's map" "check 23 — .gitignore does not hold the anchored line"
  sed "s#^$SA_CRG_IGNORE_LINE\$#<: if INCLUDE_REFERENCES :>$SA_CRG_IGNORE_LINE\n<: endif :>#" "$tmp/h" > "$t/.gitignore"
  probe "check 23 fires when the map is ignored only in some projects" "check 23 — .gitignore holds $SA_CRG_IGNORE_LINE only inside a block (INCLUDE_REFERENCES)"
  { cat "$tmp/h"; printf '!/.code-review-graph/\n'; } > "$t/.gitignore"
  probe "check 23 fires when a later rule re-includes the map" "check 23 — .gitignore does not ignore .code-review-graph/graph.db"
  grep -vxF '/.claude/compaction-marker-*.tmp' "$tmp/h" > "$t/.gitignore"
  probe "check 27 fires when the seed .gitignore does not ignore the markers" "check 27 — .gitignore does not ignore .claude/compaction-marker-abc123.tmp"
  sed "s#^<: if DATA_STORE == 'external' :>##; s#^<: endif :>\# ----#\# ----#" "$tmp/h" > "$t/.gitignore"
  probe "check 24 fires when the data-root pointer is not gated" "check 24 — .gitignore's data-root pointer is not inside a <: if DATA_STORE == 'external' :> block (it sits under no block)"
  sed "s#DATA_STORE == 'external' :>#DATA_STORE != 'repo' :>#" "$tmp/h" > "$t/.gitignore"
  probe "check 24 fires when the pointer's gate is not an equality" "check 24 — .gitignore's data-root pointer is not inside a <: if DATA_STORE == 'external' :> block (it sits under if DATA_STORE != 'repo')"
  { cat "$tmp/h"; printf '%s\n' "$SA_GITIGNORE_DATAROOT_LINE"; } > "$t/.gitignore"
  probe "check 24 fires when the pointer is carried twice" "check 24 — .gitignore carries the data-root pointer 2 times"
  cp "$tmp/h" "$t/.gitignore"

  # A render: .mcp.json compared by its servers, the .gitignore by its store.
  local r="$tmp/render"
  mkdir -p "$r/.claude"
  python3 -c 'import json, sys; print(json.dumps(json.loads(sys.argv[1]), indent=4))' "$SA_MCP_SHARED" > "$r/.mcp.json"
  cp "$t/.claude/settings.json" "$r/.claude/settings.json"
  printf 'build/\n*.tmp\n\n%s\n\n# ----\n%s\n\n# ----\n' "$SA_CRG_IGNORE_LINE" "$SA_GITIGNORE_DATAROOT_LINE" > "$r/.gitignore"
  printf 'DOC_TYPE: business\nINCLUDE_REFERENCES: false\nDATA_STORE: external\n' > "$r/$SA_ANSWERS_FILE"
  TREE="$r"
  probe_clean "a render whose .mcp.json declares the two servers in its own layout, the pointer under external"
  printf '{"mcpServers": {"elevenlabs": {}}}\n' > "$r/.mcp.json"
  probe "check 10 fires on another server in a render's .mcp.json" "check 10 — .mcp.json does not declare exactly the two D54 servers as the template ships them (it declares elevenlabs"
  printf '%s' "$SA_MCP_SHARED" > "$r/.mcp.json"
  sed -i 's/^DATA_STORE: external$/DATA_STORE: repo/' "$r/$SA_ANSWERS_FILE"
  probe "check 24 fires when a repo render carries the data-root pointer" "check 24 — .gitignore carries the data-root pointer 1 times under DATA_STORE repo"
  sed -i 's/^DATA_STORE: repo$/DATA_STORE: external/' "$r/$SA_ANSWERS_FILE"
  grep -vxF "$SA_GITIGNORE_DATAROOT_LINE" "$r/.gitignore" > "$tmp/g"; cp "$tmp/g" "$r/.gitignore"
  probe "check 24 fires when an external render lacks the data-root pointer" "check 24 — .gitignore carries the data-root pointer 0 times under DATA_STORE external"
  TREE="$t"

  SA_ROOT="$real_root"; TPL="$real_tpl"; COPIER="$real_copier"; SA_SETS_FOR=""
  st_finish "wired, empty seeds from polluted or unwired ones"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$COPIER" ]] || die "no copier.yml at $SA_ROOT"
[[ -d "$TPL" ]] || die "no template/ directory at $SA_ROOT"
command -v python3 >/dev/null 2>&1 || die "python3 is not installed"

bold "▸ $SCRIPT_NAME"
STATUS=0
for target in "$TPL" "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREE="$(cd "$target" && pwd)"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $TREE — seeds wired and empty, pair-only folders clean"
  else
    bold "✗ $TREE — ${#FINDINGS[@]} finding(s):"
    print_findings
    STATUS=1
  fi
done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ Every seed is wired and ships empty; every author-owned folder ships its pair only."
  exit 0
fi
log "  A polluted seed is a one-way door: no update can retract it (SB rule 21)."
exit 1
