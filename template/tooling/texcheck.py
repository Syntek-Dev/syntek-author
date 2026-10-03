#!/usr/bin/env python3
"""texcheck.py: prove a LaTeX file still carries exactly the author's approved words.

Usage:
    python3 tooling/texcheck.py STYLED.tex SOURCE.md [--filter tooling/pandoc/house.lua]
                                [--defaults tooling/defaults.yaml] [--pandoc pandoc]
                                [--strict] [--quiet]
    python3 tooling/texcheck.py DOCUMENT.tex DRAFT.md --section SLUG [the same options]
    python3 tooling/texcheck.py --self-test

Two modes, one comparison.

- A book chapter (`make tex-check`). The styled chapter in typeset/src/units/ began as Pandoc's
  own LaTeX for the chapter's Markdown, and only styling was added to it. The whole file is
  compared with the whole Markdown.
- A business section (`make section-check`, --section). A .tex deliverable is converted from its
  approved Markdown drafts by hand, one section at a time, between a marker pair: a line
  `% section: <slug>` and a line `% end section: <slug>`. Only the text between that pair is
  compared, with the whole of the section's promoted draft.

Either way the LaTeX is stripped back to words and compared, in order, with the words Pandoc
reads from the Markdown. Any word inserted, deleted or changed is reported with a line number on
each side, and the check fails.

The LaTeX side keeps the text a command prints (\\emph{…}, \\footnote{…}, \\smallcaps{…},
\\dropcap{T}{he}, \\conlang[…]{…}, \\url{…} as written, \\ctitle{…}) and drops what only lays
the page out (\\label, \\vspace, \\enlargethispage, \\looseness=-1, \\dnote{…}, comments, the
repeated head of a long table). The Markdown side is `pandoc -t plain` through the same house
filter, with footnotes kept where they are called and every list number, table rule and heading
mark removed. Both sides then get the same normalisation: quotation marks and apostrophes, TeX
dashes and ellipses, ligatures, spaces (non-breaking, thin, ~). Letter case is compared exactly,
except inside small capitals, where the case of the letters is styling.

Structure is compared with the words, as marks in the stream (a report shows them):
  ⟦note⟧ … ⟦/note⟧          where each footnote opens and closes (\\footnote{…})
  ⟦break⟧                   a scene break or rule (\\scenebreak, \\srule; * * * in Markdown)
  ⟦epigraph⟧ … ⟦/epigraph⟧  an epigraph (the epigraph environment; ::: epigraph)
  ⟦quote⟧ … ⟦/quote⟧        a quotation (the quote environment; a > block quote)
So a word moved into or out of a footnote fails, and so does a scene break, epigraph or quotation
added or dropped. A cross-reference (\\ref{…}) prints a number the Markdown writes by hand: a
number there in the Markdown ('clause 4.2', '(b)') matches it; a \\ref where the Markdown has no
number is a warning.

A command neither the house class, the business preamble nor Pandoc's writer uses is reported as
a warning (its brace arguments are compared as text, so a word it carries still counts); --strict
makes every warning fail. An unresolved merge conflict (lines of <<<<<<<, ======= or >>>>>>>)
always fails.

What it cannot check: maths (each formula is compared only as a placeholder), the kind of block
the words sit in (a heading's level, a list, a table's cells, emphasis), the look of the page, or
whether a styling choice was the author's. Read the proof for those.

Standard library only; Python 3.8+. Needs pandoc for the Markdown side.
Exit codes: 0 = the words match; 1 = a difference, an unresolved conflict, a broken marker pair,
or (with --strict) a warning; 2 = usage error, a missing file or section, or pandoc missing or
failing.
"""
from __future__ import annotations

import argparse
import difflib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unicodedata
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_FILTER = HERE / "pandoc" / "house.lua"

# ── Structure marks, shared by both sides ───────────────────────────────────────

NOTE, NOTE_END = "\u27e6note\u27e7", "\u27e6/note\u27e7"
BREAK = "\u27e6break\u27e7"
EPIGRAPH, EPIGRAPH_END = "\u27e6epigraph\u27e7", "\u27e6/epigraph\u27e7"
QUOTE, QUOTE_END = "\u27e6quote\u27e7", "\u27e6/quote\u27e7"
REF = "\u27e6ref\u27e7"
MARKS = {NOTE, NOTE_END, BREAK, EPIGRAPH, EPIGRAPH_END, QUOTE, QUOTE_END, REF}
LEGEND = ("⟦note⟧ … ⟦/note⟧ mark where a footnote opens and closes, ⟦break⟧ a scene break or "
          "rule, ⟦epigraph⟧ and ⟦quote⟧ an epigraph or a quotation: structure, compared with "
          "the words.")

# ── Normalisation shared by both sides ──────────────────────────────────────────

CHAR_MAP = {
    "\u2018": "'", "\u2019": "'", "\u201a": "'", "\u201b": "'", "\u2032": "'", "`": "'",
    "\u201c": '"', "\u201d": '"', "\u201e": '"', "\u201f": '"', "\u2033": '"',
    "\u2015": "\u2014", "\u2010": "-", "\u2011": "-",
    "\ufb00": "ff", "\ufb01": "fi", "\ufb02": "fl", "\ufb03": "ffi", "\ufb04": "ffl",
    "\ufb05": "st", "\ufb06": "st",
    "\u00ad": "", "\u200b": "",
}


def is_word_char(ch: str) -> bool:
    cat = unicodedata.category(ch)
    return cat[0] in "LNM" or cat == "Co"


class Tok:
    __slots__ = ("text", "key", "line", "fold")

    def __init__(self, text: str, line: int, fold: bool) -> None:
        self.text = unicodedata.normalize("NFC", text)
        self.key = self.text.casefold()
        self.line = line
        self.fold = fold


def tokenise(chars: list) -> list:
    """chars: (character, line, fold) triples, already normalised. Returns Tok objects."""
    # Three full stops are one ellipsis, as Pandoc's smart typography reads them.
    flat = []
    i = 0
    while i < len(chars):
        if chars[i][0] == "." and i + 2 < len(chars) and chars[i + 1][0] == "." and chars[i + 2][0] == ".":
            flat.append(("\u2026", chars[i][1], chars[i][2]))
            i += 3
            continue
        flat.append(chars[i])
        i += 1
    toks = []
    i, n = 0, len(flat)
    while i < n:
        ch, line, fold = flat[i]
        if ch.isspace():
            i += 1
            continue
        if ch == "\u27e6":  # a structure mark is one token
            end = next((k for k in range(i + 1, min(i + 12, n)) if flat[k][0] == "\u27e7"), None)
            mark = "".join(c for c, _, _ in flat[i:end + 1]) if end is not None else ""
            if mark in MARKS:
                toks.append(Tok(mark, line, False))
                i = end + 1
                continue
        if is_word_char(ch):
            j, word, anyfold = i, [], False
            while j < n:
                c = flat[j][0]
                if is_word_char(c):
                    word.append(c)
                    anyfold = anyfold or flat[j][2]
                    j += 1
                elif c == "'" and j + 1 < n and is_word_char(flat[j + 1][0]) and word:
                    word.append(c)
                    j += 1
                elif c == "." and word and word[-1].isdigit() and j + 1 < n and flat[j + 1][0].isdigit():
                    word.append(c)  # 4.2 is one number, so a clause number is one token
                    j += 1
                else:
                    break
            toks.append(Tok("".join(word), line, anyfold))
            i = j
            continue
        toks.append(Tok(ch, line, fold))
        i += 1
    return toks


