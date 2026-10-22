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
#                     defaults   only the answers that have no default (so the data root is
#                                outside the repository, DATA_STORE external, every layout
#                                answer takes its default, and there is no provider)
#                     all-on     every option the variant offers set true (business: every
#                                document family, msp-scp included, and Google Drive with
#                                the files kept in the repository, so .github/ ships, D53)
#                     minimal    every option the variant offers set false — the negative path
#                                (business: BUSINESS_FAMILIES=[business], the one family that
#                                cannot be dropped, and DATA_PROVIDER=none)
#                     adoption   SEED_EXAMPLES=false, as `copier copy` into an existing repository
#                     repo       DATA_STORE=repo: binaries stay in Git, and no layout answer is
#                                asked or recorded (DESIGN.md D50)
#                   plus, for fiction,
#                     conlang    FICTION_GENRE=literary with INCLUDE_WORLDBUILDING and
#                                INCLUDE_CONLANG set true explicitly, so the kit is proven to open
#                                on the answer and not only on the fantasy default;
#                   for the provider (DESIGN.md D53), one render per other DATA_PROVIDER value
#                   (theology onedrive and nas, fiction dropbox, business other-cloud), business
#                   Google Drive under the external store (no .github/) and at repo as the twin
#                   of business repo (.github/ ships, and the two answers files differ only in
#                   DATA_PROVIDER, so byte-identity.sh check 3 judges the Drive gate on real
#                   renders), and two traps that pass
#                   DATA_PROVIDER=google-drive DATA_STORE=repo to a book, once by --data and once
#                   through a scratch settings file (no .github/ either: the gate is business);
#                   for the data root (DESIGN.md D50), a copy beside a sibling answers file from
#                   before the data root (it records repo), a folder name over 64 characters
#                   (the slug is cut to 64, with no trailing hyphen), and two folder names that
#                   leave no slug, one with no ASCII letter or digit and `con`, which must be
#                   refused naming DATA_SLUG and render under repo (the repo profiles of
#                   theology and fiction are rendered into those two folders: under repo the
#                   folder name reaches no file), and an external business render whose area
#                   holds a space (Client Work, the question's own example) and whose documents
#                   kind is yes, which Copier writes single-quoted, so the data-root tool's
#                   answers reader meets Copier's own quoting on every run (tooling-smoke.sh
#                   check 49) and a filing path holds a space;
#                   and, for the other coding agents (DESIGN.md D47), Claude Code alone (the
#                   bridge still ships), one render per OpenCode provider (user is every
#                   defaults render; named, llama-cpp, ollama, vllm, lmstudio, and
#                   openai-compatible with an explicit address ending /v1/), and Trap 2 twice:
#                   AGENT_CLIENTS=[codex] with type-valid but invalid values for every hidden
#                   OpenCode and Gemini CLI answer, given once by --data and once through a
#                   scratch COPIER_SETTINGS_PATH. The two traps also keep the files in the
#                   repository and give invalid hidden DATA_AREA, DATA_SLUG and kind answers
#                   the same two ways. A hidden answer is validated and rendered but never
#                   recorded, so every validator and gate must repeat its question's `when`
#                   test (DESIGN.md Section 2), or the copy fails.
#
#                   A profile's fields: KEY=value is passed with --data and expected in the
#                   answers; settings:KEY=value goes to the render's scratch settings file
#                   (`defaults:`), never to --data; expect:KEY=value is only expected
#                   (shipped-variants.sh reads it: a computed default, or ABSENT= keys that must
#                   not be recorded and NOTEXT= a string no rendered file may carry);
#                   folder:NAME renders into OUTDIR/<name>/NAME, so the slug's default reads
#                   that folder name; peer:pre-d50 writes a sibling template's answers file
#                   from before the data root into the folder first; fail:KEY marks a render
#                   that must be refused, naming KEY (check 5), and that leaves no tree. A
#                   space inside any field's value is written %20 (fields split on whitespace).
#                   Every profile that passes no store is expected to record DATA_STORE external,
#                   DATA_AREA business, the folder's kebab name as DATA_SLUG and the four kind
#                   folders; one that keeps the files in the repository records none of the
#                   layout answers (ABSENT=). Every profile records DATA_PROVIDER, none unless
#                   it passes another.
#
#                   It renders from a SNAPSHOT: the working tree is copied with rsync (without
#                   .git), committed in a temporary repository, and rendered with
#                   `--vcs-ref=HEAD`. Copier reads a template over git, so rendering the real
#                   repository would render its last commit and silently ignore the work in
#                   front of you (SB rule 17). .gitignore is honoured, exactly as a commit would.
#
#                   Output: one directory per render, OUTDIR/<doc_type>-<profile>/ (or
#                   OUTDIR/<doc_type>-<profile>/<folder>/), beside
#                     OUTDIR/<name>.log     Copier's output
#                     <tree>.expect         the answers DESIGN.md says that render should
#                                           record (shipped-variants.sh compares them)
#                   and one tree path per successful render on stdout (never a refused one).
#                   Progress goes to stderr.
#
#                   Eight checks:
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
#                     5. Every render DESIGN.md says must be refused (fail:KEY) is refused, and
#                        Copier's output names KEY: a folder name that leaves no slug (no ASCII
#                        letter or digit, or a device name such as con) has no DATA_SLUG
#                        default, so `--defaults` stops on the question (D50). A copy that
#                        succeeds there would file the project under a slug nobody chose.
#                     6. The DATA_AREA validator, rendered with Copier's Jinja, accepts exactly
#                        what a Python reference of DESIGN.md Section 2's rules accepts, over a
#                        fixed corpus (the listed edge cases and 20,000 seeded random names): no
#                        < > : " / \ | ? *, no control character, no trailing dot or space and
#                        no leading space, no device name before the first dot in any case
#                        (CON, PRN, AUX, NUL, CONIN$, CONOUT$, COM and LPT with 1 to 9, ¹, ² or
#                        ³), at most 64 characters, never empty. The area is a folder on every
#                        machine's disk, Windows and network disks included.
#                     7. Each kind folder's validator refuses a name that differs from an
#                        earlier kind's only in case, and accepts a distinct one: two kinds
#                        that differ only in case are one folder on a case-insensitive disk.
#                     8. The DATA_SLUG default, rendered with Copier's Jinja for a fixed corpus
#                        of folder names, gives what a Python reference gives: the name in
#                        kebab case (lower case; _ . - and spaces separate words; any other
#                        character dropped), cut to 64 characters with no trailing hyphen, and
#                        no default (Copier's UNSET) where nothing is left or a device name is;
#                        a recorded slug, this template's or the sibling's, wins.
#                     Checks 3, 4 and 6–8 are skipped, by name, when no Python with Jinja2 and
#                     PyYAML is reachable (python3, or uvx --from copier).
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: anything about what the renders CONTAIN. That is the
#                   job of every per-tree audit (run-all.sh runs them over this output), and
#                   shipped-variants.sh compares each render's recorded answers with its
#                   .expect (checks 10 and 15).
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
# a YAML flow list with no spaces (fields split on whitespace), which Copier parses as a list;
# a space inside a value is written %20.
RENDERS=$(cat <<'EOF'
theology-defaults
theology-all-on      INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true
theology-minimal     INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false
theology-adoption    SEED_EXAMPLES=false
theology-repo        DATA_STORE=repo folder:con
fiction-defaults
fiction-all-on       INCLUDE_PROPOSAL=true INCLUDE_REFERENCES=true INCLUDE_SENSITIVE_CONTENT=true INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-minimal      FICTION_GENRE=literary INCLUDE_PROPOSAL=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false INCLUDE_WORLDBUILDING=false
fiction-conlang      FICTION_GENRE=literary INCLUDE_WORLDBUILDING=true INCLUDE_CONLANG=true
fiction-adoption     SEED_EXAMPLES=false
fiction-repo         DATA_STORE=repo folder:Книга
business-defaults
business-all-on      INCLUDE_REFERENCES=true DATA_PROVIDER=google-drive DATA_STORE=repo BUSINESS_FAMILIES=[business,legal,email,accounting,social-media,msp-scp]
business-minimal     INCLUDE_REFERENCES=false DATA_PROVIDER=none BUSINESS_FAMILIES=[business]
business-adoption    SEED_EXAMPLES=false
business-repo        DATA_STORE=repo
business-repo-gd     DATA_STORE=repo DATA_PROVIDER=google-drive
business-gd-external DATA_PROVIDER=google-drive
theology-onedrive    DATA_PROVIDER=onedrive
theology-nas         DATA_PROVIDER=nas
fiction-dropbox      DATA_PROVIDER=dropbox
business-other-cloud DATA_PROVIDER=other-cloud
theology-trap-drive  DATA_PROVIDER=google-drive DATA_STORE=repo
fiction-trap-drive-settings settings:DATA_PROVIDER=google-drive settings:DATA_STORE=repo expect:DATA_PROVIDER=google-drive expect:DATA_STORE=repo
theology-beside-pre-d50 peer:pre-d50 expect:DATA_STORE=repo
business-quoted-area DATA_STORE=external DATA_AREA=Client%20Work DATA_KIND_DOCS=yes
business-slug-long   folder:A_Long.Project-NAME_with__doubled..separators-Ünïcode-and-a-tail-that-runs-well-past-sixty-four
theology-slug-script folder:Книга fail:DATA_SLUG
theology-slug-device folder:con fail:DATA_SLUG
business-claude-only AGENT_CLIENTS=[]
fiction-ollama       AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=ollama OPENCODE_MODEL=qwen3:30b expect:OPENCODE_BASE_URL=http://127.0.0.1:11434/v1 expect:OPENCODE_CONTEXT=4096
theology-named       AGENT_CLIENTS=[codex,gemini-cli,opencode] CODEX_MODEL=gpt-5.5 GEMINI_MODEL=gemini-3-pro OPENCODE_PROVIDER=named OPENCODE_MODEL=example-cloud/example-model expect:ABSENT=OPENCODE_BASE_URL,OPENCODE_CONTEXT
business-llama-cpp   AGENT_CLIENTS=[antigravity,opencode] OPENCODE_PROVIDER=llama-cpp OPENCODE_MODEL=example-model-q4 expect:OPENCODE_BASE_URL=http://127.0.0.1:8080/v1 expect:OPENCODE_CONTEXT=262144
theology-vllm        AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=vllm OPENCODE_MODEL=example-org/example-model-8b expect:OPENCODE_BASE_URL=http://127.0.0.1:8000/v1 expect:OPENCODE_CONTEXT=32768
fiction-lmstudio     AGENT_CLIENTS=[gemini-cli,opencode] OPENCODE_PROVIDER=lmstudio OPENCODE_MODEL=example-model expect:OPENCODE_BASE_URL=http://127.0.0.1:1234/v1 expect:OPENCODE_CONTEXT=4096
business-oai-compat  AGENT_CLIENTS=[opencode] OPENCODE_PROVIDER=openai-compatible OPENCODE_BASE_URL=https://llm.example.com/team/v1/ OPENCODE_MODEL=example-team-model OPENCODE_CONTEXT=65536
business-trap-data   AGENT_CLIENTS=[codex] OPENCODE_PROVIDER=ollama OPENCODE_CONTEXT=999 OPENCODE_BASE_URL=trap-not-a-url OPENCODE_MODEL=trap-bad!model GEMINI_MODEL=trap-bad!model DATA_STORE=repo DATA_AREA=trap-bad:area DATA_SLUG=trap--Bad!slug DATA_KIND_PHOTOS=trap-docs|x expect:ABSENT=OPENCODE_PROVIDER,OPENCODE_BASE_URL,OPENCODE_MODEL,OPENCODE_CONTEXT,GEMINI_MODEL expect:NOTEXT=trap-
theology-trap-settings AGENT_CLIENTS=[codex] settings:CODEX_MODEL=settings-file-model expect:CODEX_MODEL=settings-file-model settings:OPENCODE_PROVIDER=ollama settings:OPENCODE_CONTEXT=999 settings:OPENCODE_BASE_URL=trap-not-a-url settings:OPENCODE_MODEL=trap-bad!model settings:GEMINI_MODEL=trap-bad!model settings:DATA_STORE=repo settings:DATA_AREA=trap-bad:area settings:DATA_SLUG=trap--Bad!slug settings:DATA_KIND_PHOTOS=trap-docs|x expect:DATA_STORE=repo expect:ABSENT=OPENCODE_PROVIDER,OPENCODE_BASE_URL,OPENCODE_MODEL,OPENCODE_CONTEXT,GEMINI_MODEL expect:NOTEXT=trap-
EOF
)

