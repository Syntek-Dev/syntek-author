#!/usr/bin/env bash
#
# tooling-smoke.sh — Run the generated Makefile's targets in every render, and require them to work.
#
#                    The skills route to `make`: `build` runs `make pdf`, `promote-section`
#                    reads `make flags`, `learn-voice` and the disclosure table read `make
#                    provenance`, `make compare` prints each section's record, the conlang
#                    skills run `make lexicon`. The Makefile is a spine
#                    file — conditional on the variant — and its tooling is Python run from
#                    tooling/. Nothing in the template's own repository ever executes either: a
#                    typo in a recipe, a tooling script that no longer parses the example
#                    language, a target that forgets to create build/.gitignore — each ships,
#                    silently, and fails on the author's first command. So every render is
#                    copied to a scratch directory and its targets are run for real.
#
#                    Eighty-seven checks, per render:
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
#                     18. Every tooling/*.py that offers a `--self-test` passes it: texcheck.py,
#                         provenance.py and compare.py everywhere, lexicon.py and script.py with
#                         the conlang kit. A self-test that needs Pandoc skips that part by itself.
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
#                     23. Business under DATA_STORE repo: `make pdf FILE=… ISSUE=1` over a final
#                         document whose PDF already sits beside it fails, leaves that PDF byte for
#                         byte, and says FORCE=1 (D43) — an issued record is never rebuilt over
#                         silently (where XeLaTeX exists). Under external the issued copy is filed
#                         under the data root instead (checks 40–43), so the check is skipped there
#                         by name: a fresh business copy is external, the business repo render repo.
#                     24. Business under repo: the same command with FORCE=1 succeeds and replaces
#                         the PDF, so the refusal in check 23 was the existing file, not the build.
#                     25. Business: `make flags SCOPE=<file>` counts a \fillme field in a .tex as
#                         an open item (the default FLAG_EXTRA_RE of tooling/project.mk), so a
#                         LaTeX deliverable never gets a false all-clear (DESIGN.md D13).
#                     26. Business: `make pdf FILE=… ISSUE=1`, alone and with FORCE=1, over a final
#                         document holding that field fails, says to clear the open items first
#                         and issues nothing: final needs zero flags, and FORCE=1 never overrides
#                         that. The refusal comes before the build, so no XeLaTeX is needed.
#                         Checks 25–28 run in both stores: each refusal comes before either
#                         store's own step (D50 Section 5.4).
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
#                     33. `make compare FORMAT=tex UNIT=smoke-compare` over a planted ledger entry
#                         carrying `format: 2` and a multi-round chain (an ai, an author and an
#                         author-note revision, then the author's final) succeeds and writes
#                         build/compare/smoke-compare/smoke-compare.tex, whose body carries each
#                         actor's macro: \cmpai…, \cmpnote… and \cmpauthor… (DESIGN.md D45; where
#                         Pandoc exists). Every variant ships the comparison, and an adoption
#                         render has no example entry, so the entry is planted in every render.
#                     34. A ledger entry git ignores, planted beside it for the same unit, never
#                         reaches build/compare/ (D42), while the tracked entry's words do —
#                         otherwise the proof is blind. A ledger is where an author's history
#                         lives; an ignored entry is one they chose to keep out of every output.
#                     35. `make compare SECTION=x` without UNIT fails, says 'SECTION= needs its
#                         unit' and writes nothing: a section slug is unique only inside its unit.
#                     36. `make compare` with no ledger entries (each one moved aside in the copy)
#                         prints 'No sections to compare yet.' and exits 0: a new project, or one
#                         adopted, has nothing to compare, and that is not an error.
#                     37. `make compare UNIT=smoke-compare` writes build/compare/smoke-compare.pdf
#                         (where Pandoc and XeLaTeX exist, and not with --skip-pdf).
#                     38. Business: `make lint` lists a list step of more than 20 words in a file
#                         under library/src/business/ under 'List steps over 20 words' (D46),
#                         and not a short step in the same file, nor the same long step in a file
#                         under library/src/legal/ where that folder ships: the STE hint leaves
#                         legal documents aside.
#
#                    The data root (DESIGN.md D50, D53). A project under DATA_STORE external
#                    files its binaries outside the repository, and the render's own resolver,
#                    .claude/syntek-author-dataroot.py, is the one route there; every skill and
#                    the Makefile act on its exit codes, so a wrong code loses a record silently.
#                    Each case that needs a root makes one beside the render's copy, outside its
#                    repository, holding its own .syntek-data-root marker, and passes it to that
#                    command alone; everything else runs with SYNTEK_DATA_ROOT unset, as
#                    _common.sh leaves it. Checks 39–49, 51–55 and 60–69 need python3 at the
#                    resolver's floor, _common.sh's SA_PYTHON_MIN, and are skipped by name below
#                    it (which the pin in _common.sh already refuses).
#                     39. With the root unset, empty, relative, a missing folder, a folder without
#                         its marker, a marked folder inside the repository, a marked folder
#                         holding it, and a marker above it with the variable unset: `make flags`
#                         and `make lint` pass in each, and so does a proof under the unmarked one
#                         (business `make pdf FILE=…`, whose TeX lookup asks the resolver, where
#                         XeLaTeX exists; books `make docx`, skipped as check 7 is in an adoption
#                         render). Under external the resolver's `path`, `add`, `verify`, `pull`
#                         and `plan` each exit 2, and `status`, which needs no root, does not.
#                         Under repo, which reads no root, `path`, `add --role generated` and `add`
#                         with a map role marked "repo": "skip" exit 2 with nothing on stdout in the
#                         last three states (the root and the repository contain one another, or a
#                         marker sits above it; checks 55 and 67 prove the two `add` calls answer
#                         with a valid root outside the repository, and the resolver's self-test
#                         proves all three with an empty, an unmarked and a valid root, and `path`
#                         and both `add` calls with the variable unset), and `status` exits 0 or 1
#                         in each state, warning in those three that it did not check the copies.
#                         Nothing is written in the project or in those folders.
#                     40. Business under external: `make pdf FILE=… ISSUE=1` with a marked root files
#                         the PDF at <root>/<area>/<docs kind>/<slug>/<FILE's folder>/<stem>.pdf, as
#                         the one current `issued` row of external.toml, its source FILE, and writes
#                         nothing beside the source (where XeLaTeX exists).
#                     41. Business under external: a second `ISSUE=1` fails before the build (no PDF
#                         in build/), names FORCE=1 and leaves the filed copy byte for byte.
#                     42. Business under external: `ISSUE=1 FORCE=1` files the new copy and keeps the
#                         old one under the root as <stem>.superseded-DD-MM-YYYY.pdf; the old row
#                         keeps its path with its state superseded, and the new current row of that
#                         path has a `replaces` naming the kept copy (where XeLaTeX exists).
#                     43. Business under external with no root: `ISSUE=1` fails, saying it files the
#                         issued copy under the data root, and builds nothing, writes nothing beside
#                         the source and starts no external.toml.
#                     44. Under external, two copies filed with `add`: `verify` exits 0; a flipped
#                         byte, a filed copy moved away and a file no row lists, in the project's
#                         folder under the root, each make it exit 1 naming the file as changed,
#                         missing or unlisted.
#                     45. Under external: `status` exits 1 and names, as not filed, a PDF that Git
#                         ignores in a filing folder and no row lists; once filed, it is not named.
#                     46. `check-names` exits 1 for `a:b.pdf`, `CON.pdf`, a name ending in a dot and
#                         `Foo.pdf` beside `foo.pdf`, and 0 for a safe name.
#                     47. Under external, the root holding the area's folder in another case: `root`
#                         warns, and `add` exits 2 and creates no second spelling.
#                     48. A second answers file recording the other store: `store` and a data
#                         command exit 2 naming DATA_STORE and no layout key (a repo record beside
#                         an external one is a store disagreement, never a layout one).
#                     49. `root` reads the render's own answers file: its store, area, slug, kind and
#                         provider lines say what the file records (the reader against Copier's own
#                         quoting).
#                     50. `guard`, given the hook's JSON: a Write under a root SYNTEK_DATA_ROOT names
#                         exits 2 with the one line; an Edit under a marked root with the variable
#                         unset exits 2, and so does one through a symbolic link into it; a Write in
#                         the project, a Read under the root and input that is no tool call exit 0.
#                     51. `make root` with no root set exits 0 and prints the answer's `provider:`
#                         line and that provider's checklist, and the line 'The files are kept in
#                         the repository' exactly under repo (D53).
#                     52. Under external, after DATA_SLUG changes: rows filed before it are found
#                         where their filed_under says (`verify` exits 0 and counts them), and
#                         `status` names that older folder.
#                     53. A second answers file with no DATA_STORE (a template not yet updated):
#                         `store` exits 0 listing it as not yet asked, with one warning line, and a
#                         data command does not refuse.
#                     54. A second map claiming a folder this template's map names: a data command
#                         there exits 2 and `root` names both maps; and where the map fixes a
#                         folder's kind, `path` puts a file of another kind's extension under it.
#                     55. `make files-add FILE=<an ignored audio file> ROLE=generated`, with no AS=, as
#                         the shipped prose routes it: under external it files the copy under the
#                         audio kind with a `generated` row, after which `verify` exits 0 with
#                         nothing unlisted; under repo it exits 0 and writes nothing anywhere. A
#                         second file is added the same way with AS=as exported in the environment
#                         (Nix stdenv and cross toolchains export it), which make must not pass on.
#                     56. With a decoy SYNTEK_DATA_ROOT holding its marker in the caller's
#                         environment, a script that sources _common.sh sees the variable unset, the
#                         render's `root` reports none, and nothing is written in the decoy.
#                     57. The seed's own guard hook command, read from .claude/settings.json: from a
#                         sub-folder it blocks a Write under a marked root and passes one in the
#                         project; outside a work tree, and in one with no resolver, it exits 0.
#                     58. With tomllib made unimportable (a Python whose standard library is not
#                         whole; an older Python is checks 73–79's), `guard` still exits
#                         2 under a root and 0 elsewhere, and `root` exits 2 with one line.
#                     59. The resolver parses under ast.parse(…, feature_version=(3, 8)), so an old
#                         python3 reaches the guard's fail-open wrapper at all.
#
#                    The manifest's role rules (D50, as agreed with syntek-media on 16/10/2026).
#                    A row records whether its file is evidence, an evidence file is never
#                    replaced, rows are only appended, and Git's HEAD is the record verify holds
#                    them to. Checks 60–62 and 67 go through `make files-add`, 60–62 filing a copy
#                    from outside the project with AS=, as the bridge files a sent copy; where a
#                    check must tell exit 1 from 2 it asks the resolver itself, because make
#                    turns both into its own 2. Checks 60–66 and 68 run under external, and are
#                    skipped by name under repo.
#                     60. A signed copy filed, then `make files-add … ROLE=signed FORCE=1` and the
#                         resolver's `add --force` over it: both refused (the resolver exits 2,
#                         'file a new version under its own name'), the filed copy and the
#                         manifest byte for byte as they were, and no superseded copy made.
#                     61. Each row records `evidence` when it is filed, as a TOML boolean: true for
#                         the signed copy, false for an issued one.
#                     62. `make files-add … ROLE=issued FORCE=1` over the issued copy appends one
#                         row: the manifest is its old text, an owner's comment line and a comment
#                         after the old row's state value included, with only that value changed
#                         to superseded, followed by one new current row of the same path whose
#                         `replaces` names the kept copy, which holds the old bytes.
#                     63. In a scratch copy of the render whose manifest is committed: `verify`
#                         exits 0, and 0 again after a state is changed by hand from current to
#                         withdrawn and after a later `add --force`; a committed row's label
#                         edited, or a committed row removed, makes it exit 1 with a `committed:`
#                         line naming the row.
#                     64. In the same copy, a tracked external.toml in a folder no map names makes
#                         `verify` exit 1 with an `orphaned:` line; untracked, it is not judged.
#                     65. A key the resolver does not know, written into a row by hand, is still
#                         there byte for byte, and in that row, after a later `add`.
#                     66. With a test map marking a folder "rows": "none": a file Git ignores in it
#                         is never named by `status`, `add` into it exits 2 and writes nothing,
#                         and a file in it under the root is never listed by `status` or
#                         `verify`; a stray file under the root outside every map folder makes
#                         both exit 1 naming it as outside every map folder.
#                     67. With a test map role marked "repo": "skip": under repo, `make files-add`
#                         with it exits 0 saying 'not filed:' and writes nothing anywhere, while a
#                         map role without the key is refused ('commit the file instead'); under
#                         external the same role is filed with its row.
#                     68. The extensions syntek-media added (A9) choose their kinds, in any letter
#                         case: `path` puts psd, bmp, dng and exr under the photos kind, aac, aif,
#                         aiff, opus and pcm under audio, and webm, mxf, m4v, mts, m2ts, avi, braw
#                         and r3d under videos, in a folder whose kind no map fixes; an unknown
#                         extension goes under docs.
#                     69. Business under external: with the copy's DATA_AREA holding $(…) and a
#                         backquote (both of which Copier's validator accepts) and a stub xelatex
#                         first on PATH that records TEXINPUTS, `make pdf FILE=<a .tex>` exits 0,
#                         runs no command from the answers (no file appears) and hands TeX the
#                         data-root folder with the area exactly as written. Needs no TeX.
#
#                    The user guide (DESIGN.md D56). how-to/src/ holds the template's chapters,
#                    never the work: the targets read it only when SCOPE names it, and a session's
#                    file tools are kept out of how-to/ by the guide guard, whatever the settings
#                    say. A render without how-to/ (one made before v0.6.0) skips these by name.
#                     70. `make lint SCOPE=how-to/src STRICT=1` and `make flags SCOPE=how-to/src
#                         STRICT=1` exit 0: the guide's chapters are lint-clean (business lint
#                         reads every line under a SCOPE for em dashes) and hold no open flag.
#                     71. A line holding two sentences, planted in
#                         how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md, is not reported
#                         by `make lint` and is reported by `make lint SCOPE=how-to/src`: without
#                         a SCOPE neither target reads the guide (the Makefile's WORK_DIRS).
#                     72. The guide guard, .claude/hooks/how-to-read-only.sh, run from the copy's
#                         root with a hand-written PreToolUse payload: it exits 2 for an Edit of
#                         how-to/CONTEXT.md, a Write of how-to/new.md, a MultiEdit of an absolute
#                         path into how-to/src/, a NotebookEdit of how-to/x.ipynb, a Write of
#                         ./planning/../how-to/a.md, a Write through a link docs-link -> how-to,
#                         and, on a disk that ignores letter case, a Write of How-To/a.md (on
#                         Linux a casefold tmpfs in an unprivileged mount namespace stands in for
#                         one; skipped, by name, where neither exists); it exits 0 for an Edit of
#                         planning/src/outline.md, a Read of how-to/CONTEXT.md, the payload {},
#                         input that is no JSON, and, in a scratch project whose how-to is a link
#                         to planning/, an Edit of planning/src/outline.md. The seed's own hook
#                         command, read from .claude/settings.json and run with bash -c, refuses
#                         the Edit of how-to/CONTEXT.md in the copy, and exits 0 with the script
#                         removed and outside a git work tree.
#
#                    An older Python (the maintainer's decision of 23/10/2026; DESIGN.md D49–D52).
#                    The project's tools need Python X.Y or later, X.Y being _common.sh's
#                    SA_PYTHON_MIN, and a person may still run one on an older Python, which no
#                    other check here ever does. A command must then refuse, loudly and on
#                    stderr: it did not run, because this is Python A.B and it needs X.Y or
#                    later; upgrade. A hook must never block on it: it lets the action through
#                    and says the same, as a PreToolUse or UserPromptSubmit hook's JSON on
#                    stdout with exit 0, its systemMessage shown to the person and its
#                    hookSpecificOutput.additionalContext read by the session. Checks 73–79 and
#                    81 run the render's own files on the newest Python below X.Y that
#                    _common.sh's sa_old_python finds (SA_OLD_PYTHON names one; python3.N on PATH
#                    or uv's own, never a download, down to 3.8), and are skipped, by name, where
#                    there is none. "Loud" means the message names the Python it runs on (Python
#                    A.B), the minimum ('X.Y or later'), that it did not run (or work) and the word
#                    'upgrade', in any letter case, with no traceback.
#                     73. The resolver, run as `pythonA.B .claude/syntek-author-dataroot.py`, for
#                         `root`, `store`, `path`, `add`, `verify`, `status`, `pull`, `plan`,
#                         `check-names` and `--self-test`: each exits non-zero with nothing on
#                         stdout and the loud message on stderr, and nothing in the copy changes.
#                     74. With python3 at A.B first on PATH, `make root`, `make files-status` and
#                         `make provenance` (each where the Makefile has it) exit non-zero and
#                         print the loud message, so make's own Python never runs a tool on it.
#                     75. Every tooling/*.py, run with no argument on Python A.B, exits non-zero
#                         with nothing on stdout and the loud message on stderr.
#                     76. `.claude/syntek-author-permissions.py --check` and `--write` on Python
#                         A.B each exit non-zero with nothing on stdout and the loud message on
#                         stderr, and nothing in the copy changes.
#                     77. The data-root guard, as the seed's hook command runs it (read from
#                         .claude/settings.json) with python3 at A.B first on PATH: a Write under a
#                         marked root, which it blocks on a current Python (checks 50 and 57),
#                         exits 0 with one JSON object on stdout, its systemMessage and its
#                         additionalContext (hookEventName PreToolUse) each the loud message, and
#                         no permissionDecision, no "decision": "block" and no "continue": false;
#                         a Write in the project exits 0 and is not blocked either.
#                     78. The guide guard, .claude/hooks/how-to-read-only.sh, the same way: an Edit
#                         of how-to/CONTEXT.md, which it refuses on a current Python (check 72),
#                         exits 0 with that JSON; an Edit of planning/src/outline.md is not blocked.
#                     79. The context-threshold hook, .claude/hooks/context-threshold-handoff.sh,
#                         given a UserPromptSubmit payload whose transcript holds no record, exits
#                         0 with that JSON (hookEventName UserPromptSubmit) and blocks no prompt.
#                     80. Every Python file the project runs but the resolver (check 59's): the
#                         permissions script, each tooling/*.py and the Python each
#                         .claude/hooks/*.sh holds between <<'PY' and PY, parses under
#                         ast.parse(…, feature_version=(3, 8)), so an old Python reaches the
#                         version check and prints the message rather than a SyntaxError. Needs
#                         no older Python, and always runs.
#                     81. _common.sh, sourced with python3 at A.B first on PATH, and again with
#                         UV_PYTHON naming it, exits 2 before anything runs, naming Python A.B and
#                         'X.Y or later': every audit's own findings would otherwise be the
#                         interpreter's (D52's update script refuses to run there).
#
#                    The handoff hooks (DESIGN.md D29, the maintainer's decisions of 24/10/2026).
#                    A hook's message is the one way the person hears that a compaction was
#                    stopped or made, and nothing else here ever runs the hooks or reads what
#                    they print: a note that never appears, appears twice, lands in another
#                    session or shows Claude Code's 'hook error' notice ships silently. Each check
#                    reads the seed's four D29 commands from the render's .claude/settings.json
#                    and runs them as Claude Code runs a command hook on Linux and macOS, `sh -c`
#                    with a payload written by hand on stdin (checks 86 and 87 under `bash -c`
#                    too), in a scratch Git project holding a copy of the render's .claude/hooks/
#                    and .claude/settings.json, from a subfolder of it. They need bash and git
#                    only (python3 reads the JSON); a render without both hooks is skipped by
#                    name, and so is one whose seed lacks an entry (shipped-seeds checks 12 and
#                    22 report it).
#                     82. Automatic compaction: PreCompact `auto` for session smoke-a exits 2 with
#                         nothing on stdout and leaves a marker in .claude/; the UserPromptSubmit
#                         command for smoke-b then exits 0, prints nothing and leaves it; for
#                         smoke-a, with its transcript past the insist threshold, it exits 0 and
#                         prints exactly one line, a JSON object whose systemMessage is the
#                         automatic note's exact text (held here, as HK_AUTO_NOTE), whose
#                         hookSpecificOutput.hookEventName is UserPromptSubmit and whose
#                         additionalContext holds the fallback for a full window (HK_AUTO_CTX),
#                         so the relayed note is the prompt's only output, and no marker remains;
#                         a second prompt prints nothing. After another `auto` of smoke-a (a
#                         compaction that went ahead anyway), its SessionStart `compact` exits 0,
#                         prints nothing and removes the marker unread, and its next prompt
#                         prints nothing. A PreCompact `auto` with no session_id, and one whose
#                         id is nothing once reduced to letters, digits and hyphens, exits 2
#                         with its reminder on stderr and adds no name to .claude/.
#                     83. Manual compaction: PreCompact `manual` for smoke-m exits 0 with nothing on
#                         stdout and leaves a marker; smoke-m's prompt prints nothing and keeps it;
#                         the SessionStart `compact` command for smoke-m exits 0 and prints exactly
#                         one JSON line whose systemMessage is the manual note's exact text
#                         (HK_MANUAL_NOTE), whose hookEventName is SessionStart and whose
#                         additionalContext offers the handoff (HK_MANUAL_CTX), and the marker is
#                         gone; a second SessionStart prints nothing. A PreCompact `manual` with
#                         no session_id exits 0 and adds no name to .claude/.
#                     84. One marker per session: an `auto` in smoke-a and a `manual` in smoke-b
#                         leave exactly .claude/compaction-marker-smoke-a.tmp and
#                         .claude/compaction-marker-smoke-b.tmp; smoke-b's SessionStart shows a
#                         note (one JSON line, hookEventName SessionStart) and leaves smoke-a's
#                         marker byte for byte; smoke-a's next prompt then shows its note
#                         (hookEventName UserPromptSubmit). Checks 82 and 83 judge the texts. An
#                         `auto` in session 'smoke.r/' leaves exactly
#                         .claude/compaction-marker-smoker.tmp (the id reduced).
#                     85. Stale markers: with another session's marker last modified eight days ago,
#                         a third session's an hour ago and a link named like a marker thirty days
#                         old, a PreCompact `auto` removes the eight-day-old one, keeps the recent
#                         one and the link, and a PreCompact `auto` of the session the link is
#                         named for neither removes it nor writes through it.
#                     86. A missing script is silent: with .claude/hooks/pre-compact-handoff.sh and
#                         .claude/hooks/context-threshold-handoff.sh removed from a copy, each of
#                         the four commands exits 0 with nothing on stdout or stderr.
#                     87. Outside a Git repository: each of the four commands, run from a scratch
#                         folder outside any repository (GIT_CEILING_DIRECTORIES set so no parent
#                         repository is found), exits 0 with nothing on stdout or stderr.
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
#                    `build` skill's last step says so. Nor that the comparison gives each word
#                    to the right actor: compare.py's own self-test (check 18) proves the
#                    attribution, and check 33 only that each actor's macro reaches the LaTeX.
#                    Nor the data root on Windows or macOS (case folding, online-only files,
#                    long paths), behind a real sync service, or either guard inside a live
#                    Claude Code session: the checks run on this machine's disk, with the hook's
#                    JSON written by hand. The resolver's own --self-test covers its units. Nor
#                    the guide guard on native Windows, where it may let a write through (D56).
#                    Nor when Claude Code fires the handoff hooks (an idle compaction among
#                    them), or how it shows their notes: checks 82–87 write the events by hand.
#
# SELF-TEST. --self-test writes a fixture render at runtime with a Makefile whose targets can be
#            told to fail one at a time, proves it clean, then fails each target in turn and
#            asserts exactly one finding each. For checks 70–72 the fixture carries a chapter
#            of the user guide and the real guide guard from template/; its Makefile reads
#            how-to/src only under a SCOPE unless told otherwise. For checks 39–69 the fixture carries the real
#            resolver from template/ behind a stand-in of the same name, which runs it unchanged
#            unless SMOKE_DR switches on one misbehaviour; the stand-in Makefile's data-root
#            targets take switches of their own. Those probes need python3 at SA_PYTHON_MIN or
#            later, and are named as skipped below it. For checks 73–81 the stand-in resolver,
#            the guide guard and the threshold hook (each a prelude before the real one), a
#            stand-in permissions script and two tooling scripts each answer an older Python as
#            the checks require, until SMOKE_OLD switches on one misbehaviour; the stand-in
#            Makefile's OLD_SWALLOW=1 hides a refusal, and check 81 sources a copy of
#            _common.sh whose pin never runs. Those probes need an older Python, as checks
#            73–79 and 81 do, and are named as skipped without one; check 80's always runs.
#            For checks 82–87 the fixture carries the real pre-compact-handoff.sh, the real
#            context-threshold-handoff.sh behind that prelude, which passes a current Python
#            straight through, and the four D29 commands read from migrations/family-refresh.json
#            (byte for byte the seed's; shipped-seeds check 12 holds them together). Each probe
#            changes one fixture file: the automatic note loses its last sentence (82), the
#            manual note one word (83), every session shares one marker name (84), the prune
#            waits seventy days (85), the commands end in the old `[ -f … ] && exec` (86), and
#            the root lookup fails with `|| exit 1` (87). Six more fire one check each: the
#            threshold hook measures after a relayed note (82), a SessionStart keeps a stale
#            `auto` marker (82), `auto` lets a payload with no session id through (82), each
#            session text loses its fallback sentence (82, 83), and the id is no longer
#            reduced in the marker's name (84).
#            Each probe runs only the group its mutation is in (the data root, an older Python,
#            the handoff hooks, or the rest), after baselines that run all four.
#
# Requirements: bash 4+, make, git, python3 at _common.sh's SA_PYTHON_MIN or later (its pin
#               refuses an older one); a Python from 3.8 to below that minimum for checks 73–79
#               and 81 (sa_old_python); pandoc, xelatex, pdftotext and uv optional. No network, unless uv must fetch
#               fontTools for `make font` on its first run.
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

# Which groups a run covers: all, or (the self-test's probes only) legacy, checks 1–38 and
# 70–72, dataroot, checks 39–69, oldpy, checks 73–81, or hooks, checks 82–87. A group not run
# leaves its checks skipped, never passed.
SMOKE_GROUPS=all

smoke() { # $1 = a COPY of a render
  local d="$1"
  RES=(); GOT=(); SKIPS=(); GRD=(); CLS=(); LIG=(); BRD=(); STE=(); CMP=(); IGN=(); ISS=(); DR=(); SELFTESTS=(); HT=(); HG=(); OLD=(); HK=()
  smoke_answers "$d"
  case "$SMOKE_GROUPS" in
    all|legacy) smoke_legacy "$d" ;;
    *) GRD[skip]="skip: not run"; BRD[skip]="skip: not run"; STE[skip]="skip: not run"; HT[skip]="skip: not run" ;;
  esac
  case "$SMOKE_GROUPS" in all|dataroot) smoke_dataroot "$d" ;; esac
  case "$SMOKE_GROUPS" in all|oldpy) smoke_oldpy "$d" ;; esac
  case "$SMOKE_GROUPS" in all|hooks) smoke_hooks "$d" ;; esac
  BUILD_DIR="$d/build"
}

# The render's answers, through _common.sh's reader: A_STORE is repo where none is recorded (a
# render from before D50), so the issuing checks keep their v0.4.0 meaning there.
HAVE_ANSWERS=false
smoke_answers() { # $1 = a COPY of a render
  A_DOC_TYPE=""; A_STORE=repo; A_PROVIDER=none; A_AREA=""; A_SLUG=""
  A_KIND_DOCS=""; A_KIND_PHOTOS=""; A_KIND_AUDIO=""; A_KIND_VIDEOS=""
  HAVE_ANSWERS=false
  load_answers "$1/$SA_ANSWERS_FILE" && HAVE_ANSWERS=true
  return 0
}

