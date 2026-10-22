#!/usr/bin/env bash
#
# update-test.sh — Prove `copier update` keeps the author's work and delivers the template's.
#
#                  A generated project lives for years and takes template improvements by
#                  `copier update`. Each ownership class (DESIGN.md D14) is a promise about
#                  what an update does: a seed the author edited is kept, and one they deleted
#                  comes back; a seed-once example they deleted stays deleted; their own files
#                  are never touched; a template-owned file takes the new version. Every one of
#                  those promises rests on a line in copier.yml, and none of them fails loudly
#                  when the line is wrong — the update reports success either way. So this test
#                  performs a real update, the way an author would meet it:
#
#                    1. snapshot the working tree as a template and render a project from it;
#                    2. act as the author: add a MEMORY.md entry, add a style-sheet rule,
#                       delete the seed-once example, delete voice-notes.md, write a unit of
#                       their own; commit;
#                    3. change a template-owned skill in the template; commit;
#                    4. `copier update` (naming the answers file, which is not Copier's default);
#                    5. commit, clone the project, and in the clone try an update that changes
#                       DOC_TYPE, which the template must refuse (DESIGN.md D35);
#                    6. assert.
#
#                  For business it then proves the v0.2.0 migration (DESIGN.md D44) on a real
#                  upgrade: the repository is cloned with its tags, the working tree is
#                  committed on top and tagged with VERSION, a project is rendered at the
#                  v0.1.0 tag, the author plants a file in every v0.1.0 family folder (plus one
#                  whose destination they already used), and `copier update` runs to the tagged
#                  tree — so Copier itself decides that the migration applies. For each book
#                  variant it proves the every-variant settings migration the same way: a
#                  project rendered at v0.1.0, whose author kept the brief current where v0.1.0
#                  said to (the audience and the reader test in .claude/CLAUDE.md Section 1),
#                  crosses v0.2.0 re-answering the reader test on the way (--data), and the new
#                  seed 00-project.md must carry the hand-edited audience, not the old answer,
#                  and the reader test answered during the update, not the older hand edit.
#
#                  Twelve checks per DOC_TYPE (and 24–28 below), six more for business, and six more for each
#                  book variant:
#                    1. The project renders.
#                    2. `copier update` succeeds.
#                    3. The author's MEMORY.md entry survives.
#                    4. The author's style-sheet rule survives.
#                    5. The deleted example stays deleted.
#                    6. The deleted voice-notes.md comes back (skills cite it).
#                    7. The author's own unit is byte-for-byte untouched.
#                    8. The template-owned skill carries the template's change.
#                    9. No conflict is left behind (no *.rej file, no conflict marker).
#                   10. An update that changes DOC_TYPE is refused, by DOC_TYPE's own validator
#                       (D35), not by some other failure such as a dirty tree.
#                   11. The refused update touched nothing: the clone's work tree is clean and
#                       its answers file still records the original DOC_TYPE.
#                   12. The update printed the option-off warning (_message_before_update),
#                       naming every INCLUDE_* option, DATA_PROVIDER (D53), DATA_STORE=repo
#                       (D50: the off value of the store deletes the data-root ignore files)
#                       and BUSINESS_FAMILIES — the only warning an author gets before an
#                       option turned off deletes the seeds they filled in.
#                   13. Business: the update from v0.1.0 to the tree tagged VERSION succeeds,
#                       and the v0.2.0 migration runs.
#                   14. Every author file planted in a v0.1.0 family folder, and the kept
#                       example proposal, is at its D44 destination, byte for byte.
#                   15. Nothing is lost: every planted file's bytes are still in the project,
#                       the collision's two files included.
#                   16. The migration names the file it could not move (the collision):
#                       nothing is left behind silently.
#                   17. A second run of the migration exits 0 and changes nothing.
#                   18. With msp-scp chosen, policies/ goes to msp-scp/ (a hand run of the
#                       script in a scratch project, no Copier).
#                   19. Books: the update from v0.1.0 to the tree tagged VERSION succeeds, and
#                       the v0.2.0 project-settings migration runs.
#                   20. The audience the author changed in .claude/CLAUDE.md Section 1 is the
#                       audience in 00-project.md ## Brief (D40), not the recorded answer.
#                   21. A second run of the settings migration exits 0 and changes nothing.
#                   22. The reader test the author answered again during the update itself is
#                       the reader test in 00-project.md ## Brief: the older hand edit in
#                       .claude/CLAUDE.md Section 1 never overwrites a fresh answer (D44).
#                   23. The migration reported that older hand edit as a conflict, naming
#                       .claude/CLAUDE.md:<line> and its value, so the author can reconcile it.
#
#                  Copy-only agent files (DESIGN.md D47, Section 3.6), in every DOC_TYPE: the
#                  author edits AGENTS.md and deletes GEMINI.md and .codex/config.toml; the
#                  template changes AGENTS.md, opencode.json and the bridge; the update answers
#                  OPENCODE_PROVIDER named and OPENCODE_MODEL anew.
#                   24. The author's edit to AGENTS.md survives, and the template's change to it
#                       never arrives: an update never renders a copy-only file.
#                   25. The deleted GEMINI.md and .codex/config.toml stay deleted.
#                   26. .agents is still a real folder, and .agents/skills still a link to
#                       exactly ../.claude/skills (never a copy, and never a link at .agents,
#                       which breaks Codex's Linux sandbox).
#                   27. The template's change to .claude/syntek-author-agents.md (the bridge,
#                       template-owned) arrives.
#                   28. The new OPENCODE_MODEL answer reaches the model table in rules 05, and
#                       opencode.json is byte for byte what the copy wrote.
#                   29. Books: a project generated at v0.1.0, before D47, gains none of the
#                       copy-only files from the upgrade: they arrive by a copy only.
#                   30. A fresh copy with the defaults records all four clients in
#                       AGENT_CLIENTS (codex, gemini-cli, antigravity, opencode).
#
#                  The update that first asks AGENT_CLIENTS (D47, Trap 1), in every DOC_TYPE: a
#                  project copied at the last release before D47 (v0.3.0) is updated to the
#                  working tree with --defaults, as a scripted update is.
#                   31. The update succeeds and records `AGENT_CLIENTS: []`: the default reads
#                       _external_data.prev._commit, so an existing project records no client
#                       whose files it never received.
#                   32. Rules 05 has no Section 4 (no other coding agent is named).
#                   33. The bridge .claude/syntek-author-agents.md is present: it always ships.
#                   34. No client file was created (every copy-only path, .agents, .codex/ and
#                       .gemini/).
#
#                  An emptied client list (once per run, on the first DOC_TYPE): a project copied
#                  with all four clients is updated with --data 'AGENT_CLIENTS=[]', and a clone
#                  of it with opencode removed.
#                   35. The update succeeds and deletes no file.
#                   36. The bridge is still present, and AGENTS.md and GEMINI.md are byte for
#                       byte what the copy wrote.
#                   37. Only rules 01, rules 05 and the answers file changed.
#                   38. Removing one client (opencode) drops exactly its row from rules 05 and
#                       changes nothing else but the answers file.
#                   39. A copy over a project that recorded `AGENT_CLIENTS: [codex]`, with
#                       --defaults, no AGENT_CLIENTS in the data and no -a (as adopt.sh prints
#                       it), keeps `[codex]`; with a value no longer a choice added to the
#                       record (`cursor`), it keeps only `[codex]` instead of failing.
#
#                  An .agents link to a folder OUTSIDE the project (once per run, on the first
#                  DOC_TYPE; DESIGN.md D48, Section 3.6). Copier refuses every destination
#                  beneath such a link before it reads _exclude, so the unversioned, family-shared
#                  migrations/agents-outside-link.py pair holds the link aside before the render
#                  and restores it after. A project copied with the real .agents/ has it replaced
#                  by a link to the author's own agent tree beside the project, and the template
#                  changes a rule.
#                   40. The update succeeds; .agents is the same link again, no
#                       .agents.syntek-held is left, Git sees no change to either, the restore
#                       is printed, and every file in the folder the link points to is byte for
#                       byte as it was after every run below.
#                   41. A second update, with nothing new in the template, exits 0 and changes
#                       nothing.
#                   42. A stranded hold is fixed: an update that stops between the stages (a
#                       refused DOC_TYPE change, in a clone) leaves the link held as
#                       .agents.syntek-held and prints the hand fix, whose last step is
#                       'mv .agents.syntek-held .agents' (this stop leaves .agents absent, so
#                       step 1 finds nothing there, step 2 has nothing to remove, and that mv
#                       alone runs); run as printed, the fix leaves the clone's work tree clean
#                       and the link's target unchanged; and so does the script's own restore
#                       after a hold left by hand. The script's --self-test runs the whole fix
#                       after the stops that leave .agents put back.
#                   43. The control: a real .agents/ folder whose skills link points outside the
#                       project updates with exit 0, the link untouched.
#
#                  The update report and the shared-file refresh (DESIGN.md D51, D52), once per
#                  run, on a fixture of three tagged releases carrying the real
#                  migrations/family-update.py, its _migrations block and its baseline task: a
#                  project copied at v0.1.0, worked on (one file per report section), updated to
#                  v0.2.0 and then to v0.3.0, inline and (in a copy) with --conflict rej.
#                   44. The update succeeds and prints the report, and each planted file is in
#                       its exact section: a conflict, a retired file the owner edited, an
#                       edited seed and an edited shared skill, an unedited seed changed twice
#                       (written once, on both updates), a new copy-only path where the owner
#                       had a file, a deleted example, a new example.
#                   45. With --conflict rej the conflict is reported as a rejected hunk.
#                   46. The unedited shared skill is refreshed and the new one arrives; the
#                       edited one is untouched; settings.json gains the threshold hook once,
#                       beside the owner's allow rule.
#                   47. Beyond the update's own changes (a copy updated with
#                       SYNTEK_UPDATE_REPORT=off), only those shared files, settings.json and
#                       the files the MCP lane said it wrote (D54: the fixture's third release
#                       declares the servers in .mcp.json, which the lane adds) changed.
#                   48. Every printed command runs offline, each in a fresh copy.
#                   49. A hand rerun of the update stage at the same versions changes nothing
#                       (files and refs); a second update with nothing new is one quiet line.
#                   50. The opt-out, a missing copier and a missing old version each print one
#                       line and exit 0 (hand runs in fresh clones, which hold no record).
#
#                  The real template across D51, from the v0.3.0 tag (every DOC_TYPE) and from
#                  main before D51, b4669a5 (the first DOC_TYPE), to the working tree: a shared
#                  skill (grill-me) edited first.
#                   51. The update prints its report, and every other file family-refresh.json
#                       lists is byte for byte the template's (refreshed or arrived), the hooks
#                       executable.
#                   52. The edited skill is untouched and listed under 'NOT UPDATED because you
#                       had changed them'.
#                   53. settings.json wires the context-threshold hook exactly once and keeps
#                       everything it held (add-only).
#                   54. A second update is a quiet no-op: exit 0, a clean tree, one report line.
#
#                  settings.json over the owner's own (D51), once per run, on the same fixture
#                  given a fourth release: three projects, each holding the owner's own
#                  settings.json (four-space indentation, permissions before model, an allow
#                  rule) before the copy at v0.3.0.
#                   55. A copy over it wires the template's threshold hook exactly once (the
#                       copy-time baseline), and adds the top-level "autoCompactEnabled": false
#                       family-refresh.json lists once, keeping the owner's indentation, key
#                       order and allow rule; the update to v0.4.0 leaves both there exactly
#                       once. A fifth project whose own settings.json holds autoCompactEnabled
#                       true keeps it through the copy and the update, and the copy alone
#                       prints the one line saying the handoff hooks assume false.
#                   56. A hook the copy wired and the owner then removed is not re-added by
#                       the next update: once removed after a commit, and once before any
#                       commit, so only the record lists it as offered.
#                   57. A copy with --skip-tasks records nothing; the first update adds the
#                       hook the owner's committed settings.json never held, exactly once.
#                   58. A second update is a no-op: settings.json byte for byte, a clean tree.
#                   59. The render record names no path of this machine: no tree of
#                       refs/syntek-author/template's chain holds a .copier-answers.* file, and
#                       no blob or message holds the template's or the project's absolute path,
#                       Copier's temporary clone (copier._vcs.clone) or an _src_path line (in a
#                       blob, one that starts the line, as an answers file writes it); no
#                       'mcp:' or 'written-blob:' line (D54) names a path that is absolute or
#                       leaves the project. Also judged on the real D54 project below.
#
#                  The data root, the provider and the MCP servers on real updates (DESIGN.md
#                  D50, D53, D54), on the real template: the working tree is tagged as the
#                  release its newest _migrations entry names (v0.5.0), and a later release
#                  (DT_NEXT) is made on a side branch, changing a rule and two copy-only files.
#                  Once per run, on the first DOC_TYPE: a project copied at v0.4.0 with every
#                  client, whose owner has their own server and an older Scrapling pin in a
#                  four-space .mcp.json, reformatted opencode.json with a catch-all allow and
#                  deleted .gemini/settings.json, is updated, --write run as printed, then
#                  updated to DT_NEXT and again; a copy of it, whose owner removes two servers,
#                  is updated to DT_NEXT; a project whose owner allows mcp__scrapling__*, keeps
#                  .mcp.json out of git and runs a Drive workflow of their own is updated, and
#                  so is its copy beside a sibling answers file that records external; a fresh
#                  copy with its own area and slug goes repo and back. On every DOC_TYPE, the
#                  update from v0.3.0 (checks 31–34) is judged too. For business, once: Drive
#                  projects from v0.4.0 and v0.3.0, then another provider, external, the
#                  settings trap and a sibling in both orders.
#                   60. D54: the nine rules arrive once: .claude/settings.json denies
#                       embed_graph_tool once and asks each of the eight tools once (from
#                       v0.4.0 and from v0.3.0).
#                   61. D54: .mcp.json and each existing client file declare each server once,
#                       equal to the new render's (an entry the owner already had excepted),
#                       and keep every key, value and list item they held, in order:
#                       .mcp.json, .agents/mcp_config.json and .codex/config.toml after the
#                       update, opencode.json after --write and the next one; from v0.3.0,
#                       .mcp.json.
#                   62. D54: a deleted client file stays deleted and none is created.
#                   63. D54: Codex gains its prompt tables: each server's tools tables in
#                       .codex/config.toml are the new render's.
#                   64. D54: the update prints the permissions script's --write line; run as
#                       printed it exits 0, then --check exits 0, and again after the next
#                       update.
#                   65. D54: a server the owner removed after the offer is not re-added: one
#                       removed before the update was ever committed (only the record knows the
#                       offer), one removed after a commit that held it.
#                   66. D54: an owner's differing entry is kept and reported once: one line on
#                       the update, none on the next.
#                   67. D54: a git-ignored .mcp.json keeps its bytes and mtime, and the update
#                       says so in exactly one line; the report never lists it under a section
#                       whose commands would compare or take it (D42: it was never read).
#                   68. D54: where the owner allows mcp__scrapling__*, no Scrapling ask is
#                       added (the other rules are, and the allow is kept), and each one left
#                       out is reported 'because you allow it'.
#                   69. D54: an owner's catch-all allow in opencode.json leaves no tool
#                       unprompted: the servers are held back there, named in the --write line,
#                       and after --write the next update adds them with an ask for every tool
#                       the settings ask about.
#                   70. D54: no file only the lane wrote is listed under 'you had changed them'
#                       by the next update, and a second update is a quiet no-op (exit 0, a
#                       clean tree, the one report line).
#                   71. D50: an update from v0.4.0 or v0.3.0 with --defaults records DATA_STORE
#                       repo and none of DATA_AREA, DATA_SLUG or the kinds, delivers the resolver
#                       and its map, no data-root ignore file, and never wires the guard.
#                   72. D50: choosing external on an update delivers the ignore files and
#                       untracks nothing (a tracked PDF stays tracked under the new ignore
#                       rule), with DATA_SLUG the real folder's kebab name.
#                   73. D50: an owner's own research/src/.gitignore is listed under CONFLICT
#                       when external is chosen.
#                   74. D50: a DATA_AREA change of case alone is refused by DATA_AREA's
#                       validator, with the tree clean and the area unchanged.
#                   75. D50: the v0.5.0 migration runs before the update report, its copier.yml
#                       entry sits before the update block, and two hand runs exit 0, print the
#                       same report and change nothing.
#                   76. D50: no hidden data-root answer gives the report a false line: no
#                       template-owned file that reads a data-root answer is listed in any
#                       section of a crossing update's report.
#                   77. D50: beside a sibling answers file that records external, the first
#                       update defaults to external, with the sibling's area and slug.
#                   78. D50: a v0.4.0 business Drive project, and a fresh v0.5.0 sibling, in
#                       both orders, records repo and google-drive and keeps .github/.
#                   79. D50: the round trip: external with its own area and slug, repo (which
#                       records neither), external with --defaults (the defaults re-derived);
#                       the resolver's status names the old folder from filed_under and prints
#                       the --data arguments, which restore the layout.
#                   80. D50: a scratch settings file with DATA_STORE external makes a v0.4.0
#                       business Drive project's update record external and delete .github/,
#                       and the report lists the edited workflow (the hazard, documented).
#                   81. D53: a business project with INCLUDE_DRIVE_SYNC true and an edited
#                       Drive workflow, from v0.4.0 and from v0.3.0, updates with --defaults to
#                       DATA_PROVIDER google-drive and DATA_STORE repo, records no
#                       INCLUDE_DRIVE_SYNC, leaves no conflict in .github/, keeps the edit and
#                       merges the store guard step into both workflows.
#                   82. D53: a project without Drive (theology, and business with false)
#                       records DATA_PROVIDER none and gains no .github/.
#                   83. D53: another provider, or external, deletes .github/, and the report
#                       lists the edited workflow under 'DELETED … although you had changed
#                       them'.
#                   84. D53: a second update of the Drive project changes nothing.
#                   85. D53: the v0.5.0 migration lists a Drive workflow the answers no longer
#                       manage and a seed line that names INCLUDE_DRIVE_SYNC, and lists no
#                       workflow the answers still manage; on the crossing update that turns
#                       external (the settings trap), it lists the pre-guard workflow the update
#                       deleted, which the report offers to restore, and tells the owner to
#                       delete the README line rather than giving it the google-drive text.
#
#                  A discarded update, the --write line and an ignored settings.json (DESIGN.md
#                  D51). Checks 86–88, 90 and 91 run once per run on the report fixture: two
#                  projects copied at v0.2.0 and updated to v0.3.0, each update then discarded
#                  and run again, and a third whose owner keeps .claude/settings.json out of git,
#                  updated to v0.3.0 and then to v0.4.0; and, on a second build of the fixture
#                  whose v0.2.0 already offers the hook, autoCompactEnabled, the D54 deny and
#                  asks and the two servers, a project copied at v0.1.0 and updated to v0.2.0,
#                  that update discarded, then updated to v0.3.0, beside one updated from v0.1.0
#                  to v0.3.0 directly. Check 89 reads the D54 flow above.
#                   86. An update discarded with git reset --hard and git clean -fd, then run
#                       again, delivers what the first run did: every path it changed, with the
#                       same status and bytes, and the record chained on the one HEAD committed.
#                   87. The same for an update discarded with git stash -u.
#                   88. A hand rerun of the update stage over either redo's uncommitted tree,
#                       whose files still hold its writes, changes nothing (files and refs).
#                   89. D51: where the owner allows mcp__scrapling__*, the update says once,
#                       naming Scrapling, that it waits for asks .claude/settings.json does not
#                       hold, with both ways in (add the asks and run --write, or add the server
#                       by hand), and no --write line promises Scrapling to the next update; the
#                       catch-all project's --write line names opencode.json and never
#                       .codex/config.toml, to which the lane gave every prompt table.
#                   90. D51: a git-ignored .claude/settings.json keeps its bytes and mtime
#                       through both updates, each of which names the entries to add by hand in
#                       exactly one line, and the record lists none as offered.
#                   91. D51: an update discarded with git reset --hard and git clean -fd, then an
#                       update to a later release, gives what a direct update gives: every path
#                       with the same status and bytes (the D54 deny and asks, the threshold
#                       hook and autoCompactEnabled in settings.json, the servers in .mcp.json,
#                       the refreshed and the arrived shared skills), the record listing the
#                       same offers and written blobs, chained on the one HEAD committed. The
#                       discarded update must have offered those entries, and the direct one
#                       delivered them, or the comparison proves nothing.
#
#                  A fresh copy prints a MissingFileWarning (the template reads the previous
#                  answers through _external_data, and a new project has none). It is expected
#                  and never a finding: only exit statuses and files are judged.
#
#                  Numbers are stable identifiers. Append, never renumber.
#
#                  What it CANNOT check: an upgrade from any release but v0.1.0 (and v0.3.0 for
#                  checks 31–34, v0.3.0 and v0.4.0 for checks 60–85 and 89), or a migration
#                  the update does not reach (a later release's script needs its own flow here,
#                  written with the release that moves the folder: DESIGN.md D26, D44); a real
#                  syntek-media beside it (an invented sibling answers file stands in: the
#                  coexistence test runs both templates), or a sibling's update discarded
#                  (family-update.py's own --self-test judges that); whether a client honours
#                  the files.
#
# SELF-TEST. --self-test runs the whole flow against a fixture template written at runtime,
#            proves the result clean, then mutates the result once per check and asserts
#            exactly one finding each. For checks 13–23 the fixture is given two tagged
#            releases — v0.1.0 with the six old family folders and an audience and a reader
#            test in .claude/CLAUDE.md Section 1, v0.2.0 with the families, the 00-project.md seed and
#            the real migrations/v0.2.0-business-families.sh and v0.2.0-project-settings.sh —
#            and both upgrades run for real. For checks 31–34 the fixture's v0.1.0, which
#            predates its agent questions, stands in for v0.3.0. For checks 40–43 the fixture
#            is given the real migrations/agents-outside-link.py and the real family-shared
#            migrations block of copier.yml, and every update runs for real. The report
#            fixture runs the real D54 lane (checks 47 and 59), and the discarded updates
#            and the ignored settings.json run on it too (checks 86–88, 90 and 91). Checks 60–85 and
#            89 need the real template, so the self-test writes the trees, logs and statuses
#            a clean run leaves (dt_synth) and mutates one input per probe, which proves every
#            judge too.
#
# Requirements: bash 4+, git, rsync, Python 3.11+ (tomllib), uvx (or COPIER_CMD), and the
#               v0.1.0, v0.3.0 and v0.4.0 tags in the template repository (CI checks out with
#               fetch-depth 0). Network on the first uvx run only. The environment's
#               SYNTEK_DATA_ROOT is never seen (_common.sh unsets it): the round trip makes
#               its own root, with its marker, and passes it to each resolver command.
#
# Usage: update-test.sh [--root DIR] [--doc-type T[,T…]] [--quiet] [--self-test] [--help]
#        --doc-type defaults to theology,fiction,business.
#
# Exit codes:  0 = every promise held, for every DOC_TYPE tested
#              1 = finding(s), or the self-test no longer separates
#              2 = script error (bad arguments, missing tools, a template with nothing to update)

set -euo pipefail
SCRIPT_NAME="update-test.sh"
# shellcheck source=SCRIPTDIR/_common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_common.sh"

DOC_TYPES="theology,fiction,business"
SELF_TEST=false

usage() {
  cat <<'EOF'
update-test.sh — Prove `copier update` keeps the author's work and delivers the template's

Usage: update-test.sh [--root DIR] [--doc-type T[,T…]] [--quiet] [--self-test] [--help]

  --root DIR       The template repository (default: this repository)
  --doc-type LIST  Which variants to test (default: theology,fiction,business)
  --quiet          Print findings only
  --self-test      Prove the checks still fire against a fixture template
  --help           Show this message

Exit codes: 0 = every promise held  1 = finding(s), or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)      [[ $# -gt 1 ]] || die "--root needs a value"; SA_ROOT="$(cd "$2" && pwd)" || die "no such directory: $2"; shift 2 ;;
    --doc-type)  [[ $# -gt 1 ]] || die "--doc-type needs a value"; DOC_TYPES="$2"; shift 2 ;;
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

MEMORY_MARK="Update-test entry"
STYLE_MARK="Update-test: an author's own style rule."
TEMPLATE_MARK="<!-- update-test: a template change -->"
AGENTS_MARK="Update-test: the author's own agent instruction."
# A model the owner names (OPENCODE_PROVIDER=named), so the answer reaches rules 05: under the
# default provider, user, OPENCODE_MODEL is hidden and rules 05 names the user's own settings.
NEW_MODEL="update-test/update-test-model"
DOCTYPE_REFUSAL="DOC_TYPE cannot change on update"
MESSAGE_MARK="Before you answer: turning an option off deletes"
# What the warning must name: each option as `KEY=false`, and the family list by its key.
# DATA_PROVIDER is D53's row (it replaced INCLUDE_DRIVE_SYNC=false) and DATA_STORE=repo D50's: the
# table names the store's off value, which deletes the data-root ignore files.
MESSAGE_NAMES="INCLUDE_PROPOSAL=false INCLUDE_WORLDBUILDING=false INCLUDE_CONLANG=false INCLUDE_REFERENCES=false INCLUDE_SENSITIVE_CONTENT=false DATA_PROVIDER DATA_STORE=repo BUSINESS_FAMILIES"

# State the checks read. --self-test mutates it.
DOC=""; PROJ=""; COPY_STATUS=0; UPDATE_STATUS=0; AUTHOR_FILE=""; AUTHOR_SUM=""; TARGET_REL=""
UPDATE_LOG=""; SWITCH_STATUS=0; SWITCH_LOG=""; SWITCH_DIRTY=""; SWITCH_RECORDED=""
DELETED=()
CO_RAN=false; OPENCODE_SUM=""; FRESH_CLIENTS=""
ALL_CLIENTS="codex,gemini-cli,antigravity,opencode"
RULES05=".claude/rules/syntek-author/05-model-allocation.md"
RULES01=".claude/rules/syntek-author/01-layout-and-routing.md"
BRIDGE=".claude/syntek-author-agents.md"
# Every path a client brings: the copy-only files, the folders that hold them, and .agents.
CLIENT_PATHS="$SA_COPY_ONLY .agents .codex .gemini"

other_doc() { # the variant a DOC_TYPE change is attempted to
  case "$1" in theology) echo fiction ;; fiction) echo business ;; *) echo theology ;; esac
}

BOOK_LEDGER="standards/style/ledger/01-example-chapter--the-turn.md standards/style/ledger/01-example-chapter--opening.md"
examples_for() { # the seed-once examples a DOC_TYPE receives
  case "$1" in
    theology) echo "manuscript/src/01-example-chapter planning/src/units/01-example-chapter.md planning/src/arguments/01-example-chapter.md $BOOK_LEDGER" ;;
    fiction)  echo "manuscript/src/01-example-chapter planning/src/units/01-example-chapter.md $BOOK_LEDGER" ;;
    business) echo "library/src/business/drafts/example-proposal planning/src/units/example-proposal.md standards/style/ledger/example-proposal--scope.md" ;;
  esac
}

run_flow() { # $1 = template repo, $2 = DOC_TYPE, $3 = work dir — fills the state
  local src="$1" tpl="$3/tpl" e log="$3/flow.log" clone="$3/proj-switch"
  DOC="$2"; PROJ="$3/proj"; COPY_STATUS=0; UPDATE_STATUS=0; DELETED=(); FLOW_RAN=true
  UPDATE_LOG="$3/update.log"; SWITCH_STATUS=0; SWITCH_LOG="$3/switch.log"; SWITCH_DIRTY=""; SWITCH_RECORDED=""
  : > "$UPDATE_LOG"; : > "$SWITCH_LOG"
  sa_snapshot "$src" "$tpl" >>"$log" 2>&1 || die "could not snapshot $src"

  sa_render "$tpl" "$PROJ" "$DOC" >>"$log" 2>&1 || COPY_STATUS=$?
  [[ "$COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$PROJ/.git" ]] || sa_git "$PROJ" init -q
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'generated' >>"$log" 2>&1
  FRESH_CLIENTS="$(answer_list AGENT_CLIENTS "$PROJ/$SA_ANSWERS_FILE" | paste -sd, -)"

  # The author at work.
  printf -- '- **01/01/2027** — **%s.** An author decision that must survive every update.\n' "$MEMORY_MARK" >> "$PROJ/.claude/MEMORY.md"
  printf '\n%s\n' "$STYLE_MARK" >> "$PROJ/standards/style/style-sheet.md"
  for e in $(examples_for "$DOC"); do
    [[ -e "$PROJ/$e" ]] && { rm -rf "${PROJ:?}/$e"; DELETED+=("$e"); }
  done
  rm -f "$PROJ/standards/style/voice-notes.md"
  if [[ "$DOC" == business ]]; then AUTHOR_FILE="library/src/business/client-docs/example-client/author-note.md"
  else AUTHOR_FILE="manuscript/src/02-author-unit/02-author-unit.md"; fi
  mkdir -p "$(dirname "$PROJ/$AUTHOR_FILE")"
  printf '# Written by the author\n\nA paragraph no update may touch.\n' > "$PROJ/$AUTHOR_FILE"
  AUTHOR_SUM="$(sha1sum < "$PROJ/$AUTHOR_FILE")"
  # The copy-only agent files (D47), where the render wrote them (every default render does).
  CO_RAN=false
  if [[ -f "$PROJ/AGENTS.md" && -f "$PROJ/GEMINI.md" && -f "$PROJ/.codex/config.toml" && -f "$PROJ/opencode.json" ]]; then
    CO_RAN=true
    printf '\n%s\n' "$AGENTS_MARK" >> "$PROJ/AGENTS.md"
    rm -f "$PROJ/GEMINI.md" "$PROJ/.codex/config.toml"
    OPENCODE_SUM="$(sha1sum < "$PROJ/opencode.json")"
  fi
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'the author at work' >>"$log" 2>&1

  # The template moves on. A template-owned skill every variant ships; a rule file if the
  # skills are not written yet.
  TARGET_REL=".claude/skills/run-workflow/SKILL.md"
  [[ -f "$tpl/template/$TARGET_REL" ]] || TARGET_REL=".claude/rules/syntek-author/01-layout-and-routing.md"
  [[ -f "$tpl/template/$TARGET_REL" ]] || die "the template has neither run-workflow/SKILL.md nor the layout rule — nothing template-owned to update"
  printf '\n%s\n' "$TEMPLATE_MARK" >> "$tpl/template/$TARGET_REL"
  if $CO_RAN; then
    printf '\n%s\n' "$TEMPLATE_MARK" >> "$tpl/template/AGENTS.md"
    printf '\n%s\n' "$TEMPLATE_MARK" >> "$tpl/template/.claude/syntek-author-agents.md"
    printf ' \n' >> "$tpl/template/opencode.json"
  fi
  sa_git "$tpl" add -A && sa_git "$tpl" commit -q -m 'a template change' >>"$log" 2>&1

  local -a co_data=()
  if $CO_RAN; then
    co_data=(--data "OPENCODE_MODEL=$NEW_MODEL")
    grep -q '^OPENCODE_PROVIDER:' "$tpl/copier.yml" && co_data+=(--data "OPENCODE_PROVIDER=named")
  fi
  sa_update "$PROJ" "${co_data[@]}" >"$UPDATE_LOG" 2>&1 || UPDATE_STATUS=$?
  cat "$UPDATE_LOG" >>"$log"

  # A changed DOC_TYPE, tried in a clone so checks 3–9 judge the real update alone. The clone
  # starts clean and committed, so a refusal can only come from the template.
  sa_git "$PROJ" add -A && sa_git "$PROJ" commit -q -m 'updated' >>"$log" 2>&1 || true
  git clone -q "$PROJ" "$clone" >>"$log" 2>&1 || die "could not clone $PROJ"
  sa_update "$clone" --data "DOC_TYPE=$(other_doc "$DOC")" >"$SWITCH_LOG" 2>&1 || SWITCH_STATUS=$?
  cat "$SWITCH_LOG" >>"$log"
  SWITCH_DIRTY="$(git -C "$clone" status --porcelain 2>/dev/null)"
  SWITCH_RECORDED="$(answer_value DOC_TYPE "$clone/$SA_ANSWERS_FILE")"
}

# ── The v0.2.0 migration, on a real upgrade from v0.1.0 (business, checks 13–18) ──

MIGRATION_FROM="v0.1.0"
MIGRATION_SCRIPT="migrations/v0.2.0-business-families.sh"
MIGRATION_MARK="v0.2.0 migration — moving your files"
# Author files planted in the v0.1.0 family folders, each with its D44 destination (msp-scp is
# not chosen, so policies go to business). Invented names only.
MIG_PLANTS=$(cat <<'EOF'
library/src/proposals/templates/author-rate-card.md library/src/business/templates/author-rate-card.md
library/src/contracts/client-docs/example-client/author-msa.tex library/src/legal/client-docs/example-client/author-msa.tex
library/src/policies/author-policy.md library/src/business/author-policy.md
library/src/correspondence/client-docs/example-client/author-letter.md library/src/email/client-emails/example-client/author-letter.md
library/src/finance/templates/author-invoice.md library/src/accounting/templates/author-invoice.md
library/src/marketing/drafts/author-post.md library/src/social-media/drafts/author-post.md
EOF
)
# A collision: the author had already used the destination in v0.1.0 (legal/ was not a template
# folder then), so the old file must stay where it is, untouched, and be named.
MIG_COLLIDE_OLD="library/src/contracts/author-nda.md"
MIG_COLLIDE_NEW="library/src/legal/author-nda.md"

MIG_RAN=false; FLOW_RAN=false
MIG_PROJ=""; MIG_COPY_STATUS=0; MIG_UPDATE_STATUS=0; MIG_LOG=""; MIG_RERUN_STATUS=0; MIG_RERUN_DIRTY=""
MSP_RESULT=""
declare -A MIG_WANT=() MIG_SUMS=()