render_names() { awk '{ print $1 }' <<< "$RENDERS"; }
render_fields() { awk -v n="$1" '$1 == n { for (i = 2; i <= NF; i++) { f = $i; gsub(/%20/, " ", f); print f } }' <<< "$RENDERS"; }
render_data()     { render_fields "$1" | grep -vE '^(settings|expect|folder|peer|fail):' || true; }  # --data, and expected
render_settings() { render_fields "$1" | sed -n 's/^settings://p'; }                # the settings file only
render_expect()   { render_fields "$1" | sed -n 's/^expect://p'; }                  # expected only
render_folder()   { render_fields "$1" | sed -n 's/^folder://p' | tail -1; }        # the folder Copier copies into
render_peer()     { render_fields "$1" | sed -n 's/^peer://p' | tail -1; }          # a sibling answers file, written first
render_fail()     { render_fields "$1" | sed -n 's/^fail://p' | tail -1; }          # the question that must refuse it

# Where a render goes: OUT/<name>, or OUT/<name>/<folder> when the profile names the folder.
tree_of() { # $1 = name
  local f; f="$(render_folder "$1")"
  if [[ -n "$f" ]]; then printf '%s/%s/%s' "$OUT" "$1" "$f"; else printf '%s/%s' "$OUT" "$1"; fi
}