smoke_legacy() { # $1 = a COPY of a render: checks 1–38
  local d="$1" lang file t
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
  smoke_compare "$d"
  if [[ -d "$d/library" ]]; then smoke_issue "$d"; smoke_guard "$d"; smoke_classification "$d"; smoke_ste "$d"
  else
    RES[issue]="skip: no issued documents in a book render"
    STE=([skip]="skip: no STE report in a book render (D46 is business-only)")
    GRD[skip]="skip: no issued documents in a book render"
    CLS[build]="skip: no house preamble in a book render"
  fi
  smoke_howto "$d"
  smoke_howto_guard "$d"
}

# The user guide's chapters (D56, checks 70–71): clean under a SCOPE that names them, and never
# read without one. HT[lint] and HT[flags] hold the exit statuses; HT[unscoped] and HT[scoped]
# whether each lint saw the planted line ('seen', 'unseen', or why it could not run).
HOWTO_CHAPTER="how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md"
HOWTO_PLANT="The guide is short. It is plain."
declare -A HT=()
smoke_howto() { # $1 = a COPY of a render
  local d="$1" s n log
  HT=()
  if [[ ! -d "$d/how-to/src" ]]; then HT[skip]="skip: no how-to/src (a render made before D56)"; return 0; fi
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  for t in lint flags; do
    s=0; (cd "$d" && timeout 300 make --no-print-directory "$t" SCOPE=how-to/src STRICT=1 "${MAKE_EXTRA[@]}") >"$d/.smoke-howto-$t.log" 2>&1 || s=$?
    HT[$t]=$s
  done
  # A make flags that fails everywhere is check 2's, not a fault of the guide.
  [[ "${RES[flags]:-0}" == 0 || "${HT[flags]}" == 0 ]] || HT[flags]="skip: make flags failed (check 2 reports it)"
  if [[ ! -f "$d/$HOWTO_CHAPTER" ]]; then HT[plant]="skip: no $HOWTO_CHAPTER"; return 0; fi
  cp -- "$d/$HOWTO_CHAPTER" "$d/.smoke-howto-chapter.keep"
  printf '
%s
' "$HOWTO_PLANT" >> "$d/$HOWTO_CHAPTER"
  n="$(wc -l < "$d/$HOWTO_CHAPTER")"
  for t in unscoped scoped; do
    log="$d/.smoke-howto-lint-$t.log"; s=0
    if [[ "$t" == unscoped ]]; then
      (cd "$d" && timeout 300 make --no-print-directory lint "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
    else
      (cd "$d" && timeout 300 make --no-print-directory lint SCOPE=how-to/src "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
    fi
    if [[ "$s" -ne 0 && "$t" == unscoped ]]; then HT[$t]="failed (exit $s)"
    elif [[ "$s" -ne 0 ]]; then HT[$t]="failed (exit $s)"
    elif grep -qF "$HOWTO_CHAPTER:$n:" "$log"; then HT[$t]=seen
    else HT[$t]=unseen; fi
  done
  cp -- "$d/.smoke-howto-chapter.keep" "$d/$HOWTO_CHAPTER"; rm -f -- "$d/.smoke-howto-chapter.keep"
}

# The guide guard (D56, check 72): every case of DESIGN.md D56's guard, run from the copy's root
# with a payload written by hand. HG[result] is 0, or the cases that went wrong; HG[case7] says
# why the letter-case case could not run.
declare -A HG=()
hg_payload() { # $1 = tool, $2 = field, $3 = target, $4 = cwd → the PreToolUse JSON
  python3 -I -c 'import json, sys; print(json.dumps({"hook_event_name": "PreToolUse", "tool_name": sys.argv[1], "tool_input": {sys.argv[2]: sys.argv[3]}, "cwd": sys.argv[4]}))' "$@"
}
hg_run() { # $1 = folder to run in, $2 = stdin, then the command → its exit status on stdout
  local dir="$1" input="$2" s=0; shift 2
  (cd "$dir" && printf '%s' "$input" | "$@") >/dev/null 2>&1 || s=$?
  printf '%s' "$s"
}
smoke_howto_guard() { # $1 = a COPY of a render
  local d="$1" g=".claude/hooks/how-to-read-only.sh" scratch got cmd s
  local -a bad=()
  HG=()
  if [[ ! -f "$d/$g" ]]; then HG[result]="skip: no $g (a render made before D56)"; return 0; fi
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  scratch="$(sa_mktemp)"
  hg_want() { # $1 = expected exit, $2 = label, $3 = folder, $4 = stdin, then the command
    local want="$1" label="$2" dir="$3" input="$4" got; shift 4
    got="$(hg_run "$dir" "$input" "$@")"
    [[ "$got" == "$want" ]] || bad+=("$label exited $got, not $want")
  }
  # Refused (exit 2).
  hg_want 2 "an Edit of how-to/CONTEXT.md" "$d" "$(hg_payload Edit file_path how-to/CONTEXT.md "$d")" bash "$g"
  hg_want 2 "a Write of how-to/new.md" "$d" "$(hg_payload Write file_path how-to/new.md "$d")" bash "$g"
  hg_want 2 "a MultiEdit of an absolute path into how-to/src/" "$d" "$(hg_payload MultiEdit file_path "$d/how-to/src/x.md" "$d")" bash "$g"
  hg_want 2 "a NotebookEdit of how-to/x.ipynb" "$d" "$(hg_payload NotebookEdit notebook_path how-to/x.ipynb "$d")" bash "$g"
  hg_want 2 "a Write of ./planning/../how-to/a.md" "$d" "$(hg_payload Write file_path ./planning/../how-to/a.md "$d")" bash "$g"
  ln -s how-to "$d/docs-link"
  hg_want 2 "a Write through the link docs-link -> how-to" "$d" "$(hg_payload Write file_path docs-link/a.md "$d")" bash "$g"
  rm -f -- "$d/docs-link"
  # Case 7: another letter case, on a disk that ignores it: this one, or a casefold tmpfs.
  if [[ -d "$d/How-To" ]]; then
    hg_want 2 "a Write of How-To/a.md on a disk that ignores case" "$d" "$(hg_payload Write file_path How-To/a.md "$d")" bash "$g"
  elif command -v unshare >/dev/null 2>&1 && command -v chattr >/dev/null 2>&1; then
    mkdir -p "$scratch/cf"
    s=0
    unshare -rm bash -c '
      mount -t tmpfs -o casefold tmpfs "$1" 2>/dev/null && mkdir "$1/d" && chattr +F "$1/d" 2>/dev/null || exit 99
      p="$1/d/p"; mkdir -p "$p/.claude/hooks" "$p/how-to"; cp -- "$2" "$p/.claude/hooks/"
      cd "$p" && python3 -I -c '"'"'import json, sys; print(json.dumps({"tool_name": "Write", "tool_input": {"file_path": "How-To/a.md"}, "cwd": sys.argv[1]}))'"'"' "$p"         | bash .claude/hooks/how-to-read-only.sh' smoke-casefold "$scratch/cf" "$d/$g" >/dev/null 2>&1 || s=$?
    case "$s" in
      2) ;;
      99) HG[case7]="skip: no casefold tmpfs here (Linux 6.13 or later, in an unprivileged mount namespace)" ;;
      *) bad+=("a Write of How-To/a.md on a casefold disk exited $s, not 2") ;;
    esac
  else
    HG[case7]="skip: the disk is case-sensitive, and no unshare or chattr to make one that is not"
  fi
  # Let through (exit 0).
  hg_want 0 "an Edit of planning/src/outline.md" "$d" "$(hg_payload Edit file_path planning/src/outline.md "$d")" bash "$g"
  hg_want 0 "a Read of how-to/CONTEXT.md" "$d" "$(hg_payload Read file_path how-to/CONTEXT.md "$d")" bash "$g"
  hg_want 0 "the payload {}" "$d" '{}' bash "$g"
  hg_want 0 "input that is no JSON" "$d" 'not json' bash "$g"
  mkdir -p "$scratch/linked/.claude/hooks" "$scratch/linked/planning/src"
  cp -- "$d/$g" "$scratch/linked/$g"; ln -s planning "$scratch/linked/how-to"
  hg_want 0 "an Edit of planning/src/outline.md where how-to links to planning/" "$scratch/linked"     "$(hg_payload Edit file_path planning/src/outline.md "$scratch/linked")" bash "$g"
  # The seed's own hook command (cases 13 and 14), with the copy's refusal as its control.
  cmd="$(python3 -I -c 'import json, sys
try:
    data = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception:
    sys.exit(0)
