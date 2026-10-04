#!/usr/bin/env bash
#
# v0.2.0-project-settings.sh — carry the author's brief values into 00-project.md, and name the
#                              seed lines that still give v0.1.0's guidance.
#
# Template v0.2.0 moved every project-specific value the rules and skills read into one
# project-owned seed, .claude/rules/syntek-author/00-project.md (DESIGN.md D40), and they now
# read it from `## Brief` alone. An update from v0.1.0 writes that seed from the Copier
# answers. But v0.1.0 told the author to keep the brief current in .claude/CLAUDE.md Section 1
# (with the reader test also in .claude/MEMORY.md, the trading name in
# standards/brand/disclaimers.md and the currency, jurisdiction and Bible translation in the
# style sheet's `## Project settings`), and those files are seeds the update never rewrites.
# So an audience, reader test, Bible translation, genre, trading name, voice, jurisdiction or
# currency the author changed there silently reverts to the old answer. No conflict, no
# error, update reports success. This script, in every variant:
#
#   1. For each `## Brief` bullet (Audience, Reader test, Bible translation, Genre, Trading
#      name, Voice, Jurisdiction, Currency), collects the same-named values from those four
#      sources. Where the bullet still equals the recorded answer and the sources hold exactly
#      one other value, it writes that value into `## Brief` and prints the change. Every
#      other value that differs from `## Brief` is listed with file:line, never written.
#      An answer the author gave DURING this update is never overwritten: where the recorded
#      answer differs from the one in the answers file before the project crossed v0.2.0 (the
#      newest committed version whose `_commit` names an earlier release), `## Brief` keeps the
#      fresh answer and each older value in those files (a hand edit, or the old answer) is
#      listed as a conflict with file:line.
#   2. Lists, with file:line and the v0.2.0 text that replaces it, every line in a seed the
#      author already has that still gives v0.1.0's guidance: a numbered section of
#      .claude/CLAUDE.md cited anywhere; 'eight files' and 'never edit them' in
#      .claude/CLAUDE.md; 'never edit' on the rules tree line of CONTEXT.md and
#      .claude/CONTEXT.md; 'Never edit .claude/rules/syntek-author/' in README.md; the
#      reader-test pointer in MEMORY.md; the trading-name pointer in brand-voice.md; and
#      'change them here' in the style sheet's `## Project settings`. Lines are matched by
#      pattern, so a line the author has reworded since v0.1.0 is still found. None is
#      rewritten: each is a seed, and what the author wrote around it is theirs.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v0.2.0, after the
# update has written the new tree. Safe to run again from the project root; it is idempotent
# (a value it wrote is no longer the answer, so it is never written twice, and the answers from
# before v0.2.0 are read from git history, so a re-answered setting stays re-answered after the
# upgrade is committed). The command it prints at the end clones the release and runs it.
#
# WHAT IT NEVER DOES:
#   - change any file but 00-project.md, and in it any line but a `## Brief` bullet that still
#     reads the recorded answer;
#   - guess: two different values for one setting are both listed, and `## Brief` keeps its own;
#   - overwrite an answer the author gave during the update itself (`copier update --data`, or
#     a changed answer at the prompt) with an older hand edit: that is listed as a conflict;
#   - act before the update delivered 00-project.md (its marker): run by hand on a v0.1.0
#     project, it prints nothing and changes nothing;
#   - read a git-ignored file (DESIGN.md D42): every file it reads is one git tracks or would
#     track (outside a git work tree, every file);
#   - fail the update: it always exits 0, because a non-zero exit aborts every migration
#     declared after it and leaves the project half-upgraded.
#
# Exit codes:  0 = always

set -uo pipefail

case "${1:-}" in
  -h | --help)
    sed -n '3,/^# Exit codes/p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

ANSWERS=".copier-answers.syntek-author.yml"
SETTINGS=".claude/rules/syntek-author/00-project.md"
SCRIPT_BASENAME="v0.2.0-project-settings.sh"
MAX_LIST=60

[[ -f "$ANSWERS" && -f "$SETTINGS" ]] || exit 0

IN_GIT=false
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && IN_GIT=true

# ── What may be read (D42) ───────────────────────────────────────────────────

declare -A READABLE=()
declare -a SCAN=()
if $IN_GIT; then
  mapfile -t SCAN < <(git ls-files -co --exclude-standard 2>/dev/null | LC_ALL=C sort -u)