def normalise_chars(chars: list) -> list:
    out = []
    for ch, line, fold in chars:
        if ch in CHAR_MAP:
            for c in CHAR_MAP[ch]:
                out.append((c, line, fold))
        elif ch.isspace() or ch in "\u00a0\u2009\u202f\u2007":
            out.append((" ", line, fold))
        else:
            out.append((ch, line, fold))
    return out


def text_chars(text: str, first_line: int = 1) -> list:
    chars, line = [], first_line
    for ch in text:
        chars.append((ch, line, False))
        if ch == "\n":
            line += 1
    return chars


# ── The LaTeX side ──────────────────────────────────────────────────────────────

SYMBOLS = {
    "ldots": "\u2026", "dots": "\u2026", "textellipsis": "\u2026",
    "textquotesingle": "'", "textquotedbl": '"', "textquoteleft": "'", "textquoteright": "'",
    "textquotedblleft": '"', "textquotedblright": '"',
    "textasciitilde": "~", "textasciicircum": "^", "textbackslash": "\\", "textbar": "|",
    "textless": "<", "textgreater": ">", "textendash": "\u2013", "textemdash": "\u2014",
    "textbullet": "\u2022", "textdagger": "\u2020", "textdaggerdbl": "\u2021",
    "S": "\u00a7", "textsection": "\u00a7", "P": "\u00b6", "textparagraph": "\u00b6",
    "copyright": "\u00a9", "textcopyright": "\u00a9", "textregistered": "\u00ae",
    "texttrademark": "\u2122", "pounds": "\u00a3", "textsterling": "\u00a3", "euro": "\u20ac",
    "textdegree": "\u00b0", "LaTeX": "LaTeX", "TeX": "TeX", "textunderscore": "_",
    "slash": "/", "textasciigrave": "`", "textasteriskcentered": "*",
    # The business preamble (tooling/latex/house-preamble.tex)
    "fillme": "[AWAITING USER INPUT]",
}
SPACES = {"quad", "qquad", "hfill", "hfil", "hspace", "break", "linebreak", "newline",
          "bigskip", "medskip", "smallskip", "enspace", "thinspace", "allowbreak", "space",
          "hskip", "vskip", "par", "item"}
SWITCHES = {
    "protect", "tightlist", "noindent", "indent", "centering", "raggedright", "raggedleft",
    "newpage", "clearpage", "cleardoublepage", "relax", "leavevmode", "nobreak", "noalign",
    "itshape", "bfseries", "scshape", "upshape", "mdseries", "slshape", "normalfont", "em",
    "rmfamily", "sffamily", "ttfamily", "tiny", "scriptsize", "footnotesize", "small",
    "normalsize", "large", "Large", "LARGE", "huge", "Huge", "toprule", "midrule",
    "bottomrule", "endhead", "endfoot", "endlastfoot", "hline",
    "arraybackslash", "tabularnewline", "makeatletter", "makeatother",
    "frontmatter", "mainmatter", "backmatter", "tableofcontents", "housetitlepage",
    "maketitle", "phantomsection", "selectfont", "strut", "nopagebreak", "nolinebreak",
    "pagebreak", "vfill", "onehalfspacing", "singlespacing", "endgraf", "headingfont",
}
# Commands whose arguments are read: m = keep as text, joined to its neighbours as print joins
# it (\dropcap{T}{he} is one word); M = keep as text, set apart (a heading); d = drop;
# o = optional (dropped); O = optional kept as text (an \item label); * = an optional star;
# n = a TeX number (\looseness=-1).
ARGS = {
    "emph": "m", "textit": "m", "textbf": "m", "textup": "m", "textsl": "m", "textmd": "m",
    "textrm": "m", "textsf": "m", "texttt": "m", "textnormal": "m", "underline": "m",
    "ul": "m", "st": "m", "sout": "m", "textsuperscript": "m", "textsubscript": "m",
    "mbox": "m", "hbox": "m", "makebox": "oom", "footnotemark": "o", "caption": "oM",
    "chapter": "*oM", "section": "*oM", "subsection": "*oM", "subsubsection": "*oM",
    "paragraph": "*oM", "subparagraph": "*oM", "part": "*oM",
    "href": "dm", "hyperlink": "dm", "hypertarget": "dm", "hyperref": "om",
    "texorpdfstring": "md", "foreignlanguage": "odm", "label": "d",
    "cite": "*od", "nocite": "d", "index": "d", "includegraphics": "od",
    "pandocbounded": "m", "passthrough": "m", "vspace": "*d", "hspace": "*d",
    "enlargethispage": "*d", "setlength": "dd", "addtolength": "dd", "setcounter": "dd",
    "addtocounter": "dd", "thispagestyle": "d", "pagestyle": "d", "markboth": "dd",
    "markright": "d", "addcontentsline": "ddd", "pagenumbering": "d", "fontsize": "dd",
    "input": "d", "include": "d", "colorbox": "dm", "textcolor": "dm", "color": "d",
    "rule": "odd", "raisebox": "doom", "parbox": "oood", "item": "O",
    "looseness": "n", "penalty": "n", "hyphenpenalty": "n", "tolerance": "n",
    "linebreak": "o", "pagebreak": "o", "nopagebreak": "o", "nolinebreak": "o",
    # The house class (tooling/latex/housebook.cls)
    "smallcaps": "m", "greek": "m", "hebrew": "m", "conlang": "om", "conlangnative": "oom",
    "epigraphsource": "M", "dropcap": "mm", "lettrine": "omm", "dnote": "d", "housemap": "d",
    "houseinput": "d", "housereferences": "o", "setscenebreak": "d", "runningtitle": "d",
    "CSLBlock": "m", "CSLLeftMargin": "m", "CSLRightInline": "m", "CSLIndent": "m",
    "MakeUppercase": "m", "MakeLowercase": "m", "textsc": "m",
    # The business preamble: \ctitle heads a clause; \ins is redline text added, \del and \cmt
    # are redline marks (struck text, a comment), not the document's words.
    "ctitle": "M", "ins": "m", "del": "d", "cmt": "d", "housetitle": "ddd",
}
FOLD = {"smallcaps", "textsc", "MakeUppercase", "MakeLowercase"}
DEFINERS = {"newcommand", "renewcommand", "providecommand", "DeclareRobustCommand"}
BREAKS = {"scenebreak", "srule"}
NOTES = {"footnote", "footnotetext"}
REFS = {"ref", "pageref", "autoref", "cref", "Cref"}
VERBATIM_ARGS = {"url", "nolinkurl"}
ENV_ARGS = {
    "longtable": "od", "tabular": "od", "tabularx": "dd", "minipage": "oood",
    "CSLReferences": "dd", "otherlanguage": "od", "figure": "o", "table": "o", "list": "dd",
    "Shaded": "", "Highlighting": "o", "multicols": "d",
}
ENV_MARKS = {"epigraph": (EPIGRAPH, EPIGRAPH_END), "quote": (QUOTE, QUOTE_END),
             "quotation": (QUOTE, QUOTE_END)}