for e in (data.get("hooks") or {}).get("PreToolUse") or []:
    for h in e.get("hooks") or []:
        if sys.argv[2] in str(h.get("command", "")):
            print(h["command"]); sys.exit(0)' "$d/.claude/settings.json" "$g")"
  if [[ -z "$cmd" ]]; then
    bad+=(".claude/settings.json has no PreToolUse entry running $g")
  else
    hg_want 2 "the seed's hook command, for an Edit of how-to/CONTEXT.md" "$d" "$(hg_payload Edit file_path how-to/CONTEXT.md "$d")" bash -c "$cmd"
    mkdir -p "$scratch/noscript/.claude/hooks" "$scratch/outside"
    git -C "$scratch/noscript" init -q
    hg_want 0 "the seed's hook command with the script absent" "$scratch/noscript" "$(hg_payload Edit file_path how-to/CONTEXT.md "$scratch/noscript")" bash -c "$cmd"
    GIT_CEILING_DIRECTORIES="$scratch" hg_want 0 "the seed's hook command outside a git work tree" "$scratch/outside"       "$(hg_payload Edit file_path how-to/CONTEXT.md "$scratch/outside")" bash -c "$cmd"
  fi
  rm -rf -- "${scratch:?}"
  if [[ ${#bad[@]} -eq 0 ]]; then HG[result]=0
  else HG[result]="$(printf '%s; ' "${bad[@]}")"; HG[result]="${HG[result]%; }"; fi
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

# D45 and D42 (checks 33 to 37): make compare prints each section's record from the ledger. Every
# render gets the same planted unit: one tracked entry whose chain holds a revision of each kind
# and the author's final, and one entry git ignores (through .git/info/exclude, so no file of the
# render changes) carrying a word that must never reach build/compare/. The tracked entry carries
# a word that must, so a target that prints nothing cannot pass for one that filters, and a
# numbered list and a quotation, so check 37 sets every paragraph shape they open. The empty
# case runs first, with every entry the render ships moved aside and then put back.
CMP_UNIT="smoke-compare"
CMP_SEEN="Larkwater"     # only in the tracked entry: must reach the LaTeX
CMP_HIDDEN="Quillhaven"  # only in the ignored entry: must never reach build/compare/ or the log
CMP_TRACKED="---
unit: $CMP_UNIT
section: crossing
origin: ai
drafted: 01/10/2026
promoted: 05/10/2026
change_ratio: 0.23
learned: false
format: 2
---

## AI original

The ferry left the north bank at dusk.
The pilot watched the water and said nothing.

1. Bring the rope.
2. Watch the far bank.

> The river keeps its own counsel.

## Author original

<!-- Empty: the AI drafted this section. -->

## Revisions

<!-- revision 1 · ai · 02/10/2026 · improve-section (edit) · rows 1–2 -->

The ferry left the north bank at dusk, low in the water.
The pilot watched the current and said nothing.

1. Bring the rope.
2. Watch the far bank.

> The river keeps its own counsel.

<!-- revision 2 · author · 03/10/2026 · adapt-section -->

The ferry left the north bank at dusk, low in the water.
The pilot watched the current from $CMP_SEEN and said nothing.

1. Bring the rope.
2. Watch the far bank.

> The river keeps its own counsel.

<!-- revision 3 · author-note · 04/10/2026 · adapt-section · rows 3 -->

The ferry left the north bank at dusk, low in the water.
The pilot watched the slow current from $CMP_SEEN and said nothing.

1. Bring the rope.
2. Watch the far bank.

> The river keeps its own counsel.

## Author final

The ferry left the north bank at dusk, low and heavy in the water.
The pilot watched the slow current from $CMP_SEEN and said nothing at all.

1. Bring the rope.
2. Watch the far bank.

> The river keeps its own counsel.

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
| 1 | Add 'low in the water' | Shows the load | accepted | |
| 2 | 'the water' to 'the current' | Avoids the repeat | accepted | |
| 3 | 'the current' to 'the slow current' | The author's note | author-note | |
"
CMP_IGNORED="---
unit: $CMP_UNIT
section: hidden
origin: ai
drafted: 01/10/2026
promoted:
change_ratio:
learned: false
format: 2
---

## AI original

$CMP_HIDDEN kept its lamps lit all night.

## Author original

## Revisions

## Author final

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
"
declare -A CMP=()
smoke_compare() { # $1 = a COPY of a render
  local d="$1" led="standards/style/ledger" f s log tex body why kind texok=false
  local aside="$1/.smoke-ledger-aside" excl="$1/.git/info/exclude"
  CMP=()
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  mkdir -p "$d/$led" "$aside" "$d/.git/info"
  # Check 36: nothing to compare is not an error.
  for f in "$d/$led"/*.md; do
    [[ -f "$f" ]] || continue
    case "${f##*/}" in CONTEXT.md|CLAUDE.md|README.md|provenance.md) continue ;; esac
    mv -- "$f" "$aside/"
  done
  log="$d/.smoke-compare-empty.log"; s=0
  (cd "$d" && timeout 300 make --no-print-directory compare "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
  why=""
  [[ "$s" -eq 0 ]] || why+=" exit $s;"
  grep -qF 'No sections to compare yet.' "$log" || why+=" no 'No sections to compare yet.';"
  why="${why# }"; CMP[empty]="${why%;}"; CMP[empty]="${CMP[empty]:-0}"
  for f in "$aside"/*.md; do [[ -f "$f" ]] && mv -- "$f" "$d/$led/"; done
  rmdir -- "$aside" 2>/dev/null || true
  # Check 35: a section's slug needs its unit, and the refusal comes before any output.
  rm -rf -- "${d:?}/build/compare"
  log="$d/.smoke-compare-section.log"; s=0
  (cd "$d" && timeout 300 make --no-print-directory compare SECTION=x "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
  why=""
  [[ "$s" -ne 0 ]] || why+=" exit 0;"
  grep -qF 'SECTION= needs its unit' "$log" || why+=" no 'SECTION= needs its unit';"
  [[ -z "$(find "$d/build/compare" -type f 2>/dev/null | head -1)" ]] || why+=" it wrote to build/compare/;"
  why="${why# }"; CMP[section]="${why%;}"; CMP[section]="${CMP[section]:-0}"
  rm -rf -- "${d:?}/build/compare"
  # Checks 33, 34 and 37: the planted chain, and the entry git ignores beside it.
  if ! $HAVE_PANDOC; then
    CMP[tex]="skip: no pandoc"; CMP[ignored]="skip: no pandoc"; CMP[pdf]="skip: no pandoc"; return 0
  fi
  printf '%s' "$CMP_TRACKED" > "$d/$led/$CMP_UNIT--crossing.md"
  printf '%s' "$CMP_IGNORED" > "$d/$led/$CMP_UNIT--hidden.md"
  [[ ! -f "$excl" ]] || cp -- "$excl" "$d/.smoke-compare-exclude"
  printf '%s\n' "$led/$CMP_UNIT--hidden.md" >> "$excl"
  log="$d/.smoke-compare-tex.log"; s=0
  (cd "$d" && timeout 300 make --no-print-directory compare FORMAT=tex "UNIT=$CMP_UNIT" "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
  tex="$d/build/compare/$CMP_UNIT/$CMP_UNIT.tex"
  if [[ "$s" -ne 0 ]]; then
    CMP[tex]="exit $s"; CMP[ignored]="skip: make compare FORMAT=tex failed (check 33 reports it)"
  elif [[ ! -f "$tex" ]]; then
    CMP[tex]="no build/compare/$CMP_UNIT/$CMP_UNIT.tex"; CMP[ignored]="skip: no LaTeX written (check 33 reports it)"
  else
    texok=true
    # The body only: the preamble defines every macro, so it carries all of them.
    body="$(awk 'seen; index($0, "\\begin{document}") == 1 { seen = 1 }' "$tex")"
    why=""
    for kind in ai note author; do
      grep -qE "\\\\cmp${kind}(ins|del)\\{" <<<"$body" || why+=" \\cmp${kind}…"
    done
    CMP[tex]="${why:+no${why} in its body}"; CMP[tex]="${CMP[tex]:-0}"
    if grep -rqF "$CMP_HIDDEN" "$d/build/compare" "$log" 2>/dev/null; then CMP[ignored]=leak
    elif ! grep -qF "$CMP_SEEN" "$tex"; then CMP[ignored]=blind
    else CMP[ignored]=0; fi
  fi
  if $SKIP_PDF || ! $HAVE_XELATEX; then CMP[pdf]="skip: no xelatex (or --skip-pdf)"
  elif ! $texok; then CMP[pdf]="skip: make compare FORMAT=tex wrote no LaTeX (check 33 reports it)"
  else
    log="$d/.smoke-compare-pdf.log"; s=0
    (cd "$d" && timeout 900 make --no-print-directory compare "UNIT=$CMP_UNIT" "${MAKE_EXTRA[@]}") >"$log" 2>&1 || s=$?
    if [[ "$s" -ne 0 ]]; then CMP[pdf]="exit $s"
    elif [[ ! -f "$d/build/compare/$CMP_UNIT.pdf" ]]; then CMP[pdf]="no build/compare/$CMP_UNIT.pdf"
    else CMP[pdf]=0; fi
  fi
  rm -f -- "${d:?}/$led/$CMP_UNIT--crossing.md" "${d:?}/$led/$CMP_UNIT--hidden.md"
  if [[ -f "$d/.smoke-compare-exclude" ]]; then mv -- "$d/.smoke-compare-exclude" "$excl"; else rm -f -- "$excl"; fi
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
# Only under DATA_STORE repo is the issued copy beside its source (D50 Section 5.4): under
# external it is filed under the data root, which checks 40–43 prove instead.
declare -A ISS=()
smoke_issue() { # $1 = a COPY of a business render
  local d="$1" tex copy pdf s
  ISS=()
  if [[ "$A_STORE" != repo ]]; then
    RES[issue]="skip: DATA_STORE $A_STORE files the issued copy under the data root (checks 40–43)"; return 0
  fi
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

# D46 (check 38): make lint lists a long list step in business technical text, and leaves a
# short step and a legal document's steps alone. The long step is 24 words, the short one 3.
# The report's section is its header line and the indented 'file:line:text' lines below it.
STE_HEAD="List steps over 20 words"
STE_LONG="1. Open the supplier portal, select the invoice for this month, check each line against the order, and then press the button to approve it."
STE_SHORT="2. Close the portal."
declare -A STE=()
smoke_ste() { # $1 = a COPY of a business render
  local d="$1" dir file legal="" s list
  STE=()
  if [[ -d "$d/library/src/business" ]]; then dir=library/src/business
  elif [[ -d "$d/library/src" ]]; then dir=library/src
  else STE[skip]="skip: no library/src"; return 0; fi
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  file="$dir/smoke-ste.md"
  printf '# Smoke STE check\n\n%s\n%s\n' "$STE_LONG" "$STE_SHORT" > "$d/$file"
  if [[ -d "$d/library/src/legal" ]]; then
    legal="library/src/legal/smoke-ste-legal.md"
    printf '# Smoke STE check\n\n%s\n' "$STE_LONG" > "$d/$legal"
  else STE[legal]="skip: no library/src/legal"; fi
  s=0; (cd "$d" && timeout 300 make --no-print-directory lint "${MAKE_EXTRA[@]}") >"$d/.smoke-ste.log" 2>&1 || s=$?
  STE[status]=$s
  list="$(awk -v h="$STE_HEAD" 'index($0, h) == 1 { on = 1; next } on && /^  / { print; next } { on = 0 }' "$d/.smoke-ste.log")"
  STE[long]=false;  grep -qF "  $file:3:" <<<"$list" && STE[long]=true
  STE[short]=false; grep -qF "  $file:4:" <<<"$list" && STE[short]=true
  if [[ -n "$legal" ]]; then STE[legal]=false; grep -qF "  $legal:" <<<"$list" && STE[legal]=true; fi
  rm -f -- "${d:?}/${file:?}" ${legal:+"${d:?}/$legal"}
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

# ── The data root (DESIGN.md D50 and D53; checks 39–69) ─────────────────────
#
# Every case runs the render's own resolver and Makefile from the copy's top. A case that needs
# a root makes one in the copy's scratch folder (outside its repository) holding its own marker
# and passes it to that call alone, through DR_ENV; _common.sh has unset the caller's. DR[n] is
# check n's result: 0, 'skip: why', or the reasons it failed, which make its one finding.
DR_PY="$SA_DATAROOT_PY"
DR_MARK="$SA_DATAROOT_MARKER"
HAVE_PY_MIN=false   # python3 at the resolver's floor, SA_PYTHON_MIN (the pin has already refused one below it)
_v="$(sa_py_version python3 || true)"; [[ -n "$_v" ]] && ! sa_py_older "$_v" && HAVE_PY_MIN=true; unset _v
declare -A DR=()
DR_ENV=()
DR_RC=0
DR_FOLDER=""            # the filing folder most cases use: research/src where the map names it
DR_FOLDER_KIND=""       # the kind that folder's map entry fixes, or empty
SMOKE_REEXPORT=""       # the self-test's check 56 mutation: re-export the decoy after sourcing
# The first words of each DATA_PROVIDER value's checklist, as the resolver prints it (D53;
# CLOUD-PROVIDER-TOOL-TEXT.md Section 2), and the line it adds under DATA_STORE repo.
declare -A DR_PROVIDER_HEAD=(
  [none]="Provider: none."
  [google-drive]="Provider: Google Drive."
  [onedrive]="Provider: OneDrive or SharePoint."
  [dropbox]="Provider: Dropbox."
  [other-cloud]="Provider: another cloud service, through a tool you run."
  [nas]="Provider: a NAS or server on your network."
)
DR_REPO_LINE="The files are kept in the repository: this answer applies once you move them out."
DR_PYC=""               # the self-test's compiled copy of the real resolver
DR_SIBLING=".copier-answers.syntek-smoke.yml"     # a second template's answers file
DR_SIBLING_MAP=".claude/syntek-smoke-dataroot.json" # and its map
declare -A DR_WHAT=(
  [39]="a root state broke text work, or a data command did not refuse it (under repo, path and add refuse only a root containing the repository or lying inside it, or a marker above it), or something was written"
  [40]="make pdf ISSUE=1 under external did not file the issued copy as D50 Section 5.4 says"
  [41]="a second make pdf ISSUE=1 under external was not refused before the build"
  [42]="make pdf ISSUE=1 FORCE=1 under external did not file a new copy and keep the superseded one"
  [43]="make pdf ISSUE=1 with no data root did not refuse before writing anything"
  [44]="verify did not catch a changed, missing or unlisted copy"
  [45]="status did not report an ignored binary that no row lists"
  [46]="check-names did not judge Windows-safe names"
  [47]="the case-only clash under the root was not caught"
  [48]="two answers files that disagree on DATA_STORE were not refused as a store disagreement"
  [49]="the resolver's root does not read the render's own answers file"
  [50]="the guard did not decide as D50 Section 6 says"
  [51]="make root did not print the answer's provider line and checklist (D53)"
  [52]="rows filed under an older layout were not found where their filed_under says"
  [53]="a second answers file with no DATA_STORE was not treated as not yet asked"
  [54]="two maps claiming one folder were not refused, or a folder's fixed kind lost to the extension"
  [55]="make files-add ROLE=generated did not file an ignored generated file as D50 says"
  [56]="a SYNTEK_DATA_ROOT in the caller's environment reached an audit (_common.sh must unset it)"
  [57]="the seed's own guard hook command did not decide as D50 Section 6 says"
  [58]="without tomllib the guard no longer decides, or a data command does not refuse in one line"
  [59]="the resolver does not parse under ast.parse(feature_version=(3, 8))"
  [60]="FORCE=1 over an evidence row was not refused with the filed copy and its row unchanged"
  [61]="a filed row does not record evidence as D50 says"
  [62]="a superseding copy did not append one row with only the old row's state changed"
  [63]="verify did not hold the rows committed at HEAD"
  [64]="verify did not fail on a tracked external.toml that no map names"
  [65]="an unknown key on a row did not survive a later add"
  [66]="a \"rows\": \"none\" folder was listed, or a stray file outside every map folder was not"
  [67]="a map role marked \"repo\": \"skip\" did not exit 0 and write nothing under repo"
  [68]="an extension syntek-media added did not choose its kind"
  [69]="make pdf ran a command from the answers, or did not hand TeX the data-root folder as written"
)
# Check 68's table: syntek-media's seventeen extensions (B0.4, A9) and their kinds, half given
# in upper case, since the resolver reads an extension in any letter case; and one it does not
# know, which is a document.
DR_A9_KINDS=(PSD:photos bmp:photos DNG:photos exr:photos AAC:audio aif:audio AIFF:audio opus:audio
             PCM:audio webm:videos MXF:videos m4v:videos MTS:videos m2ts:videos AVI:videos braw:videos
             R3D:videos smokeunknown:docs)

# Small readers the checks share, run under python3 -I: a manifest's rows as tab-separated
# fields (the eighth, evidence, as true, false, absent or not-a-boolean); one key of one row;
# a manifest edited as an owner would by hand (a key set, a row dropped, a line added, a text
# replaced once); the append-only test; the map's folders; the seed's guard command; the 3.8
# parse; a hook call's JSON. Rows are counted from 1, in the order the file holds them.
DR_HELPER='
import ast, json, os, sys

FIELDS = ("path", "kind", "filed_under", "role", "state", "source", "replaces")


def evidence(row):
    v = row.get("evidence", None)
    return "absent" if v is None else "true" if v is True else "false" if v is False else "not-a-boolean"


def rows(path):
    import tomllib
    if not os.path.isfile(path):
        return 0
    with open(path, "rb") as f:
        data = tomllib.load(f)
    for row in data.get("file", []):
        print("\t".join([str(row.get(k, "")) for k in FIELDS] + [evidence(row)]))
    return 0


def rowkey(path, n, key):
    import tomllib
    with open(path, "rb") as f:
        found = tomllib.load(f).get("file", [])
    row = found[int(n) - 1] if 0 < int(n) <= len(found) else {}
    if key not in row:
        return 1
    print(row[key])
    return 0


def blocks(text):
    lines = text.splitlines(True)
    heads = [i for i, x in enumerate(lines) if x.strip() == "[[file]]"]
    return lines, heads


def edit(path, out):
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(out)
    return 0


def block(path, n):
    with open(path, encoding="utf-8", newline="") as f:
        lines, heads = blocks(f.read())
    i = int(n) - 1
    if not 0 <= i < len(heads):
        print("the manifest has no row %s" % n)
        sys.exit(1)
    return lines, heads[i], heads[i + 1] if i + 1 < len(heads) else len(lines)


def rowset(path, n, key, raw):
    lines, start, end = block(path, n)
    hits = [i for i in range(start + 1, end) if lines[i].split("=", 1)[0].strip() == key]
    if len(hits) != 1:
        print("row %s has no single %s line" % (n, key))
        return 1
    lines[hits[0]] = "%s = %s\n" % (key, raw)
    return edit(path, "".join(lines))


def rowdrop(path, n):
    lines, start, end = block(path, n)
    return edit(path, "".join(lines[:start] + lines[end:]))


def rowadd(path, n, line):
    lines, start, end = block(path, n)
    while end > start + 1 and not lines[end - 1].strip():
        end -= 1
    return edit(path, "".join(lines[:end] + [line + "\n"] + lines[end:]))


def textsub(path, old, new):
    with open(path, encoding="utf-8", newline="") as f:
        text = f.read()
    if text.count(old) != 1:
        print("the text to replace is in the manifest %d times, not once" % text.count(old))
        return 1
    return edit(path, text.replace(old, new))


def appended(before, after, old, new):
    with open(before, encoding="utf-8", newline="") as f:
        b = f.read()
    with open(after, encoding="utf-8", newline="") as f:
        a = f.read()
    if b.count(old) != 1:
        print("the state line of the old row is not in the manifest exactly once")
        return 1
    want = b.replace(old, new)
    if not a.startswith(want):
        n = next((i for i, (x, y) in enumerate(zip(want, a)) if x != y), min(len(want), len(a)))
        line = want[:n].count("\n") + 1
        print("the old text changed beyond the state value of the old row, at line %d (%r)" % (line, a[max(0, n - 20):n + 20]))
        return 1
    rest = a[len(want):]
    if not rest.lstrip("\r\n").startswith("[[file]]") or rest.count("[[file]]") != 1:
        print("what follows the old text is not one appended [[file]] row")
        return 1
    return 0


def folders(map_path, top):
    with open(map_path, encoding="utf-8") as f:
        entries = json.load(f).get("folders", [])
    for e in entries:
        if isinstance(e, dict) and os.path.isdir(os.path.join(top, e.get("path", ""))):
            print(e["path"] + "\t" + e.get("kind", ""))
    return 0


def folder(map_path, rel):
    with open(map_path, encoding="utf-8") as f:
        entries = json.load(f).get("folders", [])
    best = ""
    for e in entries:
        p = e.get("path", "") if isinstance(e, dict) else ""
        if p and (rel == p or rel.startswith(p + "/")) and len(p) > len(best):
            best = p
    print(best)
    return 0 if best else 1


def guardcmd(settings):
    with open(settings, encoding="utf-8") as f:
        hooks = (json.load(f).get("hooks") or {}).get("PreToolUse") or []
    for entry in hooks:
        for h in entry.get("hooks") or []:
            c = h.get("command", "")
            if "dataroot.py" in c and " guard" in c:
                print(c)
                return 0
    return 1


def parse(path):
    with open(path, encoding="utf-8") as f:
        source = f.read()
    try:
        ast.parse(source, feature_version=(3, 8))
    except SyntaxError as e:
        print("line %s: %s" % (e.lineno, e.msg))
        return 1
    return 0


def call(tool, field, target):
    print(json.dumps({"tool_name": tool, "tool_input": {field: target}}))
    return 0


def swapcase(value):
    print(value.swapcase())
    return 0


sys.exit({"rows": rows, "rowkey": rowkey, "rowset": rowset, "rowdrop": rowdrop, "rowadd": rowadd,
          "textsub": textsub, "appended": appended, "folders": folders, "folder": folder,
          "guardcmd": guardcmd, "parse": parse, "call": call, "swapcase": swapcase}[sys.argv[1]](*sys.argv[2:]))
'
drh() { python3 -I -c "$DR_HELPER" "$@"; }
# The resolver run as a script with tomllib unimportable, as in a Python whose library is not whole.
DR_NOTOML='import runpy, sys; sys.modules["tomllib"] = None; sys.argv = sys.argv[1:]; runpy.run_path(sys.argv[0], run_name="__main__")'

# One resolver call from the copy's top, in DR_ENV: DR_RC, and .smoke-dr.out and .smoke-dr.err.
drc() { # $1 = copy, then the resolver's arguments
  local d="$1"; shift
  DR_RC=0
  (cd "$d" && env "${DR_ENV[@]}" timeout 120 python3 "$DR_PY" "$@") </dev/null >"$d/.smoke-dr.out" 2>"$d/.smoke-dr.err" || DR_RC=$?
}
drg() { # $1 = copy, $2 = the hook's JSON: the guard, as the hook calls it
  DR_RC=0
  (cd "$1" && env "${DR_ENV[@]}" timeout 60 python3 "$DR_PY" guard) <<<"$2" >"$1/.smoke-dr.out" 2>"$1/.smoke-dr.err" || DR_RC=$?
}
drb() { # $1 = copy, $2 = stdin, then the resolver's arguments: with tomllib unimportable
  local d="$1" in="$2"; shift 2
  DR_RC=0
  (cd "$d" && env "${DR_ENV[@]}" timeout 60 python3 -I -c "$DR_NOTOML" "$DR_PY" "$@") <<<"$in" >"$d/.smoke-dr.out" 2>"$d/.smoke-dr.err" || DR_RC=$?
}
drm() { # $1 = copy, $2 = log name, then make's arguments, in DR_ENV
  # AS is unset unless DR_ENV sets it: a caller's exported assembler (Nix stdenv) would otherwise
  # decide what every case passes; check 55 exports it on purpose, once.
  local d="$1" log="$2"; shift 2
  DR_RC=0
  (cd "$d" && env -u AS "${DR_ENV[@]}" timeout 900 make --no-print-directory "$@" "${MAKE_EXTRA[@]}") </dev/null >"$d/.smoke-dr-$log.log" 2>&1 || DR_RC=$?
}
drhook() { # $1 = folder to run in, $2 = the hook command, $3 = the hook's JSON
  DR_RC=0
  (cd "$1" && env -u SYNTEK_DATA_ROOT timeout 60 sh -c "$2") <<<"$3" >/dev/null 2>&1 || DR_RC=$?
}
# The last line of a log that says why: make's own 'Error N' line is never the reason.
dr_last() { grep -v -e '^[[:space:]]*$' -e '^make: \*\*\*' "$1" 2>/dev/null | tail -1 | cut -c1-140 || true; }
dr_root() { rm -rf -- "${1:?}"; mkdir -p "$1"; : > "$1/$DR_MARK"; } # a root, with its marker
dr_set() { # $1 = check, $2 = its reasons ('' when it passed)
  local w="${2# }"; w="${w%;}"
  DR[$1]="${w:-0}"
}
dr_kind() { # $1 = docs, photos, audio or videos → this render's folder for it
  case "$1" in
    docs) printf '%s' "$A_KIND_DOCS" ;; photos) printf '%s' "$A_KIND_PHOTOS" ;;
    audio) printf '%s' "$A_KIND_AUDIO" ;; videos) printf '%s' "$A_KIND_VIDEOS" ;;
  esac
}
dr_listing() { # $1 = copy, $2 = its scratch folder: every path there, logs and build/ aside
  find "$2" \( -path "$1/.git" -o -path "$1/build" -o -name '.smoke-*' \) -prune -o -print | LC_ALL=C sort
}
# A fresh render ships no external.toml; any a case writes is removed, and one that was there
# is put back, so each case starts from the render as it came.
declare -A DR_KEPT=()
dr_keep() { # $1 = copy, $2 = its scratch folder
  local f n=0
  DR_KEPT=()
  while IFS= read -r -d '' f; do
    n=$((n + 1)); cp -p -- "$f" "$2/dr-kept-$n.toml"; DR_KEPT[$f]="$2/dr-kept-$n.toml"
  done < <(find "$1" -path "$1/.git" -prune -o -name external.toml -type f -print0)
}
dr_reset() { # $1 = copy
  local f
  while IFS= read -r -d '' f; do
    [[ -n "${DR_KEPT[$f]:-}" ]] || rm -f -- "$f"
  done < <(find "$1" -path "$1/.git" -prune -o -name external.toml -type f -print0)
  for f in "${!DR_KEPT[@]}"; do cp -p -- "${DR_KEPT[$f]}" "$f"; done
}
dr_ignore() { # $1 = copy, $2 = path: git ignores it, through .git/info/exclude where nothing else does
  git -C "$1" check-ignore -q -- "$2" 2>/dev/null && return 0
  mkdir -p "$1/.git/info"
  [[ -f "$1/.git/info/exclude.smoke" || ! -f "$1/.git/info/exclude" ]] || cp -- "$1/.git/info/exclude" "$1/.git/info/exclude.smoke"
  printf '/%s\n' "$2" >> "$1/.git/info/exclude"
}
dr_unignore() { # $1 = copy: .git/info/exclude as it was
  if [[ -f "$1/.git/info/exclude.smoke" ]]; then mv -- "$1/.git/info/exclude.smoke" "$1/.git/info/exclude"
  else rm -f -- "$1/.git/info/exclude"; fi
}

smoke_dataroot() { # $1 = a COPY of a render: checks 39–69
  local d="$1" w n g why
  w="$(dirname "$d")"
  DR=()
  if [[ ! -f "$d/$DR_PY" ]]; then
    for n in {39..69}; do DR[$n]="skip: no data-root resolver in this render (one from before D50)"; done; return 0
  fi
  dr_parse "$d"
  why=""
  if ! $HAVE_ANSWERS; then why="no $SA_ANSWERS_FILE"
  elif [[ "$A_STORE" != external && "$A_STORE" != repo ]]; then why="DATA_STORE '$A_STORE' is not a value this release offers"; fi
  if [[ -n "$why" ]]; then for n in {39..58} {60..69}; do DR[$n]="skip: $why"; done; return 0; fi
  g="$w/dr-root-guard"; dr_root "$g"; mkdir -p "$g/business/docs"
  dr_guard "$d" "$g"
  dr_hook "$d" "$w" "$g"
  dr_notoml "$d" "$g"
  dr_env "$d" "$w"
  rm -rf -- "${g:?}"
  if ! $HAVE_PY_MIN; then
    for n in {39..49} {51..55} {60..69}; do DR[$n]="skip: python3 is below $SA_PYTHON_MIN, where every data command refuses"; done; return 0
  fi
  DR_FOLDER="$(drh folders "$d/$SA_DATAROOT_MAP" "$d" 2>/dev/null | cut -f1 | awk '$0 == "research/src" { r = $0 } NR == 1 { f = $0 } END { print (r != "" ? r : f) }' || true)"
  if [[ -z "$DR_FOLDER" ]]; then
    for n in {39..49} {51..55} {60..69}; do DR[$n]="skip: $SA_DATAROOT_MAP names no folder this render has"; done; return 0
  fi
  DR_FOLDER_KIND="$(drh folders "$d/$SA_DATAROOT_MAP" "$d" 2>/dev/null | awk -F'\t' -v p="$DR_FOLDER" '$1 == p { print $2 }' || true)"
  dr_keep "$d" "$w"
  dr_reader "$d"
  dr_makeroot "$d"
  dr_names "$d"
  dr_states "$d" "$w"
  if [[ ! -d "$d/library/src" ]]; then
    for n in 40 41 42 43 69; do DR[$n]="skip: no issued documents in a book render"; done
  elif [[ "$A_STORE" != external ]]; then
    for n in 40 41 42 43; do DR[$n]="skip: DATA_STORE repo issues beside the source (checks 23 and 24)"; done
    DR[69]="skip: DATA_STORE repo gives TeX no data-root folder"
  else dr_issue "$d" "$w"; dr_quote "$d" "$w"; fi
  if [[ "$A_STORE" == external ]]; then dr_verify "$d" "$w"; dr_case "$d" "$w"
  else for n in 44 45 47 52; do DR[$n]="skip: DATA_STORE repo files nothing under a data root"; done; fi
  dr_answers "$d" "$w"
  dr_maps "$d" "$w"
  dr_generated "$d" "$w"
  if [[ "$A_STORE" == external ]]; then
    dr_rows "$d" "$w"; dr_keys "$d" "$w"; dr_working "$d" "$w"; dr_kinds "$d" "$w"; dr_head "$d" "$w"
  else for n in {60..66} 68; do DR[$n]="skip: DATA_STORE repo files nothing under a data root"; done; fi
  dr_skip "$d" "$w"
  dr_reset "$d"
}

# Check 69: the data-root folder TeX searches comes from the answers file (DATA_AREA, the kinds),
# whose validators accept $, brackets and a backquote; the shell must get it single-quoted.
dr_quote() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" dir tex r bin="$2/dr-69-bin" seen="$2/dr-69-texinputs" ans="$1/$SA_ANSWERS_FILE" why="" f
  local area='Smoke $(touch smoke-dr-69-dollar) `touch smoke-dr-69-tick` Area'
  dir=library/src/business; [[ -d "$d/$dir" ]] || dir=library/src
  tex="$dir/smoke-dr-69.tex"
  printf '\\documentclass{article}\n\\begin{document}\nA document.\n\\end{document}\n' > "$d/$tex"
  cp -p -- "$ans" "$w/dr-69-answers.yml"
  awk -v a="$area" '/^DATA_AREA:/ { print "DATA_AREA: '\''" a "'\''"; next } { print }' "$w/dr-69-answers.yml" > "$ans"
  mkdir -p "$bin"; rm -f -- "$seen"
  cat > "$bin/xelatex" <<'STUB'
#!/bin/sh
# tooling-smoke check 69: a stand-in xelatex that records TEXINPUTS and writes the PDF xelatex would.
printf '%s\n' "$TEXINPUTS" >> "$SMOKE_TEXINPUTS_OUT"
out=.; job=texput
for a in "$@"; do case "$a" in -output-directory=*) out="${a#*=}" ;; -jobname=*) job="${a#*=}" ;; esac; done
mkdir -p "$out" && printf '%%PDF-1.4 smoke\n' > "$out/$job.pdf"
STUB
  chmod +x "$bin/xelatex"
  r="$w/dr-root-69"; dr_root "$r"
  DR_ENV=("SYNTEK_DATA_ROOT=$r" "PATH=$bin:$PATH" "SMOKE_TEX_STUB=1" "SMOKE_TEXINPUTS_OUT=$seen")
  drm "$d" 69 pdf "FILE=$tex"
  [[ $DR_RC -eq 0 ]] || why+=" exit $DR_RC ($(dr_last "$d/.smoke-dr-69.log"));"
  for f in smoke-dr-69-dollar smoke-dr-69-tick; do
    if [[ -e "$d/$f" || -e "$d/$dir/$f" ]]; then why+=" it ran 'touch $f' from DATA_AREA;"; fi
  done
  if [[ ! -s "$seen" ]]; then why+=" xelatex was never run;"
  elif ! grep -qF "/$area/" "$seen"; then why+=" TeX was not given the data-root folder with the area as written ($(head -n 1 "$seen" | cut -c1-100));"; fi
  dr_set 69 "$why"
  cp -p -- "$w/dr-69-answers.yml" "$ans"
  rm -rf -- "${d:?}/$tex" "$d/smoke-dr-69-dollar" "$d/smoke-dr-69-tick" "$d/$dir/smoke-dr-69-dollar" "$d/$dir/smoke-dr-69-tick" "${r:?}" "${bin:?}"
}

# Check 59: an old python3 must be able to compile the file to reach the guard's wrapper.
dr_parse() { # $1 = copy
  local out
  if out="$(drh parse "$1/$DR_PY" 2>&1)"; then DR[59]=0; else DR[59]="${out:-it does not parse}"; fi
}

# Check 50: the guard, called as the hook calls it, with the JSON Claude Code sends.
dr_guard() { # $1 = copy, $2 = a marked root
  local d="$1" g="$2" why="" bad link="$1/smoke-link-into-root"
  DR_ENV=("SYNTEK_DATA_ROOT=$g"); drg "$d" "$(drh call Write file_path "$g/business/new.pdf")"
  [[ $DR_RC -eq 2 && "$(cat "$d/.smoke-dr.err")" == "$SA_GUARD_LINE" ]] \
    || why+=" a Write under the root SYNTEK_DATA_ROOT names exited $DR_RC, not 2 with the guard's one line;"
  DR_ENV=(-u SYNTEK_DATA_ROOT); drg "$d" "$(drh call Edit file_path "$g/business/docs/old.pdf")"
  [[ $DR_RC -eq 2 ]] || why+=" an Edit under a marked root, the variable unset, exited $DR_RC;"
  ln -s "$g/business" "$link"
  drg "$d" "$(drh call Edit file_path "$link/docs/old.pdf")"
  [[ $DR_RC -eq 2 ]] || why+=" an Edit through a symbolic link into the root exited $DR_RC;"
  rm -f -- "$link"
  DR_ENV=("SYNTEK_DATA_ROOT=$g"); drg "$d" "$(drh call Write file_path "$d/smoke-notes.md")"
  [[ $DR_RC -eq 0 ]] || why+=" a Write in the project exited $DR_RC;"
  drg "$d" "$(drh call Read file_path "$g/business/docs/old.pdf")"
  [[ $DR_RC -eq 0 ]] || why+=" a Read under the root exited $DR_RC;"
  for bad in 'not json' '[1, 2]' '{"tool_name": "Write"}' ''; do
    drg "$d" "$bad"
    [[ $DR_RC -eq 0 ]] || { why+=" input that is no tool call ('${bad:0:24}') exited $DR_RC;"; break; }
  done
  dr_set 50 "$why"
}

# Check 57: the command the seed wires, run by a shell as Claude Code runs a hook. It finds the
# resolver from Git's top level, so it must pass when there is no work tree or no resolver.
dr_hook() { # $1 = copy, $2 = its scratch folder, $3 = a marked root
  local d="$1" w="$2" g="$3" cmd sub why="" out="$2/dr-hook-outside" bare="$2/dr-hook-bare" call
  if ! cmd="$(drh guardcmd "$d/.claude/settings.json" 2>/dev/null)"; then
    DR[57]="the seed .claude/settings.json wires no PreToolUse command that runs the resolver's guard"; return 0
  fi
  call="$(drh call Write file_path "$g/business/new.pdf")"
  sub="$d/planning"; [[ -d "$sub" ]] || sub="$d/.claude"
  drhook "$sub" "$cmd" "$call"
  [[ $DR_RC -eq 2 ]] || why+=" from ${sub#"$d/"}/, a Write under a marked root exited $DR_RC;"
  drhook "$sub" "$cmd" "$(drh call Write file_path "$d/smoke-notes.md")"
  [[ $DR_RC -eq 0 ]] || why+=" from ${sub#"$d/"}/, a Write in the project exited $DR_RC;"
  rm -rf -- "${out:?}" "${bare:?}"; mkdir -p "$out" "$bare/.claude"
  if git -C "$out" rev-parse --show-toplevel >/dev/null 2>&1; then
    SKIPS+=("check 57 outside a work tree (the scratch folder is inside one)")
  else
    drhook "$out" "$cmd" "$call"
    [[ $DR_RC -eq 0 ]] || why+=" outside a work tree it exited $DR_RC;"
  fi
  git -C "$bare" init -q
  drhook "$bare" "$cmd" "$call"
  [[ $DR_RC -eq 0 ]] || why+=" in a work tree with no resolver it exited $DR_RC;"
  rm -rf -- "${out:?}" "${bare:?}"
  dr_set 57 "$why"
}

# Check 58: without tomllib (a library that is not whole) the guard must still decide, and every other
# command must say so in one line rather than fail with a traceback.
dr_notoml() { # $1 = copy, $2 = a marked root
  local d="$1" g="$2" why="" err
  DR_ENV=("SYNTEK_DATA_ROOT=$g")
  drb "$d" "$(drh call Write file_path "$g/business/new.pdf")" guard
  [[ $DR_RC -eq 2 ]] || why+=" a Write under the root exited $DR_RC;"
  drb "$d" "$(drh call Write file_path "$d/smoke-notes.md")" guard
  [[ $DR_RC -eq 0 ]] || why+=" a Write in the project exited $DR_RC;"
  drb "$d" "" root
  err="$(cat "$d/.smoke-dr.err")"
  [[ $DR_RC -eq 2 && "$(grep -c . <<<"$err")" -eq 1 && "$err" == refused:*tomllib* ]] \
    || why+=" root exited $DR_RC with '$(head -n 1 <<<"$err" | cut -c1-80)', not 2 with one 'refused: … tomllib' line;"
  dr_set 58 "$why"
}

# Check 56: the environment. A decoy root with its marker stands in for a maintainer's own; a
# script that sources _common.sh must never see it, and so neither may anything it starts.
dr_env() { # $1 = copy, $2 = its scratch folder
  local d="$1" decoy="$2/dr-decoy" out why=""
  dr_root "$decoy"
  out="$(cd "$d" && SYNTEK_DATA_ROOT="$decoy" bash -c '
      source "$1" || exit 3
      [[ -z "$2" ]] || export SYNTEK_DATA_ROOT="$3"
      printf "variable: %s\n" "${SYNTEK_DATA_ROOT-unset}"
      [[ "$4" != true ]] || python3 "$5" root 2>/dev/null | head -n 1
    ' smoke-env "$SA_SCRIPTS_DIR/_common.sh" "$SMOKE_REEXPORT" "$decoy" "$HAVE_PY_MIN" "$DR_PY" 2>&1 || true)"
  grep -qx 'variable: unset' <<<"$out" || why+=" a script that sources _common.sh sees SYNTEK_DATA_ROOT ($(head -n 1 <<<"$out"));"
  if $HAVE_PY_MIN; then
    grep -qx 'root: none' <<<"$out" || why+=" the render's root reports '$(sed -n 2p <<<"$out")', not 'root: none';"
  fi
  [[ "$(find "$decoy" -mindepth 1 | wc -l)" -eq 1 ]] || why+=" something was written in the decoy root;"
  rm -rf -- "${decoy:?}"
  dr_set 56 "$why"
}

# Check 49: the resolver's own reading of the answers file Copier wrote, line by line.
dr_reader() { # $1 = copy
  local d="$1" why="" want k
  local -a lines=("store: $A_STORE" "provider: $A_PROVIDER")
  DR_ENV=(-u SYNTEK_DATA_ROOT); drc "$d" root
  [[ $DR_RC -eq 0 ]] || { dr_set 49 "root exited $DR_RC with no root set: $(dr_last "$d/.smoke-dr.err")"; return 0; }
  if [[ "$A_STORE" == external ]]; then
    lines+=("area: $A_AREA" "slug: $A_SLUG")
    for k in docs photos audio videos; do lines+=("kind: $k = <root>/$A_AREA/$(dr_kind "$k")/$A_SLUG/"); done
  else
    lines+=("area: not used under repo" "slug: not used under repo")
    for k in docs photos audio videos; do lines+=("kind: $k = not used under repo"); done
  fi
  for want in "${lines[@]}"; do grep -qxF -- "$want" "$d/.smoke-dr.out" || why+=" no '$want' line;"; done
  dr_set 49 "$why"
}

# Check 51 (D53): make root, the author's route to the provider's checklist.
dr_makeroot() { # $1 = copy
  local d="$1" why="" head log="$1/.smoke-dr-51.log"
  DR_ENV=(-u SYNTEK_DATA_ROOT); drm "$d" 51 root
  [[ $DR_RC -eq 0 ]] || why+=" make root exited $DR_RC with no root set;"
  grep -qxF "provider: $A_PROVIDER" "$log" || why+=" no 'provider: $A_PROVIDER' line;"
  head="${DR_PROVIDER_HEAD[$A_PROVIDER]:-Provider '$A_PROVIDER': this tool does not know it; a newer template does.}"
  awk -v h="$head" 'index($0, h) == 1 { f = 1 } END { exit !f }' "$log" || why+=" no checklist opening '$head';"
  if [[ "$A_STORE" == repo ]]; then grep -qxF "$DR_REPO_LINE" "$log" || why+=" no '${DR_REPO_LINE%%:*}' line under repo;"
  elif grep -qxF "$DR_REPO_LINE" "$log"; then why+=" the '${DR_REPO_LINE%%:*}' line under $A_STORE;"; fi
  dr_set 51 "$why"
}

# Check 46: names a Windows or macOS disk cannot hold, in any store and with no root.
dr_names() { # $1 = copy
  local d="$1" dir="$DR_FOLDER/smoke-dr-names" n why=""
  mkdir -p "$d/$dir"; : > "$d/$dir/foo.pdf"
  DR_ENV=(-u SYNTEK_DATA_ROOT)
  for n in 'a:b.pdf' 'CON.pdf' 'ends-in-a-dot.' 'Foo.pdf'; do
    drc "$d" check-names "$dir/$n"
    [[ $DR_RC -eq 1 ]] && grep -q '^unsafe:' "$d/.smoke-dr.out" || why+=" '$n' exited $DR_RC;"
  done
  drc "$d" check-names "$dir/a-safe-name.pdf"
  [[ $DR_RC -eq 0 ]] || why+=" the safe 'a-safe-name.pdf' exited $DR_RC;"
  rm -rf -- "${d:?}/${dir:?}"
  dr_set 46 "$why"
}

# Check 39: every way the root can be wrong. Text work never needs it; a data command that
# cannot use it refuses with exit 2 before it writes anything, anywhere. Under repo, which reads
# no root, path and add refuse only a root inside the repository or holding it, or a marker
# above it, and refuse it before any shortcut.
dr_states() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" st why="" c s before after proof="" doc="" src="$2/dr-39-source.pdf" made="" want said
  printf '%%PDF-1.4 smoke\n' > "$src"
  if [[ -d "$d/library/src" ]]; then
    if $SKIP_PDF || ! $HAVE_XELATEX; then SKIPS+=("check 39's proof (no xelatex, or --skip-pdf)")
    elif [[ -f "$d/tooling/latex/skeleton.tex" ]]; then
      doc=library/src/business; [[ -d "$d/$doc" ]] || doc=library/src
      doc="$doc/smoke-dr-proof.tex"; cp -- "$d/tooling/latex/skeleton.tex" "$d/$doc"; proof=pdf
    else SKIPS+=("check 39's proof (no skeleton)"); fi
  elif ! $HAVE_PANDOC; then SKIPS+=("check 39's proof (no pandoc)")
  elif [[ -z "$(cd "$d" && find manuscript/src -type f -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md ! -path '*/drafts/*' 2>/dev/null | head -1 || true)" ]]; then
    SKIPS+=("check 39's proof (no unit under manuscript/src: an adoption render)")
  else proof=docx; fi
  for st in unset empty relative missing unmarked inside holding above; do
    case "$st" in
      unset)    DR_ENV=(-u SYNTEK_DATA_ROOT) ;;
      empty)    DR_ENV=("SYNTEK_DATA_ROOT=") ;;
      relative) made="$w/dr-39-relative"; dr_root "$made"; DR_ENV=("SYNTEK_DATA_ROOT=../${made##*/}") ;;
      missing)  rm -rf -- "${w:?}/dr-39-missing"; DR_ENV=("SYNTEK_DATA_ROOT=$w/dr-39-missing") ;;
      unmarked) made="$w/dr-39-unmarked"; rm -rf -- "${made:?}"; mkdir -p "$made"; DR_ENV=("SYNTEK_DATA_ROOT=$made") ;;
      inside)   made="$d/smoke-dr-39-inside"; dr_root "$made"; DR_ENV=("SYNTEK_DATA_ROOT=$made") ;;
      holding)  made=""; : > "$w/$DR_MARK"; DR_ENV=("SYNTEK_DATA_ROOT=$w") ;;
      above)    made=""; : > "$w/$DR_MARK"; DR_ENV=(-u SYNTEK_DATA_ROOT) ;;
    esac
    before="$(dr_listing "$d" "$w")"
    for c in flags lint; do
      drm "$d" "39-$st-$c" "$c"
      [[ $DR_RC -eq 0 ]] || why+=" make $c failed with the root $st;"
    done
    if [[ "$st" == unmarked && "$proof" == pdf ]]; then
      drm "$d" 39-proof pdf "FILE=$doc"
      s="${doc%.tex}"; s="build/${s//\//__}.pdf"
      [[ $DR_RC -eq 0 && -f "$d/$s" ]] || why+=" make pdf FILE=$doc failed with the root $st ($(dr_last "$d/.smoke-dr-39-proof.log"));"
    elif [[ "$st" == unmarked && "$proof" == docx ]]; then
      drm "$d" 39-proof docx
      [[ $DR_RC -eq 0 ]] || why+=" make docx failed with the root $st;"
    fi
    if [[ "$A_STORE" == external ]]; then
      for c in path add verify pull plan status; do
        case "$c" in
          path) set -- path "$DR_FOLDER/smoke-dr-39.pdf" ;;
          add)  set -- add "$src" --role archive --as "$DR_FOLDER/smoke-dr-39.pdf" ;;
          *)    set -- "$c" ;;
        esac
        ( cd "$d" || exit 0; s=0
          env "${DR_ENV[@]}" timeout 120 python3 "$DR_PY" "$@" </dev/null >"$d/.smoke-dr-39-$st-$c.out" 2>"$d/.smoke-dr-39-$st-$c.err" || s=$?
          printf '%s\n' "$s" > "$d/.smoke-dr-39-$st-$c.rc" ) &
      done
      wait
      for c in path add verify pull plan; do
        s="$(cat "$d/.smoke-dr-39-$st-$c.rc" 2>/dev/null || echo '?')"
        [[ "$s" == 2 ]] || why+=" $c exited $s with the root $st;"
      done
      s="$(cat "$d/.smoke-dr-39-$st-status.rc" 2>/dev/null || echo '?')"
      [[ "$s" == 0 || "$s" == 1 ]] || why+=" status exited $s with the root $st, though it needs none;"
    else
      # Under repo no command reads the root, but where the root and the repository contain one
      # another or a marker sits above it, path and every add refuse it first, the shortcuts of
      # add --role generated and a "repo": "skip" role (a sibling map's, written for these calls
      # alone) included. With a valid root they answer, which checks 55 and 67 prove; the
      # resolver's self-test covers the other states.
      case "$st" in inside|holding|above) want=2 ;; *) want="" ;; esac
      [[ -z "$want" ]] || printf '%s\n' '{"format": 1, "folders": [], "roles": [{"name": "smoke-take", "evidence": true, "repo": "skip"}]}' > "$d/$DR_SIBLING_MAP"
      for c in path generated skip status; do
        case "$c" in
          path)      set -- path "$DR_FOLDER/smoke-dr-39.pdf" ;;
          generated) set -- add "$DR_FOLDER/smoke-dr-39.pdf" --role generated ;;
          skip)      set -- add "$DR_FOLDER/smoke-dr-39.pdf" --role smoke-take ;;
          *)         set -- "$c" ;;
        esac
        [[ -n "$want" || "$c" == status ]] || continue
        ( cd "$d" || exit 0; s=0
          env "${DR_ENV[@]}" timeout 120 python3 "$DR_PY" "$@" </dev/null >"$d/.smoke-dr-39-$st-$c.out" 2>"$d/.smoke-dr-39-$st-$c.err" || s=$?
          printf '%s\n' "$s" > "$d/.smoke-dr-39-$st-$c.rc" ) &
      done
      wait
      rm -f -- "$d/$DR_SIBLING_MAP"
      if [[ -n "$want" ]]; then
        for c in path generated skip; do
          s="$(cat "$d/.smoke-dr-39-$st-$c.rc" 2>/dev/null || echo '?')"
          case "$c" in
            path)      said="path" ;;
            generated) said="add --role generated" ;;
            skip)      said="add --role smoke-take (\"repo\": \"skip\")" ;;
          esac
          if [[ "$s" != 2 ]]; then why+=" under repo, $said exited $s with the root $st, not 2;"
          elif [[ -s "$d/.smoke-dr-39-$st-$c.out" ]]; then why+=" under repo, $said refused with the root $st but still answered on stdout;"; fi
        done
      fi
      s="$(cat "$d/.smoke-dr-39-$st-status.rc" 2>/dev/null || echo '?')"
      [[ "$s" == 0 || "$s" == 1 ]] || why+=" under repo, status exited $s with the root $st, though it needs none;"
      if [[ -n "$want" ]] && ! grep -q 'were not checked' "$d/.smoke-dr-39-$st-status.err" 2>/dev/null; then
        why+=" under repo, status did not warn that it left the copies unchecked with the root $st;"
      fi
    fi
    after="$(dr_listing "$d" "$w")"
    [[ "$before" == "$after" ]] \
      || why+=" with the root $st, it wrote $(LC_ALL=C comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after") 2>/dev/null | head -n 1 | sed "s|^$w/||" || true);"
    case "$st" in
      holding|above) rm -f -- "${w:?}/$DR_MARK" ;;
      relative|unmarked|inside) rm -rf -- "${made:?}" ;;
    esac
  done
  [[ -z "$doc" ]] || rm -f -- "${d:?}/${doc:?}"
  rm -f -- "$src"
  dr_set 39 "$why"
}