else
  mapfile -t SCAN < <(find . -name .git -prune -o -type f -print 2>/dev/null | sed 's#^\./##' | LC_ALL=C sort)
fi
for f in "${SCAN[@]}"; do READABLE["$f"]=1; done
readable() { [[ -n "${READABLE[$1]:-}" && -f "$1" ]]; }

readable "$SETTINGS" || exit 0

# ── The recorded answers ─────────────────────────────────────────────────────

# $1 = key, answers on stdin → its scalar value as YAML wrote it: a plain scalar folded over
# indented lines, or a single- or double-quoted one. Empty if the key is absent.
answer_from() {
  awk -v key="$1" '
    on && /^[ \t]+[^ \t]/ { l = $0; sub(/^[ \t]+/, "", l); v = v " " l; next }
    on { exit }
    $0 ~ "^" key ":" { v = $0; sub("^" key ":[ \t]*", "", v); on = 1; next }
    END {
      if (!on) exit
      sub(/[ \t]+$/, "", v)
      q = substr(v, 1, 1)
      if (q == "\047") { v = substr(v, 2); sub(/\047$/, "", v); gsub(/\047\047/, "\047", v) }
      else if (q == "\"") { v = substr(v, 2); sub(/"$/, "", v); gsub(/\\"/, "\"", v); gsub(/\\\\/, "\\", v) }
      print v
    }' 2>/dev/null
}
answer() { answer_from "$1" < "$ANSWERS"; } # $1 = key → its value in the answers file now

# The answers as they stood before the project crossed v0.2.0: the newest committed answers file
# whose `_commit` names an earlier release. During the update that is HEAD's (copier update
# refuses a dirty tree, so HEAD is the commit it started from); on a run by hand after the
# upgrade was committed, it is found further back. Empty outside git, or with no such commit.
BASE=""
before_v020() { local re='^v?0\.[01]\.[0-9]'; [[ "$1" =~ $re ]]; }
if $IN_GIT; then
  while IFS= read -r c; do
    body="$(git show "$c:$ANSWERS" 2>/dev/null)" || continue
    if before_v020 "$(answer_from _commit <<< "$body")"; then BASE="$body"; break; fi
  done < <(git log --format=%H -n 200 -- "$ANSWERS" 2>/dev/null)
fi

# The command that runs this script again: a fresh clone of the release it belongs to.
rerun_cmd() { # $1 = script basename
  # shellcheck disable=SC2016  # ${TMPDIR:-/tmp} is printed for the author's shell, not expanded
  local src dir='"${TMPDIR:-/tmp}/syntek-author-v0.2.0"'
  src="$(answer _src_path)"
  case "$src" in
    gh:*) src="https://github.com/${src#gh:}"; src="${src%.git}.git" ;;
    gl:*) src="https://gitlab.com/${src#gl:}"; src="${src%.git}.git" ;;
  esac
  if [[ -z "$src" ]]; then
    src='<the syntek-author repository>'
  elif [[ ! "$src" =~ ^[A-Za-z0-9_./:@~+=-]+$ ]]; then
    src="'${src//\'/\'\\\'\'}'"
  fi
  # A clone left by an earlier run is reused: both v0.2.0 scripts print the same folder.
  printf '{ test -d %s || git clone --depth 1 --branch v0.2.0 %s %s; } && bash %s/migrations/%s' \
    "$dir" "$src" "$dir" "$dir" "$1"
}

# ── Reading a bold-led bullet ────────────────────────────────────────────────
#
# `- **Label:** value`, `- **Label** (a note): value` and `**Label**: value` all split into the
# label (without its colon), the prefix up to the value, and the value.

BL_PREFIX=""; BL_LABEL=""; BL_VALUE=""
bullet_split() { # $1 = line; returns 1 if it is not a bold-led line
  local re='^((- )?\*\*([^*]+)\*\*[[:space:]]*(\([^)]*\))?[[:space:]]*:?[[:space:]]*)(.*)$'
  [[ "$1" =~ $re ]] || return 1
  BL_PREFIX="${BASH_REMATCH[1]}"; BL_LABEL="${BASH_REMATCH[3]}"; BL_VALUE="${BASH_REMATCH[5]}"
  BL_LABEL="${BL_LABEL%:}"
  return 0
}

norm() { # $1 = value → comments dropped, whitespace collapsed and trimmed
  local v="$1"
  v="$(sed -E 's/<!--.*-->//g; s/[[:space:]]+/ /g; s/^ //; s/ $//' <<< "$v")"
  printf '%s' "$v"
}

