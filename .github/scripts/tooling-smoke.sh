#!/usr/bin/env bash
#
# tooling-smoke.sh — Run the generated Makefile's targets in every render, and require them to work.
#
#                    The skills route to `make`: `build` runs `make pdf`, `promote-section`
#                    reads `make flags`, `learn-voice` and the disclosure table read `make
#                    provenance`, the conlang skills run `make lexicon`. The Makefile is a spine
#                    file — conditional on the variant — and its tooling is Python run from
#                    tooling/. Nothing in the template's own repository ever executes either: a
#                    typo in a recipe, a tooling script that no longer parses the example
#                    language, a target that forgets to create build/.gitignore — each ships,
#                    silently, and fails on the author's first command. So every render is
#                    copied to a scratch directory and its targets are run for real.
#
#                    Thirty-two checks, per render:
#                      1. `make help` succeeds and prints something.
#                      2. `make flags` succeeds.
#                      3. `make provenance` succeeds.
#                      4. `make lexicon` succeeds (a conlang render with a language in it).
#                      5. `make glossary` succeeds and writes build/glossary-*.md.
#                      6. `make script-sample` succeeds and writes build/script-sample-*.svg.
#                      7. `make docx` succeeds and writes a .docx (where Pandoc exists; books on
#                         the example chapter, business on a FILE=….md document).
#                      8. `make pdf` succeeds and writes a .pdf (where Pandoc and XeLaTeX exist;
#                         books on the example chapter, business on a FILE=….tex document).
#                      9. Whenever build/ exists, build/.gitignore exists and ignores everything
#                         (`*`) — generated output never reaches git (DESIGN.md D17).
#                     10. `make derive` succeeds (a conlang render with a language in it).
#                     11. `make coverage` succeeds (the same).
#                     12. `make family` succeeds (the same).
#                     13. `make font` succeeds and writes build/fonts/*.otf (the same, where uv
#                         exists).
#                     14. `make tex SCOPE=manuscript/src/01-example-chapter` succeeds and writes
#                         the Pandoc base to typeset/src/units/.base/ (a book render with the
#                         example chapter, where Pandoc exists).
#                     15. With that base copied to typeset/src/units/ as the styled chapter,
#                         `make tex-check` passes (DESIGN.md D31: the words come from Pandoc).
#                     16. With one word of the styled chapter changed, `make tex-check` fails —
#                         a fidelity check that passes a changed word proves nothing.
#                     17. `make print` succeeds and writes build/typeset/book.pdf (where XeLaTeX
#                         exists, and not with --skip-pdf).
#                     18. Every tooling/*.py that offers a `--self-test` passes it: texcheck.py
#                         and provenance.py everywhere, lexicon.py and script.py with the conlang
#                         kit. A self-test that needs Pandoc skips that part by itself.
#                     19. In a business render with the example proposal, the example section
#                         converted by Pandoc into a copy of tooling/latex/skeleton.tex between
#                         its marker pair passes `make section-check` (DESIGN.md D36; where
#                         Pandoc exists).
#                     20. With one word of that section changed, `make section-check` fails — a
#                         word check that passes a changed word in a contract proves nothing.
#                     21. `make flags` never prints a flag from a git-ignored file (DESIGN.md
#                         D42): a file in an ignored folder of the content layer carries one, and
#                         a tracked twin carries the same, which flags must list — otherwise the
#                         proof could not run. Ignored folders hold credentials and local-only
#                         material, and the targets print matching lines verbatim.
#                     22. `make lint` never prints a finding from a git-ignored file (the same
#                         pair, each with two sentences on a line and an en_US spelling).
#                     23. Business: `make pdf FILE=… ISSUE=1` over a final document whose PDF
#                         already sits beside it fails, leaves that PDF byte for byte, and says
#                         FORCE=1 (D43) — an issued record is never rebuilt over silently (where
#                         XeLaTeX exists).
#                     24. Business: the same command with FORCE=1 succeeds and replaces the PDF,
#                         so the refusal in check 23 was the existing file, not the build.
#                     25. Business: `make flags SCOPE=<file>` counts a \fillme field in a .tex as
#                         an open item (the default FLAG_EXTRA_RE of tooling/project.mk), so a
#                         LaTeX deliverable never gets a false all-clear (DESIGN.md D13).
#                     26. Business: `make pdf FILE=… ISSUE=1`, alone and with FORCE=1, over a final
#                         document holding that field fails, says to clear the open items first
#                         and issues nothing: final needs zero flags, and FORCE=1 never overrides
#                         that. The refusal comes before the build, so no XeLaTeX is needed.
#                     27. Business: `make pdf FILE=… ISSUE=0` over a final document with nothing
#                         open fails with the switch error and issues nothing: ISSUE takes 1, yes
#                         or true, so 0 can never mean on.
#                     28. Business: `make pdf FILE=… ISSUE=1 FORCE=0` over an issued PDF fails with
#                         the switch error and leaves that PDF byte for byte.
#                     29. `make flags` reads a file whose name holds a double quote and a backslash.
#                         Git quotes such a name unless the paths travel NUL-separated, and a
#                         quoted name matches no file, so it would drop out of every scan unseen.
#                     30. Business: a two-page copy of the skeleton that calls
#                         \houseclassification{…} builds with `make pdf` (where XeLaTeX exists)
#                         and, where pdftotext exists, prints the level twice on every page: in
#                         the running header and in the footer.
#                     31. Conlang: a copy of a language in a folder git ignores (its own .gitignore
#                         holds `*`) is never found by `make lexicon`, nor, when it has a script, by
#                         `make script-sample` (DESIGN.md D42), while the language it copies is.
#                     32. Where standards/brand/ ships (business): `make flags` honours BRAND_DIRS
#                         in tooling/project.mk (D43). By default it lists the brand seeds' open
#                         flags; with BRAND_DIRS pointed at another folder holding a flag, it lists
#                         that folder's flag and none from standards/brand/ — otherwise a project
#                         that keeps its brand elsewhere sees the seeds' flags open for ever, and
#                         STRICT=1 always fails.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    A check whose input is absent is SKIPPED and named as skipped, never
#                    passed: no Pandoc, no XeLaTeX, no uv, no example chapter (an adoption
#                    render), no language. --require-pandoc (CI) turns a missing Pandoc into an
#                    error.
#
#                    What it CANNOT check: that a proof LOOKS right — only that it builds (and,
#                    for check 30, where a word lands in its text). A person reads the PDF; the
#                    `build` skill's last step says so.
#
# SELF-TEST. --self-test writes a fixture render at runtime with a Makefile whose targets can be
#            told to fail one at a time, proves it clean, then fails each target in turn and
#            asserts exactly one finding each.
#
# Requirements: bash 4+, make, python3, git; pandoc, xelatex, pdftotext and uv optional. No
#               network, unless uv must fetch fontTools for `make font` on its first run.
#
# Usage: tooling-smoke.sh [--require-pandoc] [--skip-pdf] [--quiet] [--self-test] [--help] <tree>...
#
# Exit codes:  0 = every target that could run, ran and produced its output
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, no make or python3, --require-pandoc without it)

set -euo pipefail
SCRIPT_NAME="tooling-smoke.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
REQUIRE_PANDOC=false
SKIP_PDF=false
TARGETS=()