# The DATA_SLUG default DESIGN.md Section 2 gives a folder name, written from the rule rather than
# from copier.yml's expression: kebab case (lower case; _ . - and spaces separate words; any other
# character dropped), cut to 64 characters with no trailing hyphen; no default (None) where
# nothing is left or the result is a device name. Check 8 and the profiles' .expect both use it.
SLUG_REF_PY=$(cat <<'PY'
import re
DEVICE_SLUGS = {"con", "prn", "aux", "nul"} | {f"{p}{n}" for p in ("com", "lpt") for n in range(1, 10)}
def slug_ref(name):
    words = re.sub(r"[^a-z0-9 ]", "", re.sub(r"[_.\- ]", " ", name.lower())).split()
    k = "-".join(words)[:64].rstrip("-")
    return None if not k or k in DEVICE_SLUGS else k
PY
)
slug_ref() { # $1 = folder name → its slug, or nothing
  python3 -I -c "$SLUG_REF_PY"$'\nimport sys\nprint(slug_ref(sys.argv[1]) or "")' "$1"
}

# A sibling template's answers file from before the data root (peer:pre-d50): a record, but no
# DATA_STORE, so a fresh copy beside it defaults to repo (DESIGN.md D50).
write_peer() { # $1 = kind, $2 = folder
  mkdir -p "$2"
  case "$1" in
    pre-d50) printf '# Changes here will be overwritten by Copier; NEVER EDIT MANUALLY\n_commit: v0.4.2\n_src_path: ../syntek-media\nAGENT_CLIENTS: []\n' \
               > "$2/$SA_PEER_ANSWERS_FILE" ;;
    *) die "unknown peer: field: $1" ;;
  esac
}