# Each setting: its `## Brief` label, its Copier answer, and how the answer reads in the brief.
LABELS=("Audience" "Reader test" "Bible translation" "Genre" "Trading name" "Voice" "Jurisdiction" "Currency")
declare -A KEY=(
  ["Audience"]=AUDIENCE ["Reader test"]=READER_TEST ["Bible translation"]=BIBLE_TRANSLATION
  ["Genre"]=FICTION_GENRE ["Trading name"]=TRADING_NAME ["Voice"]=BUSINESS_VOICE_PERSON
  ["Jurisdiction"]=JURISDICTION ["Currency"]=CURRENCY
)
answer_as_brief() { # $1 = label → the answer as `## Brief` renders it
  local v
  v="$(answer "${KEY[$1]}")"
  [[ -n "$v" ]] || return 0
  if [[ "$1" == Voice ]]; then
    case "$v" in plural) v="first person plural ('we')" ;; *) v="first person singular ('I')" ;; esac
  fi
  norm "$v"
}
# True when the author gave this setting a new answer during the update: it was recorded
# before v0.2.0, and the answer recorded now differs. A question first asked by v0.2.0 is not.
reanswered() { # $1 = label
  local k="${KEY[$1]}" was
  [[ -n "$BASE" ]] || return 1
  grep -q "^$k:" <<< "$BASE" || return 1
  was="$(answer_from "$k" <<< "$BASE")"
  [[ "$(norm "$was")" != "$(norm "$(answer "$k")")" ]]
}
brief_norm() { # $1 = label, $2 = raw value → comparable
  local v
  v="$(norm "$2")"
  [[ "$1" == "Bible translation" ]] && { v="${v#citation key }"; v="${v//\`/}"; }
  printf '%s' "$v"
}

# Sources: "label<TAB>file:line<TAB>value", one per line.
declare -a SRC=()
add_src() { SRC+=("$1"$'\t'"$2"$'\t'"$(brief_norm "$1" "$3")"); }

# .claude/CLAUDE.md, the bullets of '## 1. Project' (v0.1.0 labels included).
if readable .claude/CLAUDE.md; then
  n=0; on=false
  while IFS= read -r line; do
    n=$((n + 1))
    if [[ "$line" =~ ^##[[:space:]] ]]; then
      if [[ "$line" =~ ^##[[:space:]]+(1\.[[:space:]]+)?Project[[:space:]]*$ ]]; then on=true; else on=false; fi
      continue
    fi
    $on || continue
    bullet_split "$line" || continue
    case "$BL_LABEL" in
      "Default Bible translation" | "Bible translation") add_src "Bible translation" ".claude/CLAUDE.md:$n" "$BL_VALUE" ;;
      "Jurisdiction and currency")
        add_src Jurisdiction ".claude/CLAUDE.md:$n" "${BL_VALUE%%;*}"
        [[ "$BL_VALUE" == *";"* ]] && add_src Currency ".claude/CLAUDE.md:$n" "${BL_VALUE#*;}"
        ;;
      Audience | "Reader test" | Genre | "Trading name" | Voice | Jurisdiction | Currency)
        add_src "$BL_LABEL" ".claude/CLAUDE.md:$n" "$BL_VALUE" ;;
    esac
  done < .claude/CLAUDE.md
fi

# .claude/MEMORY.md, a 'Reader test:' entry (not the seed's own instruction, not superseded).
RE_MEMORY='(^|[^[:alnum:]])Reader test:[[:space:]]*(.+)$'
if readable .claude/MEMORY.md; then
  n=0
  while IFS= read -r line; do
    n=$((n + 1))
    [[ "$line" == *'`Reader test:`'* || "$line" == *Superseded* ]] && continue
    plain="${line//\*\*/}"
    [[ "$plain" =~ $RE_MEMORY ]] || continue
    add_src "Reader test" ".claude/MEMORY.md:$n" "${BASH_REMATCH[2]}"
  done < .claude/MEMORY.md
fi

# standards/brand/disclaimers.md, its '**Trading name**' and '**Jurisdiction**' lines.
if readable standards/brand/disclaimers.md; then
  n=0
  while IFS= read -r line; do
    n=$((n + 1))
    [[ "$line" == '**'* ]] || continue
    bullet_split "$line" || continue
    case "$BL_LABEL" in
      "Trading name" | Jurisdiction) add_src "$BL_LABEL" "standards/brand/disclaimers.md:$n" "$BL_VALUE" ;;
    esac
  done < standards/brand/disclaimers.md
