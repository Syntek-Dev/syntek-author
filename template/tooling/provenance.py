#!/usr/bin/env python3
"""provenance.py: AI-disclosure figures from the provenance ledger.

Reads the ledger entries in standards/style/ledger/ (one per section, named
<unit-slug>--<section-slug>.md) and prints the per-unit disclosure table, computes
one entry's change ratio, or checks the ledger and its register for problems.

Usage:
    python3 tooling/provenance.py [table] [--unit SLUG]
    python3 tooling/provenance.py ratio ENTRY [--write]
    python3 tooling/provenance.py check
    python3 tooling/provenance.py --self-test
    (every subcommand also takes --ledger DIR; default standards/style/ledger)

ENTRY is a path to a ledger entry, or its name without the folder ('03-the-ford--crossing'
or '03-the-ford--crossing.md').

Change ratio: 1 minus the difflib similarity between the AI original and the author's
final text, compared word by word after HTML comments are removed. 0.00 means the AI
draft was promoted unchanged; 1.00 means it was entirely rewritten. It measures how far
the text moved, not who moved it. Author-drafted sections have no change ratio.

Improvement decisions: each row's decision is accepted, rejected or author-note. Only accepted
and rejected rows are AI suggestions; an author-note row is a change the author asked for, which
the AI applied, and is counted as neither. An empty decision is still open. Any other word is
reported. A pipe written as \\| inside a cell is text, not a column break.

The revision record: an entry written from v0.3.0 carries 'format: 2' and may hold two more
sections between '## AI original' and '## Author final'. '## Author original' is the text the
loop started from when the author drafted the section (empty when the AI did). '## Revisions'
is a chain of full-text states, oldest first, each opened by a marker on a line of its own:
    <!-- revision N · KIND · DD/MM/YYYY · SKILL (STRENGTH) · rows A–B -->
numbered from 1 with no gaps; the strength and the rows are optional. KIND names who made the
change from the state before: ai (an AI suggestion the author accepted), author-note (the AI
applying the author's own note) or author (the author's hand-edits). The chain starts at the
original (the AI original, or the Author original when the author drafted) and runs through
each revision; whatever still differs at the Author final is the author's. Two states are equal
when each paragraph (blank lines part them) has the same words, comments aside, so a paragraph
break changed is a change. A section promoted and then changed again (reopened) holds its
previous final under '## Author final' until it is promoted again; a revision records that final
as 'promoted <date>', or is dated after the promotion, and the chain ends at the last revision
until then. The full format is in standards/style/ledger/CONTEXT.md. '## Revisions'
divides the entry only when what follows it, past blank lines and comments, is a marker,
another ledger heading or the end, and neither heading divides inside an HTML comment, so a
document's own '## Revisions' heading and a superseded chain stay text. An entry without
'format' predates the record and is read exactly as before. The change ratio is still AI
original against Author final.

Never read: a ledger file git ignores. Inside a git work tree the entries are listed through
`git check-ignore`, keeping only what git does not ignore (or a negation re-includes), because
ignored files hold local-only material; outside one, every entry is read.

Check: every promoted entry needs its row in provenance.md, and every row its promoted entry.
The one exception is the template's worked example: an entry that opens with a
'<!-- WORKED EXAMPLE' comment ships promoted while provenance.md ships empty, so its missing
row is a warning, not a problem, until the author adds it or deletes the example.

Standard library only. Exit codes: 0 = done (warnings may be printed);
1 = an entry is malformed, or `check` found a disagreement; 2 = usage error, or the
ledger cannot be read.
"""
from __future__ import annotations

import argparse
import datetime
import difflib
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_LEDGER = ROOT / "standards" / "style" / "ledger"
REGISTER = "provenance.md"
NOT_ENTRIES = {"CONTEXT.md", "CLAUDE.md", "README.md", REGISTER}
REQUIRED_KEYS = ("unit", "section", "origin", "drafted", "promoted", "change_ratio", "learned")
REQUIRED_HEADINGS = ("ai original", "author final", "improvement decisions")
COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
DATE_RE = re.compile(r"^\d{2}/\d{2}/\d{4}$")
KEY_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:\s*(.*)$")
DASHES = {"", "-", "—", "–", "n/a"}
PIPE = re.compile(r"(?<!\\)\|")
# The revision record: optional, so an entry written before v0.3.0 stays valid exactly as it was.
FORMAT = 2
OPTIONAL_HEADINGS = ("author original", "revisions")
LEDGER_ORDER = ("ai original", "author original", "revisions", "author final", "improvement decisions")
TITLES = {h: h.capitalize() for h in LEDGER_ORDER} | {"ai original": "AI original"}
KINDS = ("ai", "author-note", "author")
HEADING_RE = re.compile(r"^##\s+(.+?)\s*$")
MARKER_RE = re.compile(r"^<!-- revision (\d+) · (ai|author-note|author) · (\d{2}/\d{2}/\d{4}) · "
                       r"(.+?)(?: · rows (.+?))? -->$")
MARKER_PARTS = re.compile(r"^<!-- revision (\S+) · (\S+) · (\S+) · (.+?)(?: · rows (.+?))? -->$")
MARKER_LIKE = re.compile(r"^<!--\s*revision\b", re.I)
MARKER_FORM = "<!-- revision N · kind · DD/MM/YYYY · skill · rows a–b -->"
ROWS_RE = re.compile(r"\d+(?:\s*[–-]\s*\d+)?(?:\s*,\s*\d+(?:\s*[–-]\s*\d+)?)*")


class UsageError(Exception):
    """Bad arguments, or a file that cannot be read at all (exit 2)."""


def shown(path: Path) -> str:
    """A path as a reader should see it: relative to the repository or the working folder."""
    for base in (ROOT, Path.cwd()):
        try:
            return str(path.resolve().relative_to(base.resolve()))
        except ValueError:
            continue
    return str(path)


def strip_value(raw: str) -> str:
    """A frontmatter value without its trailing comment or its quotes."""
    raw = raw.strip()
    if raw[:1] in ("'", '"'):
        end = raw.find(raw[0], 1)
        return raw[1:end] if end > 0 else raw[1:]
    return re.split(r"(?:^|\s+)#", raw, maxsplit=1)[0].strip()