usage() {
  cat <<'EOF'
tooling-smoke.sh — Run the generated Makefile's targets in every render

Usage: tooling-smoke.sh [--require-pandoc] [--skip-pdf] [--quiet] [--self-test] [--help] <tree>...

  --require-pandoc  Treat a missing pandoc as an error (CI)
  --skip-pdf        Do not build PDFs even where XeLaTeX exists
  --quiet           Print findings only
  --self-test       Prove the checks still fire against a fixture render
  --help            Show this message

Renders are copied before anything runs; the trees given are never written to.
Exit codes: 0 = clean  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --require-pandoc) REQUIRE_PANDOC=true; shift ;;
    --skip-pdf)       SKIP_PDF=true; shift ;;
    --quiet|-q)       QUIET=true; shift ;;
    --self-test)      SELF_TEST=true; shift ;;
    --help|-h)        usage; exit 0 ;;
    -*)               die "unknown argument: $1" ;;
    *)                TARGETS+=("$1"); shift ;;
  esac
done

HAVE_PANDOC=false; command -v pandoc >/dev/null 2>&1 && HAVE_PANDOC=true
HAVE_XELATEX=false; command -v xelatex >/dev/null 2>&1 && HAVE_XELATEX=true
HAVE_UV=false; command -v uv >/dev/null 2>&1 && HAVE_UV=true
HAVE_PDFTOTEXT=false; command -v pdftotext >/dev/null 2>&1 && HAVE_PDFTOTEXT=true
# A PDF's text, pages separated by form feeds (check 30); the self-test reads its stub as text.
pdf_text() { pdftotext -layout "$1" - 2>/dev/null; }
EXAMPLE_UNIT="01-example-chapter"
MAKE_EXTRA=()
# How check 19 turns a Markdown section into LaTeX; the self-test swaps in a stub, so it needs
# no Pandoc. Run inside the render, so the house filter is the render's own.
TOLATEX=(pandoc -f markdown -t latex --lua-filter tooling/pandoc/house.lua)
SMOKE_FAIL=""   # the self-test names one fixture script whose --self-test must fail

# State the checks read: per target, its exit status ("skip: why" when it could not run) and
# whether its output appeared. --self-test mutates it by rerunning with a failing target.
declare -A RES=() GOT=()
NAME=""
SKIPS=()

mk() { # $1 = dir, $2 = target, then make arguments → sets RES[target]
  local d="$1" t="$2"; shift 2
  local s=0
  (cd "$d" && timeout 900 make --no-print-directory "$t" "$@" "${MAKE_EXTRA[@]}") >"$d/.smoke-$t.log" 2>&1 || s=$?
  RES[$t]=$s
}

smoke() { # $1 = a COPY of a render
  local d="$1" lang file t
  RES=(); GOT=(); SKIPS=(); GRD=(); CLS=(); LIG=()
  mk "$d" help;       [[ -s "$d/.smoke-help.log" ]] && GOT[help]=1
  mk "$d" flags
  mk "$d" provenance
  smoke_selftests "$d"

  lang="$(find "$d/world/src/languages" -mindepth 2 -maxdepth 2 -name lexicon.toml 2>/dev/null | head -1 || true)"
  if [[ -n "$lang" ]]; then
    mk "$d" lexicon
    mk "$d" glossary;      compgen -G "$d/build/glossary-*.md" >/dev/null && GOT[glossary]=1
    mk "$d" script-sample; compgen -G "$d/build/script-sample-*.svg" >/dev/null && GOT[script-sample]=1
    mk "$d" derive
    mk "$d" coverage
    mk "$d" family
    if $HAVE_UV; then mk "$d" font; compgen -G "$d/build/fonts/*.otf" >/dev/null && GOT[font]=1
    else RES[font]="skip: no uv"; fi
  else
    for t in lexicon glossary script-sample derive coverage family font; do RES[$t]="skip: no language"; done
  fi

  if [[ -d "$d/library" ]]; then
    file="$(cd "$d" && find library/src -type f -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md 2>/dev/null | LC_ALL=C sort | head -1 || true)"
    if ! $HAVE_PANDOC; then RES[docx]="skip: no pandoc"
    elif [[ -z "$file" ]]; then RES[docx]="skip: no .md document under library/src"
    else mk "$d" docx "FILE=$file"; compgen -G "$d/build/*.docx" >/dev/null && GOT[docx]=1; fi
    file="$(cd "$d" && find library/src -type f -name '*.tex' 2>/dev/null | LC_ALL=C sort | head -1 || true)"
    if $SKIP_PDF || ! $HAVE_XELATEX; then RES[pdf]="skip: no xelatex (or --skip-pdf)"
    elif [[ -z "$file" ]]; then RES[pdf]="skip: no .tex document under library/src"
    else mk "$d" pdf "FILE=$file"; compgen -G "$d/build/*.pdf" >/dev/null && GOT[pdf]=1; fi
    for t in tex tex-check tex-mutant print; do RES[$t]="skip: no printed book in a business render"; done
    smoke_section "$d"
  else
    for t in section-check section-mutant; do RES[$t]="skip: no .tex deliverables in a book render"; done
    file="$(cd "$d" && find manuscript/src -type f -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md ! -path '*/drafts/*' 2>/dev/null | head -1 || true)"
    if ! $HAVE_PANDOC; then RES[docx]="skip: no pandoc"
    elif [[ -z "$file" ]]; then RES[docx]="skip: no unit under manuscript/src (an adoption render)"
    else mk "$d" docx; compgen -G "$d/build/*.docx" >/dev/null && GOT[docx]=1; fi
    if $SKIP_PDF || ! $HAVE_PANDOC || ! $HAVE_XELATEX; then RES[pdf]="skip: no pandoc or xelatex (or --skip-pdf)"
    elif [[ -z "$file" ]]; then RES[pdf]="skip: no unit under manuscript/src (an adoption render)"
    else mk "$d" pdf; compgen -G "$d/build/*.pdf" >/dev/null && GOT[pdf]=1; fi
    smoke_print "$d"
  fi
  smoke_ignored "$d"
  smoke_lang_ignored "$d"
  smoke_brand "$d"
  if [[ -d "$d/library" ]]; then smoke_issue "$d"; smoke_guard "$d"; smoke_classification "$d"
  else
    RES[issue]="skip: no issued documents in a book render"
    GRD[skip]="skip: no issued documents in a book render"
    CLS[build]="skip: no house preamble in a book render"
  fi
  BUILD_DIR="$d/build"
}

