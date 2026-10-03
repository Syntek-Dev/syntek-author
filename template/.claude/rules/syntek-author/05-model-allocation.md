# 05-model-allocation.md — which model does which work

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

The two model tiers are defined here and nowhere else. Every other file names a tier, never a
rule of its own, so a change of policy is one edit.

---

## 1. The two tiers

No Haiku on this project.

| Work | Model |
|---|---|
| Mechanical only: file renames, checklist ticks, running the build, format conversions, moving an agreed change into place | **<%MODEL_MECHANICAL%>** |
| Everything substantive: drafting, adapting, improving, research, fact-checking, editing, proofreading, reviewing, grilling, voice learning, any decision about meaning | **opus** |

If Opus usage is exhausted, substantive work falls back to **sonnet** until it returns, never
lower. **When in doubt, the work is substantive.** A rename that changes what a heading claims, or
a format conversion that has to choose how to render a table, is a judgement, not a chore.

---

## 2. How the tiers are named in files

- **Checklist tags** are the literal `· _opus_` (the substantive tier) and `· _sonnet_` (the
  mechanical tier). They name the tier, not a model: the mechanical tier runs on the model in the
  table above.
- **Routing frontmatter** on guides, `STEPS.md` and `CHECKLIST.md` carries `model: opus` for
  substantive work and `model: sonnet` for mechanical work. As with the tags, `sonnet` there names
  the mechanical tier, which this project runs on **<%MODEL_MECHANICAL%>**.
- **Section drafts and unit briefs carry no `model:` key.** The tier belongs to the task, not to
  the file being worked on.
- **Never write a version string.** Use the alias, `opus` or `sonnet`, so the project follows the
  current model without an edit.
- **Never put a template token inside an emphasised checklist tag.** A formatter that rewrites
  emphasis can corrupt it.

---

## 3. Why

Substantive work is where an error costs the author: a fabricated source, a flattened argument, a
changed obligation, a lost turn of voice. The cheaper tier is safe only where the result can be
checked at a glance, which is why the line sits at mechanical work and never higher, and why the
fallback never drops below the tier the work needs.