def split_frontmatter(text: str):
    """Return (meta, body, start, end, problems); start and end index the --- lines."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}, text, None, None, ["no frontmatter: the file must open with a '---' line"]
    end = next((i for i in range(1, len(lines)) if lines[i].strip() == "---"), None)
    if end is None:
        return {}, text, None, None, ["frontmatter is not closed with a '---' line"]
    meta, problems = {}, []
    for line in lines[1:end]:
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        m = KEY_RE.match(line)
        if not m:
            problems.append(f"unreadable frontmatter line: {line.strip()!r}")
            continue
        meta[m.group(1)] = strip_value(m.group(2))
    return meta, "\n".join(lines[end + 1:]), 0, end, problems


def split_sections(body: str) -> dict:
    """The ledger headings -> the text under each, keyed in lower case.

    '## AI original', '## Author final' and '## Improvement decisions' always divide an entry;
    '## Author original' and '## Revisions' (the revision record) divide it as _dividers says. Any other '##'
    line is the section's own text: a business section that opens a new part of its document
    starts with a '## Heading', and it must stay inside the text it belongs to.
    """
    lines = body.splitlines()
    return _sections(lines, _dividers(lines))


def _heading(line: str):
    m = HEADING_RE.match(line)
    return m.group(1).strip().lower() if m else None


def _dividers(lines: list) -> list:
    """(line index, heading) for each line that divides an entry, in order.

    An optional heading never divides inside an HTML comment (a redraft's superseded chain is
    kept in one), and '## Revisions' divides only when it opens a chain: a document whose own
    text has a '## Revisions' part keeps it.
    """
    starts, pos = [], 0
    for line in lines:
        starts.append(pos)
        pos += len(line) + 1
    spans = [m.span() for m in COMMENT_RE.finditer("\n".join(lines))]
    found = []
    for i, line in enumerate(lines):
        name = _heading(line)
        if name in REQUIRED_HEADINGS:
            found.append((i, name))
        elif (name in OPTIONAL_HEADINGS and not any(a < starts[i] < b for a, b in spans)
              and (name != "revisions" or _opens_chain(lines[i + 1:]))):
            found.append((i, name))
    return found


def _opens_chain(rest: list) -> bool:
    """True when the first thing below a '## Revisions' line, past blank lines and comments, is
    a revision marker, a ledger heading or the end of the entry."""
    text = "\n".join(rest)
    while True:
        text = text.lstrip()
        first = text.split("\n", 1)[0].strip()
        if not text or MARKER_LIKE.match(first) or _heading(first) in LEDGER_ORDER:
            return True
        comment = COMMENT_RE.match(text)
        if not comment:
            return False
        text = text[comment.end():]


def _sections(lines: list, cuts: list) -> dict:
    sections = {}
    for k, (i, name) in enumerate(cuts):
        end = cuts[k + 1][0] if k + 1 < len(cuts) else len(lines)
        sections[name] = "\n".join(lines[i + 1:end]).strip()
    return sections


def words(text: str) -> list:
    return re.findall(r"\S+", COMMENT_RE.sub(" ", text or ""))


def paragraphs(text: str) -> list:
    """The words of each paragraph, blank lines parting them, comments aside: two states of the
    revision record are equal when these are, so a paragraph break added or removed is a change.
    A comment counts as no blank line, so one on its own line never parts a paragraph."""
    out = []
    for chunk in re.split(r"\n\s*\n", COMMENT_RE.sub("\x00", text or "")):
        found = words(chunk.replace("\x00", " "))
        if found:
            out.append(found)
    return out


def change_ratio(ai_text: str, final_text: str):
    """1 - similarity of the two texts, word by word; None if either is empty."""
    a, b = words(ai_text), words(final_text)
    if not a or not b:
        return None
    return round(1 - difflib.SequenceMatcher(None, a, b, autojunk=False).ratio(), 2)


def table_rows(text: str) -> list:
    """Data rows of the first Markdown table in text, as lists of cells (header skipped)."""
    rows, seen_header = [], False
    for line in text.splitlines():
        s = line.strip()
        if not s.startswith("|"):
            if seen_header and rows:
                break
            continue
        if s.endswith("|") and not s.endswith("\\|"):
            s = s[:-1]
        cells = [c.strip().replace("\\|", "|") for c in PIPE.split(s[1:])]
        if all(re.fullmatch(r":?-{3,}:?", c) for c in cells if c):
            continue
        if not seen_header:
            seen_header = True
            continue
        if any(cells):
            rows.append(cells)
    return rows


def decision_of(cell: str) -> str:
    """accepted, rejected or author-note; undecided when empty; unknown otherwise."""
    word = re.sub(r"[*_`]", "", cell).strip().lower()
    if word.startswith("accept"):
        return "accepted"
    if word.startswith("reject"):
        return "rejected"
    if re.fullmatch(r"author[- ]note", word):
        return "author-note"
    return "undecided" if word in DASHES else "unknown"


def valid_date(text: str) -> bool:
    """DD/MM/YYYY, and a day the calendar has."""
    if not DATE_RE.match(text):
        return False
    try:
        datetime.datetime.strptime(text, "%d/%m/%Y")
    except ValueError:
        return False
    return True


def row_numbers(rows: str) -> list:
    """'1–4' -> [1, 2, 3, 4]; '5' -> [5]; '1–2, 7' -> [1, 2, 7]. ValueError for anything else."""
    if not ROWS_RE.fullmatch(rows.strip()):
        raise ValueError(f"not row numbers: {rows!r}")
    found = []
    for part in rows.split(","):
        ends = [int(n) for n in re.split(r"\s*[–-]\s*", part.strip())]
        if ends[0] > ends[-1]:
            raise ValueError(f"a range runs backwards: {part.strip()!r}")
        found.extend(range(ends[0], ends[-1] + 1))
    return found


@dataclass
class Revision:
    """One state of the revision chain: the section's full text after the change its marker names."""
    n: int        # 1, 2, 3 … with no gaps
    kind: str     # ai | author-note | author: who made the change from the state before
    date: str     # DD/MM/YYYY
    skill: str    # the skill, with its strength when it has one: 'improve-section (edit)'
    rows: str     # the decision rows it applied ('1–4', '5'), or '' when it names none
    text: str     # verbatim, comments kept

    def row_numbers(self) -> list:
        return row_numbers(self.rows) if self.rows else []