fi

# standards/style/style-sheet.md, '## Project settings' as v0.1.0 wrote it (a section that
# names 00-project.md is v0.2.0's, which holds no values).
STYLE=standards/style/style-sheet.md
RE_CURRENCY='^\*\*Currency\.\*\*[[:space:]]+([^,]+)'
RE_JURISDICTION='^\*\*Jurisdiction\.\*\*[[:space:]]+([^;]+)'
RE_SCRIPTURE='citation key is[[:space:]]+`([^`]+)`'
if readable "$STYLE"; then
  section="$(awk '/^## Project settings[[:space:]]*$/ { on = 1; next } on && /^## / { exit } on { print NR "\t" $0 }' "$STYLE")"
  if [[ -n "$section" && "$section" != *00-project.md* ]]; then
    while IFS=$'\t' read -r n line; do
      [[ "$line" =~ $RE_CURRENCY ]] && add_src Currency "$STYLE:$n" "${BASH_REMATCH[1]}"
      [[ "$line" =~ $RE_JURISDICTION ]] && add_src Jurisdiction "$STYLE:$n" "${BASH_REMATCH[1]%.}"
    done <<< "$section"
    # The citation key sits in the Scripture paragraph, often wrapped onto its next line.
    para="$(awk -F'\t' '$2 ~ /^\*\*Scripture\.\*\*/ { on = 1; first = $1 } on && $2 ~ /^[[:space:]]*$/ { exit } on { printf "%s ", $2 } END { if (on) printf "\t%s", first }' <<< "$section")"
    if [[ "$para" =~ $RE_SCRIPTURE ]]; then
      add_src "Bible translation" "$STYLE:${para##*$'\t'}" "${BASH_REMATCH[1]}"
    fi
  fi
fi

# ── Settle each setting against `## Brief` ───────────────────────────────────

