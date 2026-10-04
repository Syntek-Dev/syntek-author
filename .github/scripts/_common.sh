#!/usr/bin/env bash
#
# _common.sh — the one home for what every syntek-author audit reads. Sourced, never run.
#
#              Seventeen audits ask overlapping questions of the same three inputs: copier.yml
#              (what is gated, what is seeded, which tokens are registered), DESIGN.md (what
#              each variant must ship), and a tree (the template source or a render). When
#              each script carried its own parser they disagreed — about whether
#              `/README.md` and `README.md` name the same seed, about whether
#              `not (DOC_TYPE == 'theology')` and `DOC_TYPE != 'theology'` are the same gate —
#              and an audit that disagrees with its neighbour about the input is two audits
#              that cannot both be right. One reader, one home.
#
#              What lives here:
#                - logging, findings and the self-test harness (SB house shape);
#                - copier.yml readers: list items, registered keys, gated paths, gate negation;
#                - the DESIGN.md catalogue: skills, mode files, gated paths, seeds, examples,
#                  pair-only folders, the spine set;
#                - a reader for a rendered tree's answers file, and a gate evaluator;
#                - the rendering helpers (snapshot a working tree, render with Copier) and the
#                  minimal fixture template the integration self-tests run against.
#
#              The catalogue is DESIGN.md transcribed. When DESIGN.md changes, this file
#              changes in the same commit; every audit that reads it then moves together.
#
#              Nothing here writes to the repository. Fixtures and snapshots go to mktemp.
#
# Requirements: bash 4+, git, grep, awk, sed. rsync and uvx only for the rendering helpers.

# This file is a library: its catalogue variables are read by the scripts that source it.
# shellcheck disable=SC2034

[[ -n "${_SA_COMMON_LOADED:-}" ]] && return 0
_SA_COMMON_LOADED=1

SA_SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SA_ROOT="${SA_ROOT:-$(cd "$SA_SCRIPTS_DIR/../.." && pwd)}"
SA_ANSWERS_FILE=".copier-answers.syntek-author.yml"
: "${SCRIPT_NAME:=audit}"

# ── Logging and findings ─────────────────────────────────────────────────────