def read_marker(line: str, k: int):
    """The k-th marker line -> ((n, kind, date, skill, rows), None), or (None, the problem)."""
    malformed = f"revision marker {k} is malformed: {line!r}; write {MARKER_FORM!r}"
    parts = MARKER_PARTS.match(line)
    if not parts or not re.fullmatch(r"[0-9]+", parts.group(1)):
        return None, malformed
    n, kind, date, skill, rows = parts.groups()
    rows = rows or ""
    if int(n) != k:
        return None, (f"revision {n} is out of sequence: marker {k} must be revision {k} "
                      f"(revisions run 1, 2, 3 … with no gaps)")
    if kind not in KINDS:
        return None, (f"revision {n} has kind {kind!r}; it must be ai, author-note or author "
                      f"(an accepted AI suggestion is ai)")
    if not DATE_RE.match(date):
        return None, f"revision {n} is dated {date!r}; dates are DD/MM/YYYY"
    if not valid_date(date):
        return None, f"revision {n} is dated {date!r}, a day the calendar lacks"
    if rows:
        try:
            row_numbers(rows)
        except ValueError:
            return None, f"revision {n} names rows {rows!r}; write a row or a range, such as 5 or 1–4"
    if not MARKER_RE.match(line):
        return None, malformed
    return (int(n), kind, date, skill, rows), None


def parse_revisions(text: str):
    """The text under '## Revisions' -> (revisions, problems), read with its comments in place.

    Each marker line opens a state whose text runs to the next marker or the end of the section,
    so a heading or a table inside a state's text stays in that text. A malformed marker still
    ends the state before it but opens no revision: only well-formed revisions are listed.
    """
    lead, blocks = [], []
    current = lead
    for line in (text or "").splitlines():
        if MARKER_LIKE.match(line.strip()):
            current = []
            blocks.append((line.strip(), current))
        else:
            current.append(line)
    revisions, problems = [], []
    if words("\n".join(lead)):
        problems.append("'## Revisions' has text before its first marker; every state opens "
                        "with one")
    for k, (marker, body) in enumerate(blocks, 1):
        fields, problem = read_marker(marker, k)
        if problem:
            problems.append(problem)
            continue
        state = "\n".join(body).strip()
        if not words(state):
            problems.append(f"revision {fields[0]} has no text; a revision holds the section's "
                            f"full text after its change")
            continue
        revisions.append(Revision(*fields, state))
    return revisions, problems


class Entry:
    def __init__(self, path: Path):
        self.path = path
        self.errors, self.warnings = [], []
        text = path.read_text(encoding="utf-8-sig")  # a byte-order mark is not the file's text
        self.meta, body, _, _, problems = split_frontmatter(text)
        self.errors.extend(problems)
        # The template's worked example says so in a comment before its first heading.
        self.example = "<!-- WORKED EXAMPLE" in body.split("\n## ", 1)[0]
        lines = body.splitlines()
        cuts = _dividers(lines)
        self.sections = _sections(lines, cuts)
        self.headings = [name for _, name in cuts]  # as found, repeats and all
        self.ai = self.sections.get("ai original", "")
        self.final = self.sections.get("author final", "")
        raw = self.meta.get("format", "")
        self.format = int(raw) if re.fullmatch(r"[0-9]+", raw) else None
        self.author_original = self.sections.get("author original", "")
        self.revisions, self._revision_problems = parse_revisions(self.sections.get("revisions", ""))
        rows = table_rows(self.sections.get("improvement decisions", ""))
        self.decisions = [decision_of(r[3]) if len(r) >= 4 else "malformed" for r in rows]
        self.unknown = [(n, r[3]) for n, r in enumerate(rows, 1)
                        if len(r) >= 4 and self.decisions[n - 1] == "unknown"]
        self.ratio = change_ratio(self.ai, self.final) if self.origin == "ai" else None
        self._validate()

    @property
    def unit(self):
        return self.meta.get("unit", "")

    @property
    def section(self):
        return self.meta.get("section", "")

    @property
    def origin(self):
        return self.meta.get("origin", "").lower()

    @property
    def promoted(self):
        return self.meta.get("promoted", "")

    @property
    def original(self) -> str:
        """Where the chain starts: the AI original, or the Author original when the author drafted."""
        return self.ai if self.origin == "ai" else self.author_original

    @property
    def reopened(self) -> bool:
        """True when the section was promoted and has changed since without being promoted
        again, so its Author final is the previous final, not the newest state: the final
        differs from the last state, and a revision records it as 'promoted <its date>', or a
        revision or the live draft (a redraft) is dated after the promotion. An entry without
        the revision record can never say so."""
        if self.format != FORMAT or not self.promoted or not words(self.final):
            return False
        last = self.revisions[-1].text if self.revisions else self.original
        if paragraphs(self.final) == paragraphs(last) or not valid_date(self.promoted):
            return False
        when = datetime.datetime.strptime(self.promoted, "%d/%m/%Y")

        def later(date):
            return valid_date(date) and datetime.datetime.strptime(date, "%d/%m/%Y") > when

        return (later(self.meta.get("drafted", ""))
                or any(r.skill == f"promoted {self.promoted}" or later(r.date) for r in self.revisions))

    def chain(self) -> list:
        """[(kind, text)] from the original to the final: ('original', …), each revision as
        (its kind, its text), then ('author', the Author final) when the final differs from the
        last state (paragraphs() says how). An empty Author final (not promoted yet) adds
        nothing, nor does the previous final a reopened section holds until it is promoted again."""
        states = [("original", self.original)] + [(r.kind, r.text) for r in self.revisions]
        if (words(self.final) and paragraphs(self.final) != paragraphs(states[-1][1])
                and not self.reopened):
            states.append(("author", self.final))
        return states

    def _validate(self):
        m = self.meta
        if not m:
            return
        for key in REQUIRED_KEYS:
            if key not in m:
                self.errors.append(f"frontmatter has no '{key}:' line")
        for heading in REQUIRED_HEADINGS:
            if heading not in self.sections:
                self.errors.append(f"no '## {heading.capitalize()}' section")
        if self.unit and self.section and self.path.name != f"{self.unit}--{self.section}.md":
            self.errors.append(f"filename should be '{self.unit}--{self.section}.md' "
                               f"(unit and section from the frontmatter)")
        if self.origin not in ("ai", "author"):
            self.errors.append(f"origin is {m.get('origin', '')!r}; it must be 'ai' or 'author'")
        for key in ("drafted", "promoted"):
            if m.get(key) and not DATE_RE.match(m[key]):
                self.errors.append(f"{key} is {m[key]!r}; dates are DD/MM/YYYY")
        if m.get("learned", "false").lower() not in ("true", "false"):
            self.errors.append(f"learned is {m['learned']!r}; it must be true or false")
        if "malformed" in self.decisions:
            self.errors.append("an improvement decision row has fewer than five columns")
        for n, cell in self.unknown:
            self.warnings.append(f"improvement decision row {n} reads {cell!r}; write accepted, "
                                 f"rejected or author-note (it is not counted until then)")
        if self.origin == "ai" and not words(self.ai):
            self.errors.append("origin is ai but '## AI original' is empty")
        if self.promoted and not words(self.final):
            self.errors.append("promoted is set but '## Author final' is empty")
        stored = m.get("change_ratio", "")
        if self.origin == "author" and stored not in DASHES:
            self.warnings.append("an author-drafted section has no change ratio; clear it")
        if self.origin == "ai" and self.promoted:
            if stored in DASHES:
                self.warnings.append(f"change_ratio is not recorded (computed {self.ratio:.2f}); "
                                     f"run: python3 tooling/provenance.py ratio {self.path.name} --write"
                                     if self.ratio is not None else "change_ratio is not recorded")
            else:
                try:
                    if self.ratio is not None and abs(float(stored) - self.ratio) > 0.005:
                        self.warnings.append(f"change_ratio says {stored} but the texts give "
                                             f"{self.ratio:.2f}; run ratio --write")
                except ValueError:
                    self.errors.append(f"change_ratio is {stored!r}; it must be a number 0.00 to 1.00")
        self._validate_record()

    def _validate_record(self):
        """The revision record. An entry with none of it (one written before v0.3.0) gets no message."""
        raw = self.meta.get("format", "")
        if raw and raw != str(FORMAT):
            self.errors.append(f"format is {raw!r}; it must be {FORMAT} (or absent, in an entry "
                               f"written before v0.3.0)")
        rank = LEDGER_ORDER.index
        for name in OPTIONAL_HEADINGS:
            places = [i for i, h in enumerate(self.headings) if h == name]
            if len(places) > 1:
                self.errors.append(f"'## {TITLES[name]}' appears {len(places)} times; an entry has one")
            if places and any((i < places[0]) != (rank(h) < rank(name))
                              for i, h in enumerate(self.headings) if h != name):
                self.errors.append(f"'## {TITLES[name]}' is out of order: an entry's headings run "
                                   + ", ".join(TITLES[h] for h in LEDGER_ORDER))
        for name in ("ai original", "author original", "author final", "improvement decisions"):
            if any(MARKER_RE.match(s.strip()) for s in self.sections.get(name, "").splitlines()):
                self.errors.append(f"a revision marker sits under '## {TITLES[name]}'; markers "
                                   f"belong under '## Revisions'")
        self.errors.extend(self._revision_problems)
        if self.origin == "ai" and words(self.author_original):
            self.errors.append("origin is ai but '## Author original' has text; it stays empty "
                               "when the AI drafted the section")
        if self.format == FORMAT and self.origin == "author" and not words(self.author_original):
            if self.revisions:
                self.errors.append("origin is author and '## Revisions' records revisions, but "
                                   "'## Author original' is empty; record the text the first "
                                   "revision started from")
            elif self.promoted:
                self.warnings.append("an author-drafted section was promoted with an empty "
                                     "'## Author original'; make compare can show only its final text")
        before = paragraphs(self.original)
        for r in self.revisions:
            now = paragraphs(r.text)
            if before and now == before:
                self.warnings.append(f"revision {r.n} is the same text as the state before it; a "
                                     f"state equal to the one before it is never written")
            before = now
        if not raw and any(h in self.sections for h in OPTIONAL_HEADINGS):
            self.warnings.append(f"the entry has '## Author original' or '## Revisions' but no "
                                 f"'format: {FORMAT}' line; an entry written from v0.3.0 carries one")


