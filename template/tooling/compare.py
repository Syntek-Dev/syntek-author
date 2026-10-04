#!/usr/bin/env python3
"""compare.py: how each section moved from its original to its final text.

Reads one unit's ledger entries in standards/style/ledger/ through provenance.py, follows each
section's record from its original through every revision to its final, and writes the
comparison `make compare` prints, as a Pandoc document (JSON) that the Makefile sets with
XeLaTeX. Run it through make, never by hand.

Usage:
    python3 tooling/compare.py units [--ledger DIR]
    python3 tooling/compare.py ast --unit UNIT [--section SLUG] [--ledger DIR]
                               [--briefs DIR] [--pandoc-arg ARG ...] -o FILE
    python3 tooling/compare.py --self-test

units  prints each unit that has a ledger entry, one per line.
ast    writes the comparison of one unit, or of one of its sections, as Pandoc's JSON. UNIT is
       the brief's filename stem, number included ('03-the-ford'); a path to the brief or to the
       unit's folder is read as its last part. Each --pandoc-arg is passed to every Pandoc run
       that reads a state's Markdown: the Makefile passes the house filter this way.

What it shows. A cover with the key, the unit's disclosure table (the row `make provenance`
prints for it) and a table of its sections; then each section, in the order of the brief's
`sections:` list (planning/src/units/<unit>.md; a section with an entry but
not in the plan comes last, under 'Not in the plan'; with no brief, name order and a warning):
a heading block (origin, the stages recorded, the revision list, and two figures: the change
from the original to the AI edit, and from the AI edit to the final, each the change ratio
provenance.py computes), the redline, and a landscape page in three columns (Original, AI edit,
Final, aligned by paragraph). The AI edit is the state after the last ai or author-note
revision.

Who changed each word. The record is a chain of full texts: the original (the AI original, or
the Author original when the author drafted), each revision, then the Author final. Every step is
compared word by word (Python difflib, as provenance.py compares), and a word a step added is
that step's: the kind its revision marker names (ai, author-note, author), or the author's for
the step to the final. A word a step removed stays where it stood, struck through by that step;
a word one step added and a later one removed is shown as removed by the later step. In the
three columns a changed word is tinted in the colour of the step that changed it: in Original,
the step that removed it; in AI edit and Final, the step that added it. A passage a step moved
shows as removed where it stood and added where it went, both by the step that moved it: the
comparison follows words, not passages. A footnote keeps one identity along the chain, so a
word changed inside it stays inside it when an earlier note is added or removed.

A section promoted and then reopened (provenance.py's Entry.reopened: a revision records its
final as 'promoted <date>', or one is dated after the promotion) is shown to its latest
revision: its Author final is the previous final, held until it is promoted again, and is
never drawn as a later state.

An entry with no 'format: 2' predates the record. An AI-drafted one is shown from its AI original
to its final with every change unattributed; an author-drafted one, or one whose Author original
was never written, as its final alone. Each says the stages were not recorded: nothing is
guessed.

Words. Each state is read by Pandoc (-f markdown -t json), so the words are those a reader meets:
emphasis, links, quotation marks and footnotes are kept (a footnote's words are compared inside
it), and comments are dropped (flags, section markers, a superseded original). Paragraph breaks
are compared like words: a break one step added ends its paragraph with a marked pilcrow, and one
it removed is a struck pilcrow. A table is shown row by row, its cells parted by a bar; a list
item (numbered or not), a heading, a quotation and an epigraph keep their shape. Raw LaTeX in a
state is layout, and is left out. A citation, code or maths takes its step's line around a box;
a long marked word gets places to break (ulem never hyphenates), so it cannot run off the page.

Never read: a ledger entry or a brief git ignores (provenance.py's filter).

Standard library only; Python 3.11 or later. `ast` needs pandoc; the self-test needs neither
pandoc nor TeX, and runs its Pandoc cases only where pandoc is installed.
Exit codes: 0 = done (warnings may be printed); 1 = a ledger entry in scope is malformed (it is
left out, the cover says so, and the rest is written); 2 = usage error, no entry for the unit or
section, pandoc missing or failing, or a file that cannot be read.
"""
from __future__ import annotations

import argparse
import datetime
import difflib
import itertools
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import provenance  # noqa: E402
from provenance import ROOT, UsageError, change_ratio, not_ignored, shown, words  # noqa: E402

HERE = Path(__file__).resolve().parent
DEFAULT_BRIEFS = ROOT / "planning" / "src" / "units"
API_VERSION = [1, 23, 1]  # Pandoc 3.1's; the version Pandoc reports replaces it when it runs
ACTORS = ("ai", "author-note", "author", "unattributed")
MACRO = {"ai": "ai", "author-note": "note", "author": "author", "unattributed": "unatt"}
AI_KINDS = ("ai", "author-note")
SIMPLE = ("Emph", "Strong", "Underline", "Strikeout", "Superscript", "Subscript", "SmallCaps")
PILCROW = "¶"
NOTHING = "—"


class ToolError(Exception):
    """Pandoc missing or failing (exit 2)."""


# ── Tokens ─────────────────────────────────────────────────────────────────────────────────
# A state is a list of tokens: words ('w'), atoms that are compared whole and never broken
# ('a': a citation, inline code, maths, an image, a line break, a table's cell bar), paragraph
# breaks ('p', naming the kind of paragraph that follows) and paragraph breaks inside a
# footnote ('n'). A token's style is the inline marks around it, outermost first; its key is
# what the comparison sees, so a word that gains emphasis is a changed word.

class Tok:
    __slots__ = ("kind", "text", "style", "space", "data", "key")

    def __init__(self, kind, text="", style=(), space=True, data=None):
        self.kind, self.text, self.style, self.space, self.data = kind, text, style, space, data
        signature = tuple(("Note",) if e[0] == "Note" else e for e in style)
        self.key = (kind, text) if kind == "p" else (kind, text, signature)

    def __repr__(self):
        return f"Tok({self.kind}:{self.text!r})"


def stringify(inlines) -> str:
    out = []
    for el in inlines or []:
        t, c = el["t"], el.get("c")
        if t == "Str":
            out.append(c)
        elif t in ("Space", "SoftBreak", "LineBreak"):
            out.append(" ")
        elif t in ("Code", "Math"):
            out.append(c[1])
        elif t in SIMPLE or t == "Quoted":
            out.append(stringify(c if t != "Quoted" else c[1]))
        elif t in ("Span", "Link", "Image"):
            out.append(stringify(c[1]))
        elif t == "Cite":
            out.append(stringify(c[1]))
    return "".join(out)