KNOWN_ENVS = {"center", "flushleft", "flushright", "quote", "quotation", "verse", "itemize",
              "enumerate", "description", "epigraph", "titlepage", "document", "verbatim",
              "Verbatim", "lstlisting", "clause", "housenotice", "housecontrol"} | set(ENV_ARGS)
ACCENTS = {"'": "\u0301", "`": "\u0300", "^": "\u0302", '"': "\u0308", "~": "\u0303",
           "=": "\u0304", ".": "\u0307", "u": "\u0306", "v": "\u030c", "H": "\u030b",
           "c": "\u0327", "k": "\u0328", "r": "\u030a"}
# An accent over nothing (\^{}, \~{}) prints the mark itself: Pandoc writes a literal ^ as \^{}.
SPACING_ACCENTS = {"\u0302": "^", "\u0303": "~", "\u0308": "\u00a8", "\u0301": "\u00b4",
                   "\u0300": "`", "\u0304": "\u00af", "\u0307": "\u02d9", "\u0306": "\u02d8",
                   "\u030c": "\u02c7", "\u030b": "\u02dd", "\u0327": "\u00b8", "\u0328": "\u02db",
                   "\u030a": "\u02da"}
# Characters Pandoc percent-encodes in a \url, and the escapes it adds.
URL_ESCAPES = re.compile(r"\\([#%&_{}$~^])")
URL_PERCENT = re.compile(r"%(5[EeBbDd]|7[BbCcDd]|3[CcEe]|22|60)")
END_HEAD = re.compile(r"\\endhead(?![A-Za-z])")
MATH = "\u27e8math\u27e9"