def not_ignored(paths: list, where: Path) -> list:
    """The paths git does not ignore (or a negation re-includes); all of them outside a work tree."""
    git = shutil.which("git")
    if not paths or not git:
        return paths
    inside = subprocess.run([git, "rev-parse", "--is-inside-work-tree"], cwd=where,
                            capture_output=True, text=True)
    if inside.stdout.strip() != "true":
        return paths
    names = {str(p.resolve()): p for p in paths}
    proc = subprocess.run([git, "check-ignore", "-z", "--stdin", "--verbose", "--non-matching"],
                          cwd=where, input="".join(n + "\0" for n in names),
                          capture_output=True, text=True, encoding="utf-8")
    if proc.returncode not in (0, 1):
        raise UsageError(f"git check-ignore failed in {shown(where)}: {proc.stderr.strip()}")
    fields = proc.stdout.split("\0")
    keep = set()
    for k in range(0, len(fields) - 3, 4):  # source, line, pattern, path
        source, pattern, path = fields[k], fields[k + 2], fields[k + 3]
        if not source or pattern.startswith("!"):
            keep.add(path)
    return [p for n, p in names.items() if n in keep]


def load_entries(ledger: Path) -> list:
    if not ledger.is_dir():
        raise UsageError(f"ledger folder not found: {shown(ledger)}")
    found = [p for p in sorted(ledger.glob("*.md")) if p.name not in NOT_ENTRIES]
    return [Entry(p) for p in not_ignored(found, ledger)]


def resolve_entry(arg: str, ledger: Path) -> Path:
    p = Path(arg)
    if p.is_file():
        return p
    name = arg if arg.endswith(".md") else arg + ".md"
    if (ledger / name).is_file():
        return ledger / name
    raise UsageError(f"no ledger entry {arg!r} (looked for {p} and {shown(ledger / name)})")


def report(entries, out=None) -> int:
    out = out or sys.stderr
    n = 0
    for e in entries:
        for msg in e.errors:
            print(f"  error   {e.path.name}: {msg}", file=out)
            n += 1
        for msg in e.warnings:
            print(f"  warning {e.path.name}: {msg}", file=out)
    return n


def fmt_ratio(value) -> str:
    return "—" if value is None else f"{value:.2f}"


DISCLOSURE_HEAD = ("Unit", "Sections", "Words", "Author-drafted", "AI-drafted",
                   "Change from AI draft to promoted text", "AI suggestions accepted")
DISCLOSURE_NOTE = ("Change ratio: 1 minus the word-by-word similarity (Python difflib) between each AI "
                   "draft and the text the author promoted, averaged over a unit's AI-drafted sections "
                   "and weighted by the length of each draft. 0.00 means AI drafts were promoted "
                   "unchanged; 1.00 means they were entirely rewritten. It measures how far the text "
                   "moved, not who moved it. AI suggestions are proposals made on drafts, counted when "
                   "the author accepted or rejected them; a change the author asked for in a note, which "
                   "the AI applied (author-note), is the author's own and is not counted.")


