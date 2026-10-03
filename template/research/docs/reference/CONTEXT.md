# CONTEXT.md — research/docs/reference/

The template's research guides. Each one answers a recurring judgement call in the research layer,
follows the same shape (what it is · its topics · how we apply it here · who implements it ·
governing standard) and defers to a standard rather than restating it. This folder is
**template-owned**: `copier update` replaces it, so a project-specific version of a guide goes in
`research/docs/project/` under the same name, where it overrides the one here.

## Directory Tree

```text
research/docs/reference/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules for the guides
<: if DOC_TYPE == 'theology' :>├── contested-readings.md     ← mapping a passage read more than one way
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>├── handling-testimony.md     ← first-person material: consent, care, shape never paste
<: endif :>├── ingesting-sources.md      ← from a passing mention to a note the work can cite
<: if DOC_TYPE == 'fiction' :>├── real-world-detail.md      ← checking the real world a novel borrows
<: endif :>└── vetting-evidence.md       ← whether a claim is fit to print; the one verdict vocabulary
```

## What's here

- `ingesting-sources.md` — routing a source, reading it at its origin, noting what it argues and
  where it disagrees, capturing page numbers, keying it in the same pass.
- `vetting-evidence.md` — the five things a claim must carry, where claims go wrong, judging a
  study, and **the verdicts every evidence entry uses**: `verified` · `verified-with-caveat` ·
  `contested` · `thin` · `cannot-be-dated` · `unsupported`.
<: if DOC_TYPE == 'theology' :>- `contested-readings.md` — the recognition test, what turns on each reading, a position without
  false balance, and naming the dispute in the body.
<: endif :><: if DOC_TYPE == 'fiction' :>- `real-world-detail.md` — what counts as real-world detail, deliberate departures, real people
  and quoted material, and where each lands.
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>- `handling-testimony.md` — consent, shape never paste, flag never decide, protecting other
  people and the author's wellbeing. **Safeguarding-critical.**
<: endif :>
## Cross-references

- `research/docs/project/` — the author's guides; a same-named file there overrides one here.
- `research/workflows/CONTEXT.md` — the procedures that apply these guides step by step.
- `standards/verification/verification.md` — the gate the evidence guides serve.
<: if DOC_TYPE == 'theology' :>- `standards/method/THEOLOGY.md` — the method rules `contested-readings.md` applies.
<: endif :><: if DOC_TYPE == 'fiction' :>- `standards/risk/FICTION.md` — depiction and real people, which `real-world-detail.md` applies.
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>- `standards/risk/sensitive-content.md` — the standard `handling-testimony.md` applies; read it
  first.
<: endif :>