QUIET=${QUIET:-false}
log()  { $QUIET || printf '%s\n' "$*"; }
note() { printf '%s\n' "$*" >&2; }
die()  { printf '%s error: %s\n' "$SCRIPT_NAME" "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

FINDINGS=()
finding() { FINDINGS+=("$1"); }

print_findings() {
  local f
  for f in "${FINDINGS[@]}"; do printf '  · %s\n' "$f"; done
}

# ── Self-test harness ────────────────────────────────────────────────────────
#
# SB rule 38: a guard nobody has seen fail is a guard nobody knows works. The baseline must be
# clean first ("a mutation proof on a broken baseline means nothing"), then each mutation must
# produce EXACTLY ONE finding carrying the expected text — a check that fires for the wrong
# reason fails the proof as loudly as one that never fires.

ST_FAILS=0
ST_PROBES=0

st_baseline() { # $1 = what the baseline is
  run_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ %s already fails — a mutation proof on a broken baseline means nothing\033[0m\n' "$1" >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    exit 2
  fi
  log "  ✓ $1 passes — the baseline is clean"
}

probe() { # $1 = label, $2 = a substring the single expected finding must contain
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ ${#FINDINGS[@]} -eq 1 ]] && [[ "${FINDINGS[0]}" == *"$2"* ]]; then
    log "  ✓ $1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    printf '\033[31m  ✗ %s produced %d finding(s): %s\033[0m\n' \
      "$1" "${#FINDINGS[@]}" "$(printf '%s; ' "${FINDINGS[@]:-(none)}")"
  fi
}

probe_clean() { # $1 = label — a shape the checks must NOT flag
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    printf '\033[31m  ✗ %s produced %d finding(s): %s\033[0m\n' \
      "$1" "${#FINDINGS[@]}" "$(printf '%s; ' "${FINDINGS[@]}")"
  fi
}

st_finish() { # $1 = what the detector separates
  log ""
  if [[ "$ST_FAILS" -eq 0 ]]; then
    bold "✓ Self-test passed — $ST_PROBES probes: every check fires on its own mutation."
    return 0
  fi
  log "  the detector no longer separates $1 —"
  log "  fix the check, never the expectation."
  return 1
}

sa_mktemp() { mktemp -d "${TMPDIR:-/tmp}/syntek-author-audit.XXXXXX" || die "could not create a temporary directory"; }

# ── copier.yml readers ───────────────────────────────────────────────────────

# Every list item under a top-level key, unquoted, one per line. Comments and blank lines are
# skipped; the block ends at the next top-level key. Handles "double", 'single' (with '' as an
# escaped quote) and bare items, and strips a trailing comment from a bare item.
yaml_list() { # $1 = key, $2 = file
  [[ -f "$2" ]] || return 0
  awk -v key="$1" '
    function unq(s,   c, out, i, ch) {
      sub(/^[ \t]+/, "", s)
      c = substr(s, 1, 1)
      if (c == "\"") {
        out = ""; i = 2
        while (i <= length(s)) {
          ch = substr(s, i, 1)
          if (ch == "\\") { out = out substr(s, i + 1, 1); i += 2; continue }
          if (ch == "\"") break
          out = out ch; i++
        }
        return out
      }
      if (c == "\047") {
        out = ""; i = 2
        while (i <= length(s)) {
          ch = substr(s, i, 1)
          if (ch == "\047") { if (substr(s, i + 1, 1) == "\047") { out = out "\047"; i += 2; continue }; break }
          out = out ch; i++
        }
        return out
      }
      sub(/[ \t]+#.*$/, "", s); sub(/[ \t]+$/, "", s)
      return s
    }
    $0 ~ "^" key ":" { on = 1; next }
    on && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
    on && /^[ \t]*#/ { next }
    on && /^[ \t]+- / { line = $0; sub(/^[ \t]+- /, "", line); print unq(line) }
  ' "$2"
}

registered_keys() { # $1 = copier.yml
  grep -oE '^[A-Z][A-Z0-9_]*:' "$1" 2>/dev/null | tr -d ':' | sort -u
}

norm_expr() { # collapse whitespace, prefer single quotes
  local e="$1"
  e="${e//\"/\'}"
  e="$(printf '%s' "$e" | tr -s '[:space:]' ' ')"
  e="${e#"${e%%[![:space:]]*}"}"; e="${e%"${e##*[![:space:]]}"}"
  printf '%s' "$e"
}

# Split a templated list item "<: if COND :>/path<: endif :>" into COND<TAB>path (path without
# its leading slash). Prints nothing for an untemplated item.
split_gated_item() {
  local re='^<:-?[[:space:]]*if[[:space:]]+(.+[^[:space:]-])[[:space:]]*-?:>(.*)<:-?[[:space:]]*endif[[:space:]]*-?:>$'
  if [[ "$1" =~ $re ]]; then
    printf '%s\t%s\n' "$(norm_expr "${BASH_REMATCH[1]}")" "${BASH_REMATCH[2]#/}"
  fi
}

# COND<TAB>path for every templated _exclude entry.
exclude_gates() { # $1 = copier.yml
  local item
  while IFS= read -r item; do
    split_gated_item "$item"
  done < <(yaml_list _exclude "$1")
}

# The SHIPPING gate of an exclusion condition: `not (G)` → G; `A == 'x' or not B` →
# `A != 'x' and B`. Returns 1 for a shape it cannot negate textually.
negate_gate() {
  local c out="" atom rest
  c="$(norm_expr "$1")"
  if [[ "$c" =~ ^not\ \(([^()]*)\)$ ]]; then printf '%s' "${BASH_REMATCH[1]}"; return 0; fi
  [[ "$c" == *'('* || "$c" == *' and '* ]] && return 1
  rest="$c"
  while :; do
    if [[ "$rest" == *' or '* ]]; then atom="${rest%% or *}"; rest="${rest#* or }"; else atom="$rest"; rest=""; fi
    if   [[ "$atom" =~ ^([A-Za-z_][A-Za-z0-9_]*)\ ==\ (.+)$ ]]; then atom="${BASH_REMATCH[1]} != ${BASH_REMATCH[2]}"
    elif [[ "$atom" =~ ^([A-Za-z_][A-Za-z0-9_]*)\ !=\ (.+)$ ]]; then atom="${BASH_REMATCH[1]} == ${BASH_REMATCH[2]}"
    elif [[ "$atom" =~ ^not\ ([A-Za-z_][A-Za-z0-9_]*)$ ]];     then atom="${BASH_REMATCH[1]}"
    elif [[ "$atom" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]];            then atom="not $atom"
    else return 1; fi
    out="${out:+$out and }$atom"
    [[ -z "$rest" ]] && break
  done
  printf '%s' "$out"
}

# ── The DESIGN.md catalogue ──────────────────────────────────────────────────
#
# Gates are written in a small vocabulary so a tree's answers can be tested against them:
#   always · optional · theology · fiction · business · books · wb · conlang · refs ·
#   proposal · sensitive · drive · seed · fam-<family> — joined with & for "and". Each carries
#   its DOC_TYPE test (DESIGN.md Section 2), exactly as Section 3.5 writes it. A fam-<family>
#   gate is one business document family chosen in BUSINESS_FAMILIES (D39); the `business`
#   family is always chosen, so its paths carry the plain `business` gate.

declare -A SA_GATE_EXPR=(
  [theology]="DOC_TYPE == 'theology'"
  [fiction]="DOC_TYPE == 'fiction'"
  [business]="DOC_TYPE == 'business'"
  [books]="DOC_TYPE != 'business'"
  [wb]="DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING"
  [conlang]="DOC_TYPE == 'fiction' and INCLUDE_CONLANG"
  [refs]="INCLUDE_REFERENCES"
  [proposal]="DOC_TYPE != 'business' and INCLUDE_PROPOSAL"
  [sensitive]="DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT"
  [drive]="DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC"
  [fam-legal]="DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES"
  [fam-email]="DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES"
  [fam-accounting]="DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES"
  [fam-social-media]="DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES"
  [fam-msp-scp]="DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES"
)

# The business document families (DESIGN.md D39), the default BUSINESS_FAMILIES answer, and
# v0.1.0's family folders, which v0.2.0 retired (D44): none may ship again.
SA_FAMILIES="business legal email accounting social-media msp-scp"
SA_FAMILIES_DEFAULT="business legal email accounting social-media"
SA_RETIRED_FAMILIES="proposals contracts policies correspondence finance marketing"

# Skills (DESIGN.md Section 5): name · gate · modes (TFB = THEOLOGY+FICTION+BUSINESS, TF, -).
SA_SKILLS=$(cat <<'EOF'
run-workflow        always    -
draft-section       always    TFB
adapt-section       always    TFB
improve-section     always    TFB
promote-section     always    TFB
learn-voice         always    TFB
fact-check          always    TFB
spelling            always    TFB
grammar             always    TFB
comprehension       always    TFB
flow                always    TFB
structure-review    always    TFB
build               always    TFB
grilling            always    TFB
grill-with-docs     always    TFB
handoff             always    TFB
prototype           always    TFB
teach               always    TFB
wayfinder           always    TFB
research            always    TFB
grill-me            always    -
wait-what           always    -
argument-audit      theology  -
category-check      theology  -
tradition-check     theology  -
steelman            theology  -
continuity          fiction   -
character-voice     fiction   -
causality           fiction   -
pacing              fiction   -
create-name         fiction   -
chart-character-arc fiction   -
create-creature     wb        -
design-quest        wb        -
build-language      conlang   -
add-word            conlang   -
design-script       conlang   -
pronounce           conlang   -
typeset             books     TF
clause-consistency  business  -
tone                business  -
obligation-check    business  -
business-documents     business          -
legal-documents        fam-legal         -
email-documents        fam-email         -
accounting-documents   fam-accounting    -
social-media-documents fam-social-media  -
msp-scp-documents      fam-msp-scp       -
add-reference       refs      -
approach-a-reader   proposal  TF
sensitivity-pass    sensitive TF
EOF
)

# Standards folders that carry a mode file (DESIGN.md Section 4.2).
SA_MODED_STANDARDS="method risk verification"
SA_MODE_FILES="THEOLOGY.md FICTION.md BUSINESS.md"

mode_for_doc() { # theology → THEOLOGY.md
  case "$1" in theology) echo THEOLOGY.md ;; fiction) echo FICTION.md ;; business) echo BUSINESS.md ;; esac
}
doc_for_mode() { # THEOLOGY.md → theology
  case "$1" in THEOLOGY.md) echo theology ;; FICTION.md) echo fiction ;; BUSINESS.md) echo business ;; esac
}
modes_list() { # TFB → THEOLOGY.md FICTION.md BUSINESS.md
  local out=""
  [[ "$1" == *T* ]] && out+="THEOLOGY.md "
  [[ "$1" == *F* ]] && out+="FICTION.md "
  [[ "$1" == *B* ]] && out+="BUSINESS.md "
  printf '%s' "${out% }"
}

