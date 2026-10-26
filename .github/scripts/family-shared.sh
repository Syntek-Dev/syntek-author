#!/usr/bin/env bash
#
# family-shared.sh — Hold the family-shared files to one set of bytes (DESIGN.md D48).
#
#                    A project can take syntek-author and syntek-media, in either order. The
#                    files both templates write at the same path (the client entrypoints, the
#                    .agents/ folder, the .codex/ and .gemini/ pairs, opencode.json, .mcp.json),
#                    the permissions script and the data-root resolver both ship under their own
#                    name (D49, D50), and the question block that renders them must be
#                    byte-identical in both templates' sources. Otherwise whichever template
#                    copies first decides what the project holds, and the other template's
#                    promises about those files are false. syntek-author owns the sources; root
#                    family-shared.json records their source bytes, which the other template
#                    vendors and checks. Two more are shared at the template repository's root
#                    rather than in a project (manifest "scope": "repository"): the outside-link
#                    migration, migrations/agents-outside-link.py, and the copier.yml block of
#                    _migrations entries that runs it. D51 adds the shared working practice
#                    (seven SKILL.md files, the two session hooks at mode 755 and the handoffs/
#                    pair), copy-only in every family template; D52 adds the script that
#                    reports every update and refreshes those files, migrations/family-update.py
#                    (repository scope), its _migrations block, which closes _migrations, and
#                    its copy-time task, which closes _tasks. Each template's own
#                    migrations/family-refresh.json lists what that script may refresh and add
#                    to settings.json; it is per template, so it is checked here, not shared.
#                    D54 adds a fourth block, rules-web-tools: the lines between two marker
#                    lines of rules 06, the responsible-use rule for the two MCP servers every
#                    shared MCP file declares with one set of pins, one tool list and the same
#                    blank keys. D50 adds the resolver and seven data-root questions to the
#                    block, D53 DATA_PROVIDER, whose default alone reads the retired
#                    INCLUDE_DRIVE_SYNC by name. D56 adds the user guide's shared files: the
#                    five container pairs of how-to/ and its three shared chapters, copy-only
#                    and refreshed exactly as D51's files, and the guide guard
#                    (.claude/hooks/how-to-read-only.sh) to the working practice; each
#                    template's own how-to files sit only under folders named for it.
#
#                    So the shared files must also be neutral: a shared file may use only the
#                    seven shared question keys, and may name no syntek-author path (it says
#                    'every .claude/syntek-*-agents.md' instead). A shared skill, hook,
#                    handoffs or how-to file holds no delimiter at all (D51, D56): the refresh
#                    compares bytes.
#
#                    Thirty checks:
#                      1. family-shared.json exists, is JSON, and has format 1, owner
#                         syntek-author and release 'unreleased' or 'v' + VERSION: 'v' +
#                         VERSION on the commit that tag names and on a commit whose VERSION
#                         no tag has yet (the release commit), 'unreleased' once that tag is
#                         an ancestor of HEAD; either where git cannot tell (no repository at
#                         the root, no tags). --write sets it where git can tell.
#                      2. Its files are exactly the shared set below, each with its source,
#                         kind and scope ("scope" absent means "project"; the two migration
#                         scripts are "repository"), sorted by path: the data-root resolver is
#                         listed, its per-template map is not. Its blocks are exactly the
#                         question, migrations and update blocks of copier.yml, then the
#                         rules-web-tools block of rules 06 with its destination, in order.
#                      3. Every listed source exists, as a file or a link as listed.
#                      4. Every file's size, sha256 and mode ("mode": "755" for an executable
#                         source) match; every link's target matches.
#                      5. A shared file uses inside a delimiter a key other than the seven
#                         shared keys; the question block reads a name other than its fifteen
#                         keys, _external_data, _folder_name and UNSET; a migration block one
#                         other than the seven keys, _copier_conf, _stage and _copier_python;
#                         or the permissions script, the data-root resolver, the migration
#                         scripts, the rules-web-tools block and every shared skill, hook,
#                         handoffs file and how-to file hold any delimiter at all.
#                      6. A shared file, or a block, names syntek-author in any spelling
#                         (any case; -, _, a space or nothing between the words).
#                      7. A block's file (copier.yml; rules 06 for rules-web-tools) holds each
#                         of its marker lines exactly once, BEGIN before END.
#                      8. The question block's top-level keys are exactly its fifteen keys (the
#                         seven shared ones, the seven data-root ones and DATA_PROVIDER), in
#                         that order; the migrations block holds only the hold and the restore
#                         entry of migrations/agents-outside-link.py, run by _copier_python, in
#                         that order, line for line, and comments, and it opens _migrations
#                         (restore runs first).
#                      9. Each block's size and sha256 match the manifest.
#                     10. --sibling DIR: the sibling template's copies of the shared sources
#                         and its four blocks (rules-web-tools at its destination, under the
#                         sibling's own name) match ours byte for byte.
#                     11. A shared file (the agent files, the permissions script, the resolver, the
#                         shared skills, hooks, handoffs and how-to files, the migration scripts)
#                         or a block names another template (syntek-<name> in any case,
#                         syntek_<name> or Syntek<Name>, other than its held name, the syntek-*
#                         pattern and the names that are not templates: SYNTEK_UPDATE_*, and the
#                         data root's SYNTEK_DATA_ROOT, .syntek-data-root marker and .syntek-tmp
#                         suffix, found as SYNTEK_DATA, syntek-data-root and syntek-tmp), or a
#                         decision number (D<n>); the rules-web-tools block and the shared how-to
#                         files also name no section number, in either case ('Section 3' or
#                         'section 3'), nor a template's rules file by number ('rules 06').
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
#                     15. The refresh set (D51, D56): migrations/family-refresh.json is format
#                         1 for syntek-author and refreshes exactly the shared skills, hooks
#                         (the guide guard among them), handoffs files and D56's shared how-to
#                         files; each has an anchored _skip_if_exists line and an _exclude line
#                         gated on the update, file by file, and no such line names a folder
#                         above it; each hook is executable; each settings hook entry runs a
#                         hook of the set. With --sibling, each shared how-to file the sibling
#                         ships has its anchored skip line, its update-gated exclusion and a
#                         refresh entry in the sibling's own files, and no skip or update-gated
#                         exclusion line of the sibling's names /how-to or a folder under it; a
#                         sibling whose refresh data lists no "restore" gets a note, never a
#                         finding.
#                     16. Mode-file names beside the shared skills (D51): no file under
#                         template/ takes the companion's mode-file prefix (MEDIA-*.md); a
#                         shared skill's folder under template/ holds only SKILL.md and this
#                         template's own mode files (THEOLOGY.md, FICTION.md, BUSINESS.md); and,
#                         with --sibling, the sibling's shared skill folders hold none of this
#                         template's mode-file names. The sibling's MEDIA-*.md there are accepted.
#                     17. Every _tasks entry is copy only: its when: opens with
#                         _copier_operation == 'copy' (the chmod of the shared hooks included),
#                         so no task changes a project on update (D51, D52).
#                     18. The pins (D54): each of the five MCP files, parsed once its
#                         if-regions are removed, declares exactly code-review-graph then
#                         scrapling at its key path, each run by uvx with exactly the pinned
#                         arguments (OpenCode: a local command list). A misspelt pin fails only
#                         at first start, on the owner's machine.
#                     19. The tool list: code-review-graph's --tools value is the held list (29
#                         names, never embed_graph_tool) in each file, and embed_graph_tool
#                         appears nowhere else in them but as OpenCode's deny action. The tool
#                         validates none of it: an empty value would expose all 30.
#                     20. The blank keys: code-review-graph's env (OpenCode: environment) is
#                         exactly the six blank keys, in order, each ""; scrapling has none; no
#                         server entry holds another key.
#                     21. The rules and their order: the seed settings.json (gates removed)
#                         asks exactly the eight MCP asks, in order, and denies
#                         embed_graph_tool; family-refresh.json lists the same; Gemini CLI's
#                         confirmationRequired, OpenCode's asks (before every deny, with the
#                         deny) and Codex's prompt tables follow the one order. Nothing removes
#                         a prompt for either server: no mcp__ allow rule, no Gemini trust, no
#                         Codex default_tools_approval_mode or approval_mode other than
#                         "prompt", and no enableAllProjectMcpServers, enabledMcpjsonServers or
#                         disabledMcpjsonServers in the seed, family-refresh.json or a shared
#                         file. No install artefact: code-review-graph's install markers in no
#                         file under template/, and no hook command naming it in the seed or
#                         family-refresh.json.
#                     22. The lane data: family-refresh.json's "mcp" names exactly the five MCP
#                         files with their key paths, and the servers of .mcp.json; each listed
#                         server is in each listed file at its key path.
#                     23. The store's equality rule (D50): a Jinja expression in copier.yml or
#                         under template/ compares the DATA_STORE identifier by != or not in
#                         with a literal (or by the tests is ne, is !=, is not eq, is not
#                         equalto, is not sameas, is not ==), negates an == or in test of it
#                         with not (directly, through brackets, or over a group that holds
#                         one; only a copier.yml _exclude item of the house form
#                         "<: if not (GATE) :>/path<: endif :>" may, because it excludes), tests
#                         it bare, gives a block whose if (or an earlier
#                         elif) tests it an else or elif arm, or tests it in an inline
#                         if … else. Each else and elif pairs with its own if; a
#                         .get('DATA_STORE') read is a string, not the identifier, and a shell
#                         test lies outside Jinja. Each means 'not that value', which a later
#                         store value (lfs) would open.
#                     24. copier.yml's _external_data holds one peer key, naming another family
#                         template's answers file (.copier-answers.syntek-<name>.yml), never
#                         this template's own.
#                     25. The retired key (D53): inside the question block's delimiters, every
#                         string literal in the form of an UPPER_SNAKE key (capitals and digits
#                         with at least one underscore) is one of the fifteen keys, or one of
#                         exactly two 'INCLUDE_DRIVE_SYNC' literals, both in DATA_PROVIDER's
#                         default. The shared block reads no other template's answer by name.
#                     26. The data-root resolver names a top-level folder of template/ (and,
#                         with --sibling, of the sibling's template/) other
#                         than .claude, .agents, .codex and .gemini: as a path (name/, not
#                         after a word character, a dot or a hyphen) or a quoted name, case
#                         kept. A bare English word ('a library') is not a folder.
#                     27. A shared file or a block names a path only one template ships (D48):
#                         a top-level entry of template/ that is neither a family path (the
#                         shared set's, and .claude, .agents, .codex, .gemini and handoffs) nor
#                         a house file every family template's root holds (CONTEXT.md, CLAUDE.md,
#                         README.md, .gitignore), less, with --sibling, every top-level entry of
#                         the sibling's template/; with --sibling, also a top-level entry only
#                         the sibling's template/ holds (its answers file apart), reported as
#                         the sibling's. A use counts only where it is path-like: name/ (not
#                         after a word character, a dot or a hyphen), …/name ending a path, a
#                         quoted name, resource or glob, or, for a name holding a dot, the name
#                         itself. A URL is never read, nor a path under a family folder
#                         (.claude/skills/<name>/ is no top-level path). In Markdown (a shared
#                         .md and the rules-web-tools block), two plain words joined by one
#                         slash outside quotes ('people/world') are prose, and a quoted name
#                         counts only with a slash or a glob after it; in code a bare quoted name
#                         counts. The one exception: opencode.json's three edit denies, '*.pdf',
#                         'build/*' and 'typeset/src/units/.base/*', each a top-level
#                         permissions entry of exactly that action, resource and effect; the
#                         same resource anywhere else counts. A resolver folder check 26 already
#                         reported is not reported again, and a name holding the owner's is
#                         check 6's. how-to is a family path (D56), so opencode.json's how-to/*
#                         edit deny is no finding.
#                     28. Shared how-to text (D56), the first problem per file: 'make <target>'
#                         in any case ('Make lint' opening a sentence) for a target
#                         template/Makefile defines (its ^[a-z][a-z-]*: lines, so plain English
#                         such as 'make a copy' never matches); a backticked skill name of the
#                         catalogue other than D51's seven, or a .claude/skills/<name>/ path for
#                         any other skill; in a command fence (info string bash, sh, shell,
#                         console or none; a text fence, which holds a tree, is never read) a
#                         line holding a <word> placeholder, …, [...] or ...; a **Last Updated**
#                         header.
#                     29. The how-to namespace (D56): every path under template/how-to/ is a
#                         shared how-to file or lies under one of this template's own folders
#                         (how-to/docs/, how-to/src/TEMPLATE-GUIDE/ and how-to/workflows/, each
#                         with syntek-author/); no folder directly inside those three has
#                         another name (a MEDIA-* name there is check 16's). With --sibling,
#                         the sibling ships no how-to path outside the shared set and its own
#                         folders, and none under a syntek-author/ folder. The first problem
#                         per path; a file under a folder already reported is not reported
#                         again.
#                     30. Restore and guard (D56), the first of: family-refresh.json's
#                         "restore" is not exactly ["how-to"]; the guide guard is not in the
#                         shared set; family-refresh.json wires no settings.hooks.PreToolUse
#                         entry running the guard's script; family-refresh.json's
#                         settings.permissions.deny lacks the guide's Edit(/how-to/**), so an
#                         existing project would never be offered it; template/opencode.json
#                         (its gates removed) lacks exactly one top-level permissions entry
#                         {"action": "edit", "resource": "how-to/*", "effect": "deny"} after
#                         every ask.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
#                    What it CANNOT check: that the rendered files are identical in a project
#                    that took both templates (coexist-test.sh renders that), that the
#                    sibling's manifest is current (its own audit checks that), that the
#                    pinned versions still exist (it runs offline), a DATA_STORE test made
#                    through an alias (<: set s = DATA_STORE :> and a later bare s), or one
#                    whose negation hides in a test of the in test (is not in) or a macro;
#                    another template named with a space ('Syntek Media'), which ordinary prose
#                    ('a syntek template') shares, so only the owner's own name is caught that
#                    way. Check 27 cannot see a path below a family folder that only one
#                    template ships (a skill of its own under .claude/skills/), a path its
#                    tooling makes but never ships (build/), a folder named as a bare word ('the
#                    research folder', 'the Makefile'), a path inside a URL, or, in Markdown, a
#                    two-word path written without quotes or a trailing slash (manuscript/src)
#                    or quoted bare ('research'); it still reads as paths, and so reports, a
#                    word/word in code comments ('data/research') and a quoted bare name in
#                    code (('library', 'assets')), which a maintainer rewords rather than
#                    weakening the check. Check 28 cannot see a command that needs a
#                    template's name written outside a fence, a placeholder in a fence whose
#                    info string is not a shell's, or a make target named without the word
#                    make; check 29 cannot see what a sibling ships unless --sibling names
#                    its checkout.
#
# SELF-TEST. --self-test writes a fixture repository at runtime, writes its manifest, proves it
#            clean, then applies one mutation per check and asserts exactly one finding each.
#
# Requirements: bash 4+, python3 at _common.sh's SA_PYTHON_MIN or later (its pin refuses an older
#               one). No network.
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

