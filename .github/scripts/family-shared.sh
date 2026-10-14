#!/usr/bin/env bash
#
# family-shared.sh — Hold the family-shared files to one set of bytes (DESIGN.md D48).
#
#                    A project can take syntek-author and syntek-media, in either order. The
#                    files both templates write at the same path (the client entrypoints, the
#                    .agents/ folder, the .codex/ and .gemini/ pairs, opencode.json, .mcp.json),
#                    the permissions script both ship under their own name (D49), and the
#                    question block that renders them must be byte-identical in both
#                    templates' sources. Otherwise whichever template copies first decides what
#                    the project holds, and the other template's promises about those files
#                    are false. syntek-author owns the sources; root family-shared.json
#                    records their source bytes, which the other template vendors and checks.
#
#                    So the shared files must also be neutral: a shared file may use only the
#                    seven shared question keys, and may name no syntek-author path (it says
#                    'every .claude/syntek-*-agents.md' instead).
#
#                    Ten checks:
#                      1. family-shared.json exists, is JSON, and has format 1, owner
#                         syntek-author and release 'unreleased' or 'v' + VERSION.
#                      2. Its files are exactly the shared set below, each with its source and
#                         kind, sorted by path, and its blocks exactly the question block.
#                      3. Every listed source exists, as a file or a link as listed.
#                      4. Every file's size and sha256 match; every link's target matches.
#                      5. A shared file, or the question block, uses inside a delimiter a key
#                         other than the seven shared keys (the block may also read
#                         _external_data); the permissions script holds any delimiter at all.
#                      6. A shared file, or the question block, names syntek-author.
#                      7. copier.yml holds each marker line exactly once, BEGIN before END.
#                      8. The block's top-level keys are exactly the seven shared keys.
#                      9. The block's size and sha256 match the manifest.
#                     10. --sibling DIR: the sibling template's copies of the shared sources
#                         (and its question block) match ours byte for byte.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: that the rendered files are identical in a project
#                    that took both templates (coexist-test.sh renders that), or that the
#                    sibling's manifest is current (its own audit checks that).
#
# SELF-TEST. --self-test writes a fixture repository at runtime, writes its manifest, proves it
#            clean, then applies one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, python3 3.11+. No network.
#
# Usage: family-shared.sh [--write] [--sibling DIR] [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = the shared set matches its manifest (written, with --write)
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, no python3, markers absent when writing)

set -euo pipefail
SCRIPT_NAME="family-shared.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

WRITE=false
SIBLING=""
SELF_TEST=false

# The shared set (DESIGN.md D48): destination path, then source. <template> is the literal
# placeholder for each template's own name.
FS_FILES=(
  ".agents/mcp_config.json|template/.agents/mcp_config.json"
  ".agents/skills|template/.agents/skills"
  ".claude/syntek-<template>-permissions.py|template/.claude/syntek-author-permissions.py"
  ".codex/CLAUDE.md|template/.codex/CLAUDE.md"
  ".codex/CONTEXT.md|template/.codex/CONTEXT.md"
  ".codex/config.toml|template/.codex/config.toml"
  ".gemini/CLAUDE.md|template/.gemini/CLAUDE.md"
  ".gemini/CONTEXT.md|template/.gemini/CONTEXT.md"
  ".gemini/settings.json|template/.gemini/settings.json"
  ".mcp.json|template/.mcp.json"
  "AGENTS.md|template/AGENTS.md"
  "GEMINI.md|template/GEMINI.md"
  "opencode.json|template/opencode.json"
)
FS_LINKS=".agents/skills"
FS_KEYS="AGENT_CLIENTS CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT"
FS_BEGIN='# BEGIN family-shared questions (D48)'
FS_END='# END family-shared questions (D48)'
FS_MANIFEST="family-shared.json"

