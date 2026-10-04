#!/usr/bin/env bash
#
# skill-conformance.sh — Verify every skill against DESIGN.md Section 5's contract.
#
#                        Skills are the only executable tier in a generated project (DESIGN.md
#                        D5: no agents, no commands), and a skill is chosen by its description
#                        alone. A description with no boundary competes for its neighbour's
#                        work; a body with no "Complete when" never knows it has finished; a
#                        shared skill without the mode paragraph never reads its mode file and
#                        applies one variant's procedure with no domain at all. Section 5 states
#                        the contract once; this script holds every skill to it, and holds each
#                        mode file to the four headings that let the procedure find its additions.
#
#                        Nineteen checks:
#                          1. The skill folder has a SKILL.md.
#                          2. Frontmatter opens on line 1 with --- and is closed.
#                          3. `name` equals the folder name.
#                          4. `description` is present and at most 1,024 characters.
#                          5. `description` states a boundary: Not … (`other-skill`).
#                          6. No frontmatter key beyond name, description, context, agent,
#                             background, model, metadata.
#                          7. `context: fork` carries `agent:` (Explore, Plan or general-purpose)
#                             and `background:`.
#                          8. The H1 reads `# Skill: <Name> (<project name token>)`.
#                          9. The locale line: Locale: en_GB · <timezone token> · dates DD/MM/YYYY.
#                         10. `## Governing procedures (route here — do not restate at length)`.
#                         11. Every step ends with a "Complete when:" (and there is a step).
#                         12. `## Anti-patterns`.
#                         13. `## Cross-references` is the last H2.
#                         14. A moded skill carries the mode paragraph verbatim, before step 1.
#                         15. A mode file's H2s are exactly: Paths and unit · Additions to the
#                             steps · Domain rules · Examples.
#                         16. The mode files match DESIGN.md: in template/, every mode a moded
#                             skill names and no other; in a render, exactly one; an unmoded skill
#                             carries none.
#                         17. SKILL.md plus its longest mode file stays within 300 lines.
#                         18. No .claude/agents/ or .claude/commands/ folder exists.
#                         19. The skill is one DESIGN.md Section 5 names.
#
#                        Run on template/ (the default) the H1 and locale line must carry the
#                        literal PROJECT_NAME and TIMEZONE tokens; on a render, any value.
#
#                        Numbers are stable identifiers. Append, never renumber.
#
#                        What it CANNOT check: that a description's triggers are the right ones,
#                        or that a mode file's domain rules agree with its standard. Those are a
#                        reviewer's; this proves the shape that lets a reviewer find them.
#
# SELF-TEST. --self-test writes a conformant moded skill and an unmoded one at runtime, proves
#            them clean, then applies one mutation per check and asserts exactly one finding.
#
# Requirements: bash 4+, awk, grep, sed. No network.
#
# Usage: skill-conformance.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]
#        With no tree, checks template/ in the repository.
#
# Exit codes:  0 = every skill conforms
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="skill-conformance.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
skill-conformance.sh — Verify every skill against DESIGN.md Section 5's contract

Usage: skill-conformance.sh [--root DIR] [--quiet] [--self-test] [--help] [<tree>...]

  <tree>       A render (default: template/ in the repository)
  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against skills written at runtime
  --help       Show this message

Exit codes: 0 = conforms  1 = finding(s), or the self-test no longer separates
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
SOURCE=true
SKILLS_SEEN=0
GOVERNING='## Governing procedures (route here — do not restate at length)'
MODE_H2='Paths and unit|Additions to the steps|Domain rules|Examples'
MODE_PARA='**Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.'
ALLOWED_KEYS=" name description context agent background model metadata "
FORK_AGENTS=" Explore Plan general-purpose "
declare -A CAT_GATE=() CAT_MODES=()
while read -r s g m; do [[ -n "$s" ]] && { CAT_GATE["$s"]="$g"; CAT_MODES["$s"]="$m"; }; done <<< "$SA_SKILLS"

frontmatter() { awk 'NR == 1 && $0 != "---" { exit } NR == 1 { next } /^---[[:space:]]*$/ { exit } { print }' "$1"; }
fm_closed()   { awk 'NR == 1 && $0 != "---" { exit 1 } NR > 1 && /^---[[:space:]]*$/ { found = 1; exit } END { exit !found }' "$1"; }
# Fenced lines (fences included) print as blank lines, so line numbers match the file and
# steps_of() agrees with mode_para_line(), which reads the file itself.
unfenced()    { awk '/^[[:space:]]*```/ { f = !f; print ""; next } f { print ""; next } { print }' "$1"; }