# The shared set (DESIGN.md D48, D50, D51, D52): destination path, then source, then the scope
# when it is not a project path. <template> is the literal placeholder for each template's own
# name. The shared working practice and D56's shared how-to files are $SA_SHARED_REFRESH
# (_common.sh), appended below. The data-root map (.claude/syntek-author-dataroot.json) is per
# template and never listed.
FS_FILES=(
  ".agents/mcp_config.json|template/.agents/mcp_config.json"
  ".agents/skills|template/.agents/skills"
  ".claude/syntek-<template>-dataroot.py|template/.claude/syntek-author-dataroot.py"
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
for _p in $SA_SHARED_REFRESH; do FS_FILES+=("$_p|template/$_p"); done
unset _p
FS_LINKS=".agents/skills"
FS_RESOLVER=".claude/syntek-<template>-dataroot.py"
# A shared file's keys (the seven D47 questions), and the question block's fifteen, in order.
FS_KEYS="AGENT_CLIENTS CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT"
FS_BLOCK_KEYS="$FS_KEYS DATA_STORE DATA_AREA DATA_SLUG DATA_KIND_DOCS DATA_KIND_PHOTOS DATA_KIND_AUDIO DATA_KIND_VIDEOS DATA_PROVIDER"
# The one retired answer the block may name (D53), inside DATA_PROVIDER's default only.
FS_RETIRED_KEY="INCLUDE_DRIVE_SYNC"
FS_BEGIN='# BEGIN family-shared questions (D48)'
FS_END='# END family-shared questions (D48)'
FS_MIG_BEGIN='# BEGIN family-shared migrations (D48)'
FS_MIG_END='# END family-shared migrations (D48)'
FS_UPD_BEGIN='# BEGIN family-shared update (D48)'
FS_UPD_END='# END family-shared update (D48)'
# The fourth block (D54): rules 06's responsible-use rule, at its destination in every template.
FS_RULES_SOURCE="template/.claude/rules/syntek-author/06-global-rules.md"
FS_RULES_DEST=".claude/rules/syntek-<template>/06-global-rules.md"
FS_RULES_BEGIN='<!-- BEGIN family-shared rules: web and code tools -->'
FS_RULES_END='<!-- END family-shared rules: web and code tools -->'
# The MCP files' key paths (DESIGN.md D54; migrations/family-refresh.json "mcp"), path=key.key.
FS_MCP_KEYPATHS=".mcp.json=mcpServers .agents/mcp_config.json=mcpServers .codex/config.toml=mcp_servers .gemini/settings.json=mcpServers opencode.json=mcp.servers"
FS_SEED_SETTINGS="template/.claude/settings.json"
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
  FS_BLOCK_KEYS="$FS_BLOCK_KEYS" FS_RETIRED_KEY="$FS_RETIRED_KEY" FS_RESOLVER="$FS_RESOLVER" \
  FS_BEGIN="$FS_BEGIN" FS_END="$FS_END" FS_MIG_BEGIN="$FS_MIG_BEGIN" FS_MIG_END="$FS_MIG_END" \
  FS_UPD_BEGIN="$FS_UPD_BEGIN" FS_UPD_END="$FS_UPD_END" FS_REFRESH="$SA_SHARED_REFRESH" \
  FS_HOWTO="$SA_SHARED_HOWTO" FS_HOWTO_OWN="$SA_HOWTO_OWN" FS_RESTORE_DIRS="$SA_RESTORE_DIRS" \
  FS_HOWTO_GUARD="$SA_HOWTO_GUARD" FS_HOWTO_DENY="$SA_HOWTO_DENY" FS_SKILL_NAMES="$(awk 'NF { print $1 }' <<< "$SA_SKILLS" | tr '\n' ' ')" \
  FS_RULES_SOURCE="$FS_RULES_SOURCE" FS_RULES_DEST="$FS_RULES_DEST" \
  FS_RULES_BEGIN="$FS_RULES_BEGIN" FS_RULES_END="$FS_RULES_END" \
  FS_MCP_KEYPATHS="$FS_MCP_KEYPATHS" FS_MCP_FILES="$SA_MCP_FILES" FS_MCP_SERVERS="$SA_MCP_SERVERS" \
  FS_MCP_PINS="$SA_MCP_PINS" FS_CRG_TOOLS="$SA_CRG_TOOLS" FS_CRG_BLANK_KEYS="$SA_CRG_BLANK_KEYS" \
  FS_MCP_ASKS="$SA_MCP_ASKS" FS_MCP_DENY="$SA_MCP_DENY" FS_CRG_MARKERS="$SA_CRG_INSTALL_MARKERS" \
  FS_SEED_SETTINGS="$FS_SEED_SETTINGS" \
  FS_REFRESH_DATA="$FS_REFRESH_DATA" FS_HELD="$FS_HELD" FS_MANIFEST="$FS_MANIFEST" \
  FS_MODE_FILES="$SA_MODE_FILES" FS_SIBLING_MODE_RE="$SA_SIBLING_MODE_RE" \
  python3 -I - "$@" <<'PY'
import hashlib, json, os, re, subprocess, sys, tomllib
from pathlib import Path

mode, root, sibling = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
E = os.environ
files = []
for l in E["FS_FILES_LIST"].splitlines():
    if l:
        parts = l.split("|")
        files.append((parts[0], parts[1], parts[2] if len(parts) > 2 else "project"))
links = set(E["FS_LINKS"].split())
keys = E["FS_KEYS"].split()
block_keys = E["FS_BLOCK_KEYS"].split()
retired = E["FS_RETIRED_KEY"]
resolver = E["FS_RESOLVER"]
held = E["FS_HELD"]
COPIER = "copier.yml"
MIGX = ("_copier_conf", "_stage", "_copier_python")
# The blocks, in manifest order: name, source file, destination (None: a copier.yml block),
# BEGIN marker, END marker, the keys and extra names its delimiters may read (None: none at all).
BLOCKS = [("questions", COPIER, None, E["FS_BEGIN"], E["FS_END"], block_keys, ("_external_data", "_folder_name", "UNSET")),
          ("migrations", COPIER, None, E["FS_MIG_BEGIN"], E["FS_MIG_END"], keys, MIGX),
          ("update", COPIER, None, E["FS_UPD_BEGIN"], E["FS_UPD_END"], keys, MIGX),
          ("rules-web-tools", E["FS_RULES_SOURCE"], E["FS_RULES_DEST"], E["FS_RULES_BEGIN"], E["FS_RULES_END"], keys, None)]
REFRESH = E["FS_REFRESH"].split()
REFRESH_DATA = E["FS_REFRESH_DATA"]
HOWTO = E["FS_HOWTO"].split()
HOWTO_OWN = E["FS_HOWTO_OWN"].split()
RESTORE_DIRS = E["FS_RESTORE_DIRS"].split()
HOWTO_GUARD = E["FS_HOWTO_GUARD"]
HOWTO_DENY = E["FS_HOWTO_DENY"]
UPDATE = "migrations/family-update.py"
RUNPY = '"<% _copier_python %>" "<% _copier_conf.src_path %>/'
UPDATE_ARGS = ' --src "<% _copier_conf.src_path %>" --to <% _copier_conf.vcs_ref_hash %> --answers "<% _copier_conf.answers_file %>"'
WANT_UPDATE = [f"  - command: '{RUNPY}{UPDATE}\" update{UPDATE_ARGS}'", "    when: \"<% _stage == 'after' %>\""]
WANT_TASK = [f"  - command: '{RUNPY}{UPDATE}\" baseline{UPDATE_ARGS}'", "    when: \"<% _copier_operation == 'copy' %>\""]
manifest_path = root / E["FS_MANIFEST"]
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

def block_lines(path, begin, end):
    """(lines strictly between the markers, error) for one block of one file."""
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError:
        return None, f"{path.name} cannot be read"
    b = [i for i, l in enumerate(lines) if l == begin]
    e = [i for i, l in enumerate(lines) if l == end]
    if len(b) != 1 or len(e) != 1 or b[0] > e[0]:
        return None, f"{path.name} holds '{begin}' {len(b)} time(s) and '{end}' {len(e)} time(s); each must appear once, BEGIN first"
    return lines[b[0] + 1:e[0]], ""

def block_entry(name, source, dest, begin, end, lines):
    data = "".join(l + "\n" for l in lines).encode()
    e = {"name": name, "source": source}
    if dest is not None:
        e["destination"] = dest
    e.update({"begin": begin, "end": end, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()})
    return e

try:
    version = (root / "VERSION").read_text(encoding="utf-8").strip()
except OSError:
    version = ""
releases = {"unreleased"} | ({f"v{version}"} if version else set())

def release_wanted():
    """The release values the manifest may name, and why, from the repository's tags: 'v' +
    VERSION on the commit that tag names, and on an untagged commit whose VERSION no tag has
    yet (the release commit, before its tag); 'unreleased' on later work, once that tag is an
    ancestor; either where git cannot tell (no repository at the root, no tags fetched)."""
    if not version:
        return releases, ""
    def g(*args):
        r = subprocess.run(["git", "-C", str(root), *args], capture_output=True, text=True)
        return r.returncode, r.stdout.strip()
    code, top = g("rev-parse", "--show-toplevel")
    if code or Path(top).resolve() != root.resolve():
        return releases, ""
    tag = "v" + version
    code, tagged = g("rev-parse", "-q", "--verify", f"refs/tags/{tag}^{{commit}}")
    if code:
        code, tags = g("tag", "-l", "v[0-9]*")
        return ({tag}, f"VERSION is {version} and no tag {tag} exists yet, so this is its release commit") if not code and tags else (releases, "")
    code, head = g("rev-parse", "-q", "--verify", "HEAD^{commit}")
    if code:
        return releases, ""
    if tagged == head:
        return {tag}, f"HEAD is tagged {tag}"
    code, _ = g("merge-base", "--is-ancestor", tagged, head)
    return ({"unreleased"}, f"{tag} is already released, so later work is unreleased until the next release") if code == 0 else (releases, "")

wanted, wanted_why = release_wanted()
blks = {name: block_lines(root / src, b, e) for name, src, _, b, e, _, _ in BLOCKS}

if mode == "write":
    release = "unreleased"
    try:
        old = json.loads(manifest_path.read_text(encoding="utf-8"))
        if old.get("release") in wanted:
            release = old["release"]
    except (OSError, ValueError, AttributeError):
        pass
    if len(wanted) == 1:
        release = next(iter(wanted))
    for name, *_ in BLOCKS:
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
            + ",\n".join("    " + json.dumps(block_entry(n, s, d, b, e, blks[n][0]), ensure_ascii=False) for n, s, d, b, e, _, _ in BLOCKS)
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
    if not isinstance(man, dict) or man.get("format") != 1 or man.get("owner") != OWNER or man.get("release") not in wanted:
        finding(1, f"{manifest_path.name} must hold format 1, owner {OWNER} and release one of {sorted(wanted)}"
                   + (f" ({wanted_why}; family-shared.sh --write sets it)" if wanted_why else ""))
        man = None

listed = {}
mblocks = {}
if man is not None:
    mf = man.get("files") if isinstance(man.get("files"), list) else []
    want = [(p, s, "symlink" if p in links else "file", sc) for p, s, sc in sorted(files)]
    have = [(e.get("path"), e.get("source"), e.get("kind"), e.get("scope", "project")) for e in mf if isinstance(e, dict)]
    blocks = man.get("blocks") if isinstance(man.get("blocks"), list) else []
    want_blocks = [(n, s, d, b, e) for n, s, d, b, e, _, _ in BLOCKS]
    have_blocks = [(x.get("name"), x.get("source"), x.get("destination"), x.get("begin"), x.get("end")) if isinstance(x, dict) else None for x in blocks]
    if have != want:
        missing = [w[0] for w in want if w not in have]
        extra = [h[0] for h in have if h not in want]
        finding(2, f"{manifest_path.name} files differ from the shared set (missing or wrong path, source, kind or scope: {missing or 'none'}; "
                   f"extra or wrong: {extra or 'none'}; order: {'wrong' if not missing and not extra else 'n/a'})")
    elif have_blocks != want_blocks:
        finding(2, f"{manifest_path.name} blocks must be exactly the questions, migrations and update blocks of copier.yml, then the "
                   f"rules-web-tools block of {E['FS_RULES_SOURCE']} with its destination {E['FS_RULES_DEST']}, in that order, between their markers")
    listed = {e.get("path"): e for e in mf if isinstance(e, dict)}
    mblocks = {x.get("name"): x for x in blocks if isinstance(x, dict)}

delim = re.compile(r"<%(.*?)%>|<:(.*?):>|<~(.*?)~>", re.S)
strings = re.compile(r"'[^']*'|\"[^\"]*\"")
ident = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
# Any spelling of a template name: syntek-media, syntek_media, SyntekMedia. The held name and
# the owner's own name (check 6's) are left out; syntek-* never matches. So are the names that
# are not templates: the update script's opt-out and render variables (SYNTEK_UPDATE_*), and
# the data root's variable SYNTEK_DATA_ROOT, marker .syntek-data-root and temporary suffix
# .syntek-tmp, which the pattern finds as SYNTEK_DATA, syntek-data-root and syntek-tmp.
template_name = re.compile(r"syntek[-_]?[a-z][a-z0-9]*(?:-[a-z0-9]+)*", re.I)
NOT_TEMPLATES = ("syntek-held", "SYNTEK_DATA", "syntek-data-root", "syntek-tmp")
# The owner's own name in any spelling: case, -, _, a space or none (Syntek Author, SyntekAuthor).
OWN_ANY = re.compile(r"syntek[-_ ]?" + re.escape(OWNER.removeprefix("syntek-")) + r"(?![A-Za-z0-9])", re.I)
def other_templates(text):
    return sorted({n for n in template_name.findall(re.sub(r"SYNTEK_UPDATE_[A-Z]+", "", text))
                   if n not in NOT_TEMPLATES and not OWN_ANY.match(n)})
decision = re.compile(r"\bD\d+\b")
section = re.compile(r"\bsections? \d|\brules \d\d|§", re.I)
def foreign_keys(text, keyset, extra=()):
    bad = set()
    for m in delim.finditer(text):
        body = strings.sub(" ", next(g for g in m.groups() if g is not None))
        for name in ident.findall(body):
            if name in keyset or name in extra:
                continue
            if (len(name) > 1 and re.fullmatch(r"[A-Z][A-Z0-9_]*", name)) or name.startswith("_"):
                bad.add(name)
    return sorted(bad)

def names_check(label, text, sections=False):
    """Check 11: no other template's name, no decision number (and, for rules, no section number)."""
    names = other_templates(text)
    if names:
        finding(11, f"{label} names {', '.join(names)}; family-shared text names no template ('the bridge (.claude/syntek-*-agents.md)')")
    dnums = sorted(set(decision.findall(text)))
    if dnums:
        finding(11, f"{label} names decision {', '.join(dnums)}; family-shared text cites no template's decision numbers")
    if sections and section.search(text):
        finding(11, f"{label} names a section number ({section.search(text).group(0)}); each template numbers its own sections")

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
    bad = foreign_keys(text, keys)
    if source.endswith("-permissions.py") and delim.search(text):
        finding(5, f"{source} holds a template delimiter; the permissions script is never rendered differently")
    elif path == resolver and delim.search(text):
        finding(5, f"{source} holds a template delimiter; the data-root resolver is the same bytes in every project")
    elif path in REFRESH and delim.search(text):
        finding(5, f"{source} holds a template delimiter; a shared skill, hook, handoffs file or how-to file is token-free, so the refresh can compare its bytes (D51)")
    elif scope == "repository" and delim.search(text):
        finding(5, f"{source} holds a template delimiter; it is run from the template clone and never rendered")
    elif bad:
        finding(5, f"{source} uses {', '.join(bad)} — a shared file may use only the seven shared keys")
    own = OWN_ANY.search(text)
    if own:
        finding(6, f"{source} names {own.group(0)}; say 'every .claude/syntek-*-agents.md' or 'the project's rules in .claude/'")
    names_check(source, text, sections=path in HOWTO)
    if path == MIGRATION:
        helds = re.findall(r"^HELD = '([^']*)'$", text, re.M)
        if helds != [held]:
            finding(12, f"{source} holds the link as {helds or 'no HELD assignment'}; every template must hold it as exactly ['{held}']")

for name, source, dest, begin, end, keyset, extra in BLOCKS:
    blk, err = blks[name]
    if blk is None:
        finding(7, err)
        continue
    btext = "\n".join(blk)
    if name == "questions":
        top = [m.group(1) for l in blk if (m := re.match(r"([A-Za-z_][A-Za-z0-9_]*):", l))]
        if top != block_keys:
            finding(8, f"the D48 question block's top-level keys are {top}; they must be exactly {block_keys}, in that order")
    elif name == "migrations":
        # Every line that is not blank and not a comment, exactly: nothing else may ride along.
        body = [l for l in blk if l.strip() and not l.lstrip().startswith("#")]
        want_body = [line for stage, when in (("hold", "before"), ("restore", "after"))
                     for line in (f"  - command: '{RUNPY}{MIGRATION}\" {stage}'",
                                  f"    when: \"<% _stage == '{when}' %>\"")]
        if body != want_body:
            finding(8, f"the D48 migrations block must hold only the hold entry (before) and the restore entry (after) of {MIGRATION}, run by _copier_python, in that order, and comments")
        # First in _migrations: restore must run before every other after-stage entry.
        lines = (root / COPIER).read_text(encoding="utf-8").splitlines()
        above = [l for l in lines[:lines.index(begin)] if l.strip() and not l.lstrip().startswith("#")]
        if not above or above[-1] != "_migrations:":
            finding(8, "the D48 migrations block must open _migrations: its restore entry runs before every other after-stage migration only from there")
    if name == "update":
        body = [l for l in blk if l.strip() and not l.lstrip().startswith("#")]
        if body != WANT_UPDATE:
            finding(13, f"the D48 update block must hold only the update entry of {UPDATE} (_stage 'after', run by _copier_python), line for line, and comments")
        lines = (root / COPIER).read_text(encoding="utf-8").splitlines()
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
    names_check(f"the D48 {name} block", btext, sections=(dest is not None))
    if extra is None:
        if delim.search(btext):
            finding(5, f"the D48 {name} block holds a template delimiter; it is token-free, the same bytes in every template")
    else:
        bad = foreign_keys(btext, keyset, extra=extra)
        if bad:
            finding(5, f"the D48 {name} block uses {', '.join(bad)} — only {'its fifteen keys' if name == 'questions' else 'the seven shared keys'} and {', '.join(extra)}")
    own = OWN_ANY.search(btext)
    if own:
        finding(6, f"the D48 {name} block names {own.group(0)}; it is copied verbatim into the other template")
    mb = mblocks.get(name)
    if man is not None and isinstance(mb, dict):
        be = block_entry(name, source, dest, begin, end, blk)
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
    clines = (root / COPIER).read_text(encoding="utf-8").splitlines()
except OSError:
    clines = []
rd = None
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
OWN_MODES = set(E["FS_MODE_FILES"].split())
SIB_MODE = re.compile(E["FS_SIBLING_MODE_RE"])
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

# Every text file under template/, read once: checks 21 (install markers) and 23 (the store).
tfiles = []
if tpl.is_dir():
    for dp, dns, fns in os.walk(tpl):
        dns[:] = sorted(d for d in dns if d != ".git" and not os.path.islink(os.path.join(dp, d)))
        for fn in sorted(fns):
            fp = Path(dp) / fn
            if fp.is_symlink() or not fp.is_file():
                continue
            raw = fp.read_bytes()
            if b"\0" in raw:
                continue
            tfiles.append((os.path.relpath(fp, root), raw.decode("utf-8", errors="replace")))

# ── 18–22. The MCP servers (D54) ──
# Findings are gathered per (check, file), so one fault in one file is one finding.
acc = {}
def note(n, label, text): acc.setdefault((n, label), []).append(text)
TAG = re.compile(r"<:-?\s*(\w+).*?-?:>|<~.*?~>", re.S)
def ungate(text):
    """The text with every <: if/for :>…<: endif/endfor :> region and comment removed, or None."""
    out_, depth, pos = [], 0, 0
    for m in TAG.finditer(text):
        if m.group(0).startswith("<~"):
            if depth == 0:
                out_.append(text[pos:m.start()]); pos = m.end()
            continue
        w = m.group(1)
        if w in ("if", "for"):
            if depth == 0:
                out_.append(text[pos:m.start()])
            depth += 1
        elif w in ("endif", "endfor"):
            depth -= 1
            if depth < 0:
                return None
            if depth == 0:
                pos = m.end()
    if depth:
        return None
    out_.append(text[pos:])
    s = "".join(out_)
    return None if re.search(r"<%|<:|<~", s) else s

def parse(source):
    """(data, error) for a JSON or TOML source once its gates are removed."""
    try:
        text = (root / source).read_text(encoding="utf-8")
    except OSError as err:
        return None, f"cannot be read ({err.strerror})"
    s = ungate(text)
    if s is None:
        return None, "holds a delimiter outside an if-region, or unbalanced if-regions"
    try:
        return (tomllib.loads(s) if source.endswith(".toml") else json.loads(s)), ""
    except (ValueError, tomllib.TOMLDecodeError) as err:
        return None, f"does not parse ({str(err).splitlines()[0]})"

def walk(data, keypath):
    node = data
    for k in keypath:
        node = node.get(k) if isinstance(node, dict) else None
    return node

MCP_FILES = E["FS_MCP_FILES"].split()
KEYPATH = {p: kp.split(".") for p, kp in (x.split("=", 1) for x in E["FS_MCP_KEYPATHS"].split())}
SERVERS = E["FS_MCP_SERVERS"].split()
CRG, SCR = SERVERS
PINS = E["FS_MCP_PINS"].split()
TOOLS = E["FS_CRG_TOOLS"]
BLANK = E["FS_CRG_BLANK_KEYS"].split()
ASKS = E["FS_MCP_ASKS"].split()
DENY = E["FS_MCP_DENY"]
EMBED = DENY.rsplit("__", 1)[1]
WANT_ARGS = {CRG: [PINS[0], "serve", "--tools"],
             SCR: ["--from", PINS[1], "--with", PINS[2], "--with", PINS[3], "scrapling", "mcp"]}
ENTRY_KEYS = {"json": {CRG: ["command", "args", "env"], SCR: ["command", "args"]},
              "toml": {CRG: ["command", "args", "env", "tools"], SCR: ["command", "args", "tools"]},
              "opencode": {CRG: ["type", "command", "environment"], SCR: ["type", "command"]}}
PROMPT_KEYS = ("trust", "default_tools_approval_mode")   # check 21's, never check 20's
RULE = re.compile(r"mcp__(.+?)__(.+)")
ask_parts = [m.groups() for a in ASKS if (m := RULE.fullmatch(a))]
fmt = lambda p: "toml" if p.endswith(".toml") else ("opencode" if p == "opencode.json" else "json")

tool_names = TOOLS.split(",")
if len(tool_names) != 29 or len(set(tool_names)) != 29 or EMBED in tool_names:
    note(19, "_common.sh SA_CRG_TOOLS", f"holds {len(tool_names)} name(s){' with embed_graph_tool' if EMBED in tool_names else ''}; the held list is 29 distinct names without {EMBED}")

parsed, bad18 = {}, set()
for path in MCP_FILES:
    src = "template/" + path
    data, err = parse(src)
    if data is None:
        note(18, src, f"{err} once its if-regions are removed"); bad18.add(path); continue
    parsed[path] = data
    node = walk(data, KEYPATH.get(path, []))
    if not isinstance(node, dict) or list(node) != SERVERS:
        note(18, src, f"declares {list(node) if isinstance(node, dict) else 'no server table'} at {'.'.join(KEYPATH.get(path, []))}; it must declare exactly {SERVERS}, in that order")
        bad18.add(path); continue
    f = fmt(path)
    for s in SERVERS:
        e = node[s]
        if not isinstance(e, dict):
            note(18, src, f"{s} is not a table"); continue
        if f == "opencode":
            c = e.get("command")
            if e.get("type") != "local" or not isinstance(c, list) or not c:
                note(18, src, f"{s} is not a local server with a command list"); continue
            cmd, args = c[0], c[1:]
        else:
            cmd, args = e.get("command"), e.get("args")
        if cmd != "uvx":
            note(18, src, f"{s} runs {cmd!r}, not 'uvx'")
        if s == CRG:
            if not isinstance(args, list) or len(args) != 4 or args[:3] != WANT_ARGS[s]:
                note(18, src, f"{s}'s arguments are {args[:3] if isinstance(args, list) else args} (+ {max(len(args) - 3, 0) if isinstance(args, list) else 0} more); they must be {WANT_ARGS[s]} and the tool list")
            elif args[3] != TOOLS:
                note(19, src, f"{s}'s --tools value is not the held list of 29 names without {EMBED}")
        elif args != WANT_ARGS[s]:
            note(18, src, f"{s}'s arguments are {args}; they must be exactly {WANT_ARGS[s]}")
        extra = [k for k in e if k not in ENTRY_KEYS[f][s] and k not in PROMPT_KEYS]
        if extra:
            note(20, src, f"{s} holds {extra}; a server entry holds only {ENTRY_KEYS[f][s]}")
        envkey = "environment" if f == "opencode" else "env"
        if s == CRG:
            env = e.get(envkey)
            if not isinstance(env, dict) or list(env) != BLANK or any(v != "" for v in env.values()):
                note(20, src, f"{s}'s {envkey} must be exactly {BLANK}, in order, each \"\" (no key is shipped)")
        for k in PROMPT_KEYS:
            if k in e:
                note(21, src, f"{s} sets {k}, which removes a prompt")
for path in MCP_FILES:
    src = "template/" + path
    try:
        n = (root / src).read_text(encoding="utf-8").count(EMBED)
    except OSError:
        continue
    allowed = 1 if fmt(path) == "opencode" else 0
    if n != allowed:
        note(19, src, f"names {EMBED} {n} time(s); {'only once, as the deny action' if allowed else 'never'}")

# 21. The one ask order, the deny, and nothing that removes a prompt.
derived = {"gemini": [f"mcp_{s}_{t}" for s, t in ask_parts], "opencode": [f"{s}_{t}" for s, t in ask_parts]}
deny_s, deny_t = RULE.fullmatch(DENY).groups()
seed, err = parse(E["FS_SEED_SETTINGS"])
seedsrc = E["FS_SEED_SETTINGS"]
def hook_commands(settings):
    for entries in ((settings or {}).get("hooks") or {}).values():
        for e in entries if isinstance(entries, list) else []:
            for h in (e.get("hooks") or []) if isinstance(e, dict) else []:
                yield str(h.get("command", ""))
if seed is None:
    note(21, seedsrc, f"{err} once its if-regions are removed")
else:
    perm = seed.get("permissions") or {}
    if perm.get("ask") != ASKS:
        note(21, seedsrc, f"permissions.ask is {perm.get('ask')}; it must be exactly the {len(ASKS)} MCP asks, in order")
    if DENY not in (perm.get("deny") or []):
        note(21, seedsrc, f"permissions.deny lacks {DENY}")
    allows = [a for a in perm.get("allow") or [] if str(a).startswith("mcp__")]
    if allows:
        note(21, seedsrc, f"permissions.allow holds {allows}, which removes a prompt")
    if any("code-review-graph" in c for c in hook_commands(seed)):
        note(21, seedsrc, "a hook command names code-review-graph: its installer's hooks are never wired")
if isinstance(rd, dict):
    perm = (rd.get("settings") or {}).get("permissions") or {}
    if perm.get("ask") != ASKS:
        note(21, REFRESH_DATA, f"settings.permissions.ask is {perm.get('ask')}; it must be exactly the {len(ASKS)} MCP asks, in order")
    if DENY not in (perm.get("deny") or []):
        note(21, REFRESH_DATA, f"settings.permissions.deny lacks {DENY}")
    if "allow" in perm:
        note(21, REFRESH_DATA, "settings.permissions holds an allow list, which would remove a prompt")
    if any("code-review-graph" in c for c in hook_commands(rd.get("settings"))):
        note(21, REFRESH_DATA, "a hook command names code-review-graph: its installer's hooks are never wired")
g = parsed.get(".gemini/settings.json")
if isinstance(g, dict):
    tools = g.get("tools") or {}
    if tools.get("confirmationRequired") != derived["gemini"]:
        note(21, "template/.gemini/settings.json", f"tools.confirmationRequired must be exactly {derived['gemini']}, in order")
    allowed = [t for t in tools.get("allowed") or [] if str(t).startswith("mcp_")]
    if allowed:
        note(21, "template/.gemini/settings.json", f"tools.allowed holds {allowed}, which removes a prompt")
o = parsed.get("opencode.json")
if isinstance(o, dict):
    perms = [p for p in o.get("permissions") or [] if isinstance(p, dict)]
    asks = [i for i, p in enumerate(perms) if p.get("effect") == "ask"]
    denies = [i for i, p in enumerate(perms) if p.get("effect") == "deny"]
    if [perms[i].get("action") for i in asks] != derived["opencode"] or any(perms[i].get("resource") != "*" for i in asks):
        note(21, "template/opencode.json", f"its ask actions must be exactly {derived['opencode']}, in order, each on resource '*'")
    if asks and denies and min(denies) < max(asks):
        note(21, "template/opencode.json", "an ask follows a deny; every ask comes before every deny")
    if {"action": f"{deny_s}_{deny_t}", "resource": "*", "effect": "deny"} not in perms:
        note(21, "template/opencode.json", f"lacks the deny of {deny_s}_{deny_t}")
    lets = [p.get("action") for p in perms if p.get("effect") == "allow"
            and (p.get("action") == "*" or any(str(p.get("action", "")).startswith(s + "_") for s in SERVERS))]
    if lets:
        note(21, "template/opencode.json", f"allows {lets}, which removes a prompt")
c = parsed.get(".codex/config.toml")
if isinstance(c, dict):
    for s in SERVERS:
        tools = ((c.get("mcp_servers") or {}).get(s) or {}).get("tools") or {}
        want = [t for ss, t in ask_parts if ss == s]
        if list(tools) != want or any(v != {"approval_mode": "prompt"} for v in tools.values()):
            note(21, "template/.codex/config.toml", f"{s}'s tool tables must be exactly {want}, in order, each approval_mode = \"prompt\"")
    def modes(node):
        if isinstance(node, dict):
            for k, v in node.items():
                if k == "default_tools_approval_mode" or (k == "approval_mode" and v != "prompt"):
                    yield f"{k} = {v!r}"
                yield from modes(v)
    for x in sorted(set(modes(c))):
        note(21, "template/.codex/config.toml", f"sets {x}, which removes a prompt")
NO_KEYS = ("enableAllProjectMcpServers", "enabledMcpjsonServers", "disabledMcpjsonServers")
for src in [seedsrc, REFRESH_DATA] + [s for p, s, _ in sorted(files) if p not in links]:
    try:
        text = (root / src).read_text(encoding="utf-8", errors="replace")
    except OSError:
        continue
    for k in NO_KEYS:
        if k in text:
            note(21, src, f"names {k}: neither server's prompt is ever switched off")
MARKERS = [m for m in E["FS_CRG_MARKERS"].splitlines() if m]
for rel, text in tfiles:
    hit = [m for m in MARKERS if m in text]
    if hit:
        note(21, rel, f"holds code-review-graph's install marker {hit[0]!r}: its installer never runs in a template")

# 22. The lane data.
if isinstance(rd, dict):
    mcp = rd.get("mcp")
    if not isinstance(mcp, dict):
        note(22, REFRESH_DATA, "has no \"mcp\" key with servers and files")
    else:
        mfiles, mservers = mcp.get("files"), mcp.get("servers")
        want_files = {p: KEYPATH.get(p) for p in MCP_FILES}
        if mfiles != want_files:
            note(22, REFRESH_DATA, f"mcp.files must name exactly the five MCP files with their key paths: {want_files}")
        mj = walk(parsed.get(".mcp.json"), KEYPATH.get(".mcp.json", []))
        if ".mcp.json" not in bad18 and isinstance(mj, dict) and mservers != list(mj):
            note(22, REFRESH_DATA, f"mcp.servers is {mservers}; it must be the servers of .mcp.json, {list(mj)}")
        if isinstance(mfiles, dict) and isinstance(mservers, list):
            for p, kp in sorted(mfiles.items()):
                if p in bad18 or p not in parsed or not isinstance(kp, list):
                    continue
                node = walk(parsed[p], kp)
                gone = [s for s in mservers if not isinstance(node, dict) or s not in node]
                if gone:
                    note(22, REFRESH_DATA, f"lists {gone} for {p}, which does not declare them at {'.'.join(map(str, kp))}")

for (n, label), probs in sorted(acc.items(), key=lambda x: (x[0][0], x[0][1])):
    finding(n, f"{label}: {'; '.join(probs)}")

# ── 23. The store's equality rule (D50) ──
TOK = re.compile(r"""('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")|(\d+(?:\.\d*)?)|([A-Za-z_][A-Za-z0-9_]*)|(==|!=|<=|>=|\*\*|//|[-+*/%~|.,:()\[\]{}<>=!?])""")
CMP = {"==", "!=", "<", ">", "<=", ">=", "in", "not in", "is", "is not"}
OPEN, CLOSE = {"(", "[", "{"}, {")", "]", "}"}
WORDS = {"if", "else", "elif", "and", "or", "not", "in", "is"}
def tokens(body):
    toks, i = [], 0
    while i < len(body):
        m = TOK.match(body, i)
        if not m:
            i += 1; continue
        st, num, name, op = m.groups()
        t = ("str", st) if st else ("num", num) if num else ("name", name) if name else ("op", op)
        if t == ("name", "in") and toks and toks[-1] == ("name", "not"):
            toks[-1] = ("op", "not in")
        elif t == ("name", "not") and toks and toks[-1] == ("op", "is"):
            toks[-1] = ("op", "is not")
        elif t in (("name", "in"), ("name", "is")):
            toks.append(("op", t[1]))
        else:
            toks.append(t)
        i = m.end()
    return toks

def match_close(toks, i):
    depth = 0
    for j in range(i, len(toks)):
        if toks[j][0] == "op" and toks[j][1] in OPEN:
            depth += 1
        elif toks[j][0] == "op" and toks[j][1] in CLOSE:
            depth -= 1
            if depth == 0:
                return j
    return len(toks) - 1

def is_store(toks, i):
    return toks[i] == ("name", "DATA_STORE") and not (i > 0 and toks[i - 1] == ("op", "."))

def tests_store(toks):
    return any(is_store(toks, i) for i in range(len(toks)))

def literal_at(toks, j):
    return j < len(toks) and (toks[j][0] == "str" or (toks[j] in (("op", "["), ("op", "(")) and j + 1 < len(toks) and toks[j + 1][0] == "str"))

def match_open(toks, j):
    depth = 0
    for i in range(j, -1, -1):
        if toks[i][0] == "op" and toks[i][1] in CLOSE:
            depth += 1
        elif toks[i][0] == "op" and toks[i][1] in OPEN:
            depth -= 1
            if depth == 0:
                return i
    return 0

# Jinja's tests that compare: by equality, and the ones that negate it.
EQ_TESTS = {("name", "eq"), ("name", "equalto"), ("name", "sameas"), ("op", "==")}
NE_TESTS = {("name", "ne"), ("op", "!=")}

def store_problems(toks, is_cond, allow_not=False):
    """What a Jinja expression's tests of the DATA_STORE identifier break, if anything.
    allow_not: a copier.yml _exclude item of the house form, whose not (GATE) excludes."""
    probs, n = [], len(toks)
    positive = []   # (start, end) of each comparison that tests DATA_STORE by == or in
    regions = [(0, n)] if is_cond else []
    for k, t in enumerate(toks):
        if t != ("name", "if"):
            continue
        depth, j, els, end = 0, k + 1, None, n
        while j < n:
            ty, v = toks[j]
            if ty == "op" and v in OPEN:
                depth += 1
            elif ty == "op" and v in CLOSE:
                if depth == 0:
                    end = j; break
                depth -= 1
            elif depth == 0 and (toks[j] == ("name", "else") or toks[j] == ("op", ",")):
                if toks[j] == ("name", "else"):
                    els = j
                else:
                    end = j
                break
            j += 1
        stop = els if els is not None else end
        regions.append((k + 1, stop))
        if els is not None and tests_store(toks[k + 1:stop]):
            probs.append("tests DATA_STORE in an inline if … else, whose else means 'not that value'")
    for i in range(n):
        if not is_store(toks, i) or (i + 1 < n and toks[i + 1] == ("op", "=")):
            continue
        s, e = i, i + 1
        while e < n:
            if toks[e] == ("op", "|") and e + 1 < n and toks[e + 1][0] == "name":
                e += 2
                if e < n and toks[e] == ("op", "("):
                    e = match_close(toks, e) + 1
            elif toks[e] == ("op", ".") and e + 1 < n and toks[e + 1][0] == "name":
                e += 2
            elif toks[e] in (("op", "["), ("op", "(")):
                e = match_close(toks, e) + 1
            else:
                break
        while (s > 0 and e < n and toks[s - 1] == ("op", "(") and toks[e] == ("op", ")")
               and not (s > 1 and ((toks[s - 2][0] == "name" and toks[s - 2][1] not in WORDS) or toks[s - 2] in (("op", ")"), ("op", "]"))))):
            s, e = s - 1, e + 1
        after = toks[e][1] if e < n and toks[e][0] == "op" and toks[e][1] in CMP else None
        before = toks[s - 1][1] if s > 0 and toks[s - 1][0] == "op" and toks[s - 1][1] in CMP else None
        if after:
            test = toks[e + 1] if after in ("is", "is not") and e + 1 < n else None
            lit = literal_at(toks, e + 2 if test else e + 1)
            if after in ("!=", "not in") and lit:
                probs.append(f"compares DATA_STORE by {after} with a literal, which means 'not that value'")
            elif test and lit and ((after == "is" and test in NE_TESTS) or (after == "is not" and test in EQ_TESTS)):
                probs.append(f"compares DATA_STORE by {after} {test[1]} with a literal, which means 'not that value'")
            elif after in ("==", "in") or (test and ((after == "is" and test in EQ_TESTS) or (after == "is not" and test in NE_TESTS))):
                positive.append((s, e))
        elif before:
            lit = s > 1 and (toks[s - 2][0] == "str" or (toks[s - 2] in (("op", "]"), ("op", ")")) and s > 2 and toks[s - 3][0] == "str"))
            if before in ("!=", "not in") and lit:
                probs.append(f"compares DATA_STORE by {before} with a literal, which means 'not that value'")
            elif before in ("==", "in"):
                positive.append((match_open(toks, s - 2) if toks[s - 2] in (("op", "]"), ("op", ")")) else s - 2, e))
        elif ((s > 0 and toks[s - 1] in (("name", "not"), ("name", "and"), ("name", "or")))
              or (e < n and toks[e] in (("name", "and"), ("name", "or"))) or (s, e) in regions):
            probs.append("tests DATA_STORE bare, which any value passes")
    # A not over an equality test of the store (directly, through brackets, or over a group
    # that holds one) means 'not that value' as surely as != does. Jinja's not takes the
    # comparison after it, up to the next and, or, if, else or comma outside brackets.
    for k in range(n):
        if toks[k] != ("name", "not") or allow_not:
            continue
        j, depth = k + 1, 0
        while j < n:
            ty, v = toks[j]
            if ty == "op" and v in OPEN:
                depth += 1
            elif ty == "op" and v in CLOSE:
                if depth == 0:
                    break
                depth -= 1
            elif depth == 0 and (toks[j] in (("name", "and"), ("name", "or"), ("name", "if"), ("name", "else"), ("op", ","))):
                break
            j += 1
        if any(k < a and b <= j for a, b in positive):
            probs.append("negates an equality test of DATA_STORE with not, which means 'not that value'")
    return probs

def store_findings(rel, text, copier):
    stack, raw = [], False
    for m in delim.finditer(text):
        whole = m.group(0)
        if whole.startswith("<~"):
            continue
        body = next(g for g in m.groups() if g is not None).strip().strip("-+").strip()
        toks = tokens(body)
        stmt = whole.startswith("<:")
        kw = toks[0][1] if stmt and toks and toks[0][0] == "name" else ""
        if raw:
            raw = kw != "endraw"
            continue
        if kw == "raw":
            raw = True
            continue
        line = text.count("\n", 0, m.start()) + 1
        start = text.rfind("\n", 0, m.start()) + 1
        is_cond = (not stmt and copier and re.match(r"\s*when:", text[start:m.start()]) is not None)
        house = False
        if copier and kw == "if" and toks[1:2] == [("name", "not")]:
            end = text.find("\n", m.end())
            item = text[start:end if end >= 0 else len(text)]
            keys = re.findall(r"^([A-Za-z_][A-Za-z0-9_]*):", text[:start], re.M)
            house = (bool(keys) and keys[-1] == "_exclude"
                     and re.fullmatch(r'\s*-\s*"<: if not \(.*\) :>/[^"<]*<: endif :>"\s*', item) is not None)
        probs = []
        if stmt:
            expr = toks[1:]
            if kw == "set":
                expr = toks[next((j for j, t in enumerate(toks) if t == ("op", "=")), len(toks) - 1) + 1:]
            probs += store_problems(expr, kw in ("if", "elif"), house)
            if kw in ("if", "for"):
                stack.append([kw, kw == "if" and tests_store(expr)])
            elif kw in ("elif", "else") and stack and stack[-1][0] == "if":
                if stack[-1][1]:
                    probs.append(f"gives a block whose if or an earlier elif tests DATA_STORE an {kw} arm, which means 'not that value'")
                stack[-1][1] = stack[-1][1] or tests_store(expr)
            elif kw in ("endif", "endfor") and stack:
                stack.pop()
        else:
            probs += store_problems(toks, is_cond)
        snippet = re.sub(r"\s+", " ", whole)
        for p in probs:
            finding(23, f"{rel}:{line} {p}: {snippet[:110]}{'…' if len(snippet) > 110 else ''}")

if clines:
    store_findings(COPIER, (root / COPIER).read_text(encoding="utf-8"), True)
for rel, text in tfiles:
    if "DATA_STORE" in text:
        store_findings(rel, text, False)

# ── 24. The peer key names another family template's answers file (D50) ──
if clines:
    peers = [m.group(1).strip().strip('"').strip("'") for l in top_section(clines, "_external_data") if (m := re.match(r"\s+peer:\s*(.*)$", l))]
    pm = re.fullmatch(r"\.copier-answers\.syntek-([a-z0-9]+(?:-[a-z0-9]+)*)\.yml", peers[0]) if len(peers) == 1 else None
    if len(peers) != 1:
        finding(24, f"copier.yml's _external_data holds {len(peers)} peer key(s); it must hold one, naming another family template's answers file (.copier-answers.syntek-<name>.yml)")
    elif not pm or pm.group(1) == OWNER.removeprefix("syntek-"):
        finding(24, f"copier.yml's _external_data.peer is {peers[0]}; it must name another family template's answers file (.copier-answers.syntek-<name>.yml), never this template's own")

# ── 25. The retired key: UPPER_SNAKE literals inside the question block's delimiters (D53) ──
qblk = blks["questions"][0]
if qblk is not None:
    qtext = "\n".join(qblk)
    lines_ = qtext.split("\n")
    offs = [0]
    for l in lines_:
        offs.append(offs[-1] + len(l) + 1)
    span = None
    try:
        i = lines_.index("DATA_PROVIDER:")
        j = next(k for k in range(i + 1, len(lines_)) if lines_[k].startswith("  default:"))
        k = next((x for x in range(j + 1, len(lines_)) if re.match(r"(  )?[A-Za-z_][A-Za-z0-9_]*:", lines_[x])), len(lines_))
        span = (offs[j], offs[k])
    except (ValueError, StopIteration):
        pass
    snake = re.compile(r"[A-Z0-9_]*[A-Z][A-Z0-9_]*")
    lit = re.compile(r"'([^']*)'|\"([^\"]*)\"")
    count, others = 0, set()
    for m in delim.finditer(qtext):
        g = next(i for i in (1, 2, 3) if m.group(i) is not None)
        for x in lit.finditer(m.group(g)):
            s_ = x.group(1) if x.group(1) is not None else x.group(2)
            if not (snake.fullmatch(s_) and "_" in s_) or s_ in block_keys:
                continue
            if s_ == retired and span and span[0] <= m.start(g) + x.start() < span[1]:
                count += 1
            else:
                others.add(s_)
    if others:
        finding(25, f"the D48 question block names {', '.join(repr(x) for x in sorted(others))} inside a delimiter; a string in the form of a key must be one of its fifteen keys, or '{retired}' in DATA_PROVIDER's default")
    if count != 2:
        finding(25, f"the D48 question block holds {count} '{retired}' literal(s) in DATA_PROVIDER's default; exactly two map the retired answer")

# ── 26. The resolver names no top-level folder of template/, nor of the sibling's (D50) ──
src = next((s for p, s, _ in files if p == resolver), None)
hits26 = set()
if src and (root / src).is_file() and tpl.is_dir():
    rtext = (root / src).read_text(encoding="utf-8", errors="replace")
    shared_dirs = {".claude", ".agents", ".codex", ".gemini"}
    hits = []
    stpl = Path(sibling) / "template" if sibling else None
    folders = {d for t in (tpl, stpl) if t is not None and t.is_dir() for d in os.listdir(t)
               if (t / d).is_dir() and not (t / d).is_symlink()}
    for d in sorted(folders):
        if d in shared_dirs:
            continue
        q = re.escape(d)
        if re.search(rf"(?<![\w.-]){q}/|(['\"`]){q}\1", rtext):
            hits.append(d)
    hits26 = set(hits)
    if hits:
        finding(26, f"{src} names the template folder(s) {', '.join(hits)}; each template's filing folders live in its own .claude/syntek-<template>-dataroot.json")

# ── 27. No shared file or block names a path only this template ships (D48) ──
# This template's own paths are the top-level entries of template/ that are neither family
# paths nor the house files every family template's root holds; with --sibling, less every
# top-level entry of the sibling's template/, and the sibling's own such entries are judged the
# same way. A use counts only where it is path-like, so 'the research skill' is a word and
# 'research/src/' a path; a path under a family folder (.claude/skills/<name>/) is not a
# top-level path; in Markdown prose, two plain words joined by a slash ('people/world') are
# prose, and a quoted name counts only with a slash or a glob after it ('research' is a word,
# 'research/' a path). The one stated exception is opencode.json's three edit denies, inert
# where the path is absent: each is passed over only while every entry of exactly that edit
# deny in the file is a top-level permissions entry.
FAMILY_TOP = {".claude", ".agents", ".codex", ".gemini", "handoffs"} | {p.split("/")[0] for p, _, sc in files if sc == "project"}
FAMILY_DIRS = (".claude", ".agents", ".codex", ".gemini", "handoffs", "how-to")
HOUSE_ROOT = {"CONTEXT.md", "CLAUDE.md", "README.md", ".gitignore"}
OC_EXEMPT = ("*.pdf", "build/*", "typeset/src/units/.base/*")
URL = re.compile(r"[A-Za-z][A-Za-z0-9+.-]*://[^\s'\"`<>()\[\]]*")
UNDER_FAMILY = re.compile(r"(?<![\w.-])(?:\./)?(?:" + "|".join(re.escape(d) for d in FAMILY_DIRS) + r")/[^\s'\"`<>()\[\]{},;]*")
WORD_SLASH = re.compile(r"(?<![\w./`'\"-])[A-Za-z]+/[A-Za-z]+(?![\w/`'\"-]|\.\w)")
own27, sib27 = set(), set()
if tpl.is_dir():
    own27 = {n for n in os.listdir(tpl) if n not in FAMILY_TOP | HOUSE_ROOT and not OWN_ANY.search(n)}
    stpl27 = Path(sibling) / "template" if sibling else None
    if stpl27 is not None and stpl27.is_dir():
        sentries = set(os.listdir(stpl27))
        sib27 = {n for n in sentries - set(os.listdir(tpl)) - FAMILY_TOP - HOUSE_ROOT
                 if not n.startswith(".copier-answers.")}
        own27 -= sentries

def blank(text, start, end):
    return text[:start] + re.sub(r"[^\n]", " ", text[start:end]) + text[end:]

def path_uses(text, names, prose=False):
    """{name: first line} for each name the text uses as a path; a URL is never read, nor a path
    under a family folder. prose: Markdown, where word/word is prose and a quoted bare name a word."""
    for rx in (URL, UNDER_FAMILY) + ((WORD_SLASH,) if prose else ()):
        for m in reversed(list(rx.finditer(text))):
            text = blank(text, m.start(), m.end())
    hits = {}
    quoted = r"([\'\"`]){q}[/*][^\'\"`\s]*\1" if prose else r"([\'\"`]){q}(?:[/*][^\'\"`\s]*)?\1"
    for n in sorted(names):
        q = re.escape(n)
        pat = rf"(?<![\w.-]){q}/|(?<=/){q}(?![\w-]|\.\w)|" + quoted.replace("{q}", q)
        if "." in n:
            pat += rf"|(?<![\w.-]){q}(?![\w-]|\.\w)"
        m = re.search(pat, text)
        if m:
            hits[n] = text.count("\n", 0, m.start()) + 1
    return hits

def oc_exempt(text):
    """opencode.json's text with each exempt edit deny blanked, where every such object in the
    text is a top-level permissions entry of exactly that action, resource and effect."""
    top = parsed.get("opencode.json")
    perms = top.get("permissions") if isinstance(top, dict) else None
    perms = perms if isinstance(perms, list) else []
    for r in OC_EXEMPT:
        want = {"action": "edit", "resource": r, "effect": "deny"}
        obj = re.compile(r'\{\s*"action"\s*:\s*"edit"\s*,\s*"resource"\s*:\s*"' + re.escape(r) + r'"\s*,\s*"effect"\s*:\s*"deny"\s*\}')
        found = list(obj.finditer(text))
        if found and len(found) == sum(1 for p in perms if p == want):
            for m in reversed(found):
                text = blank(text, m.start(), m.end())
    return text

scan27 = []
names27 = own27 | sib27
for path, source, scope in sorted(files):
    if path in links or not (root / source).is_file():
        continue
    text = (root / source).read_text(encoding="utf-8", errors="replace")
    if path == "opencode.json":
        text = oc_exempt(text)
    # The resolver's folders that check 26 already reported are not reported twice.
    scan27.append((source, text, names27 - hits26 if path == resolver else names27, "", 0, source.endswith(".md")))
for name, source, _, begin, *_ in BLOCKS:
    if blks[name][0] is not None:
        first = (root / source).read_text(encoding="utf-8").splitlines().index(begin) + 1
        scan27.append((f"the D48 {name} block", "\n".join(blks[name][0]), names27, f"{source} ", first, source.endswith(".md")))
for label, text, names, where, first, prose in scan27:
    hits = path_uses(text, names, prose)
    for who, group in (("this template", own27), ("the sibling", sib27)):
        mine = {n: l for n, l in hits.items() if n in group}
        if mine:
            finding(27, f"{label} names {', '.join(f'{n} ({where}line {first + l})' for n, l in sorted(mine.items()))} as a path, which only "
                        f"{who} ships; family-shared text names no such path (describe it, as 'the content layer', and let the project's rules name it)")

# ── 28. Shared how-to text (D56): the first problem per file ──
# The shared chapters and pairs are read by the author of any family template's project, so
# they name no make target (each template has its own Makefile), no skill but D51's seven,
# fence no command a reader must edit before it runs, and carry no metadata header.
SKILL_NAMES = set(E["FS_SKILL_NAMES"].split())
SHARED_SKILLS = {p.split("/")[2] for p in REFRESH if p.startswith(".claude/skills/") and p.endswith("/SKILL.md")}
try:
    TARGETS = set(re.findall(r"^([a-z][a-z-]*):", (tpl / "Makefile").read_text(encoding="utf-8", errors="replace"), re.M))
except OSError:
    TARGETS = set()
MAKE = re.compile(r"(?<![\w-])make\s+([a-z][a-z-]*)(?![\w-])", re.I)
SKILL_PATH = re.compile(r"\.claude/skills/([A-Za-z0-9_-]+)/")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})\s*([^\s`]*)")
SHELLS = ("bash", "sh", "shell", "console", "")
HOLDER = re.compile(r"<[A-Za-z][A-Za-z0-9 _-]*>|…|\[\.\.\.\]|\.\.\.")

def command_lines(text):
    """(line number, line) for every line inside a command fence: info string bash, sh, shell,
    console or none. A text fence (a tree, a sample) is never read."""
    fence, cmd = None, False
    for n, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if fence is None:
            if m:
                fence, cmd = m.group(1), m.group(2).lower() in SHELLS
            continue
        if m and m.group(1)[0] == fence[0] and len(m.group(1)) >= len(fence) and not m.group(2):
            fence = None
            continue
        if cmd:
            yield n, line

def howto_problem(text):
    for n, line in enumerate(text.splitlines(), 1):
        for m in MAKE.finditer(line):
            if m.group(1) in TARGETS:
                return f"names make {m.group(1)} (line {n}), a target of one template's Makefile; route the reader to the template's own procedure, in its folder under how-to/workflows/"
    for n, line in enumerate(text.splitlines(), 1):
        for m in re.finditer(r"`([a-z][a-z0-9-]*)`", line):
            if m.group(1) in SKILL_NAMES and m.group(1) not in SHARED_SKILLS:
                return f"names the skill `{m.group(1)}` (line {n}), which only one template ships; shared how-to text names only the seven shared working-practice skills"
        for m in SKILL_PATH.finditer(line):
            if m.group(1) not in SHARED_SKILLS:
                return f"names .claude/skills/{m.group(1)}/ (line {n}), a skill only one template ships; shared how-to text names only the seven shared working-practice skills"
    for n, line in command_lines(text):
        m = HOLDER.search(line)
        if m:
            return f"fences a command holding {m.group(0)!r} (line {n}), which does not run as written; name the value in prose, or route a command that needs a template's name to its own procedure"
    for n, line in enumerate(text.splitlines(), 1):
        if "**Last Updated**" in line:
            return f"carries a metadata header (line {n}); a shared how-to file has none, because each template would render its own"
    return None

for path, source, scope in sorted(files):
    if path not in HOWTO or not (root / source).is_file():
        continue
    prob = howto_problem((root / source).read_text(encoding="utf-8", errors="replace"))
    if prob:
        finding(28, f"{source} {prob}")

# ── 29. The how-to namespace (D56) ──
# Every template's own how-to files sit under folders named for it, inside these three; every
# other path under how-to/ is a shared file. So two templates never ship the same path but as a
# byte-identical shared file, and neither's update writes into the other's folder.
NS_PARENTS = ("how-to/docs", "how-to/src/TEMPLATE-GUIDE", "how-to/workflows")
def howto_paths(base):
    """(relative path, is a folder) for every entry under base/how-to, sorted; links unread."""
    out = []
    top = base / "how-to"
    if not top.is_dir() or top.is_symlink():
        return out
    for dp, dns, fns in os.walk(top):
        dns.sort()
        for d in list(dns):
            full = os.path.join(dp, d)
            out.append((os.path.relpath(full, base), True))
            if os.path.islink(full):
                dns.remove(d)
        for fn in sorted(fns):
            out.append((os.path.relpath(os.path.join(dp, fn), base), False))
    return sorted(out)

def namespace(base, owner, label, sib_mode=False):
    """Check 29 over one template's how-to/: label '' for this template, "the sibling's " under
    --sibling. A MEDIA-* name in this template's how-to/ is check 16's, which reads all of
    template/, so it is not reported twice."""
    own = tuple(f"{par}/{owner}" for par in NS_PARENTS)
    who = "the sibling" if label else "this template"
    bad = []
    for rel, is_dir in howto_paths(base):
        if any(rel == b or rel.startswith(b + "/") for b in bad):
            continue
        parent, name = rel.rsplit("/", 1)
        if sib_mode and any(rel == f"{par}/{OWNER}" or rel.startswith(f"{par}/{OWNER}/") for par in NS_PARENTS):
            finding(29, f"{label}{rel} is, or lies under, a folder named {OWNER}/, which only {OWNER} ships; a template ships its own how-to files only under folders named for it")
            bad.append(rel)
            continue
        if is_dir:
            if parent in NS_PARENTS and name != owner:
                finding(29, f"{label}{rel} is a folder named for another template, or for none; {who} ships its own how-to files only under {owner}/ there")
                bad.append(rel)
            continue
        if SIB_MODE.match(name) and not sib_mode:
            continue
        if rel not in HOWTO and not any(rel.startswith(o + "/") for o in own):
            finding(29, f"{label}{rel} is neither a shared how-to file nor under {who}'s own folders ({', '.join(o + '/' for o in own)}); how-to/ holds nothing else")

if tpl.is_dir():
    namespace(tpl, OWNER, "")
    for o in HOWTO_OWN:
        if not o.endswith("/" + OWNER):
            finding(29, f"_common.sh SA_HOWTO_OWN names {o}; this template's own how-to folders end in {OWNER}/")

# ── 30. Restore and guard (D56): the first problem ──
def oc_howto_problem():
    top = parsed.get("opencode.json")
    if not isinstance(top, dict):
        return None   # check 18 reports a file that does not parse
    perms = top.get("permissions") if isinstance(top.get("permissions"), list) else []
    want = {"action": "edit", "resource": "how-to/*", "effect": "deny"}
    at = [i for i, x in enumerate(perms) if x == want]
    asks = [i for i, x in enumerate(perms) if isinstance(x, dict) and x.get("effect") == "ask"]
    if len(at) != 1:
        return f"template/opencode.json holds {len(at)} top-level permissions entr{'y' if len(at) == 1 else 'ies'} {json.dumps(want)}; it holds exactly one, which the permissions script derives from the seed's Edit(/how-to/**)"
    if asks and at[0] < max(asks):
        return "template/opencode.json's how-to/* edit deny comes before an ask; every ask comes before every deny"
    return None

def guard_wired(data):
    entries = (((data.get("settings") or {}).get("hooks") or {}).get("PreToolUse")) if isinstance(data, dict) else None
    for e in entries if isinstance(entries, list) else []:
        for h in (e.get("hooks") or []) if isinstance(e, dict) else []:
            if isinstance(h, dict) and HOWTO_GUARD in str(h.get("command", "")):
                return True
    return False

if isinstance(rd, dict):
    prob30 = None
    if rd.get("restore") != RESTORE_DIRS:
        prob30 = f"{REFRESH_DATA} lists \"restore\": {json.dumps(rd.get('restore'))}; it must be exactly {json.dumps(RESTORE_DIRS)}, so every update puts the read-only guide back"
    elif HOWTO_GUARD not in {p for p, _, _ in files}:
        prob30 = f"the guide guard {HOWTO_GUARD} is not in the shared set; every family template ships it byte for byte"
    elif not guard_wired(rd):
        prob30 = f"{REFRESH_DATA} wires no settings.hooks.PreToolUse entry running {HOWTO_GUARD}; an existing project would never be offered the guard"
    elif HOWTO_DENY not in ((((rd.get("settings") or {}).get("permissions") or {}).get("deny")) or []):
        prob30 = f"{REFRESH_DATA} does not list {HOWTO_DENY} under settings.permissions.deny; an existing project would never be offered the guide's deny"
    else:
        prob30 = oc_howto_problem()
    if prob30:
        finding(30, prob30)

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
        sblocks = {x.get("name"): x for x in sman.get("blocks", []) if isinstance(x, dict)}
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
        for name, source, dest, begin, end, _, _ in BLOCKS:
            ssrc = sblocks.get(name, {}).get("source") or (COPIER if dest is None else "template/" + dest.replace("<template>", sname))
            sblk, err = block_lines(sroot / ssrc, begin, end)
            if blks[name][0] is not None and sblk != blks[name][0]:
                finding(10, f"the sibling's D48 {name} block ({ssrc}) differs from ours{' (' + err + ')' if sblk is None else ''}")
        # 15 and 29 under --sibling (D56): the shared how-to files it ships are copy-only and
        # refreshed there too, it names no how-to folder copy-only, and its how-to namespace.
        sowner = str(sman.get("owner", ""))
        try:
            sclines = (sroot / COPIER).read_text(encoding="utf-8").splitlines()
        except OSError:
            sclines = []
        sskips = set(items(top_section(sclines, "_skip_if_exists")))
        sgate = re.compile(r"<: if _copier_operation == 'update' :>(/[^<]*)<: endif :>")
        son_update = {m.group(1) for x in items(top_section(sclines, "_exclude")) if (m := sgate.fullmatch(x))}
        try:
            srd = json.loads((sroot / REFRESH_DATA).read_text(encoding="utf-8"))
        except (OSError, ValueError):
            srd = None
        srefresh = set((srd or {}).get("refresh") or []) if isinstance(srd, dict) else set()
        for p in HOWTO:
            if not (sroot / "template" / p).is_file():
                continue
            if "/" + p not in sskips:
                finding(15, f"the sibling's shared {p} has no anchored _skip_if_exists line in its copier.yml")
            elif "/" + p not in son_update:
                finding(15, f"the sibling's shared {p} has no _exclude line gated on the update in its copier.yml")
            elif p not in srefresh:
                finding(15, f"the sibling's {REFRESH_DATA} does not refresh the shared {p}; our update would then never add it where the sibling's recorded render holds it")
        for line in sorted(sskips | son_update):
            rel = line.lstrip("/")
            if rel in HOWTO or not (rel == "how-to" or rel.startswith("how-to/")):
                continue
            if rel == "how-to" or line.endswith("/") or (sroot / "template" / rel).is_dir():
                finding(15, f"the sibling's copier.yml names the how-to folder {line} copy-only; the shared how-to lines are file-level, so each template's own folders stay template-owned")
        if isinstance(srd, dict) and "restore" not in srd:
            print(f"NOTE: the sibling's {REFRESH_DATA} lists no \"restore\"; its updates leave the read-only guide as they find it", file=sys.stderr)
        if sowner and sowner != OWNER:
            namespace(sroot / "template", sowner, "the sibling's ", sib_mode=True)

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

# The fixture's MCP files, seed settings.json and refresh data, built from _common.sh's
# constants (never copied from template/), with a gate in each that has one in the template.
fixture_mcp() { # $1 = dir
  FX="$1" FX_SHARED="$SA_MCP_SHARED" FX_PINS="$SA_MCP_PINS" FX_TOOLS="$SA_CRG_TOOLS" \
  FX_BLANK="$SA_CRG_BLANK_KEYS" FX_ASKS="$SA_MCP_ASKS" FX_DENY="$SA_MCP_DENY" FX_REFRESH="$FS_REFRESH_DATA" FX_HOWTO_DENY="$SA_HOWTO_DENY" \
  python3 -I - <<'FX'
import json, os, re
E = os.environ
d = E["FX"]
pins, tools, blank, asks, deny = E["FX_PINS"].split(), E["FX_TOOLS"], E["FX_BLANK"].split(), E["FX_ASKS"].split(), E["FX_DENY"]
parts = [re.fullmatch(r"mcp__(.+?)__(.+)", a).groups() for a in asks]
ds, dt = re.fullmatch(r"mcp__(.+?)__(.+)", deny).groups()
crg_args = [pins[0], "serve", "--tools", tools]
scr_args = ["--from", pins[1], "--with", pins[2], "--with", pins[3], "scrapling", "mcp"]
env = {k: "" for k in blank}
def w(p, text):
    open(os.path.join(d, p), "w", encoding="utf-8").write(text)
servers = {"code-review-graph": {"command": "uvx", "args": crg_args, "env": env}, "scrapling": {"command": "uvx", "args": scr_args}}
w("template/.mcp.json", E["FX_SHARED"])
w("template/.agents/mcp_config.json", E["FX_SHARED"])
body = json.dumps({"tools": {"exclude": ["ask_user"], "confirmationRequired": [f"mcp_{s}_{t}" for s, t in parts]}, "mcpServers": servers}, indent=2)
w("template/.gemini/settings.json", "{\n<: if 'gemini-cli' in AGENT_CLIENTS and GEMINI_MODEL :>  \"model\": {\n    \"name\": <% GEMINI_MODEL | tojson %>\n  },\n<: endif :>" + body[2:] + "\n")
oc = {"$schema": "https://opencode.ai/config.json", "compaction": {"auto": False},
      "mcp": {"servers": {"code-review-graph": {"type": "local", "command": ["uvx"] + crg_args, "environment": env},
                          "scrapling": {"type": "local", "command": ["uvx"] + scr_args}}},
      "permissions": [{"action": f"{s}_{t}", "resource": "*", "effect": "ask"} for s, t in parts]
                     + [{"action": "edit", "resource": r, "effect": "deny"} for r in ("*.pdf", "build/*", "how-to/*", "typeset/src/units/.base/*")]
                     + [{"action": f"{ds}_{dt}", "resource": "*", "effect": "deny"}]}
body = json.dumps(oc, indent=2)
w("template/opencode.json", "{\n<: if 'opencode' in AGENT_CLIENTS and OPENCODE_PROVIDER == 'named' :>  \"model\": <% OPENCODE_MODEL | tojson %>,\n<: endif :>" + body[2:] + "\n")
q = lambda v: "[" + ", ".join(f"'{x}'" for x in v) + "]"
toml = ["# Codex's project settings.", "<: if 'codex' in AGENT_CLIENTS and CODEX_MODEL :>", "model = '<%CODEX_MODEL%>'", "<: endif :>", ""]
for s, args in (("code-review-graph", crg_args), ("scrapling", scr_args)):
    toml += [f"[mcp_servers.{s}]", "command = 'uvx'", f"args = {q(args)}", ""]
    if s == "code-review-graph":
        toml += [f"[mcp_servers.{s}.env]"] + [f"{k} = ''" for k in blank] + [""]
    for ss, t in parts:
        if ss == s:
            toml += [f"[mcp_servers.{s}.tools.{t}]", 'approval_mode = "prompt"', ""]
w("template/.codex/config.toml", "\n".join(toml).rstrip("\n") + "\n")
hook = {"hooks": [{"type": "command", "command": "bash -c 'exec bash .claude/hooks/context-threshold-handoff.sh'", "timeout": 10}]}
seed = json.dumps({"model": "opus", "permissions": {"allow": ["Bash(make *)", "WebSearch"], "deny": ["AskUserQuestion", "Edit(build/**)", "@GATE@", deny], "ask": asks},
                   "hooks": {"UserPromptSubmit": [hook]}}, indent=2)
seed = seed.replace('"Edit(build/**)",\n      "@GATE@",', '"Edit(build/**)",<: if DOC_TYPE != \'business\' :>\n      "Edit(typeset/src/units/.base/**)",<: endif :>')
w("template/.claude/settings.json", seed + "\n")
rp = os.path.join(d, E["FX_REFRESH"])
rd = json.load(open(rp, encoding="utf-8"))
rd["settings"]["permissions"] = {"deny": ["AskUserQuestion", "Edit(build/**)", E["FX_HOWTO_DENY"], deny], "ask": asks}
rd["mcp"] = {"servers": ["code-review-graph", "scrapling"],
             "files": {".agents/mcp_config.json": ["mcpServers"], ".codex/config.toml": ["mcp_servers"], ".gemini/settings.json": ["mcpServers"],
                       ".mcp.json": ["mcpServers"], "opencode.json": ["mcp", "servers"]}}
json.dump(rd, open(rp, "w", encoding="utf-8"), indent=2)
FX
}

fixture() { # $1 = dir: a template repository holding the shared set and the four blocks
  local t="$1" pair source p
  mkdir -p "$t/template/.agents" "$t/template/.claude/skills" "$t/template/.codex" "$t/template/.gemini" "$t/migrations" \
    "$t/template/.claude/rules/syntek-author" "$t/template/library/src"
  printf '0.3.0\n' > "$t/VERSION"
  for pair in "${FS_FILES[@]}"; do
    [[ "${pair%%|*}" == .agents/skills ]] && continue
    source="${pair#*|}"; source="${source%%|*}"
    mkdir -p "$(dirname "$t/$source")"
    printf 'shared text for %s\n' "${pair%%|*}" > "$t/$source"
  done
  for p in $SA_SHARED_HOOKS; do chmod +x "$t/template/$p"; done
  printf "import os\nOPT_OUT = os.environ.get('SYNTEK_UPDATE_REPORT')\n" > "$t/migrations/family-update.py"
  python3 - "$t/$FS_REFRESH_DATA" "$SA_SHARED_REFRESH" "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" <<'JSON'
import json, sys
paths = sys.argv[2].split()
hook = "bash -c 'exec bash .claude/hooks/context-threshold-handoff.sh'"
guard = {"matcher": sys.argv[3], "hooks": [{"type": "command", "command": sys.argv[4], "timeout": 10}]}
json.dump({"format": 1, "template": "syntek-author", "refresh": paths, "restore": ["how-to"],
           "settings": {"hooks": {"PreToolUse": [guard], "UserPromptSubmit": [{"hooks": [{"type": "command", "command": hook}]}]},
                        "permissions": {"deny": ["Edit(build/**)", sys.argv[5]], "ask": []}}}, open(sys.argv[1], "w"), indent=2)
JSON
  # The guide (D56): a shared pair holding a text tree with the <template> placeholder, which no
  # check reads as a command, and a Makefile whose targets check 28 knows.
  printf '%s\n' 'shared text for how-to/CONTEXT.md' '' '```text' 'how-to/' '└── docs/<template>/' '```' '' \
    'Make sure each command runs as written; make a copy first.' > "$t/template/how-to/CONTEXT.md"
  printf '%s\n' 'lint: ## report long lines' 'pdf: ## build a proof' > "$t/template/Makefile"
  printf "HELD = '%s'\nprint('the bridge (.claude/syntek-*-agents.md)')\n" "$FS_HELD" > "$t/migrations/agents-outside-link.py"
  # The resolver: the names that are not templates, and 'library' as an English word and in a
  # macOS path, beside a template folder named library/.
  printf '%s\n' "ROOT_VAR = 'SYNTEK_DATA_ROOT'" "MARKER = '.syntek-data-root'" "TMP = '.syntek-tmp'" \
    "FOUND = {'syntek-data-root', 'SYNTEK_DATA', 'syntek-tmp'}" \
    "# A SharePoint library folder, or ~/Library/CloudStorage on macOS: see .claude/syntek-*-dataroot.json." \
    > "$t/template/.claude/syntek-author-dataroot.py"
  printf '# Library\n' > "$t/template/library/src/README.md"
  # Folders only this template ships (check 27); typeset/ is named by opencode.json's exempt deny.
  for p in manuscript/src research/src typeset/src/units/.base; do mkdir -p "$t/template/$p"; printf '# %s\n' "$p" > "$t/template/$p/README.md"; done
  ln -s ../.claude/skills "$t/template/.agents/skills"
  fixture_mcp "$t"
  printf '%s\n' "# 06 — global rules" "" "## 13. Web and code tools" "" "$FS_RULES_BEGIN" \
    "**Requirement.** Ask the author before each asked tool." "" "- Use the plainest tool that does the job." \
    "$FS_RULES_END" > "$t/$FS_RULES_SOURCE"
  # A shipped file outside the shared set, holding every store test check 23 allows.
  {
    printf "%s\n" "<: if DATA_STORE == 'external' :>External.<: endif :><: if DATA_STORE == 'repo' :>Repo.<: endif :>"
    printf "%s\n" "<: if DOC_TYPE == 'business' and (DATA_PROVIDER | default('google-drive')) == 'google-drive' and (DATA_STORE | default('repo')) == 'repo' :>Drive.<: endif :>"
    printf "%s\n" "<: if DATA_STORE == 'external' :><: if DOC_TYPE == 'business' :>Business.<: else :>Books.<: endif :><: endif :><: if DOC_TYPE != 'business' :>Books.<: else :><: if DATA_STORE == 'external' :>Filed.<: endif :><: endif :>"
    printf "%s\n" "<:- if DATA_STORE in ['external'] -:>In.<:- endif -:>"
    printf "%s\n" "<: raw :><: if DATA_STORE :>quoted<: else :>quoted<: endif :><: endraw :>"
    printf "%s\n" "Shell: [ \"\$store\" != repo ] && exit 1"
  } > "$t/template/README.md"
  {
    printf '_external_data:\n  prev: .copier-answers.syntek-author.yml\n  peer: .copier-answers.syntek-media.yml\n\n'
    printf 'PROJECT_NAME:\n  type: str\n\n%s\n' "$FS_BEGIN"
    printf 'AGENT_CLIENTS:\n  default: "<%% %s if _external_data.prev.get(%s) else %s %%>"\n' "'[]'" "'_commit'" "'[codex]'"
    for k in CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT; do
      printf '%s:\n  type: str\n  when: "<%% %s in AGENT_CLIENTS %%>"\n' "$k" "'opencode'"
    done
    printf '%s\n' "# The data-root questions: each machine names its root in SYNTEK_DATA_ROOT, and the" \
      "# resolver (.claude/syntek-*-dataroot.py) reads these answers at run time."
    printf '%s\n' "DATA_STORE:" "  type: str" \
      "  default: \"<% (_external_data.prev or {}).get('DATA_STORE') if (_external_data.prev or {}).get('DATA_STORE') in ['external', 'repo'] else 'external' %>\"" \
      "  validator: \"<: set p = (_external_data.peer or {}).get('DATA_STORE') :><: if p and DATA_STORE != p :>One project, one store.<: endif :>\""
    printf '%s\n' "DATA_AREA:" "  type: str" "  when: \"<% DATA_STORE == 'external' %>\"" \
      "  validator: \"<: if DATA_STORE == 'external' :><: if not DATA_AREA :>Name the area.<: elif DATA_AREA | length > 64 :>Too long.<: endif :><: endif :>\""
    printf '%s\n' "DATA_SLUG:" "  type: str" "  when: \"<% DATA_STORE == 'external' %>\"" \
      "  default: \"<: set k = _folder_name | lower :><% (_external_data.prev or {}).get('DATA_SLUG') or (k if k else UNSET) %>\""
    for k in DATA_KIND_DOCS DATA_KIND_PHOTOS DATA_KIND_AUDIO DATA_KIND_VIDEOS; do
      printf '%s:\n  type: str\n  when: "<%% DATA_STORE == %s %%>"\n' "$k" "'external'"
    done
    printf '%s\n' "DATA_PROVIDER:" "  type: str" \
      "  default: \"<% (_external_data.prev or {}).get('DATA_PROVIDER') or ('google-drive' if (_external_data.prev or {}).get('INCLUDE_DRIVE_SYNC') is sameas true else ('none' if (_external_data.prev or {}).get('INCLUDE_DRIVE_SYNC') is sameas false else 'none')) %>\""
    printf '%s\n\nTIMEZONE:\n  type: str\n\n' "$FS_END"
    printf '_message_after_update: |-\n  Updated.<:- if DATA_STORE == %s :> Files stay in the repository.<:- endif :>\n\n' "'repo'"
    printf '_exclude:\n  - .git\n'
    printf '  - "%s"\n' "<: if not (DOC_TYPE == 'business' and (DATA_PROVIDER | default('google-drive')) == 'google-drive' and (DATA_STORE | default('repo')) == 'repo') :>/.github<: endif :>" \
      "<: if not (DATA_STORE == 'external') :>/research/src/.gitignore<: endif :>"
    for p in $SA_SHARED_REFRESH; do printf '  - "<: if _copier_operation == %s :>/%s<: endif :>"\n' "'update'" "$p"; done
    printf '_skip_if_exists:\n'
    for p in $SA_SHARED_REFRESH; do printf '  - /%s\n' "$p"; done
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
  # The release the tags decide: the tagged commit, later work, and the release commit.
  cp "$tmp/m" "$m"; sa_git "$SA_ROOT" init -q; sa_git "$SA_ROOT" add -A; sa_git "$SA_ROOT" commit -q -m 'v0.3.0'; sa_git "$SA_ROOT" tag v0.3.0
  probe "check 1 fires when the commit tagged with VERSION records unreleased" "check 1 — $FS_MANIFEST must hold format 1, owner syntek-author and release one of ['v0.3.0'] (HEAD is tagged v0.3.0"
  sed -i 's/"release": "unreleased"/"release": "v0.3.0"/' "$m";                 probe_clean "the commit tagged with VERSION naming its release passes"
  sa_git "$SA_ROOT" commit -q --allow-empty -m 'later work'
  probe "check 1 fires when later work still names the last release" "check 1 — $FS_MANIFEST must hold format 1, owner syntek-author and release one of ['unreleased'] (v0.3.0 is already released"
  cp "$tmp/m" "$m";                                                              probe_clean "later work recording unreleased passes"
  printf '0.4.0\n' > "$SA_ROOT/VERSION"
  probe "check 1 fires when the release commit still records unreleased" "check 1 — $FS_MANIFEST must hold format 1, owner syntek-author and release one of ['v0.4.0'] (VERSION is 0.4.0 and no tag v0.4.0 exists yet"
  printf '0.3.0\n' > "$SA_ROOT/VERSION"; rm -rf "$SA_ROOT/.git"
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
  printf 'Read the Syntek Author rules.\n' > "$g"; fs_py write "$SA_ROOT" ""
  probe "check 6 fires on the owner's name in another spelling" "check 6 — template/GEMINI.md names Syntek Author"
  printf 'Read the syntek-media rules.\n' > "$g"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when a project-scope shared file names another template" "check 11 — template/GEMINI.md names syntek-media"
  printf 'shared text for GEMINI.md\n' > "$g"; printf '# as syntek-media says\n' > "$SA_ROOT/template/.claude/syntek-author-permissions.py"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the permissions script names another template" "check 11 — template/.claude/syntek-author-permissions.py names syntek-media"
  printf 'shared text\n' > "$SA_ROOT/template/.claude/syntek-author-permissions.py"
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

  st_v050 "$tmp"
  st_v060 "$tmp"

  sib="$tmp/sibling"; cp -a "$SA_ROOT" "$sib"
  printf '# Grilling — media nonfiction mode\n' > "$sib/template/.claude/skills/grilling/MEDIA-NONFICTION.md"
  mv "$sib/template/.claude/syntek-author-permissions.py" "$sib/template/.claude/syntek-media-permissions.py"
  mkdir -p "$sib/template/.claude/rules/syntek-media"
  mv "$sib/$FS_RULES_SOURCE" "$sib/template/.claude/rules/syntek-media/06-global-rules.md"
  sed -i 's/"owner": "syntek-author"/"owner": "syntek-media"/; /"path": ".claude\/syntek-<template>-permissions.py"/s/syntek-author-permissions/syntek-media-permissions/' "$sib/$FS_MANIFEST"
  sed -i '/"name": "rules-web-tools"/s#"source": "template/.claude/rules/syntek-author/#"source": "template/.claude/rules/syntek-media/#' "$sib/$FS_MANIFEST"
  SIBLING="$sib";                                                                probe_clean "a sibling with identical copies under its own name, and MEDIA-* mode files beside a shared skill, is clean"
  python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); m["blocks"]=[b for b in m["blocks"] if b["name"]!="rules-web-tools"]; json.dump(m,open(sys.argv[1],"w"))' "$sib/$FS_MANIFEST"
  probe_clean "a sibling manifest without the fourth block is read at its destination, under the sibling's name"
  printf '# x\n' > "$sib/template/.claude/skills/grilling/THEOLOGY.md"
  probe "check 16 fires when the sibling ships this template's mode-file name beside a shared skill" "check 16 — the sibling's template/.claude/skills/grilling/THEOLOGY.md"
  rm "$sib/template/.claude/skills/grilling/THEOLOGY.md"
  printf 'drifted\n' > "$sib/template/AGENTS.md";                                  probe "check 10 fires when a sibling's copy drifts" "check 10 — the sibling's template/AGENTS.md"
  cp "$SA_ROOT/template/AGENTS.md" "$sib/template/AGENTS.md"
  printf '# drifted\n' >> "$sib/migrations/agents-outside-link.py";                 probe "check 10 fires when a sibling's migration script drifts" "check 10 — the sibling's migrations/agents-outside-link.py"
  cp "$SA_ROOT/migrations/agents-outside-link.py" "$sib/migrations/agents-outside-link.py"
  sed -i 's/^  # Runs on every update\.$/  # Runs on each update./' "$sib/copier.yml"; probe "check 10 fires when a sibling's migrations block drifts" "check 10 — the sibling's D48 migrations block"
  cp "$SA_ROOT/copier.yml" "$sib/copier.yml"
  sed -i 's/^- Use the plainest tool that does the job\.$/- Use any tool./' "$sib/template/.claude/rules/syntek-media/06-global-rules.md"
  probe "check 10 fires when a sibling's rules-web-tools block drifts" "check 10 — the sibling's D48 rules-web-tools block (template/.claude/rules/syntek-media/06-global-rules.md)"
  cp "$SA_ROOT/$FS_RULES_SOURCE" "$sib/template/.claude/rules/syntek-media/06-global-rules.md"
  cp "$SA_ROOT/template/.claude/syntek-author-dataroot.py" "$tmp/resolver.held"; mkdir -p "$sib/template/production"
  printf '%s\n' 'X = "production/src/"' >> "$SA_ROOT/template/.claude/syntek-author-dataroot.py"; fs_py write "$SA_ROOT" ""
  cp "$SA_ROOT/template/.claude/syntek-author-dataroot.py" "$sib/template/.claude/syntek-author-dataroot.py"
  probe "check 26 fires when the resolver names a folder of the sibling's template" "check 26 — template/.claude/syntek-author-dataroot.py names the template folder(s) production"
  cp "$tmp/resolver.held" "$SA_ROOT/template/.claude/syntek-author-dataroot.py"; cp "$tmp/resolver.held" "$sib/template/.claude/syntek-author-dataroot.py"; fs_py write "$SA_ROOT" ""
  # Check 27 with --sibling: a path both templates ship passes; one only the sibling ships fires.
  cp "$SA_ROOT/template/GEMINI.md" "$tmp/gemini.held"
  printf '%s\n' "Draft in manuscript/src/ first." > "$SA_ROOT/template/GEMINI.md"; cp "$SA_ROOT/template/GEMINI.md" "$sib/template/GEMINI.md"; fs_py write "$SA_ROOT" ""
  probe_clean "with --sibling, a path both templates ship passes check 27"
  printf '%s\n' "Render into production/renders/." > "$SA_ROOT/template/GEMINI.md"; cp "$SA_ROOT/template/GEMINI.md" "$sib/template/GEMINI.md"; fs_py write "$SA_ROOT" ""
  probe "check 27 fires when a shared file names a path only the sibling ships" "check 27 — template/GEMINI.md names production (line 1) as a path, which only the sibling ships"
  cp "$tmp/gemini.held" "$SA_ROOT/template/GEMINI.md"; cp "$tmp/gemini.held" "$sib/template/GEMINI.md"; fs_py write "$SA_ROOT" ""
  # The guide under --sibling (D56): the sibling's own folders pass; its shared how-to lines and
  # refresh entries, a folder line, and a path under this template's folder fire.
  mkdir -p "$sib/template/how-to/src/TEMPLATE-GUIDE/syntek-media"; printf '# A — b\n' > "$sib/template/how-to/src/TEMPLATE-GUIDE/syntek-media/01-a.md"
  probe_clean "with --sibling, the sibling's own how-to folder passes check 29"
  cp "$sib/copier.yml" "$tmp/sib.c"; grep -vxF '  - /how-to/workflows/CLAUDE.md' "$tmp/sib.c" > "$sib/copier.yml"
  probe "check 15 fires when the sibling ships a shared how-to file without its skip line" "check 15 — the sibling's shared how-to/workflows/CLAUDE.md has no anchored _skip_if_exists line"
  cp "$tmp/sib.c" "$sib/copier.yml"; sed -i 's#^  - /handoffs/CONTEXT.md$#&\n  - /how-to/src#' "$sib/copier.yml"
  probe "check 15 fires when the sibling names a how-to folder copy-only" "check 15 — the sibling's copier.yml names the how-to folder /how-to/src"
  cp "$tmp/sib.c" "$sib/copier.yml"; cp "$sib/$FS_REFRESH_DATA" "$tmp/sib.rd"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["refresh"].remove("how-to/src/CLAUDE.md"); json.dump(d,open(sys.argv[1],"w"))' "$sib/$FS_REFRESH_DATA"
  probe "check 15 fires when the sibling does not refresh a shared how-to file it ships" "check 15 — the sibling's $FS_REFRESH_DATA does not refresh the shared how-to/src/CLAUDE.md"
  cp "$tmp/sib.rd" "$sib/$FS_REFRESH_DATA"; python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d.pop("restore"); json.dump(d,open(sys.argv[1],"w"))' "$sib/$FS_REFRESH_DATA"
  probe_clean "a sibling whose refresh data lists no restore gets a note, never a finding"
  cp "$tmp/sib.rd" "$sib/$FS_REFRESH_DATA"; mkdir -p "$sib/template/how-to/docs/syntek-author"; printf 'x\n' > "$sib/template/how-to/docs/syntek-author/x.md"
  probe "check 29 fires when the sibling ships a path under a syntek-author/ folder" "check 29 — the sibling's how-to/docs/syntek-author is, or lies under, a folder named syntek-author/"
  rm -r "$sib/template/how-to/docs/syntek-author"; printf 'x\n' > "$sib/template/how-to/stray.md"
  probe "check 29 fires when the sibling ships a how-to path outside the shared set and its own folders" "check 29 — the sibling's how-to/stray.md is neither a shared how-to file"
  rm "$sib/template/how-to/stray.md" "$sib/template/how-to/src/TEMPLATE-GUIDE/syntek-media/01-a.md"
  SIBLING=""

  SA_ROOT="$real_root"
  st_finish "a shared set in step with its manifest from one that has drifted"
}

# The v0.5.0 probes (D50, D53, D54): the fourth block, the fifteen-key question block, the
# resolver, the MCP files and their rules, the store's equality rule, the peer key and the
# retired key. $1 = the self-test's scratch folder. Each mutation is undone before the next.
st_v050() {
  local tmp="$1" m="$SA_ROOT/$FS_MANIFEST" c="$SA_ROOT/copier.yml" rules="$SA_ROOT/$FS_RULES_SOURCE"
  local res="$SA_ROOT/template/.claude/syntek-author-dataroot.py" readme="$SA_ROOT/template/README.md"
  local rd="$SA_ROOT/$FS_REFRESH_DATA" seed="$SA_ROOT/$FS_SEED_SETTINGS" f
  fs_py write "$SA_ROOT" ""
  for f in "$m" "$c" "$rules" "$res" "$readme" "$rd" "$seed" "$SA_ROOT"/template/.mcp.json "$SA_ROOT"/template/.gemini/settings.json \
           "$SA_ROOT"/template/opencode.json "$SA_ROOT"/template/.codex/config.toml; do
    cp "$f" "$tmp/v050.${f##*/}.${f//\//_}"
  done
  st_restore() { local f; for f in "$@"; do cp "$tmp/v050.${f##*/}.${f//\//_}" "$f"; done; fs_py write "$SA_ROOT" ""; }
  readme_add() { printf '%s\n' "$1" >> "$readme"; }

  # The manifest: the resolver listed, the map not, and the fourth block with its destination.
  python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); m["files"].insert(2, {"path": ".claude/syntek-<template>-dataroot.json", "source": "template/.claude/syntek-author-dataroot.json", "kind": "file"}); json.dump(m,open(sys.argv[1],"w"))' "$m"
  probe "check 2 fires when the manifest lists the data-root map" "check 2"
  st_restore "$m"
  python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); m["files"]=[e for e in m["files"] if not e["path"].endswith("-dataroot.py")]; json.dump(m,open(sys.argv[1],"w"))' "$m"
  probe "check 2 fires when the manifest leaves the resolver out" "check 2"
  st_restore "$m"
  python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); m["blocks"]=m["blocks"][:3]; json.dump(m,open(sys.argv[1],"w"))' "$m"
  probe "check 2 fires when the rules-web-tools block is not listed" "check 2"
  st_restore "$m"
  python3 -c 'import json,sys; m=json.load(open(sys.argv[1])); del m["blocks"][3]["destination"]; json.dump(m,open(sys.argv[1],"w"))' "$m"
  probe "check 2 fires when the rules-web-tools block loses its destination" "check 2"
  st_restore "$m"

  # The fourth block: its markers, its bytes, and token-free, template-free text.
  printf '%s\n' "$FS_RULES_BEGIN" >> "$rules";                                     probe "check 7 fires on a second rules-web-tools BEGIN marker" "check 7 — 06-global-rules.md holds"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- Use a plain tool./' "$rules"
  probe "check 9 fires when the rules-web-tools block changes" "check 9 — the D48 rules-web-tools block"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- Ask <%AUTHOR_FIRST_NAME%>./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on a delimiter in the rules-web-tools block" "check 5 — the D48 rules-web-tools block holds a template delimiter"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- See syntek-author./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 6 fires when the rules-web-tools block names syntek-author" "check 6 — the D48 rules-web-tools block"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- As syntek-media says./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the rules-web-tools block names another template" "check 11 — the D48 rules-web-tools block names syntek-media"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- Decided in D54./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the rules-web-tools block names a decision number" "check 11 — the D48 rules-web-tools block names decision D54"
  st_restore "$rules"; sed -i 's/^- Use the plainest tool that does the job\.$/- As Section 12 says./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the rules-web-tools block names a section number" "check 11 — the D48 rules-web-tools block names a section number"
  st_restore "$rules"; printf '%s\n' "## 14. Our own section, D99, outside the markers" >> "$rules"; fs_py write "$SA_ROOT" ""
  probe_clean "the template's own text outside the rules-web-tools markers is its own"
  st_restore "$rules"

  # The question block: fifteen keys in order, what it may read, and check 11 on it.
  python3 - "$c" <<'PY'
import sys
p = sys.argv[1]; lines = open(p).read().split("\n")
i = lines.index("DATA_PROVIDER:"); j = next(k for k in range(i + 1, len(lines)) if not lines[k].startswith("  "))
blk = lines[i:j]; del lines[i:j]
k = lines.index("DATA_STORE:") - 2
open(p, "w").write("\n".join(lines[:k] + blk + lines[k:]))
PY
  fs_py write "$SA_ROOT" ""
  probe "check 8 fires when the question block's keys are out of order" "check 8 — the D48 question block's top-level keys"
  st_restore "$c"; sed -i "s/^  validator: \"<: if DATA_STORE == 'external' :><: if not DATA_AREA :>/  validator: \"<: if DATA_STORE == 'external' and _copier_operation == 'copy' :><: if not DATA_AREA :>/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires when the question block reads a name outside its own" "check 5 — the D48 questions block uses _copier_operation"
  st_restore "$c"; sed -i 's/^# resolver (.claude\/syntek-\*-dataroot.py) reads these answers at run time\.$/# resolver reads these answers at run time (D50)./' "$c"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the question block names a decision number" "check 11 — the D48 questions block names decision D50"
  st_restore "$c"; sed -i 's/^# resolver (.claude\/syntek-\*-dataroot.py) reads these answers at run time\.$/# resolver reads .copier-answers.syntek-media.yml too./' "$c"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the question block names another template" "check 11 — the D48 questions block names syntek-media"
  st_restore "$c"

  # The resolver: no delimiter, no template, no decision number, no template folder.
  printf '%s\n' "x = '<%AGENT_CLIENTS%>'" >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 5 fires on any delimiter in the resolver, a shared key's included" "check 5 — template/.claude/syntek-author-dataroot.py holds a template delimiter"
  st_restore "$res"; printf '%s\n' "# as .claude/syntek-media-dataroot.json says" >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the resolver names another template" "check 11 — template/.claude/syntek-author-dataroot.py names syntek-media"
  st_restore "$res"; printf '%s\n' "# Decided in D50." >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when the resolver names a decision number" "check 11 — template/.claude/syntek-author-dataroot.py names decision D50"
  st_restore "$res"; printf '%s\n' "FOLDERS = ['library/src']" >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 26 fires when the resolver names a template folder as a path" "check 26 — template/.claude/syntek-author-dataroot.py names the template folder(s) library"
  st_restore "$res"; printf '%s\n' "LAYER = \"library\"" >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 26 fires when the resolver quotes a template folder's name" "check 26 — template/.claude/syntek-author-dataroot.py names the template folder(s) library"
  st_restore "$res"; printf '%s\n' "# Files under .claude/ and .agents/ are the family's own." >> "$res"; fs_py write "$SA_ROOT" ""
  probe_clean "the resolver may name the shared folders .claude and .agents"
  st_restore "$res"

  # A path only this template ships (check 27): path-like uses only, and opencode.json's three
  # edit denies the one exception.
  local gem="$SA_ROOT/template/GEMINI.md" agents="$SA_ROOT/template/AGENTS.md" oc="$SA_ROOT/template/opencode.json"
  cp "$gem" "$tmp/v050.gem"; cp "$agents" "$tmp/v050.agents"
  printf '%s\n' "Draft in manuscript/src/ first." > "$gem"; fs_py write "$SA_ROOT" ""
  probe "check 27 fires when a shared file names a path only this template ships" "check 27 — template/GEMINI.md names manuscript (line 1)"
  printf '%s\n' "Ask the project's research skill about the manuscript; read each folder's CONTEXT.md, README.md" \
    "and .gitignore; see https://example.org/research/notes and 'https://example.org/typeset/'." > "$gem"; fs_py write "$SA_ROOT" ""
  probe_clean "a template folder named as a word, the house files every family template ships and a URL's path pass"
  printf '%s\n' "Weigh the research/planning question, and people/world. Ask the 'research' skill, or \`research\`;" \
    "its folder is .claude/skills/research/SKILL.md." > "$gem"; fs_py write "$SA_ROOT" ""
  probe_clean "Markdown prose passes: word/word, a quoted bare name, a path under a family folder"
  printf '%s\n' "Save each page under \`research/src\`." > "$gem"; fs_py write "$SA_ROOT" ""
  probe "check 27 fires on a quoted two-word path in Markdown" "check 27 — template/GEMINI.md names research (line 1)"
  cp "$tmp/v050.gem" "$gem"; printf '%s\n' "Never edit 'typeset/src/units/.base/*'." > "$agents"; fs_py write "$SA_ROOT" ""
  probe "check 27 fires on an exempt resource outside opencode.json" "check 27 — template/AGENTS.md names typeset (line 1)"
  cp "$tmp/v050.agents" "$agents"
  python3 - "$oc" <<'PY'
import re, sys
p = sys.argv[1]; t = open(p).read()
pat = r'"action": "edit",(\s*)"resource": "typeset/src/units/\.base/\*"'
assert len(re.findall(pat, t)) == 1
open(p, "w").write(re.sub(pat, r'"action": "read",\1"resource": "typeset/src/units/.base/*"', t))
PY
  fs_py write "$SA_ROOT" ""
  probe "check 27 fires on an exempt resource in opencode.json outside an edit deny" "check 27 — template/opencode.json names typeset"
  st_restore "$oc"
  sed -i 's/^- Use the plainest tool that does the job\.$/- Save each page under research\/src\/./' "$rules"; fs_py write "$SA_ROOT" ""
  probe "check 27 fires when a block names a path only this template ships" "check 27 — the D48 rules-web-tools block names research ($FS_RULES_SOURCE line"
  st_restore "$rules"
  printf '%s\n' "# copies land under data/research" >> "$res"; fs_py write "$SA_ROOT" ""
  probe "check 27 reads the resolver for a path check 26 does not see" "check 27 — template/.claude/syntek-author-dataroot.py names research (line"
  st_restore "$res"; cp "$SA_ROOT/template/.claude/syntek-author-permissions.py" "$tmp/perms.held"
  printf '%s\n' "LAYERS = ('library', 'assets')" >> "$SA_ROOT/template/.claude/syntek-author-permissions.py"; fs_py write "$SA_ROOT" ""
  probe "check 27 still reads a bare quoted name in code" "check 27 — template/.claude/syntek-author-permissions.py names library (line"
  cp "$tmp/perms.held" "$SA_ROOT/template/.claude/syntek-author-permissions.py"; fs_py write "$SA_ROOT" ""

  # The MCP files (D54): pins, the tool list, the blank keys, the rules, the lane data.
  sed -i 's/code-review-graph==2\.3\.9/code-review-graph==2.3.8/' "$SA_ROOT/template/opencode.json"; fs_py write "$SA_ROOT" ""
  probe "check 18 fires on a changed pin" "check 18 — template/opencode.json"
  st_restore "$SA_ROOT/template/opencode.json"
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p)); del d["mcpServers"]["scrapling"]; open(p,"w").write(json.dumps(d, indent=2)+"\n")' "$SA_ROOT/template/.mcp.json"; fs_py write "$SA_ROOT" ""
  probe "check 18 fires when a file loses a server" "check 18 — template/.mcp.json"
  st_restore "$SA_ROOT/template/.mcp.json"
  sed -i 's/,cross_repo_search_tool/,cross_repo_search_tool,embed_graph_tool/' "$SA_ROOT/template/.codex/config.toml"; fs_py write "$SA_ROOT" ""
  probe "check 19 fires when the tool list offers embed_graph_tool" "check 19 — template/.codex/config.toml"
  st_restore "$SA_ROOT/template/.codex/config.toml"
  sed -i 's/,traverse_graph_tool//' "$SA_ROOT/template/.gemini/settings.json"; fs_py write "$SA_ROOT" ""
  probe "check 19 fires when the tool list drops a tool" "check 19 — template/.gemini/settings.json"
  st_restore "$SA_ROOT/template/.gemini/settings.json"
  sed -i 's/"ask_user"/"ask_user", "mcp_code-review-graph_embed_graph_tool"/' "$SA_ROOT/template/.gemini/settings.json"; fs_py write "$SA_ROOT" ""
  probe "check 19 fires when embed_graph_tool is named outside the tool list" "check 19 — template/.gemini/settings.json: names embed_graph_tool 1 time(s)"
  st_restore "$SA_ROOT/template/.gemini/settings.json"
  sed -i 's/"VOYAGE_API_KEY": ""/"VOYAGE_API_KEY": "set"/' "$SA_ROOT/template/opencode.json"; fs_py write "$SA_ROOT" ""
  probe "check 20 fires when a blank key carries a value" "check 20 — template/opencode.json"
  st_restore "$SA_ROOT/template/opencode.json"
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["mcpServers"]["scrapling"]["cwd"]="/tmp"; open(p,"w").write(json.dumps(d, indent=2)+"\n")' "$SA_ROOT/template/.mcp.json"; fs_py write "$SA_ROOT" ""
  probe "check 20 fires on another key in a server entry" "check 20 — template/.mcp.json"
  st_restore "$SA_ROOT/template/.mcp.json"
  python3 -c 'import sys; p=sys.argv[1]; a, b = "\"mcp__scrapling__stealthy_fetch\"", "\"mcp__scrapling__bulk_stealthy_fetch\""; t=open(p).read(); s=",\n      "; assert t.count(a + s + b) == 1; open(p,"w").write(t.replace(a + s + b, b + s + a))' "$seed"
  probe "check 21 fires when the seed's asks change order" "check 21 — $FS_SEED_SETTINGS"
  st_restore "$seed"
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["settings"]["permissions"]["deny"].pop(); json.dump(d,open(p,"w"),indent=2)' "$rd"
  probe "check 21 fires when family-refresh.json drops the deny" "check 21 — $FS_REFRESH_DATA"
  st_restore "$rd"
  sed -i '0,/"mcp_scrapling_fetch",/{/"mcp_scrapling_fetch",/d}' "$SA_ROOT/template/.gemini/settings.json"; fs_py write "$SA_ROOT" ""
  probe "check 21 fires when Gemini CLI's confirmationRequired loses an ask" "check 21 — template/.gemini/settings.json"
  st_restore "$SA_ROOT/template/.gemini/settings.json"
  sed -i 's/"command": "uvx",$/"command": "uvx", "trust": true,/' "$SA_ROOT/template/.gemini/settings.json"; sed -i '0,/"trust": true,/!s/ "trust": true,//' "$SA_ROOT/template/.gemini/settings.json"; fs_py write "$SA_ROOT" ""
  probe "check 21 fires on a Gemini trust (not check 20)" "check 21 — template/.gemini/settings.json: code-review-graph sets trust"
  st_restore "$SA_ROOT/template/.gemini/settings.json"
  python3 -c 'import json,sys; p=sys.argv[1]; t=open(p).read(); h,b=t.split("<: endif :>",1); d=json.loads("{"+b[b.index("\""):]); d["permissions"].insert(0, d["permissions"].pop()); open(p,"w").write(h+"<: endif :>"+json.dumps(d, indent=2)[2:]+"\n")' "$SA_ROOT/template/opencode.json"; fs_py write "$SA_ROOT" ""
  probe "check 21 fires when an OpenCode deny comes before an ask" "check 21 — template/opencode.json: an ask follows a deny"
  st_restore "$SA_ROOT/template/opencode.json"
  sed -i '0,/approval_mode = "prompt"/s//approval_mode = "approve"/' "$SA_ROOT/template/.codex/config.toml"; fs_py write "$SA_ROOT" ""
  probe "check 21 fires on a Codex approval_mode other than prompt" "check 21 — template/.codex/config.toml"
  st_restore "$SA_ROOT/template/.codex/config.toml"
  sed -i 's/"model": "opus",/"model": "opus",\n  "enableAllProjectMcpServers": true,/' "$seed"
  probe "check 21 fires when the seed switches the MCP prompt off" "check 21 — $FS_SEED_SETTINGS: names enableAllProjectMcpServers"
  st_restore "$seed"
  printf '%s\n' "$SA_CRG_INSTALL_MARKERS" | head -n 1 >> "$readme"
  probe "check 21 fires on an install marker under template/" "check 21 — template/README.md: holds code-review-graph's install marker"
  st_restore "$readme"
  sed -i "s#exec bash .claude/hooks/context-threshold-handoff.sh#exec bash .claude/hooks/context-threshold-handoff.sh; code-review-graph update#" "$seed"
  probe "check 21 fires on a seed hook that runs code-review-graph" "check 21 — $FS_SEED_SETTINGS: a hook command names code-review-graph"
  st_restore "$seed"
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p)); del d["mcp"]["files"][".codex/config.toml"]; json.dump(d,open(p,"w"),indent=2)' "$rd"
  probe "check 22 fires when the lane data leaves an MCP file out" "check 22 — $FS_REFRESH_DATA"
  st_restore "$rd"
  python3 -c 'import json,sys; p=sys.argv[1]; d=json.load(open(p)); d["mcp"]["servers"].append("elevenlabs"); json.dump(d,open(p,"w"),indent=2)' "$rd"
  probe "check 22 fires when the lane data names a server .mcp.json does not" "check 22 — $FS_REFRESH_DATA"
  st_restore "$rd"

  # The store's equality rule (check 23).
  readme_add "<: if DATA_STORE != 'repo' :>x<: endif :>";                       probe "check 23 fires on != with a literal" "check 23 — template/README.md:7 compares DATA_STORE by !="
  st_restore "$readme"; readme_add "<: if DATA_STORE not in ['repo'] :>x<: endif :>"; probe "check 23 fires on not in with a literal" "check 23 — template/README.md:7 compares DATA_STORE by not in"
  st_restore "$readme"; readme_add "<: if 'repo' != DATA_STORE :>x<: endif :>";     probe "check 23 fires on != with the literal first" "check 23 — template/README.md:7 compares DATA_STORE by !="
  st_restore "$readme"; readme_add "<: if DATA_STORE :>x<: endif :>";               probe "check 23 fires on a bare test" "check 23 — template/README.md:7 tests DATA_STORE bare"
  st_restore "$readme"; readme_add "<: if DOC_TYPE == 'business' and not DATA_STORE :>x<: endif :>"
  probe "check 23 fires on a bare test inside a condition" "check 23 — template/README.md:7 tests DATA_STORE bare"
  st_restore "$readme"; readme_add "<: if DATA_STORE == 'external' :>x<: else :>y<: endif :>"
  probe "check 23 fires on an else arm" "check 23 — template/README.md:7 gives a block whose if or an earlier elif tests DATA_STORE an else arm"
  st_restore "$readme"; readme_add "<: if DATA_STORE == 'external' :>x<: elif DOC_TYPE == 'business' :>y<: endif :>"
  probe "check 23 fires on an elif arm" "check 23 — template/README.md:7 gives a block whose if or an earlier elif tests DATA_STORE an elif arm"
  st_restore "$readme"; readme_add "<: if DOC_TYPE == 'business' :>x<: elif DATA_STORE == 'external' :>y<: else :>z<: endif :>"
  probe "check 23 fires on an else after an elif that tests it" "check 23 — template/README.md:7 gives a block whose if or an earlier elif tests DATA_STORE an else arm"
  st_restore "$readme"; readme_add "<% 'a' if DATA_STORE == 'external' else 'b' %>"
  probe "check 23 fires on an inline if … else" "check 23 — template/README.md:7 tests DATA_STORE in an inline if"
  st_restore "$readme"; readme_add "<: if DATA_STORE != p :>x<: endif :><% 'a' if DATA_STORE == 'external' %><: set s = DATA_STORE :>Store <% DATA_STORE %>.<: if (_external_data.peer or {}).get('DATA_STORE') != 'repo' :>y<: endif :>"
  probe_clean "another answer compared by !=, an inline if without else, an assignment, the printed value and a .get('DATA_STORE') string pass"
  st_restore "$readme"; readme_add "<: if not (DATA_STORE == 'external') :>x<: endif :>"
  probe "check 23 fires on not over a bracketed equality" "check 23 — template/README.md:7 negates an equality test of DATA_STORE with not"
  st_restore "$readme"; readme_add "<: if not DATA_STORE == 'external' :>x<: endif :>"
  probe "check 23 fires on not over a bare equality" "check 23 — template/README.md:7 negates an equality test of DATA_STORE with not"
  st_restore "$readme"; readme_add "<: if not (DOC_TYPE == 'business' and DATA_STORE in ['repo']) :>x<: endif :>"
  probe "check 23 fires on not over a group that holds an in test" "check 23 — template/README.md:7 negates an equality test of DATA_STORE with not"
  st_restore "$readme"; readme_add "<: if DATA_STORE is ne 'repo' :>x<: endif :>"
  probe "check 23 fires on the ne test" "check 23 — template/README.md:7 compares DATA_STORE by is ne"
  st_restore "$readme"; readme_add "<: if DATA_STORE is not eq 'repo' :>x<: endif :>"
  probe "check 23 fires on a negated eq test" "check 23 — template/README.md:7 compares DATA_STORE by is not eq"
  st_restore "$readme"; readme_add "<: if not INCLUDE_PROPOSAL and DATA_STORE == 'repo' :>x<: endif :><: if DATA_STORE is equalto 'repo' and not (DOC_TYPE == 'business') :>y<: endif :>"
  probe_clean "a not over another answer beside a store equality, and the equalto test, pass"
  st_restore "$readme"
  sed -i "0,/^  when: \"<% DATA_STORE == 'external' %>\"$/s//  when: \"<% DATA_STORE %>\"/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 23 fires on a bare when: in copier.yml" "check 23 — copier.yml"
  st_restore "$c"
  sed -i "0,/^  when: \"<% DATA_STORE == 'external' %>\"$/s//  when: \"<% not (DATA_STORE == 'repo') %>\"/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 23 fires on a negated when: in copier.yml (only _exclude's house form may negate)" "check 23 — copier.yml"
  st_restore "$c"

  # The peer key (check 24).
  sed -i 's/^  peer: .copier-answers.syntek-media.yml$/  peer: .copier-answers.syntek-author.yml/' "$c"
  probe "check 24 fires when the peer key names this template's own answers file" "check 24"
  st_restore "$c"; sed -i '/^  peer: /d' "$c"
  probe "check 24 fires when the peer key is gone" "check 24"
  st_restore "$c"

  # The retired key (check 25).
  sed -i "s/^  validator: \"<: set p = (_external_data.peer or {}).get('DATA_STORE') :>/  validator: \"<: set n = (_external_data.prev or {}).get('PROJECT_NAME') :><: set p = (_external_data.peer or {}).get('DATA_STORE') :>/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 25 fires when the block reads another template answer by name" "check 25 — the D48 question block names 'PROJECT_NAME'"
  st_restore "$c"; sed -i "s/(_external_data.prev or {}).get('DATA_PROVIDER') or ('google-drive'/(_external_data.prev or {}).get('DATA_PROVIDER') or (_external_data.prev or {}).get('INCLUDE_DRIVE_SYNC') or ('google-drive'/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 25 fires on a third INCLUDE_DRIVE_SYNC literal" "check 25 — the D48 question block holds 3 'INCLUDE_DRIVE_SYNC' literal(s)"
  st_restore "$c"; sed -i "s/^  validator: \"<: set p = (_external_data.peer or {}).get('DATA_STORE') :>/  validator: \"<: set r = (_external_data.prev or {}).get('INCLUDE_DRIVE_SYNC') :><: set p = (_external_data.peer or {}).get('DATA_STORE') :>/" "$c"; fs_py write "$SA_ROOT" ""
  probe "check 25 fires on the retired key outside DATA_PROVIDER's default" "check 25 — the D48 question block names 'INCLUDE_DRIVE_SYNC'"
  st_restore "$c"
}

# The v0.6.0 probes (D56): the shared how-to files and the guide guard. $1 = the self-test's
# scratch folder. Each mutation is undone before the next.
st_v060() {
  local tmp="$1" ctx="$SA_ROOT/template/how-to/CONTEXT.md" wf="$SA_ROOT/template/how-to/workflows/CLAUDE.md"
  local rd="$SA_ROOT/$FS_REFRESH_DATA" oc="$SA_ROOT/template/opencode.json"
  fs_py write "$SA_ROOT" ""
  cp "$ctx" "$tmp/v060.ctx"; cp "$wf" "$tmp/v060.wf"; cp "$rd" "$tmp/v060.rd"; cp "$oc" "$tmp/v060.oc"
  printf '%s\n' 'Ask the `run-workflow` skill for the procedure.' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on a skill only one template ships" "check 28 — template/how-to/CONTEXT.md names the skill \`run-workflow\`"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' '```bash' "$SA_UVX_COPIER update --trust -a .copier-answers.<template>.yml" '```' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on a placeholder in a command fence" "check 28 — template/how-to/CONTEXT.md fences a command holding '<template>'"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' 'Then run make lint over the guide.' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on a make target in a sentence" "check 28 — template/how-to/CONTEXT.md names make lint"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' '**Last Updated**: 01/01/2027 **Version**: 0.1.0' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on a metadata header" "check 28 — template/how-to/CONTEXT.md carries a metadata header"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' '```bash' 'make pdf' '```' 'See .claude/skills/handoff/SKILL.md and `grill-me`; make a note.' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 reads a make target inside a command fence too" "check 28 — template/how-to/CONTEXT.md names make pdf"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' 'Make lint reports it.' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on a make target opening a sentence" "check 28 — template/how-to/CONTEXT.md names make lint"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' '```bash' 'git log ...' '```' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe "check 28 fires on ASCII ... in a command fence" "check 28 — template/how-to/CONTEXT.md fences a command holding '...'"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' 'See .claude/skills/handoff/SKILL.md and `grill-me`; make a note, and make sure. Make sure.' >> "$ctx"; fs_py write "$SA_ROOT" ""
  probe_clean "a shared skill, its path, and plain English 'make' in either case pass check 28"
  cp "$tmp/v060.ctx" "$ctx"; printf '%s\n' 'As Section 3 of the rules says.' >> "$wf"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires when a shared how-to file names a section number" "check 11 — template/how-to/workflows/CLAUDE.md names a section number"
  cp "$tmp/v060.wf" "$wf"; printf '%s\n' 'As section 3 of the rules says.' >> "$wf"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires on a section number in lower case" "check 11 — template/how-to/workflows/CLAUDE.md names a section number (section 3)"
  cp "$tmp/v060.wf" "$wf"; printf '%s\n' 'As rules 06 says.' >> "$wf"; fs_py write "$SA_ROOT" ""
  probe "check 11 fires on a rules file named by its number" "check 11 — template/how-to/workflows/CLAUDE.md names a section number (rules 06)"
  cp "$tmp/v060.wf" "$wf"; fs_py write "$SA_ROOT" ""
  printf 'x\n' > "$SA_ROOT/template/how-to/notes.md"
  probe "check 29 fires on a how-to path outside the shared set and this template's folders" "check 29 — how-to/notes.md is neither a shared how-to file"
  rm "$SA_ROOT/template/how-to/notes.md"; mkdir -p "$SA_ROOT/template/how-to/docs/syntek-media"; printf 'x\n' > "$SA_ROOT/template/how-to/docs/syntek-media/x.md"
  probe "check 29 fires on another template's folder inside how-to/docs" "check 29 — how-to/docs/syntek-media is a folder named for another template"
  rm -r "$SA_ROOT/template/how-to/docs/syntek-media"; mkdir -p "$SA_ROOT/template/how-to/docs/syntek-author"; printf 'x\n' > "$SA_ROOT/template/how-to/docs/syntek-author/x.md"
  probe_clean "this template's own how-to folder passes check 29"
  rm -r "$SA_ROOT/template/how-to/docs/syntek-author"
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["restore"]=[]; json.dump(d,open(sys.argv[1],"w"))' "$rd"
  probe "check 30 fires when family-refresh.json restores nothing" "check 30 — $FS_REFRESH_DATA lists \"restore\": []"
  cp "$tmp/v060.rd" "$rd"; python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); del d["settings"]["hooks"]["PreToolUse"]; json.dump(d,open(sys.argv[1],"w"))' "$rd"
  probe "check 30 fires when family-refresh.json does not wire the guide guard" "check 30 — $FS_REFRESH_DATA wires no settings.hooks.PreToolUse entry"
  cp "$tmp/v060.rd" "$rd"; python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d["settings"]["permissions"]["deny"].remove(sys.argv[2]); json.dump(d,open(sys.argv[1],"w"))' "$rd" "$SA_HOWTO_DENY"
  probe "check 30 fires when family-refresh.json does not offer the guide's deny" "check 30 — $FS_REFRESH_DATA does not list $SA_HOWTO_DENY under settings.permissions.deny"
  cp "$tmp/v060.rd" "$rd"; python3 - "$oc" <<'PY'
import re, sys
p = sys.argv[1]; t = open(p).read()
pat = r'\s*\{\s*"action": "edit",\s*"resource": "how-to/\*",\s*"effect": "deny"\s*\},'
assert len(re.findall(pat, t)) == 1
open(p, "w").write(re.sub(pat, "", t))
PY
  fs_py write "$SA_ROOT" ""
  probe "check 30 fires when opencode.json lacks the how-to/* edit deny" "check 30 — template/opencode.json holds 0 top-level permissions entries"
  cp "$tmp/v060.oc" "$oc"; fs_py write "$SA_ROOT" ""
}

command -v python3 >/dev/null 2>&1 || die "python3 is not installed"   # _common.sh refused an older one
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
  bold "✓ ${#FS_FILES[@]} shared file(s) and the four blocks match $FS_MANIFEST and stay template-neutral; the update entry closes _migrations, its baseline task closes _tasks, $FS_REFRESH_DATA refreshes exactly the shared working practice and how-to files and restores how-to/, the MCP files hold one set of pins, tools, keys and asks, the store is tested by equality only, no shared file or block names a path only one template ships, and how-to/ holds only the shared files and this template's own folders."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
print_findings
exit 1
