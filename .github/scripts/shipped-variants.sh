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
#                       Twenty-five checks:
#                         1. The answers file is present and records DOC_TYPE.
#                         2. Every skill the variant needs is present, with its SKILL.md.
#                         3. No skill the variant must not have, and no skill DESIGN.md does
#                            not name.
#                         4. Every moded skill and moded standards folder carries exactly one
#                            mode file, the variant's own; an unmoded skill carries none.
#                         5. The content layer is manuscript/ xor library/, by DOC_TYPE.
#                         6. Every catalogued path is present exactly when its gate is open —
#                            workflows, guides, gated folders, seeds, seed-once examples, the
#                            bridge, the permissions script and the data-root resolver and its
#                            map (always), the three data-root ignore files (only under
#                            DATA_STORE external, D50), .github/ (only for business with
#                            DATA_PROVIDER google-drive and DATA_STORE repo, D53), the other
#                            coding agents' files, and the user guide (D56): every how-to path,
#                            the guide guard among the hooks, and exactly the variant's own
#                            chapter of 14, 15 and 16. A catalogued folder is a real folder, never a
#                            link (.agents above all: a linked .agents breaks Codex's Linux
#                            sandbox), and .agents/skills is a link to exactly ../.claude/skills,
#                            never a copy.
#                         7. No workflow folder DESIGN.md Section 4.4 does not number, and no
#                            how-to procedure (how-to/workflows/<template>/NN-*) Section 4.5
#                            does not number (D56).
#                         8. No template-only or retired path (copier.yml, DESIGN.md, adopt/,
#                            .github/scripts/, .claude/agents/, .claude/commands/ …).
#                         9. No template delimiter survives rendering.
#                        10. The recorded answers match what DESIGN.md says the render should
#                            record (only when generate-all.sh left a <tree>.expect beside it),
#                            the data-root answers and DATA_PROVIDER included (D50, D53); a list
#                            answer (BUSINESS_FAMILIES) is compared value by value.
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
#                            sets model.name exactly when GEMINI_MODEL is set and excludes
#                            ask_user; .agents/mcp_config.json is byte for byte .mcp.json (the
#                            1308 shared bytes, D54); opencode.json follows OPENCODE_PROVIDER —
#                            `user` writes nothing but $schema, compaction, mcp and permissions,
#                            `named` only the model, a local server one OpenAI-compatible
#                            provider with the address without its trailing slash, the model,
#                            and limit.context an integer — sets compaction.auto false, and
#                            denies edits to *.pdf, build/*, how-to/* (D56) and
#                            typeset/src/units/.base/* with no rule after its denies (the last
#                            match wins). Every MCP file declares
#                            exactly the two D54 servers, each with .mcp.json's command,
#                            arguments and blank keys (OpenCode's command list and environment
#                            read as the same), and no file carries a credential: a key named
#                            like one (api key, token, secret, password, in any case) ships only
#                            as one of code-review-graph's six blank keys, and each of those is
#                            exactly "". Whether each file ships is check 6.
#                        13. `python3 .claude/syntek-author-permissions.py --check` exits 0 in
#                            the render (DESIGN.md D49): a fresh project already carries every
#                            rule the script can express.
#                        14. Optional, each where its tool is installed and `unshare -rn` keeps
#                            it off the network (OpenCode also in its own PID namespace, so the
#                            MCP servers it starts end with it), with a scratch HOME, XDG folders
#                            and TMPDIR:
#                            `opencode debug config` loads opencode.json without a normalization
#                            diagnostic or a dropped key, provider, model or rule (OpenCode skips
#                            a malformed value silently); and on Linux
#                            `codex sandbox -P :workspace -C <render> -- true` succeeds (a linked
#                            .agents makes every sandboxed command fail). Never `codex doctor`.
#                        15. Hidden answers stay hidden (Trap 2): no key the profile's .expect
#                            lists as ABSENT is recorded, and no rendered file carries its
#                            NOTEXT string, a value given only to a hidden question — the D47
#                            answers, and the data-root layout answers under DATA_STORE repo
#                            (D50).
#                        16. Rules 05 names exactly the clients chosen: a Section 4 when
#                            AGENT_CLIENTS names any, a row for each client named and none for
#                            a client not named.
#                        17. The data-root map (.claude/syntek-author-dataroot.json, D50) parses
#                            as JSON in format 1, lists its folders once each with a known kind,
#                            and names only folders some variant ships: one map serves every
#                            variant, and a folder no variant has is a filing rule for nothing.
#                            Every key the resolver judges holds a value it reads (the format's
#                            contract, K8): warn_over_kib a positive integer, rows only "none";
#                            each role, where the map defines any, named in lower-case words
#                            joined by hyphens, never a shared role's or a kind's name, once, with
#                            evidence true or false and repo, if given, only "skip". A value the
#                            resolver refuses makes the whole map unreadable, and every command
#                            that touches its folders then exits 2. A key it does not know is
#                            kept and never judged.
#                        18. `python3 .claude/syntek-author-dataroot.py --self-test` exits 0 in
#                            the render: the resolver every project runs proves itself where it
#                            landed.
#                        19. No external.toml ships: a filing folder's manifest is the
#                            project's own, written by its first filing, and one shipped would
#                            list files no machine holds.
#                        20. The seed .claude/settings.json wires the data-root guard exactly
#                            once, on PreToolUse with its matcher, whatever the store: one copy
#                            is the guard; a second runs it twice, none leaves the root open to
#                            edits.
#                        21. Each Drive workflow that ships (google-drive-push.yml,
#                            google-drive-pull.yml; DESIGN.md D37, D53) holds the store guard
#                            step 'Stop unless the documents are kept in the repository' exactly
#                            once, directly after 'Checkout repository' and before
#                            'Authenticate to Google Cloud', never skippable (no if: or
#                            continue-on-error:), reading DATA_STORE from the answers file and
#                            stopping with exit 1; where both ship, the step's script is the same
#                            in both.
#                        22. Under DATA_STORE external, each data-root ignore file that ships
#                            ignores every extension the shipped resolver counts as a binary (its
#                            EXTENSIONS table, read without running it), in every letter case,
#                            and never the manifest external.toml, as Git reads them (git
#                            check-ignore): a type it misses is committed instead of filed, and
#                            an ignored manifest loses the record of what is filed (D50). Skipped,
#                            by name, without git.
#                        23. The guide guard in the render (D56), the first problem of: the
#                            seed .claude/settings.json wires exactly one PreToolUse entry whose
#                            command names .claude/hooks/how-to-read-only.sh; its
#                            permissions.deny holds Edit(/how-to/**); the guard script, where it
#                            ships (its absence is check 6's), is executable. Without the entry
#                            or the bit, nothing stops a session's file tools in the read-only
#                            guide but the deny, which a session started in a subfolder escapes.
#                        24. The render's always-loaded instruction set is over
#                            SA_STARTUP_BUDGET characters (DESIGN.md D59): .claude/CLAUDE.md, a
#                            root CLAUDE.md or CLAUDE.local.md if one ships, each file they
#                            import with an @ line (outside code spans and fences, relative to
#                            the importing file, four hops), and every .claude/rules/**/*.md that
#                            does not open with paths frontmatter; or a path-scoped rule is over
#                            SA_SCOPED_LIMIT, past which Claude Code reads only its start.
#                        25. Rules 04 and 09 do not open with exactly DESIGN.md Section 4.1's
#                            frontmatter (---, paths:, one double-quoted glob a line equal to
#                            SA_RULE_PATHS_04 or _09, in order, ---), their brace expansion
#                            passes 1,000 patterns, 09's binary globs miss an extension the
#                            shipped resolver counts (its EXTENSIONS table, check 22's reading)
#                            in lower or upper case, or another syntek-author rules file opens
#                            with frontmatter; or, under DATA_STORE repo, the shipped resolver's
#                            EXTENSIONS table cannot be read. Any error in the check is itself a
#                            check 25 finding. Frontmatter Claude Code cannot parse loads the
#                            rule at launch, silently.
#
#                       Numbers are stable identifiers. Append, never renumber.
#
#                       What it CANNOT check: whether a file's CONTENT is right beyond the facts
#                       its checks name — a gated row inside an index file that names an absent
#                       path is doc-references.sh's, and a shared file that differs between
#                       variants is byte-identity.sh's. Nor can it see a path DESIGN.md never
#                       named; check 7 covers workflows, the one family whose numbering is
#                       frozen.
#
# SELF-TEST. --self-test builds a theology tree from the catalogue at runtime, proves it clean,
#            then applies one mutation per check and asserts exactly one finding each; then
#            the same for a business tree that keeps its documents in the repository and has
#            the Google Drive workflows.
#
# Requirements: bash 4+, grep, awk, find, python3 at _common.sh's SA_PYTHON_MIN or later (the
#               floor of the permissions script and the resolver; the pin refuses an older one,
#               so checks 13 and 18 never skip on the interpreter). No network. Does NOT render — pass
#               trees that generate-all.sh (or `copier copy`) produced. opencode, codex and
#               unshare optional (check 14); git for check 22.
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
declare -A NOTES=()

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
        if [[ ! -L "$TREE/$p" ]]; then finding "check 6 — $p is missing or not a link (gate: $gate is open) — it links to $SA_AGENTS_LINK_TARGET, never copies it"
        elif [[ "$(readlink "$TREE/$p")" != "$SA_AGENTS_LINK_TARGET" ]]; then finding "check 6 — $p links to $(readlink "$TREE/$p"), not $SA_AGENTS_LINK_TARGET"; fi
      elif [[ "$kind" == d && -L "$TREE/$p" ]]; then finding "check 6 — $p is a link (to $(readlink "$TREE/$p")); it must be a real folder"
      elif [[ "$kind" == d && ! -d "$TREE/$p" ]]; then finding "check 6 — $p/ is missing (gate: $gate is open)"
      elif [[ "$kind" == f && ! -f "$TREE/$p" ]]; then finding "check 6 — $p is missing (gate: $gate is open)"; fi
    else
      # A {L} row whose layer is the OTHER one is check 5's, not a second finding here.
      [[ -e "$TREE/$p" || -L "$TREE/$p" ]] && finding "check 6 — $p leaked into this project (gate: $gate is shut)"
    fi
  done <<< "$SA_PATHS"

  # ── 7. Workflow folders DESIGN.md does not number ───────────────────────────
  while read -r gate kind path; do
    [[ "$path" == */workflows/[0-9][0-9]-* || "$path" == how-to/workflows/*/[0-9][0-9]-* ]] || continue
    if [[ "$path" == '{L}'* ]]; then wf_known["manuscript${path#\{L\}}"]=1; wf_known["library${path#\{L\}}"]=1
    else wf_known["$path"]=1; fi
  done <<< "$SA_PATHS"
  while IFS= read -r rel; do
    [[ -n "${wf_known[$rel]:-}" ]] || finding "check 7 — $rel/ is a workflow DESIGN.md Section 4.4 does not number (author procedures belong in workflows/local/)"
  done < <(cd "$TREE" && find . -mindepth 3 -maxdepth 3 -type d -path './*/workflows/[0-9][0-9]-*' -not -path './.git/*' | sed 's#^\./##' | sort)
  # The user guide's procedures (D56): numbered from 01 in each template's own folder.
  while IFS= read -r rel; do
    [[ -n "${wf_known[$rel]:-}" ]] || finding "check 7 — $rel/ is a how-to procedure DESIGN.md Section 4.5 does not number"
  done < <(cd "$TREE" && find . -mindepth 4 -maxdepth 4 -type d -path './how-to/workflows/*/[0-9][0-9]-*' | sed 's#^\./##' | sort)

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
      [[ -z "$k" || "$k" == ABSENT || "$k" == NOTEXT ]] && continue   # check 15's
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
    done < <(python3 - "$TREE" "$TREE/$SA_ANSWERS_FILE" "$A_CLIENTS" "$SA_MCP_SHARED" "$SA_CRG_BLANK_KEYS" <<'PY'
import json, re, sys, tomllib
tree, answers, clients = sys.argv[1], sys.argv[2], sys.argv[3].split()
SHARED, BLANK = sys.argv[4], sys.argv[5].split()
LOCAL = ("llama-cpp", "ollama", "vllm", "lmstudio", "openai-compatible")
DENIES = ("*.pdf", "build/*", "how-to/*", "typeset/src/units/.base/*")
# The two D54 servers as .mcp.json declares them: command, arguments, and the names of the blank
# keys (their values are the credential test's).
def shape(command, args, env):
    return (command, list(args or []), list((env or {}).keys()))
EXPECTED = {n: shape(v.get("command"), v.get("args"), v.get("env")) for n, v in json.loads(SHARED)["mcpServers"].items()}
def servers(rel, found, opencode=False):
    if not isinstance(found, dict) or not found:
        print(f"{rel} declares no MCP server — every MCP file declares the two D54 servers ({', '.join(EXPECTED)})")
        return
    if sorted(found) != sorted(EXPECTED):
        print(f"{rel} declares the MCP servers {sorted(found)}, not exactly {sorted(EXPECTED)} (D54)")
        return
    for name, v in found.items():
        v = v if isinstance(v, dict) else {}
        if opencode:
            cmd = v.get("command") if isinstance(v.get("command"), list) else []
            got = shape(cmd[0] if cmd else None, cmd[1:], v.get("environment")) if v.get("type") == "local" else None
        else:
            got = shape(v.get("command"), v.get("args"), v.get("env"))
        if got != EXPECTED[name]:
            print(f"{rel} declares {name} with another command, arguments or blank keys than .mcp.json (D54)")
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
CREDENTIAL = re.compile(r"(api_?key|token|secret|password)$", re.I)
def keyless(rel, data):
    # A key named like a credential, in any case, ships only as one of the six blank keys, and
    # each of those is exactly "" wherever it appears.
    hits = []
    def walk(x):
        if isinstance(x, dict):
            for k, v in x.items():
                if k in BLANK:
                    if v != "":
                        hits.append(f"{k} with a value")
                elif CREDENTIAL.search(str(k)):
                    hits.append(str(k))
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(data)
    if hits:
        print(f"{rel} carries a credential key ({', '.join(sorted(set(hits)))}) — only code-review-graph's six blank keys ship, each \"\"")
if "codex" in clients:
    d = load(".codex/config.toml", "toml")
    if d is not None:
        if "CLAUDE.md" not in (d.get("project_doc_fallback_filenames") or []):
            print(".codex/config.toml lost the CLAUDE.md fallback — Codex would read no folder manual")
        if d.get("model", "") != ans("CODEX_MODEL"):
            print(f".codex/config.toml sets model {d.get('model', '(none)')!r}; CODEX_MODEL is {ans('CODEX_MODEL')!r}")
        for k in ("model_provider", "model_providers", "profile", "profiles", "approval_policy", "sandbox_mode"):
            if k in d: print(f".codex/config.toml sets {k}, which D47 never ships")
        servers(".codex/config.toml", d.get("mcp_servers"))
        keyless(".codex/config.toml", d)
if "gemini-cli" in clients:
    d = load(".gemini/settings.json", "json")
    if d is not None:
        got = (d.get("model") or {}).get("name", "")
        if got != ans("GEMINI_MODEL"):
            print(f".gemini/settings.json sets model.name {got!r}; GEMINI_MODEL is {ans('GEMINI_MODEL')!r}")
        if "ask_user" not in ((d.get("tools") or {}).get("exclude") or []):
            print(".gemini/settings.json does not exclude ask_user — .claude/settings.json denies AskUserQuestion (D49)")
        servers(".gemini/settings.json", d.get("mcpServers"))
        keyless(".gemini/settings.json", d)
if "antigravity" in clients:
    try:
        raw = open(f"{tree}/.agents/mcp_config.json", "rb").read()
    except FileNotFoundError:
        raw = None
    if raw is not None and raw != SHARED.encode("utf-8"):
        print(".agents/mcp_config.json is not byte for byte .mcp.json (the 1308 shared bytes that declare the two D54 servers; D48, D54)")
if "opencode" in clients:
    d = load("opencode.json", "json")
    if d is not None:
        prov, model = ans("OPENCODE_PROVIDER") or "user", ans("OPENCODE_MODEL")
        provs = d.get("providers")
        if prov == "user":
            extra = sorted(set(d) - {"$schema", "compaction", "mcp", "permissions"})
            if extra: print(f"opencode.json writes {extra} for OPENCODE_PROVIDER user — the user's own OpenCode settings must apply")
        elif prov == "named":
            if provs is not None: print("opencode.json writes a provider for a model the owner named")
            if d.get("model", "") != model: print(f"opencode.json sets model {d.get('model')!r}; OPENCODE_MODEL is {model!r}")
        elif prov in LOCAL:
            provs = provs or {}
            p = provs.get(prov)
            if list(provs) != [prov] or not p:
                print(f"opencode.json providers are {list(provs)}; OPENCODE_PROVIDER is {prov!r}")
            else:
                if d.get("model") != f"{prov}/{model}":
                    print(f"opencode.json sets model {d.get('model')!r}, not {prov}/{model}")
                if p.get("package") != "@opencode/ai/providers/openai-compatible":
                    print(f"opencode.json's provider package is {p.get('package')!r}, not the OpenAI-compatible one")
                url = (p.get("settings") or {}).get("baseURL")
                if url != ans("OPENCODE_BASE_URL").rstrip("/"):
                    print(f"opencode.json's baseURL is {url!r}, not OPENCODE_BASE_URL without its trailing slash")
                elif url.endswith("/"):
                    print("opencode.json's baseURL ends in a slash")
                m = (p.get("models") or {}).get(model) or {}
                lim = m.get("limit") or {}
                if m.get("modelID") != model:
                    print("opencode.json's model entry does not carry OPENCODE_MODEL")
                if type(lim.get("context")) is not int or str(lim.get("context")) != ans("OPENCODE_CONTEXT"):
                    print(f"opencode.json's limit.context is {lim.get('context')!r}, not the integer OPENCODE_CONTEXT {ans('OPENCODE_CONTEXT')}")
                if lim.get("output") != 8192:
                    print(f"opencode.json's limit.output is {lim.get('output')!r}, not 8192")
                if not (m.get("capabilities") or {}).get("tools"):
                    print("opencode.json's model is not marked as calling tools")
        else:
            print(f"OPENCODE_PROVIDER is {prov!r}, which is no longer a choice")
        if d.get("compaction") != {"auto": False}:
            print("opencode.json does not set compaction.auto false — hand off, never compact")
        rules = d.get("permissions") or []
        denied = {(r.get("action"), r.get("resource")) for r in rules if r.get("effect") == "deny"}
        for res in DENIES:
            if ("edit", res) not in denied: print(f"opencode.json does not deny edits to {res}")
        first = next((i for i, r in enumerate(rules) if r.get("effect") == "deny"), len(rules))
        if any(r.get("effect") != "deny" for r in rules[first:]):
            print("opencode.json has a rule after its denies — the last match wins, so it can override them")
        servers("opencode.json", (d.get("mcp") or {}).get("servers"), opencode=True)
        keyless("opencode.json", d)
PY
)
  fi
  # ── 13. The permissions script finds no drift in a fresh render (D49) ───────
  local perm="$TREE/.claude/syntek-author-permissions.py" out status
  if [[ -f "$perm" ]]; then
    status=0
    out="$(cd "$TREE" && python3 -I "$perm" --check 2>&1)" || status=$?
    [[ "$status" -eq 0 ]] || finding "check 13 — .claude/syntek-author-permissions.py --check exits $status in a fresh render: $(printf '%s\n' "$out" | grep -v '^[[:space:]]*$' | tail -1 | cut -c1-160)"
  fi

  # ── 14. Optional: the clients themselves read the files (no network, scratch home) ──
  client_probes

  # ── 15. Hidden answers are never recorded or rendered (Trap 2) ──────────────
  if [[ -n "$EXPECT" && -f "$EXPECT" ]]; then
    local absent notext
    absent="$(sed -n 's/^ABSENT=//p' "$EXPECT")"; notext="$(sed -n 's/^NOTEXT=//p' "$EXPECT")"
    for k in ${absent//,/ }; do
      grep -qE "^$k:" "$TREE/$SA_ANSWERS_FILE" \
        && finding "check 15 — the answers record $k, which this profile hides — a hidden answer is never recorded"
    done
    if [[ -n "$notext" ]]; then
      while IFS= read -r rel; do
        [[ -n "$rel" ]] && finding "check 15 — ${rel#./} carries '$notext', a value given only to a hidden question"
      done < <(cd "$TREE" && grep -rlIF --exclude-dir=.git -- "$notext" . 2>/dev/null | sort || true)
    fi
  fi

  # ── 16. Rules 05 names exactly the clients chosen ───────────────────────────
  local r05="$TREE/.claude/rules/syntek-author/05-model-allocation.md" c label
  if [[ -f "$r05" ]]; then
    if [[ -n "${A_CLIENTS// /}" ]]; then
      grep -qE '^## 4\.' "$r05" || finding "check 16 — rules 05 has no Section 4, though AGENT_CLIENTS names $A_CLIENTS"
    else
      grep -qE '^## 4\.' "$r05" && finding "check 16 — rules 05 has a Section 4, though AGENT_CLIENTS names no client"
    fi
    for c in codex gemini-cli antigravity opencode; do
      case "$c" in codex) label="Codex" ;; gemini-cli) label="Gemini CLI" ;; antigravity) label="Antigravity" ;; opencode) label="OpenCode" ;; esac
      if has_client "$c"; then
        grep -qF "| $label |" "$r05" || finding "check 16 — rules 05 has no $label row, though AGENT_CLIENTS names $c"
      else
        grep -qF "| $label |" "$r05" && finding "check 16 — rules 05 has a $label row, though AGENT_CLIENTS does not name $c"
      fi
    done
  fi

  # ── 17. The data-root map parses and names only folders a variant ships (D50) ─
  if [[ -f "$TREE/$SA_DATAROOT_MAP" ]]; then
    while IFS= read -r hits; do
      [[ -n "$hits" ]] && finding "check 17 — $hits"
    done < <(python3 - "$TREE/$SA_DATAROOT_MAP" "$SA_DATAROOT_MAP" "$(catalogued_folders)" <<'PY'
import json, re, sys
path, rel, known = sys.argv[1], sys.argv[2], set(sys.argv[3].split())
try:
    with open(path, encoding="utf-8") as fh:
        data = json.load(fh)
except Exception as exc:
    print(f"{rel} does not parse as JSON ({exc.__class__.__name__}) — the resolver cannot read its filing folders")
    sys.exit(0)
if not isinstance(data, dict) or type(data.get("format")) is not int or data["format"] != 1:
    print(f"{rel} is not format 1 — this release's resolver reads format 1 and refuses a later one")
    sys.exit(0)
folders = data.get("folders")
if not isinstance(folders, list) or not all(isinstance(f, dict) and isinstance(f.get("path"), str) for f in folders):
    print(f"{rel} holds no list of folders, each with a path")
    sys.exit(0)
# K8's rules for the keys the resolver judges; any value it would refuse makes the whole map
# unreadable, so its folders refuse every data command. A key it does not know is kept, unjudged.
KINDS = ("docs", "photos", "audio", "videos")
SHARED_ROLES = ("issued", "signed", "ingested", "received", "archive", "evidence", "asset", "generated")
ROLE_NAME = re.compile(r"[a-z][a-z0-9]*(?:-[a-z0-9]+)*")
seen = set()
for f in folders:
    p = f["path"]
    if p in seen:
        print(f"{rel} names {p} twice")
    seen.add(p)
    if p not in known:
        print(f"{rel} names {p}, a folder no variant ships — the map names only the template's filing folders")
    if "kind" in f and f["kind"] not in KINDS:
        print(f"{rel} gives {p} the kind {f['kind']!r}, not docs, photos, audio or videos")
    if "warn_over_kib" in f and (type(f["warn_over_kib"]) is not int or f["warn_over_kib"] <= 0):
        print(f"{rel} gives {p} warn_over_kib {f['warn_over_kib']!r}, not a positive whole number of KiB")
    if "rows" in f and f["rows"] != "none":
        print(f"{rel} gives {p} rows {f['rows']!r}: the one value is \"none\" (working output that never takes rows)")
roles = data.get("roles", [])
if not isinstance(roles, list):
    print(f"{rel} holds roles that are not a list — the resolver cannot read the map at all")
    roles = []
named = set()
for i, r in enumerate(roles):
    name = r.get("name") if isinstance(r, dict) else None
    if not isinstance(name, str) or not ROLE_NAME.fullmatch(name):
        print(f"{rel} roles[{i}] is named {name!r}, not lower-case words joined by hyphens (brand-export)")
        continue
    if name in SHARED_ROLES or name in KINDS:
        print(f"{rel} defines the role {name!r}, a {'shared role' if name in SHARED_ROLES else 'kind'}'s name, which a map never defines")
    if name in named:
        print(f"{rel} defines the role {name!r} twice")
    named.add(name)
    if type(r.get("evidence")) is not bool:
        print(f"{rel} gives the role {name!r} evidence {r.get('evidence')!r}, not true or false")
    if "repo" in r and r["repo"] != "skip":
        print(f"{rel} gives the role {name!r} repo {r['repo']!r}: the one value is \"skip\" (never filed under repo)")
PY
)
  fi

  # ── 18. The resolver proves itself in the render (D50) ──────────────────────
  local dr="$TREE/$SA_DATAROOT_PY"
  if [[ -f "$dr" ]]; then
    status=0
    out="$(cd "$TREE" && python3 -I "$dr" --self-test 2>&1)" || status=$?
    [[ "$status" -eq 0 ]] || finding "check 18 — $SA_DATAROOT_PY --self-test exits $status in this render: $(printf '%s\n' "$out" | grep -v '^[[:space:]]*$' | tail -1 | cut -c1-160)"
  fi

  # ── 19. No manifest ships (D50) ─────────────────────────────────────────────
  while IFS= read -r rel; do
    [[ -n "$rel" ]] && finding "check 19 — ${rel#./} ships — a filing folder's manifest is the project's own, written by its first filing (make files-add), never by the template"
  done < <(cd "$TREE" && find . -name .git -prune -o -name external.toml -print | sort)

  # ── 20. The seed wires the data-root guard once (D50) ───────────────────────
  if [[ -f "$TREE/.claude/settings.json" ]]; then
    while IFS= read -r hits; do
      [[ -n "$hits" ]] && finding "check 20 — $hits"
    done < <(python3 - "$TREE/.claude/settings.json" "$SA_GUARD_CMD" "$SA_GUARD_MATCHER" <<'PY'
import json, sys
path, cmd, matcher = sys.argv[1:4]
try:
    with open(path, encoding="utf-8") as fh:
        data = json.load(fh)
except Exception as exc:
    print(f".claude/settings.json does not parse as JSON ({exc.__class__.__name__}), so it wires no data-root guard")
    sys.exit(0)
hooks = data.get("hooks") if isinstance(data, dict) and isinstance(data.get("hooks"), dict) else {}
wired = [(event, e.get("matcher", "")) for event, entries in hooks.items() if isinstance(entries, list)
         for e in entries if isinstance(e, dict)
         for h in (e.get("hooks") or []) if isinstance(h, dict) and h.get("command") == cmd]
if len(wired) != 1:
    print(f".claude/settings.json wires the data-root guard {len(wired)} times — the seed wires it once, whatever the store")
elif wired[0] != ("PreToolUse", matcher):
    print(f".claude/settings.json wires the data-root guard on {wired[0][0]} for {wired[0][1]!r}, not on PreToolUse for {matcher!r}")
PY
)
  fi

  # ── 21. The Drive workflows hold the store guard step (D37, D53) ────────────
  local -a wfs=()
  for p in google-drive-push.yml google-drive-pull.yml; do
    [[ -f "$TREE/.github/workflows/$p" ]] && wfs+=("$TREE/.github/workflows/$p")
  done
  if [[ ${#wfs[@]} -gt 0 ]]; then
    while IFS= read -r hits; do
      [[ -n "$hits" ]] && finding "check 21 — $hits"
    done < <(python3 - "$SA_DRIVE_GUARD_STEP" "$SA_ANSWERS_FILE" "${wfs[@]}" <<'PY'
import os, re, sys
guard, answers, files = sys.argv[1], sys.argv[2], sys.argv[3:]
CHECKOUT, AUTH = "Checkout repository", "Authenticate to Google Cloud"
def steps(text):
    """Each job's steps, in order, as text: the workflows are the template's own YAML, written with
    `steps:` lists of `- name:` items, so a reader of that shape needs no YAML library."""
    lines, out = text.split("\n"), []
    for n, line in enumerate(lines):
        m = re.match(r"^( *)steps:\s*$", line)
        if not m:
            continue
        ind, cur = len(m.group(1)), None
        for l in lines[n + 1:]:
            if l.strip() and not l.lstrip().startswith("#") and len(l) - len(l.lstrip(" ")) <= ind:
                break
            item = re.match(r"^ {%d}- (.*)$" % (ind + 2), l)
            if item:
                cur = {"name": None, "keys": [], "lines": [], "ind": ind + 4}
                out.append(cur)
                l = " " * (ind + 4) + item.group(1)
            if cur is None:
                continue
            cur["lines"].append(l)
            k = re.match(r"^ {%d}([A-Za-z_-]+):\s*(.*)$" % cur["ind"], l)
            if k:
                cur["keys"].append(k.group(1))
                if k.group(1) == "name":
                    cur["name"] = k.group(2).strip().strip("'\"")
    return out
def run_block(step):
    body, on = [], False
    for l in step["lines"]:
        if re.match(r"^ {%d}run:\s*\|" % step["ind"], l):
            on = True
            continue
        if on:
            if l.strip() and len(l) - len(l.lstrip(" ")) <= step["ind"]:
                break
            body.append(l)
    return "\n".join(body).rstrip()
scripts = {}
for path in files:
    rel = ".github/workflows/" + os.path.basename(path)
    with open(path, encoding="utf-8") as fh:
        st = steps(fh.read())
    names = [x["name"] for x in st]
    hits = [x for x in st if x["name"] == guard]
    if len(hits) != 1:
        print(f"{rel} holds {len(hits)} steps named '{guard}' — it needs exactly one, or it acts on a project whose files are kept outside the repository")
        continue
    i = names.index(guard)
    if i == 0 or names[i - 1] != CHECKOUT or (AUTH in names and names.index(AUTH) < i):
        print(f"{rel}: the store guard step is not directly after '{CHECKOUT}' and before '{AUTH}' — it must read the "
              f"checked-out answers and stop the job before anything authenticates")
    if {"if", "continue-on-error"} & set(hits[0]["keys"]):
        print(f"{rel}: the store guard step can be skipped (if: or continue-on-error:)")
    run = run_block(hits[0])
    if not ("DATA_STORE" in run and answers in run and re.search(r"\bexit 1\b", run)):
        print(f"{rel}: the store guard step does not read DATA_STORE from {answers} and stop with exit 1")
    scripts[rel] = run
if len(set(scripts.values())) > 1:
    print(f"the store guard step's script differs between {' and '.join(sorted(scripts))} — one guard, the same in both")
PY
)
  fi

  # ── 22. The data-root ignore files ignore every binary the resolver counts (D50) ─
  local -a igs=()
  if gate_true ext && [[ -f "$TREE/$SA_DATAROOT_PY" ]]; then
    for p in $SA_DATAROOT_IGNORES; do [[ -f "$TREE/$p" ]] && igs+=("$p"); done
  fi
  if [[ ${#igs[@]} -gt 0 ]] && ! command -v git >/dev/null 2>&1; then
    NOTES["check 22 skipped — git is not installed, so no ignore file could be read as Git reads it"]=1
  elif [[ ${#igs[@]} -gt 0 ]]; then
    while IFS= read -r hits; do
      [[ -n "$hits" ]] && finding "check 22 — $hits"
    done < <(python3 - "$TREE" "$SA_DATAROOT_PY" "${igs[@]}" <<'PY'
import ast, os, shutil, subprocess, sys, tempfile
tree, resolver, ignores = sys.argv[1], sys.argv[2], sys.argv[3:]
# The resolver's own kind table, read without running it.
table = None
try:
    with open(os.path.join(tree, resolver), encoding="utf-8") as fh:
        body = ast.parse(fh.read()).body
    for node in body:
        if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == "EXTENSIONS" for t in node.targets):
            table = ast.literal_eval(node.value)
except (OSError, SyntaxError, ValueError):
    table = None
if not (isinstance(table, dict) and table and all(isinstance(v, (tuple, list)) and all(isinstance(e, str) and e for e in v)
                                                  for v in table.values())):
    print(f"{resolver} holds no EXTENSIONS table of kinds and extensions to hold the ignore files to")
    sys.exit(0)
def forms(ext):
    """Lower, upper and both alternations: every letter of the extension in both cases."""
    alt = "".join(c.upper() if i % 2 else c.lower() for i, c in enumerate(ext))
    return list(dict.fromkeys([ext.lower(), ext.upper(), alt, alt.swapcase()]))
scratch = tempfile.mkdtemp(prefix="sv-check22.")
try:
    subprocess.run(["git", "init", "-q", "--template=", scratch], check=True, capture_output=True)
    asked, owner = [], {}
    for rel in ignores:
        folder = os.path.dirname(rel)
        os.makedirs(os.path.join(scratch, folder), exist_ok=True)
        shutil.copyfile(os.path.join(tree, rel), os.path.join(scratch, rel))
        for kind, exts in table.items():
            for ext in exts:
                for f in forms(ext):
                    name = f"{folder}/x.{f}"
                    asked.append(name)
                    owner[name] = (rel, ext, kind)
        asked.append(f"{folder}/external.toml")
    out = subprocess.run(["git", "-C", scratch, "-c", "core.excludesFile=/dev/null", "check-ignore", "--no-index", "--stdin"],
                         input="\n".join(asked) + "\n", capture_output=True, text=True)
    if out.returncode not in (0, 1):
        print(f"git check-ignore could not read the ignore files: {out.stderr.strip()[:160]}")
        sys.exit(0)
    ignored = set(out.stdout.split("\n"))
    for rel in ignores:
        folder = os.path.dirname(rel)
        missed = {}
        for name in asked:
            if name in owner and owner[name][0] == rel and name not in ignored:
                missed.setdefault((owner[name][1], owner[name][2]), []).append(name.rsplit(".", 1)[1])
        if missed:
            shown = ", ".join(f"{ext} ({'/'.join(fs)}, {kind})" for (ext, kind), fs in sorted(missed.items()))
            print(f"{rel} does not ignore {len(missed)} extension(s) the data-root tool counts as binaries, in every "
                  f"letter case: {shown} — such a file would be committed instead of filed")
        if f"{folder}/external.toml" in ignored:
            print(f"{rel} ignores external.toml — the folder's manifest is its record of what is filed, and is committed")
finally:
    shutil.rmtree(scratch, ignore_errors=True)
PY
)
  fi

  # ── 23. The guide guard in the render (D56) ─────────────────────────────────
  if [[ -f "$TREE/.claude/settings.json" ]]; then
    hits="$(python3 - "$TREE/.claude/settings.json" "$SA_HOWTO_GUARD" "$SA_HOWTO_DENY" <<'PY'
import json, sys
path, script, deny = sys.argv[1:4]
try:
    with open(path, encoding="utf-8") as fh:
        data = json.load(fh)
except Exception:
    sys.exit(0)  # check 20 reports a settings file that does not parse
hooks = data.get("hooks") if isinstance(data, dict) and isinstance(data.get("hooks"), dict) else {}
pre = hooks.get("PreToolUse") if isinstance(hooks.get("PreToolUse"), list) else []
n = sum(1 for e in pre if isinstance(e, dict) and isinstance(e.get("hooks"), list)
        and any(isinstance(h, dict) and script in str(h.get("command", "")) for h in e["hooks"]))
perms = data.get("permissions") if isinstance(data, dict) and isinstance(data.get("permissions"), dict) else {}
if n != 1:
    print(f".claude/settings.json wires the guide guard ({script}) in {n} PreToolUse entries — the seed wires it once")
elif deny not in (perms.get("deny") or []):
    print(f".claude/settings.json does not deny {deny} — the user guide is read-only (D56)")
PY
)"
    if [[ -n "$hits" ]]; then
      finding "check 23 — $hits"
    elif [[ -f "$TREE/$SA_HOWTO_GUARD" && ! -x "$TREE/$SA_HOWTO_GUARD" ]]; then
      finding "check 23 — $SA_HOWTO_GUARD is not executable — the seed's entry runs it with bash, but the copy task and every family template ship it at mode 755"
    fi
  fi

  # ── 24–25. The always-loaded instruction set and the path-scoped rules (D59) ─
  local sa_ext=""; gate_true ext && sa_ext=1
  while IFS=$'\t' read -r n msg; do
    [[ -n "$n" ]] && finding "check $n — $msg"
  done < <(SA_RULE_PATHS_04="$SA_RULE_PATHS_04" SA_RULE_PATHS_09="$SA_RULE_PATHS_09" SA_EXT="$sa_ext" \
    python3 - "$TREE" "$SA_STARTUP_BUDGET" "$SA_SCOPED_LIMIT" "$SA_DATAROOT_PY" <<'PY'
import ast, os, re, sys
def main():
    tree, budget, limit, resolver = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
    R = ".claude/rules/syntek-author/"
    want = {R + "04-build-pipeline.md": os.environ["SA_RULE_PATHS_04"].split("\n"),
            R + "09-data-root.md": os.environ["SA_RULE_PATHS_09"].split("\n")}
    FM = re.compile(r'---\npaths:\n((?:  - "[^"\n]+"\n)+)---\n')
    def read(p):
        with open(p, encoding="utf-8") as fh:
            return fh.read()
    def scoped(t):
        m = FM.match(t)
        return [l[5:-1] for l in m.group(1).splitlines()] if m else None
    loaded, seen = [], set()
    def take(p, depth):
        p = os.path.normpath(p)
        if depth > 4 or p in seen or not os.path.isfile(p):
            return
        seen.add(p); t = read(p); loaded.append((p, len(t))); fence = False
        for line in t.splitlines():
            if line.lstrip().startswith("```"):
                fence = not fence; continue
            if not fence:
                for m in re.finditer(r'(?:^|\s)@([^\s`]+)', re.sub(r'`[^`]*`', '', line)):
                    take(os.path.join(os.path.dirname(p), m.group(1)), depth + 1)
    for s in (".claude/CLAUDE.md", "CLAUDE.md", "CLAUDE.local.md"):
        take(os.path.join(tree, s), 0)
    for root, dirs, files in os.walk(os.path.join(tree, ".claude", "rules")):
        dirs.sort()
        for f in sorted(x for x in files if x.endswith(".md")):
            p = os.path.join(root, f); t = read(p); rel = os.path.relpath(p, tree)
            if scoped(t) is None:
                take(p, 0)
            elif len(t) > limit:
                print(f"24\t{rel} is {len(t):,} characters; Claude Code reads only the first {limit:,} of a rule it loads on demand (D59)")
            if rel.startswith(R) and rel not in want and t.startswith("---\n"):
                print(f"25\t{rel} opens with frontmatter; only 04 and 09 are path-scoped (D59)")
    total = sum(n for _, n in loaded)
    if total > budget:
        top = ", ".join(f"{os.path.relpath(p, tree)} {n:,}" for p, n in sorted(loaded, key=lambda x: -x[1])[:5])
        print(f"24\tthe always-loaded instruction files total {total:,} characters; the budget is {budget:,} (D59): {top}")
    def expand(g):
        m = re.search(r'\{([^{}]*)\}', g)
        return [g] if not m else [x for a in m.group(1).split(",") for x in expand(g[:m.start()] + a + g[m.end():])]
    for rel, globs in want.items():
        p = os.path.join(tree, rel)
        if not os.path.isfile(p):
            continue  # check 6 reports a missing file
        got = scoped(read(p))
        if got is None:
            print(f"25\t{rel} does not open with D59's frontmatter (---, paths:, one double-quoted glob a line, ---): Claude Code would load it at launch"); continue
        if got != globs:
            print(f"25\t{rel}'s paths differ from DESIGN.md Section 4.1 (D59)"); continue
        if sum(len(expand(g)) for g in got if "{" in g) > 1000:
            print(f"25\t{rel}'s braces expand past 1,000 patterns; Claude Code would match the excess literally"); continue
        if rel.endswith("09-data-root.md"):
            try:
                table = next(ast.literal_eval(n.value) for n in ast.parse(read(os.path.join(tree, resolver))).body
                             if isinstance(n, ast.Assign) and any(getattr(x, "id", "") == "EXTENSIONS" for x in n.targets))
                exts = {f for es in table.values() for e in es for f in (e.lower(), e.upper())}
            except Exception:
                if os.environ.get("SA_EXT") != "1":
                    print(f"25\t{rel}: the resolver's EXTENSIONS table cannot be read, so 09's binary globs go unchecked (D59)")
                continue  # under external, check 22 reports it
            named = {e for g in got if "/**/*.{" in g for e in g.rsplit("{", 1)[1].rstrip("}").split(",")}
            miss = sorted(exts - named)
            if miss:
                print(f"25\t{rel}'s binary globs miss {', '.join(miss)}, which the resolver counts as binaries (D59)")
try:
    main()
except Exception as e:
    print(f"25\tthe D59 check could not run: {e!r}")
PY
)
  return 0
}

# Every folder the catalogue names, or holds a catalogued path, in any variant ({L} read as both
# content layers): the folders the data-root map may name (check 17).
catalogued_folders() {
  local gate kind path p
  while read -r gate kind path; do
    [[ -z "$path" ]] && continue
    for p in "${path/\{L\}/manuscript}" "${path/\{L\}/library}"; do
      [[ "$kind" == d ]] && printf '%s\n' "$p"
      while [[ "$p" == */* ]]; do p="${p%/*}"; printf '%s\n' "$p"; done
    done
  done <<< "$SA_PATHS" | sort -u | paste -sd' ' -
}

# Check 14. Each probe runs only where its tool is installed and an unprivileged network
# namespace keeps it off the network, with a scratch HOME, XDG folders and TMPDIR; a probe
# that cannot run is a named skip. Never `codex doctor` (it contacts the network).
OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
CODEX_BIN="${CODEX_BIN:-codex}"
client_probes() {
  local scratch out status line
  if ! command -v unshare >/dev/null 2>&1 || ! unshare -rn true 2>/dev/null; then
    NOTES["check 14 skipped — no unprivileged network namespace (unshare -rn) to keep the clients off the network"]=1
    return 0
  fi
  scratch="$(sa_mktemp)"; mkdir -p "$scratch/home" "$scratch/tmp"
  # OpenCode starts the MCP servers opencode.json declares, and they outlive it: it runs in its
  # own PID namespace too (unshare -p), so every process it starts ends with it and none writes
  # into the scratch folder once it is removed. unshare --fork blocks SIGTERM, so the timeout
  # follows with SIGKILL (-k), which --kill-child passes on to the namespace.
  if has_client opencode && [[ -f "$TREE/opencode.json" ]]; then
    if ! command -v "$OPENCODE_BIN" >/dev/null 2>&1; then
      NOTES["check 14 (opencode debug config) skipped — opencode is not installed"]=1
    elif ! unshare -rnpf --kill-child true 2>/dev/null; then
      NOTES["check 14 (opencode debug config) skipped — no unprivileged PID namespace (unshare -rnpf --kill-child) to end the MCP servers OpenCode starts"]=1
    else
      status=0
      out="$(cd "$TREE" && HOME="$scratch/home" XDG_CONFIG_HOME="$scratch/home/.config" XDG_DATA_HOME="$scratch/home/.local/share" \
             XDG_STATE_HOME="$scratch/home/.local/state" XDG_CACHE_HOME="$scratch/home/.cache" TMPDIR="$scratch/tmp" \
             OPENCODE_DISABLE_MODELS_FETCH=1 timeout -k 10 120 unshare -rnpf --kill-child sh -c 'ip link set lo up 2>/dev/null; exec "$0" debug config --print-logs --log-level warn' "$OPENCODE_BIN" 2>"$scratch/oc.err")" || status=$?
      if [[ "$status" -ne 0 ]]; then
        finding "check 14 — opencode debug config exits $status on this render: $(tail -1 "$scratch/oc.err" | cut -c1-160)"
      elif grep -qi 'configuration normalization diagnostic' "$scratch/oc.err" \
           || grep -rqi 'configuration normalization diagnostic' "$scratch/home/.local/share/opencode/log" 2>/dev/null; then
        finding "check 14 — opencode reports a configuration normalization diagnostic for opencode.json: it skips a malformed value silently"
      else
        while IFS= read -r line; do
          [[ -n "$line" ]] && finding "check 14 — opencode $line"
        done < <(printf '%s' "$out" | python3 -c '
import json, os, sys
tree = os.path.realpath(sys.argv[1])
raw = sys.stdin.read()
try:
    docs = json.loads(raw)
except Exception:
    print("debug config printed no JSON to compare"); sys.exit(0)
mine = json.load(open(os.path.join(tree, "opencode.json"), encoding="utf-8"))
info = next((d.get("info") or {} for d in docs if os.path.realpath(d.get("path", "")) == os.path.join(tree, "opencode.json")), None)
if info is None:
    print("did not load the opencode.json of this render"); sys.exit(0)
for k in mine:
    if k not in info: print(f"dropped the key {k} from opencode.json while normalising it")
mp, ip = mine.get("providers") or {}, info.get("providers") or {}
for p in (mp if "providers" in info else []):
    if p not in ip: print(f"dropped the provider {p} from opencode.json: one malformed field drops the whole provider")
    elif set((mp[p].get("models") or {})) != set((ip[p].get("models") or {})): print(f"dropped a model of {p} from opencode.json")
if len(mine.get("permissions") or []) != len(info.get("permissions") or []):
    print("dropped a permissions rule from opencode.json while normalising it")
' "$TREE")
      fi
    fi
  fi
  if [[ "$(uname -s)" == Linux ]]; then
    if command -v "$CODEX_BIN" >/dev/null 2>&1; then
      status=0
      out="$(cd /tmp && CODEX_HOME="$scratch/home" HOME="$scratch/home" TMPDIR="$scratch/tmp" \
             timeout -k 10 120 unshare -rn "$CODEX_BIN" sandbox -P :workspace -C "$TREE" -- true 2>&1)" || status=$?
      [[ "$status" -eq 0 ]] || finding "check 14 — a sandboxed Codex command fails in this render (exit $status): $(printf '%s\n' "$out" | grep -v '^[[:space:]]*$' | head -1 | cut -c1-200)"
    else
      NOTES["check 14 (codex sandbox) skipped — codex is not installed"]=1
    fi
  fi
  rm -rf "$scratch" 2>/dev/null || { sleep 1; rm -rf "$scratch" 2>/dev/null; } \
    || NOTES["check 14 left its scratch folder $scratch: a client's process was still writing in it"]=1
  return 0
}

# ── Self-test ────────────────────────────────────────────────────────────────

# The two D54 servers as each client file writes them (check 12), read from the shared bytes.
mcp_servers_json() { # → .mcp.json's mcpServers, on one line
  python3 - "$SA_MCP_SHARED" <<'PY'
import json, sys
print(json.dumps(json.loads(sys.argv[1])["mcpServers"]))
PY
}
mcp_opencode_json() { # → opencode.json's mcp.servers, on one line
  python3 - "$SA_MCP_SHARED" <<'PY'
import json, sys
out = {}
for name, srv in json.loads(sys.argv[1])["mcpServers"].items():
    out[name] = {"type": "local", "command": [srv["command"]] + srv["args"]}
    if srv.get("env"):
        out[name]["environment"] = srv["env"]
print(json.dumps(out))
PY
}
mcp_codex_toml() { # → .codex/config.toml's [mcp_servers.*] tables
  python3 - "$SA_MCP_SHARED" <<'PY'
import json, sys
for name, srv in json.loads(sys.argv[1])["mcpServers"].items():
    args = ", ".join(json.dumps(a) for a in srv["args"])
    print("\n[mcp_servers.%s]\ncommand = %s\nargs = [%s]" % (name, json.dumps(srv["command"]), args))
    if srv.get("env"):
        print("\n[mcp_servers.%s.env]" % name)
        for key, value in srv["env"].items():
            print("%s = %s" % (key, json.dumps(value)))
PY
}

# The guard step both Drive workflows hold (check 21), in the template's shape.
write_drive_workflow() { # $1 = file, $2 = workflow name
  mkdir -p "$(dirname "$1")"
  { printf 'name: %s\n\njobs:\n  sync:\n    runs-on: ubuntu-latest\n    steps:\n' "$2"
    printf '      - name: Checkout repository\n        uses: actions/checkout@v4\n\n'
    printf '      - name: %s\n' "$SA_DRIVE_GUARD_STEP"
    cat <<'YML'
        run: |
          store=""
          if [ -f .copier-answers.syntek-author.yml ]; then
            store="$(sed -n 's/^DATA_STORE: *//p' .copier-answers.syntek-author.yml)"
          fi
          if [ -n "$store" ] && [ "$store" != repo ]; then
            echo "::error::DATA_STORE is '$store'"
            exit 1
          fi

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
YML
  } > "$1"
}

build_tree() { # $1 = dir — every path the catalogue says the current answers open
  local t="$1" s g m gate kind path p mf servers oc
  mkdir -p "$t/$(content_layer)" "$t/.claude/skills"
  while read -r gate kind path; do
    [[ -z "$gate" ]] && continue
    gate_true "$gate" || continue
    p="$(expand_layer "$path")"
    if [[ "$kind" == l ]]; then mkdir -p "$(dirname "$t/$p")"; ln -s "$SA_AGENTS_LINK_TARGET" "$t/$p"
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
  # The store and the provider (D50, D53); the layout answers only under external.
  printf 'DATA_STORE: %s\nDATA_PROVIDER: %s\n' "$A_STORE" "$A_PROVIDER" >> "$t/$SA_ANSWERS_FILE"
  [[ "$A_STORE" == external ]] && printf 'DATA_AREA: business\nDATA_SLUG: gen\nDATA_KIND_DOCS: docs\nDATA_KIND_PHOTOS: photos\nDATA_KIND_AUDIO: audio\nDATA_KIND_VIDEOS: videos\n' \
    >> "$t/$SA_ANSWERS_FILE"
  if [[ -n "${A_CLIENTS// /}" ]]; then
    printf 'AGENT_CLIENTS:\n' >> "$t/$SA_ANSWERS_FILE"
    printf -- '- %s\n' $A_CLIENTS >> "$t/$SA_ANSWERS_FILE"
    printf 'CODEX_MODEL: ""\nGEMINI_MODEL: ""\nOPENCODE_PROVIDER: ollama\nOPENCODE_BASE_URL: http://127.0.0.1:11434/v1/\nOPENCODE_MODEL: qwen3:30b\nOPENCODE_CONTEXT: 32768\n' >> "$t/$SA_ANSWERS_FILE"
    servers="$(mcp_servers_json)"; oc="$(mcp_opencode_json)"
    has_client codex && { printf "project_doc_fallback_filenames = ['CLAUDE.md']\n"; mcp_codex_toml; } > "$t/.codex/config.toml"
    has_client gemini-cli && printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s}\n' "$servers" > "$t/.gemini/settings.json"
    has_client antigravity && printf '%s' "$SA_MCP_SHARED" > "$t/.agents/mcp_config.json"
    has_client opencode && cat > "$t/opencode.json" <<JSON
{"model": "ollama/qwen3:30b",
 "providers": {"ollama": {"package": "@opencode/ai/providers/openai-compatible", "settings": {"baseURL": "http://127.0.0.1:11434/v1"},
   "models": {"qwen3:30b": {"modelID": "qwen3:30b", "capabilities": {"tools": true}, "limit": {"context": 32768, "output": 8192}}}}},
 "compaction": {"auto": false},
 "mcp": {"servers": ${oc}},
 "permissions": [{"action": "edit", "resource": "*.pdf", "effect": "deny"}, {"action": "edit", "resource": "build/*", "effect": "deny"},
                 {"action": "edit", "resource": "how-to/*", "effect": "deny"}, {"action": "edit", "resource": "typeset/src/units/.base/*", "effect": "deny"}]}
JSON
  fi
  # The permissions script and the data-root resolver (always ship): stand-ins that exit as
  # STUB_PERM_EXIT and STUB_DR_EXIT say. The map, in the template's shape.
  printf 'import os, sys\nsys.exit(int(os.environ.get("STUB_PERM_EXIT", "0")))\n' > "$t/.claude/syntek-author-permissions.py"
  # The resolver's stand-in carries a kind table, which the ignore files are held to (check 22).
  printf 'import os, sys\nEXTENSIONS = {"docs": ("pdf", "7z"), "photos": ("png",), "audio": ("wav",), "videos": ("m2ts",)}\nsys.exit(int(os.environ.get("STUB_DR_EXIT", "0")))\n' \
    > "$t/$SA_DATAROOT_PY"
  for p in $SA_DATAROOT_IGNORES; do
    [[ -f "$t/$p" ]] && printf '# Binary records\n*.[pP][dD][fF]\n*.7[zZ]\n*.[pP][nN][gG]\n*.[wW][aA][vV]\n*.[mM]2[tT][sS]\n!external.toml\n' > "$t/$p"
  done
  printf '{\n  "format": 1,\n  "folders": [\n    {"path": "library/src", "kind": "docs"},\n    {"path": "research/src"},\n    {"path": "proposal/src"},\n    {"path": "assets", "warn_over_kib": 1024},\n    {"path": "world/src"}\n  ]\n}\n' \
    > "$t/$SA_DATAROOT_MAP"
  # The seed settings.json: the data-root guard, once (check 20), then the guide guard, and the
  # guide's deny (check 23); the guard script at mode 755.
  python3 -c 'import json, sys; print(json.dumps({"hooks": {"PreToolUse": [{"matcher": sys.argv[1], "hooks": [{"type": "command", "command": sys.argv[2], "timeout": 10}]}, {"matcher": sys.argv[3], "hooks": [{"type": "command", "command": sys.argv[4], "timeout": 10}]}]}, "permissions": {"deny": ["Edit(build/**)", sys.argv[5]]}}, indent=2))' \
    "$SA_GUARD_MATCHER" "$SA_GUARD_CMD" "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" > "$t/.claude/settings.json"
  chmod +x "$t/$SA_HOWTO_GUARD"
  if gate_true drive; then
    write_drive_workflow "$t/.github/workflows/google-drive-push.yml" "Push Documents to Google Drive"
    write_drive_workflow "$t/.github/workflows/google-drive-pull.yml" "Pull Documents from Google Drive"
  fi
  # Rules 04 and 09 with D59's frontmatter (checks 24 and 25); .claude/CLAUDE.md imports CONTEXT.md.
  local rn globs
  for rn in 04-build-pipeline 09-data-root; do
    [[ "$rn" == 04-* ]] && globs="$SA_RULE_PATHS_04" || globs="$SA_RULE_PATHS_09"
    { printf -- '---\npaths:\n'; while IFS= read -r g; do printf '  - "%s"\n' "$g"; done <<< "$globs"; printf -- '---\n\n# %s\n' "${rn%%-*}"; } \
      > "$t/.claude/rules/syntek-author/$rn.md"
  done
  printf '@../CONTEXT.md\n' > "$t/.claude/CLAUDE.md"
  # Rules 05: Section 4 and one row per client chosen.
  { printf '# 05 — model allocation\n\n## 3. Why\n'
    if [[ -n "${A_CLIENTS// /}" ]]; then
      printf '\n## 4. Other coding agents\n\n| Client | Model | Set in |\n|---|---|---|\n'
      has_client codex && printf "| Codex | Codex's own default | x |\n"
      has_client gemini-cli && printf "| Gemini CLI | Gemini CLI's own default | x |\n"
      has_client antigravity && printf '| Antigravity | chosen in the app | x |\n'
      has_client opencode && printf '| OpenCode | `qwen3:30b` | x |\n'
    fi; } > "$t/.claude/rules/syntek-author/05-model-allocation.md"
  return 0
}

# Stand-ins for opencode and codex (check 14): opencode prints its debug config for the
# opencode.json in the folder it starts in (dropping the providers when STUB_DROP is set),
# codex's sandbox fails when STUB_SANDBOX_FAIL is set.
write_client_stubs() { # $1 = bin dir
  mkdir -p "$1"
  cat > "$1/opencode" <<'STUB'
#!/usr/bin/env bash
python3 - "$PWD/opencode.json" <<'P'
import json, os, sys
d = json.load(open(sys.argv[1]))
if os.environ.get("STUB_DROP"): d.pop("providers", None)
print(json.dumps([{"type": "document", "path": sys.argv[1], "info": d}]))
P
STUB
  cat > "$1/codex" <<'STUB'
#!/usr/bin/env bash
if [ -n "${STUB_SANDBOX_FAIL:-}" ]; then echo "error building bubblewrap command: crosses writable symlink .agents" >&2; exit 1; fi
exit 0
STUB
  chmod +x "$1/opencode" "$1/codex"
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  A_DOC_TYPE=theology; A_PROPOSAL=true; A_REFS=true; A_SENSITIVE=false; A_WB=false; A_CONLANG=false
  A_PROVIDER=none; A_STORE=external; A_SEED=true; A_CLIENTS="codex gemini-cli antigravity opencode"
  local servers oc; servers="$(mcp_servers_json)"; oc="$(mcp_opencode_json)"
  # Check 14 runs the stand-ins, never the installed clients: a self-test proves the detector,
  # and the real clients are probed on real renders.
  local real_oc="$OPENCODE_BIN" real_cx="$CODEX_BIN"
  write_client_stubs "$tmp/bin"; OPENCODE_BIN="$tmp/bin/opencode"; CODEX_BIN="$tmp/bin/codex"
  TREE="$tmp/gen"; EXPECT=""
  build_tree "$TREE"
  st_baseline "a theology tree built from the catalogue, its documents under the data root"

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
  mkdir -p "$TREE/how-to/workflows/syntek-author/05-invent-a-procedure"
  probe "check 7 fires on a how-to procedure DESIGN.md does not number" "check 7 — how-to/workflows/syntek-author/05-invent-a-procedure/ is a how-to procedure"
  rmdir "$TREE/how-to/workflows/syntek-author/05-invent-a-procedure"
  printf 'x\n' > "$TREE/how-to/src/TEMPLATE-GUIDE/syntek-author/15-a-novel.md"
  probe "check 6 fires when another variant's chapter of the user guide ships" "check 6 — how-to/src/TEMPLATE-GUIDE/syntek-author/15-a-novel.md leaked"
  rm -f "$TREE/how-to/src/TEMPLATE-GUIDE/syntek-author/15-a-novel.md"

  printf 'x\n' > "$TREE/copier.yml"
  probe "check 8 fires when copier.yml leaks" "check 8 — copier.yml"
  rm -f "$TREE/copier.yml"

  printf 'Hello <%%PROJECT_NAME%%>\n' >> "$TREE/README.md"
  probe "check 9 fires on a surviving token" "check 9 — README.md"
  printf 'x\n' > "$TREE/README.md"

  printf 'DOC_TYPE=theology\nINCLUDE_REFERENCES=false\n' > "$tmp/expect"; EXPECT="$tmp/expect"
  probe "check 10 fires when the recorded answers differ from DESIGN.md's" "check 10 — the render recorded INCLUDE_REFERENCES=true"
  EXPECT=""

  rm "$TREE/.agents/skills"; ln -s ../.claude "$TREE/.agents/skills"
  probe "check 6 fires when .agents/skills links anywhere but ../.claude/skills" "check 6 — .agents/skills links to ../.claude,"
  rm "$TREE/.agents/skills"; mkdir "$TREE/.agents/skills"; printf 'x\n' > "$TREE/.agents/skills/CONTEXT.md"
  probe "check 6 fires when .agents/skills is a copy" "check 6 — .agents/skills is missing or not a link"
  rm -rf "$TREE/.agents/skills"; ln -s "$SA_AGENTS_LINK_TARGET" "$TREE/.agents/skills"
  mv "$TREE/.agents" "$TREE/.agents-real"; ln -s .agents-real "$TREE/.agents"
  probe "check 6 fires when .agents is a link" "check 6 — .agents is a link"
  rm "$TREE/.agents"; mv "$TREE/.agents-real" "$TREE/.agents"
  mv "$TREE/.claude/syntek-author-agents.md" "$tmp/held"
  probe "check 6 fires when the bridge is missing" "check 6 — .claude/syntek-author-agents.md is missing"
  mv "$tmp/held" "$TREE/.claude/syntek-author-agents.md"
  printf '%s' "$SA_MCP_SHARED" > "$TREE/.claude/mcp_config.json"
  probe "check 8 fires when the retired .claude/mcp_config.json ships" "check 8 — .claude/mcp_config.json"
  rm -f "$TREE/.claude/mcp_config.json"

  mv "$TREE/proposal/src/.gitignore" "$tmp/held"
  probe "check 6 fires when a data-root ignore file is missing under external" "check 6 — proposal/src/.gitignore is missing (gate: prop-ext is open)"
  mv "$tmp/held" "$TREE/proposal/src/.gitignore"
  mv "$TREE/$SA_DATAROOT_PY" "$tmp/held"
  probe "check 6 fires when the data-root resolver is missing" "check 6 — $SA_DATAROOT_PY is missing"
  mv "$tmp/held" "$TREE/$SA_DATAROOT_PY"
  printf 'DATA_STORE=repo\n' > "$tmp/expect"; EXPECT="$tmp/expect"
  probe "check 10 fires when the recorded store differs from DESIGN.md's" "check 10 — the render recorded DATA_STORE=external"
  printf 'ABSENT=DATA_SLUG\n' > "$tmp/expect"
  probe "check 15 fires when a hidden data-root answer is recorded" "check 15 — the answers record DATA_SLUG"
  EXPECT=""

  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s, "model": {"name": "gemini-x"}}\n' "$servers" > "$TREE/.gemini/settings.json"
  probe "check 12 fires when Gemini CLI's model is not the answer" "check 12 — .gemini/settings.json sets model.name 'gemini-x'"
  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s, "GEMINI_API_KEY": "example"}\n' "$servers" > "$TREE/.gemini/settings.json"
  probe "check 12 fires on a credential key in capitals" "check 12 — .gemini/settings.json carries a credential key (GEMINI_API_KEY)"
  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": {}}\n' > "$TREE/.gemini/settings.json"
  probe "check 12 fires when a client file declares no MCP server" "check 12 — .gemini/settings.json declares no MCP server"
  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s}\n' "$servers" > "$TREE/.gemini/settings.json"
  cp "$TREE/.codex/config.toml" "$tmp/cx"
  sed -i 's/scrapling\[ai\]==0\.4\.15/scrapling[ai]==0.4.14/' "$TREE/.codex/config.toml"
  probe "check 12 fires when Codex pins another Scrapling" "check 12 — .codex/config.toml declares scrapling with another command, arguments or blank keys"
  cp "$tmp/cx" "$TREE/.codex/config.toml"

  sed -i 's#ollama/qwen3:30b#vllm/qwen3:30b#' "$TREE/opencode.json"
  probe "check 12 fires when opencode.json names another model" "check 12 — opencode.json sets model 'vllm/qwen3:30b'"
  sed -i 's#vllm/qwen3:30b#ollama/qwen3:30b#' "$TREE/opencode.json"
  cp "$TREE/opencode.json" "$tmp/oc"
  sed -i 's#11434/v1"#11434/v1/"#' "$TREE/opencode.json"
  probe "check 12 fires when the baseURL keeps its trailing slash" "check 12 — opencode.json's baseURL is 'http://127.0.0.1:11434/v1/'"
  cp "$tmp/oc" "$TREE/opencode.json"; sed -i 's#"context": 32768#"context": "32768"#' "$TREE/opencode.json"
  probe "check 12 fires when limit.context is a string" "check 12 — opencode.json's limit.context is '32768'"
  cp "$tmp/oc" "$TREE/opencode.json"; sed -i 's# "compaction": {"auto": false},##' "$TREE/opencode.json"
  probe "check 12 fires when compaction is left on" "check 12 — opencode.json does not set compaction.auto false"
  cp "$tmp/oc" "$TREE/opencode.json"; sed -i 's#"resource": "build/\*"#"resource": "build/**"#' "$TREE/opencode.json"
  probe "check 12 fires when a mapped deny is missing" "check 12 — opencode.json does not deny edits to build/*"
  cp "$tmp/oc" "$TREE/opencode.json"
  sed -i 's#"effect": "deny"}]}#"effect": "deny"}, {"action": "edit", "resource": "*", "effect": "allow"}]}#' "$TREE/opencode.json"
  probe "check 12 fires on a rule after the denies" "check 12 — opencode.json has a rule after its denies"
  cp "$tmp/oc" "$TREE/opencode.json"
  sed -i 's#"GOOGLE_API_KEY": ""#"GOOGLE_API_KEY": "example"#' "$TREE/opencode.json"
  probe "check 12 fires when a blank key carries a value" "check 12 — opencode.json carries a credential key (GOOGLE_API_KEY with a value)"
  cp "$tmp/oc" "$TREE/opencode.json"
  python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); del d["mcp"]["servers"]["scrapling"]; json.dump(d, open(sys.argv[1], "w"))' "$TREE/opencode.json"
  probe "check 12 fires when opencode.json drops a server" "check 12 — opencode.json declares the MCP servers ['code-review-graph']"
  cp "$tmp/oc" "$TREE/opencode.json"
  cp "$TREE/$SA_ANSWERS_FILE" "$tmp/answers"
  sed -i 's/^OPENCODE_PROVIDER: ollama$/OPENCODE_PROVIDER: user/' "$TREE/$SA_ANSWERS_FILE"
  printf '{"$schema": "https://opencode.ai/config.json", "compaction": {"auto": false}, "mcp": {"servers": %s},\n "permissions": [{"action": "edit", "resource": "*.pdf", "effect": "deny"}, {"action": "edit", "resource": "build/*", "effect": "deny"}, {"action": "edit", "resource": "how-to/*", "effect": "deny"}, {"action": "edit", "resource": "typeset/src/units/.base/*", "effect": "deny"}]}\n' "$oc" \
    > "$TREE/opencode.json"
  probe_clean "check 12 holds the user provider's opencode.json, which declares the MCP servers"
  cp "$tmp/answers" "$TREE/$SA_ANSWERS_FILE"; cp "$tmp/oc" "$TREE/opencode.json"
  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s}\n' "$servers" > "$TREE/.gemini/settings.json"
  probe_clean "check 12 holds Gemini CLI's file with the two servers"
  printf '{"mcpServers": %s}\n' "$servers" > "$TREE/.gemini/settings.json"
  probe "check 12 fires when Gemini CLI does not exclude ask_user" "check 12 — .gemini/settings.json does not exclude ask_user"
  printf '{"tools": {"exclude": ["ask_user"]}, "mcpServers": %s}\n' "$servers" > "$TREE/.gemini/settings.json"
  printf '%s' "$SA_MEDIA04_AGENTS_MCP" > "$TREE/.agents/mcp_config.json"
  probe "check 12 fires when Antigravity's MCP file is not .mcp.json's bytes" "check 12 — .agents/mcp_config.json is not byte for byte .mcp.json"
  printf '%s' "$SA_MCP_SHARED" > "$TREE/.agents/mcp_config.json"
  STUB_PERM_EXIT=1 probe "check 13 fires when the permissions script finds drift" "check 13 — .claude/syntek-author-permissions.py --check exits 1"
  if unshare -rn true 2>/dev/null; then
    STUB_DROP=1 probe "check 14 fires when OpenCode drops a malformed provider" "check 14 — opencode dropped the key providers"
    STUB_SANDBOX_FAIL=1 probe "check 14 fires when a sandboxed Codex command fails" "check 14 — a sandboxed Codex command fails"
  else
    log "  - check 14 not proven: no unprivileged network namespace (unshare -rn) here"
  fi
  printf 'ABSENT=GEMINI_MODEL\n' > "$tmp/expect"; EXPECT="$tmp/expect"
  probe "check 15 fires when a hidden answer is recorded" "check 15 — the answers record GEMINI_MODEL"
  printf 'NOTEXT=trap-\n' > "$tmp/expect"
  probe_clean "check 15 holds a render that carries no hidden value"
  printf 'trap-bad!model\n' >> "$TREE/README.md"
  probe "check 15 fires when a hidden value is rendered" "check 15 — README.md carries 'trap-'"
  printf 'x\n' > "$TREE/README.md"
  EXPECT=""
  cp "$TREE/.claude/rules/syntek-author/05-model-allocation.md" "$tmp/r05"
  sed -i '/^| Antigravity |/d' "$TREE/.claude/rules/syntek-author/05-model-allocation.md"
  probe "check 16 fires when a chosen client has no rules 05 row" "check 16 — rules 05 has no Antigravity row"
  cp "$tmp/r05" "$TREE/.claude/rules/syntek-author/05-model-allocation.md"

  cp "$TREE/$SA_DATAROOT_MAP" "$tmp/map"
  sed -i 's#"path": "world/src"#"path": "papers/src"#' "$TREE/$SA_DATAROOT_MAP"
  probe "check 17 fires when the map names a folder no variant ships" "check 17 — $SA_DATAROOT_MAP names papers/src, a folder no variant ships"
  printf '{"format": 1, "folders": [\n' > "$TREE/$SA_DATAROOT_MAP"
  probe "check 17 fires when the map does not parse" "check 17 — $SA_DATAROOT_MAP does not parse as JSON"
  sed 's#"format": 1#"format": 2#' "$tmp/map" > "$TREE/$SA_DATAROOT_MAP"
  probe "check 17 fires on a map of a later format" "check 17 — $SA_DATAROOT_MAP is not format 1"
  # The keys a map may carry beyond this template's own (K8): roles, a working-output folder,
  # and keys the resolver does not know; then one value it refuses at a time.
  st_dr_map() { # $1 = the roles list as JSON, $2 = extra keys for the world/src entry
    printf '{\n  "format": 1,\n  "folders": [\n    {"path": "library/src", "kind": "docs"},\n    {"path": "research/src"},\n    {"path": "proposal/src"},\n    {"path": "assets", "warn_over_kib": 1024},\n    {"path": "world/src"%s}\n  ],\n  "roles": %s\n}\n' \
      "$2" "$1" > "$TREE/$SA_DATAROOT_MAP"
  }
  st_dr_map '[{"name": "take", "evidence": true, "repo": "skip"}, {"name": "brand-export", "evidence": true, "rights": "x"}, {"name": "draft-cut", "evidence": false}]' ', "rows": "none", "id": 7'
  probe_clean "check 17 holds a map with its own roles, a working-output folder and keys it does not know"
  st_dr_map '[{"name": "photos", "evidence": true}]' ''
  probe "check 17 fires on a role named after a kind" "check 17 — $SA_DATAROOT_MAP defines the role 'photos', a kind's name"
  st_dr_map '[{"name": "signed", "evidence": true}]' ''
  probe "check 17 fires on a role named after a shared role" "check 17 — $SA_DATAROOT_MAP defines the role 'signed', a shared role's name"
  st_dr_map '[{"name": "brand-", "evidence": true}]' ''
  probe "check 17 fires on a role name that is not words joined by hyphens" "check 17 — $SA_DATAROOT_MAP roles[0] is named 'brand-'"
  st_dr_map '[{"name": "take", "evidence": true}, {"name": "take", "evidence": true}]' ''
  probe "check 17 fires on a role defined twice" "check 17 — $SA_DATAROOT_MAP defines the role 'take' twice"
  st_dr_map '[{"name": "take"}]' ''
  probe "check 17 fires on a role with no evidence flag" "check 17 — $SA_DATAROOT_MAP gives the role 'take' evidence None"
  st_dr_map '[{"name": "take", "evidence": true, "repo": "never"}]' ''
  probe "check 17 fires on a repo value other than skip" "check 17 — $SA_DATAROOT_MAP gives the role 'take' repo 'never'"
  st_dr_map '{"name": "take", "evidence": true}' ''
  probe "check 17 fires on roles that are not a list" "check 17 — $SA_DATAROOT_MAP holds roles that are not a list"
  st_dr_map '[]' ', "rows": "some"'
  probe "check 17 fires on a rows value other than none" "check 17 — $SA_DATAROOT_MAP gives world/src rows 'some'"
  st_dr_map '[]' ', "warn_over_kib": 0'
  probe "check 17 fires on a size warning that is not a positive integer" "check 17 — $SA_DATAROOT_MAP gives world/src warn_over_kib 0"
  cp "$tmp/map" "$TREE/$SA_DATAROOT_MAP"
  STUB_DR_EXIT=1 probe "check 18 fires when the resolver's self-test fails in the render" "check 18 — $SA_DATAROOT_PY --self-test exits 1"
  printf 'format = 1\n' > "$TREE/research/src/external.toml"
  probe "check 19 fires when a manifest ships" "check 19 — research/src/external.toml ships"
  rm -f "$TREE/research/src/external.toml"
  cp "$TREE/.claude/settings.json" "$tmp/seed"
  python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); d["hooks"]["PreToolUse"].append(d["hooks"]["PreToolUse"][0]); json.dump(d, open(sys.argv[1], "w"))' "$TREE/.claude/settings.json"
  probe "check 20 fires when the seed wires the guard twice" "check 20 — .claude/settings.json wires the data-root guard 2 times"
  cp "$tmp/seed" "$TREE/.claude/settings.json"
  python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); d["hooks"] = {"PostToolUse": d["hooks"]["PreToolUse"][:1], "PreToolUse": d["hooks"]["PreToolUse"][1:]}; json.dump(d, open(sys.argv[1], "w"))' "$TREE/.claude/settings.json"
  probe "check 20 fires when the guard runs on another event" "check 20 — .claude/settings.json wires the data-root guard on PostToolUse"
  cp "$tmp/seed" "$TREE/.claude/settings.json"
  chmod -x "$TREE/$SA_HOWTO_GUARD"
  probe "check 23 fires when the guide guard is not executable" "check 23 — $SA_HOWTO_GUARD is not executable"
  chmod +x "$TREE/$SA_HOWTO_GUARD"
  python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); d["hooks"]["PreToolUse"].pop(); json.dump(d, open(sys.argv[1], "w"))' "$TREE/.claude/settings.json"
  probe "check 23 fires when the seed does not wire the guide guard" "check 23 — .claude/settings.json wires the guide guard ($SA_HOWTO_GUARD) in 0 PreToolUse entries"
  cp "$tmp/seed" "$TREE/.claude/settings.json"
  python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); d["permissions"]["deny"].remove(sys.argv[2]); json.dump(d, open(sys.argv[1], "w"))' "$TREE/.claude/settings.json" "$SA_HOWTO_DENY"
  probe "check 23 fires when the seed does not deny the guide" "check 23 — .claude/settings.json does not deny $SA_HOWTO_DENY"
  cp "$tmp/seed" "$TREE/.claude/settings.json"
  cp "$TREE/research/src/.gitignore" "$tmp/ig"
  sed -i '/^\*\.\[wW\]\[aA\]\[vV\]$/d' "$TREE/research/src/.gitignore"
  probe "check 22 fires when an ignore file misses a binary type the resolver counts" "check 22 — research/src/.gitignore does not ignore 1 extension(s) the data-root tool counts as binaries, in every letter case: wav (wav/WAV/wAv/WaV, audio)"
  cp "$tmp/ig" "$TREE/research/src/.gitignore"
  sed -i 's/^\*\.\[pP\]\[dD\]\[fF\]$/*.pdf/' "$TREE/research/src/.gitignore"
  probe "check 22 fires when an ignore file ignores a type in one letter case only" "check 22 — research/src/.gitignore does not ignore 1 extension(s) the data-root tool counts as binaries, in every letter case: pdf (PDF/pDf/PdF, docs)"
  cp "$tmp/ig" "$TREE/research/src/.gitignore"
  printf '*.toml\n' >> "$TREE/research/src/.gitignore"
  probe "check 22 fires when an ignore file ignores the manifest" "check 22 — research/src/.gitignore ignores external.toml"
  cp "$tmp/ig" "$TREE/research/src/.gitignore"
  cp "$TREE/$SA_DATAROOT_PY" "$tmp/dr"
  printf 'import sys\nsys.exit(0)\n' > "$TREE/$SA_DATAROOT_PY"
  probe "check 22 fires when the resolver holds no kind table to read" "check 22 — $SA_DATAROOT_PY holds no EXTENSIONS table"
  cp "$tmp/dr" "$TREE/$SA_DATAROOT_PY"
  # D59: the always-loaded set, its imports, the on-demand limit and the frontmatter's shape.
  local r="$TREE/.claude/rules/syntek-author"
  cp "$r/01-layout-and-routing.md" "$tmp/r01"
  head -c "$SA_STARTUP_BUDGET" /dev/zero | tr '\0' x >> "$r/01-layout-and-routing.md"
  probe "check 24 fires when the always-loaded instruction files pass the budget" "check 24 — the always-loaded instruction files total"
  cp "$tmp/r01" "$r/01-layout-and-routing.md"
  cp "$TREE/.claude/CLAUDE.md" "$tmp/cm"; cp "$TREE/.claude/MEMORY.md" "$tmp/mem"
  printf '@MEMORY.md\n' >> "$TREE/.claude/CLAUDE.md"
  head -c "$SA_STARTUP_BUDGET" /dev/zero | tr '\0' x >> "$TREE/.claude/MEMORY.md"
  probe "check 24 counts a file .claude/CLAUDE.md imports" "check 24 — the always-loaded instruction files total"
  cp "$tmp/cm" "$TREE/.claude/CLAUDE.md"; cp "$tmp/mem" "$TREE/.claude/MEMORY.md"
  cp "$r/04-build-pipeline.md" "$tmp/r04"
  head -c "$SA_SCOPED_LIMIT" /dev/zero | tr '\0' x >> "$r/04-build-pipeline.md"
  probe "check 24 fires when a path-scoped rule passes the on-demand limit" "check 24 — .claude/rules/syntek-author/04-build-pipeline.md is"
  cp "$tmp/r04" "$r/04-build-pipeline.md"
  sed -i 's#^  - "\(\*\*/\*\.{cls.*\)"$#  - \1#' "$r/04-build-pipeline.md"
  probe "check 25 fires when a glob is not quoted" "check 25 — .claude/rules/syntek-author/04-build-pipeline.md does not open with D59's frontmatter"
  cp "$tmp/r04" "$r/04-build-pipeline.md"
  cp "$r/07-session-boundaries.md" "$tmp/r07"
  { printf -- '---\npaths:\n  - "x"\n---\n'; cat "$tmp/r07"; } > "$r/07-session-boundaries.md"
  probe "check 25 fires when another rules file opens with frontmatter" "check 25 — .claude/rules/syntek-author/07-session-boundaries.md opens with frontmatter"
  cp "$tmp/r07" "$r/07-session-boundaries.md"

  # A business tree with two of the six families chosen: the family gates in both directions.
  # Claude Code only: no other client's file may ship. Its documents stay in the repository,
  # with the Google Drive workflows (D53).
  A_CLIENTS=""
  A_DOC_TYPE=business; A_PROPOSAL=false; A_REFS=false; A_FAMILIES="business legal"
  A_PROVIDER=google-drive; A_STORE=repo
  TREE="$tmp/biz"
  build_tree "$TREE"
  st_baseline "a business tree with the business and legal families, Google Drive and the repository store"

  mv "$TREE/.claude/skills/legal-documents" "$tmp/held"
  probe "check 2 fires when a chosen family's skill is missing" "check 2 — skill legal-documents"
  mv "$tmp/held" "$TREE/.claude/skills/legal-documents"

  printf '# x\n' > "$TREE/AGENTS.md"
  probe "check 6 fires when an entrypoint ships with no client chosen" "check 6 — AGENTS.md leaked"
  rm -f "$TREE/AGENTS.md"
  printf '\n## 4. Other coding agents\n' >> "$TREE/.claude/rules/syntek-author/05-model-allocation.md"
  probe "check 16 fires when rules 05 names agents in a Claude-only project" "check 16 — rules 05 has a Section 4"
  printf '# 05 — model allocation\n\n## 3. Why\n' > "$TREE/.claude/rules/syntek-author/05-model-allocation.md"

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

  printf 'x\n' > "$TREE/research/src/.gitignore"
  probe "check 6 fires when a data-root ignore file ships under repo" "check 6 — research/src/.gitignore leaked into this project (gate: ext is shut)"
  rm -f "$TREE/research/src/.gitignore"
  local wf="$TREE/.github/workflows"
  cp "$wf/google-drive-pull.yml" "$tmp/pull"; cp "$wf/google-drive-push.yml" "$tmp/push"
  awk -v g="      - name: $SA_DRIVE_GUARD_STEP" '$0 == g { skip = 1; next } skip && /^      - name: / { skip = 0 } !skip' "$tmp/pull" > "$wf/google-drive-pull.yml"
  probe "check 21 fires when a Drive workflow loses the store guard step" "check 21 — .github/workflows/google-drive-pull.yml holds 0 steps named"
  cp "$tmp/pull" "$wf/google-drive-pull.yml"
  awk -v g="      - name: $SA_DRIVE_GUARD_STEP" '$0 == g { print; print "        if: github.event_name == '"'"'push'"'"'"; next } { print }' "$tmp/push" > "$wf/google-drive-push.yml"
  probe "check 21 fires when the store guard step can be skipped" "check 21 — .github/workflows/google-drive-push.yml: the store guard step can be skipped"
  python3 - "$tmp/push" "$wf/google-drive-push.yml" "      - name: $SA_DRIVE_GUARD_STEP" <<'PY'
