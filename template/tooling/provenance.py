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
import sys
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
    """The three ledger headings -> the text under each, keyed in lower case.

    Only '## AI original', '## Author final' and '## Improvement decisions' divide an entry.
    Any other '##' line is the section's own text: a business section that opens a new part of
    its document starts with a '## Heading', and it must stay inside the text it belongs to.
    """
    sections, current, buf = {}, None, []
    for line in body.splitlines():
        m = re.match(r"^##\s+(.+?)\s*$", line)
        if m and m.group(1).strip().lower() in REQUIRED_HEADINGS:
            if current is not None:
                sections[current] = "\n".join(buf).strip()
            current, buf = m.group(1).strip().lower(), []
        elif current is not None:
            buf.append(line)
    if current is not None:
        sections[current] = "\n".join(buf).strip()
    return sections


def words(text: str) -> list:
    return re.findall(r"\S+", COMMENT_RE.sub(" ", text or ""))


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
    """accepted, rejected or author-note (D38); undecided when empty; unknown otherwise."""
    word = re.sub(r"[*_`]", "", cell).strip().lower()
    if word.startswith("accept"):
        return "accepted"
    if word.startswith("reject"):
        return "rejected"
    if re.fullmatch(r"author[- ]note", word):
        return "author-note"
    return "undecided" if word in DASHES else "unknown"


class Entry:
    def __init__(self, path: Path):
        self.path = path
        self.errors, self.warnings = [], []
        text = path.read_text(encoding="utf-8")
        self.meta, body, _, _, problems = split_frontmatter(text)
        self.errors.extend(problems)
        # The template's worked example says so in a comment before its first heading.
        self.example = "<!-- WORKED EXAMPLE" in body.split("\n## ", 1)[0]
        self.sections = split_sections(body)
        self.ai = self.sections.get("ai original", "")
        self.final = self.sections.get("author final", "")
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


def load_entries(ledger: Path) -> list:
    if not ledger.is_dir():
        raise UsageError(f"ledger folder not found: {shown(ledger)}")
    return [Entry(p) for p in sorted(ledger.glob("*.md")) if p.name not in NOT_ENTRIES]


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

    def summarise(group):
        ai = [e for e in group if e.origin == "ai"]
        weight = sum(len(words(e.ai)) for e in ai if e.ratio is not None)
        mean = (sum(e.ratio * len(words(e.ai)) for e in ai if e.ratio is not None) / weight
                if weight else None)
        decided = [d for e in group for d in e.decisions if d in ("accepted", "rejected")]
        accepted = decided.count("accepted")
        return [str(len(group)), f"{sum(len(words(e.final)) for e in group):,}",
                str(len(group) - len(ai)), str(len(ai)), fmt_ratio(mean),
                f"{accepted} of {len(decided)}" if decided else "—"]

    print("| Unit | Sections | Words | Author-drafted | AI-drafted "
          "| Change from AI draft to promoted text | AI suggestions accepted |")
    print("|---|---|---|---|---|---|---|")
    units = sorted({e.unit for e in promoted})
    for unit in units:
        print("| " + " | ".join([unit] + summarise([e for e in promoted if e.unit == unit])) + " |")
    if len(units) > 1:
        print("| **All units** | " + " | ".join(summarise(promoted)) + " |")
    print()
    print("Change ratio: 1 minus the word-by-word similarity (Python difflib) between each AI "
          "draft and the text the author promoted, averaged over a unit's AI-drafted sections "
          "and weighted by the length of each draft. 0.00 means AI drafts were promoted "
          "unchanged; 1.00 means they were entirely rewritten. It measures how far the text "
          "moved, not who moved it. AI suggestions are proposals made on drafts, counted when "
          "the author accepted or rejected them; a change the author asked for in a note, which "
          "the AI applied (author-note), is the author's own and is not counted.")
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
    text = path.read_text(encoding="utf-8")
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
        for cells in table_rows(register.read_text(encoding="utf-8")):
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