# Gated and required paths (DESIGN.md Sections 3.2, 3.5, 4). {L} is the content layer.
# Layer roots manuscript/ and library/ are checked on their own (content layer xor), so they are
# not rows here. kind: d = directory, f = file.
SA_PATHS=$(cat <<'EOF'
always             f  .copier-answers.syntek-author.yml
always             f  README.md
always             f  CONTEXT.md
always             f  Makefile
always             f  .gitignore
always             f  .mcp.json
always             f  .claude/CLAUDE.md
always             f  .claude/CONTEXT.md
always             f  .claude/MEMORY.md
always             f  .claude/settings.json
always             f  .claude/hooks/CONTEXT.md
always             f  .claude/hooks/CLAUDE.md
always             f  .claude/hooks/pre-compact-handoff.sh
always             f  .claude/skills/CONTEXT.md
always             f  .claude/skills/CLAUDE.md
always             f  .claude/rules/syntek-author/01-layout-and-routing.md
always             f  .claude/rules/syntek-author/02-skills.md
always             f  .claude/rules/syntek-author/03-authorship.md
always             f  .claude/rules/syntek-author/04-build-pipeline.md
always             f  .claude/rules/syntek-author/05-model-allocation.md
always             f  .claude/rules/syntek-author/06-global-rules.md
always             f  .claude/rules/syntek-author/07-session-boundaries.md
always             f  .claude/rules/syntek-author/08-naming-and-memory.md
always             f  .claude/rules/syntek-author/00-project.md
always             d  handoffs
always             d  learning
always             d  assets
always             d  {L}/docs/reference
always             d  {L}/docs/project
always             d  {L}/src
always             d  {L}/workflows/local
always             d  {L}/workflows/01-draft-a-section
always             d  {L}/workflows/02-adapt-a-draft
always             d  {L}/workflows/03-improve-your-draft
always             d  {L}/workflows/04-promote-a-section
always             d  {L}/workflows/06-build-a-proof
always             d  {L}/workflows/07-learn-from-your-edits
always             f  {L}/docs/reference/section-anatomy.md
always             f  {L}/docs/reference/drafting-with-ai.md
always             f  {L}/docs/reference/the-status-ladders.md
books              d  manuscript/workflows/05-review-a-chapter
business           d  library/workflows/05-review-a-document
business           d  library/workflows/08-ingest-an-existing-document
theology           d  manuscript/workflows/10-steelman-the-objections
theology           f  manuscript/docs/reference/main-text-and-footnotes.md
fiction            f  manuscript/docs/reference/scene-craft.md
business           f  library/docs/reference/document-anatomy.md
business           f  library/docs/reference/latex-deliverables.md
business           f  library/docs/reference/versioning-and-the-register.md
business           d  library/src/business
business           d  library/src/business/templates
business           d  library/src/business/client-docs
business           f  library/src/business/drafts/README.md
business           f  library/docs/reference/business-standards.md
business           d  library/workflows/10-create-a-business-document
fam-legal          d  library/src/legal
fam-legal          d  library/src/legal/templates
fam-legal          d  library/src/legal/client-docs
fam-legal          f  library/src/legal/drafts/README.md
fam-legal          f  library/docs/reference/legal-standards.md
fam-legal          d  library/workflows/11-create-a-legal-document
fam-email          d  library/src/email
fam-email          d  library/src/email/templates
fam-email          d  library/src/email/client-emails
fam-email          d  library/src/email/supplier-emails
fam-email          f  library/src/email/drafts/README.md
fam-email          f  library/docs/reference/email-standards.md
fam-email          f  library/docs/reference/EMAIL-ANATOMY-AND-NAMING.md
fam-email          d  library/workflows/12-write-an-email
fam-accounting     d  library/src/accounting
fam-accounting     d  library/src/accounting/templates
fam-accounting     d  library/src/accounting/client-docs
fam-accounting     f  library/src/accounting/drafts/README.md
fam-accounting     f  library/docs/reference/accounting-standards.md
fam-accounting     d  library/workflows/13-create-an-accounting-document
fam-social-media   d  library/src/social-media
fam-social-media   d  library/src/social-media/templates
fam-social-media   d  library/src/social-media/client-docs
fam-social-media   f  library/src/social-media/drafts/README.md
fam-social-media   f  library/docs/reference/social-media-standards.md
fam-social-media   d  library/workflows/14-create-a-social-media-document
fam-msp-scp        d  library/src/msp-scp
fam-msp-scp        d  library/src/msp-scp/templates
fam-msp-scp        d  library/src/msp-scp/client-docs
fam-msp-scp        f  library/src/msp-scp/drafts/README.md
fam-msp-scp        f  library/docs/reference/msp-scp-standards.md
fam-msp-scp        f  library/docs/reference/MSP-SCP-POLICY-SUITE.md
fam-msp-scp        d  library/workflows/15-create-an-msp-scp-document
always             d  planning/docs/reference
always             d  planning/docs/project
always             d  planning/workflows/local
always             f  planning/src/outline.md
always             d  planning/src/units
always             d  planning/src/maps
always             d  planning/src/reviews
always             d  planning/workflows/01-plan-a-unit
always             d  planning/workflows/09-review-the-whole-work
always             f  planning/docs/reference/unit-briefs.md
always             f  planning/docs/reference/reviews-are-advice.md
always             f  planning/docs/reference/decision-maps.md
theology           d  planning/src/arguments
theology           d  planning/workflows/02-map-the-argument
theology           f  planning/docs/reference/argument-maps.md
fiction            f  planning/src/causality.md
fiction            f  planning/src/timeline.md
fiction            f  planning/src/continuity.md
fiction            d  planning/src/arcs
fiction            d  planning/workflows/03-chart-the-causality
fiction            d  planning/workflows/04-chart-a-character-arc
fiction            f  planning/docs/reference/causality-chains.md
fiction            f  planning/docs/reference/character-arcs.md
wb                 d  planning/src/quests
wb                 d  planning/workflows/05-design-a-quest
wb                 f  planning/docs/reference/quest-design.md
business           f  planning/src/document-register.md
business           f  planning/src/review-schedule.md
business           f  planning/src/precedence.md
business           d  planning/src/approvals
business           d  planning/workflows/06-run-a-review-cycle
business           d  planning/workflows/07-record-an-approval
business           d  planning/workflows/08-update-the-register
business           f  planning/docs/reference/the-document-register.md
always             d  research/docs/reference
always             d  research/docs/project
always             d  research/workflows/local
always             d  research/src/sources
always             d  research/src/evidence
always             d  research/src/notes
always             d  research/workflows/01-ingest-a-source
always             d  research/workflows/02-verify-a-claim
always             f  research/docs/reference/ingesting-sources.md
always             f  research/docs/reference/vetting-evidence.md
theology           d  research/src/contested-readings
theology           d  research/workflows/03-map-a-contested-reading
theology           f  research/docs/reference/contested-readings.md
fiction            d  research/src/setting
fiction            f  research/src/permissions.md
fiction            f  research/docs/reference/real-world-detail.md
sensitive          d  research/src/testimony
sensitive          d  research/workflows/05-handle-testimony-safely
sensitive          f  research/docs/reference/handling-testimony.md
proposal           d  proposal
proposal           d  proposal/docs/reference
proposal           d  proposal/docs/project
proposal           d  proposal/workflows/local
proposal           d  proposal/workflows/01-assemble-the-proposal
proposal           d  proposal/workflows/02-approach-a-reader
proposal           d  proposal/workflows/03-update-the-tracker
proposal           f  proposal/docs/reference/comp-titles.md
proposal           f  proposal/docs/reference/approaching-readers.md
proposal           f  proposal/src/sample/sample-index.md
theology&proposal  d  proposal/src/book-proposal
theology&proposal  f  proposal/src/endorsements/tracker.md
theology&proposal  f  proposal/docs/reference/book-proposal-anatomy.md
fiction&proposal   f  proposal/src/query-letter.md
fiction&proposal   f  proposal/src/synopsis-short.md
fiction&proposal   f  proposal/src/synopsis-long.md
fiction&proposal   f  proposal/src/comp-titles.md
fiction&proposal   f  proposal/src/submissions/tracker.md
fiction&proposal   f  proposal/docs/reference/query-package-anatomy.md
fiction            d  world
fiction            d  world/docs/reference
fiction            d  world/docs/project
fiction            d  world/workflows/local
fiction            f  world/src/names-register.md
fiction            d  world/src/characters
fiction            d  world/src/places
fiction            f  world/src/.gitignore
fiction            d  world/workflows/01-create-a-character
fiction            d  world/workflows/02-create-a-place
fiction            d  world/workflows/03-name-something
fiction            f  world/docs/reference/story-bible.md
fiction            f  world/docs/reference/naming.md
wb                 d  world/src/creatures
wb                 d  world/src/cultures
wb                 d  world/workflows/04-create-a-creature
wb                 d  world/workflows/05-create-a-culture
wb                 f  world/docs/reference/creatures.md
wb                 f  world/docs/reference/cultures.md
wb                 d  world/src/peoples
wb                 d  world/src/history
wb                 f  world/src/history/eras.md
wb                 d  world/workflows/10-create-a-people
wb                 d  world/workflows/11-chart-the-world-history
wb                 f  world/docs/reference/peoples.md
wb                 f  world/docs/reference/world-history.md
conlang            d  world/src/languages
conlang            d  world/workflows/06-build-a-language
conlang            d  world/workflows/07-add-a-word
conlang            d  world/workflows/08-design-a-script
conlang            d  world/workflows/09-record-a-pronunciation
conlang            f  world/docs/reference/building-a-language.md
conlang            f  world/docs/reference/lexicon-format.md
conlang            f  world/docs/reference/writing-systems.md
conlang            f  world/docs/reference/pronunciation.md
conlang            f  tooling/lexicon.py
conlang            f  tooling/script.py
conlang            f  tooling/font.py
conlang            f  tooling/conlang_common.py
conlang            d  tooling/data
conlang            f  tooling/data/core-concepts.toml
always             f  standards/style/style-sheet.md
always             f  standards/style/voice-notes.md
always             f  standards/style/terminology.md
always             d  standards/style/samples
always             d  standards/style/ledger
always             f  standards/style/ledger/provenance.md
always             f  standards/method/method.md
always             f  standards/risk/risk.md
always             f  standards/verification/verification.md
sensitive          f  standards/risk/sensitive-content.md
refs               d  standards/referencing
refs               f  tooling/schema.sql
refs               f  tooling/seed-refs.sql
refs               f  tooling/export_refs.py
refs               f  tooling/harvard.csl
business           d  standards/brand
business           f  standards/brand/brand-voice.md
business           f  standards/brand/brand-guide.md
business           f  standards/brand/disclaimers.md
always             d  tooling/latex
always             f  tooling/latex/symbol-fallback.tex
always             f  tooling/latex/compare.tex
always             f  tooling/project.mk
business           f  tooling/latex/house-preamble.tex
business           f  tooling/latex/skeleton.tex
books              f  tooling/latex/housebook.cls
books              f  tooling/book.latex
always             f  tooling/texcheck.py
always             d  tooling/pandoc
always             f  tooling/pandoc/house.lua
always             f  tooling/defaults.yaml
always             f  tooling/provenance.py
always             f  tooling/compare.py
always             f  tooling/compare.yaml
books              d  typeset
books              d  typeset/docs/reference
books              d  typeset/docs/project
books              d  typeset/src
books              d  typeset/src/frontmatter
books              d  typeset/src/backmatter
books              d  typeset/src/units
books              f  typeset/src/units/.base/README.md
books              f  typeset/src/page-design.md
books              f  typeset/src/book.tex
books              d  typeset/workflows/local
books              d  typeset/workflows/01-design-the-page
books              d  typeset/workflows/02-typeset-a-chapter
books              d  typeset/workflows/03-retypeset-after-edits
books              d  typeset/workflows/04-typeset-the-book
books              f  typeset/docs/reference/the-typesetting-pipeline.md
books              f  typeset/docs/reference/the-house-class.md
books              f  typeset/docs/reference/the-fidelity-check.md
books              f  typeset/docs/reference/semantic-markdown.md
conlang            f  typeset/docs/reference/conlang-in-print.md
drive              d  .github
books&seed         d  manuscript/src/01-example-chapter
books&seed         f  planning/src/units/01-example-chapter.md
theology&seed      f  planning/src/arguments/01-example-chapter.md
business&seed      d  library/src/business/drafts/example-proposal
business&seed      f  planning/src/units/example-proposal.md
books&seed         f  standards/style/ledger/01-example-chapter--the-turn.md
books&seed         f  standards/style/ledger/01-example-chapter--opening.md
business&seed      f  standards/style/ledger/example-proposal--scope.md
conlang&seed       d  world/src/languages/example-proto
conlang&seed       d  world/src/languages/example-tongue
conlang&seed       f  research/src/setting/example-model-classical-latin.md
conlang&seed       f  research/src/setting/example-model-old-spanish.md
conlang&seed       f  research/src/setting/example-model-ogham.md
wb&seed            f  world/src/peoples/example-people.md
wb&seed            f  world/src/cultures/example-culture.md
EOF
)

