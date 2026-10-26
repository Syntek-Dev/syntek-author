#!/usr/bin/env bash
#
# docs-pairing.sh — Enforce the folder pair, and the shapes of the files that carry routing.
#
#                   Every directory a generated project contains carries CONTEXT.md (what is
#                   here and why) and CLAUDE.md (how to work here). That pair is how Claude
#                   finds its way: the read order walks it top-down, and a folder without it is
#                   a folder nobody was told how to work in. The exceptions are DESIGN.md's and
#                   only those (.claude/rules/syntek-author/01-layout-and-routing.md): build/,
#                   .git/, .claude/rules/ (a CONTEXT.md there would LOAD AS A RULE), the inside
#                   of each skill folder, each drafts/ and each typeset/src/units/.base/
#                   (Pandoc bases, DESIGN.md Section 4.4), which carry only README.md. The
#                   project root carries CONTEXT.md; its CLAUDE.md is .claude/CLAUDE.md. audio/
#                   is generated and git-ignored, so it is exempt like build/. The root .agents/
#                   (DESIGN.md D47) is a client-discovery folder, the same in every template of
#                   the family: it holds the skills link and Antigravity's mcp_config.json and
#                   no pair, and the bridge and the root CONTEXT.md explain it.
#
#                   The same audit holds the shapes the routing depends on: a CLAUDE.md that
#                   does not import its CONTEXT.md loads half a folder; a workflow without its
#                   CHECKLIST.md cannot be ticked; a STEPS.md step without its Skill line routes
#                   nowhere; a guide without its Governing standard section restates a rule it
#                   should cite.
#
#                   Twenty-one checks:
#                     1. A directory has no CONTEXT.md.
#                     2. A directory has no CLAUDE.md (the root excepted).
#                     3. A CLAUDE.md does not open with @./CONTEXT.md.
#                     4. A CLAUDE.md has no `Read order:` line.
#                     5. A CLAUDE.md's H2s are not exactly: Purpose (one line) · How to work
#                        here · Guardrails · Output & naming.
#                     6. A CLAUDE.md carries a directory tree (it belongs in CONTEXT.md).
#                     7. A CONTEXT.md has no `## Directory Tree` with a text fence.
#                     8. A CONTEXT.md carries an operating-rule heading (Rules, Guardrails,
#                        Conventions, Requirements, Constraints, How to work here, Definition of
#                        done) — that belongs in CLAUDE.md.
#                     9. A CONTEXT.md tree row has no annotation.
#                    10. .claude/rules/ carries a CONTEXT.md or CLAUDE.md.
#                    11. A drafts/ folder lacks README.md, or carries a pair.
#                    12. A workflow folder (layer/workflows/NN-name/, or a how-to procedure,
#                        how-to/workflows/<template>/NN-name/, D56) lacks STEPS.md or
#                        CHECKLIST.md. Checks 13–15 and 17 read both kinds.
#                    13. STEPS.md or CHECKLIST.md routing frontmatter is wrong: `workflow:` is
#                        not the folder name, `phase:` is not one of plan · research · produce ·
#                        review · publish · convert · author, `skills:` or `model:` is missing,
#                        or an `agent:` key is present (skills only — DESIGN.md D5).
#                    14. A CHECKLIST.md item does not end ` · _opus_` or ` · _sonnet_`.
#                    15. A STEPS.md step (## N.) does not open with `> **Skill:**`, or does not
#                        carry _Substantive._ or _Mechanical._ (a parenthetical before the full
#                        stop is allowed, and may wrap: _Substantive (the author's call)._).
#                    16. A guide (docs/reference/*.md, or a how-to guide,
#                        how-to/docs/<template>/*.md, D56) breaks AT's format: frontmatter `type:
#                        guide`, `skills:`, `model:`; `**What it is.**`; the H2s How we apply
#                        it here, Who implements it, and Governing standard (last); 54–82 lines.
#                    17. A STEPS.md, CHECKLIST.md, guide or standards file lacks the metadata
#                        header (**Last Updated** … **Version** … **Maintained By** …, then
#                        **Language**: British English (en_GB)).
#                    18. The root .agents/ holds anything but `skills` and `mcp_config.json`: a
#                        pair there, or any other file, is read by every client that scans it,
#                        and breaks the folder's byte-for-byte match with syntek-media's.
#                    19. A chapter of the user guide (every how-to/src/TEMPLATE-GUIDE/**/*.md
#                        but the pair; DESIGN.md Section 6, D56) breaks the chapter format, the
#                        first problem of: it opens with frontmatter; its first line is not
#                        '# Title — gloss'; it carries a **Last Updated** header; its lede, the
#                        lines between the title and the first H2, is not one to three
#                        sentences, one a line; it has fewer than 2 or more than 8 H2s before
#                        '## Where the rules live', which is not the second-to-last H2, or
#                        '## Next' is not the last; its name is neither NN-kebab-title.md
#                        inside a template's folder nor kebab-title.md directly in
#                        TEMPLATE-GUIDE/.
#                    20. A command fence in any .md under how-to/ (info string bash, sh, shell,
#                        console or none) holds a placeholder: <word>, … or ... ([...]
#                        included). The guide is read by authors who run each fenced command
#                        exactly as written (D56); a text fence holds a tree or a sample, and
#                        is never read.
#                    21. A shown Copier copy, update or recopy command (`uvx … copier copy`, in
#                        any text file of the tree, and, run on the template source, in every
#                        file of the repository outside template/ that Git holds or would add)
#                        runs Copier otherwise than as `uvx --python '>=X.Y' copier`, X.Y being
#                        _common.sh's SA_PYTHON_MIN, quoted (DESIGN.md D3; .claude/CLAUDE.md
#                        Section 9). Left to itself uvx may run Copier on an older Python it
#                        already has, where the update script refuses to run, so the update
#                        prints no report, refreshes nothing and restores no guide file; and
#                        the shell reads an unquoted > as a redirection, writing a file named
#                        '=X.Y'. A script that prints the command through a placeholder
#                        (--python %s) passes where the same line holds the quoted '>=X.Y' it
#                        fills in, and one that fills in the quoted '>=%s' passes in a file
#                        that sets PYTHON_MIN = (X, Y), which fills it in (check 22 holds that
#                        value). Not read: CHANGELOG.md, the record of past releases, and
#                        .github/scripts/, whose audits run Copier on a pinned UV_PYTHON and
#                        show no command. Prose that names uvx without a Copier command after
#                        it, and a command wrapped across two lines, are not read either.
#                    22. The Python minimum (DESIGN.md D18) is set somewhere other than once, or
#                        to a value other than _common.sh's SA_PYTHON_MIN (X.Y): each
#                        .claude/*.py, each .claude/hooks/*.sh that runs python3, each
#                        tooling/*.py and, on the template source, each migrations/*.py sets
#                        `PYTHON_MIN = (X, Y)` exactly once; the Makefile sets
#                        `PYTHON_MIN := X.Y` exactly once; tooling/font.py declares
#                        `# requires-python = ">=X.Y"` once; each shipped Drive workflow sets
#                        `PYTHON_VERSION: 'X.Y'` once; and, on the template source, CI's
#                        workflow sets `UV_PYTHON: &python-min "X.Y"` once. One tool left on
#                        another minimum would accept, or refuse, a Python the rest do not, and
#                        a move to the next minimum would miss it. A file that is absent is not
#                        read.
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   Block delimiters are stripped before a line is read, so a gated tree row in
#                   an index file is judged as the row it renders to; headings inside fenced
#                   code (an entry template quoted in a CLAUDE.md) are not read as headings.
#
#                   What it CANNOT check: whether a paragraph says anything. A script proves a
#                   heading and a tree exist; only a reader can tell whether they orient. Nor
#                   whether a fenced command runs as written: check 20 sees a placeholder, never
#                   a command that needs a value it does not name; check 21 sees the form of a
#                   Copier command, never whether its other flags are right.
#
# SELF-TEST. --self-test builds a conformant tree at runtime — pairs, a skill, the rules folder,
#            a drafts/ folder, a workflow, a guide, a standard, and a how-to tree with its
#            pairs, one chapter, one guide and one procedure, inside a scratch repository whose
#            README.md shows the house form of a Copier command — proves it clean, then applies
#            one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, grep, awk, sed, find; git for check 21's repository files. No network.
#
# Usage: docs-pairing.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]
#        With no tree, checks template/ in the repository.
#
# Exit codes:  0 = every pair present and every routed file in shape
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="docs-pairing.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
docs-pairing.sh — Enforce the folder pair, and the shapes of the files that carry routing

