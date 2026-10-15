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
#                    Two more are shared at the template repository's root rather than in a
#                    project (manifest "scope": "repository"): the outside-link migration,
#                    migrations/agents-outside-link.py, and the copier.yml block of
#                    _migrations entries that runs it. D51 adds the shared working practice
#                    (seven SKILL.md files, the two session hooks at mode 755 and the handoffs/
#                    pair), copy-only in every family template; D52 adds the script that
#                    reports every update and refreshes those files, migrations/family-update.py
#                    (repository scope), its _migrations block, which closes _migrations, and
#                    its copy-time task, which closes _tasks. Each template's own
#                    migrations/family-refresh.json lists what that script may refresh and add
#                    to settings.json; it is per template, so it is checked here, not shared.
#
#                    So the shared files must also be neutral: a shared file may use only the
#                    seven shared question keys, and may name no syntek-author path (it says
#                    'every .claude/syntek-*-agents.md' instead). A shared skill, hook or
#                    handoffs file holds no delimiter at all (D51): the refresh compares bytes.
#
#                    Sixteen checks:
#                      1. family-shared.json exists, is JSON, and has format 1, owner
#                         syntek-author and release 'unreleased' or 'v' + VERSION.
#                      2. Its files are exactly the shared set below, each with its source,
#                         kind and scope ("scope" absent means "project"; the two migration
#                         scripts are "repository"), sorted by path, and its blocks exactly the
#                         question block, the migrations block and the update block, in order.
#                      3. Every listed source exists, as a file or a link as listed.
#                      4. Every file's size, sha256 and mode ("mode": "755" for an executable
#                         source) match; every link's target matches.
#                      5. A shared file, or a block, uses inside a delimiter a key other than
#                         the seven shared keys (the question block may also read
#                         _external_data, the two migration blocks _copier_conf, _stage and
#                         _copier_python); the permissions script, the migration scripts and
#                         every shared skill, hook and handoffs file hold any delimiter at all.
#                      6. A shared file, or a block, names syntek-author.
#                      7. copier.yml holds each marker line exactly once, BEGIN before END.
#                      8. The question block's top-level keys are exactly the seven shared
#                         keys; the migrations block holds only the hold and the restore entry
#                         of migrations/agents-outside-link.py, run by _copier_python, in that
#                         order, line for line, and comments, and it opens _migrations (restore
#                         runs first).
#                      9. Each block's size and sha256 match the manifest.
#                     10. --sibling DIR: the sibling template's copies of the shared sources
#                         (and its two blocks) match ours byte for byte.
#                     11. The migration script, or the migrations block, names another
#                         template (syntek-<name> in any spelling, syntek_<name> or
#                         Syntek<Name>, other than its held name and the syntek-* pattern),
#                         or a decision number (D<n>).
#                     12. The migration script's held name is not exactly .agents.syntek-held
#                         (one HELD assignment), so the templates would hold the link under
#                         different names and a stranded hold's printed fix would differ.
#                     13. The update block holds only the update entry of
#                         migrations/family-update.py, line for line, and comments, and closes
#                         _migrations: an entry after it would change files the report has
#                         already judged (D52).
#                     14. The baseline task of migrations/family-update.py, copy only, is the
#                         last entry of _tasks, line for line: it records the render of what
#                         every earlier task left.
#                     15. The refresh set (D51): migrations/family-refresh.json is format 1
#                         for syntek-author and refreshes exactly the shared skills, hooks and
#                         handoffs files; each has an anchored _skip_if_exists line and an
#                         _exclude line gated on the update, file by file, and no such line
#                         names a folder above it; each hook is executable; each settings hook
#                         entry runs a hook of the set.
#                     16. Mode-file names beside the shared skills (D51): no file under
#                         template/ takes the companion's mode-file prefix (MEDIA-*.md); a
#                         shared skill's folder under template/ holds only SKILL.md and this
#                         template's own mode files (THEOLOGY.md, FICTION.md, BUSINESS.md); and,
#                         with --sibling, the sibling's shared skill folders hold none of this
#                         template's mode-file names. The sibling's MEDIA-*.md there are accepted.
#
#                     17. Every _tasks entry is copy only: its when: opens with
#                         _copier_operation == 'copy' (the chmod of the shared hooks included),
#                         so no task changes a project on update (D51, D52).
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

# The shared set (DESIGN.md D48, D51, D52): destination path, then source, then the scope when
# it is not a project path. <template> is the literal placeholder for each template's own name.
# The shared working practice is $SA_SHARED_PRACTICE (_common.sh), appended below.
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
  "migrations/agents-outside-link.py|migrations/agents-outside-link.py|repository"
  "migrations/family-update.py|migrations/family-update.py|repository"
  "opencode.json|template/opencode.json"
)
for _p in $SA_SHARED_PRACTICE; do FS_FILES+=("$_p|template/$_p"); done
unset _p
FS_LINKS=".agents/skills"
FS_KEYS="AGENT_CLIENTS CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT"
FS_BEGIN='# BEGIN family-shared questions (D48)'
FS_END='# END family-shared questions (D48)'
FS_MIG_BEGIN='# BEGIN family-shared migrations (D48)'
FS_MIG_END='# END family-shared migrations (D48)'
FS_UPD_BEGIN='# BEGIN family-shared update (D48)'
FS_UPD_END='# END family-shared update (D48)'
FS_REFRESH_DATA="migrations/family-refresh.json"
FS_HELD='.agents.syntek-held'
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
  FS_BEGIN="$FS_BEGIN" FS_END="$FS_END" FS_MIG_BEGIN="$FS_MIG_BEGIN" FS_MIG_END="$FS_MIG_END" \
  FS_UPD_BEGIN="$FS_UPD_BEGIN" FS_UPD_END="$FS_UPD_END" FS_REFRESH="$SA_SHARED_PRACTICE" \
  FS_REFRESH_DATA="$FS_REFRESH_DATA" FS_HELD="$FS_HELD" FS_MANIFEST="$FS_MANIFEST" \
  FS_MODE_FILES="$SA_MODE_FILES" FS_SIBLING_MODE_RE="$SA_SIBLING_MODE_RE" \
  python3 -I - "$@" <<'PY'
