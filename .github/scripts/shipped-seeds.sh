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
#                    Seventeen checks:
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
#                     10. .mcp.json is exactly {"mcpServers": {}} (DESIGN.md D19).
#                     11. A pair-only folder holds something other than its pair, a nested
#                         .gitignore, a declared seed or a seed-once example.
#                     12. .claude/settings.json breaks DESIGN.md Section 4.1: model opus,
#                         autoCompactEnabled false, PreCompact hooks for auto and manual,
#                         denies AskUserQuestion, Edit(**/*.pdf), Edit(build/**), and no
#                         owner-specific key (effortLevel, ultracode, enabledPlugins, disable*).
#                         Read only where the file is plain JSON (a render, or a source with no
#                         block in it).
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
#                         else in it is a project's build shipped to every project.
#
#                    Checks 1–4 read copier.yml and template/ (static, once). Checks 5–17 read
#                    every tree given — template/ by default, or renders — and skip a seed the
#                    tree does not ship.
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
# Requirements: bash 4+, grep, awk, python3 (checks 10 and 12). No network.
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

  <tree>       A render to check as well (checks 5–15); template/ is always checked
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
}

json_check() { # $1 = mode (mcp|settings), $2 = file → prints one problem per line
  python3 - "$1" "$2" <<'PY'
import json, sys
mode, path = sys.argv[1], sys.argv[2]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception as exc:
    print(f"is not valid JSON ({exc.__class__.__name__})"); sys.exit(0)
if mode == "mcp":
    if data != {"mcpServers": {}}:
        print('is not exactly {"mcpServers": {}} — the template adds no server (DESIGN.md D19)')
    sys.exit(0)
if data.get("model") != "opus":
    print(f"model is {data.get('model')!r}, not 'opus'")
if data.get("autoCompactEnabled") is not False:
    print("autoCompactEnabled is not false — hand off, never compact (DESIGN.md D29)")
hooks = (data.get("hooks") or {}).get("PreCompact") or []
matchers = {h.get("matcher") for h in hooks if isinstance(h, dict)}
for m in ("auto", "manual"):
    if m not in matchers:
        print(f"has no PreCompact hook for '{m}'")
deny = set(((data.get("permissions") or {}).get("deny")) or [])
for d in ("AskUserQuestion", "Edit(**/*.pdf)", "Edit(build/**)"):
    if d not in deny:
        print(f"does not deny {d}")
for k in data:
    if k in ("effortLevel", "ultracode", "enabledPlugins") or k.startswith("disable"):
        print(f"carries the owner-specific key {k}")
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

  # ── 10. .mcp.json ───────────────────────────────────────────────────────────
  if [[ -f "$TREE/.mcp.json" ]]; then
    while IFS= read -r line; do finding "check 10 — .mcp.json $line"; done < <(json_check mcp "$TREE/.mcp.json")
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

  # ── 12. settings.json ───────────────────────────────────────────────────────
  f="$TREE/.claude/settings.json"
  if [[ -f "$f" ]] && ! grep -q '<:' "$f"; then
    while IFS= read -r line; do finding "check 12 — .claude/settings.json $line"; done < <(json_check settings "$f")
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
    printf '_skip_if_exists:\n'
    for s in $SA_SEEDS; do printf '  - /%s\n' "$s"; done
    printf 'PROJECT_NAME:\n  type: str\n'
  } > "$r/copier.yml"
  for s in $SA_SEEDS; do mkdir -p "$(dirname "$t/$s")"; printf '# %s\n' "${s##*/}" > "$t/$s"; done
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
  printf '{"mcpServers": {}}\n' > "$t/.mcp.json"
  cat > "$t/.claude/settings.json" <<'EOF'
{
  "model": "opus",
  "autoCompactEnabled": false,
  "hooks": {"PreCompact": [{"matcher": "auto", "hooks": []}, {"matcher": "manual", "hooks": []}]},
  "permissions": {"deny": ["AskUserQuestion", "Edit(**/*.pdf)", "Edit(build/**)"], "allow": ["Bash(make *)"]}
}
EOF
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
  printf '{"mcpServers": {"elevenlabs": {}}}\n' > "$t/.mcp.json";  probe "check 10 fires on a server in .mcp.json" "check 10"; printf '{"mcpServers": {}}\n' > "$t/.mcp.json"
  printf '# a handoff\n' > "$t/handoffs/HANDOFF-X-01-01-2027.md";  probe "check 11 fires on a file in a pair-only folder" "check 11 — handoffs/HANDOFF-X"; rm -f "$t/handoffs/HANDOFF-X-01-01-2027.md"
  mkdir -p "$t/learning/a-topic";                                   probe "check 11 fires on a sub-folder in a pair-only folder" "check 11 — learning/a-topic/"; rmdir "$t/learning/a-topic"
  cp "$t/.claude/settings.json" "$tmp/h"
  sed -i 's/"autoCompactEnabled": false/"autoCompactEnabled": true/' "$t/.claude/settings.json"; probe "check 12 fires when compaction is switched on" "check 12"; cp "$tmp/h" "$t/.claude/settings.json"
  printf 'DOC_TYPE: business\nINCLUDE_REFERENCES: false\n' > "$t/$SA_ANSWERS_FILE"
  probe_clean "check 13 holds a business render that carries none of the gated permissions"
  sed -i 's/^DOC_TYPE: business/DOC_TYPE: theology/' "$t/$SA_ANSWERS_FILE"
  probe "check 13 fires when a book render does not deny edits to the Pandoc bases" "check 13 — .claude/settings.json does not deny Edit(typeset/src/units/.base/**)"
  sed -i 's/^DOC_TYPE: theology/DOC_TYPE: business/' "$t/$SA_ANSWERS_FILE"
  sed -i 's#"allow": \["Bash(make \*)"\]#"allow": ["Bash(make *)", "Bash(uv run tooling/font.py *)"]#' "$t/.claude/settings.json"
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