def disclosure_row(group) -> list:
    """The disclosure table's cells after the unit, for promoted entries without errors: sections,
    words, author-drafted, AI-drafted, the change ratio weighted by draft length, and the AI
    suggestions accepted. make compare prints the same row on its cover."""
    ai = [e for e in group if e.origin == "ai"]
    weight = sum(len(words(e.ai)) for e in ai if e.ratio is not None)
    mean = (sum(e.ratio * len(words(e.ai)) for e in ai if e.ratio is not None) / weight
            if weight else None)
    decided = [d for e in group for d in e.decisions if d in ("accepted", "rejected")]
    accepted = decided.count("accepted")
    return [str(len(group)), f"{sum(len(words(e.final)) for e in group):,}",
            str(len(group) - len(ai)), str(len(ai)), fmt_ratio(mean),
            f"{accepted} of {len(decided)}" if decided else "—"]


def cmd_table(args) -> int:
    entries = load_entries(args.ledger)
    errors = report(entries)
    usable = [e for e in entries if not e.errors]
    if args.unit:
        usable = [e for e in usable if e.unit == args.unit]
    promoted = [e for e in usable if e.promoted]
    waiting = len(usable) - len(promoted)
    today = datetime.date.today().strftime("%d/%m/%Y")
    if not promoted:
        scope = f" for unit {args.unit}" if args.unit else ""
        print(f"No promoted sections yet{scope}: the ledger holds {len(usable)} usable "
              f"entr{'y' if len(usable) == 1 else 'ies'} and none has been promoted.")
        return 1 if errors else 0

    print("| " + " | ".join(DISCLOSURE_HEAD) + " |")
    print("|---|---|---|---|---|---|---|")
    units = sorted({e.unit for e in promoted})
    for unit in units:
        print("| " + " | ".join([unit] + disclosure_row([e for e in promoted if e.unit == unit])) + " |")
    if len(units) > 1:
        print("| **All units** | " + " | ".join(disclosure_row(promoted)) + " |")
    print()
    print(DISCLOSURE_NOTE)
    if waiting:
        print(f"{waiting} section{'s' if waiting != 1 else ''} drafted but not yet promoted "
              f"{'are' if waiting != 1 else 'is'} excluded.")
    print(f"Generated by tooling/provenance.py on {today} from {len(promoted)} promoted "
          f"ledger entr{'y' if len(promoted) == 1 else 'ies'}.")
    return 1 if errors else 0


def cmd_ratio(args) -> int:
    path = resolve_entry(args.entry, args.ledger)
    e = Entry(path)
    if not e.meta:
        print(f"error: {shown(path)}: {e.errors[0]}", file=sys.stderr)
        return 1
    if e.origin == "author":
        print("n/a (author-drafted: no AI original to compare)")
        return 0
    if e.origin != "ai":
        print(f"error: {shown(path)}: origin must be 'ai' or 'author'", file=sys.stderr)
        return 1
    if e.ratio is None:
        missing = "'## AI original'" if not words(e.ai) else "'## Author final'"
        print(f"error: {shown(path)}: cannot compute a change ratio: {missing} is empty",
              file=sys.stderr)
        return 1
    print(f"{e.ratio:.2f}")
    if args.write:
        write_ratio(path, e.ratio)
        print(f"wrote change_ratio: {e.ratio:.2f} to {shown(path)}")
    return 0


def write_ratio(path: Path, ratio: float) -> None:
    text = path.read_text(encoding="utf-8-sig")
    lines = text.split("\n")
    _, _, _, end, _ = split_frontmatter(text)
    value = f"{ratio:.2f}"
    for i in range(1, end):
        m = re.match(r"^(change_ratio\s*:)([^#]*?)(\s*#.*)?$", lines[i])
        if m:
            comment = m.group(3) or ""
            lines[i] = f"{m.group(1)} {value}" + (" " * 10 + comment.strip() if comment else "")
            break
    else:
        lines.insert(end, f"change_ratio: {value}")
    path.write_text("\n".join(lines), encoding="utf-8")


def cmd_check(args) -> int:
    entries = load_entries(args.ledger)
    problems = report(entries, out=sys.stdout)
    register = args.ledger / REGISTER
    rows = {}
    if register.is_file():
        for cells in table_rows(register.read_text(encoding="utf-8-sig")):
            if len(cells) < 5:
                print(f"  error   {REGISTER}: row {cells!r} has fewer than five columns")
                problems += 1
                continue
            rows[(cells[0], cells[1])] = cells
    else:
        print(f"  warning {REGISTER}: not found in {shown(args.ledger)}")
    promoted = {(e.unit, e.section): e for e in entries if e.promoted and not e.errors}
    for key, e in sorted(promoted.items()):
        row = rows.get(key)
        if row is None and e.example:
            print(f"  warning {REGISTER}: no row for the worked example's promoted section "
                  f"{key[0]} / {key[1]}; add it while practising, or delete the example")
            continue
        if row is None:
            print(f"  error   {REGISTER}: no row for promoted section {key[0]} / {key[1]}")
            problems += 1
            continue
        expected = [e.origin, fmt_ratio(e.ratio), e.promoted]
        found = [row[2].lower(), "—" if row[3] in DASHES else row[3], row[4]]
        for label, want, got in zip(("Origin", "Change ratio", "Promoted"), expected, found):
            if want != got:
                print(f"  error   {REGISTER}: {key[0]} / {key[1]}: {label} is {got!r}; "
                      f"the ledger entry gives {want!r}")
                problems += 1
    for key in sorted(set(rows) - set(promoted)):
        print(f"  error   {REGISTER}: row {key[0]} / {key[1]} has no promoted ledger entry")
        problems += 1
    print(f"{len(entries)} ledger entr{'y' if len(entries) == 1 else 'ies'}, {len(rows)} register "
          f"row{'s' if len(rows) != 1 else ''}: "
          + ("no problems" if not problems else f"{problems} problem{'s' if problems != 1 else ''}"))
    return 1 if problems else 0


SELF_TEST_ENTRY = """---
unit: 01-test
section: opening
origin: ai
drafted: 01/01/2027
promoted: 02/01/2027
change_ratio: —
learned: false
---

## AI original

The river was loud in the dark and the ford was closed.

## Author final

The river was louder in the dark, and the ford was closed to all.

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
| 1 | 'louder' for 'loud' | rhythm | accepted | |
| 2 | cut 'in the dark' | brevity | rejected | keep it |
| 3 | add 'to all' | the author's note | author-note | |
| 4 | tighter \\| shorter | the pipe is quoted | **rejected** | |
| 5 | a comma after 'dark' | rhythm | maybe | |
| 6 | 'shut' for 'closed' | plainness | | |
"""

