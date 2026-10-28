#!/usr/bin/env bash
#
# coexist-test.sh — Prove a second template can share a project with syntek-author.
#
#                   syntek-author is the first of a family: syntek-media is planned to sit in
#                   the SAME repositories (DESIGN.md Section 9). Two templates in one project
#                   work only if neither can overwrite the other: each keeps its own answers
#                   file, its own rules folder and its own skills, and every file both would
#                   ship — README.md, CONTEXT.md, .claude/CLAUDE.md, the settings, the
#                   .gitignore — is a seed in both, written by whichever came first and updated
#                   by neither (D17). A shared root file that one of them OWNS is a file the two
#                   fight over on every update, and the loser is whatever the author wrote.
#
#                   The test renders a project, applies a dummy second template built at
#                   runtime (its own answers file, its own rules file, its own skill, and the
#                   D17 root files as seeds), changes both templates, updates both, and checks.
#
#                   Fifty-two checks:
#                     1. The second template applies over the project without --overwrite —
#                        nothing it ships collides with what is there.
#                     2. Both answers files exist, under different names.
#                     3. syntek-author's update succeeds and delivers its change.
#                     4. The second template's update succeeds and delivers its change.
#                     5. Each template's own files survive the other's update.
#                     6. No file is owned by both: a path syntek-author renders and does not
#                        seed is never shipped by the second template, and the reverse.
#                     7. No conflict is left behind (no *.rej file, no conflict marker).
#                     8. The copy-only agent files syntek-author wrote (DESIGN.md D47, Section
#                        3.6: AGENTS.md, GEMINI.md, .codex/, .gemini/, opencode.json, the
#                        .agents/skills link and .agents/mcp_config.json) are byte for byte what
#                        it wrote, and .agents/skills still links to ../.claude/skills, after
#                        the second template's copy and both updates. The dummy ships the same
#                        paths copy-only, with its own bridge beside syntek-author's. That
#                        follows syntek-media: its D73 makes AGENTS.md, GEMINI.md, .agents and
#                        the .codex/ files copy-only, and its 0.4.2 (D76) replaces the .agents
#                        link with the real .agents/ folder holding the skills link and
#                        mcp_config.json; media does not yet ship .gemini/ or opencode.json.
#                        DESIGN.md D54 exempts the MCP servers either template's script adds
#                        once; here that exemption never applies: syntek-author wrote its
#                        servers first and this dummy (media 0.4.x) runs no MCP lane, so the
#                        files must not change at all. Two lanes meeting is checks 18–20.
#                     9. The other order, as a project that took syntek-media 0.4.x first: the
#                        dummy's real .agents/ (skills link, the 23-byte mcp_config.json that
#                        declares no server, its render recorded) is there before syntek-author's
#                        copy, which then succeeds with no --exclude and leaves .agents a real
#                        folder, .agents/skills the link to ../.claude/skills, mcp_config.json
#                        exactly the shared bytes (the copy's baseline gives the unedited file
#                        the two servers, D54), and both bridges.
#                    10. The family-shared contract (DESIGN.md D48), in that media-first
#                        project: the dummy vendors every token-free source family-shared.json
#                        lists, as a sibling template would, so each such file in the project
#                        (the permissions script under both templates' names) carries the
#                        manifest's sha256, and each listed link its target, whichever template
#                        wrote it. Skipped, by name, when the repository has no
#                        family-shared.json.
#                    11. Each template keeps its own render record (DESIGN.md D52), in both
#                        orders: after both copies the project holds refs/syntek-author/template
#                        and refs/dummy-media/template, and after both updates each template's
#                        refs/<template>/yours as well. The dummy runs the same family-shared
#                        migrations/family-update.py, block and task, with its own
#                        family-refresh.json, as a sibling template does.
#                    12. The shared working practice (D51) across templates: syntek-author's
#                        update refreshes a shared skill both copies wrote, and the dummy's later
#                        update, whose own release changed that file differently, leaves
#                        syntek-author's bytes and reports the file under "NOT UPDATED because
#                        the file holds syntek-author's version" (the sibling attribution).
#                    13. Each report is its own: every path syntek-author's report lists is in
#                        its own render record, every path the dummy's lists in the dummy's, and
#                        neither lists a conflict or a rejected hunk the other template's update
#                        left (there are none in this flow).
#
#                   A sibling at the D48 set only (syntek-media 0.5.0: the agent files, none of
#                   the D51 shared working practice, no family-update.py), in both orders,
#                   which then adopts the shared set in a later release (syntek-media 0.6.0):
#                    14. syntek-author's update beside it succeeds, prints one report, refreshes
#                        the shared skill, keeps only syntek-author's refs, and wires each hook
#                        of family-refresh.json exactly once (and holds each top-level value it
#                        lists, autoCompactEnabled and idleCompaction, once, with that value).
#                    15. Sibling first: syntek-author's copy over the sibling's own
#                        settings.json (tab-indented, no hooks, no top-level value of ours)
#                        wires each hook exactly once, adds each top-level value
#                        family-refresh.json lists (autoCompactEnabled and idleCompaction, both
#                        false) once, and keeps the sibling's lines as they were.
#                    16. The sibling's later update to its release with the shared set (whose
#                        family-refresh.json and seed carry the same top-level values too)
#                        succeeds, records refs/dummy-media/template and yours, leaves no
#                        conflict, wires no hook twice, writes no key twice and leaves the shared
#                        skill's bytes as they were.
#                    17. The sibling's own MEDIA-*.md mode file beside a shared skill arrives,
#                        and is neither in syntek-author's record nor in either report.
#
#                   A sibling at this release, as syntek-media 0.5.0 and later ship (DESIGN.md
#                   D50, D53, D54, Section 9 rules 3, 5 and 6): its answers file has the peer's
#                   name (.copier-answers.syntek-media.yml, copier.yml's _external_data.peer),
#                   it carries the data-root questions of the family-shared block read from its
#                   own answers and syntek-author's, the resolver under its own name, a map of
#                   its own (media/src, fixed to the videos kind), the marked rules-web-tools
#                   block in its own rules file, the MCP lane, and the MCP files and settings.json
#                   a render of syntek-author holds (the same shared bytes, rendered with the
#                   same answers). In a business project, both orders, each first copy with a
#                   layout of its own (DATA_AREA, DATA_SLUG and a kind folder):
#                    18. Each MCP server appears exactly once in every MCP file present (.mcp.json,
#                        .agents/mcp_config.json and the client files) where either template's
#                        recorded render declares it, at most once elsewhere, after both copies
#                        and both updates, and no conflict marker or .rej file is left.
#                    19. The second template's copy, and every update after it, prints nothing
#                        about the MCP servers: the first template delivered them.
#                    20. A sibling whose render holds code-review-graph at an older pin, copied
#                        first: syntek-author's copy keeps that pin in every MCP file, and its
#                        line attributes the value to the sibling ('<file> holds syntek-media's
#                        version of the "code-review-graph" MCP server').
#                    21. Both rules files' marked rules-web-tools block (DESIGN.md D48, D54):
#                        each marker once, BEGIN first, and the lines strictly between them carry
#                        the sha256 family-shared.json records for the block. Skipped, by name,
#                        while the manifest records no rules-web-tools block.
#                    22. The second template's first answers equal the first's: DATA_STORE,
#                        DATA_AREA, DATA_SLUG and the four kind folders (the peer default).
#                    23. A second template's first DATA_SLUG that differs from the first's is
#                        refused: the copy exits non-zero with 'One project, one layout' and
#                        writes no answers file.
#                    24. A later store change by one template (syntek-author's update with
#                        --data DATA_STORE=repo) succeeds and its after-update message reports
#                        the difference ('One project keeps one store'); the other's update to
#                        the same store then succeeds, and the data commands work again: no
#                        deadlock.
#                    25. While the two records hold different stores, both resolvers' data
#                        commands (path) exit 2.
#                    26. Beside a sibling record without DATA_STORE (media 0.4.x, 'not yet
#                        asked'), syntek-author's resolver's store and path exit 0, each with
#                        exactly one warning line and no refusal.
#                    27. A sibling record from before the data root, then a fresh syntek-author
#                        copy with --defaults: it records DATA_STORE repo and no layout answer.
#                    28. Both resolvers are the same bytes (and, where family-shared.json lists
#                        the resolver, carry its sha256).
#                    29. Both resolvers print the same root report and the same path for a file
#                        in each template's filing folder: a .pdf under media/src lands in the
#                        videos kind the sibling's map fixes, and a .png under library/src in the
#                        docs kind syntek-author's map fixes, so each reads both maps.
#                    30. A DATA_PROVIDER difference never refuses (D53): the sibling's copy with
#                        another provider succeeds, and syntek-author's resolver's path exits 0
#                        with a 'differ on DATA_PROVIDER' warning.
#
#                   The manifest role rules with both maps present (DESIGN.md D50, as syntek-media
#                   asked in its B0.4 reply): the sibling's map defines three roles of its own,
#                   all evidence (take and approved-master marked "repo": "skip", brand-export
#                   committed under repo, as media's reply sets them), and marks media/src/renders,
#                   inside its media/src, "rows": "none" (working output). Each case runs on a
#                   scratch copy of a project above, with a data root of its own:
#                    31. The sibling map's own roles are roles to both resolvers: syntek-author's
#                        files a copy under each (exit 0), each row recording evidence = true,
#                        and both verify then pass; add --force on each, by either resolver,
#                        exits 2 ('file a new version under its own name'), the manifest and
#                        every filed copy under the data root byte for byte unchanged.
#                    32. A role the two maps define differently (syntek-author's map, as a later
#                        release might ship it, defines brand-export as not evidence) is treated
#                        as evidence: the filed row records evidence = true and add --force on
#                        it exits 2; both resolvers' status report the difference once, saying
#                        evidence wins, and exit 0.
#                    33. A sibling map the resolvers cannot read refuses only the commands that
#                        touch its folders. At format 2: path into media/src exits 2 from both,
#                        while syntek-author's add of a library/src file exits 0 and verify of
#                        'library/*' exits 0 from both; a whole verify leaves media/src alone
#                        (every refusal line names it), verifies the library row and exits 2.
#                        Unparseable (its folders unknown): the same add, and a whole verify by
#                        either resolver, exit 0, each with one warning naming the map.
#                    34. Under repo, a sibling role marked "repo": "skip" (take): add by either
#                        resolver exits 0 with one 'not filed:' line and writes nothing in the
#                        project or the data root; a role without it (brand-export) exits 2,
#                        'commit the file instead'.
#                    35. The sibling's media/src/renders ("rows": "none") is never listed by
#                        either resolver's status or verify: an ignored binary in it and a file
#                        under its place at the data root go unnamed, while the same two in
#                        media/src (the controls) are named; add refuses to file there (exit 2).
#                    36. A sibling map that defines a role under a shared role's name (signed) or
#                        a kind's (videos) cannot be read: path into media/src exits 2 from both
#                        resolvers, naming the role, while path into syntek-author's library/src
#                        exits 0.
#
#                   The user guide shared by both (DESIGN.md D56): the sibling ships the shared
#                   how-to files byte for byte, its own files under how-to/docs/<sibling>/,
#                   how-to/src/TEMPLATE-GUIDE/<sibling>/ and how-to/workflows/<sibling>/,
#                   "restore": ["how-to"] in its refresh data, and the guide's deny and guard in
#                   its seed; a later release of it revises a shared chapter, and the next takes
#                   the shared bytes again.
#                    37. In both orders, each shared how-to file is there, holds the manifest's
#                        bytes and no conflict, and every how-to file each template renders is
#                        there, after both copies (and, author first, both updates).
#                    38. The sibling copied first with its own revision of
#                        updating-and-recovery.md: syntek-author's copy and its update to a
#                        release that changes nothing there keep it, listed under LEFT AS IT IS
#                        with 'it holds dummy-media's version', never written over while it
#                        stands unchanged (D56, as softened on 23/10/2026); after the
#                        sibling's update to the shared bytes, syntek-author's next report lists
#                        nothing for it.
#                    39. The crossing: syntek-author copied before the guide, the sibling's
#                        revision beside it, then syntek-author's update into the release that
#                        adds the guide lists the file as holding dummy-media's version, and
#                        never under 'new in this version'.
#                    40. make lint SCOPE=how-to/src STRICT=1 and make flags SCOPE=how-to/src
#                        STRICT=1 exit 0 over both templates' chapters, and make lint without a
#                        SCOPE never reads them (a line holding two sentences planted in the
#                        sibling's chapter is silent).
#                    41. The owner's committed edit to how-to/CONTEXT.md is restored by
#                        syntek-author's update and listed under RESTORED; the sibling's next
#                        update lists nothing for it (it holds the bytes both ship); the owner's
#                        edit in the sibling's how-to folder is untouched by syntek-author's
#                        update; the guide guard is wired once after both copies and updates.
#                    42. A plain clone (38 without refs/dummy-media/template, as git clone
#                        gives): syntek-author's update leaves the sibling's revision and says
#                        'this clone holds no record of dummy-media'; after the sibling's next
#                        update here records it, syntek-author's update leaves it as the
#                        sibling's.
#
#                   One project, one set of agent clients and models (DESIGN.md D47, Section 9
#                   rule 7; syntek-media's point, accepted 24/10/2026). The peer dummy vendors
#                   this tree's whole family-shared questions block and copier.yml's per-client
#                   gates, so it reads syntek-author's recorded client and model answers as
#                   syntek-author reads its. Each case is a business project of its own:
#                    43. syntek-author copied with AGENT_CLIENTS [codex] and an invented
#                        CODEX_MODEL; the dummy copied after it with --defaults records the
#                        same two answers, and the project holds none of GEMINI.md, .gemini/,
#                        opencode.json and .agents/mcp_config.json.
#                    44. The other order: the dummy copied first with AGENT_CLIENTS [opencode],
#                        OPENCODE_PROVIDER ollama, an address that is not ollama's default, an
#                        invented OPENCODE_MODEL and OPENCODE_CONTEXT 8192; syntek-author copied
#                        after it with --defaults records those five, and every agent answer as
#                        the dummy recorded it, the project holds none of .codex/, GEMINI.md,
#                        .gemini/ and .agents/mcp_config.json, and syntek-author's rules 05
#                        model table names the model.
#                    45. A sibling record holding values this release does not offer
#                        (AGENT_CLIENTS [codex, a-future-client], OPENCODE_PROVIDER
#                        a-future-provider) is filtered, never fed to choices: syntek-author's
#                        copy with --defaults succeeds and records AGENT_CLIENTS [codex] and no
#                        OpenCode answer (hidden).
#                    46. The update that first asks AGENT_CLIENTS, beside a sibling that records
#                        clients (a copy of 44's project whose syntek-author record has lost the
#                        seven agent answers, as a record from before them), records the
#                        sibling's clients and models, not none.
#                    47. A provider changed on the second copy inherits none of the sibling's
#                        OpenCode answers: beside a sibling record at ollama with an address, a
#                        model and a context of its own, syntek-author's copy with
#                        OPENCODE_PROVIDER vllm and no model stops with 'Name the model', and
#                        with a model of its own records vllm's own address and context.
#                    48. The template's own record comes first: a copy with --overwrite and no
#                        -a (as a re-adoption runs it) over 43's project, whose sibling record
#                        now holds another client list and another CODEX_MODEL, keeps
#                        syntek-author's own [codex] and model.
#                    49. An empty list is the sibling's choice of none: beside a sibling record
#                        holding AGENT_CLIENTS [], syntek-author's copy with --defaults records
#                        [] and the project holds none of AGENTS.md, GEMINI.md, .agents,
#                        .codex/, .gemini/ and opencode.json.
#                    50. GEMINI_MODEL reads the sibling's record too: in 47's copy, beside a
#                        sibling record that also holds gemini-cli and an invented
#                        GEMINI_MODEL, syntek-author records that model.
#
#                   Lessons in learning/ with two templates (DESIGN.md D57): each template's
#                   teaching skill keeps its own topics there, in a folder named for it while
#                   another template's answers file stands at the root, and only syntek-author
#                   ships the folder's pair. After the first copy, in both orders, three lessons
#                   are planted and committed where the teaching skills would write them: one at
#                   the top of learning/ with no Template: line (learning/old-topic/), one in
#                   syntek-author's folder (learning/syntek-author/a-topic/) and one in the
#                   sibling's (learning/dummy-media/m-topic/):
#                    51. Each lesson is byte for byte as planted after both copies (and, author
#                        first, both updates), nothing under learning/ holds a conflict marker or
#                        a .rej, and no report of either template lists a path under learning/.
#                    52. learning/CONTEXT.md and learning/CLAUDE.md hold the bytes
#                        refs/syntek-author/template holds for them, and
#                        refs/dummy-media/template holds no path under learning/. Skipped, by
#                        name, where the template ships no learning/ pair or the repository has
#                        no migrations/family-update.py (no render record).
#                   Checks 25, 26 and 29–36 run the resolver, which needs Python at
#                   _common.sh's SA_PYTHON_MIN or later (its pin refuses an older python3); on
#                   a python3 without tomllib they are skipped, by name. Every resolver run gets
#                   a temporary data root holding its own marker; no audit reads a machine's
#                   root (D50).
#
#                   Numbers are stable identifiers. Append, never renumber.
#
#                   What it CANNOT check: the real syntek-media. The dummies follow Section 9's
#                   rules and media 0.4.2's .agents/ layout; family-shared.sh --sibling compares
#                   a real syntek-media checkout's vendored sources. The sibling's map is a
#                   stand-in written from media's B0.4 reply (its roles, their evidence and
#                   "repo": "skip", a renders/ working-output folder), not media's shipped map.
#                   It never copies syntek-author at v0.4.0 beside a fresh sibling (check 27 runs
#                   the other way round, which exercises syntek-author's own copier.yml), and it
#                   never syncs a data root. Check 39's release before the guide is the working
#                   tree with how-to/ and its refresh lines taken out, not the v0.5.0 tag.
#                   Check 46's record from before the clients is this release's with the seven
#                   answers taken out, not a copy from the v0.3.0 tag (update-test.sh's checks
#                   31–34 update from that tag, with no sibling). The sibling records of checks
#                   45, 47, 49 and 50 are written by hand, and check 48's is the dummy's with
#                   its agent answers rewritten, not records a real sibling's copy wrote. Nor
#                   what a teaching skill does at run time (D57): checks 51 and 52 plant the
#                   lessons by hand where the skills would write them, and prove only that no
#                   copy or update touches them.
#
# SELF-TEST. --self-test runs the whole flow with a fixture syntek-author, proves it clean, then
#            mutates the result once per check and asserts exactly one finding each.
#
# Requirements: bash 4+, git, rsync, uvx (or COPIER_CMD). Network on the first uvx run only.
#
# Usage: coexist-test.sh [--root DIR] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = the two templates share the project cleanly
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, no copier.yml)

set -euo pipefail
SCRIPT_NAME="coexist-test.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

SELF_TEST=false