class Reader:
    """Pandoc's blocks -> tokens."""

    def __init__(self):
        self.out, self.space, self.notes = [], False, 0

    def run(self, blocks) -> list:
        self.blocks(blocks, ("para", 0, ""))
        return self.out

    def brk(self, kind, depth, label=""):
        self.out.append(Tok("p", f"{kind}{depth}", space=False, data=label))
        self.space = False

    def para(self, ctx, inlines, style=()):
        self.brk(*ctx)
        self.inline(inlines, style)

    def blocks(self, blocks, ctx):
        kind, depth, _ = ctx
        for b in blocks:
            t, c = b["t"], b.get("c")
            if t in ("Para", "Plain"):
                self.para(ctx, c)
                if kind in ("item", "enum"):
                    ctx = ("cont", depth, "")
            elif t == "Header":
                self.para(("head", min(c[0], 6), ""), c[2])
            elif t == "BulletList":
                for item in c:
                    self.blocks(item, ("item", depth + 1, ""))
            elif t == "OrderedList":
                (start, _style, delim), items = c
                close = {"OneParen": ")", "TwoParens": ")"}.get(delim["t"], ".")
                for n, item in enumerate(items):
                    self.blocks(item, ("enum", depth + 1, f"{start + n}{close}"))
            elif t == "BlockQuote":
                self.blocks(c, ("quote", depth + 1, ""))
            elif t == "Div":
                classes = c[0][1]
                if "scene-break" in classes:
                    self.brk("break", 0)
                elif "epigraph" in classes:
                    self.blocks(c[1], ("epigraph", 0, ""))
                else:
                    self.blocks(c[1], ctx)
            elif t == "HorizontalRule":
                self.brk("break", 0)
            elif t == "CodeBlock":
                for line in c[1].split("\n"):
                    self.para(("code", 0, ""), _plain_inlines(line))
            elif t == "LineBlock":
                for line in c:
                    self.para(("line", 0, ""), line)
            elif t == "DefinitionList":
                for term, defs in c:
                    self.para(("term", 0, ""), term)
                    for d in defs:
                        self.blocks(d, ("quote", depth + 1, ""))
            elif t == "Table":
                self.table(c)
            elif t == "Figure":
                self.blocks(c[2], ctx)
                self.blocks(c[1][1], ctx)
            # RawBlock: comments, flags and raw LaTeX are not words; Null holds nothing.

    def table(self, c):
        _, _, _, head, bodies, foot = c
        rows = [(r, True) for r in head[1]]
        for body in bodies:
            rows += [(r, True) for r in body[2]] + [(r, False) for r in body[3]]
        rows += [(r, False) for r in foot[1]]
        for row, is_head in rows:
            self.brk("row", 0)
            for k, cell in enumerate(row[1]):
                if k:
                    self.atom("|", {"t": "Str", "c": "|"}, ())
                    self.space = True
                style = (("Strong",),) if is_head else ()
                for inlines in note_paragraphs(cell[4]):
                    self.inline(inlines, style)
                    self.space = True

    def word(self, text, style):
        self.out.append(Tok("w", text, style, self.space))
        self.space = False

    def atom(self, key, element, style):
        self.out.append(Tok("a", key, style, self.space, element))
        self.space = False

    def inline(self, inlines, style):
        for el in inlines:
            t, c = el["t"], el.get("c")
            if t == "Str":
                self.word(c, style)
            elif t in ("Space", "SoftBreak"):
                self.space = True
            elif t == "LineBreak":
                self.atom("line break", el, style)
            elif t in SIMPLE:
                self.inline(c, style + ((t,),))
            elif t == "Span":
                attr = c[0]
                self.inline(c[1], style + (("Span", tuple(attr[1]),
                                            tuple(tuple(kv) for kv in attr[2])),))
            elif t == "Link":
                self.inline(c[1], style + (("Link", c[2][0], c[2][1]),))
            elif t == "Quoted":
                left, right = ("‘", "’") if c[0]["t"] == "SingleQuote" else ("“", "”")
                self.word(left, style)
                self.inline(c[1], style)
                self.space = False
                self.word(right, style)
            elif t == "Cite":
                key = "; ".join(
                    f"{ci['citationMode']['t']} {stringify(ci['citationPrefix'])} @{ci['citationId']} "
                    f"{stringify(ci['citationSuffix'])}".strip() for ci in c[0])
                self.atom("cite " + key, el, style)
            elif t == "Code":
                self.atom("code " + c[1], el, style)
            elif t == "Math":
                self.atom("math " + c[1], el, style)
            elif t == "RawInline":
                if c[0] != "html":  # an HTML comment is a flag or a note, never a word
                    self.atom(f"raw {c[0]} {c[1]}", el, style)
            elif t == "Image":
                alt = stringify(c[1]) or c[2][0]
                self.atom("image " + c[2][0], {"t": "Emph", "c": _plain_inlines(f"[image: {alt}]")}, style)
            elif t == "Note":
                self.notes += 1
                self.note(c, style + (("Note", self.notes),))

    def note(self, blocks, style):
        before = self.space
        for k, inlines in enumerate(note_paragraphs(blocks)):
            if k:
                self.out.append(Tok("n", PILCROW, style, False))
            self.space = before if k == 0 else False
            self.inline(inlines, style)
        self.space = False


def note_paragraphs(blocks):
    """The inline content of each paragraph in a footnote or a table cell, in order."""
    for b in blocks:
        t, c = b["t"], b.get("c")
        if t in ("Para", "Plain"):
            yield c
        elif t == "Header":
            yield c[2]
        elif t == "LineBlock":
            yield from c
        elif t in ("BulletList",):
            for item in c:
                yield from note_paragraphs(item)
        elif t == "OrderedList":
            for item in c[1]:
                yield from note_paragraphs(item)
        elif t == "BlockQuote":
            yield from note_paragraphs(c)
        elif t == "Div":
            yield from note_paragraphs(c[1])
        elif t == "CodeBlock":
            yield _plain_inlines(c[1])
        elif t == "Table":
            for body in c[4]:
                for row in body[3]:
                    for cell in row[1]:
                        yield from note_paragraphs(cell[4])


def _plain_inlines(text: str) -> list:
    out = []
    for n, w in enumerate(text.split()):
        if n:
            out.append({"t": "Space"})
        out.append({"t": "Str", "c": w})
    return out


def plain_blocks(text: str) -> list:
    """A stand-in for Pandoc's reader, for the self-test: blank lines part paragraphs, '#' lines
    are headings, '* * *' is a scene break, '^[…]' is a footnote and '*word*' is emphasis."""
    blocks = []
    for chunk in re.split(r"\n\s*\n", provenance.COMMENT_RE.sub("", text or "")):
        chunk = chunk.strip()
        if not chunk:
            continue
        if chunk == "* * *":
            blocks.append({"t": "HorizontalRule"})
            continue
        m = re.match(r"^(#{1,6})\s+(.*)$", chunk)
        if m:
            blocks.append({"t": "Header", "c": [len(m.group(1)), ["", [], []], _rich(m.group(2))]})
        else:
            blocks.append({"t": "Para", "c": _rich(" ".join(chunk.split()))})
    return blocks


def _rich(text: str) -> list:
    out = []
    for n, part in enumerate(re.split(r"(\^\[[^\]]*\])", text)):
        if n % 2:
            out.append({"t": "Note", "c": [{"t": "Para", "c": _rich(part[2:-1])}]})
            continue
        for k, w in enumerate(part.split(" ")):
            if not w:
                if k or out:
                    out.append({"t": "Space"})
                continue
            if k and out and out[-1]["t"] != "Space":
                out.append({"t": "Space"})
            m = re.fullmatch(r"\*([^*]+)\*(\W*)", w)
            out.extend([{"t": "Emph", "c": [{"t": "Str", "c": m.group(1)}]}]
                       + ([{"t": "Str", "c": m.group(2)}] if m.group(2) else []) if m
                       else [{"t": "Str", "c": w}])
    while out and out[-1]["t"] == "Space":
        out.pop()
    return out


class PandocReader:
    """Each state's Markdown -> tokens, through `pandoc -f markdown -t json` and its arguments."""

    def __init__(self, args=()):
        self.exe = shutil.which("pandoc")
        if not self.exe:
            raise ToolError("pandoc not found; make compare needs Pandoc")
        self.args, self.cache, self.version = list(args), {}, None

    def blocks(self, text: str) -> list:
        proc = subprocess.run([self.exe, "-f", "markdown", "-t", "json", *self.args], input=text,
                              capture_output=True, text=True, encoding="utf-8")
        if proc.returncode != 0:
            raise ToolError(f"pandoc failed: {proc.stderr.strip()}")
        if proc.stderr.strip():
            sys.stderr.write(proc.stderr)
        doc = json.loads(proc.stdout)
        self.version = self.version or doc.get("pandoc-api-version")
        return doc["blocks"]

    def __call__(self, text: str) -> list:
        if text not in self.cache:
            self.cache[text] = Reader().run(self.blocks(text)) if words(text) else []
        return self.cache[text]


def plain_reader(text: str) -> list:
    return Reader().run(plain_blocks(text)) if words(text) else []


# ── Attribution ────────────────────────────────────────────────────────────────────────────

class Item:
    """One token in the redline: who added it ('original' when it was there from the start),
    and who removed it (None while it is live)."""
    __slots__ = ("tok", "first", "added", "removed")

    def __init__(self, tok, added, removed=None):
        self.tok, self.added, self.removed = tok, added, removed
        self.first = tok  # as the state that added it wrote it; tok follows each later state

    def __repr__(self):
        return f"Item({self.tok.text!r}, +{self.added}, -{self.removed})"


def edit_ops(a: list, b: list) -> list:
    """['=', i, j] / ['-', i, None] / ['+', None, j], difflib's way (as provenance.py's ratio),
    then each run of pure deletions or insertions slid to a paragraph's edges where it can be."""
    ops = []
    matcher = difflib.SequenceMatcher(None, [t.key for t in a], [t.key for t in b], autojunk=False)
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal":
            ops += [["=", i, j] for i, j in zip(range(i1, i2), range(j1, j2))]
        else:
            ops += [["-", i, None] for i in range(i1, i2)] + [["+", None, j] for j in range(j1, j2)]
    return _slide(ops, a, b)


