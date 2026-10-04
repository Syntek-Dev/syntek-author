# CONTEXT.md — library/src/email/templates/

Reusable starting points for emails the business sends often: for example a proposal's covering
email, a meeting follow-up, a request for a quote. Each is a Markdown file in the authored-email
anatomy, holding the structure and standard wording a new email starts from, with every
recipient-specific value left as a placeholder. A template holds no client's data and no agreed
number; an email made from one lives in `library/src/email/client-emails/` or
`library/src/email/supplier-emails/`.

## Directory Tree

```text
library/src/email/templates/
├── CONTEXT.md                  ← this file (add a tree line for each template)
├── CLAUDE.md                   ← operating rules
└── template-<purpose>.md       ← one per recurring email (none yet)
```

## What's here

- Nothing yet. A template earns its place when the same email has been written three times.
- **Placeholders.** `[BRACKETED]` fields for every recipient, fact and figure; the `**Status:**`
  line reads `Template, never sent`.
- **The internal note says when to use it**, and what the sender must decide before it goes.
- **Registered, not versioned.** A template is listed in the register with version `—`.

## Cross-references

- `library/docs/reference/email-standards.md` — the anatomy a template must carry.
- `library/workflows/02-adapt-a-draft/` — turning a template into an email.