usage() {
  cat <<'EOF'
coexist-test.sh — Prove a second template can share a project with syntek-author

Usage: coexist-test.sh [--root DIR] [--quiet] [--self-test] [--help]

  --root DIR   The template repository (default: this repository)
  --quiet      Print findings only
  --self-test  Prove the checks still fire against a fixture template
  --help       Show this message

Exit codes: 0 = coexist cleanly  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

B_ANSWERS=".copier-answers.dummy-media.yml"
B_RULE=".claude/rules/dummy-media/01-media.md"
A_MARK="<!-- coexist-test: syntek-author change -->"
B_MARK="<!-- coexist-test: dummy-media change -->"
SHARED_ROOT="README.md CONTEXT.md .gitignore .mcp.json .claude/CLAUDE.md .claude/CONTEXT.md .claude/MEMORY.md .claude/settings.json .claude/skills/CONTEXT.md .claude/skills/CLAUDE.md .claude/hooks/CONTEXT.md .claude/hooks/CLAUDE.md"
B_BRIDGE=".claude/dummy-media-agents.md"
B_MODE="MEDIA-BUSINESS.md"   # the sibling's own mode file beside each shared skill (its names are MEDIA-*)
SH_MARK_A="<!-- coexist-test: syntek-author's next revision of a shared file -->"
SH_MARK_B="<!-- coexist-test: dummy-media's own next revision of a shared file -->"
SH_FILE=""; A_LOG=""; B_LOG=""; SH_A_SUM=""; B_FIRST=""
# syntek-media 0.4.x's MCP files (DESIGN.md D54): no server anywhere, and no .gemini/ or
# opencode.json of its own.
MEDIA04_MCP_JSON='{"mcpServers": {}}'$'\n'
MEDIA04_CODEX=$'# Project instructions: use the canonical folder manual where AGENTS.md is absent.\nproject_doc_fallback_filenames = [\'CLAUDE.md\']\n'
# The rules-web-tools markers (DESIGN.md D48, D54), read from family-shared.json where it records
# the block; these are the frozen lines (handoff contract K4).
RWT_BEGIN='<!-- BEGIN family-shared rules: web and code tools -->'
RWT_END='<!-- END family-shared rules: web and code tools -->'

PROJ=""; A_RULE=""; A_COPY=0; B_COPY=0; A_UPDATE=0; B_UPDATE=0
A_OWNED=(); A_ALL=(); B_OWNED=(); B_ALL=()
declare -A A_KEPT=()
MF=""; MF_B_COPY=0; MF_A_COPY=0; MANIFEST=""; MF_RAN=false
NOTES=()

# The family-shared files a sibling template vendors into its template/: every token-free file
# family-shared.json lists with the project scope, at its destination path ("<template>" filled
# with $3), and every listed link. A "repository" entry sits at the template repository's root
# and never reaches a project. Prints
# "F<TAB>path<TAB>sha256<TAB>source" and "L<TAB>path<TAB>target" lines.
manifest_entries() { # $1 = syntek-author repo, $2 = manifest, $3 = template name
  python3 - "$1" "$2" "$3" <<'PY'
import hashlib, json, sys
root, man, name = sys.argv[1], sys.argv[2], sys.argv[3]
for f in json.load(open(man, encoding="utf-8")).get("files", []):
    if f.get("scope", "project") != "project":
        continue  # a template-repository file (the migration script): never in a project
    path = f["path"].replace("<template>", name)
    if f.get("kind") == "symlink":
        print(f"L\t{path}\t{f['target']}"); continue
    data = open(f"{root}/{f['source']}", "rb").read()
    if any(d in data for d in (b"<%", b"<:", b"<~")):
        continue  # rendered from answers: identical only for identical answers
    print(f"F\t{path}\t{f['sha256']}\t{f['source']}")
PY
}

# The data-root questions of the family-shared block (DESIGN.md D50, D53): DATA_STORE to the
# block's end. They read only data-root keys, _external_data, _folder_name and UNSET, so they
# need none of the block's agent questions.
dataroot_questions() { # $1 = copier.yml
  awk '/^DATA_STORE:/ { on = 1 } /^# END family-shared questions/ { on = 0 } on { print }' "$1"
}

# The whole family-shared questions block (DESIGN.md D48), its marker lines included, as a
# sibling vendors it: the agent questions read the other template's record too (checks 43–50).
# Where copier.yml holds no block, the data-root questions alone.
Q_BEGIN='# BEGIN family-shared questions (D48)'
Q_END='# END family-shared questions (D48)'
shared_questions() { # $1 = copier.yml
  if grep -qxF "$Q_BEGIN" "$1" && grep -qxF "$Q_END" "$1"; then
    awk -v b="$Q_BEGIN" -v e="$Q_END" '$0 == b { on = 1 } on { print } $0 == e { on = 0 }' "$1"
  else
    dataroot_questions "$1"
  fi
}

# copier.yml's per-client _exclude lines (DESIGN.md D47, Section 3.5): each client's files ship
# only when AGENT_CLIENTS names it.
client_gates() { # $1 = copier.yml
  grep -E '^  - "<: if not \(.*AGENT_CLIENTS.*\) :>/' "$1" || true
}

# A rules file's marked rules-web-tools block, the marker lines included.
rwt_block() { # $1 = rules file
  awk -v b="$RWT_BEGIN" -v e="$RWT_END" '$0 == b { on = 1 } on { print } $0 == e { on = 0 }' "$1"
}

# The second template, as DESIGN.md Section 9 requires one to be written, with syntek-media
# 0.4.2's .agents/ layout, vendoring the family-shared sources when $2 has a manifest.
# $3 = the mode:
#   (none)  a sibling with the shared set (D51, D52): a MEDIA-*.md mode file of its own beside
#           each shared skill and the shared hooks wired in its settings, in syntek-media
#           0.4.x's MCP state (D54): no server in .mcp.json or .agents/mcp_config.json (the 23
#           bytes) or .codex/config.toml, and no MCP lane.
#   d48     a sibling at the D48 set only (syntek-media 0.5.0's agent files): none of the shared
#           working practice (D51), no family-update.py, no block and no task, and a
#           settings.json of its own (tab-indented, no hooks).
#   peer    a sibling at this release (D47, D50, D53, D54): the shared set, the whole questions
#           block read from its own answers and syntek-author's (_external_data.peer), the
#           per-client gates of syntek-author's copier.yml, the resolver under its own name and
#           a map of its own, the marked rules-web-tools block, the MCP lane, and the five MCP
#           files and settings.json of the render $5.
# $4 = its name (default dummy-media): the answers file, rules folder, bridge and refs follow it;
# a syntek-<name> template fills a manifest path's <template> with <name> alone.
build_dummy() { # $1 = dir, $2 = the syntek-author repo it vendors from, $3 = mode, $4 = name, $5 = render
  local b="$1" src="${2:-}" mode="${3:-}" n="${4:-dummy-media}" ref="${5:-}" s kind path sum source shared="" refresh="" f
  local short="${n#syntek-}" answers=".copier-answers.${4:-dummy-media}.yml" rule=".claude/rules/${n}/01-media.md"
  mkdir -p "$b/template/.claude/rules/$n" "$b/template/.claude/skills/$n-clip" "$b/template/media" "$b/migrations"
  # The shared working practice the sibling ships too (D51): what syntek-author refreshes.
  if [[ -n "$src" && -f "$src/migrations/family-refresh.json" ]]; then
    refresh="$(python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1]))["refresh"]))' "$src/migrations/family-refresh.json")"
    [[ "$mode" == d48 ]] || shared="$refresh"
  fi
  {
    cat <<'EOF'
_min_copier_version: "9.6.0"
_subdirectory: template
EOF
    printf '_answers_file: %s\n' "$answers"
    if [[ "$mode" == peer ]]; then
      printf '_external_data:\n  prev: %s\n  peer: %s\n' "$answers" "$SA_ANSWERS_FILE"
    fi
    cat <<'EOF'
_templates_suffix: ""
_envops:
  variable_start_string: "<%"
  variable_end_string: "%>"
  block_start_string: "<:"
  block_end_string: ":>"
  comment_start_string: "<~"
  comment_end_string: "~>"
  keep_trailing_newline: true
_skip_if_exists:
EOF
    for s in $SHARED_ROOT $SA_COPY_ONLY $shared; do printf '  - /%s\n' "$s"; done
    printf '_preserve_symlinks: true\n_exclude:\n  - .git\n'
    for s in $SA_COPY_ONLY $SA_COPY_ONLY_DIRS $shared; do printf '  - "<: if %s :>/%s<: endif :>"\n' "$SA_COPY_ONLY_GATE" "$s"; done
    if [[ "$mode" == peer && -n "$src" ]]; then client_gates "$src/copier.yml"; fi
    printf 'PROJECT_NAME:\n  type: str\n'
    if [[ "$mode" == peer && -n "$src" ]]; then shared_questions "$src/copier.yml"; fi
    # The family-shared update script, its block and its task, as a sibling carries them (D52).
    if [[ "$mode" != d48 && -n "$src" && -f "$src/migrations/family-update.py" ]] && grep -qF "$SA_UPD_END" "$src/copier.yml"; then
      printf '_migrations:\n'
      awk -v b="$SA_UPD_BEGIN" -v e="$SA_UPD_END" '$0 == b { on = 1 } on { print } $0 == e { on = 0 }' "$src/copier.yml"
      printf '_tasks:\n  - command: "[ -d .git ] || git init --initial-branch=main"\n    when: "<%% _copier_operation == %s %%>"\n' "'copy'"
      grep -A1 -F 'migrations/family-update.py" baseline' "$src/copier.yml"
    fi
  } > "$b/copier.yml"
  if [[ "$mode" != d48 && -n "$src" && -f "$src/migrations/family-update.py" ]]; then
    cp "$src/migrations/family-update.py" "$b/migrations/family-update.py"
    # Its own refresh list and the shared hooks' settings entries, as a sibling carries them; at
    # this release (peer), the MCP servers too (D54).
    python3 - "$b/migrations/family-refresh.json" "$shared" "$src/migrations/family-refresh.json" "$n" "$mode" <<'PY'
import json, sys
src = json.load(open(sys.argv[3], encoding="utf-8"))
want = src.get("settings") or {}
top = {k: v for k, v in want.items() if k not in ("hooks", "permissions")}
data = {"format": 1, "template": sys.argv[4], "refresh": sys.argv[2].split(),
        "settings": {**top, "hooks": want.get("hooks") or {}, "permissions": {"deny": [], "ask": []}}}
if sys.argv[5] == "peer" and src.get("mcp"):
    data["mcp"] = src["mcp"]
# The user guide (D56): a sibling that ships the shared how-to files restores how-to/ too.
if src.get("restore") and any(p.startswith("how-to/") for p in data["refresh"]):
    data["restore"] = src["restore"]
json.dump(data, open(sys.argv[1], "w", encoding="utf-8"), indent=2)
PY
  fi
  printf '<%% _copier_answers|to_nice_yaml -%%>\n' > "$b/template/$answers"
  printf '# 01 — media\n\nTemplate-owned by %s.\n' "$n" > "$b/template/$rule"
  printf -- '---\nname: %s-clip\ndescription: Clip a recording.\n---\n' "$n" > "$b/template/.claude/skills/$n-clip/SKILL.md"
  printf '# CONTEXT.md — media/\n' > "$b/template/media/CONTEXT.md"
  printf '@./CONTEXT.md\n\n# CLAUDE.md — media/\n' > "$b/template/media/CLAUDE.md"
  for s in $SHARED_ROOT $SA_COPY_ONLY; do
    [[ "$s" == .agents/skills ]] && continue
    mkdir -p "$(dirname "$b/template/$s")"; printf '# seeded by %s\n' "$n" > "$b/template/$s"
  done
  ln -s "$SA_AGENTS_LINK_TARGET" "$b/template/.agents/skills"
  # Its settings.json seed is JSON of its own: tab-indented; the G sibling wires the shared hooks.
  python3 - "$b/template/.claude/settings.json" "$src/migrations/family-refresh.json" "$mode" "$SA_HOWTO_DENY" <<'PY'
import json, os, sys
d = {"model": "sonnet"}
if sys.argv[3] != "d48" and os.path.isfile(sys.argv[2]):
    src = json.load(open(sys.argv[2], encoding="utf-8"))
    want = src.get("settings") or {}
    d.update({k: v for k, v in want.items() if k not in ("hooks", "permissions")})
    if want.get("hooks"):
        d["hooks"] = want["hooks"]
    # The guide's deny (D56), where the sibling ships the shared how-to files.
    if any(p.startswith("how-to/") for p in src.get("refresh", [])):
        d["permissions"] = {"deny": [sys.argv[4]]}
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent="\t") + "\n")
PY
  # Media's own mode files beside each shared skill (MEDIA-BUSINESS.md and its kind).
  for s in $shared; do
    [[ "$s" == */SKILL.md ]] || continue
    mkdir -p "$b/template/$(dirname "$s")"
    printf '# Mode: media business

Template-owned by %s.
' "$n" > "$b/template/$(dirname "$s")/$B_MODE"
  done
  printf '%s' "$SA_MEDIA04_AGENTS_MCP" > "$b/template/.agents/mcp_config.json"
  printf '# %s bridge\n\nTemplate-owned by %s.\n' "$n" "$n" > "$b/template/.claude/$n-agents.md"
  if [[ -n "$src" && -f "$src/family-shared.json" ]]; then
    while IFS=$'\t' read -r kind path sum source; do
      # syntek-media 0.4.x's MCP files are its own, never the shared bytes (D54).
      [[ -z "$mode" && ( "$path" == .mcp.json || "$path" == .agents/mcp_config.json ) ]] && continue
      [[ "$mode" == d48 && " $refresh " == *" $path "* ]] && continue
      mkdir -p "$(dirname "$b/template/$path")"
      if [[ "$kind" == L ]]; then rm -rf "${b:?}/template/$path"; ln -s "$sum" "$b/template/$path"
      else cp "$src/$source" "$b/template/$path"; fi
    done < <(manifest_entries "$src" "$src/family-shared.json" "$short")
  fi
  if [[ -z "$mode" ]]; then
    printf '%s' "$MEDIA04_MCP_JSON" > "$b/template/.mcp.json"
    printf '%s' "$MEDIA04_CODEX" > "$b/template/.codex/config.toml"
  fi
  if [[ "$mode" == peer ]]; then
    # The resolver under its own name, the same bytes (D50), and a map of its own: one filing
    # folder, whose fixed kind tells which map a resolver read, a working-output folder inside it,
    # and the three roles of media's B0.4 reply, all evidence (checks 31–36).
    [[ -f "$src/template/$SA_DATAROOT_PY" ]] && cp "$src/template/$SA_DATAROOT_PY" "$b/template/.claude/syntek-$short-dataroot.py"
    peer_map > "$b/template/.claude/syntek-$short-dataroot.json"
    mkdir -p "$b/template/$PEER_RENDERS"
    printf '# CONTEXT.md — media/src/\n' > "$b/template/media/src/CONTEXT.md"
    printf '@./CONTEXT.md\n\n# CLAUDE.md — media/src/\n' > "$b/template/media/src/CLAUDE.md"
    printf '# CONTEXT.md — %s/ (working output: re-rendered, never filed)\n' "$PEER_RENDERS" > "$b/template/$PEER_RENDERS/CONTEXT.md"
    printf '@./CONTEXT.md\n\n# CLAUDE.md — %s/\n' "$PEER_RENDERS" > "$b/template/$PEER_RENDERS/CLAUDE.md"
    # The rules-web-tools block in its own rules file, under a heading of its own numbering.
    if [[ -f "$src/template/.claude/rules/syntek-author/06-global-rules.md" ]]; then
      { printf '# 06 — global rules\n\n## 9. Web and code tools\n\n'
        rwt_block "$src/template/.claude/rules/syntek-author/06-global-rules.md"; } > "$b/template/.claude/rules/$n/06-global-rules.md"
    fi
    # The MCP files and settings.json, as a sibling renders the same shared bytes with the same
    # answers: a file that render lacks, the sibling ships none of either.
    for f in $SA_MCP_FILES .claude/settings.json; do
      if [[ -f "$ref/$f" ]]; then cp "$ref/$f" "$b/template/$f"; else rm -f "$b/template/$f"; fi
    done
  fi
  # The user guide (D56): the sibling's own how-to files, under folders named for it.
  if [[ "$mode" != d48 && " $shared " == *" how-to/"* ]]; then howto_own "$b/template" "$n"; fi
  sa_git "$b" init -q && sa_git "$b" add -A && sa_git "$b" commit -q -m "$n"
}

owned_and_all() { # $1 = rendered dir, $2 = copier.yml, $3 = answers file → "O path" / "A path"
  local f s seed
  local -a skips=()
  while IFS= read -r s; do [[ -n "$s" ]] && skips+=("${s#/}"); done < <(yaml_list _skip_if_exists "$2")
  while IFS= read -r -d '' f; do
    f="${f#./}"
    [[ "$f" == "$3" ]] && continue
    echo "A $f"
    seed=false
    for s in "${skips[@]}"; do
      # shellcheck disable=SC2053  # _skip_if_exists entries may be globs
      [[ "$f" == $s ]] && { seed=true; break; }
    done
    $seed || echo "O $f"
  done < <(cd "$1" && find . -name .git -prune -o -type f -print0)
}

