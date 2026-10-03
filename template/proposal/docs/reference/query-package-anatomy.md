---
type: guide
skills: [build, research, approach-a-reader]
model: opus
---

# Query-package anatomy — what an agent receives, and how submissions are tracked

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The parts of a submission to a literary agent, what each must achieve, and how
agents are chosen and tracked. An agent reads the query's opening lines and the first pages;
everything else confirms the read or ends it. The parts are kept ready so any request can be met
the same day, without a rewrite.

## The parts

| Part | File | What it must achieve |
|---|---|---|
| Query letter | `proposal/src/query-letter.md` | About a page: the hook, the protagonist, the stakes and the choice; title, genre, word count to the nearest thousand and comparable titles; a short biography |
| Short synopsis | `proposal/src/synopsis-short.md` | About 500 words: the whole story, ending included |
| Long synopsis | `proposal/src/synopsis-long.md` | About 1,000–1,500 words, for an agent who asks for more |
| Comparable titles | `proposal/src/comp-titles.md` | Two or three recent books whose readers will want this one |
| Sample | `proposal/src/sample/sample-index.md` | The opening chapters, consecutive and promoted, to the length asked |
| Tracker | `proposal/src/submissions/tracker.md` | Every query, request, pass and offer, with the next action |

## The agent's guidelines win

Agencies publish what they want to receive, commonly a covering letter, a synopsis and the
opening chapters, each to a stated length and format. Send exactly that: the package's own targets
give way to every agency's stated requirement. Record each agency's requirements in its tracker
row before drafting.

## Synopses

A synopsis is how an agent judges the shape of the story, not a teaser. It tells the whole plot,
the ending included, conventionally in the present tense and the third person, naming only the
characters the plot needs. No rhetorical questions and no withheld twist.

## Choosing and tracking agents

- **Why them:** they represent the genre, are open to submissions, and their list has room for this
  book. Record the reason in the row; if there is none, do not query.
- **Statuses:** `to query` · `queried` · `requested` · `passed` · `offer` · `withdrawn` · `lapsed`.
  A drafted query leaves the row at `to query`; only the author sending it makes it `queried`.
- **Simultaneous submissions** are the norm unless an agency says otherwise. If an offer comes, the
  author tells every agent still considering the book; that is the convention, and it is fair.
- **Do not chase a query;** once the agency's stated response time passes, mark the row `lapsed`.
  A requested manuscript may be chased once, politely, after the time the agent gave.
- **Replies are quoted in the row:** a request's terms, a pass's reasons, an offer's terms.

## How we apply it here

- **Query only a finished, revised novel.** For a first novel, agents commonly expect the
  manuscript to be complete before a query is sent; check `manuscript/src/` first.
- **Never invent** an agent's interest, a request or an offer, and never claim a comparable title's
  sales.
- **Personalise in the draft.** Each agent's query is a tailored copy in
  `proposal/src/submissions/drafts/`; the master `query-letter.md` stays general.
- **Build from the source:** `make docx SCOPE=proposal/src/synopsis-short.md`, and the same for each
  part an agent wants as a file.

## Who implements it

- **Skills:** `build`, `research`, `approach-a-reader`. **Workflows:**
  `proposal/workflows/01-assemble-the-proposal/`, `proposal/workflows/02-approach-a-reader/`,
  `proposal/workflows/03-update-the-tracker/`.

## Governing standard

`standards/method/FICTION.md` makes the story bible the source of truth the synopses must match;
`standards/style/voice-notes.md` governs how the letter sounds. The standards own the rules; this
guide owns the package.