# Checks 40–43 (business under external): issuing files the PDF under the root, by the
# resolver's add, after the D43 checks; never beside the source. The document is the house
# skeleton marked final, as in checks 23 and 24.
dr_issue() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" dir tex pdf built man r mirror why keep sup rows
  dir=library/src/business; [[ -d "$d/$dir" ]] || dir=library/src
  tex="$dir/smoke-dr-issue.tex"; pdf="${tex%.tex}.pdf"; built="${tex%.tex}"; built="build/${built//\//__}.pdf"
  if [[ -f "$d/tooling/latex/skeleton.tex" ]]; then cp -- "$d/tooling/latex/skeleton.tex" "$d/$tex.src"
  else printf '\\documentclass{article}\n\\begin{document}\nA document.\n\\end{document}\n' > "$d/$tex.src"; fi
  if grep -qE '^% status:' "$d/$tex.src"; then sed -E '0,/^% status:.*/s//% status: final/' "$d/$tex.src" > "$d/$tex"
  else { printf '%% status: final\n'; cat "$d/$tex.src"; } > "$d/$tex"; fi
  rm -f -- "$d/$tex.src"
  man="$(drh folder "$d/$SA_DATAROOT_MAP" "$pdf" 2>/dev/null || true)"; man="$d/${man:-library/src}/external.toml"
  # Check 43: no root. The refusal comes before the build, so it needs no XeLaTeX.
  rm -f -- "${d:?}/$built"
  DR_ENV=(-u SYNTEK_DATA_ROOT); drm "$d" 43 pdf "FILE=$tex" ISSUE=1
  why=""
  [[ $DR_RC -ne 0 ]] || why+=" it exited 0;"
  grep -qF 'ISSUE=1 files the issued copy under the data root' "$d/.smoke-dr-43.log" || why+=" no refusal saying ISSUE=1 files the issued copy under the data root;"
  [[ ! -e "$d/$built" ]] || why+=" it built $built;"
  [[ ! -e "$d/$pdf" ]] || why+=" a copy was written beside the source;"
  [[ ! -e "$man" ]] || why+=" it started ${man#"$d/"};"
  dr_set 43 "$why"
  rm -f -- "${d:?}/${pdf:?}"; dr_reset "$d"
  r="$w/dr-root-issue"; dr_root "$r"
  mirror="$r/$A_AREA/$A_KIND_DOCS/$A_SLUG/$pdf"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  # Check 40: the first issue.
  if $SKIP_PDF || ! $HAVE_XELATEX; then
    DR[40]="skip: no xelatex (or --skip-pdf)"; DR[42]="skip: no xelatex (or --skip-pdf)"
  else
    drm "$d" 40 pdf "FILE=$tex" ISSUE=1
    why=""
    [[ $DR_RC -eq 0 ]] || why+=" exit $DR_RC ($(dr_last "$d/.smoke-dr-40.log"));"
    [[ -f "$mirror" ]] || why+=" no copy at <root>/$A_AREA/$A_KIND_DOCS/$A_SLUG/$pdf;"
    rows="$(drh rows "$man" 2>&1 || true)"
    awk -F'\t' -v p="$pdf" -v s="$tex" '$1 == p && $4 == "issued" && $5 == "current" && $6 == s { n++ } END { exit !(n == 1 && NR == 1) }' <<<"$rows" \
      || why+=" ${man#"$d/"} does not hold one current issued row for $pdf with source $tex;"
    [[ ! -e "$d/$pdf" ]] || why+=" a copy was written beside the source;"
    dr_set 40 "$why"
  fi
  # Check 41: a second issue. Without XeLaTeX (or after check 40 failed), the issued copy it
  # must refuse over is filed here with add, so the refusal is judged either way.
  if [[ ! -f "$mirror" ]]; then
    printf '%%PDF-1.4 smoke issued\n' > "$w/dr-issued.pdf"
    drc "$d" add "$w/dr-issued.pdf" --as "$pdf" --role issued --source "$tex"
  fi
  if [[ ! -f "$mirror" ]]; then
    DR[41]="no issued copy could be filed to refuse over: $(dr_last "$d/.smoke-dr.err")"
    [[ "${DR[42]:-}" == skip:* ]] || DR[42]="skip: no issued copy to supersede (check 41 reports it)"
  else
    keep="$w/dr-issued.keep"; cp -- "$mirror" "$keep"; rm -f -- "${d:?}/$built"
    drm "$d" 41 pdf "FILE=$tex" ISSUE=1
    why=""
    [[ $DR_RC -ne 0 ]] || why+=" it exited 0;"
    grep -qF 'FORCE=1' "$d/.smoke-dr-41.log" || why+=" the refusal does not name FORCE=1;"
    [[ ! -e "$d/$built" ]] || why+=" it built $built before refusing;"
    cmp -s "$mirror" "$keep" || why+=" the filed copy changed;"
    dr_set 41 "$why"
    # Check 42: FORCE=1 files a new copy and keeps the old one under its superseded name. Rows
    # are only appended (D50): the old row keeps its path, and only its state changes.
    if [[ "${DR[42]:-}" != skip:* ]]; then
      drm "$d" 42 pdf "FILE=$tex" ISSUE=1 FORCE=1
      why=""
      [[ $DR_RC -eq 0 ]] || why+=" exit $DR_RC ($(dr_last "$d/.smoke-dr-42.log"));"
      sup="$(cd "$(dirname "$mirror")" 2>/dev/null && compgen -G "$(basename "${pdf%.pdf}").superseded-*.pdf" | head -n 1 || true)"
      [[ -n "$sup" ]] && cmp -s "$(dirname "$mirror")/$sup" "$keep" \
        || why+=" the old copy was not kept as $(basename "${pdf%.pdf}").superseded-DD-MM-YYYY.pdf;"
      [[ -f "$mirror" ]] && ! cmp -s "$mirror" "$keep" || why+=" no new copy was filed;"
      rows="$(drh rows "$man" 2>&1 || true)"
      if [[ -n "$sup" ]]; then
        sup="$(dirname "$pdf")/$sup"
        awk -F'\t' -v p="$pdf" '$1 == p && $5 == "superseded" { f = 1 } END { exit !f }' <<<"$rows" \
          || why+=" no row for $pdf, its path unchanged, whose state is superseded;"
        awk -F'\t' -v p="$sup" '$1 == p { f = 1 } END { exit !f }' <<<"$rows" \
          && why+=" a row's path was rewritten to $sup (rows are only appended);"
        awk -F'\t' -v p="$pdf" -v o="$sup" '$1 == p && $5 == "current" && $7 == o { f = 1 } END { exit !f }' <<<"$rows" \
          || why+=" no current row for $pdf whose replaces names $sup;"
      fi
      dr_set 42 "$why"
    fi
  fi
  rm -f -- "${d:?}/${tex:?}" "${d:?}/${pdf:?}" "$w/dr-issued.pdf" "$w/dr-issued.keep"
  rm -rf -- "${r:?}"; dr_reset "$d"
}

# Checks 44, 52 and 45 (under external): what the manifest promises, checked against the root.
dr_verify() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" r="$2/dr-root-verify" f="$DR_FOLDER/smoke-dr-verify" s="$DR_FOLDER/smoke-dr-status"
  local m why="" ra rb ans="$1/$SA_ANSWERS_FILE" moved=zz-smoke-moved
  dr_root "$r"; mkdir -p "$d/$f" "$d/$s"
  printf '%%PDF-1.4 smoke a\n' > "$d/$f/a.pdf"; printf '%%PDF-1.4 smoke b\n' > "$d/$f/b.pdf"
  dr_ignore "$d" "$f/a.pdf"; dr_ignore "$d" "$f/b.pdf"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$d" add "$f/a.pdf" --role archive; ra=$DR_RC
  drc "$d" add "$f/b.pdf" --role archive; rb=$DR_RC
  m="$r/$A_AREA/$A_KIND_DOCS/$A_SLUG/$f"
  if [[ $ra -ne 0 || $rb -ne 0 || ! -f "$m/a.pdf" || ! -f "$m/b.pdf" ]]; then
    DR[44]="add could not file two copies to verify (exit $ra and $rb): $(dr_last "$d/.smoke-dr.err")"
    DR[52]="skip: no copies were filed (check 44 reports it)"
  else
    # Check 44.
    drc "$d" verify
    [[ $DR_RC -eq 0 ]] || why+=" verify exited $DR_RC on intact copies;"
    cp -- "$m/a.pdf" "$w/dr-a.keep"; printf 'X' | dd of="$m/a.pdf" bs=1 seek=3 conv=notrunc 2>/dev/null
    drc "$d" verify
    [[ $DR_RC -eq 1 ]] && grep -qF "changed: $f/a.pdf" "$d/.smoke-dr.out" \
      || why+=" with a flipped byte verify exited $DR_RC without naming $f/a.pdf as changed;"
    cp -- "$w/dr-a.keep" "$m/a.pdf"; mv -- "$m/b.pdf" "$w/dr-b.keep"
    drc "$d" verify
    [[ $DR_RC -eq 1 ]] && grep -qF "missing: $f/b.pdf" "$d/.smoke-dr.out" \
      || why+=" with a copy moved away verify exited $DR_RC without naming $f/b.pdf as missing;"
    mv -- "$w/dr-b.keep" "$m/b.pdf"; printf 'stray\n' > "$m/stray.pdf"
    drc "$d" verify
    [[ $DR_RC -eq 1 ]] && grep -q "^unlisted: .*$f/stray\.pdf" "$d/.smoke-dr.out" \
      || why+=" with a file no row lists verify exited $DR_RC without naming it as unlisted;"
    rm -f -- "$m/stray.pdf" "$w/dr-a.keep"
    dr_set 44 "$why"
    # Check 52: the slug changes; the rows stay where their filed_under says.
    [[ "$moved" != "$A_SLUG"* ]] || moved=yy-smoke-moved
    cp -- "$ans" "$w/dr-answers.keep"
    awk -v s="$moved" '/^DATA_SLUG:/ { print "DATA_SLUG: " s; next } { print }' "$w/dr-answers.keep" > "$ans"
    why=""
    drc "$d" verify
    [[ $DR_RC -eq 0 ]] || why+=" verify exited $DR_RC ($(dr_last "$d/.smoke-dr.out"));"
    grep -q '^verified 2,' "$d/.smoke-dr.out" || why+=" verify did not count both rows ($(grep '^verified' "$d/.smoke-dr.out" | cut -c1-40 || true));"
    drc "$d" status
    cat "$d/.smoke-dr.out" "$d/.smoke-dr.err" | grep -qF "$A_AREA/$A_KIND_DOCS/$A_SLUG" \
      || why+=" status did not name the older folder $A_AREA/$A_KIND_DOCS/$A_SLUG;"
    cp -- "$w/dr-answers.keep" "$ans"; rm -f -- "$w/dr-answers.keep"
    dr_set 52 "$why"
  fi
  # Check 45: the loss detector.
  printf '%%PDF-1.4 smoke lost\n' > "$d/$s/lost.pdf"; dr_ignore "$d" "$s/lost.pdf"
  why=""
  drc "$d" status
  [[ $DR_RC -eq 1 ]] && grep -qF "not filed: $s/lost.pdf" "$d/.smoke-dr.out" \
    || why+=" status exited $DR_RC without naming $s/lost.pdf as not filed;"
  drc "$d" add "$s/lost.pdf" --role archive
  if [[ $DR_RC -ne 0 ]]; then why+=" add could not file it (exit $DR_RC);"
  else
    drc "$d" status
    [[ $DR_RC -eq 0 ]] && ! grep -qF "not filed: $s/lost.pdf" "$d/.smoke-dr.out" \
      || why+=" once filed, status exited $DR_RC or still named it;"
  fi
  dr_set 45 "$why"
  dr_unignore "$d"
  rm -rf -- "${d:?}/${f:?}" "${d:?}/${s:?}" "${r:?}"; dr_reset "$d"
}

# Check 47 (under external): a case-insensitive disk sees one folder where others see two.
dr_case() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-case" other why="" f="$DR_FOLDER/smoke-dr-case.pdf"
  other="$(drh swapcase "$A_AREA")"
  if [[ "$other" == "$A_AREA" ]]; then DR[47]="skip: DATA_AREA '$A_AREA' holds no letter whose case can differ"; return 0; fi
  dr_root "$r"; mkdir -p "$r/$other"
  printf '%%PDF-1.4 smoke case\n' > "$d/$f"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$d" root
  grep '^warning:' "$d/.smoke-dr.err" | grep -qF -- "$other" || why+=" root gave no warning naming $other;"
  drc "$d" add "$f" --role archive
  [[ $DR_RC -eq 2 ]] || why+=" add exited $DR_RC, not 2;"
  if [[ -e "$r/$A_AREA" && ! "$r/$A_AREA" -ef "$r/$other" ]]; then why+=" add created $A_AREA beside $other;"; fi
  rm -f -- "${d:?}/${f:?}"; rm -rf -- "${r:?}"; dr_reset "$d"
  dr_set 47 "$why"
}

# Checks 48 and 53: a second template's answers file beside this one.
dr_answers() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-answers" sib="$1/$DR_SIBLING" why="" err
  dr_root "$r"
  if [[ "$A_STORE" == external ]]; then printf 'DATA_STORE: repo\nDATA_PROVIDER: none\n' > "$sib"
  else
    printf '%s\n' 'DATA_STORE: external' 'DATA_AREA: business' 'DATA_SLUG: smoke-sibling' 'DATA_KIND_DOCS: docs' \
      'DATA_KIND_PHOTOS: photos' 'DATA_KIND_AUDIO: audio' 'DATA_KIND_VIDEOS: videos' 'DATA_PROVIDER: none' > "$sib"
  fi
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$d" store
  [[ $DR_RC -eq 2 ]] && grep -q 'DATA_STORE' "$d/.smoke-dr.err" || why+=" store exited $DR_RC without naming DATA_STORE;"
  drc "$d" path "$DR_FOLDER/smoke-dr-answers.pdf"
  err="$(cat "$d/.smoke-dr.err")"
  [[ $DR_RC -eq 2 && "$err" == *DATA_STORE* && ! "$err" =~ DATA_(AREA|SLUG|KIND) ]] \
    || why+=" path exited $DR_RC with '$(head -n 1 <<<"$err" | cut -c1-80)', not 2 naming DATA_STORE alone;"
  dr_set 48 "$why"
  # Check 53: a record without DATA_STORE is not yet asked.
  printf 'DOC_TYPE: %s\n_src_path: smoke\n' "${A_DOC_TYPE:-business}" > "$sib"
  why=""
  drc "$d" store
  err="$(cat "$d/.smoke-dr.err")"
  [[ $DR_RC -eq 0 ]] && grep -qx 'syntek-smoke: not yet asked' "$d/.smoke-dr.out" || why+=" store exited $DR_RC without listing it as not yet asked;"
  # A render may carry a sibling record of its own (one from before D50): count this one's lines.
  [[ "$(grep -F -- "$DR_SIBLING" <<<"$err" | grep -c '^warning: .*not yet asked')" -eq 1 && "$err" != *refused:* ]] \
    || why+=" store did not give exactly one 'not yet asked' warning line for $DR_SIBLING, and no refusal;"
  drc "$d" path "$DR_FOLDER/smoke-dr-answers.pdf"
  [[ $DR_RC -eq 0 ]] || why+=" path exited $DR_RC ($(dr_last "$d/.smoke-dr.err"));"
  dr_set 53 "$why"
  rm -f -- "$sib"; rm -rf -- "${r:?}"
}

# Check 54: one folder, one template's map; and a folder's fixed kind beats the extension.
dr_maps() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-maps" sm="$1/$DR_SIBLING_MAP" why="" role=archive p k ext want real
  dr_root "$r"; real="$(cd "$r" && pwd -P)"
  printf '{"format": 1, "folders": [{"path": "%s"}]}\n' "$DR_FOLDER" > "$sm"
  printf '%%PDF-1.4 smoke maps\n' > "$2/dr-maps.pdf"
  [[ "$A_STORE" == external ]] || role=generated
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$d" path "$DR_FOLDER/smoke-dr-maps.pdf"
  [[ $DR_RC -eq 2 ]] || why+=" path under $DR_FOLDER exited $DR_RC;"
  drc "$d" add "$2/dr-maps.pdf" --role "$role" --as "$DR_FOLDER/smoke-dr-maps.pdf"
  [[ $DR_RC -eq 2 ]] || why+=" add --role $role under $DR_FOLDER exited $DR_RC;"
  drc "$d" root
  grep -qF "${SA_DATAROOT_MAP##*/}" "$d/.smoke-dr.err" && grep -qF "${DR_SIBLING_MAP##*/}" "$d/.smoke-dr.err" \
    || why+=" root did not name both maps;"
  rm -f -- "$sm" "$2/dr-maps.pdf"
  if [[ "$A_STORE" == external ]]; then
    while IFS=$'\t' read -r p k; do
      [[ -n "$k" ]] || continue
      ext=png; [[ "$k" != photos ]] || ext=pdf
      drc "$d" path "$p/smoke-dr-kind.$ext"
      want="$A_AREA/$(dr_kind "$k")/$A_SLUG/$p/smoke-dr-kind.$ext"
      [[ $DR_RC -eq 0 && ( "$(cat "$d/.smoke-dr.out")" == "$r/$want" || "$(cat "$d/.smoke-dr.out")" == "$real/$want" ) ]] \
        || why+=" a .$ext under $p (kind $k) went to '$(cut -c1-80 "$d/.smoke-dr.out")';"
    done < <(drh folders "$d/$SA_DATAROOT_MAP" "$d" 2>/dev/null || true)
  fi
  rm -rf -- "${r:?}"
  dr_set 54 "$why"
}