run_flow() { # $1 = syntek-author repo, $2 = work dir
  local w="$2" a="$2/a" b="$2/b" log="$2/flow.log" kind path
  PROJ="$w/proj"; A_COPY=0; B_COPY=0; A_UPDATE=0; B_UPDATE=0
  A_OWNED=(); A_ALL=(); B_OWNED=(); B_ALL=()
  sa_snapshot "$1" "$a" >>"$log" 2>&1 || die "could not snapshot $1"
  A_FIRST="$(git -C "$a" rev-parse HEAD)"   # syntek-author before its change: where the D48 flows copy
  build_dummy "$b" "$a" >>"$log" 2>&1
  B_FIRST="$(git -C "$b" rev-parse HEAD)"   # the dummy's first release, which the media-first copy takes
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init

  sa_render "$a" "$PROJ" theology >>"$log" 2>&1 || A_COPY=$?
  [[ "$A_COPY" -eq 0 ]] || return 0
  [[ -d "$PROJ/.git" ]] || sa_git "$PROJ" init -q
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'syntek-author' >>"$log" 2>&1
  while read -r kind path; do
    if [[ "$kind" == O ]]; then A_OWNED+=("$path"); else A_ALL+=("$path"); fi
  done < <(owned_and_all "$PROJ" "$a/copier.yml" "$SA_ANSWERS_FILE")
  A_KEPT=()
  for path in $SA_COPY_ONLY; do
    if [[ -L "$PROJ/$path" ]]; then A_KEPT["$path"]="link:$(readlink "$PROJ/$path")"
    elif [[ -f "$PROJ/$path" ]]; then A_KEPT["$path"]="$(sha256sum < "$PROJ/$path")"; fi
  done
  # The lessons of checks 51–52, after the first copy (D57).
  ln_plant "$PROJ"

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$w/b-alone" </dev/null >>"$log" 2>&1 || true
  while read -r kind path; do
    if [[ "$kind" == O ]]; then B_OWNED+=("$path"); else B_ALL+=("$path"); fi
  done < <(owned_and_all "$w/b-alone" "$b/copier.yml" "$B_ANSWERS")

  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$PROJ" </dev/null >>"$log" 2>&1 || B_COPY=$?
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'dummy-media' >>"$log" 2>&1 || true

  A_RULE=".claude/skills/run-workflow/SKILL.md"
  [[ -f "$a/template/$A_RULE" ]] || A_RULE=".claude/rules/syntek-author/01-layout-and-routing.md"
  [[ -f "$a/template/$A_RULE" ]] || die "the template has neither run-workflow/SKILL.md nor the layout rule — nothing template-owned to update"
  printf '\n%s\n' "$A_MARK" >> "$a/template/$A_RULE"
  # A shared skill both templates ship: each template's next release changes it its own way
  # (version skew), so the dummy's update meets syntek-author's newer bytes (check 12).
  SH_FILE=""
  if [[ -f "$a/migrations/family-refresh.json" ]]; then
    SH_FILE="$(python3 -c 'import json,sys; print(next((p for p in json.load(open(sys.argv[1]))["refresh"] if p.endswith("SKILL.md")), ""))' "$a/migrations/family-refresh.json")"
  fi
  if [[ -n "$SH_FILE" && -f "$a/template/$SH_FILE" && -f "$b/template/$SH_FILE" ]]; then
    printf '\n%s\n' "$SH_MARK_A" >> "$a/template/$SH_FILE"; printf '\n%s\n' "$SH_MARK_B" >> "$b/template/$SH_FILE"
  else
    SH_FILE=""
  fi
  sa_git "$a" add -A && sa_git "$a" commit -q -m change >>"$log" 2>&1
  printf '\n%s\n' "$B_MARK" >> "$b/template/$B_RULE"; sa_git "$b" add -A && sa_git "$b" commit -q -m change >>"$log" 2>&1

  A_LOG="$w/a-update.log"; B_LOG="$w/b-update.log"
  sa_update "$PROJ" >"$A_LOG" 2>&1 || A_UPDATE=$?
  cat "$A_LOG" >>"$log"
  SH_A_SUM=""; [[ -n "$SH_FILE" ]] && SH_A_SUM="$(sha256sum < "$PROJ/$SH_FILE")"
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'update syntek-author' >>"$log" 2>&1 || true
  (cd "$PROJ" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$B_ANSWERS" </dev/null) >"$B_LOG" 2>&1 || B_UPDATE=$?
  cat "$B_LOG" >>"$log"

  # The other order: the dummy (syntek-media 0.4.2's layout) first, then syntek-author, with no
  # --exclude.
  MF="$w/media-first"; MF_B_COPY=0; MF_A_COPY=0; MF_RAN=true
  MANIFEST=""; [[ -f "$a/family-shared.json" ]] && MANIFEST="$a/family-shared.json"
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$B_FIRST" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$MF" </dev/null >>"$log" 2>&1 || MF_B_COPY=$?
  [[ -d "$MF/.git" ]] || sa_git "$MF" init -q
  sa_git "$MF" add -A && sa_git "$MF" commit -q -m 'dummy-media first' >>"$log" 2>&1 || true
  ln_plant "$MF"   # the lessons of checks 51–52, after the first copy (D57)
  MF_A_LOG="$w/mf-a-copy.log"
  sa_render "$a" "$MF" theology >"$MF_A_LOG" 2>&1 || MF_A_COPY=$?
  cat "$MF_A_LOG" >>"$log"
  MF_SRC="$a"

  # A sibling at the D48 set only, in both orders, which later adopts the shared set.
  run_d48_flow "$a" "$w"
  # A sibling at this release, whose answers file has the peer's name (D50, D53, D54).
  run_peer_flow "$a" "$w"
  # The user guide shared by both (D56).
  run_howto_lint "$PROJ" "$w"
  run_howto_flow "$a" "$b" "$w"
}

run_checks() {
  FINDINGS=()
  local p f
  local -A a_owned=() a_all=() b_owned=() b_all=()
  if [[ "$A_COPY" -ne 0 ]]; then finding "check 1 — syntek-author itself did not render (exit $A_COPY)"; return 0; fi
  [[ "$B_COPY" -eq 0 ]] || finding "check 1 — the second template could not apply over the project without --overwrite (exit $B_COPY) — something it ships collides"
  if [[ ! -f "$PROJ/$SA_ANSWERS_FILE" || ! -f "$PROJ/$B_ANSWERS" ]]; then
    finding "check 2 — the project does not hold both $SA_ANSWERS_FILE and $B_ANSWERS"
  fi
  # A file that vanished is check 5's; 3 and 4 judge delivery to a file that is there.
  if [[ "$A_UPDATE" -ne 0 ]]; then finding "check 3 — syntek-author's update failed (exit $A_UPDATE)"
  elif [[ -f "$PROJ/$A_RULE" ]] && ! grep -qF "$A_MARK" "$PROJ/$A_RULE"; then finding "check 3 — syntek-author's change did not reach $A_RULE"; fi
  if [[ "$B_UPDATE" -ne 0 ]]; then finding "check 4 — the second template's update failed (exit $B_UPDATE)"
  elif [[ -f "$PROJ/$B_RULE" ]] && ! grep -qF "$B_MARK" "$PROJ/$B_RULE"; then finding "check 4 — the second template's change did not reach $B_RULE"; fi
  [[ -f "$PROJ/$A_RULE" ]] || finding "check 5 — syntek-author's $A_RULE did not survive the second template's update"
  [[ -f "$PROJ/$B_RULE" ]] || finding "check 5 — the second template's $B_RULE did not survive syntek-author's update"
  for p in "${A_OWNED[@]}"; do a_owned["$p"]=1; done
  for p in "${A_ALL[@]}";   do a_all["$p"]=1; done
  for p in "${B_OWNED[@]}"; do b_owned["$p"]=1; done
  for p in "${B_ALL[@]}";   do b_all["$p"]=1; done
  for p in "${!a_owned[@]}"; do
    [[ -n "${b_all[$p]:-}" ]] && finding "check 6 — $p is template-owned by syntek-author and shipped by the second template — seed it in both (DESIGN.md D17)"
  done
  for p in "${!b_owned[@]}"; do
    [[ -n "${a_all[$p]:-}" ]] && finding "check 6 — $p is template-owned by the second template and shipped by syntek-author"
  done
  while IFS= read -r f; do
    finding "check 7 — conflict left behind: ${f#"$PROJ"/}"
  done < <( { find "$PROJ" -name .git -prune -o -name '*.rej' -print; \
              grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$PROJ" 2>/dev/null; } | sort -u || true)
  local now
  for p in "${!A_KEPT[@]}"; do
    now=""
    if [[ -L "$PROJ/$p" ]]; then now="link:$(readlink "$PROJ/$p")"
    elif [[ -f "$PROJ/$p" ]]; then now="$(sha256sum < "$PROJ/$p")"; fi
    [[ "$now" == "${A_KEPT[$p]}" ]] || finding "check 8 — the copy-only $p syntek-author wrote did not survive the second template and both updates unchanged"
  done
  [[ -z "${A_KEPT[.agents/skills]:-}" || "${A_KEPT[.agents/skills]}" == "link:$SA_AGENTS_LINK_TARGET" ]] \
    || finding "check 8 — syntek-author's .agents/skills links to ${A_KEPT[.agents/skills]#link:}, not $SA_AGENTS_LINK_TARGET"
  $MF_RAN && media_first_checks
  report_checks
  $D48_RAN && d48_checks
  $PEER_RAN && peer_checks
  howto_checks
  ln_checks
  return 0
}

# The paths one report lists, from the last report for $2 in a log.
report_paths() { # $1 = log, $2 = template name
  python3 - "$1" "$2" <<'PY'
import re, sys
lines = open(sys.argv[1], encoding="utf-8", errors="replace").read().splitlines()
starts = [i for i, l in enumerate(lines) if l.startswith(f"▸ {sys.argv[2]} update report")]
cur = None
for l in (lines[starts[-1]:] if starts else []):
    if re.match(r"  [A-Z]{2}", l):
        cur = l.strip()
    elif re.match(r"    \S", l) and cur and not l.strip().startswith("…"):
        print(cur + "\t" + l.strip())
    elif l and not l.startswith((" ", "▸")):
        break
PY
}

report_checks() {
  local r t log p sec
  [[ "$A_COPY" -eq 0 && "$B_COPY" -eq 0 ]] || return 0
  [[ -f "$MF_SRC/migrations/family-update.py" ]] || { NOTES+=("checks 11–13 skipped — the repository has no migrations/family-update.py"); return 0; }
  for r in refs/syntek-author/template refs/dummy-media/template refs/syntek-author/yours refs/dummy-media/yours; do
    git -C "$PROJ" rev-parse -q --verify "$r" >/dev/null 2>&1 || finding "check 11 — after both copies and both updates the project has no $r — each template keeps its own render record"
  done
  if [[ "$MF_A_COPY" -eq 0 && "$MF_B_COPY" -eq 0 ]]; then
    for r in refs/syntek-author/template refs/dummy-media/template; do
      git -C "$MF" rev-parse -q --verify "$r" >/dev/null 2>&1 || finding "check 11 — media first: after both copies the project has no $r"
    done
  fi
  [[ -n "$SH_FILE" ]] || NOTES+=("check 12 skipped — no shared SKILL.md that both templates ship")
  if [[ -n "$SH_FILE" && "$A_UPDATE" -eq 0 && "$B_UPDATE" -eq 0 ]]; then
    if ! grep -qF "$SH_MARK_A" "$PROJ/$SH_FILE" 2>/dev/null || [[ "$(sha256sum < "$PROJ/$SH_FILE")" != "$SH_A_SUM" ]]; then
      finding "check 12 — the shared $SH_FILE does not hold syntek-author's refreshed revision after both updates — the dummy's update overwrote or merged it, or syntek-author's never refreshed it"
    fi
    sec="$(report_paths "$B_LOG" dummy-media | awk -F'\t' -v p="$SH_FILE" '$2 == p { print $1; exit }')"
    [[ "$sec" == "NOT UPDATED because the file holds syntek-author's version"* ]] \
      || finding "check 12 — the dummy's report lists $SH_FILE under '${sec:-nothing}', not as holding syntek-author's version"
  fi
  for t in syntek-author dummy-media; do
    log="$A_LOG"; [[ "$t" == dummy-media ]] && log="$B_LOG"
    while IFS=$'\t' read -r sec p; do
      [[ -z "$p" ]] && continue
      case "$sec" in CONFLICT*|REJECTED*) finding "check 13 — $t's report lists a conflict ($p) in an update that left none of its own" ;; esac
      git -C "$PROJ" cat-file -e "refs/$t/template:$p" 2>/dev/null || git -C "$PROJ" cat-file -e "refs/$t/template^:$p" 2>/dev/null \
        || finding "check 13 — $t's report lists $p, which $t does not render — a report holds only its own template's files"
    done < <(report_paths "$log" "$t")
  done
  return 0
}

# ── A sibling at the D48 set only, then adopting the shared working practice (checks 14–17) ──

# Judges a project's settings.json against syntek-author's family-refresh.json: prints "ok", or
# each hook entry that is not wired exactly once, and each top-level value it lists
# (autoCompactEnabled, idleCompaction) that the file's text does not hold exactly once with that
# value (a key written twice parses silently to the last). $3 = tabs: the file must still be
# the sibling's own, tab-indented with its own first key.
hooks_once() { # $1 = settings.json, $2 = family-refresh.json, $3 = tabs (optional)
  python3 - "$1" "$2" "${3:-}" <<'PY'
import json, re, sys
path, data, keep = sys.argv[1:]
try:
    text = open(path, encoding="utf-8").read()
    st = json.loads(text)
except (OSError, ValueError) as e:
    print(f"settings.json unreadable ({e})"); sys.exit(0)
settings = json.load(open(data, encoding="utf-8")).get("settings") or {}
want = settings.get("hooks") or {}
scripts = lambda e: set(re.findall(r"\.claude/hooks/([A-Za-z0-9._-]+)", json.dumps(e.get("hooks"))))
bad = []
for event, entries in want.items():
    for w in entries:
        n = sum(1 for e in (st.get("hooks") or {}).get(event) or []
                if e.get("matcher", "") == w.get("matcher", "") and scripts(w) <= scripts(e))
        if n != 1:
            bad.append(f"{event} {w.get('matcher', '')} {','.join(sorted(scripts(w)))} wired {n} time(s)")
for key, value in settings.items():
    if key in ("hooks", "permissions") or isinstance(value, (dict, list)) or value is None:
        continue
    n = len(re.findall(r'"%s"\s*:' % re.escape(key), text))
    if n != 1 or json.dumps(st.get(key)) != json.dumps(value):
        bad.append(f"{key} written {n} time(s), value {json.dumps(st.get(key))}, not {json.dumps(value)} once")
if keep == "tabs" and (any(l.startswith(" ") for l in text.splitlines()) or list(st)[:1] != ["model"]):
    bad.append("the sibling's tab indentation or key order was not kept")
print("; ".join(bad) or "ok")
PY
}
conflicts_in() { # $1 = project → its .rej files and conflict markers, space-separated
  { find "$1" -name .git -prune -o -name '*.rej' -print; grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$1" 2>/dev/null; } \
    | sort -u | sed "s|^$1/||" | paste -sd' ' - || true
}

D48_RAN=false; A_FIRST=""
declare -A D48=()
run_d48_flow() { # $1 = syntek-author snapshot (with A_FIRST and its change), $2 = work dir
  local a="$1" w="$2/d48" log="$2/d48-flow.log" b="$2/d48/dummy" order p sum
  D48=(); D48_RAN=true
  [[ -f "$a/migrations/family-update.py" ]] || { D48_RAN=false; NOTES+=("checks 14–17 skipped — the repository has no migrations/family-update.py"); return 0; }
  mkdir -p "$w"
  build_dummy "$b" "$a" d48 >>"$log" 2>&1
  local first; first="$(git -C "$b" rev-parse HEAD)"
  # The sibling's later release adopts the shared working practice: the same bytes, its own
  # family-update.py, block, task, refresh list and MEDIA-* mode files.
  build_dummy "$w/dummy-g" "$a" >>"$log" 2>&1
  rsync -a --delete --exclude .git "$w/dummy-g/" "$b/" >>"$log" 2>&1
  sa_git "$b" add -A && sa_git "$b" commit -q -m 'dummy-media adopts the shared working practice' >>"$log" 2>&1
  for order in author-first d48-first; do
    p="$w/$order"
    if [[ "$order" == author-first ]]; then
      a_copy_at "$a" "$A_FIRST" "$p" >>"$log" 2>&1 || D48[$order.a_copy]=$?
      [[ -d "$p/.git" ]] || sa_git "$p" init -q
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'syntek-author' >>"$log" 2>&1 || true
      "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$first" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$p" </dev/null >>"$log" 2>&1 || D48[$order.b_copy]=$?
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'dummy-media at D48' >>"$log" 2>&1 || true
    else
      "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$first" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$p" </dev/null >>"$log" 2>&1 || D48[$order.b_copy]=$?
      [[ -d "$p/.git" ]] || sa_git "$p" init -q
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'dummy-media at D48' >>"$log" 2>&1 || true
      a_copy_at "$a" "$A_FIRST" "$p" >>"$log" 2>&1 || D48[$order.a_copy]=$?
      D48[$order.copied]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json" tabs)"
      sa_git "$p" add -A && sa_git "$p" commit -q -m 'syntek-author' >>"$log" 2>&1 || true
    fi
    sa_update "$p" >"$w/$order-a.log" 2>&1 || D48[$order.a_update]=$?
    cat "$w/$order-a.log" >>"$log"
    D48[$order.a_report]="$(grep -c '^▸ syntek-author update report' "$w/$order-a.log" || true)"
    D48[$order.a_refreshed]=true
    [[ -z "$SH_FILE" ]] || grep -qF "$SH_MARK_A" "$p/$SH_FILE" 2>/dev/null || D48[$order.a_refreshed]=false
    D48[$order.a_refs]="$(git -C "$p" for-each-ref --format='%(refname)' 'refs/syntek-author/' 'refs/dummy-media/' | paste -sd' ' -)"
    D48[$order.a_hooks]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json")"
    sa_git "$p" add -A && sa_git "$p" commit -q -m 'update syntek-author' >>"$log" 2>&1 || true
    sum="$(cd "$p" && for f in $SH_FILE; do sha256sum "$f"; done)"
    (cd "$p" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$B_ANSWERS" </dev/null) >"$w/$order-b.log" 2>&1 || D48[$order.b_update]=$?
    cat "$w/$order-b.log" >>"$log"
    D48[$order.b_refs]="$(git -C "$p" for-each-ref --format='%(refname)' 'refs/dummy-media/' | paste -sd' ' -)"
    D48[$order.b_hooks]="$(hooks_once "$p/.claude/settings.json" "$a/migrations/family-refresh.json")"
    D48[$order.b_conflicts]="$(conflicts_in "$p")"
    D48[$order.b_shared_kept]=true
    [[ "$sum" == "$(cd "$p" && for f in $SH_FILE; do sha256sum "$f"; done)" ]] || D48[$order.b_shared_kept]=false
    D48[$order.b_mode]="missing"
    if [[ -n "$SH_FILE" ]]; then
      local mode_file; mode_file="$(dirname "$SH_FILE")/$B_MODE"
      if [[ ! -f "$p/$mode_file" ]]; then D48[$order.b_mode]="missing"
      elif git -C "$p" cat-file -e "refs/syntek-author/template:$mode_file" 2>/dev/null; then D48[$order.b_mode]="in syntek-author's record"
      elif grep -qxF "    $mode_file" "$w/$order-a.log" "$w/$order-b.log"; then D48[$order.b_mode]="listed in a report"
      else D48[$order.b_mode]="ok"; fi
    else
      D48[$order.b_mode]="ok"
    fi
  done
}

a_copy_at() { # $1 = syntek-author repo, $2 = ref, $3 = dest
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$2" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=theology" \
    "$1" "$3" </dev/null
}

d48_checks() {
  local o L
  for o in author-first d48-first; do
    L="[D48-only sibling, $o]"
    if [[ "${D48[$o.a_copy]:-0}" -ne 0 || "${D48[$o.b_copy]:-0}" -ne 0 ]]; then
      finding "check 14 — $L a copy failed (syntek-author exit ${D48[$o.a_copy]:-0}, the sibling exit ${D48[$o.b_copy]:-0})"; continue
    fi
    if [[ "${D48[$o.a_update]:-0}" -ne 0 || "${D48[$o.a_report]:-0}" -ne 1 ]]; then
      finding "check 14 — $L syntek-author's update failed (exit ${D48[$o.a_update]:-0}) or printed ${D48[$o.a_report]:-0} report(s), not one"
    fi
    ${D48[$o.a_refreshed]} || finding "check 14 — $L syntek-author's update did not refresh the shared $SH_FILE"
    [[ "${D48[$o.a_refs]}" == "refs/syntek-author/template refs/syntek-author/yours" ]] \
      || finding "check 14 — $L after syntek-author's update the refs are '${D48[$o.a_refs]}', not syntek-author's two alone"
    [[ "${D48[$o.a_hooks]}" == ok ]] || finding "check 14 — $L after syntek-author's update: ${D48[$o.a_hooks]}"
    if [[ "$o" == d48-first ]]; then
      [[ "${D48[$o.copied]}" == ok ]] || finding "check 15 — $L syntek-author's copy over the sibling's settings.json: ${D48[$o.copied]}"
    fi
    [[ "${D48[$o.b_update]:-0}" -eq 0 ]] || finding "check 16 — $L the sibling's update to its release with the shared set failed (exit ${D48[$o.b_update]})"
    [[ "${D48[$o.b_refs]}" == "refs/dummy-media/template refs/dummy-media/yours" ]] \
      || finding "check 16 — $L after the sibling adopted the shared set its refs are '${D48[$o.b_refs]}'"
    [[ "${D48[$o.b_hooks]}" == ok ]] || finding "check 16 — $L after the sibling adopted the shared set: ${D48[$o.b_hooks]}"
    [[ -z "${D48[$o.b_conflicts]}" ]] || finding "check 16 — $L the sibling's update left a conflict: ${D48[$o.b_conflicts]}"
    ${D48[$o.b_shared_kept]} || finding "check 16 — $L the sibling's update changed the shared $SH_FILE"
    [[ "${D48[$o.b_mode]}" == ok ]] || finding "check 17 — $L the sibling's $B_MODE beside the shared skill is ${D48[$o.b_mode]}"
  done
  return 0
}

# ── A sibling at this release: the peer, the data root and the MCP servers (checks 18–30) ──

PEER_RAN=false; PEER_W=""; PEER_ROOT=""; PEER_REFRESH=""; PEER_MANIFEST=""; PY_DR=false
PEER_NAME="syntek-media"            # its answers file is the peer copier.yml reads (D50)
PEER_ORDERS="author-first media-first"
PEER_AREA="personal"; PEER_SLUG="lantern-road"; PEER_PHOTOS="images"; PEER_OTHER_SLUG="another-project"
PEER_PIN_OLD="code-review-graph==1.0.0"
declare -A PEER=()
# The sibling map's own roles, all evidence, as media's B0.4 reply defines them (DESIGN.md D50):
# take and approved-master are never filed under repo ("repo": "skip"); brand-export is
# committed there. Its working output (renders) is a folder that never takes rows.
PEER_ROLES="take approved-master brand-export"
PEER_SKIP_ROLE="take"; PEER_COMMIT_ROLE="brand-export"
PEER_RENDERS="media/src/renders"
PEER_MAP_FILE=".claude/syntek-${PEER_NAME#syntek-}-dataroot.json"

# The sibling's map (format 1): media/src fixed to videos, its renders/ marked "rows": "none".
peer_map() {
  cat <<EOF
{
  "format": 1,
  "folders": [
    {"path": "media/src", "kind": "videos"},
    {"path": "$PEER_RENDERS", "rows": "none"}
  ],
  "roles": [
    {"name": "take", "evidence": true, "repo": "skip"},
    {"name": "approved-master", "evidence": true, "repo": "skip"},
    {"name": "brand-export", "evidence": true}
  ]
}
EOF
}

# The first template's layout, given so that only the peer default can carry it to the second.
peer_layout_args() { printf '%s\n' --data "DATA_AREA=$PEER_AREA" --data "DATA_SLUG=$PEER_SLUG" --data "DATA_KIND_PHOTOS=$PEER_PHOTOS"; }
peer_layout_want() { printf 'external|%s|%s|docs|%s|audio|videos' "$PEER_AREA" "$PEER_SLUG" "$PEER_PHOTOS"; }

peer_copy() { # $1 = author|media, $2 = its template, $3 = dest, $4 = log, then copier arguments
  local who="$1" t="$2" d="$3" log="$4"; shift 4
  if [[ "$who" == author ]]; then sa_render "$t" "$d" business "$@" >"$log" 2>&1
  else "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref=HEAD --data "PROJECT_NAME=$SA_RENDER_NAME" "$@" "$t" "$d" </dev/null >"$log" 2>&1; fi
}
peer_update() { # $1 = author|media, $2 = project, $3 = log, then copier arguments
  local who="$1" p="$2" log="$3"; shift 3
  if [[ "$who" == author ]]; then sa_update "$p" "$@" >"$log" 2>&1
  else (cd "$p" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$SA_PEER_ANSWERS_FILE" "$@" </dev/null) >"$log" 2>&1; fi
}
commit_all() { # $1 = project, $2 = message
  [[ -d "$1/.git" ]] || sa_git "$1" init -q
  { sa_git "$1" add -A && sa_git "$1" commit -q -m "$2"; } >/dev/null 2>&1 || true
}
# One resolver run, with the temporary root and its marker (no audit reads a machine's root).
dr_run() { # $1 = project, $2 = author|media (whose resolver), $3 = output prefix, then its arguments
  local p="$1" t="$2" o="$3"; shift 3
  (cd "$p" && SYNTEK_DATA_ROOT="$PEER_ROOT" python3 ".claude/syntek-$t-dataroot.py" "$@") >"$o.out" 2>"$o.err"
}
# "exit warnings refusals not-yet-asked": a run judged by its stderr lines.
dr_judge() { # $1 = exit status, $2 = output prefix
  printf '%s %s %s %s' "$1" "$(grep -c '^warning:' "$2.err" || true)" "$(grep -c '^refused:' "$2.err" || true)" \
    "$(grep -c 'not yet asked' "$2.err" || true)"
}
layout_of() { # $1 = answers file → "store|area|slug|docs|photos|audio|videos"
  local k out=""
  for k in DATA_STORE DATA_AREA DATA_SLUG DATA_KIND_DOCS DATA_KIND_PHOTOS DATA_KIND_AUDIO DATA_KIND_VIDEOS; do
    out+="$(answer_value "$k" "$1")|"
  done
  printf '%s' "${out%|}"
}

# Each MCP server in each MCP file a project holds (DESIGN.md D54): "ok", or each departure. A
# server either template's recorded render declares in a file must be there exactly once; any
# other at most once. A JSON key written twice is counted (the parse keeps the last silently); a
# TOML table declared twice does not parse, and is named.
mcp_once() { # $1 = project, $2 = family-refresh.json, $3 = the template names whose records count
  python3 - "$1" "$2" "$3" <<'PY'
import json, subprocess, sys
proj, data, names = sys.argv[1], sys.argv[2], sys.argv[3].split()
import tomllib
mcp = json.load(open(data, encoding="utf-8")).get("mcp") or {}
servers, files = mcp.get("servers") or [], mcp.get("files") or {}
def tree(text, path):
    if path.endswith(".toml"):
        return tomllib.loads(text)
    return json.loads(text, object_pairs_hook=lambda pairs: ("pairs", pairs))
def count(node, keys, server):
    for k in keys:
        if isinstance(node, tuple):
            node = next((v for kk, v in reversed(node[1]) if kk == k), None)
        elif isinstance(node, dict):
            node = node.get(k)
        else:
            return 0
    if isinstance(node, tuple):
        return sum(1 for kk, _ in node[1] if kk == server)
    return 1 if isinstance(node, dict) and server in node else 0
bad = []
for path, keys in sorted(files.items()):
    try:
        text = open(f"{proj}/{path}", encoding="utf-8").read()
    except FileNotFoundError:
        continue
    try:
        here = tree(text, path)
    except ValueError as e:
        bad.append(f"{path} does not parse ({str(e).splitlines()[0]})"); continue
    declared = set()
    for n in names:
        r = subprocess.run(["git", "-C", proj, "show", f"refs/{n}/template:{path}"], capture_output=True, text=True)
        if r.returncode == 0:
            try:
                rec = tree(r.stdout, path)
            except ValueError:
                continue
            declared |= {s for s in servers if count(rec, keys, s) >= 1}
    for s in servers:
        c = count(here, keys, s)
        if c > 1 or (s in declared and c != 1):
            bad.append(f"{path} declares {s} {c} time(s), not once")
print("; ".join(bad) or "ok")
PY
}

# A rules file's marked block: "sha256 <hex>" over the lines strictly between the markers, as
# family-shared.sh hashes a block, or what is wrong with its markers.
block_state() { # $1 = rules file, $2 = begin, $3 = end
  python3 - "$1" "$2" "$3" <<'PY'
import hashlib, sys
path, b, e = sys.argv[1:]
try:
    lines = open(path, encoding="utf-8").read().splitlines()
except OSError:
    print("missing"); sys.exit()
if lines.count(b) != 1 or lines.count(e) != 1:
    print("its markers are not each there once"); sys.exit()
i, j = lines.index(b), lines.index(e)
if j < i:
    print("its END marker comes before its BEGIN marker"); sys.exit()
print("sha256 " + hashlib.sha256("".join(l + "\n" for l in lines[i + 1:j]).encode()).hexdigest())
PY
}
manifest_block() { # $1 = manifest, $2 = block name → "sha256<TAB>begin<TAB>end", or nothing
  python3 - "$1" "$2" <<'PY'
import json, sys
for b in json.load(open(sys.argv[1], encoding="utf-8")).get("blocks", []):
    if b.get("name") == sys.argv[2]:
        print(f"{b.get('sha256', '')}\t{b.get('begin', '')}\t{b.get('end', '')}")
PY
}
manifest_file_sha() { # $1 = manifest, $2 = path as it lists it → its sha256, or nothing
  python3 -c 'import json, sys; print(next((f.get("sha256", "") for f in json.load(open(sys.argv[1], encoding="utf-8")).get("files", []) if f.get("path") == sys.argv[2]), ""))' "$1" "$2"
}

# The second template's first DATA_SLUG, another than the first's: refused (check 23).
peer_refused() { # $1 = author|media (who copies second), $2 = its template, $3 = project, $4 = order
  local who="$1" t="$2" o="$4" scratch="$PEER_W/$4-slug" rc=0 ans="$SA_PEER_ANSWERS_FILE"
  [[ "$who" == author ]] && ans="$SA_ANSWERS_FILE"
  rm -rf "$scratch"; cp -a "$3" "$scratch"
  peer_copy "$who" "$t" "$scratch" "$scratch.log" --data "DATA_SLUG=$PEER_OTHER_SLUG" || rc=$?
  PEER[$o.refused]=$rc; PEER[$o.refused_msg]=false; PEER[$o.refused_wrote]=false
  grep -qF 'One project, one layout' "$scratch.log" && PEER[$o.refused_msg]=true
  [[ -e "$scratch/$ans" ]] && PEER[$o.refused_wrote]=true
  return 0
}

# After both copies: both records' layouts, and both resolvers' root report and paths.
peer_probe() { # $1 = order
  local o="$1" p="$PEER_W/$1" t rc
  PEER[$o.layout_author]="$(layout_of "$p/$SA_ANSWERS_FILE")"
  PEER[$o.layout_media]="$(layout_of "$p/$SA_PEER_ANSWERS_FILE")"
  $PY_DR || return 0
  for t in author media; do
    rc=0; dr_run "$p" "$t" "$PEER_W/$o-$t-root" root || rc=$?
    PEER[$o.root_$t]="$rc $(cat "$PEER_W/$o-$t-root.out")"
    rc=0; dr_run "$p" "$t" "$PEER_W/$o-$t-pm" path media/src/cue-sheet.pdf || rc=$?
    PEER[$o.pm_$t]="$rc $(cat "$PEER_W/$o-$t-pm.out")"
    rc=0; dr_run "$p" "$t" "$PEER_W/$o-$t-pl" path library/src/logo.png || rc=$?
    PEER[$o.pl_$t]="$rc $(cat "$PEER_W/$o-$t-pl.out")"
  done
  PEER[$o.provider_warn]="$(grep -c 'differ on DATA_PROVIDER' "$PEER_W/$o-author-pm.err" || true)"
  return 0
}

run_peer_flow() { # $1 = syntek-author snapshot, $2 = work dir
  local a="$1" w="$2/peer" log="$2/peer-flow.log" b="$2/peer/media" p rc f
  local -a layout pins
  PEER=(); PEER_RAN=true; PEER_W="$w"
  if ! grep -q '^DATA_STORE:' "$a/copier.yml" || [[ ! -f "$a/template/$SA_DATAROOT_PY" ]]; then
    PEER_RAN=false; NOTES+=("checks 18–30 skipped — copier.yml asks no DATA_STORE, or the template ships no $SA_DATAROOT_PY"); return 0
  fi
  PY_DR=false; python3 -c 'import tomllib' 2>/dev/null && PY_DR=true
  $PY_DR || NOTES+=("checks 25, 26 and 29–36 skipped — python3 has no tomllib: the resolver needs Python $SA_PYTHON_MIN or later, with its standard library whole")
  PEER_REFRESH="$a/migrations/family-refresh.json"
  PEER_MANIFEST=""; [[ -f "$a/family-shared.json" ]] && PEER_MANIFEST="$a/family-shared.json"
  if [[ -z "$PEER_MANIFEST" || -z "$(manifest_block "$PEER_MANIFEST" rules-web-tools)" ]]; then
    NOTES+=("check 21 skipped — family-shared.json records no rules-web-tools block (family-shared.sh --write writes it)")
  fi
  mkdir -p "$w/dataroot"; : > "$w/dataroot/$SA_DATAROOT_MARKER"; PEER_ROOT="$(cd "$w/dataroot" && pwd -P)"
  mapfile -t layout < <(peer_layout_args)
  read -r -a pins <<< "$SA_MCP_PINS"

  # syntek-author first, with a layout of its own; the sibling renders the same shared bytes
  # with the same answers, so its MCP files and settings.json are that render's.
  p="$w/author-first"
  peer_copy author "$a" "$p" "$w/author-first-1-copy.log" "${layout[@]}" || PEER[author-first.first_copy]=$?
  commit_all "$p" 'syntek-author'
  build_dummy "$b" "$a" peer "$PEER_NAME" "$p" >>"$log" 2>&1
  peer_refused media "$b" "$p" author-first
  # Another provider (D53): a difference is reported, never refused.
  peer_copy media "$b" "$p" "$w/author-first-2-copy.log" --data DATA_PROVIDER=dropbox || PEER[author-first.second_copy]=$?
  commit_all "$p" "$PEER_NAME"
  peer_probe author-first
  # A later store change by one, then the other's: reported, refused meanwhile, never a deadlock.
  peer_update author "$p" "$w/author-first-1-update.log" --data DATA_STORE=repo || PEER[store.a_update]=$?
  PEER[store.line]=false; grep -qF 'One project keeps one store' "$w/author-first-1-update.log" && PEER[store.line]=true
  commit_all "$p" 'syntek-author: DATA_STORE repo'
  if $PY_DR; then
    rc=0; dr_run "$p" author "$w/store-a" path library/src/scan.pdf || rc=$?; PEER[store.refuse_author]=$rc
    rc=0; dr_run "$p" media "$w/store-b" path library/src/scan.pdf || rc=$?; PEER[store.refuse_media]=$rc
  fi
  peer_update media "$p" "$w/author-first-2-update.log" --data DATA_STORE=repo || PEER[store.b_update]=$?
  commit_all "$p" "$PEER_NAME: DATA_STORE repo"
  if $PY_DR; then rc=0; dr_run "$p" author "$w/store-c" path library/src/scan.pdf || rc=$?; PEER[store.agree]=$rc; fi
  PEER[author-first.logs]="$w/author-first-2-copy.log $w/author-first-1-update.log $w/author-first-2-update.log"

  # The sibling first, with a layout of its own.
  p="$w/media-first"
  peer_copy media "$b" "$p" "$w/media-first-1-copy.log" "${layout[@]}" || PEER[media-first.first_copy]=$?
  commit_all "$p" "$PEER_NAME"
  peer_refused author "$a" "$p" media-first
  peer_copy author "$a" "$p" "$w/media-first-2-copy.log" || PEER[media-first.second_copy]=$?
  commit_all "$p" 'syntek-author'
  peer_probe media-first
  peer_update author "$p" "$w/media-first-1-update.log" || PEER[media-first.a_update]=$?
  commit_all "$p" 'update syntek-author'
  peer_update media "$p" "$w/media-first-2-update.log" || PEER[media-first.b_update]=$?
  commit_all "$p" "update $PEER_NAME"
  PEER[media-first.logs]="$w/media-first-2-copy.log $w/media-first-1-update.log $w/media-first-2-update.log"

  # The sibling's render holds code-review-graph at an older pin, and comes first.
  rsync -a --delete "$b/" "$w/media-oldpin/" >>"$log" 2>&1
  PEER[oldpin.files]=""
  for f in $SA_MCP_FILES; do
    if [[ ! -f "$w/media-oldpin/template/$f" ]] || ! grep -qF "${pins[0]}" "$w/media-oldpin/template/$f"; then continue; fi
    python3 -c 'import sys; p, a, b = sys.argv[1:]; s = open(p, encoding="utf-8").read(); open(p, "w", encoding="utf-8").write(s.replace(a, b))' \
      "$w/media-oldpin/template/$f" "${pins[0]}" "$PEER_PIN_OLD"
    PEER[oldpin.files]+="$f "
  done
  sa_git "$w/media-oldpin" add -A && sa_git "$w/media-oldpin" commit -q -m 'an older pin' >>"$log" 2>&1 || true
  peer_copy media "$w/media-oldpin" "$w/oldpin" "$w/oldpin-1-copy.log" || PEER[oldpin.first_copy]=$?
  commit_all "$w/oldpin" "$PEER_NAME"
  peer_copy author "$a" "$w/oldpin" "$w/oldpin-2-copy.log" || PEER[oldpin.second_copy]=$?

  # A sibling from before the data root (syntek-media 0.4.x: its record holds no DATA_STORE).
  build_dummy "$w/media04" "$a" d48 "$PEER_NAME" >>"$log" 2>&1
  peer_copy media "$w/media04" "$w/pre" "$w/pre-1-copy.log" || PEER[pre.first_copy]=$?
  commit_all "$w/pre" "$PEER_NAME 0.4.x"
  rm -rf "$w/pre-external"; cp -a "$w/pre" "$w/pre-external"
  peer_copy author "$a" "$w/pre" "$w/pre-2-copy.log" || PEER[pre.second_copy]=$?
  peer_copy author "$a" "$w/pre-external" "$w/pre-3-copy.log" --data DATA_STORE=external || PEER[pre.external_copy]=$?
  commit_all "$w/pre-external" 'syntek-author, external'
  if $PY_DR; then
    rc=0; dr_run "$w/pre-external" author "$w/pre-store" store || rc=$?; PEER[pre.store]="$(dr_judge "$rc" "$w/pre-store")"
    rc=0; dr_run "$w/pre-external" author "$w/pre-path" path library/src/scan.pdf || rc=$?; PEER[pre.path]="$(dr_judge "$rc" "$w/pre-path")"
  fi
  # The manifest role rules with both maps present, on scratch copies of the projects above.
  run_roles_flow
  # One project, one set of agent clients and models, in projects of their own.
  run_clients_flow "$a" "$b" "$w"
  return 0
}

peer_checks() {
  local o L p f got want line rec msha rsha
  local -a pins
  read -r -a pins <<< "$SA_MCP_PINS"
  if [[ -n "$PEER_MANIFEST" ]]; then IFS=$'\t' read -r msha _ _ < <(manifest_block "$PEER_MANIFEST" rules-web-tools) || msha=""; else msha=""; fi
  rsha=""; [[ -n "$PEER_MANIFEST" ]] && rsha="$(manifest_file_sha "$PEER_MANIFEST" '.claude/syntek-<template>-dataroot.py')"
  for o in $PEER_ORDERS; do
    L="[$o]"; p="$PEER_W/$o"
    if [[ "${PEER[$o.first_copy]:-0}" -ne 0 || "${PEER[$o.second_copy]:-0}" -ne 0 ]]; then
      finding "check 22 — $L a copy failed (the first exit ${PEER[$o.first_copy]:-0}, the second exit ${PEER[$o.second_copy]:-0}): the second template must take the first's data-root answers$([[ "$o" == author-first ]] && printf ', and another DATA_PROVIDER never refuses (D53)')"
      continue
    fi
    # 18: each server once in every MCP file, no conflict, both updates through.
    got="$(mcp_once "$p" "$PEER_REFRESH" "syntek-author $PEER_NAME")"
    [[ "$got" == ok ]] || finding "check 18 — $L after both copies and both updates: $got"
    got="$(conflicts_in "$p")"
    [[ -z "$got" ]] || finding "check 18 — $L a conflict is left: $got"
    if [[ "$o" == media-first && ( "${PEER[$o.a_update]:-0}" -ne 0 || "${PEER[$o.b_update]:-0}" -ne 0 ) ]]; then
      finding "check 18 — $L an update failed (syntek-author exit ${PEER[$o.a_update]:-0}, $PEER_NAME exit ${PEER[$o.b_update]:-0})"
    fi
    # 19: the second template, and every update after it, says nothing about the servers.
    for f in ${PEER[$o.logs]}; do
      line="$(grep -m1 -F 'MCP server' "$f" 2>/dev/null || true)"
      [[ -z "$line" ]] || finding "check 19 — $L ${f##*/} speaks of the MCP servers the first template delivered: $line"
    done
    # 21: both rules files' marked block carries the manifest's hash.
    if [[ -n "$msha" ]]; then
      for f in ".claude/rules/syntek-author/06-global-rules.md" ".claude/rules/$PEER_NAME/06-global-rules.md"; do
        got="$(block_state "$p/$f" "$RWT_BEGIN" "$RWT_END")"
        [[ "$got" == "sha256 $msha" ]] || finding "check 21 — $L $f: the rules-web-tools block is not the manifest's (${got/sha256 /sha256 is })"
      done
    fi
    # 22: the second's first answers are the first's.
    want="$(peer_layout_want)"
    [[ "${PEER[$o.layout_author]}" == "$want" && "${PEER[$o.layout_media]}" == "$want" ]] \
      || finding "check 22 — $L the records hold '${PEER[$o.layout_author]}' (syntek-author) and '${PEER[$o.layout_media]}' ($PEER_NAME), not both '$want': the second template did not take the first's store, area, slug and kinds"
    # 23: another first slug is refused, and nothing is recorded.
    if [[ "${PEER[$o.refused]:-0}" -eq 0 || "${PEER[$o.refused_msg]}" != true || "${PEER[$o.refused_wrote]}" != false ]]; then
      finding "check 23 — $L the second copy with DATA_SLUG=$PEER_OTHER_SLUG exited ${PEER[$o.refused]:-0} (refusal named: ${PEER[$o.refused_msg]}, answers written: ${PEER[$o.refused_wrote]}): a first answer must equal the other template's"
    fi
    # 28: the same resolver bytes, and the manifest's where it lists the resolver.
    if ! cmp -s "$p/$SA_DATAROOT_PY" "$p/.claude/syntek-${PEER_NAME#syntek-}-dataroot.py"; then
      finding "check 28 — $L $SA_DATAROOT_PY and .claude/syntek-${PEER_NAME#syntek-}-dataroot.py are not the same bytes"
    elif [[ -n "$rsha" && "$(sha256sum < "$p/$SA_DATAROOT_PY" | cut -d' ' -f1)" != "$rsha" ]]; then
      finding "check 28 — $L both resolvers differ from the sha256 family-shared.json lists for .claude/syntek-<template>-dataroot.py"
    fi
    # 29: the same root report and paths, each reading both maps.
    if $PY_DR; then
      [[ "${PEER[$o.root_author]}" == "0 "* && "${PEER[$o.root_author]}" == "${PEER[$o.root_media]}" ]] \
        || finding "check 29 — $L the two resolvers' root reports differ, or one did not exit 0"
      want="0 $PEER_ROOT/$PEER_AREA/videos/$PEER_SLUG/media/src/cue-sheet.pdf"
      [[ "${PEER[$o.pm_author]}" == "$want" && "${PEER[$o.pm_media]}" == "$want" ]] \
        || finding "check 29 — $L path media/src/cue-sheet.pdf gives '${PEER[$o.pm_author]}' (syntek-author) and '${PEER[$o.pm_media]}' ($PEER_NAME), not '$want' from both: each must read the sibling's map, whose media/src is fixed to videos"
      want="0 $PEER_ROOT/$PEER_AREA/docs/$PEER_SLUG/library/src/logo.png"
      [[ "${PEER[$o.pl_author]}" == "$want" && "${PEER[$o.pl_media]}" == "$want" ]] \
        || finding "check 29 — $L path library/src/logo.png gives '${PEER[$o.pl_author]}' (syntek-author) and '${PEER[$o.pl_media]}' ($PEER_NAME), not '$want' from both: each must read syntek-author's map, whose library/src is fixed to docs"
    fi
  done
  # 24 and 25: a later store change, refused meanwhile, never a deadlock.
  if [[ "${PEER[author-first.first_copy]:-0}" -eq 0 && "${PEER[author-first.second_copy]:-0}" -eq 0 ]]; then
    if [[ "${PEER[store.a_update]:-0}" -ne 0 || "${PEER[store.line]}" != true ]]; then
      finding "check 24 — syntek-author's update with --data DATA_STORE=repo beside a sibling at external exited ${PEER[store.a_update]:-0} without the after-update line 'One project keeps one store'"
    elif [[ "${PEER[store.b_update]:-0}" -ne 0 ]] || { $PY_DR && [[ "${PEER[store.agree]:-1}" -ne 0 ]]; }; then
      finding "check 24 — the sibling's update to the same store exited ${PEER[store.b_update]:-0}, and path then exited ${PEER[store.agree]:-unrun}: a later store change must never deadlock"
    fi
    if $PY_DR && [[ "${PEER[store.refuse_author]:-0}" -ne 2 || "${PEER[store.refuse_media]:-0}" -ne 2 ]]; then
      finding "check 25 — while the records hold repo and external, path exited ${PEER[store.refuse_author]:-0} (syntek-author's resolver) and ${PEER[store.refuse_media]:-0} ($PEER_NAME's), not 2 from both"
    fi
  fi
  # 26 and 27: a sibling record from before the data root.
  if [[ "${PEER[pre.first_copy]:-0}" -ne 0 || "${PEER[pre.second_copy]:-0}" -ne 0 || "${PEER[pre.external_copy]:-0}" -ne 0 ]]; then
    finding "check 27 — beside a sibling record without DATA_STORE a copy failed ($PEER_NAME exit ${PEER[pre.first_copy]:-0}, syntek-author exit ${PEER[pre.second_copy]:-0}, with external ${PEER[pre.external_copy]:-0})"
  else
    got="$(answer_value DATA_STORE "$PEER_W/pre/$SA_ANSWERS_FILE")"; rec="$(answer_value DATA_AREA "$PEER_W/pre/$SA_ANSWERS_FILE")"
    [[ -z "$rec" ]] || rec=" and DATA_AREA '$rec'"
    [[ "$got" == repo && -z "$rec" ]] \
      || finding "check 27 — a fresh copy beside a sibling record from before the data root recorded DATA_STORE '$got'$rec, not repo alone"
    if $PY_DR; then
      [[ "${PEER[pre.store]}" == "0 1 0 1" && "${PEER[pre.path]}" == "0 1 0 1" ]] \
        || finding "check 26 — beside a sibling record without DATA_STORE, store and path gave 'exit warnings refusals not-yet-asked' of '${PEER[pre.store]}' and '${PEER[pre.path]}', not '0 1 0 1' each"
    fi
  fi
  # 20: a sibling's older pin is kept and attributed to it.
  if [[ "${PEER[oldpin.first_copy]:-0}" -ne 0 || "${PEER[oldpin.second_copy]:-0}" -ne 0 ]]; then
    finding "check 20 — over a sibling with an older pin a copy failed ($PEER_NAME exit ${PEER[oldpin.first_copy]:-0}, syntek-author exit ${PEER[oldpin.second_copy]:-0})"
  elif [[ -z "${PEER[oldpin.files]}" ]]; then
    finding "check 20 — no MCP file of the sibling declares ${pins[0]}, so no older pin could be planted"
  else
    for f in ${PEER[oldpin.files]}; do
      if ! grep -qF "$PEER_PIN_OLD" "$PEER_W/oldpin/$f" 2>/dev/null || grep -qF "${pins[0]}" "$PEER_W/oldpin/$f" 2>/dev/null; then
        finding "check 20 — $f no longer holds the sibling's $PEER_PIN_OLD alone after syntek-author's copy: a sibling's older pin is kept"
      elif ! grep -qF "$f holds $PEER_NAME's version of the \"code-review-graph\" MCP server" "$PEER_W/oldpin-2-copy.log"; then
        finding "check 20 — syntek-author's copy did not attribute $f's code-review-graph to $PEER_NAME"
      fi
    done
  fi
  # 30: a provider difference warns and never refuses (D53).
  if $PY_DR && [[ "${PEER[author-first.second_copy]:-0}" -eq 0 && "${PEER[author-first.first_copy]:-0}" -eq 0 ]]; then
    [[ "${PEER[author-first.pm_author]}" == "0 "* && "${PEER[author-first.provider_warn]:-0}" -ge 1 ]] \
      || finding "check 30 — with DATA_PROVIDER none beside dropbox, path exited '${PEER[author-first.pm_author]%% *}' with ${PEER[author-first.provider_warn]:-0} 'differ on DATA_PROVIDER' warning(s): a provider difference warns and never refuses"
  fi
  roles_checks
  clients_checks
  return 0
}

# ── The manifest role rules with both maps present (checks 31–36) ──────────────────────────

PEER_BAD_NAMES="signed:shared videos:kind"   # a map role under a shared role's name, and a kind's
RP=""; RR=""

# A scratch copy of a peer project with a data root of its own, so one case's filing never
# reaches another's: sets RP (the project) and RR (the root, holding its marker).
roles_project() { # $1 = the project to copy, $2 = the case's name
  RP="$PEER_W/roles/$2"; RR="$PEER_W/roles/$2-root"
  rm -rf "$RP" "$RR"; mkdir -p "$RR"; cp -a "$1" "$RP"; : > "$RR/$SA_DATAROOT_MARKER"
  RR="$(cd "$RR" && pwd -P)"
}
# One resolver run in that copy, with its root; its output goes to roles/<prefix>.out and .err.
rr_run() { # $1 = author|media (whose resolver), $2 = output prefix, then its arguments
  local t="$1" o="$PEER_W/roles/$2"; shift 2
  (cd "$RP" && SYNTEK_DATA_ROOT="$RR" python3 ".claude/syntek-$t-dataroot.py" "$@") >"$o.out" 2>"$o.err"
}
# How many lines of one run (stdout and stderr) match an extended regular expression.
rr_count() { # $1 = output prefix, $2 = regex
  cat "$PEER_W/roles/$1.out" "$PEER_W/roles/$1.err" 2>/dev/null | grep -cE -e "$2" || true
}
# One change to a map in a scratch copy: format2, unparseable, or <name>:<true|false> (a role
# added with that evidence).
map_set() { # $1 = map file, $2 = the change
  python3 - "$1" "$2" <<'PY'
import json, sys
path, what = sys.argv[1:]
if what == "unparseable":
    open(path, "w", encoding="utf-8").write('{"format": 1, "folders": [\n')
    sys.exit()
d = json.load(open(path, encoding="utf-8"))
if what == "format2":
    d["format"] = 2
else:
    name, evidence = what.split(":")
    d.setdefault("roles", []).append({"name": name, "evidence": evidence == "true"})
open(path, "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
}
# "<path> <role> <evidence>;" for each row of a manifest, in order; "none" without one.
rows_evidence() { # $1 = manifest
  python3 - "$1" <<'PY'
import sys, tomllib
try:
    rows = tomllib.load(open(sys.argv[1], "rb")).get("file", [])
except (OSError, tomllib.TOMLDecodeError):
    rows = []
print("".join(f"{r.get('path')} {r.get('role')} {str(r.get('evidence', 'absent')).lower()};" for r in rows) or "none")
PY
}
# One sha256 over every file below the folders, paths and bytes (.git apart): nothing moved.
tree_sum() { # $1… = folders
  local d
  for d in "$@"; do
    if [[ -d "$d" ]]; then (cd "$d" && find . -name .git -prune -o -type f -print0 | LC_ALL=C sort -z | xargs -0 -r sha256sum)
    else printf 'no %s\n' "$d"; fi
  done | sha256sum | cut -d' ' -f1
}
file_sum() { if [[ -f "$1" ]]; then sha256sum < "$1" | cut -d' ' -f1; else printf 'none'; fi; }

# Checks 31–36, on scratch copies of the media-first project (external, both maps) and of the
# author-first one (both records at repo after checks 24 and 25).
run_roles_flow() {
  local base="$PEER_W/media-first" r who verb n what rc before m
  PEER[roles.ext]=false; PEER[roles.repo]=false
  $PY_DR || return 0
  mkdir -p "$PEER_W/roles"
  if [[ "${PEER[media-first.first_copy]:-0}" -eq 0 && "${PEER[media-first.second_copy]:-0}" -eq 0 && -f "$base/$PEER_MAP_FILE" ]]; then
    PEER[roles.ext]=true
  fi
  if [[ "${PEER[store.agree]:-1}" -eq 0 && "$(answer_value DATA_STORE "$PEER_W/author-first/$SA_ANSWERS_FILE")" == repo \
        && "$(answer_value DATA_STORE "$PEER_W/author-first/$SA_PEER_ANSWERS_FILE")" == repo ]]; then
    PEER[roles.repo]=true
  fi
  [[ "${PEER[roles.ext]}" == true ]] || NOTES+=("checks 31–33, 35 and 36 skipped — the media-first peer project did not copy (check 22 says why)")
  [[ "${PEER[roles.repo]}" == true ]] || NOTES+=("check 34 skipped — the author-first peer project did not reach DATA_STORE repo in both records (check 24 says why)")
  if [[ "${PEER[roles.ext]}" == true ]]; then
    # 31: the sibling map's own roles, filed and verified by both; add --force refused on each.
    roles_project "$base" own
    for r in $PEER_ROLES; do
      printf '%s: the approved version\n' "$r" > "$RP/media/src/$r-01.wav"
      rc=0; rr_run author "own-add-$r" add "media/src/$r-01.wav" --role "$r" || rc=$?; PEER[own.add_$r]=$rc
    done
    PEER[own.rows]="$(rows_evidence "$RP/media/src/external.toml")"
    for who in author media; do rc=0; rr_run "$who" "own-verify-$who" verify || rc=$?; PEER[own.verify_$who]=$rc; done
    before="$(file_sum "$RP/media/src/external.toml") $(tree_sum "$RR")"
    for r in $PEER_ROLES; do
      printf '%s: a later version\n' "$r" > "$RP/media/src/$r-01.wav"
      for who in author media; do
        rc=0; rr_run "$who" "own-force-$who-$r" add "media/src/$r-01.wav" --role "$r" --force || rc=$?
        PEER[own.force_${who}_$r]="$rc $(rr_count "own-force-$who-$r" '^refused: .*file a new version under its own name')"
      done
    done
    PEER[own.kept]=false
    if [[ "$(file_sum "$RP/media/src/external.toml") $(tree_sum "$RR")" == "$before" ]]; then PEER[own.kept]=true; fi

    # 32: syntek-author's map, as a later release might ship it, defines brand-export as not
    # evidence beside the sibling's evidence: evidence wins, and status says so once.
    roles_project "$base" differ
    map_set "$RP/$SA_DATAROOT_MAP" "$PEER_COMMIT_ROLE:false"
    printf 'a brand export\n' > "$RP/media/src/brand-02.png"
    rc=0; rr_run author differ-add add media/src/brand-02.png --role "$PEER_COMMIT_ROLE" || rc=$?
    PEER[differ.add]="$rc $(rows_evidence "$RP/media/src/external.toml")"
    printf 'a brand export, revised\n' > "$RP/media/src/brand-02.png"
    rc=0; rr_run author differ-force add media/src/brand-02.png --role "$PEER_COMMIT_ROLE" --force || rc=$?; PEER[differ.force]=$rc
    for who in author media; do
      rc=0; rr_run "$who" "differ-status-$who" status || rc=$?
      PEER[differ.status_$who]="$rc $(rr_count "differ-status-$who" "^warning: the maps define the role '$PEER_COMMIT_ROLE' differently .*evidence wins")"
    done

    # 33: a sibling map the resolvers cannot read: at format 2 it refuses only what touches its
    # folders; unparseable (its folders unknown), it refuses nothing and is named once.
    roles_project "$base" newer
    map_set "$RP/$PEER_MAP_FILE" format2
    for who in author media; do
      rc=0; rr_run "$who" "newer-path-$who" path media/src/cue-sheet.pdf || rc=$?
      PEER[newer.path_$who]="$rc $(rr_count "newer-path-$who" "^refused: media/src is named by .*${PEER_MAP_FILE##*/}, which cannot be read")"
    done
    printf 'a scan\n' > "$RP/library/src/scan-33.pdf"
    rc=0; rr_run author newer-add add library/src/scan-33.pdf --role archive || rc=$?; PEER[newer.add]=$rc
    for who in author media; do rc=0; rr_run "$who" "newer-lib-$who" verify 'library/*' || rc=$?; PEER[newer.lib_$who]=$rc; done
    rc=0; rr_run author newer-verify verify || rc=$?
    PEER[newer.verify]="$rc $(rr_count newer-verify '^refused: verify leaves media/src') $(rr_count newer-verify '^refused:') $(rr_count newer-verify '^verified 1,')"
    roles_project "$base" broken
    map_set "$RP/$PEER_MAP_FILE" unparseable
    printf 'a scan\n' > "$RP/library/src/scan-33.pdf"
    rc=0; rr_run author broken-add add library/src/scan-33.pdf --role archive || rc=$?
    PEER[broken.add]="$rc $(rr_count broken-add "^warning: .*${PEER_MAP_FILE##*/} cannot be read")"
    for who in author media; do
      rc=0; rr_run "$who" "broken-verify-$who" verify || rc=$?
      PEER[broken.verify_$who]="$rc $(rr_count "broken-verify-$who" "^warning: .*${PEER_MAP_FILE##*/} cannot be read")"
    done

    # 35: the sibling's working output, in the work tree (ignored) and at its place under the
    # root, beside the controls in media/src that status and verify must name.
    roles_project "$base" work
    printf '*.mp4\n' > "$RP/media/src/.gitignore"
    printf 'a working render\n' > "$RP/$PEER_RENDERS/master-draft.mp4"
    printf 'a clip no row lists\n' > "$RP/media/src/clip-35.mp4"
    m="$RR/$PEER_AREA/videos/$PEER_SLUG"
    mkdir -p "$m/$PEER_RENDERS"
    printf 'an earlier render\n' > "$m/$PEER_RENDERS/master-old.mp4"
    printf 'a stray take\n' > "$m/media/src/stray-35.mp4"
    for who in author media; do
      for verb in status verify; do
        rc=0; rr_run "$who" "work-$verb-$who" "$verb" || rc=$?
        PEER[work.${verb}_$who]="$rc $(rr_count "work-$verb-$who" "$PEER_RENDERS/") $(rr_count "work-$verb-$who" 'media/src/clip-35[.]mp4') $(rr_count "work-$verb-$who" 'media/src/stray-35[.]mp4')"
      done
    done
    rc=0; rr_run author work-add add "$PEER_RENDERS/master-draft.mp4" --role "$PEER_SKIP_ROLE" || rc=$?
    PEER[work.add]="$rc $(rr_count work-add '^refused: .*marks as working output')"

    # 36: a sibling map role under a shared role's or a kind's name makes the map unreadable.
    for what in $PEER_BAD_NAMES; do
      n="${what%%:*}"
      roles_project "$base" "name-$n"
      map_set "$RP/$PEER_MAP_FILE" "$n:true"
      for who in author media; do
        rc=0; rr_run "$who" "name-$n-media-$who" path media/src/cue-sheet.pdf || rc=$?
        PEER[name.${n}_$who]="$rc $(rr_count "name-$n-media-$who" "^refused: .*'$n' is a ${what#*:}")"
        rc=0; rr_run "$who" "name-$n-library-$who" path library/src/logo.png || rc=$?; PEER[name.${n}_library_$who]=$rc
      done
    done
  fi
  if [[ "${PEER[roles.repo]}" == true ]]; then
    # 34: under repo, a "repo": "skip" role is never filed and writes nothing; another is refused.
    roles_project "$PEER_W/author-first" skip
    printf 'a take\n' > "$RP/media/src/take-34.wav"
    before="$(tree_sum "$RP" "$RR")"
    for who in author media; do
      rc=0; rr_run "$who" "skip-add-$who" add media/src/take-34.wav --role "$PEER_SKIP_ROLE" || rc=$?
      PEER[skip.add_$who]="$rc $(rr_count "skip-add-$who" '^not filed: ')"
    done
    PEER[skip.wrote]=nothing
    if [[ "$(tree_sum "$RP" "$RR")" != "$before" || -n "$(find "$RP" -name .git -prune -o -name external.toml -print)" ]]; then
      PEER[skip.wrote]=something
    fi
    rc=0; rr_run author skip-commit add media/src/take-34.wav --role "$PEER_COMMIT_ROLE" || rc=$?
    PEER[skip.commit]="$rc $(rr_count skip-commit '^refused: .*commit the file instead')"
  fi
  return 0
}

roles_checks() {
  local r who verb n got want bad rc a b v
  $PY_DR || return 0
  if [[ "${PEER[roles.ext]:-false}" == true ]]; then
    # 31: the sibling map's own roles.
    bad=""; for r in $PEER_ROLES; do [[ "${PEER[own.add_$r]:-unrun}" == 0 ]] || bad+=" $r exit ${PEER[own.add_$r]:-unrun},"; done
    [[ -z "$bad" ]] || finding "check 31 — syntek-author's resolver did not file a copy under the sibling map's role(s)${bad%,}: a role a present map defines is a role to every resolver"
    want=""; for r in $PEER_ROLES; do want+="media/src/$r-01.wav $r true;"; done
    [[ "${PEER[own.rows]:-unrun}" == "$want" ]] \
      || finding "check 31 — the rows filed under the sibling map's roles read '${PEER[own.rows]:-unrun}', not '$want': a role the map makes evidence is recorded evidence = true at filing"
    [[ "${PEER[own.verify_author]:-unrun}" == 0 && "${PEER[own.verify_media]:-unrun}" == 0 ]] \
      || finding "check 31 — verify over the rows of the sibling map's roles exited ${PEER[own.verify_author]:-unrun} (syntek-author's resolver) and ${PEER[own.verify_media]:-unrun} ($PEER_NAME's), not 0 from both"
    bad=""
    for r in $PEER_ROLES; do for who in author media; do
      [[ "${PEER[own.force_${who}_$r]:-unrun}" == "2 1" ]] || bad+=" $who/$r '${PEER[own.force_${who}_$r]:-unrun}',"
    done; done
    [[ -z "$bad" ]] || finding "check 31 — add --force on an evidence row of the sibling map's roles was not refused with 'file a new version under its own name' (exit, refusal lines):${bad%,}"
    [[ "${PEER[own.kept]:-unrun}" == true ]] \
      || finding "check 31 — add --force on the evidence rows changed the manifest or a filed copy under the data root: an evidence row's file and hash are never replaced"
    # 32: a role the two maps define differently.
    want="0 media/src/brand-02.png $PEER_COMMIT_ROLE true;"
    [[ "${PEER[differ.add]:-unrun}" == "$want" ]] \
      || finding "check 32 — with '$PEER_COMMIT_ROLE' evidence in the sibling's map and not in syntek-author's, add gave '${PEER[differ.add]:-unrun}' (exit, rows), not '$want': where two maps define a role differently, evidence wins"
    [[ "${PEER[differ.force]:-unrun}" == 2 ]] \
      || finding "check 32 — add --force on the row of the role the maps define differently exited ${PEER[differ.force]:-unrun}, not 2: a role either map makes evidence is protected"
    [[ "${PEER[differ.status_author]:-unrun}" == "0 1" && "${PEER[differ.status_media]:-unrun}" == "0 1" ]] \
      || finding "check 32 — status gave 'exit warnings' of '${PEER[differ.status_author]:-unrun}' (syntek-author's resolver) and '${PEER[differ.status_media]:-unrun}' ($PEER_NAME's), not '0 1' each: a role the maps define differently is reported once, evidence winning, and never refuses"
    # 33: a sibling map the resolvers cannot read.
    [[ "${PEER[newer.path_author]:-unrun}" == "2 1" && "${PEER[newer.path_media]:-unrun}" == "2 1" ]] \
      || finding "check 33 — with the sibling's map at format 2, path media/src/cue-sheet.pdf gave 'exit refusals' of '${PEER[newer.path_author]:-unrun}' (syntek-author's resolver) and '${PEER[newer.path_media]:-unrun}' ($PEER_NAME's), not '2 1' from both: a map that cannot be read refuses the commands that touch its folders"
    [[ "${PEER[newer.add]:-unrun}" == 0 && "${PEER[newer.lib_author]:-unrun}" == 0 && "${PEER[newer.lib_media]:-unrun}" == 0 ]] \
      || finding "check 33 — with the sibling's map at format 2, syntek-author's add of library/src/scan-33.pdf exited ${PEER[newer.add]:-unrun}, and verify 'library/*' exited ${PEER[newer.lib_author]:-unrun} and ${PEER[newer.lib_media]:-unrun}, not 0: a sibling's newer map refuses only the commands that touch its folders"
    read -r rc a b v <<< "${PEER[newer.verify]:-unrun 0 0 0}"
    [[ "$rc" == 2 && "$a" =~ ^[1-9][0-9]*$ && "$a" == "$b" && "$v" == 1 ]] \
      || finding "check 33 — with the sibling's map at format 2, a whole verify exited $rc with $a of $b refusal line(s) leaving media/src alone and $v 'verified 1' line(s): it must leave media/src alone in every refusal, verify the library row and exit 2"
    [[ "${PEER[broken.add]:-unrun}" == "0 1" && "${PEER[broken.verify_author]:-unrun}" == "0 1" && "${PEER[broken.verify_media]:-unrun}" == "0 1" ]] \
      || finding "check 33 — with the sibling's map unparseable, syntek-author's add gave '${PEER[broken.add]:-unrun}' and verify '${PEER[broken.verify_author]:-unrun}' (syntek-author's resolver) and '${PEER[broken.verify_media]:-unrun}' ($PEER_NAME's) ('exit warnings'), not '0 1' each: a map whose folders are unknown refuses nothing, and is named once"
    # 35: the working-output folder is never listed; the controls are.
    bad=""
    for who in author media; do for verb in status verify; do
      read -r _ a _ _ <<< "${PEER[work.${verb}_$who]:-unrun unrun 0 0}"
      [[ "$a" == 0 ]] || bad+=" $who's $verb ($a line(s)),"
    done; done
    [[ -z "$bad" ]] || finding "check 35 — a file under the sibling's $PEER_RENDERS, marked \"rows\": \"none\", was listed by${bad%,}: working output is never listed"
    bad=""
    for who in author media; do
      read -r _ _ a b <<< "${PEER[work.status_$who]:-unrun 0 0 0}"
      [[ "$a" != 0 && "$b" != 0 ]] || bad+=" $who's status (the ignored clip $a, the stray file $b),"
      read -r _ _ _ b <<< "${PEER[work.verify_$who]:-unrun 0 0 0}"
      [[ "$b" != 0 ]] || bad+=" $who's verify (the stray file $b),"
    done
    [[ -z "$bad" ]] || finding "check 35 — the controls in media/src (an ignored binary and a file under the data root that no row lists) went unnamed by${bad%,}: beside the working-output folder, the filing folder is still judged"
    [[ "${PEER[work.add]:-unrun}" == "2 1" ]] \
      || finding "check 35 — add of a file under $PEER_RENDERS gave '${PEER[work.add]:-unrun}' (exit, refusal lines), not exit 2 naming it working output: a folder marked \"rows\": \"none\" never takes rows"
    # 36: a sibling map role under a shared role's or a kind's name.
    bad=""
    for what in $PEER_BAD_NAMES; do n="${what%%:*}"; for who in author media; do
      [[ "${PEER[name.${n}_$who]:-unrun}" == "2 1" ]] || bad+=" '$n' by $who '${PEER[name.${n}_$who]:-unrun}',"
    done; done
    [[ -z "$bad" ]] || finding "check 36 — a sibling map role named after a shared role or a kind did not make path media/src/cue-sheet.pdf refuse, naming the role (exit, refusal lines):${bad%,}"
    bad=""
    for what in $PEER_BAD_NAMES; do n="${what%%:*}"; for who in author media; do
      [[ "${PEER[name.${n}_library_$who]:-unrun}" == 0 ]] || bad+=" '$n' by $who exit ${PEER[name.${n}_library_$who]:-unrun},"
    done; done
    [[ -z "$bad" ]] || finding "check 36 — beside a sibling map with a role named after a shared role or a kind, path library/src/logo.png was refused:${bad%,}: only the commands that touch that map's folders refuse"
  fi
  if [[ "${PEER[roles.repo]:-false}" == true ]]; then
    # 34: "repo": "skip" under repo.
    [[ "${PEER[skip.add_author]:-unrun}" == "0 1" && "${PEER[skip.add_media]:-unrun}" == "0 1" ]] \
      || finding "check 34 — under repo, add --role $PEER_SKIP_ROLE gave 'exit not-filed-lines' of '${PEER[skip.add_author]:-unrun}' (syntek-author's resolver) and '${PEER[skip.add_media]:-unrun}' ($PEER_NAME's), not '0 1' each: a role whose map says \"repo\": \"skip\" is never filed under repo"
    [[ "${PEER[skip.wrote]:-unrun}" == nothing ]] \
      || finding "check 34 — under repo, add with the sibling's \"repo\": \"skip\" role wrote into the project or the data root: it writes nothing"
    [[ "${PEER[skip.commit]:-unrun}" == "2 1" ]] \
      || finding "check 34 — under repo, add --role $PEER_COMMIT_ROLE (no \"repo\": \"skip\") gave '${PEER[skip.commit]:-unrun}' (exit, refusal lines), not exit 2 with 'commit the file instead'"
  fi
  return 0
}

# ── One project, one set of agent clients and models (checks 43–50) ───────────────────────────
#
# syntek-media's point, accepted 24/10/2026 (DESIGN.md D47, Section 9 rule 7): the shared block's
# client and model defaults read the sibling's record after this template's own, so a template
# applied second writes no client file the first left out, and both records, and so both rules
# 05 model tables, agree. Each case is a business project of its own, with the peer dummy.
CL_RAN=false
CL_SEVEN="AGENT_CLIENTS CODEX_MODEL GEMINI_MODEL OPENCODE_PROVIDER OPENCODE_BASE_URL OPENCODE_MODEL OPENCODE_CONTEXT"
CL_CODEX_MODEL="gpt-invented-4.2"
CL_OC_PROVIDER="ollama"; CL_OC_MODEL="qwen-invented:14b"; CL_OC_CONTEXT=8192
CL_OC_URL="http://127.0.0.1:11500/v1"   # not ollama's default port, so check 44 sees it inherited
CL_VLLM_URL="http://127.0.0.1:8000/v1"; CL_VLLM_CONTEXT=32768   # vllm's own defaults (DESIGN.md Section 2)
CL_OWN_MODEL="mistral-invented-7b"; CL_SIB_MODEL="gpt-sibling-invented-3.0"; CL_GEMINI_MODEL="gemini-invented-2.5-pro"
CL_FUTURE_CLIENT="a-future-client"; CL_FUTURE_PROVIDER="a-future-provider"
CL_RULES=".claude/rules/syntek-author/05-model-allocation.md"

# The agent answers a record holds, in the block's order, space-separated: "KEY=value", a list
# as its values joined by commas. An answer the record does not hold (hidden) is left out.
agent_answers() { # $1 = answers file
  local k out=""
  for k in $CL_SEVEN; do
    grep -q "^$k:" "$1" 2>/dev/null || continue
    if [[ "$k" == AGENT_CLIENTS ]]; then out+="$k=$(answer_list "$k" "$1" | paste -sd, -) "
    else out+="$k=$(answer_value "$k" "$1") "; fi
  done
  printf '%s' "${out% }"
}
# Those of the paths that stand in the project (a file, a folder or a link), space-separated.
present_of() { # $1 = project, then paths
  local p="$1" f out=""; shift
  for f in "$@"; do [[ -e "$p/$f" || -L "$p/$f" ]] && out+="$f "; done
  printf '%s' "${out% }"
}
# A record from before the agent questions: the seven answers and their list items taken out.
strip_agent_answers() { # $1 = answers file
  awk -v keys=" $CL_SEVEN " '
    /^[A-Za-z_][A-Za-z0-9_]*:/ { k = $0; sub(/:.*/, "", k); drop = (index(keys, " " k " ") > 0); if (drop) next; print; next }
    drop && /^- / { next }
    { drop = 0; print }' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

run_clients_flow() { # $1 = syntek-author snapshot, $2 = the peer dummy, $3 = the peer work dir
  local a="$1" b="$2" w="$3" p
  if ! grep -q '^AGENT_CLIENTS:' "$b/copier.yml"; then
    NOTES+=("checks 43–50 skipped — the peer dummy vendors no AGENT_CLIENTS (copier.yml holds no family-shared questions block)"); return 0
  fi
  CL_RAN=true
  # 43: syntek-author first, Codex alone with a model of its own; then the sibling, --defaults.
  p="$w/clients-author-first"
  peer_copy author "$a" "$p" "$w/clients-43-1.log" --data 'AGENT_CLIENTS=[codex]' --data "CODEX_MODEL=$CL_CODEX_MODEL" || PEER[cl43.first]=$?
  commit_all "$p" 'syntek-author'
  peer_copy media "$b" "$p" "$w/clients-43-2.log" || PEER[cl43.second]=$?
  commit_all "$p" "$PEER_NAME"
  # 44: the sibling first, OpenCode alone on a local server; then syntek-author, --defaults.
  p="$w/clients-media-first"
  peer_copy media "$b" "$p" "$w/clients-44-1.log" --data 'AGENT_CLIENTS=[opencode]' --data "OPENCODE_PROVIDER=$CL_OC_PROVIDER" \
    --data "OPENCODE_BASE_URL=$CL_OC_URL" --data "OPENCODE_MODEL=$CL_OC_MODEL" --data "OPENCODE_CONTEXT=$CL_OC_CONTEXT" \
    || PEER[cl44.first]=$?
  commit_all "$p" "$PEER_NAME"
  peer_copy author "$a" "$p" "$w/clients-44-2.log" || PEER[cl44.second]=$?
  commit_all "$p" 'syntek-author'
  # 46: the update that first asks AGENT_CLIENTS beside that sibling, on a copy of 44's project
  # whose syntek-author record has lost the seven answers.
  if [[ "${PEER[cl44.first]:-0}" -eq 0 && "${PEER[cl44.second]:-0}" -eq 0 ]]; then
    PEER[cl46.ran]=true; rm -rf "$w/clients-first-update"; cp -a "$p" "$w/clients-first-update"; p="$w/clients-first-update"
    strip_agent_answers "$p/$SA_ANSWERS_FILE"; commit_all "$p" 'syntek-author: a record from before the agent questions'
    peer_update author "$p" "$w/clients-46.log" || PEER[cl46.update]=$?
  else
    NOTES+=("check 46 skipped — check 44's copies did not succeed (check 44 says why)")
  fi
  # 45: a sibling record holding a client and a provider this release does not offer.
  p="$w/clients-future"; rm -rf "$p"; mkdir -p "$p"
  printf '%s\n' "# A later release of the other template: an invented record." '_commit: v9.0.0' 'AGENT_CLIENTS:' '- codex' \
    "- $CL_FUTURE_CLIENT" 'DATA_PROVIDER: none' 'DATA_STORE: repo' "OPENCODE_PROVIDER: $CL_FUTURE_PROVIDER" \
    "PROJECT_NAME: $SA_RENDER_NAME" > "$p/$SA_PEER_ANSWERS_FILE"
  commit_all "$p" "$PEER_NAME, later"
  peer_copy author "$a" "$p" "$w/clients-45.log" || PEER[cl45.copy]=$?
  # 47 and 50: a sibling record at ollama with an address, a model and a context of its own, and
  # Gemini CLI with a model; syntek-author's copy changes the provider, without a model and with.
  p="$w/clients-provider"; rm -rf "$p" "$p-nomodel"; mkdir -p "$p"
  printf '%s\n' "# The other template at this release: an invented record." '_commit: v0.6.0' 'AGENT_CLIENTS:' '- opencode' \
    '- gemini-cli' 'DATA_PROVIDER: none' 'DATA_STORE: repo' "GEMINI_MODEL: $CL_GEMINI_MODEL" "OPENCODE_BASE_URL: $CL_OC_URL" \
    "OPENCODE_CONTEXT: $CL_OC_CONTEXT" "OPENCODE_MODEL: $CL_OC_MODEL" "OPENCODE_PROVIDER: $CL_OC_PROVIDER" \
    "PROJECT_NAME: $SA_RENDER_NAME" > "$p/$SA_PEER_ANSWERS_FILE"
  commit_all "$p" "$PEER_NAME"
  cp -a "$p" "$p-nomodel"
  peer_copy author "$a" "$p-nomodel" "$w/clients-47-1.log" --data 'OPENCODE_PROVIDER=vllm' || PEER[cl47.nomodel]=$?
  peer_copy author "$a" "$p" "$w/clients-47-2.log" --data 'OPENCODE_PROVIDER=vllm' --data "OPENCODE_MODEL=$CL_OWN_MODEL" \
    || PEER[cl47.copy]=$?
  # 48: a copy with --overwrite and no -a over 43's project, whose sibling record now holds
  # another client list and another CODEX_MODEL.
  if [[ "${PEER[cl43.first]:-0}" -eq 0 && "${PEER[cl43.second]:-0}" -eq 0 ]]; then
    PEER[cl48.ran]=true; p="$w/clients-own-first"; rm -rf "$p"; cp -a "$w/clients-author-first" "$p"
    strip_agent_answers "$p/$SA_PEER_ANSWERS_FILE"
    printf '%s\n' 'AGENT_CLIENTS:' '- gemini-cli' '- codex' "CODEX_MODEL: $CL_SIB_MODEL" "GEMINI_MODEL: $CL_GEMINI_MODEL" \
      >> "$p/$SA_PEER_ANSWERS_FILE"
    commit_all "$p" "$PEER_NAME, answered again"
    peer_copy author "$a" "$p" "$w/clients-48.log" --overwrite || PEER[cl48.copy]=$?
  else
    NOTES+=("check 48 skipped — check 43's copies did not succeed (check 43 says why)")
  fi
  # 49: a sibling record whose client list is empty: the sibling chose none.
  p="$w/clients-none"; rm -rf "$p"; mkdir -p "$p"
  printf '%s\n' "# The other template at this release, Claude-only: an invented record." '_commit: v0.6.0' 'AGENT_CLIENTS: []' \
    'DATA_PROVIDER: none' 'DATA_STORE: repo' "PROJECT_NAME: $SA_RENDER_NAME" > "$p/$SA_PEER_ANSWERS_FILE"
  commit_all "$p" "$PEER_NAME, Claude-only"
  peer_copy author "$a" "$p" "$w/clients-49.log" || PEER[cl49.copy]=$?
  return 0
}

clients_checks() {
  local p a m want got kv miss
  $CL_RAN || return 0
  # 43: the sibling, copied second, records syntek-author's clients and model, and writes no
  # client file syntek-author left out.
  p="$PEER_W/clients-author-first"
  if [[ "${PEER[cl43.first]:-0}" -ne 0 || "${PEER[cl43.second]:-0}" -ne 0 ]]; then
    finding "check 43 — a copy failed (syntek-author exit ${PEER[cl43.first]:-0}, $PEER_NAME exit ${PEER[cl43.second]:-0}): the second template must take the first's clients and models"
  else
    want="AGENT_CLIENTS=codex CODEX_MODEL=$CL_CODEX_MODEL"
    a="$(agent_answers "$p/$SA_ANSWERS_FILE")"; m="$(agent_answers "$p/$SA_PEER_ANSWERS_FILE")"
    [[ "$a" == "$want" && "$m" == "$want" ]] \
      || finding "check 43 — the records hold '$a' (syntek-author) and '$m' ($PEER_NAME), not both '$want': the second template did not take the first's clients and model"
    got="$(present_of "$p" GEMINI.md .gemini opencode.json .agents/mcp_config.json)"
    [[ -z "$got" ]] || finding "check 43 — beside a Codex-only syntek-author the project holds $got: the second template wrote a client file the first left out"
  fi
  # 44: syntek-author, copied second, records the sibling's OpenCode answers, writes no client
  # file the sibling left out, and its model table names the model.
  p="$PEER_W/clients-media-first"
  if [[ "${PEER[cl44.first]:-0}" -ne 0 || "${PEER[cl44.second]:-0}" -ne 0 ]]; then
    finding "check 44 — a copy failed ($PEER_NAME exit ${PEER[cl44.first]:-0}, syntek-author exit ${PEER[cl44.second]:-0}): the second template must take the first's clients and models"
  else
    a="$(agent_answers "$p/$SA_ANSWERS_FILE")"; m="$(agent_answers "$p/$SA_PEER_ANSWERS_FILE")"; miss=""
    for kv in AGENT_CLIENTS=opencode "OPENCODE_PROVIDER=$CL_OC_PROVIDER" "OPENCODE_BASE_URL=$CL_OC_URL" "OPENCODE_MODEL=$CL_OC_MODEL" \
      "OPENCODE_CONTEXT=$CL_OC_CONTEXT"; do
      [[ " $a " == *" $kv "* ]] || miss+=" $kv"
    done
    [[ -z "$miss" && "$a" == "$m" ]] \
      || finding "check 44 — syntek-author records '$a' beside $PEER_NAME's '$m'$([[ -n "$miss" ]] && printf ', without%s' "$miss"): the second template did not take the first's clients and OpenCode answers"
    got="$(present_of "$p" .codex GEMINI.md .gemini .agents/mcp_config.json)"
    [[ -z "$got" ]] || finding "check 44 — beside an OpenCode-only sibling the project holds $got: syntek-author wrote a client file the sibling left out"
    grep -qF "| OpenCode | \`$CL_OC_MODEL\`" "$p/$CL_RULES" 2>/dev/null \
      || finding "check 44 — $CL_RULES's model table does not name $CL_OC_MODEL for OpenCode: it follows syntek-author's record, which must hold the sibling's model"
  fi
  # 45: values this release does not offer are filtered, never fed to choices.
  p="$PEER_W/clients-future"
  if [[ "${PEER[cl45.copy]:-0}" -ne 0 ]]; then
    got="$(grep -m1 -E 'Validation error|not a valid|Error' "$PEER_W/clients-45.log" 2>/dev/null || true)"
    finding "check 45 — beside a sibling record holding [codex, $CL_FUTURE_CLIENT] and OPENCODE_PROVIDER $CL_FUTURE_PROVIDER, syntek-author's copy exited ${PEER[cl45.copy]}${got:+ ($got)}: a recorded value this release does not offer must never reach choices"
  else
    a="$(agent_answers "$p/$SA_ANSWERS_FILE")"
    [[ " $a " == *" AGENT_CLIENTS=codex "* && " $a " != *" OPENCODE_"* ]] \
      || finding "check 45 — beside a sibling record holding [codex, $CL_FUTURE_CLIENT] and OPENCODE_PROVIDER $CL_FUTURE_PROVIDER, syntek-author records '$a', not AGENT_CLIENTS codex and no OpenCode answer"
  fi
  # 46: the update that first asks AGENT_CLIENTS takes the sibling's clients and models, not none.
  if [[ "${PEER[cl46.ran]:-false}" == true ]]; then
    p="$PEER_W/clients-first-update"
    if [[ "${PEER[cl46.update]:-0}" -ne 0 ]]; then
      finding "check 46 — the update that first asks AGENT_CLIENTS, beside a sibling that records clients, failed (exit ${PEER[cl46.update]})"
    else
      a="$(agent_answers "$p/$SA_ANSWERS_FILE")"; m="$(agent_answers "$p/$SA_PEER_ANSWERS_FILE")"
      [[ "$a" == "$m" && " $a " == *" AGENT_CLIENTS=opencode "* ]] \
        || finding "check 46 — the update that first asks AGENT_CLIENTS recorded '$a' beside $PEER_NAME's '$m': it takes the sibling's clients and models, not none"
    fi
  fi
  # 47: a provider syntek-author's copy changes inherits none of the sibling's OpenCode answers.
  if [[ "${PEER[cl47.nomodel]:-0}" -eq 0 ]] || ! grep -q 'Name the model' "$PEER_W/clients-47-1.log" 2>/dev/null; then
    finding "check 47 — beside a sibling record at $CL_OC_PROVIDER naming $CL_OC_MODEL, syntek-author's copy with OPENCODE_PROVIDER vllm and no model exited ${PEER[cl47.nomodel]:-0} without 'Name the model': a provider the person changes must not inherit the sibling's model"
  fi
  p="$PEER_W/clients-provider"
  if [[ "${PEER[cl47.copy]:-0}" -ne 0 ]]; then
    finding "check 47 — beside a sibling record at $CL_OC_PROVIDER, syntek-author's copy with OPENCODE_PROVIDER vllm and a model of its own failed (exit ${PEER[cl47.copy]})"
  else
    a="$(agent_answers "$p/$SA_ANSWERS_FILE")"; miss=""
    for kv in OPENCODE_PROVIDER=vllm "OPENCODE_BASE_URL=$CL_VLLM_URL" "OPENCODE_MODEL=$CL_OWN_MODEL" "OPENCODE_CONTEXT=$CL_VLLM_CONTEXT"; do
      [[ " $a " == *" $kv "* ]] || miss+=" $kv"
    done
    [[ -z "$miss" ]] \
      || finding "check 47 — beside a sibling record at $CL_OC_PROVIDER ($CL_OC_URL, context $CL_OC_CONTEXT), syntek-author's copy with OPENCODE_PROVIDER vllm records '$a', without$miss: a provider the person changes inherits none of the sibling's address, model or context"
  fi
  # 48: this template's own record comes before the sibling's.
  if [[ "${PEER[cl48.ran]:-false}" == true ]]; then
    p="$PEER_W/clients-own-first"; want="AGENT_CLIENTS=codex CODEX_MODEL=$CL_CODEX_MODEL"
    if [[ "${PEER[cl48.copy]:-0}" -ne 0 ]]; then
      finding "check 48 — syntek-author's copy with --overwrite over its own Codex-only project failed (exit ${PEER[cl48.copy]})"
    else
      a="$(agent_answers "$p/$SA_ANSWERS_FILE")"
      [[ "$a" == "$want" ]] \
        || finding "check 48 — a copy over a project whose syntek-author record holds '$want', beside a sibling record holding [gemini-cli, codex] and CODEX_MODEL $CL_SIB_MODEL, records '$a': the template's own record comes before the sibling's"
    fi
  fi
  # 49: an empty list the sibling recorded is its choice of none.
  p="$PEER_W/clients-none"
  if [[ "${PEER[cl49.copy]:-0}" -ne 0 ]]; then
    finding "check 49 — beside a sibling record holding AGENT_CLIENTS [], syntek-author's copy failed (exit ${PEER[cl49.copy]})"
  else
    a="$(agent_answers "$p/$SA_ANSWERS_FILE")"
    [[ "$a" == "AGENT_CLIENTS=" ]] \
      || finding "check 49 — beside a sibling record holding AGENT_CLIENTS [], syntek-author records '$a', not AGENT_CLIENTS []: an empty list is the sibling's choice of none"
    got="$(present_of "$p" AGENTS.md GEMINI.md .agents .codex .gemini opencode.json)"
    [[ -z "$got" ]] || finding "check 49 — beside a sibling record holding AGENT_CLIENTS [], the project holds $got: syntek-author wrote a client file the sibling chose not to have"
  fi
  # 50: GEMINI_MODEL reads the sibling's record too (47's copy).
  if [[ "${PEER[cl47.copy]:-0}" -eq 0 ]]; then
    a="$(agent_answers "$PEER_W/clients-provider/$SA_ANSWERS_FILE")"
    [[ " $a " == *" GEMINI_MODEL=$CL_GEMINI_MODEL "* ]] \
      || finding "check 50 — beside a sibling record holding gemini-cli and GEMINI_MODEL $CL_GEMINI_MODEL, syntek-author records '$a': the second template did not take the first's Gemini CLI model"
  else
    NOTES+=("check 50 skipped — check 47's copy did not succeed (check 47 says why)")
  fi
  return 0
}

MF_SRC=""
# ── The user guide shared by two templates (DESIGN.md D56; checks 37–42) ──────
#
# The sibling ships the shared how-to files byte for byte (vendored from family-shared.json),
# its own files under folders named for it, "restore": ["how-to"] in its refresh data, and the
# guide's deny and guard in its seed. Each case runs on a project of its own: the sibling copied
# first with its own revision of a shared chapter (38), the same in a clone without the sibling's
# record (42), syntek-author crossing into the release that adds the guide beside the sibling's
# revision (39), and an owner's edits (41); checks 37 and 40 read the main flow's projects.
HT_SHARED_CH="how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md"
HT_REV_MARK="A line only the sibling's own revision of this chapter holds."
HT_SIB_WHY="it holds dummy-media's version of a shared file"
HT_CLONE_WHY="this clone holds no record of dummy-media"
HT_LEFT="LEFT AS IT IS in how-to/"
HT_RESTORED="RESTORED to the template's text"
HT_NEW="NOT UPDATED because it is new in this version"
HT_SIB_SEC="NOT UPDATED because the file holds dummy-media's version"
HT_PLANT="The guide is short. It is plain."
HT_RAN=false; HT_W=""
declare -A HT=()

# The sibling's own how-to files (D56): a guide, a chapter and a procedure under folders named
# for it, plain enough for make lint and make flags with SCOPE=how-to/src STRICT=1.
howto_own() { # $1 = the sibling's template/, $2 = its name
  local t="$1" n="$2" f
  mkdir -p "$t/how-to/docs/$n" "$t/how-to/src/TEMPLATE-GUIDE/$n" "$t/how-to/workflows/$n/01-b"
  printf '# A guide of the sibling — what it explains\n\nThe guide explains one thing.\n' > "$t/how-to/docs/$n/x.md"
  printf '# A chapter of the sibling — what it covers\n\nThe chapter explains the sibling.\n\n## The first topic\n\nOne plain sentence.\n\n## The second topic\n\nAnother plain sentence.\n\n## Where the rules live\n\n- The rules.\n\n## Next\n\n- Read on.\n' \
    > "$t/how-to/src/TEMPLATE-GUIDE/$n/01-a.md"
  for f in CONTEXT CLAUDE STEPS CHECKLIST; do printf '# %s.md — a procedure of the sibling\n' "$f" > "$t/how-to/workflows/$n/01-b/$f.md"; done
}

# Every section of the last report for $3 in a log that lists the path, then each line of its
# entry: "section<TAB>line" ("section<TAB>" for the path's own line).
ht_entries() { # $1 = log, $2 = path, $3 = template name
  python3 - "$1" "$2" "$3" <<'PY'
import re, sys
log, path, name = sys.argv[1:]
try:
    lines = open(log, encoding="utf-8", errors="replace").read().splitlines()
except OSError:
    sys.exit(0)
starts = [i for i, l in enumerate(lines) if l.startswith(f"▸ {name} update report")]
cur, on = None, False
for l in (lines[starts[-1]:] if starts else []):
    if re.match(r"  [A-Z]{2}", l):
        cur, on = l.strip(), False
    elif re.match(r"    \S", l):
        on = cur is not None and l.strip() == path
        if on:
            print(cur + "\t")
    elif on and l.startswith("        "):
        print(cur + "\t" + l.strip())
    elif l and not l.startswith((" ", "▸")):
        break
PY
}
ht_sha() { if [[ -f "$1" ]]; then sha256sum < "$1" | cut -d' ' -f1; else printf 'none'; fi; }
# The sha256 a shared how-to file must carry: family-shared.json's where it lists the file, the
# template source's otherwise (a shared how-to file holds no delimiter, so the two agree).
ht_want_sha() { # $1 = syntek-author repo, $2 = path
  local s=""
  [[ -f "$1/family-shared.json" ]] && s="$(manifest_file_sha "$1/family-shared.json" "$2")"
  [[ -n "$s" ]] || s="$(ht_sha "$1/template/$2")"
  printf '%s' "$s"
}
ht_guard_count() { # $1 = settings.json → how many PreToolUse entries run the guide guard
  python3 - "$1" "$SA_HOWTO_GUARD" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception:
    print(-1); sys.exit(0)
pre = (d.get("hooks") or {}).get("PreToolUse") or []
print(sum(1 for e in pre if any(sys.argv[2] in str(h.get("command", "")) for h in e.get("hooks") or [])))
PY
}

run_howto_flow() { # $1 = syntek-author snapshot (A_FIRST and its change), $2 = the dummy, $3 = work dir
  local a="$1" b0="$2" w="$3/ht" log="$3/ht-flow.log" a2="$3/ht/a" b="$3/ht/b" p f pre revb back
  HT_RAN=true; HT_W="$w"   # HT holds check 40's state already (run_howto_lint runs first)
  if [[ ! -f "$b0/template/$HT_SHARED_CH" || ! -f "$a/template/$HT_SHARED_CH" ]]; then
    HT_RAN=false; NOTES+=("checks 38, 39, 41 and 42 skipped — the dummy vendors no $HT_SHARED_CH (family-shared.json lists no how-to file)"); return 0
  fi
  mkdir -p "$w"
  # syntek-author before the guide (39): its snapshot on a side branch, with how-to/ and the
  # how-to lines of its refresh data gone; main stays the snapshot with its change.
  git clone -q "$a" "$a2" >>"$log" 2>&1 || die "could not clone $a"
  sa_git "$a2" checkout -q -b pre "$A_FIRST" >>"$log" 2>&1
  sa_git "$a2" rm -q -r -- template/how-to >>"$log" 2>&1
  python3 - "$a2/migrations/family-refresh.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
d["refresh"] = [p for p in d.get("refresh", []) if not p.startswith("how-to/")]
d.pop("restore", None)
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
  sa_git "$a2" add -A && sa_git "$a2" commit -q -m 'syntek-author before the guide' >>"$log" 2>&1
  pre="$(git -C "$a2" rev-parse HEAD)"; sa_git "$a2" checkout -q - >>"$log" 2>&1
  # Tagged, so Copier reads the crossing as an upgrade: two untagged commits the same distance
  # from the root compare by their hashes, and half the time Copier refuses a 'downgrade'.
  sa_git "$a2" tag v0.0.1 "$pre" >>"$log" 2>&1; sa_git "$a2" tag v0.0.2 HEAD >>"$log" 2>&1
  # The sibling's own revision of a shared chapter, and a later release back on the shared bytes.
  git clone -q "$b0" "$b" >>"$log" 2>&1 || die "could not clone $b0"
  printf '\n%s\n' "$HT_REV_MARK" >> "$b/template/$HT_SHARED_CH"
  sa_git "$b" add -A && sa_git "$b" commit -q -m 'the sibling revises a shared chapter' >>"$log" 2>&1; revb="$(git -C "$b" rev-parse HEAD)"
  cp "$a/template/$HT_SHARED_CH" "$b/template/$HT_SHARED_CH"
  sa_git "$b" add -A && sa_git "$b" commit -q -m 'the sibling takes the shared bytes again' >>"$log" 2>&1; back="$(git -C "$b" rev-parse HEAD)"
  HT[rev_sha]="$(git -C "$b" show "$revb:template/$HT_SHARED_CH" | sha256sum | cut -d' ' -f1)"
  HT[want_sha]="$(ht_want_sha "$a" "$HT_SHARED_CH")"

  b_copy() { "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$1" --data "PROJECT_NAME=$SA_RENDER_NAME" "$b" "$2" </dev/null; }
  b_update() { (cd "$1" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref="$2" --answers-file "$B_ANSWERS" </dev/null); }
  a_update() { (cd "$1" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref=HEAD --answers-file "$SA_ANSWERS_FILE" </dev/null); }

  # 38 and 42: the sibling first, with its own revision; syntek-author second.
  p="$w/p38"; HT[38_copy]=0
  { b_copy "$revb" "$p" && { [[ -d "$p/.git" ]] || sa_git "$p" init -q; } && commit_all "$p" 'the sibling first' \
      && a_copy_at "$a" "$A_FIRST" "$p" && commit_all "$p" 'syntek-author second'; } >>"$log" 2>&1 || HT[38_copy]=$?
  if [[ "${HT[38_copy]}" -eq 0 ]]; then
    cp -a "$p" "$w/p42"
    HT[38_a1]=0; a_update "$p" >"$w/38a.log" 2>&1 || HT[38_a1]=$?; cat "$w/38a.log" >>"$log"
    HT[38_sha1]="$(ht_sha "$p/$HT_SHARED_CH")"
    commit_all "$p" 'syntek-author updated' >>"$log" 2>&1 || true
    HT[38_b]=0; b_update "$p" "$back" >>"$log" 2>&1 || HT[38_b]=$?
    commit_all "$p" 'the sibling updated' >>"$log" 2>&1 || true
    HT[38_a2]=0; a_update "$p" >"$w/38b.log" 2>&1 || HT[38_a2]=$?; cat "$w/38b.log" >>"$log"
    HT[38_sha2]="$(ht_sha "$p/$HT_SHARED_CH")"
    p="$w/p42"
    git -C "$p" update-ref -d refs/dummy-media/template >>"$log" 2>&1 || true
    HT[42_a1]=0; a_update "$p" >"$w/42a.log" 2>&1 || HT[42_a1]=$?; cat "$w/42a.log" >>"$log"
    HT[42_sha1]="$(ht_sha "$p/$HT_SHARED_CH")"
    commit_all "$p" 'syntek-author updated in a plain clone' >>"$log" 2>&1 || true
    HT[42_b]=0; b_update "$p" "$revb" >>"$log" 2>&1 || HT[42_b]=$?
    commit_all "$p" 'the sibling updated, and recorded' >>"$log" 2>&1 || true
    HT[42_a2]=0; a_update "$p" >"$w/42b.log" 2>&1 || HT[42_a2]=$?; cat "$w/42b.log" >>"$log"
    HT[42_sha2]="$(ht_sha "$p/$HT_SHARED_CH")"
  fi

  # 39: syntek-author before the guide, the sibling's revision beside it, then the crossing.
  p="$w/p39"; HT[39_copy]=0; HT[39_a]=0
  { a_copy_at "$a2" "$pre" "$p" && { [[ -d "$p/.git" ]] || sa_git "$p" init -q; } && commit_all "$p" 'syntek-author before the guide' \
      && b_copy "$revb" "$p" && commit_all "$p" 'the sibling, with its revision'; } >>"$log" 2>&1 || HT[39_copy]=$?
  if [[ "${HT[39_copy]}" -eq 0 ]]; then
    a_update "$p" >"$w/39.log" 2>&1 || HT[39_a]=$?; cat "$w/39.log" >>"$log"
    HT[39_sha]="$(ht_sha "$p/$HT_SHARED_CH")"
  fi

  # 41: the owner edits a shared how-to file and a file in the sibling's folder.
  p="$w/p41"; HT[41_copy]=0; HT[41_a]=0; HT[41_b]=0
  { a_copy_at "$a" "$A_FIRST" "$p" && { [[ -d "$p/.git" ]] || sa_git "$p" init -q; } && commit_all "$p" 'syntek-author' \
      && b_copy "$B_FIRST" "$p" && commit_all "$p" 'the sibling'; } >>"$log" 2>&1 || HT[41_copy]=$?
  if [[ "${HT[41_copy]}" -eq 0 ]]; then
    printf '\nMy own line.\n' >> "$p/how-to/CONTEXT.md"; printf '\nMy own line.\n' >> "$p/how-to/docs/dummy-media/x.md"
    commit_all "$p" 'my edits in the guide' >>"$log" 2>&1
    HT[41_x]="$(ht_sha "$p/how-to/docs/dummy-media/x.md")"
    a_update "$p" >"$w/41a.log" 2>&1 || HT[41_a]=$?; cat "$w/41a.log" >>"$log"
    HT[41_ctx]="$(ht_sha "$p/how-to/CONTEXT.md")"; HT[41_x_after]="$(ht_sha "$p/how-to/docs/dummy-media/x.md")"
    commit_all "$p" 'syntek-author updated' >>"$log" 2>&1 || true
    b_update "$p" HEAD >"$w/41b.log" 2>&1 || HT[41_b]=$?; cat "$w/41b.log" >>"$log"
    HT[41_guard]="$(ht_guard_count "$p/.claude/settings.json")"
  fi
  HT[ctx_sha]="$(ht_want_sha "$a" how-to/CONTEXT.md)"
  return 0
}

# Check 40 on a copy of the main project: the guide's chapters clean under a SCOPE, and never
# read without one.
run_howto_lint() { # $1 = the main project, $2 = work dir
  local p="$2/ht40" s ch="how-to/src/TEMPLATE-GUIDE/dummy-media/01-a.md"
  HT=(); HT[40]=""
  if [[ ! -f "$1/Makefile" || ! -f "$1/$ch" ]]; then HT[40]="skip: no Makefile or no sibling chapter in the project"; return 0; fi
  cp -a "$1" "$p"
  s=0; (cd "$p" && make --no-print-directory lint SCOPE=how-to/src STRICT=1) >"$2/ht40-lint.log" 2>&1 || s=$?; HT[40_lint]=$s
  s=0; (cd "$p" && make --no-print-directory flags SCOPE=how-to/src STRICT=1) >"$2/ht40-flags.log" 2>&1 || s=$?; HT[40_flags]=$s
  printf '\n%s\n' "$HT_PLANT" >> "$p/$ch"
  s=0; (cd "$p" && make --no-print-directory lint) >"$2/ht40-unscoped.log" 2>&1 || s=$?
  if [[ "$s" -ne 0 ]]; then HT[40_unscoped]="make lint failed (exit $s)"
  elif grep -qF "$ch" "$2/ht40-unscoped.log"; then HT[40_unscoped]=seen
  else HT[40_unscoped]=unseen; fi
}

howto_checks() {
  local L p f now want sec e n r
  # 37. In both orders, each shared how-to file is there with the manifest's bytes and no
  # conflict, and both templates' how-to files are there.
  for L in author-first media-first; do
    p="$PROJ"; [[ "$L" == media-first ]] && p="$MF"
    [[ "$L" == author-first && ( "$A_UPDATE" -ne 0 || "$B_UPDATE" -ne 0 ) ]] && continue   # checks 3 and 4
    [[ "$L" == media-first && ( "$MF_A_COPY" -ne 0 || "$MF_B_COPY" -ne 0 ) ]] && continue   # check 9
    r=""
    for f in $SA_SHARED_HOWTO; do
      [[ -f "$MF_SRC/template/$f" ]] || continue
      want="$(ht_want_sha "$MF_SRC" "$f")"
      if [[ ! -f "$p/$f" || -L "$p/$f" ]]; then r="$f is missing, or not a file"; break; fi
      now="$(ht_sha "$p/$f")"
      if grep -q '^<<<<<<< ' "$p/$f" || [[ -e "$p/$f.rej" ]]; then r="$f holds a conflict"; break; fi
      [[ "$now" == "$want" ]] || { r="$f does not hold the manifest's bytes"; break; }
    done
    if [[ -z "$r" ]]; then
      for f in "${A_ALL[@]}" "${B_ALL[@]}"; do
        [[ "$f" == how-to/* ]] || continue
        [[ -f "$p/$f" ]] || { r="$f, a file of one template's guide, is missing"; break; }
      done
    fi
    n="after both copies"; [[ "$L" == author-first ]] && n+=" and both updates"
    [[ -z "$r" ]] || finding "check 37 — [$L] $n: $r"
  done
  if ! $HT_RAN; then return 0; fi
  # 38. The sibling's revision is kept and attributed, never written over while it stands
  # unchanged; once the sibling takes the shared bytes again, nothing is listed.
  if [[ "${HT[38_copy]}" -ne 0 ]]; then
    finding "check 38 — the sibling's copy and syntek-author's after it failed (exit ${HT[38_copy]})"
  else
    e="$(ht_entries "$HT_W/38a.log" "$HT_SHARED_CH" syntek-author)"
    if [[ "${HT[38_a1]}" -ne 0 || "${HT[38_b]}" -ne 0 || "${HT[38_a2]}" -ne 0 ]]; then
      finding "check 38 — an update failed (syntek-author ${HT[38_a1]}, the sibling ${HT[38_b]}, syntek-author again ${HT[38_a2]})"
    elif [[ "${HT[38_sha1]}" != "${HT[rev_sha]}" ]]; then
      finding "check 38 — syntek-author's update replaced the sibling's revision of $HT_SHARED_CH — a sibling's version is never written over while it stands unchanged"
    elif ! grep -q "^$HT_LEFT.*$HT_SIB_WHY" <<< "$e"; then
      finding "check 38 — syntek-author's report does not list $HT_SHARED_CH under '$HT_LEFT' with '$HT_SIB_WHY'"
    elif [[ "${HT[38_sha2]}" != "${HT[want_sha]}" ]] || [[ -n "$(ht_entries "$HT_W/38b.log" "$HT_SHARED_CH" syntek-author)" ]]; then
      finding "check 38 — after the sibling's update to the shared bytes, $HT_SHARED_CH does not hold them, or syntek-author's next report still lists it"
    fi
  fi
  # 39. The crossing beside the sibling's revision: listed as the sibling's, never as new.
  if [[ "${HT[39_copy]}" -ne 0 || "${HT[39_a]}" -ne 0 ]]; then
    finding "check 39 — the crossing beside the sibling failed (copies ${HT[39_copy]}, update ${HT[39_a]})"
  else
    e="$(ht_entries "$HT_W/39.log" "$HT_SHARED_CH" syntek-author)"
    if grep -q "^$HT_NEW" <<< "$e"; then
      finding "check 39 — the crossing lists the sibling's revision of $HT_SHARED_CH under '$HT_NEW' — it is the sibling's, not the owner's"
    elif ! grep -qE "^$HT_SIB_SEC|^$HT_LEFT.*$HT_SIB_WHY" <<< "$e"; then
      finding "check 39 — the crossing does not list $HT_SHARED_CH as holding dummy-media's version (a shared file)"
    elif [[ "${HT[39_sha]}" != "${HT[rev_sha]}" ]]; then
      finding "check 39 — the crossing replaced the sibling's revision of $HT_SHARED_CH"
    fi
  fi
  # 40. make lint and make flags read the guide's chapters only under a SCOPE.
  case "${HT[40]:-}" in
    skip:*) NOTES+=("check 40 skipped — ${HT[40]#skip: }") ;;
    *)
      if [[ "${HT[40_lint]:-1}" -ne 0 || "${HT[40_flags]:-1}" -ne 0 ]]; then
        finding "check 40 — make lint (exit ${HT[40_lint]:-none}) or make flags (exit ${HT[40_flags]:-none}) with SCOPE=how-to/src STRICT=1 failed over both templates' chapters"
      elif [[ "${HT[40_unscoped]:-}" != unseen ]]; then
        r="${HT[40_unscoped]:-was not run}"; [[ "$r" != seen ]] || r="reported the line planted in the sibling's chapter"
        finding "check 40 — make lint without a SCOPE $r — it reads no how-to/src"
      fi ;;
  esac
  # 41. The owner's edit to a shared how-to file is restored by one template's update and the
  # other's is quiet for it; the sibling's folder is never touched; the guard is wired once.
  if [[ "${HT[41_copy]}" -ne 0 || "${HT[41_a]}" -ne 0 || "${HT[41_b]}" -ne 0 ]]; then
    finding "check 41 — a copy or an update failed (copies ${HT[41_copy]}, syntek-author ${HT[41_a]}, the sibling ${HT[41_b]})"
  elif [[ "${HT[41_ctx]}" != "${HT[ctx_sha]}" ]]; then
    finding "check 41 — syntek-author's update did not put the owner's how-to/CONTEXT.md back to the shared bytes"
  elif ! grep -q "^$HT_RESTORED" <<< "$(ht_entries "$HT_W/41a.log" how-to/CONTEXT.md syntek-author)"; then
    finding "check 41 — syntek-author's report does not list how-to/CONTEXT.md under RESTORED"
  elif [[ -n "$(ht_entries "$HT_W/41b.log" how-to/CONTEXT.md dummy-media)" ]]; then
    finding "check 41 — the sibling's next update lists how-to/CONTEXT.md, which holds the bytes both templates ship"
  elif [[ "${HT[41_x_after]}" != "${HT[41_x]}" ]]; then
    finding "check 41 — syntek-author's update touched the owner's edit in the sibling's how-to/docs/dummy-media/x.md"
  elif [[ "${HT[41_guard]}" != 1 ]]; then
    finding "check 41 — after both copies and both updates settings.json runs the guide guard in ${HT[41_guard]} PreToolUse entries, not one"
  fi
  # 42. A plain clone: the sibling's revision left as unjudgeable, then as the sibling's.
  if [[ "${HT[38_copy]}" -eq 0 ]]; then
    if [[ "${HT[42_a1]}" -ne 0 || "${HT[42_b]}" -ne 0 || "${HT[42_a2]}" -ne 0 ]]; then
      finding "check 42 — an update in the plain clone failed (syntek-author ${HT[42_a1]}, the sibling ${HT[42_b]}, syntek-author again ${HT[42_a2]})"
    elif [[ "${HT[42_sha1]}" != "${HT[rev_sha]}" || "${HT[42_sha2]}" != "${HT[rev_sha]}" ]]; then
      finding "check 42 — in a clone without the sibling's record, syntek-author's update replaced the sibling's revision of $HT_SHARED_CH"
    elif ! grep -q "^$HT_LEFT.*$HT_CLONE_WHY" <<< "$(ht_entries "$HT_W/42a.log" "$HT_SHARED_CH" syntek-author)"; then
      finding "check 42 — in a clone without the sibling's record, the report does not say '$HT_CLONE_WHY'"
    elif ! grep -q "^$HT_LEFT.*$HT_SIB_WHY" <<< "$(ht_entries "$HT_W/42b.log" "$HT_SHARED_CH" syntek-author)"; then
      finding "check 42 — once the sibling's update recorded its render, the report does not say '$HT_SIB_WHY'"
    fi
  fi
  return 0
}

# The fixture as this release's syntek-author is, for checks 37–42: two shared how-to files and a
# chapter of its own, the guide guard and its entry, the deny, "restore" in its refresh data, and
# a stand-in Makefile whose lint and flags read how-to/src only under a SCOPE. Commits.
extend_fixture_howto() { # $1 = fixture template repo
  local t="$1" d="$1/template" own="how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md"
  local shared="how-to/CONTEXT.md $HT_SHARED_CH"
  mkdir -p "$d/how-to/src/TEMPLATE-GUIDE/syntek-author" "$d/.claude/hooks"
  printf '# CONTEXT.md — how-to/\n\nThe user guide, shared by every template.\n' > "$d/how-to/CONTEXT.md"
  printf '# Updating and recovery — taking an update safely\n\nAn update brings the template'"'"'s changes.\n\n## Before you update\n\nCommit your work.\n\n## Where the rules live\n\n- The rules.\n\n## Next\n\n- Read on.\n' > "$d/$HT_SHARED_CH"
  printf '# Overview — what the project is\n\nThe project holds your work.\n\n## The layers\n\nEach layer has a job.\n\n## The settings\n\nTwo files hold them.\n\n## Where the rules live\n\n- The rules.\n\n## Next\n\n- Read on.\n' > "$d/$own"
  cp "$SA_ROOT/template/$SA_HOWTO_GUARD" "$d/$SA_HOWTO_GUARD"; chmod +x "$d/$SA_HOWTO_GUARD"
  printf '%s\n' 'WORK_DIRS := $(filter-out how-to/src,$(wildcard */src))' 'IN = $(if $(SCOPE),$(SCOPE),$(WORK_DIRS))' \
    'lint:' $'\t@n=0; for f in $$(find $(or $(IN),.nothing-to-scan) -name \'*.md\' ! -name CONTEXT.md ! -name CLAUDE.md 2>/dev/null); do \\' \
    $'\t  h=$$(grep -nH \'[^[:space:].][.!?][[:space:]][[:space:]]*[[:upper:]]\' "$$f"); [ -z "$$h" ] || { echo "$$h"; n=$$((n + 1)); }; done; \\' \
    $'\t[ -z "$(STRICT)" ] || [ "$$n" -eq 0 ]' \
    'flags:' $'\t@n=0; for f in $$(find $(or $(IN),.nothing-to-scan) -name \'*.md\' ! -name CONTEXT.md ! -name CLAUDE.md 2>/dev/null); do \\' \
    $'\t  h=$$(grep -nH \'VERIFY:\' "$$f"); [ -z "$$h" ] || { echo "$$h"; n=$$((n + 1)); }; done; \\' \
    $'\t[ -z "$(STRICT)" ] || [ "$$n" -eq 0 ]' > "$d/Makefile"
  python3 - "$t/copier.yml" "$t/migrations/family-refresh.json" "$d/.claude/settings.json" "$shared $SA_HOWTO_GUARD" \
    "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" "$SA_HOWTO_DENY" <<'PY' || return 1
import json, sys
cy, rf, st, paths, matcher, cmd, deny = sys.argv[1:]
paths = paths.split()
lines = open(cy, encoding="utf-8").read().split("\n")
def after(key, new):
    i = lines.index(key)
    lines[i + 1:i + 1] = new
after("_exclude:", [f"  - \"<: if _copier_operation == 'update' :>/{p}<: endif :>\"" for p in paths])
after("_skip_if_exists:", [f"  - /{p}" for p in paths])
open(cy, "w", encoding="utf-8").write("\n".join(lines))
entry = {"matcher": matcher, "hooks": [{"type": "command", "command": cmd, "timeout": 10}]}
d = json.load(open(rf, encoding="utf-8"))
d["refresh"] = d.get("refresh", []) + paths
d["restore"] = ["how-to"]
d.setdefault("settings", {}).setdefault("hooks", {})["PreToolUse"] = [entry]
json.dump(d, open(rf, "w", encoding="utf-8"), indent=2)
s = json.load(open(st, encoding="utf-8"))
s.setdefault("hooks", {})["PreToolUse"] = [entry]
s.setdefault("permissions", {}).setdefault("deny", []).append(deny)
open(st, "w", encoding="utf-8").write(json.dumps(s, indent=2) + "\n")
PY
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture: the user guide'
}

# ── Lessons in learning/ with two templates (DESIGN.md D57; checks 51–52) ──────
#
# Each template's teaching skill keeps its own topics in learning/, in a folder named for it while
# another template's answers file stands at the root; only syntek-author ships the folder's pair.
# No audit runs a skill, so the lessons are planted by hand where the skills would write them, in
# both orders after the first copy: a topic at the top of learning/ with no Template: line (as
# before D57, or adopted), one in syntek-author's folder and one in the sibling's.
LN_LESSONS=(learning/old-topic/PROGRESS.md learning/syntek-author/a-topic/MISSION.md learning/dummy-media/m-topic/MISSION.md)
LN_PAIR="learning/CONTEXT.md learning/CLAUDE.md"
declare -A LN_WANT=()
MF_A_LOG=""

ln_plant() { # $1 = project: the three lessons, committed
  local p="$1" f
  for f in "${LN_LESSONS[@]}"; do mkdir -p "$p/${f%/*}"; done
  printf '# Progress\n\n- 01/01/2027: a lesson from before the template folders; its topic names no template.\n' > "$p/${LN_LESSONS[0]}"
  printf '# Mission\n\nTemplate: syntek-author\n\nPunctuate dialogue without help.\n' > "$p/${LN_LESSONS[1]}"
  printf '# Mission\n\nTemplate: dummy-media\n\nCut a scene to its one beat.\n' > "$p/${LN_LESSONS[2]}"
  for f in "${LN_LESSONS[@]}"; do LN_WANT["$f"]="$(ht_sha "$p/$f")"; done
  commit_all "$p" 'lessons in learning/'
}

ln_checks() {
  local L p f r n t log sec c52=true
  if [[ ! -f "$MF_SRC/template/learning/CONTEXT.md" ]]; then
    c52=false; NOTES+=("check 52 skipped — the template ships no learning/ pair")
  elif [[ ! -f "$MF_SRC/migrations/family-update.py" ]]; then
    c52=false; NOTES+=("check 52 skipped — the repository has no migrations/family-update.py, so no render record")
  fi
  for L in author-first media-first; do
    p="$PROJ"; [[ "$L" == media-first ]] && p="$MF"
    [[ "$L" == author-first && ( "$A_UPDATE" -ne 0 || "$B_UPDATE" -ne 0 ) ]] && continue   # checks 3 and 4
    [[ "$L" == media-first && ( "$MF_A_COPY" -ne 0 || "$MF_B_COPY" -ne 0 ) ]] && continue   # check 9
    n="after both copies"; [[ "$L" == author-first ]] && n+=" and both updates"
    # 51. Each lesson as planted, no conflict under learning/, and no report naming a path there.
    r=""
    for f in "${LN_LESSONS[@]}"; do
      if [[ ! -f "$p/$f" || -L "$p/$f" ]]; then r="$f is missing, or not a file"; break; fi
      [[ "$(ht_sha "$p/$f")" == "${LN_WANT[$f]:-}" ]] || { r="$f is not byte for byte the lesson planted there"; break; }
    done
    if [[ -z "$r" ]]; then
      f="$( { find "$p/learning" -name '*.rej' -print; grep -rlI -e '^<<<<<<< ' "$p/learning"; } 2>/dev/null | LC_ALL=C sort | head -n 1 || true)"
      [[ -z "$f" ]] || r="${f#"$p"/} holds a conflict"
    fi
    if [[ -z "$r" ]]; then
      for t in syntek-author dummy-media; do
        log="$A_LOG"; [[ "$t" == dummy-media ]] && log="$B_LOG"
        if [[ "$L" == media-first ]]; then [[ "$t" == syntek-author ]] || continue; log="$MF_A_LOG"; fi
        [[ -n "$log" && -f "$log" ]] || continue
        while IFS=$'\t' read -r sec f; do
          [[ "$f" == learning/* ]] && { r="$t's report lists $f under '$sec'"; break 2; }
        done < <(report_paths "$log" "$t")
      done
    fi
    [[ -z "$r" ]] || finding "check 51 — [$L] $n: $r — lessons in learning/ are the author's, and no template's copy or update touches them (DESIGN.md D57)"
    # 52. The pair is syntek-author's render; the sibling's record holds no path under learning/.
    $c52 || continue
    git -C "$p" rev-parse -q --verify refs/syntek-author/template >/dev/null 2>&1 || continue   # check 11's
    r=""
    for f in $LN_PAIR; do
      if ! git -C "$p" cat-file -e "refs/syntek-author/template:$f" 2>/dev/null; then r="syntek-author's render record holds no $f"; break; fi
      [[ "$(ht_sha "$p/$f")" == "$(git -C "$p" cat-file blob "refs/syntek-author/template:$f" | sha256sum | cut -d' ' -f1)" ]] \
        || { r="$f does not hold the bytes syntek-author's render record holds"; break; }
    done
    if [[ -z "$r" ]] && git -C "$p" rev-parse -q --verify refs/dummy-media/template >/dev/null 2>&1; then
      f="$(git -C "$p" ls-tree -r --name-only refs/dummy-media/template -- learning 2>/dev/null | head -n 1 || true)"
      [[ -z "$f" ]] || r="dummy-media's render record holds $f, but no other template ships a path under learning/"
    fi
    [[ -z "$r" ]] || finding "check 52 — [$L] $n: $r — the learning/ pair is syntek-author's alone (DESIGN.md D57)"
  done
  return 0
}

# The fixture's learning/ pair, as this release's syntek-author ships it (checks 51–52): rendered,
# so the render record and the project hold the same rendered bytes. Commits.
extend_fixture_learning() { # $1 = fixture template repo
  local t="$1" d="$1/template/learning"
  mkdir -p "$d"
  printf '# CONTEXT.md — learning/\n\nThe practice folder of <%% AUTHOR_NAME %%>, shared with any companion template.\n' > "$d/CONTEXT.md"
  printf '@./CONTEXT.md\n\n# CLAUDE.md — learning/\n\nWrite only inside the topic'"'"'s folder.\n' > "$d/CLAUDE.md"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture: the learning/ pair'
}

media_first_checks() {
  local kind path sum source now
  if [[ "$MF_B_COPY" -ne 0 ]]; then finding "check 9 — the dummy second template did not render on its own (exit $MF_B_COPY)"; return 0; fi
  if [[ "$MF_A_COPY" -ne 0 ]]; then
    finding "check 9 — syntek-author's copy over a project with syntek-media 0.4.2's .agents/ failed (exit $MF_A_COPY) — it must succeed with no --exclude"
    return 0
  fi
  if [[ -L "$MF/.agents" || ! -d "$MF/.agents" ]]; then
    finding "check 9 — after both copies .agents is not a real folder"
  elif [[ ! -L "$MF/.agents/skills" || "$(readlink "$MF/.agents/skills")" != "$SA_AGENTS_LINK_TARGET" ]]; then
    finding "check 9 — after both copies .agents/skills is not the link to $SA_AGENTS_LINK_TARGET"
  elif [[ "$(cat "$MF/.agents/mcp_config.json" 2>/dev/null; printf x)" != "${SA_MCP_SHARED}x" ]]; then
    finding "check 9 — after both copies .agents/mcp_config.json is not exactly the shared bytes: the copy's baseline must give media 0.4.x's unedited 23 bytes the two MCP servers, once (D54)"
  fi
  [[ -f "$MF/$B_BRIDGE" && -f "$MF/.claude/syntek-author-agents.md" ]] \
    || finding "check 9 — after both copies the project does not hold both bridges ($B_BRIDGE and .claude/syntek-author-agents.md)"

  if [[ -z "$MANIFEST" ]]; then
    NOTES+=("check 10 skipped — the repository has no family-shared.json")
    return 0
  fi
  while IFS=$'\t' read -r kind path sum source; do
    # .agents/mcp_config.json is check 9's: it must be exactly the shared bytes (D54).
    [[ "$path" == .agents/mcp_config.json ]] && continue
    if [[ "$kind" == L ]]; then
      [[ -L "$MF/$path" && "$(readlink "$MF/$path")" == "$sum" ]] \
        || finding "check 10 — $path in the media-first project is not the link to $sum family-shared.json lists"
      continue
    fi
    local -a names=("$path")
    # A <template> path (the permissions script, the resolver) under both templates' names.
    [[ "$path" == *dummy-media* ]] && names+=("${path/dummy-media/author}")
    for now in "${names[@]}"; do
      [[ -f "$MF/$now" ]] || continue
      [[ "$(sha256sum < "$MF/$now" | cut -d' ' -f1)" == "$sum" ]] \
        || finding "check 10 — $now in the media-first project does not carry the sha256 family-shared.json lists for $source"
    done
  done < <(manifest_entries "$MF_SRC" "$MANIFEST" dummy-media)
  return 0
}

# The fixture as this release's syntek-author is, for checks 18–30 and 43–50: the peer key, the
# real family-shared questions block in place of the fixture's own agent questions, copier.yml's
# per-client gates, the real resolver and map, and rules 06 holding the real rules-web-tools
# block. Commits.
extend_fixture_peer() { # $1 = fixture template repo
  local t="$1" d="$1/template"
  grep -q '^DATA_STORE:' "$SA_ROOT/copier.yml" && [[ -f "$SA_ROOT/template/$SA_DATAROOT_PY" ]] || return 0
  cp "$SA_ROOT/template/$SA_DATAROOT_PY" "$d/$SA_DATAROOT_PY" && cp "$SA_ROOT/template/$SA_DATAROOT_MAP" "$d/$SA_DATAROOT_MAP" || return 1
  { printf '# 06 — global rules\n\n## 13. Web and code tools\n\n'
    rwt_block "$SA_ROOT/template/.claude/rules/syntek-author/06-global-rules.md"; } > "$d/.claude/rules/syntek-author/06-global-rules.md"
  # The questions: the whole block replaces the fixture's agent questions (a copier.yml without
  # the block gives its data-root questions, appended); the per-client gates open _exclude.
  python3 - "$t/copier.yml" "$SA_ANSWERS_FILE" "$SA_PEER_ANSWERS_FILE" <(shared_questions "$SA_ROOT/copier.yml") \
    <(client_gates "$SA_ROOT/copier.yml") <<'PY' || return 1
import sys
path, prev, peer, block, gates = sys.argv[1:]
lines = open(path, encoding="utf-8").read().split("\n")
block = open(block, encoding="utf-8").read().rstrip("\n").split("\n")
gates = [g for g in open(gates, encoding="utf-8").read().split("\n") if g]
i = lines.index("  prev: " + prev)
lines.insert(i + 1, "  peer: " + peer)
i = lines.index("_exclude:")
lines[i + 1:i + 1] = gates
if "AGENT_CLIENTS:" in block:
    b, e = lines.index("# BEGIN fixture agent questions"), lines.index("# END fixture agent questions")
    lines[b:e + 1] = block
else:
    lines += [""] + block
open(path, "w", encoding="utf-8").write("\n".join(lines))
PY
  # The after-update message that reports a store the sibling records differently.
  awk '/^_message_after_update:/ { on = 1; print; next } on && /^[^ ]/ { on = 0 } on { print }' "$SA_ROOT/copier.yml" >> "$t/copier.yml"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture: the data root and the rules-web-tools block'
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/fixture" >/dev/null
  # The real update script, block and task, and a shared skill and hook (checks 11–13), with the
  # real MCP lane (D54: checks 9 and 18–20).
  sa_add_update "$tmp/fixture" syntek-author ".claude/skills/wait-what/SKILL.md .claude/hooks/context-threshold-handoff.sh" mcp \
    || die "could not give the fixture the update script"
  extend_fixture_peer "$tmp/fixture" || die "could not give the fixture the data-root questions and the resolver"
  extend_fixture_howto "$tmp/fixture" || die "could not give the fixture the user guide"
  extend_fixture_learning "$tmp/fixture" || die "could not give the fixture the learning/ pair"
  # The fixture's settings.json wires the hook its family-refresh.json offers, as the real seed does.
  python3 - "$tmp/fixture/template/.claude/settings.json" "$tmp/fixture/migrations/family-refresh.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
d["hooks"] = json.load(open(sys.argv[2], encoding="utf-8"))["settings"]["hooks"]
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
  sa_git "$tmp/fixture" add -A && sa_git "$tmp/fixture" commit -q -m 'fixture: the update script'
  # A family-shared manifest for the fixture (check 10): its token-free entrypoint, its link
  # and its MCP file, as family-shared.sh --write records them.
  python3 - "$tmp/fixture" "$RWT_BEGIN" "$RWT_END" <<'PY'
import hashlib, json, sys
root = sys.argv[1]
def f(p):
    b = open(f"{root}/template/{p}", "rb").read()
    return {"path": p, "source": f"template/{p}", "kind": "file", "bytes": len(b), "sha256": hashlib.sha256(b).hexdigest()}
files = [f(".agents/mcp_config.json"),
         {"path": ".agents/skills", "source": "template/.agents/skills", "kind": "symlink", "target": "../.claude/skills"},
         f("AGENTS.md"), f(".claude/skills/wait-what/SKILL.md"), f(".claude/hooks/context-threshold-handoff.sh"),
         f(".claude/hooks/how-to-read-only.sh"), f("how-to/CONTEXT.md"), f("how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md")]
# The resolver under every template's name (D50), and the rules-web-tools block (D54, check 21).
r = f(".claude/syntek-author-dataroot.py"); r["path"] = ".claude/syntek-<template>-dataroot.py"
files.append(r)
rules = "template/.claude/rules/syntek-author/06-global-rules.md"
lines = open(f"{root}/{rules}", encoding="utf-8").read().splitlines()
b, e = lines.index(sys.argv[2]), lines.index(sys.argv[3])
body = "".join(l + "\n" for l in lines[b + 1:e]).encode()
blocks = [{"name": "rules-web-tools", "source": rules, "destination": ".claude/rules/<template>/06-global-rules.md",
           "begin": sys.argv[2], "end": sys.argv[3], "bytes": len(body), "sha256": hashlib.sha256(body).hexdigest()}]
json.dump({"format": 1, "owner": "syntek-author", "release": "unreleased", "files": files, "blocks": blocks},
          open(f"{root}/family-shared.json", "w"), indent=2)
PY
  run_flow "$tmp/fixture" "$tmp"
  st_baseline "the fixture template sharing a project with a dummy second template, both orders"

  B_COPY=1;   probe "check 1 fires when the second template collides" "check 1"; B_COPY=0
  mv "$PROJ/$B_ANSWERS" "$tmp/h"; probe "check 2 fires when an answers file is missing" "check 2"; mv "$tmp/h" "$PROJ/$B_ANSWERS"
  A_UPDATE=1; probe "check 3 fires when syntek-author's update fails" "check 3"; A_UPDATE=0
  cp "$PROJ/$B_RULE" "$tmp/h"; grep -vF "$B_MARK" "$tmp/h" > "$PROJ/$B_RULE"
  probe "check 4 fires when the second template's change is lost" "check 4"; cp "$tmp/h" "$PROJ/$B_RULE"
  mv "$PROJ/$B_RULE" "$tmp/h"; probe "check 5 fires when one template's file vanishes" "check 5"; mv "$tmp/h" "$PROJ/$B_RULE"
  A_OWNED+=("README.md"); probe "check 6 fires on a root file syntek-author owns" "check 6 — README.md"; unset 'A_OWNED[-1]'
  printf 'x\n' > "$PROJ/CONTEXT.md.rej"; probe "check 7 fires on a rejected hunk" "check 7"; rm -f "$PROJ/CONTEXT.md.rej"
  printf '# yours\n' > "$PROJ/AGENTS.md"; A_KEPT[AGENTS.md]="not-this"
  probe "check 8 fires when a copy-only file was overwritten" "check 8 — the copy-only AGENTS.md"; unset 'A_KEPT[AGENTS.md]'; rm -f "$PROJ/AGENTS.md"
  MF_A_COPY=1; probe "check 9 fires when the copy over media's .agents/ fails" "check 9 — syntek-author's copy over a project"; MF_A_COPY=0
  cp "$MF/.agents/mcp_config.json" "$tmp/h"; printf '%s' "$SA_MEDIA04_AGENTS_MCP" > "$MF/.agents/mcp_config.json"
  probe "check 9 fires when media's 23 bytes are left without the servers" "check 9 — after both copies .agents/mcp_config.json is not exactly the shared bytes"
  cp "$tmp/h" "$MF/.agents/mcp_config.json"
  mv "$MF/$B_BRIDGE" "$tmp/h"
  probe "check 9 fires when a bridge is missing after both copies" "check 9 — after both copies the project does not hold both bridges"
  mv "$tmp/h" "$MF/$B_BRIDGE"
  cp "$MF/AGENTS.md" "$tmp/h"; printf 'x\n' >> "$MF/AGENTS.md"
  probe "check 10 fires when a vendored shared file differs from the manifest" "check 10 — AGENTS.md in the media-first project"
  cp "$tmp/h" "$MF/AGENTS.md"
  local held_ref; held_ref="$(git -C "$PROJ" rev-parse refs/dummy-media/yours)"
  git -C "$PROJ" update-ref -d refs/dummy-media/yours
  probe "check 11 fires when a template's record is missing" "check 11 — after both copies and both updates the project has no refs/dummy-media/yours"
  git -C "$PROJ" update-ref refs/dummy-media/yours "$held_ref"
  cp "$PROJ/$SH_FILE" "$tmp/h"; printf '%s\n' "$SH_MARK_B" > "$PROJ/$SH_FILE"
  probe "check 12 fires when the dummy's update replaced syntek-author's revision" "check 12 — the shared $SH_FILE does not hold"
  cp "$tmp/h" "$PROJ/$SH_FILE"
  cp "$B_LOG" "$tmp/h"; grep -vxF "    $SH_FILE" "$tmp/h" > "$B_LOG"
  probe "check 12 fires when the sibling attribution is missing" "check 12 — the dummy's report lists"; cp "$tmp/h" "$B_LOG"
  cp "$A_LOG" "$tmp/h"; printf '▸ syntek-author update report, 1 → 2\n  NOT UPDATED because you had changed them (1):\n    media/CONTEXT.md\n' >> "$A_LOG"
  probe "check 13 fires when a report lists the other template's file" "check 13 — syntek-author's report lists media/CONTEXT.md"; cp "$tmp/h" "$A_LOG"
  local held
  held="${D48[author-first.a_report]}"; D48[author-first.a_report]=0
  probe "check 14 fires when the update beside a D48-only sibling prints no report" "check 14 — [D48-only sibling, author-first] syntek-author's update failed"
  D48[author-first.a_report]="$held"
  D48[d48-first.a_refreshed]=false
  probe "check 14 fires when the shared skill is not refreshed beside a D48-only sibling" "check 14 — [D48-only sibling, d48-first] syntek-author's update did not refresh"
  D48[d48-first.a_refreshed]=true
  held="${D48[d48-first.copied]}"; D48[d48-first.copied]="UserPromptSubmit  context-threshold-handoff.sh wired 0 time(s)"
  probe "check 15 fires when the copy over the sibling's settings.json does not wire the hooks" "check 15"; D48[d48-first.copied]="$held"
  held="${D48[d48-first.b_hooks]}"; D48[d48-first.b_hooks]="UserPromptSubmit  context-threshold-handoff.sh wired 2 time(s)"
  probe "check 16 fires when the sibling's adoption duplicates a hook" "check 16 — [D48-only sibling, d48-first] after the sibling adopted"; D48[d48-first.b_hooks]="$held"
  # The judge itself: a top-level value written twice, missing, or another value, is named.
  printf '{"settings": {"autoCompactEnabled": false, "idleCompaction": false}}\n' > "$tmp/rf.json"
  local judged=""
  printf '{\n  "autoCompactEnabled": false,\n  "autoCompactEnabled": false,\n  "idleCompaction": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == "autoCompactEnabled written 2 time(s)"* ]] || judged+=" twice"
  printf '{\n  "model": "opus"\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == "autoCompactEnabled written 0 time(s)"* ]] || judged+=" missing"
  printf '{\n  "autoCompactEnabled": true,\n  "idleCompaction": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == *"value true"* ]] || judged+=" true"
  printf '{\n  "autoCompactEnabled": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == "idleCompaction written 0 time(s)"* ]] || judged+=" idle-missing"
  printf '{\n  "autoCompactEnabled": false,\n  "idleCompaction": false\n}\n' > "$tmp/st.json"
  [[ "$(hooks_once "$tmp/st.json" "$tmp/rf.json")" == ok ]] || judged+=" once"
  if [[ -n "$judged" ]]; then
    printf '\033[31m  ✗ hooks_once misjudges a top-level value:%s\033[0m\n' "$judged" >&2; exit 2
  fi
  held="${D48[author-first.b_refs]}"; D48[author-first.b_refs]=""
  probe "check 16 fires when the sibling keeps no record" "check 16 — [D48-only sibling, author-first] after the sibling adopted the shared set its refs"; D48[author-first.b_refs]="$held"
  D48[author-first.b_conflicts]="README.md.rej"
  probe "check 16 fires when the sibling's update leaves a conflict" "check 16 — [D48-only sibling, author-first] the sibling's update left"; D48[author-first.b_conflicts]=""
  D48[d48-first.b_mode]="in syntek-author's record"
  probe "check 17 fires when the sibling's MEDIA-* mode file is counted as syntek-author's" "check 17"; D48[d48-first.b_mode]=ok
  if $PEER_RAN; then
    local pa="$PEER_W/author-first" pm="$PEER_W/media-first" held_v f
    # 18: a server missing from a file, a server written twice, and a conflict left behind.
    cp "$pm/.mcp.json" "$tmp/h"
    python3 -c 'import json, sys; d = json.load(open(sys.argv[1])); del d["mcpServers"]["scrapling"]; open(sys.argv[1], "w").write(json.dumps(d, indent=2) + "\n")' "$pm/.mcp.json"
    probe "check 18 fires when a server is missing from an MCP file" "check 18 — [media-first] after both copies and both updates: .mcp.json declares scrapling 0 time(s)"
    sed 's/"mcpServers": {/"mcpServers": {"scrapling": {}, /' "$tmp/h" > "$pm/.mcp.json"
    probe "check 18 fires when a server is written twice" "check 18 — [media-first] after both copies and both updates: .mcp.json declares scrapling 2 time(s)"
    cp "$tmp/h" "$pm/.mcp.json"
    printf 'x\n' > "$pa/.mcp.json.rej"; probe "check 18 fires on a conflict left in the peer project" "check 18 — [author-first] a conflict is left"; rm -f "$pa/.mcp.json.rej"
    # 19: the second template's report speaks of the servers.
    f="${PEER[media-first.logs]%% *}"; cp "$f" "$tmp/h"
    printf '▸ syntek-author: added 2 MCP servers to .mcp.json: code-review-graph, scrapling\n' >> "$f"
    probe "check 19 fires when the second template adds the servers again" "check 19 — [media-first] media-first-2-copy.log speaks of the MCP servers"; cp "$tmp/h" "$f"
    # 20: the older pin replaced, and its attribution missing.
    f="${PEER[oldpin.files]%% *}"; cp "$PEER_W/oldpin/$f" "$tmp/h"
    sed "s/$PEER_PIN_OLD/${SA_MCP_PINS%% *}/" "$tmp/h" > "$PEER_W/oldpin/$f"
    probe "check 20 fires when the sibling's older pin is replaced" "check 20 — $f no longer holds"; cp "$tmp/h" "$PEER_W/oldpin/$f"
    cp "$PEER_W/oldpin-2-copy.log" "$tmp/h"; grep -vF "$f holds $PEER_NAME's version" "$tmp/h" > "$PEER_W/oldpin-2-copy.log" || true
    probe "check 20 fires when the older pin is not attributed to the sibling" "check 20 — syntek-author's copy did not attribute $f"; cp "$tmp/h" "$PEER_W/oldpin-2-copy.log"
    # 21: a byte of the sibling's block, and a marker written twice.
    f="$pa/.claude/rules/$PEER_NAME/06-global-rules.md"; cp "$f" "$tmp/h"
    sed '0,/^- \*\*/s//- **Changed./' "$tmp/h" > "$f"
    probe "check 21 fires when a rules file's block differs from the manifest" "check 21 — [author-first] .claude/rules/$PEER_NAME/06-global-rules.md: the rules-web-tools block is not the manifest's (sha256 is"
    { cat "$tmp/h"; printf '%s\n' "$RWT_END"; } > "$f"
    probe "check 21 fires when a marker is there twice" "its markers are not each there once"; cp "$tmp/h" "$f"
    # 22: the second template did not inherit.
    held_v="${PEER[media-first.layout_author]}"; PEER[media-first.layout_author]="external|business|media-first|docs|photos|audio|videos"
    probe "check 22 fires when the second template does not take the first's layout" "check 22 — [media-first] the records hold"; PEER[media-first.layout_author]="$held_v"
    # 23: another first slug accepted, and an answers file written by the refused copy.
    PEER[author-first.refused]=0; probe "check 23 fires when another first slug is accepted" "check 23 — [author-first]"; PEER[author-first.refused]=1
    PEER[media-first.refused_wrote]=true; probe "check 23 fires when the refused copy recorded answers" "check 23 — [media-first]"; PEER[media-first.refused_wrote]=false
    # 24: the after-update line missing, and the other's update failing.
    PEER[store.line]=false; probe "check 24 fires when the store change is not reported" "check 24 — syntek-author's update"; PEER[store.line]=true
    held_v="${PEER[store.b_update]:-0}"; PEER[store.b_update]=1
    probe "check 24 fires when the other's update to the same store fails" "check 24 — the sibling's update"; PEER[store.b_update]="$held_v"
    # 26 and 27: a sibling record without DATA_STORE.
    if $PY_DR; then
      held_v="${PEER[pre.path]}"; PEER[pre.path]="2 1 1 1"
      probe "check 26 fires when a record not yet asked is refused" "check 26"; PEER[pre.path]="$held_v"
    fi
    cp "$PEER_W/pre/$SA_ANSWERS_FILE" "$tmp/h"; sed 's/^DATA_STORE: repo$/DATA_STORE: external/' "$tmp/h" > "$PEER_W/pre/$SA_ANSWERS_FILE"
    probe "check 27 fires when a copy beside a pre-data-root record records external" "check 27"; cp "$tmp/h" "$PEER_W/pre/$SA_ANSWERS_FILE"
    # 28: the resolvers differ.
    f="$pm/.claude/syntek-${PEER_NAME#syntek-}-dataroot.py"; cp "$f" "$tmp/h"; printf '\n' >> "$f"
    probe "check 28 fires when the two resolvers differ" "check 28 — [media-first]"; cp "$tmp/h" "$f"
    if $PY_DR; then
      # 25, 29 and 30: what the resolvers printed.
      held_v="${PEER[store.refuse_media]}"; PEER[store.refuse_media]=0
      probe "check 25 fires when a resolver acts while the stores disagree" "check 25"; PEER[store.refuse_media]="$held_v"
      held_v="${PEER[author-first.pm_media]}"; PEER[author-first.pm_media]="0 $PEER_ROOT/$PEER_AREA/docs/$PEER_SLUG/media/src/cue-sheet.pdf"
      probe "check 29 fires when a resolver does not read the other template's map" "check 29 — [author-first] path media/src/cue-sheet.pdf"; PEER[author-first.pm_media]="$held_v"
      held_v="${PEER[media-first.root_media]}"; PEER[media-first.root_media]="$held_v x"
      probe "check 29 fires when the two root reports differ" "check 29 — [media-first] the two resolvers' root reports differ"; PEER[media-first.root_media]="$held_v"
      held_v="${PEER[author-first.provider_warn]}"; PEER[author-first.provider_warn]=0
      probe "check 30 fires when a provider difference is not warned" "check 30"; PEER[author-first.provider_warn]="$held_v"
      # 31–36: the manifest role rules with both maps present.
      held_v="${PEER[own.force_author_take]}"; PEER[own.force_author_take]="0 0"
      probe "check 31 fires when add --force supersedes an evidence row of a sibling map role" "check 31 — add --force on an evidence row of the sibling map's roles was not refused"
      PEER[own.force_author_take]="$held_v"
      held_v="${PEER[own.rows]}"; PEER[own.rows]="${held_v/ take true;/ take false;}"
      probe "check 31 fires when a sibling map role's row records evidence false" "check 31 — the rows filed under the sibling map's roles"; PEER[own.rows]="$held_v"
      held_v="${PEER[differ.add]}"; PEER[differ.add]="${held_v% true;} false;"
      probe "check 32 fires when a role the maps define differently is not filed as evidence" "check 32 — with '$PEER_COMMIT_ROLE' evidence"; PEER[differ.add]="$held_v"
      held_v="${PEER[differ.status_media]}"; PEER[differ.status_media]="0 0"
      probe "check 32 fires when status does not report a role the maps define differently" "check 32 — status gave"; PEER[differ.status_media]="$held_v"
      held_v="${PEER[newer.add]}"; PEER[newer.add]=2
      probe "check 33 fires when a sibling's newer map refuses syntek-author's add" "check 33 — with the sibling's map at format 2, syntek-author's add"; PEER[newer.add]="$held_v"
      held_v="${PEER[broken.verify_author]}"; PEER[broken.verify_author]="2 1"
      probe "check 33 fires when an unparseable sibling map stops verify" "check 33 — with the sibling's map unparseable"; PEER[broken.verify_author]="$held_v"
      held_v="${PEER[skip.wrote]}"; PEER[skip.wrote]=something
      probe "check 34 fires when a \"repo\": \"skip\" role writes under repo" "check 34 — under repo, add with the sibling's"; PEER[skip.wrote]="$held_v"
      held_v="${PEER[work.status_media]}"; PEER[work.status_media]="1 1 1 1"
      probe "check 35 fires when status lists a file in the working-output folder" "check 35 — a file under the sibling's $PEER_RENDERS"; PEER[work.status_media]="$held_v"
      held_v="${PEER[name.videos_author]}"; PEER[name.videos_author]="0 0"
      probe "check 36 fires when a map role named after a kind is accepted" "check 36 — a sibling map role named after a shared role or a kind did not"
      PEER[name.videos_author]="$held_v"
    fi
    if $CL_RAN; then
      # 43–50: one set of agent clients and models. Each mutation leaves a record as a block
      # that ignores the other template's record would write it, or a file it would let in.
      f="$PEER_W/clients-author-first/$SA_PEER_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed 's/^- codex$/- codex\n- gemini-cli\n- antigravity\n- opencode/' "$tmp/h" > "$f"
      probe "check 43 fires when the second template does not take the first's clients" "check 43 — the records hold"; cp "$tmp/h" "$f"
      printf '# GEMINI.md\n' > "$PEER_W/clients-author-first/GEMINI.md"
      probe "check 43 fires when the second template writes a client file the first left out" "check 43 — beside a Codex-only syntek-author the project holds GEMINI.md"
      rm -f "$PEER_W/clients-author-first/GEMINI.md"
      f="$PEER_W/clients-media-first/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      grep -v '^OPENCODE_' "$tmp/h" > "$f"; printf 'OPENCODE_PROVIDER: user\n' >> "$f"
      probe "check 44 fires when syntek-author does not take the sibling's OpenCode answers" "check 44 — syntek-author records"; cp "$tmp/h" "$f"
      mkdir -p "$PEER_W/clients-media-first/.codex"
      probe "check 44 fires when syntek-author writes a client file the sibling left out" "check 44 — beside an OpenCode-only sibling the project holds .codex"
      rm -rf "$PEER_W/clients-media-first/.codex"
      f="$PEER_W/clients-media-first/$CL_RULES"; cp "$f" "$tmp/h"; grep -v '^| OpenCode |' "$tmp/h" > "$f" || true
      probe "check 44 fires when rules 05's model table does not name the sibling's model" "check 44 — $CL_RULES's model table"; cp "$tmp/h" "$f"
      f="$PEER_W/clients-media-first/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed 's|^OPENCODE_BASE_URL: .*|OPENCODE_BASE_URL: http://127.0.0.1:11434/v1|' "$tmp/h" > "$f"
      probe "check 44 fires when syntek-author takes its provider's own address, not the sibling's" "check 44 — syntek-author records"; cp "$tmp/h" "$f"
      held_v="${PEER[cl45.copy]:-0}"; PEER[cl45.copy]=1
      probe "check 45 fires when a value not offered reaches choices and stops the copy" "check 45 — beside a sibling record holding"; PEER[cl45.copy]="$held_v"
      f="$PEER_W/clients-future/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed "s/^- codex\$/- codex\n- $CL_FUTURE_CLIENT/" "$tmp/h" > "$f"
      probe "check 45 fires when a client not offered is recorded" "check 45 — beside a sibling record holding [codex, $CL_FUTURE_CLIENT] and OPENCODE_PROVIDER $CL_FUTURE_PROVIDER, syntek-author records"
      cp "$tmp/h" "$f"
      f="$PEER_W/clients-first-update/$SA_ANSWERS_FILE"
      if [[ -f "$f" ]]; then
        cp "$f" "$tmp/h"; strip_agent_answers "$f"; printf 'AGENT_CLIENTS: []\n' >> "$f"
        probe "check 46 fires when the update that first asks AGENT_CLIENTS records none beside a sibling's clients" "check 46"; cp "$tmp/h" "$f"
      else
        ST_FAILS=$((ST_FAILS + 1)); printf '\033[31m  ✗ self-test: the fixture ran no check 46 update\033[0m\n' >&2
      fi
      held_v="${PEER[cl47.nomodel]:-0}"; PEER[cl47.nomodel]=0
      probe "check 47 fires when a changed provider's copy without a model succeeds" "check 47 — beside a sibling record at $CL_OC_PROVIDER naming"
      PEER[cl47.nomodel]="$held_v"
      f="$PEER_W/clients-provider/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed "s|^OPENCODE_BASE_URL: .*|OPENCODE_BASE_URL: $CL_OC_URL|" "$tmp/h" > "$f"
      probe "check 47 fires when a changed provider inherits the sibling's address" "check 47 — beside a sibling record at $CL_OC_PROVIDER ($CL_OC_URL"
      cp "$tmp/h" "$f"
      f="$PEER_W/clients-own-first/$SA_ANSWERS_FILE"
      if [[ -f "$f" ]]; then
        cp "$f" "$tmp/h"; sed "s|^CODEX_MODEL: .*|CODEX_MODEL: $CL_SIB_MODEL|" "$tmp/h" > "$f"
        probe "check 48 fires when the sibling's record wins over the template's own" "check 48 — a copy over a project"; cp "$tmp/h" "$f"
      else
        ST_FAILS=$((ST_FAILS + 1)); printf '\033[31m  ✗ self-test: the fixture ran no check 48 copy\033[0m\n' >&2
      fi
      f="$PEER_W/clients-none/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed 's/^AGENT_CLIENTS: \[\]$/AGENT_CLIENTS:\n- codex\n- gemini-cli\n- antigravity\n- opencode/' "$tmp/h" > "$f"
      probe "check 49 fires when an empty sibling list is skipped" "check 49 — beside a sibling record holding AGENT_CLIENTS [], syntek-author records"
      cp "$tmp/h" "$f"
      printf '# AGENTS.md\n' > "$PEER_W/clients-none/AGENTS.md"
      probe "check 49 fires when a client file is written beside a sibling that chose none" "check 49 — beside a sibling record holding AGENT_CLIENTS [], the project holds AGENTS.md"
      rm -f "$PEER_W/clients-none/AGENTS.md"
      f="$PEER_W/clients-provider/$SA_ANSWERS_FILE"; cp "$f" "$tmp/h"
      sed "s|^GEMINI_MODEL: .*|GEMINI_MODEL: ''|" "$tmp/h" > "$f"
      probe "check 50 fires when GEMINI_MODEL ignores the sibling's record" "check 50"; cp "$tmp/h" "$f"
    else
      ST_FAILS=$((ST_FAILS + 1)); printf '\033[31m  ✗ self-test: the fixture ran no clients flow (checks 43–50)\033[0m\n' >&2
    fi
  fi
  # 37–42: the user guide shared by both (D56).
  cp "$PROJ/how-to/CONTEXT.md" "$tmp/h"; printf 'x\n' >> "$PROJ/how-to/CONTEXT.md"
  probe "check 37 fires when a shared how-to file does not hold the manifest's bytes" "check 37 — [author-first] after both copies and both updates: how-to/CONTEXT.md does not hold"
  cp "$tmp/h" "$PROJ/how-to/CONTEXT.md"
  if $HT_RAN; then
    cp "$HT_W/38a.log" "$tmp/h"; grep -vF "$HT_SIB_WHY" "$tmp/h" > "$HT_W/38a.log" || true
    probe "check 38 fires when the sibling's revision is not attributed" "check 38 — syntek-author's report does not list"; cp "$tmp/h" "$HT_W/38a.log"
    cp "$HT_W/39.log" "$tmp/h"
    python3 - "$HT_W/39.log" "$HT_NEW" "$HT_SHARED_CH" <<'PY'
import sys
p, title, path = sys.argv[1:]
lines = open(p, encoding="utf-8").read().split("\n")
i = max(i for i, l in enumerate(lines) if l.startswith("▸ syntek-author update report"))
lines[i + 1:i + 1] = ["", f"  {title} and you already had a file there (1):", f"    {path}"]
open(p, "w", encoding="utf-8").write("\n".join(lines))
PY
    probe "check 39 fires when the crossing lists the sibling's revision as new" "check 39 — the crossing lists the sibling's revision"; cp "$tmp/h" "$HT_W/39.log"
    held="${HT[40_unscoped]}"; HT[40_unscoped]=seen
    probe "check 40 fires when make lint reads how-to/src without a SCOPE" "check 40 — make lint without a SCOPE reported the line"; HT[40_unscoped]="$held"
    held="${HT[41_ctx]}"; HT[41_ctx]=none
    probe "check 41 fires when the owner's edit to a shared how-to file is not restored" "check 41 — syntek-author's update did not put"; HT[41_ctx]="$held"
    cp "$HT_W/42a.log" "$tmp/h"; grep -vF "$HT_CLONE_WHY" "$tmp/h" > "$HT_W/42a.log" || true
    probe "check 42 fires when a plain clone's report does not say it holds no record" "check 42 — in a clone without the sibling's record, the report does not say"; cp "$tmp/h" "$HT_W/42a.log"
  else
    finding "self-test: the fixture ran no D56 flow (checks 38–42)"
  fi
  # 51–52: lessons in learning/ with two templates (D57).
  local ln_f="$PROJ/learning/syntek-author/a-topic/MISSION.md"
  cp "$ln_f" "$tmp/h"; sed -i '1s/^#/=/' "$ln_f"
  probe "check 51 fires when a lesson in a template's folder changes by one byte" "check 51 — [author-first] after both copies and both updates: learning/syntek-author/a-topic/MISSION.md is not byte for byte"
  cp "$tmp/h" "$ln_f"
  cp "$PROJ/learning/CLAUDE.md" "$tmp/h"; printf 'x\n' >> "$PROJ/learning/CLAUDE.md"
  probe "check 52 fires when the learning/ pair is not syntek-author's render" "check 52 — [author-first] after both copies and both updates: learning/CLAUDE.md does not hold"
  cp "$tmp/h" "$PROJ/learning/CLAUDE.md"
  st_finish "templates that coexist from templates that collide"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
copier_init
bold "▸ $SCRIPT_NAME"
work="$(sa_mktemp)"
run_flow "$SA_ROOT" "$work"
run_checks
for n in "${NOTES[@]}"; do log "  - $n"; done
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  log "  ✓ both templates applied, both updated, ${#A_OWNED[@]} syntek-author-owned file(s) and ${#B_OWNED[@]} second-template-owned file(s) disjoint"
  log "  ✓ media first: syntek-author's copy over media 0.4.x's .agents/ succeeded with no --exclude, its baseline gave the 23 bytes the two MCP servers; the family-shared files carry the manifest's bytes"
  log "  ✓ each template keeps its own render record in both orders; a shared skill refreshed by syntek-author keeps its bytes through the dummy's update, which attributes it; each report lists only its own files"
  $PEER_RAN && log "  ✓ a sibling at this release, both orders: the second takes the first's store, area, slug and kinds and refuses another slug; each MCP server once in every MCP file, the second report silent, an older sibling pin kept and attributed; the rules-web-tools blocks, the resolvers' bytes, roots and paths the same; a store change reported, refused meanwhile, never a deadlock; a pre-data-root sibling gives repo and one warning; a provider difference only warns"
  $CL_RAN && log "  ✓ one set of agent clients and models: the second template takes the first's clients and models in both orders (Gemini CLI's model and the OpenCode address included) and writes no client file the first left out, a sibling's empty list included; a sibling's value this release does not offer is filtered; a changed provider inherits none of the sibling's OpenCode answers; the template's own record comes first; and the update that first asks the clients takes the sibling's"
  $PEER_RAN && $PY_DR && log "  ✓ the manifest role rules with both maps: the sibling map's evidence roles filed and add --force refused on them, a role the maps define differently treated as evidence and reported, a newer or unparseable sibling map refusing only its own folders, a \"repo\": \"skip\" role writing nothing under repo, working output never listed, a map role named after a shared role or a kind refused"
  $HT_RAN && log "  ✓ the user guide: each shared how-to file once with the manifest's bytes in both orders; a sibling's revision kept, attributed and never written over while it stands unchanged, also in a plain clone and on the crossing; make lint and make flags clean with SCOPE=how-to/src and blind to it without; an owner's edit to a shared how-to file restored by one template and left quiet by the other; the guard wired once"
  log "  ✓ lessons in learning/, at the top and in each template's folder, kept byte for byte through both copies and, author first, both updates, and named in no report; the learning/ pair syntek-author's render, and nothing under learning/ in the sibling's record"
  $D48_RAN && log "  ✓ a sibling at the D48 set only, in both orders: syntek-author's report and refresh work beside it, its copy wires the hooks once into the sibling's settings.json, and the sibling's later adoption of the shared set converges (its own refs, no conflict, no hook twice, its MEDIA-* mode file its own)"
  rm -rf "$work"
  bold "✓ A second template shares the project cleanly."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s) (work kept in $work; output in $work/flow.log):"
print_findings
log ""
log "  DESIGN.md Section 9: own answers file, own rules folder, shared root files seeded in both,"
log "  agent entrypoints and client settings copy-only in both (D47), family-shared bytes (D48),"
log "  one data-root layout and one manifest format (D50) and each MCP server once (D54)."
exit 1