# The description as one string: inline, or a folded/literal block joined with spaces.
description_of() { # stdin = frontmatter
  awk '
    /^description:/ {
      v = $0; sub(/^description:[ \t]*/, "", v)
      if (v ~ /^[>|][-+]?[ \t]*$/) { block = 1; next }
      gsub(/^["\047]|["\047]$/, "", v); print v; done = 1; exit
    }
    block && /^[ \t]+/ { l = $0; sub(/^[ \t]+/, "", l); out = out (out == "" ? "" : " ") l; next }
    block { print out; done = 1; exit }
    END { if (!done && block && out != "") print out }'
}

# Steps: numbered items opening with bold, or numbered headings, outside the three closing
# sections. Prints "S<TAB>line<TAB>title<TAB>0|1" per step (1 = carries Complete when).
steps_of() {
  unfenced "$1" | awk '
    function close_step() { if (open) print "S\t" sline "\t" stitle "\t" complete; open = 0 }
    /^## / {
      close_step()
      excluded = ($0 ~ /^## (Governing procedures|Anti-patterns|Cross-references)/)
      if (!excluded && $0 ~ /^## (Step )?[0-9]+[.:)]? /) { open = 1; sline = NR; stitle = substr($0, 4); complete = 0 }
      next
    }
    excluded { next }
    /^### (Step )?[0-9]+[.:)]? / || /^[0-9]+\. \*\*/ { close_step(); open = 1; sline = NR; stitle = substr($0, 1, 50); complete = 0 }
    open && /Complete when:/ { complete = 1 }
    END { close_step() }'
}

mode_para_line() { # line number where the verbatim mode paragraph starts, or nothing
  awk -v want="$MODE_PARA" '
    function flush() { if (buf != "") { gsub(/[ \t]+/, " ", buf); sub(/^ /, "", buf); sub(/ $/, "", buf); if (buf == want) { print start; found = 1; exit } } buf = "" }
    /^[ \t]*>?[ \t]*$/ { flush(); next }
    { l = $0; sub(/^[ \t]*> ?/, "", l); if (buf == "") start = NR; buf = buf " " l }
    END { if (!found) flush() }' "$1"
}

check_skill() { # $1 = folder name
  local s="$1" dir="$TREE/.claude/skills/$1" f fm desc k v n h2 last mode modes have want first_step para total longest
  f="$dir/SKILL.md"
  SKILLS_SEEN=$((SKILLS_SEEN + 1))
  [[ -n "${CAT_GATE[$s]:-}" ]] || finding "check 19 — .claude/skills/$s is not a skill DESIGN.md Section 5 names"
  if [[ ! -f "$f" ]]; then finding "check 1 — .claude/skills/$s/ has no SKILL.md"; return 0; fi

  # ── 2–7. Frontmatter ────────────────────────────────────────────────────────
  if ! fm_closed "$f"; then
    finding "check 2 — $s/SKILL.md frontmatter does not open on line 1 with --- and close"
  else
    fm="$(frontmatter "$f")"
    v="$(awk '/^name:/ { v = $0; sub(/^name:[ \t]*/, "", v); gsub(/["\047]/, "", v); print v; exit }' <<< "$fm")"
    [[ "$v" == "$s" ]] || finding "check 3 — $s/SKILL.md says name: '${v}'; the folder is $s"
    desc="$(description_of <<< "$fm")"
    if [[ -z "$desc" ]]; then finding "check 4 — $s/SKILL.md has no description"
    elif [[ ${#desc} -gt 1024 ]]; then finding "check 4 — $s/SKILL.md description is ${#desc} characters; the limit is 1,024"; fi
    if [[ -n "$desc" ]] && ! grep -qE 'Not .*\(`[a-z0-9-]+`\)' <<< "$desc"; then
      finding "check 5 — $s/SKILL.md description states no boundary of the form Not … (\`other-skill\`)"
    fi
    while IFS= read -r k; do
      [[ "$ALLOWED_KEYS" == *" $k "* ]] || finding "check 6 — $s/SKILL.md frontmatter carries '$k', which this template does not admit"
    done < <(grep -oE '^[A-Za-z][A-Za-z0-9_-]*:' <<< "$fm" | tr -d ':')
    if grep -qE '^context:[[:space:]]*fork' <<< "$fm"; then
      v="$(awk '/^agent:/ { v = $0; sub(/^agent:[ \t]*/, "", v); print v; exit }' <<< "$fm")"
      [[ -n "$v" && "$FORK_AGENTS" == *" $v "* ]] || finding "check 7 — $s/SKILL.md forks without an admitted agent: (Explore, Plan or general-purpose)"
      grep -q '^background:' <<< "$fm" || finding "check 7 — $s/SKILL.md forks without background:"
    fi
  fi

  # ── 8–13. Body ──────────────────────────────────────────────────────────────
  if $SOURCE; then
    grep -qE '^# Skill: .+ \(<%PROJECT_NAME%>\)$' "$f" || finding "check 8 — $s/SKILL.md has no H1 '# Skill: <Name> (<%PROJECT_NAME%>)'"
    grep -qE 'Locale:.*en_GB.*<%TIMEZONE%>.*DD/MM/YYYY' "$f" || finding "check 9 — $s/SKILL.md has no locale line (en_GB · <%TIMEZONE%> · dates DD/MM/YYYY)"
  else
    grep -qE '^# Skill: .+ \(.+\)$' "$f" || finding "check 8 — $s/SKILL.md has no H1 '# Skill: <Name> (<project>)'"
    grep -qE 'Locale:.*en_GB.*DD/MM/YYYY' "$f" || finding "check 9 — $s/SKILL.md has no locale line (en_GB · timezone · dates DD/MM/YYYY)"
  fi
  grep -qxF "$GOVERNING" "$f" || finding "check 10 — $s/SKILL.md has no '$GOVERNING'"
  n=0; first_step=""
  while IFS=$'\t' read -r _ line title complete; do
    [[ -z "$line" ]] && continue
    n=$((n + 1)); [[ -z "$first_step" ]] && first_step="$line"
    [[ "$complete" == 1 ]] || finding "check 11 — $s/SKILL.md step '${title:0:40}' (line $line) has no 'Complete when:'"
  done < <(steps_of "$f")
  [[ "$n" -gt 0 ]] || finding "check 11 — $s/SKILL.md has no numbered steps"
  h2="$(unfenced "$f" | grep '^## ' | sed 's/[[:space:]]*$//')"
  grep -qx '## Anti-patterns' <<< "$h2" || finding "check 12 — $s/SKILL.md has no '## Anti-patterns'"
  last="$(tail -1 <<< "$h2")"
  [[ "$last" == '## Cross-references' ]] || finding "check 13 — $s/SKILL.md does not end with '## Cross-references' (last H2: '${last}')"

  # ── 14–17. Modes ────────────────────────────────────────────────────────────
  modes="${CAT_MODES[$s]:--}"
  have=()
  for mode in $SA_MODE_FILES; do [[ -f "$dir/$mode" ]] && have+=("$mode"); done
  if [[ "$modes" != - || ${#have[@]} -gt 0 ]]; then
    para="$(mode_para_line "$f")"
    if [[ -z "$para" ]]; then finding "check 14 — $s/SKILL.md is moded but does not carry the mode paragraph verbatim (DESIGN.md Section 5)"
    elif [[ -n "$first_step" && "$para" -gt "$first_step" ]]; then finding "check 14 — $s/SKILL.md carries the mode paragraph after step 1"; fi
  fi
  longest=0
  for mode in "${have[@]}"; do
    h2="$(unfenced "$dir/$mode" | grep '^## ' | sed 's/^## //; s/[[:space:]]*$//' | paste -sd'|' -)"
    [[ "$h2" == "$MODE_H2" ]] || finding "check 15 — $s/$mode has H2s '${h2:-none}'; expected '$MODE_H2'"
    n="$(wc -l < "$dir/$mode")"; [[ "$n" -gt "$longest" ]] && longest="$n"
  done
  if [[ "$modes" == - ]]; then
    [[ ${#have[@]} -eq 0 ]] || finding "check 16 — $s is unmoded (DESIGN.md Section 5) but carries ${have[*]}"
  elif $SOURCE; then
    want="$(modes_list "$modes")"
    for mode in $want; do [[ -f "$dir/$mode" ]] || finding "check 16 — $s is moded but $mode is missing"; done
    for mode in "${have[@]}"; do [[ " $want " == *" $mode "* ]] || finding "check 16 — $s carries $mode, a mode DESIGN.md does not give it"; done
  else
    [[ ${#have[@]} -eq 1 ]] || finding "check 16 — $s carries ${#have[@]} mode file(s) in a render; exactly one ships"
  fi
  total=$(( $(wc -l < "$f") + longest ))
  [[ "$total" -le 300 ]] || finding "check 17 — $s/SKILL.md plus its longest mode file is $total lines; the cap is 300"
}

run_checks() {
  FINDINGS=()
  SKILLS_SEEN=0
  local d
  for d in agents commands; do
    [[ -e "$TREE/.claude/$d" ]] && finding "check 18 — .claude/$d/ exists; this template ships skills only (DESIGN.md D5)"
  done
  [[ -d "$TREE/.claude/skills" ]] || return 0
  while IFS= read -r d; do check_skill "$d"; done \
    < <(find "$TREE/.claude/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | LC_ALL=C sort)
}

# ── Self-test ────────────────────────────────────────────────────────────────

write_skill() { # $1 = dir, $2 = name, $3 = moded (true|false)
  local d="$1" s="$2"
  mkdir -p "$d"
  {
    printf -- '---\nname: %s\ndescription: >-\n  Do one job well, on the author'"'"'s word. Use when asked to %s. Not for proofreading\n  (`spelling`).\n---\n\n' "$s" "$s"
    printf '# Skill: %s (<%%PROJECT_NAME%%>)\n\nLocale: en_GB · <%%TIMEZONE%%> · dates DD/MM/YYYY.\n\n' "$s"
    printf '%s\n\n- `.claude/rules/syntek-author/03-authorship.md`\n\n' "$GOVERNING"
    if [[ "$3" == true ]]; then
      printf '> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of\n'
      printf '> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain\n'
      printf '> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they\n'
      printf '> disagree, the procedure wins and the disagreement is reported to the author.\n\n'
    fi
    printf '## Steps\n\n1. **Read the brief.** Read it. *Complete when:* it is read.\n'
    printf '2. **Do the work.** Do it. *Complete when:* it is done.\n\n'
    printf '## Anti-patterns\n\n- Rewriting what was not asked for.\n\n## Cross-references\n\n- `.claude/rules/syntek-author/02-skills.md`\n'
  } > "$d/SKILL.md"
  if [[ "$3" == true ]]; then
    for m in $SA_MODE_FILES; do
      printf '# %s — %s\n\n## Paths and unit\n\nx\n\n## Additions to the steps\n\nx\n\n## Domain rules\n\nx\n\n## Examples\n\nx\n' "$m" "$s" > "$d/$m"
    done
  fi
}

self_test() {
  local tmp sk ds gm
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  TREE="$tmp/template"; SOURCE=true
  sk="$TREE/.claude/skills"; ds="$sk/draft-section"; gm="$sk/grill-me"
  write_skill "$ds" draft-section true
  write_skill "$gm" grill-me false
  st_baseline "a moded and an unmoded skill, both conformant"

  # Shapes the checks must not flag: a block description read once (not twice, which doubled
  # its length), and a fenced block above the mode paragraph (line numbers must still agree).
  cp "$gm/SKILL.md" "$tmp/h"
  sed -i "s/^  Do one job well/  $(printf 'word %.0s' $(seq 1 110))Do one job well/; s/^  (\`spelling\`)\.\$/&\nmodel: opus/" "$gm/SKILL.md"
  probe_clean "a 670-character block description followed by a key is read once and passes check 4"; cp "$tmp/h" "$gm/SKILL.md"
  cp "$ds/SKILL.md" "$tmp/h"
  awk -v blk="$(printf '```text\n%s\n```' "$(seq 1 12)")" '/^> \*\*Mode\./ && !d { print blk; print ""; d = 1 } { print }' "$tmp/h" > "$ds/SKILL.md"
  probe_clean "a fenced block above the mode paragraph keeps steps and paragraph on the same numbering"; cp "$tmp/h" "$ds/SKILL.md"

  mv "$gm/SKILL.md" "$tmp/h"; probe "check 1 fires on a skill with no SKILL.md" "check 1"; mv "$tmp/h" "$gm/SKILL.md"
  cp "$gm/SKILL.md" "$tmp/h"
  sed -i '1d' "$gm/SKILL.md";                                  probe "check 2 fires on frontmatter that does not open" "check 2"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^name: grill-me/name: grillme/' "$gm/SKILL.md";    probe "check 3 fires on a name that is not the folder" "check 3"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i "s/^  Do one job well/  $(printf 'word %.0s' $(seq 1 210))Do one job well/" "$gm/SKILL.md"; probe "check 4 fires on a description over 1,024 characters" "check 4"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/Not for proofreading/For proofreading/' "$gm/SKILL.md"; probe "check 5 fires on a description with no boundary" "check 5"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^name: grill-me/name: grill-me\neffort: high/' "$gm/SKILL.md"; probe "check 6 fires on a key the template does not admit" "check 6"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^name: grill-me/name: grill-me\ncontext: fork\nbackground: false/' "$gm/SKILL.md"; probe "check 7 fires on a fork with no agent" "check 7"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^# Skill: grill-me .*/# grill-me/' "$gm/SKILL.md"; probe "check 8 fires on the wrong H1" "check 8"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i '/^Locale:/d' "$gm/SKILL.md";                         probe "check 9 fires on a missing locale line" "check 9"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^## Governing procedures.*/## Governing procedures/' "$gm/SKILL.md"; probe "check 10 fires on a shortened governing heading" "check 10"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/Do it\. \*Complete when:\* it is done\./Do it./' "$gm/SKILL.md"; probe "check 11 fires on a step with no Complete when" "check 11"; cp "$tmp/h" "$gm/SKILL.md"
  sed -i 's/^## Anti-patterns/## Pitfalls/' "$gm/SKILL.md";   probe "check 12 fires on a missing Anti-patterns" "check 12"; cp "$tmp/h" "$gm/SKILL.md"
  printf '\n## Notes\n\nA trailing section.\n' >> "$gm/SKILL.md"; probe "check 13 fires when Cross-references is not last" "check 13"; cp "$tmp/h" "$gm/SKILL.md"
  cp "$ds/SKILL.md" "$tmp/h"
  sed -i 's/^> disagree, the procedure wins/> disagree, the mode wins/' "$ds/SKILL.md"; probe "check 14 fires on an edited mode paragraph" "check 14"; cp "$tmp/h" "$ds/SKILL.md"
  cp "$ds/FICTION.md" "$tmp/h"
  sed -i 's/^## Domain rules/## Rules/' "$ds/FICTION.md";     probe "check 15 fires on a renamed mode H2" "check 15"; cp "$tmp/h" "$ds/FICTION.md"
  mv "$ds/BUSINESS.md" "$tmp/h";                               probe "check 16 fires on a missing mode file" "check 16"; mv "$tmp/h" "$ds/BUSINESS.md"
  cp "$ds/SKILL.md" "$tmp/h"
  seq 1 290 | sed 's/^/- cross-reference /' >> "$ds/SKILL.md"; probe "check 17 fires when a skill and its mode pass 300 lines" "check 17"; cp "$tmp/h" "$ds/SKILL.md"
  mkdir -p "$TREE/.claude/agents";                             probe "check 18 fires on an agents folder" "check 18"; rmdir "$TREE/.claude/agents"
  write_skill "$sk/invented-skill" invented-skill false;       probe "check 19 fires on a skill DESIGN.md does not name" "check 19"; rm -rf "$sk/invented-skill"

  st_finish "conformant skills from broken ones"
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
  SOURCE=false; [[ "$TREE" == "$(cd "$SA_ROOT/template" 2>/dev/null && pwd)" ]] && SOURCE=true
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 && "$SKILLS_SEEN" -eq 0 ]]; then
    log "  ✓ $TREE — no skill folder under .claude/skills/: nothing to check (clean by absence, not by inspection)"
  elif [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $TREE — $SKILLS_SEEN skill(s) conform"
  else
    bold "✗ $TREE — ${#FINDINGS[@]} finding(s) across $SKILLS_SEEN skill(s):"
    print_findings
    STATUS=1
  fi
done
log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ Every skill meets DESIGN.md Section 5's contract."
  exit 0
fi
log "  The contract: DESIGN.md Section 5 (frontmatter, body, the mode paragraph, the four mode H2s)."
exit 1