Usage: docs-pairing.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]

  <tree>       A rendered project, or any directory shaped like one
               (default: template/ in the repository)
  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a tree built at runtime
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

TREE=""
DIRS_CHECKED=0
FILES_CHECKED=0
PHASES="plan research produce review publish convert author"
CLAUDE_H2='Purpose (one line)|How to work here|Guardrails|Output & naming'
BANNED='^#{2,3} +(Rules|Guardrails|Conventions|Requirements|Constraints|How to work here|Definition of done)( |$)'

# Read a file with every block delimiter removed, so a gated row reads as the row it renders to.
unblocked() { sed -E 's/<:([^:]|:[^>])*:>//g' "$1"; }
# …and with fenced code removed, so a heading quoted in a sample is not read as one.
unfenced() { unblocked "$1" | awk '/^[[:space:]]*```/ { f = !f; next } !f'; }

frontmatter() { # the lines between the opening --- and the closing --- (empty if none)
  awk 'NR == 1 && $0 != "---" { exit } NR == 1 { next } /^---[[:space:]]*$/ { exit } { print }' "$1"
}
fm_value() { # $1 = key, stdin = frontmatter
  awk -v k="$1" '$0 ~ "^" k ":" { v = $0; sub("^" k ":[ \t]*", "", v); print v; exit }'
}