# What DESIGN.md Section 2 says the render should record: the variant's defaults, then the
# profile's answers on top. A literary novel defaults the worldbuilding kit off.
expect_for() { # $1 = name → KEY=value lines
  local name="$1" doc="${1%%-*}" kv k v absent="" notext="" folder
  local layout="DATA_AREA DATA_SLUG DATA_KIND_DOCS DATA_KIND_PHOTOS DATA_KIND_AUDIO DATA_KIND_VIDEOS"
  local -A e=([DOC_TYPE]="$doc" [INCLUDE_PROPOSAL]=false [INCLUDE_REFERENCES]=false
              [INCLUDE_SENSITIVE_CONTENT]=false [INCLUDE_WORLDBUILDING]=false [INCLUDE_CONLANG]=false
              [SEED_EXAMPLES]=true [MODEL_MECHANICAL]=sonnet
              [AGENT_CLIENTS]="codex,gemini-cli,antigravity,opencode" [OPENCODE_PROVIDER]=user
              [DATA_STORE]=external [DATA_PROVIDER]=none)
  case "$doc" in
    theology) e[INCLUDE_PROPOSAL]=true; e[INCLUDE_REFERENCES]=true; e[AUDIENCE]=lay ;;
    fiction)  e[INCLUDE_PROPOSAL]=true; e[AUDIENCE]=adult; e[INCLUDE_WORLDBUILDING]=true; e[INCLUDE_CONLANG]=true ;;
    business) e[MODEL_MECHANICAL]=opus; e[AUDIENCE]=client; e[BUSINESS_FAMILIES]="${SA_FAMILIES_DEFAULT// /,}" ;;
  esac
  # The --data answers, then the expect: ones, which win (a value a settings file gave).
  while IFS= read -r kv; do
    [[ -z "$kv" ]] && continue
    k="${kv%%=*}"; v="${kv#*=}"
    case "$k" in
      ABSENT) absent="$absent,$v"; continue ;;
      NOTEXT) notext="$v"; continue ;;
    esac
    if [[ "$k" == FICTION_GENRE && "$v" != fantasy && "$v" != science-fiction ]]; then
      e[INCLUDE_WORLDBUILDING]=false; e[INCLUDE_CONLANG]=false
    fi
    [[ "$k" == FICTION_GENRE ]] && continue
    # A list answer is expected as its values joined by commas, as shipped-variants.sh reads it.
    [[ "$v" == '['*']' ]] && { v="${v#[}"; v="${v%]}"; }
    e["$k"]="$v"
  done < <(render_data "$name"; render_expect "$name")
  # INCLUDE_CONLANG defaults to INCLUDE_WORLDBUILDING and is hidden without it.
  if [[ "${e[INCLUDE_WORLDBUILDING]}" == false ]]; then e[INCLUDE_CONLANG]=false; fi
  # OPENCODE_PROVIDER is asked, and recorded, only when opencode is a client.
  [[ ",${e[AGENT_CLIENTS]}," == *,opencode,* ]] || unset 'e[OPENCODE_PROVIDER]'
  # The layout answers are asked, and recorded, only under the external store (DESIGN.md D50):
  # each at its literal default, and the slug from the folder Copier copied into.
  if [[ "${e[DATA_STORE]}" == external ]]; then
    folder="$(render_folder "$name")"
    [[ -n "${e[DATA_AREA]:-}" ]] || e[DATA_AREA]=business
    [[ -n "${e[DATA_SLUG]:-}" ]] || e[DATA_SLUG]="$(slug_ref "${folder:-$name}")"
    [[ -n "${e[DATA_KIND_DOCS]:-}" ]] || e[DATA_KIND_DOCS]=docs
    [[ -n "${e[DATA_KIND_PHOTOS]:-}" ]] || e[DATA_KIND_PHOTOS]=photos
    [[ -n "${e[DATA_KIND_AUDIO]:-}" ]] || e[DATA_KIND_AUDIO]=audio
    [[ -n "${e[DATA_KIND_VIDEOS]:-}" ]] || e[DATA_KIND_VIDEOS]=videos
  else
    for k in $layout; do unset "e[$k]"; done
    absent="$absent,${layout// /,}"
  fi
  for k in DOC_TYPE INCLUDE_PROPOSAL INCLUDE_REFERENCES INCLUDE_SENSITIVE_CONTENT INCLUDE_WORLDBUILDING \
           INCLUDE_CONLANG SEED_EXAMPLES MODEL_MECHANICAL AUDIENCE BUSINESS_FAMILIES \
           AGENT_CLIENTS OPENCODE_PROVIDER DATA_STORE $layout DATA_PROVIDER; do
    [[ -n "${e[$k]:-}" ]] && printf '%s=%s\n' "$k" "${e[$k]}"
  done
  [[ -n "$absent" ]] && printf 'ABSENT=%s\n' "${absent#,}"
  [[ -n "$notext" ]] && printf 'NOTEXT=%s\n' "$notext"
  # The last test is false for most profiles; that must not be this function's status (set -e).
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
render_one() { # $1 = name — writes its tree, <tree>.expect, OUT/name.log and OUT/name.status
  local name="$1" doc="${1%%-*}" args=() kv status=0 settings="" k v tree peer
  while IFS= read -r kv; do [[ -n "$kv" ]] && args+=(--data "$kv"); done < <(render_data "$name")
  rm -rf "${OUT:?}/${name:?}" "${OUT:?}/${name:?}.log" "${OUT:?}/${name:?}.status" \
    "${OUT:?}/${name:?}.expect" "${OUT:?}/${name:?}.settings.yml"
  tree="$(tree_of "$name")"
  mkdir -p "$(dirname "$tree")"
  # A refused render leaves no tree, so nothing is expected of one.
  [[ -n "$(render_fail "$name")" ]] || expect_for "$name" > "$tree.expect"
  peer="$(render_peer "$name")"
  [[ -z "$peer" ]] || write_peer "$peer" "$tree"
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
  COPIER_SETTINGS_PATH="$settings" sa_render "$SNAP" "$tree" "$doc" "${args[@]}" > "$OUT/$name.log" 2>&1 || status=$?
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

# Checks 3, 4 and 6–8: the D47 and D50 validators and the slug's default, rendered with Copier's
# own Jinja. One finding per line.
validator_problems() { # $1 = copier.yml
  "${SA_JPY[@]}" -I - "$1" "$SLUG_REF_PY" <<'PY'
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

# The data-root answers (DESIGN.md D50) are read under the external store, with no previous record
# and no sibling, so only the character rules and the kinds' distinctness speak.
EMPTY = {"prev": {}, "peer": {}}
def compiled(key, part, check):
    q = data.get(key) or {}
    if not isinstance(q, dict) or not q.get(part):
        print(f"{check} — copier.yml has no {key} {part} to prove")
        return None
    try:
        return env.from_string(str(q[part]))
    except Exception as exc:
        print(f"{check} — the {key} {part} does not parse ({exc.__class__.__name__}: {exc})")
        return None

# 6. DATA_AREA agrees with the rules of DESIGN.md Section 2, written here as a reference.
RESERVED = set('<>:"/\\|?*')
DEVICES = {"CON", "PRN", "AUX", "NUL", "CONIN$", "CONOUT$"}
def area_ok(a):
    if not a or len(a) > 64:
        return False
    if any(ch in RESERVED or ord(ch) < 32 or ord(ch) == 127 for ch in a):
        return False
    if a.endswith((".", " ")) or a.startswith(" "):
        return False
    stem = a.split(".", 1)[0].rstrip(" ").upper()
    return not (stem in DEVICES or re.fullmatch(r"(COM|LPT)[1-9\u00b9\u00b2\u00b3]", stem))
t = compiled("DATA_AREA", "validator", "check 6")
if t is not None:
    cases = ["business", "Business", "Client Work", "Gesch\u00e4ft", ".hidden", "COM0", "LPT10", "console",
             "x" * 64, "x" * 65, "", ".", "..", "trail.", "trail ", " lead", "CON", "con", "Con.txt",
             "nul.tar.gz", "NUL .txt", "COM1", "com9", "com\u00b9", "LPT3", "CONIN$", "conout$.x", "a\tb",
             "a\x7fb", "a\x00b", "a\x1fb", "CON.", "aux ", "prn\u00a0", "COM\u2074", "LPT0"]
    cases += [f"a{c}b" for c in '<>:"/\\|?*']
    alpha = ["a", "B", "c", "o", "n", "C", "O", "N", "u", "x", "l", "p", "t", "1", "9", "0", "\u00b9", ".", " ",
             "<", "|", "*", '"', "\t", "\x7f", "\x00", "\u00e9", "$", "I", "-", "_", "/", ":", "?"]
    rnd = random.Random(6)
    for _ in range(20000):
        cases.append("".join(rnd.choice(alpha) for _ in range(rnd.randint(0, 9))))
    for _ in range(200):
        cases.append("".join(rnd.choice("ab .") for _ in range(rnd.randint(60, 68))))
    bad = [c for c in cases
           if (t.render(DATA_STORE="external", DATA_AREA=c, _external_data=EMPTY).strip() == "") != area_ok(c)]
    if bad:
        print(f"check 6 — the DATA_AREA validator disagrees with DESIGN.md Section 2's rules on {len(bad)} of "
              f"{len(cases)} names, for example {bad[0]!r} (the rules {'accept' if area_ok(bad[0]) else 'refuse'} it)")

# 7. Each kind refuses an earlier kind's name in another case, and accepts a distinct one.
KINDS = ["DATA_KIND_DOCS", "DATA_KIND_PHOTOS", "DATA_KIND_AUDIO", "DATA_KIND_VIDEOS"]
BASE = {"DATA_KIND_DOCS": "Docs", "DATA_KIND_PHOTOS": "Photos", "DATA_KIND_AUDIO": "Audio", "DATA_KIND_VIDEOS": "Videos"}
for i, key in enumerate(KINDS):
    t = compiled(key, "validator", "check 7")
    if t is None:
        continue
    def verdict(value):
        ctx = dict(BASE, DATA_STORE="external", _external_data=EMPTY)
        ctx[key] = value
        return t.render(**ctx).strip()
    problems = []
    for earlier in KINDS[:i]:
        for value in (BASE[earlier].lower(), BASE[earlier].upper(), BASE[earlier]):
            if not verdict(value):
                problems.append(f"accepts {value!r} beside {earlier} {BASE[earlier]!r}")
    if verdict(BASE[key].lower() + "-own"):
        problems.append(f"refuses the distinct name {BASE[key].lower() + '-own'!r}")
    if problems:
        print(f"check 7 — the {key} validator {problems[0]} — two kinds that differ only in case "
              f"are one folder on a case-insensitive disk")

# 8. DATA_SLUG's default gives the reference slug of the folder name, or no default (UNSET).
ref = {}
exec(sys.argv[2], ref)
UNSET = "\x00UNSET\x00"
t = compiled("DATA_SLUG", "default", "check 8")
if t is not None:
    names = ["My_Project.v2", "probe-project", "Probe Project", "--a--b--", "a\tb", "A.B_C-D E", "\u041a\u043d\u0438\u0433\u0430",
             "con", "CON", "Con.", "com1", "LPT9", "com10", "con-x", "", "!!!", "\u00c9cole de Paris", "x" * 66,
             "y" * 63 + " b", "z" * 64 + "-tail", "a" * 62 + "--" + "b", "a" * 63 + "\u00e9" + "b" * 3,
             "A_Long.Project-NAME_with__doubled..separators-\u00dcn\u00efcode-and-a-tail-that-runs-well-past-sixty-four"]
    alpha = ["a", "B", "z", "0", "9", "_", ".", "-", " ", "\u00e9", "\u041a", "\t", "c", "o", "n", "1", "l", "p", "t", "!"]
    rnd = random.Random(8)
    for _ in range(5000):
        names.append("".join(rnd.choice(alpha) for _ in range(rnd.randint(0, 12))))
    for _ in range(300):
        names.append("".join(rnd.choice("ab-_. ") for _ in range(rnd.randint(58, 72))))
    bad = []
    for n in names:
        want = ref["slug_ref"](n) or UNSET
        got = t.render(_folder_name=n, _external_data=EMPTY, UNSET=UNSET).strip()
        if got != want:
            bad.append((n, got, want))
    for n, record in (("prev", {"prev": {"DATA_SLUG": "kept-slug"}, "peer": {"DATA_SLUG": "peer-slug"}}),
                      ("peer", {"prev": {}, "peer": {"DATA_SLUG": "peer-slug"}})):
        want = record[n]["DATA_SLUG"]
        got = t.render(_folder_name="Other Folder", _external_data=record, UNSET=UNSET).strip()
        if got != want:
            bad.append((f"<a {n} record holding {want!r}>", got, want))
    if bad:
        n, got, want = bad[0]
        show = lambda v: "no default (UNSET)" if v == UNSET else repr(v)
        print(f"check 8 — the DATA_SLUG default disagrees with DESIGN.md Section 2's rule on {len(bad)} of "
              f"{len(names) + 2} folder names, for example {n!r}: it gives {show(got)}, the rule {show(want)}")
PY
}

VALIDATOR_COPIER=""
run_checks() {
  FINDINGS=()
  local name status err line want
  if sa_jinja_init; then
    while IFS= read -r line; do [[ -n "$line" ]] && finding "$line"; done \
      < <(validator_problems "${VALIDATOR_COPIER:-$SA_ROOT/copier.yml}")
  else
    NOTES+=("checks 3, 4 and 6–8 skipped — no Python with Jinja2 and PyYAML (python3, or uvx --from copier)")
  fi
  for name in "${SELECTED[@]}"; do
    status="$(cat "$OUT/$name.status" 2>/dev/null || echo 'did not run')"
    err="$(grep -v '^[[:space:]]*$' "$OUT/$name.log" 2>/dev/null | tail -1 || true)"
    want="$(render_fail "$name")"
    if [[ -n "$want" ]]; then
      if [[ "$status" == 0 ]]; then
        finding "check 5 — $name rendered, but DESIGN.md says it must be refused for $want (folder '$(render_folder "$name")') — see $OUT/$name.log"
      elif ! grep -qF -- "$want" "$OUT/$name.log" 2>/dev/null; then
        finding "check 5 — $name was refused (exit $status), but not for $want: ${err:-no output} — see $OUT/$name.log"
      fi
      continue
    fi
    if [[ "$status" != 0 ]]; then
      finding "check 1 — $name did not render (exit $status): ${err:-no output} — see $OUT/$name.log"
      continue
    fi
    [[ -f "$(tree_of "$name")/$SA_ANSWERS_FILE" ]] \
      || finding "check 2 — $name has no $SA_ANSWERS_FILE — it can never be updated"
  done
}

# ── Self-test ────────────────────────────────────────────────────────────────

# The agent questions' validators (checks 3–4), and the data-root validators and the slug's
# default (checks 6–8), in their proven shape, for the self-test.
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
DATA_AREA:
  type: str
  when: "<% DATA_STORE == 'external' %>"
  validator: >-
    <: if DATA_STORE == 'external' :><: set a = DATA_AREA :><: set p = (_external_data.peer or {}).get('DATA_AREA') :><: set q = (_external_data.prev or {}).get('DATA_AREA') :><: set stem = a.split('.')[0].rstrip(' ').upper() :><: if not a :>Name the area, the first folder under the data root: for example business.<: elif a | select('in', '<>:"/\\|?*') | list | length > 0 :>Leave out < > : " / \ | ? and *: Windows and network disks refuse them in a folder name.<: elif a | select('lt', ' ') | list | length > 0 or '\x7f' in a :>Leave out tabs and other control characters: no disk keeps them safely in a folder name.<: elif a[-1] in '. ' or a[0] == ' ' :>Do not end the name with a dot or a space, or begin it with a space: Windows drops them, which is also why . and .. are refused.<: elif stem in ['CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'] or (stem | length == 4 and stem[:3] in ['COM', 'LPT'] and stem[3] in '123456789¹²³') :>Windows reserves that name in any case, before any dot (CON, PRN, AUX, NUL, COM1 to COM9, LPT1 to LPT9 and the like): choose another.<: elif a | length > 64 :>Keep the name to 64 characters or fewer.<: elif q and a != q and a | lower == q | lower :>This project's files are filed under '<% q %>'. A change of case alone makes a second folder on some disks and the same folder on others: keep '<% q %>', or choose another name.<: elif not q and p and a != p and a | lower == p | lower :>The other template files this project under '<% p %>'. A difference of case alone makes a second folder on some disks and the same folder on others: answer '<% p %>' exactly.<: elif not q and p and a != p :>One project, one layout: the other template files this project under '<% p %>'. Answer '<% p %>' here too, or change that template's answer first.<: endif :><: endif :>
DATA_SLUG:
  type: str
  default: "<: set k = ((_folder_name | lower | replace('_', ' ') | replace('.', ' ') | replace('-', ' ') | select('in', 'abcdefghijklmnopqrstuvwxyz0123456789 ') | join).split() | join('-'))[:64].rstrip('-') :><% (_external_data.prev or {}).get('DATA_SLUG') or (_external_data.peer or {}).get('DATA_SLUG') or (k if k and k not in ['con', 'prn', 'aux', 'nul', 'com1', 'com2', 'com3', 'com4', 'com5', 'com6', 'com7', 'com8', 'com9', 'lpt1', 'lpt2', 'lpt3', 'lpt4', 'lpt5', 'lpt6', 'lpt7', 'lpt8', 'lpt9'] else UNSET) %>"
  when: "<% DATA_STORE == 'external' %>"
DATA_KIND_DOCS:
  type: str
  when: "<% DATA_STORE == 'external' %>"
  validator: >-
    <: if DATA_STORE == 'external' :><: set k = DATA_KIND_DOCS :><: set p = (_external_data.peer or {}).get('DATA_KIND_DOCS') :><: set q = (_external_data.prev or {}).get('DATA_KIND_DOCS') :><: set stem = k.split('.')[0].rstrip(' ').upper() :><: if not k :>Name the folder for documents: for example docs.<: elif k | select('in', '<>:"/\\|?*') | list | length > 0 :>Leave out < > : " / \ | ? and *: Windows and network disks refuse them in a folder name.<: elif k | select('lt', ' ') | list | length > 0 or '\x7f' in k :>Leave out tabs and other control characters: no disk keeps them safely in a folder name.<: elif k[-1] in '. ' or k[0] == ' ' :>Do not end the name with a dot or a space, or begin it with a space: Windows drops them, which is also why . and .. are refused.<: elif stem in ['CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'] or (stem | length == 4 and stem[:3] in ['COM', 'LPT'] and stem[3] in '123456789¹²³') :>Windows reserves that name in any case, before any dot (CON, PRN, AUX, NUL, COM1 to COM9, LPT1 to LPT9 and the like): choose another.<: elif k | length > 64 :>Keep the name to 64 characters or fewer.<: elif q and k != q and k | lower == q | lower :>This project's documents are filed under '<% q %>'. A change of case alone makes a second folder on some disks and the same folder on others: keep '<% q %>', or choose another name.<: elif not q and p and k != p and k | lower == p | lower :>The other template files documents under '<% p %>'. A difference of case alone makes a second folder on some disks and the same folder on others: answer '<% p %>' exactly.<: elif not q and p and k != p :>One project, one layout: the other template files documents under '<% p %>'. Answer '<% p %>' here too, or change that template's answer first.<: endif :><: endif :>
DATA_KIND_PHOTOS:
  type: str
  when: "<% DATA_STORE == 'external' %>"
  validator: >-
    <: if DATA_STORE == 'external' :><: set k = DATA_KIND_PHOTOS :><: set p = (_external_data.peer or {}).get('DATA_KIND_PHOTOS') :><: set q = (_external_data.prev or {}).get('DATA_KIND_PHOTOS') :><: set stem = k.split('.')[0].rstrip(' ').upper() :><: if not k :>Name the folder for images: for example photos.<: elif k | select('in', '<>:"/\\|?*') | list | length > 0 :>Leave out < > : " / \ | ? and *: Windows and network disks refuse them in a folder name.<: elif k | select('lt', ' ') | list | length > 0 or '\x7f' in k :>Leave out tabs and other control characters: no disk keeps them safely in a folder name.<: elif k[-1] in '. ' or k[0] == ' ' :>Do not end the name with a dot or a space, or begin it with a space: Windows drops them, which is also why . and .. are refused.<: elif stem in ['CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'] or (stem | length == 4 and stem[:3] in ['COM', 'LPT'] and stem[3] in '123456789¹²³') :>Windows reserves that name in any case, before any dot (CON, PRN, AUX, NUL, COM1 to COM9, LPT1 to LPT9 and the like): choose another.<: elif k | length > 64 :>Keep the name to 64 characters or fewer.<: elif k | lower == DATA_KIND_DOCS | lower :>Give images a folder of their own: documents already use '<% DATA_KIND_DOCS %>', and a difference of case alone is the same folder on some disks.<: elif q and k != q and k | lower == q | lower :>This project's images are filed under '<% q %>'. A change of case alone makes a second folder on some disks and the same folder on others: keep '<% q %>', or choose another name.<: elif not q and p and k != p and k | lower == p | lower :>The other template files images under '<% p %>'. A difference of case alone makes a second folder on some disks and the same folder on others: answer '<% p %>' exactly.<: elif not q and p and k != p :>One project, one layout: the other template files images under '<% p %>'. Answer '<% p %>' here too, or change that template's answer first.<: endif :><: endif :>
DATA_KIND_AUDIO:
  type: str
  when: "<% DATA_STORE == 'external' %>"
  validator: >-
    <: if DATA_STORE == 'external' :><: set k = DATA_KIND_AUDIO :><: set p = (_external_data.peer or {}).get('DATA_KIND_AUDIO') :><: set q = (_external_data.prev or {}).get('DATA_KIND_AUDIO') :><: set stem = k.split('.')[0].rstrip(' ').upper() :><: if not k :>Name the folder for audio: for example audio.<: elif k | select('in', '<>:"/\\|?*') | list | length > 0 :>Leave out < > : " / \ | ? and *: Windows and network disks refuse them in a folder name.<: elif k | select('lt', ' ') | list | length > 0 or '\x7f' in k :>Leave out tabs and other control characters: no disk keeps them safely in a folder name.<: elif k[-1] in '. ' or k[0] == ' ' :>Do not end the name with a dot or a space, or begin it with a space: Windows drops them, which is also why . and .. are refused.<: elif stem in ['CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'] or (stem | length == 4 and stem[:3] in ['COM', 'LPT'] and stem[3] in '123456789¹²³') :>Windows reserves that name in any case, before any dot (CON, PRN, AUX, NUL, COM1 to COM9, LPT1 to LPT9 and the like): choose another.<: elif k | length > 64 :>Keep the name to 64 characters or fewer.<: elif k | lower in [DATA_KIND_DOCS | lower, DATA_KIND_PHOTOS | lower] :>Give audio a folder of its own: documents use '<% DATA_KIND_DOCS %>' and images '<% DATA_KIND_PHOTOS %>', and a difference of case alone is the same folder on some disks.<: elif q and k != q and k | lower == q | lower :>This project's audio is filed under '<% q %>'. A change of case alone makes a second folder on some disks and the same folder on others: keep '<% q %>', or choose another name.<: elif not q and p and k != p and k | lower == p | lower :>The other template files audio under '<% p %>'. A difference of case alone makes a second folder on some disks and the same folder on others: answer '<% p %>' exactly.<: elif not q and p and k != p :>One project, one layout: the other template files audio under '<% p %>'. Answer '<% p %>' here too, or change that template's answer first.<: endif :><: endif :>
DATA_KIND_VIDEOS:
  type: str
  when: "<% DATA_STORE == 'external' %>"
  validator: >-
    <: if DATA_STORE == 'external' :><: set k = DATA_KIND_VIDEOS :><: set p = (_external_data.peer or {}).get('DATA_KIND_VIDEOS') :><: set q = (_external_data.prev or {}).get('DATA_KIND_VIDEOS') :><: set stem = k.split('.')[0].rstrip(' ').upper() :><: if not k :>Name the folder for video: for example videos.<: elif k | select('in', '<>:"/\\|?*') | list | length > 0 :>Leave out < > : " / \ | ? and *: Windows and network disks refuse them in a folder name.<: elif k | select('lt', ' ') | list | length > 0 or '\x7f' in k :>Leave out tabs and other control characters: no disk keeps them safely in a folder name.<: elif k[-1] in '. ' or k[0] == ' ' :>Do not end the name with a dot or a space, or begin it with a space: Windows drops them, which is also why . and .. are refused.<: elif stem in ['CON', 'PRN', 'AUX', 'NUL', 'CONIN$', 'CONOUT$'] or (stem | length == 4 and stem[:3] in ['COM', 'LPT'] and stem[3] in '123456789¹²³') :>Windows reserves that name in any case, before any dot (CON, PRN, AUX, NUL, COM1 to COM9, LPT1 to LPT9 and the like): choose another.<: elif k | length > 64 :>Keep the name to 64 characters or fewer.<: elif k | lower in [DATA_KIND_DOCS | lower, DATA_KIND_PHOTOS | lower, DATA_KIND_AUDIO | lower] :>Give video a folder of its own: documents use '<% DATA_KIND_DOCS %>', images '<% DATA_KIND_PHOTOS %>' and audio '<% DATA_KIND_AUDIO %>', and a difference of case alone is the same folder on some disks.<: elif q and k != q and k | lower == q | lower :>This project's video is filed under '<% q %>'. A change of case alone makes a second folder on some disks and the same folder on others: keep '<% q %>', or choose another name.<: elif not q and p and k != p and k | lower == p | lower :>The other template files video under '<% p %>'. A difference of case alone makes a second folder on some disks and the same folder on others: answer '<% p %>' exactly.<: elif not q and p and k != p :>One project, one layout: the other template files video under '<% p %>'. Answer '<% p %>' here too, or change that template's answer first.<: endif :><: endif :>
EOF
}