import hashlib, json, os, re, sys
from pathlib import Path

mode, root, sibling = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
files = []
for l in os.environ["FS_FILES_LIST"].splitlines():
    if l:
        parts = l.split("|")
        files.append((parts[0], parts[1], parts[2] if len(parts) > 2 else "project"))
links = set(os.environ["FS_LINKS"].split())
keys = os.environ["FS_KEYS"].split()
held = os.environ["FS_HELD"]
# The blocks, in manifest order: name, BEGIN marker, END marker, the extra names its delimiters may read.
BLOCKS = [("questions", os.environ["FS_BEGIN"], os.environ["FS_END"], ("_external_data",)),
          ("migrations", os.environ["FS_MIG_BEGIN"], os.environ["FS_MIG_END"], ("_copier_conf", "_stage", "_copier_python")),
          ("update", os.environ["FS_UPD_BEGIN"], os.environ["FS_UPD_END"], ("_copier_conf", "_stage", "_copier_python"))]
REFRESH = os.environ["FS_REFRESH"].split()
REFRESH_DATA = os.environ["FS_REFRESH_DATA"]
UPDATE = "migrations/family-update.py"
RUNPY = '"<% _copier_python %>" "<% _copier_conf.src_path %>/'
UPDATE_ARGS = ' --src "<% _copier_conf.src_path %>" --to <% _copier_conf.vcs_ref_hash %> --answers "<% _copier_conf.answers_file %>"'
WANT_UPDATE = [f"  - command: '{RUNPY}{UPDATE}\" update{UPDATE_ARGS}'", "    when: \"<% _stage == 'after' %>\""]
WANT_TASK = [f"  - command: '{RUNPY}{UPDATE}\" baseline{UPDATE_ARGS}'", "    when: \"<% _copier_operation == 'copy' %>\""]
manifest_path = root / os.environ["FS_MANIFEST"]
OWNER = "syntek-author"
MIGRATION = "migrations/agents-outside-link.py"
out = []
def finding(n, text): out.append(f"check {n} — {text}")

def entry(path, source, scope):
    p = root / source
    if path in links:
        e = {"path": path, "source": source, "kind": "symlink"}
        if scope != "project":
            e["scope"] = scope
        if p.is_symlink():
            e["target"] = os.readlink(p)
        return e, p.is_symlink(), "a link"
    e = {"path": path, "source": source, "kind": "file"}
    if scope != "project":
        e["scope"] = scope
    ok = p.is_file() and not p.is_symlink()
    if ok:
        b = p.read_bytes()
        e["bytes"], e["sha256"] = len(b), hashlib.sha256(b).hexdigest()
        if os.stat(p).st_mode & 0o111:
            e["mode"] = "755"
    return e, ok, "a file"

def block_lines(copier, begin, end):
    """(lines strictly between the markers, error) for one block of one copier.yml."""
    try:
        lines = copier.read_text(encoding="utf-8").splitlines()
    except OSError:
        return None, f"{copier.name} cannot be read"
    b = [i for i, l in enumerate(lines) if l == begin]
    e = [i for i, l in enumerate(lines) if l == end]
    if len(b) != 1 or len(e) != 1 or b[0] > e[0]:
        return None, f"copier.yml holds '{begin}' {len(b)} time(s) and '{end}' {len(e)} time(s); each must appear once, BEGIN first"
    return lines[b[0] + 1:e[0]], ""