class TexReader:
    """Reads LaTeX source into (character, line, fold) triples of the text it prints."""

    def __init__(self, text: str) -> None:
        self.s = text
        self.i = 0
        self.line = 1
        self.out = []
        self.unknown = []  # (line, name)

    # -- low-level movement --
    def peek(self, k: int = 0) -> str:
        j = self.i + k
        return self.s[j] if j < len(self.s) else ""

    def advance(self, k: int = 1) -> None:
        for _ in range(k):
            if self.i < len(self.s):
                if self.s[self.i] == "\n":
                    self.line += 1
                self.i += 1

    def emit(self, text: str, fold: bool, line=None) -> None:
        for ch in text:
            self.out.append((ch, self.line if line is None else line, fold))

    def mark(self, mark: str, line=None) -> None:
        self.emit(" " + mark + " ", False, line)

    def skip_spaces(self, newlines: bool = True) -> None:
        while self.peek() and self.peek() in " \t" + ("\n" if newlines else ""):
            self.advance()

    def skip_comment(self) -> None:
        while self.peek() and self.peek() != "\n":
            self.advance()
        self.advance()  # the newline: a comment joins its line to the next, as TeX does
        while self.peek() in (" ", "\t"):
            self.advance()

    def skip_group(self, open_="{", close="}") -> str:
        """Consume a balanced group starting at open_; return its raw inside."""
        assert self.peek() == open_
        self.advance()
        depth, start = 1, self.i
        while self.peek():
            c = self.peek()
            if c == "\\":
                self.advance(2)
                continue
            if c == "%":
                self.skip_comment()
                continue
            if c == open_:
                depth += 1
            elif c == close:
                depth -= 1
                if depth == 0:
                    inner = self.s[start:self.i]
                    self.advance()
                    return inner
            self.advance()
        return self.s[start:]

    def next_arg_is(self, ch: str) -> bool:
        j = self.i
        while j < len(self.s) and self.s[j] in " \t\n":
            if self.s[j] == "\n" and j + 1 < len(self.s) and self.s[j + 1] == "\n":
                return False  # a blank line ends the search: a new paragraph is not an argument
            j += 1
        if j < len(self.s) and self.s[j] == ch:
            while self.i < j:
                self.advance()
            return True
        return False

    # -- the reader --
    def read(self, fold: bool = False, until_brace: bool = False) -> None:
        while self.i < len(self.s):
            c = self.peek()
            if c == "}":
                if until_brace:
                    self.advance()
                    return
                self.advance()
                continue
            if c == "{":
                self.advance()
                self.read(fold, until_brace=True)
                continue
            if c == "%":
                self.skip_comment()
                continue
            if c == "\\":
                self.command(fold)
                continue
            if c == "~":
                self.emit(" ", fold)
                self.advance()
                continue
            if c == "&":
                self.emit(" ", fold)
                self.advance()
                continue
            if c == "$":
                self.math_dollar(fold)
                continue
            if c in "#^_":
                self.advance()
                continue
            if c == "-":
                if self.s.startswith("---", self.i):
                    self.emit("\u2014", fold)
                    self.advance(3)
                elif self.s.startswith("--", self.i):
                    self.emit("\u2013", fold)
                    self.advance(2)
                else:
                    self.emit("-", fold)
                    self.advance()
                continue
            if c == "`":
                if self.s.startswith("``", self.i):
                    self.emit('"', fold)
                    self.advance(2)
                else:
                    self.emit("'", fold)
                    self.advance()
                continue
            if c == "'":
                if self.s.startswith("''", self.i):
                    self.emit('"', fold)
                    self.advance(2)
                else:
                    self.emit("'", fold)
                    self.advance()
                continue
            self.emit(c, fold)
            self.advance()

    def math_dollar(self, fold: bool) -> None:
        line = self.line
        double = self.s.startswith("$$", self.i)
        self.advance(2 if double else 1)
        end = "$$" if double else "$"
        while self.peek() and not self.s.startswith(end, self.i):
            if self.peek() == "\\":
                self.advance()
            self.advance()
        self.advance(len(end))
        self.emit(MATH, fold, line)

    def math_until(self, closer: str, fold: bool) -> None:
        line = self.line
        while self.peek() and not self.s.startswith(closer, self.i):
            self.advance()
        self.advance(len(closer))
        self.emit(MATH, fold, line)

    def arg_text(self, fold: bool) -> None:
        """Read one mandatory argument as text."""
        self.skip_spaces()
        if self.peek() == "{":
            self.advance()
            self.read(fold, until_brace=True)
        elif self.peek() == "\\":
            self.command(fold)
        elif self.peek():
            self.emit(self.peek(), fold)
            self.advance()

    def arg_drop(self) -> None:
        self.skip_spaces()
        if self.peek() == "{":
            self.skip_group()
        elif self.peek() == "\\":
            self.advance()
            if self.peek().isalpha():
                while self.peek().isalpha():
                    self.advance()
            else:
                self.advance()
        elif self.peek():
            self.advance()

    def run_spec(self, spec: str, fold: bool) -> None:
        for kind in spec:
            if kind == "*":
                if self.peek() == "*":
                    self.advance()
            elif kind == "o":
                if self.next_arg_is("["):
                    self.skip_group("[", "]")
            elif kind == "O":
                if self.next_arg_is("["):
                    self.advance()
                    while self.peek():
                        if self.peek() == "]":
                            break
                        if self.peek() == "{":
                            self.advance()
                            self.read(fold, until_brace=True)
                            continue
                        if self.peek() == "\\":
                            self.command(fold)
                            continue
                        self.emit(self.peek(), fold)
                        self.advance()
                    self.advance()
            elif kind == "m":
                self.arg_text(fold)
            elif kind == "M":
                self.emit(" ", fold)
                self.arg_text(fold)
                self.emit(" ", fold)
            elif kind == "d":
                self.arg_drop()
            elif kind == "n":
                self.skip_spaces()
                if self.peek() == "=":
                    self.advance()
                self.skip_spaces()
                if self.peek() in "+-":
                    self.advance()
                while self.peek().isdigit():
                    self.advance()

    def command(self, fold: bool) -> None:
        line = self.line
        self.advance()  # the backslash
        c = self.peek()
        if not c:
            return
        if not c.isalpha():
            self.advance()
            if c == "\\":  # a line break, with an optional star and length
                if self.peek() == "*":
                    self.advance()
                if self.next_arg_is("["):
                    self.skip_group("[", "]")
                self.emit(" ", fold)
            elif c in "&%$#_{}":
                self.emit(c, fold)
            elif c == " " or c == "\n":
                self.emit(" ", fold)
            elif c == "(":
                self.math_until("\\)", fold)
            elif c == "[":
                self.math_until("\\]", fold)
            elif c in ACCENTS:
                self.accent(ACCENTS[c], fold)
            # \, \; \: \! \/ \- \@ print no letters
            return
        name = ""
        while self.peek().isalpha():
            name += self.peek()
            self.advance()
        if name in ACCENTS and len(name) == 1:
            self.accent(ACCENTS[name], fold)
            return
        self.skip_spaces(newlines=False)
        if name in ("begin", "end"):
            self.environment(name, fold, line)
            return
        if name in VERBATIM_ARGS:  # a URL prints as written: keep its _ ~ ^, undo Pandoc's escapes
            self.skip_spaces()
            if self.peek() == "{":
                raw = URL_PERCENT.sub(lambda m: chr(int(m.group(1), 16)),
                                      URL_ESCAPES.sub(r"\1", self.skip_group()))
                self.emit(raw, fold, line)
            return
        if name in NOTES:
            self.run_spec("o", fold)
            self.mark(NOTE, line)
            self.arg_text(fold)
            self.mark(NOTE_END)
            return
        if name in BREAKS:
            self.mark(BREAK, line)
            return
        if name in REFS:
            if self.peek() == "*":
                self.advance()
            self.arg_drop()
            self.mark(REF, line)
            return
        if name == "endfirsthead":  # a long table's head again, for its later pages: read once
            m = END_HEAD.search(self.s, self.i)
            if m:
                self.advance(m.end() - self.i)
            self.emit(" ", fold, line)
            return
        if name in ("def", "gdef", "edef", "xdef"):
            self.arg_drop()
            while self.peek() and self.peek() != "{":
                self.advance()
            if self.peek() == "{":
                self.skip_group()
            return
        if name == "let":
            self.arg_drop()
            self.skip_spaces()
            if self.peek() == "=":
                self.advance()
            self.arg_drop()
            return
        if name in DEFINERS:
            if self.peek() == "*":
                self.advance()
            self.arg_drop()
            while self.next_arg_is("["):
                self.skip_group("[", "]")
            self.arg_drop()
            return
        if name == "vadjust":
            self.skip_spaces()
            if self.s.startswith("pre", self.i):
                self.advance(3)
            self.arg_drop()
            return
        if name in SYMBOLS:
            if self.s.startswith("{}", self.i):
                self.advance(2)
            self.emit(SYMBOLS[name], fold, line)
            return
        if name in SPACES and name not in ARGS:
            self.emit(" ", fold, line)
            if name in ("hspace", "hskip", "vskip"):
                self.run_spec("*d", fold)
            return
        if name in SWITCHES and name not in ARGS:
            if name in ("pagebreak", "nopagebreak", "linebreak", "nolinebreak") and self.next_arg_is("["):
                self.skip_group("[", "]")
            self.emit(" ", fold, line)
            return
        if name in ARGS:
            if name in SPACES or name in SWITCHES:
                self.emit(" ", fold, line)
            self.run_spec(ARGS[name], fold or name in FOLD)
            return
        # Unknown: compare every brace argument as text, so a word it carries still counts.
        self.unknown.append((line, name))
        while self.next_arg_is("["):
            self.skip_group("[", "]")
        while self.next_arg_is("{"):
            self.emit(" ", fold)
            self.arg_text(fold)
            self.emit(" ", fold)

    def accent(self, mark: str, fold: bool) -> None:
        self.skip_spaces(newlines=False)
        if self.peek() == "{":
            inner = self.skip_group()
            base = inner.strip().lstrip("\\")
        else:
            base = self.peek()
            self.advance()
        if not base:
            self.emit(SPACING_ACCENTS.get(mark, mark), fold)
            return
        self.emit(unicodedata.normalize("NFC", base + mark), fold)

    def environment(self, which: str, fold: bool, line: int) -> None:
        if self.peek() != "{":
            return
        env = self.skip_group().strip()
        self.emit(" ", fold, line)
        if env in ENV_MARKS:
            self.mark(ENV_MARKS[env][0 if which == "begin" else 1], line)
        if which == "end":
            return
        if env not in KNOWN_ENVS:
            self.unknown.append((line, "begin{" + env + "}"))
        if env in ("verbatim", "Verbatim", "lstlisting"):
            closer = "\\end{" + env + "}"
            while self.peek() and not self.s.startswith(closer, self.i):
                self.emit(self.peek(), fold)
                self.advance()
            return
        self.run_spec(ENV_ARGS.get(env, ""), fold)