# D42 (checks 21 and 22): a git-ignored file's lines never reach make flags or make lint. The
# same text sits in a tracked twin, which must be listed, so a target that lists nothing at all
# cannot pass for one that filters.
IGN_TEXT='<!-- VERIFY: smoke ignore check -->\nThe tide was late. It turned at noon.\nThe pilots organize the crossing.\n'
# Check 29: a name git would quote. It holds no space, which make itself cannot carry in a list.
QUOTED_NAME='smoke-q"uote\name.md'
declare -A IGN=()
smoke_ignored() { # $1 = a COPY of a render
  local d="$1" src t s
  IGN=()
  if [[ -d "$d/library/src" ]]; then src=library/src
  elif [[ -d "$d/manuscript/src" ]]; then src=manuscript/src
  else for t in flags lint quote; do IGN[$t]="skip: no content layer"; done; return 0; fi
  # A render is its own repository (the copy task runs git init); the fixture is made one here.
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  mkdir -p "$d/$src/smoke-private"
  printf '*\n' > "$d/$src/smoke-private/.gitignore"
  printf '%b' "$IGN_TEXT" > "$d/$src/smoke-private/smoke-ignored.md"
  printf '%b' "$IGN_TEXT" > "$d/$src/smoke-visible.md"
  printf '<!-- VERIFY: smoke quoted-name check -->\n' > "$d/$src/$QUOTED_NAME"
  for t in flags lint; do
    s=0
    (cd "$d" && timeout 300 make --no-print-directory "$t" "${MAKE_EXTRA[@]}") >"$d/.smoke-ignored-$t.log" 2>&1 || s=$?
    if grep -qF 'smoke-ignored.md' "$d/.smoke-ignored-$t.log"; then IGN[$t]=leak
    elif [[ "$s" -ne 0 && "$t" == flags ]]; then IGN[$t]="skip: make flags failed (check 2 reports it)"
    elif [[ "$s" -ne 0 ]]; then IGN[$t]="failed $s"
    elif ! grep -qF 'smoke-visible.md' "$d/.smoke-ignored-$t.log"; then IGN[$t]=blind
    else IGN[$t]=0; fi
  done
  if [[ "${IGN[flags]}" == skip:* ]]; then IGN[quote]="${IGN[flags]}"
  elif grep -qF "$QUOTED_NAME" "$d/.smoke-ignored-flags.log"; then IGN[quote]=0
  else IGN[quote]=blind; fi
  rm -f -- "${d:?}/${src:?}/smoke-private/smoke-ignored.md" "${d:?}/${src:?}/smoke-private/.gitignore" \
    "${d:?}/${src:?}/smoke-visible.md" "${d:?}/${src:?}/$QUOTED_NAME"
  rmdir -- "${d:?}/${src:?}/smoke-private" 2>/dev/null || true
}

# D42 (check 31): a language folder git ignores is never found, by the Makefile (lexicon.toml
# and script/glyphs.toml through its NOT_IGNORED filter) or by the conlang tooling
# (conlang_common.language_dirs). The copy is of the first language with a script, so
# script-sample's choice of 'the only language with a script' is tested too.
declare -A LIG=()
declare -A CHECK_OF=([lexicon]=4 [script-sample]=6)
smoke_lang_ignored() { # $1 = a COPY of a render
  local d="$1" langs="world/src/languages" from slug hidden=smoke-hidden-tongue t s
  from="$(cd "$d" && { find "$langs" -mindepth 3 -maxdepth 3 -path '*/script/glyphs.toml' 2>/dev/null | LC_ALL=C sort | head -1 | sed 's|/script/glyphs.toml$||'; } || true)"
  [[ -n "$from" ]] || from="$(cd "$d" && { find "$langs" -mindepth 2 -maxdepth 2 -name lexicon.toml 2>/dev/null | LC_ALL=C sort | head -1 | sed 's|/lexicon.toml$||'; } || true)"
  if [[ -z "$from" ]]; then LIG[lexicon]="skip: no language"; LIG[script-sample]="skip: no language"; return 0; fi
  slug="$(basename "$from")"
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  cp -a "$d/$from" "$d/$langs/$hidden"
  printf '*\n' > "$d/$langs/$hidden/.gitignore"
  for t in lexicon script-sample; do
    if [[ "$t" == script-sample && ! -f "$d/$from/script/glyphs.toml" ]]; then LIG[$t]="skip: no language with a script"; continue; fi
    s=0
    (cd "$d" && timeout 300 make --no-print-directory "$t" "${MAKE_EXTRA[@]}") >"$d/.smoke-lang-ignored-$t.log" 2>&1 || s=$?
    if grep -qF "$hidden" "$d/.smoke-lang-ignored-$t.log"; then LIG[$t]=leak
    elif [[ "$s" -ne 0 ]]; then LIG[$t]="skip: make $t failed (check ${CHECK_OF[$t]} reports it)"
    elif ! grep -qF "$slug" "$d/.smoke-lang-ignored-$t.log"; then LIG[$t]=blind
    else LIG[$t]=0; fi
  done
  rm -rf -- "${d:?}/$langs/$hidden"
}

# D43 (check 32): BRAND_DIRS in tooling/project.mk says where make flags looks for brand files.
# The default run must list a brand seed's flag, or the proof is blind; then project.mk points
# BRAND_DIRS at a folder outside every src/ holding one flag, and only that folder may count.
# A report line is '  <path>:<line>:<text>', so a flag's text that merely names standards/brand/
# (in 00-project.md, say) is never mistaken for a flag in it.
BRAND_ELSEWHERE="smoke-brand"
declare -A BRD=()
smoke_brand() { # $1 = a COPY of a render
  local d="$1" mkf="$1/tooling/project.mk" s had=false
  BRD=()
  if [[ ! -d "$d/standards/brand" ]]; then BRD[skip]="skip: no standards/brand (a book render)"; return 0; fi
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  s=0; (cd "$d" && timeout 300 make --no-print-directory flags "${MAKE_EXTRA[@]}") >"$d/.smoke-brand-default.log" 2>&1 || s=$?
  if [[ "$s" -ne 0 ]]; then BRD[skip]="skip: make flags failed (check 2 reports it)"; return 0; fi
  grep -qE '^  standards/brand/[^:]+:[0-9]+:' "$d/.smoke-brand-default.log" && BRD[default]=1
  mkdir -p "$d/$BRAND_ELSEWHERE" "$d/tooling"
  printf '# Brand guide, kept elsewhere\n\n<!-- VERIFY: smoke brand-dirs check -->\n' > "$d/$BRAND_ELSEWHERE/brand-guide.md"
  if [[ -f "$mkf" ]]; then had=true; cp "$mkf" "$d/.smoke-brand-project.mk"; fi
  if $had && grep -qE '^BRAND_DIRS[[:space:]]*[:?]?=' "$mkf"; then
    sed -i -E "s|^BRAND_DIRS[[:space:]]*([:?]?=).*|BRAND_DIRS \1 $BRAND_ELSEWHERE|" "$mkf"
  else
    printf '\nBRAND_DIRS = %s\n' "$BRAND_ELSEWHERE" >> "$mkf"
  fi
  s=0; (cd "$d" && timeout 300 make --no-print-directory flags "${MAKE_EXTRA[@]}") >"$d/.smoke-brand.log" 2>&1 || s=$?
  BRD[status]=$s
  grep -qE '^  standards/brand/[^:]+:[0-9]+:' "$d/.smoke-brand.log" && BRD[stale]=1
  grep -qE "^  $BRAND_ELSEWHERE/brand-guide\.md:[0-9]+:" "$d/.smoke-brand.log" && BRD[counted]=1
  if $had; then mv "$d/.smoke-brand-project.mk" "$mkf"; else rm -f -- "$mkf"; fi
  rm -rf -- "${d:?}/$BRAND_ELSEWHERE"
}