# What the v0.2.0 reader said about SELF_TEST_ENTRY, word for word: a legacy entry must not change.
SELF_TEST_LEGACY_WARNINGS = [
    "improvement decision row 5 reads 'maybe'; write accepted, rejected or author-note "
    "(it is not counted until then)",
    "change_ratio is not recorded (computed 0.31); run: python3 tooling/provenance.py ratio "
    "01-test--opening.md --write",
]

SELF_TEST_CHAIN = """---
unit: 01-test
section: crossing
origin: author          # ai | author
drafted: 04/10/2026
promoted: 06/10/2026
change_ratio:
learned: false
format: 2
---

## AI original

<!-- Empty: the author drafted this section. -->

## Author original

The river was loud and the ford was shut.

## Revisions

<!-- revision 1 · ai · 04/10/2026 · improve-section (edit) · rows 1–2 -->

The river was louder in the dark, and the ford was shut.

<!-- revision 2 · author · 05/10/2026 · adapt-section -->

The river was louder in the dark, and the ford was closed.

<!-- revision 3 · author-note · 05/10/2026 · adapt-section · rows 3 -->

The river was louder in the dark, and the ford was closed to all.

## Author final

The river was louder in the dark, and the ford was closed to all who came.

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
| 1 | 'louder' for 'loud' | rhythm | accepted | |
| 2 | add 'in the dark' | setting | accepted | |
| 3 | 'closed to all' | the author's note | author-note | |
| 4 | cut 'who came' | brevity | rejected | keep it |
"""

SELF_TEST_BUSINESS = """---
unit: 02-test
section: scope
origin: ai
drafted: 04/10/2026
promoted:
change_ratio:
learned: false
format: 2
---

## AI original

## Scope of work

The work covers the staff handbook.

### Fees

The fee is fixed for the whole review.

<!-- superseded AI original, 03/10/2026: The work covers the handbook.

## Revisions

<!-- revision 1 · ai · 03/10/2026 · improve-section (light) --&gt;

The work covers the whole handbook.
-->

## Author original

<!-- Empty: the AI drafted this section. -->

## Revisions

<!-- revision 1 · ai · 04/10/2026 · improve-section (edit) -->

## Scope of work

The work covers the staff handbook and nothing beyond it.

### Fees

The fee is fixed for the whole review.

| Stage | Weeks |
|---|---|
| Review | 2 |
| Rewrite | 6 |

<!-- revision 2 · author · 05/10/2026 · adapt-section -->

## Scope of work

The work covers the staff handbook, and nothing beyond it.

### Fees

The fee is fixed for the whole review.

## Revisions

Each chapter is revised once.

## Author final

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
"""