def block_entry(name, begin, end, lines):
    data = "".join(l + "\n" for l in lines).encode()
    return {"name": name, "source": "copier.yml", "begin": begin, "end": end,
            "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}

try:
    version = (root / "VERSION").read_text(encoding="utf-8").strip()
except OSError:
    version = ""
releases = {"unreleased"} | ({f"v{version}"} if version else set())
blks = {name: block_lines(root / "copier.yml", b, e) for name, b, e, _ in BLOCKS}

if mode == "write":
    release = "unreleased"
    try:
        old = json.loads(manifest_path.read_text(encoding="utf-8"))
        if old.get("release") in releases:
            release = old["release"]
    except (OSError, ValueError, AttributeError):
        pass
    for name, _, _, _ in BLOCKS:
        if blks[name][0] is None:
            print(blks[name][1], file=sys.stderr); sys.exit(2)
    entries = []
    for path, source, scope in sorted(files):
        e, ok, kind = entry(path, source, scope)
        if not ok:
            print(f"{source} is not {kind}; the manifest cannot be written", file=sys.stderr); sys.exit(2)
        entries.append(e)
    text = ('{\n  "format": 1,\n  "owner": "' + OWNER + '",\n  "release": ' + json.dumps(release) + ',\n  "files": [\n'
            + ",\n".join("    " + json.dumps(e, ensure_ascii=False) for e in entries)
            + '\n  ],\n  "blocks": [\n'
            + ",\n".join("    " + json.dumps(block_entry(n, b, e, blks[n][0]), ensure_ascii=False) for n, b, e, _ in BLOCKS)
            + "\n  ]\n}\n")
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
mblocks = {}
if man is not None:
    mf = man.get("files") if isinstance(man.get("files"), list) else []
    want = [(p, s, "symlink" if p in links else "file", sc) for p, s, sc in sorted(files)]
    have = [(e.get("path"), e.get("source"), e.get("kind"), e.get("scope", "project")) for e in mf if isinstance(e, dict)]
    blocks = man.get("blocks") if isinstance(man.get("blocks"), list) else []
    want_blocks = [(n, "copier.yml", b, e) for n, b, e, _ in BLOCKS]
    have_blocks = [(x.get("name"), x.get("source"), x.get("begin"), x.get("end")) if isinstance(x, dict) else None for x in blocks]
    if have != want:
        missing = [w[0] for w in want if w not in have]
        extra = [h[0] for h in have if h not in want]
        finding(2, f"{manifest_path.name} files differ from the shared set (missing or wrong path, source, kind or scope: {missing or 'none'}; "
                   f"extra or wrong: {extra or 'none'}; order: {'wrong' if not missing and not extra else 'n/a'})")
    elif have_blocks != want_blocks:
        finding(2, f"{manifest_path.name} blocks must be exactly the questions, migrations and update blocks, in that order, between their D48 markers")
    listed = {e.get("path"): e for e in mf if isinstance(e, dict)}
    mblocks = {x.get("name"): x for x in blocks if isinstance(x, dict)}

delim = re.compile(r"<%(.*?)%>|<:(.*?):>|<~(.*?)~>", re.S)
strings = re.compile(r"'[^']*'|\"[^\"]*\"")
ident = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
# Any spelling of a template name: syntek-media, syntek_media, SyntekMedia. The held name and
# the owner's own name (check 6's) are left out; syntek-* never matches.
template_name = re.compile(r"syntek[-_]?[a-z][a-z0-9]*(?:-[a-z0-9]+)*", re.I)
def other_templates(text):
    return sorted({n for n in template_name.findall(text) if n not in (OWNER, "syntek-held")})
decision = re.compile(r"\bD\d+\b")
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

for path, source, scope in sorted(files):
    e, ok, kind = entry(path, source, scope)
    if not ok:
        finding(3, f"{source} is missing, or is not {kind}")
        continue
    m = listed.get(path)
    if m is not None and m.get("source") == source:
        fields = ("target",) if path in links else ("bytes", "sha256", "mode")
        if any(m.get(f) != e.get(f) for f in fields):
            finding(4, f"{source} differs from {manifest_path.name} ({', '.join(f'{f} {m.get(f)} != {e.get(f)}' for f in fields if m.get(f) != e.get(f))}) — run family-shared.sh --write if the change is meant")
    if path in links:
        continue
    text = (root / source).read_text(encoding="utf-8", errors="replace")
    bad = foreign_keys(text)
    if source.endswith("-permissions.py") and delim.search(text):
        finding(5, f"{source} holds a template delimiter; the permissions script is never rendered differently")
    elif path in REFRESH and delim.search(text):
        finding(5, f"{source} holds a template delimiter; a shared skill, hook or handoffs file is token-free, so the refresh can compare its bytes (D51)")
    elif scope == "repository" and delim.search(text):
        finding(5, f"{source} holds a template delimiter; it is run from the template clone and never rendered")
    elif bad:
        finding(5, f"{source} uses {', '.join(bad)} — a shared file may use only the seven shared keys")
    if OWNER in text:
        finding(6, f"{source} names {OWNER}; say 'every .claude/syntek-*-agents.md' or 'the project's rules in .claude/'")
    if scope == "repository":
        # The opt-out and render variables the update script reads are not template names.
        names = other_templates(re.sub(r"SYNTEK_UPDATE_[A-Z]+", "", text))
        if names:
            finding(11, f"{source} names {', '.join(names)}; a family-shared script names no template ('the bridge (.claude/syntek-*-agents.md)')")
        dnums = sorted(set(decision.findall(text)))
        if dnums:
            finding(11, f"{source} names decision {', '.join(dnums)}; a family-shared script cites no template's decision numbers")
    if path == MIGRATION:
        helds = re.findall(r"^HELD = '([^']*)'$", text, re.M)
        if helds != [held]:
            finding(12, f"{source} holds the link as {helds or 'no HELD assignment'}; every template must hold it as exactly ['{held}']")

for name, begin, end, extra in BLOCKS:
    blk, err = blks[name]
    if blk is None:
        finding(7, err)
        continue
    btext = "\n".join(blk)
    if name == "questions":
        top = [m.group(1) for l in blk if (m := re.match(r"([A-Za-z_][A-Za-z0-9_]*):", l))]
        if sorted(top) != sorted(keys) or len(top) != len(set(top)):
            finding(8, f"the D48 question block's top-level keys are {top}; they must be exactly {keys}")
    elif name == "migrations":
        # Every line that is not blank and not a comment, exactly: nothing else may ride along.
        body = [l for l in blk if l.strip() and not l.lstrip().startswith("#")]
        want_body = [line for stage, when in (("hold", "before"), ("restore", "after"))
                     for line in (f"  - command: '{RUNPY}{MIGRATION}\" {stage}'",
                                  f"    when: \"<% _stage == '{when}' %>\"")]
        if body != want_body:
            finding(8, f"the D48 migrations block must hold only the hold entry (before) and the restore entry (after) of {MIGRATION}, run by _copier_python, in that order, and comments")
        # First in _migrations: restore must run before every other after-stage entry.
    if name == "migrations":
        lines = (root / "copier.yml").read_text(encoding="utf-8").splitlines()
        above = [l for l in lines[:lines.index(begin)] if l.strip() and not l.lstrip().startswith("#")]
        if not above or above[-1] != "_migrations:":
            finding(8, "the D48 migrations block must open _migrations: its restore entry runs before every other after-stage migration only from there")
    if name == "update":
        body = [l for l in blk if l.strip() and not l.lstrip().startswith("#")]
        if body != WANT_UPDATE:
            finding(13, f"the D48 update block must hold only the update entry of {UPDATE} (_stage 'after', run by _copier_python), line for line, and comments")
        lines = (root / "copier.yml").read_text(encoding="utf-8").splitlines()
        after = []
        for l in lines[lines.index(end) + 1:]:
            if re.match(r"[A-Za-z_][A-Za-z0-9_]*:", l):
                break
            if l.strip() and not l.lstrip().startswith("#"):
                after.append(l)
        above = [l for l in lines[:lines.index(begin)] if l.strip() and not l.lstrip().startswith("#")]
        tops = [l for l in above if re.match(r"[A-Za-z_][A-Za-z0-9_]*:", l)]
        if after or not tops or tops[-1] != "_migrations:":
            finding(13, "the D48 update block must close _migrations: the report judges what every other migration left")
    if name in ("migrations", "update"):
        names = other_templates(btext)
        if names:
            finding(11, f"the D48 {name} block names {', '.join(names)}; it is copied verbatim into the other template")
        dnums = sorted(set(decision.findall(btext)))
        if dnums:
            finding(11, f"the D48 {name} block names decision {', '.join(dnums)}; it is copied verbatim into the other template")
    bad = foreign_keys(btext, extra=extra)
    if bad:
        finding(5, f"the D48 {name} block uses {', '.join(bad)} — only the seven shared keys and {', '.join(extra)}")
    if OWNER in btext:
        finding(6, f"the D48 {name} block names {OWNER}; it is copied verbatim into the other template")
    mb = mblocks.get(name)
    if man is not None and isinstance(mb, dict):
        be = block_entry(name, begin, end, blk)
        if (mb.get("bytes"), mb.get("sha256")) != (be["bytes"], be["sha256"]):
            finding(9, f"the D48 {name} block differs from {manifest_path.name} (bytes {mb.get('bytes')} != {be['bytes']}) — run family-shared.sh --write if the change is meant")

# ── 14. The baseline task closes _tasks; 15. the refresh set (D51, D52) ──
def top_section(lines, key):
    """The lines of one top-level key of copier.yml, up to the next top-level key."""
    out, on = [], False
    for l in lines:
        if re.match(r"[A-Za-z_][A-Za-z0-9_]*:", l):
            on = l.split(":")[0] == key
            continue
        if on:
            out.append(l)
    return out

def items(lines):
    return [m.group(1).strip().strip('"').strip("'") for l in lines if (m := re.match(r"  - (.*)$", l))]

try:
    clines = (root / "copier.yml").read_text(encoding="utf-8").splitlines()
except OSError:
    clines = []
if clines:
    tasks = [l for l in top_section(clines, "_tasks") if l.strip() and not l.lstrip().startswith("#")]
    if tasks[-2:] != WANT_TASK:
        finding(14, f"the baseline task of {UPDATE} (copy only, run by _copier_python) must be the last entry of _tasks, line for line")
    # 17. Every task is copy only: an update changes files only through the merge and the
    # migrations, which report what they did; an ungated chmod would change a shared hook's
    # mode on every update.
    entries = []
    for l in tasks:
        if l.startswith("  - "):
            entries.append([l])
        elif entries:
            entries[-1].append(l)
    for e in entries:
        if not any(re.match(r'\s+when: "<% _copier_operation == \'copy\'( |%)', l) for l in e):
            finding(17, f"the task {e[0].strip()[2:][:70]} is not copy only — its when: must open with _copier_operation == 'copy', or it runs on every update")
    skips, excl = set(items(top_section(clines, "_skip_if_exists"))), items(top_section(clines, "_exclude"))
    gate = re.compile(r"<: if _copier_operation == 'update' :>(/[^<]*)<: endif :>")
    on_update = {m.group(1) for x in excl if (m := gate.fullmatch(x))}
    for p in REFRESH:
        if "/" + p not in skips:
            finding(15, f"the shared {p} has no anchored _skip_if_exists line — a copy over a sibling's copy would abort or overwrite it")
        if "/" + p not in on_update:
            finding(15, f"the shared {p} has no _exclude line gated on the update — an update would merge into it, or delete the sibling's copy")
        parts = p.split("/")
        for i in range(1, len(parts)):
            folder = "/" + "/".join(parts[:i])
            if folder in skips or folder in on_update:
                finding(15, f"copier.yml names the folder {folder} copy-only; the shared lines are file-level, so the template's own mode files beside {p} stay template-owned")
        if p.startswith(".claude/hooks/") and p.endswith(".sh") and (root / "template" / p).is_file() and not os.stat(root / "template" / p).st_mode & 0o111:
            finding(15, f"template/{p} is not executable — a copy over the sibling's 755 copy would see a conflict")
    try:
        rd = json.loads((root / REFRESH_DATA).read_text(encoding="utf-8"))
    except (OSError, ValueError) as err:
        rd = None
        finding(15, f"{REFRESH_DATA} cannot be read as JSON ({err})")
    if isinstance(rd, dict):
        if rd.get("format") != 1 or rd.get("template") != OWNER:
            finding(15, f"{REFRESH_DATA} must hold format 1 and template {OWNER}")
        if sorted(rd.get("refresh") or []) != sorted(REFRESH):
            finding(15, f"{REFRESH_DATA} refreshes {sorted(set(rd.get('refresh') or []) ^ set(REFRESH))} differently from the shared set")
        hooks = (rd.get("settings") or {}).get("hooks") or {}
        for event, entries in hooks.items():
            for e in entries if isinstance(entries, list) else []:
                for h in (e.get("hooks") or []) if isinstance(e, dict) else []:
                    named = re.findall(r"\.claude/hooks/[A-Za-z0-9._-]+", str(h.get("command", "")))
                    if not named or any(n not in REFRESH for n in named):
                        finding(15, f"{REFRESH_DATA} wires a {event} hook that runs no hook of the shared set ({named or 'none'})")

# ── 16. Mode-file names beside the shared skills (D51) ──
# A moded shared SKILL.md reads every upper-case .md beside it as a mode file, in every family
# template. This template's are THEOLOGY.md, FICTION.md and BUSINESS.md; the companion's are
# MEDIA-<KIND>.md. Neither template may ship a name of the other's, or anything else there.
OWN_MODES = set(os.environ["FS_MODE_FILES"].split())
SIB_MODE = re.compile(os.environ["FS_SIBLING_MODE_RE"])
SHARED_SKILL_DIRS = sorted({p.rsplit("/", 1)[0] for p in REFRESH if p.startswith(".claude/skills/") and p.endswith("/SKILL.md")})
tpl = root / "template"
if tpl.is_dir():
    for dp, dns, fns in os.walk(tpl):
        dns[:] = [d for d in dns if d != ".git"]
        for fn in fns:
            if SIB_MODE.match(fn):
                rel = os.path.relpath(os.path.join(dp, fn), root)
                finding(16, f"{rel} takes the companion template's mode-file prefix (MEDIA-*); this template's mode files are {', '.join(sorted(OWN_MODES))}")
    for d in SHARED_SKILL_DIRS:
        folder = tpl / d
        if not folder.is_dir():
            continue
        for fn in sorted(os.listdir(folder)):
            if fn == "SKILL.md" or fn in OWN_MODES or SIB_MODE.match(fn):
                continue
            finding(16, f"template/{d}/{fn} sits beside a family-shared SKILL.md; that folder holds only SKILL.md and this template's mode files, because the neutral Mode paragraph reads every upper-case .md there")

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
        for path, source, scope in sorted(files):
            fallback = path if scope == "repository" else "template/" + path.replace("<template>", sname)
            ssrc = sfiles.get(path, {}).get("source") or fallback
            a, b = root / source, sroot / ssrc
            if path in links:
                same = b.is_symlink() and a.is_symlink() and os.readlink(a) == os.readlink(b)
            else:
                same = b.is_file() and a.is_file() and a.read_bytes() == b.read_bytes()
            if not same:
                finding(10, f"the sibling's {ssrc} differs from our {source}, or is absent")
        for d in SHARED_SKILL_DIRS:
            sfolder = sroot / "template" / d
            for fn in sorted(os.listdir(sfolder)) if sfolder.is_dir() else []:
                if fn in OWN_MODES:
                    finding(16, f"the sibling's template/{d}/{fn} takes this template's mode-file name; in a project that takes both, one would overwrite the other")
        for name, begin, end, _ in BLOCKS:
            sblk, err = block_lines(sroot / "copier.yml", begin, end)
            if blks[name][0] is not None and sblk != blks[name][0]:
                finding(10, f"the sibling's D48 {name} block differs from ours{' (' + err + ')' if sblk is None else ''}")

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

fixture() { # $1 = dir: a template repository holding the shared set and the three blocks
  local t="$1" pair source p
  mkdir -p "$t/template/.agents" "$t/template/.claude/skills" "$t/template/.codex" "$t/template/.gemini" "$t/migrations"
  printf '0.3.0\n' > "$t/VERSION"
  for pair in "${FS_FILES[@]}"; do
    [[ "${pair%%|*}" == .agents/skills ]] && continue
    source="${pair#*|}"; source="${source%%|*}"
    mkdir -p "$(dirname "$t/$source")"
    printf 'shared text for %s\n' "${pair%%|*}" > "$t/$source"
  done
  for p in $SA_SHARED_HOOKS; do chmod +x "$t/template/$p"; done
  printf "import os\nOPT_OUT = os.environ.get('SYNTEK_UPDATE_REPORT')\n" > "$t/migrations/family-update.py"
  python3 - "$t/$FS_REFRESH_DATA" "$SA_SHARED_PRACTICE" <<'JSON'
import json, sys
paths = sys.argv[2].split()
hook = "bash -c 'exec bash .claude/hooks/context-threshold-handoff.sh'"
json.dump({"format": 1, "template": "syntek-author", "refresh": paths,
           "settings": {"hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": hook}]}]},
                        "permissions": {"deny": ["Edit(build/**)"], "ask": []}}}, open(sys.argv[1], "w"), indent=2)
