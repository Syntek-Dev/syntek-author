#!/usr/bin/env bash
#
# generate-all.sh — Render every variant and profile of the template, for the audits to read.
#
#                   A template defect is invisible until somebody generates, and whoever
#                   generates is not whoever broke it (SB rules 42–43). syntek-author renders
#                   three variants from one tree, each with options, so a mistake in one gate
#                   shows only in the render paths that open it — and the path nobody renders
#                   is the one that rots. So every audit that reads a render reads ALL of them.
#
#                   Renders, per DOC_TYPE (theology, fiction, business):
#                     defaults   only the answers that have no default
#                     all-on     every option the variant offers set true (business: every
#                                document family, msp-scp included)
#                     minimal    every option the variant offers set false — the negative path
#                                (business: BUSINESS_FAMILIES=[business], the one family that
#                                cannot be dropped)
#                     adoption   SEED_EXAMPLES=false, as `copier copy` into an existing repository
#                   plus, for fiction,
#                     conlang    FICTION_GENRE=literary with INCLUDE_WORLDBUILDING and
#                                INCLUDE_CONLANG set true explicitly, so the kit is proven to open
#                                on the answer and not only on the fantasy default;
#                   and, for the other coding agents (DESIGN.md D47), Claude Code alone (the
#                   bridge still ships), one render per OpenCode provider (user is every
#                   defaults render; named, llama-cpp, ollama, vllm, lmstudio, and
#                   openai-compatible with an explicit address ending /v1/), and Trap 2 twice:
#                   AGENT_CLIENTS=[codex] with type-valid but invalid values for every hidden
#                   OpenCode and Gemini CLI answer, given once by --data and once through a
#                   scratch COPIER_SETTINGS_PATH. A hidden answer is validated and rendered but
#                   never recorded, so every validator and gate must repeat its question's
#                   `when` test (DESIGN.md Section 2), or the copy fails.
#
#                   A profile's fields: KEY=value is passed with --data and expected in the
#                   answers; settings:KEY=value goes to the render's scratch settings file
#                   (`defaults:`), never to --data; expect:KEY=value is only expected
#                   (shipped-variants.sh reads it: a computed default, or ABSENT= keys that must
#                   not be recorded and NOTEXT= a string no rendered file may carry).
#
#                   It renders from a SNAPSHOT: the working tree is copied with rsync (without
#                   .git), committed in a temporary repository, and rendered with
#                   `--vcs-ref=HEAD`. Copier reads a template over git, so rendering the real
#                   repository would render its last commit and silently ignore the work in
#                   front of you (SB rule 17). .gitignore is honoured, exactly as a commit would.
#
#                   Output: one directory per render, OUTDIR/<doc_type>-<profile>/, beside
#                     OUTDIR/<name>.log     Copier's output
#                     OUTDIR/<name>.expect  the answers DESIGN.md says that render should
#                                           record (shipped-variants.sh compares them)
#                   and one tree path per successful render on stdout. Progress goes to stderr.
#
#                   Four checks:
#                     1. Every requested render succeeds.
#                     2. Every render carries .copier-answers.syntek-author.yml — without it a
#                        project can never be updated, and no audit can tell what it holds.
#                     3. The OPENCODE_BASE_URL validator in copier.yml, rendered with Copier's
#                        own Jinja, accepts exactly what re.fullmatch(r'https?://[^\s"]+/v1/?')
#                        accepts, over a fixed corpus (the listed edge cases and 20,000 seeded
#                        random strings, Unicode whitespace included). The answer is written
#                        inside a JSON string, so a looser validator can break opencode.json.
#                     4. Every validator of a question whose `when` reads AGENT_CLIENTS (the D47
#                        answers) stays silent wherever that `when` is false, for bad values of
#                        every agent answer (AGENT_CLIENTS
#                        none, codex or opencode; OPENCODE_PROVIDER user, named or ollama): a
#                        validator that fires on a hidden value fails a copy that never asked.
#                        Checks 3 and 4 are skipped, by name, when no Python with Jinja2 and
#                        PyYAML is reachable (python3, or uvx --from copier).
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: anything about what the renders CONTAIN. That is the
#                   job of every per-tree audit (run-all.sh runs them over this output).
#
# SELF-TEST. --self-test builds a fixture template at runtime with an uncommitted file in it,
#            renders it, asserts the uncommitted file reached the render (the snapshot works),
#            then breaks the fixture once per check and asserts exactly one finding each.
#
# Requirements: bash 4.3+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#               Checks 3–4: Jinja2 and PyYAML in python3, or uvx.
#
# Usage: generate-all.sh [OUTDIR] [--root DIR] [--only NAME[,NAME…]] [--jobs N] [--list]
#                        [--quiet] [--self-test] [--help]
#        OUTDIR defaults to ${TMPDIR:-/tmp}/syntek-author-render.
#
# Exit codes:  0 = every render succeeded
#              1 = a render failed or is incomplete, or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, no copier.yml)