# Check 55: generated audio (O47), by the route the shipped prose names: make files-add with
# FILE and ROLE only. A conlang language's audio folder is git-ignored; elsewhere the file is
# ignored through .git/info/exclude, as an author's output folder would be. GNU make predefines
# AS (the assembler), and a build environment may export it, so a second file is added with
# AS=as in make's environment: neither origin may reach the tool as --as.
dr_generated() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-generated" g g2 f man why="" rows copy log as
  if [[ -d "$d/world/src" ]]; then g="world/src/languages/smoke-tongue/audio/smoke-generated.mp3"
  else g="$DR_FOLDER/smoke-dr-generated/smoke-generated.mp3"; fi
  g2="${g%.mp3}-env.mp3"
  man="$(drh folder "$d/$SA_DATAROOT_MAP" "$g" 2>/dev/null || true)"
  if [[ -z "$man" ]]; then DR[55]="skip: no map folder holds $g"; return 0; fi
  man="$d/$man/external.toml"
  mkdir -p "$d/$(dirname "$g")"
  printf 'ID3 smoke generated audio\n' > "$d/$g"; printf 'ID3 smoke generated audio, AS exported\n' > "$d/$g2"
  dr_ignore "$d" "$g"; dr_ignore "$d" "$g2"; dr_root "$r"
  for f in "$g" "$g2"; do
    if [[ "$f" == "$g" ]]; then as=""; log=55; DR_ENV=("SYNTEK_DATA_ROOT=$r")
    else as=" with AS=as exported"; log=55-env; DR_ENV=("SYNTEK_DATA_ROOT=$r" "AS=as"); fi
    drm "$d" "$log" files-add "FILE=$f" ROLE=generated
    log="$d/.smoke-dr-$log.log"
    if [[ "$A_STORE" == external ]]; then
      [[ $DR_RC -eq 0 ]] || why+=" make files-add$as exited $DR_RC ($(dr_last "$log"));"
      copy="$r/$A_AREA/$A_KIND_AUDIO/$A_SLUG/$f"
      [[ -f "$copy" ]] && cmp -s "$copy" "$d/$f" || why+=" no copy at <root>/$A_AREA/$A_KIND_AUDIO/$A_SLUG/$f;"
      rows="$(drh rows "$man" 2>&1 || true)"
      awk -F'\t' -v p="$f" '$1 == p && $2 == "audio" && $4 == "generated" && $5 == "current" { n = 1 } END { exit !n }' <<<"$rows" \
        || why+=" ${man#"$d/"} holds no current generated audio row for $f;"
    else
      [[ $DR_RC -eq 0 ]] || why+=" make files-add$as exited $DR_RC under repo ($(dr_last "$log"));"
    fi
  done
  if [[ "$A_STORE" == external ]]; then
    DR_ENV=("SYNTEK_DATA_ROOT=$r"); drc "$d" verify
    [[ $DR_RC -eq 0 ]] && ! grep -q '^unlisted:' "$d/.smoke-dr.out" || why+=" verify then exited $DR_RC or listed a file as unlisted;"
  else
    [[ ! -e "$man" ]] || why+=" it wrote ${man#"$d/"} under repo;"
    [[ "$(find "$r" -mindepth 1 | wc -l)" -eq 1 ]] || why+=" it wrote under the root under repo;"
  fi
  dr_unignore "$d"
  rm -f -- "${d:?}/${g:?}" "${d:?}/${g2:?}"; rm -rf -- "${r:?}"
  [[ "$g" != world/src/languages/smoke-tongue/* ]] || rm -rf -- "${d:?}/world/src/languages/smoke-tongue"
  [[ "$g" != "$DR_FOLDER"/smoke-dr-generated/* ]] || rm -rf -- "${d:?}/$DR_FOLDER/smoke-dr-generated"
  dr_reset "$d"
  dr_set 55 "$why"
}

# Checks 60–62 (under external): the evidence flag a row records, the refusal it earns, and the
# append-only supersede. Each copy is filed by make files-add from outside the project with
# AS=, as the bridge files a sent or signed copy, so make's own AS never decides the path.
dr_rows() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" r="$2/dr-root-rows" dir="$DR_FOLDER/smoke-dr-rows" sg is m man rows why="" rs ri n out sup p role ev
  local old='state = "current"  # smoke: a comment after the value' new='state = "superseded"  # smoke: a comment after the value'
  sg="$dir/nda-signed.pdf"; is="$dir/letter.pdf"
  man="$(drh folder "$d/$SA_DATAROOT_MAP" "$sg" 2>/dev/null || true)"; man="$d/${man:-$DR_FOLDER}/external.toml"
  dr_root "$r"; m="$r/$A_AREA/$(dr_kind "${DR_FOLDER_KIND:-docs}")/$A_SLUG"
  printf '%%PDF-1.4 smoke signed\n' > "$w/dr-signed.pdf"; printf '%%PDF-1.4 smoke issued\n' > "$w/dr-issued.pdf"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drm "$d" 61-signed files-add "FILE=$w/dr-signed.pdf" "AS=$sg" ROLE=signed; rs=$DR_RC
  drm "$d" 61-issued files-add "FILE=$w/dr-issued.pdf" "AS=$is" ROLE=issued; ri=$DR_RC
  if [[ $rs -ne 0 || $ri -ne 0 || ! -f "$m/$sg" || ! -f "$m/$is" ]]; then
    DR[61]="make files-add could not file a signed and an issued copy (exit $rs and $ri): $(dr_last "$d/.smoke-dr-61-signed.log")"
    DR[60]="skip: no signed copy was filed (check 61 reports it)"; DR[62]="skip: no issued copy was filed (check 61 reports it)"
  else
    # Check 61: evidence is recorded when the row is written, as a TOML boolean.
    rows="$(drh rows "$man" 2>&1 || true)"
    for n in "$sg:signed:true" "$is:issued:false"; do
      IFS=: read -r p role ev <<<"$n"
      awk -F'\t' -v p="$p" -v r="$role" -v e="$ev" '$1 == p && $4 == r && $8 == e { f = 1 } END { exit !f }' <<<"$rows" \
        || why+=" the $role row records evidence '$(awk -F'\t' -v p="$p" '$1 == p { print $8; exit }' <<<"$rows")', not $ev;"
    done
    dr_set 61 "$why"
    # Check 60: FORCE=1 never replaces an evidence row's file or hash, by make or by the tool.
    why=""
    cp -- "$m/$sg" "$w/dr-rows-signed.keep"; cp -- "$man" "$w/dr-rows-man.keep"
    printf '%%PDF-1.4 smoke signed, a second scan\n' > "$w/dr-signed.pdf"
    drm "$d" 60 files-add "FILE=$w/dr-signed.pdf" "AS=$sg" ROLE=signed FORCE=1
    [[ $DR_RC -ne 0 ]] || why+=" make files-add ROLE=signed FORCE=1 exited 0;"
    grep -qF 'file a new version under its own name' "$d/.smoke-dr-60.log" \
      || why+=" make files-add ROLE=signed FORCE=1 did not say to file a new version under its own name;"
    drc "$d" add "$w/dr-signed.pdf" --as "$sg" --role signed --force
    [[ $DR_RC -eq 2 ]] && grep -qF 'add --force never replaces' "$d/.smoke-dr.err" \
      || why+=" add --force exited $DR_RC ($(dr_last "$d/.smoke-dr.err")), not 2 saying add --force never replaces an evidence row;"
    cmp -s "$m/$sg" "$w/dr-rows-signed.keep" || why+=" the filed signed copy changed;"
    cmp -s "$man" "$w/dr-rows-man.keep" || why+=" ${man#"$d/"} changed;"
    ! compgen -G "$m/${sg%.pdf}.superseded-*.pdf" >/dev/null || why+=" a superseded copy of the signed one was made;"
    dr_set 60 "$why"
    # Check 62: the supersede appends a row; the old text, comments included, keeps every byte
    # but the old row's state value.
    why=""
    n="$(awk -F'\t' -v p="$is" '$1 == p { print NR; exit }' <<<"$rows")"
    if ! out="$(drh textsub "$man" $'format = 1\n' $'format = 1\n# smoke: a note the owner wrote, kept byte for byte\n')" \
       || ! out="$(drh rowset "$man" "$n" state "${old#state = }")"; then
      DR[62]="the manifest could not be given an owner's comments: $out"
    else
      cp -- "$man" "$w/dr-rows-before.toml"; cp -- "$m/$is" "$w/dr-rows-issued.keep"
      printf '%%PDF-1.4 smoke issued, the corrected copy\n' > "$w/dr-issued.pdf"
      drm "$d" 62 files-add "FILE=$w/dr-issued.pdf" "AS=$is" ROLE=issued FORCE=1
      [[ $DR_RC -eq 0 ]] || why+=" make files-add ROLE=issued FORCE=1 exited $DR_RC ($(dr_last "$d/.smoke-dr-62.log"));"
      out="$(drh appended "$w/dr-rows-before.toml" "$man" "$old" "$new")" || why+=" $out;"
      sup="$(cd "$m/$dir" 2>/dev/null && compgen -G "$(basename "${is%.pdf}").superseded-*.pdf" | head -n 1 || true)"
      [[ -n "$sup" ]] && cmp -s "$m/$dir/$sup" "$w/dr-rows-issued.keep" \
        || why+=" the old copy was not kept under the root as $(basename "${is%.pdf}").superseded-DD-MM-YYYY.pdf;"
      cmp -s "$m/$is" "$w/dr-issued.pdf" || why+=" the new copy is not at <root>/…/$is;"
      rows="$(drh rows "$man" 2>&1 || true)"
      awk -F'\t' -v p="$is" -v o="$dir/$sup" '$1 == p && $5 == "current" && $7 == o { f++ } END { exit !(f == 1) }' <<<"$rows" \
        || why+=" no one current row for $is whose replaces names the kept copy;"
      dr_set 62 "$why"
    fi
  fi
  rm -rf -- "${r:?}"; rm -f -- "$w/dr-signed.pdf" "$w/dr-issued.pdf" "$w"/dr-rows-*; dr_reset "$d"
}

# Check 65 (under external): a key the resolver does not know, on a row, is kept as it is, so
# a companion's later field (a take's id, its rights) survives this template's add.
dr_keys() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-keys" dir="$DR_FOLDER/smoke-dr-keys" man why="" out
  local line='smoke_take_id = "a key this release does not know"'
  man="$(drh folder "$d/$SA_DATAROOT_MAP" "$dir/one.pdf" 2>/dev/null || true)"; man="$d/${man:-$DR_FOLDER}/external.toml"
  dr_root "$r"; mkdir -p "$d/$dir"
  printf '%%PDF-1.4 smoke one\n' > "$d/$dir/one.pdf"; printf '%%PDF-1.4 smoke two\n' > "$d/$dir/two.pdf"
  dr_ignore "$d" "$dir/one.pdf"; dr_ignore "$d" "$dir/two.pdf"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$d" add "$dir/one.pdf" --role archive
  if [[ $DR_RC -ne 0 ]]; then why="add could not file a copy (exit $DR_RC): $(dr_last "$d/.smoke-dr.err")"
  elif ! out="$(drh rowadd "$man" 1 "$line")"; then why="the row could not be given a key by hand: $out"
  else
    drc "$d" add "$dir/two.pdf" --role archive
    [[ $DR_RC -eq 0 ]] || why+=" a later add exited $DR_RC ($(dr_last "$d/.smoke-dr.err"));"
    grep -qxF -- "$line" "$man" || why+=" the line '$line' is gone from ${man#"$d/"};"
    [[ "$(drh rowkey "$man" 1 smoke_take_id 2>/dev/null || true)" == "a key this release does not know" ]] \
      || why+=" row 1 no longer holds smoke_take_id;"
  fi
  dr_unignore "$d"
  rm -rf -- "${r:?}" "${d:?}/${dir:?}"; dr_reset "$d"
  dr_set 65 "$why"
}

# Check 66 (under external): a test map marks a folder as working output ("rows": "none"). Its
# files are never filed, nor listed in the work tree or under the root; a stray file under the
# root that lies outside every map folder is reported, since no row can ever list it.
dr_working() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-working" sm="$1/$DR_SIBLING_MAP" wk=smoke-dr-working m c why="" out
  dr_root "$r"; m="$r/$A_AREA/$(dr_kind docs)/$A_SLUG"
  printf '{"format": 1, "folders": [{"path": "%s", "rows": "none"}]}\n' "$wk" > "$sm"
  mkdir -p "$d/$wk" "$m/$wk" "$m/smoke-dr-stray"
  printf '%%PDF-1.4 smoke render\n' > "$d/$wk/render.pdf"; dr_ignore "$d" "$wk/render.pdf"
  printf '%%PDF-1.4 smoke render, under the root\n' > "$m/$wk/take.pdf"
  printf '%%PDF-1.4 smoke stray\n' > "$m/smoke-dr-stray/stray.pdf"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  for c in status verify; do
    drc "$d" "$c"; out="$(cat "$d/.smoke-dr.out")"
    [[ $DR_RC -eq 1 ]] && grep -q '^unlisted: .*smoke-dr-stray/stray\.pdf (outside every map folder' <<<"$out" \
      || why+=" with a stray file under the root outside every map folder, $c exited $DR_RC without naming it as such;"
    ! grep -qF "$wk/" <<<"$out" || why+=" $c named a file in the working-output folder ($(grep -m 1 -F "$wk/" <<<"$out" | cut -c1-80));"
  done
  rm -rf -- "${m:?}/smoke-dr-stray"
  for c in status verify; do
    drc "$d" "$c"
    [[ $DR_RC -eq 0 ]] || why+=" with only working output left, $c exited $DR_RC ($(grep -m 1 -e '^unlisted:' -e '^not filed:' "$d/.smoke-dr.out" | cut -c1-80 || true));"
  done
  drc "$d" add "$wk/render.pdf" --role archive
  [[ $DR_RC -eq 2 ]] || why+=" add into $wk/ exited $DR_RC, not 2;"
  [[ ! -e "$d/$wk/external.toml" && "$(find "$m/$wk" -type f | wc -l)" -eq 1 ]] || why+=" add into $wk/ wrote a row or a copy;"
  dr_unignore "$d"
  rm -f -- "$sm"; rm -rf -- "${r:?}" "${d:?}/${wk:?}"; dr_reset "$d"
  dr_set 66 "$why"
}

# Check 67 (every store): a test map's role marked "repo": "skip" (a companion's takes) is never
# filed under repo, where make files-add with it exits 0 and writes nothing, while a map role
# without the key is refused; under external it is filed as any role is.
dr_skip() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-skip" sm="$1/$DR_SIBLING_MAP" dir="$DR_FOLDER/smoke-dr-skip" man why="" before after rows
  dr_root "$r"
  printf '%s\n' '{"format": 1, "folders": [], "roles": [{"name": "smoke-take", "evidence": true, "repo": "skip"},' \
    '{"name": "smoke-export", "evidence": true}]}' > "$sm"
  mkdir -p "$d/$dir"; printf '%%PDF-1.4 smoke take\n' > "$d/$dir/take.pdf"; dr_ignore "$d" "$dir/take.pdf"
  man="$(drh folder "$d/$SA_DATAROOT_MAP" "$dir/take.pdf" 2>/dev/null || true)"; man="$d/${man:-$DR_FOLDER}/external.toml"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  if [[ "$A_STORE" == repo ]]; then
    before="$(dr_listing "$d" "$d")"
    drm "$d" 67 files-add "FILE=$dir/take.pdf" ROLE=smoke-take
    [[ $DR_RC -eq 0 ]] && grep -q '^not filed: ' "$d/.smoke-dr-67.log" \
      || why+=" make files-add ROLE=smoke-take exited $DR_RC ($(dr_last "$d/.smoke-dr-67.log")), not 0 with a 'not filed:' line;"
    drm "$d" 67-export files-add "FILE=$dir/take.pdf" ROLE=smoke-export
    [[ $DR_RC -ne 0 ]] && grep -qF 'commit the file instead' "$d/.smoke-dr-67-export.log" \
      || why+=" make files-add ROLE=smoke-export, a role without \"repo\": \"skip\", exited $DR_RC without 'commit the file instead';"
    after="$(dr_listing "$d" "$d")"
    [[ "$before" == "$after" ]] \
      || why+=" it wrote $(LC_ALL=C comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after") 2>/dev/null | head -n 1 | sed "s|^$d/||" || true) in the project;"
    [[ "$(find "$r" -mindepth 1 | wc -l)" -eq 1 ]] || why+=" it wrote under the root;"
  else
    drc "$d" add "$dir/take.pdf" --role smoke-take
    rows="$(drh rows "$man" 2>&1 || true)"
    [[ $DR_RC -eq 0 && -f "$r/$A_AREA/$(dr_kind "${DR_FOLDER_KIND:-docs}")/$A_SLUG/$dir/take.pdf" ]] \
      && awk -F'\t' -v p="$dir/take.pdf" '$1 == p && $4 == "smoke-take" && $5 == "current" { f = 1 } END { exit !f }' <<<"$rows" \
      || why+=" under external, add --role smoke-take exited $DR_RC ($(dr_last "$d/.smoke-dr.err")) or left no copy and current row;"
  fi
  dr_unignore "$d"
  rm -f -- "$sm"; rm -rf -- "${r:?}" "${d:?}/${dir:?}"; dr_reset "$d"
  dr_set 67 "$why"
}

# Check 68 (under external): the kinds of syntek-media's seventeen extensions (A9), in a folder
# whose kind no map fixes, so the extension table alone decides. The calls run at once.
dr_kinds() { # $1 = copy, $2 = its scratch folder
  local d="$1" r="$2/dr-root-kinds" why="" e ext k want got real s
  if [[ -n "$DR_FOLDER_KIND" ]]; then DR[68]="skip: $DR_FOLDER fixes its kind ($DR_FOLDER_KIND), so no extension chooses one there"; return 0; fi
  dr_root "$r"; real="$(cd "$r" && pwd -P)"
  for e in "${DR_A9_KINDS[@]}"; do
    ext="${e%%:*}"
    ( cd "$d" || exit 0; s=0
      env SYNTEK_DATA_ROOT="$r" timeout 120 python3 "$DR_PY" path "$DR_FOLDER/smoke-dr-kinds/x.$ext" </dev/null \
        >"$d/.smoke-dr-68-$ext.out" 2>"$d/.smoke-dr-68-$ext.err" || s=$?
      printf '%s\n' "$s" > "$d/.smoke-dr-68-$ext.rc" ) &
  done
  wait
  for e in "${DR_A9_KINDS[@]}"; do
    ext="${e%%:*}"; k="${e#*:}"
    want="$A_AREA/$(dr_kind "$k")/$A_SLUG/$DR_FOLDER/smoke-dr-kinds/x.$ext"
    s="$(cat "$d/.smoke-dr-68-$ext.rc" 2>/dev/null || echo '?')"; got="$(cat "$d/.smoke-dr-68-$ext.out" 2>/dev/null || true)"
    [[ "$s" == 0 && ( "$got" == "$r/$want" || "$got" == "$real/$want" ) ]] \
      || why+=" .$ext went to '${got#"$r/"}' (exit $s), not under the $k kind;"
  done
  rm -rf -- "${r:?}"
  dr_set 68 "$why"
}

# Checks 63 and 64 (under external): Git's HEAD is the record. In a scratch copy of the render,
# its own repository beside this one, the manifest is committed and then edited by hand as an
# owner might: verify must hold every committed row but for the one allowed state change, and
# a manifest Git tracks in a folder no map names is an orphan, whose rows nothing reads.
dr_head() { # $1 = copy, $2 = its scratch folder
  local d="$1" w="$2" h="$2/dr-head" r="$2/dr-root-head" dir="$DR_FOLDER/smoke-dr-head" a b rel man why="" k
  rm -rf -- "${h:?}"; cp -a -- "$d" "$h"
  dr_root "$r"; mkdir -p "$h/$dir"
  a="$dir/a.pdf"; b="$dir/b.pdf"
  printf '%%PDF-1.4 smoke head a\n' > "$h/$a"; printf '%%PDF-1.4 smoke head b\n' > "$h/$b"
  dr_ignore "$h" "$a"; dr_ignore "$h" "$b"
  rel="$(drh folder "$h/$SA_DATAROOT_MAP" "$a" 2>/dev/null || true)"; rel="${rel:-$DR_FOLDER}/external.toml"; man="$h/$rel"
  DR_ENV=("SYNTEK_DATA_ROOT=$r")
  drc "$h" add "$a" --role archive; k="$DR_RC"
  drc "$h" add "$b" --role archive; k="$k $DR_RC"
  if [[ "$k" != "0 0" ]] || ! sa_git "$h" add -- "$rel" >/dev/null 2>&1 \
     || ! sa_git "$h" commit -q --no-verify -m 'smoke: the filed rows' >/dev/null 2>&1; then
    DR[63]="two copies could not be filed and their manifest committed (add exited $k): $(dr_last "$h/.smoke-dr.err")"
    DR[64]="skip: no committed manifest (check 63 reports it)"
  else
    cp -- "$man" "$w/dr-head.toml"
    # Check 63.
    drc "$h" verify
    [[ $DR_RC -eq 0 ]] || why+=" verify exited $DR_RC on the rows as committed ($(dr_last "$h/.smoke-dr.out"));"
    drh rowset "$man" 1 state '"withdrawn"' >/dev/null || why+=" row 1 of $rel has no single state line to change;"
    drc "$h" verify
    [[ $DR_RC -eq 0 ]] \
      || why+=" with row 1's state changed by hand from current to withdrawn, verify exited $DR_RC ($(grep -m 1 '^committed:' "$h/.smoke-dr.out" | cut -c1-80 || true));"
    cp -- "$w/dr-head.toml" "$man"
    drh rowset "$man" 1 label '"smoke: edited by hand"' >/dev/null || why+=" row 1 of $rel has no single label line to edit;"
    drc "$h" verify
    [[ $DR_RC -eq 1 ]] && grep -qF "committed: $rel row 1 ($a) differs from HEAD in label" "$h/.smoke-dr.out" \
      || why+=" with row 1's label edited, verify exited $DR_RC without a 'committed: … differs from HEAD in label' line;"
    cp -- "$w/dr-head.toml" "$man"
    drh rowdrop "$man" 2 >/dev/null || why+=" $rel has no row 2 to remove;"
    drc "$h" verify
    [[ $DR_RC -eq 1 ]] && grep -qF "committed: $rel row 2 ($b) is committed at HEAD but gone from the work tree" "$h/.smoke-dr.out" \
      || why+=" with row 2 removed, verify exited $DR_RC without a 'committed: … gone from the work tree' line;"
    cp -- "$w/dr-head.toml" "$man"
    printf '%%PDF-1.4 smoke head a, a later copy\n' > "$h/$a"
    drc "$h" add "$a" --role archive --force; k="$DR_RC"
    drc "$h" verify
    [[ $k -eq 0 && $DR_RC -eq 0 ]] \
      || why+=" after a supersede that followed the commit, add exited $k and verify $DR_RC ($(grep -m 1 '^committed:' "$h/.smoke-dr.out" | cut -c1-80 || true));"
    dr_set 63 "$why"
    # Check 64.
    why=""
    mkdir -p "$h/smoke-dr-orphan"; printf 'format = 1\n' > "$h/smoke-dr-orphan/external.toml"
    if ! sa_git "$h" add -- smoke-dr-orphan/external.toml >/dev/null 2>&1; then why=" smoke-dr-orphan/external.toml could not be tracked;"
    else
      drc "$h" verify
      [[ $DR_RC -eq 1 ]] && grep -q '^orphaned: smoke-dr-orphan/external\.toml' "$h/.smoke-dr.out" \
        || why+=" with smoke-dr-orphan/external.toml tracked, verify exited $DR_RC without an 'orphaned:' line naming it;"
      sa_git "$h" rm -q --cached -- smoke-dr-orphan/external.toml >/dev/null 2>&1 || true
      drc "$h" verify
      [[ $DR_RC -eq 0 ]] || why+=" untracked, it still made verify exit $DR_RC;"
    fi
    dr_set 64 "$why"
  fi
  rm -rf -- "${h:?}" "${r:?}"; rm -f -- "$w/dr-head.toml"
}

BUILD_DIR=""
SELFTESTS=()
# ── An older Python (checks 73–81) ───────────────────────────────────────────
#
# The newest Python below SA_PYTHON_MIN this machine has (_common.sh's sa_old_python), found once.
# OLD[n] is check n's result: 0, 'skip: why', or the reasons it failed, which make its one finding.
OLD_PY=""; OLD_VER=""; OLD_WHY=""
if OLD_PY="$(sa_old_python)"; then OLD_VER="$(sa_py_version "$OLD_PY")"; else OLD_WHY="${OLD_PY:-no older Python}"; OLD_PY=""; fi
OLD_BIN=""              # a folder holding python3 -> the older Python, put first on PATH
OLD_RC=0
SMOKE_COMMON=""         # the self-test's check 81 mutation: a copy of _common.sh whose pin never runs
declare -A OLD=()
declare -A OLD_WHAT=(
  [73]="the data-root resolver did not refuse loudly on an older Python"
  [74]="a make target that runs python3 did not refuse loudly on an older python3"
  [75]="a tooling script did not refuse loudly on an older Python"
  [76]="the permissions script did not refuse loudly on an older Python"
  [77]="the data-root guard, on an older python3, blocked or did not warn the person and the session"
  [78]="the guide guard, on an older python3, blocked or did not warn the person and the session"
  [79]="the context-threshold hook, on an older python3, blocked or did not warn the person and the session"
  [80]="a Python file the project runs does not parse under ast.parse(feature_version=(3, 8))"
  [81]="_common.sh did not refuse an older Python before anything ran"
)
# The judges, run on the current Python. Each prints what is wrong, or nothing.
#   refusal OUT ERR RC OLD MIN   a command: non-zero, nothing on stdout, the loud message on stderr
#   log LOG RC OLD MIN           a make target: non-zero, the loud message in its output
#   hook OUT RC EVENT OLD MIN W  a hook: exit 0, no block; with W=1 the loud message as its JSON
#   parse FILE                   the file parses under feature_version (3, 8)
#   hookpy FILE                  every <<'PY' … PY block of a hook script parses so
OLD_HELPER="$SA_LOUD_DEF"'
import ast
import json


def first(text):
    lines = [x.strip() for x in text.splitlines() if x.strip()]
    return (lines[0] if lines else "")[:90]


def refusal(out, err, rc, old, need):
    out, err = open(out, errors="replace").read(), open(err, errors="replace").read()
    bad = []
    if rc == "0":
        bad.append("exited 0")
    if out.strip():
        bad.append("printed on stdout (%r)" % first(out))
    miss = unloud(err, old, need)
    if miss:
        bad.append("its stderr (%r) lacks %s" % (first(err), ", ".join(miss)))
    print(", ".join(bad))


def log(path, rc, old, need):
    text = open(path, errors="replace").read()
    bad = []
    if rc == "0":
        bad.append("exited 0")
    miss = unloud(text, old, need)
    if miss:
        bad.append("its output (%r) lacks %s" % (first(text), ", ".join(miss)))
    print(", ".join(bad))


def hook(out, rc, event, old, need, warn):
    text = open(out, errors="replace").read().strip()
    bad = []
    if rc != "0":
        bad.append("exited %s, not 0 (a hook never blocks on an older Python)" % rc)
    if not text:
        if warn == "1":
            bad.append("printed nothing, so no warning reached the person or the session")
        print(", ".join(bad))
        return
    try:
        data = json.loads(text)
    except ValueError:
        data = None
    if not isinstance(data, dict):
        bad.append("its stdout is not one JSON object (%r)" % first(text))
        print(", ".join(bad))
        return
    spec = data.get("hookSpecificOutput")
    if data.get("decision") == "block" or data.get("continue") is False:
        bad.append("its JSON blocks (decision block, or continue false)")
    if isinstance(spec, dict) and "permissionDecision" in spec:
        bad.append("its JSON decides the permission (%r)" % spec.get("permissionDecision"))
    if warn == "1":
        msg = data.get("systemMessage")
        miss = unloud(msg, old, need) if isinstance(msg, str) else ["a systemMessage, which the person sees"]
        if miss:
            bad.append("its systemMessage lacks %s" % ", ".join(miss))
        ctx = spec.get("additionalContext") if isinstance(spec, dict) else None
        if not isinstance(spec, dict) or spec.get("hookEventName") != event:
            bad.append("its hookSpecificOutput names no hookEventName %s" % event)
        miss = unloud(ctx, old, need) if isinstance(ctx, str) else ["an additionalContext, which the session reads"]
        if miss:
            bad.append("its additionalContext lacks %s" % ", ".join(miss))
    print(", ".join(bad))


def parse_text(source):
    try:
        ast.parse(source, feature_version=(3, 8))
    except SyntaxError as e:
        return "line %s: %s" % (e.lineno, e.msg)
    return ""


def parse(path):
    print(parse_text(open(path, encoding="utf-8").read()))


def hookpy(path):
    block, inside, start, bad = [], False, 0, []
    for n, line in enumerate(open(path, encoding="utf-8").read().splitlines(), 1):
        if not inside and re.search(r"<<\s*\x27PY\x27", line):
            inside, block, start = True, [], n
        elif inside and line == "PY":
            inside = False
            why = parse_text("\n".join(block) + "\n")
            if why:
                bad.append("the block from line %d, %s" % (start, why))
        elif inside:
            block.append(line)
    print("; ".join(bad))


{"refusal": refusal, "log": log, "hook": hook, "parse": parse, "hookpy": hookpy}[sys.argv[1]](*sys.argv[2:])
'
oldh() { python3 -I -c "$OLD_HELPER" "$@"; }
old_set() { # $1 = check, $2 = its reasons ('' when it passed)
  local w="${2# }"; w="${w%;}"
  OLD[$1]="${w:-0}"
}
# One command from the copy's top on the older Python: OLD_RC, .smoke-old.out and .smoke-old.err.
old_run() { # $1 = copy, then the command
  local d="$1"; shift
  OLD_RC=0
  (cd "$d" && env -u SYNTEK_DATA_ROOT PATH="$OLD_BIN:$PATH" timeout 120 "$@") </dev/null >"$d/.smoke-old.out" 2>"$d/.smoke-old.err" || OLD_RC=$?
}
# One hook from the copy's top, its JSON on stdin, with python3 at the older Python first on PATH.
old_hook() { # $1 = copy, $2 = the hook's JSON, then the command
  local d="$1" in="$2"; shift 2
  OLD_RC=0
  (cd "$d" && env -u SYNTEK_DATA_ROOT PATH="$OLD_BIN:$PATH" timeout 60 "$@") <<<"$in" >"$d/.smoke-old.out" 2>"$d/.smoke-old.err" || OLD_RC=$?
}
# Every file's hash, logs, .git and build/ aside: what a refusal must leave as it was.
old_sums() { # $1 = copy
  (cd "$1" && find . \( -name .git -o -name build -o -name '.smoke-*' \) -prune -o -type f -print0 | LC_ALL=C sort -z \
    | xargs -0 -r sha1sum 2>/dev/null) || true
}
old_changed() { # $1 = sums before, $2 = sums after → the first path that differs
  diff <(printf '%s\n' "$1") <(printf '%s\n' "$2") | sed -n 's/^[<>] [0-9a-f]*  \.\///p' | head -1 || true
}

smoke_oldpy() { # $1 = a COPY of a render: checks 73–81
  local d="$1" w n
  w="$(dirname "$d")"
  OLD=()
  old_parse "$d"
  if [[ -z "$OLD_PY" ]]; then
    for n in {73..79} 81; do OLD[$n]="skip: $OLD_WHY"; done; return 0
  fi
  OLD_BIN="$w/old-python-bin"; rm -rf -- "$OLD_BIN"; mkdir -p "$OLD_BIN"; ln -s "$OLD_PY" "$OLD_BIN/python3"
  [[ -d "$d/.git" ]] || git -C "$d" init -q
  old_resolver "$d"
  old_make "$d"
  old_tools "$d"
  old_permissions "$d"
  old_guard "$d" "$w"
  old_howto "$d"
  old_threshold "$d" "$w"
  old_pin
  rm -rf -- "${OLD_BIN:?}"
}

# Check 73: every command a person or the Makefile gives the resolver.
old_resolver() { # $1 = copy
  local d="$1" why="" before after a bad
  local -a cmds=("root" "store" "path smoke-old.pdf" "add smoke-old.pdf --role issued" "verify" "status" "pull" "plan"
                 "check-names smoke-old.pdf" "--self-test")
  if [[ ! -f "$d/$DR_PY" ]]; then OLD[73]="skip: no data-root resolver in this render (one from before D50)"; return 0; fi
  before="$(old_sums "$d")"
  for a in "${cmds[@]}"; do
    # shellcheck disable=SC2086  # each entry is the resolver's arguments, split on purpose
    old_run "$d" "$OLD_PY" "$DR_PY" $a
    bad="$(oldh refusal "$d/.smoke-old.out" "$d/.smoke-old.err" "$OLD_RC" "$OLD_VER" "$SA_PYTHON_MIN")"
    [[ -z "$bad" ]] || why+=" '$a' $bad;"
  done
  after="$(old_sums "$d")"
  [[ "$before" == "$after" ]] || why+=" a refused command changed $(old_changed "$before" "$after");"
  old_set 73 "$why"
}

# Check 74: make's own python3 is the older one.
old_make() { # $1 = copy
  local d="$1" why="" t s log bad ran=""
  for t in root files-status provenance; do
    grep -q "^$t:" "$d/Makefile" 2>/dev/null || continue
    ran+=" $t"; log="$d/.smoke-old-make-$t.log"; s=0
    (cd "$d" && env -u AS -u SYNTEK_DATA_ROOT PATH="$OLD_BIN:$PATH" timeout 300 make --no-print-directory "$t" "${MAKE_EXTRA[@]}") \
      </dev/null >"$log" 2>&1 || s=$?
    bad="$(oldh log "$log" "$s" "$OLD_VER" "$SA_PYTHON_MIN")"
    [[ -z "$bad" ]] || why+=" make $t $bad;"
  done
  if [[ -z "$ran" ]]; then OLD[74]="skip: the Makefile has none of root, files-status and provenance"; return 0; fi
  old_set 74 "$why"
}

# Check 75: each tooling script, as make runs it, from the copy's top.
old_tools() { # $1 = copy
  local d="$1" why="" f bad
  local -a py=()
  for f in "$d"/tooling/*.py; do [[ -f "$f" ]] && py+=("${f#"$d/"}"); done
  if [[ ${#py[@]} -eq 0 ]]; then OLD[75]="skip: no tooling/*.py in this render"; return 0; fi
  for f in "${py[@]}"; do
    old_run "$d" "$OLD_PY" "$f"
    bad="$(oldh refusal "$d/.smoke-old.out" "$d/.smoke-old.err" "$OLD_RC" "$OLD_VER" "$SA_PYTHON_MIN")"
    [[ -z "$bad" ]] || why+=" $f $bad;"
  done
  old_set 75 "$why"
}

# Check 76: the permissions script, read-only and writing.
old_permissions() { # $1 = copy
  local d="$1" p=".claude/syntek-author-permissions.py" why="" a bad before after
  if [[ ! -f "$d/$p" ]]; then OLD[76]="skip: no $p in this render (one from before D49)"; return 0; fi
  before="$(old_sums "$d")"
  for a in --check --write; do
    old_run "$d" "$OLD_PY" "$p" "$a"
    bad="$(oldh refusal "$d/.smoke-old.out" "$d/.smoke-old.err" "$OLD_RC" "$OLD_VER" "$SA_PYTHON_MIN")"
    [[ -z "$bad" ]] || why+=" $a $bad;"
  done
  after="$(old_sums "$d")"
  [[ "$before" == "$after" ]] || why+=" --write changed $(old_changed "$before" "$after");"
  old_set 76 "$why"
}

# Check 77: the data-root guard as the seed runs it, under a marked root and in the project.
old_guard() { # $1 = copy, $2 = its scratch folder
  local d="$1" g="$2/old-root" cmd why="" bad
  if [[ ! -f "$d/$DR_PY" ]]; then OLD[77]="skip: no data-root resolver in this render (one from before D50)"; return 0; fi
  if ! cmd="$(drh guardcmd "$d/.claude/settings.json" 2>/dev/null)"; then
    OLD[77]="skip: the seed .claude/settings.json wires no data-root guard (check 57 reports it)"; return 0
  fi
  dr_root "$g"; mkdir -p "$g/business"
  old_hook "$d" "$(drh call Write file_path "$g/business/new.pdf")" sh -c "$cmd"
  bad="$(oldh hook "$d/.smoke-old.out" "$OLD_RC" PreToolUse "$OLD_VER" "$SA_PYTHON_MIN" 1)"
  [[ -z "$bad" ]] || why+=" a Write under a marked root $bad;"
  old_hook "$d" "$(drh call Write file_path "$d/smoke-notes.md")" sh -c "$cmd"
  bad="$(oldh hook "$d/.smoke-old.out" "$OLD_RC" PreToolUse "$OLD_VER" "$SA_PYTHON_MIN" 0)"
  [[ -z "$bad" ]] || why+=" a Write in the project $bad;"
  rm -rf -- "${g:?}"
  old_set 77 "$why"
}

# Check 78: the guide guard, run from the copy's root as check 72 runs it.
old_howto() { # $1 = copy
  local d="$1" g="$SA_HOWTO_GUARD" why="" bad
  if [[ ! -f "$d/$g" ]]; then OLD[78]="skip: no $g (a render made before D56)"; return 0; fi
  old_hook "$d" "$(hg_payload Edit file_path how-to/CONTEXT.md "$d")" bash "$g"
  bad="$(oldh hook "$d/.smoke-old.out" "$OLD_RC" PreToolUse "$OLD_VER" "$SA_PYTHON_MIN" 1)"
  [[ -z "$bad" ]] || why+=" an Edit of how-to/CONTEXT.md $bad;"
  old_hook "$d" "$(hg_payload Edit file_path planning/src/outline.md "$d")" bash "$g"
  bad="$(oldh hook "$d/.smoke-old.out" "$OLD_RC" PreToolUse "$OLD_VER" "$SA_PYTHON_MIN" 0)"
  [[ -z "$bad" ]] || why+=" an Edit of planning/src/outline.md $bad;"
  old_set 78 "$why"
}

# Check 79: the context-threshold hook, on a prompt whose transcript holds no record yet.
old_threshold() { # $1 = copy, $2 = its scratch folder
  local d="$1" h=".claude/hooks/context-threshold-handoff.sh" t="$2/old-transcript.jsonl" why="" bad in
  if [[ ! -f "$d/$h" ]]; then OLD[79]="skip: no $h in this render (one from before D51)"; return 0; fi
  : > "$t"
  in="$(python3 -I -c 'import json, sys; print(json.dumps({"hook_event_name": "UserPromptSubmit", "session_id": "smoke-old", "transcript_path": sys.argv[1], "cwd": sys.argv[2], "prompt": "Carry on."}))' "$t" "$d")"
  old_hook "$d" "$in" bash "$h"
  bad="$(oldh hook "$d/.smoke-old.out" "$OLD_RC" UserPromptSubmit "$OLD_VER" "$SA_PYTHON_MIN" 1)"
  [[ -z "$bad" ]] || why+=" a prompt $bad;"
  rm -f -- "$t"
  old_set 79 "$why"
}

# Check 80: the grammar every Python file the project runs keeps, so an old Python can read it.
old_parse() { # $1 = copy
  local d="$1" why="" f bad
  local -a py=()
  [[ -f "$d/.claude/syntek-author-permissions.py" ]] && py+=(.claude/syntek-author-permissions.py)
  for f in "$d"/tooling/*.py; do [[ -f "$f" ]] && py+=("${f#"$d/"}"); done
  for f in "${py[@]}"; do
    bad="$(oldh parse "$d/$f" 2>&1)"
    [[ -z "$bad" ]] || why+=" $f, $bad;"
  done
  for f in "$d"/.claude/hooks/*.sh; do
    [[ -f "$f" ]] || continue
    bad="$(oldh hookpy "$f" 2>&1)"
    [[ -z "$bad" ]] || why+=" ${f#"$d/"}, $bad;"
  done
  if [[ ${#py[@]} -eq 0 ]] && ! compgen -G "$d/.claude/hooks/*.sh" >/dev/null; then
    OLD[80]="skip: no permissions script, tooling script or hook in this render"; return 0
  fi
  old_set 80 "$why"
}

# Check 81: _common.sh, sourced in a fresh shell, with the older Python as python3 and as UV_PYTHON.
old_pin() {
  local lib="${SMOKE_COMMON:-$SA_SCRIPTS_DIR/_common.sh}" why="" out s label
  for label in python3 UV_PYTHON; do
    s=0
    if [[ "$label" == python3 ]]; then
      out="$(env -u SA_PYTHON_PINNED -u UV_PYTHON PATH="$OLD_BIN:$PATH" SA_ROOT="$SA_ROOT" \
        bash -c 'source "$1" && echo "smoke: sourced"' smoke-pin "$lib" 2>&1)" || s=$?
    else
      out="$(env -u SA_PYTHON_PINNED UV_PYTHON="$OLD_PY" SA_ROOT="$SA_ROOT" \
        bash -c 'source "$1" && echo "smoke: sourced"' smoke-pin "$lib" 2>&1)" || s=$?
    fi
    if [[ $s -ne 2 || "$out" == *"smoke: sourced"* || "$out" != *"Python $OLD_VER"* || "$out" != *"$SA_PYTHON_MIN or later"* ]]; then
      why+=" with $label naming Python $OLD_VER, sourcing it exited $s ($(head -n 1 <<<"$out" | cut -c1-100));"
    fi
  done
  old_set 81 "$why"
}

# ── The handoff hooks (DESIGN.md D29; checks 82–87) ──────────────────────────
#
# The seed's four D29 commands, run as Claude Code runs a command hook, in a scratch Git project
# holding a copy of the render's .claude/hooks/ and .claude/settings.json. HK[n] is check n's
# result: 0, 'skip: why', or the reasons it failed, which make its one finding. The two notes'
# texts are held here exactly as the hook prints them for the person.
HK_PRE=".claude/hooks/pre-compact-handoff.sh"
HK_THRESHOLD=".claude/hooks/context-threshold-handoff.sh"
HK_AUTO_NOTE="Automatic compaction was stopped. Run /handoff to save where you are, then /clear to start a fresh session. If /handoff has no room to run, run /compact yourself (it is allowed), then /handoff."
HK_MANUAL_NOTE="This session was compacted by hand with /compact. That works, but a handoff gives a cleaner break: next time, run /handoff to save where you are, then /clear to start a fresh session."
# A distinctive part of each note's session text (additionalContext): the full-window fallback.
HK_AUTO_CTX="the person may run /compact, which the project allows, and then /handoff"
HK_MANUAL_CTX="the session offers the handoff skill now"
HK_SHELLS=(sh bash)     # checks 86 and 87; Claude Code's own is sh -c (on Linux and macOS)
HK_W="" HK_OUT="" HK_ERR="" HK_TX="" HK_RC=0
declare -A HK=() HK_CMD=()
declare -A HK_WHAT=(
  [82]="an automatic compaction was not blocked with its note relayed once, to its own session"
  [83]="a manual /compact was not let through with its note shown once, at its own session's start"
  [84]="two sessions' compactions did not keep one marker each"
  [85]="a PreCompact auto did not prune stale markers as D29 says"
  [86]="a handoff hook entry was not silent with its script missing"
  [87]="a handoff hook entry was not silent outside a Git repository"
)
declare -A HK_EVENT=([prompt]="UserPromptSubmit" [auto]="PreCompact auto" [manual]="PreCompact manual" [start]="SessionStart compact")
# The helpers, on the current Python:
#   cmds SETTINGS              the four commands, NUL-separated (prompt, auto, manual, start; '' if absent)
#   note OUT EVENT TEXT LABEL [PART]  OUT is one JSON note of EVENT, its systemMessage TEXT ('' = any),
#                                     its additionalContext holding PART (when given)
#   age SECONDS PATH...        each path last modified SECONDS ago (a link itself, never its target)
HK_HELPER='
import json
import os
import sys
import time


def cmds(path):
    want = (("UserPromptSubmit", "", "context-threshold-handoff.sh"), ("PreCompact", "auto", "pre-compact-handoff.sh"),
            ("PreCompact", "manual", "pre-compact-handoff.sh"), ("SessionStart", "compact", "pre-compact-handoff.sh"))
    try:
        hooks = json.load(open(path, encoding="utf-8")).get("hooks")
    except (OSError, ValueError, AttributeError):
        hooks = None
    out = []
    for event, matcher, script in want:
        found = ""
        for entry in (hooks.get(event) if isinstance(hooks, dict) else None) or []:
            if not isinstance(entry, dict) or (entry.get("matcher") or "") != matcher:
                continue
            for h in entry.get("hooks") or []:
                c = h.get("command") if isinstance(h, dict) else None
                if not found and isinstance(c, str) and ".claude/hooks/" + script in c:
                    found = c
        out.append(found)
    sys.stdout.write("\0".join(out) + "\0")


def note(out, event, text, label, part=""):
    lines = open(out, encoding="utf-8", errors="replace").read().splitlines()
    if len(lines) != 1:
        print("printed %d line(s), not the one line of a note" % len(lines))
        return
    try:
        data = json.loads(lines[0])
    except ValueError:
        data = None
    if not isinstance(data, dict):
        print("printed a line that is no JSON object (%r)" % lines[0][:60])
        return
    bad = []
    msg = data.get("systemMessage")
    if text and msg != text:
        m = str(msg)
        i = next((k for k in range(min(len(m), len(text))) if m[k] != text[k]), min(len(m), len(text)))
        bad.append("its systemMessage is not %s (from character %d it reads %r where the note reads %r)"
                   % (label, i + 1, m[i:i + 60], text[i:i + 60]))
    elif not isinstance(msg, str) or not msg.strip():
        bad.append("its systemMessage is empty")
    spec = data.get("hookSpecificOutput")
    if not isinstance(spec, dict) or spec.get("hookEventName") != event:
        bad.append("its hookSpecificOutput.hookEventName is not %s" % event)
    ctx = spec.get("additionalContext") if isinstance(spec, dict) else None
    if not isinstance(ctx, str) or not ctx.strip():
        bad.append("its hookSpecificOutput.additionalContext is empty")
    elif part and part not in ctx:
        bad.append("its hookSpecificOutput.additionalContext lacks %r" % part)
    print(", ".join(bad))


def age(seconds, *paths):
    when = time.time() - float(seconds)
    for p in paths:
        os.utime(p, (when, when), follow_symlinks=not os.path.islink(p))


{"cmds": cmds, "note": note, "age": age}[sys.argv[1]](*sys.argv[2:])
'
hkh() { python3 -I -c "$HK_HELPER" "$@"; }
hk_set() { # $1 = check, $2 = its reasons ('' when it passed)
  local w="${2# }"; w="${w%;}"
  HK[$1]="${w:-0}"
}
hk_json() { local s="${1//\\/\\\\}"; printf '%s' "${s//\"/\\\"}"; } # a JSON string's inside
# One event, its payload written by hand: HK_RC, $HK_OUT and $HK_ERR. The threshold hook's own
# variables are unset, so its measure assumes a 200000-token window and the shipped thresholds.
hk_ev() { # $1 = prompt, auto, manual or start, $2 = folder to run in, $3 = session ('(none)': no key), $4 = shell (sh)
  local kind="$1" dir="$2" sid="$3" sh="${4:-sh}" ev kv in idkv
  case "$kind" in
    prompt) ev=UserPromptSubmit; kv='"prompt": "Carry on."' ;;
    auto)   ev=PreCompact; kv='"trigger": "auto", "custom_instructions": null' ;;
    manual) ev=PreCompact; kv='"trigger": "manual", "custom_instructions": ""' ;;
    start)  ev=SessionStart; kv='"source": "compact"' ;;
  esac
  idkv="\"session_id\": \"$(hk_json "$sid")\", "; [[ "$sid" != "(none)" ]] || idkv=""
  in="{$idkv\"transcript_path\": \"$(hk_json "$HK_TX")\", \"cwd\": \"$(hk_json "$dir")\", \"hook_event_name\": \"$ev\", $kv}"
  HK_RC=0
  (cd "$dir" && env -u CLAUDE_CONTEXT_WINDOW -u CLAUDE_CONTEXT_ADVISE_PCT -u CLAUDE_CONTEXT_INSIST_PCT \
    timeout 60 "$sh" -c "${HK_CMD[$kind]}" <<<"$in") >"$HK_OUT" 2>"$HK_ERR" || HK_RC=$?
}
hk_marks() { # $1 = project → the names in .claude/ that start compaction-marker, sorted, one line
  local f out=""
  for f in "$1"/.claude/compaction-marker*; do [[ -e "$f" || -L "$f" ]] && out+=" ${f##*/}"; done
  printf '%s' "${out# }"
}
hk_snap() { # $1 = project → each marker file's name and bytes, '' when there is none
  local f
  for f in "$1"/.claude/compaction-marker*; do [[ -f "$f" ]] && printf '%s=%s;' "${f##*/}" "$(od -An -c -- "$f" | tr -d ' \n')"; done
  return 0
}
hk_clear() { rm -rf -- "$1"/.claude/compaction-marker*; }
hk_names() { ls -A -- "$1/.claude" 2>/dev/null | paste -sd' ' -; } # $1 = project → the names in .claude/