usage() {
  cat <<'EOF'
family-shared.sh — Hold the family-shared files to one set of bytes (DESIGN.md D48)

Usage: family-shared.sh [--write] [--sibling DIR] [--root DIR] [--quiet] [--self-test] [--help]

  (no flag)      Check family-shared.json against the sources, and the sources' neutrality
  --write        Regenerate family-shared.json from the sources, then check
  --sibling DIR  Also compare a sibling template checkout's copies (skipped, with a note,
                 when DIR has no family-shared.json)
  --root DIR     The template repository (default: this repository)
  --quiet        Print findings only
  --self-test    Prove the checks still fire against a fixture written at runtime
  --help         Show this message

Exit codes: 0 = in step  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --write)     WRITE=true; shift ;;
    --sibling)   [[ $# -gt 1 ]] || die "--sibling needs a value"; SIBLING="$2"; shift 2 ;;
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

# One Python program does the reading; it prints one finding per line, or the manifest.
# $1 = mode (check | write), $2 = root, $3 = sibling (may be empty).
fs_py() {
  FS_FILES_LIST="$(printf '%s\n' "${FS_FILES[@]}")" FS_LINKS="$FS_LINKS" FS_KEYS="$FS_KEYS" \
  FS_BEGIN="$FS_BEGIN" FS_END="$FS_END" FS_MANIFEST="$FS_MANIFEST" \
  python3 -I - "$@" <<'PY'
import hashlib, json, os, re, sys
from pathlib import Path

mode, root, sibling = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
files = [l.split("|", 1) for l in os.environ["FS_FILES_LIST"].splitlines() if l]
links = set(os.environ["FS_LINKS"].split())
keys = os.environ["FS_KEYS"].split()
begin, end = os.environ["FS_BEGIN"], os.environ["FS_END"]
manifest_path = root / os.environ["FS_MANIFEST"]
OWNER = "syntek-author"
out = []
def finding(n, text): out.append(f"check {n} — {text}")

def entry(path, source):
    p = root / source
    if path in links:
        e = {"path": path, "source": source, "kind": "symlink"}
        if p.is_symlink():
            e["target"] = os.readlink(p)
        return e, p.is_symlink(), "a link"
    e = {"path": path, "source": source, "kind": "file"}
    ok = p.is_file() and not p.is_symlink()
    if ok:
        b = p.read_bytes()
        e["bytes"], e["sha256"] = len(b), hashlib.sha256(b).hexdigest()
    return e, ok, "a file"

def block_lines(copier):
    """(lines strictly between the markers, error) for one copier.yml."""
    try:
        lines = copier.read_text(encoding="utf-8").splitlines()
    except OSError:
        return None, f"{copier.name} cannot be read"
    b = [i for i, l in enumerate(lines) if l == begin]
    e = [i for i, l in enumerate(lines) if l == end]
    if len(b) != 1 or len(e) != 1 or b[0] > e[0]:
        return None, f"copier.yml holds '{begin}' {len(b)} time(s) and '{end}' {len(e)} time(s); each must appear once, BEGIN first"
    return lines[b[0] + 1:e[0]], ""

def block_entry(lines):
    data = "".join(l + "\n" for l in lines).encode()
    return {"name": "questions", "source": "copier.yml", "begin": begin, "end": end,
            "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}

try:
    version = (root / "VERSION").read_text(encoding="utf-8").strip()
except OSError:
    version = ""
releases = {"unreleased"} | ({f"v{version}"} if version else set())
blk, blk_err = block_lines(root / "copier.yml")

if mode == "write":
    release = "unreleased"
    try:
        old = json.loads(manifest_path.read_text(encoding="utf-8"))
        if old.get("release") in releases:
            release = old["release"]
    except (OSError, ValueError, AttributeError):
        pass
    if blk is None:
        print(blk_err, file=sys.stderr); sys.exit(2)
    entries = []
    for path, source in sorted(files):
        e, ok, kind = entry(path, source)
        if not ok:
            print(f"{source} is not {kind}; the manifest cannot be written", file=sys.stderr); sys.exit(2)
        entries.append(e)
    text = ('{\n  "format": 1,\n  "owner": "' + OWNER + '",\n  "release": ' + json.dumps(release) + ',\n  "files": [\n'
            + ",\n".join("    " + json.dumps(e, ensure_ascii=False) for e in entries)
            + '\n  ],\n  "blocks": [\n    ' + json.dumps(block_entry(blk), ensure_ascii=False) + "\n  ]\n}\n")
    manifest_path.write_text(text, encoding="utf-8")
    sys.exit(0)

# ── check ──
man = None
try:
    man = json.loads(manifest_path.read_text(encoding="utf-8"))
except FileNotFoundError:
    finding(1, f"{manifest_path.name} does not exist — run family-shared.sh --write")
except (OSError, ValueError) as err:
    finding(1, f"{manifest_path.name} is not JSON ({err})")
if man is not None:
    if not isinstance(man, dict) or man.get("format") != 1 or man.get("owner") != OWNER or man.get("release") not in releases:
        finding(1, f"{manifest_path.name} must hold format 1, owner {OWNER} and release one of {sorted(releases)}")
        man = None

listed = {}
if man is not None:
    mf = man.get("files") if isinstance(man.get("files"), list) else []
    want = [(p, s, "symlink" if p in links else "file") for p, s in sorted(files)]
    have = [(e.get("path"), e.get("source"), e.get("kind")) for e in mf if isinstance(e, dict)]
    blocks = man.get("blocks") if isinstance(man.get("blocks"), list) else []
    if have != want:
        missing = [w[0] for w in want if w not in have]
        extra = [h[0] for h in have if h not in want]
        finding(2, f"{manifest_path.name} files differ from the shared set (missing or wrong: {missing or 'none'}; "
                   f"extra or wrong: {extra or 'none'}; order: {'wrong' if not missing and not extra else 'n/a'})")
    elif len(blocks) != 1 or not isinstance(blocks[0], dict) or blocks[0].get("name") != "questions" \
            or blocks[0].get("begin") != begin or blocks[0].get("end") != end or blocks[0].get("source") != "copier.yml":
        finding(2, f"{manifest_path.name} blocks must be exactly the questions block between the D48 markers")
    listed = {e.get("path"): e for e in mf if isinstance(e, dict)}

delim = re.compile(r"<%(.*?)%>|<:(.*?):>|<~(.*?)~>", re.S)
strings = re.compile(r"'[^']*'|\"[^\"]*\"")
ident = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
def foreign_keys(text, extra=()):
    bad = set()
    for m in delim.finditer(text):
        body = strings.sub(" ", next(g for g in m.groups() if g is not None))
        for name in ident.findall(body):
            if name in keys or name in extra:
                continue
            if (len(name) > 1 and re.fullmatch(r"[A-Z][A-Z0-9_]*", name)) or name.startswith("_"):
                bad.add(name)
    return sorted(bad)

for path, source in sorted(files):
    e, ok, kind = entry(path, source)
    if not ok:
        finding(3, f"{source} is missing, or is not {kind}")
        continue
    m = listed.get(path)
    if m is not None and m.get("source") == source:
        fields = ("target",) if path in links else ("bytes", "sha256")
        if any(m.get(f) != e.get(f) for f in fields):
            finding(4, f"{source} differs from {manifest_path.name} ({', '.join(f'{f} {m.get(f)} != {e.get(f)}' for f in fields if m.get(f) != e.get(f))}) — run family-shared.sh --write if the change is meant")
    if path in links:
        continue
    text = (root / source).read_text(encoding="utf-8", errors="replace")
    bad = foreign_keys(text)
    if source.endswith("-permissions.py") and delim.search(text):
        finding(5, f"{source} holds a template delimiter; the permissions script is never rendered differently")
    elif bad:
        finding(5, f"{source} uses {', '.join(bad)} — a shared file may use only the seven shared keys")
    if OWNER in text:
        finding(6, f"{source} names {OWNER}; say 'every .claude/syntek-*-agents.md' or 'the project's rules in .claude/'")

if blk is None:
    finding(7, blk_err)
else:
    btext = "\n".join(blk)
    top = [m.group(1) for l in blk if (m := re.match(r"([A-Za-z_][A-Za-z0-9_]*):", l))]
    if sorted(top) != sorted(keys) or len(top) != len(set(top)):
        finding(8, f"the D48 block's top-level keys are {top}; they must be exactly {keys}")
    bad = foreign_keys(btext, extra=("_external_data",))
    if bad:
        finding(5, f"the D48 question block uses {', '.join(bad)} — only the seven shared keys and _external_data")
    if OWNER in btext:
        finding(6, f"the D48 question block names {OWNER}; it is copied verbatim into the other template")
    if man is not None and isinstance(man.get("blocks"), list) and man["blocks"] and isinstance(man["blocks"][0], dict):
        be, mb = block_entry(blk), man["blocks"][0]
        if (mb.get("bytes"), mb.get("sha256")) != (be["bytes"], be["sha256"]):
            finding(9, f"the D48 question block differs from {manifest_path.name} (bytes {mb.get('bytes')} != {be['bytes']}) — run family-shared.sh --write if the change is meant")

if sibling:
    sroot = Path(sibling)
    try:
        sman = json.loads((sroot / manifest_path.name).read_text(encoding="utf-8"))
    except (OSError, ValueError):
        sman = None
        print(f"NOTE: {sroot} has no readable {manifest_path.name}; the sibling comparison is skipped", file=sys.stderr)
    if sman is not None:
        sname = str(sman.get("owner", "")).removeprefix("syntek-")
        sfiles = {e.get("path"): e for e in sman.get("files", []) if isinstance(e, dict)}
        for path, source in sorted(files):
            ssrc = sfiles.get(path, {}).get("source") or ("template/" + path.replace("<template>", sname))
            a, b = root / source, sroot / ssrc
            if path in links:
                same = b.is_symlink() and a.is_symlink() and os.readlink(a) == os.readlink(b)
            else:
                same = b.is_file() and a.is_file() and a.read_bytes() == b.read_bytes()
            if not same:
                finding(10, f"the sibling's {ssrc} differs from our {source}, or is absent")
        sblk, err = block_lines(sroot / "copier.yml")
        if blk is not None and sblk != blk:
            finding(10, f"the sibling's D48 question block differs from ours{' (' + err + ')' if sblk is None else ''}")

print("\n".join(out))
PY
}

run_checks() {
  FINDINGS=()
  local out line
  out="$(fs_py check "$SA_ROOT" "$SIBLING")" || die "the manifest reader failed"
  while IFS= read -r line; do
    [[ -n "$line" ]] && finding "$line"
  done <<< "$out"
  return 0
}

# ── Self-test ────────────────────────────────────────────────────────────────

fixture() { # $1 = dir: a template repository holding the shared set and the question block
  local t="$1" pair
  mkdir -p "$t/template/.agents" "$t/template/.claude/skills" "$t/template/.codex" "$t/template/.gemini"
  printf '0.3.0\n' > "$t/VERSION"
  for pair in "${FS_FILES[@]}"; do
    [[ "${pair%%|*}" == .agents/skills ]] && continue
    printf 'shared text for %s\n' "${pair%%|*}" > "$t/${pair#*|}"
  done
  printf '{\n  "model": <%% OPENCODE_MODEL | tojson %%>\n}\n' > "$t/template/opencode.json"
  ln -s ../.claude/skills "$t/template/.agents/skills"
  {
    printf 'PROJECT_NAME:\n  type: str\n\n%s\n' "$FS_BEGIN"
    printf 'AGENT_CLIENTS:\n  default: "<%% %s if _external_data.prev.get(%s) else %s %%>"\n' "'[]'" "'_commit'" "'[codex]'"
    for k in CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT; do
      printf '%s:\n  type: str\n  when: "<%% %s in AGENT_CLIENTS %%>"\n' "$k" "'opencode'"
    done
    printf '%s\n\nTIMEZONE:\n  type: str\n' "$FS_END"
  } > "$t/copier.yml"
}

self_test() {
  local tmp real_root="$SA_ROOT" sib
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  fixture "$tmp/repo"; SA_ROOT="$tmp/repo"
  fs_py write "$SA_ROOT" "" || { note "the fixture manifest could not be written"; return 1; }
  st_baseline "a fixture repository with its manifest"
  local m="$SA_ROOT/$FS_MANIFEST" g="$SA_ROOT/template/GEMINI.md" c="$SA_ROOT/copier.yml"

  cp "$m" "$tmp/m"
  sed -i 's/"release": "unreleased"/"release": "v9.9.9"/' "$m";                probe "check 1 fires on a release that is neither unreleased nor VERSION" "check 1"
  cp "$tmp/m" "$m"; sed -i '/"path": "GEMINI.md"/d' "$m"
  probe "check 2 fires when a shared file is not listed" "check 2"
  cp "$tmp/m" "$m"; rm "$g";                                                      probe "check 3 fires when a shared source is missing" "check 3 — template/GEMINI.md"
  printf 'shared text for GEMINI.md\nand one more line\n' > "$g";                  probe "check 4 fires when a shared file changes" "check 4 — template/GEMINI.md"
  printf 'shared text for GEMINI.md\n' > "$g"
  rm "$SA_ROOT/template/.agents/skills"; ln -s ../.claude "$SA_ROOT/template/.agents/skills"
  probe "check 4 fires when the link target changes" "check 4 — template/.agents/skills"
  rm "$SA_ROOT/template/.agents/skills"; ln -s ../.claude/skills "$SA_ROOT/template/.agents/skills"
  printf 'Read <%%PROJECT_NAME%%>.\n' > "$g"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on a non-shared key in a shared file" "check 5 — template/GEMINI.md uses PROJECT_NAME"
  printf 'x = "<%% OPENCODE_MODEL %%>"\n' > "$SA_ROOT/template/.claude/syntek-author-permissions.py"; printf 'shared text for GEMINI.md\n' > "$g"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on any delimiter in the permissions script" "check 5 — template/.claude/syntek-author-permissions.py"
  printf 'shared text\n' > "$SA_ROOT/template/.claude/syntek-author-permissions.py"
  printf 'Read .claude/syntek-author-agents.md.\n' > "$g"; fs_py write "$SA_ROOT" ""
  probe "check 6 fires when a shared file names syntek-author" "check 6 — template/GEMINI.md"
  printf 'shared text for GEMINI.md\n' > "$g"; fs_py write "$SA_ROOT" ""; cp "$c" "$tmp/c"
  printf '%s\n' "$FS_END" >> "$c";                                               probe "check 7 fires on a second END marker" "check 7"
  cp "$tmp/c" "$c"; sed -i "s/^$FS_END\$/DATE:\n  type: str\n$FS_END/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 8 fires on a foreign key inside the block" "check 8"
  cp "$tmp/c" "$c"; fs_py write "$SA_ROOT" ""
  sed -i 's/  type: str$/  type: int/' "$c";                                     probe "check 9 fires when the block changes" "check 9"
  cp "$tmp/c" "$c"
  sib="$tmp/sibling"; cp -a "$SA_ROOT" "$sib"
  mv "$sib/template/.claude/syntek-author-permissions.py" "$sib/template/.claude/syntek-media-permissions.py"
  sed -i 's/"owner": "syntek-author"/"owner": "syntek-media"/; /"path": ".claude\/syntek-<template>-permissions.py"/s/syntek-author-permissions/syntek-media-permissions/' "$sib/$FS_MANIFEST"
  SIBLING="$sib";                                                                probe_clean "a sibling with identical copies under its own name is clean"
  printf 'drifted\n' > "$sib/template/AGENTS.md";                                  probe "check 10 fires when a sibling's copy drifts" "check 10 — the sibling's template/AGENTS.md"
  SIBLING=""

  SA_ROOT="$real_root"
  st_finish "a shared set in step with its manifest from one that has drifted"
}

command -v python3 >/dev/null 2>&1 || die "python3 is not installed"
python3 -c 'import sys; sys.exit(sys.version_info < (3, 11))' || die "python3 is older than 3.11"
if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
bold "▸ $SCRIPT_NAME — $SA_ROOT"
if $WRITE; then
  fs_py write "$SA_ROOT" "" || exit 2
  log "  wrote $FS_MANIFEST"
fi
run_checks
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ ${#FS_FILES[@]} shared file(s) and the question block match $FS_MANIFEST, and use only the shared keys."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
exit 1