def _slide(ops: list, a: list, b: list) -> list:
    """A run of tokens added (or removed) between two equal stretches can often sit one token
    earlier or later with the same meaning, because the token at one end equals the token past
    the other: difflib picks one place, often mid-paragraph. Prefer the place where the run
    starts with a paragraph break and ends before one, so a new paragraph reads as one."""
    k = 0
    while k < len(ops):
        tag = ops[k][0]
        e = k
        while e < len(ops) and ops[e][0] == tag:
            e += 1
        if tag != "=" and (k == 0 or ops[k - 1][0] == "=") and (e == len(ops) or ops[e][0] == "="):
            seq, at = (a, 1) if tag == "-" else (b, 2)

            def score(s, f):
                first, last = ops[s][at], ops[f - 1][at]
                return (2 * (seq[first].kind == "p")
                        + (last + 1 == len(seq) or seq[last + 1].kind == "p"))

            def left(s, f):
                if s == 0 or ops[s - 1][0] != "=" or seq[ops[s - 1][at]].key != seq[ops[f - 1][at]].key:
                    return False
                x, y = ops[s - 1], ops[f - 1]
                moved = ["=", y[1], x[2]] if tag == "-" else ["=", x[1], y[2]]
                ops[s:f] = [op for op in ops[s:f - 1]]
                ops[s - 1:s] = [[tag, x[1], None] if tag == "-" else [tag, None, x[2]]]
                ops.insert(f - 1, moved)
                return True

            def right(s, f):
                if f == len(ops) or ops[f][0] != "=" or seq[ops[s][at]].key != seq[ops[f][at]].key:
                    return False
                x, z = ops[s], ops[f]
                moved = ["=", x[1], z[2]] if tag == "-" else ["=", z[1], x[2]]
                rest = ops[s + 1:f] + [[tag, z[1], None] if tag == "-" else [tag, None, z[2]]]
                ops[s:f + 1] = [moved] + rest
                return True

            length, start, origin = e - k, k, k
            while left(start, start + length):
                start -= 1
            best, best_at = None, start
            while True:
                s = (score(start, start + length), -abs(start - origin))
                if best is None or s > best:
                    best, best_at = s, start
                if not right(start, start + length):
                    break
                start += 1
            while start > best_at:
                left(start, start + length)
                start -= 1
            k = start + length
        else:
            k = e
    return ops


def _note_of(tok):
    """The identity of the footnote a token sits in, or None outside a note."""
    return next((e[1] for e in tok.style if e[0] == "Note"), None)


def _renote(tok, ident):
    style = tuple(("Note", ident) if e[0] == "Note" else e for e in tok.style)
    return Tok(tok.kind, tok.text, style, tok.space, tok.data)


def step(items: list, new: list, kind: str, fresh=0) -> list:
    """The redline after one more state: words kept, removed (struck by `kind`, in place) or
    added (by `kind`, after anything already struck at that place). Each state numbers its own
    footnotes, so a note in `new` takes the identity of the note its kept words came from (a
    note with none gets a fresh one, marked by `fresh`): a word struck inside a note stays in
    the same note as its neighbours however the notes before it change."""
    live = [it for it in items if it.removed is None]
    ops = edit_ops([it.tok for it in live], new)
    same = {}
    for tag, i, j in ops:
        if tag == "=" and _note_of(new[j]) is not None and _note_of(live[i].tok) is not None:
            same.setdefault(_note_of(new[j]), _note_of(live[i].tok))
    new = [t if _note_of(t) is None else _renote(t, same.get(_note_of(t), (fresh, _note_of(t))))
           for t in new]
    nxt, upcoming = [len(live)] * len(ops), len(live)
    for n in range(len(ops) - 1, -1, -1):
        nxt[n] = upcoming
        if ops[n][0] != "+":
            upcoming = ops[n][1]
    out, pos = [], 0

    def copy_to(target):
        nonlocal pos
        while pos < len(items) and items[pos] is not target:
            out.append(items[pos])
            pos += 1

    for n, (tag, i, j) in enumerate(ops):
        if tag == "+":
            copy_to(live[nxt[n]] if nxt[n] < len(live) else None)
            out.append(Item(new[j], kind))
            continue
        copy_to(live[i])
        it = items[pos]
        pos += 1
        if tag == "=":
            it.tok = new[j]
        else:
            it.removed = kind
        out.append(it)
    out.extend(items[pos:])
    return out


def attribute(states: list, upto=None):
    """states: [(kind, tokens)], the first the original. Returns (items, snapshot): the redline
    of the whole chain (every item ever made, struck or live, in place), and the items live
    after state `upto`, each with its token as it stood then."""
    items = [Item(t, "original") for t in states[0][1]] if states else []
    snapshot = None
    for n, (kind, toks) in enumerate(states):
        if n:
            items = step(items, toks, kind, n)
        if n == upto:
            snapshot = [(it, it.tok) for it in items if it.removed is None]
    return items, snapshot


# ── Pandoc's document: building blocks ─────────────────────────────────────────────────────

def Str(s):
    return {"t": "Str", "c": s}


SPACE = {"t": "Space"}


def text(s: str) -> list:
    return _plain_inlines(s)


def raw_inline(tex):
    return {"t": "RawInline", "c": ["latex", tex]}


def raw_block(tex):
    return {"t": "RawBlock", "c": ["latex", tex]}


def para(inlines):
    return {"t": "Para", "c": inlines}


def plain(inlines):
    return {"t": "Plain", "c": inlines}


def header(level, inlines):
    return {"t": "Header", "c": [level, ["", ["unnumbered"], []], inlines]}


def emph(inlines):
    return {"t": "Emph", "c": inlines}


def strong(inlines):
    return {"t": "Strong", "c": inlines}


def bullets(items):
    return {"t": "BulletList", "c": [[plain(i)] for i in items]}


def tex_escape(s: str) -> str:
    named = {"\\": r"\textbackslash{}", "^": r"\textasciicircum{}", "~": r"\textasciitilde{}"}
    return re.sub(r"[\\{}%#&_$^~]", lambda m: named.get(m.group(), "\\" + m.group()), s)


def table(head: list, rows: list, widths: list) -> dict:
    """A table whose columns wrap, each a fraction of the text width."""
    nil = ["", [], []]

    def row(cells):
        return [nil, [[nil, {"t": "AlignDefault"}, 1, 1, [plain(c)]] for c in cells]]

    specs = [[{"t": "AlignLeft"}, {"t": "ColWidth", "c": w}] for w in widths]
    return {"t": "Table", "c": [nil, [None, []], specs, [nil, [row(head)]],
                                [[nil, 0, [], [row(r) for r in rows]]], [nil, []]]}


def marked(mark, inlines, atom=None):
    """Inlines inside the macro for a mark: ('ins'|'del'|'tint', actor), or None for none.
    Words go inside the ulem macro. An atom ulem cannot read (a citation, code, maths, an image:
    atom 'box') goes inside it in a box, which ulem marks whole; a line break or raw LaTeX (atom
    'ink') takes the colour alone, because there is nothing to draw a line under."""
    if not mark or not inlines:
        return inlines
    op, actor = mark
    if atom == "ink":
        return [raw_inline(r"\cmpink{" + MACRO[actor] + "}{")] + inlines + [raw_inline("}")]
    name = rf"\cmptint{MACRO[actor]}" if op == "tint" else rf"\cmp{MACRO[actor]}{op}"
    if atom == "box":
        return [raw_inline(name + r"{\mbox{")] + inlines + [raw_inline("}}")]
    return [raw_inline(name + "{")] + inlines + [raw_inline("}")]


LONG_WORD = 18  # letters; a marked word longer than this gets places to break


def breakable(word: str) -> list:
    """A long word inside a mark, with places to break it, because ulem never hyphenates: after
    each '/', '.', '-', '_', '=', '&', '?' or '#' of a web address (no hyphen shown), or a
    discretionary hyphen every six letters of any other word."""
    if re.search(r"/|@|www\.", word):
        parts = []
        for part in re.split(r"(?<=[/.\-_=&?#])", word):
            parts += [part[k:k + 10] for k in range(0, len(part), 10)]
        sep = r"\allowbreak{}"
    else:
        parts = [word[k:k + 6] for k in range(0, len(word), 6)]
        if len(parts) > 1 and len(parts[-1]) < 3:
            parts[-2:] = [parts[-2] + parts[-1]]
        sep = r"\-"
    out = []
    for part in (p for p in parts if p):
        out += ([raw_inline(sep)] if out else []) + [Str(part)]
    return out


def render_tok(tok, mark):
    if tok.kind == "w":
        return Str(tok.text)
    if tok.kind == "n":
        return Str(PILCROW)
    if mark and mark[0] == "del":  # a removed atom prints as its text, struck like a word
        shown_text = {"line break": "/", "|": "|"}.get(tok.text, None)
        if shown_text is None:
            shown_text = stringify([tok.data]) or tok.text.split(" ", 1)[-1]
        return Str(shown_text)
    return tok.data


def atom_kind(tok, mark):
    """'box' for an atom marked around a box, 'ink' for one marked by colour alone, None for a
    word (a removed atom prints as struck text, so it is a word here)."""
    if tok.kind != "a" or (mark and mark[0] == "del") or tok.text == "|":
        return None
    return "ink" if tok.text == "line break" or tok.text.startswith("raw ") else "box"