# Paths that must never reach a generated project: the template's own state, and the retired
# agent and command tiers (DESIGN.md D5).
SA_NEVER="copier.yml DESIGN.md adopt template .copier-answers.yml .github/scripts .github/workflows/audit-template.yml .claude/agents .claude/commands"

# Seeds (DESIGN.md Section 3.1): the registers and style trio, the proposal package stubs, the
# business brand files, and the author-filled index pairs (the map index, and the pair of every
# layer's docs/project/ and workflows/local/).
SA_INDEX_SEED_LAYERS="manuscript library planning research proposal world typeset"
SA_INDEX_SEEDS="planning/src/maps/CONTEXT.md$(for l in $SA_INDEX_SEED_LAYERS; do for d in docs/project workflows/local; do printf ' %s/%s/CONTEXT.md %s/%s/CLAUDE.md' "$l" "$d" "$l" "$d"; done; done)"
SA_BRAND_SEEDS="standards/brand/brand-voice.md standards/brand/brand-guide.md"
SA_PROPOSAL_STUBS="proposal/src/book-proposal/01-overview-and-hook.md proposal/src/book-proposal/02-why-now.md proposal/src/book-proposal/03-audience.md proposal/src/book-proposal/04-comparable-titles.md proposal/src/book-proposal/05-chapter-outline.md proposal/src/book-proposal/06-about-the-author.md proposal/src/book-proposal/07-endorsements-and-reach.md proposal/src/book-proposal/08-sample-chapters.md proposal/src/query-letter.md proposal/src/synopsis-short.md proposal/src/synopsis-long.md proposal/src/comp-titles.md"
SA_SEEDS=".claude/rules/syntek-author/00-project.md tooling/project.mk README.md CONTEXT.md .gitignore .mcp.json .claude/CLAUDE.md .claude/CONTEXT.md .claude/MEMORY.md .claude/settings.json .claude/skills/CONTEXT.md .claude/skills/CLAUDE.md .claude/hooks/CONTEXT.md .claude/hooks/CLAUDE.md standards/style/style-sheet.md standards/style/voice-notes.md standards/style/terminology.md standards/style/ledger/provenance.md planning/src/outline.md planning/src/causality.md planning/src/timeline.md planning/src/continuity.md world/src/names-register.md planning/src/document-register.md planning/src/review-schedule.md planning/src/precedence.md standards/brand/disclaimers.md tooling/seed-refs.sql research/src/permissions.md proposal/src/endorsements/tracker.md proposal/src/submissions/tracker.md proposal/src/sample/sample-index.md world/src/history/eras.md typeset/src/page-design.md typeset/src/book.tex $SA_PROPOSAL_STUBS $SA_BRAND_SEEDS $SA_INDEX_SEEDS"