exempt_dir() { # tree-relative dir; true when it needs no pair
  case "/$1/" in
    */.git/*|*/build/*|*/audio/*|*/__pycache__/*|*/node_modules/*) return 0 ;;
    /.claude/rules/*) return 0 ;;
    /.agents/*) return 0 ;;
    /.claude/skills/*/*) return 0 ;;
    */drafts/*) return 0 ;;
    */.base/*) return 0 ;;
  esac
  return 1
}

is_guide() { # tree-relative path
  local b="${1##*/}"
  # A how-to guide (D56): how-to/docs/<template>/*.md, the pair apart.
  if [[ "$1" == how-to/docs/*/*.md && "$1" != how-to/docs/*/*/* ]]; then
    [[ "$b" == CONTEXT.md || "$b" == CLAUDE.md ]] && return 1
    return 0
  fi
  [[ "$1" == */docs/reference/*.md || "$1" == docs/reference/*.md ]] || return 1
  [[ "$b" == CONTEXT.md || "$b" == CLAUDE.md ]] && return 1
  [[ "$b" =~ ^[A-Z0-9-]+\.md$ ]] && return 1     # SCREAMING-CASE sub-docs behind an index
  [[ "$1" == */docs/reference/*/* ]] && return 1
  return 0
}

has_header() { # file carries both metadata lines
  grep -qE '^\*\*Last Updated\*\*: .+ \*\*Version\*\*: .+ \*\*Maintained By\*\*: .+' "$1" \
    && grep -qE '^\*\*Language\*\*: British English \(en_GB\)' "$1"
}

check_claude() { # $1 = rel
  local f="$TREE/$1" first h2
  [[ "$1" == .claude/CLAUDE.md ]] && return 0
  FILES_CHECKED=$((FILES_CHECKED + 1))
  first="$(unblocked "$f" | grep -m1 '[^[:space:]]' || true)"
  [[ "$first" == '@./CONTEXT.md' ]] || finding "check 3 — $1 does not open with @./CONTEXT.md"
  grep -q '^Read order:' "$f" || finding "check 4 — $1 has no 'Read order:' line"
  h2="$(unfenced "$f" | grep '^## ' | sed 's/^## //; s/[[:space:]]*$//' | paste -sd'|' -)"
  [[ "$h2" == "$CLAUDE_H2" ]] || finding "check 5 — $1 has H2s '${h2:-none}'; expected '$CLAUDE_H2'"
  grep -q '^```text' "$f" && finding "check 6 — $1 carries a directory tree; it belongs in CONTEXT.md"
  return 0
}

check_context() { # $1 = rel
  local f="$TREE/$1" h r
  FILES_CHECKED=$((FILES_CHECKED + 1))
  if ! grep -q '^## Directory Tree' "$f" || ! grep -q '^```text' "$f"; then
    finding "check 7 — $1 has no '## Directory Tree' with a text fence"
  fi
  while IFS= read -r h; do
    finding "check 8 — $1 carries the heading '$h' — an operating rule belongs in CLAUDE.md"
  done < <(unfenced "$f" | grep -E "$BANNED" || true)
  while IFS= read -r r; do
    finding "check 9 — $1 has a tree row '$r' with no annotation"
  done < <(unblocked "$f" | awk '
    /^```text/ { inb = 1; next }
    inb && /^```/ { inb = 0 }
    inb && /^(├|└)── / {
      row = $0; sub(/^(├|└)── /, "", row)
      name = row; sub(/[[:space:]].*$/, "", name)
      rest = substr(row, length(name) + 1); gsub(/[[:space:]]/, "", rest)
      if (rest == "") print name
    }')
}

check_workflow() { # $1 = rel dir of a workflow folder
  local d="$1" f fm v name="${1##*/}" line
  for f in STEPS.md CHECKLIST.md; do
    if [[ ! -f "$TREE/$d/$f" ]]; then finding "check 12 — $d/ has no $f"; continue; fi
    FILES_CHECKED=$((FILES_CHECKED + 1))
    fm="$(frontmatter "$TREE/$d/$f")"
    if [[ -z "$fm" ]]; then finding "check 13 — $d/$f has no routing frontmatter"; continue; fi
    v="$(fm_value workflow <<< "$fm")"
    [[ "$v" == "$name" ]] || finding "check 13 — $d/$f says workflow: '${v}'; the folder is $name"
    v="$(fm_value phase <<< "$fm")"
    [[ " $PHASES " == *" $v "* ]] || finding "check 13 — $d/$f has phase: '${v}'; expected one of: $PHASES"
    grep -q '^skills:' <<< "$fm" || finding "check 13 — $d/$f routing frontmatter has no skills:"
    grep -q '^model:' <<< "$fm" || finding "check 13 — $d/$f routing frontmatter has no model:"
    grep -q '^agent:' <<< "$fm" && finding "check 13 — $d/$f carries an agent: key — skills only (DESIGN.md D5)"
    has_header "$TREE/$d/$f" || finding "check 17 — $d/$f has no metadata header"
  done
  if [[ -f "$TREE/$d/CHECKLIST.md" ]]; then
    while IFS= read -r line; do
      finding "check 14 — $d/CHECKLIST.md item has no model tag: ${line:0:70}"
    done < <(grep -E '^[[:space:]]*- \[[ xX]\] ' "$TREE/$d/CHECKLIST.md" | grep -vE ' · _(opus|sonnet)_[[:space:]]*$' || true)
  fi
  if [[ -f "$TREE/$d/STEPS.md" ]]; then
    while IFS= read -r line; do
      finding "check 15 — $d/STEPS.md $line"
    done < <(awk '
      function close_step() {
        if (step == "") return
        if (!skill) print "step \"" step "\" does not open with > **Skill:**"
        if (!tag) print "step \"" step "\" carries neither _Substantive._ nor _Mechanical._"
      }
      /^## / { close_step(); step = ""; if ($0 ~ /^## [0-9]+\. /) { step = substr($0, 4); skill = 0; tag = 0; first = 1 }; next }
      step != "" && first && /[^[:space:]]/ { first = 0; if ($0 ~ /^> \*\*Skill:\*\*/) skill = 1 }
      step != "" && /(^|[^A-Za-z])_(Substantive|Mechanical)([ ._(]|$)/ { tag = 1 }
      END { close_step() }' < <(unfenced "$TREE/$d/STEPS.md"))
  fi
}

check_guide() { # $1 = rel
  local f="$TREE/$1" fm n h2 last
  FILES_CHECKED=$((FILES_CHECKED + 1))
  fm="$(frontmatter "$f")"
  [[ "$(fm_value type <<< "$fm")" == guide ]] || finding "check 16 — $1 frontmatter does not say type: guide"
  grep -q '^skills:' <<< "$fm" || finding "check 16 — $1 frontmatter has no skills:"
  grep -q '^model:' <<< "$fm" || finding "check 16 — $1 frontmatter has no model:"
  grep -q '^\*\*What it is\.\*\*' "$f" || finding "check 16 — $1 has no '**What it is.**' opening"
  h2="$(unfenced "$f" | grep '^## ' | sed 's/^## //; s/[[:space:]]*$//')"
  grep -qx 'How we apply it here' <<< "$h2" || finding "check 16 — $1 has no '## How we apply it here'"
  grep -qx 'Who implements it' <<< "$h2" || finding "check 16 — $1 has no '## Who implements it'"
  last="$(tail -1 <<< "$h2")"
  [[ "$last" == 'Governing standard' ]] || finding "check 16 — $1 does not end with '## Governing standard' (last H2: '${last}')"
  n="$(wc -l < "$f")"
  [[ "$n" -ge 54 && "$n" -le 82 ]] || finding "check 16 — $1 is $n lines; a guide is 54–82"
  has_header "$f" || finding "check 17 — $1 has no metadata header"
}

# A chapter of the user guide (check 19, D56): the first problem only.
check_chapter() { # $1 = rel
  local f="$TREE/$1" first i w=-1 n rest
  local -a h2=()
  FILES_CHECKED=$((FILES_CHECKED + 1))
  first="$(head -n 1 "$f")"
  if [[ "$first" == '---' ]]; then
    finding "check 19 — $1 opens with frontmatter; a chapter has none (DESIGN.md Section 6)"; return 0
  fi
  if ! grep -qE '^# .+ — .+$' <<< "$first"; then
    finding "check 19 — $1 does not open with '# Title — gloss' (its first line: '${first:0:60}')"; return 0
  fi
  if grep -q '\*\*Last Updated\*\*' "$f"; then
    finding "check 19 — $1 carries a **Last Updated** header; a chapter has none (DESIGN.md Section 6)"; return 0
  fi
  local lede
  # Reads to the end (no early exit), so the pipe never breaks under pipefail.
  lede="$(unfenced "$f" | awk 'NR == 1 { next } /^## / { done = 1 } !done && NF { c++ } END { print c + 0 }')"
  if (( lede < 1 || lede > 3 )); then
    finding "check 19 — $1 has a lede of $lede line(s); a chapter's is one to three sentences, one a line (DESIGN.md Section 6)"; return 0
  fi
  mapfile -t h2 < <(unfenced "$f" | grep '^## ' | sed 's/^## //; s/[[:space:]]*$//')
  n=${#h2[@]}
  for i in "${!h2[@]}"; do [[ "${h2[$i]}" == 'Where the rules live' ]] && { w=$i; break; }; done
  if (( w < 0 )); then
    finding "check 19 — $1 has no '## Where the rules live'"; return 0
  elif (( w < 2 || w > 8 )); then
    finding "check 19 — $1 has $w topic H2s before '## Where the rules live'; a chapter has 2–8"; return 0
  elif (( w != n - 2 )) || [[ "${h2[n-1]}" != Next ]]; then
    finding "check 19 — $1 does not end with '## Where the rules live' and then '## Next' (its last H2s: '${h2[n-2]:-}', '${h2[n-1]}')"; return 0
  fi
  rest="${1#how-to/src/TEMPLATE-GUIDE/}"
  if [[ "$rest" == */* ]]; then
    [[ "$rest" =~ ^[^/]+/[0-9][0-9]-[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] \
      || finding "check 19 — $1 is not named NN-kebab-title.md directly inside a template's folder under how-to/src/TEMPLATE-GUIDE/"
  else
    [[ "$rest" =~ ^[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] \
      || finding "check 19 — $1 is not named kebab-title.md, as a shared chapter directly in how-to/src/TEMPLATE-GUIDE/ is"
  fi
  return 0
}

# The first line of a command fence that holds a placeholder (check 20): "N: line", or nothing.
# A fence opens with three or more backticks or tildes; its info string's first word decides:
# bash, sh, shell, console or none is a command fence, anything else (text above all) is not.
fence_placeholder() { # $1 = file
  awk '
    {
      line = $0
      if (match(line, /^[ ]*(```+|~~~+)/)) {
        mark = substr(line, RSTART, RLENGTH); sub(/^[ ]+/, "", mark)
        info = substr(line, RSTART + RLENGTH); sub(/^[ \t]+/, "", info); sub(/[ \t].*$/, "", info)
        if (!open) {
          open = 1; fc = substr(mark, 1, 1); fl = length(mark)
          cmd = (info == "" || info == "bash" || info == "sh" || info == "shell" || info == "console")
          next
        }
        if (substr(mark, 1, 1) == fc && length(mark) >= fl && info == "") { open = 0; next }
      }
      if (open && cmd && (line ~ /<[A-Za-z][A-Za-z0-9 _-]*>/ || index(line, "…") || index(line, "..."))) {
        print NR ": " line; exit
      }
    }' "$1"
}

# The lines of a file that show a Copier copy, update or recopy command run otherwise than in the
# house form (check 21), one "N: line" each. A command is uvx, its options, then copier (or
# copier@… or copier==…) and one of the three subcommands; in the house form the text from uvx
# to copier is exactly "uvx --python '>=X.Y' ", or "uvx --python %s " on a line that holds the
# quoted '>=X.Y' a printf fills in, or "uvx --python '>=%s' " in a file that sets
# PYTHON_MIN = (X, Y), which fills it in. Prose that names uvx without a Copier command is not
# read.
copier_form() { # $1 = file
  local filled=0
  grep -qE "^[[:space:]]*PYTHON_MIN = \(${SA_PYTHON_MIN%%.*}, ${SA_PYTHON_MIN#*.}\)[[:space:]]*$" "$1" 2>/dev/null && filled=1
  awk -v want="uvx --python '>=$SA_PYTHON_MIN' " -v quoted="'>=$SA_PYTHON_MIN'" -v filled="$filled" '
    BEGIN {
      n = split("--python -p --from --with -w --with-editable --with-requirements --index --index-url --default-index --extra-index-url --python-preference --cache-dir --directory --project --config-file", v, " ")
      for (i = 1; i <= n; i++) takes[v[i]] = 1
    }
    index($0, "uvx") {
      line = $0; rest = line; bad = 0
      while (!bad && (p = index(rest, "uvx")) > 0) {
        pre = (p > 1) ? substr(rest, p - 1, 1) : ""
        after = substr(rest, p + 3); rest = after
        if (pre ~ /[A-Za-z0-9_.-]/ || after !~ /^[ \t]/) continue
        n = split(after, tok, /[ \t]+/); cmd = 0; expect = 0
        for (i = 1; i <= n; i++) {
          t = tok[i]
          if (t == "") continue
          if (expect) { expect = 0; continue }
          if (t ~ /^copier((@|==)[^ \t`"'\'']+)?$/) {
            if (i < n && tok[i + 1] ~ /^(copy|update|recopy)([^A-Za-z0-9_-]|$)/) cmd = 1
            break
          }
          if (t ~ /^-/) { if (index(t, "=") == 0 && (t in takes)) expect = 1; continue }
          break
        }
        if (!cmd) continue
        seg = "uvx" substr(after, 1, index(after, "copier") - 1)
        if (seg == want) continue
        if (seg == "uvx --python %s " && index(line, quoted)) continue
        if (seg == "uvx --python '\''>=%s'\'' " && filled) continue
        bad = 1
      }
      if (bad) { print NR ": " line }
    }' "$1"
}

# Check 21 on the repository's own files, read only on the template source: every file Git holds
# or would add outside template/, but CHANGELOG.md and these audits. NUL-separated, from SA_ROOT.
root_copier_files() {
  local f
  if git -C "$SA_ROOT" rev-parse --show-toplevel >/dev/null 2>&1; then
    { git -C "$SA_ROOT" ls-files -z --cached; git -C "$SA_ROOT" ls-files -z --others --exclude-standard; } | sort -zu
  else
    (cd "$SA_ROOT" && find . \( -name .git -o -name handoffs \) -prune -o -type f -print0 | sed -z 's#^\./##' | sort -z)
  fi | while IFS= read -r -d '' f; do
    case "$f" in template/*|.github/scripts/*|CHANGELOG.md) continue ;; esac
    [[ -f "$SA_ROOT/$f" && ! -L "$SA_ROOT/$f" ]] && grep -qI -e uvx -- "$SA_ROOT/$f" 2>/dev/null && printf '%s\0' "$f"
  done
  return 0
}

copier_form_findings() { # $1 = base folder, $2 = path under it, $3 = how the path is named
  local hit text
  while IFS= read -r hit; do
    text="${hit#*: }"; text="${text#"${text%%[![:space:]]*}"}"
    finding "check 21 — $3:${hit%%: *} shows a Copier command not run as $SA_UVX_COPIER (D3): ${text:0:160}"
  done < <(copier_form "$1/$2")
}

# Check 22: one place sets the Python minimum in a file ($4: py, make, font, drive or ci), once and
# to SA_PYTHON_MIN. $1 = base folder, $2 = path under it, $3 = how the path is named.
python_min_finding() {
  local f="$1/$2" form="$4" maj="${SA_PYTHON_MIN%%.*}" min="${SA_PYTHON_MIN#*.}" esc="${SA_PYTHON_MIN//./\\.}"
  local any want shape n_any n_want
  case "$form" in
    py)    any='^[[:space:]]*PYTHON_MIN[[:space:]]*='; want="^[[:space:]]*PYTHON_MIN = \\($maj, $min\\)[[:space:]]*$"; shape="PYTHON_MIN = ($maj, $min)" ;;
    make)  any='^[[:space:]]*PYTHON_MIN[[:space:]]*[:?+]?='; want="^PYTHON_MIN := ${esc}[[:space:]]*$"; shape="PYTHON_MIN := $SA_PYTHON_MIN" ;;
    font)  any='^#[[:space:]]*requires-python[[:space:]]*='; want="^# requires-python = \">=$esc\"[[:space:]]*$"; shape="# requires-python = \">=$SA_PYTHON_MIN\"" ;;
    drive) any='^[[:space:]]*PYTHON_VERSION:'; want="^[[:space:]]*PYTHON_VERSION: '${esc}'[[:space:]]*$"; shape="PYTHON_VERSION: '$SA_PYTHON_MIN'" ;;
    ci)    any='^[[:space:]]*UV_PYTHON:'; want="^[[:space:]]*UV_PYTHON: &python-min \"$esc\"[[:space:]]*$"; shape="UV_PYTHON: &python-min \"$SA_PYTHON_MIN\"" ;;
  esac
  [[ -f "$f" ]] || return 0
  n_any="$(grep -cE -- "$any" "$f" || true)"; n_want="$(grep -cE -- "$want" "$f" || true)"
  [[ "$n_any" == 1 && "$n_want" == 1 ]] && return 0
  if [[ "$n_any" == 0 ]]; then
    finding "check 22 — $3 sets no Python minimum: it needs $shape, once (DESIGN.md D18)"
  elif [[ "$n_any" != 1 ]]; then
    finding "check 22 — $3 sets the Python minimum $n_any times: once, as $shape (DESIGN.md D18)"
  else
    finding "check 22 — $3 sets a Python minimum other than $SA_PYTHON_MIN: $(grep -m1 -E -- "$any" "$f" | sed 's/^[[:space:]]*//' | cut -c1-80) (want $shape, DESIGN.md D18)"
  fi
}

python_min_findings() {
  local f
  while IFS= read -r -d '' f; do
    f="${f#./}"
    case "$f" in
      .claude/hooks/*.sh) grep -qI -e python3 -- "$TREE/$f" 2>/dev/null || continue ;;
    esac
    python_min_finding "$TREE" "$f" "$f" py
  done < <(cd "$TREE" && find . \( -path './.claude/*.py' -o -path './.claude/hooks/*.sh' -o -path './tooling/*.py' \) \
             ! -path './.claude/*/*/*' ! -path './tooling/*/*' -type f -print0 2>/dev/null | sort -z)
  python_min_finding "$TREE" Makefile Makefile make
  python_min_finding "$TREE" tooling/font.py tooling/font.py font
  for f in .github/workflows/google-drive-push.yml .github/workflows/google-drive-pull.yml; do
    python_min_finding "$TREE" "$f" "$f" drive
  done
  if [[ -d "$SA_ROOT/template" && "$TREE" == "$(cd "$SA_ROOT/template" && pwd)" ]]; then
    while IFS= read -r -d '' f; do
      f="${f#"$SA_ROOT"/}"
      python_min_finding "$SA_ROOT" "$f" "$f (the repository)" py
    done < <(find "$SA_ROOT/migrations" -maxdepth 1 -name '*.py' -type f -print0 2>/dev/null | sort -z)
    python_min_finding "$SA_ROOT" .github/workflows/audit-template.yml ".github/workflows/audit-template.yml (the repository)" ci
  fi
}

run_checks() {
  FINDINGS=()
  DIRS_CHECKED=0; FILES_CHECKED=0
  local d f
  while IFS= read -r -d '' d; do
    d="${d#./}"; [[ "$d" == . ]] && d=""
    if [[ -n "$d" ]] && exempt_dir "$d"; then
      continue
    fi
    DIRS_CHECKED=$((DIRS_CHECKED + 1))
    [[ -f "$TREE/${d:+$d/}CONTEXT.md" ]] || finding "check 1 — ${d:-the root}/ has no CONTEXT.md"
    if [[ -n "$d" && ! -f "$TREE/$d/CLAUDE.md" ]]; then finding "check 2 — $d/ has no CLAUDE.md"; fi
    [[ -f "$TREE/${d:+$d/}CLAUDE.md" && -n "$d" ]] && check_claude "$d/CLAUDE.md"
    [[ -f "$TREE/${d:+$d/}CONTEXT.md" ]] && check_context "${d:+$d/}CONTEXT.md"
    if [[ "$d" =~ ^[^/]+/workflows/[0-9][0-9]-[^/]+$ || "$d" =~ ^how-to/workflows/[^/]+/[0-9][0-9]-[^/]+$ ]]; then check_workflow "$d"; fi
  done < <(cd "$TREE" && find . \( -name .git -o -name build -o -name audio -o -name __pycache__ -o -name node_modules \) -prune -o -type d -print0 | sort -z)

  # ── 10. Nothing in .claude/rules/ that would load as a rule ─────────────────
  if [[ -d "$TREE/.claude/rules" ]]; then
    while IFS= read -r f; do
      finding "check 10 — ${f#./} sits in .claude/rules/, where it would load as a rule"
    done < <(cd "$TREE" && find ./.claude/rules \( -name CONTEXT.md -o -name CLAUDE.md \) | sort)
  fi

  # ── 11. drafts/ carries README.md, never a pair ─────────────────────────────
  while IFS= read -r d; do
    d="${d#./}"
    [[ -f "$TREE/$d/README.md" ]] || finding "check 11 — $d/ has no README.md"
    if [[ -f "$TREE/$d/CONTEXT.md" || -f "$TREE/$d/CLAUDE.md" ]]; then finding "check 11 — $d/ carries a pair; a drafts/ folder carries README.md only"; fi
  done < <(cd "$TREE" && find . -name .git -prune -o -type d -name drafts -print | sort)

  # ── 18. The root .agents/ holds the link and the MCP file only ──────────────
  if [[ -d "$TREE/.agents" && ! -L "$TREE/.agents" ]]; then
    while IFS= read -r f; do
      case "$f" in skills|mcp_config.json) ;; *) finding "check 18 — .agents/$f does not belong in .agents/, which holds only skills and mcp_config.json (no pair)" ;; esac
    done < <(cd "$TREE/.agents" && find . -mindepth 1 -maxdepth 1 -printf '%f\n' | LC_ALL=C sort)
  fi

  # ── 16–17. Guides and standards ─────────────────────────────────────────────
  while IFS= read -r -d '' f; do
    f="${f#./}"
    if is_guide "$f"; then check_guide "$f"; fi
  done < <(cd "$TREE" && find . -name .git -prune -o \( -path '*/docs/reference/*' -o -path './how-to/docs/*' \) -name '*.md' -print0 | sort -z)
  # ── 19–20. The user guide (D56): chapters, and the command fences of every file ──
  if [[ -d "$TREE/how-to" ]]; then
    local hit
    while IFS= read -r -d '' f; do
      f="${f#./}"
      if [[ "$f" == how-to/src/TEMPLATE-GUIDE/* && "${f##*/}" != CONTEXT.md && "${f##*/}" != CLAUDE.md ]]; then
        check_chapter "$f"
      fi
      hit="$(fence_placeholder "$TREE/$f")"
      [[ -z "$hit" ]] || finding "check 20 — $f fences a command holding a placeholder (line ${hit%%: *}: ${hit#*: }) — every fenced command runs exactly as written; name the value in the sentence before it"
    done < <(cd "$TREE" && find ./how-to -name '*.md' -print0 | sort -z)
  fi

  # ── 21. Every shown Copier command in the house form (D3) ───────────────────
  while IFS= read -r -d '' f; do
    f="${f#./}"
    copier_form_findings "$TREE" "$f" "$f"
  done < <(cd "$TREE" && grep -rlIZ --exclude-dir=.git --exclude-dir=build --exclude-dir=node_modules -e uvx . 2>/dev/null | sort -z || true)
  if [[ -d "$SA_ROOT/template" && "$TREE" == "$(cd "$SA_ROOT/template" && pwd)" ]]; then
    while IFS= read -r -d '' f; do
      copier_form_findings "$SA_ROOT" "$f" "$f (the repository)"
    done < <(root_copier_files)
  fi

  # ── 22. One Python minimum, set once in each place (D18) ────────────────────
  python_min_findings

  if [[ -d "$TREE/standards" ]]; then
    while IFS= read -r -d '' f; do
      f="${f#./}"
      case "${f##*/}" in CONTEXT.md|CLAUDE.md|README.md) continue ;; esac
      [[ "$f" == standards/style/samples/* || "$f" == standards/style/ledger/* ]] && continue
      FILES_CHECKED=$((FILES_CHECKED + 1))
      has_header "$TREE/$f" || finding "check 17 — $f has no metadata header"
    done < <(cd "$TREE" && find ./standards -name '*.md' -print0 | sort -z)
  fi
}

# ── Self-test ────────────────────────────────────────────────────────────────

HEADER=$'**Last Updated**: 01/01/2027 **Version**: 0.1.0 **Maintained By**: Ada Example\n**Language**: British English (en_GB)'

write_pair() { # $1 = tree, $2 = rel dir ("" for root: CONTEXT only)
  local t="$1" d="$2" label="${2:-.}"
  mkdir -p "$t/${d:-.}"
  printf '# CONTEXT.md — %s/\n\nWhat this folder holds, and why.\n\n## Directory Tree\n\n```text\n%s/\n├── CONTEXT.md   ← this file\n└── CLAUDE.md    ← operating rules\n```\n\n## Cross-references\n\n- None.\n' \
    "$label" "$label" > "$t/${d:+$d/}CONTEXT.md"
  [[ -z "$d" ]] && return 0
  printf '@./CONTEXT.md\n\n# CLAUDE.md — %s/\n\nRead order: `.claude/CLAUDE.md` → this file.\n\n## Purpose (one line)\n\nOne line.\n\n## How to work here\n\n- **Routing:** none.\n\n## Guardrails\n\n- **Never overwrite.**\n\n## Output & naming\n\n- Kebab-case.\n' \
    "$d" > "$t/$d/CLAUDE.md"
}

write_fixture() { # $1 = tree
  local t="$1" d i wf="manuscript/workflows/01-draft-a-section"
  write_pair "$t" ""
  mkdir -p "$t/.claude/rules/syntek-author" "$t/.claude/skills/flow"
  printf '# CLAUDE.md — Probe\n\nThe project brief.\n' > "$t/.claude/CLAUDE.md"
  printf '# CONTEXT.md — .claude/\n\nOrientation.\n\n## Directory Tree\n\n```text\n.claude/\n└── CLAUDE.md   ← the brief\n```\n' > "$t/.claude/CONTEXT.md"
  printf '# 01 — layout\n' > "$t/.claude/rules/syntek-author/01-layout-and-routing.md"
  write_pair "$t" .claude/rules; rm -f "$t/.claude/rules/CONTEXT.md" "$t/.claude/rules/CLAUDE.md"
  write_pair "$t" .claude/skills
  printf -- '---\nname: flow\n---\n' > "$t/.claude/skills/flow/SKILL.md"
  for d in manuscript manuscript/docs manuscript/docs/reference manuscript/workflows "$wf" manuscript/src manuscript/src/01-the-ford standards standards/method; do
    write_pair "$t" "$d"
  done
  mkdir -p "$t/manuscript/src/01-the-ford/drafts"
  printf '# Work in progress\n' > "$t/manuscript/src/01-the-ford/drafts/README.md"
  printf '# The ford\n' > "$t/manuscript/src/01-the-ford/01-the-ford.md"
  mkdir -p "$t/.agents"; ln -s ../.claude/skills "$t/.agents/skills"; printf '{\n  "mcpServers": {}\n}\n' > "$t/.agents/mcp_config.json"
  printf '# method.md — how arguments are built\n\n%s\n\n## 1. A rule\n' "$HEADER" > "$t/standards/method/method.md"
  for f in STEPS CHECKLIST; do
    printf -- '---\nworkflow: 01-draft-a-section\nphase: produce\nskills: [draft-section]\nmodel: opus\n---\n\n# %s.md — draft a section\n\n%s\n\n' "$f" "$HEADER" > "$t/$wf/$f.md"
  done
  printf '## 1. Fix the brief\n\n> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`\n\nConfirm the brief. _Substantive._\n' >> "$t/$wf/STEPS.md"
  printf '## Pre-Conditions\n\n- [ ] Read the brief. · _sonnet_\n\n## Execution Checklist\n\n- [ ] Drafted. · _opus_\n\n## Done When\n\n- [ ] **One draft exists.** · _opus_\n' >> "$t/$wf/CHECKLIST.md"
  {
    printf -- '---\ntype: guide\nskills: [draft-section]\nmodel: opus\n---\n\n# Section anatomy — what a section is\n\n%s\n\n**What it is.** A section is one small passage.\n\n## The parts\n\n' "$HEADER"
    for i in $(seq 1 34); do printf 'Line %d of the topic.\n' "$i"; done
    printf '\n## How we apply it here\n\nOne section at a time.\n\n## Who implements it\n\nThe draft-section skill.\n\n## Governing standard\n\nThe standard owns the rule; this guide owns the explanation.\n'
  } > "$t/manuscript/docs/reference/section-anatomy.md"
  write_howto "$t"
  # Check 22: a project script and the Makefile, each setting the one Python minimum once.
  printf 'import sys\n\nPYTHON_MIN = (%s, %s)\n' "${SA_PYTHON_MIN%%.*}" "${SA_PYTHON_MIN#*.}" > "$t/.claude/syntek-author-probe.py"
  printf 'PY := python3\nPYTHON_MIN := %s\n' "$SA_PYTHON_MIN" > "$t/Makefile"
}

# The user guide (D56): its pairs, one chapter, one guide and one procedure, with a text tree
# holding the <template> placeholder, which no check reads as a command.
write_howto() { # $1 = tree
  local t="$1" d f i hp="how-to/workflows/syntek-author/01-update-the-template"
  for d in how-to how-to/docs how-to/docs/syntek-author how-to/src how-to/src/TEMPLATE-GUIDE how-to/src/TEMPLATE-GUIDE/syntek-author \
           how-to/workflows how-to/workflows/syntek-author "$hp"; do
    write_pair "$t" "$d"
  done
  printf '# CONTEXT.md — how-to/src/TEMPLATE-GUIDE/\n\nThe chapters.\n\n## Directory Tree\n\n```text\nhow-to/src/TEMPLATE-GUIDE/\n├── CONTEXT.md   ← this file\n├── CLAUDE.md    ← operating rules\n└── <template>/  ← each template'"'"'s own chapters\n```\n' \
    > "$t/how-to/src/TEMPLATE-GUIDE/CONTEXT.md"
  {
    printf '# Overview — what a project is\n\nA lede of one sentence.\n\n## The layers\n\nOne sentence.\n\n'
    printf '```bash\nmake lint SCOPE=how-to/src STRICT=1\n```\n\n## The settings\n\nOne sentence.\n\n'
    printf '## Where the rules live\n\n- The rules: `.claude/rules/`.\n\n## Next\n\n- Start → `how-to/src/TEMPLATE-GUIDE/syntek-author/02-next.md`\n'
  } > "$t/how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md"
  {
    printf -- '---\ntype: guide\nskills: []\nmodel: opus\n---\n\n# Updating the template — taking its improvements\n\n%s\n\n**What it is.** An update.\n\n## Before you start\n\n' "$HEADER"
    for i in $(seq 1 34); do printf 'Line %d of the topic.\n' "$i"; done
    printf '\n## How we apply it here\n\nOne update at a time.\n\n## Who implements it\n\nProcedure 01.\n\n## Governing standard\n\nThe rules own the rule; this guide owns the explanation.\n'
  } > "$t/how-to/docs/syntek-author/updating-the-template.md"
  for f in STEPS CHECKLIST; do
    printf -- '---\nworkflow: 01-update-the-template\nphase: review\nskills: []\nmodel: opus\n---\n\n# %s.md — update the template\n\n%s\n\n' "$f" "$HEADER" > "$t/$hp/$f.md"
  done
  printf '## 1. Check the tree\n\n> **Skill:** none · **Guide:** `how-to/docs/syntek-author/updating-the-template.md`\n\nRun:\n\n```bash\ngit status --short\n```\n\n_Mechanical._\n' >> "$t/$hp/STEPS.md"
  # A shown update command in the house form (check 21), housekeeping off, as the procedures give it.
  printf '\n## 2. Update\n\n> **Skill:** none · **Guide:** `how-to/docs/syntek-author/updating-the-template.md`\n\n```bash\nGIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \\\n  %s update --trust -a .copier-answers.syntek-author.yml\n```\n\n_Mechanical._\n' "$SA_UVX_COPIER" >> "$t/$hp/STEPS.md"
  printf '## Pre-Conditions\n\n- [ ] The tree is clean. · _sonnet_\n\n## Execution Checklist\n\n- [ ] Updated. · _opus_\n\n## Done When\n\n- [ ] **The report is read.** · _opus_\n' >> "$t/$hp/CHECKLIST.md"
}

self_test() {
  local tmp t wf="manuscript/workflows/01-draft-a-section" g="manuscript/docs/reference/section-anatomy.md" real_root="$SA_ROOT"
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'; SA_ROOT='$real_root'" RETURN
  # The tree is a scratch repository's template/, so check 21 also reads the repository's own
  # files: a README.md showing the house form, and a CHANGELOG.md, which it never reads.
  SA_ROOT="$tmp/repo"; t="$SA_ROOT/template"; TREE="$t"
  write_fixture "$t"
  sa_git "$SA_ROOT" init -q
  printf '# Probe template\n\n```bash\n%s copy --trust gh:Example/probe my-book\n```\n' "$SA_UVX_COPIER" > "$SA_ROOT/README.md"
  printf '# Changelog\n\n- v0.1.0: run `uvx copier update --trust -a .copier-answers.syntek-author.yml`.\n' > "$SA_ROOT/CHANGELOG.md"
  st_baseline "a conformant tree"

  mkdir -p "$t/typeset/src/units/.base"; write_pair "$t" typeset; write_pair "$t" typeset/src; write_pair "$t" typeset/src/units
  printf '# Pandoc bases\n' > "$t/typeset/src/units/.base/README.md"
  probe_clean "a typeset/src/units/.base/ with only README.md is a declared exception"; rm -rf "$t/typeset"

  mv "$t/manuscript/src/CONTEXT.md" "$tmp/h"; probe "check 1 fires on a folder with no CONTEXT.md" "check 1 — manuscript/src/"; mv "$tmp/h" "$t/manuscript/src/CONTEXT.md"
  mv "$t/manuscript/src/CLAUDE.md" "$tmp/h";  probe "check 2 fires on a folder with no CLAUDE.md" "check 2 — manuscript/src/"; mv "$tmp/h" "$t/manuscript/src/CLAUDE.md"
  cp "$t/standards/CLAUDE.md" "$tmp/h"
  sed -i '1s/.*/# no import/' "$t/standards/CLAUDE.md";        probe "check 3 fires when the import is lost" "check 3"; cp "$tmp/h" "$t/standards/CLAUDE.md"
  sed -i '/^Read order:/d' "$t/standards/CLAUDE.md";           probe "check 4 fires when the read order is lost" "check 4"; cp "$tmp/h" "$t/standards/CLAUDE.md"
  sed -i 's/^## Guardrails/## Rules/' "$t/standards/CLAUDE.md"; probe "check 5 fires on a renamed H2" "check 5"; cp "$tmp/h" "$t/standards/CLAUDE.md"
  printf '```text\nstandards/\n```\n' >> "$t/standards/CLAUDE.md"; probe "check 6 fires on a tree in CLAUDE.md" "check 6"; cp "$tmp/h" "$t/standards/CLAUDE.md"
  cp "$t/standards/CONTEXT.md" "$tmp/h"
  sed -i 's/^## Directory Tree/## Layout/' "$t/standards/CONTEXT.md"; probe "check 7 fires when the tree heading is lost" "check 7"; cp "$tmp/h" "$t/standards/CONTEXT.md"
  printf '\n## Conventions\n\n- A rule.\n' >> "$t/standards/CONTEXT.md"; probe "check 8 fires on a rule heading in CONTEXT.md" "check 8"; cp "$tmp/h" "$t/standards/CONTEXT.md"
  sed -i 's/^└── CLAUDE.md    ← operating rules/└── CLAUDE.md/' "$t/standards/CONTEXT.md"; probe "check 9 fires on a bare tree row" "check 9"; cp "$tmp/h" "$t/standards/CONTEXT.md"
  printf '# x\n' > "$t/.claude/rules/CONTEXT.md";              probe "check 10 fires on a pair in .claude/rules/" "check 10"; rm -f "$t/.claude/rules/CONTEXT.md"
  mv "$t/manuscript/src/01-the-ford/drafts/README.md" "$tmp/h"; probe "check 11 fires on a drafts/ with no README.md" "check 11"; mv "$tmp/h" "$t/manuscript/src/01-the-ford/drafts/README.md"
  mv "$t/$wf/STEPS.md" "$tmp/h";                               probe "check 12 fires on a workflow with no STEPS.md" "check 12"; mv "$tmp/h" "$t/$wf/STEPS.md"
  cp "$t/$wf/CHECKLIST.md" "$tmp/h"
  sed -i 's/^workflow: .*/workflow: 01-wrong-name/' "$t/$wf/CHECKLIST.md"; probe "check 13 fires on a workflow key that is not the folder" "check 13"; cp "$tmp/h" "$t/$wf/CHECKLIST.md"
  sed -i 's/^model: opus/model: opus\nagent: writer/' "$t/$wf/CHECKLIST.md"; probe "check 13 fires on an agent key" "check 13 — $wf/CHECKLIST.md carries an agent"; cp "$tmp/h" "$t/$wf/CHECKLIST.md"
  sed -i 's/Drafted\. · _opus_/Drafted./' "$t/$wf/CHECKLIST.md"; probe "check 14 fires on an untagged item" "check 14"; cp "$tmp/h" "$t/$wf/CHECKLIST.md"
  cp "$t/$wf/STEPS.md" "$tmp/h"
  sed -i '/^> \*\*Skill:\*\*/d' "$t/$wf/STEPS.md";            probe "check 15 fires on a step with no Skill line" "check 15"; cp "$tmp/h" "$t/$wf/STEPS.md"
  cp "$t/$g" "$tmp/h"
  sed -i 's/^## Who implements it/## Who does it/' "$t/$g";   probe "check 16 fires on a guide missing a section" "check 16"; cp "$tmp/h" "$t/$g"
  sed -i '/^Line [0-9]* of the topic\./d' "$t/$g";            probe "check 16 fires on a guide that is too short" "check 16 — $g is"; cp "$tmp/h" "$t/$g"
  sed -i '/^\*\*Language\*\*/d' "$t/standards/method/method.md"; probe "check 17 fires on a standard with no header" "check 17"
  printf '%s\n' "$HEADER" >> "$t/standards/method/method.md"
  printf '# x\n' > "$t/.agents/CONTEXT.md";                     probe "check 18 fires on a pair file in .agents/" "check 18 — .agents/CONTEXT.md"; rm -f "$t/.agents/CONTEXT.md"

  # The user guide (D56).
  local ch="how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md" hp="how-to/workflows/syntek-author/01-update-the-template"
  local hg="how-to/docs/syntek-author/updating-the-template.md"
  mv "$t/$hp/CHECKLIST.md" "$tmp/h";                           probe "check 12 fires on a how-to procedure with no CHECKLIST.md" "check 12 — $hp/ has no CHECKLIST.md"; mv "$tmp/h" "$t/$hp/CHECKLIST.md"
  cp "$t/$hp/STEPS.md" "$tmp/h"
  sed -i 's/^phase: review$/phase: maintain/' "$t/$hp/STEPS.md"; probe "check 13 fires on a how-to procedure's phase" "check 13 — $hp/STEPS.md has phase: 'maintain'"; cp "$tmp/h" "$t/$hp/STEPS.md"
  cp "$t/$hg" "$tmp/h"
  sed -i 's/^## Governing standard$/## Governed by/' "$t/$hg";  probe "check 16 fires on a how-to guide missing a section" "check 16 — $hg does not end with"; cp "$tmp/h" "$t/$hg"
  cp "$t/$ch" "$tmp/h"
  { printf -- '---\ntype: chapter\n---\n'; cat "$tmp/h"; } > "$t/$ch"; probe "check 19 fires on a chapter with frontmatter" "check 19 — $ch opens with frontmatter"; cp "$tmp/h" "$t/$ch"
  sed -i '1s/ — what a project is$//' "$t/$ch";                probe "check 19 fires on a chapter title without its gloss" "check 19 — $ch does not open with"; cp "$tmp/h" "$t/$ch"
  sed -i 's/^## Next$/## Onward/; s/^## The layers$/## Next/' "$t/$ch"; probe "check 19 fires when ## Next is not last" "check 19 — $ch does not end with '## Where the rules live' and then '## Next'"; cp "$tmp/h" "$t/$ch"
  sed -i 's/^## The settings$/Settings./' "$t/$ch";             probe "check 19 fires on a chapter with one topic H2" "check 19 — $ch has 1 topic H2s"; cp "$tmp/h" "$t/$ch"
  sed -i '3a Two.\nThree.\nFour.' "$t/$ch";                   probe "check 19 fires on a lede of four sentences" "check 19 — $ch has a lede of 4 line(s)"; cp "$tmp/h" "$t/$ch"
  mv "$t/$ch" "$t/how-to/src/TEMPLATE-GUIDE/syntek-author/Overview.md"
  probe "check 19 fires on a chapter named otherwise than NN-kebab-title.md" "check 19 — how-to/src/TEMPLATE-GUIDE/syntek-author/Overview.md is not named"
  mv "$t/how-to/src/TEMPLATE-GUIDE/syntek-author/Overview.md" "$t/$ch"
  printf '\n```bash\nmake pdf FILE=<file>\n```\n' >> "$t/$ch";      probe "check 20 fires on a placeholder in a command fence" "check 20 — $ch fences a command holding a placeholder"; cp "$tmp/h" "$t/$ch"
  cp "$t/$hp/STEPS.md" "$tmp/h2"
  printf '\n```\n%s update …\n```\n' "$SA_UVX_COPIER" >> "$t/$hp/STEPS.md"; probe "check 20 reads a fence with no info string in a procedure" "check 20 — $hp/STEPS.md fences a command"
  cp "$tmp/h2" "$t/$hp/STEPS.md"
  # Check 21: a shown Copier command run otherwise than as uvx --python '>=X.Y' copier.
  printf '\nOr run `uvx copier update --trust -a .copier-answers.syntek-author.yml` by hand.\n' >> "$t/$hp/STEPS.md"
  probe "check 21 fires on a bare uvx copier update in a procedure" "check 21 — $hp/STEPS.md:"; cp "$tmp/h2" "$t/$hp/STEPS.md"
  sed -i "s/copier update --trust/copier recopy --trust/; s/--python '>=$SA_PYTHON_MIN'/--python \">=$SA_PYTHON_MIN\"/" "$t/$hp/STEPS.md"
  probe "check 21 fires on the minimum in double quotes" "check 21 — $hp/STEPS.md:"; cp "$tmp/h2" "$t/$hp/STEPS.md"
  cp "$SA_ROOT/README.md" "$tmp/h3"
  sed -i "s/--python '>=$SA_PYTHON_MIN'/--python >=$SA_PYTHON_MIN/" "$SA_ROOT/README.md"
  probe "check 21 fires on an unquoted minimum in the repository's own README.md" "check 21 — README.md (the repository):4 shows a Copier command"
  cp "$tmp/h3" "$SA_ROOT/README.md"; sed -i "s/--python '>=$SA_PYTHON_MIN'/--python '>=3.0'/" "$SA_ROOT/README.md"
  probe "check 21 fires on another minimum" "check 21 — README.md (the repository):4"; cp "$tmp/h3" "$SA_ROOT/README.md"
  printf 'uvx copier@9.18.0 copy --trust gh:Example/probe .\n' > "$t/how-to/notes.txt"
  probe "check 21 reads every text file of the tree, a pinned Copier too" "check 21 — how-to/notes.txt:1"; rm -f "$t/how-to/notes.txt"
  mkdir -p "$SA_ROOT/migrations"
  printf '%s\n' '#!/bin/sh' "printf '  uvx --python %s copier update --trust -a x\\n' \"'>=$SA_PYTHON_MIN'\"" > "$SA_ROOT/migrations/v9.9.9-probe.sh"
  printf '%s\n' 'Run it again with `uvx --python '"'>=$SA_PYTHON_MIN'"'` in place of `uvx`; uvx may choose a Python.' >> "$SA_ROOT/README.md"
  probe_clean "a printf filling in the quoted minimum, prose naming uvx, and CHANGELOG.md pass check 21"
  sed -i "s/\"'>=$SA_PYTHON_MIN'\"/\"'>=3.0'\"/" "$SA_ROOT/migrations/v9.9.9-probe.sh"
  probe "check 21 fires on a printf that fills in another minimum" "check 21 — migrations/v9.9.9-probe.sh (the repository):2"
  rm -rf "$SA_ROOT/migrations"; cp "$tmp/h3" "$SA_ROOT/README.md"
  # Check 22: the Python minimum set once, to SA_PYTHON_MIN, in each place.
  cp "$t/.claude/syntek-author-probe.py" "$tmp/h4"
  sed -i "s/^PYTHON_MIN = .*/PYTHON_MIN = (3, 0)/" "$t/.claude/syntek-author-probe.py"
  probe "check 22 fires on a script set to another minimum" "check 22 — .claude/syntek-author-probe.py sets a Python minimum other than"
  cp "$tmp/h4" "$t/.claude/syntek-author-probe.py"; printf 'PY := python3\n' > "$t/Makefile"
  probe "check 22 fires on a Makefile that sets no minimum" "check 22 — Makefile sets no Python minimum"
  printf 'PY := python3\nPYTHON_MIN := %s\n' "$SA_PYTHON_MIN" > "$t/Makefile"
  mkdir -p "$SA_ROOT/migrations"; printf 'PYTHON_MIN = (%s, %s)\nPYTHON_MIN = (3, 0)\n' "${SA_PYTHON_MIN%%.*}" "${SA_PYTHON_MIN#*.}" > "$SA_ROOT/migrations/probe.py"
  probe "check 22 fires on a repository script that sets it twice" "check 22 — migrations/probe.py (the repository) sets the Python minimum 2 times"
  mkdir -p "$SA_ROOT/migrations"
  printf '%s\n' "PYTHON_MIN = (${SA_PYTHON_MIN%%.*}, ${SA_PYTHON_MIN#*.})" "rerun = \"uvx --python '>=%s' copier update\" % '%d.%d' % PYTHON_MIN" > "$SA_ROOT/migrations/probe.py"
  probe_clean "a script filling in the quoted '>=%s' from the PYTHON_MIN it sets passes checks 21 and 22"
  sed '1d' "$SA_ROOT/migrations/probe.py" > "$SA_ROOT/migrations/probe.sh"; rm -f "$SA_ROOT/migrations/probe.py"
  probe "check 21 fires on '>=%s' in a file that sets no PYTHON_MIN" "check 21 — migrations/probe.sh (the repository):1 shows a Copier command"
  rm -rf "$SA_ROOT/migrations"
  printf '\n```bash\ngit log ...\n```\n' >> "$t/$ch";            probe "check 20 fires on ASCII ... in a command fence" "check 20 — $ch fences a command holding a placeholder (line"; cp "$tmp/h" "$t/$ch"
  printf '\n```text\nhow-to/workflows/<template>/  ← a sample, never run\n```\n' >> "$t/$ch"; probe_clean "a text fence holding a placeholder is never read as a command"; cp "$tmp/h" "$t/$ch"
  st_finish "a paired, well-shaped tree from a broken one"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  [[ -d "$SA_ROOT/template" ]] || die "no template/ directory at $SA_ROOT, and no tree given"
  TARGETS=("$SA_ROOT/template")
fi

bold "▸ $SCRIPT_NAME"
STATUS=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREE="$(cd "$target" && pwd)"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $TREE — $DIRS_CHECKED director(ies), $FILES_CHECKED routed file(s), all in shape"
  else
    bold "✗ $TREE — ${#FINDINGS[@]} finding(s) across $DIRS_CHECKED director(ies):"
    print_findings
    STATUS=1
  fi
done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ Every folder carries its pair; every routed file is in its house shape."
  exit 0
fi
log "  House shapes: cross-check Section 1.1 (a)–(e), DESIGN.md Section 4.4 for guides."
exit 1