def leaf(run):
    """[(tok, mark)] with one mark and no further style -> (space before, inlines)."""
    out, mark = [], run[0][1]
    for n, (tok, _) in enumerate(run):
        kind = atom_kind(tok, mark)
        if kind:  # each atom on its own: a box must not hold the spaces a line may break at
            if out and tok.space:
                out.append(SPACE)
            out.extend(marked(mark, [render_tok(tok, mark)], kind))
            continue
        if not out or atom_kind(run[n - 1][0], mark):
            out += [SPACE] if out and tok.space else []
            out.append([])  # a run of words, closed below
        elif tok.space:
            out[-1].append(SPACE)
        word = render_tok(tok, mark)
        out[-1].extend(breakable(tok.text) if mark and tok.kind == "w" and len(tok.text) > LONG_WORD
                       else [word])
    flat = []
    for part in out:
        flat.extend(marked(mark, part) if isinstance(part, list) else [part])
    return run[0][0].space, flat


def build(entries, depth=0):
    """[(tok, mark)] sharing their first `depth` style marks -> (space before, inlines), with
    each mark's macro innermost, so ulem only ever sees words."""
    out, lead, last = [], None, None
    for elem, group in itertools.groupby(entries, key=lambda e: e[0].style[depth]
                                         if len(e[0].style) > depth else None):
        group = list(group)
        if elem is None:
            runs = [list(run) for _, run in itertools.groupby(group, key=lambda e: e[1])]
            parts = [leaf(run) + (run[0][1], run[-1][1]) for run in runs]
        elif elem[0] == "Note":
            parts = [(group[0][0].space, [{"t": "Note", "c": note_blocks(group, depth + 1)}],
                      group[0][1], group[-1][1])]
        else:
            space, inner = build(group, depth + 1)
            parts = [(space, [wrap(elem, inner)], group[0][1], group[-1][1])]
        for space, inlines, first, final in parts:
            if lead is None:
                lead = space
            elif space or _meets(last, first):
                out.append(SPACE)
            out.extend(inlines)
            last = final
    return bool(lead), out


def _meets(before, after) -> bool:
    """True where a struck run and an added one meet: they always get a space between them, even
    where the added word opens its paragraph and so has none of its own."""
    return bool(before and after and {before[0], after[0]} == {"del", "ins"})


def wrap(elem, inlines):
    if elem[0] == "Span":
        return {"t": "Span", "c": [["", list(elem[1]), [list(kv) for kv in elem[2]]], inlines]}
    if elem[0] == "Link":
        return {"t": "Link", "c": [["", [], []], inlines, [elem[1], elem[2]]]}
    return {"t": elem[0], "c": inlines}


def note_blocks(entries, depth):
    """A footnote's paragraphs from its entries: a live 'n' token starts a new one (marked at
    the end of the one before when a step added it); a removed one is a struck pilcrow."""
    paras, current = [], []
    for tok, mark in entries:
        if tok.kind == "n" and not (mark and mark[0] == "del"):
            if mark and current:
                current.append((Tok("w", PILCROW, tok.style, True), mark))
            paras.append(current)
            current = []
        else:
            current.append((tok, mark))
    paras.append(current)
    return [para(build(p, depth)[1]) for p in paras if p]


# ── Paragraphs ─────────────────────────────────────────────────────────────────────────────

class Paragraph:
    def __init__(self, tok, mark=None):
        self.kind = re.match(r"[a-z]+", tok.text).group()
        self.depth = int(tok.text[len(self.kind):] or 0)
        self.label, self.mark, self.entries = tok.data or "", mark, []

    def blocks(self) -> list:
        if self.kind == "break":
            stars = [Str("*"), SPACE, Str("*"), SPACE, Str("*")]
            body = para(marked(self.mark, stars))
        else:
            inlines = build(self.entries)[1]
            if not inlines:
                return []
            body = para(inlines)
        env = {"head": f"{{{self.depth}}}", "item": f"{{{self.depth}}}{{}}",
               "enum": f"{{{self.depth}}}{{{tex_escape(self.label)}}}", "cont": f"{{{self.depth}}}",
               "quote": f"{{{self.depth}}}", "epigraph": "", "break": "", "code": "", "row": "",
               "line": "", "term": ""}.get(self.kind)
        if env is None:
            return [body]
        name = {"row": "cmptablerow", "enum": "cmpitem"}.get(self.kind, f"cmp{self.kind}")
        return [raw_block(rf"\begin{{{name}}}{env}"), body, raw_block(rf"\end{{{name}}}")]


def _all_after(items, n, live_test):
    """True when every live item after n, up to the next live paragraph break, passes."""
    for it in items[n + 1:]:
        if it.removed is None:
            if it.tok.kind == "p":
                return True
            if not live_test(it):
                return False
    return True


def redline(items) -> list:
    """The final text with every added word marked by who added it and every removed word
    struck in place by who removed it."""
    paras, current = [], None
    for n, it in enumerate(items):
        tok = it.tok
        if tok.kind == "p":
            if it.removed is None:
                fresh = it.added != "original"
                whole = fresh and _all_after(items, n, lambda x: x.added != "original")
                if fresh and current is not None and not whole:
                    current.entries.append((Tok("w", PILCROW), ("ins", it.added)))
                current = Paragraph(tok, ("ins", it.added) if fresh else None)
                paras.append(current)
            elif _all_after(items, n, lambda x: False) or current is None:
                current = Paragraph(tok, ("del", it.removed))
                paras.append(current)
            else:
                current.entries.append((Tok("w", PILCROW), ("del", it.removed)))
            continue
        if current is None:
            current = Paragraph(Tok("p", "para0"))
            paras.append(current)
        mark = (("del", it.removed) if it.removed
                else None if it.added == "original" else ("ins", it.added))
        current.entries.append((tok, mark))
    return [b for p in paras for b in p.blocks()]


# ── The three columns ──────────────────────────────────────────────────────────────────────

def column_paragraphs(entries) -> list:
    """[(tok, mark, item id)] of one stage -> [(Paragraph, set of item ids)], in order."""
    out, current = [], None
    for tok, mark, ident in entries:
        if tok.kind == "p" or current is None:
            current = (Paragraph(tok if tok.kind == "p" else Tok("p", "para0")), set())
            out.append(current)
        current[1].add(ident)
        if tok.kind != "p":
            current[0].entries.append((tok, mark))
    return out


def align(columns: list) -> list:
    """columns: three lists of (Paragraph, item ids). Paragraphs that hold the same item (one
    word followed through the chain) share a row; the middle column, when it has paragraphs, is
    the pivot. A paragraph only the first column has (removed outright) sits after the rows of
    the paragraphs before it; one only the last column has (added outright) sits before the
    rows of the paragraphs after it, beside a removed one when they meet. Returns rows, each a
    list per column of paragraph indexes."""
    parent = {}

    def find(x):
        while parent.setdefault(x, x) != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    owner = {}
    for c, col in enumerate(columns):
        for p, (_, ids) in enumerate(col):
            find((c, p))
            for i in ids:
                if i in owner:
                    parent[find((c, p))] = find(owner[i])
                else:
                    owner[i] = (c, p)
    groups = {}
    for c, col in enumerate(columns):
        for p in range(len(col)):
            groups.setdefault(find((c, p)), [[] for _ in columns])[c].append(p)
    rows = list(groups.values())
    pivot = 1 if columns[1] else 0
    order = sorted((r for r in rows if r[pivot]), key=lambda r: min(r[pivot]))
    for c in (0, 2):
        if c == pivot:
            continue
        alone = [r for r in rows if not r[pivot] and r[c] and (c == 0 or not r[0])]
        for r in sorted(alone, key=lambda r: min(r[c])):
            if c == 0:
                at = max((k + 1 for k, o in enumerate(order) if o[0] and min(o[0]) < min(r[0])),
                         default=0)
            else:
                at = next((k for k, o in enumerate(order) if o[2] and min(o[2]) > min(r[2])),
                          len(order))
            before = order[at - 1] if at else None
            if c == 2 and before is not None and not before[pivot] and not before[2]:
                before[2] = r[2]  # a paragraph removed and one added at the same place
            else:
                order.insert(at, r)
    return order


# ── Sections ───────────────────────────────────────────────────────────────────────────────