# The every-variant settings migration (D40): an invented audience, set where v0.1.0 told the
# author to keep it, must reach `## Brief`. No '|', '&' or '\' in it: sed writes it.
SETTINGS_SCRIPT="migrations/v0.2.0-project-settings.sh"
SETTINGS_MARK="v0.2.0 migration — project settings"
SETTINGS_FILE=".claude/rules/syntek-author/00-project.md"
SETTINGS_EDIT="Update-test audience, an invented reading group new to the subject"
# A reader test the author hand-edited under v0.1.0, then answered afresh during the update
# (D44: the fresh answer wins, and the hand edit is a conflict). Same limits as above.
READER_HAND="Update-test reader, an invented night-shift nurse reading on a break"
READER_FRESH="Update-test reader, an invented apprentice who answered again during the update"
READER_CONFLICT="conflict  Reader test"
SET_RAN=false
SET_DOC=""; SET_PROJ=""; SET_COPY_STATUS=0; SET_UPDATE_STATUS=0; SET_LOG=""; SET_RERUN_STATUS=0; SET_RERUN_DIRTY=""

sum_of() { sha1sum < "$1" | cut -d' ' -f1; }

# `- **Label:** value` and `- **Label** (a note): value` both read as the value.
brief_value() { # $1 = 00-project.md, $2 = label → the value of that bullet under ## Brief
  awk -v pre="- **$2" '
    /^## / { on = ($0 ~ /^## Brief[ \t]*$/); next }
    on && index($0, pre) == 1 {
      v = substr($0, length(pre) + 1)
      if (substr(v, 1, 3) == ":**") v = substr(v, 4)
      else if (substr(v, 1, 2) == "**") { v = substr(v, 3); sub(/^[ \t]*\([^)]*\)/, "", v); if (substr(v, 1, 1) != ":") next; v = substr(v, 2) }
      else next
      sub(/^[ \t]+/, "", v); print v; exit
    }' "$1" 2>/dev/null
}

# The real repository as a template with history: its tags (v0.1.0, v0.3.0, v0.4.0) and the
# working tree committed on top, tagged with VERSION, so Copier sees a release to upgrade to.
# When VERSION is already a release tag (unreleased work on top of it), that tag stays where the
# release put it: Copier reads the untagged commit as a later version (v0.3.0-1-g…), and the
# Trap 1 flow can still copy the real release. Unreleased work whose newest _migrations entry
# names a later release than VERSION is tagged as that release: an update runs a migration only
# up to the version it updates to, so v0.4.0-1-g… would never run the v0.5.0 migration.
tagged_template() { # $1 = template repository, $2 = dest
  local src="$1" dest="$2" ver top
  git -C "$src" rev-parse -q --verify "refs/tags/$MIGRATION_FROM" >/dev/null 2>&1 \
    || die "$src has no $MIGRATION_FROM tag — the upgrade cannot be proven (git fetch --tags; CI needs fetch-depth: 0)"
  git clone -q --no-local "$src" "$dest" || die "could not clone $src"
  command -v rsync >/dev/null 2>&1 || die "rsync is not installed"
  rsync -a --delete --exclude '.git' "$src/" "$dest/" || die "could not copy the working tree"
  sa_git "$dest" add -A && sa_git "$dest" commit -q --allow-empty -m 'update-test: the working tree' || die "could not commit the working tree"
  ver="v$(tr -d '[:space:]' < "$dest/VERSION" 2>/dev/null)"
  [[ "$ver" != v ]] || die "no VERSION in $src"
  top="$(grep -oE '^  - version: v[0-9]+\.[0-9]+\.[0-9]+$' "$dest/copier.yml" | awk '{ print $3 }' | sort -V | tail -1 || true)"
  [[ -z "$top" ]] || ver="$(printf '%s\n' "$ver" "$top" | sort -V | tail -1)"
  if ! git -C "$dest" rev-parse -q --verify "refs/tags/$ver" >/dev/null 2>&1; then
    sa_git "$dest" tag "$ver" >/dev/null
  fi
}

run_migration_flow() { # $1 = template repository WITH the two tags, $2 = work dir
  local tpl="$1" w="$2" log="$2/mig-flow.log" from to f rel
  MIG_RAN=true; MIG_PROJ="$w/mig-proj"; MIG_COPY_STATUS=0; MIG_UPDATE_STATUS=0; MIG_LOG="$w/mig-update.log"
  MIG_RERUN_STATUS=0; MIG_RERUN_DIRTY=""; MIG_WANT=(); MIG_SUMS=(); : > "$MIG_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$MIGRATION_FROM" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data DOC_TYPE=business \
    "$tpl" "$MIG_PROJ" </dev/null >>"$log" 2>&1 || MIG_COPY_STATUS=$?
  [[ "$MIG_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$MIG_PROJ/.git" ]] || sa_git "$MIG_PROJ" init -q
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'generated at v0.1.0' >>"$log" 2>&1

  # The author at work in the old folders.
  while read -r from to; do
    [[ -z "$from" ]] && continue
    mkdir -p "$(dirname "$MIG_PROJ/$from")"
    printf '# Written by the author in %s\n\nA document no upgrade may lose.\n' "$from" > "$MIG_PROJ/$from"
    MIG_WANT["$from"]="$to"; MIG_SUMS["$from"]="$(sum_of "$MIG_PROJ/$from")"
  done <<< "$MIG_PLANTS"
  for f in "$MIG_COLLIDE_OLD" "$MIG_COLLIDE_NEW"; do
    mkdir -p "$(dirname "$MIG_PROJ/$f")"
    printf '# The author'\''s own copy at %s\n' "$f" > "$MIG_PROJ/$f"
    MIG_SUMS["$f"]="$(sum_of "$MIG_PROJ/$f")"
  done
  # The kept example proposal travels with its family (Section 3.2).
  while IFS= read -r f; do
    rel="${f#library/src/proposals/}"
    MIG_WANT["$f"]="library/src/business/$rel"; MIG_SUMS["$f"]="$(sum_of "$MIG_PROJ/$f")"
  done < <(cd "$MIG_PROJ" && find library/src/proposals/drafts/example-proposal -type f 2>/dev/null | LC_ALL=C sort)
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'the author at work' >>"$log" 2>&1

  sa_update "$MIG_PROJ" >"$MIG_LOG" 2>&1 || MIG_UPDATE_STATUS=$?
  cat "$MIG_LOG" >>"$log"

  # A second run by hand, on the committed result, must change nothing.
  sa_git "$MIG_PROJ" add -A && sa_git "$MIG_PROJ" commit -q -m 'upgraded' >>"$log" 2>&1 || true
  (cd "$MIG_PROJ" && bash "$tpl/$MIGRATION_SCRIPT") >>"$log" 2>&1 || MIG_RERUN_STATUS=$?
  MIG_RERUN_DIRTY="$(git -C "$MIG_PROJ" status --porcelain 2>/dev/null)"

  # With msp-scp chosen, policies go to msp-scp (D44): a hand run, no Copier needed.
  mkdir -p "$w/msp/library/src/business" "$w/msp/library/src/msp-scp" "$w/msp/library/src/policies"
  printf 'DOC_TYPE: business\nBUSINESS_FAMILIES:\n- business\n- msp-scp\n' > "$w/msp/$SA_ANSWERS_FILE"
  printf '# x\n' > "$w/msp/library/src/business/CONTEXT.md"; printf '# x\n' > "$w/msp/library/src/msp-scp/CONTEXT.md"
  printf '# An IT policy\n' > "$w/msp/library/src/policies/author-policy.md"
  (cd "$w/msp" && bash "$tpl/$MIGRATION_SCRIPT") >>"$log" 2>&1 || true
  MSP_RESULT="$(cd "$w/msp" && find library/src -type f -name author-policy.md | LC_ALL=C sort | paste -sd' ' -)"
}

mig_checks() {
  local from to f found
  local -A have=()
  if [[ "$MIG_COPY_STATUS" -ne 0 ]]; then
    finding "check 13 — [business] the project did not render at $MIGRATION_FROM (exit $MIG_COPY_STATUS)"
    return 0
  fi
  if [[ "$MIG_UPDATE_STATUS" -ne 0 ]]; then
    finding "check 13 — [business] copier update from $MIGRATION_FROM failed (exit $MIG_UPDATE_STATUS)"
  elif ! grep -qF "$MIGRATION_MARK" "$MIG_LOG" 2>/dev/null; then
    finding "check 13 — [business] the update from $MIGRATION_FROM did not run the v0.2.0 migration (is VERSION past 0.1.0, and _migrations keyed v0.2.0?)"
  fi
  for from in "${!MIG_WANT[@]}"; do
    to="${MIG_WANT[$from]}"
    if [[ ! -f "$MIG_PROJ/$to" || "$(sum_of "$MIG_PROJ/$to")" != "${MIG_SUMS[$from]}" ]]; then
      finding "check 14 — [business] $from is not at $to byte for byte after the upgrade"
    fi
  done
  while IFS= read -r -d '' f; do have["$(sum_of "$f")"]=1; done \
    < <(find "$MIG_PROJ" -name .git -prune -o -type f -print0 2>/dev/null)
  for f in "${!MIG_SUMS[@]}"; do
    [[ -n "${have[${MIG_SUMS[$f]}]:-}" ]] || finding "check 15 — [business] what the author wrote in $f is nowhere in the project after the upgrade"
  done
  grep -qF "$MIG_COLLIDE_OLD" "$MIG_LOG" 2>/dev/null \
    || finding "check 16 — [business] the migration did not name $MIG_COLLIDE_OLD, which it could not move ($MIG_COLLIDE_NEW exists)"
  if [[ "$MIG_RERUN_STATUS" -ne 0 || -n "$MIG_RERUN_DIRTY" ]]; then
    found="$(printf '%s\n' "$MIG_RERUN_DIRTY" | grep -c . || true)"
    finding "check 17 — [business] a second run of the migration was not a no-op (exit $MIG_RERUN_STATUS, $found path(s) changed)"
  fi
  [[ "$MSP_RESULT" == "library/src/msp-scp/author-policy.md" ]] \
    || finding "check 18 — [business] with msp-scp chosen, policies/author-policy.md went to '${MSP_RESULT:-nowhere}', not library/src/msp-scp/"
}

# ── The v0.2.0 settings migration, on a real upgrade from v0.1.0 (books, checks 19–21) ──

run_settings_flow() { # $1 = template repository WITH the two tags, $2 = work dir, $3 = book DOC_TYPE
  local tpl="$1" w="$2" log="$2/set-flow.log"
  SET_RAN=true; SET_DOC="$3"; SET_PROJ="$w/set-proj"; SET_COPY_STATUS=0; SET_UPDATE_STATUS=0
  SET_LOG="$w/set-update.log"; SET_RERUN_STATUS=0; SET_RERUN_DIRTY=""; : > "$SET_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$MIGRATION_FROM" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=$SET_DOC" \
    "$tpl" "$SET_PROJ" </dev/null >>"$log" 2>&1 || SET_COPY_STATUS=$?
  [[ "$SET_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$SET_PROJ/.git" ]] || sa_git "$SET_PROJ" init -q
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'generated at v0.1.0' >>"$log" 2>&1

  # The author keeps the brief current where v0.1.0 said to: .claude/CLAUDE.md Section 1.
  sed -i "s|^- \*\*Audience:\*\* .*|- **Audience:** $SETTINGS_EDIT|" "$SET_PROJ/.claude/CLAUDE.md" 2>>"$log" || true
  sed -i "s|^\(- \*\*Reader test\*\*[^:]*:\) .*|\1 $READER_HAND|" "$SET_PROJ/.claude/CLAUDE.md" 2>>"$log" || true
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'the author changes the audience and the reader test' >>"$log" 2>&1 || true

  # The upgrade, answering the reader test again on the way (D44: that answer must stand).
  sa_update "$SET_PROJ" --data "READER_TEST=$READER_FRESH" >"$SET_LOG" 2>&1 || SET_UPDATE_STATUS=$?
  cat "$SET_LOG" >>"$log"

  # A second run by hand, on the committed result, must change nothing.
  sa_git "$SET_PROJ" add -A && sa_git "$SET_PROJ" commit -q -m 'upgraded' >>"$log" 2>&1 || true
  (cd "$SET_PROJ" && bash "$tpl/$SETTINGS_SCRIPT") >>"$log" 2>&1 || SET_RERUN_STATUS=$?
  SET_RERUN_DIRTY="$(git -C "$SET_PROJ" status --porcelain 2>/dev/null)"
}

set_checks() {
  local got found
  if [[ "$SET_COPY_STATUS" -ne 0 ]]; then
    finding "check 19 — [$SET_DOC] the project did not render at $MIGRATION_FROM (exit $SET_COPY_STATUS)"
    return 0
  fi
  if [[ "$SET_UPDATE_STATUS" -ne 0 ]]; then
    finding "check 19 — [$SET_DOC] copier update from $MIGRATION_FROM failed (exit $SET_UPDATE_STATUS)"
  elif ! grep -qF "$SETTINGS_MARK" "$SET_LOG" 2>/dev/null; then
    finding "check 19 — [$SET_DOC] the update from $MIGRATION_FROM did not run the v0.2.0 project-settings migration (is its _migrations entry keyed v0.2.0, with no DOC_TYPE test?)"
  fi
  got="$(brief_value "$SET_PROJ/$SETTINGS_FILE" Audience)"
  [[ "$got" == "$SETTINGS_EDIT" ]] \
    || finding "check 20 — [$SET_DOC] $SETTINGS_FILE ## Brief gives the audience as '${got:-nothing}', not the one the author set in .claude/CLAUDE.md Section 1"
  if [[ "$SET_RERUN_STATUS" -ne 0 || -n "$SET_RERUN_DIRTY" ]]; then
    found="$(printf '%s\n' "$SET_RERUN_DIRTY" | grep -c . || true)"
    finding "check 21 — [$SET_DOC] a second run of the settings migration was not a no-op (exit $SET_RERUN_STATUS, $found path(s) changed)"
  fi
  got="$(brief_value "$SET_PROJ/$SETTINGS_FILE" "Reader test")"
  [[ "$got" == "$READER_FRESH" ]] \
    || finding "check 22 — [$SET_DOC] $SETTINGS_FILE ## Brief gives the reader test as '${got:-nothing}', not the one the author answered during the update ($READER_FRESH)"
  for found in $CLIENT_PATHS; do
    [[ -e "$SET_PROJ/$found" || -L "$SET_PROJ/$found" ]] \
      && finding "check 29 — [$SET_DOC] the upgrade from $MIGRATION_FROM created the copy-only $found — an update must never add one"
  done
  if ! grep -qF "$READER_CONFLICT" "$SET_LOG" 2>/dev/null \
     || ! grep -F '.claude/CLAUDE.md:' "$SET_LOG" 2>/dev/null | grep -qF "$READER_HAND"; then
    finding "check 23 — [$SET_DOC] the settings migration did not report the older reader test in .claude/CLAUDE.md ('$READER_HAND') as a conflict with its file:line"
  fi
}

# ── The update that first asks AGENT_CLIENTS (D47 Trap 1, checks 31–34) ──────

TRAP_FROM="v0.3.0"
TRAP_RAN=false
TRAP_DOC=""; TRAP_PROJ=""; TRAP_COPY_STATUS=0; TRAP_UPDATE_STATUS=0; TRAP_RECORDED=""

run_trap_flow() { # $1 = template repository WITH the tag, $2 = work dir, $3 = DOC_TYPE
  local tpl="$1" w="$2" log="$2/trap-flow.log"
  TRAP_RAN=true; TRAP_DOC="$3"; TRAP_PROJ="$w/trap-proj"; TRAP_COPY_STATUS=0; TRAP_UPDATE_STATUS=0
  TRAP_RECORDED=""
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$TRAP_FROM" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=$TRAP_DOC" \
    "$tpl" "$TRAP_PROJ" </dev/null >>"$log" 2>&1 || TRAP_COPY_STATUS=$?
  [[ "$TRAP_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$TRAP_PROJ/.git" ]] || sa_git "$TRAP_PROJ" init -q
  sa_git "$TRAP_PROJ" add -A && sa_git "$TRAP_PROJ" commit -q -m "generated at $TRAP_FROM" >>"$log" 2>&1
  # What checks 60, 61, 71, 76 and 82 read in the real run (TD_*; D50, D53, D54).
  TD_DOC="$TRAP_DOC"; TD_PROJ="$TRAP_PROJ"; TD_LOG="$w/trap-update.log"; TD_PRE="$w/trap-pre"; TD_TPL="$w/trap-tpl"
  dt_keep "$TRAP_PROJ" "$TD_PRE"
  # A scripted update: --defaults, no AGENT_CLIENTS given (sa_update passes --defaults).
  sa_update "$TRAP_PROJ" >"$TD_LOG" 2>&1 || TRAP_UPDATE_STATUS=$?
  cat "$TD_LOG" >>"$log"
  TRAP_RECORDED="$(grep -E '^AGENT_CLIENTS:' "$TRAP_PROJ/$SA_ANSWERS_FILE" 2>/dev/null | head -1)"
  dt_record "$TRAP_PROJ" "$TD_TPL"
}

trap_checks() {
  local p
  if [[ "$TRAP_COPY_STATUS" -ne 0 ]]; then
    finding "check 31 — [$TRAP_DOC] the project did not render at $TRAP_FROM (exit $TRAP_COPY_STATUS)"
    return 0
  fi
  if [[ "$TRAP_UPDATE_STATUS" -ne 0 ]]; then
    finding "check 31 — [$TRAP_DOC] copier update --defaults from $TRAP_FROM failed (exit $TRAP_UPDATE_STATUS)"
  elif [[ "$TRAP_RECORDED" != 'AGENT_CLIENTS: []' ]]; then
    finding "check 31 — [$TRAP_DOC] the update from $TRAP_FROM recorded '${TRAP_RECORDED:-no AGENT_CLIENTS}', not 'AGENT_CLIENTS: []' — an existing project would record clients whose files it never received"
  fi
  grep -qE '^## 4\.' "$TRAP_PROJ/$RULES05" 2>/dev/null \
    && finding "check 32 — [$TRAP_DOC] after the update from $TRAP_FROM, $RULES05 has a Section 4 — it names coding agents the project never chose"
  [[ -f "$TRAP_PROJ/$BRIDGE" ]] \
    || finding "check 33 — [$TRAP_DOC] after the update from $TRAP_FROM, the bridge $BRIDGE is missing — it always ships"
  for p in $CLIENT_PATHS; do
    [[ -e "$TRAP_PROJ/$p" || -L "$TRAP_PROJ/$p" ]] \
      && finding "check 34 — [$TRAP_DOC] the update from $TRAP_FROM created $p — an update never adds a client's file"
  done
  return 0
}

# ── An emptied client list, and one client removed (checks 35–39) ─────────────

CL_RAN=false
CL_DOC=""; CL_PROJ=""; CL_ONE=""; CL_COPY_STATUS=0; CL_UPDATE_STATUS=0; CL_ONE_STATUS=0
CL_PORCELAIN=""; CL_ONE_PORCELAIN=""; CL_ONE_DIFF=""
CL_RE_STATUS=0; CL_RE_RECORDED=""; CL_RE_BAD_STATUS=0; CL_RE_BAD_RECORDED=""
declare -A CL_SUMS=()

run_clients_flow() { # $1 = template repository, $2 = work dir, $3 = DOC_TYPE
  local src="$1" w="$2" tpl="$2/cl-tpl" log="$2/cl-flow.log" f
  CL_RAN=true; CL_DOC="$3"; CL_PROJ="$w/cl-proj"; CL_ONE="$w/cl-one"
  CL_COPY_STATUS=0; CL_UPDATE_STATUS=0; CL_ONE_STATUS=0; CL_PORCELAIN=""; CL_ONE_PORCELAIN=""; CL_ONE_DIFF=""
  CL_SUMS=()
  sa_snapshot "$src" "$tpl" >>"$log" 2>&1 || die "could not snapshot $src"
  sa_render "$tpl" "$CL_PROJ" "$CL_DOC" --data "AGENT_CLIENTS=[$ALL_CLIENTS]" >>"$log" 2>&1 || CL_COPY_STATUS=$?
  [[ "$CL_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$CL_PROJ/.git" ]] || sa_git "$CL_PROJ" init -q
  sa_git "$CL_PROJ" add -A && sa_git "$CL_PROJ" commit -q -m 'generated with every client' >>"$log" 2>&1
  for f in AGENTS.md GEMINI.md; do
    [[ -f "$CL_PROJ/$f" ]] && CL_SUMS["$f"]="$(sum_of "$CL_PROJ/$f")"
  done
  git clone -q "$CL_PROJ" "$CL_ONE" >>"$log" 2>&1 || die "could not clone $CL_PROJ"

  sa_update "$CL_PROJ" --data 'AGENT_CLIENTS=[]' >>"$log" 2>&1 || CL_UPDATE_STATUS=$?
  CL_PORCELAIN="$(git -C "$CL_PROJ" status --porcelain 2>/dev/null)"

  sa_update "$CL_ONE" --data 'AGENT_CLIENTS=[codex,gemini-cli,antigravity]' >>"$log" 2>&1 || CL_ONE_STATUS=$?
  CL_ONE_PORCELAIN="$(git -C "$CL_ONE" status --porcelain 2>/dev/null)"
  CL_ONE_DIFF="$(git -C "$CL_ONE" diff -U0 -- "$RULES05" 2>/dev/null | grep -E '^[-+][^-+]' || true)"

  # Check 39: a copy over a project keeps its recorded clients (re-adoption).
  local re="$w/cl-recopy"
  CL_RE_STATUS=0; CL_RE_RECORDED=""; CL_RE_BAD_STATUS=0; CL_RE_BAD_RECORDED=""
  sa_render "$tpl" "$re" "$CL_DOC" --data 'AGENT_CLIENTS=[codex]' >>"$log" 2>&1 || CL_RE_STATUS=$?
  [[ "$CL_RE_STATUS" -eq 0 ]] || return 0
  sa_render "$tpl" "$re" "$CL_DOC" --overwrite >>"$log" 2>&1 || CL_RE_STATUS=$?
  CL_RE_RECORDED="$(answer_list AGENT_CLIENTS "$re/$SA_ANSWERS_FILE" | paste -sd, -)"
  sed -i '/^AGENT_CLIENTS:/a - cursor' "$re/$SA_ANSWERS_FILE"
  sa_render "$tpl" "$re" "$CL_DOC" --overwrite >>"$log" 2>&1 || CL_RE_BAD_STATUS=$?
  CL_RE_BAD_RECORDED="$(answer_list AGENT_CLIENTS "$re/$SA_ANSWERS_FILE" | paste -sd, -)"
}

clients_checks() {
  local line path f want
  if [[ "$CL_COPY_STATUS" -ne 0 ]]; then
    finding "check 35 — [$CL_DOC] the project with every client did not render (exit $CL_COPY_STATUS)"
    return 0
  fi
  [[ "$CL_UPDATE_STATUS" -eq 0 ]] || finding "check 35 — [$CL_DOC] copier update --data 'AGENT_CLIENTS=[]' failed (exit $CL_UPDATE_STATUS)"
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    path="${line:3}"
    case "${line:0:2}" in
      *D*) finding "check 35 — [$CL_DOC] emptying AGENT_CLIENTS deleted $path — an update never removes a client's file" ;;
    esac
  done <<< "$CL_PORCELAIN"
  [[ -f "$CL_PROJ/$BRIDGE" ]] || finding "check 36 — [$CL_DOC] emptying AGENT_CLIENTS removed the bridge $BRIDGE — it always ships"
  for f in AGENTS.md GEMINI.md; do
    want="${CL_SUMS[$f]:-}"
    if [[ -z "$want" ]]; then finding "check 36 — [$CL_DOC] the copy with every client wrote no $f to compare"
    elif [[ ! -f "$CL_PROJ/$f" || "$(sum_of "$CL_PROJ/$f")" != "$want" ]]; then
      finding "check 36 — [$CL_DOC] emptying AGENT_CLIENTS changed $f — a copy-only entrypoint is the author's once written"
    fi
  done
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    path="${line:3}"
    [[ "${line:0:2}" == *D* ]] && continue   # check 35's
    case "$path" in
      "$RULES01"|"$RULES05"|"$SA_ANSWERS_FILE") ;;
      *) finding "check 37 — [$CL_DOC] emptying AGENT_CLIENTS changed $path — only rules 01, rules 05 and the answers file may change" ;;
    esac
  done <<< "$CL_PORCELAIN"
  if [[ "$CL_ONE_STATUS" -ne 0 ]]; then
    finding "check 38 — [$CL_DOC] copier update removing opencode from AGENT_CLIENTS failed (exit $CL_ONE_STATUS)"
    return 0
  fi
  if [[ "$CL_ONE_DIFF" != '-| OpenCode |'* || "$(printf '%s\n' "$CL_ONE_DIFF" | grep -c .)" -ne 1 ]]; then
    finding "check 38 — [$CL_DOC] removing opencode did not drop exactly its row from $RULES05 (changed lines: $(printf '%s' "$CL_ONE_DIFF" | tr '\n' ' ' | cut -c1-160))"
  fi
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    path="${line:3}"
    case "$path" in
      "$RULES05"|"$SA_ANSWERS_FILE") ;;
      *) finding "check 38 — [$CL_DOC] removing opencode changed $path — only its rules 05 row and the answers file may change" ;;
    esac
  done <<< "$CL_ONE_PORCELAIN"
  if [[ "$CL_RE_STATUS" -ne 0 ]]; then
    finding "check 39 — [$CL_DOC] a copy over a project that recorded [codex] failed (exit $CL_RE_STATUS)"
  elif [[ "$CL_RE_RECORDED" != "codex" ]]; then
    finding "check 39 — [$CL_DOC] a copy over a project that recorded [codex] recorded [${CL_RE_RECORDED}] — re-adoption must keep the recorded clients"
  fi
  if [[ "$CL_RE_BAD_STATUS" -ne 0 ]]; then
    finding "check 39 — [$CL_DOC] a copy over a record holding a value no longer a choice failed (exit $CL_RE_BAD_STATUS)"
  elif [[ "$CL_RE_BAD_RECORDED" != "codex" ]]; then
    finding "check 39 — [$CL_DOC] a copy over a record of [codex, cursor] recorded [${CL_RE_BAD_RECORDED}], not [codex]"
  fi
  return 0
}

# ── An .agents link to a folder outside the project (D48, checks 40–43) ───────

OL_HELD=".agents.syntek-held"
OL_FIX="mv $OL_HELD .agents"
OL_MIG_BEGIN="# BEGIN family-shared migrations (D48)"
OL_MIG_END="# END family-shared migrations (D48)"
OL_RAN=false
OL_DOC=""; OL_PROJ=""; OL_LOG=""; OL_COPY_STATUS=0; OL_STATUS=0; OL_TARGET=""; OL_AFTER_TARGET=""
OL_HELD_LEFT=false; OL_DIRTY=""; OL_AGAIN_STATUS=0; OL_AGAIN_DIRTY=""; OL_SUMS_BEFORE=""; OL_SUMS_AFTER=""
OL_STRAND_LOG=""; OL_STRAND_STATUS=0; OL_STRAND_HELD=false; OL_STRAND_DIRTY=""; OL_STRAND_TARGET=""
OL_RESTORE_DIRTY=""; OL_RESTORE_TARGET=""; OL_CTL_STATUS=0; OL_CTL_TARGET=""; OL_CTL_AFTER=""

ol_sums() { # $1 = dir → every path under it, with its checksum (a link: its target)
  (cd "$1" && find . -print0 | LC_ALL=C sort -z | while IFS= read -r -d '' f; do
    if [[ -L "$f" ]]; then printf '%s -> %s\n' "$f" "$(readlink "$f")"
    elif [[ -f "$f" ]]; then printf '%s %s\n' "$f" "$(sum_of "$f")"
    else printf '%s/\n' "$f"; fi
  done) 2>/dev/null
}

run_outside_flow() { # $1 = template repository (with the outside-link pair), $2 = work dir, $3 = DOC_TYPE
  local src="$1" w="$2" tpl="$2/ol-tpl" log="$2/ol-flow.log" out="$2/outside-agents"
  local clone="$2/ol-strand" ctl="$2/ol-control"
  OL_RAN=true; OL_DOC="$3"; OL_PROJ="$w/ol-proj"; OL_LOG="$w/ol-update.log"; OL_STRAND_LOG="$w/ol-strand.log"
  OL_COPY_STATUS=0; OL_STATUS=0; OL_HELD_LEFT=false; OL_DIRTY=""; OL_AGAIN_STATUS=0; OL_AGAIN_DIRTY=""
  OL_STRAND_STATUS=0; OL_STRAND_HELD=false; OL_STRAND_DIRTY=""; OL_STRAND_TARGET=""
  OL_RESTORE_DIRTY=""; OL_RESTORE_TARGET=""; OL_CTL_STATUS=0; OL_CTL_TARGET=""; OL_CTL_AFTER=""
  : > "$OL_LOG"; : > "$OL_STRAND_LOG"
  sa_snapshot "$src" "$tpl" >>"$log" 2>&1 || die "could not snapshot $src"
  rm -rf "$out"; mkdir -p "$out/skills"
  printf "The author's own agent tree, outside the project.\n" > "$out/note.md"
  OL_SUMS_BEFORE="$(ol_sums "$out")"

  sa_render "$tpl" "$OL_PROJ" "$OL_DOC" >>"$log" 2>&1 || OL_COPY_STATUS=$?
  [[ "$OL_COPY_STATUS" -eq 0 ]] || return 0
  [[ -d "$OL_PROJ/.git" ]] || sa_git "$OL_PROJ" init -q
  rm -rf "${OL_PROJ:?}/.agents"; ln -s ../outside-agents "$OL_PROJ/.agents"
  sa_git "$OL_PROJ" add -A && sa_git "$OL_PROJ" commit -q -m 'generated; .agents links to my own agent tree' >>"$log" 2>&1
  OL_TARGET="$(readlink "$OL_PROJ/.agents")"
  printf '\n%s\n' "$TEMPLATE_MARK" >> "$tpl/template/$RULES01"
  sa_git "$tpl" add -A && sa_git "$tpl" commit -q -m 'a template change' >>"$log" 2>&1

  # 40: the update.
  sa_update "$OL_PROJ" >"$OL_LOG" 2>&1 || OL_STATUS=$?
  cat "$OL_LOG" >>"$log"
  OL_AFTER_TARGET="$(readlink "$OL_PROJ/.agents" 2>/dev/null || printf 'not a link')"
  if [[ -e "$OL_PROJ/$OL_HELD" || -L "$OL_PROJ/$OL_HELD" ]]; then OL_HELD_LEFT=true; fi
  OL_DIRTY="$(git -C "$OL_PROJ" status --porcelain -- .agents "$OL_HELD" 2>/dev/null | paste -sd' ' -)"
  sa_git "$OL_PROJ" add -A && sa_git "$OL_PROJ" commit -q -m 'updated' >>"$log" 2>&1 || true

  # 41: a second update, with nothing new in the template.
  sa_update "$OL_PROJ" >>"$log" 2>&1 || OL_AGAIN_STATUS=$?
  OL_AGAIN_DIRTY="$(git -C "$OL_PROJ" status --porcelain 2>/dev/null)"

  # 42: an update that stops between the stages, in a clone, then the printed fix; then a hold
  # left by hand, put back by the script's own restore.
  git clone -q "$OL_PROJ" "$clone" >>"$log" 2>&1 || die "could not clone $OL_PROJ"
  sa_update "$clone" --data "DOC_TYPE=$(other_doc "$OL_DOC")" >"$OL_STRAND_LOG" 2>&1 || OL_STRAND_STATUS=$?
  cat "$OL_STRAND_LOG" >>"$log"
  if [[ -L "$clone/$OL_HELD" && ! -L "$clone/.agents" && ! -e "$clone/.agents" ]]; then OL_STRAND_HELD=true; fi
  if $OL_STRAND_HELD; then (cd "$clone" && $OL_FIX) >>"$log" 2>&1 || true; fi
  OL_STRAND_DIRTY="$(git -C "$clone" status --porcelain 2>/dev/null | paste -sd' ' -)"
  OL_STRAND_TARGET="$(readlink "$clone/.agents" 2>/dev/null || printf 'not a link')"
  (cd "$clone" && python3 "$tpl/migrations/agents-outside-link.py" hold && python3 "$tpl/migrations/agents-outside-link.py" restore) >>"$log" 2>&1 || true
  OL_RESTORE_DIRTY="$(git -C "$clone" status --porcelain 2>/dev/null | paste -sd' ' -)"
  OL_RESTORE_TARGET="$(readlink "$clone/.agents" 2>/dev/null || printf 'not a link')"

  # 43: the control, a real .agents/ whose skills link leaves the project.
  sa_render "$tpl" "$ctl" "$OL_DOC" >>"$log" 2>&1 || OL_CTL_STATUS=$?
  if [[ "$OL_CTL_STATUS" -eq 0 ]]; then
    [[ -d "$ctl/.git" ]] || sa_git "$ctl" init -q
    rm -rf "${ctl:?}/.agents/skills"; ln -s ../../outside-agents/skills "$ctl/.agents/skills"
    sa_git "$ctl" add -A && sa_git "$ctl" commit -q -m 'generated; .agents/skills links outside' >>"$log" 2>&1
    OL_CTL_TARGET="$(readlink "$ctl/.agents/skills")"
    sa_update "$ctl" >>"$log" 2>&1 || OL_CTL_STATUS=$?
    OL_CTL_AFTER="$(readlink "$ctl/.agents/skills" 2>/dev/null || printf 'not a link')"
  fi
  OL_SUMS_AFTER="$(ol_sums "$out")"
}