# D13 and D43 (checks 25 to 28): an open item stops an issue, and ISSUE and FORCE are switches.
# Two final documents sit beside the business family's sources, made from the skeleton (or a
# bare document where a render has none): one holds a \fillme field in its body, the other
# nothing open. Every refusal comes before the build, so none of it needs XeLaTeX: a target
# that failed to refuse either issues a copy or fails without the refusal's words.
declare -A GRD=()
smoke_guard() { # $1 = a COPY of a business render
  local d="$1" dir open clean pdf s extra log why
  if [[ -d "$d/library/src/business" ]]; then dir=library/src/business
  elif [[ -d "$d/library/src" ]]; then dir=library/src
  else GRD[skip]="skip: no library/src"; return 0; fi
  open="$dir/smoke-open.tex"; clean="$dir/smoke-clean.tex"
  if [[ -f "$d/tooling/latex/skeleton.tex" ]]; then cp "$d/tooling/latex/skeleton.tex" "$d/$clean.src"
  else printf '\\documentclass{article}\n\\begin{document}\nA document.\n\\end{document}\n' > "$d/$clean.src"; fi
  if grep -qE '^% status:' "$d/$clean.src"; then sed -E '0,/^% status:.*/s//% status: final/' "$d/$clean.src" > "$d/$clean"
  else { printf '%% status: final\n'; cat "$d/$clean.src"; } > "$d/$clean"; fi
  rm -f -- "${d:?}/${clean:?}.src"
  awk 'index($0, "\\end{document}") == 1 && !done { print "Owner: \\fillme."; done = 1 } { print }' "$d/$clean" > "$d/$open"
  # Check 25: make flags counts the field.
  s=0; (cd "$d" && timeout 300 make --no-print-directory flags "SCOPE=$open" "${MAKE_EXTRA[@]}") >"$d/.smoke-guard-flags.log" 2>&1 || s=$?
  GRD[flags]=$s
  GRD[counted]=false; grep -qE 'smoke-open\.tex:[0-9]+:.*fillme' "$d/.smoke-guard-flags.log" && GRD[counted]=true
  # Check 26: ISSUE=1, alone and with FORCE=1, refuses the document holding it.
  pdf="${open%.tex}.pdf"; GRD[open]=ok
  for extra in "" FORCE=1; do
    log="$d/.smoke-guard-open${extra:+-force}.log"; s=0
    (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$open" ISSUE=1 ${extra:+"$extra"} "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
    why=""
    [[ "$s" -ne 0 ]] || why+=" exit 0;"
    grep -qF 'clear the open items first' "$log" || why+=" no refusal naming the open items;"
    [[ ! -e "$d/$pdf" ]] || why+=" a copy was issued;"
    [[ -z "$why" ]] || GRD[open]="ISSUE=1${extra:+ $extra}:${why%;}"
    rm -f -- "${d:?}/${pdf:?}"
    [[ "${GRD[open]}" == ok ]] || break
  done
  # Check 27: ISSUE=0 is refused, and issues nothing.
  pdf="${clean%.tex}.pdf"; s=0
  (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$clean" ISSUE=0 "${MAKE_EXTRA[@]}") >"$d/.smoke-guard-issue0.log" 2>&1 || s=$?
  why=""
  [[ "$s" -ne 0 ]] || why+=" exit 0;"
  grep -qF 'ISSUE takes 1, yes or true' "$d/.smoke-guard-issue0.log" || why+=" no switch error;"
  [[ ! -e "$d/$pdf" ]] || why+=" a copy was issued;"
  why="${why# }"; GRD[issue0]="${why%;}"; GRD[issue0]="${GRD[issue0]:-ok}"
  rm -f -- "${d:?}/${pdf:?}"
  # Check 28: FORCE=0 is refused, and the issued copy stays as it was.
  printf 'An issued copy that must survive.\n' > "$d/$pdf"; cp "$d/$pdf" "$d/.smoke-guard.keep"; s=0
  (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$clean" ISSUE=1 FORCE=0 "${MAKE_EXTRA[@]}") >"$d/.smoke-guard-force0.log" 2>&1 || s=$?
  why=""
  [[ "$s" -ne 0 ]] || why+=" exit 0;"
  grep -qF 'FORCE takes 1, yes or true' "$d/.smoke-guard-force0.log" || why+=" no switch error;"
  cmp -s "$d/$pdf" "$d/.smoke-guard.keep" || why+=" the issued copy changed;"
  why="${why# }"; GRD[force0]="${why%;}"; GRD[force0]="${GRD[force0]:-ok}"
  rm -f -- "${d:?}/${open:?}" "${d:?}/${clean:?}" "${d:?}/${pdf:?}" "${d:?}/.smoke-guard.keep"
}

# Check 30: \houseclassification{…} puts the level in the running header and the footer of every
# page. The copy of the skeleton calls it just before \begin{document} and gains a second page.
declare -A CLS=()
smoke_classification() { # $1 = a COPY of a business render
  local d="$1" dir tex out s pages
  if $SKIP_PDF || ! $HAVE_XELATEX; then CLS[build]="skip: no xelatex (or --skip-pdf)"; return 0; fi
  if [[ ! -f "$d/tooling/latex/skeleton.tex" ]]; then CLS[build]="skip: no skeleton"; return 0; fi
  if [[ -d "$d/library/src/business" ]]; then dir=library/src/business; else dir=library/src; fi
  tex="$dir/smoke-classified.tex"; out="$d/build/${tex//\//__}"; out="${out%.tex}.pdf"
  awk 'index($0, "\\begin{document}") == 1 && !a { print "\\houseclassification{SMOKE-CLASSIFIED}"; a = 1 }
       index($0, "\\end{document}") == 1 && !b { print "\\clearpage"; print "A second page."; b = 1 }
       { print }' "$d/tooling/latex/skeleton.tex" > "$d/$tex"
  s=0; (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$tex" "${MAKE_EXTRA[@]}") >"$d/.smoke-classification.log" 2>&1 || s=$?
  CLS[build]=$s
  if [[ "$s" -eq 0 && ! -f "$out" ]]; then CLS[build]="no PDF at build/$(basename "$out")"; fi
  if [[ "${CLS[build]}" == 0 ]]; then
    if ! $HAVE_PDFTOTEXT; then CLS[text]="skip: no pdftotext, so the level's place was not read"
    else
      pages="$(pdf_text "$out" | awk 'BEGIN { RS = "\f" } NF { n++; if (gsub(/SMOKE-CLASSIFIED/, "&") < 2) bad = bad " " n } END { print n + 0 ":" bad }')"
      if [[ "${pages%%:*}" -lt 2 ]]; then CLS[text]="the copy printed ${pages%%:*} page(s), not two"
      elif [[ -n "${pages#*:}" ]]; then CLS[text]="page(s)${pages#*:} of ${pages%%:*} lack the level in the header or the footer"
      else CLS[text]=0; fi
    fi
  fi
  rm -f -- "${d:?}/${tex:?}"
}

# D43 (checks 23 and 24): ISSUE=1 never overwrites an issued PDF unless FORCE=1. The document is
# a copy of the first .tex under library/src/ (the one check 8 builds), beside its source so its
# relative inputs resolve, or — in a render with none, which is most — of the house skeleton,
# in library/src/business/. Either way it is marked final, so only the existing PDF can stop it.
declare -A ISS=()
smoke_issue() { # $1 = a COPY of a business render
  local d="$1" tex copy pdf s
  ISS=()
  if $SKIP_PDF || ! $HAVE_XELATEX; then RES[issue]="skip: no xelatex (or --skip-pdf)"; return 0; fi
  tex="$(cd "$d" && find library/src -type f -name '*.tex' 2>/dev/null | LC_ALL=C sort | head -1 || true)"
  if [[ -n "$tex" ]]; then copy="$(dirname "$tex")/smoke-issue.tex"
  elif [[ -f "$d/tooling/latex/skeleton.tex" && -d "$d/library/src/business" ]]; then
    tex="tooling/latex/skeleton.tex"; copy="library/src/business/smoke-issue.tex"
  else RES[issue]="skip: no .tex document under library/src and no skeleton"; return 0; fi
  RES[issue]=ran
  pdf="${copy%.tex}.pdf"
  if grep -qE '^% status:' "$d/$tex"; then sed -E '0,/^% status:.*/s//% status: final/' "$d/$tex" > "$d/$copy"
  else { printf '%% status: final\n'; cat "$d/$tex"; } > "$d/$copy"; fi
  printf 'An issued copy that must survive.\n' > "$d/$pdf"; cp "$d/$pdf" "$d/.smoke-issued.keep"
  s=0; (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$copy" ISSUE=1 "${MAKE_EXTRA[@]}") >"$d/.smoke-issue.log" 2>&1 || s=$?
  ISS[status]=$s
  ISS[kept]=false; cmp -s "$d/$pdf" "$d/.smoke-issued.keep" && ISS[kept]=true
  ISS[says]=false; grep -qF 'FORCE=1' "$d/.smoke-issue.log" && ISS[says]=true
  cp "$d/.smoke-issued.keep" "$d/$pdf"
  s=0; (cd "$d" && timeout 900 make --no-print-directory pdf "FILE=$copy" ISSUE=1 FORCE=1 "${MAKE_EXTRA[@]}") >"$d/.smoke-issue-force.log" 2>&1 || s=$?
  ISS[force]=$s
  ISS[replaced]=false; [[ -f "$d/$pdf" ]] && ! cmp -s "$d/$pdf" "$d/.smoke-issued.keep" && ISS[replaced]=true
  rm -f -- "${d:?}/${copy:?}" "${d:?}/${pdf:?}" "${d:?}/.smoke-issued.keep"
}

# Each tooling script's own self-test (check 18), run from the render's root as the author would.
smoke_selftests() { # $1 = a COPY of a render
  local d="$1" f n s
  SELFTESTS=()
  for f in "$d"/tooling/*.py; do
    [[ -f "$f" ]] && grep -q -- '--self-test' "$f" || continue
    n="$(basename "$f" .py)"; s=0
    (cd "$d" && SMOKE_FAIL="$SMOKE_FAIL" timeout 300 python3 -B "tooling/$n.py" --self-test) >"$d/.smoke-selftest-$n.log" 2>&1 || s=$?
    SELFTESTS+=("$n:$s")
  done
}

# A business section's words (DESIGN.md D36): the example draft converted into the skeleton's
# first marker pair must pass make section-check, and fail with one word changed.
smoke_section() { # $1 = a COPY of a business render
  local d="$1" draft slug tex="library/src/business/smoke-section.tex" t
  draft="$(cd "$d" && find library/src -path '*/drafts/*' -type f -name '*.md' ! -name README.md 2>/dev/null | LC_ALL=C sort | head -1 || true)"
  if [[ -z "$draft" || ! -f "$d/tooling/latex/skeleton.tex" ]]; then
    for t in section-check section-mutant; do RES[$t]="skip: no example section draft (an adoption render)"; done; return 0
  elif ! $HAVE_PANDOC; then
    for t in section-check section-mutant; do RES[$t]="skip: no pandoc"; done; return 0
  fi
  slug="$(sed -n 's/^section:[[:space:]]*//p' "$d/$draft" | head -1)"
  if ! (cd "$d" && "${TOLATEX[@]}" "$draft" > .smoke-section-body.tex 2>/dev/null) || [[ -z "$slug" ]]; then
    RES[section-check]="could not convert $draft"; RES[section-mutant]="skip: no conversion"; return 0
  fi
  python3 - "$d/tooling/latex/skeleton.tex" "$d/.smoke-section-body.tex" "$slug" "$d/$tex" <<'PY'
import re, sys
skel, body, slug, out = open(sys.argv[1]).read(), open(sys.argv[2]).read(), sys.argv[3], sys.argv[4]
m = re.search(r'^% section: (\S+)\n.*?^% end section: \1$', skel, re.S | re.M)
skel = skel[:m.start()] + f'% section: {slug}\n{body.rstrip()}\n% end section: {slug}' + skel[m.end():]
open(out, 'w').write(skel)
PY
  mk "$d" section-check "FILE=$tex" "SECTION=$slug" "DRAFT=$draft"
  t="${RES[section-check]}"; mv "$d/.smoke-section-check.log" "$d/.smoke-section-check.keep"
  # One word changed: the first capitalised word that opens a line inside the marker pair.
  awk -v s="% section: $slug" '$0 == s { inside = 1 } inside && !done && /^[A-Z][a-z]+ / { sub(/^[A-Z][a-z]+ /, "Mutated "); done = 1 } { print }' \
    "$d/$tex" > "$d/$tex.mut" && mv "$d/$tex.mut" "$d/$tex"
  if ! grep -q '^Mutated ' "$d/$tex"; then RES[section-mutant]="nothing to mutate"
  else mk "$d" section-check "FILE=$tex" "SECTION=$slug" "DRAFT=$draft"; RES[section-mutant]="${RES[section-check]}"; mv "$d/.smoke-section-check.log" "$d/.smoke-section-mutant.log"; fi
  RES[section-check]="$t"; mv "$d/.smoke-section-check.keep" "$d/.smoke-section-check.log"
  rm -f "$d/$tex"
  return 0
}

# The printed book (DESIGN.md D31 and Section 7): base, styled copy, fidelity, mutation, print.
smoke_print() { # $1 = a COPY of a book render
  local d="$1" u="$EXAMPLE_UNIT" base styled t
  base="$d/typeset/src/units/.base/$u.tex"; styled="$d/typeset/src/units/$u.tex"
  if [[ ! -d "$d/typeset" ]]; then
    for t in tex tex-check tex-mutant print; do RES[$t]="skip: no typeset/ layer"; done; return 0
  elif [[ ! -f "$d/manuscript/src/$u/$u.md" ]]; then
    for t in tex tex-check tex-mutant print; do RES[$t]="skip: no example chapter (an adoption render)"; done; return 0
  elif ! $HAVE_PANDOC; then
    for t in tex tex-check tex-mutant; do RES[$t]="skip: no pandoc"; done
  else
    mk "$d" tex "SCOPE=manuscript/src/$u"; [[ -f "$base" ]] && GOT[tex]=1
    if [[ "${RES[tex]}" != 0 || ! -f "$base" ]]; then
      RES[tex-check]="skip: make tex wrote no base"; RES[tex-mutant]="skip: make tex wrote no base"
    else
      cp "$base" "$styled"
      mk "$d" tex-check "UNIT=$u"; t="${RES[tex-check]}"; mv "$d/.smoke-tex-check.log" "$d/.smoke-tex-check.keep"
      # One word changed: the first word of the first prose line (never a comment or a macro).
      sed -E '0,/^[A-Z][a-z]+ /s/^[A-Z][a-z]+ /Mutated /' "$base" > "$styled"
      if cmp -s "$base" "$styled"; then RES[tex-mutant]="nothing to mutate"
      else mk "$d" tex-check "UNIT=$u"; RES[tex-mutant]="${RES[tex-check]}"; mv "$d/.smoke-tex-check.log" "$d/.smoke-tex-mutant.log"; fi
      RES[tex-check]="$t"; mv "$d/.smoke-tex-check.keep" "$d/.smoke-tex-check.log"
      cp "$base" "$styled"
    fi
  fi
  if $SKIP_PDF || ! $HAVE_XELATEX; then RES[print]="skip: no xelatex (or --skip-pdf)"
  else mk "$d" print; [[ -f "$d/build/typeset/book.pdf" ]] && GOT[print]=1; fi
  return 0
}

BUILD_DIR=""
SELFTESTS=()
run_checks() {
  FINDINGS=(); SKIPS=()
  local t n err r
  local -a order=(help:1 flags:2 provenance:3 lexicon:4 glossary:5 script-sample:6 docx:7 pdf:8
                  derive:10 coverage:11 family:12 font:13 tex:14 tex-check:15 print:17 section-check:19)
  for t in "${order[@]}"; do
    n="${t#*:}"; t="${t%%:*}"
    r="${RES[$t]:-skip: not run}"
    case "$r" in
      skip:*) SKIPS+=("$t (${r#skip: })"); continue ;;
      0) ;;
      *) err="$(grep -v '^[[:space:]]*$' "$(dirname "$BUILD_DIR")/.smoke-$t.log" 2>/dev/null | tail -1 || true)"
         finding "check $n — [$NAME] make $t failed (exit $r): ${err:0:100}"; continue ;;
    esac
    case "$t" in
      help|glossary|script-sample|docx|pdf|font|tex|print)
        [[ -n "${GOT[$t]:-}" ]] || finding "check $n — [$NAME] make $t succeeded but wrote nothing where it should" ;;
    esac
  done
  r="${RES[tex-mutant]:-skip: not run}"
  case "$r" in
    skip:*) SKIPS+=("tex-check mutation (${r#skip: })") ;;
    0) finding "check 16 — [$NAME] make tex-check passed a styled chapter with one word changed — the fidelity check does not catch a changed word" ;;
    "nothing to mutate") finding "check 16 — [$NAME] the styled chapter has no prose line to change, so the mutation proof could not run" ;;
    *) ;;
  esac
  r="${RES[section-mutant]:-skip: not run}"
  case "$r" in
    skip:*) SKIPS+=("section-check mutation (${r#skip: })") ;;
    0) finding "check 20 — [$NAME] make section-check passed a section with one word changed — the business word check does not catch a changed word" ;;
    "nothing to mutate") finding "check 20 — [$NAME] the converted section has no prose line to change, so the mutation proof could not run" ;;
    *) ;;
  esac
  for t in flags:21 lint:22; do
    n="${t#*:}"; t="${t%%:*}"
    case "${IGN[$t]:-skip: not run}" in
      skip:*) r="${IGN[$t]:-skip: not run}"; SKIPS+=("$t ignore check (${r#skip: })") ;;
      leak)   finding "check $n — [$NAME] make $t printed a line from a git-ignored file (DESIGN.md D42) — see .smoke-ignored-$t.log" ;;
      blind)  finding "check $n — [$NAME] make $t did not list the tracked twin either, so the git-ignore proof could not run" ;;
      failed*) finding "check $n — [$NAME] make $t failed (exit ${IGN[$t]#failed }) on a tracked file and an ignored one — see .smoke-ignored-$t.log" ;;
      *) ;;
    esac
  done
  case "${RES[issue]:-skip: not run}" in
    skip:*) r="${RES[issue]:-skip: not run}"; SKIPS+=("issue (${r#skip: })") ;;
    *)
      if [[ "${ISS[status]:-0}" == 0 || "${ISS[kept]:-false}" != true || "${ISS[says]:-false}" != true ]]; then
        finding "check 23 — [$NAME] make pdf ISSUE=1 over an issued PDF did not refuse with FORCE=1 named and the PDF kept (exit ${ISS[status]:-?}, kept ${ISS[kept]:-?}, says FORCE=1 ${ISS[says]:-?})"
      fi
      if [[ "${ISS[force]:-1}" != 0 || "${ISS[replaced]:-false}" != true ]]; then
        err="$(grep -v '^[[:space:]]*$' "$(dirname "$BUILD_DIR")/.smoke-issue-force.log" 2>/dev/null | tail -1 || true)"
        finding "check 24 — [$NAME] make pdf ISSUE=1 FORCE=1 did not replace the issued PDF (exit ${ISS[force]:-?}): ${err:0:100}"
      fi ;;
  esac
  case "${GRD[skip]:-}" in
    skip:*) SKIPS+=("issue guard (${GRD[skip]#skip: })") ;;
    *)
      if [[ "${GRD[flags]:-?}" != 0 ]]; then
        finding "check 25 — [$NAME] make flags SCOPE=<file> failed (exit ${GRD[flags]:-?}) on a .tex holding a \\fillme field — see .smoke-guard-flags.log"
      elif [[ "${GRD[counted]:-false}" != true ]]; then
        finding "check 25 — [$NAME] make flags did not count a \\fillme field in a .tex as an open item (FLAG_EXTRA_RE in tooling/project.mk) — see .smoke-guard-flags.log"
      fi
      [[ "${GRD[open]:-?}" == ok ]] \
        || finding "check 26 — [$NAME] make pdf did not refuse to issue a final document holding a \\fillme field (${GRD[open]:-not run})"
      [[ "${GRD[issue0]:-?}" == ok ]] \
        || finding "check 27 — [$NAME] make pdf ISSUE=0 was not refused as a switch value (${GRD[issue0]:-not run})"
      [[ "${GRD[force0]:-?}" == ok ]] \
        || finding "check 28 — [$NAME] make pdf ISSUE=1 FORCE=0 over an issued PDF was not refused as a switch value (${GRD[force0]:-not run})" ;;
  esac
  case "${IGN[quote]:-skip: not run}" in
    skip:*) r="${IGN[quote]:-skip: not run}"; SKIPS+=("quoted-name check (${r#skip: })") ;;
    0) ;;
    *) finding "check 29 — [$NAME] make flags did not read a file whose name holds a double quote and a backslash (git quotes such a name unless the paths travel NUL-separated) — see .smoke-ignored-flags.log" ;;
  esac
  case "${CLS[build]:-skip: not run}" in
    skip:*) r="${CLS[build]:-skip: not run}"; SKIPS+=("classification (${r#skip: })") ;;
    0)
      case "${CLS[text]:-skip: not run}" in
        skip:*) r="${CLS[text]:-skip: not run}"; SKIPS+=("classification text (${r#skip: })") ;;
        0) ;;
        *) finding "check 30 — [$NAME] \\houseclassification built, but ${CLS[text]}" ;;
      esac ;;
    *) err="$(grep -v '^[[:space:]]*$' "$(dirname "$BUILD_DIR")/.smoke-classification.log" 2>/dev/null | tail -1 || true)"
       finding "check 30 — [$NAME] a document calling \\houseclassification did not build (${CLS[build]}): ${err:0:100}" ;;
  esac
  for t in lexicon script-sample; do
    case "${LIG[$t]:-skip: not run}" in
      skip:*) r="${LIG[$t]:-skip: not run}"; SKIPS+=("ignored-language $t (${r#skip: })") ;;
      0) ;;
      leak)    finding "check 31 — [$NAME] make $t found a language in a folder git ignores (DESIGN.md D42) — see .smoke-lang-ignored-$t.log" ;;
      blind)   finding "check 31 — [$NAME] make $t did not name the language the ignored copy was made from, so the proof could not run" ;;
    esac
  done
  case "${BRD[skip]:-}" in
    skip:*) SKIPS+=("brand folders (${BRD[skip]#skip: })") ;;
    *)
      if [[ -z "${BRD[default]:-}" ]]; then
        finding "check 32 — [$NAME] make flags listed no flag in standards/brand/ with the default BRAND_DIRS, so the BRAND_DIRS proof could not run — see .smoke-brand-default.log"
      else
        r=""
        [[ "${BRD[status]:-?}" == 0 ]] || r+=" make flags failed (exit ${BRD[status]:-?});"
        [[ -z "${BRD[stale]:-}" ]] || r+=" the brand seeds' flags in standards/brand/ were still counted;"
        [[ -n "${BRD[counted]:-}" ]] || r+=" the flag in $BRAND_ELSEWHERE/ was not counted;"
        [[ -z "$r" ]] || finding "check 32 — [$NAME] make flags did not honour BRAND_DIRS = $BRAND_ELSEWHERE in tooling/project.mk (D43):${r%;} — see .smoke-brand.log"
      fi ;;
  esac
  for t in "${SELFTESTS[@]}"; do
    [[ "${t#*:}" == 0 ]] && continue
    err="$(grep -v '^[[:space:]]*$' "$(dirname "$BUILD_DIR")/.smoke-selftest-${t%%:*}.log" 2>/dev/null | tail -1 || true)"
    finding "check 18 — [$NAME] python3 tooling/${t%%:*}.py --self-test failed (exit ${t#*:}): ${err:0:100}"
  done
  if [[ -d "$BUILD_DIR" ]]; then
    grep -qx '\*' "$BUILD_DIR/.gitignore" 2>/dev/null \
      || finding "check 9 — [$NAME] build/ exists without a build/.gitignore holding '*' — generated output would reach git"
  fi
}