class Section:
    """One ledger entry, read as the chain of states make compare shows."""

    def __init__(self, entry, reader):
        e = self.entry = entry
        self.notes = []
        self.legacy = e.format is None
        self.reopened = e.reopened
        self.promoted = bool(e.promoted and words(e.final)) and not self.reopened
        self.final_only = e.origin == "author" and not words(e.author_original)
        if self.final_only:
            # No original was recorded: the text alone, never a guess at how it got there.
            last = e.final if words(e.final) else (e.revisions[-1].text if e.revisions else "")
            self.chain = [("original", last)] if words(last) else []
            why = "the entry predates the record" if self.legacy else "no Author original was written"
            self.notes.append(f"The author drafted this section, and its stages were not recorded "
                              f"({why}): only its text is shown, unmarked.")
        else:
            chain = e.chain()
            if self.legacy:
                chain = [(k if k == "original" else "unattributed", t) for k, t in chain]
                if len(chain) > 1:
                    self.notes.append("This entry predates the record (it has no 'format: 2'): the "
                                      "changes from the AI original to the final are shown, but who "
                                      "made them was not recorded, so none is attributed.")
            self.chain = [(k, t) for k, t in chain if k == "original" or words(t)]
            if len(self.chain) == 1:
                self.notes.append("This entry predates the record (it has no 'format: 2'): only its "
                                  "AI original is shown." if self.legacy else
                                  "No revision is recorded yet, so nothing has changed.")
        if self.reopened:
            self.notes.append(f"Promoted {e.promoted}, then reopened and changed: until it is "
                              f"promoted again, its Author final is the previous final, so the last "
                              f"state shown is the latest recorded, not a final.")
        elif not self.promoted:
            self.notes.append("Not promoted yet: the last state shown is the latest recorded, not "
                              "a final.")
        self.ai_at = max((n for n, (k, _) in enumerate(self.chain) if k in AI_KINDS), default=None)
        self.items, snapshot = attribute([(k, reader(t)) for k, t in self.chain], self.ai_at)
        self.index = {id(it): n for n, it in enumerate(self.items)}
        self.ai_edit = snapshot

    def stages(self) -> str:
        if not self.chain:
            return "nothing recorded"
        if self.final_only:
            return "final only" if self.promoted else "latest text only"
        names = ["AI original" if self.entry.origin == "ai" else "Author original"]
        if self.legacy and len(self.chain) > 1:
            names.append("final (unattributed)")
        elif not self.legacy:
            if self.ai_at is not None:
                names.append("AI edit")
            if self.promoted:
                names.append("final")
            elif len(self.chain) > 1:
                names.append("latest (reopened)" if self.reopened else "latest (not promoted)")
        return ", ".join(names)

    def revisions(self) -> str:
        return "not recorded" if self.legacy else str(len(self.entry.revisions))

    def heading_blocks(self, position: str, new_page=True) -> list:
        e = self.entry
        last = "final" if self.promoted else "latest state"
        facts = [position, f"Origin: {'AI-drafted' if e.origin == 'ai' else 'author-drafted'}.",
                 f"Stages recorded: {self.stages()}.",
                 f"Promoted {e.promoted}." if self.promoted
                 else f"Promoted {e.promoted}, reopened since." if self.reopened
                 else "Not promoted yet."]
        out = ([raw_block(r"\cmpsectionbreak")] if new_page else []) + [
            header(1, text(e.section)), para(text(" ".join(facts)))]
        if e.revisions and not self.legacy:
            rows = []
            for r in e.revisions:
                inl = text(str(r.n)) + [SPACE, Str("·"), SPACE] + marked(("tint", r.kind), text(r.kind))
                for part in [r.date, r.skill] + ([f"rows {r.rows}"] if r.rows else []):
                    inl += [SPACE, Str("·"), SPACE] + text(part)
                rows.append(inl)
            out += [para([strong(text("Revisions"))]), bullets(rows)]
        else:
            out.append(para(text(f"Revisions: {'not recorded' if self.legacy else 'none recorded'}.")))
        original = self.chain[0][1] if self.chain else ""
        latest = self.chain[-1][1] if self.chain else ""
        if self.final_only or len(self.chain) < 2:
            figures = "Change figures: none, because only one state is recorded."
        elif self.ai_at is None:
            figures = (f"No AI edit recorded. Change from the original to the {last}: "
                       f"{provenance.fmt_ratio(change_ratio(original, latest))}.")
        else:
            ai_text = self.chain[self.ai_at][1]
            figures = (f"Change from the original to the AI edit: "
                       f"{provenance.fmt_ratio(change_ratio(original, ai_text))}. Change from the AI "
                       f"edit to the {last}: {provenance.fmt_ratio(change_ratio(ai_text, latest))}.")
        if not figures.startswith("Change figures"):
            figures += " Each is 1 minus the word-by-word similarity, as make provenance computes it."
        out.append(para(text(figures)))
        out += [para([emph(text(note))]) for note in self.notes]
        return out

    def redline_blocks(self) -> list:
        title = "Redline" if len(self.chain) > 1 else "Text"
        return [header(2, text(title))] + (redline(self.items) or [para([emph(text("No text recorded."))])])

    def columns(self) -> list:
        """[(tok, tint, item id)] for the three columns: the original (each word a later step
        removed, tinted by that step), the AI edit and the last state (each word a step added,
        tinted by that step)."""
        ix = self.index
        first = [(it.first, ("tint", it.removed) if it.removed else None, ix[id(it)])
                 for it in self.items if it.added == "original"]
        middle = [(tok, None if it.added == "original" else ("tint", it.added), ix[id(it)])
                  for it, tok in (self.ai_edit or [])]
        last = [(it.tok, None if it.added == "original" else ("tint", it.added), ix[id(it)])
                for it in self.items if it.removed is None]
        return [first, middle, last]

    def merge_unchanged(self, rows, prepared) -> list:
        """Rows that changed nowhere print the same text in every column, so they keep level side
        by side: consecutive ones share a row, and only a changed paragraph needs one of its own."""
        shown = [c for c in range(3) if c != 1 or self.ai_edit is not None]

        def unchanged(row):
            return all(len(row[c]) == 1 and all(m is None for _, m in prepared[c][row[c][0]][0].entries)
                       for c in shown)

        out, run = [], False
        for row in rows:
            if unchanged(row) and run:
                for c in range(3):
                    out[-1][c] += row[c]
            else:
                out.append([list(cells) for cells in row])
            run = unchanged(row)
        return out

    def column_blocks(self) -> list:
        """The landscape page: Original, AI edit and Final side by side, aligned by paragraph."""
        if len(self.chain) < 2:
            return [para([emph(text("No three-column page: only one state is recorded."))])]
        e = self.entry
        prepared = [column_paragraphs(col) for col in self.columns()]
        heads = ["AI original" if e.origin == "ai" else "Author original",
                 f"AI edit (after revision {self.ai_at})" if self.ai_edit is not None else "AI edit",
                 "Final" if self.promoted
                 else "Latest (reopened, not promoted again)" if self.reopened
                 else "Latest (not promoted)"]
        if self.ai_edit is None:
            missing = ("Not recorded: this entry predates the record." if self.legacy
                       else "No AI edit recorded.")
        out = [raw_block(r"\begin{cmplandscape}"),
               raw_block(r"\cmpcolheads" + "".join("{" + tex_escape(h) + "}" for h in heads)),
               header(2, text(f"{e.section}: Original, AI edit, Final")),
               para([emph(text("A tinted word is one that changed, in the colour and line of the "
                               "step that changed it: in the first column the step that removed "
                               "it, in the other two the step that added it."))]),
               raw_block(r"\begin{cmpcolumns}")]
        for c, head in enumerate(heads):
            out += ([raw_block(r"\cmpnextcol")] if c else []) + [para([strong(text(head))])]
        for r, row in enumerate(self.merge_unchanged(align(prepared), prepared)):
            out.append(raw_block(r"\cmprow"))
            for c in range(3):
                if c:
                    out.append(raw_block(r"\cmpnextcol"))
                if c == 1 and self.ai_edit is None:
                    out += [para([emph(text(missing))])] if r == 0 else []
                    continue
                for p in row[c]:
                    out += prepared[c][p][0].blocks()
        return out + [raw_block(r"\end{cmpcolumns}"), raw_block(r"\end{cmplandscape}")]


# ── The unit: entries, plan order, the document ───────────────────────────────────────────

PLAN_FLOW = re.compile(r"^\s*-\s*\{.*?\bslug\s*:\s*['\"]?([^,'\"}\s]+)")
PLAN_KEY = re.compile(r"^\s*(?:-\s*)?slug\s*:\s*['\"]?([^'\"\s#]+)")
PLAN_BARE = re.compile(r"^\s*-\s*['\"]?([A-Za-z0-9][A-Za-z0-9_-]*)['\"]?\s*(?:#.*)?$")