def tex_tokens(text: str):
    reader = TexReader(text)
    reader.read()
    return tokenise(normalise_chars(reader.out)), reader.unknown


def conflicts(text: str) -> list:
    found = []
    for n, line in enumerate(text.splitlines(), 1):
        if line.startswith(("<<<<<<<", ">>>>>>>", "|||||||")) or line.rstrip() == "=======":
            found.append(n)
    return found


# ── A business section: the text between its marker pair ──────────────────────

SECTION_OPEN = re.compile(r"^\s*%\s*section:\s*(\S+)\s*$")
SECTION_CLOSE = re.compile(r"^\s*%\s*end section:\s*(\S+)\s*$")


class SectionError(Exception):
    """A marker pair that cannot be read. code 2: no such section; code 1: a broken pair."""

    def __init__(self, message: str, code: int) -> None:
        super().__init__(message)
        self.code = code


def section_text(tex_text: str, slug: str) -> str:
    """The .tex with every line outside the section's marker pair blanked, so that line numbers
    still match the file."""
    lines = tex_text.split("\n")
    opens = [n for n, ln in enumerate(lines) if SECTION_OPEN.match(ln)]
    closes = [n for n, ln in enumerate(lines) if SECTION_CLOSE.match(ln)]
    mine = [n for n in opens if SECTION_OPEN.match(lines[n]).group(1) == slug]
    ends = [n for n in closes if SECTION_CLOSE.match(lines[n]).group(1) == slug]
    if not mine:
        found = sorted({SECTION_OPEN.match(lines[n]).group(1) for n in opens})
        raise SectionError(f"no '% section: {slug}' line; the sections in this file are: "
                           + (", ".join(found) if found else "none"), 2)
    if len(mine) > 1 or len(ends) > 1:
        twice = [n + 1 for n in (mine if len(mine) > 1 else ends)]
        raise SectionError(f"section '{slug}' has more than one "
                           f"{'opening' if len(mine) > 1 else 'closing'} marker (lines "
                           + ", ".join(map(str, twice)) + ")", 1)
    start = mine[0]
    if not ends or ends[0] < start:
        raise SectionError(f"section '{slug}' opens at line {start + 1} but has no "
                           f"'% end section: {slug}' line after it", 1)
    end = ends[0]
    inside = [n + 1 for n in opens + closes if start < n < end]
    if inside:
        raise SectionError(f"another section's marker sits inside section '{slug}' (line "
                           f"{inside[0]}); marker pairs never nest", 1)
    return "\n".join(ln if start < n < end else "" for n, ln in enumerate(lines))


# ── The Markdown side ──────────────────────────────────────────────────────────

# A second filter, run after the house filter: every word the reader meets, in the order the
# LaTeX sets it, one line per block, with each footnote where it is called and the structure
# marks around it. Its output is a raw plain block, so `-t plain` prints it as it stands.
FLATTEN_LUA = r"""
local M = { note = '⟦note⟧', note_end = '⟦/note⟧', brk = '⟦break⟧',
            epigraph = '⟦epigraph⟧', epigraph_end = '⟦/epigraph⟧',
            quote = '⟦quote⟧', quote_end = '⟦/quote⟧' }
local out = {}
local deferred = nil
local inlines, blocks
local function put(s) out[#out + 1] = s end
local function note(el) put(' ' .. M.note .. ' '); blocks(el.content); put(' ' .. M.note_end .. ' ') end
inlines = function(list)
  for _, el in ipairs(list) do
    local t = el.t
    if t == 'Str' then put(el.text)
    elseif t == 'Space' or t == 'SoftBreak' or t == 'LineBreak' then put(' ')
    elseif t == 'Quoted' then
      local q = el.quotetype == 'SingleQuote' and "'" or '"'
      put(q); inlines(el.content); put(q)
    elseif t == 'Note' then
      if deferred then deferred[#deferred + 1] = el else note(el) end
    elseif t == 'Math' then put('\u{27E8}math\u{27E9}')
    elseif t == 'Code' then put(el.text)
    elseif t == 'RawInline' or t == 'Image' then
    elseif el.content then inlines(el.content)
    end
  end
end
local function cells(rows)
  for _, row in ipairs(rows) do
    for _, cell in ipairs(row.cells) do blocks(cell.contents); put(' ') end
  end
end
local function has(b, class) return b.classes ~= nil and b.classes:includes(class) end
blocks = function(list)
  for _, b in ipairs(list) do
    local t = b.t
    if t == 'Para' or t == 'Plain' or t == 'Header' then inlines(b.content); put('\n')
    elseif t == 'LineBlock' then for _, l in ipairs(b.content) do inlines(l); put('\n') end
    elseif t == 'CodeBlock' then put(b.text); put('\n')
    elseif t == 'HorizontalRule' then put(M.brk .. '\n')
    elseif t == 'BlockQuote' then put(M.quote .. '\n'); blocks(b.content); put(M.quote_end .. '\n')
    elseif t == 'Div' and has(b, 'epigraph') then
      put(M.epigraph .. '\n'); blocks(b.content); put(M.epigraph_end .. '\n')
    elseif t == 'Div' and has(b, 'scene-break') then put(M.brk .. '\n')
    elseif t == 'BulletList' or t == 'OrderedList' then
      for _, item in ipairs(b.content) do blocks(item) end
    elseif t == 'DefinitionList' then
      for _, entry in ipairs(b.content) do
        inlines(entry[1]); put('\n')
        for _, def in ipairs(entry[2]) do blocks(def) end
      end
    elseif t == 'Table' then
      -- in the order a LaTeX long table sets them: caption, head, foot, then the body rows
      if b.caption and b.caption.long then blocks(b.caption.long) end
      cells(b.head.rows)
      cells(b.foot.rows)
      for _, body in ipairs(b.bodies) do cells(body.head); cells(body.body) end
    elseif t == 'Figure' then
      blocks(b.content)
      -- a footnote in a figure's caption is set after the figure (\footnotetext)
      local outer = deferred
      deferred = {}
      if b.caption and b.caption.long then blocks(b.caption.long) end
      local notes = deferred
      deferred = outer
      for _, n in ipairs(notes) do note(n) end
    elseif b.content and t ~= 'RawBlock' then blocks(b.content)
    end
  end
end
function Pandoc(doc)
  blocks(doc.blocks)
  return pandoc.Pandoc({ pandoc.RawBlock('plain', table.concat(out)) }, doc.meta)
end
"""


class ToolError(Exception):
    """pandoc missing or failing, or an unreadable file (exit 2)."""