outside_checks() {
  local L="[$OL_DOC]"
  if [[ "$OL_COPY_STATUS" -ne 0 ]]; then
    finding "check 40 — $L the project did not render (exit $OL_COPY_STATUS)"
    return 0
  fi
  if [[ "$OL_STATUS" -ne 0 ]]; then
    finding "check 40 — $L copier update with .agents linked outside the project failed (exit $OL_STATUS) — see $OL_LOG"
  else
    [[ "$OL_AFTER_TARGET" == "$OL_TARGET" ]] \
      || finding "check 40 — $L the outside .agents link was not restored unchanged: it is '$OL_AFTER_TARGET', it was '$OL_TARGET'"
    $OL_HELD_LEFT && finding "check 40 — $L the update left $OL_HELD behind"
    [[ -z "$OL_DIRTY" ]] || finding "check 40 — $L Git sees the outside link changed after the update: $OL_DIRTY"
    grep -qF "restored .agents -> $OL_TARGET" "$OL_LOG" 2>/dev/null \
      || finding "check 40 — $L the update did not print the outside link's restore — see $OL_LOG"
  fi
  [[ "$OL_SUMS_AFTER" == "$OL_SUMS_BEFORE" ]] \
    || finding "check 40 — $L an update wrote into the folder outside the project that .agents links to"
  if [[ "$OL_AGAIN_STATUS" -ne 0 || -n "$OL_AGAIN_DIRTY" ]]; then
    finding "check 41 — $L a second update over the outside link was not a no-op (exit $OL_AGAIN_STATUS; $(printf '%s\n' "$OL_AGAIN_DIRTY" | grep -c . || true) path(s) changed)"
  fi
  if [[ "$OL_STRAND_STATUS" -eq 0 ]]; then
    finding "check 42 — $L the update meant to stop between the stages (a changed DOC_TYPE) was accepted, so no stranded hold was tested"
  elif ! $OL_STRAND_HELD; then
    finding "check 42 — $L the update that stopped did not leave the link held as $OL_HELD (exit $OL_STRAND_STATUS) — see $OL_STRAND_LOG"
  elif ! grep -qF "$OL_FIX" "$OL_STRAND_LOG" 2>/dev/null; then
    finding "check 42 — $L the update that stopped with the link held did not print the hand fix '$OL_FIX'"
  elif [[ -n "$OL_STRAND_DIRTY" || "$OL_STRAND_TARGET" != "$OL_TARGET" ]]; then
    finding "check 42 — $L the printed hand fix did not restore the project (status '$OL_STRAND_DIRTY'; .agents -> '$OL_STRAND_TARGET')"
  fi
  if [[ -n "$OL_RESTORE_DIRTY" || "$OL_RESTORE_TARGET" != "$OL_TARGET" ]]; then
    finding "check 42 — $L the script's restore did not put back a held link (status '$OL_RESTORE_DIRTY'; .agents -> '$OL_RESTORE_TARGET')"
  fi
  if [[ "$OL_CTL_STATUS" -ne 0 ]]; then
    finding "check 43 — $L a real .agents/ whose skills link points outside the project did not update (exit $OL_CTL_STATUS)"
  elif [[ "$OL_CTL_AFTER" != "$OL_CTL_TARGET" ]]; then
    finding "check 43 — $L the update changed the outside .agents/skills link: it is '$OL_CTL_AFTER', it was '$OL_CTL_TARGET'"
  fi
  return 0
}

# The fixture with the real outside-link script and the real family-shared migrations block.
outside_fixture() { # $1 = dest
  local t="$1"
  sa_fixture_template "$t" >/dev/null
  mkdir -p "$t/migrations"
  cp "$SA_ROOT/migrations/agents-outside-link.py" "$t/migrations/" || die "no migrations/agents-outside-link.py in $SA_ROOT"
  { printf '_migrations:\n'
    awk -v b="$OL_MIG_BEGIN" -v e="$OL_MIG_END" '$0 == b { on = 1 } on { print } $0 == e { on = 0 }' "$SA_ROOT/copier.yml"
  } >> "$t/copier.yml"
  grep -qF "$OL_MIG_END" "$t/copier.yml" || die "no family-shared migrations block in $SA_ROOT/copier.yml"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture: the outside-link pair'
}

# A two-release fixture for the self-test: v0.1.0 with the six old family folders and an
# audience in .claude/CLAUDE.md Section 1, v0.2.0 with the D39 families, the 00-project.md seed
# and the real migration scripts, each tagged.
mig_fixture() { # $1 = dest
  local t="$1" old
  sa_fixture_template "$t" >/dev/null
  sed -i 's#/library/src/business/drafts/example-proposal<#/library/src/proposals/drafts/example-proposal<#' "$t/copier.yml"
  mv "$t/template/library/src/business" "$t/template/library/src/proposals"
  for old in proposals contracts policies correspondence finance marketing; do
    mkdir -p "$t/template/library/src/$old"; printf '# CONTEXT.md — library/src/%s/\n' "$old" > "$t/template/library/src/$old/CONTEXT.md"
  done
  # v0.1.0 kept the brief, the audience and reader test included, in .claude/CLAUDE.md
  # Section 1 (a seed), with the reader test's note as v0.1.0 wrote it.
  printf '# CLAUDE.md — <%%PROJECT_NAME%%>\n\n## 1. Project\n\n- **Audience:** <%%AUDIENCE%%>\n- **Reader test** (every `comprehension` pass reads as this person): <%%READER_TEST%%>\n\n## 3. Project-specific rules\n' > "$t/template/.claude/CLAUDE.md"
  printf 'AUDIENCE:\n  type: str\n  default: invented general readers\nREADER_TEST:\n  type: str\n  default: an invented reader at the end of a working day\n' >> "$t/copier.yml"
  # v0.1.0 predates D47: no agent question, entrypoint, link, client setting or bridge, and a
  # rules 05 with no Section 4. The fixture's later release ships them, so check 29 proves an
  # update across it never adds a client's file, and checks 31–34 (Trap 1) that the update
  # which first asks AGENT_CLIENTS records none.
  mkdir -p "$t.held"
  (cd "$t/template" && mv AGENTS.md GEMINI.md .agents .codex opencode.json .claude/syntek-author-agents.md \
     .claude/rules/syntek-author/05-model-allocation.md "$t.held/")
  printf '# 05 — model allocation\n\n## 1. The two tiers\n' > "$t/template/$RULES05"
  awk '/^# BEGIN fixture agent questions/ { on = 1 } !on { print } /^# END fixture agent questions/ { on = 0 }' \
    "$t/copier.yml" > "$t.copier-v010"
  awk '/^# BEGIN fixture agent questions/ { on = 1 } on { print } /^# END fixture agent questions/ { on = 0 }' \
    "$t/copier.yml" > "$t.agent-questions"
  cp "$t.copier-v010" "$t/copier.yml"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture v0.1.0' && sa_git "$t" tag v0.1.0
  (cd "$t.held" && mv AGENTS.md GEMINI.md .agents .codex opencode.json "$t/template/" \
     && mv syntek-author-agents.md "$t/template/.claude/" \
     && mv 05-model-allocation.md "$t/template/.claude/rules/syntek-author/") && rmdir "$t.held"
  cat "$t.agent-questions" >> "$t/copier.yml"; rm -f "$t.copier-v010" "$t.agent-questions"
  sed -i 's#/library/src/proposals/drafts/example-proposal<#/library/src/business/drafts/example-proposal<#' "$t/copier.yml"
  mkdir -p "$t/template/library/src/business/drafts"
  mv "$t/template/library/src/proposals/drafts/example-proposal" "$t/template/library/src/business/drafts/"
  for old in proposals contracts policies correspondence finance marketing; do rm -rf "${t:?}/template/library/src/$old"; done
  for f in business legal email accounting social-media email/client-emails; do
    mkdir -p "$t/template/library/src/$f"; printf '# CONTEXT.md — library/src/%s/\n' "$f" > "$t/template/library/src/$f/CONTEXT.md"
  done
  mkdir -p "$t/migrations" "$t/template/.claude/rules/syntek-author"
  cp "$SA_ROOT/$MIGRATION_SCRIPT" "$t/$MIGRATION_SCRIPT" || die "no $MIGRATION_SCRIPT in $SA_ROOT"
  cp "$SA_ROOT/$SETTINGS_SCRIPT" "$t/$SETTINGS_SCRIPT" || die "no $SETTINGS_SCRIPT in $SA_ROOT"
  printf '# 00-project.md\n\n## Brief\n\n- **Audience:** <%%AUDIENCE%%>\n- **Reader test** (every `comprehension` pass reads as this person): <%%READER_TEST%%>\n\n## Paths\n' > "$t/template/$SETTINGS_FILE"
  cat >> "$t/copier.yml" <<'EOF'
BUSINESS_FAMILIES:
  type: str
  multiselect: true
  choices: [business, legal, email, accounting, social-media, msp-scp]
  default: [business, legal, email, accounting, social-media]
  when: "<% DOC_TYPE == 'business' %>"
_migrations:
  - version: v0.2.0
    command: bash "<% _copier_conf.src_path %>/migrations/v0.2.0-business-families.sh"
    when: "<% _stage == 'after' and DOC_TYPE == 'business' %>"
  - version: v0.2.0
    command: bash "<% _copier_conf.src_path %>/migrations/v0.2.0-project-settings.sh"
    when: "<% _stage == 'after' %>"
EOF
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'fixture v0.2.0' && sa_git "$t" tag v0.2.0
}

# ── The update report and the shared-file refresh (D51, D52, checks 44–54) ───

RP_RAN=false; SH_RAN=false
RP_SHARED=".claude/skills/wait-what/SKILL.md .claude/skills/grill-me/SKILL.md .claude/hooks/context-threshold-handoff.sh"
RP_ARRIVES=".claude/skills/to-questionnaire/SKILL.md"
RP_HOOK_CMD="bash -c 'exec bash .claude/hooks/context-threshold-handoff.sh'"
SHARED_EDIT=".claude/skills/grill-me/SKILL.md"
SHARED_MARK="Update-test: the author's own line in a shared skill."
PRE_D51_REF="b4669a5"   # main before D51 and D52: the commit this work branched from
RP_HEAD="▸ syntek-author update report"
# Where each planted file of the report fixture must be listed (checks 44 and 45).
RP_WANT=$(cat <<'EOF'
.claude/rules/syntek-author/01-layout-and-routing.md	CONFLICT
notes/retired.md	DELETED by this update although you had changed them
.gitignore	NOT UPDATED because you had changed them
.claude/skills/grill-me/SKILL.md	NOT UPDATED because you had changed them
README.md	NOT UPDATED because files of this kind are written once
notes/shared.md	NOT UPDATED because it is new in this version
planning/src/units/01-example-chapter.md	NOT RESTORED because you had deleted them
planning/src/units/02-example-chapter.md	NOT ADDED
EOF
)

# The report's sections, from the last report in a log: "section<TAB>path" per entry.
report_sections() { # $1 = log
  python3 - "$1" <<'PY'
import re, sys
lines = open(sys.argv[1], encoding="utf-8", errors="replace").read().splitlines()
starts = [i for i, l in enumerate(lines) if re.match(r"▸ \S+ update report", l)]
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

# Runs every git command a report printed, each in a fresh copy of the project, offline.
# Prints one line per command that failed, then "COUNT n".
report_commands() { # $1 = log, $2 = project
  python3 - "$1" "$2" <<'PY'
import os, re, shlex, shutil, subprocess, sys, tempfile
log, proj = sys.argv[1:]
lines = open(log, encoding="utf-8", errors="replace").read().splitlines()
cmds = [l.split(":", 1)[1].strip() for l in lines if re.match(r"\s+(compare|take|see|restore|yours):\s+git ", l)]
cmds += [l.strip() for l in lines if re.match(r"\s+git (log|diff) ", l) and "<path>" not in l]
env = dict(os.environ, GIT_TERMINAL_PROMPT="0", GIT_PAGER="cat", GIT_ALLOW_PROTOCOL="file")
for c in dict.fromkeys(cmds):
    with tempfile.TemporaryDirectory() as t:
        trial = os.path.join(t, "p")
        shutil.copytree(proj, trial, symlinks=True)
        r = subprocess.run(shlex.split(c), cwd=trial, capture_output=True, text=True, env=env)
        if r.returncode:
            print(f"{c} (exit {r.returncode}: {r.stderr.strip()[:80]})")
print(f"COUNT {len(cmds)}")
PY
}

# A file of the template at a ref, written to $3 (absent: returns 1).
tpl_file() { # $1 = template repo, $2 = ref, $3 = path under template/, $4 = dest
  git -C "$1" cat-file -e "$2:template/$3" 2>/dev/null && git -C "$1" show "$2:template/$3" > "$4"
}

# Three tagged releases of the fixture with the real update script: each section of the
# report gets one planted file (RP_WANT), and the shared set gets a refresh, an owner edit and
# an arrival. With $2 = early (check 91), release 2 already offers what release 3 offers in the
# settings and MCP lanes, and the D54 deny and asks too: the hook entry, autoCompactEnabled,
# the nine rules and the two servers, so an update to it that is discarded has offered them.
report_fixture() { # $1 = dest, $2 = early (optional)
  local t="$1" early="${2:-}"
  sa_fixture_template "$t" >/dev/null
  sa_add_update "$t" syntek-author "$RP_SHARED $RP_ARRIVES" mcp || die "could not give the fixture the update script"
  # D54: the first two releases declare no MCP server in the seed .mcp.json; the third does, so
  # the update to it runs the real lane, which adds them to the owner's unedited file.
  printf '{\n  "mcpServers": {}\n}\n' > "$t/template/.mcp.json"
  rm -rf "${t:?}/template/.claude/skills/to-questionnaire"
  mkdir -p "$t/template/notes"
  printf '# Retired notes\n\nTemplate-owned; release 1.\n' > "$t/template/notes/retired.md"
  printf '# CONTEXT.md — notes/\n' > "$t/template/notes/CONTEXT.md"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'release 1' && sa_git "$t" tag v0.1.0
  printf '\nRelease 2.\n' >> "$t/template/README.md"
  printf '\nRevision 2.\n' >> "$t/template/.claude/skills/wait-what/SKILL.md"
  if [[ "$early" == early ]]; then
    python3 - "$t/template/.claude/settings.json" "$RP_HOOK_CMD" "$t/migrations/family-refresh.json" "$SA_MCP_DENY" "$SA_MCP_ASKS" <<'PY'
import json, sys
path, cmd, data, deny, asks = sys.argv[1:]
rules = {"deny": [deny], "ask": asks.split()}
json.dump({"model": "opus", "autoCompactEnabled": False,
           "hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": cmd, "timeout": 10}]}]},
           "permissions": rules}, open(path, "w"), indent=2)
d = json.load(open(data, encoding="utf-8"))
d["settings"] = {"autoCompactEnabled": False, **d["settings"], "permissions": rules}
json.dump(d, open(data, "w", encoding="utf-8"), indent=2)
PY
    printf '%s' "$SA_MCP_SHARED" > "$t/template/.mcp.json"
  fi
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'release 2' && sa_git "$t" tag v0.2.0
  printf '\nRelease 3.\n' >> "$t/template/README.md"
  printf '\nRevision 3.\n' >> "$t/template/.claude/skills/wait-what/SKILL.md"
  printf '\nRevision 3.\n' >> "$t/template/.claude/skills/grill-me/SKILL.md"
  sed -i 's/^Template-owned; updated by copier update\.$/Template-owned; changed in release 3./' "$t/template/$RULES01"
  rm "$t/template/notes/retired.md"
  printf '*.log\n' >> "$t/template/.gitignore"
  printf '\nRelease 3.\n' >> "$t/template/planning/src/units/01-example-chapter.md"
  printf '# A second example brief\n' > "$t/template/planning/src/units/02-example-chapter.md"
  printf '# Shared notes\n\nCopy-only; release 3.\n' > "$t/template/notes/shared.md"
  printf '%s' "$SA_MCP_SHARED" > "$t/template/.mcp.json"
  mkdir -p "$t/template/.claude/skills/to-questionnaire"
  printf -- '---\nname: to-questionnaire\ndescription: A shared skill.\n---\n\n# Skill: to-questionnaire\n' > "$t/template/$RP_ARRIVES"
  python3 - "$t/template/.claude/settings.json" "$RP_HOOK_CMD" "$t/migrations/family-refresh.json" <<'PY'
import json, sys
# Release 2's settings kept (the early fixture's rules), the hook and the value set.
s = json.load(open(sys.argv[1], encoding="utf-8"))
s.update({"model": "opus", "autoCompactEnabled": False,
          "hooks": {"UserPromptSubmit": [{"hooks": [{"type": "command", "command": sys.argv[2], "timeout": 10}]}]}})
json.dump(s, open(sys.argv[1], "w"), indent=2)
# Release 3 also offers the top-level autoCompactEnabled, as the real family-refresh.json does.
d = json.load(open(sys.argv[3], encoding="utf-8"))
d["settings"] = {"autoCompactEnabled": False, **d["settings"]}
json.dump(d, open(sys.argv[3], "w", encoding="utf-8"), indent=2)
PY
  python3 - "$t/copier.yml" <<'PY'
import sys
p = sys.argv[1]
lines = open(p, encoding="utf-8").read().split("\n")
i = lines.index("_exclude:")
lines[i + 1:i + 1] = ["  - \"<: if _copier_operation == 'update' or not SEED_EXAMPLES :>/planning/src/units/02-example-chapter.md<: endif :>\"",
                      "  - \"<: if _copier_operation == 'update' :>/notes/shared.md<: endif :>\""]
i = lines.index("_skip_if_exists:")
lines[i + 1:i + 1] = ["  - /notes/shared.md"]
open(p, "w", encoding="utf-8").write("\n".join(lines))
PY
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'release 3' && sa_git "$t" tag v0.3.0
  printf '\nRelease 4.\n' >> "$t/template/$RULES01"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'release 4' && sa_git "$t" tag v0.4.0
}

rp_copy() { # $1 = template, $2 = ref, $3 = dest, $4 = DOC_TYPE, then extra copier arguments
  local src="$1" ref="$2" dest="$3" doc="$4"; shift 4
  "${SA_COPIER[@]}" copy --trust --defaults --vcs-ref="$ref" \
    --data "PROJECT_NAME=$SA_RENDER_NAME" --data "PROJECT_DESCRIPTION=$SA_RENDER_DESCRIPTION" \
    --data "AUTHOR_NAME=$SA_RENDER_AUTHOR" --data "DATE=$SA_RENDER_DATE" --data "DOC_TYPE=$doc" \
    "$@" "$src" "$dest" </dev/null
}
rp_update() { # $1 = project, $2 = ref, then extra copier arguments
  local p="$1" ref="$2"; shift 2
  (cd "$p" && "${SA_COPIER[@]}" update --trust --defaults --vcs-ref="$ref" --answers-file "$SA_ANSWERS_FILE" "$@" </dev/null)
}
rp_hand() { # $1 = project, then environment assignments: one hand run of the update stage
  local p="$1"; shift
  (cd "$p" && env SYNTEK_UPDATE_COPIER="${SA_COPIER[*]}" VERSION_FROM=v0.2.0 "$@" \
     python3 "$RP_TPL/migrations/family-update.py" update --src "$RP_TPL" --to "$RP_TO" --answers "$SA_ANSWERS_FILE")
}

rp_state() { # $1 = project → every path git status lists, with its status and the sha1 of its bytes
  local p="$1" line f
  git -C "$p" status --porcelain -uall | LC_ALL=C sort | while IFS= read -r line; do
    f="${line:3}"
    if [[ -f "$p/$f" ]]; then printf '%s %s\n' "$line" "$(sha1sum < "$p/$f" | cut -d' ' -f1)"; else printf '%s -\n' "$line"; fi
  done
}

RP_TPL=""; RP_TO=""; RP_PROJ=""; RP_LOG=""; RP_REJ_LOG=""; RP_STATUS=0; RP_REJ_STATUS=0; RP_COPY=0
RP_BEYOND=""; RP_CMD_FAILS=""; RP_CMD_COUNT=0; RP_RERUN_CHANGED=""; RP_AGAIN_STATUS=0; RP_AGAIN_DIRTY=""; RP_AGAIN_LOG=""
RP_ONE_LINE=()
# Checks 86–88, by how the update was discarded (reset, stash): the exit status of the flow's
# steps, what the second run delivered differently, whether its record sits on the one HEAD
# committed ("ok"), and what a hand rerun over its uncommitted tree changed.
declare -A RP_REDO_ST=() RP_REDO_DIFF=() RP_REDO_CHAIN=() RP_REDO_RERUN=()
# Check 90: a .claude/settings.json the owner keeps out of git, through two updates.
RP_IGN_LINE=".claude/settings.json is ignored by git, so it was not read"
RP_IGN_ST=0; RP_IGN_STAT_PRE=""; RP_IGN_STAT_POST=""; RP_IGN_N1=0; RP_IGN_N2=0; RP_IGN_REC=0
# Check 91, on the early fixture: the flow's status, what the discarded update to v0.2.0 failed to
# offer and what the direct update to v0.3.0 failed to deliver (so the comparison means
# something), how the two results differ, how their records' offer and written-blob lines
# differ, and whether the result's record sits on the one HEAD committed ("ok").
RP_LATER_ST=0; RP_LATER_MISSING=""; RP_LATER_DIFF=""; RP_LATER_REC=""; RP_LATER_CHAIN=""
run_report_flow() { # $1 = work dir — the fixture flow, the same in the real run and the self-test
  local w="$1/rp" log="$1/rp-flow.log" p off rej before after k out d st base first
  RP_RAN=true; RP_TPL="$w/tpl"; RP_PROJ="$w/proj"; RP_LOG="$w/update.log"; RP_REJ_LOG="$w/rej.log"; RP_AGAIN_LOG="$w/again.log"
  RP_STATUS=0; RP_REJ_STATUS=0; RP_COPY=0; RP_AGAIN_STATUS=0; RP_ONE_LINE=()
  mkdir -p "$w"; : > "$RP_LOG"; : > "$RP_REJ_LOG"; : > "$RP_AGAIN_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  report_fixture "$RP_TPL"
  RP_TO="$(git -C "$RP_TPL" rev-parse v0.3.0)"
  rp_copy "$RP_TPL" v0.1.0 "$RP_PROJ" theology >>"$log" 2>&1 || RP_COPY=$?
  [[ "$RP_COPY" -eq 0 ]] || return 0
  p="$RP_PROJ"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied at v0.1.0' >>"$log" 2>&1
  # The author at work: one file for each section of the report.
  printf 'mine/\n' >> "$p/.gitignore"
  printf '\n%s\n' "$SHARED_MARK" >> "$p/$SHARED_EDIT"
  sed -i 's/^Template-owned; updated by copier update\.$/Template-owned; my own wording./' "$p/$RULES01"
  printf 'An edit the author made.\n' >> "$p/notes/retired.md"
  rm -f "$p/planning/src/units/01-example-chapter.md"
  printf '# My own shared notes\n' > "$p/notes/shared.md"
  printf '{\n  "model": "opus",\n  "permissions": {\n    "allow": ["Bash(make *)"]\n  }\n}\n' > "$p/.claude/settings.json"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'the author at work' >>"$log" 2>&1
  rp_update "$p" v0.2.0 >>"$log" 2>&1 || RP_STATUS=$?
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated to v0.2.0' >>"$log" 2>&1 || true
  rej="$w/proj-rej"; off="$w/proj-off"
  cp -a "$p" "$rej"; cp -a "$p" "$off"
  rp_update "$p" v0.3.0 >"$RP_LOG" 2>&1 || RP_STATUS=$?
  rp_update "$rej" v0.3.0 --conflict rej >"$RP_REJ_LOG" 2>&1 || RP_REJ_STATUS=$?
  (export SYNTEK_UPDATE_REPORT=off; rp_update "$off" v0.3.0) >>"$log" 2>&1 || true
  cat "$RP_LOG" "$RP_REJ_LOG" >>"$log"
  # 47: what the report changed beyond the update itself (the opt-out renders and refreshes nothing).
  RP_BEYOND="$(comm -23 <(git -C "$p" status --porcelain -uall | cut -c4- | LC_ALL=C sort) \
                        <(git -C "$off" status --porcelain -uall | cut -c4- | LC_ALL=C sort) | paste -sd' ' -)"
  # 48: every printed command, offline.
  out="$(report_commands "$RP_LOG" "$p")"
  RP_CMD_COUNT="$(sed -n 's/^COUNT //p' <<< "$out")"; RP_CMD_FAILS="$(grep -v '^COUNT ' <<< "$out" || true)"
  # 49: a hand rerun at the same versions changes nothing; then a second update is quiet.
  before="$(git -C "$p" status --porcelain; git -C "$p" for-each-ref)"
  rp_hand "$p" >>"$log" 2>&1 || true
  after="$(git -C "$p" status --porcelain; git -C "$p" for-each-ref)"
  [[ "$before" == "$after" ]] && RP_RERUN_CHANGED="" || RP_RERUN_CHANGED="$(diff <(echo "$before") <(echo "$after") | grep '^[<>]' | head -3 | paste -sd' ' - || true)"
  sa_git "$p" checkout -q syntek-author/template -- "$RULES01" >>"$log" 2>&1 || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated to v0.3.0' >>"$log" 2>&1 || true
  rp_update "$p" v0.3.0 >"$RP_AGAIN_LOG" 2>&1 || RP_AGAIN_STATUS=$?
  RP_AGAIN_DIRTY="$(git -C "$p" status --porcelain)"
  # 50: the limits, each a hand run in a fresh clone (no record): one line, exit 0.
  for k in off no-copier no-old-version; do
    git clone -q "$p" "$w/clone-$k" >>"$log" 2>&1
    case "$k" in
      off)            out="$(rp_hand "$w/clone-$k" SYNTEK_UPDATE_REPORT=off 2>&1)" ;;
      no-copier)      out="$(cd "$w/clone-$k" && SYNTEK_UPDATE_COPIER=/nonexistent/copier VERSION_FROM=v0.2.0 python3 "$RP_TPL/migrations/family-update.py" update --src "$RP_TPL" --to "$RP_TO" --answers "$SA_ANSWERS_FILE" 2>&1)" ;;
      no-old-version) out="$(rp_hand "$w/clone-$k" VERSION_FROM=v9.9.9 2>&1)" ;;
    esac
    RP_ONE_LINE+=("$k"$'\t'"$?"$'\t'"$(printf '%s\n' "$out" | grep -c . || true)"$'\t'"$(printf '%s' "$out" | head -1)")
  done
  # 86–88: an update discarded and run again delivers what the first run did, on the record HEAD
  # committed; a hand rerun over the second run's uncommitted tree changes nothing.
  RP_REDO_ST=(); RP_REDO_DIFF=(); RP_REDO_CHAIN=(); RP_REDO_RERUN=()
  for k in reset stash; do
    d="$w/discard-$k"; st=0
    rp_copy "$RP_TPL" v0.2.0 "$d" theology >>"$log" 2>&1 || st=$?
    if [[ "$st" -eq 0 ]]; then
      { sa_git "$d" add -A && sa_git "$d" commit -q -m 'copied at v0.2.0'; } >>"$log" 2>&1 || st=$?
      base="$(git -C "$d" rev-parse -q --verify refs/syntek-author/template 2>/dev/null || true)"
      rp_update "$d" v0.3.0 >>"$log" 2>&1 || st=$?
      first="$(rp_state "$d")"
      if [[ "$k" == reset ]]; then
        { sa_git "$d" reset -q --hard && sa_git "$d" clean -q -fd; } >>"$log" 2>&1 || st=$?
      else
        sa_git "$d" stash push -q -u >>"$log" 2>&1 || st=$?
      fi
      [[ -z "$(git -C "$d" status --porcelain)" ]] || st=99   # the update was not discarded
      rp_update "$d" v0.3.0 >>"$log" 2>&1 || st=$?
      out="$(rp_state "$d")"
      if [[ -z "$first" ]]; then
        RP_REDO_DIFF[$k]="the first update changed nothing"
      else
        RP_REDO_DIFF[$k]="$(diff <(echo "$first") <(echo "$out") | grep '^[<>]' | head -3 | paste -sd' ' - || true)"
      fi
      out="$(git -C "$d" rev-parse -q --verify 'refs/syntek-author/template^' 2>/dev/null || true)"
      [[ -n "$base" && "$out" == "$base" ]] && RP_REDO_CHAIN[$k]=ok || RP_REDO_CHAIN[$k]="its parent is '${out:-none}', not '${base:-none}'"
      before="$(git -C "$d" status --porcelain; git -C "$d" for-each-ref)"
      rp_hand "$d" >>"$log" 2>&1 || true
      after="$(git -C "$d" status --porcelain; git -C "$d" for-each-ref)"
      RP_REDO_RERUN[$k]="$(diff <(echo "$before") <(echo "$after") | grep '^[<>]' | head -3 | paste -sd' ' - || true)"
    fi
    RP_REDO_ST[$k]="$st"
  done
  # 90: a settings.json the owner keeps out of git is never read or written; each update names
  # the entries to add by hand once, and none is recorded as offered.
  d="$w/settings-ignored"; st=0; RP_IGN_STAT_PRE=""; RP_IGN_STAT_POST=""; RP_IGN_N1=0; RP_IGN_N2=0; RP_IGN_REC=0
  rp_copy "$RP_TPL" v0.2.0 "$d" theology >>"$log" 2>&1 || st=$?
  if [[ "$st" -eq 0 ]]; then
    { sa_git "$d" add -A && sa_git "$d" commit -q -m 'copied at v0.2.0'
      printf '/.claude/settings.json\n' >> "$d/.gitignore"
      sa_git "$d" rm -q --cached .claude/settings.json
      sa_git "$d" add -A && sa_git "$d" commit -q -m 'my settings stay out of git'; } >>"$log" 2>&1 || st=$?
    RP_IGN_STAT_PRE="$(dt_stat "$d/.claude/settings.json")"
    rp_update "$d" v0.3.0 >"$w/ignored-1.log" 2>&1 || st=$?
    { sa_git "$d" add -A && sa_git "$d" commit -q -m 'updated to v0.3.0'; } >>"$log" 2>&1 || st=$?
    rp_update "$d" v0.4.0 >"$w/ignored-2.log" 2>&1 || st=$?
    cat "$w/ignored-1.log" "$w/ignored-2.log" >>"$log"
    RP_IGN_N1="$(grep -cF "$RP_IGN_LINE" "$w/ignored-1.log" || true)"
    RP_IGN_N2="$(grep -cF "$RP_IGN_LINE" "$w/ignored-2.log" || true)"
    RP_IGN_REC="$(git -C "$d" log -1 --format=%B refs/syntek-author/template 2>/dev/null | grep -c '^settings: ' || true)"
    RP_IGN_STAT_POST="$(dt_stat "$d/.claude/settings.json")"
  fi
  RP_IGN_ST="$st"
  run_later_flow "$w" "$log"
}

# The offer and written-blob lines of a project's newest render record.
rp_record() { # $1 = project
  git -C "$1" log -1 --format=%B refs/syntek-author/template 2>/dev/null \
    | grep -E '^(settings-offered|settings|mcp-offered|mcp|written-blob): ' || true
}

# What the settings and MCP lanes owe a project of the early fixture at v0.2.0 or later: the D54
# deny and each ask once, the threshold hook once, autoCompactEnabled false, both servers in
# .mcp.json. Prints the missing ones, '; '-joined (nothing when all are there).
rp_holds() { # $1 = project
  python3 - "$1" "$RP_HOOK_CMD" "$SA_MCP_DENY" "$SA_MCP_ASKS" "$SA_MCP_SERVERS" <<'PY'
import json, sys
p, cmd, deny, asks, servers = sys.argv[1:]
def load(rel):
    try:
        v = json.load(open(p + "/" + rel, encoding="utf-8"))
    except (OSError, ValueError):
        return {}
    return v if isinstance(v, dict) else {}
s, m = load(".claude/settings.json"), load(".mcp.json")
perm = s.get("permissions") if isinstance(s.get("permissions"), dict) else {}
miss = [] if (perm.get("deny") or []).count(deny) == 1 else ["the deny " + deny]
miss += ["the ask " + a for a in asks.split() if (perm.get("ask") or []).count(a) != 1]
hooks = [h for e in ((s.get("hooks") or {}).get("UserPromptSubmit") or []) if isinstance(e, dict)
         for h in (e.get("hooks") or []) if isinstance(h, dict) and h.get("command") == cmd]
miss += [] if len(hooks) == 1 else ["the threshold hook once"]
miss += [] if s.get("autoCompactEnabled") is False else ["autoCompactEnabled false"]
miss += ["the server %s in .mcp.json" % x for x in servers.split() if x not in (m.get("mcpServers") or {})]
print("; ".join(miss))
PY
}

# 91: copied at the early fixture's first release, updated to its second, the update discarded
# with git reset --hard and git clean -fd, then updated to its third, against a direct update from
# the first to the third: every path git status lists, with its status and bytes, the record's
# offers and written blobs, and the record on the one HEAD committed.
run_later_flow() { # $1 = the report flow's work dir, $2 = its log
  local w="$1" log="$2" t="$1/tpl-later" a="$1/later-direct" d="$1/later-discarded" st=0 base first out f
  RP_LATER_ST=0; RP_LATER_MISSING=""; RP_LATER_DIFF=""; RP_LATER_REC=""; RP_LATER_CHAIN=""
  report_fixture "$t" early >>"$log" 2>&1 || st=$?
  if [[ "$st" -eq 0 ]]; then
    rp_copy "$t" v0.1.0 "$a" theology >>"$log" 2>&1 || st=$?
    rp_copy "$t" v0.1.0 "$d" theology >>"$log" 2>&1 || st=$?
  fi
  if [[ "$st" -eq 0 ]]; then
    { sa_git "$a" add -A && sa_git "$a" commit -q -m 'copied at v0.1.0'
      sa_git "$d" add -A && sa_git "$d" commit -q -m 'copied at v0.1.0'; } >>"$log" 2>&1 || st=$?
    rp_update "$a" v0.3.0 >>"$log" 2>&1 || st=$?
    base="$(git -C "$d" rev-parse -q --verify refs/syntek-author/template 2>/dev/null || true)"
    rp_update "$d" v0.2.0 >>"$log" 2>&1 || st=$?
    first="$(rp_holds "$d")"
    [[ -z "$first" ]] || RP_LATER_MISSING="the discarded update to v0.2.0 did not offer $first"
    { sa_git "$d" reset -q --hard && sa_git "$d" clean -q -fd; } >>"$log" 2>&1 || st=$?
    [[ -z "$(git -C "$d" status --porcelain)" ]] || st=99   # the update was not discarded
    rp_update "$d" v0.3.0 >>"$log" 2>&1 || st=$?
    out="$(rp_holds "$a")"
    for f in .claude/skills/wait-what/SKILL.md .claude/skills/grill-me/SKILL.md "$RP_ARRIVES"; do
      cmp -s "$a/$f" <(git -C "$t" show "v0.3.0:template/$f") || out+="${out:+; }the shared $f at v0.3.0"
    done
    [[ -z "$out" ]] || RP_LATER_MISSING+="${RP_LATER_MISSING:+; }the direct update to v0.3.0 did not deliver $out"
    RP_LATER_DIFF="$(diff <(rp_state "$a") <(rp_state "$d") | grep '^[<>]' | head -3 | paste -sd' ' - || true)"
    RP_LATER_REC="$(diff <(rp_record "$a") <(rp_record "$d") | grep '^[<>]' | head -3 | paste -sd' ' - || true)"
    out="$(git -C "$d" rev-parse -q --verify 'refs/syntek-author/template^' 2>/dev/null || true)"
    [[ -n "$base" && "$out" == "$base" ]] && RP_LATER_CHAIN=ok || RP_LATER_CHAIN="its parent is '${out:-none}', not '${base:-none}'"
  fi
  RP_LATER_ST="$st"
}