def read_plan(text: str):
    """The slugs of a brief's `sections:` list, in order: the flow form '- {slug: x, …}', the
    block form '- slug: x' (its other keys on the lines below) or a bare '- x'. None when the
    brief has no frontmatter or no `sections:` key."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None
    end = next((n for n in range(1, len(lines)) if lines[n].strip() in ("---", "...")), len(lines))
    slugs = None
    for line in lines[1:end]:
        if slugs is None:
            m = re.match(r"^sections\s*:\s*(.*?)\s*(?:#.*)?$", line)
            if m:
                slugs = []
                inline = m.group(1)
                if inline.startswith("["):
                    found = re.findall(r"\bslug\s*:\s*['\"]?([^,'\"}\s\]]+)", inline)
                    return found or [s.strip(" '\"") for s in inline.strip("[]").split(",") if s.strip()]
            continue
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not line[:1].isspace() and not line.startswith("-"):
            break  # the next key
        for pattern in (PLAN_FLOW, PLAN_KEY, PLAN_BARE):
            m = pattern.match(line)
            if m:
                slugs.append(m.group(1))
                break
    return slugs


def unit_name(arg: str) -> str:
    """'03-the-ford', 'manuscript/src/03-the-ford/' or 'planning/src/units/03-the-ford.md' ->
    '03-the-ford'."""
    name = Path(arg.strip().rstrip("/")).name
    return name[:-3] if name.endswith(".md") else name


def load_plan(unit: str, briefs: Path):
    """(the plan's slugs or None, a warning or None). A brief git ignores is never read."""
    brief = briefs / f"{unit}.md"
    if not brief.is_file() or not not_ignored([brief], brief.parent):
        return None, (f"no brief at {shown(brief)}, so the sections are in name order")
    plan = read_plan(brief.read_text(encoding="utf-8-sig"))
    if plan is None:
        return None, f"{shown(brief)} has no sections: list, so the sections are in name order"
    return plan, None


def make_document(unit, section, ledger, briefs, reader, warn) -> tuple:
    """(Pandoc's document as a dict, exit code). Raises UsageError when there is nothing to show."""
    entries = [e for e in provenance.load_entries(ledger) if e.unit == unit]
    disclosed = [e for e in entries if e.promoted and not e.errors]  # make provenance's row
    if not entries:
        units = sorted({e.unit for e in provenance.load_entries(ledger) if e.unit})
        raise UsageError(f"no ledger entry for unit {unit!r} in {shown(ledger)} (units with entries: "
                         f"{', '.join(units) or 'none'}); UNIT is the brief's filename without .md")
    if section:
        entries = [e for e in entries if e.section == section]
        if not entries:
            raise UsageError(f"no ledger entry for section {section!r} of unit {unit!r} "
                             f"(looked for {shown(ledger / f'{unit}--{section}.md')})")
    bad = [e for e in entries if e.errors]
    for e in bad:
        for msg in e.errors:
            warn(f"error: {e.path.name}: {msg}; it is left out (python3 tooling/provenance.py check)")
    good = {e.section: e for e in entries if not e.errors}
    plan, problem = load_plan(unit, briefs)
    if problem:
        warn(f"warning: {problem}")
    in_plan = [s for s in (plan or []) if s in good]
    rest = sorted(s for s in good if s not in in_plan)
    sections = [(s, Section(good[s], reader)) for s in in_plan + rest]
    today = datetime.date.today().strftime("%d/%m/%Y")
    blocks = cover(unit, section, sections, bad, plan, problem, today, disclosed)
    for n, (slug, s) in enumerate(sections):
        divider = plan is not None and slug not in plan and (n == 0 or sections[n - 1][0] in plan)
        if divider:
            blocks += [raw_block(r"\cmpsectionbreak"), header(1, text("Not in the plan")),
                       para(text("These sections have ledger entries but are not in the brief's "
                                 "sections: list. A section cut from the plan keeps its entry."))]
        if plan is None:
            position = "No brief: sections in name order."
        elif slug in plan:
            position = f"Section {plan.index(slug) + 1} of {len(plan)} in the plan."
        else:
            position = "Not in the plan."
        blocks += s.heading_blocks(position, not divider) + s.redline_blocks() + s.column_blocks()
    version = getattr(reader, "version", None) or API_VERSION
    return {"pandoc-api-version": version, "meta": {}, "blocks": blocks}, (1 if bad else 0)


def cover(unit, section, sections, bad, plan, problem, today, disclosed=()) -> list:
    n = len(sections)
    title = unit + (f", section {section}" if section else "")
    out = [raw_block(r"\cmpcover{" + tex_escape(title) + "}"),
           para(text(f"Made by tooling/compare.py on {today} from {n} ledger entr"
                     f"{'y' if n == 1 else 'ies'} (make compare). It shows how each section "
                     f"moved from its original to its final text, as the ledger records it: a "
                     f"redline, then the stages side by side. It is for the author and for "
                     f"disclosure, and is never issued, committed or synced.")),
           header(2, text("Key")), raw_block(r"\cmplegend"),
           para(text("In the redline every word a step added is marked by who added it, and every "
                     "word a step removed is struck where it stood by who removed it; a word one "
                     "step added and a later one removed is struck by the later. A marked pilcrow "
                     "is a paragraph break added or removed. The AI edit is the text after the last "
                     "ai or author-note revision. Whatever changed between the last revision and "
                     "the final is the author's. The comparison follows words, not passages: a "
                     "passage a step moved shows as removed where it stood and added where it "
                     "went, both marked by the step that moved it.")),
           header(2, text("Disclosure"))]
    if disclosed:
        row = [text(unit)] + [text(c) for c in provenance.disclosure_row(disclosed)]
        out += [table([text(h) for h in provenance.DISCLOSURE_HEAD], [row],
                      [0.15, 0.10, 0.10, 0.13, 0.11, 0.22, 0.19]),
                para([emph(text(provenance.DISCLOSURE_NOTE))])]
    else:
        out.append(para([emph(text("No section of this unit is promoted yet, so make provenance "
                                   "has no row for it."))]))
    out.append(header(2, text("Sections")))
    rows = [[text(s.entry.section), text(s.entry.origin), text(s.stages()), text(s.revisions()),
             text(provenance.fmt_ratio(s.entry.ratio)),
             text(f"{s.entry.promoted}, reopened" if s.reopened else s.entry.promoted or "not yet")]
            for _, s in sections]
    rows += [[text(e.section or e.path.name), text(e.origin or NOTHING),
              text("left out: malformed (python3 tooling/provenance.py check)"),
              text(NOTHING), text(NOTHING), text(NOTHING)] for e in bad]
    heads = ("Section", "Origin", "Stages recorded", "Revisions", "Change ratio", "Promoted")
    out.append(table([text(h) for h in heads], rows, [0.17, 0.09, 0.34, 0.13, 0.12, 0.15]))
    notes = ["Change ratio: 1 minus the word-by-word similarity between the AI original and the "
             "final, as make provenance prints it; an author-drafted section has none."]
    if problem:
        notes.append(f"Order: {problem}.")
    elif plan is not None:
        notes.append("Order: the brief's sections: list.")
    out += [para([emph(text(note))]) for note in notes]
    return out


# ── Command line ───────────────────────────────────────────────────────────────────────────

def cmd_units(args) -> int:
    for unit in sorted({e.unit for e in provenance.load_entries(args.ledger) if e.unit}):
        print(unit)
    return 0


def cmd_ast(args) -> int:
    reader = PandocReader(args.pandoc_arg)
    doc, code = make_document(unit_name(args.unit), args.section, args.ledger, args.briefs, reader,
                              lambda msg: print(msg, file=sys.stderr))
    if reader.version is None:
        reader.blocks("")
        doc["pandoc-api-version"] = reader.version or API_VERSION
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
    return code


def main(argv=None) -> int:
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--ledger", type=Path, default=provenance.DEFAULT_LEDGER,
                        help="the ledger folder (default: standards/style/ledger)")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd")
    sub.add_parser("units", parents=[common], help="print each unit that has a ledger entry")
    a = sub.add_parser("ast", parents=[common], help="write one unit's comparison as Pandoc JSON")
    a.add_argument("--unit", required=True, help="the brief's filename stem, such as 03-the-ford")
    a.add_argument("--section", help="only this section's slug")
    a.add_argument("--briefs", type=Path, default=DEFAULT_BRIEFS,
                   help="the unit briefs folder (default: planning/src/units)")
    a.add_argument("--pandoc-arg", action="append", default=[], metavar="ARG",
                   help="one argument for each Pandoc run that reads a state (repeatable)")
    a.add_argument("-o", "--out", type=Path, required=True, help="the JSON file to write")
    argv = sys.argv[1:] if argv is None else argv
    if argv[:1] == ["--self-test"]:
        return self_test()
    args = ap.parse_args(argv)
    if not args.cmd:
        ap.print_usage(sys.stderr)
        return 2
    try:
        return {"units": cmd_units, "ast": cmd_ast}[args.cmd](args)
    except (UsageError, ToolError) as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as err:
        print(f"error: {err}", file=sys.stderr)
        return 2