set -euo pipefail
SCRIPT_NAME="generate-all.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

OUT="${TMPDIR:-/tmp}/syntek-author-render"
ONLY=""
JOBS=4
LIST=false
SELF_TEST=false

usage() {
  cat <<'EOF'
generate-all.sh — Render every variant and profile of the template

Usage: generate-all.sh [OUTDIR] [--root DIR] [--only NAME[,NAME…]] [--jobs N] [--list]
                       [--quiet] [--self-test] [--help]

  OUTDIR       Where the renders go (default: ${TMPDIR:-/tmp}/syntek-author-render)
  --root DIR   The template repository (default: this repository)
  --only LIST  Render only these, e.g. theology-defaults,fiction-conlang
  --jobs N     Renders to run at once (default 4)
  --list       Print the render names and exit
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture template
  --help       Show this message

Prints one rendered tree path per line on stdout.
Exit codes: 0 = every render succeeded  1 = a render failed  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --only)      [[ $# -gt 1 ]] || die "--only needs a value"; ONLY="$2"; shift 2 ;;
    --jobs)      [[ $# -gt 1 && "$2" =~ ^[1-9][0-9]*$ ]] || die "--jobs needs a positive number"; JOBS="$2"; shift 2 ;;
    --list)      LIST=true; shift ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           OUT="$1"; shift ;;
  esac
done

# ── The render matrix ────────────────────────────────────────────────────────
#
# name · extra --data answers. Only options the variant SHOWS are passed: a hidden question's
# value comes from its default, which is exactly what a real generation sees. A list answer is
# a YAML flow list with no spaces (fields split on whitespace), which Copier parses as a list.
RENDERS=$(cat <<'EOF'
theology-defaults
theology-all-on      INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true
theology-minimal     INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false
theology-adoption    SEED_EXAMPLES=false
fiction-defaults
fiction-all-on       INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-minimal      FICTION_GENRE=literary INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false INCLUDE_WORLDBUILDING=false
fiction-conlang      FICTION_GENRE=literary INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-adoption     SEED_EXAMPLES=false
business-defaults
business-all-on      INCLUDE_REFERENCES=true INCLUDE_DRIVE_SYNC=true BUSINESS_FAMILIES=[business,legal,email,accounting,social-media,msp-scp]
business-minimal     INCLUDE_REFERENCES=false INCLUDE_DRIVE_SYNC=false BUSINESS_FAMILIES=[business]
business-adoption    SEED_EXAMPLES=false
business-claude-only AGENT_CLIENTS=[]
fiction-ollama       AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=ollama OPENCODE_MODEL=qwen3:30b expect:OPENCODE_BASE_URL=http://127.0.0.1:11434/v1 expect:OPENCODE_CONTEXT=4096
theology-named       AGENT_CLIENTS=[codex,gemini-cli,opencode] CODEX_MODEL=gpt-5.5 GEMINI_MODEL=gemini-3-pro OPENCODE_PROVIDER=named OPENCODE_MODEL=example-cloud/example-model expect:ABSENT=OPENCODE_BASE_URL,OPENCODE_CONTEXT
business-llama-cpp   AGENT_CLIENTS=[antigravity,opencode] OPENCODE_PROVIDER=llama-cpp OPENCODE_MODEL=example-model-q4 expect:OPENCODE_BASE_URL=http://127.0.0.1:8080/v1 expect:OPENCODE_CONTEXT=262144
theology-vllm        AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=vllm OPENCODE_MODEL=example-org/example-model-8b expect:OPENCODE_BASE_URL=http://127.0.0.1:8000/v1 expect:OPENCODE_CONTEXT=32768
fiction-lmstudio     AGENT_CLIENTS=[gemini-cli,opencode] OPENCODE_PROVIDER=lmstudio OPENCODE_MODEL=example-model expect:OPENCODE_BASE_URL=http://127.0.0.1:1234/v1 expect:OPENCODE_CONTEXT=4096
business-oai-compat  AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=openai-compatible OPENCODE_BASE_URL=https://llm.example.com/team/v1/ OPENCODE_MODEL=example-team-model OPENCODE_CONTEXT=65536
business-trap-data   AGENT_CLIENTS=[codex] OPENCODE_PROVIDER=ollama OPENCODE_CONTEXT=999 OPENCODE_BASE_URL=trap-not-a-url OPENCODE_MODEL=trap-bad!model GEMINI_MODEL=trap-bad!model expect:ABSENT=OPENCODE_PROVIDER,OPENCODE_BASE_URL,OPENCODE_MODEL,OPENCODE_CONTEXT,GEMINI_MODEL expect:NOTEXT=trap-
theology-trap-settings AGENT_CLIENTS=[codex] settings:CODEX_MODEL=settings-file-model expect:CODEX_MODEL=settings-file-model settings:OPENCODE_PROVIDER=ollama settings:OPENCODE_CONTEXT=999 settings:OPENCODE_BASE_URL=trap-not-a-url settings:OPENCODE_MODEL=trap-bad!model settings:GEMINI_MODEL=trap-bad!model expect:ABSENT=OPENCODE_PROVIDER,OPENCODE_BASE_URL,OPENCODE_MODEL,OPENCODE_CONTEXT,GEMINI_MODEL expect:NOTEXT=trap-
EOF
)

render_names() { awk '{ print $1 }' <<< "$RENDERS"; }
render_fields() { awk -v n="$1" '$1 == n { for (i = 2; i <= NF; i++) print $i }' <<< "$RENDERS"; }
render_data()     { render_fields "$1" | grep -vE '^(settings|expect):' || true; }  # --data, and expected
render_settings() { render_fields "$1" | sed -n 's/^settings://p'; }                # the settings file only
render_expect()   { render_fields "$1" | sed -n 's/^expect://p'; }                  # expected only

# What DESIGN.md Section 2 says the render should record: the variant's defaults, then the
# profile's answers on top. A literary novel defaults the worldbuilding kit off.
expect_for() { # $1 = name → KEY=value lines
  local name="$1" doc="${1%%-*}" kv k v
  local -A e=([DOC_TYPE]="$doc" [INCLUDE_PROPOSAL]=false [INCLUDE_REFERENCES]=false
              [INCLUDE_SENSITIVE_CONTENT]=false [INCLUDE_WORLDBUILDING]=false [INCLUDE_CONLANG]=false
              [INCLUDE_DRIVE_SYNC]=false [SEED_EXAMPLES]=true [MODEL_MECHANICAL]=sonnet
              [AGENT_CLIENTS]="codex,gemini-cli,antigravity,opencode" [OPENCODE_PROVIDER]=user)
  case "$doc" in
    theology) e[INCLUDE_PROPOSAL]=true; e[INCLUDE_REFERENCES]=true; e[AUDIENCE]=lay ;;
    fiction)  e[INCLUDE_PROPOSAL]=true; e[AUDIENCE]=adult; e[INCLUDE_WORLDBUILDING]=true; e[INCLUDE_CONLANG]=true ;;
    business) e[MODEL_MECHANICAL]=opus; e[AUDIENCE]=client; e[BUSINESS_FAMILIES]="${SA_FAMILIES_DEFAULT// /,}" ;;
  esac
  while IFS= read -r kv; do
    [[ -z "$kv" ]] && continue
    k="${kv%%=*}"; v="${kv#*=}"
    if [[ "$k" == FICTION_GENRE && "$v" != fantasy && "$v" != science-fiction ]]; then
      e[INCLUDE_WORLDBUILDING]=false; e[INCLUDE_CONLANG]=false
    fi
    [[ "$k" == FICTION_GENRE ]] && continue
    # A list answer is expected as its values joined by commas, as shipped-variants.sh reads it.
    [[ "$v" == '['*']' ]] && { v="${v#[}"; v="${v%]}"; }
    e["$k"]="$v"
  done < <(render_data "$name")
  # INCLUDE_CONLANG defaults to INCLUDE_WORLDBUILDING and is hidden without it.
  if [[ "${e[INCLUDE_WORLDBUILDING]}" == false ]]; then e[INCLUDE_CONLANG]=false; fi
  # OPENCODE_PROVIDER is asked, and recorded, only when opencode is a client.
  [[ ",${e[AGENT_CLIENTS]}," == *,opencode,* ]] || unset 'e[OPENCODE_PROVIDER]'
  for k in DOC_TYPE INCLUDE_PROPOSAL INCLUDE_REFERENCES INCLUDE_SENSITIVE_CONTENT INCLUDE_WORLDBUILDING \
           INCLUDE_CONLANG INCLUDE_DRIVE_SYNC SEED_EXAMPLES MODEL_MECHANICAL AUDIENCE BUSINESS_FAMILIES \
           AGENT_CLIENTS OPENCODE_PROVIDER; do
    [[ -n "${e[$k]:-}" ]] && printf '%s=%s\n' "$k" "${e[$k]}"
  done
  render_expect "$name"
  # The last key is unset outside business; that must not be this function's status (set -e).
  return 0
}