# ── Self-test ────────────────────────────────────────────────────────────────

write_fixture() { # $1 = dir
  local d="$1"
  mkdir -p "$d/world/src/languages/example-tongue" "$d/manuscript/src/$EXAMPLE_UNIT" "$d/typeset/src/units" "$d/tooling"
  git -C "$d" init -q
  printf 'import os, sys  # --self-test\nsys.exit(1 if os.environ.get("SMOKE_FAIL") == "demo" else 0)\n' > "$d/tooling/demo.py"
  printf '[meta]\nslug = "example-tongue"\n' > "$d/world/src/languages/example-tongue/lexicon.toml"
  mkdir -p "$d/world/src/languages/example-tongue/script"
  printf '[meta]\n' > "$d/world/src/languages/example-tongue/script/glyphs.toml"
  printf '# The ford\n\nThe ford ran low.\n' > "$d/manuscript/src/$EXAMPLE_UNIT/$EXAMPLE_UNIT.md"
  cat > "$d/Makefile" <<'EOF'
-include tooling/project.mk
BRAND_DIRS ?= standards/brand
FAIL ?=
NOIGNORE ?=
LAX ?=
fail = @[ "$(FAIL)" != "$@" ] || { echo "failing $@ on purpose"; exit 1; }
build/.gitignore:
	@mkdir -p build
	@[ -n "$(NOIGNORE)" ] || printf '*\n' > build/.gitignore
help:
	$(fail)
	@echo "help  show every target"
flags:
	$(fail)
	@find . -name .git -prune -o -path ./standards -prune -o -path ./smoke-brand -prune -o -name '*.md' -print | LC_ALL=C sort | while read -r f; do \
	  if [ -z "$(LEAK_FLAGS)" ] && git check-ignore -q "$$f" 2>/dev/null; then continue; fi; \
	  case "$$f" in *'"'*) [ -z "$(QUOTE_BLIND)" ] || continue ;; esac; \
	  grep -nH 'VERIFY:' "$$f" || true; done
	@for b in $(if $(STICKY_BRAND),standards/brand) $(if $(BLIND_BRAND),,$(if $(NEWBLIND_BRAND),$(filter standards/brand,$(BRAND_DIRS)),$(BRAND_DIRS))); do \
	  [ -d "$$b" ] && grep -rnH 'VERIFY:' "$$b" | sed 's/^/  /' || true; done
	@[ -z "$(SCOPE)" ] || [ -n "$(BLIND_FILLME)" ] || grep -nH 'fillme' $(SCOPE) || true