report_checks() {
  local L="[report fixture]" path sec got line k rc n first lane
  if [[ "$RP_COPY" -ne 0 ]]; then finding "check 44 — $L the fixture did not copy at v0.1.0 (exit $RP_COPY)"; return 0; fi
  if [[ "$RP_STATUS" -ne 0 ]] || ! grep -qF "$RP_HEAD" "$RP_LOG"; then
    finding "check 44 — $L the update to v0.3.0 failed (exit $RP_STATUS) or printed no update report — see $RP_LOG"
  else
    got="$(report_sections "$RP_LOG")"
    while IFS=$'\t' read -r path sec; do
      [[ -z "$path" ]] && continue
      line="$(awk -F'\t' -v p="$path" '$2 == p { print $1; exit }' <<< "$got")"
      [[ "$line" == "$sec"* ]] || finding "check 44 — $L $path is listed under '${line:-nothing}', not '$sec'"
    done <<< "$RP_WANT"
  fi
  if [[ "$RP_REJ_STATUS" -ne 0 ]] || ! report_sections "$RP_REJ_LOG" | grep -q "^REJECTED HUNKS.*"$'\t'"$RULES01\$"; then
    finding "check 45 — $L with --conflict rej, $RULES01 is not listed under REJECTED HUNKS (exit $RP_REJ_STATUS) — see $RP_REJ_LOG"
  fi
  for path in .claude/skills/wait-what/SKILL.md "$RP_ARRIVES"; do
    cmp -s "$RP_PROJ/$path" <(git -C "$RP_TPL" show "v0.3.0:template/$path") \
      || finding "check 46 — $L the shared $path is not the v0.3.0 version: an unedited shared file is refreshed, a new one arrives"
  done
  grep -qF "$SHARED_MARK" "$RP_PROJ/$SHARED_EDIT" && ! grep -q 'Revision 3' "$RP_PROJ/$SHARED_EDIT" \
    || finding "check 46 — $L the owner's edit to the shared $SHARED_EDIT did not survive untouched"
  python3 - "$RP_PROJ/.claude/settings.json" <<'PY' || finding "check 46 — $L .claude/settings.json did not gain the threshold hook exactly once beside the owner's allow rule"
import json, sys
d = json.load(open(sys.argv[1]))
ups = [h for e in d.get("hooks", {}).get("UserPromptSubmit", []) for h in e.get("hooks", [])]
sys.exit(0 if len(ups) == 1 and "context-threshold-handoff.sh" in ups[0]["command"] and d["permissions"]["allow"] == ["Bash(make *)"] else 1)
PY
  # The files the MCP lane said it wrote (D54) are allowed too, and only those.
  lane="$(sed -nE 's/^▸ [^:]+: added [0-9]+ MCP servers? to ([^ :]+)( \(.*\))?: .*/\1/p' "$RP_LOG" | LC_ALL=C sort -u)"
  # shellcheck disable=SC2086  # one argument per path the lane wrote
  [[ "$RP_BEYOND" == "$(printf '%s\n' .claude/settings.json .claude/skills/to-questionnaire/SKILL.md .claude/skills/wait-what/SKILL.md $lane | LC_ALL=C sort -u | paste -sd' ' -)" ]] \
    || finding "check 47 — $L beyond the update's own changes, the report changed '${RP_BEYOND:-nothing}' — only the refreshed and added shared files, settings.json and the files the MCP lane wrote may change"
  [[ -z "$RP_CMD_FAILS" && "${RP_CMD_COUNT:-0}" -ge 12 ]] \
    || finding "check 48 — $L a printed command failed offline, or too few were printed (${RP_CMD_COUNT:-0}): ${RP_CMD_FAILS:-none failed}"
  [[ -z "$RP_RERUN_CHANGED" ]] || finding "check 49 — $L a second run of the update stage at the same versions changed something: $RP_RERUN_CHANGED"
  n="$(grep -c "^$RP_HEAD" "$RP_AGAIN_LOG" || true)"
  if [[ "$RP_AGAIN_STATUS" -ne 0 || -n "$RP_AGAIN_DIRTY" || "$n" -ne 1 ]] || grep -qE '^  (NOT|CONFLICT|DELETED|REJECTED)' "$RP_AGAIN_LOG"; then
    finding "check 49 — $L a second update with nothing new was not a quiet no-op (exit $RP_AGAIN_STATUS; $(printf '%s\n' "$RP_AGAIN_DIRTY" | grep -c . || true) path(s) changed; $n report line(s))"
  fi
  for line in "${RP_ONE_LINE[@]}"; do
    IFS=$'\t' read -r k rc n first <<< "$line"
    [[ "$rc" -eq 0 && "$n" -eq 1 ]] || finding "check 50 — $L $k: the update stage printed $n line(s) and exited $rc, not one line and 0 ('$first')"
  done
  for k in reset stash; do
    n=86; [[ "$k" == stash ]] && n=87
    if [[ "${RP_REDO_ST[$k]:-none}" != 0 ]]; then
      finding "check $n — $L the copy, the update, its discarding ($k) or the second run failed (status ${RP_REDO_ST[$k]:-none})"
    elif [[ -n "${RP_REDO_DIFF[$k]:-}" ]]; then
      finding "check $n — $L after the update was discarded ($k), the second run did not deliver what the first did: ${RP_REDO_DIFF[$k]}"
    elif [[ "${RP_REDO_CHAIN[$k]:-}" != ok ]]; then
      finding "check $n — $L after the update was discarded ($k), the second run's record is not on the record HEAD committed: ${RP_REDO_CHAIN[$k]:-none}"
    fi
    [[ -z "${RP_REDO_RERUN[$k]:-}" ]] \
      || finding "check 88 — $L a hand rerun over the uncommitted tree of the second run ($k) changed something: ${RP_REDO_RERUN[$k]}"
  done
  if [[ "$RP_IGN_ST" -ne 0 ]]; then
    finding "check 90 — $L the project whose owner keeps .claude/settings.json out of git did not copy or update (status $RP_IGN_ST)"
  elif [[ -z "$RP_IGN_STAT_PRE" || "$RP_IGN_STAT_POST" != "$RP_IGN_STAT_PRE" || "$RP_IGN_N1" -ne 1 || "$RP_IGN_N2" -ne 1 || "$RP_IGN_REC" -ne 0 ]]; then
    finding "check 90 — $L the git-ignored .claude/settings.json was touched, or the two updates named its entries $RP_IGN_N1 and $RP_IGN_N2 time(s), not once each, or the record lists $RP_IGN_REC as offered"
  fi
  if [[ "$RP_LATER_ST" -ne 0 ]]; then
    finding "check 91 — $L the copies at v0.1.0, the update to v0.2.0, its discarding (reset and clean) or the update to v0.3.0 failed (status $RP_LATER_ST)"
  else
    [[ -z "$RP_LATER_MISSING" ]] || finding "check 91 — $L the comparison proves nothing: $RP_LATER_MISSING"
    [[ -z "$RP_LATER_DIFF" ]] \
      || finding "check 91 — $L after an update to v0.2.0 was discarded, the update to v0.3.0 did not give what a direct update from v0.1.0 gives: $RP_LATER_DIFF"
    [[ -z "$RP_LATER_REC" ]] \
      || finding "check 91 — $L after an update to v0.2.0 was discarded, the record of the update to v0.3.0 does not list a direct update's offers and written blobs: $RP_LATER_REC"
    [[ "$RP_LATER_CHAIN" == ok ]] \
      || finding "check 91 — $L after an update to v0.2.0 was discarded, the record of the update to v0.3.0 is not on the record HEAD committed: ${RP_LATER_CHAIN:-none}"
  fi
  return 0
}

# An update of a real project across D51 (checks 51–54): copied at $4, a shared skill edited,
# updated to $5, then updated again with nothing new.
SH_LABEL=""; SH_TPL=""; SH_TO=""; SH_PROJ=""; SH_LOG=""; SH_LOG2=""; SH_COPY=0; SH_UPDATE=0; SH_AGAIN=0
SH_DIRTY=""; SH_EDIT_SUM=""; SH_SETTINGS_BEFORE=""
run_shared_flow() { # $1 = template, $2 = work dir, $3 = DOC_TYPE, $4 = from ref, $5 = to ref, $6 = label
  local w="$2/sh-$6" log="$2/sh-$6.log"
  SH_RAN=true; SH_LABEL="$6 [$3]"; SH_TPL="$1"; SH_TO="$5"; SH_PROJ="$w/proj"; SH_LOG="$w/update.log"; SH_LOG2="$w/again.log"
  SH_COPY=0; SH_UPDATE=0; SH_AGAIN=0; SH_DIRTY=""; SH_SETTINGS_BEFORE="$w/settings.before"
  mkdir -p "$w"; : > "$SH_LOG"; : > "$SH_LOG2"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  rp_copy "$1" "$4" "$SH_PROJ" "$3" >>"$log" 2>&1 || SH_COPY=$?
  [[ "$SH_COPY" -eq 0 ]] || return 0
  [[ -d "$SH_PROJ/.git" ]] || sa_git "$SH_PROJ" init -q
  sa_git "$SH_PROJ" add -A && sa_git "$SH_PROJ" commit -q -m "copied at $4" >>"$log" 2>&1
  printf '\n%s\n' "$SHARED_MARK" >> "$SH_PROJ/$SHARED_EDIT"
  SH_EDIT_SUM="$(sum_of "$SH_PROJ/$SHARED_EDIT")"
  cp "$SH_PROJ/.claude/settings.json" "$SH_SETTINGS_BEFORE"
  sa_git "$SH_PROJ" add -A && sa_git "$SH_PROJ" commit -q -m 'a shared skill edited' >>"$log" 2>&1
  rp_update "$SH_PROJ" "$5" >"$SH_LOG" 2>&1 || SH_UPDATE=$?
  cat "$SH_LOG" >>"$log"
  sa_git "$SH_PROJ" add -A && sa_git "$SH_PROJ" commit -q -m "updated to $5" >>"$log" 2>&1 || true
  rp_update "$SH_PROJ" "$5" >"$SH_LOG2" 2>&1 || SH_AGAIN=$?
  cat "$SH_LOG2" >>"$log"
  SH_DIRTY="$(git -C "$SH_PROJ" status --porcelain)"
}

shared_checks() {
  local L="[$SH_LABEL]" p n tmpf
  if [[ "$SH_COPY" -ne 0 ]]; then finding "check 51 — $L the project did not copy (exit $SH_COPY)"; return 0; fi
  if [[ "$SH_UPDATE" -ne 0 ]] || ! grep -qF "$RP_HEAD" "$SH_LOG"; then
    finding "check 51 — $L the update failed (exit $SH_UPDATE) or printed no update report — see $SH_LOG"; return 0
  fi
  tmpf="$(dirname "$SH_LOG")/expected"
  for p in $(git -C "$SH_TPL" show "$SH_TO:migrations/family-refresh.json" 2>/dev/null | python3 -c 'import json,sys; print(" ".join(json.load(sys.stdin)["refresh"]))'); do
    [[ "$p" == "$SHARED_EDIT" ]] && continue
    tpl_file "$SH_TPL" "$SH_TO" "$p" "$tmpf" || continue
    cmp -s "$SH_PROJ/$p" "$tmpf" \
      || finding "check 51 — $L the shared $p is not the template's version after the update (unedited: it is refreshed, or it arrives)"
    [[ "$p" != *.sh || -x "$SH_PROJ/$p" ]] || finding "check 51 — $L the shared hook $p is not executable after the update"
  done
  [[ "$(sum_of "$SH_PROJ/$SHARED_EDIT" 2>/dev/null)" == "$SH_EDIT_SUM" ]] \
    || finding "check 52 — $L the owner's edit to the shared $SHARED_EDIT was overwritten or merged"
  n="$(report_sections "$SH_LOG" | awk -F'\t' -v p="$SHARED_EDIT" '$2 == p { print $1; exit }')"
  [[ "$n" == "NOT UPDATED because you had changed them"* ]] \
    || finding "check 52 — $L the edited $SHARED_EDIT is listed under '${n:-nothing}', not 'NOT UPDATED because you had changed them'"
  python3 - "$SH_SETTINGS_BEFORE" "$SH_PROJ/.claude/settings.json" <<'PY' || finding "check 53 — $L .claude/settings.json did not gain the context-threshold hook exactly once, add-only"
import json, sys
before, after = (json.load(open(f)) for f in sys.argv[1:])
def within(a, b):
    if isinstance(a, dict):
        return isinstance(b, dict) and all(k in b and within(v, b[k]) for k, v in a.items())
    if isinstance(a, list):
        return isinstance(b, list) and all(any(within(x, y) for y in b) for x in a)
    return a == b
ups = [h for e in after.get("hooks", {}).get("UserPromptSubmit", []) for h in e.get("hooks", [])
       if "context-threshold-handoff.sh" in h.get("command", "")]
sys.exit(0 if len(ups) == 1 and within(before, after) else 1)
PY
  n="$(grep -c "^$RP_HEAD" "$SH_LOG2" || true)"
  if [[ "$SH_AGAIN" -ne 0 || -n "$SH_DIRTY" || "$n" -ne 1 ]] || grep -qE '^  (NOT|CONFLICT|DELETED|REJECTED)' "$SH_LOG2"; then
    finding "check 54 — $L a second update was not a quiet no-op (exit $SH_AGAIN; $(printf '%s\n' "$SH_DIRTY" | grep -c . || true) path(s) changed; $n report line(s))"
  fi
  return 0
}

# ── settings.json across a copy over the owner's own, a removal and a copy without tasks
#    (D51, checks 55–59) ────────────────────────────────────────────────────────────────

SM_RAN=false
SM_HOOK="context-threshold-handoff.sh"
sm_existing() { # the owner's settings.json before the copy: four spaces, permissions first
  cat <<'EOF'
{
    "permissions": {
        "allow": [
            "Bash(make *)"
        ]
    },
    "model": "opus"
}
EOF
}
# Judges a settings.json: prints "ok", or what is wrong. $2 = how many threshold hooks it must
# wire (0 or 1); $3 = the autoCompactEnabled it must hold, written once (default false); the
# owner's four-space indentation, key order and allow rule must hold.
sm_judge() { # $1 = settings.json, $2 = hooks wanted, $3 = autoCompactEnabled wanted (false|true)
  python3 - "$1" "$2" "$SM_HOOK" "${3:-false}" <<'PY'
import json, re, sys
path, want, hook, compact = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
try:
    text = open(path, encoding="utf-8").read()
    d = json.loads(text)
except (OSError, ValueError) as e:
    print(f"unreadable ({e})"); sys.exit(0)
n = sum(1 for e in (d.get("hooks") or {}).get("UserPromptSubmit") or [] for h in e.get("hooks") or []
        if hook in h.get("command", ""))
bad = []
if n != want: bad.append(f"the threshold hook wired {n} time(s), not {want}")
k = len(re.findall(r'"autoCompactEnabled"\s*:', text))
if k != 1 or json.dumps(d.get("autoCompactEnabled")) != compact:
    bad.append(f"autoCompactEnabled written {k} time(s), {json.dumps(d.get('autoCompactEnabled'))}, not {compact} once")
if list(d)[:2] != ["permissions", "model"]: bad.append(f"the owner's key order changed ({list(d)})")
if (d.get("permissions") or {}).get("allow") != ["Bash(make *)"]: bad.append("the owner's allow rule changed")
if any("\t" in l or len(re.match(r" *", l).group(0)) % 4 for l in text.splitlines()): bad.append("the owner's four-space indentation was not kept")
print("; ".join(bad) or "ok")
PY
}
# The paths of this machine in a project's render record: an answers file in any recorded tree
# (the rendered one names Copier's temporary clone in _src_path), or a blob or message naming
# $2, $3, a temporary clone or an _src_path line.
sm_abs() { # $1 = project, $2 = template path, $3 = project path
  local revs rev
  revs="$(git -C "$1" rev-list refs/syntek-author/template 2>/dev/null)" || { echo "no record"; return 0; }
  { for rev in $revs; do
      git -C "$1" ls-tree -r --name-only "$rev" | grep -E '(^|/)\.copier-answers\.' | sed "s/^/answers file in $rev: /" || true
    done
    # shellcheck disable=SC2086  # one argument per commit
    git -C "$1" grep -l -F -e "$2" -e "$3" -e 'copier._vcs.clone' $revs 2>/dev/null || true
    # An _src_path line is a rendered answers file's, at the start of a line: the resolver
    # holds the text inside a string of its self-test, which names no path of this machine.
    # shellcheck disable=SC2086  # one argument per commit
    git -C "$1" grep -l -E -e '^_src_path:' $revs 2>/dev/null || true
    git -C "$1" log --format=%B refs/syntek-author/template | grep -F -e "$2" -e "$3" -e 'copier._vcs.clone' -e '_src_path:' || true
    # D54: an 'mcp:' or 'written-blob:' line's path is project-relative, inside the project.
    git -C "$1" log --format=%B refs/syntek-author/template \
      | awk '($1 == "mcp:" || $1 == "written-blob:") && ($2 ~ /^[\/~]/ || $2 ~ /^[A-Za-z]:/ || $2 ~ /(^|\/)\.\.(\/|$)/) { print "record line: " $0 }' || true
  } | head -3 | paste -sd' ' -
}

SM_COPY=(); SM_UPD=(); SM_A_COPIED=""; SM_A_UPDATED=""; SM_A_AGAIN_DIRTY=""; SM_A_SAME=true
SM_B_UPDATED=""; SM_B2_UPDATED=""; SM_C_RECORD=""; SM_C_UPDATED=""; SM_ABS=""
SM_T_COPIED=""; SM_T_UPDATED=""; SM_T_LINES=""
# The one line a copy prints for an owner's autoCompactEnabled other than false.
SM_KEPT='kept your "autoCompactEnabled": true in .claude/settings.json: the handoff hooks assume false; set it to false in .claude/settings.json to use them.'
run_sm_flow() { # $1 = the report fixture template (tags v0.3.0 and v0.4.0), $2 = work dir
  local w="$2/sm" log="$2/sm-flow.log" p k before
  SM_RAN=true; SM_COPY=(0 0 0 0 0); SM_UPD=(0 0 0 0 0 0); SM_A_SAME=true; SM_ABS=""
  mkdir -p "$w"
  for k in a b b2 c t; do
    p="$w/$k"; mkdir -p "$p/.claude"; sm_existing > "$p/.claude/settings.json"
    [[ "$k" == t ]] && sed -i 's/^    "model": "opus"$/    "model": "opus",\n    "autoCompactEnabled": true/' "$p/.claude/settings.json"
    { sa_git "$p" init -q && sa_git "$p" add -A && sa_git "$p" commit -q -m "the owner's own settings"; } >>"$log" 2>&1
  done
  # a: a copy over the owner's settings.json, an update, a second update.
  p="$w/a"
  rp_copy "$1" v0.3.0 "$p" theology >>"$log" 2>&1 || SM_COPY[0]=$?
  SM_A_COPIED="$(sm_judge "$p/.claude/settings.json" 1)"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied over my settings' >>"$log" 2>&1 || true
  rp_update "$p" v0.4.0 >>"$log" 2>&1 || SM_UPD[0]=$?
  SM_A_UPDATED="$(sm_judge "$p/.claude/settings.json" 1)"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated to v0.4.0' >>"$log" 2>&1 || true
  before="$(sha1sum < "$p/.claude/settings.json")"
  rp_update "$p" v0.4.0 >>"$log" 2>&1 || SM_UPD[1]=$?
  [[ "$(sha1sum < "$p/.claude/settings.json")" == "$before" ]] || SM_A_SAME=false
  SM_A_AGAIN_DIRTY="$(git -C "$p" status --porcelain)"
  SM_ABS="$(sm_abs "$p" "$1" "$p")"
  # b: the copy wires the hook, the owner removes it, the next update leaves it removed.
  p="$w/b"
  rp_copy "$1" v0.3.0 "$p" theology >>"$log" 2>&1 || SM_COPY[1]=$?
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied over my settings' >>"$log" 2>&1 || true
  python3 - "$p/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
d.pop("hooks", None)
open(sys.argv[1], "w").write(json.dumps(d, indent=4) + "\n")
PY
  sa_git "$p" commit -q -am 'I do not want the threshold hook' >>"$log" 2>&1 || true
  rp_update "$p" v0.4.0 >>"$log" 2>&1 || SM_UPD[2]=$?
  SM_B_UPDATED="$(sm_judge "$p/.claude/settings.json" 0)"
  # b2: as b, but the hook is removed before the copy is committed, so no commit ever held it
  # and only the render record knows it was offered.
  p="$w/b2"
  rp_copy "$1" v0.3.0 "$p" theology >>"$log" 2>&1 || SM_COPY[3]=$?
  python3 - "$p/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
d.pop("hooks", None)
open(sys.argv[1], "w").write(json.dumps(d, indent=4) + "\n")
PY
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied over my settings, without the hook' >>"$log" 2>&1 || true
  rp_update "$p" v0.4.0 >>"$log" 2>&1 || SM_UPD[4]=$?
  SM_B2_UPDATED="$(sm_judge "$p/.claude/settings.json" 0)"
  # c: a copy without tasks (no record); the first update adds the hook it never held.
  p="$w/c"
  rp_copy "$1" v0.3.0 "$p" theology --skip-tasks >>"$log" 2>&1 || SM_COPY[2]=$?
  SM_C_RECORD="$(git -C "$p" rev-parse -q --verify refs/syntek-author/template 2>/dev/null || true)"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied over my settings, no tasks' >>"$log" 2>&1 || true
  rp_update "$p" v0.4.0 >>"$log" 2>&1 || SM_UPD[3]=$?
  SM_C_UPDATED="$(sm_judge "$p/.claude/settings.json" 1)"
  # t: the owner set autoCompactEnabled true; the copy keeps it and says so once, the update
  # says nothing more.
  p="$w/t"
  rp_copy "$1" v0.3.0 "$p" theology >"$w/t-copy.log" 2>&1 || SM_COPY[4]=$?
  SM_T_COPIED="$(sm_judge "$p/.claude/settings.json" 1 true)"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied over my settings, compaction on' >>"$log" 2>&1 || true
  rp_update "$p" v0.4.0 >"$w/t-update.log" 2>&1 || SM_UPD[5]=$?
  SM_T_UPDATED="$(sm_judge "$p/.claude/settings.json" 1 true)"
  SM_T_LINES="$(grep -cF "$SM_KEPT" "$w/t-copy.log" || true) $(grep -cF "$SM_KEPT" "$w/t-update.log" || true)"
  cat "$w/t-copy.log" "$w/t-update.log" >>"$log"
}

sm_checks() {
  local L="[settings fixture]"
  if [[ "${SM_COPY[*]}" != "0 0 0 0 0" || "${SM_UPD[*]}" != "0 0 0 0 0 0" ]]; then
    finding "check 55 — $L a copy over the owner's settings.json or an update failed (copies: ${SM_COPY[*]}; updates: ${SM_UPD[*]})"
    return 0
  fi
  [[ "$SM_A_COPIED" == ok ]] || finding "check 55 — $L after a copy over the owner's settings.json: $SM_A_COPIED"
  [[ "$SM_A_UPDATED" == ok ]] || finding "check 55 — $L after the update that followed the copy: $SM_A_UPDATED"
  [[ "$SM_B_UPDATED" == ok ]] || finding "check 56 — $L after the owner removed the hook the copy had wired, the update: $SM_B_UPDATED"
  [[ "$SM_B2_UPDATED" == ok ]] || finding "check 56 — $L after the owner removed the hook before any commit (only the record knew it), the update: $SM_B2_UPDATED"
  [[ -z "$SM_C_RECORD" ]] || finding "check 57 — $L a copy with --skip-tasks recorded a render, so the no-record case was not tested"
  [[ "$SM_C_UPDATED" == ok ]] || finding "check 57 — $L a copy without tasks, then an update: $SM_C_UPDATED"
  [[ "$SM_T_COPIED" == ok ]] || finding "check 55 — $L after a copy over the owner's autoCompactEnabled true: $SM_T_COPIED"
  [[ "$SM_T_UPDATED" == ok ]] || finding "check 55 — $L after the update that followed the copy over autoCompactEnabled true: $SM_T_UPDATED"
  [[ "$SM_T_LINES" == "1 0" ]] \
    || finding "check 55 — $L the owner's autoCompactEnabled true was not reported exactly once, by the copy alone (copy, update: $SM_T_LINES)"
  if ! $SM_A_SAME || [[ -n "$SM_A_AGAIN_DIRTY" ]]; then
    finding "check 58 — $L a second update was not a no-op ($($SM_A_SAME && echo 'settings.json kept' || echo 'settings.json rewritten'); $(printf '%s\n' "$SM_A_AGAIN_DIRTY" | grep -c . || true) path(s) changed)"
  fi
  [[ -z "$SM_ABS" ]] || finding "check 59 — $L the render record names a path of this machine: $SM_ABS"
  return 0
}

# ── The data root, the provider and the MCP servers on real updates (D50, D53, D54) ──
#
# Checks 60–85, on the real template: a project copied at v0.4.0 (or v0.3.0) is updated to the
# working tree, tagged as the release its newest _migrations entry names, and then to one later
# release made here on a side branch (DT_NEXT), so that an update after the crossing one has
# something to deliver. Each flow keeps what the checks read: copies of the files before and
# after, the new render's files from the render record (refs/syntek-author/template), the logs
# and the exit statuses. The judges run when the checks run, so --self-test proves them on
# synthetic trees it writes (dt_synth) with one mutation per check.

DT_FROM="v0.4.0"                   # the release before D50, D53 and D54
DT_NEXT=""                         # the later release next_release tags (v0.5.1 for v0.5.0)
DT_MIG_SCRIPT="migrations/v0.5.0-data-root.sh"
DT_MIG_MARK="▸ v0.5.0 migration — the data root and the provider"
DT_MIG_ENTRY="  - version: v0.5.0"
DT_PERMS=".claude/syntek-author-permissions.py"
DT_WRITE_LINE="run: python3 $DT_PERMS --write"
DT_OWNER_SERVER="owner-notes"      # an invented server the owner declared before the update
DT_DIFF_LINE='kept your "scrapling" MCP server in .mcp.json'
DT_IGNORED_LINE='.mcp.json is ignored by git, so it was not read'
DT_ALLOW_LINE='not added to .claude/settings.json, because you allow it'
DT_WAIT_LINE='wait for ask rules --write cannot carry, because .claude/settings.json does not ask before their tools (you allow them there)'
DT_DRIVE_LIST="These workflows name Google Drive's API"
DT_STALE_DRIVE="v0.5.0: DATA_PROVIDER replaces INCLUDE_DRIVE_SYNC"
DT_STALE_DRIVE_GONE="v0.5.0: delete this line: these answers"
DT_DRIVE_GONE="This update deleted these workflows, which name Google Drive's API"
DT_SAME="the template did not change"
DT_CHANGED_SEC="NOT UPDATED because you had changed them"
DT_DELETED_SEC="DELETED by this update although you had changed them"
DT_PULL=".github/workflows/google-drive-pull.yml"
DT_PUSH=".github/workflows/google-drive-push.yml"
DT_CRON_OLD="- cron: '0 6 \* \* \*'"     # a sed pattern: the pull workflow's schedule in v0.3.0 and v0.4.0
DT_CRON_NEW="- cron: '30 5 * * 1-5'"     # the owner's own schedule
DT_PDF="library/src/business/update-test-issued.pdf"
# Invented folder names and answers. Each folder's kebab name is what DATA_SLUG's default gives.
DT_EXT_DIR="Ext_Probe Project.v2";  DT_EXT_SLUG="ext-probe-project-v2"
DT_RT_DIR="Round Trip_Probe";       DT_RT_SLUG_DEFAULT="round-trip-probe"
DT_RT_AREA="Clients"; DT_RT_SLUG="custom-slug"; DT_AREA_DEFAULT="business"
DT_SIB_AREA="Studio"; DT_SIB_SLUG="shared-probe"
DT_LAYOUT_KEYS="DATA_AREA DATA_SLUG DATA_KIND_DOCS DATA_KIND_PHOTOS DATA_KIND_AUDIO DATA_KIND_VIDEOS"