def _self_test_record(verdict, probe) -> None:
    """The revision record's cases: legacy entries unchanged, the chain read in order, each new message."""
    import contextlib
    import io
    import tempfile

    def kinds(e):
        return [k for k, _ in e.chain()]

    def says(messages, part):
        return any(part in m for m in messages)

    legacy = probe(SELF_TEST_ENTRY, "01-test--opening.md")
    verdict("a legacy AI-drafted entry reads exactly as before",
            not legacy.errors and legacy.warnings == SELF_TEST_LEGACY_WARNINGS
            and legacy.ratio == 0.31 and legacy.format is None and not legacy.revisions
            and kinds(legacy) == ["original", "author"], (legacy.errors, legacy.warnings))
    without = re.sub(r"## Author original.*?(?=## Author final)", "", SELF_TEST_CHAIN, flags=re.S)
    old = probe(without.replace("format: 2\n", ""))
    verdict("a legacy author-drafted entry reads exactly as before",
            not old.errors and not old.warnings and old.format is None
            and old.chain() == [("original", ""), ("author", old.final)], (old.errors, old.warnings))

    e = probe(SELF_TEST_CHAIN)
    verdict("a clean format-2 entry has no errors or warnings",
            e.format == 2 and not e.errors and not e.warnings, (e.errors, e.warnings))
    verdict("the chain runs original, ai, author, author-note, then the author's final",
            kinds(e) == ["original", "ai", "author", "author-note", "author"]
            and e.chain()[0][1] == e.author_original == e.original
            and e.chain()[-1][1] == e.final, e.chain())
    got = [(r.n, r.kind, r.date, r.skill, r.rows, r.row_numbers()) for r in e.revisions]
    want = [(1, "ai", "04/10/2026", "improve-section (edit)", "1–2", [1, 2]),
            (2, "author", "05/10/2026", "adapt-section", "", []),
            (3, "author-note", "05/10/2026", "adapt-section", "3", [3])]
    verdict("each marker gives its number, kind, date, skill and rows", got == want, got)
    same = probe(SELF_TEST_CHAIN.replace("closed to all who came.", "closed to all."))
    verdict("a final equal to the last state adds no state",
            kinds(same) == ["original", "ai", "author", "author-note"], kinds(same))
    with tempfile.TemporaryDirectory() as tmp:
        (Path(tmp) / "01-test--crossing.md").write_text(SELF_TEST_CHAIN, encoding="utf-8")
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(io.StringIO()):
            code = main(["table", "--ledger", tmp])
        verdict("the table counts a format-2 entry's decisions as before",
                code == 0 and "| 2 of 3 |" in out.getvalue(), out.getvalue())

    b = probe(SELF_TEST_BUSINESS, "02-test--scope.md")
    verdict("a format-2 AI-drafted chain starts at the AI original",
            not b.errors and not b.warnings and b.original == b.ai
            and kinds(b) == ["original", "ai", "author"], (b.errors, b.warnings, kinds(b)))
    verdict("a business section's own ## and ### headings stay in its texts",
            all("## Scope of work" in t and "### Fees" in t for t in (b.ai, *(r.text for r in b.revisions)))
            and len(b.revisions) == 2, [r.text for r in b.revisions])
    verdict("a document's own '## Revisions' part stays in the state that holds it",
            b.revisions[-1:] and "Each chapter is revised once." in b.revisions[-1].text, b.revisions)
    verdict("a superseded chain inside its comment is never read as the live one",
            "superseded AI original" in b.ai and [r.date for r in b.revisions] == ["04/10/2026", "05/10/2026"],
            b.revisions)
    verdict("a table inside a revision's text is never read as decision rows",
            b.decisions == [] and "| Review | 2 |" in b.revisions[0].text, b.decisions)
    promoted = SELF_TEST_BUSINESS.replace("promoted:\n", "promoted: 06/10/2026\n").replace(
        "## Author final\n", "## Author final\n\nThe work covers the staff handbook, and nothing else.\n")
    plain = re.sub(r"## Author original.*?(?=## Author final)", "", promoted, flags=re.S)
    p, q = probe(promoted, "02-test--scope.md"), probe(plain, "02-test--scope.md")
    verdict("the revisions never leak into the change ratio",
            p.ratio is not None and p.ratio == q.ratio, (p.ratio, q.ratio))

    reopened = SELF_TEST_CHAIN.replace(
        "<!-- revision 3 · author-note · 05/10/2026 · adapt-section · rows 3 -->\n\n"
        "The river was louder in the dark, and the ford was closed to all.\n",
        "<!-- revision 3 · author-note · 05/10/2026 · adapt-section · rows 3 -->\n\n"
        "The river was louder in the dark, and the ford was closed to all.\n\n"
        "<!-- revision 4 · author · 07/10/2026 · promoted 06/10/2026 -->\n\n"
        "The river was louder in the dark, and the ford was closed to all who came.\n\n"
        "<!-- revision 5 · ai · 07/10/2026 · adapt-section -->\n\n"
        "The river roared in the dark, and the ford was closed to all who came.\n")
    r = probe(reopened)
    verdict("a reopened section's previous final is never drawn after the new revisions",
            not r.errors and r.reopened and kinds(r) == ["original", "ai", "author", "author-note",
                                                         "author", "ai"], (r.errors, kinds(r)))
    later = probe(SELF_TEST_CHAIN.replace("closed to all who came.", "closed to all.").replace(
        "## Author final\n", "<!-- revision 4 · ai · 08/10/2026 · spelling -->\n\n"
        "The river was louder in the dark, and the ford was closed to all men.\n\n## Author final\n"))
    verdict("a revision dated after the promotion marks it reopened, with no 'promoted' revision",
            not later.errors and later.reopened and kinds(later)[-1] == "ai", (later.errors, kinds(later)))
    redrafted = probe(SELF_TEST_CHAIN.replace("drafted: 04/10/2026", "drafted: 08/10/2026"))
    verdict("a chain restarted after the promotion (drafted later) ends before the old final",
            redrafted.reopened and kinds(redrafted)[-1] == "author-note", kinds(redrafted))
    revert = probe(SELF_TEST_CHAIN.replace("closed to all who came.", "shut.").replace(
        "promoted: 06/10/2026", "promoted: 05/10/2026"))
    verdict("the author's own revert before promotion is still the final step",
            not revert.reopened and kinds(revert)[-1] == "author"
            and revert.chain()[-1][1] == "The river was louder in the dark, and the ford was shut.",
            (kinds(revert), revert.warnings))
    split = probe(SELF_TEST_CHAIN.replace("closed to all who came.", "closed to all.").replace(
        "## Author final\n\nThe river was louder in the dark, and",
        "## Author final\n\nThe river was louder in the dark,\n\nand"))
    verdict("a final that only parts a paragraph is the author's step",
            kinds(split)[-1] == "author" and len(split.chain()) == 5, kinds(split))
    broken = probe(SELF_TEST_CHAIN.replace(
        "<!-- revision 2 · author · 05/10/2026 · adapt-section -->\n\n"
        "The river was louder in the dark, and the ford was closed.",
        "<!-- revision 2 · author · 05/10/2026 · adapt-section -->\n\n"
        "The river was louder in the dark,\n\n<!-- a flag -->\n\nand the ford was shut."))
    verdict("a paragraph break changed is a change; a comment alone parts nothing",
            paragraphs("One two.\n<!-- x -->\nThree.") == [["One", "two.", "Three."]]
            and not any("same text" in w for w in broken.warnings), broken.warnings)
    with tempfile.TemporaryDirectory() as tmp:
        (Path(tmp) / "01-test--crossing.md").write_text("\ufeff" + SELF_TEST_CHAIN, encoding="utf-8")
        bom = Entry(Path(tmp) / "01-test--crossing.md")
        verdict("an entry saved with a byte-order mark reads as any other", not bom.errors, bom.errors)

    errors = (
        ("a malformed marker is an error",
         SELF_TEST_CHAIN.replace("revision 2 · author · 05/10/2026 · adapt-section",
                                 "revision 2 - author - 05/10/2026"), "malformed"),
        ("a marker out of sequence is an error",
         SELF_TEST_CHAIN.replace("revision 3 ·", "revision 4 ·"), "out of sequence"),
        ("an unknown kind is an error",
         SELF_TEST_CHAIN.replace("revision 2 · author ·", "revision 2 · editor ·"), "kind 'editor'"),
        ("a bad revision date is an error",
         SELF_TEST_CHAIN.replace("04/10/2026 · improve", "31/02/2026 · improve"),
         "dated '31/02/2026', a day the calendar lacks"),
        ("a revision with no text is an error",
         SELF_TEST_CHAIN.replace("The river was louder in the dark, and the ford was closed.\n",
                                 "<!-- nothing yet -->\n"), "revision 2 has no text"),
        ("an Author original in an AI-drafted entry is an error",
         SELF_TEST_BUSINESS.replace("<!-- Empty: the AI drafted this section. -->",
                                    "The work covers the handbook."), "origin is ai but"),
        ("revisions with an empty Author original are an error",
         SELF_TEST_CHAIN.replace("The river was loud and the ford was shut.\n", ""),
         "'## Author original' is empty"),
        ("'## Revisions' out of order is an error",
         re.sub(r"(## Revisions.*?)(## Author final.*?)(## Improvement decisions)", r"\2\1\3",
                SELF_TEST_CHAIN, flags=re.S), "out of order"),
        ("text above the first marker leaves the markers stray, and says so",
         SELF_TEST_CHAIN.replace("## Revisions\n", "## Revisions\n\nA stray line.\n"),
         "marker sits under"),
        ("a format other than 2 is an error",
         SELF_TEST_CHAIN.replace("format: 2", "format: two"), "format is 'two'"),
    )
    for label, text, part in errors:
        bad = probe(text, "02-test--scope.md" if "unit: 02-test" in text else "01-test--crossing.md")
        verdict(label, says(bad.errors, part), bad.errors)
    _, lead = parse_revisions("A stray line.\n<!-- revision 1 · ai · 04/10/2026 · spelling -->\nText.")
    verdict("a chain read alone reports text before its first marker",
            says(lead, "before its first marker"), lead)
    again, _ = parse_revisions("<!-- revision 1 · author · 07/10/2026 · promoted 06/10/2026 -->\n"
                               "The final as first promoted.\n"
                               "<!-- revision 2 · ai · 07/10/2026 · spelling · rows 5-6 -->\n"
                               "The final as corrected.")
    verdict("a re-promotion's marker names the promotion it keeps; a hyphen marks a range",
            [(r.kind, r.skill, r.row_numbers()) for r in again]
            == [("author", "promoted 06/10/2026", []), ("ai", "spelling", [5, 6])], again)
    with tempfile.TemporaryDirectory() as tmp:
        (Path(tmp) / "01-test--crossing.md").write_text(errors[0][1], encoding="utf-8")
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            code = main(["table", "--ledger", tmp])
        verdict("an entry with a malformed chain fails the table", code == 1, code)

    warnings = (
        ("a revision equal to the state before it is a warning",
         SELF_TEST_CHAIN.replace("the ford was closed.\n", "the ford was shut.\n"), "same text"),
        ("a promoted author-drafted entry with no Author original is a warning",
         re.sub(r"(## Author original\n).*?(?=## Author final)", r"\1\n", SELF_TEST_CHAIN, flags=re.S),
         "empty '## Author original'"),
        ("the record's headings without 'format: 2' are a warning",
         SELF_TEST_CHAIN.replace("format: 2\n", ""), "no 'format: 2' line"),
    )
    for label, text, part in warnings:
        soft = probe(text)
        verdict(label, not soft.errors and says(soft.warnings, part), (soft.errors, soft.warnings))