lint:
	@find . -name .git -prune -o -name '*.md' -print | LC_ALL=C sort | while read -r f; do \
	  if [ -z "$(LEAK_LINT)" ] && git check-ignore -q "$$f" 2>/dev/null; then continue; fi; \
	  grep -nH 'organize' "$$f" || true; done
provenance:
	$(fail)
lexicon:
	$(fail)
	@for f in world/src/languages/*/lexicon.toml; do [ -f "$$f" ] || continue; \
	  if [ -z "$(LEAK_LANG)" ] && git check-ignore -q "$$f" 2>/dev/null; then continue; fi; \
	  echo "$$(basename "$$(dirname "$$f")"): checked"; done
glossary: | build/.gitignore
	$(fail)
	@echo x > build/glossary-example-tongue.md
script-sample: | build/.gitignore
	$(fail)
	@for f in world/src/languages/*/script/glyphs.toml; do [ -f "$$f" ] || continue; \
	  if [ -z "$(LEAK_SCRIPT)" ] && git check-ignore -q "$$f" 2>/dev/null; then continue; fi; \
	  s=$$(basename "$$(dirname "$$(dirname "$$f")")"); echo '<svg/>' > build/script-sample-$$s.svg; \
	  echo "wrote build/script-sample-$$s.svg"; done
