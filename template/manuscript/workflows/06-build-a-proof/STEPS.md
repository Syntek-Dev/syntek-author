---
workflow: 06-build-a-proof
phase: publish
skills: [build, fact-check]
model: sonnet
---

# STEPS.md — build a proof

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for rendering a chapter or the whole manuscript, and reading the result. Run
from the **repository root**: every `make` command and `SCOPE` path is relative to it. Each step
names the skill and the guide it uses. Tick `CHECKLIST.md` as you go. The `model: sonnet` above
names the mechanical tier; the reading steps are Opus.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `build` skill
> is this procedure in skill form; read its mode file before step 1.

## 1. Decide the scope and the format

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

**Scope:** one chapter (`SCOPE=manuscript/src/NN-kebab-title`) or the whole manuscript
(`make book`). **Format:** `.docx` for editors, `.pdf` for a typeset proof, `.epub` to read as a
reader would; both `.docx` and `.pdf` when the request is just 'build'. **If the request is
ambiguous, ask** before running a long build.
_Mechanical (running); the scope call is substantive if ambiguous._

## 2. Check claim currency, before an editorial export

> **Skill:** `fact-check` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

If the output is going to an editor, an early reader or a publisher, run `fact-check` over any
claim in scope whose evidence entry was last checked more than about twelve months ago. **Report
anything stale to the author; it is their call whether it blocks the export.** Skip this step for a
working proof. _Substantive._

## 3. Regenerate the references (references option only)

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

```sh
make refs
```

The format targets depend on it anyway; running it first makes failures easier to read. If it
reports that the database is missing, **stop** and tell the author to run `make init`; never
bootstrap it mid-build. Without the references option there is no `refs` target: go to step 4.
_Mechanical._

## 4. Build the output

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

```sh
make docx SCOPE=manuscript/src/NN-kebab-title    # editor copy
make pdf  SCOPE=manuscript/src/NN-kebab-title    # typeset proof
make epub SCOPE=manuscript/src/NN-kebab-title    # e-reader copy
make book                                        # the whole manuscript
```

The targets drive Pandoc through `tooling/defaults.yaml` and exclude governance files and
everything under a drafts folder. _Mechanical._

## 5. Confirm the build included what you expected

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Check the file list the Makefile echoed. A chapter or section missing from it is almost always still
in drafts: it has not been promoted, so it should not be in the build. **Do not work around the
exclusion.** _Substantive._

## 6. Read the proof

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

A successful build is not a good proof. Open it and check:

- **Citations resolved**, with no raw `[@key]` anywhere (references option).
- **The reference list** present and complete; an entry that renders visibly short is a reference
  record needing completion, not a broken build.
- **Footnotes** under the right sentences.
- **Headings, chapter order and scene or section breaks** as intended; no section marker or
  internal note visible in the output.
- **Special characters** (accents, other scripts, symbols) rendering correctly.

_Substantive._

## 7. Report back

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Give the output path(s), the scope and format, anything flagged in step 2, and anything the proof
revealed. For each problem, name the procedure that owns the fix (a section procedure for prose,
the add-reference skill for a reference record, `fact-check` for a claim) and stop there rather than fixing
it in `build/`. _Substantive._

## Troubleshooting

- **The database is missing** — the references database has not been built. Tell the author to run
  `make init`; do not do it yourself.
- **No files under the scope** — wrong or empty `SCOPE`. Check the folder name against
  `manuscript/src/`, and remember governance files and drafts are excluded by design.
- **The `.pdf` fails with a TeX or missing-package error** — the TeX installation is missing or
  incomplete. `.docx` and `.epub` do not need it: fall back to `make docx` and tell the author the
  PDF proof needs a XeLaTeX-capable TeX installation.
- **A raw `[@key]` in the output** — the key is not in the reference data, or `make refs` has not
  re-run. Fix the reference record with the add-reference skill; never patch the output.
- **`make clean`** removes `build/` entirely; rebuild from step 3.