smoke_hooks() { # $1 = a COPY of a render: checks 82–87
  local d="$1" n c p m
  local -a cmds=()
  HK=(); HK_CMD=()
  if [[ ! -f "$d/$HK_PRE" || ! -f "$d/$HK_THRESHOLD" ]]; then
    for n in {82..87}; do HK[$n]="skip: no $HK_PRE and $HK_THRESHOLD (a render made before D51)"; done; return 0
  fi
  while IFS= read -r -d '' c; do cmds+=("$c"); done < <(hkh cmds "$d/.claude/settings.json" 2>/dev/null || true)
  if [[ ${#cmds[@]} -ne 4 || -z "${cmds[0]}" || -z "${cmds[1]}" || -z "${cmds[2]}" || -z "${cmds[3]}" ]]; then
    for n in {82..87}; do HK[$n]="skip: the seed .claude/settings.json lacks one of the four D29 entries (shipped-seeds checks 12 and 22 report it)"; done
    return 0
  fi
  HK_CMD=([prompt]="${cmds[0]}" [auto]="${cmds[1]}" [manual]="${cmds[2]}" [start]="${cmds[3]}")
  HK_W="$(sa_mktemp)"; HK_OUT="$HK_W/out"; HK_ERR="$HK_W/err"; HK_TX="$HK_W/transcript.jsonl"; : > "$HK_TX"
  for p in "$HK_W/project" "$HK_W/missing"; do
    mkdir -p "$p/.claude" "$p/sub/dir"
    cp -pR -- "$d/.claude/hooks" "$p/.claude/hooks"; cp -p -- "$d/.claude/settings.json" "$p/.claude/settings.json"
    git -C "$p" init -q
  done
  p="$HK_W/project"; m="$HK_W/missing"
  rm -f -- "${m:?}/$HK_PRE" "$m/$HK_THRESHOLD"
  mkdir -p "$HK_W/outside/deep"
  hk_auto "$p" "$p/sub/dir"
  hk_manual "$p" "$p/sub/dir"
  hk_sessions "$p" "$p/sub/dir"
  hk_stale "$p" "$p/sub/dir"
  hk_silent 86 "$m/sub/dir" "with the scripts removed"
  GIT_CEILING_DIRECTORIES="$HK_W" hk_silent 87 "$HK_W/outside/deep" "outside a repository"
  rm -rf -- "${HK_W:?}"
}

# Check 82: an automatic compaction, blocked, its note relayed once to its own session alone.
hk_auto() { # $1 = project, $2 = the subfolder to run from
  local p="$1" s="$2" why="" before bad names sid what
  hk_clear "$p"
  hk_ev auto "$s" smoke-a
  [[ "$HK_RC" == 2 ]] || why+=" PreCompact auto exited $HK_RC, not 2;"
  [[ ! -s "$HK_OUT" ]] || why+=" PreCompact auto printed on stdout;"
  before="$(hk_snap "$p")"
  [[ -n "$before" ]] || why+=" PreCompact auto left no marker in .claude/;"
  hk_ev prompt "$s" smoke-b
  [[ "$HK_RC" == 0 && ! -s "$HK_OUT" ]] || why+=" smoke-b's prompt exited $HK_RC or printed (another session's marker);"
  [[ "$(hk_snap "$p")" == "$before" ]] || why+=" smoke-b's prompt changed smoke-a's marker;"
  # The window past the insist threshold, as when an automatic compaction is stopped: the
  # relayed note must still be the prompt's only output.
  printf '%s\n' '{"type": "assistant", "message": {"usage": {"input_tokens": 160000}}}' > "$HK_TX"
  hk_ev prompt "$s" smoke-a
  : > "$HK_TX"
  [[ "$HK_RC" == 0 ]] || why+=" smoke-a's next prompt exited $HK_RC, not 0;"
  bad="$(hkh note "$HK_OUT" UserPromptSubmit "$HK_AUTO_NOTE" "the automatic note" "$HK_AUTO_CTX" 2>&1)" || true
  [[ -z "$bad" ]] || why+=" smoke-a's next prompt: $bad;"
  [[ -z "$(hk_snap "$p")" ]] || why+=" a marker remains after the note;"
  hk_ev prompt "$s" smoke-a
  [[ ! -s "$HK_OUT" ]] || why+=" a second prompt printed again;"
  # An automatic compaction that went ahead anyway: its SessionStart says nothing, and removes
  # the marker unread, so no prompt relays a note on a compaction that happened.
  hk_ev auto "$s" smoke-a
  hk_ev start "$s" smoke-a
  [[ "$HK_RC" == 0 && ! -s "$HK_OUT" ]] || why+=" smoke-a's SessionStart after a compaction that went ahead exited $HK_RC or printed;"
  [[ -z "$(hk_snap "$p")" ]] || why+=" smoke-a's SessionStart after a compaction that went ahead left its marker;"
  hk_ev prompt "$s" smoke-a
  [[ ! -s "$HK_OUT" ]] || why+=" smoke-a's prompt after that SessionStart printed;"
  # No session id: still blocked and reminded; no marker is written, read or removed.
  names="$(hk_names "$p")"
  for sid in "(none)" "/./.."; do
    what="no session id"; [[ "$sid" == "(none)" ]] || what="the session id '$sid'"
    hk_ev auto "$s" "$sid"
    [[ "$HK_RC" == 2 && -s "$HK_ERR" ]] || why+=" PreCompact auto with $what exited $HK_RC, not 2 with its reminder;"
    [[ "$(hk_names "$p")" == "$names" ]] || why+=" PreCompact auto with $what left a new name in .claude/;"
  done
  hk_set 82 "$why"
}

# Check 83: a manual /compact, let through, its note shown once at its own session's start.
hk_manual() { # $1 = project, $2 = the subfolder to run from
  local p="$1" s="$2" why="" before bad names
  hk_clear "$p"
  hk_ev manual "$s" smoke-m
  [[ "$HK_RC" == 0 ]] || why+=" PreCompact manual exited $HK_RC, not 0;"
  [[ ! -s "$HK_OUT" ]] || why+=" PreCompact manual printed on stdout;"
  before="$(hk_snap "$p")"
  [[ -n "$before" ]] || why+=" PreCompact manual left no marker in .claude/;"
  hk_ev prompt "$s" smoke-m
  [[ "$HK_RC" == 0 && ! -s "$HK_OUT" ]] || why+=" smoke-m's prompt exited $HK_RC or printed before the compaction ended;"
  [[ "$(hk_snap "$p")" == "$before" ]] || why+=" smoke-m's prompt changed its marker;"
  hk_ev start "$s" smoke-m
  [[ "$HK_RC" == 0 ]] || why+=" smoke-m's SessionStart exited $HK_RC, not 0;"
  bad="$(hkh note "$HK_OUT" SessionStart "$HK_MANUAL_NOTE" "the manual note" "$HK_MANUAL_CTX" 2>&1)" || true
  [[ -z "$bad" ]] || why+=" smoke-m's SessionStart: $bad;"
  [[ -z "$(hk_snap "$p")" ]] || why+=" a marker remains after the note;"
  hk_ev start "$s" smoke-m
  [[ ! -s "$HK_OUT" ]] || why+=" a second SessionStart printed again;"
  names="$(hk_names "$p")"
  hk_ev manual "$s" "(none)"
  [[ "$HK_RC" == 0 ]] || why+=" PreCompact manual with no session id exited $HK_RC, not 0;"
  [[ "$(hk_names "$p")" == "$names" ]] || why+=" PreCompact manual with no session id left a new name in .claude/;"
  hk_set 83 "$why"
}

# Check 84: two sessions, one marker each; neither touches the other's.
hk_sessions() { # $1 = project, $2 = the subfolder to run from
  local p="$1" s="$2" why="" marks bad keep="$HK_W/smoke-a.keep"
  local a=".claude/compaction-marker-smoke-a.tmp" b=".claude/compaction-marker-smoke-b.tmp"
  hk_clear "$p"; rm -f -- "$keep"
  hk_ev auto "$s" smoke-a
  hk_ev manual "$s" smoke-b
  marks="$(hk_marks "$p")"
  [[ "$marks" == "${a#.claude/} ${b#.claude/}" ]] \
    || why+=" an auto in smoke-a and a manual in smoke-b left ${marks:-no marker}, not $a and $b;"
  [[ ! -f "$p/$a" ]] || cp -p -- "$p/$a" "$keep"
  hk_ev start "$s" smoke-b
  bad="$(hkh note "$HK_OUT" SessionStart "" "a note" 2>&1)" || true
  [[ -z "$bad" ]] || why+=" smoke-b's SessionStart: $bad;"
  if [[ ! -f "$keep" ]] || ! cmp -s -- "$keep" "$p/$a"; then why+=" smoke-a's marker was not there byte for byte after smoke-b's SessionStart;"; fi
  hk_ev prompt "$s" smoke-a
  bad="$(hkh note "$HK_OUT" UserPromptSubmit "" "a note" 2>&1)" || true
  [[ -z "$bad" ]] || why+=" smoke-a's next prompt: $bad;"
  # The id in the name is reduced to letters, digits and hyphens.
  hk_clear "$p"
  hk_ev auto "$s" "smoke.r/"
  marks="$(hk_marks "$p")"
  [[ "$marks" == "compaction-marker-smoker.tmp" ]] \
    || why+=" an auto in session 'smoke.r/' left ${marks:-no marker}, not .claude/compaction-marker-smoker.tmp;"
  hk_clear "$p"
  hk_set 84 "$why"
}

# Check 85: the prune of other sessions' markers, older than seven days, never through a link.
hk_stale() { # $1 = project, $2 = the subfolder to run from
  local p="$1" s="$2" why="" t="$HK_W/link-target"
  local old="$p/.claude/compaction-marker-smoke-old.tmp" new="$p/.claude/compaction-marker-smoke-new.tmp"
  local link="$p/.claude/compaction-marker-smoke-link.tmp"
  hk_clear "$p"
  printf 'auto smoke-old\n' > "$old"; printf 'auto smoke-new\n' > "$new"; printf 'target\n' > "$t"
  ln -s -- "$t" "$link"
  if ! hkh age 691200 "$old" || ! hkh age 3600 "$new" || ! hkh age 2592000 "$t" "$link"; then
    HK[85]="skip: this system cannot set a file's or a link's modification time"; rm -f -- "$t"; hk_clear "$p"; return 0
  fi
  hk_ev auto "$s" smoke-p
  [[ ! -e "$old" ]] || why+=" a PreCompact auto kept another session's marker last modified eight days ago;"
  [[ -f "$new" && "$(cat -- "$new")" == "auto smoke-new" ]] || why+=" a PreCompact auto removed or changed a third session's marker last modified an hour ago;"
  [[ -L "$link" ]] || why+=" a PreCompact auto removed a link named like a marker;"
  hk_ev auto "$s" smoke-link
  [[ -L "$link" ]] || why+=" a PreCompact auto of the session the link is named for removed it;"
  [[ "$(cat -- "$t" 2>/dev/null)" == target ]] || why+=" a PreCompact auto wrote through a link named like its marker;"
  rm -f -- "$t"; hk_clear "$p"
  hk_set 85 "$why"
}

# Checks 86 and 87: each of the four commands, under each shell, exits 0 and prints nothing.
hk_silent() { # $1 = check, $2 = folder to run from, $3 = where, for the finding
  local n="$1" dir="$2" where="$3" why="" sh k err out
  for sh in "${HK_SHELLS[@]}"; do
    for k in prompt auto manual start; do
      hk_ev "$k" "$dir" smoke-x "$sh"
      [[ "$HK_RC" == 0 && ! -s "$HK_OUT" && ! -s "$HK_ERR" ]] && continue
      err="$(head -n 1 -- "$HK_ERR" | cut -c1-80)"; out=""
      [[ ! -s "$HK_OUT" ]] || out=", printing on stdout"
      why+=" ${HK_EVENT[$k]} under $sh -c $where exited $HK_RC$out${err:+, saying '$err' on stderr};"
    done
  done
  hk_set "$n" "$why"
}

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
  case "${CMP[tex]:-skip: not run}" in
    skip:*) r="${CMP[tex]:-skip: not run}"; SKIPS+=("compare FORMAT=tex (${r#skip: })") ;;
    0) ;;
    *) finding "check 33 — [$NAME] make compare FORMAT=tex UNIT=$CMP_UNIT over a planted multi-round chain did not write its LaTeX with every actor's macro (${CMP[tex]}) — see .smoke-compare-tex.log" ;;
  esac
  case "${CMP[ignored]:-skip: not run}" in
    skip:*) r="${CMP[ignored]:-skip: not run}"; SKIPS+=("compare ignore check (${r#skip: })") ;;
    0) ;;
    leak)  finding "check 34 — [$NAME] make compare printed a git-ignored ledger entry's words (DESIGN.md D42) — see build/compare/$CMP_UNIT/ and .smoke-compare-tex.log" ;;
    *)     finding "check 34 — [$NAME] make compare did not print the tracked entry's words either, so the git-ignore proof could not run — see build/compare/$CMP_UNIT/$CMP_UNIT.tex" ;;
  esac
  case "${CMP[section]:-skip: not run}" in
    skip:*) r="${CMP[section]:-skip: not run}"; SKIPS+=("compare SECTION without UNIT (${r#skip: })") ;;
    0) ;;
    *) finding "check 35 — [$NAME] make compare SECTION=x without UNIT was not refused before any output (${CMP[section]}) — see .smoke-compare-section.log" ;;
  esac
  case "${CMP[empty]:-skip: not run}" in
    skip:*) r="${CMP[empty]:-skip: not run}"; SKIPS+=("compare with no entries (${r#skip: })") ;;
    0) ;;
    *) finding "check 36 — [$NAME] make compare with no ledger entries did not say 'No sections to compare yet.' and exit 0 (${CMP[empty]}) — see .smoke-compare-empty.log" ;;
  esac
  case "${CMP[pdf]:-skip: not run}" in
    skip:*) r="${CMP[pdf]:-skip: not run}"; SKIPS+=("compare PDF (${r#skip: })") ;;
    0) ;;
    *) err="$(grep -v '^[[:space:]]*$' "$(dirname "$BUILD_DIR")/.smoke-compare-pdf.log" 2>/dev/null | tail -1 || true)"
       finding "check 37 — [$NAME] make compare UNIT=$CMP_UNIT did not write build/compare/$CMP_UNIT.pdf (${CMP[pdf]}): ${err:0:100}" ;;
  esac
  case "${STE[skip]:-}" in
    skip:*) SKIPS+=("STE list steps (${STE[skip]#skip: })") ;;
    *)
      if [[ "${STE[status]:-?}" != 0 ]]; then
        finding "check 38 — [$NAME] make lint failed (exit ${STE[status]:-?}) on a file with list steps — see .smoke-ste.log"
      else
        r=""
        [[ "${STE[long]:-false}" == true ]] || r+=" the 24-word step in library/src/ was not listed;"
        [[ "${STE[short]:-false}" == false ]] || r+=" the 3-word step was listed;"
        [[ "${STE[legal]:-false}" != true ]] || r+=" the step in library/src/legal/ was listed;"
        [[ -z "$r" ]] || finding "check 38 — [$NAME] make lint did not report list steps over 20 words as D46 says:${r%;} — see .smoke-ste.log"
      fi
      case "${STE[legal]:-}" in skip:*) SKIPS+=("STE legal exclusion (${STE[legal]#skip: })") ;; esac ;;
  esac
  case "${HT[skip]:-}" in
    skip:*) SKIPS+=("user guide (${HT[skip]#skip: })") ;;
    *)
      for t in lint flags; do
        r="${HT[$t]:-skip: not run}"
        case "$r" in
          skip:*) SKIPS+=("make $t SCOPE=how-to/src (${r#skip: })") ;;
          0) ;;
          *) err="$(grep -v -e '^[[:space:]]*$' -e ': 0$' "$(dirname "$BUILD_DIR")/.smoke-howto-$t.log" 2>/dev/null | head -2 | paste -sd' ' - || true)"
             finding "check 70 — [$NAME] make $t SCOPE=how-to/src STRICT=1 failed (exit $r) over the user guide's chapters: ${err:0:120} — see .smoke-howto-$t.log" ;;
        esac
      done
      case "${HT[plant]:-}" in
        skip:*) SKIPS+=("planted chapter line (${HT[plant]#skip: })") ;;
        *)
          r=""
          [[ "${HT[unscoped]:-}" == unseen ]] || r+=" make lint without a SCOPE ${HT[unscoped]/seen/reported it};"
          [[ "${HT[scoped]:-}" == seen ]] || r+=" make lint SCOPE=how-to/src ${HT[scoped]/unseen/did not report it};"
          [[ -z "$r" ]] || finding "check 71 — [$NAME] a line holding two sentences planted in $HOWTO_CHAPTER:${r%;} — without a SCOPE neither target reads how-to/src (DESIGN.md D56); see .smoke-howto-lint-*.log" ;;
      esac ;;
  esac
  case "${HG[result]:-skip: not run}" in
    skip:*) r="${HG[result]:-skip: not run}"; SKIPS+=("guide guard (${r#skip: })") ;;
    0) ;;
    *) finding "check 72 — [$NAME] the guide guard (.claude/hooks/how-to-read-only.sh) failed: ${HG[result]:0:400}" ;;
  esac
  case "${HG[case7]:-}" in skip:*) SKIPS+=("guide guard, another letter case (${HG[case7]#skip: })") ;; esac
  for n in {39..69}; do
    r="${DR[$n]:-skip: not run}"
    case "$r" in
      skip:*) SKIPS+=("check $n (${r#skip: })") ;;
      0) ;;
      *) finding "check $n — [$NAME] ${DR_WHAT[$n]}: $r — see .smoke-dr*" ;;
    esac
  done
  for n in {73..81}; do
    r="${OLD[$n]:-skip: not run}"
    case "$r" in
      skip:*) SKIPS+=("check $n (${r#skip: })") ;;
      0) ;;
      *) if [[ "$n" == 80 ]]; then finding "check 80 — [$NAME] ${OLD_WHAT[80]}: $r"
         else finding "check $n — [$NAME] ${OLD_WHAT[$n]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): $r — see .smoke-old*"; fi ;;
    esac
  done
  for n in {82..87}; do
    r="${HK[$n]:-skip: not run}"
    case "$r" in
      skip:*) SKIPS+=("check $n (${r#skip: })") ;;
      0) ;;
      *) finding "check $n — [$NAME] ${HK_WHAT[$n]}: $r" ;;
    esac
  done
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