docx: | build/.gitignore
	$(fail)
	@echo x > build/manuscript__src.docx
pdf: | build/.gitignore
	$(fail)
	@case '$(ISSUE)' in ''|1|yes|true) ;; *) [ -n "$(LAX_ISSUE)" ] || { echo "error: ISSUE takes 1, yes or true"; exit 1; } ;; esac
	@case '$(FORCE)' in ''|1|yes|true) ;; *) [ -n "$(LAX_FORCE)" ] || { echo "error: FORCE takes 1, yes or true"; exit 1; } ;; esac
	@if [ -n "$(ISSUE)" ] && [ -z "$(LAX_OPEN)" ] && grep -q 'fillme' '$(FILE)'; then echo "error: clear the open items first"; exit 1; fi
	@echo x > build/manuscript__src.pdf
	@if [ -n "$(FILE)" ] && grep -q 'houseclassification{' '$(FILE)'; then \
	  [ -z "$(FAIL_CLASS)" ] || { echo "failing on the classification"; exit 1; }; \
	  if [ -n "$(HEADLESS)" ]; then printf 'body\fbody\f'; \
	  else printf 'SMOKE-CLASSIFIED body SMOKE-CLASSIFIED\fSMOKE-CLASSIFIED body SMOKE-CLASSIFIED\f'; fi \
	    > 'build/$(subst /,__,$(basename $(FILE))).pdf'; fi
	@if [ -n "$(ISSUE)" ]; then t="$(basename $(FILE)).pdf"; \
	  if [ -n "$(STUBBORN)" ] || { [ -e "$$t" ] && [ -z "$(FORCE)$(CLOBBER)" ]; }; then echo "error: $$t is issued; FORCE=1 replaces it"; exit 1; fi; \
	  echo rebuilt > "$$t"; fi
derive:
	$(fail)
coverage:
	$(fail)
family:
	$(fail)
font: | build/.gitignore
	$(fail)
	@mkdir -p build/fonts && echo x > build/fonts/example-tongue.otf
tex: | build/.gitignore
	$(fail)
	@mkdir -p typeset/src/units/.base
	@printf '%% a comment\n\\chapter{The Ford}\n\nThe ford ran low.\n' > typeset/src/units/.base/01-example-chapter.tex
tex-check:
	$(fail)
	@[ -n "$(LAX)" ] || cmp -s typeset/src/units/.base/$(UNIT).tex typeset/src/units/$(UNIT).tex
print: | build/.gitignore
	$(fail)
	@mkdir -p build/typeset && echo x > build/typeset/book.pdf
section-check:
	$(fail)
	@[ -n "$(LAX)" ] || ! grep -q '^Mutated ' $(FILE)
EOF
}

