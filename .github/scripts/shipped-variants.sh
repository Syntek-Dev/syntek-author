#!/usr/bin/env bash
#
# shipped-variants.sh — Verify a rendered project carries exactly what its variant should.
#
#                       One tree ships three variants, and the only mechanism that separates
#                       them is a templated _exclude line per gated path (DESIGN.md Section
#                       3.5). Nothing fails when a line is missing or wrong: a theology project
#                       that receives the fiction skills simply has them, and a skill fires on
#                       description match — so a skill that shipped without its documents
#                       "competes for work it cannot do" (SB rule 9). The opposite failure is
#                       as quiet: a gate that never opens leaves a project without the workflow
#                       its rules route to. This script reads a render and compares it with
#                       DESIGN.md, path by path, in both directions.
#
#                       The expected contents come from the catalogue in _common.sh (DESIGN.md
#                       Sections 3–5 transcribed), evaluated against the answers the render
#                       recorded in .copier-answers.syntek-author.yml.
#
#                       Twelve checks:
#                         1. The answers file is present and records DOC_TYPE.
#                         2. Every skill the variant needs is present, with its SKILL.md.
#                         3. No skill the variant must not have, and no skill DESIGN.md does
#                            not name.
#                         4. Every moded skill and moded standards folder carries exactly one
#                            mode file, the variant's own; an unmoded skill carries none.
#                         5. The content layer is manuscript/ xor library/, by DOC_TYPE.
#                         6. Every catalogued path is present exactly when its gate is open —
#                            workflows, guides, gated folders, seeds, seed-once examples.
#                         7. No workflow folder DESIGN.md Section 4.4 does not number.
#                         8. No template-only or retired path (copier.yml, DESIGN.md, adopt/,
#                            .github/scripts/, .claude/agents/, .claude/commands/ …).
#                         9. No template delimiter survives rendering.
#                        10. The recorded answers match what DESIGN.md says the render should
#                            record (only when generate-all.sh left a <tree>.expect beside it);
#                            a list answer (BUSINESS_FAMILIES) is compared value by value.
#                        11. Business: every folder in library/src/ is a document family
#                            DESIGN.md D39 names. A v0.1.0 family folder (proposals, contracts,
#                            policies, correspondence, finance, marketing) is retired, and one
#                            that ships again would compete with its successor for every
#                            document. Whether each family ships exactly when it is chosen is
#                            checks 2, 3 and 6, through the fam-<family> gates of _common.sh.
#                        12. The other coding agents' files (DESIGN.md D47, Section 3.6) say what
#                            the answers chose: each JSON file parses and .codex/config.toml
#                            parses as TOML; .codex/config.toml keeps the CLAUDE.md fallback and
#                            sets `model` exactly when CODEX_MODEL is set; .gemini/settings.json
#                            sets model.name exactly when GEMINI_MODEL is set; opencode.json
#                            writes one provider named for OPENCODE_PROVIDER with the answered
#                            URL, model and context, or none when hosted, and denies edits to
#                            PDFs and build/; and none of them carries a key. Whether each file
#                            and the .agents link (a link to exactly .claude) ship is check 6.
#
#                       Numbers are stable identifiers. Append, never renumber.
#
#                       What it CANNOT check: a file's CONTENT — a gated row inside an index
#                       file that names an absent path is doc-references.sh's, and a shared file
#                       that differs between variants is byte-identity.sh's. Nor can it see a
#                       path DESIGN.md never named; check 7 covers workflows, the one family
#                       whose numbering is frozen.
#
# SELF-TEST. --self-test builds a theology tree from the catalogue at runtime, proves it clean,
#            then applies one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, grep, awk, find. No network. Does NOT render — pass trees that
#               generate-all.sh (or `copier copy`) produced.
#
# Usage: shipped-variants.sh [--quiet] [--self-test] [--help] <rendered-tree>...
#
# Exit codes:  0 = every tree carries exactly its variant
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="shipped-variants.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
shipped-variants.sh — Verify a rendered project carries exactly what its variant should

