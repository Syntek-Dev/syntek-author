# Pull request

## Summary

<!-- One or two sentences: what is different after this merges, and why. Link the issue: Closes #123 -->

## Decision

<!--
The DESIGN.md decision (D-number) or section this implements. If it changes DESIGN.md, link the
issue or comment where the maintainer approved the change. DESIGN.md is the contract: where any
other file disagrees with it, that file is wrong.
-->

---

## Checklist

CI (`.github/workflows/audit-template.yml`) runs every audit on every push to every branch; read
its run. Tick the first box only for a local run you saw finish.

- [ ] `bash .github/scripts/run-all.sh` passed locally (or, below: which audits I ran, and why not all)
- [ ] A `CHANGELOG.md` entry under `[Unreleased]`, citing the decision or section
- [ ] `DESIGN.md` changed only with the maintainer's approval (linked above), or not at all
- [ ] If a family-shared byte changed (D48): `bash .github/scripts/family-shared.sh --write` run, and the `CHANGELOG.md` entry says companion templates must refresh
- [ ] If author work moves: a version-keyed migration in this pull request (D44)
- [ ] If a template skill was added: its deny line and Codex entry proposed for the maintainer (`.claude/CLAUDE.md` Section 3)
- [ ] No rendered output committed (renders, logs and scratch projects stay in a temporary directory)
- [ ] No personal data under `template/`: examples invented, seeds empty of entries
- [ ] British English (en_GB), single quotation marks, DD/MM/YYYY in prose

### Licence

- [ ] I agree that my contribution is licensed under the MIT Licence, with the permission for generated projects (inbound = outbound), as `CONTRIBUTING.md` ('Licence') says

---

## Anything reviewers should know

<!-- Trade-offs you weighed, audits you could not run and why, what you deliberately left out. -->