def self_test() -> int:
    """Prove the decisions are read and counted as the docstring says."""
    import contextlib
    import io
    import tempfile
    failures = []

    def verdict(label, passed, detail=""):
        print(f"  {'ok  ' if passed else 'FAIL'} {label}")
        if not passed:
            failures.append(label)
            print(f"         {detail}")

    print("provenance.py --self-test")
    with tempfile.TemporaryDirectory() as tmp:
        ledger = Path(tmp)
        (ledger / "01-test--opening.md").write_text(SELF_TEST_ENTRY, encoding="utf-8")
        entry = Entry(ledger / "01-test--opening.md")
        want = ["accepted", "rejected", "author-note", "rejected", "unknown", "undecided"]
        verdict("each decision is read, a quoted \\| included", entry.decisions == want, entry.decisions)
        verdict("an unknown decision is reported", any("'maybe'" in w for w in entry.warnings),
                entry.warnings)
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            code = main(["table", "--ledger", str(ledger)])
        table = out.getvalue()
        verdict("the table prints", code == 0, err.getvalue())
        verdict("an author-note is counted as no AI suggestion", "| 1 of 3 |" in table, table)
        verdict("the change column says what it measures",
                "Change from AI draft to promoted text" in table, table)
    for example, want_code in ((True, 0), (False, 1)):
        with tempfile.TemporaryDirectory() as tmp:
            ledger = Path(tmp)
            text = SELF_TEST_ENTRY
            if example:
                text = text.replace("---\n\n## AI original",
                                    "---\n\n<!-- WORKED EXAMPLE: shipped once. -->\n\n## AI original")
            (ledger / "01-test--opening.md").write_text(text, encoding="utf-8")
            (ledger / REGISTER).write_text("| Unit | Section | Origin | Change ratio | Promoted |\n"
                                           "|---|---|---|---|---|\n", encoding="utf-8")
            out = io.StringIO()
            with contextlib.redirect_stdout(out), contextlib.redirect_stderr(io.StringIO()):
                code = main(["check", "--ledger", str(ledger)])
            label = ("a worked example's missing register row is only a warning" if example
                     else "any other promoted entry with no register row fails the check")
            verdict(label, code == want_code and "no row for" in out.getvalue(), out.getvalue())

    def probe(text, name="01-test--crossing.md"):
        with tempfile.TemporaryDirectory() as tmp:
            (Path(tmp) / name).write_text(text, encoding="utf-8")
            return Entry(Path(tmp) / name)

    _self_test_record(verdict, probe)
    if shutil.which("git"):
        with tempfile.TemporaryDirectory() as tmp:
            ledger = Path(tmp)
            subprocess.run(["git", "init", "-q", str(ledger)], check=True)
            for name in ("01-test--opening.md", "01-test--local.md", "01-test--kept.md"):
                (ledger / name).write_text(SELF_TEST_ENTRY, encoding="utf-8")
            (ledger / ".gitignore").write_text("*--local.md\n*--kept.md\n!*--kept.md\n", encoding="utf-8")
            got = sorted(p.name for p in not_ignored(sorted(ledger.glob("*.md")), ledger))
            verdict("an entry git ignores is never read; a re-included one is",
                    got == ["01-test--kept.md", "01-test--opening.md"], got)
        with tempfile.TemporaryDirectory() as tmp:
            plain = [Path(tmp) / "01-test--opening.md"]
            verdict("outside a work tree every entry is read", not_ignored(plain, Path(tmp)) == plain)
    else:
        print("  skip git: git not found")
    if failures:
        print(f"self-test FAILED: {len(failures)} case(s)")
        return 1
    print("self-test passed")
    return 0


def main(argv=None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--ledger", type=Path, default=DEFAULT_LEDGER,
                        help="the ledger folder (default: standards/style/ledger)")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd")
    t = sub.add_parser("table", parents=[common], help="print the per-unit disclosure table")
    t.add_argument("--unit", help="only this unit's slug")
    r = sub.add_parser("ratio", parents=[common], help="compute one entry's change ratio")
    r.add_argument("entry", help="a ledger entry path, or its unit--section name")
    r.add_argument("--write", action="store_true", help="also record it in the entry's frontmatter")
    sub.add_parser("check", parents=[common], help="check every entry and the register")
    argv = sys.argv[1:] if argv is None else argv
    if argv[:1] == ["--self-test"]:
        return self_test()
    if not argv or (argv[0].startswith("-") and argv[0] not in ("-h", "--help")):
        argv = ["table"] + list(argv)
    args = ap.parse_args(argv)
    try:
        return {"table": cmd_table, "ratio": cmd_ratio, "check": cmd_check}[args.cmd](args)
    except UsageError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    except (OSError, UnicodeDecodeError) as err:
        print(f"error: {err}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