self_test() {
  local tmp real_root="$SA_ROOT" real_out="$OUT" real_only="$ONLY" real_renders="$RENDERS"
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/tpl" >/dev/null
  # The fixture gains the slug's refusal (check 5): no default where the folder is `con`, so
  # `--defaults` stops on the question, as copier.yml's DATA_SLUG does.
  printf '%s\n' 'DATA_SLUG:' '  type: str' "  default: \"<% UNSET if _folder_name == 'con' else _folder_name %>\"" \
    >> "$tmp/tpl/copier.yml"
  cp "$tmp/tpl/copier.yml" "$tmp/copier.held"
  RENDERS="$real_renders"$'\ntheology-refused     folder:con fail:DATA_SLUG'
  write_validators "$tmp/validators.yml"; VALIDATOR_COPIER="$tmp/validators.yml"
  SA_ROOT="$tmp/tpl"; OUT="$tmp/out"
  printf '# Uncommitted\n' > "$SA_ROOT/template/UNCOMMITTED.md"

  ONLY="theology-defaults,business-defaults,theology-refused"; select_renders; generate 2>/dev/null
  st_baseline "the fixture template, rendered twice and refused once"
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

  ONLY="theology-refused"; select_renders
  sed -i "s/UNSET if _folder_name == 'con' else _folder_name/_folder_name/" "$tmp/tpl/copier.yml"
  generate 2>/dev/null
  probe "check 5 fires when a folder that leaves no slug still renders" "check 5 — theology-refused rendered"
  sed -e 's/^DATA_SLUG:$/DATA_FOLDER:/' "$tmp/copier.held" > "$tmp/tpl/copier.yml"
  generate 2>/dev/null
  probe "check 5 fires when the render is refused for another question" "check 5 — theology-refused was refused (exit 1), but not for DATA_SLUG"
  cp "$tmp/copier.held" "$tmp/tpl/copier.yml"
  ONLY="theology-defaults"; select_renders; generate 2>/dev/null

  if sa_jinja_init; then
    sed -i "s/ or '\"' in u :>/ :>/" "$tmp/validators.yml"
    probe "check 3 fires when the base-URL validator lets a quotation mark through" "check 3 — the OPENCODE_BASE_URL validator disagrees"
    write_validators "$tmp/validators.yml"
    sed -i "s/<: if 'codex' in AGENT_CLIENTS and CODEX_MODEL/<: if CODEX_MODEL/" "$tmp/validators.yml"
    probe "check 4 fires when a validator does not open with its when test" "check 4 — the CODEX_MODEL validator fires while CODEX_MODEL is hidden"
    write_validators "$tmp/validators.yml"
    sed -i "s/elif a | length > 64 :>/elif a | length > 65 :>/" "$tmp/validators.yml"
    probe "check 6 fires when the area validator lets a 65-character name through" "check 6 — the DATA_AREA validator disagrees"
    write_validators "$tmp/validators.yml"
    sed -i "s/ or '\\\\x7f' in a :>/ :>/" "$tmp/validators.yml"
    probe "check 6 fires when the area validator lets DEL through" "check 6 — the DATA_AREA validator disagrees"
    write_validators "$tmp/validators.yml"
    sed -i "s/elif k | lower == DATA_KIND_DOCS | lower :>/elif k == DATA_KIND_DOCS :>/" "$tmp/validators.yml"
    probe "check 7 fires when a kind may repeat another in another case" "check 7 — the DATA_KIND_PHOTOS validator accepts 'docs' beside DATA_KIND_DOCS 'Docs'"
    write_validators "$tmp/validators.yml"
    sed -i "s/\[:64\]\.rstrip('-')/[:64]/" "$tmp/validators.yml"
    probe "check 8 fires when the slug keeps a trailing hyphen" "check 8 — the DATA_SLUG default disagrees"
    write_validators "$tmp/validators.yml"
    sed -i "s/else UNSET) %>/else 'project') %>/" "$tmp/validators.yml"
    probe "check 8 fires when a folder that leaves no slug gets a literal one" "check 8 — the DATA_SLUG default disagrees"
    write_validators "$tmp/validators.yml"
  else
    log "  - checks 3, 4 and 6–8 not proven: no Python with Jinja2 and PyYAML (python3, or uvx --from copier)"
  fi

  SA_ROOT="$real_root"; OUT="$real_out"; ONLY="$real_only"; VALIDATOR_COPIER=""; RENDERS="$real_renders"
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
  [[ -z "$(render_fail "$name")" && "$(cat "$OUT/$name.status" 2>/dev/null)" == 0 ]] && printf '%s\n' "$(tree_of "$name")"
done

for n in "${NOTES[@]}"; do note "  - $n"; done
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  $QUIET || note "✓ ${#SELECTED[@]} render(s), each complete or refused as designed; the agent and data-root validators proven."
  exit 0
fi
{
  printf '✗ %d finding(s):\n' "${#FINDINGS[@]}"
  print_findings
} >&2
exit 1