def pandoc_plain(md: Path, house_filter, defaults, pandoc: str) -> str:
    exe = shutil.which(pandoc)
    if not exe:
        raise ToolError(f"pandoc not found ({pandoc}); install it, or pass --pandoc")
    with tempfile.TemporaryDirectory() as tmp:
        flat = Path(tmp) / "flatten.lua"
        flat.write_text(FLATTEN_LUA, encoding="utf-8")
        cmd = [exe]
        if defaults:
            cmd.append(f"--defaults={defaults}")
        cmd += ["-f", "markdown", "-t", "plain", "--wrap=none",
                "-M", "suppress-bibliography=true"]
        if house_filter:
            cmd.append(f"--lua-filter={house_filter}")
        cmd += [f"--lua-filter={flat}", str(md)]
        proc = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
    if proc.returncode != 0:
        raise ToolError(f"pandoc failed on {md}:\n{proc.stderr.strip()}")
    if proc.stderr.strip():
        sys.stderr.write(proc.stderr)
    return proc.stdout


def md_tokens(plain: str, source: str) -> list:
    """Tokens from pandoc's plain text, each given the source line it most likely came from.

    Only words anchor, and only where a run of them matches the source in order (difflib), so
    words Pandoc writes that the source does not (a citation's author and year) never pull the
    line numbers of everything after them to a later match.
    """
    toks = tokenise(normalise_chars(text_chars(plain)))
    lines = source.split("\n")
    body_start = 0
    if lines and lines[0].strip() == "---":
        for n in range(1, len(lines)):
            if lines[n].strip() in ("---", "..."):
                body_start = n + 1
                break
    src = "\n".join(lines[body_start:])
    src = src.replace("---", "\u2014").replace("--", "\u2013")
    src_toks = tokenise(normalise_chars(text_chars(src, body_start + 1)))
    words_md = [k for k, t in enumerate(toks) if is_word_char(t.text[0])]
    words_src = [k for k, t in enumerate(src_toks) if is_word_char(t.text[0])]
    sm = difflib.SequenceMatcher(None, [toks[k].key for k in words_md],
                                 [src_toks[k].key for k in words_src], autojunk=False)
    anchored = {}
    for a, b, size in sm.get_matching_blocks():
        for d in range(size):
            anchored[words_md[a + d]] = src_toks[words_src[b + d]].line
    last = body_start + 1
    for k, tok in enumerate(toks):
        last = anchored.get(k, last)
        tok.line = last
    return toks


# ── Comparison and the report ──────────────────────────────────────────────────

def words(toks, a: int, b: int, limit: int = 14) -> str:
    seg = [t.text for t in toks[a:b]]
    text = " ".join(seg[:limit]) + (" …" if len(seg) > limit else "")
    return "'" + text + "'"


def lines_of(toks, a: int, b: int) -> str:
    if a >= len(toks):
        return f"line {toks[-1].line if toks else 1} (end)"
    first, last = toks[a].line, toks[max(a, b - 1)].line
    return f"line {first}" if first == last else f"lines {first}–{last}"


REF_NUMBER = re.compile(r"[0-9]+(?:\.[0-9]+)*|[a-z]|[ivxlc]+|[()]")


def is_reference_number(toks) -> bool:
    """'4.2', '7(b)' or '(iii)': the number a \\ref prints, written by hand in the Markdown."""
    keys = [t.key for t in toks]
    return (bool(keys) and all(REF_NUMBER.fullmatch(k) for k in keys)
            and (any(k[0].isdigit() for k in keys) or (keys[0] == "(" and keys[-1] == ")")))


def split_refs(tex: list):
    """The tokens without their \\ref marks, and where each mark stood: {index: [lines]}."""
    kept, refs = [], {}
    for t in tex:
        if t.key == REF:
            refs.setdefault(len(kept), []).append(t.line)
        else:
            kept.append(t)
    return kept, refs


def compare(md: list, tex: list, refs=None) -> list:
    problems = []
    refs = refs if refs is not None else {}
    sm = difflib.SequenceMatcher(None, [t.key for t in md], [t.key for t in tex], autojunk=False)
    for op, a1, a2, b1, b2 in sm.get_opcodes():
        if op == "equal":
            for k in range(a2 - a1):
                m, t = md[a1 + k], tex[b1 + k]
                if m.text != t.text and not t.fold:
                    problems.append(f"changed case: Markdown line {m.line} '{m.text}' → .tex line {t.line} '{t.text}'")
        elif op == "replace":
            problems.append(f"changed: Markdown {lines_of(md, a1, a2)} {words(md, a1, a2)} → "
                            f".tex {lines_of(tex, b1, b2)} {words(tex, b1, b2)}")
        elif op == "delete":
            if refs.get(b1) and is_reference_number(md[a1:a2]):
                refs[b1].pop(0)  # the \ref prints this number
                continue
            problems.append(f"deleted: Markdown {lines_of(md, a1, a2)} {words(md, a1, a2)} is missing "
                            f"from the .tex (near {lines_of(tex, b1, b1 + 1)})")
        elif op == "insert":
            problems.append(f"inserted: .tex {lines_of(tex, b1, b2)} {words(tex, b1, b2)} is not in the "
                            f"Markdown (near {lines_of(md, a1, a1 + 1)})")
    return problems


def check(tex_text: str, plain: str, md_source: str, strict: bool = False):
    """Returns (problems, warnings, word_count)."""
    problems = [f"unresolved merge conflict: .tex line {n}" for n in conflicts(tex_text)]
    tex, unknown = tex_tokens(tex_text)
    tex, refs = split_refs(tex)
    md = md_tokens(plain, md_source)
    problems += compare(md, tex, refs)
    warnings = []
    seen = set()
    for line, name in unknown:
        if name in seen:
            continue
        seen.add(name)
        warnings.append(f".tex line {line}: \\{name} is neither a house macro nor a Pandoc construct; "
                        "its brace arguments were compared as text")
    for line in sorted(ln for lines in refs.values() for ln in lines):
        warnings.append(f".tex line {line}: a \\ref prints a number where the Markdown has none")
    if strict:
        problems += ["(strict) " + w for w in warnings]
    return problems, warnings, sum(1 for t in md if is_word_char(t.text[0]))


def run(args) -> int:
    tex_path, md_path = Path(args.styled), Path(args.source)
    for p in (tex_path, md_path):
        if not p.is_file():
            print(f"error: {p} not found", file=sys.stderr)
            return 2
    house = args.filter if args.filter else (DEFAULT_FILTER if DEFAULT_FILTER.is_file() else None)
    if house and not Path(house).is_file():
        print(f"error: filter {house} not found", file=sys.stderr)
        return 2
    try:
        tex_text = tex_path.read_text(encoding="utf-8")
        md_text = md_path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError) as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    what = f"{tex_path}"
    if args.section:
        what = f"section '{args.section}' of {tex_path}"
        try:
            tex_text = section_text(tex_text, args.section)
        except SectionError as err:
            print(f"{'error' if err.code == 2 else 'texcheck'}: {tex_path}: {err}",
                  file=sys.stderr if err.code == 2 else sys.stdout)
            return err.code
    try:
        plain = pandoc_plain(md_path, house, args.defaults, args.pandoc)
    except ToolError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    problems, warnings, count = check(tex_text, plain, md_text, args.strict)
    for w in warnings:
        print(f"warning: {w}")
    if problems:
        print(f"texcheck: {what} differs from {md_path}: {len(problems)} difference(s)")
        for p in problems:
            print(f"  {p}")
        if any("\u27e6" in p for p in problems):
            print(f"  {LEGEND}")
        if args.section:
            print("  The approved words are the draft's. Fix the conversion in the .tex, never the draft.")
        else:
            print("  The words come from the Markdown. Fix the .tex (or re-typeset), never the reverse.")
        return 1
    if not args.quiet:
        print(f"texcheck: {what} carries the words of {md_path} exactly ({count} words)")
    return 0