# Seed-once examples (DESIGN.md Section 3.2).
SA_EXAMPLES="manuscript/src/01-example-chapter planning/src/units/01-example-chapter.md planning/src/arguments/01-example-chapter.md library/src/business/drafts/example-proposal planning/src/units/example-proposal.md standards/style/ledger/01-example-chapter--the-turn.md standards/style/ledger/01-example-chapter--opening.md standards/style/ledger/example-proposal--scope.md world/src/languages/example-proto world/src/languages/example-tongue research/src/setting/example-model-classical-latin.md research/src/setting/example-model-old-spanish.md research/src/setting/example-model-ogham.md world/src/peoples/example-people.md world/src/cultures/example-culture.md"
SA_EXAMPLE_GATE="_copier_operation == 'update' or not SEED_EXAMPLES"

# The root spine (DESIGN.md Section 2, Token discipline), plus the answers file, which differs
# between every pair of renders by construction.
SA_ROOT_SPINE=".claude/CLAUDE.md CONTEXT.md README.md Makefile tooling/defaults.yaml .claude/settings.json .copier-answers.syntek-author.yml"
SA_ROOT_SPINE_GLOBS=".claude/rules/syntek-author/*.md"

# Tokens that may appear anywhere (DESIGN.md Section 2): identity and locale.
SA_IDENTITY_TOKENS="PROJECT_NAME PROJECT_SLUG AUTHOR_NAME AUTHOR_FIRST_NAME DATE TIMEZONE"
SA_COPIER_VARS="_copier_operation _copier_answers _copier_conf"

# Author-owned, pair-only folders (DESIGN.md Section 3.3). Globs are bash patterns on
# tree-relative directory paths.
SA_PAIR_ONLY_GLOBS="*/docs/project */workflows/local docs/project workflows/local standards/style/samples standards/style/ledger planning/src/units planning/src/maps planning/src/reviews planning/src/arguments planning/src/arcs planning/src/quests planning/src/approvals world/src/* research/src/* handoffs learning assets"

# ── Spine and gate sets, built from the catalogue and copier.yml together ────

declare -A SA_SPINE_EXACT=()
declare -A SA_SEED_SET=()
SA_EXAMPLE_LIST=()
SA_GATED_LIST=()
SA_ALLOWED_GATES=()
SA_SETS_FOR=""