# Checks 73–81's fixture text. A stand-in Python script's version gate, as the decision of
# 23/10/2026 asks of every tool: OLD, and refuse(name), which says it did not run, on stderr.
old_gate_py() {
  printf '%s\n' 'import os' 'import sys' "MIN = tuple(int(x) for x in \"$SA_PYTHON_MIN\".split(\".\"))" \
    'OLD = sys.version_info[:2] < MIN' '' '' 'def refuse(name):' \
    '    sys.stderr.write("%s did NOT run: this is Python %d.%d, and it needs Python %d.%d or later. Upgrade to Python %d.%d.\n"' \
    '                     % ((name,) + tuple(sys.version_info[:2]) + MIN + MIN))' '    sys.exit(2)' '' ''
}
# A stand-in hook's answer to an older python3: the warning as its JSON, exit 0. $1 = the hook's
# name, $2 = its event, $3 = the SMOKE_OLD fault that makes it block (exit 2) or say nothing.
old_hook_prelude() {
  local tuple="(${SA_PYTHON_MIN%%.*}, ${SA_PYTHON_MIN#*.})"
  printf '%s\n' "# tooling-smoke.sh self-test: an older python3, answered as checks 77–79 require." \
    "if command -v python3 >/dev/null 2>&1 && _v=\$(python3 -c 'import sys; v = sys.version_info[:2]; sys.exit(1) if v >= $tuple else print(\"%d.%d\" % v)' 2>/dev/null); then" \
    '  cat >/dev/null' \
    "  case \"\${SMOKE_OLD:-}\" in $3) [ \"$3\" = threshold-silent ] && exit 0; echo 'refused' >&2; exit 2 ;; esac" \
    "  _m=\"$1 did NOT work: this is Python \$_v, and it needs Python $SA_PYTHON_MIN or later. Upgrade to Python $SA_PYTHON_MIN.\"" \
    "  printf '{\"systemMessage\": \"%s\", \"hookSpecificOutput\": {\"hookEventName\": \"$2\", \"additionalContext\": \"%s\"}}\\n' \"\$_m\" \"\$_m\"" \
    '  exit 0' 'fi'
}

write_fixture() { # $1 = dir, $2 = DATA_STORE (external by default), $3 = DOC_TYPE (fiction)
  local d="$1" store="${2:-external}" doc="${3:-fiction}"
  mkdir -p "$d/world/src/languages/example-tongue" "$d/manuscript/src/$EXAMPLE_UNIT" "$d/typeset/src/units" "$d/tooling"
  git -C "$d" init -q
  { printf 'import os, sys  # --self-test\n'; old_gate_py; printf '%s\n' 'if OLD:' \
      '    if os.environ.get("SMOKE_OLD") == "tool-traceback":' '        raise RuntimeError("the fault: no version gate")' \
      '    refuse("tooling/demo.py")' 'sys.exit(1 if os.environ.get("SMOKE_FAIL") == "demo" else 0)'; } > "$d/tooling/demo.py"
  { old_gate_py; printf '%s\n' 'if OLD:' '    refuse("tooling/smoke_provenance.py")' 'print("provenance: nothing recorded yet")'; } > "$d/tooling/smoke_provenance.py"
  printf '[meta]\nslug = "example-tongue"\n' > "$d/world/src/languages/example-tongue/lexicon.toml"
  mkdir -p "$d/world/src/languages/example-tongue/script"
  printf '[meta]\n' > "$d/world/src/languages/example-tongue/script/glyphs.toml"
  printf '# The ford\n\nThe ford ran low.\n' > "$d/manuscript/src/$EXAMPLE_UNIT/$EXAMPLE_UNIT.md"
  # The user guide (checks 70–72): a chapter, and the real guide guard from template/.
  mkdir -p "$d/$(dirname "$HOWTO_CHAPTER")" "$d/.claude/hooks"
  printf '# Overview — what a project is\n\nThe guide explains the project.\n\n## Where the rules live\n\n- The rules: `.claude/rules/`.\n' > "$d/$HOWTO_CHAPTER"
  { head -n 1 "$SA_ROOT/template/$SA_HOWTO_GUARD"; old_hook_prelude "The guide guard" PreToolUse howto-blocks
    tail -n +2 "$SA_ROOT/template/$SA_HOWTO_GUARD"; } > "$d/$SA_HOWTO_GUARD"; chmod +x "$d/$SA_HOWTO_GUARD"
  # Checks 73–87: the real handoff hooks from template/, the threshold hook behind the prelude
  # that answers an older Python as checks 79 and 80 require (a current one passes straight
  # through, as checks 82–87 need), and a stand-in permissions script.
  cp -- "$SA_ROOT/template/$HK_PRE" "$d/$HK_PRE"; chmod +x "$d/$HK_PRE"
  { head -n 1 "$SA_ROOT/template/$HK_THRESHOLD"; old_hook_prelude "The context-threshold hook" UserPromptSubmit threshold-silent
    tail -n +2 "$SA_ROOT/template/$HK_THRESHOLD"; } > "$d/$HK_THRESHOLD"; chmod +x "$d/$HK_THRESHOLD"
  { old_gate_py; printf '%s\n' 'if OLD and os.environ.get("SMOKE_OLD") != "perm-runs":' '    refuse(".claude/syntek-author-permissions.py")' \
      'print("plan: every client file already holds every rule")'; } > "$d/.claude/syntek-author-permissions.py"
  # The stand-in lint: 'organize' and two sentences on a line in the files named, and, in a
  # business render under a SCOPE, an em dash outside a heading; STRICT=1 fails on any finding.
  cat > "$d/tooling/smoke-lint.sh" <<'LINT'
leak=$1 strict=$2 scoped=$3
shift 3
[ "$#" -gt 0 ] || { echo "lint: nothing to check"; exit 0; }
total=0
for f in $(find "$@" -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md -print 2>/dev/null | LC_ALL=C sort); do
  if [ -z "$leak" ] && git check-ignore -q "$f" 2>/dev/null; then continue; fi
  hits=$(grep -nH -e organize -e '[^[:space:].][.!?][[:space:]][[:space:]]*[[:upper:]]' "$f")
  if [ -n "$scoped" ] && [ -d library ]; then
    hits="$hits
$(grep -nH '—' "$f" | grep -v '^[^:]*:[0-9]*:#')"
  fi
  hits=$(printf '%s\n' "$hits" | grep . || true)
  [ -z "$hits" ] || { printf '%s\n' "$hits"; total=$((total + $(printf '%s\n' "$hits" | wc -l))); }
done
[ -z "$strict" ] || [ "$total" -eq 0 ]
LINT
  write_dataroot_fixture "$d" "$doc" "$store"
  printf 'STORE = %s\n' "$store" > "$d/Makefile"
  cat >> "$d/Makefile" <<'EOF'
-include tooling/project.mk
BRAND_DIRS ?= standards/brand
DR = python3 .claude/syntek-author-dataroot.py
TEX_DIR = $(shell $(DR) path '$(patsubst %/,%,$(dir $(FILE)))' 2>/dev/null)
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
	@[ -z "$(STRICT)" ] || [ -z "$(SCOPE)" ] || ! grep -rqE 'VERIFY:|fillme' $(SCOPE)
WORK_DIRS := $(if $(WORK_ALL),$(wildcard */src),$(filter-out how-to/src,$(wildcard */src)))
lint:
	@[ -z "$(LINT_NEEDS_ROOT)" ] || [ -z "$${SYNTEK_DATA_ROOT+set}" ] || { echo "lint failing on purpose: it reads the data root"; exit 1; }
	@sh tooling/smoke-lint.sh '$(LEAK_LINT)' '$(STRICT)' '$(if $(SCOPE),1)' $(if $(SCOPE),$(SCOPE),$(WORK_DIRS))
	@[ ! -d library/src ] || { echo "List steps over 20 words (ASD-STE100; a hint for technical text only):"; \
	  [ -n "$(STE_BLIND)" ] || find library/src -name '*.md' | LC_ALL=C sort | while read -r f; do \
	    case "$$f" in library/src/legal/*) [ -n "$(STE_LEGAL)" ] || continue ;; esac; \
	    awk -v max=$(if $(STE_ALL),2,20) '/^[0-9]+\. / && NF - 1 > max { print "  " FILENAME ":" FNR ":" $$0 }' "$$f"; done; }
provenance:
	$(fail)
	@python3 tooling/smoke_provenance.py$(if $(OLD_SWALLOW), || true)
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
	@if [ -n "$(ISSUE)" ] && [ "$(STORE)" = external ]; then \
	  dest=$$($(DR) path '$(basename $(FILE)).pdf') || { \
	    if [ -n "$(NOROOT_BESIDE)" ]; then echo beside > '$(basename $(FILE)).pdf'; exit 0; fi; \
	    echo "error: ISSUE=1 files the issued copy under the data root, and it cannot be used"; exit 2; }; \
	  if [ -e "$$dest" ] && [ -z "$(FORCE)$(DR_CLOBBER)" ]; then echo "error: $$dest is issued; FORCE=1 files a new copy"; exit 1; fi; fi
	@echo x > build/manuscript__src.pdf
	@[ -z "$(FILE)" ] || echo "built $$(date +%s) $(FORCE)" > 'build/$(subst /,__,$(basename $(FILE))).pdf'
	$(if $(SMOKE_TEX_STUB),@case '$(FILE)' in (*.tex) mkdir -p build/latex; $(if $(TEX_UNQUOTED),TEXINPUTS="$(TEX_DIR):",TEXINPUTS='$(TEX_DIR):') xelatex -output-directory=build/latex -jobname=smoke '$(FILE)' ;; esac)
	@if [ -n "$(FILE)" ] && grep -q 'houseclassification{' '$(FILE)'; then \
	  [ -z "$(FAIL_CLASS)" ] || { echo "failing on the classification"; exit 1; }; \
	  if [ -n "$(HEADLESS)" ]; then printf 'body\fbody\f'; \
	  else printf 'SMOKE-CLASSIFIED body SMOKE-CLASSIFIED\fSMOKE-CLASSIFIED body SMOKE-CLASSIFIED\f'; fi \
	    > 'build/$(subst /,__,$(basename $(FILE))).pdf'; fi
	@if [ -n "$(ISSUE)" ] && [ "$(STORE)" = repo ]; then t="$(basename $(FILE)).pdf"; \
	  if [ -n "$(STUBBORN)" ] || { [ -e "$$t" ] && [ -z "$(FORCE)$(CLOBBER)" ]; }; then echo "error: $$t is issued; FORCE=1 replaces it"; exit 1; fi; \
	  echo rebuilt > "$$t"; fi
	@if [ -n "$(ISSUE)" ] && [ "$(STORE)" = external ]; then \
	  $(DR) add 'build/$(subst /,__,$(basename $(FILE))).pdf' --role issued --source '$(FILE)' \
	    --as '$(if $(and $(ISSUE_WRONG_AS),$(if $(FORCE),,1)),$(dir $(FILE))misfiled.pdf,$(basename $(FILE)).pdf)'$(if $(and $(FORCE),$(if $(FORCE_DROPPED),,1)), --force); fi
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
compare: | build/.gitignore
	@test -z "$(SECTION)" || test -n "$(UNIT)" || test -n "$(LAX_SECTION)" || { echo "error: SECTION= needs its unit: make compare UNIT=<unit> SECTION=<slug>"; exit 2; }
	@units='$(UNIT)'; \
	[ -n "$$units" ] || units=$$(for f in standards/style/ledger/*--*.md; do [ -f "$$f" ] && basename "$$f" | sed 's/--.*//'; done | sort -u); \
	if [ -z "$$units" ]; then [ -z "$(LOUD_EMPTY)" ] || { echo "error: no units"; exit 1; }; echo "No sections to compare yet."; exit 0; fi; \
	for u in $$units; do \
	  if [ -n "$(FAIL_CMP_TEX)" ] && [ '$(FORMAT)' = tex ]; then echo "failing compare on purpose"; exit 1; fi; \
	  mkdir -p build/compare/$$u; t=build/compare/$$u/$$u.tex; \
	  if [ -n "$(CMP_NOTEX)" ] && [ '$(FORMAT)' = tex ]; then continue; fi; \
	  { printf '%s\n' '\documentclass{article}' '\begin{document}'; \
	    for f in standards/style/ledger/$$u--*.md; do [ -f "$$f" ] || continue; \
	      if [ -z "$(LEAK_COMPARE)" ] && git check-ignore -q "$$f" 2>/dev/null; then continue; fi; \
	      cat "$$f"; \
	      if grep -q ' · ai · ' "$$f"; then printf '%s\n' '\cmpaiins{x}'; fi; \
	      if grep -q ' · author-note · ' "$$f" && [ -z "$(CMP_BLIND_NOTE)" ]; then printf '%s\n' '\cmpnoteins{x}'; fi; \
	      if grep -q ' · author · ' "$$f"; then printf '%s\n' '\cmpauthordel{x}'; fi; \
	    done; printf '%s\n' '\end{document}'; } > $$t; \
	  if [ '$(FORMAT)' = tex ]; then echo "wrote $$t"; continue; fi; \
	  [ -n "$(CMP_NOPDF)" ] || echo x > build/compare/$$u.pdf; \
	done
root:
	@$(DR) root $(if $(ROOT_PROVIDER_WRONG),| sed 's/^provider: .*/provider: smoke-wrong/')
files-add:
	@test -n "$(FILE)" || { echo "error: name the file"; exit 2; }
	@test -n "$(ROLE)" || { echo "error: name its role"; exit 2; }
	@$(DR) add '$(FILE)' --role '$(ROLE)'$(if $(if $(AS_BUILTIN),$(AS),$(if $(AS_ENV),$(filter-out default,$(origin AS)),$(and $(filter command line,$(origin AS)),$(AS)))), --as '$(AS)')$(if $(FORCE), --force)
EOF
}

# The data-root half of a fixture render: the real resolver behind a stand-in of the same name
# (DR_SHIM), a map, the answers, the ignore files of DATA_STORE external and the seed's guard.
write_dataroot_fixture() { # $1 = dir, $2 = DOC_TYPE, $3 = DATA_STORE
  local d="$1" doc="$2" store="$3"
  mkdir -p "$d/.claude" "$d/research/src" "$d/world/src"
  # The real resolver, compiled once per self-test: a probe calls it about a hundred times.
  if [[ ! -f "${DR_PYC:-}" ]]; then
    DR_PYC="$(dirname "$d")/dr-real.pyc"
    python3 -I -c 'import py_compile, sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)' \
      "$SA_ROOT/template/$DR_PY" "$DR_PYC" || die "the self-test could not compile template/$DR_PY"
  fi
  cp -- "$DR_PYC" "$d/.claude/.smoke-real-dataroot.pyc"
  printf '%s' "${DR_SHIM//@PYTHON_MIN@/$SA_PYTHON_MIN}" > "$d/$DR_PY"
  printf '%s\n' '{"format": 1, "folders": [{"path": "library/src", "kind": "docs"}, {"path": "research/src"}, {"path": "world/src"}]}' \
    > "$d/$SA_DATAROOT_MAP"
  { printf 'DOC_TYPE: %s\nDATA_STORE: %s\n' "$doc" "$store"
    [[ "$store" != external ]] || printf '%s\n' 'DATA_AREA: business' 'DATA_SLUG: smoke-fixture' 'DATA_KIND_DOCS: docs' \
      'DATA_KIND_PHOTOS: photos' 'DATA_KIND_AUDIO: audio' 'DATA_KIND_VIDEOS: videos'
    printf 'DATA_PROVIDER: none\n'; } > "$d/$SA_ANSWERS_FILE"
  [[ "$store" != external ]] || printf '%s\n' '*.pdf' '*.mp3' '*.png' '*.syntek-tmp' '!external.toml' > "$d/research/src/.gitignore"
  printf 'languages/*/audio/\n' > "$d/world/src/.gitignore"
  # The seed's hooks: the two guards, and the four D29 entries as migrations/family-refresh.json
  # offers them (checks 82–87), which shipped-seeds holds equal to the seed's.
  python3 -I -c 'import json, sys
hooks = {"PreToolUse": [{"matcher": sys.argv[1], "hooks": [
    {"type": "command", "command": sys.argv[2], "timeout": int(sys.argv[3])}]},
    {"matcher": sys.argv[4], "hooks": [{"type": "command", "command": sys.argv[5], "timeout": 10}]}]}
offered = json.load(open(sys.argv[6], encoding="utf-8"))["settings"]["hooks"]
for event in ("PreCompact", "SessionStart", "UserPromptSubmit"):
    hooks[event] = offered[event]
print(json.dumps({"hooks": hooks}, indent=2))' \
    "$SA_GUARD_MATCHER" "$SA_GUARD_CMD" "$SA_GUARD_TIMEOUT" "$SA_HOWTO_GUARD_MATCHER" "$SA_HOWTO_GUARD_CMD" \
    "$SA_ROOT/migrations/family-refresh.json" > "$d/.claude/settings.json"
}

# The stand-in resolver. Unswitched, it runs the real one in this process, so the guard's own
# project lookup and an unimportable tomllib reach it unchanged; SMOKE_DR names one misbehaviour,
# each of which exactly one check exists to catch. It parses as Python 3.8, as the real one must.
DR_SHIM='"""tooling-smoke.sh self-test: the real data-root resolver, with one switchable fault."""
import json
import os
import runpy
import subprocess
import sys

REAL = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".smoke-real-dataroot.pyc")
MUT = os.environ.get("SMOKE_DR", "")
ARGS = sys.argv[1:]
CMD = ARGS[0] if ARGS else ""
MIN = tuple(int(x) for x in "@PYTHON_MIN@".split("."))
if sys.version_info[:2] < MIN:  # checks 73, 74 and 77: an older Python, answered before anything else
    SAYS = ("The data-root resolver did NOT %s: this is Python %d.%d, and it needs Python %d.%d or later. "
            "Upgrade to Python %d.%d." % (("work" if CMD == "guard" else "run",) + tuple(sys.version_info[:2]) + MIN + MIN))
    OLDMUT = os.environ.get("SMOKE_OLD", "")
    if CMD == "guard":
        sys.stdin.read()
        if OLDMUT == "old-guard-blocks":
            sys.stderr.write("blocked\n")
            sys.exit(2)
        sys.stdout.write(json.dumps({"systemMessage": SAYS, "hookSpecificOutput": {
            "hookEventName": "PreToolUse", "additionalContext": SAYS}}) + "\n")
        sys.exit(0)
    (sys.stdout if OLDMUT == "old-stdout" else sys.stderr).write(SAYS + "\n")
    sys.exit(2)
if MUT == "eager-tomllib":
    import tomllib  # noqa: F401  the fault: the guard path needs a module old Pythons lack


def done(code, out="", err=""):
    sys.stdout.write(out)
    sys.stderr.write(err)
    sys.exit(code)


def answer(key):
    with open(".copier-answers.syntek-author.yml", encoding="utf-8") as f:
        for line in f:
            if line.startswith(key + ":"):
                return line.split(":", 1)[1].strip()
    return ""


def manifests():
    for here, dirs, files in os.walk("."):
        dirs[:] = [x for x in dirs if x != ".git"]
        if "external.toml" in files:
            yield os.path.join(here, "external.toml")


def strip(pattern):
    """Every manifest without the lines a fault drops, as a resolver that rewrote it would."""
    import re
    for m in manifests():
        with open(m, encoding="utf-8", newline="") as f:
            lines = f.readlines()
        kept = [x for x in lines if not re.match(pattern, x)]
        if kept != lines:
            with open(m, "w", encoding="utf-8", newline="") as f:
                f.writelines(kept)


A9 = ("psd", "bmp", "dng", "exr", "aac", "aif", "aiff", "opus", "pcm",
      "webm", "mxf", "m4v", "mts", "m2ts", "avi", "braw", "r3d")
FINDS = ("changed:", "missing:", "unlisted:", "committed:", "orphaned:", "not filed:")


if "tomllib" in sys.modules and sys.modules["tomllib"] is None:
    MUT = ""  # check 58 blocks tomllib in this process: no fault may move the call out of it
if CMD == "guard" and MUT in ("guard-no-link", "guard-bad-input"):
    data = sys.stdin.read()
    if MUT == "guard-no-link" and "smoke-link-into-root" in data:
        done(0)
    if MUT == "guard-bad-input":
        try:
            json.loads(data)
        except ValueError:
            done(2, "", "refused\n")
    done(subprocess.run([sys.executable, REAL, "guard"], input=data, text=True).returncode)
if MUT in ("", "eager-tomllib") or MUT.startswith("guard-"):
    sys.argv = [REAL] + ARGS
    runpy.run_path(REAL, run_name="__main__")
    sys.exit(0)

saved = {}
if MUT == "rows-ignored":  # the fault: a resolver blind to "rows": "none" on a folder entry
    import glob
    for m in glob.glob(os.path.join(".claude", "syntek-*-dataroot.json")):
        with open(m, encoding="utf-8") as f:
            text = f.read()
        data = json.loads(text)
        if any(isinstance(e, dict) and "rows" in e for e in data.get("folders", [])):
            saved[m] = text
            data["folders"] = [{k: v for k, v in e.items() if k != "rows"} for e in data["folders"]]
            with open(m, "w", encoding="utf-8") as f:
                json.dump(data, f)
r = subprocess.run([sys.executable, REAL] + ARGS, capture_output=True, text=True)
for m, text in saved.items():
    with open(m, "w", encoding="utf-8") as f:
        f.write(text)
code, out, err = r.returncode, r.stdout, r.stderr
root = os.environ.get("SYNTEK_DATA_ROOT", "")
if MUT == "lenient-root" and code == 2 and "holds no .syntek-data-root marker" in err:
    done(0)
if MUT == "repo-shortcut" and CMD in ("path", "add") and code == 2 and answer("DATA_STORE") == "repo" and (
        "inside a data root" in err or "inside this repository" in err or "holds this repository" in err):
    done(0, ARGS[1] + "\n" if CMD == "path" else "not filed: the fault: a shortcut taken over the root\n")
if MUT == "writes-on-refusal" and CMD == "add" and code == 2 and "holds no .syntek-data-root marker" in err:
    with open(os.path.join(root, "smoke-written.pdf"), "w") as f:
        f.write("written\n")
if MUT.startswith("verify-blind-") and CMD == "verify":  # blind to one kind of finding in a map folder
    out = "".join(x for x in out.splitlines(True)
                  if not (x.startswith(MUT[13:] + ":") and "outside every map folder" not in x))
    if code == 1 and not any(x.startswith(FINDS) for x in out.splitlines()):
        code = 0
if MUT == "status-blind" and CMD == "status":
    out = "".join(x for x in out.splitlines(True) if not x.startswith("not filed:"))
    code = 0 if code == 1 and "unlisted:" not in out else code
if MUT == "names-lenient" and CMD == "check-names" and any(os.path.basename(a).startswith("CON.") for a in ARGS[1:]):
    done(0, "check-names: 1 checked, 0 unsafe\n")
if MUT == "case-creates" and CMD == "add" and code == 2 and "differs only in case" in err:
    os.makedirs(os.path.join(root, answer("DATA_AREA")), exist_ok=True)
    done(0)