JSON
  printf "HELD = '%s'\nprint('the bridge (.claude/syntek-*-agents.md)')\n" "$FS_HELD" > "$t/migrations/agents-outside-link.py"
  printf '{\n  "model": <%% OPENCODE_MODEL | tojson %%>\n}\n' > "$t/template/opencode.json"
  ln -s ../.claude/skills "$t/template/.agents/skills"
  {
    printf 'PROJECT_NAME:\n  type: str\n\n%s\n' "$FS_BEGIN"
    printf 'AGENT_CLIENTS:\n  default: "<%% %s if _external_data.prev.get(%s) else %s %%>"\n' "'[]'" "'_commit'" "'[codex]'"
    for k in CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT; do
      printf '%s:\n  type: str\n  when: "<%% %s in AGENT_CLIENTS %%>"\n' "$k" "'opencode'"
    done
    printf '%s\n\nTIMEZONE:\n  type: str\n\n' "$FS_END"
    printf '_exclude:\n  - .git\n'
    for p in $SA_SHARED_PRACTICE; do printf '  - "<: if _copier_operation == %s :>/%s<: endif :>"\n' "'update'" "$p"; done
    printf '_skip_if_exists:\n'
    for p in $SA_SHARED_PRACTICE; do printf '  - /%s\n' "$p"; done
    printf '\n_migrations:\n%s\n' "$FS_MIG_BEGIN"
    printf '  # Runs on every update.\n'
    printf '  - command: %s"<%% _copier_python %%>" "<%% _copier_conf.src_path %%>/migrations/agents-outside-link.py" %s%s\n    when: "<%% _stage == %s %%>"\n' \
      "'" hold "'" "'before'" "'" restore "'" "'after'"
    printf '%s\n  - version: v0.2.0\n    command: bash "<%% _copier_conf.src_path %%>/migrations/v0.2.0-x.sh"\n' "$FS_MIG_END"
    printf '%s\n  # Runs last.\n' "$FS_UPD_BEGIN"
    printf '%s\n' "  - command: '\"<% _copier_python %>\" \"<% _copier_conf.src_path %>/migrations/family-update.py\" update --src \"<% _copier_conf.src_path %>\" --to <% _copier_conf.vcs_ref_hash %> --answers \"<% _copier_conf.answers_file %>\"'" \
      "    when: \"<% _stage == 'after' %>\""
    printf '%s\n\n_tasks:\n  - command: "git init"\n    when: "<%% _copier_operation == %s %%>"\n' "$FS_UPD_END" "'copy'"
    printf '%s\n' "  - command: '\"<% _copier_python %>\" \"<% _copier_conf.src_path %>/migrations/family-update.py\" baseline --src \"<% _copier_conf.src_path %>\" --to <% _copier_conf.vcs_ref_hash %> --answers \"<% _copier_conf.answers_file %>\"'" \
      "    when: \"<% _copier_operation == 'copy' %>\""
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

  # The repository-scoped migration script and the migrations block.
  local mig="$SA_ROOT/migrations/agents-outside-link.py"
  cp "$m" "$tmp/m"; sed -i 's/"scope": "repository", //' "$m"
  probe "check 2 fires when the migration script loses its repository scope" "check 2"
  cp "$tmp/m" "$m"; sed -i 's/"path": "AGENTS.md", "source": "template\/AGENTS.md", "kind": "file"/&, "scope": "repository"/' "$m"
  probe "check 2 fires when a project file is given the repository scope" "check 2"
  cp "$tmp/m" "$m"; python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); m["blocks"]=m["blocks"][:1]; json.dump(m,open(sys.argv[1],"w"))' "$m"
  probe "check 2 fires when the migrations block is not listed" "check 2"
  cp "$tmp/m" "$m"; cp "$mig" "$tmp/mig"
  printf "x = '<%% _stage %%>'\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on any delimiter in the migration script" "check 5 — migrations/agents-outside-link.py"
  cp "$tmp/mig" "$mig"; printf "# from syntek-author\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 6 fires when the migration script names syntek-author" "check 6 — migrations/agents-outside-link.py"
  cp "$tmp/mig" "$mig"; printf "# see .claude/syntek-media-agents.md\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the migration script names another template" "check 11 — migrations/agents-outside-link.py names syntek-media"
  cp "$tmp/mig" "$mig"; printf "# see syntek_media and the bridge\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires on another spelling of a template name" "check 11 — migrations/agents-outside-link.py names syntek_media"
  cp "$tmp/mig" "$mig"; printf "# SyntekMedia does the same\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires on a template name without a separator" "check 11 — migrations/agents-outside-link.py names SyntekMedia"
  cp "$tmp/mig" "$mig"; printf "# Decided in D76.\n" >> "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the migration script names a decision number" "check 11 — migrations/agents-outside-link.py names decision D76"
  cp "$tmp/mig" "$mig"; sed -i "s/^HELD = .*/HELD = '.agents.held'/" "$mig"; fs_py write "$SA_ROOT" ""
  probe "check 12 fires when the held name is not the family's" "check 12"
  cp "$tmp/mig" "$mig"; fs_py write "$SA_ROOT" ""
  printf '%s\n' "$FS_MIG_BEGIN" >> "$c";                                           probe "check 7 fires on a second migrations BEGIN marker" "check 7"
  cp "$tmp/c" "$c"; sed -i "s/^$FS_MIG_END\$/- version: v0.9.9\n$FS_MIG_END/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 8 fires on a line at column 0 inside the migrations block" "check 8 — the D48 migrations block"
  cp "$tmp/c" "$c"; sed -i "s/ restore'\$/ hold'/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 8 fires when the restore entry is gone" "check 8 — the D48 migrations block"
  cp "$tmp/c" "$c"; sed -i "s/^$FS_MIG_END\$/  - version: v0.9.9\n    command: x\n$FS_MIG_END/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 8 fires on an indented extra entry inside the migrations block" "check 8 — the D48 migrations block must hold only"
  cp "$tmp/c" "$c"; python3 - "$c" "$FS_MIG_BEGIN" "$FS_MIG_END" <<'MOVE'
