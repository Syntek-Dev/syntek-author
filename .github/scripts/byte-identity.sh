#!/usr/bin/env bash
#
# byte-identity.sh — Verify shared files are byte-identical in every render that ships them.
#
#                    DESIGN.md Section 2 ("Token discipline") makes one promise that holds
#                    the three variants together: outside the spine set, a file that ships in
#                    two variants is the SAME file in both. That is what lets a skill be fixed
#                    once, reviewed once and updated everywhere, and it is what makes
#                    "variant differences live in gated files and mode files" true rather than
#                    aspirational. check-template-tokens.sh polices the SOURCE for the tokens
#                    and blocks that would break the promise; this script checks the promise
#                    itself, on the renders — so a difference that arrives some other way (a
#                    Copier variable, a filter, a profile option leaking into a shared file) is
#                    caught where it actually shows.
#
#                    Two answers are not variants, and the promise holds across them too
#                    (DESIGN.md Section 7). The store (D50): a shared file reads the same under
#                    `external` and `repo`, so prose names the outcome in both and rules 09
#                    names the path. The provider (D53): DATA_PROVIDER opens one gate only,
#                    `.github/` in business with google-drive and repo, so two renders that
#                    differ in nothing else differ in nothing but their answers.
#
#                    Three checks:
#                      1. A file outside the spine set (and not a data-root file) differs
#                         between two renders that both ship it.
#                      2. A data-root file — the resolver, its map, or one of the three
#                         data-root ignore files — differs between two renders that both ship
#                         it (D50). Compared whatever the spine set says: the store, the
#                         variant and the options never change them.
#                      3. Two renders whose answers differ only in DATA_PROVIDER differ in
#                         anything but the answers file: a spine file's bytes, or a file one
#                         ships and the other does not (D53). The one exception is the gate
#                         the provider opens: where one render is business with google-drive
#                         and repo and the other is not, `.github/` ships in that render alone
#                         and a spine file may differ between the two only in hunks that name
#                         `.github` (each changed hunk of a line diff must). DATA_SLUG defaults to
#                         the render folder's name, so it is set aside with DATA_PROVIDER, and
#                         each render's slug is read as one placeholder in its spine files.
#                         Shared files need no such reading: a slug in one fails check 1.
#
#                    Compared: every file present in at least two renders. Skipped: .git/,
#                    the answers file (and any other template's beside it: a test may plant a
#                    sibling's record, which this template never renders), build/, audio/,
#                    __pycache__/ and tooling/references.db
#                    (generated after rendering, by `make init`), and, for check 1, the spine
#                    set — the root spine, every seed, every seed-once example and every index
#                    file (computed in _common.sh from DESIGN.md and copier.yml). The store axis
#                    is covered when the renders include a variant at both stores, and the
#                    provider axis when they include a variant under two providers with the
#                    same other answers (generate-all.sh renders both); the summary says which.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: the spine set itself. A spine file may differ, but
#                    only on lines whose template source carries a variant token or block;
#                    proving that needs a line-level map from render to source that Jinja does
#                    not provide. check-template-tokens.sh keeps the spine set small instead.
#                    For the same reason, where the drive gate differs between two renders,
#                    check 3 reads the diff, not the source: a gated line that is not about
#                    `.github/` passes where it sits in one hunk with a line that is. And a slug that is
#                    also a word of a spine file is read as the slug there too; generate-all.sh
#                    names its folders <variant>-<profile>, which no spine text carries.
#
# SELF-TEST. --self-test builds six small renders at runtime — theology at both stores and under
#            a second provider, fiction, and business at repo with and without Google Drive —
#            holding a shared file, the data-root files, spine files that legitimately differ
#            (a slug, a store, the Drive rows) and files only one render ships. It proves them
#            clean, then applies one mutation per check and asserts exactly one finding each:
#            check 2 also with the ignore file made a seed (still check 2 alone), check 3 on a
#            spine file, on the text either side of a slug, on a file one provider alone ships,
#            on `.github/` outside the Drive gate and a file outside `.github/` inside it, and on
#            a Drive-only line in a spine file that does not name `.github/`.
#
# Requirements: bash 4+, sha1sum, awk, sed, grep, find. No network.
#
# Usage: byte-identity.sh [--root DIR] [--quiet] [--self-test] [--help] <tree> <tree>...
#
# Exit codes:  0 = every shared file is identical wherever it ships
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (fewer than two trees, a tree that does not exist)

set -euo pipefail
SCRIPT_NAME="byte-identity.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false
TARGETS=()