if MUT == "store-lenient" and code == 2 and "disagree on DATA_STORE" in err:
    done(0)
if MUT == "reader-slug" and CMD == "root":
    out = "".join(x.rstrip("\n") + "-misread\n" if x.startswith("slug: ") else x for x in out.splitlines(True))
if MUT == "older-layout-fails" and CMD == "verify" and "not this project" in err:
    code = 1
if MUT == "nostore-refuses" and "not yet asked" in err:
    code = 2
if MUT == "maps-lenient" and code == 2 and "claim one folder" in err:
    done(0)
if MUT == "generated-writes" and CMD == "add" and "not filed: generated" in out:
    top = "/".join(ARGS[1].split("/")[:2])
    with open(os.path.join(top, "external.toml"), "w") as f:
        f.write("format = 1\n")
if MUT == "force-evidence" and CMD == "add" and "--force" in ARGS and code == 2 and "filed as evidence" in err:
    done(0, "filed: " + ARGS[1] + " (the fault: --force let through over an evidence row)\n")
if MUT == "no-evidence-flag" and CMD == "add" and code == 0:
    strip(r"evidence[ \t]*=")
if MUT == "rewrites-manifest" and CMD == "add" and "--force" in ARGS and code == 0:
    strip(r"[ \t]*#")
if MUT == "drops-unknown" and CMD == "add" and code == 0:
    strip(r"smoke_")
if MUT == "stray-blind" and CMD in ("status", "verify"):
    out = "".join(x for x in out.splitlines(True) if not (x.startswith("unlisted:") and "outside every map folder" in x))
    if code == 1 and not any(x.startswith(FINDS) for x in out.splitlines()):
        code = 0
if MUT == "skip-refused" and CMD == "add" and code == 0 and out.startswith("not filed: the role"):
    done(2, "", "refused: this project keeps its files in the repository (DATA_STORE repo): commit the file instead\n")
if MUT == "a9-unknown" and CMD == "path" and code == 0 and ARGS[1].rsplit(".", 1)[-1].lower() in A9:
    for k in ("DATA_KIND_PHOTOS", "DATA_KIND_AUDIO", "DATA_KIND_VIDEOS"):
        out = out.replace("/%s/%s/%s/" % (answer("DATA_AREA"), answer(k), answer("DATA_SLUG")),
                          "/%s/%s/%s/" % (answer("DATA_AREA"), answer("DATA_KIND_DOCS"), answer("DATA_SLUG")), 1)
done(code, out, err)
'

self_test() {
  local tmp t n
  bold "▸ $SCRIPT_NAME --self-test"; log ""
  tmp="$(sa_mktemp)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  HAVE_PANDOC=true; HAVE_XELATEX=true; HAVE_UV=true; HAVE_PDFTOTEXT=true; SKIP_PDF=false; NAME="fixture"
  pdf_text() { cat "$1"; }   # the fixture's PDF is its text, pages split by form feeds
  FX_STORE=external; FX_PREP=""
  fresh() {
    rm -rf "$tmp/run"; write_fixture "$tmp/run" "$FX_STORE"
    [[ -z "$FX_PREP" ]] || "$FX_PREP" "$tmp/run"
    smoke "$tmp/run"
  }
  SMOKE_GROUPS=all; MAKE_EXTRA=(); fresh
  st_baseline "a fixture whose every target works, the data root's included"
  SMOKE_GROUPS=legacy
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
  MAKE_EXTRA=("FAIL_CMP_TEX=1"); fresh
  probe "check 33 fires when make compare FORMAT=tex fails" "check 33 — [fixture] make compare FORMAT=tex UNIT=smoke-compare over a planted multi-round chain did not write its LaTeX with every actor's macro (exit"
  MAKE_EXTRA=("CMP_NOTEX=1"); fresh
  probe "check 33 fires when make compare FORMAT=tex writes no LaTeX" "check 33 — [fixture] make compare FORMAT=tex UNIT=smoke-compare over a planted multi-round chain did not write its LaTeX with every actor's macro (no build/compare/"
  MAKE_EXTRA=("CMP_BLIND_NOTE=1"); fresh
  probe "check 33 fires when the LaTeX lacks one actor's macro" "every actor's macro (no \\cmpnote… in its body)"
  MAKE_EXTRA=("LEAK_COMPARE=1"); fresh
  probe "check 34 fires when make compare prints a git-ignored ledger entry" "check 34 — [fixture] make compare printed a git-ignored ledger entry's words"
  MAKE_EXTRA=("LAX_SECTION=1"); fresh
  probe "check 35 fires when make compare takes SECTION without UNIT" "check 35 — [fixture] make compare SECTION=x without UNIT was not refused"
  MAKE_EXTRA=("LOUD_EMPTY=1"); fresh
  probe "check 36 fires when make compare fails on a ledger with no entries" "check 36 — [fixture] make compare with no ledger entries"
  MAKE_EXTRA=("CMP_NOPDF=1"); fresh
  probe "check 37 fires when make compare writes no PDF" "check 37 — [fixture] make compare UNIT=smoke-compare did not write build/compare/smoke-compare.pdf"
  MAKE_EXTRA=("WORK_ALL=1"); fresh
  probe "check 71 fires when make lint reads how-to/src without a SCOPE (WORK_DIRS restored to every */src)" "check 71 — [fixture] a line holding two sentences planted in $HOWTO_CHAPTER: make lint without a SCOPE reported it"
  MAKE_EXTRA=(); FX_PREP=ht_prep_guard; fresh; FX_PREP=""
  probe "check 72 fires when the guide guard never refuses (return 2 made return 0)" "check 72 — [fixture] the guide guard (.claude/hooks/how-to-read-only.sh) failed: an Edit of how-to/CONTEXT.md exited 0, not 2"
  # A business render: the example section is 'converted' by a stub, so no Pandoc is needed.
  TOLATEX=(sed '1,/^---$/d'); FX_STORE=repo; fresh_business() {
    MAKE_EXTRA=("$@"); rm -rf "$tmp/run"; write_fixture "$tmp/run" "$FX_STORE" business; rm -rf "$tmp/run/manuscript" "$tmp/run/typeset"
    mkdir -p "$tmp/run/library/src/business/drafts/x" "$tmp/run/library/src/legal" "$tmp/run/tooling/latex"
    [[ "$FX_STORE" != external ]] || printf '%s\n' '*.pdf' '*.png' '!external.toml' > "$tmp/run/library/src/.gitignore"
    printf '# A letter\n' > "$tmp/run/library/src/business/a.md"
    printf '%% a document\n%% status: draft\n' > "$tmp/run/library/src/business/a.tex"
    printf -- '---\nsection: scope\n---\n\nThe work covers the handbook.\n' > "$tmp/run/library/src/business/drafts/x/02-scope.md"
    printf '\\begin{document}\n%% section: summary\n[Summary.]\n%% end section: summary\n\\end{document}\n' > "$tmp/run/tooling/latex/skeleton.tex"
    mkdir -p "$tmp/run/standards/brand"
    printf '# Brand guide\n\n<!-- VERIFY: the seed brand guide -->\n' > "$tmp/run/standards/brand/brand-guide.md"
    [[ -z "$FX_PREP" ]] || "$FX_PREP" "$tmp/run"
    smoke "$tmp/run"
  }
  SMOKE_GROUPS=all; fresh_business
  probe_clean "a business render under repo, with no printed book, is clean and its book checks are skipped"
  SMOKE_GROUPS=legacy
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
  fresh_business "STE_BLIND=1"
  probe "check 38 fires when make lint does not list a long list step" "check 38 — [fixture] make lint did not report list steps over 20 words as D46 says: the 24-word step"
  fresh_business "STE_ALL=1"
  probe "check 38 fires when make lint lists a short list step" "check 38 — [fixture] make lint did not report list steps over 20 words as D46 says: the 3-word step"
  fresh_business "STE_LEGAL=1"
  probe "check 38 fires when make lint lists a step in a legal document" "check 38 — [fixture] make lint did not report list steps over 20 words as D46 says: the step in library/src/legal/"
  FX_PREP=ht_prep_dash; fresh_business; FX_PREP=""
  probe "check 70 fires on an em dash in a business render's chapter" "check 70 — [fixture] make lint SCOPE=how-to/src STRICT=1 failed (exit"
  self_test_dataroot
  self_test_oldpy
  self_test_hooks
  TOLATEX=(pandoc -f markdown -t latex --lua-filter tooling/pandoc/house.lua)
  MAKE_EXTRA=(); SMOKE_GROUPS=all; FX_STORE=external; FX_PREP=""
  DR_PYC=""
  st_finish "working tooling from broken tooling"
}

# Checks 39–69: each fault is one SMOKE_DR switch of the stand-in resolver, one switch of the
# stand-in Makefile, or one change to a fixture file (FX_PREP), and exactly one check must name
# it. Called by self_test, whose fresh_business it uses.
self_test_dataroot() {
  if ! $HAVE_PY_MIN; then log "  · checks 39–69 skipped: python3 is below $SA_PYTHON_MIN (the resolver's floor)"; return 0; fi
  [[ -f "$SA_ROOT/template/$DR_PY" ]] || die "the self-test needs template/$DR_PY"
  FX_STORE=external; SMOKE_GROUPS=all; fresh_business
  probe_clean "a business render under external, with a resolver whose every case works, is clean"
  SMOKE_GROUPS=dataroot
  dr_probe "check 39 fires when make lint needs the root" "check 39 — [fixture] a root state broke text work" "" LINT_NEEDS_ROOT=1
  dr_probe "check 39 fires when a data command passes over a root without its marker" "path exited 0 with the root unmarked" lenient-root
  dr_probe "check 39 fires when a refused data command still writes" "with the root unmarked, it wrote dr-39-unmarked/smoke-written.pdf" writes-on-refusal
  dr_probe "check 40 fires when ISSUE=1 files the copy anywhere but its mirror path" "check 40 — [fixture] make pdf ISSUE=1 under external did not file" "" ISSUE_WRONG_AS=1
  dr_probe "check 41 fires when a second ISSUE=1 builds before it refuses" "check 41 — [fixture] a second make pdf ISSUE=1" "" DR_CLOBBER=1
  dr_probe "check 42 fires when FORCE=1 does not supersede" "check 42 — [fixture] make pdf ISSUE=1 FORCE=1" "" FORCE_DROPPED=1
  dr_probe "check 43 fires when ISSUE=1 with no root writes beside the source" "check 43 — [fixture] make pdf ISSUE=1 with no data root" "" NOROOT_BESIDE=1
  dr_probe "check 44 fires when verify misses a flipped byte" "without naming research/src/smoke-dr-verify/a.pdf as changed" verify-blind-changed
  dr_probe "check 44 fires when verify misses a missing copy" "without naming research/src/smoke-dr-verify/b.pdf as missing" verify-blind-missing
  dr_probe "check 44 fires when verify misses an unlisted file" "without naming it as unlisted" verify-blind-unlisted
  dr_probe "check 45 fires when status misses an ignored PDF no row lists" "check 45 — [fixture] status did not report" status-blind
  dr_probe "check 46 fires when check-names passes a device name" "check 46 — [fixture] check-names did not judge Windows-safe names: 'CON.pdf' exited 0" names-lenient
  dr_probe "check 47 fires when add creates a second spelling of the area" "check 47 — [fixture] the case-only clash" case-creates
  dr_probe "check 48 fires when two records' stores may disagree" "check 48 — [fixture] two answers files that disagree on DATA_STORE" store-lenient
  dr_probe "check 49 fires when root misreads the answers file" "check 49 — [fixture] the resolver's root does not read the render's own answers file: no 'slug: smoke-fixture' line" reader-slug
  dr_probe "check 50 fires when the guard lets an edit through a link into the root" "an Edit through a symbolic link into the root exited 0" guard-no-link
  dr_probe "check 50 fires when the guard blocks input that is no tool call" "input that is no tool call ('not json') exited 2" guard-bad-input
  dr_probe "check 51 fires when make root prints another provider" "check 51 — [fixture] make root did not print the answer's provider line" "" ROOT_PROVIDER_WRONG=1
  dr_probe "check 52 fires when verify cannot find rows under an older layout" "check 52 — [fixture] rows filed under an older layout" older-layout-fails
  dr_probe "check 53 fires when a record with no DATA_STORE is refused" "check 53 — [fixture] a second answers file with no DATA_STORE" nostore-refuses
  dr_probe "check 54 fires when two maps may claim one folder" "check 54 — [fixture] two maps claiming one folder were not refused" maps-lenient
  dr_probe "check 55 fires when files-add without AS= passes make's built-in AS" "check 55 — [fixture] make files-add ROLE=generated did not file" "" AS_BUILTIN=1
  dr_probe "check 55 fires when files-add passes an AS exported in make's environment" "make files-add with AS=as exported exited" "" AS_ENV=1
  dr_probe "check 60 fires when add --force replaces an evidence row" "check 60 — [fixture] FORCE=1 over an evidence row was not refused" force-evidence
  dr_probe "check 61 fires when a filed row records no evidence" "check 61 — [fixture] a filed row does not record evidence as D50 says: the signed row records evidence 'absent'" no-evidence-flag
  dr_probe "check 62 fires when a supersede rewrites the old text beyond the state value" "check 62 — [fixture] a superseding copy did not append one row with only the old row's state changed: the old text changed" rewrites-manifest
  dr_probe "check 63 fires when verify does not hold the rows committed at HEAD" "check 63 — [fixture] verify did not hold the rows committed at HEAD: with row 1's label edited" verify-blind-committed
  dr_probe "check 64 fires when verify misses a tracked manifest no map names" "check 64 — [fixture] verify did not fail on a tracked external.toml" verify-blind-orphaned
  dr_probe "check 65 fires when an add drops a row's unknown key" "check 65 — [fixture] an unknown key on a row did not survive a later add" drops-unknown
  dr_probe "check 66 fires when a \"rows\": \"none\" folder is read as a filing folder" "named a file in the working-output folder" rows-ignored
  dr_probe "check 66 fires when a stray file outside every map folder is not reported" "without naming it as such" stray-blind
  dr_probe "check 68 fires when the extension table lacks syntek-media's seventeen" "check 68 — [fixture] an extension syntek-media added did not choose its kind: .PSD went to" a9-unknown
  dr_probe "check 69 fires when the TeX search path reaches the shell double-quoted" "check 69 — [fixture] make pdf ran a command from the answers" "" TEX_UNQUOTED=1
  FX_STORE=repo
  dr_probe "check 39 fires when path or add under repo takes its shortcut over a marker above the repository" "under repo, path exited 0 with the root above, not 2" repo-shortcut
  dr_probe "check 55 fires when a generated file is written under repo" "it wrote world/src/external.toml under repo" generated-writes
  dr_probe "check 67 fires when a \"repo\": \"skip\" role is refused under repo" "check 67 — [fixture] a map role marked" skip-refused
  FX_STORE=external
  SMOKE_REEXPORT=1
  dr_probe "check 56 fires when the decoy SYNTEK_DATA_ROOT is re-exported after sourcing" "check 56 — [fixture] a SYNTEK_DATA_ROOT in the caller's environment reached an audit" ""
  SMOKE_REEXPORT=""
  FX_PREP=dr_prep_hook
  dr_probe "check 57 fires when the seed's hook command exits 1 with no resolver" "in a work tree with no resolver it exited 1" ""
  FX_PREP=""
  dr_probe "check 58 fires when the guard needs tomllib" "check 58 — [fixture] without tomllib the guard no longer decides" eager-tomllib
  FX_PREP=dr_prep_parse
  dr_probe "check 59 fires when the resolver needs a grammar newer than Python 3.8's" "check 59 — [fixture] the resolver does not parse under ast.parse(feature_version=(3, 8)): line" ""
  FX_PREP=""
  SMOKE_GROUPS=all
}
# Checks 73–81: each fault is one SMOKE_OLD switch of a stand-in, one switch of the stand-in
# Makefile, one change to a fixture file (FX_PREP) or a copy of _common.sh, and exactly one check
# must name it. Called by self_test, whose fresh it uses.
self_test_oldpy() {
  local lib="$tmp/common-nopin.sh"
  FX_STORE=external; MAKE_EXTRA=(); SMOKE_GROUPS=oldpy
  FX_PREP=old_prep_parse; fresh; FX_PREP=""
  probe "check 80 fires when a hook's Python needs a grammar newer than Python 3.8's" "check 80 — [fixture] ${OLD_WHAT[80]}: .claude/hooks/context-threshold-handoff.sh, the block from line"
  if [[ -z "$OLD_PY" ]]; then
    log "  · checks 73–79 and 81 skipped: $OLD_WHY"; SMOKE_GROUPS=all; return 0
  fi
  old_probe "check 73 fires when the resolver's refusal goes to stdout" "check 73 — [fixture] ${OLD_WHAT[73]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): 'root' printed on stdout" old-stdout
  MAKE_EXTRA=("OLD_SWALLOW=1"); fresh; MAKE_EXTRA=()
  probe "check 74 fires when make hides a tool's refusal" "check 74 — [fixture] ${OLD_WHAT[74]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): make provenance exited 0"
  old_probe "check 75 fires when a tooling script has no version gate" "check 75 — [fixture] ${OLD_WHAT[75]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): tooling/demo.py its stderr" tool-traceback
  old_probe "check 76 fires when the permissions script runs on an older Python" "check 76 — [fixture] ${OLD_WHAT[76]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): --check exited 0" perm-runs
  old_probe "check 77 fires when the data-root guard blocks on an older Python" "check 77 — [fixture] ${OLD_WHAT[77]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): a Write under a marked root exited 2" old-guard-blocks
  old_probe "check 78 fires when the guide guard blocks on an older Python" "check 78 — [fixture] ${OLD_WHAT[78]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): an Edit of how-to/CONTEXT.md exited 2" howto-blocks
  old_probe "check 79 fires when the threshold hook says nothing on an older Python" "check 79 — [fixture] ${OLD_WHAT[79]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): a prompt printed nothing" threshold-silent
  sed 's/^sa_python_pin$/: sa_python_pin  # the fault: the pin never runs/' "$SA_SCRIPTS_DIR/_common.sh" > "$lib"
  grep -q '^: sa_python_pin' "$lib" || die "_common.sh holds no 'sa_python_pin' line for the self-test to turn off"
  SMOKE_COMMON="$lib"; fresh; SMOKE_COMMON=""
  probe "check 81 fires when _common.sh's pin never runs" "check 81 — [fixture] ${OLD_WHAT[81]} (Python $OLD_VER; the minimum is $SA_PYTHON_MIN): with python3 naming"
  SMOKE_GROUPS=all
}
# Checks 82–87: each fault is one change to a fixture file (FX_PREP), and exactly one check must
# name it. The fixture's hooks are the real ones, so the group must be clean before any probe.
# Called by self_test, whose fresh it uses.
self_test_hooks() {
  FX_STORE=external; MAKE_EXTRA=(); SMOKE_GROUPS=hooks
  FX_PREP=""; fresh
  probe_clean "the real handoff hooks and the four commands family-refresh.json offers are clean (checks 82–87)"
  FX_PREP=hk_prep_auto; fresh
  probe "check 82 fires when the automatic note loses its last sentence" "check 82 — [fixture] ${HK_WHAT[82]}: smoke-a's next prompt: its systemMessage is not the automatic note"
  FX_PREP=hk_prep_manual; fresh
  probe "check 83 fires when the manual note changes one word" "check 83 — [fixture] ${HK_WHAT[83]}: smoke-m's SessionStart: its systemMessage is not the manual note"
  FX_PREP=hk_prep_shared; fresh
  probe "check 84 fires when every session shares one marker" "check 84 — [fixture] ${HK_WHAT[84]}: an auto in smoke-a and a manual in smoke-b left compaction-marker-shared.tmp"
  FX_PREP=hk_prep_prune; fresh
  probe "check 85 fires when the prune waits seventy days" "check 85 — [fixture] ${HK_WHAT[85]}: a PreCompact auto kept another session's marker last modified eight days ago"
  FX_PREP=hk_prep_exec; fresh
  probe "check 86 fires when the commands end in the old [ -f … ] && exec" "check 86 — [fixture] ${HK_WHAT[86]}: UserPromptSubmit under sh -c with the scripts removed exited 1"
  FX_PREP=hk_prep_root; fresh
  probe "check 87 fires when the root lookup fails with || exit 1" "check 87 — [fixture] ${HK_WHAT[87]}: UserPromptSubmit under sh -c outside a repository exited 1"
  FX_PREP=hk_prep_relay; fresh
  probe "check 82 fires when the threshold hook measures after a relayed note" "check 82 — [fixture] ${HK_WHAT[82]}: smoke-a's next prompt: printed"
  FX_PREP=hk_prep_stale; fresh
  probe "check 82 fires when a SessionStart keeps a stale auto marker" "check 82 — [fixture] ${HK_WHAT[82]}: smoke-a's SessionStart after a compaction that went ahead left its marker"
  FX_PREP=hk_prep_nosid; fresh
  probe "check 82 fires when auto lets a payload with no session id through" "check 82 — [fixture] ${HK_WHAT[82]}: PreCompact auto with no session id exited 0, not 2"
  FX_PREP=hk_prep_autoctx; fresh
  probe "check 82 fires when the automatic note's session text loses its fallback" "check 82 — [fixture] ${HK_WHAT[82]}: smoke-a's next prompt: its hookSpecificOutput.additionalContext lacks"
  FX_PREP=hk_prep_manualctx; fresh
  probe "check 83 fires when the manual note's session text loses its offer" "check 83 — [fixture] ${HK_WHAT[83]}: smoke-m's SessionStart: its hookSpecificOutput.additionalContext lacks"
  FX_PREP=hk_prep_raw; fresh
  probe "check 84 fires when the session id is not reduced in the marker's name" "check 84 — [fixture] ${HK_WHAT[84]}: an auto in session 'smoke.r/' left no marker"
  FX_PREP=""; SMOKE_GROUPS=all
}
# One fixture file changed: OLD becomes NEW on every line holding ONLY (any line by default),
# or the self-test stops (exit 2).
hk_prep_sub() { # $1 = file, $2 = OLD, $3 = NEW, $4 = the check whose probe it is, $5 = ONLY
  python3 -I -c 'import sys
path, old, new, check, only = (sys.argv[1:] + [""])[:5]
lines = open(path, encoding="utf-8").read().splitlines(True)
hit = [n for n, line in enumerate(lines) if old in line and only in line]
if not hit:
    sys.exit("%s holds no %r for the check %s probe to change" % (path, old, check))
for n in hit:
    lines[n] = lines[n].replace(old, new)
open(path, "w", encoding="utf-8").write("".join(lines))' "$@" || die "the self-test could not change the fixture"
}
hk_prep_auto() { # $1 = fixture: the automatic note loses its fallback sentence (check 82)
  hk_prep_sub "$1/$HK_PRE" ' If /handoff has no room to run, run /compact yourself (it is allowed), then /handoff."' '"' 82
}
hk_prep_manual() { # $1 = fixture: the manual note changes one word (check 83)
  hk_prep_sub "$1/$HK_PRE" 'That works, but a handoff' 'That works, yet a handoff' 83
}
hk_prep_shared() { # $1 = fixture: every session shares one marker file (check 84)
  hk_prep_sub "$1/$HK_PRE" 'marker="$dir/compaction-marker-$session.tmp"' 'marker="$dir/compaction-marker-shared.tmp"' 84
}
hk_prep_prune() { # $1 = fixture: the prune waits seventy days, not seven (check 85)
  hk_prep_sub "$1/$HK_PRE" '-mmin +10080 ' '-mmin +100800 ' 85
}
hk_prep_exec() { # $1 = fixture: the four commands end in an earlier release's `[ -f … ] && exec` (check 86)
  hk_prep_sub "$1/.claude/settings.json" '\" ] || exit 0; exec bash' '\" ] && exec bash' 86 -handoff.sh
}
hk_prep_root() { # $1 = fixture: the four commands' root lookup ends '|| exit 1' (check 87)
  hk_prep_sub "$1/.claude/settings.json" '--show-toplevel 2>/dev/null) || exit 0;' '--show-toplevel 2>/dev/null) || exit 1;' 87 -handoff.sh
}
hk_prep_relay() { # $1 = fixture: the threshold hook measures after a relayed note (check 82)
  python3 -I - "$1/$HK_THRESHOLD" <<'PY' || die "the self-test could not change the fixture"
import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
old = "printf '%s\\n' \"$relayed\"\n    exit 0\n"
if s.count(old) != 1:
    sys.exit("%s holds no relayed note followed by exit 0 for the check 82 probe to change" % p)
open(p, "w", encoding="utf-8").write(s.replace(old, "printf '%s\\n' \"$relayed\"\n"))
PY
}
hk_prep_stale() { # $1 = fixture: a SessionStart keeps another trigger's marker (check 82)
  hk_prep_sub "$1/$HK_PRE" 'consume || true' ':' 82
}
hk_prep_nosid() { # $1 = fixture: auto lets a payload with no session id through (check 82)
  hk_prep_sub "$1/$HK_PRE" 'leave auto' '[ -n "$session" ] || exit 0; leave auto' 82
}
hk_prep_autoctx() { # $1 = fixture: the automatic note's session text loses its fallback (check 82)
  hk_prep_sub "$1/$HK_PRE" ': the person may run /compact, which the project allows, and then /handoff.' '.' 82
}
hk_prep_raw() { # $1 = fixture: the session id reaches the marker's name unreduced (check 84)
  hk_prep_sub "$1/$HK_PRE" '"${BASH_REMATCH[1]//[^A-Za-z0-9-]/}"' '"${BASH_REMATCH[1]}"' 84
}
hk_prep_manualctx() { # $1 = fixture: the manual note's session text loses its offer (check 83)
  hk_prep_sub "$1/$HK_PRE" ' Where the person compacted to make room for a handoff, as the note after a stopped automatic compaction suggests, the session offers the handoff skill now.' '' 83
}
old_probe() { # $1 = label, $2 = the finding's text, $3 = SMOKE_OLD
  export SMOKE_OLD="$3"
  fresh
  unset SMOKE_OLD
  probe "$1" "$2"
}
old_prep_parse() { # $1 = fixture: the threshold hook's embedded Python gains a statement 3.8 cannot parse
  python3 -I - "$1/.claude/hooks/context-threshold-handoff.sh" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
assert "\nPY\n" in s, "the threshold hook holds no <<'PY' block for the self-test to change"
open(p, "w", encoding="utf-8").write(s.replace("\nPY\n", "\nmatch sys.argv:\n    case _:\n        pass\nPY\n", 1))
PY
}

dr_probe() { # $1 = label, $2 = the finding's text, $3 = SMOKE_DR, then the stand-in Makefile's switches
  local label="$1" want="$2"
  export SMOKE_DR="$3"; shift 3
  fresh_business "$@"
  unset SMOKE_DR
  probe "$label" "$want"
}
dr_prep_hook() { # $1 = fixture: the seed's hook command ends 'exit 1' where it means 'exit 0'
  python3 -I - "$1/.claude/settings.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
hook = data["hooks"]["PreToolUse"][0]["hooks"][0]
hook["command"] = hook["command"][: hook["command"].rindex("exit 0")] + "exit 1'"
with open(sys.argv[1], "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
PY
}
ht_prep_dash() { # $1 = fixture: the guide's chapter gains an em dash outside a heading (check 70)
  printf '%s\n' '' 'The guide is plain — and short.' >> "$1/$HOWTO_CHAPTER"
}
ht_prep_guard() { # $1 = fixture: the guide guard never refuses (check 72)
  grep -q 'return 2$' "$1/$SA_HOWTO_GUARD" || die "the guide guard holds no 'return 2' for the self-test to change"
  sed -i 's/return 2$/return 0/' "$1/$SA_HOWTO_GUARD"
}
dr_prep_parse() { # $1 = fixture: the stand-in resolver gains a statement Python 3.8 cannot parse
  printf '%s\n' '' '' 'def _smoke_never(value):' '    match value:' '        case _:' '            return value' >> "$1/$DR_PY"
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