import sys
# The guard step moved after 'Authenticate to Google Cloud': the steps in the order checkout, auth, guard.
text = open(sys.argv[1]).read()
head, rest = text.split(sys.argv[3] + "\n", 1)
guard, auth = rest.split("      - name: Authenticate to Google Cloud\n", 1)
open(sys.argv[2], "w").write(head + "      - name: Authenticate to Google Cloud\n" + auth.rstrip("\n") + "\n\n" + sys.argv[3] + "\n" + guard)
PY
  probe "check 21 fires when the store guard step comes after authentication" "check 21 — .github/workflows/google-drive-push.yml: the store guard step is not directly after"
  cp "$tmp/push" "$wf/google-drive-push.yml"
  sed -i 's/^            exit 1$/            echo stopped; exit 1/' "$wf/google-drive-pull.yml"
  probe "check 21 fires when the two guard steps differ" "check 21 — the store guard step's script differs"
  rm -f "$wf/google-drive-pull.yml"
  probe_clean "check 21 holds a project that kept one Drive workflow"
  sed -i 's/^            exit 1$/            exit 0/' "$wf/google-drive-push.yml"
  probe "check 21 fires when the guard does not stop the job" "check 21 — .github/workflows/google-drive-push.yml: the store guard step does not read DATA_STORE"
  cp "$tmp/push" "$wf/google-drive-push.yml"; cp "$tmp/pull" "$wf/google-drive-pull.yml"
  # D59 under the repository store, where check 22 does not read the resolver.
  cp "$TREE/$SA_DATAROOT_PY" "$tmp/dr"
  sed -i 's/"videos": ("m2ts",)/"videos": ("m2ts", "xyz")/' "$TREE/$SA_DATAROOT_PY"
  probe "check 25 fires when 09's binary globs miss an extension the resolver counts" "check 25 — .claude/rules/syntek-author/09-data-root.md's binary globs miss XYZ, xyz"
  sed -i 's/^EXTENSIONS = /KINDS = /' "$TREE/$SA_DATAROOT_PY"
  probe "check 25 fires when the resolver's table cannot be read under repo" "check 25 — .claude/rules/syntek-author/09-data-root.md: the resolver's EXTENSIONS table cannot be read"
  cp "$tmp/dr" "$TREE/$SA_DATAROOT_PY"
  A_FAMILIES=""; A_PROVIDER=none; A_STORE=repo
  OPENCODE_BIN="$real_oc"; CODEX_BIN="$real_cx"

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
for n in "${!NOTES[@]}"; do log "  - $n"; done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ ${#TARGETS[@]} tree(s): every variant carries exactly its own paths, skills and mode files."
  exit 0
fi
log "  A path shipped where it should not, or did not ship where it should. Fix the gate in"
log "  copier.yml's _exclude (DESIGN.md Section 3.5), or the file's place under template/."
exit 1