declare -a CHANGED=() DIFFERS=() CONFLICTS=()
for label in "${LABELS[@]}"; do
  # The bullet in `## Brief`, if this variant has it.
  bline=""; bn=0; n=0; on=false
  while IFS= read -r line; do
    n=$((n + 1))
    if [[ "$line" =~ ^##[[:space:]] ]]; then [[ "$line" =~ ^##[[:space:]]+Brief[[:space:]]*$ ]] && on=true || on=false; continue; fi
    $on || continue
    bullet_split "$line" || continue
    [[ "$BL_LABEL" == "$label" ]] && { bline="$line"; bn=$n; break; }
  done < "$SETTINGS"
  [[ $bn -gt 0 ]] || continue
  bullet_split "$bline"
  prefix="$BL_PREFIX"
  brief="$(brief_norm "$label" "$BL_VALUE")"
  ans="$(answer_as_brief "$label")"
  [[ "$label" == "Bible translation" ]] && ans="${ans//\`/}"
  [[ -n "$ans" ]] || ans="$brief"

  # This setting's sources, and the distinct values that are not the answer.
  declare -a mine=()
  declare -A other=()
  for s in "${SRC[@]}"; do
    IFS=$'\t' read -r l loc v <<< "$s"
    [[ "$l" == "$label" && -n "$v" ]] || continue
    mine+=("$loc"$'\t'"$v")
    [[ "$v" != "$ans" ]] && other["$v"]+="${other[$v]:+, }$loc"
  done

  # An answer given during this update is the author's newest word: never written over.
  fresh=false
  reanswered "$label" && fresh=true

  if [[ "$brief" == "$ans" && ${#other[@]} -eq 1 ]] && ! $fresh; then
    for v in "${!other[@]}"; do :; done
    new="$v"
    [[ "$label" == "Bible translation" ]] && new="\`$v\`"
    tmp="$(mktemp 2>/dev/null)" || tmp=""
    if [[ -n "$tmp" ]] && NEWLINE="$prefix$new" LN="$bn" awk 'NR == ENVIRON["LN"] { print ENVIRON["NEWLINE"]; next } { print }' "$SETTINGS" > "$tmp" \
       && cat "$tmp" > "$SETTINGS"; then
      CHANGED+=("$label: '$ans' -> '$v' (from ${other[$v]})")
      brief="$v"
    else
      DIFFERS+=("$label — could not write '$v' into $SETTINGS:$bn; copy it there by hand (from ${other[$v]})")
    fi
    [[ -n "$tmp" ]] && rm -f "$tmp"
  fi

  # Every source that still differs from `## Brief`, written or not.
  block=""
  for m in "${mine[@]}"; do
    IFS=$'\t' read -r loc v <<< "$m"
    [[ "$v" == "$brief" ]] && continue
    block+=$'\n'"      $loc  '$v'"
  done
  if [[ -n "$block" ]] && $fresh && [[ "$brief" == "$ans" ]]; then
    CONFLICTS+=("$label — you answered '$ans' during this update, and \`## Brief\` keeps it ($SETTINGS:$bn); these still hold an older value:$block")
  elif [[ -n "$block" ]]; then
    DIFFERS+=("$label — \`## Brief\` says '$brief' ($SETTINGS:$bn); these differ:$block")
  fi
  unset mine other
done

# ── Seed lines that still give v0.1.0's guidance ─────────────────────────────

R_S1="the settings in \`.claude/rules/syntek-author/00-project.md\` \`## Brief\` (the brief itself stays in \`.claude/CLAUDE.md\`, under 'Project')"
R_S2="'Where the rules live' in \`.claude/CLAUDE.md\`"
R_S3="an override under \`## Overrides\` in \`.claude/rules/syntek-author/00-project.md\`, or a project rule under 'Project-specific rules' in \`.claude/CLAUDE.md\`"
R_SN="the heading's name, never its number (\`00-project.md\` \`## Paths\` says where each thing lives)"
R_EIGHT="The rules are the nine files in \`.claude/rules/syntek-author/\`: \`00-project.md\`, this project's settings (yours to edit), and the eight template-owned files from \`01-\` on."
R_NEVER="**The eight numbered files from \`01-\` on are template-owned: never edit them.** \`00-project.md\` is a seed: written once and never overwritten, so change it freely."
R_TREE="rules/syntek-author/ ← loaded at launch: 00-project.md (this project's settings; yours) and the template's rules (never edit)"
R_README="**Never edit the rules from \`01-\` to \`08-\` in \`.claude/rules/syntek-author/\`**, or any other file the template owns. Put settings and overrides in \`00-project.md\`, project rules under 'Project-specific rules' in \`.claude/CLAUDE.md\`."
R_MEMORY="Two facts belong here: \`Target length:\` and \`Delivery date:\`. The audience and reader test live in \`.claude/rules/syntek-author/00-project.md\` \`## Brief\`; change them there."
R_BRAND="the trading name, exactly as printed, is in \`.claude/rules/syntek-author/00-project.md\` \`## Brief\`"
R_STYLE="Their values are kept in \`.claude/rules/syntek-author/00-project.md\` \`## Brief\`; where this file and \`00-project.md\` differ, \`00-project.md\` wins."

declare -a STALE=()
declare -A SEEN=()
stale() { # $1 = file, $2 = line number, $3 = replacement
  local key="$1:$2" text
  [[ -n "${SEEN[$key]:-}" ]] && return 0
  SEEN["$key"]=1
  text="$(sed -n "${2}p" "$1" 2>/dev/null | sed -E 's/^[[:space:]]+//' | cut -c1-110)"
  STALE+=("$key  $text"$'\n'"        v0.2.0: $3")
}
grep_lines() { # $1 = file, then grep arguments → matching line numbers
  local f="$1"; shift
  readable "$f" || return 0
  grep -n "$@" -- "$f" 2>/dev/null | cut -d: -f1
}

# v0.2.0's own wording names 00-project.md beside the eight files, so such a line is current.
for n in $(grep_lines .claude/CLAUDE.md -F 'eight files'); do
  sed -n "${n}p" .claude/CLAUDE.md | grep -qF '00-project' || stale .claude/CLAUDE.md "$n" "$R_EIGHT"
done
for n in $(grep_lines .claude/CLAUDE.md -F 'never edit them'); do
  sed -n "${n}p" .claude/CLAUDE.md | grep -qF '01-' || stale .claude/CLAUDE.md "$n" "$R_NEVER"
done
for f in CONTEXT.md .claude/CONTEXT.md; do
  for n in $(grep_lines "$f" -i 'syntek-author/.*never edit'); do
    sed -n "${n}p" "$f" | grep -qF '00-project' || stale "$f" "$n" "$R_TREE"
  done
done
for n in $(grep_lines README.md -F 'Never edit `.claude/rules/syntek-author/`'); do stale README.md "$n" "$R_README"; done
for n in $(grep_lines .claude/MEMORY.md -E '`Reader test:`|CLAUDE\.md`? Section [0-9]'); do stale .claude/MEMORY.md "$n" "$R_MEMORY"; done
BV=standards/brand/brand-voice.md
if readable "$BV"; then
  while IFS= read -r n; do stale "$BV" "$n" "$R_BRAND"; done < <(awk '
    { line[NR] = $0 }
    END { for (i = 1; i <= NR; i++) if (tolower(line[i]) ~ /trading name/ && (line[i] ~ /disclaimers\.md/ || line[i + 1] ~ /disclaimers\.md/)) print i }' "$BV")
fi
for n in $(grep_lines "$STYLE" -F 'change them here'); do stale "$STYLE" "$n" "$R_STYLE"; done

# A numbered section of .claude/CLAUDE.md, cited anywhere git tracks or would track.
declare -a CITED=()
if [[ ${#SCAN[@]} -gt 0 ]]; then
  mapfile -t CITED < <(printf '%s\0' "${SCAN[@]}" | grep -zv '^\.copier-answers' \
    | xargs -0 grep -nHIoE 'CLAUDE\.md`? Section [0-9]+' -- 2>/dev/null || true)
fi
for c in "${CITED[@]}"; do
  f="${c%%:*}"; rest="${c#*:}"; n="${rest%%:*}"; num="${c##* }"
  case "$num" in 1) r="$R_S1" ;; 2) r="$R_S2" ;; 3) r="$R_S3" ;; *) r="$R_SN" ;; esac
  readable "$f" && stale "$f" "$n" "$r"
done

# ── Report ───────────────────────────────────────────────────────────────────

if [[ ${#CHANGED[@]} -eq 0 && ${#DIFFERS[@]} -eq 0 && ${#CONFLICTS[@]} -eq 0 && ${#STALE[@]} -eq 0 ]]; then
  exit 0
fi
printf '\n▸ v0.2.0 migration — project settings (DESIGN.md D40)\n'
printf '  The skills now read them from %s ## Brief alone.\n' "$SETTINGS"

if [[ ${#CHANGED[@]} -gt 0 ]]; then
  printf '\n  Copied into ## Brief, the one value you had set in place of the answer:\n\n'
  for c in "${CHANGED[@]}"; do printf '    changed  %s\n' "$c"; done
fi

if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  printf '\n  You answered these again during this update, so ## Brief keeps the new answer and nothing\n'
  printf '  was copied over it. Each file listed still holds an older value (a hand edit, or the old\n'
  printf '  answer): make it agree with ## Brief or, if the older value is the one you want, write it\n'
  printf '  into ## Brief in %s yourself:\n\n' "$SETTINGS"
  for c in "${CONFLICTS[@]}"; do printf '    conflict  %s\n' "$c"; done
fi

if [[ ${#DIFFERS[@]} -gt 0 ]]; then
  printf '\n  These still differ from ## Brief, and nothing was copied from them: two values competed,\n'
  printf '  ## Brief already had one of its own, or the file still holds the old answer. Decide each,\n'
  printf '  keep the value you want in %s,\n  and make the files listed agree:\n\n' "$SETTINGS"
  for d in "${DIFFERS[@]}"; do printf '    %s\n' "$d"; done
fi

if [[ ${#STALE[@]} -gt 0 ]]; then
  printf '\n  %d line(s) in seeds you already have still give v0.1.0'\''s guidance. An update never\n' "${#STALE[@]}"
  printf '  rewrites a seed, so change each by hand to say what v0.2.0 says:\n\n'
  i=0
  for s in "${STALE[@]}"; do
    i=$((i + 1))
    if [[ $i -gt $MAX_LIST ]]; then
      printf '    … and %d more\n' "$(( ${#STALE[@]} - MAX_LIST ))"
      break
    fi
    printf '    %s\n' "$s"
  done
fi

if [[ ${#CHANGED[@]} -gt 0 ]]; then
  printf '\n  This script changed only the ## Brief lines marked changed above, and only from a value you\n'
  printf '  had set yourself. Review with `git diff`, then commit. To run it again:\n'
else
  printf '\n  This script changed nothing. To run it again:\n'
fi
printf '    %s\n\n' "$(rerun_cmd "$SCRIPT_BASENAME")"
exit 0
