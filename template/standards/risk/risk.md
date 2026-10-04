# risk.md — what the work must not put at risk

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The governing standard for everything the work says about real people, what it learned in
confidence, and the personal data a project inevitably gathers. `structure-review` checks it
through its risk lens; `fact-check` applies its sourcing rules; `draft-section` writes to it.
The domain's own risks are in the mode file beside this one (exactly one of `THEOLOGY.md`,
`FICTION.md` or `BUSINESS.md` ships here), and they add to these rules, never relax them.

Dates DD/MM/YYYY.

---

## 1. A real person is named only on a public, checkable basis

**Requirement.** A claim about an identifiable living person (what they did, said, believe or
are) is made only from a public source that `fact-check` can verify, and only where the work
needs it. Anything less is anonymised, generalised, or flagged for the author's decision.

**Why this rule exists.** A false or private claim about a real person can do them lasting harm
and expose the author to a defamation or privacy claim; a true one still needs a reason to be in
the work.

---

## 2. A confidence is shaped, never pasted

**Requirement.** Anything the author learned in confidence (from an employer, a client, a
congregation, a patient, a friend or a family member) never enters the work verbatim or
identifiably. It may shape the argument or the story; a claim that depends on it is made from a
public source instead, or flagged for the author's decision.

> **Right:** 'Organisations of this kind commonly…' supported by a public study.
>
> **Wrong:** a recognisable account of one employer's internal meeting.

**Why this rule exists.** The author may not be free to publish what they know, and a reader who
recognises the source can identify the person who trusted the author with it.

---

## 3. Consent is explicit, recorded and never inferred

**Requirement.** A real person's story, words or likeness enters the work only with their
explicit consent, given after they understood how it will be used, and recorded (who, what,
when) in `.claude/MEMORY.md` `## Sensitivities` (mapped in `00-project.md`
`## Memory headings`). Silence, an old conversation or 'they would not mind' is not consent.

**Why this rule exists.** Consent inferred by the writer is the writer's convenience, not the
subject's choice, and it cannot be withdrawn once the work is printed.

---

## 4. Personal data stays out of the repository

**Requirement.** The repository holds no more personal data than the work needs: no contact
details, credentials, identity documents, financial details, health information or student
records of anyone. Special-category information about an identifiable person (health, sex life,
religious belief as private fact, ethnicity) is never recorded without that person's explicit
consent. A folder that must hold sensitive material is ignored by git by default, with only its
`CONTEXT.md` and `CLAUDE.md` re-included.

**Why this rule exists.** A repository is copied, synchronised and shared far more widely than
anyone intends; what is not in it cannot leak from it.

---

## 5. Flag and defer

**Requirement.** When a draft raises any risk covered here, the skill stops at the sentence,
flags it with `AUTHOR TO CONFIRM` (stating the risk and the options), tells the author, and does
not resolve it on its own judgement. The decision is recorded, dated, in `.claude/MEMORY.md`.

**Why this rule exists.** A silent softening or cut can undo something the author meant, and a
silent keep can publish something they would have removed. Either way, the decision was not
theirs.

---

## 6. The author's wellbeing comes first

**Requirement.** Where the work draws on the author's own hard experience, the skill keeps the
author's first-person voice, never fabricates or embellishes personal detail, and pauses to ask
before pressing on through a hard passage. The author sets the pace, and may stop.

**Why this rule exists.** No unit is worth harm to the person writing it, and a passage
written under pressure is rarely the one the author wants to keep.