import sys
p, b, e = sys.argv[1:]
lines = open(p).read().split("\n")
i, j = lines.index(b), lines.index(e)
blk, rest = lines[i:j + 1], lines[:i] + lines[j + 1:]
k = rest.index("    command: bash \"<% _copier_conf.src_path %>/migrations/v0.2.0-x.sh\"") + 1
open(p, "w").write("\n".join(rest[:k] + blk + rest[k:]))
MOVE
  fs_py write "$SA_ROOT" ""
  probe "check 8 fires when the migrations block is not first in _migrations" "check 8 — the D48 migrations block must open _migrations"
  cp "$tmp/c" "$c"; sed -i "s/^  # Runs on every update\.\$/  # Runs on every syntek-media update./" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the migrations block names a template" "check 11 — the D48 migrations block"
  cp "$tmp/c" "$c"; sed -i "s/^  # Runs on every update\.\$/  # D11: runs on every update./" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the migrations block names a decision number" "check 11 — the D48 migrations block names decision D11"
  cp "$tmp/c" "$c"; fs_py write "$SA_ROOT" ""
  sed -i 's/^  # Runs on every update\.$/  # Runs on each update./' "$c";               probe "check 9 fires when the migrations block changes" "check 9 — the D48 migrations block"
  cp "$tmp/c" "$c"
  # The update script, its block and task, and the refresh set (D51, D52).
  local upd="$SA_ROOT/migrations/family-update.py" skill="$SA_ROOT/template/.claude/skills/handoff/SKILL.md"
  local rd="$SA_ROOT/$FS_REFRESH_DATA" hookf="$SA_ROOT/template/.claude/hooks/context-threshold-handoff.sh"
  cp "$upd" "$tmp/upd"; printf "# writes refs/syntek-media/template\n" >> "$upd"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the update script names another template" "check 11 — migrations/family-update.py names syntek-media"
  cp "$tmp/upd" "$upd"; printf "x = '<%% _stage %%>'\n" >> "$upd"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on any delimiter in the update script" "check 5 — migrations/family-update.py"
  cp "$tmp/upd" "$upd"; printf 'SYNTEK_UPDATE_COPIER = 1\n' >> "$upd"; fs_py write "$SA_ROOT" ""
  probe_clean "the update script's own SYNTEK_UPDATE_* variables are not template names"
  cp "$tmp/upd" "$upd"; fs_py write "$SA_ROOT" ""; cp "$skill" "$tmp/skill"
  printf 'Ask <%%AUTHOR_FIRST_NAME%%> first.\n' >> "$skill"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on a delimiter in a shared skill" "check 5 — template/.claude/skills/handoff/SKILL.md holds a template delimiter"
  cp "$tmp/skill" "$skill"; fs_py write "$SA_ROOT" ""
  sed -i 's/ update --src / report --src /' "$c"; fs_py write "$SA_ROOT" ""
  probe "check 13 fires when the update entry changes" "check 13 — the D48 update block must hold only"
  cp "$tmp/c" "$c"; sed -i "s/^$FS_UPD_END\$/$FS_UPD_END\n  - version: v0.9.9\n    command: x/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 13 fires on an entry after the update block" "check 13 — the D48 update block must close _migrations"
  cp "$tmp/c" "$c"; printf '  - command: "echo late"\n    when: "<%% _copier_operation == %s %%>"\n' "'copy'" >> "$c"; fs_py write "$SA_ROOT" ""
  probe "check 14 fires on a task after the baseline task" "check 14"
  cp "$tmp/c" "$c"; python3 - "$c" <<'PY'