# ── Self-test ──────────────────────────────────────────────────────────────────

SAMPLE_PLAIN = """The Ford
⟦epigraph⟧
'Count the stones, and the river lets you pass.'
— a saying of the ford villages
⟦/epigraph⟧
The river was louder in the dark — and hebori too…
Maren's lantern was shuttered; it's 'quiet' and "loud" – ok. ⟦note⟧ A note, inline.
 ⟦/note⟧  See the LORD.
⟦quote⟧
'Never at night,' she said.
⟦/quote⟧
⟦break⟧
Tam had told her the ford was safe at 10 000 paces.
"""
SAMPLE_MD = """# The Ford

::: epigraph
'Count the stones, and the river lets you pass.'

— a saying of the ford villages
:::

The river was louder in the dark --- and [hebori]{.conlang lang=example-tongue} too...
Maren's lantern was shuttered; it's 'quiet' and "loud" -- ok.[^1] See the LORD.

> 'Never at night,' she said.

* * *

Tam had told her the ford was safe at 10 000 paces.

[^1]: A note, inline.
"""
SAMPLE_BASE = r"""\hypertarget{the-ford}{%
\chapter{The Ford}\label{the-ford}}

\begin{epigraph}

`Count the stones, and the river lets you pass.'

\epigraphsource{--- a saying of the ford villages}

\end{epigraph}

% section: opening

The river was louder in the dark --- and \conlang[example-tongue]{hebori} too\ldots{}
Maren's lantern was shuttered; it's `quiet' and ``loud'' -- ok.\footnote{A note, inline.} See the LORD.

\begin{quote}
`Never at night,' she said.
\end{quote}

\scenebreak

Tam had told her the ford was safe at 10~000 paces.
"""

# A source whose citation Pandoc writes as words the source does not hold, with a later line
# that holds one of them: the Markdown line of a change after it must still be right.
CITED_MD = "\n".join(
    ["# Cited", "", "As the record shows [@smith2020, p. 4], the word was kept."]
    + [f"Filler line {n} keeps the lines apart." for n in range(4, 13)]
    + ["The word λόγος was written here."]
    + [f"Filler line {n} keeps the lines apart." for n in range(14, 34)]
    + ["Smith wrote of it again, years later.", ""])
CITED_PLAIN = CITED_MD.replace("[@smith2020, p. 4]", "(Smith 2020, p. 4)").replace("# Cited", "Cited")
CITED_TEX = CITED_PLAIN.replace("Cited", r"\chapter{Cited}", 1)

EDGE_MD = """# Edges

See <https://example.org/a_b~c^d> and <a_b@example.org>.
A caret ^ here and a tilde ~ too, a\\_b and 50% & #1.

| Column A | Column B[^t] |
|---|---|
| one | two |

: A table caption.

> A quoted line.

* * *

Last line.

[^t]: A note in a table head.
"""

SECTION_TEX = r"""% unit: example
\documentclass[11pt]{article}
\begin{document}
\housetitle{Title}{Name}{01/01/2027}
% section: summary
\section{Summary}

What this document is for.
% end section: summary

% section: terms
\section{Terms}

\begin{clause}
  \item \ctitle{Definitions}\label{cl:definitions}
  In this document, \textbf{the Work} means the rewrite.\dnote{VERIFY: the scope}
  \item The fees are in clause~\ref{cl:definitions} and paid within 30 days.
\end{clause}
% end section: terms
\end{document}
"""
SECTION_MD = """---
unit: example
section: terms
---

## Terms

### Definitions

In this document, **the Work** means the rewrite. <!-- VERIFY: the scope -->

The fees are in clause 1.1 and paid within 30 days.
"""
SECTION_PLAIN = """Terms
Definitions
In this document, the Work means the rewrite.
The fees are in clause 1.1 and paid within 30 days.
"""