# Build once per copier.yml. A missing copier.yml leaves the catalogue alone in charge, which is
# what a partial tree needs: the audits still know DESIGN.md's answer.
build_sets() { # $1 = copier.yml (may be absent)
  local copier="${1:-}" p cond path gate g s m expr
  [[ "$SA_SETS_FOR" == "x$copier" ]] && return 0
  SA_SETS_FOR="x$copier"
  SA_SPINE_EXACT=(); SA_SEED_SET=(); SA_EXAMPLE_LIST=(); SA_GATED_LIST=(); SA_ALLOWED_GATES=()

  for p in $SA_ROOT_SPINE; do SA_SPINE_EXACT["$p"]=1; done
  for p in $SA_SEEDS; do SA_SEED_SET["$p"]=1; done
  for p in $SA_EXAMPLES; do SA_EXAMPLE_LIST+=("$p"); done
  for g in "${SA_GATE_EXPR[@]}"; do SA_ALLOWED_GATES+=("$(norm_expr "$g")"); done
  SA_ALLOWED_GATES+=("$(norm_expr "_copier_operation != 'update' and SEED_EXAMPLES")")
  SA_ALLOWED_GATES+=("SEED_EXAMPLES")

  if [[ -n "$copier" && -f "$copier" ]]; then
    while IFS= read -r p; do
      [[ -z "$p" ]] && continue
      [[ "$p" == *'<:'* ]] && continue
      SA_SEED_SET["${p#/}"]=1
    done < <(yaml_list _skip_if_exists "$copier")
    while IFS=$'\t' read -r cond path; do
      [[ -z "$path" ]] && continue
      SA_GATED_LIST+=("$path")
      if [[ "$cond" == *_copier_operation* ]]; then SA_EXAMPLE_LIST+=("$path"); fi
      if expr="$(negate_gate "$cond")"; then SA_ALLOWED_GATES+=("$(norm_expr "$expr")"); fi
    done < <(exclude_gates "$copier")
  fi

  while read -r gate _ path; do
    [[ -z "$gate" || "$gate" == '#'* || "$gate" == always ]] && continue
    if [[ "$path" == '{L}'* ]]; then
      SA_GATED_LIST+=("manuscript${path#\{L\}}" "library${path#\{L\}}")
    else
      SA_GATED_LIST+=("$path")
    fi
  done <<< "$SA_PATHS"
  SA_GATED_LIST+=(manuscript library)

  while read -r s g m; do
    [[ -z "$s" ]] && continue
    [[ "$g" != always ]] && SA_GATED_LIST+=(".claude/skills/$s")
    for p in $(modes_list "$m"); do SA_GATED_LIST+=(".claude/skills/$s/$p"); done
  done <<< "$SA_SKILLS"
  for s in $SA_MODED_STANDARDS; do
    for p in $SA_MODE_FILES; do SA_GATED_LIST+=("standards/$s/$p"); done
  done
}

is_seed() { [[ -n "${SA_SEED_SET[$1]:-}" ]]; }

is_example() { # under a seed-once example path
  local e
  for e in "${SA_EXAMPLE_LIST[@]}"; do
    [[ "$1" == "$e" || "$1" == "$e"/* ]] && return 0
  done
  return 1
}

# An index file: a CONTEXT.md or CLAUDE.md whose folder holds a gated descendant.
is_index_file() {
  local base="${1##*/}" dir g
  [[ "$base" == CONTEXT.md || "$base" == CLAUDE.md ]] || return 1
  if [[ "$1" == */* ]]; then dir="${1%/*}"; else dir=""; fi
  for g in "${SA_GATED_LIST[@]}"; do
    if [[ -z "$dir" ]]; then return 0; fi
    [[ "$g" == "$dir"/* ]] && return 0
  done
  return 1
}

is_root_spine() {
  local g
  [[ -n "${SA_SPINE_EXACT[$1]:-}" ]] && return 0
  for g in $SA_ROOT_SPINE_GLOBS; do
    # shellcheck disable=SC2053  # the right-hand side is a glob on purpose
    [[ "$1" == $g ]] && return 0
  done
  return 1
}

# spine_kind REL → prints root | seed | example | index, or returns 1 for a shared file.
spine_kind() {
  if is_root_spine "$1"; then echo root; return 0; fi
  if is_seed "$1"; then echo seed; return 0; fi
  if is_example "$1"; then echo example; return 0; fi
  if is_index_file "$1"; then echo index; return 0; fi
  return 1
}

is_allowed_gate() {
  local e g
  e="$(norm_expr "$1")"
  for g in "${SA_ALLOWED_GATES[@]}"; do [[ "$e" == "$g" ]] && return 0; done
  return 1
}

# ── A rendered tree's answers, and the gate evaluator ────────────────────────

A_DOC_TYPE=""; A_PROPOSAL=false; A_REFS=false; A_SENSITIVE=false; A_WB=false
A_CONLANG=false; A_DRIVE=false; A_SEED=true; A_FAMILIES=""

answer_value() { # $1 = key, $2 = answers file → raw value, unquoted
  awk -v key="$1" '
    $0 ~ "^" key ":" {
      v = $0; sub("^" key ":[ \t]*", "", v); sub(/[ \t]+$/, "", v)
      if (v ~ /^".*"$/ || v ~ /^\047.*\047$/) v = substr(v, 2, length(v) - 2)
      print v; exit
    }' "$2" 2>/dev/null
}

# Every value of a list answer (a multiselect such as BUSINESS_FAMILIES), one per line. Copier
# writes a block list (`KEY:` then `- value` lines); a flow list (`KEY: [a, b]`) is read too.
answer_list() { # $1 = key, $2 = answers file
  awk -v key="$1" '
    $0 ~ "^" key ":" {
      v = $0; sub("^" key ":[ \t]*", "", v)
      if (v ~ /^\[/) { gsub(/[][ \t"\047]/, "", v); n = split(v, a, ","); for (i = 1; i <= n; i++) if (a[i] != "") print a[i]; exit }
      on = 1; next
    }
    on && /^[ \t]*- / { v = $0; sub(/^[ \t]*- [ \t]*/, "", v); gsub(/["\047]/, "", v); print v; next }
    on { exit }' "$2" 2>/dev/null
}

load_answers() { # $1 = answers file. Returns 1 if absent or carries no DOC_TYPE.
  local f="$1" v
  [[ -f "$f" ]] || return 1
  A_DOC_TYPE="$(answer_value DOC_TYPE "$f")"
  [[ -n "$A_DOC_TYPE" ]] || return 1
  bool() { case "$(answer_value "$1" "$f")" in true|True|yes) echo true ;; *) echo "${2:-false}" ;; esac; }
  A_PROPOSAL=$(bool INCLUDE_PROPOSAL); A_REFS=$(bool INCLUDE_REFERENCES)
  A_SENSITIVE=$(bool INCLUDE_SENSITIVE_CONTENT); A_WB=$(bool INCLUDE_WORLDBUILDING)
  A_CONLANG=$(bool INCLUDE_CONLANG); A_DRIVE=$(bool INCLUDE_DRIVE_SYNC)
  v="$(answer_value SEED_EXAMPLES "$f")"
  case "$v" in false|False|no) A_SEED=false ;; *) A_SEED=true ;; esac
  A_FAMILIES=""
  if [[ "$A_DOC_TYPE" == business ]]; then
    A_FAMILIES="$(answer_list BUSINESS_FAMILIES "$f" | tr '\n' ' ')"
    A_FAMILIES="${A_FAMILIES% }"
    [[ -n "$A_FAMILIES" ]] || A_FAMILIES="$SA_FAMILIES_DEFAULT"
  fi
  return 0
}