import sys
p = sys.argv[1]; lines = open(p).read().split("\n")
i = lines.index('  - command: "git init"'); del lines[i + 1]
open(p, "w").write("\n".join(lines))
PY
  fs_py write "$SA_ROOT" ""
  probe "check 17 fires on a task without its copy-only gate" "check 17 — the task command: \"git init\" is not copy only"
  cp "$tmp/c" "$c"; grep -vxF '  - /.claude/skills/wayfinder/SKILL.md' "$tmp/c" > "$c"; fs_py write "$SA_ROOT" ""
  probe "check 15 fires when a shared file loses its skip line" "check 15 — the shared .claude/skills/wayfinder/SKILL.md has no anchored _skip_if_exists line"
  cp "$tmp/c" "$c"; grep -vF ":>/handoffs/CLAUDE.md<:" "$tmp/c" > "$c"; fs_py write "$SA_ROOT" ""
  probe "check 15 fires when a shared file loses its update exclusion" "check 15 — the shared handoffs/CLAUDE.md has no _exclude line"
  cp "$tmp/c" "$c"; sed -i 's#^  - /handoffs/CONTEXT.md$#&\n  - /.claude/skills/handoff#' "$c"; fs_py write "$SA_ROOT" ""
  probe "check 15 fires on a folder-level line" "check 15 — copier.yml names the folder /.claude/skills/handoff"
  cp "$tmp/c" "$c"; chmod -x "$hookf"; fs_py write "$SA_ROOT" ""
  probe "check 15 fires on a hook that is not executable" "check 15 — template/.claude/hooks/context-threshold-handoff.sh is not executable"
  chmod +x "$hookf"; fs_py write "$SA_ROOT" ""; cp "$rd" "$tmp/rd"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["refresh"].pop(); json.dump(d,open(sys.argv[1],"w"))' "$rd"
  probe "check 15 fires when family-refresh.json leaves a shared file out" "check 15 — $FS_REFRESH_DATA refreshes"
  cp "$tmp/rd" "$rd"; sed -i "s#exec bash .claude/hooks/context-threshold-handoff.sh#exec bash .claude/hooks/private-hook.sh#" "$rd"
  probe "check 15 fires on a hook entry outside the shared set" "check 15 — $FS_REFRESH_DATA wires a UserPromptSubmit hook"
  cp "$tmp/rd" "$rd"
  # Mode-file names beside the shared skills (check 16).
  local gfold="$SA_ROOT/template/.claude/skills/grilling" hookdoc="$SA_ROOT/template/.claude/hooks/CONTEXT.md"
  [[ -f "$hookdoc" && ! -x "$hookdoc" ]] && probe_clean "a shared hooks-folder CONTEXT.md is not held to a hook's mode 755"
  printf '# Grilling — fiction mode\n' > "$gfold/FICTION.md"; probe_clean "this template's own mode file beside a shared skill is accepted"
  printf '# Grilling — media fiction mode\n' > "$gfold/MEDIA-FICTION.md"
  probe "check 16 fires on a MEDIA-* mode file beside a shared skill under template/" "check 16 — template/.claude/skills/grilling/MEDIA-FICTION.md takes the companion"
  rm "$gfold/MEDIA-FICTION.md"; mkdir -p "$SA_ROOT/template/standards/method"; printf 'x\n' > "$SA_ROOT/template/standards/method/MEDIA-BUSINESS.md"
  probe "check 16 fires on a MEDIA-* name anywhere under template/" "check 16 — template/standards/method/MEDIA-BUSINESS.md"
  rm -r "$SA_ROOT/template/standards"; printf 'x\n' > "$gfold/NOTES.md"
  probe "check 16 fires on any other file beside a shared skill" "check 16 — template/.claude/skills/grilling/NOTES.md"
  rm "$gfold/NOTES.md" "$gfold/FICTION.md"
  sib="$tmp/sibling"; cp -a "$SA_ROOT" "$sib"
  printf '# Grilling — media nonfiction mode\n' > "$sib/template/.claude/skills/grilling/MEDIA-NONFICTION.md"
  mv "$sib/template/.claude/syntek-author-permissions.py" "$sib/template/.claude/syntek-media-permissions.py"
  sed -i 's/"owner": "syntek-author"/"owner": "syntek-media"/; /"path": ".claude\/syntek-<template>-permissions.py"/s/syntek-author-permissions/syntek-media-permissions/' "$sib/$FS_MANIFEST"
  SIBLING="$sib";                                                                probe_clean "a sibling with identical copies under its own name, and MEDIA-* mode files beside a shared skill, is clean"
  printf '# x\n' > "$sib/template/.claude/skills/grilling/THEOLOGY.md"
  probe "check 16 fires when the sibling ships this template's mode-file name beside a shared skill" "check 16 — the sibling's template/.claude/skills/grilling/THEOLOGY.md"
  rm "$sib/template/.claude/skills/grilling/THEOLOGY.md"
  printf 'drifted\n' > "$sib/template/AGENTS.md";                                  probe "check 10 fires when a sibling's copy drifts" "check 10 — the sibling's template/AGENTS.md"
  cp "$SA_ROOT/template/AGENTS.md" "$sib/template/AGENTS.md"
  printf '# drifted\n' >> "$sib/migrations/agents-outside-link.py";                 probe "check 10 fires when a sibling's migration script drifts" "check 10 — the sibling's migrations/agents-outside-link.py"
  cp "$SA_ROOT/migrations/agents-outside-link.py" "$sib/migrations/agents-outside-link.py"
  sed -i 's/^  # Runs on every update\.$/  # Runs on each update./' "$sib/copier.yml"; probe "check 10 fires when a sibling's migrations block drifts" "check 10 — the sibling's D48 migrations block"
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
  bold "✓ ${#FS_FILES[@]} shared file(s), the question, migrations and update blocks match $FS_MANIFEST and stay template-neutral; the update entry closes _migrations, its baseline task closes _tasks, and $FS_REFRESH_DATA refreshes exactly the shared working practice."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
exit 1