def self_test() -> int:
    failures = []

    def verdict(label, passed, lines=()):
        print(f"  {'ok  ' if passed else 'FAIL'} {label}")
        if not passed:
            failures.append(label)
            for p in lines:
                print(f"         {p}")

    def expect(label, tex, ok, contains=None, strict=False, plain=SAMPLE_PLAIN, md=SAMPLE_MD):
        problems, warnings, _ = check(tex, plain, md, strict)
        passed = (not problems) == ok and (contains is None or any(contains in p for p in problems + warnings))
        verdict(label, passed, problems + warnings)

    styled = (SAMPLE_BASE
              .replace("The river was", r"\dropcap{T}{he river} was")
              .replace("See the LORD.", r"See the \smallcaps{Lord}.\enlargethispage{\baselineskip}")
              .replace("Tam had told", "\\looseness=-1\n% a widow fixed by hand\nTam had to\\-ld")
              .replace(r"\end{epigraph}", "\\end{epigraph}\n\\pagebreak[3]"))
    print("texcheck.py --self-test")
    expect("the Pandoc base matches its Markdown", SAMPLE_BASE, True)
    expect("house styling changes no word", styled, True)
    expect("a changed word fails", styled.replace("louder", "loud"), False, "changed")
    expect("a deleted word fails", styled.replace("lantern was", "lantern"), False, "deleted")
    expect("an inserted word fails", styled.replace("in the dark", "in the deep dark"), False, "inserted")
    expect("changed punctuation fails", styled.replace("shuttered;", "shuttered,"), False, "changed")
    expect("a case change outside small capitals fails", styled.replace("Maren's", "maren's"), False, "case")
    expect("a change inside a footnote fails", styled.replace(r"\footnote{A note, inline.}", r"\footnote{A note, inline}"), False)
    expect("a word moved into a footnote fails",
           styled.replace(r"\footnote{A note, inline.} See", r"\footnote{A note, inline. See}"), False, "See")
    expect("a word moved out of a footnote fails",
           styled.replace(r"ok.\footnote{A note, inline.}", r"ok. A\footnote{note, inline.}"), False, "'A'")
    expect("a dropped scene break fails", styled.replace("\\scenebreak\n", ""), False, BREAK)
    expect("an added scene break fails", styled.replace("\\pagebreak[3]", "\\scenebreak"), False, BREAK)
    expect("a dropped epigraph environment fails",
           styled.replace("\\begin{epigraph}\n", "").replace("\\end{epigraph}\n", ""), False, EPIGRAPH)
    expect("a dropped quote environment fails",
           styled.replace("\\begin{quote}\n", "").replace("\\end{quote}\n", ""), False, QUOTE)
    expect("a merge conflict fails", styled + "<<<<<<< styled\nx\n=======\ny\n>>>>>>> new-base\n", False, "conflict")
    expect("an unknown command warns", styled.replace(r"\pagebreak[3]", r"\fancybreak{}"), True, "fancybreak")
    expect("an unknown command fails with --strict", styled.replace(r"\pagebreak[3]", r"\fancybreak{}"), False, "strict", strict=True)
    expect("words inside an unknown command still count", styled.replace("too", r"\textlarger{too much}"), False, "inserted")
    expect("a URL keeps its _ ~ and ^", r"See \url{https://example.org/a_b~c\%5Ed\#x}.", True,
           plain="See https://example.org/a_b~c^d#x.\n", md="See <https://example.org/a_b~c^d#x>.\n")
    expect("a changed URL fails", r"See \url{https://example.org/a_c}.", False, "changed",
           plain="See https://example.org/a_b.\n", md="See <https://example.org/a_b>.\n")
    expect("a literal caret and tilde match", r"A caret \^{} and a tilde \textasciitilde{} and \~{} too.", True,
           plain="A caret ^ and a tilde ~ and ~ too.\n", md="A caret ^ and a tilde ~ and ~ too.\n")
    expect("an accent on a letter still composes", r"Caf\'{e} and na\"ive.", True,
           plain="Café and naïve.\n", md="Café and naïve.\n")
    cited = check(CITED_TEX.replace("λόγος", "λόγοι"), CITED_PLAIN, CITED_MD)[0]
    verdict("a change after a citation names its own Markdown line",
            len(cited) == 1 and "Markdown line 13" in cited[0], cited)

    section = section_text(SECTION_TEX, "terms")
    expect("section mode: the converted section matches its draft", section, True,
           plain=SECTION_PLAIN, md=SECTION_MD)
    expect("section mode: a changed word fails", section.replace("rewrite", "review"), False, "changed",
           plain=SECTION_PLAIN, md=SECTION_MD)
    expect("section mode: the rest of the document is what the pair leaves out", SECTION_TEX,
           False, "inserted", plain=SECTION_PLAIN, md=SECTION_MD)
    expect("section mode: a \\ref with no number in the draft warns",
           section, True, "\\ref", plain=SECTION_PLAIN.replace("clause 1.1", "clause"),
           md=SECTION_MD.replace("clause 1.1", "clause"))
    for label, tex, slug, code in (("a missing section is an error", SECTION_TEX, "fees", 2),
                                   ("an unclosed section fails", SECTION_TEX.replace("% end section: terms\n", ""), "terms", 1),
                                   ("a doubled marker fails", SECTION_TEX + "% section: terms\n", "terms", 1)):
        try:
            section_text(tex, slug)
            verdict("section mode: " + label, False, ["no error was raised"])
        except SectionError as err:
            verdict("section mode: " + label, err.code == code, [f"code {err.code}: {err}"])

    exe = shutil.which("pandoc")
    if exe and DEFAULT_FILTER.is_file():
        with tempfile.TemporaryDirectory() as tmp:
            def base_of(text):
                md = Path(tmp) / "unit.md"
                md.write_text(text, encoding="utf-8")
                proc = subprocess.run([exe, "-f", "markdown", "-t", "latex", "--wrap=preserve",
                                       "--top-level-division=chapter", "-M", "house-class=true",
                                       "-M", "house-book=true", f"--lua-filter={DEFAULT_FILTER}", str(md)],
                                      capture_output=True, text=True, encoding="utf-8")
                return proc.stdout, pandoc_plain(md, DEFAULT_FILTER, None, "pandoc")

            base, plain = base_of(SAMPLE_MD)
            edge, edge_plain = base_of(EDGE_MD)
            sec_md = Path(tmp) / "draft.md"
            sec_md.write_text(SECTION_MD, encoding="utf-8")
            sec_plain = pandoc_plain(sec_md, DEFAULT_FILTER, None, "pandoc")
            for label, tex, pl, md, ok in (
                    ("round trip: pandoc's own base passes", base, plain, SAMPLE_MD, True),
                    ("round trip: one changed word fails", base.replace("louder", "quieter"), plain, SAMPLE_MD, False),
                    ("round trip: autolinks, a caret, a tilde and a captioned table pass", edge, edge_plain, EDGE_MD, True),
                    ("round trip: a table caption moved after its rows fails",
                     re.sub(r"\\caption\{A table caption\.\}\\tabularnewline\n", "", edge, count=1)
                     .replace(r"\end{longtable}", "\\caption{A table caption.}\n\\end{longtable}"), edge_plain, EDGE_MD, False),
                    ("round trip: a business draft matches its hand conversion", section, sec_plain, SECTION_MD, True)):
                problems, _, _ = check(tex, pl, md)
                verdict(label, (not problems) == ok, problems)
    else:
        print("  skip round trip: pandoc or tooling/pandoc/house.lua not found")
    if failures:
        print(f"self-test FAILED: {len(failures)} case(s)")
        return 1
    print("self-test passed")
    return 0


def main(argv=None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog="Normally run as: make tex-check [UNIT=NN-kebab-title] (a book), or "
                                        "make section-check FILE=….tex SECTION=<slug> DRAFT=….md (business)")
    ap.add_argument("styled", nargs="?", help="the .tex: a styled chapter, or a business document")
    ap.add_argument("source", nargs="?", help="its Markdown: the chapter, or the section's promoted draft")
    ap.add_argument("--section", metavar="SLUG",
                    help="compare only the text between '%% section: SLUG' and '%% end section: SLUG'")
    ap.add_argument("--filter", help="the house Lua filter (default: tooling/pandoc/house.lua)")
    ap.add_argument("--defaults", help="Pandoc defaults, as the build uses (tooling/defaults.yaml)")
    ap.add_argument("--pandoc", default=os.environ.get("PANDOC", "pandoc"), help="the pandoc to run")
    ap.add_argument("--strict", action="store_true", help="fail on any warning")
    ap.add_argument("--quiet", action="store_true", help="print nothing when the words match")
    ap.add_argument("--self-test", action="store_true", help="prove the check still separates")
    args = ap.parse_args(argv)
    if args.self_test:
        return self_test()
    if not args.styled or not args.source:
        ap.print_usage(sys.stderr)
        print("error: name the .tex and its Markdown", file=sys.stderr)
        return 2
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