content_layer() { [[ "$A_DOC_TYPE" == business ]] && echo library || echo manuscript; }

gate_true() { # $1 = gate in the catalogue vocabulary
  local atom IFS='&'
  for atom in $1; do
    case "$atom" in
      always|optional) ;;
      theology|fiction|business) [[ "$A_DOC_TYPE" == "$atom" ]] || return 1 ;;
      books)     [[ "$A_DOC_TYPE" != business ]] || return 1 ;;
      wb)        [[ "$A_DOC_TYPE" == fiction && "$A_WB" == true ]] || return 1 ;;
      conlang)   [[ "$A_DOC_TYPE" == fiction && "$A_CONLANG" == true ]] || return 1 ;;
      refs)      [[ "$A_REFS" == true ]] || return 1 ;;
      proposal)  [[ "$A_DOC_TYPE" != business && "$A_PROPOSAL" == true ]] || return 1 ;;
      sensitive) [[ "$A_DOC_TYPE" != business && "$A_SENSITIVE" == true ]] || return 1 ;;
      drive)     [[ "$A_DOC_TYPE" == business && "$A_DRIVE" == true ]] || return 1 ;;
      fam-*)     [[ "$A_DOC_TYPE" == business && " $A_FAMILIES " == *" ${atom#fam-} "* ]] || return 1 ;;
      seed)      [[ "$A_SEED" == true ]] || return 1 ;;
      *) return 1 ;;
    esac
  done
  return 0
}

# ── Files ────────────────────────────────────────────────────────────────────

# Every file under DIR, relative to it, NUL-separated: git-tracked plus untracked-unignored
# when DIR is inside a work tree (the file just written is the one that most needs checking),
# a plain walk otherwise. .git is never listed.
list_files0() { # $1 = dir
  local dir="$1" top rel
  if top="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)" && [[ "$(cd "$dir" && pwd -P)" != "$(cd "$top" && pwd -P)"/.git* ]]; then
    { git -C "$dir" ls-files -z --full-name -- . ; git -C "$dir" ls-files -z --others --exclude-standard --full-name -- . ; } \
      | { rel="$(cd "$dir" && pwd -P)"; rel="${rel#"$(cd "$top" && pwd -P)"}"; rel="${rel#/}"
          while IFS= read -r -d '' f; do
            [[ -n "$rel" ]] && f="${f#"$rel"/}"
            [[ -e "$dir/$f" ]] && printf '%s\0' "$f"
          done; } | sort -zu
  else
    (cd "$dir" && find . -name .git -prune -o -type f -print0 | sed -z 's#^\./##' | sort -z)
  fi
}

# ── Rendering ────────────────────────────────────────────────────────────────

SA_COPIER=()
copier_init() {
  if [[ -n "${COPIER_CMD:-}" ]]; then
    read -r -a SA_COPIER <<< "$COPIER_CMD"
  elif command -v uvx >/dev/null 2>&1; then
    SA_COPIER=(uvx copier)
  elif command -v copier >/dev/null 2>&1; then
    SA_COPIER=(copier)
  else
    die "neither uvx nor copier is on PATH — nothing can render (install uv, or set COPIER_CMD)"
  fi
}

sa_git() { # $1 = dir, then git arguments — with an identity, so CI needs no global config
  local d="$1"; shift
  git -C "$d" -c user.name='syntek-author audit' -c user.email='audit@example.com' \
    -c commit.gpgsign=false -c init.defaultBranch=main "$@"
}

# Copy a working tree (uncommitted work included, .gitignore honoured as a commit would) to
# DEST and commit it, so `--vcs-ref=HEAD` renders exactly what is on disk (SB rule 17).
sa_snapshot() { # $1 = source repo, $2 = dest
  command -v rsync >/dev/null 2>&1 || die "rsync is not installed"
  rm -rf "$2"; mkdir -p "$2"
  rsync -a --exclude '.git' "$1/" "$2/" || return 1
  sa_git "$2" init -q && sa_git "$2" add -A && sa_git "$2" commit -q -m 'audit snapshot' || return 1
}

# The answers every render passes: the four questions with no default, and DOC_TYPE.
SA_RENDER_NAME="Probe Project"
SA_RENDER_DESCRIPTION="A probe project rendered by the audit suite to prove the template generates end to end."
SA_RENDER_AUTHOR="Ada Example"
SA_RENDER_DATE="01/01/2027"

sa_render() { # $1 = template, $2 = dest, $3 = DOC_TYPE, then extra copier arguments
  local src="$1" dest="$2" doc="$3"; shift 3
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD \
    --data "PROJECT_NAME=$SA_RENDER_NAME" \
    --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" \
    --data "DATE=$SA_RENDER_DATE" \
    --data "DOC_TYPE=$doc" \
    "$@" "$src" "$dest" </dev/null
}

sa_update() { # $1 = project dir, then extra copier arguments
  local proj="$1"; shift
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  (cd "$proj" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD \
     --answers-file "$SA_ANSWERS_FILE" "$@" </dev/null)
}

# ── The fixture template ─────────────────────────────────────────────────────
#
# A minimal template with the real repository's shape: the house delimiters, the named answers
# file, the D17 seeds, the copy-only examples, one variant gate, and the D35 guard — the
# previous answers read through _external_data, DOC_TYPE's validator and the option-off
# message — so every integration self-test also proves it tolerates the MissingFileWarning
# a fresh copy prints. The integration tests'
# self-tests run their whole flow against it, so the harness is proven independently of the
# real template's state — which, mid-build, may not render at all.