# ── Self-test ──────────────────────────────────────────────────────────────────────────────

ROUNDS = [
    ("original", "The river was loud and the ford was shut."),
    ("ai", "The river was louder in the dark, and the ford was shut."),
    ("author", "The river was louder in the dark, and the ford was closed."),
    ("author-note", "The river was louder in the dark, and the ford was closed to all."),
    ("ai", "The river was louder in the dark, and the old ford was closed to all."),
    ("author", "The river was louder in the dark, and the ford was closed to all who came."),
]

ENTRY = """---
unit: 01-test
section: {section}
origin: {origin}
drafted: 04/10/2026
promoted: {promoted}
change_ratio:
learned: false
{format}---

## AI original

{ai}

{rest}## Author final

{final}

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
"""


def entry_text(section="crossing", origin="ai", promoted="06/10/2026", fmt=True, ai="", rest="",
               final=""):
    return ENTRY.format(section=section, origin=origin, promoted=promoted, ai=ai, rest=rest,
                        final=final, format="format: 2\n" if fmt else "")


def chain_text(rounds) -> str:
    """'## Revisions' with one marker per round after the first, and the final, as text."""
    out = ["## Revisions", ""]
    for n, (kind, body) in enumerate(rounds[1:], 1):
        out += [f"<!-- revision {n} · {kind} · 0{min(n, 9)}/10/2026 · improve-section (edit) -->", "",
                body, ""]
    return "\n".join(out) + "\n"


def raw_tex(node) -> list:
    """Every raw LaTeX string in a Pandoc tree, in order."""
    found = []
    if isinstance(node, dict):
        if node.get("t") in ("RawInline", "RawBlock") and node["c"][0] == "latex":
            found.append(node["c"][1])
        for v in node.values():
            found += raw_tex(v)
    elif isinstance(node, list):
        for v in node:
            found += raw_tex(v)
    return found


def balanced(tex: str) -> bool:
    depth = 0
    for ch in re.sub(r"\\[{}]", "", tex):
        depth += {"{": 1, "}": -1}.get(ch, 0)
        if depth < 0:
            return False
    return depth == 0


def self_test() -> int:
    import contextlib
    import io
    import tempfile
    failures = []

    def verdict(label, passed, detail=""):
        print(f"  {'ok  ' if passed else 'FAIL'} {label}")
        if not passed:
            failures.append(label)
            print(f"         {detail}")

    def probe(text_, name="01-test--crossing.md"):
        with tempfile.TemporaryDirectory() as tmp:
            (Path(tmp) / name).write_text(text_, encoding="utf-8")
            return provenance.Entry(Path(tmp) / name)

    print("compare.py --self-test")
    items, snap = attribute([(k, plain_reader(t)) for k, t in ROUNDS], upto=4)
    live = {it.tok.text: it.added for it in items if it.removed is None}
    struck = [(it.tok.text, it.added, it.removed) for it in items if it.removed]
    verdict("each word kept its first author across five rounds",
            live.get("louder") == "ai" and live.get("dark,") == "ai" and live.get("to") == "author-note"
            and live.get("who") == "author" and live.get("came.") == "author"
            and live.get("river") == "original", live)
    verdict("the live words are exactly the last state",
            [it.tok.text for it in items if it.removed is None and it.tok.kind == "w"]
            == ROUNDS[-1][1].split(), [it.tok.text for it in items if it.removed is None])
    verdict("a word one step removed is struck by that step",
            ("loud", "original", "ai") in struck and ("shut.", "original", "author") in struck, struck)
    verdict("a word the AI added and the author removed is struck by the author",
            ("old", "ai", "author") in struck, struck)
    order = [it.tok.text for it in items if it.tok.kind == "w"]
    verdict("a removed word stays where it stood",
            order[order.index("old") - 1] == "the" and order[order.index("old") + 1] == "ford"
            and order.index("loud") < order.index("louder"), order)
    verdict("the AI edit is the state after the last ai or author-note round",
            [t.text for it, t in snap if t.kind == "w"] == ROUNDS[4][1].split(), snap)
    two = attribute([("original", plain_reader("One two three.")),
                     ("ai", plain_reader("One two three.\n\nFour five six."))])[0]
    verdict("a paragraph added outright opens with its own break",
            [(it.tok.kind, it.added) for it in two][4:6] == [("p", "ai"), ("w", "ai")],
            [(it.tok.text, it.added) for it in two])

    second = []
    for chain in ((("original", "The ford was shut.^[First note about the ford.] The river "
                                "rose.^[Second note about the old river.]"),
                   ("ai", "The ford was shut. The river rose.^[Second note about the river.]")),
                  (("original", "The river rose.^[Second note about the old river.]"),
                   ("author", "The river rose.^[Second note about the river.]"),
                   ("ai", "A start.^[A first note.] The river rose.^[Second note about the river.]"))):
        notes = attribute([(k, plain_reader(t)) for k, t in chain])[0]
        second.append([b for b in json.dumps(redline(notes)).split('{"t": "Note"')[1:] if "Second" in b])
    verdict("a footnote stays one footnote when a note before it is removed or added",
            all(len(found) == 1 and "old" in found[0] and "river." in found[0] for found in second),
            second)
    long_word = breakable("Hippopotomonstrosesquippedaliophobia.")
    address = breakable("https://example.org/a/very/long/path/index.html")
    verdict("a long marked word gets places to break, and still reads as itself",
            r"\-" in raw_tex(long_word) and stringify(long_word) == "Hippopotomonstrosesquippedaliophobia."
            and r"\allowbreak{}" in raw_tex(address)
            and stringify(address) == "https://example.org/a/very/long/path/index.html",
            (long_word, address))

    rounds = ROUNDS[:1] + ROUNDS[1:]
    fmt2 = probe(entry_text(ai=ROUNDS[0][1], rest=chain_text(rounds[:-1]), final=ROUNDS[-1][1]))
    s = Section(fmt2, plain_reader)
    verdict("a format-2 entry's chain is read through provenance.py",
            not fmt2.errors and [k for k, _ in s.chain] == [k for k, _ in ROUNDS], (fmt2.errors, s.chain))
    legacy = probe(entry_text(fmt=False, ai="The ford was shut.", final="The ford was closed."))
    s = Section(legacy, plain_reader)
    verdict("a legacy AI-drafted entry is two states, every change unattributed",
            [k for k, _ in s.chain] == ["original", "unattributed"]
            and {it.added for it in s.items if it.removed is None} == {"original", "unattributed"}
            and {it.removed for it in s.items if it.removed} == {"unattributed"}
            and any("not recorded" in n for n in s.notes), (s.chain, s.notes))
    reopened = probe(entry_text(ai=ROUNDS[0][1], promoted="05/10/2026", final=ROUNDS[1][1], rest=(
        "## Revisions\n\n<!-- revision 1 · author · 06/10/2026 · promoted 05/10/2026 -->\n\n"
        f"{ROUNDS[1][1]}\n\n<!-- revision 2 · ai · 06/10/2026 · adapt-section -->\n\n{ROUNDS[4][1]}\n\n")))
    s = Section(reopened, plain_reader)
    heads = [stringify(b["c"]) for b in s.column_blocks() if b["t"] == "Para"]
    verdict("a reopened section ends at its latest revision and says so",
            not reopened.errors and [k for k, _ in s.chain] == ["original", "author", "ai"]
            and not s.promoted and "latest (reopened)" in s.stages()
            and any("reopened" in h for h in heads) and any("reopened" in n for n in s.notes),
            (reopened.errors, s.chain, heads))
    author = probe(entry_text(fmt=False, origin="author", ai="<!-- Empty. -->",
                              final="The ford was closed."))
    s = Section(author, plain_reader)
    verdict("a legacy author-drafted entry is its final alone, unmarked, and says why",
            s.final_only and len(s.chain) == 1 and all(it.added == "original" for it in s.items)
            and any("stages were not recorded" in n for n in s.notes)
            and "only one state" in stringify(s.column_blocks()[0]["c"]), s.notes)

    flow = "---\ntitle: x\nsections:\n  - {slug: opening, purpose: \"A, b.\", status: promoted}\n" \
           "  - {purpose: \"c\", slug: the-turn, status: \"\"}\nstatus: draft\n---\n"
    block = "---\nsections:\n- slug: summary\n  purpose: one, two\n- slug: 'scope'\n  status: ''\n" \
            "  - plain-one\n---\n# Title\n"
    verdict("the brief's plan is read in the flow form", read_plan(flow) == ["opening", "the-turn"],
            read_plan(flow))
    verdict("the brief's plan is read in the block form",
            read_plan(block) == ["summary", "scope", "plain-one"], read_plan(block))
    verdict("a brief with no sections: list gives no plan", read_plan("---\ntitle: x\n---\n") is None)
    verdict("a unit given as a path is read as its name",
            unit_name("manuscript/src/03-the-ford/") == unit_name("planning/src/units/03-the-ford.md")
            == "03-the-ford")

    business = ("## Scope of work\n\nThe work covers the staff handbook.\n\n### Fees\n\n"
                "The fee is fixed.")
    revised = business.replace("handbook.", "handbook and nothing beyond it.")
    record = chain_text([("original", business), ("ai", revised)])
    biz = probe(entry_text(section="scope", ai=business, rest=record, final=revised), "01-test--scope.md")
    s = Section(biz, plain_reader)
    tex = raw_tex(s.redline_blocks())
    verdict("a business section keeps its ## and ### headings as headings",
            not biz.errors and r"\begin{cmphead}{2}" in tex and r"\begin{cmphead}{3}" in tex
            and r"\cmpaiins{" in tex, (biz.errors, tex))

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        ledger, briefs = root / "ledger", root / "units"
        ledger.mkdir()
        briefs.mkdir()
        (ledger / "01-test--crossing.md").write_text(
            entry_text(ai=ROUNDS[0][1], rest=chain_text(ROUNDS[:-1]), final=ROUNDS[-1][1]), encoding="utf-8")
        (ledger / "01-test--opening.md").write_text(
            entry_text(section="opening", fmt=False, ai="The ford was shut.", final="The ford was closed."),
            encoding="utf-8")
        (ledger / "01-test--secret.md").write_text(
            entry_text(section="secret", ai="Zanzibarine words.", final="Zanzibarine words here."),
            encoding="utf-8")
        (briefs / "01-test.md").write_text(
            "---\nsections:\n  - {slug: opening, status: promoted}\n  - {slug: crossing}\n---\n",
            encoding="utf-8")
        git = shutil.which("git")
        if git:
            subprocess.run([git, "init", "-q", str(root)], check=True)
            (root / ".gitignore").write_text("*--secret.md\n", encoding="utf-8")
        warned = []
        doc, code = make_document("01-test", None, ledger, briefs, plain_reader, warned.append)
        dumped = json.dumps(doc)
        if git:
            verdict("a git-ignored entry is never read", "Zanzibarine" not in dumped
                    and "secret" not in dumped, warned)
        else:
            print("  skip git: git not found")
        heads = [stringify(b["c"][2]) for b in doc["blocks"] if b["t"] == "Header" and b["c"][0] == 1]
        verdict("sections follow the brief's plan", heads == ["opening", "crossing"], heads)
        cells = [stringify(c[4][0]["c"]) for b in doc["blocks"] if b["t"] == "Table"
                 for c in b["c"][4][0][3][0][1]]
        verdict("the cover carries the unit's disclosure row, as make provenance prints it",
                cells[:7] == ["01-test"] + provenance.disclosure_row(
                    [e for e in provenance.load_entries(ledger) if e.unit == "01-test" and e.promoted]),
                cells[:7])
        tex = "".join(raw_tex(doc))
        verdict("the emitted LaTeX is balanced", balanced(tex) and code == 0, tex[:200])
        verdict("every actor's macros are emitted",
                all(rf"\cmp{MACRO[a]}ins{{" in tex and rf"\cmp{MACRO[a]}del{{" in tex for a in ACTORS)
                and r"\cmplegend" in tex and r"\begin{cmpcolumns}" in tex, tex[:300])
        verdict("each paragraph's raw LaTeX closes every macro it opens",
                all(balanced("".join(raw_tex(b))) for b in doc["blocks"] if b["t"] == "Para"))
        (briefs / "01-test.md").unlink()
        doc, _ = make_document("01-test", None, ledger, briefs, plain_reader, warned.append)
        heads = [stringify(b["c"][2]) for b in doc["blocks"] if b["t"] == "Header" and b["c"][0] == 1]
        verdict("with no brief the sections are in name order, with a warning",
                heads == ["crossing", "opening"] and any("no brief" in w for w in warned), (heads, warned))
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            main(["units", "--ledger", str(ledger)])
        verdict("units lists each unit with an entry", out.getvalue().split() == ["01-test"], out.getvalue())
        with contextlib.redirect_stderr(io.StringIO()) as err:
            code = main(["ast", "--unit", "02-none", "--ledger", str(ledger), "-o", str(root / "x.json")])
        verdict("a unit with no entry is a usage error", code == 2 and "no ledger entry" in err.getvalue(),
                err.getvalue())

    if shutil.which("pandoc"):
        _self_test_pandoc(verdict)
    else:
        print("  skip pandoc: pandoc not found")
    if failures:
        print(f"self-test FAILED: {len(failures)} case(s)")
        return 1
    print("self-test passed")
    return 0