# "ok", or what is wrong, from the reasons given (one per argument).
verdict() { if [[ $# -eq 0 ]]; then echo ok; else local IFS=$'\x1f'; local s="$*"; echo "${s//$'\x1f'/; }"; fi; }

# The MCP judges. Every mode prints "ok", or what is wrong.
#   rules SETTINGS [allowed]        the D54 deny and eight asks once each ('allowed': the owner
#                                   allows mcp__scrapling__*, so no Scrapling ask, the allow kept)
#   servers BEFORE AFTER TPL REL [KEEP…]  each server once under REL's key path, equal to the new
#                                   render's (KEEP: to BEFORE's); BEFORE's keys, values and list
#                                   items all kept, in order; a Codex server's tools tables apart
#   absent FILE REL NAME…           none of the servers is declared there
#   same BEFORE AFTER REL NAME      the server's value is BEFORE's
#   codex AFTER TPL                 every server's tools tables (the prompts) are the render's
#   ocasks FILE                     opencode.json asks for every tool of every server it declares
ut_judge() {
  UT_SERVERS="$SA_MCP_SERVERS" UT_ASKS="$SA_MCP_ASKS" UT_DENY="$SA_MCP_DENY" python3 - "$@" <<'PY'
import json, os, re, sys
KP = {".mcp.json": ["mcpServers"], ".agents/mcp_config.json": ["mcpServers"], ".codex/config.toml": ["mcp_servers"],
      ".gemini/settings.json": ["mcpServers"], "opencode.json": ["mcp", "servers"]}
SERVERS, ASKS, DENY = os.environ["UT_SERVERS"].split(), os.environ["UT_ASKS"].split(), os.environ["UT_DENY"]

def load(path, rel):
    text = open(path, encoding="utf-8").read()
    if rel.endswith(".toml"):
        import tomllib
        return text, tomllib.loads(text)
    return text, json.loads(text)

def at(d, rel):
    for k in KP[rel]:
        d = d.get(k) if isinstance(d, dict) else None
    return d if isinstance(d, dict) else {}

def count(text, rel, name):
    n = re.escape(name)
    if rel.endswith(".toml"):
        return len(re.findall(r'(?m)^[ \t]*\[[ \t]*mcp_servers\.(?:"%s"|%s)[ \t]*\][ \t]*$' % (n, n), text))
    return len(re.findall(r'"%s"\s*:' % n, text))

def own(v, rel):  # a Codex server's own keys; its tools tables are the prompts (mode codex)
    return {k: x for k, x in v.items() if k != "tools"} if rel.endswith(".toml") and isinstance(v, dict) else v

def within(a, b):  # every key, value and list item of a is in b, in a's order
    if isinstance(a, dict):
        if not isinstance(b, dict):
            return False
        keys, last = list(b), -1
        for k, v in a.items():
            if k not in b or keys.index(k) < last or not within(v, b[k]):
                return False
            last = keys.index(k)
        return True
    if isinstance(a, list):
        if not isinstance(b, list):
            return False
        j = 0
        for x in a:
            while j < len(b) and not within(x, b[j]):
                j += 1
            if j == len(b):
                return False
            j += 1
        return True
    return a == b

mode, a = sys.argv[1], sys.argv[2:]
bad = []
try:
    if mode == "rules":
        p = (json.load(open(a[0], encoding="utf-8")).get("permissions") or {})
        allowed = len(a) > 1 and a[1] == "allowed"
        n = (p.get("deny") or []).count(DENY)
        if n != 1:
            bad.append(f"denies {DENY} {n} time(s), not once")
        for r in ASKS:
            want = 0 if allowed and r.startswith("mcp__scrapling__") else 1
            n = (p.get("ask") or []).count(r)
            if n != want:
                bad.append(f"asks {r} {n} time(s), not {'never' if want == 0 else 'once'}")
        if allowed and "mcp__scrapling__*" not in (p.get("allow") or []):
            bad.append("the owner's allow rule mcp__scrapling__* is gone")
    elif mode == "servers":
        before, after, tpl, rel, keep = a[0], a[1], a[2], a[3], set(a[4:])
        if not os.path.isfile(after):
            bad.append("missing")
        else:
            text, d = load(after, rel)
            _, t = load(tpl, rel)
            b = load(before, rel)[1] if before != "-" else {}
            for s in SERVERS:
                n = count(text, rel, s)
                if n != 1:
                    bad.append(f"declares {s} {n} time(s), not once")
                elif s in keep:
                    if at(d, rel).get(s) != at(b, rel).get(s):
                        bad.append(f"the owner's own {s} entry was not kept")
                elif own(at(d, rel).get(s), rel) != own(at(t, rel).get(s), rel):
                    bad.append(f"its {s} entry is not the new render's")
            if before != "-" and not within(b, d):
                bad.append("a key, value or list item it held before is gone or out of order")
    elif mode == "absent":
        _, d = load(a[0], a[1])
        bad += [f"declares {s}" for s in a[2:] if s in at(d, a[1])]
    elif mode == "same":
        b, d = load(a[0], a[2])[1], load(a[1], a[2])[1]
        if at(d, a[2]).get(a[3]) != at(b, a[2]).get(a[3]):
            bad.append(f"its {a[3]} entry is not the owner's")
    elif mode == "codex":
        d, t = load(a[0], ".codex/config.toml")[1], load(a[1], ".codex/config.toml")[1]
        for s in SERVERS:
            got = (at(d, ".codex/config.toml").get(s) or {}).get("tools")
            if not got or got != (at(t, ".codex/config.toml").get(s) or {}).get("tools"):
                bad.append(f"the {s} prompt tables are not the new render's")
    elif mode == "ocasks":
        d = json.load(open(a[0], encoding="utf-8"))
        have = {(p.get("action"), p.get("effect")) for p in d.get("permissions") or [] if isinstance(p, dict)}
        for r in ASKS:
            _, s, tool = r.split("__", 2)
            if s in at(d, "opencode.json") and (f"{s}_{tool}", "ask") not in have:
                bad.append(f"declares {s} but does not ask before {s}_{tool}")
    else:
        bad.append(f"no judge called {mode}")
except (OSError, ValueError, KeyError, ImportError) as e:
    bad.append(f"unreadable ({e})")
print("; ".join(bad) or "ok")
PY
}

dt_stat() { # $1 = file → its sha1, size and mtime in nanoseconds (empty when absent)
  python3 - "$1" <<'PY'
import hashlib, os, sys
try:
    st = os.stat(sys.argv[1])
    print(hashlib.sha1(open(sys.argv[1], "rb").read()).hexdigest(), st.st_size, st.st_mtime_ns)
except OSError:
    print("")
PY
}
dt_keep() { # $1 = project, $2 = dir: copies of every MCP file and settings.json the project holds
  local f
  for f in $SA_MCP_FILES .claude/settings.json; do
    [[ -f "$1/$f" ]] || continue
    mkdir -p "$(dirname "$2/$f")"; cp "$1/$f" "$2/$f"
  done
}
dt_record() { # $1 = project, $2 = dir: the new render's MCP files, from the render record
  local f
  for f in $SA_MCP_FILES; do
    git -C "$1" cat-file -e "refs/syntek-author/template:$f" 2>/dev/null || continue
    mkdir -p "$(dirname "$2/$f")"; git -C "$1" show "refs/syntek-author/template:$f" > "$2/$f"
  done
}
dt_clients() { # $1 = project → the copy-only client files present, space-separated
  local f out=()
  for f in $SA_COPY_ONLY; do [[ -e "$1/$f" || -L "$1/$f" ]] && out+=("$f"); done
  echo "${out[*]}"
}
dt_unmerged() { # $1 = project, $2 = path → every unmerged path under it, space-separated
  git -C "$1" status --porcelain -- "$2" 2>/dev/null | grep -E '^(DD|AU|UD|UA|DU|AA|UU) ' | cut -c4- | paste -sd' ' - || true
}
dt_section_of() { # $1 = log, $2 = path → the report section listing the path (empty: none)
  report_sections "$1" | awk -F'\t' -v p="$2" '$2 == p { print $1; exit }'
}

# Template-owned files that read a data-root answer inside a delimiter: none may be reported as
# kept back by a crossing update, whatever hidden answers it records (D50, check 76). Seeds and
# copy-only files are the author's once written, so they are left out.
DT_READERS=""
dt_readers_init() { # once, in the calling shell (the checks read it from subshells)
  local f
  if [[ -z "$DT_READERS" ]]; then
    build_sets "$SA_ROOT/copier.yml"
    while IFS= read -r f; do
      is_seed "$f" && continue
      [[ " $SA_COPY_ONLY " == *" $f "* ]] && continue
      DT_READERS+="$f"$'\n'
    done < <(python3 - "$SA_ROOT/template" <<'PY'
import os, re, sys
root = sys.argv[1]
span = re.compile(r"(<%.*?%>|<:.*?:>)", re.S)
key = re.compile(r"\bDATA_(STORE|AREA|SLUG|KIND_[A-Z]+|PROVIDER)\b")
for d, _, fs in os.walk(root):
    for f in fs:
        p = os.path.join(d, f)
        try:
            t = open(p, encoding="utf-8").read()
        except (OSError, UnicodeDecodeError):
            continue
        if any(key.search(m.group(0)) for m in span.finditer(t)):
            print(os.path.relpath(p, root))
PY
)
  fi
  [[ -n "$DT_READERS" ]] || die "no template file reads a data-root answer — check 76 has nothing to judge"
}
dt_false_lines() { # $1 = update log → every listed path that reads a data-root answer
  report_sections "$1" | cut -f2 | grep -Fx -f <(printf '%s' "$DT_READERS") | LC_ALL=C sort -u | paste -sd' ' - || true
}

# The judges of the data root and the provider, from a project's files.
dr_repo_judge() { # $1 = project → the update recorded repo and kept the data root off (check 71)
  local p="$1" a="$1/$SA_ANSWERS_FILE" bad=() k f v
  v="$(answer_value DATA_STORE "$a")"
  [[ "$v" == repo ]] || bad+=("records DATA_STORE '${v:-nothing}', not repo")
  for k in $DT_LAYOUT_KEYS; do grep -q "^$k:" "$a" 2>/dev/null && bad+=("records $k"); done
  for f in "$SA_DATAROOT_PY" "$SA_DATAROOT_MAP"; do [[ -f "$p/$f" ]] || bad+=("has no $f"); done
  for f in $SA_DATAROOT_IGNORES; do [[ -e "$p/$f" ]] && bad+=("gained $f"); done
  grep -q 'dataroot' "$p/.claude/settings.json" 2>/dev/null && bad+=("its .claude/settings.json wires the data-root guard")
  verdict "${bad[@]}"
}
dr_none_judge() { # $1 = project → DATA_PROVIDER none, no .github/, no retired key (check 82)
  local a="$1/$SA_ANSWERS_FILE" bad=() v
  v="$(answer_value DATA_PROVIDER "$a")"
  [[ "$v" == none ]] || bad+=("records DATA_PROVIDER '${v:-nothing}', not none")
  grep -q '^INCLUDE_DRIVE_SYNC:' "$a" 2>/dev/null && bad+=("still records INCLUDE_DRIVE_SYNC")
  [[ -e "$1/.github" ]] && bad+=("has .github/")
  verdict "${bad[@]}"
}
dr_drive_judge() { # $1 = project, $2 = its unmerged paths under .github/ → check 81
  local p="$1" a="$1/$SA_ANSWERS_FILE" bad=() f n m
  [[ "$(answer_value DATA_PROVIDER "$a")" == google-drive ]] || bad+=("records DATA_PROVIDER '$(answer_value DATA_PROVIDER "$a")', not google-drive")
  [[ "$(answer_value DATA_STORE "$a")" == repo ]] || bad+=("records DATA_STORE '$(answer_value DATA_STORE "$a")', not repo")
  grep -q '^INCLUDE_DRIVE_SYNC:' "$a" 2>/dev/null && bad+=("still records the retired INCLUDE_DRIVE_SYNC")
  [[ -z "$2" ]] || bad+=("unmerged under .github/: $2")
  m="$(grep -rlE '^(<<<<<<<|>>>>>>>)( |$)' "$p/.github" 2>/dev/null | sed "s#^$p/##" | paste -sd' ' -)"
  [[ -z "$m" ]] || bad+=("conflict markers in $m")
  grep -qF -e "$DT_CRON_NEW" "$p/$DT_PULL" 2>/dev/null || bad+=("the owner's edit to $DT_PULL is gone")
  for f in "$DT_PULL" "$DT_PUSH"; do
    n="$(grep -cE "^[[:space:]]*- name: ${SA_DRIVE_GUARD_STEP}[[:space:]]*$" "$p/$f" 2>/dev/null || true)"
    [[ "${n:-0}" -eq 1 ]] || bad+=("$f holds the store guard step ${n:-0} time(s), not once")
  done
  verdict "${bad[@]}"
}
dr_ext_judge() { # $1 = project, $2 = the slug its folder gives, $3 = the area wanted → store external
  local a="$1/$SA_ANSWERS_FILE" bad=() v
  v="$(answer_value DATA_STORE "$a")"; [[ "$v" == external ]] || bad+=("records DATA_STORE '${v:-nothing}', not external")
  v="$(answer_value DATA_SLUG "$a")"; [[ "$v" == "$2" ]] || bad+=("records DATA_SLUG '${v:-nothing}', not '$2'")
  v="$(answer_value DATA_AREA "$a")"; [[ "$v" == "$3" ]] || bad+=("records DATA_AREA '${v:-nothing}', not '$3'")
  verdict "${bad[@]}"
}
dr_gone_judge() { # $1 = project, $2 = update log → .github/ deleted and the edited workflow listed
  local bad=() s
  [[ -e "$1/.github" ]] && bad+=(".github/ is still there")
  s="$(dt_section_of "$2" "$DT_PULL")"
  [[ "$s" == "$DT_DELETED_SEC"* ]] || bad+=("the report lists the edited $DT_PULL under '${s:-nothing}', not '$DT_DELETED_SEC'")
  verdict "${bad[@]}"
}

# ── The MCP flow (D54): a v0.4.0 project with every client, once per run ─────

MC_RAN=false; MC_DOC=""; MC_W=""; MC_PROJ=""; MC_LOG=""; MC_NEXT_LOG=""; MC_AGAIN_LOG=""
MC_COPY=0; MC_UPD=0; MC_WRITE=0; MC_CHECK1=0; MC_NEXT_ST=0; MC_CHECK2=0; MC_AGAIN_ST=0; MC_AGAIN_DIRTY=""
MC_CLIENTS_PRE=""; MC_CLIENTS_MID=""; MC_CLIENTS_END=""; MC_MIG1=0; MC_MIG2=0; MC_MIG_DIRTY=""; MC_ABS=""
MR_PROJ=""; MR_ST=0
MA_PROJ=""; MA_LOG=""; MA_COPY=0; MA_UPD=0; MA_STAT_PRE=""
SB_PROJ=""; SB_ST=0

# A later release on a side branch of the tagged template, so an update after the crossing one
# delivers something: a template-owned rule and two copy-only files change. HEAD stays put.
next_release() { # $1 = tagged template
  local t="$1" top
  [[ -n "$DT_NEXT" ]] && return 0
  top="$(git -C "$t" tag -l 'v[0-9]*' | sort -V | tail -1)"
  DT_NEXT="$(awk -F. '{ printf "%s.%s.%d", $1, $2, $3 + 1 }' <<< "$top")"
  sa_git "$t" checkout -q -b update-test-next || return 1
  printf '\n%s\n' "$TEMPLATE_MARK" >> "$t/template/$RULES01"
  printf '# update-test: the next release\n' >> "$t/template/.codex/config.toml"
  printf '\n' >> "$t/template/.agents/mcp_config.json"
  sa_git "$t" add -A && sa_git "$t" commit -q -m 'update-test: the next release' && sa_git "$t" tag "$DT_NEXT" || return 1
  sa_git "$t" checkout -q -
}

# The owner at work before the update: their own server and an older Scrapling pin in a
# four-space .mcp.json, opencode.json reformatted with a catch-all allow, Gemini CLI's settings
# deleted.
mc_owner() { # $1 = project
  python3 - "$1" "$DT_OWNER_SERVER" <<'PY'
import json, os, sys
p, mine = sys.argv[1], sys.argv[2]
servers = {mine: {"command": "uvx", "args": [mine + "-mcp==1.0.0"]},
           "scrapling": {"command": "uvx", "args": ["--from", "scrapling[ai]==0.4.10", "scrapling", "mcp"]}}
open(os.path.join(p, ".mcp.json"), "w", encoding="utf-8").write(json.dumps({"mcpServers": servers}, indent=4) + "\n")
f = os.path.join(p, "opencode.json")
oc = json.load(open(f, encoding="utf-8"))
oc = {"permissions": oc.get("permissions", []) + [{"action": "*", "resource": "*", "effect": "allow"}],
      **{k: v for k, v in oc.items() if k != "permissions"}}
open(f, "w", encoding="utf-8").write(json.dumps(oc, indent=4) + "\n")
os.remove(os.path.join(p, ".gemini", "settings.json"))
PY
}
dt_drop_server() { # $1 = JSON file, $2 = server: the owner removes it
  python3 - "$1" "$2" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
d.get("mcpServers", {}).pop(sys.argv[2], None)
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
}
dt_sibling() { # $1 = project, then the record's lines: an invented answers file of the other template
  local p="$1"; shift
  { printf "# The other syntek template's answers: an invented record.\n_commit: v0.5.0\n_src_path: gh:example/syntek-media\n"
    printf '%s\n' "$@"; } > "$p/$SA_PEER_ANSWERS_FILE"
}

run_mcp_flow() { # $1 = tagged template, $2 = work dir, $3 = DOC_TYPE
  local tpl="$1" w="$2/mc" log="$2/mc-flow.log" p
  MC_RAN=true; MC_DOC="$3"; MC_W="$w"; MC_PROJ="$w/proj"; MC_LOG="$w/up.log"; MC_NEXT_LOG="$w/next.log"; MC_AGAIN_LOG="$w/again.log"
  MC_COPY=0; MC_UPD=0; MC_WRITE=0; MC_CHECK1=0; MC_NEXT_ST=0; MC_CHECK2=0; MC_AGAIN_ST=0; MC_AGAIN_DIRTY=""
  MC_MIG1=0; MC_MIG2=0; MC_MIG_DIRTY=""; MC_ABS=""; MR_PROJ="$w/removed"; MR_ST=0
  MA_PROJ="$w/allowed"; MA_LOG="$w/allowed.log"; MA_COPY=0; MA_UPD=0; MA_STAT_PRE=""; SB_PROJ="$w/sibling"; SB_ST=0
  rm -rf "$w"; mkdir -p "$w"; : > "$MC_LOG"; : > "$MC_NEXT_LOG"; : > "$MC_AGAIN_LOG"; : > "$MA_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  next_release "$tpl" >>"$log" 2>&1 || die "could not tag a later release in $tpl"

  # The owner's project, with every client.
  p="$MC_PROJ"
  rp_copy "$tpl" "$DT_FROM" "$p" "$3" --data "AGENT_CLIENTS=[$ALL_CLIENTS]" >>"$log" 2>&1 || MC_COPY=$?
  [[ "$MC_COPY" -eq 0 ]] || return 0
  [[ -d "$p/.git" ]] || sa_git "$p" init -q
  sa_git "$p" add -A && sa_git "$p" commit -q -m "copied at $DT_FROM" >>"$log" 2>&1
  mc_owner "$p" >>"$log" 2>&1 || die "could not make the owner's MCP edits in $p"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'my own MCP setup' >>"$log" 2>&1
  MC_CLIENTS_PRE="$(dt_clients "$p")"; dt_keep "$p" "$w/pre"
  rp_update "$p" HEAD >"$MC_LOG" 2>&1 || MC_UPD=$?
  cat "$MC_LOG" >>"$log"
  dt_keep "$p" "$w/mid"; dt_record "$p" "$w/tpl-mid"; MC_CLIENTS_MID="$(dt_clients "$p")"
  cp -a "$p" "$MR_PROJ"     # before the update is committed (check 65)
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated' >>"$log" 2>&1 || true
  # 75: the migration by hand, twice, on the committed result.
  (cd "$p" && bash "$tpl/$DT_MIG_SCRIPT") >"$w/mig1.out" 2>&1 || MC_MIG1=$?
  (cd "$p" && bash "$tpl/$DT_MIG_SCRIPT") >"$w/mig2.out" 2>&1 || MC_MIG2=$?
  MC_MIG_DIRTY="$(git -C "$p" status --porcelain)"
  # 64: the line the update printed, run as printed; then the next release.
  (cd "$p" && python3 "$DT_PERMS" --write) >>"$log" 2>&1 || MC_WRITE=$?
  (cd "$p" && python3 "$DT_PERMS" --check) >>"$log" 2>&1 || MC_CHECK1=$?
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'the client rules written' >>"$log" 2>&1 || true
  rp_update "$p" "$DT_NEXT" >"$MC_NEXT_LOG" 2>&1 || MC_NEXT_ST=$?
  cat "$MC_NEXT_LOG" >>"$log"
  dt_record "$p" "$w/tpl-end"; MC_CLIENTS_END="$(dt_clients "$p")"
  (cd "$p" && python3 "$DT_PERMS" --check) >>"$log" 2>&1 || MC_CHECK2=$?
  sa_git "$p" add -A && sa_git "$p" commit -q -m "updated to $DT_NEXT" >>"$log" 2>&1 || true
  rp_update "$p" "$DT_NEXT" >"$MC_AGAIN_LOG" 2>&1 || MC_AGAIN_ST=$?
  cat "$MC_AGAIN_LOG" >>"$log"
  MC_AGAIN_DIRTY="$(git -C "$p" status --porcelain)"
  MC_ABS="$(sm_abs "$p" "$tpl" "$p")"

  # 65: servers the owner removed, once before the update was ever committed (only the record
  # lists the offer) and once after a commit that held it.
  p="$MR_PROJ"
  dt_drop_server "$p/.mcp.json" code-review-graph >>"$log" 2>&1 || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated, without code-review-graph' >>"$log" 2>&1 || true
  dt_drop_server "$p/.agents/mcp_config.json" scrapling >>"$log" 2>&1 || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'no scrapling for Antigravity' >>"$log" 2>&1 || true
  rp_update "$p" "$DT_NEXT" >>"$log" 2>&1 || MR_ST=$?

  # 67, 68, 85: an owner who allows every Scrapling tool, keeps .mcp.json out of git and runs a
  # Drive workflow of their own; 77: the same project beside a sibling that records external.
  p="$MA_PROJ"
  rp_copy "$tpl" "$DT_FROM" "$p" "$3" >>"$log" 2>&1 || MA_COPY=$?
  [[ "$MA_COPY" -eq 0 ]] || return 0
  [[ -d "$p/.git" ]] || sa_git "$p" init -q
  sa_git "$p" add -A && sa_git "$p" commit -q -m "copied at $DT_FROM" >>"$log" 2>&1
  python3 - "$p/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
d.setdefault("permissions", {}).setdefault("allow", []).append("mcp__scrapling__*")
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
  printf '/.mcp.json\n' >> "$p/.gitignore"; sa_git "$p" rm -q --cached .mcp.json >>"$log" 2>&1 || true
  mkdir -p "$p/.github/workflows"; git -C "$tpl" show "$DT_FROM:template/$DT_PUSH" > "$p/$DT_PUSH" 2>>"$log" || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'my settings, my own Drive workflow' >>"$log" 2>&1
  MA_STAT_PRE="$(dt_stat "$p/.mcp.json")"
  cp -a "$p" "$SB_PROJ"
  rp_update "$p" HEAD >"$MA_LOG" 2>&1 || MA_UPD=$?
  cat "$MA_LOG" >>"$log"
  p="$SB_PROJ"
  dt_sibling "$p" "DATA_STORE: external" "DATA_AREA: $DT_SIB_AREA" "DATA_SLUG: $DT_SIB_SLUG" \
    "DATA_KIND_DOCS: docs" "DATA_KIND_PHOTOS: photos" "DATA_KIND_AUDIO: audio" "DATA_KIND_VIDEOS: videos" "DATA_PROVIDER: none"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'a sibling at external' >>"$log" 2>&1
  rp_update "$p" HEAD >>"$log" 2>&1 || SB_ST=$?
}

mcp_flow_checks() {
  local L="[$MC_DOC from $DT_FROM]" v rel keep n a b s
  if [[ "$MC_COPY" -ne 0 || "$MC_UPD" -ne 0 ]]; then
    finding "check 60 — $L the copy at $DT_FROM or the update to the working tree failed (copy exit $MC_COPY, update exit $MC_UPD) — see $MC_LOG"
    return 0
  fi
  v="$(ut_judge rules "$MC_W/mid/.claude/settings.json")"
  [[ "$v" == ok ]] || finding "check 60 — $L after the update, .claude/settings.json $v"
  for rel in .mcp.json .agents/mcp_config.json .codex/config.toml; do
    keep=(); [[ "$rel" == .mcp.json ]] && keep=(scrapling)
    v="$(ut_judge servers "$MC_W/pre/$rel" "$MC_W/mid/$rel" "$MC_W/tpl-mid/$rel" "$rel" "${keep[@]}")"
    [[ "$v" == ok ]] || finding "check 61 — $L after the update, $rel: $v"
  done
  v="$(ut_judge servers "$MC_W/pre/opencode.json" "$MC_PROJ/opencode.json" "$MC_W/tpl-end/opencode.json" opencode.json)"
  [[ "$v" == ok ]] || finding "check 61 — $L after --write and the next update, opencode.json: $v"
  [[ "$MC_CLIENTS_MID" == "$MC_CLIENTS_PRE" && "$MC_CLIENTS_END" == "$MC_CLIENTS_PRE" ]] \
    || finding "check 62 — $L the client files changed: before '$MC_CLIENTS_PRE', after the update '$MC_CLIENTS_MID', after the next '$MC_CLIENTS_END' — an update never creates or restores one"
  v="$(ut_judge codex "$MC_W/mid/.codex/config.toml" "$MC_W/tpl-mid/.codex/config.toml")"
  [[ "$v" == ok ]] || finding "check 63 — $L after the update, .codex/config.toml: $v"
  if ! grep -qF "$DT_WRITE_LINE" "$MC_LOG"; then
    finding "check 64 — $L the update did not print '$DT_WRITE_LINE'"
  elif [[ "$MC_WRITE" -ne 0 || "$MC_CHECK1" -ne 0 || "$MC_CHECK2" -ne 0 ]]; then
    finding "check 64 — $L the printed --write exited $MC_WRITE, then --check $MC_CHECK1, and $MC_CHECK2 after the next update — not 0, 0 and 0"
  fi
  if [[ "$MR_ST" -ne 0 ]]; then
    finding "check 65 — $L the next update after the owner removed two servers failed (exit $MR_ST)"
  else
    v="$(ut_judge absent "$MR_PROJ/.mcp.json" .mcp.json code-review-graph)"
    [[ "$v" == ok ]] || finding "check 65 — $L .mcp.json, whose code-review-graph the owner removed before any commit, $v again"
    v="$(ut_judge absent "$MR_PROJ/.agents/mcp_config.json" .agents/mcp_config.json scrapling)"
    [[ "$v" == ok ]] || finding "check 65 — $L .agents/mcp_config.json, whose scrapling the owner removed after a commit, $v again"
  fi
  a="$(grep -cF "$DT_DIFF_LINE" "$MC_LOG" || true)"; b="$(grep -cF "$DT_DIFF_LINE" "$MC_NEXT_LOG" || true)"
  v="$(ut_judge same "$MC_W/pre/.mcp.json" "$MC_PROJ/.mcp.json" .mcp.json scrapling)"
  [[ "$a" -eq 1 && "$b" -eq 0 && "$v" == ok ]] \
    || finding "check 66 — $L the owner's differing scrapling entry: '$v'; reported $a time(s) by the update and $b by the next, not once and never again"
  # shellcheck disable=SC2086  # one argument per server
  v="$(ut_judge absent "$MC_W/mid/opencode.json" opencode.json $SA_MCP_SERVERS)"
  if [[ "$v" != ok ]]; then
    finding "check 69 — $L opencode.json, whose owner allows every tool, $v before --write — a server there must wait for its asks"
  elif grep -qF "$DT_WRITE_LINE" "$MC_LOG" && ! grep -F "$DT_WRITE_LINE" "$MC_LOG" | grep -qE 'held back now: [^)]*opencode\.json'; then
    finding "check 69 — $L the --write line does not name opencode.json as held back"
  else
    v="$(ut_judge ocasks "$MC_PROJ/opencode.json")"
    [[ "$v" == ok ]] || finding "check 69 — $L after --write and the next update, opencode.json $v"
  fi
  for rel in .agents/mcp_config.json .codex/config.toml; do
    s="$(dt_section_of "$MC_NEXT_LOG" "$rel")"
    [[ "$s" == "$DT_CHANGED_SEC"* ]] && finding "check 70 — $L the next update lists $rel, which only the lane wrote, under '$DT_CHANGED_SEC'"
  done
  n="$(grep -c '^▸' "$MC_AGAIN_LOG" || true)"
  if [[ "$MC_NEXT_ST" -ne 0 || "$MC_AGAIN_ST" -ne 0 || -n "$MC_AGAIN_DIRTY" || "$n" -ne 1 ]] || ! grep -q "^$RP_HEAD.*: $DT_SAME" "$MC_AGAIN_LOG" \
     || grep -qE '^  (NOT|CONFLICT|DELETED|REJECTED)' "$MC_AGAIN_LOG"; then
    finding "check 70 — $L the next update (exit $MC_NEXT_ST) and a second one (exit $MC_AGAIN_ST) were not a delivery then a quiet no-op ($(printf '%s\n' "$MC_AGAIN_DIRTY" | grep -c . || true) path(s) changed; $n ▸ line(s))"
  fi
  [[ -z "$MC_ABS" ]] || finding "check 59 — $L the render record names a path of this machine: $MC_ABS"
  v="$(dr_repo_judge "$MC_PROJ")"
  [[ "$v" == ok ]] || finding "check 71 — $L after the update with --defaults, the project $v"
  a="$(grep -nF "$DT_MIG_MARK" "$MC_LOG" | head -1 | cut -d: -f1 || true)"; b="$(grep -n "^$RP_HEAD" "$MC_LOG" | head -1 | cut -d: -f1 || true)"
  s="$(awk -v e="$DT_MIG_ENTRY" -v u="$SA_UPD_BEGIN" '$0 == e && !m { m = NR } $0 == u && !b { b = NR } END { print (m && b && m < b) ? "before" : "not before" }' "$SA_ROOT/copier.yml")"
  if [[ -z "$a" || -z "$b" || "$a" -gt "$b" || "$s" != before ]]; then
    finding "check 75 — $L the v0.5.0 migration did not run before the update report (its line ${a:-absent}, the report's ${b:-absent}), or its copier.yml entry is $s the update block"
  elif [[ "$MC_MIG1" -ne 0 || "$MC_MIG2" -ne 0 || -n "$MC_MIG_DIRTY" ]] || ! cmp -s "$MC_W/mig1.out" "$MC_W/mig2.out"; then
    finding "check 75 — $L two hand runs of the v0.5.0 migration (exits $MC_MIG1 and $MC_MIG2) did not print the same report and change nothing"
  fi
  v="$(dt_false_lines "$MC_LOG")"
  [[ -z "$v" ]] || finding "check 76 — $L the update report lists template-owned files that read a data-root answer: $v"
  v="$(dr_none_judge "$MC_PROJ")"
  [[ "$v" == ok ]] || finding "check 82 — $L after the update, the project $v"
  if [[ "$MA_COPY" -ne 0 || "$MA_UPD" -ne 0 ]]; then
    finding "check 67 — $L the project with a git-ignored .mcp.json did not copy or update (copy exit $MA_COPY, update exit $MA_UPD) — see $MA_LOG"
    return 0
  fi
  n="$(grep -cF "$DT_IGNORED_LINE" "$MA_LOG" || true)"
  [[ "$(dt_stat "$MA_PROJ/.mcp.json")" == "$MA_STAT_PRE" && "$n" -eq 1 ]] \
    || finding "check 67 — $L the git-ignored .mcp.json was touched, or the update said so $n time(s), not once"
  s="$(dt_section_of "$MA_LOG" .mcp.json)"
  [[ -z "$s" || "$s" == "NOT COMPARED because git ignores them"* ]] \
    || finding "check 67 — $L the report lists the git-ignored .mcp.json under '$s', whose commands read or overwrite it"
  v="$(ut_judge rules "$MA_PROJ/.claude/settings.json" allowed)"
  [[ "$v" == ok ]] || finding "check 68 — $L where the owner allows mcp__scrapling__*, .claude/settings.json $v"
  for s in $SA_MCP_ASKS; do
    [[ "$s" == mcp__scrapling__* ]] || continue
    grep -F "$DT_ALLOW_LINE" "$MA_LOG" | grep -qE "ask $s(;|$)" \
      || finding "check 68 — $L the update did not say it left out '$s' because the owner allows it"
  done
  awk -v h="$DT_DRIVE_LIST" -v f="    $DT_PUSH" 'index($0, h) { on = 1 } on && $0 == f { ok = 1 } END { exit !ok }' "$MA_LOG" \
    || finding "check 85 — $L the v0.5.0 migration did not list the owner's own $DT_PUSH, which the answers no longer manage"
  # 89: the asks the owner allows are said once instead of a --write promise; the --write line
  # names only the client files that lack a rule.
  n="$(grep -cF "$DT_WAIT_LINE" "$MA_LOG" || true)"
  a="$(grep -F "$DT_WAIT_LINE" "$MA_LOG" | head -1 || true)"
  if [[ "$n" -ne 1 || "$a" != *" scrapling"* || "$a" != *"and run python3 $DT_PERMS --write"* || "$a" != *"by hand"* ]]; then
    finding "check 89 — $L where the owner allows mcp__scrapling__*, the update said $n time(s), not once, that Scrapling waits for asks .claude/settings.json does not hold, with both ways in"
  elif grep -F "$DT_WRITE_LINE" "$MA_LOG" | grep -qE 'held back now: [^)]*scrapling'; then
    finding "check 89 — $L the --write line promises Scrapling to the next update, though --write cannot carry the asks the owner allows"
  fi
  b="$(grep -F "$DT_WRITE_LINE" "$MC_LOG" | sed -nE 's/.* into (.*), run: python3 .*/\1/p' | head -1 || true)"
  # A missing --write line is check 64's; here only a line that leaves opencode.json out.
  [[ -z "$b" || "$b" == *opencode.json* ]] \
    || finding "check 89 — $L the --write line does not name opencode.json ('$b'), whose catch-all allow holds none of the new asks"
  [[ "$b" != *".codex/config.toml"* ]] \
    || finding "check 89 — $L the --write line names .codex/config.toml ('$b'), which holds every prompt table the lane gave it"
  if [[ "$SB_ST" -ne 0 ]]; then
    finding "check 77 — $L the first update beside a sibling at external failed (exit $SB_ST)"
  else
    v="$(dr_ext_judge "$SB_PROJ" "$DT_SIB_SLUG" "$DT_SIB_AREA")"
    [[ "$v" == ok ]] || finding "check 77 — $L beside a sibling that records external, the first update $v"
  fi
  return 0
}

# ── The update from v0.3.0, judged for D50, D53 and D54 (every DOC_TYPE, in the real run) ──

TD_RAN=false; TD_DOC=""; TD_PROJ=""; TD_LOG=""; TD_PRE=""; TD_TPL=""
trap_data_checks() {
  local L="[$TD_DOC from $TRAP_FROM]" v
  [[ "$TRAP_COPY_STATUS" -eq 0 && "$TRAP_UPDATE_STATUS" -eq 0 ]] || return 0   # check 31's
  v="$(ut_judge rules "$TD_PROJ/.claude/settings.json")"
  [[ "$v" == ok ]] || finding "check 60 — $L after the update, .claude/settings.json $v"
  v="$(ut_judge servers "$TD_PRE/.mcp.json" "$TD_PROJ/.mcp.json" "$TD_TPL/.mcp.json" .mcp.json)"
  [[ "$v" == ok ]] || finding "check 61 — $L after the update, .mcp.json: $v"
  v="$(dr_repo_judge "$TD_PROJ")"
  [[ "$v" == ok ]] || finding "check 71 — $L after the update with --defaults, the project $v"
  v="$(dt_false_lines "$TD_LOG")"
  [[ -z "$v" ]] || finding "check 76 — $L the update report lists template-owned files that read a data-root answer: $v"
  v="$(dr_none_judge "$TD_PROJ")"
  [[ "$v" == ok ]] || finding "check 82 — $L after the update, the project $v"
  return 0
}

# ── The Drive flows (D53, and D50's store on a Drive project): business, once per run ──

DR_RAN=false; DR_W=""
DR4_PROJ=""; DR4_LOG=""; DR4_COPY=0; DR4_UPD=0; DR4_UNMERGED=""; DR4_AGAIN_ST=0; DR4_AGAIN_DIRTY=""; DR4_AGAIN_LOG=""
DR3_PROJ=""; DR3_LOG=""; DR3_COPY=0; DR3_UPD=0; DR3_UNMERGED=""
DRP_PROJ=""; DRP_LOG=""; DRP_ST=0
DRE_PROJ=""; DRE_LOG=""; DRE_ST=0; DRE_PDF=""
DRS_PROJ=""; DRS_LOG=""; DRS_ST=0
DRA_PROJ=""; DRA_ST=0; DRB_PROJ=""; DRB_ST=0

dr_owner() { # $1 = project: the owner's own schedule for the pull, and a tracked issued PDF
  sed -i "s/$DT_CRON_OLD/$DT_CRON_NEW/" "$1/$DT_PULL" 2>/dev/null || true
  mkdir -p "$(dirname "$1/$DT_PDF")"; printf '%%PDF-1.4 an invented issued copy\n' > "$1/$DT_PDF"
}

run_drive_flow() { # $1 = tagged template, $2 = work dir
  local tpl="$1" w="$2/dr" log="$2/dr-flow.log" p before
  DR_RAN=true; DR_W="$w"; rm -rf "$w"; mkdir -p "$w"
  DR4_PROJ="$w/v040"; DR4_LOG="$w/v040.log"; DR4_COPY=0; DR4_UPD=0; DR4_UNMERGED=""; DR4_AGAIN_ST=0; DR4_AGAIN_DIRTY=""; DR4_AGAIN_LOG="$w/again.log"
  DR3_PROJ="$w/v030"; DR3_LOG="$w/v030.log"; DR3_COPY=0; DR3_UPD=0; DR3_UNMERGED=""
  DRP_PROJ="$w/onedrive"; DRP_LOG="$w/onedrive.log"; DRP_ST=0
  DRE_PROJ="$w/$DT_EXT_DIR"; DRE_LOG="$w/external.log"; DRE_ST=0; DRE_PDF=""
  DRS_PROJ="$w/settings-trap"; DRS_LOG="$w/settings-trap.log"; DRS_ST=0
  DRA_PROJ="$w/sibling-after"; DRA_ST=0; DRB_PROJ="$w/sibling-first"; DRB_ST=0
  : > "$DR4_LOG"; : > "$DR3_LOG"; : > "$DRP_LOG"; : > "$DRE_LOG"; : > "$DRS_LOG"; : > "$DR4_AGAIN_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init

  # 81 (from v0.4.0), 84; then from its committed result 83 (another provider; external, with
  # 72 and 73), and from its state before the update 80 (the settings trap) and 78 (a sibling).
  p="$DR4_PROJ"
  rp_copy "$tpl" "$DT_FROM" "$p" business --data INCLUDE_DRIVE_SYNC=true >>"$log" 2>&1 || DR4_COPY=$?
  [[ "$DR4_COPY" -eq 0 ]] || return 0
  [[ -d "$p/.git" ]] || sa_git "$p" init -q
  sa_git "$p" add -A && sa_git "$p" commit -q -m "copied at $DT_FROM" >>"$log" 2>&1
  dr_owner "$p"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'my own schedule; an issued copy' >>"$log" 2>&1
  cp -a "$p" "$DRS_PROJ"; cp -a "$p" "$DRA_PROJ"
  rp_update "$p" HEAD >"$DR4_LOG" 2>&1 || DR4_UPD=$?
  cat "$DR4_LOG" >>"$log"
  DR4_UNMERGED="$(dt_unmerged "$p" .github)"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'updated' >>"$log" 2>&1 || true
  rp_update "$p" HEAD >"$DR4_AGAIN_LOG" 2>&1 || DR4_AGAIN_ST=$?
  cat "$DR4_AGAIN_LOG" >>"$log"
  DR4_AGAIN_DIRTY="$(git -C "$p" status --porcelain)"

  cp -a "$p" "$DRP_PROJ"
  rp_update "$DRP_PROJ" HEAD --data DATA_PROVIDER=onedrive >"$DRP_LOG" 2>&1 || DRP_ST=$?
  cat "$DRP_LOG" >>"$log"

  cp -a "$p" "$DRE_PROJ"; p="$DRE_PROJ"
  mkdir -p "$p/research/src"; printf '# The owner'\''s own ignore rules\n*.bak\n' > "$p/research/src/.gitignore"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'my own research/src/.gitignore' >>"$log" 2>&1
  git -C "$p" ls-files | LC_ALL=C sort > "$w/index-before"
  rp_update "$p" HEAD --data DATA_STORE=external >"$DRE_LOG" 2>&1 || DRE_ST=$?
  cat "$DRE_LOG" >>"$log"
  git -C "$p" ls-files | LC_ALL=C sort -u > "$w/index-after"
  # Tracked although an ignore rule now matches it: an ignore rule never untracks a file.
  DRE_PDF="$(git -C "$p" ls-files -ci --exclude-standard -- "$DT_PDF" 2>/dev/null)"

  printf 'defaults:\n  DATA_STORE: external\n' > "$w/settings-trap.yml"
  (export COPIER_SETTINGS_PATH="$w/settings-trap.yml"; rp_update "$DRS_PROJ" HEAD) >"$DRS_LOG" 2>&1 || DRS_ST=$?
  cat "$DRS_LOG" >>"$log"

  # 78: the v0.4.0 project first, then a fresh sibling at v0.5.0 (which records repo beside a
  # record without a store); and the other order, a sibling from before D50 and a fresh copy.
  dt_sibling "$DRA_PROJ" "DATA_STORE: repo" "DATA_PROVIDER: none"
  sa_git "$DRA_PROJ" add -A && sa_git "$DRA_PROJ" commit -q -m 'a sibling at v0.5.0' >>"$log" 2>&1
  rp_update "$DRA_PROJ" HEAD >>"$log" 2>&1 || DRA_ST=$?
  mkdir -p "$DRB_PROJ"; dt_sibling "$DRB_PROJ"; sed -i 's/^_commit: v0.5.0$/_commit: v0.4.2/' "$DRB_PROJ/$SA_PEER_ANSWERS_FILE"
  { sa_git "$DRB_PROJ" init -q && sa_git "$DRB_PROJ" add -A && sa_git "$DRB_PROJ" commit -q -m 'a sibling from before D50'; } >>"$log" 2>&1 || true
  rp_copy "$tpl" HEAD "$DRB_PROJ" business --data DATA_PROVIDER=google-drive >>"$log" 2>&1 || DRB_ST=$?

  # 81 from v0.3.0.
  p="$DR3_PROJ"
  rp_copy "$tpl" "$TRAP_FROM" "$p" business --data INCLUDE_DRIVE_SYNC=true >>"$log" 2>&1 || DR3_COPY=$?
  [[ "$DR3_COPY" -eq 0 ]] || return 0
  [[ -d "$p/.git" ]] || sa_git "$p" init -q
  sa_git "$p" add -A && sa_git "$p" commit -q -m "copied at $TRAP_FROM" >>"$log" 2>&1
  dr_owner "$p"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'my own schedule; an issued copy' >>"$log" 2>&1
  rp_update "$p" HEAD >"$DR3_LOG" 2>&1 || DR3_UPD=$?
  cat "$DR3_LOG" >>"$log"
  DR3_UNMERGED="$(dt_unmerged "$p" .github)"
}

drive_checks() {
  local L="[business Drive]" v s
  if [[ "$DR4_COPY" -ne 0 || "$DR4_UPD" -ne 0 ]]; then
    finding "check 81 — $L from $DT_FROM: the copy or the update failed (copy exit $DR4_COPY, update exit $DR4_UPD) — see $DR4_LOG"
    return 0
  fi
  v="$(dr_drive_judge "$DR4_PROJ" "$DR4_UNMERGED")"
  [[ "$v" == ok ]] || finding "check 81 — $L from $DT_FROM, the update with --defaults: $v"
  if [[ "$DR3_COPY" -ne 0 || "$DR3_UPD" -ne 0 ]]; then
    finding "check 81 — $L from $TRAP_FROM: the copy or the update failed (copy exit $DR3_COPY, update exit $DR3_UPD) — see $DR3_LOG"
  else
    v="$(dr_drive_judge "$DR3_PROJ" "$DR3_UNMERGED")"
    [[ "$v" == ok ]] || finding "check 81 — $L from $TRAP_FROM, the update with --defaults: $v"
  fi
  v="$(dr_repo_judge "$DR4_PROJ")"
  [[ "$v" == ok ]] || finding "check 71 — $L from $DT_FROM, the project $v"
  v="$(dt_false_lines "$DR4_LOG")"
  [[ -z "$v" ]] || finding "check 76 — $L the update report lists template-owned files that read a data-root answer: $v"
  if [[ "$DR4_AGAIN_ST" -ne 0 || -n "$DR4_AGAIN_DIRTY" ]] || ! grep -q "^$RP_HEAD.*: $DT_SAME" "$DR4_AGAIN_LOG"; then
    finding "check 84 — $L a second update changed something (exit $DR4_AGAIN_ST; $(printf '%s\n' "$DR4_AGAIN_DIRTY" | grep -c . || true) path(s) changed)"
  fi
  if ! grep -qE '^    README\.md:[0-9]+ .*INCLUDE_DRIVE_SYNC' "$DR4_LOG" || ! grep -qF "$DT_STALE_DRIVE" "$DR4_LOG"; then
    finding "check 85 — $L the v0.5.0 migration did not list the seed README.md line that names INCLUDE_DRIVE_SYNC, with its v0.5.0 text"
  elif grep -qF "$DT_DRIVE_LIST" "$DR4_LOG"; then
    finding "check 85 — $L the v0.5.0 migration listed a Drive workflow the answers still manage"
  fi
  if [[ "$DRP_ST" -ne 0 ]]; then finding "check 83 — $L the update to DATA_PROVIDER onedrive failed (exit $DRP_ST)"
  else v="$(dr_gone_judge "$DRP_PROJ" "$DRP_LOG")"; [[ "$v" == ok ]] || finding "check 83 — $L after DATA_PROVIDER onedrive: $v"; fi
  if [[ "$DRE_ST" -ne 0 ]]; then
    finding "check 72 — $L the update to DATA_STORE external failed (exit $DRE_ST) — see $DRE_LOG"
  else
    v="$(dr_gone_judge "$DRE_PROJ" "$DRE_LOG")"; [[ "$v" == ok ]] || finding "check 83 — $L after DATA_STORE external: $v"
    v="$(dr_ext_judge "$DRE_PROJ" "$DT_EXT_SLUG" "$DT_AREA_DEFAULT")"
    s="$(LC_ALL=C comm -23 "$DR_W/index-before" "$DR_W/index-after" | paste -sd' ' - || true)"
    [[ "$v" == ok && -z "$s" && "$DRE_PDF" == "$DT_PDF" && -f "$DRE_PROJ/library/src/.gitignore" && -f "$DRE_PROJ/research/src/.gitignore" ]] \
      || finding "check 72 — $L choosing external: answers '$v'; untracked '${s:-nothing}'; the issued PDF tracked under an ignore rule: '${DRE_PDF:-no}'; the ignore files delivered: $([[ -f "$DRE_PROJ/library/src/.gitignore" && -f "$DRE_PROJ/research/src/.gitignore" ]] && echo yes || echo no)"
    s="$(dt_section_of "$DRE_LOG" research/src/.gitignore)"
    [[ "$s" == CONFLICT* ]] || finding "check 73 — $L the owner's own research/src/.gitignore is listed under '${s:-nothing}', not CONFLICT"
  fi
  if [[ "$DRS_ST" -ne 0 ]]; then finding "check 80 — $L the update under the settings trap failed (exit $DRS_ST)"
  else
    v="$(answer_value DATA_STORE "$DRS_PROJ/$SA_ANSWERS_FILE")"; s="$(dr_gone_judge "$DRS_PROJ" "$DRS_LOG")"
    [[ "$v" == external && "$s" == ok ]] || finding "check 80 — $L a settings file with DATA_STORE external: the update recorded '${v:-nothing}' and $s (the hazard must show)"
    if ! awk -v h="$DT_DRIVE_GONE" -v p="    $DT_PUSH" 'index($0, h) { on = 1; next } /^▸/ { on = 0 } on && $0 == p { f = 1 } END { exit !f }' "$DRS_LOG"; then
      finding "check 85 — $L the crossing update to external did not list the pre-guard $DT_PUSH it deleted, which its report offers to restore"
    elif grep -qF "$DT_STALE_DRIVE" "$DRS_LOG" || ! grep -qF "$DT_STALE_DRIVE_GONE" "$DRS_LOG"; then
      finding "check 85 — $L under external the v0.5.0 migration gave README.md's INCLUDE_DRIVE_SYNC line the google-drive text, not 'delete this line'"
    fi
  fi
  dr_sibling_check "$DRA_PROJ" "$DRA_ST" "the update after a fresh sibling at v0.5.0"
  dr_sibling_check "$DRB_PROJ" "$DRB_ST" "a fresh copy beside a sibling from before D50"
  return 0
}
dr_sibling_check() { # $1 = project, $2 = its exit status, $3 = what it was → check 78
  local a="$1/$SA_ANSWERS_FILE" L="[business Drive]"
  if [[ "$2" -ne 0 ]]; then finding "check 78 — $L $3 failed (exit $2)"; return 0; fi
  [[ "$(answer_value DATA_STORE "$a")" == repo && "$(answer_value DATA_PROVIDER "$a")" == google-drive && -f "$1/$DT_PUSH" ]] \
    || finding "check 78 — $L $3 recorded DATA_STORE '$(answer_value DATA_STORE "$a")' and DATA_PROVIDER '$(answer_value DATA_PROVIDER "$a")', .github/ $([[ -f "$1/$DT_PUSH" ]] && echo present || echo absent) — not repo, google-drive and the workflows"
}

# ── The round trip (D50): external with its own layout, repo, external again ─

RT_RAN=false; RT_DOC=""; RT_W=""; RT_PROJ=""; RT_ROOT=""; RT_ST=""; RT_STATUS_OUT=""; RT_ARGS=""
RT_CASE_ST=0; RT_CASE_DIRTY=""; RT_CASE_LOG=""
rt_step() { # $1 = label, then a command: runs it into the flow's log and keeps "label status"
  local label="$1" rc=0; shift
  "$@" >>"$log" 2>&1 || rc=$?
  st+=("$label $rc")
}
rt_resolver() { # $1 = project, then the resolver's arguments, with the round trip's own root
  (cd "$1" && SYNTEK_DATA_ROOT="$RT_ROOT" python3 "$SA_DATAROOT_PY" "${@:2}")
}
run_roundtrip_flow() { # $1 = tagged template, $2 = work dir, $3 = DOC_TYPE
  local tpl="$1" w="$2/rt" log="$2/rt-flow.log" p st=() a=()
  RT_RAN=true; RT_DOC="$3"; RT_W="$w"; RT_PROJ="$w/$DT_RT_DIR"; RT_ROOT="$w/data-root"; RT_STATUS_OUT=""; RT_ARGS=""
  RT_CASE_ST=0; RT_CASE_DIRTY=""; RT_CASE_LOG="$w/case.log"
  rm -rf "$w"; mkdir -p "$RT_ROOT"; : > "$RT_ROOT/$SA_DATAROOT_MARKER"; : > "$RT_CASE_LOG"
  [[ ${#SA_COPIER[@]} -gt 0 ]] || copier_init
  p="$RT_PROJ"
  rt_step copy rp_copy "$tpl" HEAD "$p" "$3" --data "DATA_AREA=$DT_RT_AREA" --data "DATA_SLUG=$DT_RT_SLUG"
  [[ -d "$p/.git" ]] || sa_git "$p" init -q
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'copied at external' >>"$log" 2>&1 || true
  cp "$p/$SA_ANSWERS_FILE" "$w/copied.yml" 2>/dev/null || true
  # A record filed under the custom layout (the root is passed to this one command only).
  mkdir -p "$p/research/src"; printf '%%PDF-1.4 an invented scan\n' > "$p/research/src/update-test-scan.pdf"
  rt_step add rt_resolver "$p" add research/src/update-test-scan.pdf --role archive
  rm -f "$p/research/src/update-test-scan.pdf"
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'filed a scan' >>"$log" 2>&1 || true
  rt_step repo rp_update "$p" HEAD --data DATA_STORE=repo
  cp "$p/$SA_ANSWERS_FILE" "$w/repo.yml" 2>/dev/null || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'repo' >>"$log" 2>&1 || true
  rt_step external rp_update "$p" HEAD --data DATA_STORE=external
  cp "$p/$SA_ANSWERS_FILE" "$w/again.yml" 2>/dev/null || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'external again' >>"$log" 2>&1 || true
  RT_STATUS_OUT="$(rt_resolver "$p" status 2>&1 || true)"
  RT_ARGS="$(sed -n 's/.*update every template with \(--data .*\)$/\1/p' <<< "$RT_STATUS_OUT" | head -1)"
  read -r -a a <<< "$RT_ARGS"
  rt_step restore rp_update "$p" HEAD "${a[@]}"
  cp "$p/$SA_ANSWERS_FILE" "$w/restored.yml" 2>/dev/null || true
  sa_git "$p" add -A && sa_git "$p" commit -q -m 'the layout restored' >>"$log" 2>&1 || true
  # 74: the same area in another case.
  rp_update "$p" HEAD --data "DATA_AREA=${DT_RT_AREA,,}" >"$RT_CASE_LOG" 2>&1 || RT_CASE_ST=$?
  cat "$RT_CASE_LOG" >>"$log"
  RT_CASE_DIRTY="$(git -C "$p" status --porcelain)"
  RT_ST="${st[*]}"
}

rt_checks() {
  local L="[$RT_DOC round trip]" bad=() k old="$DT_RT_AREA/docs/$DT_RT_SLUG"
  [[ "$RT_ST" == "copy 0 add 0 repo 0 external 0 restore 0" ]] || bad+=("exit statuses: $RT_ST")
  [[ "$(answer_value DATA_AREA "$RT_W/copied.yml")" == "$DT_RT_AREA" && "$(answer_value DATA_SLUG "$RT_W/copied.yml")" == "$DT_RT_SLUG" ]] \
    || bad+=("the copy did not record its own layout")
  [[ "$(answer_value DATA_STORE "$RT_W/repo.yml")" == repo ]] || bad+=("repo was not recorded")
  for k in $DT_LAYOUT_KEYS; do grep -q "^$k:" "$RT_W/repo.yml" 2>/dev/null && bad+=("repo still records $k"); done
  k="$(ut_rt_again)"
  [[ "$k" == ok ]] || bad+=("external again $k")
  [[ "$RT_STATUS_OUT" == *"'$old'"* ]] || bad+=("the resolver's status does not name the old folder '$old'")
  [[ "$RT_ARGS" == "--data DATA_AREA=$DT_RT_AREA --data DATA_SLUG=$DT_RT_SLUG" ]] || bad+=("it printed the restore arguments '${RT_ARGS:-none}'")
  [[ "$(answer_value DATA_AREA "$RT_W/restored.yml")" == "$DT_RT_AREA" && "$(answer_value DATA_SLUG "$RT_W/restored.yml")" == "$DT_RT_SLUG" ]] \
    || bad+=("--data did not restore the layout")
  [[ ${#bad[@]} -eq 0 ]] || finding "check 79 — $L $(verdict "${bad[@]}")"
  if [[ "$RT_CASE_ST" -eq 0 ]]; then
    finding "check 74 — $L an update changing DATA_AREA only in case was accepted"
  elif ! grep -qF "question 'DATA_AREA'" "$RT_CASE_LOG" || [[ -n "$RT_CASE_DIRTY" ]] \
       || [[ "$(answer_value DATA_AREA "$RT_PROJ/$SA_ANSWERS_FILE")" != "$DT_RT_AREA" ]]; then
    finding "check 74 — $L the case-only DATA_AREA change was not refused by DATA_AREA's validator with the tree clean ($(printf '%s\n' "$RT_CASE_DIRTY" | grep -c . || true) path(s) changed)"
  fi
  return 0
}
ut_rt_again() { # the answers after external again: the defaults re-derived
  local f="$RT_W/again.yml" bad=() v
  v="$(answer_value DATA_STORE "$f")"; [[ "$v" == external ]] || bad+=("records '${v:-nothing}'")
  v="$(answer_value DATA_AREA "$f")"; [[ "$v" == "$DT_AREA_DEFAULT" ]] || bad+=("records area '${v:-nothing}', not the default '$DT_AREA_DEFAULT'")
  v="$(answer_value DATA_SLUG "$f")"; [[ "$v" == "$DT_RT_SLUG_DEFAULT" ]] || bad+=("records slug '${v:-nothing}', not the folder's '$DT_RT_SLUG_DEFAULT'")
  verdict "${bad[@]}"
}

# The trees, logs and statuses every check from 60 to 85 reads, as a clean run leaves them, for
# --self-test: invented server values, the real file shapes and the real report lines.
dt_synth() { # $1 = dir
  local s="$1"
  rm -rf "$s"; mkdir -p "$s"
  python3 - "$s" "$SA_MCP_ASKS" "$SA_MCP_DENY" "$SA_ANSWERS_FILE" "$DT_EXT_DIR" "$DT_RT_DIR" <<'PY'
import json, os, sys
s, asks, deny, ans, ext_dir, rt_dir = sys.argv[1], sys.argv[2].split(), sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6]
T = {"code-review-graph": {"command": "uvx", "args": ["code-review-graph==9.9.9", "serve"]},
     "scrapling": {"command": "uvx", "args": ["scrapling==9.9.9", "mcp"]}}
def w(rel, text):
    p = os.path.join(s, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w", encoding="utf-8").write(text)
def j(rel, d, indent=2):
    w(rel, json.dumps(d, indent=indent) + "\n")
def toml(servers):
    out = []
    for n, v in servers.items():
        out += ["", f"[mcp_servers.{n}]", "command = 'uvx'", "args = [%s]" % ", ".join(repr(a) for a in v["args"])]
        for r in asks:
            _, srv, tool = r.split("__", 2)
            if srv == n:
                out += ["", f"[mcp_servers.{n}.tools.{tool}]", 'approval_mode = "prompt"']
    return "\n".join(out) + "\n"
def answers(rel, **kv):
    w(rel, "".join(f"{k}: {v}\n" for k, v in sorted(kv.items())))
oc_asks = [{"action": "%s_%s" % tuple(r.split("__", 2)[1:]), "resource": "*", "effect": "ask"} for r in asks]
rules = {"permissions": {"deny": ["AskUserQuestion", deny], "ask": list(asks)}}
codex0 = "project_doc_fallback_filenames = ['CLAUDE.md']\n"
mine = {"owner-notes": {"command": "uvx", "args": ["owner-notes-mcp==1.0.0"]},
        "scrapling": {"command": "uvx", "args": ["scrapling==0.0.1", "mcp"]}}
oc0 = {"permissions": [{"action": "edit", "resource": "*.pdf", "effect": "deny"}, {"action": "*", "resource": "*", "effect": "allow"}],
       "$schema": "https://opencode.ai/config.json", "compaction": {"auto": False}}
# The MCP flow: before, after the update, the new render, and the end.
j("mc/pre/.mcp.json", {"mcpServers": mine}, 4)
j("mc/pre/.agents/mcp_config.json", {"mcpServers": {}})
w("mc/pre/.codex/config.toml", codex0)
j("mc/pre/opencode.json", oc0, 4)
for d in ("tpl-mid", "tpl-end"):
    j(f"mc/{d}/.mcp.json", {"mcpServers": T}); j(f"mc/{d}/.agents/mcp_config.json", {"mcpServers": T})
    w(f"mc/{d}/.codex/config.toml", codex0 + toml(T))
    j(f"mc/{d}/opencode.json", {"$schema": oc0["$schema"], "compaction": oc0["compaction"], "mcp": {"servers": T}, "permissions": oc_asks})
mid = {"mcpServers": {**mine, "code-review-graph": T["code-review-graph"]}}
for d in ("mc/mid", "mc/proj"):
    j(f"{d}/.mcp.json", mid, 4); j(f"{d}/.agents/mcp_config.json", {"mcpServers": T})
    w(f"{d}/.codex/config.toml", codex0 + toml(T)); j(f"{d}/.claude/settings.json", rules)
j("mc/mid/opencode.json", oc0, 4)
j("mc/proj/opencode.json", {**oc0, "permissions": oc0["permissions"] + oc_asks, "mcp": {"servers": T}}, 4)
answers(f"mc/proj/{ans}", DOC_TYPE="theology", DATA_STORE="repo", DATA_PROVIDER="none")
for d in ("mc/proj", "td/proj", "dr/v040", "dr/v030"):
    w(f"{d}/.claude/syntek-author-dataroot.py", "# the resolver\n"); w(f"{d}/.claude/syntek-author-dataroot.json", "{}\n")
held = "▸ syntek-author: to carry the new ask and deny rules into opencode.json, run: python3 .claude/syntek-author-permissions.py --write; the next update then adds the MCP servers to each file that holds their ask rules (held back now: opencode.json code-review-graph, scrapling)\n"
w("mc/up.log", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n"
  "▸ syntek-author: added 1 MCP server to .mcp.json: code-review-graph\n"
  "▸ syntek-author: kept your \"scrapling\" MCP server in .mcp.json, which differs from the template's (compare: git diff syntek-author/template -- .mcp.json)\n"
  + held + "▸ syntek-author update report, 0.4.0 → 0.5.0\n  The template changed 2 files here: 2 delivered.\n")
w("mc/next.log", "▸ syntek-author: added 2 MCP servers to opencode.json: code-review-graph, scrapling\n"
  "▸ syntek-author update report, 0.5.0 → 0.5.1\n  The template changed 3 files here: 1 delivered, 2 kept back.\n\n"
  "  NOT UPDATED because files of this kind are written once: seeds, examples, copy-only (2):\n"
  "    .agents/mcp_config.json\n        compare: git diff syntek-author/template -- .agents/mcp_config.json\n"
  "    .codex/config.toml\n        compare: git diff syntek-author/template -- .codex/config.toml\n\n"
  "  These commands work offline until the next update.\n")
w("mc/again.log", "▸ syntek-author update report, 0.5.1 → 0.5.1: the template did not change.\n")
w("mc/mig1.out", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n")
w("mc/mig2.out", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n")
j("mc/removed/.mcp.json", {"mcpServers": mine}, 4)
j("mc/removed/.agents/mcp_config.json", {"mcpServers": {"code-review-graph": T["code-review-graph"]}})
# The owner who allows every Scrapling tool, keeps .mcp.json out of git and runs a workflow.
j("mc/allowed/.claude/settings.json", {"permissions": {"allow": ["mcp__scrapling__*"], "deny": [deny],
                                                         "ask": [r for r in asks if not r.startswith("mcp__scrapling__")]}})
j("mc/allowed/.mcp.json", {"mcpServers": {}})
w("mc/allowed.log", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n"
  "  These workflows name Google Drive's API, and the recorded answers ship no .github/.\n\n"
  "    .github/workflows/google-drive-push.yml\n"
  "▸ syntek-author: not added to .claude/settings.json, because you allow it: "
  + "; ".join("ask " + r for r in asks if r.startswith("mcp__scrapling__")) + "\n"
  "▸ syntek-author: .mcp.json is ignored by git, so it was not read and no MCP server was added to it (add them by hand): code-review-graph, scrapling\n"
  "▸ syntek-author: to carry the new ask and deny rules into opencode.json and .gemini/settings.json, run: python3 .claude/syntek-author-permissions.py --write; "
  "the next update then adds the MCP servers to each file that holds their ask rules (held back now: opencode.json code-review-graph; .gemini/settings.json code-review-graph)\n"
  "▸ syntek-author: these MCP servers wait for ask rules --write cannot carry, because .claude/settings.json does not ask before their tools (you allow them there): "
  "opencode.json scrapling; .gemini/settings.json scrapling. To add them, either add those asks to .claude/settings.json ("
  + ", ".join(r for r in asks if r.startswith("mcp__scrapling__")) + ") and run python3 .claude/syntek-author-permissions.py --write, after which "
  "the next update adds them; or add the servers to those files by hand (git show syntek-author/template:opencode.json; git show syntek-author/template:.gemini/settings.json).\n"
  "▸ syntek-author update report, 0.4.0 → 0.5.0\n")
answers(f"mc/sibling/{ans}", DATA_STORE="external", DATA_AREA="Studio", DATA_SLUG="shared-probe", DATA_PROVIDER="none")
# The update from v0.3.0.
j("td/proj/.claude/settings.json", rules); j("td/proj/.mcp.json", {"mcpServers": T})
answers(f"td/proj/{ans}", DOC_TYPE="theology", DATA_STORE="repo", DATA_PROVIDER="none", AGENT_CLIENTS="[]")
j("td/pre/.mcp.json", {"mcpServers": {}}); j("td/tpl/.mcp.json", {"mcpServers": T})
w("td/up.log", "▸ syntek-author update report, 0.3.0 → 0.5.0\n  The template changed 9 files here: 9 delivered.\n")
# The Drive flows.
step = "      - name: Stop unless the documents are kept in the repository\n"
for d in ("dr/v040", "dr/v030"):
    answers(f"{d}/{ans}", DOC_TYPE="business", DATA_STORE="repo", DATA_PROVIDER="google-drive")
    w(f"{d}/.github/workflows/google-drive-pull.yml", "on:\n  schedule:\n    - cron: '30 5 * * 1-5'\njobs:\n  pull:\n    steps:\n" + step)
    w(f"{d}/.github/workflows/google-drive-push.yml", "on: push\njobs:\n  push:\n    steps:\n" + step)
w("dr/v040.log", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n"
  "    README.md:206  - `INCLUDE_DRIVE_SYNC=false` deletes `.github/`, the Drive push and pull workflows.\n"
  "        v0.5.0: DATA_PROVIDER replaces INCLUDE_DRIVE_SYNC: '- Choosing a provider other than Google Drive …'\n"
  "▸ syntek-author update report, 0.4.0 → 0.5.0\n")
w("dr/v030.log", "▸ syntek-author update report, 0.3.0 → 0.5.0\n")
w("dr/again.log", "▸ syntek-author update report, 0.5.0 → 0.5.0: the template did not change.\n")
gone = ("▸ syntek-author update report, 0.5.0 → 0.5.0\n"
        "  DELETED by this update although you had changed them (retired by the template, or by an answer that no longer ships them) (1):\n"
        "    .github/workflows/google-drive-pull.yml\n        see:     git show syntek-author/yours:.github/workflows/google-drive-pull.yml\n")
answers(f"dr/onedrive/{ans}", DOC_TYPE="business", DATA_STORE="repo", DATA_PROVIDER="onedrive")
w("dr/onedrive.log", gone)
answers(f"dr/{ext_dir}/{ans}", DOC_TYPE="business", DATA_STORE="external", DATA_AREA="business", DATA_SLUG="ext-probe-project-v2")
w(f"dr/{ext_dir}/library/src/.gitignore", "*.pdf\n"); w(f"dr/{ext_dir}/research/src/.gitignore", "*.pdf\n")
w("dr/external.log", gone.replace("  DELETED", "  CONFLICT: both versions are in the file between <<<<<<< and >>>>>>>; resolve it, then git add (1):\n    research/src/.gitignore\n  DELETED", 1))
w("dr/index-before", ".gitignore\nlibrary/src/business/update-test-issued.pdf\n")
w("dr/index-after", ".gitignore\nlibrary/src/.gitignore\nlibrary/src/business/update-test-issued.pdf\n")
answers(f"dr/settings-trap/{ans}", DOC_TYPE="business", DATA_STORE="external", DATA_PROVIDER="google-drive")
w("dr/settings-trap.log", "▸ v0.5.0 migration — the data root and the provider (DESIGN.md D50, D53); report only\n"
  "  This update deleted these workflows, which name Google Drive's API. Your copies\n"
  "  predate the store guard, so one restored from the update report (git restore\n\n"
  "    .github/workflows/google-drive-pull.yml\n    .github/workflows/google-drive-push.yml\n\n"
  "    README.md:206  - `INCLUDE_DRIVE_SYNC=false` deletes `.github/`, the Drive push and pull workflows.\n"
  "        v0.5.0: delete this line: these answers (DOC_TYPE business, DATA_PROVIDER google-drive, DATA_STORE external) ship no `.github/`\n"
  + gone)
for d in ("dr/sibling-after", "dr/sibling-first"):
    answers(f"{d}/{ans}", DOC_TYPE="business", DATA_STORE="repo", DATA_PROVIDER="google-drive")
    w(f"{d}/.github/workflows/google-drive-push.yml", "on: push\n")
# The round trip.
answers("rt/copied.yml", DATA_STORE="external", DATA_AREA="Clients", DATA_SLUG="custom-slug")
answers("rt/repo.yml", DATA_STORE="repo", DATA_PROVIDER="none")
answers("rt/again.yml", DATA_STORE="external", DATA_AREA="business", DATA_SLUG="round-trip-probe")
answers("rt/restored.yml", DATA_STORE="external", DATA_AREA="Clients", DATA_SLUG="custom-slug")
answers(f"rt/{rt_dir}/{ans}", DATA_STORE="external", DATA_AREA="Clients", DATA_SLUG="custom-slug")
w("rt/case.log", "ValueError: Validation error for question 'DATA_AREA': This project's files are filed under 'Clients'.\n")
PY
  MC_RAN=true; MC_DOC=theology; MC_W="$s/mc"; MC_PROJ="$s/mc/proj"; MC_LOG="$s/mc/up.log"; MC_NEXT_LOG="$s/mc/next.log"; MC_AGAIN_LOG="$s/mc/again.log"
  MC_COPY=0; MC_UPD=0; MC_WRITE=0; MC_CHECK1=0; MC_NEXT_ST=0; MC_CHECK2=0; MC_AGAIN_ST=0; MC_AGAIN_DIRTY=""
  MC_CLIENTS_PRE="AGENTS.md GEMINI.md .agents/mcp_config.json .codex/config.toml opencode.json"
  MC_CLIENTS_MID="$MC_CLIENTS_PRE"; MC_CLIENTS_END="$MC_CLIENTS_PRE"; MC_MIG1=0; MC_MIG2=0; MC_MIG_DIRTY=""; MC_ABS=""
  MR_PROJ="$s/mc/removed"; MR_ST=0
  MA_PROJ="$s/mc/allowed"; MA_LOG="$s/mc/allowed.log"; MA_COPY=0; MA_UPD=0; MA_STAT_PRE="$(dt_stat "$MA_PROJ/.mcp.json")"
  SB_PROJ="$s/mc/sibling"; SB_ST=0
  TD_RAN=true; TD_DOC=theology; TD_PROJ="$s/td/proj"; TD_LOG="$s/td/up.log"; TD_PRE="$s/td/pre"; TD_TPL="$s/td/tpl"
  TRAP_COPY_STATUS=0; TRAP_UPDATE_STATUS=0
  DR_RAN=true; DR_W="$s/dr"
  DR4_PROJ="$s/dr/v040"; DR4_LOG="$s/dr/v040.log"; DR4_COPY=0; DR4_UPD=0; DR4_UNMERGED=""; DR4_AGAIN_ST=0; DR4_AGAIN_DIRTY=""; DR4_AGAIN_LOG="$s/dr/again.log"
  DR3_PROJ="$s/dr/v030"; DR3_LOG="$s/dr/v030.log"; DR3_COPY=0; DR3_UPD=0; DR3_UNMERGED=""
  DRP_PROJ="$s/dr/onedrive"; DRP_LOG="$s/dr/onedrive.log"; DRP_ST=0
  DRE_PROJ="$s/dr/$DT_EXT_DIR"; DRE_LOG="$s/dr/external.log"; DRE_ST=0; DRE_PDF="$DT_PDF"
  DRS_PROJ="$s/dr/settings-trap"; DRS_LOG="$s/dr/settings-trap.log"; DRS_ST=0
  DRA_PROJ="$s/dr/sibling-after"; DRA_ST=0; DRB_PROJ="$s/dr/sibling-first"; DRB_ST=0
  RT_RAN=true; RT_DOC=theology; RT_W="$s/rt"; RT_PROJ="$s/rt/$DT_RT_DIR"; RT_ROOT="$s/rt/data-root"
  RT_ST="copy 0 add 0 repo 0 external 0 restore 0"
  RT_STATUS_OUT="warning: 1 current row(s) are filed under '$DT_RT_AREA/docs/$DT_RT_SLUG', not this project's '$DT_AREA_DEFAULT/docs/$DT_RT_SLUG_DEFAULT': to file there again, update every template with --data DATA_AREA=$DT_RT_AREA --data DATA_SLUG=$DT_RT_SLUG"
  RT_ARGS="--data DATA_AREA=$DT_RT_AREA --data DATA_SLUG=$DT_RT_SLUG"; RT_CASE_ST=1; RT_CASE_DIRTY=""; RT_CASE_LOG="$s/rt/case.log"
}
dt_json() { # $1 = file, $2 = Python statement on d: edits a JSON file in place
  python3 - "$1" "$2" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
exec(sys.argv[2])
open(sys.argv[1], "w", encoding="utf-8").write(json.dumps(d, indent=2) + "\n")
PY
}

# The probes for checks 60–85, on dt_synth's trees: each mutation is undone before the next.
dt_self_test() { # $1 = scratch dir
  local s="$1/dt" h="$1/dt-held" r first
  dt_synth "$s"
  dt_readers_init
  st_baseline "the trees and logs of real updates across D50, D53 and D54 (synthetic)"
  first="$(head -1 <<< "$DT_READERS")"
  hold() { cp -a "$1" "$h"; }; back() { rm -rf "$1"; cp -a "$h" "$1"; rm -rf "$h"; }
  MC_UPD=1; probe "check 60 fires when the crossing update fails" "check 60 — [theology from v0.4.0] the copy at v0.4.0 or the update"; MC_UPD=0
  hold "$s/mc/mid/.claude/settings.json"; dt_json "$s/mc/mid/.claude/settings.json" 'd["permissions"]["ask"].pop()'
  probe "check 60 fires when an ask does not arrive" "check 60 — [theology from v0.4.0] after the update, .claude/settings.json asks"; back "$s/mc/mid/.claude/settings.json"
  hold "$s/td/proj/.claude/settings.json"; dt_json "$s/td/proj/.claude/settings.json" 'd["permissions"]["deny"].append(d["permissions"]["deny"][-1])'
  probe "check 60 fires when the deny arrives twice" "check 60 — [theology from v0.3.0] after the update, .claude/settings.json denies"; back "$s/td/proj/.claude/settings.json"
  hold "$s/mc/mid/.mcp.json"; dt_json "$s/mc/mid/.mcp.json" 'd["mcpServers"].pop("owner-notes")'
  probe "check 61 fires when the owner's own server is lost" "check 61 — [theology from v0.4.0] after the update, .mcp.json: a key"; back "$s/mc/mid/.mcp.json"
  hold "$s/mc/mid/.agents/mcp_config.json"; printf '{"mcpServers": {"scrapling": {}, "scrapling": {}}}\n' > "$s/mc/mid/.agents/mcp_config.json"
  probe "check 61 fires when a server is declared twice and another is missing" "check 61 — [theology from v0.4.0] after the update, .agents/mcp_config.json: declares code-review-graph 0 time(s)"; back "$s/mc/mid/.agents/mcp_config.json"
  hold "$s/mc/proj/opencode.json"; dt_json "$s/mc/proj/opencode.json" 'd["mcp"]["servers"]["scrapling"]["args"] = ["x"]'
  probe "check 61 fires when a server is not the new render's" "check 61 — [theology from v0.4.0] after --write and the next update, opencode.json: its scrapling entry"; back "$s/mc/proj/opencode.json"
  hold "$s/mc/proj/opencode.json"; dt_json "$s/mc/proj/opencode.json" 'd["permissions"][:2] = d["permissions"][1::-1]'
  probe "check 61 fires when the owner's list items change order" "check 61 — [theology from v0.4.0] after --write and the next update, opencode.json: a key, value or list item it held before is gone or out of order"; back "$s/mc/proj/opencode.json"
  hold "$s/td/proj/.mcp.json"; dt_json "$s/td/proj/.mcp.json" 'd["mcpServers"].pop("scrapling")'
  probe "check 61 fires when the update from v0.3.0 misses a server" "check 61 — [theology from v0.3.0] after the update, .mcp.json: declares scrapling 0"; back "$s/td/proj/.mcp.json"
  r="$MC_CLIENTS_END"; MC_CLIENTS_END="$r .gemini/settings.json"
  probe "check 62 fires when a deleted client file comes back" "check 62"; MC_CLIENTS_END="$r"
  hold "$s/mc/mid/.codex/config.toml"; sed -i '0,/approval_mode = "prompt"/s//approval_mode = "never"/' "$s/mc/mid/.codex/config.toml"
  probe "check 63 fires when a Codex prompt table is not the render's" "check 63"; back "$s/mc/mid/.codex/config.toml"
  MC_CHECK2=1; probe "check 64 fires when --check fails after the next update" "check 64 — [theology from v0.4.0] the printed --write"; MC_CHECK2=0
  hold "$MC_LOG"; grep -vF "$DT_WRITE_LINE" "$h" > "$MC_LOG" || true
  probe "check 64 fires when the --write line is not printed" "check 64 — [theology from v0.4.0] the update did not print"; back "$MC_LOG"
  hold "$s/mc/removed/.mcp.json"; dt_json "$s/mc/removed/.mcp.json" 'd["mcpServers"]["code-review-graph"] = {}'
  probe "check 65 fires when a server removed before any commit comes back" "check 65 — [theology from v0.4.0] .mcp.json"; back "$s/mc/removed/.mcp.json"
  hold "$s/mc/removed/.agents/mcp_config.json"; dt_json "$s/mc/removed/.agents/mcp_config.json" 'd["mcpServers"]["scrapling"] = {}'
  probe "check 65 fires when a server removed after a commit comes back" "check 65 — [theology from v0.4.0] .agents/mcp_config.json"; back "$s/mc/removed/.agents/mcp_config.json"
  hold "$MC_NEXT_LOG"; { grep -F "$DT_DIFF_LINE" "$MC_LOG"; cat "$h"; } > "$MC_NEXT_LOG"
  probe "check 66 fires when the differing entry is reported again" "check 66"; back "$MC_NEXT_LOG"
  hold "$s/mc/proj/.mcp.json"; dt_json "$s/mc/proj/.mcp.json" 'd["mcpServers"]["scrapling"]["args"] = ["the template'"'"'s"]'
  probe "check 66 fires when the owner's differing entry is replaced" "check 66"; back "$s/mc/proj/.mcp.json"
  printf ' ' >> "$MA_PROJ/.mcp.json"; probe "check 67 fires when the git-ignored .mcp.json is written" "check 67"
  printf '{\n  "mcpServers": {}\n}\n' > "$MA_PROJ/.mcp.json"; MA_STAT_PRE="$(dt_stat "$MA_PROJ/.mcp.json")"
  hold "$MA_LOG"; grep -vF "$DT_IGNORED_LINE" "$h" > "$MA_LOG" || true
  probe "check 67 fires when the ignored .mcp.json is not reported" "check 67"; back "$MA_LOG"
  hold "$MA_LOG"; printf '  NOT UPDATED because you had changed them (1):\n    .mcp.json\n' >> "$MA_LOG"
  probe "check 67 fires when the ignored .mcp.json is listed as your edit" "check 67"; back "$MA_LOG"
  hold "$MA_PROJ/.claude/settings.json"; dt_json "$MA_PROJ/.claude/settings.json" 'd["permissions"]["ask"].append("mcp__scrapling__fetch")'
  probe "check 68 fires when an allowed Scrapling ask is added" "check 68 — [theology from v0.4.0] where the owner allows"; back "$MA_PROJ/.claude/settings.json"
  hold "$MA_LOG"; sed -i 's/; ask mcp__scrapling__bulk_fetch//' "$MA_LOG"
  probe "check 68 fires when a left-out ask is not reported" "check 68 — [theology from v0.4.0] the update did not say it left out 'mcp__scrapling__bulk_fetch'"; back "$MA_LOG"
  hold "$s/mc/mid/opencode.json"; dt_json "$s/mc/mid/opencode.json" 'd["mcp"] = {"servers": {"scrapling": {}}}'
  probe "check 69 fires when a server reaches opencode.json before its asks" "check 69 — [theology from v0.4.0] opencode.json, whose owner allows every tool, declares scrapling"; back "$s/mc/mid/opencode.json"
  hold "$s/mc/proj/opencode.json"; dt_json "$s/mc/proj/opencode.json" 'd["permissions"] = [p for p in d["permissions"] if p["action"] != "scrapling_fetch"]'
  probe "check 69 fires when a Scrapling tool is left unprompted" "check 69 — [theology from v0.4.0] after --write and the next update, opencode.json declares scrapling but does not ask before scrapling_fetch"; back "$s/mc/proj/opencode.json"
  hold "$MA_LOG"; grep -vF "$DT_WAIT_LINE" "$h" > "$MA_LOG" || true
  probe "check 89 fires when the allowed server's wait is not said" "check 89 — [theology from v0.4.0] where the owner allows mcp__scrapling__*, the update said 0 time(s)"; back "$MA_LOG"
  hold "$MA_LOG"; grep -F "$DT_WAIT_LINE" "$h" >> "$MA_LOG"
  probe "check 89 fires when the allowed server's wait is said twice" "check 89 — [theology from v0.4.0] where the owner allows mcp__scrapling__*, the update said 2 time(s)"; back "$MA_LOG"
  hold "$MA_LOG"; sed -i 's/(held back now: opencode.json code-review-graph;/(held back now: opencode.json code-review-graph, scrapling;/' "$MA_LOG"
  probe "check 89 fires when the --write line promises the allowed server" "check 89 — [theology from v0.4.0] the --write line promises Scrapling"; back "$MA_LOG"
  hold "$MC_LOG"; sed -i 's/ into opencode.json, run: python3/ into opencode.json and .codex\/config.toml, run: python3/' "$MC_LOG"
  probe "check 89 fires when the --write line names a client file that holds every rule" "check 89 — [theology from v0.4.0] the --write line names .codex/config.toml"; back "$MC_LOG"
  hold "$MC_LOG"; sed -i 's/ into opencode.json, run: python3/ into .gemini\/settings.json, run: python3/' "$MC_LOG"
  probe "check 89 fires when the --write line leaves out opencode.json" "check 89 — [theology from v0.4.0] the --write line does not name opencode.json"; back "$MC_LOG"
  hold "$MC_NEXT_LOG"
  sed -i -e 's/^  NOT UPDATED because files of this kind are written once.*/  NOT UPDATED because you had changed them (1):/' -e '/^    \.agents\/mcp_config\.json$/d' "$MC_NEXT_LOG"
  probe "check 70 fires when a lane-written file counts as the owner's" "check 70 — [theology from v0.4.0] the next update lists .codex/config.toml"
  back "$MC_NEXT_LOG"
  MC_AGAIN_DIRTY=" M .mcp.json"; probe "check 70 fires when a second update changes a file" "check 70 — [theology from v0.4.0] the next update"; MC_AGAIN_DIRTY=""
  MC_ABS="/tmp/x/tagged"; probe "check 59 fires when the real record names a path" "check 59 — [theology from v0.4.0]"; MC_ABS=""
  hold "$TD_PROJ/$SA_ANSWERS_FILE"; printf 'DATA_AREA: business\n' >> "$TD_PROJ/$SA_ANSWERS_FILE"
  probe "check 71 fires when an update under repo records a layout answer" "check 71 — [theology from v0.3.0] after the update with --defaults, the project records DATA_AREA"; back "$TD_PROJ/$SA_ANSWERS_FILE"
  mkdir -p "$MC_PROJ/research/src"; : > "$MC_PROJ/research/src/.gitignore"
  probe "check 71 fires when an update under repo delivers an ignore file" "check 71 — [theology from v0.4.0] after the update with --defaults, the project gained research/src/.gitignore"
  rm -rf "$MC_PROJ/research"
  hold "$DR4_PROJ/.claude/syntek-author-dataroot.py"; rm -f "$DR4_PROJ/.claude/syntek-author-dataroot.py"
  probe "check 71 fires when the resolver does not arrive" "check 71 — [business Drive] from v0.4.0, the project has no .claude/syntek-author-dataroot.py"; back "$DR4_PROJ/.claude/syntek-author-dataroot.py"
  DRE_PDF=""; probe "check 72 fires when a tracked binary is untracked" "check 72"; DRE_PDF="$DT_PDF"
  hold "$DRE_PROJ/$SA_ANSWERS_FILE"; sed -i 's/^DATA_SLUG: .*/DATA_SLUG: probe-project/' "$DRE_PROJ/$SA_ANSWERS_FILE"
  probe "check 72 fires when DATA_SLUG is not the folder's kebab name" "check 72 — [business Drive] choosing external: answers 'records DATA_SLUG"; back "$DRE_PROJ/$SA_ANSWERS_FILE"
  hold "$DRE_LOG"; grep -v -e '^  CONFLICT' -e '^    research/src/.gitignore$' "$h" > "$DRE_LOG" || true
  probe "check 73 fires when the owner's ignore file is not a conflict" "check 73"; back "$DRE_LOG"
  RT_CASE_ST=0; probe "check 74 fires when a case-only area change is accepted" "check 74 — [theology round trip] an update changing"; RT_CASE_ST=1
  RT_CASE_DIRTY=" M .copier-answers.syntek-author.yml"; probe "check 74 fires when the refusal touched the tree" "check 74 — [theology round trip] the case-only"; RT_CASE_DIRTY=""
  printf 'a later line\n' >> "$s/mc/mig2.out"; probe "check 75 fires when the migration's second run differs" "check 75 — [theology from v0.4.0] two hand runs"
  head -1 "$s/mc/mig1.out" > "$s/mc/mig2.out"
  hold "$MC_LOG"; { grep "^$RP_HEAD" "$h"; grep -v "^$RP_HEAD" "$h"; } > "$MC_LOG"
  probe "check 75 fires when the migration runs after the report" "check 75 — [theology from v0.4.0] the v0.5.0 migration did not run before"; back "$MC_LOG"
  hold "$TD_LOG"; printf '  NOT UPDATED because you had changed them (1):\n    %s\n' "$first" >> "$TD_LOG"
  probe "check 76 fires when a data-root reader is reported as kept back" "check 76 — [theology from v0.3.0] the update report lists template-owned files that read a data-root answer: $first"; back "$TD_LOG"
  hold "$SB_PROJ/$SA_ANSWERS_FILE"; sed -i 's/^DATA_STORE: .*/DATA_STORE: repo/' "$SB_PROJ/$SA_ANSWERS_FILE"
  probe "check 77 fires when the first update ignores a sibling at external" "check 77"; back "$SB_PROJ/$SA_ANSWERS_FILE"
  hold "$DRB_PROJ/.github"; rm -rf "$DRB_PROJ/.github"
  probe "check 78 fires when a fresh copy beside a sibling from before D50 ships no .github/" "check 78 — [business Drive] a fresh copy"; back "$DRB_PROJ/.github"
  hold "$DRA_PROJ/$SA_ANSWERS_FILE"; sed -i 's/^DATA_STORE: .*/DATA_STORE: external/' "$DRA_PROJ/$SA_ANSWERS_FILE"
  probe "check 78 fires when the update beside a fresh sibling leaves repo" "check 78 — [business Drive] the update after"; back "$DRA_PROJ/$SA_ANSWERS_FILE"
  r="$RT_ARGS"; RT_ARGS=""; probe "check 79 fires when the resolver prints no restore arguments" "check 79"; RT_ARGS="$r"
  hold "$RT_W/again.yml"; sed -i "s/^DATA_SLUG: .*/DATA_SLUG: $DT_RT_SLUG/" "$RT_W/again.yml"
  probe "check 79 fires when repo does not forget the layout" "check 79 — [theology round trip] external again records slug"; back "$RT_W/again.yml"
  r="$RT_STATUS_OUT"; RT_STATUS_OUT="status: 0 not filed"; probe "check 79 fires when the old folder is not named" "check 79"; RT_STATUS_OUT="$r"
  hold "$DRS_PROJ/$SA_ANSWERS_FILE"; sed -i 's/^DATA_STORE: .*/DATA_STORE: repo/' "$DRS_PROJ/$SA_ANSWERS_FILE"
  probe "check 80 fires when the settings trap does not show" "check 80"; back "$DRS_PROJ/$SA_ANSWERS_FILE"
  hold "$DR4_PROJ/$DT_PULL"; sed -i '/cron/d' "$DR4_PROJ/$DT_PULL"
  probe "check 81 fires when the owner's edit to a Drive workflow is lost" "check 81 — [business Drive] from v0.4.0, the update with --defaults: the owner's edit"; back "$DR4_PROJ/$DT_PULL"
  hold "$DR3_PROJ/$DT_PUSH"; sed -i '/- name: Stop unless/d' "$DR3_PROJ/$DT_PUSH"
  probe "check 81 fires when the store guard step is not merged" "check 81 — [business Drive] from v0.3.0, the update with --defaults: $DT_PUSH holds the store guard step 0"; back "$DR3_PROJ/$DT_PUSH"
  hold "$DR3_PROJ/$SA_ANSWERS_FILE"; printf 'INCLUDE_DRIVE_SYNC: true\n' >> "$DR3_PROJ/$SA_ANSWERS_FILE"
  probe "check 81 fires when the retired key is still recorded" "check 81 — [business Drive] from v0.3.0, the update with --defaults: still records"; back "$DR3_PROJ/$SA_ANSWERS_FILE"
  DR4_UNMERGED="$DT_PULL"; probe "check 81 fires on an unmerged workflow" "check 81 — [business Drive] from v0.4.0, the update with --defaults: unmerged"; DR4_UNMERGED=""
  hold "$TD_PROJ/$SA_ANSWERS_FILE"; sed -i 's/^DATA_PROVIDER: .*/DATA_PROVIDER: google-drive/' "$TD_PROJ/$SA_ANSWERS_FILE"
  probe "check 82 fires when a project without Drive records google-drive" "check 82 — [theology from v0.3.0]"; back "$TD_PROJ/$SA_ANSWERS_FILE"
  mkdir -p "$MC_PROJ/.github"; probe "check 82 fires when a project without Drive gains .github/" "check 82 — [theology from v0.4.0] after the update, the project has .github/"; rmdir "$MC_PROJ/.github"
  mkdir -p "$DRP_PROJ/.github"; probe "check 83 fires when another provider keeps .github/" "check 83 — [business Drive] after DATA_PROVIDER onedrive"; rmdir "$DRP_PROJ/.github"
  hold "$DRE_LOG"; grep -v '^  DELETED' "$h" > "$DRE_LOG" || true
  probe "check 83 fires when the edited workflow is not listed as deleted" "check 83 — [business Drive] after DATA_STORE external"; back "$DRE_LOG"
  DR4_AGAIN_DIRTY=" M Makefile"; probe "check 84 fires when a second update changes a file" "check 84"; DR4_AGAIN_DIRTY=""
  hold "$MA_LOG"; grep -vF "    $DT_PUSH" "$h" > "$MA_LOG" || true
  probe "check 85 fires when an unmanaged Drive workflow is not listed" "check 85 — [theology from v0.4.0]"; back "$MA_LOG"
  hold "$DR4_LOG"; grep -v 'README\.md:' "$h" > "$DR4_LOG" || true
  probe "check 85 fires when a stale seed line is not listed" "check 85 — [business Drive] the v0.5.0 migration did not list the seed"; back "$DR4_LOG"
  hold "$DR4_LOG"; printf '  %s, and the recorded answers ship no .github/.\n' "$DT_DRIVE_LIST" >> "$DR4_LOG"
  probe "check 85 fires when a managed workflow is listed" "check 85 — [business Drive] the v0.5.0 migration listed"; back "$DR4_LOG"
  hold "$DRS_LOG"; grep -vxF "    $DT_PUSH" "$h" > "$DRS_LOG" || true
  probe "check 85 fires when the deleted pre-guard workflow is not listed" "check 85 — [business Drive] the crossing update to external"; back "$DRS_LOG"
  hold "$DRS_LOG"; sed "s/v0.5.0: delete this line: these answers.*/$DT_STALE_DRIVE: '- Choosing …'/" "$h" > "$DRS_LOG"
  probe "check 85 fires when the README line gets the google-drive text under external" "check 85 — [business Drive] under external"; back "$DRS_LOG"
  # The judges themselves, on shapes the mutations above do not reach.
  r=""
  [[ "$(ut_judge servers - "$s/mc/mid/.codex/config.toml" "$s/mc/tpl-mid/.codex/config.toml" .codex/config.toml)" == ok ]] || r+=" codex-servers"
  [[ "$(ut_judge absent "$s/mc/mid/.codex/config.toml" .codex/config.toml scrapling)" == "declares scrapling" ]] || r+=" codex-absent"
  [[ -z "$r" ]] || { printf '\033[31m  ✗ ut_judge misjudges:%s\033[0m\n' "$r" >&2; exit 2; }
  MC_RAN=false; TD_RAN=false; DR_RAN=false; RT_RAN=false
}

run_checks() {
  FINDINGS=()
  $FLOW_RAN && flow_checks
  $MIG_RAN && mig_checks
  $SET_RAN && set_checks
  $TRAP_RAN && trap_checks
  $CL_RAN && clients_checks
  $OL_RAN && outside_checks
  $RP_RAN && report_checks
  $SH_RAN && shared_checks
  $SM_RAN && sm_checks
  if $MC_RAN || $TD_RAN || $DR_RAN || $RT_RAN; then dt_readers_init; fi
  $MC_RAN && mcp_flow_checks
  $TD_RAN && trap_data_checks
  $DR_RAN && drive_checks
  $RT_RAN && rt_checks
  return 0
}

flow_checks() {
  local e f
  if [[ "$COPY_STATUS" -ne 0 ]]; then
    finding "check 1 — [$DOC] the project did not render (exit $COPY_STATUS)"
    return 0
  fi
  [[ "$UPDATE_STATUS" -eq 0 ]] || finding "check 2 — [$DOC] copier update failed (exit $UPDATE_STATUS)"
  grep -qF "$MEMORY_MARK" "$PROJ/.claude/MEMORY.md" 2>/dev/null \
    || finding "check 3 — [$DOC] the author's MEMORY.md entry did not survive the update"
  grep -qF "$STYLE_MARK" "$PROJ/standards/style/style-sheet.md" 2>/dev/null \
    || finding "check 4 — [$DOC] the author's style-sheet rule did not survive the update"
  if [[ ${#DELETED[@]} -eq 0 ]]; then
    finding "check 5 — [$DOC] the render shipped no seed-once example to delete, so 'stays deleted' was never tested"
  fi
  for e in "${DELETED[@]}"; do
    [[ -e "$PROJ/$e" ]] && finding "check 5 — [$DOC] the deleted example $e came back on update"
  done
  [[ -f "$PROJ/standards/style/voice-notes.md" ]] \
    || finding "check 6 — [$DOC] the deleted voice-notes.md was not recreated — skills cite it"
  [[ -f "$PROJ/$AUTHOR_FILE" && "$(sha1sum < "$PROJ/$AUTHOR_FILE")" == "$AUTHOR_SUM" ]] \
    || finding "check 7 — [$DOC] the author's own $AUTHOR_FILE changed or vanished"
  grep -qF "$TEMPLATE_MARK" "$PROJ/$TARGET_REL" 2>/dev/null \
    || finding "check 8 — [$DOC] $TARGET_REL did not take the template's change"
  while IFS= read -r f; do
    finding "check 9 — [$DOC] conflict left behind: ${f#"$PROJ"/}"
  done < <( { find "$PROJ" -name .git -prune -o -name '*.rej' -print; \
              grep -rlI --exclude-dir=.git -e '^<<<<<<< ' "$PROJ" 2>/dev/null; } | sort -u || true)
  if [[ "$SWITCH_STATUS" -eq 0 ]]; then
    finding "check 10 — [$DOC] an update changing DOC_TYPE to $(other_doc "$DOC") was accepted — it must be refused (DESIGN.md D35)"
  elif ! grep -qF "$DOCTYPE_REFUSAL" "$SWITCH_LOG" 2>/dev/null; then
    finding "check 10 — [$DOC] the DOC_TYPE change failed (exit $SWITCH_STATUS), but not with DOC_TYPE's validator message — see $SWITCH_LOG"
  fi
  if [[ -n "$SWITCH_DIRTY" || "$SWITCH_RECORDED" != "$DOC" ]]; then
    finding "check 11 — [$DOC] the refused DOC_TYPE change touched the project ($(printf '%s\n' "$SWITCH_DIRTY" | grep -c . || true) path(s) changed; the answers record '$SWITCH_RECORDED')"
  fi
  if $CO_RAN; then
    if ! grep -qF "$AGENTS_MARK" "$PROJ/AGENTS.md" 2>/dev/null; then
      finding "check 24 — [$DOC] the author's edit to AGENTS.md did not survive the update"
    elif grep -qF "$TEMPLATE_MARK" "$PROJ/AGENTS.md"; then
      finding "check 24 — [$DOC] the update rendered the copy-only AGENTS.md — the template's change reached it"
    fi
    for e in GEMINI.md .codex/config.toml; do
      [[ -e "$PROJ/$e" ]] && finding "check 25 — [$DOC] the deleted copy-only $e came back on update"
    done
    if [[ -L "$PROJ/.agents" || ! -d "$PROJ/.agents" ]]; then
      finding "check 26 — [$DOC] .agents is no longer a real folder after the update"
    elif [[ ! -L "$PROJ/.agents/skills" || "$(readlink "$PROJ/.agents/skills")" != "$SA_AGENTS_LINK_TARGET" ]]; then
      finding "check 26 — [$DOC] .agents/skills is no longer a link to $SA_AGENTS_LINK_TARGET after the update"
    fi
    grep -qF "$TEMPLATE_MARK" "$PROJ/.claude/syntek-author-agents.md" 2>/dev/null \
      || finding "check 27 — [$DOC] the bridge .claude/syntek-author-agents.md did not take the template's change"
    grep -qF "$NEW_MODEL" "$PROJ/.claude/rules/syntek-author/05-model-allocation.md" 2>/dev/null \
      || finding "check 28 — [$DOC] the new OPENCODE_MODEL answer did not reach the model table in rules 05"
    [[ "$(sha1sum < "$PROJ/opencode.json" 2>/dev/null)" == "$OPENCODE_SUM" ]] \
      || finding "check 28 — [$DOC] the update changed the copy-only opencode.json"
  fi
  [[ "$FRESH_CLIENTS" == "$ALL_CLIENTS" ]] \
    || finding "check 30 — [$DOC] a fresh copy with the defaults recorded AGENT_CLIENTS '${FRESH_CLIENTS:-none}', not $ALL_CLIENTS"
  if ! grep -qF "$MESSAGE_MARK" "$UPDATE_LOG" 2>/dev/null; then
    finding "check 12 — [$DOC] copier update printed no option-off warning (_message_before_update)"
  else
    for e in $MESSAGE_NAMES; do
      grep -qF "$e" "$UPDATE_LOG" || finding "check 12 — [$DOC] the option-off warning does not name ${e%=false}"
    done
  fi
}

self_test() {
  local tmp
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  copier_init
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  sa_fixture_template "$tmp/fixture" >/dev/null
  run_flow "$tmp/fixture" theology "$tmp"
  st_baseline "a real update of the fixture template"

  COPY_STATUS=1;   probe "check 1 fires when the render fails" "check 1"; COPY_STATUS=0
  UPDATE_STATUS=1; probe "check 2 fires when the update fails" "check 2"; UPDATE_STATUS=0
  cp "$PROJ/.claude/MEMORY.md" "$tmp/h"; grep -vF "$MEMORY_MARK" "$tmp/h" > "$PROJ/.claude/MEMORY.md"
  probe "check 3 fires when the MEMORY entry is lost" "check 3"; cp "$tmp/h" "$PROJ/.claude/MEMORY.md"
  cp "$PROJ/standards/style/style-sheet.md" "$tmp/h"; grep -vF "$STYLE_MARK" "$tmp/h" > "$PROJ/standards/style/style-sheet.md"
  probe "check 4 fires when the style rule is lost" "check 4"; cp "$tmp/h" "$PROJ/standards/style/style-sheet.md"
  mkdir -p "$PROJ/${DELETED[0]}"; probe "check 5 fires when an example comes back" "check 5"; rm -rf "${PROJ:?}/${DELETED[0]}"
  mv "$PROJ/standards/style/voice-notes.md" "$tmp/h"; probe "check 6 fires when voice-notes.md is not recreated" "check 6"; mv "$tmp/h" "$PROJ/standards/style/voice-notes.md"
  cp "$PROJ/$AUTHOR_FILE" "$tmp/h"; printf 'tidied\n' >> "$PROJ/$AUTHOR_FILE"; probe "check 7 fires when the author's unit changes" "check 7"; cp "$tmp/h" "$PROJ/$AUTHOR_FILE"
  cp "$PROJ/$TARGET_REL" "$tmp/h"; grep -vF "$TEMPLATE_MARK" "$tmp/h" > "$PROJ/$TARGET_REL"
  probe "check 8 fires when the template change does not arrive" "check 8"; cp "$tmp/h" "$PROJ/$TARGET_REL"
  printf 'x\n' > "$PROJ/README.md.rej"; probe "check 9 fires on a rejected hunk" "check 9"; rm -f "$PROJ/README.md.rej"
  SWITCH_STATUS=0; probe "check 10 fires when a DOC_TYPE change is accepted" "check 10"; SWITCH_STATUS=1
  cp "$SWITCH_LOG" "$tmp/h"; grep -vF "$DOCTYPE_REFUSAL" "$tmp/h" > "$SWITCH_LOG" || true
  probe "check 10 fires when the update failed for another reason" "check 10 — [theology] the DOC_TYPE change failed"; cp "$tmp/h" "$SWITCH_LOG"
  SWITCH_DIRTY=" M README.md"; probe "check 11 fires when the refused update touched a file" "check 11"; SWITCH_DIRTY=""
  SWITCH_RECORDED=fiction; probe "check 11 fires when the answers record the new DOC_TYPE" "check 11"; SWITCH_RECORDED=theology
  cp "$UPDATE_LOG" "$tmp/h"; grep -vF "$MESSAGE_MARK" "$tmp/h" > "$UPDATE_LOG" || true
  probe "check 12 fires when the option-off warning is not printed" "check 12"; cp "$tmp/h" "$UPDATE_LOG"
  grep -vF "DATA_PROVIDER" "$tmp/h" > "$UPDATE_LOG" || true
  probe "check 12 fires when the warning leaves the provider out" "check 12 — [theology] the option-off warning does not name DATA_PROVIDER"; cp "$tmp/h" "$UPDATE_LOG"
  grep -vF "DATA_STORE=repo" "$tmp/h" > "$UPDATE_LOG" || true
  probe "check 12 fires when the warning leaves the store out" "check 12 — [theology] the option-off warning does not name DATA_STORE=repo"; cp "$tmp/h" "$UPDATE_LOG"
  $CO_RAN || { finding "self-test: the fixture wrote no agent files"; }
  cp "$PROJ/AGENTS.md" "$tmp/h"; printf '%s\n' "$TEMPLATE_MARK" >> "$PROJ/AGENTS.md"
  probe "check 24 fires when the update renders AGENTS.md" "check 24 — [theology] the update rendered"; cp "$tmp/h" "$PROJ/AGENTS.md"
  printf 'x\n' > "$PROJ/GEMINI.md"; probe "check 25 fires when a deleted entrypoint comes back" "check 25 — [theology] the deleted copy-only GEMINI.md"; rm -f "$PROJ/GEMINI.md"
  rm "$PROJ/.agents/skills"; mkdir "$PROJ/.agents/skills"
  probe "check 26 fires when .agents/skills is a copy, not the link" "check 26 — [theology] .agents/skills"
  rmdir "$PROJ/.agents/skills"; ln -s "$SA_AGENTS_LINK_TARGET" "$PROJ/.agents/skills"
  mv "$PROJ/.agents" "$tmp/agents-held"; ln -s .claude "$PROJ/.agents"
  probe "check 26 fires when .agents is a link" "check 26 — [theology] .agents is no longer a real folder"
  rm "$PROJ/.agents"; mv "$tmp/agents-held" "$PROJ/.agents"
  cp "$PROJ/.claude/syntek-author-agents.md" "$tmp/h"; grep -vF "$TEMPLATE_MARK" "$tmp/h" > "$PROJ/.claude/syntek-author-agents.md"
  probe "check 27 fires when the bridge misses the template's change" "check 27"; cp "$tmp/h" "$PROJ/.claude/syntek-author-agents.md"
  cp "$PROJ/opencode.json" "$tmp/h"; printf ' \n' >> "$PROJ/opencode.json"
  probe "check 28 fires when the update changes opencode.json" "check 28 — [theology] the update changed"; cp "$tmp/h" "$PROJ/opencode.json"
  FRESH_CLIENTS="codex,opencode"; probe "check 30 fires when a fresh copy records fewer clients" "check 30"; FRESH_CLIENTS="$ALL_CLIENTS"

  # Checks 13–18: a real upgrade between the fixture's two tagged releases.
  FLOW_RAN=false
  mig_fixture "$tmp/mig-tpl"
  mkdir -p "$tmp/mig"; run_migration_flow "$tmp/mig-tpl" "$tmp/mig"
  st_baseline "a real upgrade of the fixture from v0.1.0 to v0.2.0"
  local first to
  MIG_COPY_STATUS=1; probe "check 13 fires when the project does not render at v0.1.0" "check 13"; MIG_COPY_STATUS=0
  MIG_UPDATE_STATUS=1; probe "check 13 fires when the upgrade fails" "check 13 — [business] copier update"; MIG_UPDATE_STATUS=0
  cp "$MIG_LOG" "$tmp/h"; grep -vF "$MIGRATION_MARK" "$tmp/h" > "$MIG_LOG" || true
  probe "check 13 fires when the migration did not run" "check 13 — [business] the update from v0.1.0 did not run"; cp "$tmp/h" "$MIG_LOG"
  first="library/src/finance/templates/author-invoice.md"; to="${MIG_WANT[$first]}"
  mkdir -p "$(dirname "$MIG_PROJ/$first")"; mv "$MIG_PROJ/$to" "$MIG_PROJ/$first"
  probe "check 14 fires when a planted file stays in its old folder" "check 14 — [business] $first"
  mv "$MIG_PROJ/$first" "$MIG_PROJ/$to"
  mv "$MIG_PROJ/$MIG_COLLIDE_OLD" "$tmp/h"
  probe "check 15 fires when the collision's old file is lost" "check 15 — [business] what the author wrote in $MIG_COLLIDE_OLD"
  mv "$tmp/h" "$MIG_PROJ/$MIG_COLLIDE_OLD"
  cp "$MIG_LOG" "$tmp/h"; grep -vF "$MIG_COLLIDE_OLD" "$tmp/h" > "$MIG_LOG" || true
  probe "check 16 fires when the leftover is not named" "check 16"; cp "$tmp/h" "$MIG_LOG"
  MIG_RERUN_DIRTY=" M library/src/business/author-policy.md"; probe "check 17 fires when a second run changes a file" "check 17"; MIG_RERUN_DIRTY=""
  MSP_RESULT="library/src/business/author-policy.md"; probe "check 18 fires when policies ignore msp-scp" "check 18"; MSP_RESULT="library/src/msp-scp/author-policy.md"
  MIG_RAN=false

  # Checks 19–23: a book project's upgrade between the same two releases.
  mkdir -p "$tmp/set"; run_settings_flow "$tmp/mig-tpl" "$tmp/set" theology
  st_baseline "a real upgrade of a book project from v0.1.0 to v0.2.0, its audience changed in Section 1 and its reader test re-answered"
  SET_COPY_STATUS=1; probe "check 19 fires when the project does not render at v0.1.0" "check 19"; SET_COPY_STATUS=0
  SET_UPDATE_STATUS=1; probe "check 19 fires when the upgrade fails" "check 19 — [theology] copier update"; SET_UPDATE_STATUS=0
  cp "$SET_LOG" "$tmp/h"; grep -vF "$SETTINGS_MARK" "$tmp/h" > "$SET_LOG" || true
  probe "check 19 fires when the settings migration did not run" "check 19 — [theology] the update from v0.1.0 did not run"; cp "$tmp/h" "$SET_LOG"
  cp "$SET_PROJ/$SETTINGS_FILE" "$tmp/h"
  sed -i "s|^- \*\*Audience:\*\* .*|- **Audience:** invented general readers|" "$SET_PROJ/$SETTINGS_FILE"
  probe "check 20 fires when ## Brief keeps the old answer" "check 20"; cp "$tmp/h" "$SET_PROJ/$SETTINGS_FILE"
  SET_RERUN_DIRTY=" M $SETTINGS_FILE"; probe "check 21 fires when a second run changes a file" "check 21"; SET_RERUN_DIRTY=""
  SET_RERUN_STATUS=1; probe "check 21 fires when a second run fails" "check 21"; SET_RERUN_STATUS=0
  cp "$SET_PROJ/$SETTINGS_FILE" "$tmp/h"
  sed -i "s|^\(- \*\*Reader test\*\*[^:]*:\) .*|\1 $READER_HAND|" "$SET_PROJ/$SETTINGS_FILE"
  probe "check 22 fires when the older hand edit overwrites the fresh answer" "check 22"; cp "$tmp/h" "$SET_PROJ/$SETTINGS_FILE"
  cp "$SET_LOG" "$tmp/h"; grep -vF "$READER_CONFLICT" "$tmp/h" > "$SET_LOG" || true
  probe "check 23 fires when the conflict is not reported" "check 23"; cp "$tmp/h" "$SET_LOG"
  grep -vF "$READER_HAND" "$tmp/h" > "$SET_LOG" || true
  probe "check 23 fires when the conflict does not name the hand edit" "check 23"; cp "$tmp/h" "$SET_LOG"
  printf 'x\n' > "$SET_PROJ/AGENTS.md"
  probe "check 29 fires when an upgrade adds a copy-only file" "check 29 — [theology] the upgrade from v0.1.0 created the copy-only AGENTS.md"; rm -f "$SET_PROJ/AGENTS.md"
  SET_RAN=false

  # Checks 31–34: the update that first asks AGENT_CLIENTS. The fixture's v0.1.0 has no agent
  # question, so it stands in for the real v0.3.0.
  mkdir -p "$tmp/trap"; TRAP_FROM="v0.1.0"; run_trap_flow "$tmp/mig-tpl" "$tmp/trap" theology
  st_baseline "an update of a project copied before the agent questions, with --defaults"
  TRAP_COPY_STATUS=1; probe "check 31 fires when the project does not render at the old release" "check 31 — [theology] the project did not render"; TRAP_COPY_STATUS=0
  TRAP_UPDATE_STATUS=1; probe "check 31 fires when the update fails" "check 31 — [theology] copier update --defaults"; TRAP_UPDATE_STATUS=0
  TRAP_RECORDED="AGENT_CLIENTS:"; probe "check 31 fires when the update records clients" "check 31 — [theology] the update from v0.1.0 recorded"; TRAP_RECORDED='AGENT_CLIENTS: []'
  cp "$TRAP_PROJ/$RULES05" "$tmp/h"; printf '\n## 4. Other coding agents\n' >> "$TRAP_PROJ/$RULES05"
  probe "check 32 fires when rules 05 gains a Section 4" "check 32"; cp "$tmp/h" "$TRAP_PROJ/$RULES05"
  mv "$TRAP_PROJ/$BRIDGE" "$tmp/h"; probe "check 33 fires when the bridge is missing" "check 33"; mv "$tmp/h" "$TRAP_PROJ/$BRIDGE"
  mkdir "$TRAP_PROJ/.codex"; probe "check 34 fires when the update creates a client folder" "check 34 — [theology] the update from v0.1.0 created .codex"; rmdir "$TRAP_PROJ/.codex"
  TRAP_RAN=false; TRAP_FROM="v0.3.0"

  # Checks 35–39: an emptied client list, one client removed, and a copy over a recorded project, on the fixture.
  mkdir -p "$tmp/cl"; run_clients_flow "$tmp/fixture" "$tmp/cl" theology
  st_baseline "an update emptying AGENT_CLIENTS, and one removing opencode"
  CL_UPDATE_STATUS=1; probe "check 35 fires when the update fails" "check 35 — [theology] copier update"; CL_UPDATE_STATUS=0
  local held_porcelain="$CL_PORCELAIN"
  CL_PORCELAIN="$held_porcelain"$'\n'" D .codex/config.toml"
  probe "check 35 fires when the update deletes a client's file" "check 35 — [theology] emptying AGENT_CLIENTS deleted .codex/config.toml"
  CL_PORCELAIN="$held_porcelain"$'\n'" M README.md"
  probe "check 37 fires when another file changes" "check 37 — [theology] emptying AGENT_CLIENTS changed README.md"
  CL_PORCELAIN="$held_porcelain"
  cp "$CL_PROJ/AGENTS.md" "$tmp/h"; printf 'x\n' >> "$CL_PROJ/AGENTS.md"
  probe "check 36 fires when an entrypoint changed" "check 36 — [theology] emptying AGENT_CLIENTS changed AGENTS.md"; cp "$tmp/h" "$CL_PROJ/AGENTS.md"
  mv "$CL_PROJ/$BRIDGE" "$tmp/h"; probe "check 36 fires when the bridge is gone" "check 36 — [theology] emptying AGENT_CLIENTS removed the bridge"; mv "$tmp/h" "$CL_PROJ/$BRIDGE"
  local held_diff="$CL_ONE_DIFF"
  CL_ONE_DIFF="$held_diff"$'\n''-| Codex | x |'
  probe "check 38 fires when another row goes too" "check 38 — [theology] removing opencode did not drop exactly its row"
  CL_ONE_DIFF="$held_diff"
  held_porcelain="$CL_ONE_PORCELAIN"; CL_ONE_PORCELAIN="$held_porcelain"$'\n'" M GEMINI.md"
  probe "check 38 fires when removing one client changes another file" "check 38 — [theology] removing opencode changed GEMINI.md"
  CL_ONE_PORCELAIN="$held_porcelain"
  CL_RE_STATUS=1; probe "check 39 fires when the copy over a recorded project fails" "check 39 — [theology] a copy over a project that recorded [codex] failed"; CL_RE_STATUS=0
  CL_RE_RECORDED=""; probe "check 39 fires when a copy resets the recorded clients" "check 39 — [theology] a copy over a project that recorded [codex] recorded []"; CL_RE_RECORDED="codex"
  CL_RE_BAD_STATUS=1; probe "check 39 fires when a stale recorded value breaks the copy" "check 39 — [theology] a copy over a record holding a value no longer a choice failed"; CL_RE_BAD_STATUS=0
  CL_RE_BAD_RECORDED="codex,cursor"; probe "check 39 fires when a stale value survives" "check 39 — [theology] a copy over a record of [codex, cursor] recorded [codex,cursor]"; CL_RE_BAD_RECORDED="codex"
  CL_RAN=false

  # Checks 40–43: an .agents link outside the project, on the fixture with the real pair.
  outside_fixture "$tmp/ol-fixture"
  mkdir -p "$tmp/ol"; run_outside_flow "$tmp/ol-fixture" "$tmp/ol" theology
  st_baseline "updates of a project whose .agents links outside it, a stranded hold and the control"
  OL_COPY_STATUS=1; probe "check 40 fires when the project does not render" "check 40 — [theology] the project did not render"; OL_COPY_STATUS=0
  OL_STATUS=1; probe "check 40 fires when the update fails" "check 40 — [theology] copier update with .agents linked outside"; OL_STATUS=0
  OL_AFTER_TARGET="not a link"; probe "check 40 fires when the link is not restored" "check 40 — [theology] the outside .agents link was not restored"; OL_AFTER_TARGET="$OL_TARGET"
  OL_HELD_LEFT=true; probe "check 40 fires when the held link is left" "check 40 — [theology] the update left"; OL_HELD_LEFT=false
  OL_DIRTY="T .agents"; probe "check 40 fires when Git sees the link changed" "check 40 — [theology] Git sees"; OL_DIRTY=""
  cp "$OL_LOG" "$tmp/h"; grep -vF "restored .agents" "$tmp/h" > "$OL_LOG" || true
  probe "check 40 fires when the restore is not printed" "check 40 — [theology] the update did not print"; cp "$tmp/h" "$OL_LOG"
  local ol_sums="$OL_SUMS_AFTER"; OL_SUMS_AFTER="$ol_sums"$'\n'"./mcp_config.json x"
  probe "check 40 fires on a write into the outside folder" "check 40 — [theology] an update wrote into the folder outside"; OL_SUMS_AFTER="$ol_sums"
  OL_AGAIN_DIRTY=" M $RULES01"; probe "check 41 fires when a second update changes a file" "check 41"; OL_AGAIN_DIRTY=""
  OL_AGAIN_STATUS=1; probe "check 41 fires when a second update fails" "check 41"; OL_AGAIN_STATUS=0
  local ol_strand="$OL_STRAND_STATUS"
  OL_STRAND_STATUS=0; probe "check 42 fires when the stopping update is accepted" "check 42 — [theology] the update meant to stop"; OL_STRAND_STATUS="$ol_strand"
  OL_STRAND_HELD=false; probe "check 42 fires when the stopped update left no hold" "check 42 — [theology] the update that stopped did not leave"; OL_STRAND_HELD=true
  cp "$OL_STRAND_LOG" "$tmp/h"; grep -vF "$OL_FIX" "$tmp/h" > "$OL_STRAND_LOG" || true
  probe "check 42 fires when the hand fix is not printed" "check 42 — [theology] the update that stopped with the link held"; cp "$tmp/h" "$OL_STRAND_LOG"
  OL_STRAND_TARGET="not a link"; probe "check 42 fires when the hand fix does not restore the link" "check 42 — [theology] the printed hand fix"; OL_STRAND_TARGET="$OL_TARGET"
  OL_RESTORE_DIRTY="?? $OL_HELD"; probe "check 42 fires when the script's restore leaves the hold" "check 42 — [theology] the script's restore"; OL_RESTORE_DIRTY=""
  OL_CTL_STATUS=1; probe "check 43 fires when the control does not update" "check 43"; OL_CTL_STATUS=0
  OL_CTL_AFTER="not a link"; probe "check 43 fires when the control's skills link changes" "check 43 — [theology] the update changed"; OL_CTL_AFTER="$OL_CTL_TARGET"
  OL_RAN=false

  # Checks 44–50, 86–88, 90 and 91: the update report on its own fixture, the same flow as the real run.
  mkdir -p "$tmp/rp"; run_report_flow "$tmp/rp"
  st_baseline "the update report on its fixture: every section, the refresh, the commands, the rerun, the limits, a discarded update, an ignored settings.json, a discarded update followed by a later one"
  RP_STATUS=1; probe "check 44 fires when the update fails" "check 44 — [report fixture] the update to v0.3.0 failed"; RP_STATUS=0
  cp "$RP_LOG" "$tmp/h"; grep -vx '    \.gitignore' "$tmp/h" > "$RP_LOG"
  probe "check 44 fires when a file is not in its section" "check 44 — [report fixture] .gitignore is listed under 'nothing'"; cp "$tmp/h" "$RP_LOG"
  cp "$RP_REJ_LOG" "$tmp/h"; grep -v '^  REJECTED' "$tmp/h" > "$RP_REJ_LOG"
  probe "check 45 fires when the rejected hunk is not reported" "check 45"; cp "$tmp/h" "$RP_REJ_LOG"
  cp "$RP_PROJ/.claude/skills/wait-what/SKILL.md" "$tmp/h"; printf 'stale\n' >> "$RP_PROJ/.claude/skills/wait-what/SKILL.md"
  probe "check 46 fires when an unedited shared file is not refreshed" "check 46 — [report fixture] the shared .claude/skills/wait-what/SKILL.md"
  cp "$tmp/h" "$RP_PROJ/.claude/skills/wait-what/SKILL.md"
  local rp_beyond="$RP_BEYOND"; RP_BEYOND="$RP_BEYOND README.md"
  probe "check 47 fires when the report changes another file" "check 47"; RP_BEYOND="$rp_beyond"
  cp "$RP_LOG" "$tmp/h"; grep -vE '^▸ [^:]+: added [0-9]+ MCP servers? to \.mcp\.json' "$tmp/h" > "$RP_LOG" || true
  probe "check 47 fires when the MCP lane changed a file it did not report" "check 47 — [report fixture] beyond the update's own changes, the report changed '.claude/settings.json .claude/skills/to-questionnaire/SKILL.md .claude/skills/wait-what/SKILL.md .mcp.json'"
  cp "$tmp/h" "$RP_LOG"
  RP_CMD_FAILS="git show x (exit 128)"; probe "check 48 fires when a printed command fails" "check 48"; RP_CMD_FAILS=""
  RP_RERUN_CHANGED="> refs/x"; probe "check 49 fires when a rerun changes something" "check 49 — [report fixture] a second run"; RP_RERUN_CHANGED=""
  RP_AGAIN_DIRTY=" M README.md"; probe "check 49 fires when a second update changes a file" "check 49 — [report fixture] a second update"; RP_AGAIN_DIRTY=""
  local rp_one="${RP_ONE_LINE[0]}"; RP_ONE_LINE[0]=$'off\t0\t2\tx'
  probe "check 50 fires when the opt-out prints more than one line" "check 50 — [report fixture] off"; RP_ONE_LINE[0]="$rp_one"
  RP_REDO_ST[reset]=1; probe "check 86 fires when the discarded update's second run fails" "check 86 — [report fixture] the copy"; RP_REDO_ST[reset]=0
  RP_REDO_DIFF[reset]="< ?? .claude/skills/to-questionnaire/SKILL.md 0123"
  probe "check 86 fires when the second run does not deliver what the first did" "check 86 — [report fixture] after the update was discarded (reset), the second run did not"; RP_REDO_DIFF[reset]=""
  local rp_chain="${RP_REDO_CHAIN[reset]}"; RP_REDO_CHAIN[reset]="its parent is 'abc', not 'def'"
  probe "check 86 fires when the second run is chained on the discarded record" "check 86 — [report fixture] after the update was discarded (reset), the second run's record"; RP_REDO_CHAIN[reset]="$rp_chain"
  RP_REDO_DIFF[stash]="> M .claude/settings.json 0123"
  probe "check 87 fires when the update discarded by git stash -u is not delivered again" "check 87 — [report fixture] after the update was discarded (stash)"; RP_REDO_DIFF[stash]=""
  RP_REDO_RERUN[stash]="> refs/x"; probe "check 88 fires when a hand rerun over the second run changes something" "check 88"; RP_REDO_RERUN[stash]=""
  local rp_ign="$RP_IGN_STAT_POST"; RP_IGN_STAT_POST="x 1 2"
  probe "check 90 fires when the ignored settings.json is written" "check 90 — [report fixture] the git-ignored"; RP_IGN_STAT_POST="$rp_ign"
  RP_IGN_N2=0; probe "check 90 fires when the next update does not name the entries again" "check 90 — [report fixture] the git-ignored"; RP_IGN_N2=1
  RP_IGN_REC=1; probe "check 90 fires when an entry is recorded as offered" "check 90 — [report fixture] the git-ignored"; RP_IGN_REC=0
  RP_LATER_ST=1; probe "check 91 fires when the flow of the later update fails" "check 91 — [report fixture] the copies at v0.1.0"; RP_LATER_ST=0
  RP_LATER_MISSING="the discarded update to v0.2.0 did not offer the deny $SA_MCP_DENY"
  probe "check 91 fires when the discarded update offered nothing to compare" "check 91 — [report fixture] the comparison proves nothing"; RP_LATER_MISSING=""
  RP_LATER_DIFF="< M .claude/settings.json 0123"
  probe "check 91 fires when the later update does not give what a direct one gives" "check 91 — [report fixture] after an update to v0.2.0 was discarded, the update to v0.3.0 did not give"; RP_LATER_DIFF=""
  RP_LATER_REC="< settings: deny $SA_MCP_DENY"
  probe "check 91 fires when the later record's offers are not a direct update's" "check 91 — [report fixture] after an update to v0.2.0 was discarded, the record of the update to v0.3.0 does not list"; RP_LATER_REC=""
  local rp_later="$RP_LATER_CHAIN"; RP_LATER_CHAIN="its parent is 'abc', not 'def'"
  probe "check 91 fires when the later record sits on the discarded one" "check 91 — [report fixture] after an update to v0.2.0 was discarded, the record of the update to v0.3.0 is not on"; RP_LATER_CHAIN="$rp_later"
  RP_RAN=false

  # Checks 51–54: an update across the shared set, on the same fixture (v0.1.0 to v0.3.0).
  run_shared_flow "$RP_TPL" "$tmp" theology v0.1.0 v0.3.0 fixture
  st_baseline "an update of the fixture across its shared set"
  SH_UPDATE=1; probe "check 51 fires when the update fails" "check 51 — [fixture [theology]] the update failed"; SH_UPDATE=0
  cp "$SH_PROJ/$RP_ARRIVES" "$tmp/h"; rm "$SH_PROJ/$RP_ARRIVES"
  probe "check 51 fires when a new shared file does not arrive" "check 51 — [fixture [theology]] the shared $RP_ARRIVES"; cp "$tmp/h" "$SH_PROJ/$RP_ARRIVES"
  cp "$SH_PROJ/$SHARED_EDIT" "$tmp/h"; printf 'merged\n' >> "$SH_PROJ/$SHARED_EDIT"
  probe "check 52 fires when the owner's edit is overwritten" "check 52 — [fixture [theology]] the owner's edit"; cp "$tmp/h" "$SH_PROJ/$SHARED_EDIT"
  cp "$SH_LOG" "$tmp/h"; grep -vxF "    $SHARED_EDIT" "$tmp/h" > "$SH_LOG"
  probe "check 52 fires when the edited file is not reported" "check 52 — [fixture [theology]] the edited"; cp "$tmp/h" "$SH_LOG"
  cp "$SH_PROJ/.claude/settings.json" "$tmp/h"; printf '{"model": "opus"}\n' > "$SH_PROJ/.claude/settings.json"
  probe "check 53 fires when the threshold hook is not wired" "check 53"; cp "$tmp/h" "$SH_PROJ/.claude/settings.json"
  SH_DIRTY=" M README.md"; probe "check 54 fires when a second update changes a file" "check 54"; SH_DIRTY=""
  SH_RAN=false

  # Checks 55–59: settings.json copied over the owner's own, on the same fixture (v0.3.0 to v0.4.0).
  run_sm_flow "$RP_TPL" "$tmp"
  st_baseline "settings.json across a copy over the owner's own, a removal and a copy without tasks"
  SM_UPD[0]=1; probe "check 55 fires when an update fails" "check 55 — [settings fixture] a copy over"; SM_UPD[0]=0
  SM_A_COPIED="the threshold hook wired 0 time(s), not 1"
  probe "check 55 fires when a copy over the owner's settings.json does not wire the hook" "check 55 — [settings fixture] after a copy"; SM_A_COPIED=ok
  SM_T_COPIED='autoCompactEnabled written 1 time(s), false, not true once'
  probe "check 55 fires when a copy overwrites the owner's autoCompactEnabled" "check 55 — [settings fixture] after a copy over the owner's autoCompactEnabled true"; SM_T_COPIED=ok
  SM_T_LINES="1 1"; probe "check 55 fires when the kept value is reported again by the update" "check 55 — [settings fixture] the owner's autoCompactEnabled true was not reported exactly once"; SM_T_LINES="1 0"
  # sm_judge itself: the key absent, written twice, or with another value.
  local sj=""
  sm_existing > "$tmp/sj.json"
  [[ "$(sm_judge "$tmp/sj.json" 0)" == *"autoCompactEnabled written 0 time(s)"* ]] || sj+=" absent"
  sed 's/^    "model": "opus"$/    "autoCompactEnabled": false,\n    "autoCompactEnabled": false,\n    "model": "opus"/' "$tmp/sj.json" > "$tmp/sj2.json"
  [[ "$(sm_judge "$tmp/sj2.json" 0)" == *"autoCompactEnabled written 2 time(s)"* ]] || sj+=" twice"
  sed 's/^    "model": "opus"$/    "model": "opus",\n    "autoCompactEnabled": false/' "$tmp/sj.json" > "$tmp/sj3.json"
  [[ "$(sm_judge "$tmp/sj3.json" 0)" == ok && "$(sm_judge "$tmp/sj3.json" 0 true)" == *"not true once"* ]] || sj+=" value"
  [[ -z "$sj" ]] || { printf '\033[31m  ✗ sm_judge misjudges autoCompactEnabled:%s\033[0m\n' "$sj" >&2; exit 2; }
  SM_A_UPDATED="the threshold hook wired 2 time(s), not 1"
  probe "check 55 fires when the update wires the hook twice" "check 55 — [settings fixture] after the update"; SM_A_UPDATED=ok
  SM_B_UPDATED="the threshold hook wired 1 time(s), not 0"
  probe "check 56 fires when a removed hook is re-added" "check 56"; SM_B_UPDATED=ok
  SM_B2_UPDATED="the threshold hook wired 1 time(s), not 0"
  probe "check 56 fires when the record is not read" "check 56 — [settings fixture] after the owner removed the hook before any commit"; SM_B2_UPDATED=ok
  SM_C_UPDATED="the threshold hook wired 0 time(s), not 1"
  probe "check 57 fires when a project without a record never gets the hook" "check 57 — [settings fixture] a copy without tasks"; SM_C_UPDATED=ok
  SM_C_RECORD="0123abc"; probe "check 57 fires when the no-record case had a record" "check 57 — [settings fixture] a copy with --skip-tasks"; SM_C_RECORD=""
  SM_A_SAME=false; probe "check 58 fires when a second update rewrites settings.json" "check 58"; SM_A_SAME=true
  SM_ABS="/tmp/x/tpl"; probe "check 59 fires when the record names a path" "check 59"; SM_ABS=""
  # sm_abs itself: a record whose tree holds a rendered answers file naming Copier's clone.
  mkdir -p "$tmp/abs-probe/r"
  printf '_src_path: /tmp/x/copier._vcs.clone.abc\n' > "$tmp/abs-probe/r/.copier-answers.x.yml"
  { sa_git "$tmp/abs-probe" init -q
    sa_git "$tmp/abs-probe" add -A
    sa_git "$tmp/abs-probe" commit -q -m 'a record'
    sa_git "$tmp/abs-probe" update-ref refs/syntek-author/template HEAD; } >/dev/null 2>&1
  SM_ABS="$(sm_abs "$tmp/abs-probe" /nowhere/tpl /nowhere/proj)"
  probe "check 59 finds a recorded answers file naming Copier's temporary clone" "check 59"; SM_ABS=""
  # sm_abs on a record whose MCP lines name a path outside the project (D54).
  mkdir -p "$tmp/abs-mcp"; printf '{}\n' > "$tmp/abs-mcp/.mcp.json"
  { sa_git "$tmp/abs-mcp" init -q
    sa_git "$tmp/abs-mcp" add -A
    sa_git "$tmp/abs-mcp" commit -q -m $'a record\n\nmcp: .mcp.json scrapling 0\nwritten-blob: ../outside/.mcp.json 0123abc'
    sa_git "$tmp/abs-mcp" update-ref refs/syntek-author/template HEAD; } >/dev/null 2>&1
  SM_ABS="$(sm_abs "$tmp/abs-mcp" /nowhere/tpl /nowhere/proj)"
  probe "check 59 finds an MCP record line naming a path outside the project" "check 59 — [settings fixture] the render record names a path of this machine: record line: written-blob: ../outside"; SM_ABS=""
  SM_RAN=false

  # Checks 60–85: the trees, logs and statuses of real updates across D50, D53 and D54.
  dt_self_test "$tmp"
  st_finish "an update that keeps its promises from one that breaks them"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

[[ -f "$SA_ROOT/copier.yml" ]] || die "no copier.yml at $SA_ROOT"
copier_init
bold "▸ $SCRIPT_NAME"
STATUS=0

# The tagged template every variant's upgrade runs against: cloned once per run, removed at exit.
TAGGED=""; TAGGED_DIR=""
tagged_once() {
  [[ -n "$TAGGED" ]] && return 0
  TAGGED_DIR="$(sa_mktemp)"; TAGGED="$TAGGED_DIR/tagged"
  tagged_template "$SA_ROOT" "$TAGGED" >>"$TAGGED_DIR/tagged.log"
}
trap 'if [[ -n "$TAGGED_DIR" ]]; then rm -rf "$TAGGED_DIR"; fi' EXIT

FIRST_DOC="${DOC_TYPES%%,*}"
for doc in ${DOC_TYPES//,/ }; do
  case "$doc" in theology|fiction|business) ;; *) die "unknown DOC_TYPE: $doc" ;; esac
  work="$(sa_mktemp)"
  MIG_RAN=false; SET_RAN=false; TRAP_RAN=false; CL_RAN=false; OL_RAN=false; RP_RAN=false; SH_RAN=false; SM_RAN=false
  MC_RAN=false; TD_RAN=false; DR_RAN=false; RT_RAN=false
  run_flow "$SA_ROOT" "$doc" "$work"
  tagged_once
  git -C "$TAGGED" rev-parse -q --verify "refs/tags/$TRAP_FROM" >/dev/null 2>&1 \
    || die "$SA_ROOT has no $TRAP_FROM tag — Trap 1 cannot be proven (git fetch --tags; CI needs fetch-depth: 0)"
  git -C "$TAGGED" rev-parse -q --verify "refs/tags/$DT_FROM" >/dev/null 2>&1 \
    || die "$SA_ROOT has no $DT_FROM tag — the updates across D50, D53 and D54 cannot be proven (CI needs fetch-depth: 0)"
  run_trap_flow "$TAGGED" "$work" "$doc"
  TD_RAN=true
  cat "$work/trap-flow.log" >> "$work/flow.log" 2>/dev/null || true
  run_shared_flow "$TAGGED" "$work" "$doc" "$TRAP_FROM" HEAD "$TRAP_FROM"
  cat "$work/sh-$TRAP_FROM.log" >> "$work/flow.log" 2>/dev/null || true
  if [[ "$doc" == "$FIRST_DOC" ]]; then
    run_clients_flow "$SA_ROOT" "$work" "$doc"
    cat "$work/cl-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_outside_flow "$SA_ROOT" "$work" "$doc"
    cat "$work/ol-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_report_flow "$work"
    cat "$work/rp-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_sm_flow "$RP_TPL" "$work"
    cat "$work/sm-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_mcp_flow "$TAGGED" "$work" "$doc"
    cat "$work/mc-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_roundtrip_flow "$TAGGED" "$work" "$doc"
    cat "$work/rt-flow.log" >> "$work/flow.log" 2>/dev/null || true
  fi
  if [[ "$doc" == business ]]; then
    run_drive_flow "$TAGGED" "$work"
    cat "$work/dr-flow.log" >> "$work/flow.log" 2>/dev/null || true
    run_migration_flow "$TAGGED" "$work"
    cat "$work/mig-flow.log" >> "$work/flow.log" 2>/dev/null || true
  else
    run_settings_flow "$TAGGED" "$work" "$doc"
    cat "$work/set-flow.log" >> "$work/flow.log" 2>/dev/null || true
  fi
  run_checks
  if [[ "$doc" == "$FIRST_DOC" ]]; then
    # The same promises from main before D51 (once per run): its shared skills were
    # template-owned and tokenised, and nothing recorded a render.
    git -C "$TAGGED" rev-parse -q --verify "$PRE_D51_REF^{commit}" >/dev/null 2>&1 \
      || die "$SA_ROOT has no commit $PRE_D51_REF — the update from before D51 cannot be proven (CI needs fetch-depth: 0)"
    run_shared_flow "$TAGGED" "$work" "$doc" "$PRE_D51_REF" HEAD pre-D51
    cat "$work/sh-pre-D51.log" >> "$work/flow.log" 2>/dev/null || true
    shared_checks
  fi
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $doc — edits kept, example still gone, voice-notes.md recreated, author unit untouched, $TARGET_REL updated; DOC_TYPE change refused untouched; option-off warning printed"
    $CO_RAN && log "  ✓ $doc — copy-only agent files: AGENTS.md edit kept and never re-rendered, deleted entrypoints stay deleted, .agents a real folder with its skills link, the bridge updated, a new model answer in rules 05 only"
    $MIG_RAN && log "  ✓ $doc — upgrade from $MIGRATION_FROM: every author file moved to its family byte for byte, the collision kept and named, a second run a no-op, msp-scp honoured"
    $TRAP_RAN && log "  ✓ $doc — update from $TRAP_FROM with --defaults: AGENT_CLIENTS recorded empty, no Section 4 in rules 05, the bridge present, no client file created"
    $OL_RAN && log "  ✓ $doc — .agents linked outside the project: held and restored by the update with its target untouched, a second update a no-op, a stranded hold fixed by the printed mv and by restore, a real .agents/ with an outside skills link updated"
    $RP_RAN && log "  ✓ $doc — the update report: every section on its fixture (inline and rej), the refresh and the owner's edit, settings add-only, every printed command run offline, a rerun and a second update quiet, the opt-out and the limits one line each; an update discarded by reset and clean, or by stash, delivered again by the second run, whose hand rerun changes nothing; an update discarded and followed by one to a later release giving a direct update's result, offers and written blobs; an ignored settings.json never read, its entries named once per update"
    $SH_RAN && log "  ✓ $doc — updates from $TRAP_FROM and from $PRE_D51_REF: unedited shared files refreshed or added, the edited one kept and reported, the threshold hook wired once, add-only, a second update quiet"
    $SM_RAN && log "  ✓ $doc — settings.json: a copy over the owner's own wires the hook and adds autoCompactEnabled false once in the owner's formatting, keeps an owner's true and says so once, an update keeps them once, a removed hook stays removed, a project without a record gets it once, a second update a no-op, the record names no path of this machine"
    $CL_RAN && log "  ✓ $doc — AGENT_CLIENTS emptied: nothing deleted, the bridge and entrypoints kept, only rules 01, rules 05 and the answers changed; opencode removed: only its rules 05 row went"
    $SET_RAN && log "  ✓ $doc — upgrade from $MIGRATION_FROM: the audience set in .claude/CLAUDE.md Section 1 reached 00-project.md ## Brief, the reader test answered during the update kept with the older hand edit reported as a conflict, a second run a no-op"
    $TD_RAN && log "  ✓ $doc — update from $TRAP_FROM across v0.5.0: the nine rules and both MCP servers once, DATA_STORE repo with no layout answer, the resolver and no ignore file, no guard wired, DATA_PROVIDER none and no .github/, no false report line"
    $MC_RAN && log "  ✓ $doc — MCP servers from $DT_FROM: added once to each existing file in the owner's order, a differing entry kept and said once, no client file created or restored, Codex's prompts, --write then --check clean, held back from a catch-all opencode.json until --write, removed servers never re-added, an ignored .mcp.json untouched, allowed Scrapling asks left out, a quiet second update; the v0.5.0 migration before the report and the same twice; a sibling at external followed"
    $RT_RAN && log "  ✓ $doc — the round trip: external with its own layout, repo, external re-derived, the old folder named from filed_under and restored by --data; a case-only area change refused, the tree clean"
    $DR_RAN && log "  ✓ $doc — Google Drive from $DT_FROM and $TRAP_FROM: google-drive and repo recorded, the owner's edit kept with the guard step merged, a second update a no-op; another provider, external and the settings trap delete .github/ and list the edit; external delivers the ignore files, untracks nothing and lists the owner's ignore file as a conflict; a sibling in both orders keeps repo; the migration lists the unmanaged workflow and the stale seed line"
    rm -rf "$work"
  else
    bold "✗ $doc — ${#FINDINGS[@]} finding(s) (work kept in $work; Copier's output in $work/flow.log):"
    print_findings
    # On a CI runner the work directory is gone once the job ends, so show Copier's output here.
    if [[ "${GITHUB_ACTIONS:-}" == true ]]; then
      echo "::group::Copier output for $doc (start, error lines and end of flow.log)"
      head -n 60 "$work/flow.log" 2>/dev/null || true
      echo "… error lines …"
      grep -n -i -E 'traceback|error|exception|fatal|refus|invalid|not found|denied' "$work/flow.log" 2>/dev/null | head -n 40 || true
      echo "… end …"
      tail -n 40 "$work/flow.log" 2>/dev/null || true
      echo "::endgroup::"
    fi
    STATUS=1
  fi
done
log ""
[[ "$STATUS" -eq 0 ]] && { bold "✓ copier update keeps every ownership promise."; exit 0; }
log "  Each promise rests on one copier.yml line: _skip_if_exists for seeds, the copy-only"
log "  _exclude gate for examples (DESIGN.md Sections 3.1–3.2), DOC_TYPE's validator with"
log "  _external_data, _message_before_update (D35), and the _migrations entries (D44)."
exit 1