self_test() {
  local tmp t n
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  HAVE_PANDOC=true; HAVE_XELATEX=true; HAVE_UV=true; HAVE_PDFTOTEXT=true; SKIP_PDF=false; NAME="fixture"
  pdf_text() { cat "$1"; }   # the fixture's PDF is its text, pages split by form feeds
  fresh() { rm -rf "$tmp/run"; write_fixture "$tmp/run"; smoke "$tmp/run"; }
  MAKE_EXTRA=(); fresh
  st_baseline "a fixture whose every target works"
  for t in help:1 flags:2 provenance:3 lexicon:4 glossary:5 script-sample:6 docx:7 pdf:8 \
           derive:10 coverage:11 family:12 font:13 tex:14 tex-check:15 print:17; do
    n="${t#*:}"; t="${t%%:*}"
    MAKE_EXTRA=("FAIL=$t"); fresh
    probe "check $n fires when make $t fails" "check $n — [fixture] make $t failed"
  done
  MAKE_EXTRA=("NOIGNORE=1"); fresh
  probe "check 9 fires when build/ has no .gitignore" "check 9"
  MAKE_EXTRA=("LAX=1"); fresh
  probe "check 16 fires when tex-check passes a chapter with a changed word" "check 16"
  MAKE_EXTRA=(); SMOKE_FAIL=demo; fresh; SMOKE_FAIL=""
  probe "check 18 fires when a tooling script's --self-test fails" "check 18 — [fixture] python3 tooling/demo.py"
  MAKE_EXTRA=("LEAK_FLAGS=1"); fresh
  probe "check 21 fires when make flags reads a git-ignored file" "check 21 — [fixture] make flags printed a line from a git-ignored file"
  MAKE_EXTRA=("LEAK_LINT=1"); fresh
  probe "check 22 fires when make lint reads a git-ignored file" "check 22 — [fixture] make lint printed a line from a git-ignored file"
  MAKE_EXTRA=("QUOTE_BLIND=1"); fresh
  probe "check 29 fires when make flags drops a file whose name git would quote" "check 29 — [fixture] make flags did not read a file whose name holds a double quote"
  MAKE_EXTRA=("LEAK_LANG=1"); fresh
  probe "check 31 fires when make lexicon finds a language in an ignored folder" "check 31 — [fixture] make lexicon found a language in a folder git ignores"
  MAKE_EXTRA=("LEAK_SCRIPT=1"); fresh
  probe "check 31 fires when make script-sample finds a script in an ignored folder" "check 31 — [fixture] make script-sample found a language in a folder git ignores"
  # A business render: the example section is 'converted' by a stub, so no Pandoc is needed.
  TOLATEX=(sed '1,/^---$/d'); fresh_business() {
    MAKE_EXTRA=("$@"); rm -rf "$tmp/run"; write_fixture "$tmp/run"; rm -rf "$tmp/run/manuscript" "$tmp/run/typeset"
    mkdir -p "$tmp/run/library/src/business/drafts/x" "$tmp/run/tooling/latex"
    printf '# A letter\n' > "$tmp/run/library/src/business/a.md"
    printf '%% a document\n%% status: draft\n' > "$tmp/run/library/src/business/a.tex"
    printf -- '---\nsection: scope\n---\n\nThe work covers the handbook.\n' > "$tmp/run/library/src/business/drafts/x/02-scope.md"
    printf '\\begin{document}\n%% section: summary\n[Summary.]\n%% end section: summary\n\\end{document}\n' > "$tmp/run/tooling/latex/skeleton.tex"
    mkdir -p "$tmp/run/standards/brand"
    printf '# Brand guide\n\n<!-- VERIFY: the seed brand guide -->\n' > "$tmp/run/standards/brand/brand-guide.md"
    smoke "$tmp/run"
  }
  fresh_business
  probe_clean "a business render, with no printed book, is clean and its book checks are skipped"
  fresh_business "FAIL=section-check"
  probe "check 19 fires when make section-check fails" "check 19 — [fixture] make section-check failed"
  fresh_business "LAX=1"
  probe "check 20 fires when section-check passes a section with a changed word" "check 20"
  fresh_business "CLOBBER=1"
  probe "check 23 fires when ISSUE=1 overwrites an issued PDF" "check 23"
  fresh_business "STUBBORN=1"
  probe "check 24 fires when FORCE=1 cannot replace it either" "check 24"
  fresh_business "BLIND_FILLME=1"
  probe "check 25 fires when make flags does not count a \\fillme field" "check 25 — [fixture] make flags did not count"
  fresh_business "LAX_OPEN=1"
  probe "check 26 fires when ISSUE=1 issues a document holding an open item" "check 26 — [fixture] make pdf did not refuse"
  fresh_business "LAX_ISSUE=1"
  probe "check 27 fires when ISSUE=0 issues" "check 27 — [fixture] make pdf ISSUE=0"
  fresh_business "LAX_FORCE=1"
  probe "check 28 fires when FORCE=0 replaces an issued copy" "check 28 — [fixture] make pdf ISSUE=1 FORCE=0"
  fresh_business "FAIL_CLASS=1"
  probe "check 30 fires when a document calling \\houseclassification does not build" "check 30 — [fixture] a document calling"
  fresh_business "HEADLESS=1"
  probe "check 30 fires when a page lacks the classification" "check 30 — [fixture] \\houseclassification built, but page(s)"
  fresh_business "BLIND_BRAND=1"
  probe "check 32 fires when make flags reads no brand folder at all" "check 32 — [fixture] make flags listed no flag in standards/brand/"
  fresh_business "STICKY_BRAND=1"
  probe "check 32 fires when the default brand seeds still count with BRAND_DIRS set elsewhere" "check 32 — [fixture] make flags did not honour BRAND_DIRS = smoke-brand in tooling/project.mk (D43): the brand seeds' flags"
  fresh_business "NEWBLIND_BRAND=1"
  probe "check 32 fires when the folder BRAND_DIRS names is not read" "check 32 — [fixture] make flags did not honour BRAND_DIRS = smoke-brand in tooling/project.mk (D43): the flag in smoke-brand/"
  TOLATEX=(pandoc -f markdown -t latex --lua-filter tooling/pandoc/house.lua)
  MAKE_EXTRA=()
  st_finish "working tooling from broken tooling"
}

command -v make >/dev/null 2>&1 || die "make is not installed"
command -v python3 >/dev/null 2>&1 || die "python3 is not installed"
if $SELF_TEST; then
  self_test
  exit $?
fi
$REQUIRE_PANDOC && ! $HAVE_PANDOC && die "pandoc is not installed and --require-pandoc was given"
[[ ${#TARGETS[@]} -gt 0 ]] || die "no rendered tree given (see generate-all.sh)"

bold "▸ $SCRIPT_NAME (pandoc: $HAVE_PANDOC · xelatex: $HAVE_XELATEX$($SKIP_PDF && echo ' · pdf skipped'))"
STATUS=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  NAME="$(basename "$target")"
  work="$(sa_mktemp)"
  cp -a "$target" "$work/tree"
  smoke "$work/tree"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $NAME${SKIPS[*]:+ — skipped: ${SKIPS[*]}}"
    rm -rf "$work"
  else
    bold "✗ $NAME — ${#FINDINGS[@]} finding(s) (logs kept in $work/tree/.smoke-*.log):"
    print_findings
    [[ ${#SKIPS[@]} -gt 0 ]] && log "    skipped: ${SKIPS[*]}"
    STATUS=1
  fi
done
log ""
[[ "$STATUS" -eq 0 ]] && { bold "✓ Every target that could run in every render ran and produced its output."; exit 0; }
exit 1