usage() {
  cat <<'EOF'
byte-identity.sh — Verify shared files are byte-identical in every render that ships them

Usage: byte-identity.sh [--root DIR] [--quiet] [--self-test] [--help] <tree> <tree>...

  --root DIR   The template repository whose copier.yml defines the spine set
  --quiet      Print findings only
  --self-test  Prove the checks still fire against renders built at runtime
  --help       Show this message

Exit codes: 0 = identical  1 = finding(s), or the self-test no longer separates
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

TREES=()
NAMES=()
COMPARED=0
SPINE_SKIPPED=0
DATAROOT_COMPARED=0
PROVIDER_GROUPS=0
STORE_AXIS=""
declare -A SPINE=()

# The data-root files (DESIGN.md D50): token-free, template-owned, and the same in every render
# that ships them. Check 2 holds them to that even if a later catalogue made one spine.
DATAROOT_FILES=" $SA_DATAROOT_PY $SA_DATAROOT_MAP $SA_DATAROOT_IGNORES "
is_dataroot_file() { [[ "$DATAROOT_FILES" == *" $1 "* ]]; }

# The answers check 3 sets aside: the provider itself, and the slug, which defaults to the
# render folder's name and so differs between any two renders of one run.
PROVIDER_ASIDE='^(DATA_PROVIDER|DATA_SLUG):'
SLUG_PLACEHOLDER='<DATA_SLUG>'

hash_tree() { # $1 = index, $2 = tree → index<TAB>hash<TAB>rel
  (cd "$2" && find . \( -name .git -o -name build -o -name audio -o -name __pycache__ \) -prune -o -type f -print0 \
     | xargs -0 -r sha1sum) \
    | awk -v i="$1" '{ h = $1; $1 = ""; sub(/^ +/, ""); sub(/^\.\//, ""); print i "\t" h "\t" $0 }' \
    | grep -v -E -e $'\t\\.copier-answers[^/]*\\.yml$' -e $'\ttooling/references\\.db$' || true
}

idx_names() { # "0,2" → "a, c"
  local out="" idx
  for idx in ${1//,/ }; do out+="${out:+, }${NAMES[$idx]}"; done
  printf '%s' "$out"
}

group_names() { # "0,1|2" → "{a, b}  ≠  {c}" — tree indexes sharing one version, versions split by |
  local out="" g
  while IFS= read -r -d '|' g; do out+="${out:+  ≠  }{$(idx_names "$g")}"; done <<< "$1|"
  printf '%s' "$out"
}

# Checks 1 and 2: one line per file present in two or more renders, "rel<TAB>SAME" or
# "rel<TAB>0,1|2" (the indexes sharing each version).
VERSIONS_AWK='
  { key = $3; if (!(key in seen)) { seen[key] = 1; order[++n] = key }
    cnt[key]++
    if (!((key SUBSEP $2) in hv)) { hv[key SUBSEP $2] = ++nv[key] }
    v = hv[key SUBSEP $2]; mem[key, v] = mem[key, v] (mem[key, v] == "" ? "" : ",") $1 }
  END {
    for (k = 1; k <= n; k++) {
      key = order[k]
      if (cnt[key] < 2) continue
      if (nv[key] == 1) { print key "\tSAME"; continue }
      out = ""
      for (v = 1; v <= nv[key]; v++) out = out (v > 1 ? "|" : "") mem[key, v]
      print key "\t" out
    }
  }'

# Check 3. Input, in this order: M<TAB>group<TAB>tree<TAB>drive (each tree in a group of two or
# more), S<TAB>rel (each spine file), O<TAB>tree<TAB>rel<TAB>hash (a spine file's hash with the
# slugs read as one placeholder), R<TAB>tree<TAB>hash<TAB>rel (every record). Output:
# P<TAB>rel<TAB>have<TAB>lack for a file only some renders of a group ship, and
# D<TAB>rel<TAB>versions for a spine file that differs between renders of one drive state.
PROVIDER_AWK='
  BEGIN { FS = "\t" }
  $1 == "M" { grp[$3] = $2; drv[$3] = $4; gm[$2] = gm[$2] (gm[$2] == "" ? "" : " ") $3
              if ($4 == 1) nopen[$2]++; next }
  $1 == "S" { sp[$2] = 1; next }
  $1 == "O" { ov[$2 SUBSEP $3] = $4; next }
  $1 == "R" { t = $2; if (!(t in grp)) next
              g = grp[t]; rel = $4
              if (!((g SUBSEP rel) in seen)) { seen[g SUBSEP rel] = 1; n++; rg[n] = g; rr[n] = rel }
              h[t SUBSEP rel] = ((t SUBSEP rel) in ov) ? ov[t SUBSEP rel] : $3; next }
  END {
    for (k = 1; k <= n; k++) {
      g = rg[k]; rel = rr[k]
      m = split(gm[g], mem, " ")
      have = ""; lack = ""; po = 0; ps = 0
      for (x = 1; x <= m; x++) {
        t = mem[x]
        if ((t SUBSEP rel) in h) { have = have (have == "" ? "" : ",") t; if (drv[t] == 1) po++; else ps++ }
        else lack = lack (lack == "" ? "" : ",") t
      }
      if (lack != "") {
        # The one file a provider may add: .github/, in every render whose drive gate is open
        # and in none whose gate is shut.
        if (!(rel ~ /^\.github\// && po == nopen[g] + 0 && ps == 0)) print "P\t" rel "\t" have "\t" lack
        continue
      }
      if (!(rel in sp)) continue
      for (state = 0; state <= 1; state++) {
        split("", vid); nv = 0
        for (x = 1; x <= m; x++) {
          t = mem[x]; if (drv[t] + 0 != state) continue
          hv = h[t SUBSEP rel]
          if (!(hv in vid)) { vid[hv] = ++nv; vm[nv] = "" }
          v = vid[hv]; vm[v] = vm[v] (vm[v] == "" ? "" : ",") t
        }
        if (nv > 1) { out = ""; for (v = 1; v <= nv; v++) out = out (v > 1 ? "|" : "") vm[v]; print "D\t" rel "\t" out }
      }
      # Across the gate: one render of each state, for the shell to diff line by line.
      to = ""; ts = ""
      for (x = 1; x <= m; x++) { t = mem[x]; if (drv[t] == 1 && to == "") to = t; if (drv[t] != 1 && ts == "") ts = t }
      if (to != "" && ts != "" && h[to SUBSEP rel] != h[ts SUBSEP rel]) print "X\t" rel "\t" to "\t" ts
    }
  }'

# The hash of a file with every slug of its group read as one placeholder (check 3). A slug is
# kebab case (copier.yml's validator), so it is literal in a pattern; it is matched whole, and
# the loop takes adjacent occurrences.
slug_hash() { # $1 = file, $2 = slugs joined by |
  sed -E -e ':a' -e "s/(^|[^A-Za-z0-9_-])($2)([^A-Za-z0-9_-]|\$)/\\1${SLUG_PLACEHOLDER}\\3/" -e 'ta' "$1" \
    | sha1sum | cut -c1-40
}

# The hunks of a spine file that differ across the Drive gate without naming .github/ (check 3):
# each changed hunk of the Drive render against the other must name it, so a line the gate adds
# that is about anything else is found. The slugs are read as one placeholder first.
drive_hunks() { # $1 = the file where the gate is open, $2 = where it is shut, $3 = slugs joined by |
  local d f i=0
  d="$(mktemp -d "${TMPDIR:-/tmp}/byte-identity-XXXXXX")"
  for f in "$1" "$2"; do
    i=$((i + 1))
    if [[ -n "$3" ]]; then
      sed -E -e ':a' -e "s/(^|[^A-Za-z0-9_-])($3)([^A-Za-z0-9_-]|\$)/\1${SLUG_PLACEHOLDER}\3/" -e 'ta' "$f"
    else
      cat "$f"
    fi > "$d/$i"
  done
  diff "$d/2" "$d/1" | awk '/^[0-9]/ { if (n && !ok) bad = bad " " h; h = $0; n = 1; ok = 0; next }
    /^[<>]/ && index($0, ".github") { ok = 1 } END { if (n && !ok) bad = bad " " h; printf "%s", bad }' || true
  rm -rf "$d"
}

provider_axis() { # $1 = the records of every tree
  local recs="$1" i ans key slug t f rel alt
  local -a tdrive=() tslug=() grp=()
  local -A members=() stores=()
  PROVIDER_GROUPS=0; STORE_AXIS=""
  for i in "${!TREES[@]}"; do
    tdrive[i]=0; tslug[i]=""
    ans="${TREES[$i]}/$SA_ANSWERS_FILE"
    [[ -f "$ans" ]] || continue
    key="$({ grep -vE "$PROVIDER_ASIDE" "$ans" || true; } | sha1sum | cut -c1-40)"
    members["$key"]+="${members[$key]:+ }$i"
    if load_answers "$ans"; then
      if gate_true drive; then tdrive[i]=1; fi
      if [[ " ${stores[$A_DOC_TYPE]:-} " != *" $A_STORE "* ]]; then stores["$A_DOC_TYPE"]+=" $A_STORE"; fi
    fi
    slug="$(answer_value DATA_SLUG "$ans")"
    if [[ "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then tslug[i]="$slug"; fi
  done
  for t in theology fiction business; do
    if [[ " ${stores[$t]:-} " == *" external "* && " ${stores[$t]:-} " == *" repo "* ]]; then
      STORE_AXIS+="${STORE_AXIS:+, }$t"
    fi
  done

  local stream=""
  for key in "${!members[@]}"; do
    read -r -a grp <<< "${members[$key]}"
    [[ ${#grp[@]} -ge 2 ]] || continue
    PROVIDER_GROUPS=$((PROVIDER_GROUPS + 1))
    # The group's slugs, longest first, as one alternation.
    alt="$(for i in "${grp[@]}"; do printf '%s\n' "${tslug[$i]}"; done | sed '/^$/d' | sort -u \
           | awk '{ print length($0) "\t" $0 }' | sort -k1,1rn | cut -f2 | paste -sd'|')"
    for i in "${grp[@]}"; do
      stream+="M"$'\t'"$key"$'\t'"$i"$'\t'"${tdrive[$i]}"$'\n'
      [[ -n "$alt" ]] || continue
      while IFS= read -r -d '' f; do
        rel="${f#./}"
        [[ "${SPINE[$rel]:-0}" == 1 ]] || continue
        stream+="O"$'\t'"$i"$'\t'"$rel"$'\t'"$(slug_hash "${TREES[$i]}/$rel" "$alt")"$'\n'
      done < <(cd "${TREES[$i]}" && { grep -rlIZE --exclude-dir=.git --exclude-dir=build --exclude-dir=audio \
                 --exclude-dir=__pycache__ --exclude="$SA_ANSWERS_FILE" "(^|[^A-Za-z0-9_-])($alt)([^A-Za-z0-9_-]|\$)" . || true; })
    done
  done
  [[ "$PROVIDER_GROUPS" -gt 0 ]] || return 0

  local kind a b hunks
  while IFS=$'\t' read -r kind rel a b; do
    case "$kind" in
      P) finding "check 3 — $rel ships in {$(idx_names "$a")} and not in {$(idx_names "$b")}, whose answers differ only in DATA_PROVIDER" ;;
      D) finding "check 3 — $rel differs between renders whose answers differ only in DATA_PROVIDER: $(group_names "$a")" ;;
      X) hunks="$(drive_hunks "${TREES[$a]}/$rel" "${TREES[$b]}/$rel" "$(printf '%s\n' "${tslug[$a]}" "${tslug[$b]}" | sed '/^$/d' | sort -u | paste -sd'|')")"
         [[ -z "$hunks" ]] || finding "check 3 — $rel differs across the Drive gate in lines that do not name .github/ ($(idx_names "$a") against $(idx_names "$b"), at$hunks): only the gate's own lines may differ" ;;
    esac
  done < <({ printf '%s' "$stream"
             for rel in "${!SPINE[@]}"; do if [[ "${SPINE[$rel]}" == 1 ]]; then printf 'S\t%s\n' "$rel"; fi; done
             sed 's/^/R\t/' <<< "$recs"; } | awk "$PROVIDER_AWK")
}

run_checks() {
  FINDINGS=()
  COMPARED=0; SPINE_SKIPPED=0; DATAROOT_COMPARED=0
  SPINE=()
  local i rel groups recs
  NAMES=()
  for i in "${!TREES[@]}"; do NAMES+=("$(basename "${TREES[$i]}")"); done
  recs="$(for i in "${!TREES[@]}"; do hash_tree "$i" "${TREES[$i]}"; done)"
  # The spine set, once per file (a data-root file is never spine here: check 2 compares it).
  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    if ! is_dataroot_file "$rel" && spine_kind "$rel" >/dev/null; then SPINE["$rel"]=1; else SPINE["$rel"]=0; fi
  done < <(cut -f3 <<< "$recs" | sort -u)

  while IFS=$'\t' read -r rel groups; do
    [[ -z "$rel" ]] && continue
    if is_dataroot_file "$rel"; then
      DATAROOT_COMPARED=$((DATAROOT_COMPARED + 1))
      [[ "$groups" == SAME ]] || finding "check 2 — $rel (a data-root file) differs between renders: $(group_names "$groups")"
      continue
    fi
    if [[ "${SPINE[$rel]}" == 1 ]]; then SPINE_SKIPPED=$((SPINE_SKIPPED + 1)); continue; fi
    COMPARED=$((COMPARED + 1))
    [[ "$groups" == SAME ]] || finding "check 1 — $rel differs between renders: $(group_names "$groups")"
  done < <(awk -F'\t' "$VERSIONS_AWK" <<< "$recs")

  provider_axis "$recs"
}

# ── Self-test ────────────────────────────────────────────────────────────────

self_test() {
  local tmp t r09 held
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  build_sets ""
  r09=".claude/rules/syntek-author/09-data-root.md"
  # name · DOC_TYPE · store · provider
  TREES=()
  while read -r t doc store provider; do
    mkdir -p "$tmp/$t/.claude/skills/flow" "$tmp/$t/.claude/rules/syntek-author" "$tmp/$t/.git"
    printf '# Skill: flow\n\nShared, word for word.\n' > "$tmp/$t/.claude/skills/flow/SKILL.md"
    printf '#!/usr/bin/env python3\n"""The resolver, the same bytes everywhere."""\n' > "$tmp/$t/$SA_DATAROOT_PY"
    printf '{\n  "format": 1\n}\n' > "$tmp/$t/$SA_DATAROOT_MAP"
    printf 'ref: %s\n' "$t" > "$tmp/$t/.git/HEAD"
    { printf '_commit: v0.5.0\nDOC_TYPE: %s\nDATA_STORE: %s\n' "$doc" "$store"
      if [[ "$store" == external ]]; then printf 'DATA_AREA: business\nDATA_SLUG: %s\n' "$t"; fi
      printf 'DATA_PROVIDER: %s\n' "$provider"; } > "$tmp/$t/$SA_ANSWERS_FILE"
    if [[ "$store" == external ]]; then
      mkdir -p "$tmp/$t/research/src"
      printf '# Binary copies are filed under the data root.\n*.pdf\n' > "$tmp/$t/research/src/.gitignore"
      printf '# The data root\n\n<root>/business/<kind folder>/%s/<path>\n' "$t" > "$tmp/$t/$r09"
    else
      printf '# The data root\n\nThis project keeps its files in the repository.\n' > "$tmp/$t/$r09"
    fi
    printf '# A %s project\n' "$doc" > "$tmp/$t/README.md"
    TREES+=("$tmp/$t")
  done <<'EOF'
theology-ext       theology external none
theology-onedrive  theology external onedrive
theology-repo      theology repo     none
fiction-ext        fiction  external none
business-repo      business repo     none
business-gd-repo   business repo     google-drive
EOF
  printf '# A theology project, its records in the repository\n' > "$tmp/theology-repo/README.md"
  mkdir -p "$tmp/fiction-ext/world"; printf '# World\n' > "$tmp/fiction-ext/world/CONTEXT.md"
  mkdir -p "$tmp/business-gd-repo/.github/workflows"
  printf 'name: Push to Google Drive\n' > "$tmp/business-gd-repo/.github/workflows/google-drive-push.yml"
  printf '# .github\n' > "$tmp/business-gd-repo/.github/CONTEXT.md"
  printf -- '- `.github/` pushes to Google Drive\n' >> "$tmp/business-gd-repo/README.md"
  st_baseline "six renders that differ only in the spine, the store, the slug and the Drive gate"

  held="$tmp/held"
  t="$tmp/business-repo/.claude/skills/flow/SKILL.md"; cp "$t" "$held"
  printf '# Skill: flow\n\nShared, word for word — except here.\n' > "$t"
  probe "check 1 fires when a shared skill differs in one render" "check 1 — .claude/skills/flow/SKILL.md differs"
  cp "$held" "$t"

  printf 'a different spine line\n' >> "$tmp/theology-repo/README.md"
  probe_clean "a spine file may differ between variants and stores"
  sed -i '$d' "$tmp/theology-repo/README.md"

  t="$tmp/fiction-ext/research/src/.gitignore"; cp "$t" "$held"
  printf '*.docx\n' >> "$t"
  probe "check 2 fires when a data-root ignore file differs in one render" "check 2 — research/src/.gitignore (a data-root file) differs"
  cp "$held" "$t"

  # Made a seed by a later catalogue, in a render paired under two providers: still check 2's
  # alone, never exempt as spine and never a second finding from check 3.
  t="$tmp/theology-onedrive/research/src/.gitignore"; cp "$t" "$held"
  printf '*.docx\n' >> "$t"
  SA_SEED_SET["research/src/.gitignore"]=1
  probe "check 2 alone fires with the ignore file made a seed" "check 2 — research/src/.gitignore"
  unset 'SA_SEED_SET[research/src/.gitignore]'
  cp "$held" "$t"

  t="$tmp/theology-repo/$SA_DATAROOT_PY"; cp "$t" "$held"
  printf 'STORE = "repo"\n' >> "$t"
  probe "check 2 fires when the resolver differs between the stores" "check 2 — $SA_DATAROOT_PY (a data-root file) differs"
  cp "$held" "$t"

  printf 'Synced with OneDrive.\n' >> "$tmp/theology-onedrive/README.md"
  probe "check 3 fires when a spine file differs under another provider" \
    "check 3 — README.md differs between renders whose answers differ only in DATA_PROVIDER: {theology-ext}  ≠  {theology-onedrive}"
  sed -i '$d' "$tmp/theology-onedrive/README.md"

  t="$tmp/theology-onedrive/$r09"; cp "$t" "$held"
  sed -i 's#<root>/business/#<root>/Business/#' "$t"
  probe "check 3 reads only the slug as a placeholder, not the text before it" "check 3 — $r09 differs"
  cp "$held" "$t"
  sed -i 's#/<path>#/<file>#' "$t"
  probe "check 3 reads only the slug as a placeholder, not the text after it" "check 3 — $r09 differs"
  cp "$held" "$t"

  mkdir -p "$tmp/theology-onedrive/planning/src"; printf '# Extra\n' > "$tmp/theology-onedrive/planning/src/extra.md"
  probe "check 3 fires when a file ships under one provider only" \
    "check 3 — planning/src/extra.md ships in {theology-onedrive} and not in {theology-ext}"
  rm -rf "$tmp/theology-onedrive/planning"

  printf 'DATA_STORE: external\n' > "$tmp/business-repo/$SA_PEER_ANSWERS_FILE"
  probe_clean "a sibling template's answers file beside one render is not part of it"
  rm -f "$tmp/business-repo/$SA_PEER_ANSWERS_FILE"

  mkdir -p "$tmp/business-gd-repo/library/src"; printf '# Notes\n' > "$tmp/business-gd-repo/library/src/drive-notes.md"
  probe "check 3 fires on a file outside .github/ that only the Drive render ships" \
    "check 3 — library/src/drive-notes.md ships in {business-gd-repo} and not in {business-repo}"
  rm -rf "$tmp/business-gd-repo/library"

  printf -- '- Drive keeps a second copy of the library\n' >> "$tmp/business-gd-repo/$r09"
  probe "check 3 fires on a Drive-only spine line that does not name .github/" \
    "check 3 — $r09 differs across the Drive gate in lines that do not name .github/ (business-gd-repo against business-repo, at 3a4)"
  sed -i '$d' "$tmp/business-gd-repo/$r09"

  mkdir -p "$tmp/business-repo/.github/workflows"; printf 'name: Stray\n' > "$tmp/business-repo/.github/workflows/stray.yml"
  probe "check 3 fires on .github/ where the Drive gate is shut" \
    "check 3 — .github/workflows/stray.yml ships in {business-repo} and not in {business-gd-repo}"
  rm -rf "$tmp/business-repo/.github"

  st_finish "identical shared files, data-root files and provider renders from ones that vary"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ ${#TARGETS[@]} -ge 2 ]] || die "give at least two rendered trees — identity is a comparison"
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  TREES+=("$(cd "$target" && pwd)")
done
build_sets "$SA_ROOT/copier.yml"

bold "▸ $SCRIPT_NAME — ${#TREES[@]} render(s)"
run_checks
log "  compared $COMPARED shared file(s) and $DATAROOT_COMPARED data-root file(s) present in two or more renders; $SPINE_SKIPPED spine file(s) exempt"
log "  the store: ${STORE_AXIS:-no variant} rendered at both external and repo"
log "  the provider: $PROVIDER_GROUPS group(s) of renders whose answers differ only in DATA_PROVIDER"
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ Every shared file is byte-identical wherever it ships."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
log ""
log "  A shared file must not vary by variant, store or option (DESIGN.md Section 2, D50, D53)."
log "  Move the difference into a gated file or a mode file, or — if the file is an index — gate"
log "  its rows. Under two providers, only the answers file and the Drive gate's .github/ differ."
exit 1