Usage: shipped-variants.sh [--quiet] [--self-test] [--help] <rendered-tree>...

  --quiet      Print findings only
  --self-test  Prove the checks still fire against a tree built at runtime
  --help       Show this message

A <tree>.expect file beside a tree (written by generate-all.sh) adds check 10.
Exit codes: 0 = clean  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           TARGETS+=("$1"); shift ;;
  esac
done

TREE=""
EXPECT=""

expand_layer() { local p="$1"; [[ "$p" == '{L}'* ]] && p="$(content_layer)${p#\{L\}}"; printf '%s' "$p"; }

run_checks() {
  FINDINGS=()
  local s g m have want mf p gate kind path layer other d rel k v got hits
  local -A catalogued=() wf_known=()

  # ── 1. The answers ──────────────────────────────────────────────────────────
  if ! load_answers "$TREE/$SA_ANSWERS_FILE"; then
    finding "check 1 — no $SA_ANSWERS_FILE recording DOC_TYPE — the project cannot be updated, and nothing can say what it should hold"
    return 0
  fi

  # ── 2–4. Skills and their mode files ────────────────────────────────────────
  while read -r s g m; do
    [[ -z "$s" ]] && continue
    catalogued["$s"]=1
    if [[ "$g" == optional ]]; then
      [[ -d "$TREE/.claude/skills/$s" ]] || continue
    elif gate_true "$g"; then
      if [[ ! -d "$TREE/.claude/skills/$s" ]]; then
        finding "check 2 — skill $s is missing — the $A_DOC_TYPE variant needs it (gate: $g)"; continue
      fi
      [[ -f "$TREE/.claude/skills/$s/SKILL.md" ]] || finding "check 2 — skill $s has no SKILL.md"
    else
      [[ -d "$TREE/.claude/skills/$s" ]] && finding "check 3 — skill $s leaked into this project (gate: $g is shut)"
      continue
    fi
    want=""
    [[ "$m" != - ]] && want="$(mode_for_doc "$A_DOC_TYPE")"
    for mf in $SA_MODE_FILES; do
      have=false; [[ -f "$TREE/.claude/skills/$s/$mf" ]] && have=true
      if [[ "$mf" == "$want" ]] && ! $have; then finding "check 4 — skill $s is moded but its $mf is missing"; fi
      if [[ "$mf" != "$want" ]] && $have; then finding "check 4 — skill $s carries $mf, which belongs to another variant (or to no skill)"; fi
    done
  done <<< "$SA_SKILLS"
  if [[ -d "$TREE/.claude/skills" ]]; then
    while IFS= read -r d; do
      [[ -n "${catalogued[$d]:-}" ]] || finding "check 3 — skill $d is not one DESIGN.md Section 5 names"
    done < <(find "$TREE/.claude/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
  fi
  for s in $SA_MODED_STANDARDS; do
    [[ -d "$TREE/standards/$s" ]] || continue
    want="$(mode_for_doc "$A_DOC_TYPE")"
    for mf in $SA_MODE_FILES; do
      have=false; [[ -f "$TREE/standards/$s/$mf" ]] && have=true
      if [[ "$mf" == "$want" ]] && ! $have; then finding "check 4 — standards/$s/ is moded but its $mf is missing"; fi
      if [[ "$mf" != "$want" ]] && $have; then finding "check 4 — standards/$s/ carries $mf, which belongs to another variant"; fi
    done
  done

  # ── 5. Content layer ────────────────────────────────────────────────────────
  layer="$(content_layer)"
  other=manuscript; [[ "$layer" == manuscript ]] && other=library
  [[ -d "$TREE/$layer" ]] || finding "check 5 — the content layer $layer/ is missing"
  [[ -e "$TREE/$other" ]] && finding "check 5 — $other/ shipped in a $A_DOC_TYPE project; the content layer is $layer/"

  # ── 6. Every catalogued path, both directions ───────────────────────────────
  while read -r gate kind path; do
    [[ -z "$gate" ]] && continue
    p="$(expand_layer "$path")"
    if gate_true "$gate"; then
      if [[ "$kind" == l ]]; then
        if [[ ! -L "$TREE/$p" ]]; then finding "check 6 — $p is missing or not a link (gate: $gate is open)"
        elif [[ "$(readlink "$TREE/$p")" != .claude ]]; then finding "check 6 — $p links to $(readlink "$TREE/$p"), not .claude"; fi
      elif [[ "$kind" == d && ! -d "$TREE/$p" ]]; then finding "check 6 — $p/ is missing (gate: $gate is open)"
      elif [[ "$kind" == f && ! -f "$TREE/$p" ]]; then finding "check 6 — $p is missing (gate: $gate is open)"; fi
    else
      # A {L} row whose layer is the OTHER one is check 5's, not a second finding here.
      [[ -e "$TREE/$p" || -L "$TREE/$p" ]] && finding "check 6 — $p leaked into this project (gate: $gate is shut)"
    fi
  done <<< "$SA_PATHS"

  # ── 7. Workflow folders DESIGN.md does not number ───────────────────────────
  while read -r gate kind path; do
    [[ "$path" == */workflows/[0-9][0-9]-* ]] || continue
    if [[ "$path" == '{L}'* ]]; then wf_known["manuscript${path#\{L\}}"]=1; wf_known["library${path#\{L\}}"]=1
    else wf_known["$path"]=1; fi
  done <<< "$SA_PATHS"
  while IFS= read -r rel; do
    [[ -n "${wf_known[$rel]:-}" ]] || finding "check 7 — $rel/ is a workflow DESIGN.md Section 4.4 does not number (author procedures belong in workflows/local/)"
  done < <(cd "$TREE" && find . -mindepth 3 -maxdepth 3 -type d -path './*/workflows/[0-9][0-9]-*' -not -path './.git/*' | sed 's#^\./##' | sort)

  # ── 8. Template-only and retired paths ──────────────────────────────────────
  for p in $SA_NEVER; do
    [[ -e "$TREE/$p" ]] && finding "check 8 — $p is in the project; it belongs to the template repository or a retired tier"
  done

  # ── 9. No delimiter survives ────────────────────────────────────────────────
  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    hits="$(grep -cE '<%|<:|<~' "$TREE/$rel" || true)"
    finding "check 9 — ${rel#./} carries $hits line(s) with a template delimiter that survived rendering"
  done < <(cd "$TREE" && grep -rIlE --exclude-dir=.git '<%|<:|<~' . 2>/dev/null | sed 's#^\./##' | sort || true)

  # ── 10. The answers DESIGN.md expects ───────────────────────────────────────
  if [[ -n "$EXPECT" && -f "$EXPECT" ]]; then
    while IFS='=' read -r k v; do
      [[ -z "$k" ]] && continue
      got="$(answer_value "$k" "$TREE/$SA_ANSWERS_FILE")"
      if [[ "$k" == BUSINESS_FAMILIES || "$k" == AGENT_CLIENTS ]]; then
        got="$(answer_list "$k" "$TREE/$SA_ANSWERS_FILE" | paste -sd, -)"
      fi
      case "$k" in INCLUDE_*|SEED_EXAMPLES) [[ -z "$got" ]] && got=false ;; esac
      [[ "$k" == SEED_EXAMPLES && -z "$(answer_value "$k" "$TREE/$SA_ANSWERS_FILE")" ]] && got=true
      [[ -z "$got" && ( "$k" == MODEL_MECHANICAL || "$k" == AUDIENCE ) ]] && continue
      [[ "$got" == "$v" ]] || finding "check 10 — the render recorded $k=$got; DESIGN.md Section 2 gives $v for this profile"
    done < "$EXPECT"
  fi

  # ── 11. library/src/ holds only the D39 families ────────────────────────────
  if [[ "$A_DOC_TYPE" == business && -d "$TREE/library/src" ]]; then
    while IFS= read -r d; do
      if [[ " $SA_RETIRED_FAMILIES " == *" $d "* ]]; then
        finding "check 11 — library/src/$d/ is a v0.1.0 family folder, retired in v0.2.0 (DESIGN.md D39, D44)"
      elif [[ " $SA_FAMILIES " != *" $d "* ]]; then
        finding "check 11 — library/src/$d/ is not a document family DESIGN.md D39 names"
      fi
    done < <(find "$TREE/library/src" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
  fi

  # ── 12. The other coding agents' files say what the answers chose ───────────
  if [[ -n "${A_CLIENTS// /}" ]]; then
    while IFS= read -r hits; do
      [[ -n "$hits" ]] && finding "check 12 — $hits"
    done < <(python3 - "$TREE" "$TREE/$SA_ANSWERS_FILE" "$A_CLIENTS" <<'PY'
import json, re, sys, tomllib
tree, answers, clients = sys.argv[1], sys.argv[2], sys.argv[3].split()
def ans(key):
    for line in open(answers, encoding="utf-8"):
        m = re.match(rf"^{key}:\s*(.*?)\s*$", line)
        if m:
            return m.group(1).strip("'\"")
    return ""
def load(rel, kind):
    try:
        with open(f"{tree}/{rel}", "rb") as fh:
            return tomllib.load(fh) if kind == "toml" else json.load(fh)
    except FileNotFoundError:
        return None
    except Exception as exc:
        print(f"{rel} does not parse as {kind.upper()} ({exc.__class__.__name__})"); return None
def keyless(rel, data):
    if re.search(r'"?(api_?key|apiKey|token|secret|password)"?\s*[:=]', json.dumps(data)):
        print(f"{rel} carries a credential key")
if "codex" in clients:
    d = load(".codex/config.toml", "toml")
    if d is not None:
        if "CLAUDE.md" not in (d.get("project_doc_fallback_filenames") or []):
            print(".codex/config.toml lost the CLAUDE.md fallback — Codex would read no folder manual")
        if d.get("model", "") != ans("CODEX_MODEL"):
            print(f".codex/config.toml sets model {d.get('model', '(none)')!r}; CODEX_MODEL is {ans('CODEX_MODEL')!r}")
        for k in ("model_provider", "model_providers", "approval_policy", "sandbox_mode"):
            if k in d: print(f".codex/config.toml sets {k}, which D47 never ships")
        keyless(".codex/config.toml", d)
if "gemini-cli" in clients:
    d = load(".gemini/settings.json", "json")
    if d is not None:
        got = (d.get("model") or {}).get("name", "")
        if got != ans("GEMINI_MODEL"):
            print(f".gemini/settings.json sets model.name {got!r}; GEMINI_MODEL is {ans('GEMINI_MODEL')!r}")
        keyless(".gemini/settings.json", d)
if "antigravity" in clients:
    d = load(".claude/mcp_config.json", "json")
    if d is not None and d != {"mcpServers": {}}:
        print(".claude/mcp_config.json is not exactly {\"mcpServers\": {}}")
if "opencode" in clients:
    d = load("opencode.json", "json")
    if d is not None:
        prov, model = ans("OPENCODE_PROVIDER") or "llama-cpp", ans("OPENCODE_MODEL")
        provs = d.get("providers") or {}
        if prov == "hosted":
            if provs: print("opencode.json writes a provider for a hosted model")
            if d.get("model", "") != model: print(f"opencode.json sets model {d.get('model')!r}; OPENCODE_MODEL is {model!r}")
        else:
            p = provs.get(prov)
            if list(provs) != [prov] or not p:
                print(f"opencode.json providers are {list(provs)}; OPENCODE_PROVIDER is {prov!r}")
            else:
                if d.get("model") != f"{prov}/{model}":
                    print(f"opencode.json sets model {d.get('model')!r}, not {prov}/{model}")
                if (p.get("settings") or {}).get("baseURL") != ans("OPENCODE_BASE_URL"):
                    print("opencode.json's baseURL is not OPENCODE_BASE_URL")
                m = (p.get("models") or {}).get(model) or {}
                if m.get("modelID") != model or str((m.get("limit") or {}).get("context")) != ans("OPENCODE_CONTEXT"):
                    print("opencode.json's model entry does not carry OPENCODE_MODEL and OPENCODE_CONTEXT")
                if not (m.get("capabilities") or {}).get("tools"):
                    print("opencode.json's model is not marked as calling tools")
        denied = {(r.get("action"), r.get("resource")) for r in d.get("permissions") or [] if r.get("effect") == "deny"}
        for res in ("*.pdf", "build/**"):
            if ("edit", res) not in denied: print(f"opencode.json does not deny edits to {res}")
        keyless("opencode.json", d)
PY
)
  fi
}

# ── Self-test ────────────────────────────────────────────────────────────────

build_tree() { # $1 = dir — every path the catalogue says the current answers open
  local t="$1" s g m gate kind path p mf
  mkdir -p "$t/$(content_layer)" "$t/.claude/skills"
  while read -r gate kind path; do
    [[ -z "$gate" ]] && continue
    gate_true "$gate" || continue
    p="$(expand_layer "$path")"
    if [[ "$kind" == l ]]; then ln -s .claude "$t/$p"
    elif [[ "$kind" == d ]]; then mkdir -p "$t/$p"; else mkdir -p "$(dirname "$t/$p")"; printf 'x\n' > "$t/$p"; fi
  done <<< "$SA_PATHS"
  while read -r s g m; do
    [[ -z "$s" || "$g" == optional ]] && continue
    gate_true "$g" || continue
    mkdir -p "$t/.claude/skills/$s"; printf -- '---\nname: %s\n---\n' "$s" > "$t/.claude/skills/$s/SKILL.md"
    [[ "$m" != - ]] && printf 'x\n' > "$t/.claude/skills/$s/$(mode_for_doc "$A_DOC_TYPE")"
  done <<< "$SA_SKILLS"
  for s in $SA_MODED_STANDARDS; do printf 'x\n' > "$t/standards/$s/$(mode_for_doc "$A_DOC_TYPE")"; done
  if [[ "$A_DOC_TYPE" == business ]]; then
    { printf 'DOC_TYPE: business\nBUSINESS_FAMILIES:\n'; printf -- '- %s\n' $A_FAMILIES
      printf 'INCLUDE_REFERENCES: false\nSEED_EXAMPLES: true\nMODEL_MECHANICAL: opus\nAUDIENCE: client\n'; } > "$t/$SA_ANSWERS_FILE"
  else
    printf 'DOC_TYPE: theology\nINCLUDE_PROPOSAL: true\nINCLUDE_REFERENCES: true\nINCLUDE_SENSITIVE_CONTENT: false\nSEED_EXAMPLES: true\nMODEL_MECHANICAL: sonnet\nAUDIENCE: lay\n' \
      > "$t/$SA_ANSWERS_FILE"
  fi
  if [[ -n "${A_CLIENTS// /}" ]]; then
    printf 'AGENT_CLIENTS:\n' >> "$t/$SA_ANSWERS_FILE"
    printf -- '- %s\n' $A_CLIENTS >> "$t/$SA_ANSWERS_FILE"
    printf 'CODEX_MODEL: ""\nGEMINI_MODEL: ""\nOPENCODE_PROVIDER: ollama\nOPENCODE_BASE_URL: http://127.0.0.1:11434/v1\nOPENCODE_MODEL: qwen3:30b\nOPENCODE_CONTEXT: 32768\n' >> "$t/$SA_ANSWERS_FILE"
    has_client codex && printf "project_doc_fallback_filenames = ['CLAUDE.md']\n" > "$t/.codex/config.toml"
    has_client gemini-cli && printf '{"mcpServers": {}}\n' > "$t/.gemini/settings.json"
    has_client antigravity && printf '{"mcpServers": {}}\n' > "$t/.claude/mcp_config.json"
    has_client opencode && cat > "$t/opencode.json" <<'JSON'
{"model": "ollama/qwen3:30b",
 "providers": {"ollama": {"package": "@opencode/ai/providers/openai-compatible", "settings": {"baseURL": "http://127.0.0.1:11434/v1"},
   "models": {"qwen3:30b": {"modelID": "qwen3:30b", "capabilities": {"tools": true}, "limit": {"context": 32768, "output": 8192}}}}},
 "permissions": [{"action": "edit", "resource": "*.pdf", "effect": "deny"}, {"action": "edit", "resource": "build/**", "effect": "deny"}]}
JSON
  fi
  return 0
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  A_DOC_TYPE=theology; A_PROPOSAL=true; A_REFS=true; A_SENSITIVE=false; A_WB=false; A_CONLANG=false
  A_DRIVE=false; A_SEED=true; A_CLIENTS="codex gemini-cli antigravity opencode"
  TREE="$tmp/gen"; EXPECT=""
  build_tree "$TREE"
  st_baseline "a theology tree built from the catalogue"

  mv "$TREE/$SA_ANSWERS_FILE" "$tmp/held"
  probe "check 1 fires when the answers file is missing" "check 1"
  mv "$tmp/held" "$TREE/$SA_ANSWERS_FILE"

  mv "$TREE/.claude/skills/draft-section" "$tmp/held"
  probe "check 2 fires when a shared skill is missing" "check 2 — skill draft-section"
  mv "$tmp/held" "$TREE/.claude/skills/draft-section"

  mkdir -p "$TREE/.claude/skills/continuity"
  probe "check 3 fires when a fiction skill leaks into theology" "check 3 — skill continuity"
  rm -rf "$TREE/.claude/skills/continuity"

  printf 'x\n' > "$TREE/.claude/skills/draft-section/FICTION.md"
  probe "check 4 fires on a second mode file" "check 4 — skill draft-section carries FICTION.md"
  rm -f "$TREE/.claude/skills/draft-section/FICTION.md"

  mkdir -p "$TREE/library"
  probe "check 5 fires when both content layers ship" "check 5"
  rmdir "$TREE/library"

  mv "$TREE/planning/docs/reference/argument-maps.md" "$tmp/held"
  probe "check 6 fires when a theology guide is missing" "check 6 — planning/docs/reference/argument-maps.md is missing"
  mv "$tmp/held" "$TREE/planning/docs/reference/argument-maps.md"

  printf 'x\n' > "$TREE/tooling/lexicon.py"
  probe "check 6 fires when a conlang script leaks into theology" "check 6 — tooling/lexicon.py leaked"
  rm -f "$TREE/tooling/lexicon.py"

  mkdir -p "$TREE/planning/workflows/99-invent-a-step"
  probe "check 7 fires on an unnumbered workflow" "check 7"
  rmdir "$TREE/planning/workflows/99-invent-a-step"

  printf 'x\n' > "$TREE/copier.yml"
  probe "check 8 fires when copier.yml leaks" "check 8 — copier.yml"
  rm -f "$TREE/copier.yml"

  printf 'Hello <%%PROJECT_NAME%%>\n' >> "$TREE/README.md"
  probe "check 9 fires on a surviving token" "check 9 — README.md"
  printf 'x\n' > "$TREE/README.md"

  printf 'DOC_TYPE=theology\nINCLUDE_REFERENCES=false\n' > "$tmp/expect"; EXPECT="$tmp/expect"
  probe "check 10 fires when the recorded answers differ from DESIGN.md's" "check 10 — the render recorded INCLUDE_REFERENCES=true"
  EXPECT=""

  rm "$TREE/.agents"; ln -s ../.claude "$TREE/.agents"
  probe "check 6 fires when .agents links anywhere but .claude" "check 6 — .agents links to ../.claude"
  rm "$TREE/.agents"; ln -s .claude "$TREE/.agents"

  printf '{"mcpServers": {}, "model": {"name": "gemini-x"}}\n' > "$TREE/.gemini/settings.json"
  probe "check 12 fires when Gemini CLI's model is not the answer" "check 12 — .gemini/settings.json sets model.name 'gemini-x'"
  printf '{"mcpServers": {}}\n' > "$TREE/.gemini/settings.json"

  sed -i 's#ollama/qwen3:30b#vllm/qwen3:30b#' "$TREE/opencode.json"
  probe "check 12 fires when opencode.json names another model" "check 12 — opencode.json sets model 'vllm/qwen3:30b'"
  sed -i 's#vllm/qwen3:30b#ollama/qwen3:30b#' "$TREE/opencode.json"

  # A business tree with two of the six families chosen: the family gates in both directions.
  # Claude Code only: no other client's file may ship.
  A_CLIENTS=""
  A_DOC_TYPE=business; A_PROPOSAL=false; A_REFS=false; A_FAMILIES="business legal"
  TREE="$tmp/biz"
  build_tree "$TREE"
  st_baseline "a business tree with the business and legal families"

  mv "$TREE/.claude/skills/legal-documents" "$tmp/held"
  probe "check 2 fires when a chosen family's skill is missing" "check 2 — skill legal-documents"
  mv "$tmp/held" "$TREE/.claude/skills/legal-documents"

  printf '# x\n' > "$TREE/AGENTS.md"
  probe "check 6 fires when an entrypoint ships with no client chosen" "check 6 — AGENTS.md leaked"
  rm -f "$TREE/AGENTS.md"

  mkdir -p "$TREE/.claude/skills/msp-scp-documents"
  probe "check 3 fires when an unchosen family's skill ships" "check 3 — skill msp-scp-documents leaked"
  rm -rf "$TREE/.claude/skills/msp-scp-documents"

  mkdir -p "$TREE/library/workflows/15-create-an-msp-scp-document"
  probe "check 6 fires when an unchosen family's workflow ships" "check 6 — library/workflows/15-create-an-msp-scp-document leaked"
  rmdir "$TREE/library/workflows/15-create-an-msp-scp-document"

  printf 'BUSINESS_FAMILIES=business,legal,email\n' > "$tmp/expect"; EXPECT="$tmp/expect"
  probe "check 10 fires when the recorded families differ from DESIGN.md's" "check 10 — the render recorded BUSINESS_FAMILIES=business,legal"
  EXPECT=""

  mkdir -p "$TREE/library/src/proposals"
  probe "check 11 fires when a retired v0.1.0 family folder ships" "check 11 — library/src/proposals/ is a v0.1.0 family folder"
  rmdir "$TREE/library/src/proposals"
  A_FAMILIES=""

  st_finish "a correctly gated render from a leaking or incomplete one"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ ${#TARGETS[@]} -gt 0 ]] || die "no rendered tree given — this script asserts on trees Copier produced (see generate-all.sh)"
build_sets "$SA_ROOT/copier.yml"

bold "▸ $SCRIPT_NAME"
STATUS=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREE="$(cd "$target" && pwd)"
  EXPECT=""; [[ -f "$TREE.expect" ]] && EXPECT="$TREE.expect"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $TREE — the $A_DOC_TYPE variant, exactly"
  else
    bold "✗ $TREE — ${#FINDINGS[@]} finding(s):"
    print_findings
    STATUS=1
  fi
done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ ${#TARGETS[@]} tree(s): every variant carries exactly its own paths, skills and mode files."
  exit 0
fi
log "  A path shipped where it should not, or did not ship where it should. Fix the gate in"
log "  copier.yml's _exclude (DESIGN.md Section 3.5), or the file's place under template/."
exit 1