SELECTED=()
select_renders() {
  local n
  SELECTED=()
  if [[ -z "$ONLY" ]]; then
    mapfile -t SELECTED < <(render_names)
    return 0
  fi
  for n in ${ONLY//,/ }; do
    render_names | grep -qxF "$n" || die "no such render: $n (see --list)"
    SELECTED+=("$n")
  done
}

# ── Rendering ────────────────────────────────────────────────────────────────

SNAP=""
NOTES=()
render_one() { # $1 = name — writes OUT/name, OUT/name.log, OUT/name.status, OUT/name.expect
  local name="$1" doc="${1%%-*}" args=() kv status=0 settings="" k v
  while IFS= read -r kv; do [[ -n "$kv" ]] && args+=(--data "$kv"); done < <(render_data "$name")
  rm -rf "${OUT:?}/$name" "$OUT/$name.log" "$OUT/$name.status" "$OUT/$name.expect" "$OUT/$name.settings.yml"
  expect_for "$name" > "$OUT/$name.expect"
  # A scratch Copier settings file: given values as `defaults:`, and never an empty file (an
  # empty settings.yml crashes Copier 9.17.1). Without settings: fields, a missing path keeps
  # the user's own settings out of the render.
  settings="$OUT/$name.settings.yml"
  { printf 'defaults:\n'
    while IFS= read -r kv; do
      [[ -z "$kv" ]] && continue
      k="${kv%%=*}"; v="${kv#*=}"
      if [[ "$v" =~ ^[0-9]+$ ]]; then printf '  %s: %s\n' "$k" "$v"; else printf "  %s: '%s'\n" "$k" "${v//\'/\'\'}"; fi
    done < <(render_settings "$name")
  } > "$settings"
  if [[ "$(wc -l < "$settings")" -eq 1 ]]; then printf 'defaults: {}\n' > "$settings"; fi
  COPIER_SETTINGS_PATH="$settings" sa_render "$SNAP" "$OUT/$name" "$doc" "${args[@]}" > "$OUT/$name.log" 2>&1 || status=$?
  printf '%s\n' "$status" > "$OUT/$name.status"
}

generate() {
  local name running=0 work
  mkdir -p "$OUT"
  OUT="$(cd "$OUT" && pwd)"
  work="$(sa_mktemp)"
  SNAP="$work/snapshot"
  $QUIET || note "  snapshotting $SA_ROOT (working tree, .gitignore honoured)…"
  sa_snapshot "$SA_ROOT" "$SNAP" >/dev/null || { rm -rf "$work"; die "could not snapshot $SA_ROOT"; }
  for name in "${SELECTED[@]}"; do
    $QUIET || note "  rendering $name…"
    render_one "$name" &
    running=$((running + 1))
    if [[ "$running" -ge "$JOBS" ]]; then wait -n || true; running=$((running - 1)); fi
  done
  wait || true
  rm -rf "$work"
}

# Checks 3 and 4: the D47 validators, rendered with Copier's own Jinja. One finding per line.
validator_problems() { # $1 = copier.yml
  "${SA_JPY[@]}" -I - "$1" <<'PY'
import random, re, sys
import yaml
from jinja2.sandbox import SandboxedEnvironment
try:
    from jinja2_ansible_filters import AnsibleCoreFiltersExtension  # as Copier loads it
    ext = [AnsibleCoreFiltersExtension]
except Exception:
    ext = []
env = SandboxedEnvironment(variable_start_string="<%", variable_end_string="%>",
                           block_start_string="<:", block_end_string=":>",
                           comment_start_string="<~", comment_end_string="~>", extensions=ext)
data = yaml.safe_load(open(sys.argv[1], encoding="utf-8")) or {}

def render(src, ctx):
    try:
        return env.from_string(str(src)).render(**ctx).strip()
    except Exception as exc:
        return f"<render error: {exc.__class__.__name__}: {exc}>"

# 3. OPENCODE_BASE_URL agrees with its regular expression on a fixed corpus.
q = data.get("OPENCODE_BASE_URL") or {}
if not isinstance(q, dict) or not q.get("validator"):
    print("check 3 — copier.yml has no OPENCODE_BASE_URL validator to prove")
else:
    rx = re.compile(r'https?://[^\s"]+/v1/?')
    cases = ["http://127.0.0.1:8080/v1", "http://127.0.0.1:8080/v1/", "https://h/v1", "http://h/v1//",
             "http:///v1", "http:////v1", "http:///v1/", "http://h/v2", "ftp://h/v1", "http://h /v1",
             "http://h\t/v1", 'http://h"/v1', "", "http://h/v1\n", "http://h/V1", "HTTP://h/v1",
             "http://h/v1?x", "https://a.b/c/v1", "http:// x/v1", "http://h/v1 ", "http://x\x1c/v1",
             "http://x\x85/v1", "http://x /v1", "http://x /v1", "https://llm.example.com/team/v1/"]
    alpha = ["h", "t", "p", "s", ":", "/", "v", "1", " ", '"', "\t", ".", "x", "\n", "\x1c", " ", "　"]
    rnd = random.Random(1)
    for _ in range(20000):
        n = rnd.randint(0, 14)
        cases.append(rnd.choice(["http://", "https://", "", ""]) + "".join(rnd.choice(alpha) for _ in range(n))
                     + rnd.choice(["/v1", "/v1/", "", "/v1//"]))
    try:
        t = env.from_string(str(q["validator"]))
    except Exception as exc:
        print(f"check 3 — the OPENCODE_BASE_URL validator does not parse ({exc.__class__.__name__}: {exc})")
        t = None
    if t is not None:
        bad = []
        for c in cases:
            ctx = {"AGENT_CLIENTS": ["opencode"], "OPENCODE_PROVIDER": "llama-cpp", "OPENCODE_BASE_URL": c}
            if (t.render(**ctx).strip() == "") != bool(rx.fullmatch(c)):
                bad.append(c)
        if bad:
            print(f"check 3 — the OPENCODE_BASE_URL validator disagrees with re.fullmatch on {len(bad)} of "
                  f"{len(cases)} strings, for example {bad[0]!r}: it must accept exactly ^https?://[^\\s\"]+/v1/?$")

# 4. No validator fires where its question is hidden.
bad_values = {"CODEX_MODEL": "bad model!", "GEMINI_MODEL": "bad model!", "OPENCODE_BASE_URL": "not a url",
              "OPENCODE_MODEL": "bad model!", "OPENCODE_CONTEXT": 999}
seen = set()
for clients in ([], ["codex"], ["opencode"]):
    for prov in ("user", "named", "ollama"):
        ctx = dict(bad_values, AGENT_CLIENTS=clients, OPENCODE_PROVIDER=prov)
        for key, spec in data.items():
            if not isinstance(spec, dict) or not spec.get("validator") or "AGENT_CLIENTS" not in str(spec.get("when", "")):
                continue
            when = spec["when"]
            shown = render(when, ctx) if isinstance(when, str) else str(when)
            if shown.lower() not in ("false", "", "none", "0"):
                continue
            out = render(spec["validator"], ctx)
            if out and key not in seen:
                seen.add(key)
                print(f"check 4 — the {key} validator fires while {key} is hidden (AGENT_CLIENTS={clients}, "
                      f"OPENCODE_PROVIDER={prov}): {out[:90]!r} — open it with the question's when test")
PY
}

VALIDATOR_COPIER=""
run_checks() {
  FINDINGS=()
  local name status err line
  if sa_jinja_init; then
    while IFS= read -r line; do [[ -n "$line" ]] && finding "$line"; done \
      < <(validator_problems "${VALIDATOR_COPIER:-$SA_ROOT/copier.yml}")
  else
    NOTES+=("checks 3–4 skipped — no Python with Jinja2 and PyYAML (python3, or uvx --from copier)")
  fi
  for name in "${SELECTED[@]}"; do
    status="$(cat "$OUT/$name.status" 2>/dev/null || echo 'did not run')"
    if [[ "$status" != 0 ]]; then
      err="$(grep -v '^[[:space:]]*$' "$OUT/$name.log" 2>/dev/null | tail -1 || true)"
      finding "check 1 — $name did not render (exit $status): ${err:-no output} — see $OUT/$name.log"
      continue
    fi
    [[ -f "$OUT/$name/$SA_ANSWERS_FILE" ]] \
      || finding "check 2 — $name has no $SA_ANSWERS_FILE — it can never be updated"
  done
}

# ── Self-test ────────────────────────────────────────────────────────────────

# The agent questions' validators in their proven shape (checks 3–4), for the self-test.
write_validators() { # $1 = file
  cat > "$1" <<'EOF'
AGENT_CLIENTS:
  type: str
  multiselect: true
  choices: [codex, gemini-cli, antigravity, opencode]
CODEX_MODEL:
  type: str
  default: ""
  when: "<% 'codex' in AGENT_CLIENTS %>"
  validator: >-
    <: if 'codex' in AGENT_CLIENTS and CODEX_MODEL | reject('in', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._:/@+-') | list | length > 0 :>
    Use a model name.
    <: endif :>
OPENCODE_PROVIDER:
  type: str
  default: user
  when: "<% 'opencode' in AGENT_CLIENTS %>"
OPENCODE_BASE_URL:
  type: str
  when: "<% 'opencode' in AGENT_CLIENTS and OPENCODE_PROVIDER not in ['user', 'named'] %>"
  validator: >-
    <: if 'opencode' in AGENT_CLIENTS and OPENCODE_PROVIDER not in ['user', 'named'] :><: set u = OPENCODE_BASE_URL :><: set body = u[8:] if u.startswith('https://') else (u[7:] if u.startswith('http://') else '') :><: set body = body[:-1] if body.endswith('/v1/') else body :><: if not body.endswith('/v1') or (body[:-3] | length) < 1 or (u.split() | join) != u or '"' in u :>Use the server's address.<: endif :><: endif :>
EOF
}

self_test() {
  local tmp real_root="$SA_ROOT" real_out="$OUT" real_only="$ONLY"
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/tpl" >/dev/null
  write_validators "$tmp/validators.yml"; VALIDATOR_COPIER="$tmp/validators.yml"
  SA_ROOT="$tmp/tpl"; OUT="$tmp/out"
  printf '# Uncommitted\n' > "$SA_ROOT/template/UNCOMMITTED.md"

  ONLY="theology-defaults,business-defaults"; select_renders; generate 2>/dev/null
  st_baseline "the fixture template, rendered twice"
  [[ -f "$OUT/theology-defaults/UNCOMMITTED.md" ]] || {
    printf '\033[31m  ✗ an uncommitted file did not reach the render — the snapshot is not the working tree\033[0m\n' >&2; exit 2; }
  log "  ✓ an uncommitted file reached the render — the snapshot is the working tree"

  printf '<: if DOC_TYPE == :>broken\n' > "$SA_ROOT/template/library/src/BROKEN.md"
  generate 2>/dev/null
  probe "check 1 fires when one variant fails to render" "check 1 — business-defaults"
  rm -f "$SA_ROOT/template/library/src/BROKEN.md"

  mv "$SA_ROOT/template/$SA_ANSWERS_FILE" "$tmp/held"
  ONLY="theology-defaults"; select_renders; generate 2>/dev/null
  probe "check 2 fires when the answers file is not rendered" "check 2"
  mv "$tmp/held" "$SA_ROOT/template/$SA_ANSWERS_FILE"
  generate 2>/dev/null

  if sa_jinja_init; then
    sed -i "s/ or '\"' in u :>/ :>/" "$tmp/validators.yml"
    probe "check 3 fires when the base-URL validator lets a quotation mark through" "check 3 — the OPENCODE_BASE_URL validator disagrees"
    write_validators "$tmp/validators.yml"
    sed -i "s/<: if 'codex' in AGENT_CLIENTS and CODEX_MODEL/<: if CODEX_MODEL/" "$tmp/validators.yml"
    probe "check 4 fires when a validator does not open with its when test" "check 4 — the CODEX_MODEL validator fires while CODEX_MODEL is hidden"
    write_validators "$tmp/validators.yml"
  else
    log "  - checks 3–4 not proven: no Python with Jinja2 and PyYAML (python3, or uvx --from copier)"
  fi

  SA_ROOT="$real_root"; OUT="$real_out"; ONLY="$real_only"; VALIDATOR_COPIER=""
  st_finish "a template that renders from one that does not"
}

if $LIST; then render_names; exit 0; fi
if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
command -v git >/dev/null 2>&1 || die "git is not installed"
copier_init
select_renders

$QUIET || note "▸ $SCRIPT_NAME — ${#SELECTED[@]} render(s) into $OUT"
generate
run_checks

for name in "${SELECTED[@]}"; do
  [[ "$(cat "$OUT/$name.status" 2>/dev/null)" == 0 ]] && printf '%s\n' "$OUT/$name"
done

for n in "${NOTES[@]}"; do note "  - $n"; done
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  $QUIET || note "✓ ${#SELECTED[@]} render(s), every one complete; the agent validators proven."
  exit 0
fi
{
  printf '✗ %d finding(s):\n' "${#FINDINGS[@]}"
  print_findings
} >&2
exit 1
