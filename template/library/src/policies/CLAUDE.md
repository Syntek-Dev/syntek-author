@./CONTEXT.md

# CLAUDE.md — library/src/policies/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the policies, procedures and notices the business sets and must be able to show it follows.

## How to work here

- **Routing:** the loop in `library/workflows/`; `obligation-check` at fact check reads every
  must-statement; `fact-check` verifies every legal or framework reference. A live policy that is
  due for review goes through `planning/workflows/06-run-a-review-cycle/`, not workflow 05 here.
- **Model:** **Opus** throughout; a policy's wording is its substance.
- **Concrete steps:**
  1. Confirm with the author who the policy binds, who owns it and who approves it.
  2. Draft each rule area as a section, in the imperative: 'Staff must…', 'The business shall…'.
  3. Review to `final`; record the approval; register it with its review cycle.
- **Definition of done:** every rule is a must or shall statement someone could audit; every
  reference to a law or framework is verified and dated; the owner, approver, classification and
  next review date are stated; the approval is recorded.

## Guardrails

- **Policies command; they do not advise.** Replace 'should consider' with 'must' or 'shall', or
  cut the sentence. A rule nobody could be found to have broken is not a rule.
- **'Aligned with' or 'informed by' a framework, never 'certified to'**, unless a certificate
  exists, is filed, and is cited with a `VERIFY` flag until checked.
- **Never invent a control number, a statute or a section.** Framework and legal references carry
  a `VERIFY` flag until `fact-check` has confirmed them against the source.
- **A policy describes what the business actually does.** A rule the business does not follow is a
  liability, not an aspiration; raise the gap with the author.
- **Active only on approval.** Never set a policy Active in the register or its Document Control
  block without the recorded approval.

## Output & naming

- **Hand-written:** policy `.tex` files, section drafts, client folder pairs.
- **Generated (never hand-edit):** the issued PDF beside each `.tex`.