sa_fixture_template() { # $1 = dest (created, git-initialised and committed)
  local t="$1" d
  rm -rf "$t"; mkdir -p "$t/template"
  cat > "$t/copier.yml" <<'EOF'
_min_copier_version: "9.6.0"
_subdirectory: template
_answers_file: .copier-answers.syntek-author.yml
_external_data:
  prev: .copier-answers.syntek-author.yml
_message_before_update: |
  Before you answer: turning an option off deletes every file it generated, seeds included.
    INCLUDE_PROPOSAL=false
    INCLUDE_WORLDBUILDING=false
    INCLUDE_CONLANG=false
    INCLUDE_REFERENCES=false
    INCLUDE_SENSITIVE_CONTENT=false
    INCLUDE_DRIVE_SYNC=false
    BUSINESS_FAMILIES, a family unticked
_templates_suffix: ""
_envops:
  variable_start_string: "<%"
  variable_end_string: "%>"
  block_start_string: "<:"
  block_end_string: ":>"
  comment_start_string: "<~"
  comment_end_string: "~>"
  keep_trailing_newline: true
_exclude:
  - .git
  - "<: if not (DOC_TYPE != 'business') :>/manuscript<: endif :>"
  - "<: if not (DOC_TYPE == 'business') :>/library<: endif :>"
  - "<: if not (DOC_TYPE == 'theology') :>/planning/src/arguments<: endif :>"
  - "<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/manuscript/src/01-example-chapter<: endif :>"
  - "<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/planning/src/units/01-example-chapter.md<: endif :>"
  - "<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/planning/src/arguments/01-example-chapter.md<: endif :>"
  - "<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/library/src/business/drafts/example-proposal<: endif :>"
  - "<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/planning/src/units/example-proposal.md<: endif :>"
_skip_if_exists:
  - /README.md
  - /CONTEXT.md
  - /.gitignore
  - /.mcp.json
  - /.claude/CLAUDE.md
  - /.claude/CONTEXT.md
  - /.claude/MEMORY.md
  - /.claude/settings.json
  - /.claude/skills/CONTEXT.md
  - /.claude/skills/CLAUDE.md
  - /.claude/hooks/CONTEXT.md
  - /.claude/hooks/CLAUDE.md
  - /standards/style/style-sheet.md
  - /standards/style/voice-notes.md
  - /standards/style/terminology.md
PROJECT_NAME:
  type: str
PROJECT_DESCRIPTION:
  type: str
AUTHOR_NAME:
  type: str
DATE:
  type: str
DOC_TYPE:
  type: str
  choices: [theology, fiction, business]
  validator: "<: if (_external_data.prev.DOC_TYPE | default(DOC_TYPE, true)) != DOC_TYPE :>DOC_TYPE cannot change on update.<: endif :>"
SEED_EXAMPLES:
  type: bool
  default: true
EOF
  cd "$t/template" || return 1
  mkdir -p .claude/skills/run-workflow .claude/skills/grilling .claude/hooks .claude/rules/syntek-author standards/style \
    manuscript/src/01-example-chapter library/src/business/drafts/example-proposal \
    planning/src/units planning/src/arguments
  printf '<%% _copier_answers|to_nice_yaml -%%>\n' > "$SA_ANSWERS_FILE"
  printf '# <%%PROJECT_NAME%%>\n\nA fixture project.\n' > README.md
  printf '# CONTEXT.md — <%%PROJECT_NAME%%>\n' > CONTEXT.md
  printf 'build/\n' > .gitignore
  printf '{"mcpServers": {}}\n' > .mcp.json
  printf '# CLAUDE.md — <%%PROJECT_NAME%%>\n\n## 3. Project-specific rules\n' > .claude/CLAUDE.md
  for d in .claude .claude/skills .claude/hooks manuscript/src library/src planning/src/units; do
    printf '# CONTEXT.md — %s/\n' "$d" > "$d/CONTEXT.md"
  done
  for d in .claude/skills .claude/hooks manuscript/src library/src planning/src/units; do
    printf '@./CONTEXT.md\n\n# CLAUDE.md — %s/\n' "$d" > "$d/CLAUDE.md"
  done
  printf '# MEMORY.md — <%%PROJECT_SLUG%%>\n\n## Facts\n\n_No entries yet._\n' > .claude/MEMORY.md
  printf '{"model": "opus"}\n' > .claude/settings.json
  printf '# 01 — layout and routing\n\nTemplate-owned; updated by copier update.\n' > .claude/rules/syntek-author/01-layout-and-routing.md
  printf -- '---\nname: run-workflow\ndescription: Route a request to its workflow.\n---\n\n# Skill: run-workflow (<%%PROJECT_NAME%%>)\n' > .claude/skills/run-workflow/SKILL.md
  # A moded skill, so an additive adoption has a mode file to write beside a kept SKILL.md.
  printf -- '---\nname: grilling\ndescription: Question a plan.\n---\n\n# Skill: Grilling (<%%PROJECT_NAME%%>)\n\n> **Mode.** Before step 1, read the doc-type mode file beside this one.\n' > .claude/skills/grilling/SKILL.md
  printf '# Grilling — theology mode\n' > .claude/skills/grilling/THEOLOGY.md
  printf '# Style sheet\n\n## Spelling\n' > standards/style/style-sheet.md
  printf '# Voice notes\n\n## Learned\n' > standards/style/voice-notes.md
  printf '# Terminology\n\n| Term | Meaning | Use | Avoid |\n|---|---|---|---|\n' > standards/style/terminology.md
  printf '# The example chapter\n' > manuscript/src/01-example-chapter/01-example-chapter.md
  printf '\\documentclass{article}\n' > library/src/business/drafts/example-proposal/example-proposal.tex
  printf '# Example chapter brief\n' > planning/src/units/01-example-chapter.md
  printf '# Example proposal brief\n' > planning/src/units/example-proposal.md
  printf '# Example argument map\n' > planning/src/arguments/01-example-chapter.md
  printf 'help:\n\t@echo help\n' > Makefile
  cd - >/dev/null || return 1
  sa_git "$t" init -q && sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture template'
}
