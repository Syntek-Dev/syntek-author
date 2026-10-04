# CONTEXT.md — standards/risk/

The risk standard: what the work must not put at risk while it tells the truth. `risk.md` holds
the rules every kind of work shares (real people, confidences, consent, personal data, flag and
defer, the author's wellbeing); the doc-type mode file beside it holds the domain's own risks.
Where `method/` asks whether a claim is true, this folder asks what a true sentence could cost
someone, and who decides whether to pay it. Not here: the facts themselves
(`research/src/evidence/`) or how hard material sounds (`standards/style/`).

## Directory Tree

```text
standards/risk/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules
├── risk.md                  ← the shared rules: real people, confidences, consent, flag and defer
<: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT -:>
├── sensitive-content.md     ← the four pillars for hard subjects: care, sourcing, signposting, safeguarding
<: endif -:>
<: if DOC_TYPE == 'theology' -:>
└── THEOLOGY.md              ← honesty and contested ground: readers, traditions, pastoral confidences
<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
└── FICTION.md               ← depiction and real people; real languages as models; hostile peoples
<: endif -:>
<: if DOC_TYPE == 'business' -:>
└── BUSINESS.md              ← confidentiality and disclaimers: clients, credentials, regulated claims
<: endif -:>
```

## What's here

- `risk.md` — the rules every variant shares. **A risk is flagged for the author's decision,
  never resolved silently in a draft.**
<: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT -:>
- `sensitive-content.md` — the standard for the work's hardest subjects: handled with care,
  sourced more rigorously than anything else, signposted to help, and written without harm to
  any child, third party or the author. The subjects themselves are named only in
  `.claude/MEMORY.md` `## Sensitivities` (mapped in `00-project.md` `## Memory headings`).
<: endif -:>
<: if DOC_TYPE == 'theology' -:>
- `THEOLOGY.md` — examining a practice without despising the practitioner; claims about named
  churches and traditions; what is heard in pastoral confidence.

<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
- `FICTION.md` — content notes, safe messaging on self-harm and suicide, real people and places,
  representation, permissions for quoted material, lived experience behind the story; rule 7,
  real languages as models (their sound, never their words), and rule 8, a hostile people never
  a real people in disguise.

<: endif -:>
<: if DOC_TYPE == 'business' -:>
- `BUSINESS.md` — client confidentiality, credentials, personal data, disclaimers by document
  class, and regulated or professional claims.

<: endif -:>
## Cross-references

- `.claude/MEMORY.md` — `## Sensitivities` records the project's own sensitive matters, once
  (mapped in `00-project.md` `## Memory headings`).
- `.claude/rules/syntek-author/03-authorship.md` — never fabricate; the `AUTHOR TO CONFIRM` flag.
- `standards/method/method.md` — the sourcing rules every risky claim must also meet.
- `.claude/skills/structure-review/SKILL.md` — its risk lens reads this folder.