def _self_test_pandoc(verdict):
    """The Pandoc cases: real Markdown in, LaTeX out (no TeX needed)."""
    house = HERE / "pandoc" / "house.lua"
    reader = PandocReader([f"--lua-filter={house}"] if house.is_file() else [])
    first = ("::: epigraph\n'Count the stones.'\n:::\n\nThe river was *loud*.^[A note on the river.]\n"
             "Tam had told her.\n\n<!-- AUTHOR TO CONFIRM: a flag. -->\n\n- one\n- two\n\n"
             "1. Read the passage.\n2. Note it.\n\n> A quoted line.\n\nTerm\n:   Its definition.")
    second = (first.replace("A note on the river.", "A longer note on the river.")
              .replace("*loud*", "*louder*").replace("Note it.", "Note it with `care`.")
              .replace("quoted line", "quoted line, kept").replace("Its definition", "Its short definition"))
    third = second.replace("Tam had told her.", "Tam had told her.\n\nShe went on.")
    items, _ = attribute([("original", reader(first)), ("ai", reader(second)), ("author", reader(third))])
    blocks = redline(items)
    notes = [n for n in json.dumps(blocks).split('"Note"')[1:]]
    verdict("Pandoc: a word changed inside a footnote is marked inside it",
            notes and r"\\cmpaiins{" in notes[0] and "longer" in notes[0], notes[:1])
    verdict("Pandoc: comments and flags are never words",
            "AUTHOR" not in json.dumps(blocks), json.dumps(blocks)[:300])
    doc = {"pandoc-api-version": reader.version or API_VERSION, "meta": {}, "blocks": blocks}
    proc = subprocess.run([reader.exe, "-f", "json", "-t", "latex"], input=json.dumps(doc),
                          capture_output=True, text=True, encoding="utf-8")
    tex = proc.stdout
    verdict("Pandoc: the redline becomes LaTeX with balanced macros",
            proc.returncode == 0 and balanced(tex) and r"\footnote{" in tex and r"\cmpaiins{" in tex
            and r"\emph{\cmpaidel{loud} \cmpaiins{louder}}" in tex and r"\cmpauthorins{" in tex
            and r"\begin{cmpepigraph}" in tex and r"\begin{cmpitem}" in tex, tex[:600])
    defined = set(re.findall(r"\\newenvironment\{(cmp\w+)\}", (HERE / "latex" / "compare.tex").read_text(
        encoding="utf-8")))
    used = set(re.findall(r"\\begin\{(cmp\w+)\}", tex))
    verdict("Pandoc: every paragraph shape the redline opens is defined in compare.tex (a numbered "
            "list, a quotation and a definition included)",
            used and used <= defined and {"cmpitem", "cmpquote", "cmpterm"} <= used, used - defined)
    verdict("Pandoc: code a step added takes its step's line around a box",
            r"\cmpaiins{\mbox{\texttt{care}}}" in tex, tex[:800])
    biz = ("## Scope of work\n\nThe work covers the handbook.\n\n### Fees\n\n"
           "| Stage | Weeks |\n|---|---|\n| Review | 2 |\n")
    items, _ = attribute([("original", reader(biz)), ("ai", reader(biz.replace("| 2 |", "| 3 |")))])
    tex = json.dumps(redline(items))
    verdict("Pandoc: a business section's headings and a table row survive the comparison",
            r"\\begin{cmphead}{2}" in tex and r"\\begin{cmphead}{3}" in tex and r"\\begin{cmptablerow}" in tex
            and r"\\cmpaiins{" in tex and r"\\cmpaidel{" in tex, tex[:400])


if __name__ == "__main__":
    sys.exit(main())
