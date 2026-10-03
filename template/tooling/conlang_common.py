#!/usr/bin/env python3
"""conlang_common.py: what lexicon.py, script.py and font.py share.

Not run directly. It holds the one copy of each rule the three scripts must agree on:
where the languages live and how a language is named on the command line; how a TOML file
is read (every string NFC-normalised, so a decomposed IPA symbol or headword typed on an IPA
keyboard or a Mac matches the precomposed one in the inventory); how build/ is created
(always with its .gitignore); the em grid a script's glyphs are drawn on; the shape every
glyph SVG must have; and, above all, the one deterministic assignment of Private Use Area
code points, so that the text `script.py transliterate --pua` prints is the text the font
`font.py build` makes can draw.

Code-point rule (ConScript Unicode Registry convention): a glyph's explicit `codepoint`
always wins; every glyph without one is given the next free code point after the highest
explicit one, in the order the glyphs appear in glyphs.toml, starting from U+E000 when no
glyph has an explicit one. Positional forms are never given code points; the font reaches
them through its contextual alternates.

Standard library only; Python 3.11+ (tomllib).
"""
from __future__ import annotations

import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
from pathlib import Path

if sys.version_info < (3, 11):
    sys.exit("error: the conlang tooling needs Python 3.11 or later (it reads TOML with tomllib)")
import tomllib  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_LANGUAGES = ROOT / "world" / "src" / "languages"
DEFAULT_CONCEPTS = ROOT / "tooling" / "data" / "core-concepts.toml"
DEFAULT_REGISTER = ROOT / "world" / "src" / "names-register.md"
PUA_START = 0xE000
PUA_RANGES = ((0xE000, 0xF8FF), (0xF0000, 0xFFFFD), (0x100000, 0x10FFFD))
POSITIONS = ("isolated", "initial", "medial", "final")
SCRIPT_TYPES = ("alphabet", "abjad", "abugida", "syllabary", "logographic", "featural")
DIRECTIONS = ("ltr", "rtl", "ttb")
MEDIUMS = ("stone", "wood", "clay", "palm-leaf", "parchment", "paper", "metal", "other")
TOOLS = ("chisel", "knife", "stylus", "reed-pen", "brush", "quill", "other")
SVG_NS = "http://www.w3.org/2000/svg"
DRAWING_TAGS = {"path", "rect", "circle", "ellipse", "line", "polyline", "polygon", "text",
                "image", "use"}


class Fatal(Exception):
    """A missing or unparseable file, or bad arguments (exit 2)."""


def shown(path: Path) -> str:
    """A path as a reader should see it: relative to the repository or the working folder."""
    for base in (ROOT, Path.cwd()):
        try:
            return str(Path(path).resolve().relative_to(base.resolve()))
        except ValueError:
            continue
    return str(path)


def nfc(value):
    """Every string in value (keys included, through lists and tables) in Unicode NFC.

    The one normalisation the tools share: 'ã' typed as a + U+0303 and 'ã' typed as U+00E3
    look identical, and must compare equal, wherever they come from (a TOML file, the
    names register, a Markdown file or the command line)."""
    if isinstance(value, str):
        return unicodedata.normalize("NFC", value)
    if isinstance(value, dict):
        return {nfc(k): nfc(v) for k, v in value.items()}
    if isinstance(value, list):
        return [nfc(v) for v in value]
    return value


def nfc_args(args, *keys):
    """Normalise the named text arguments of an argparse namespace, in place. Only text that
    is compared with the data (IPA, romanised words), never a path: a file name is left
    exactly as the file system spells it."""
    for key in keys:
        if isinstance(getattr(args, key, None), str):
            setattr(args, key, nfc(getattr(args, key)))
    return args


def load_toml(path: Path) -> dict:
    if not path.is_file():
        raise Fatal(f"{shown(path)} not found")
    try:
        with path.open("rb") as fh:
            return nfc(tomllib.load(fh))
    except tomllib.TOMLDecodeError as err:
        raise Fatal(f"{shown(path)}: {err}") from None


def read_text(path: Path) -> str:
    """A text file (Markdown, the names register) as UTF-8, NFC-normalised."""
    return nfc(Path(path).read_text(encoding="utf-8"))


def is_language(folder: Path) -> bool:
    return any((folder / name).is_file()
               for name in ("language.toml", "phonology.toml", "lexicon.toml"))


def language_dirs(languages: Path, need: str | None = None) -> list:
    """Every language folder under the languages folder, sorted by slug.

    need: a file every returned folder must have (e.g. 'script/glyphs.toml')."""
    if not languages.is_dir():
        return []
    found = [d for d in sorted(languages.iterdir()) if d.is_dir() and is_language(d)]
    if need:
        found = [d for d in found if (d / need).is_file()]
    return found


def resolve_language(arg: str, languages: Path, need: str | None = None) -> Path:
    """A language folder from a slug (a folder under the languages folder) or a path."""
    p = Path(arg)
    if p.is_dir() and is_language(p):
        folder = p
    elif (languages / arg).is_dir():
        folder = languages / arg
    else:
        found = ", ".join(d.name for d in language_dirs(languages, need)) or "none"
        raise Fatal(f"no language {arg!r} in {shown(languages)} (found: {found})")
    if need and not (folder / need).is_file():
        raise Fatal(f"{shown(folder / need)} not found")
    return folder


def ensure_parent(out: Path):
    """Create out's folder; a build/ folder created here gets its .gitignore ('*')."""
    out = Path(out)
    missing, parent = [], out.parent
    while not parent.exists():
        missing.append(parent)
        parent = parent.parent
    out.parent.mkdir(parents=True, exist_ok=True)
    for folder in missing:
        if folder.name == "build" and not (folder / ".gitignore").exists():
            (folder / ".gitignore").write_text("*\n", encoding="utf-8")


# ── Glyph tables, the em grid and code points ─────────────────────────────────────────────

def load_glyph_table(folder: Path):
    """(meta, glyphs) from <language>/script/glyphs.toml; glyphs keep their file order."""
    data = load_toml(folder / "script" / "glyphs.toml")
    meta = data.get("meta") or {}
    glyphs = data.get("glyph") or []
    if not isinstance(meta, dict):
        raise Fatal(f"{shown(folder / 'script' / 'glyphs.toml')}: [meta] must be a table")
    if not isinstance(glyphs, list):
        raise Fatal(f"{shown(folder / 'script' / 'glyphs.toml')}: glyphs must be [[glyph]] tables")
    return meta, [g for g in glyphs if isinstance(g, dict)]


def grid(meta: dict) -> dict:
    """The em grid from [meta], with the template's defaults (1000 / 800 / -200 / 600)."""
    def number(key, default):
        try:
            return int(meta.get(key, default))
        except (TypeError, ValueError):
            return default
    return {"units_per_em": number("units_per_em", 1000), "ascender": number("ascender", 800),
            "descender": number("descender", -200),
            "default_advance": number("default_advance", 600)}


def grid_problems(meta: dict) -> list:
    """Errors in the [meta] em grid, as strings."""
    problems, g = [], grid(meta)
    for key in ("units_per_em", "ascender", "descender", "default_advance"):
        if key in meta and not isinstance(meta[key], int):
            problems.append(f"[meta] {key} must be a whole number")
    if g["units_per_em"] <= 0:
        problems.append("[meta] units_per_em must be positive")
    if g["ascender"] - g["descender"] != g["units_per_em"]:
        problems.append(f"[meta] ascender ({g['ascender']}) minus descender ({g['descender']}) "
                        f"must equal units_per_em ({g['units_per_em']})")
    if g["default_advance"] <= 0:
        problems.append("[meta] default_advance must be positive")
    return problems


def advance(glyph: dict, meta: dict) -> int:
    """A glyph's advance width in font units (0 or absent = default_advance)."""
    try:
        value = int(glyph.get("advance", 0) or 0)
    except (TypeError, ValueError):
        value = 0
    return value if value > 0 else grid(meta)["default_advance"]


def parse_codepoint(text) -> int | None:
    """'U+E000', 'E000' or '0xE000' -> 0xE000; anything else -> None."""
    m = re.fullmatch(r"(?:U\+|0x)?([0-9A-Fa-f]{4,6})", str(text or "").strip())
    return int(m.group(1), 16) if m else None


def in_pua(cp: int) -> bool:
    return any(lo <= cp <= hi for lo, hi in PUA_RANGES)


def assign_codepoints(glyphs: list):
    """The one code-point assignment both script.py and font.py use.

    Returns (assigned, problems): assigned is a list of (glyph, codepoint, explicit) in file
    order, one per glyph with an id; problems lists malformed or duplicated pins."""
    problems, explicit, used = [], {}, {}
    for n, g in enumerate(glyphs, start=1):
        text = str(g.get("codepoint", "") or "").strip()
        if not text:
            continue
        cp = parse_codepoint(text)
        if cp is None:
            problems.append(f"glyph {n} {g.get('id', '')!r}: codepoint {text!r} is not of the "
                            f"form U+E000")
            continue
        if cp in used:
            problems.append(f"glyph {n} {g.get('id', '')!r}: codepoint U+{cp:04X} is already "
                            f"used by glyph {used[cp]}")
            continue
        used[cp] = n
        explicit[n] = cp
    nxt = max(explicit.values()) + 1 if explicit else PUA_START
    assigned = []
    for n, g in enumerate(glyphs, start=1):
        if not str(g.get("id", "") or "").strip():
            continue
        if n in explicit:
            assigned.append((g, explicit[n], True))
            continue
        while nxt in used:
            nxt += 1
        used[nxt] = n
        assigned.append((g, nxt, False))
        nxt += 1
    for g, cp, _ in assigned:
        if not in_pua(cp):
            problems.append(f"glyph {g.get('id')!r}: U+{cp:04X} is outside the Private Use Area")
    return assigned, problems


def codepoint_map(glyphs: list) -> dict:
    """{glyph id: code point} under the shared assignment."""
    assigned, _ = assign_codepoints(glyphs)
    return {str(g["id"]): cp for g, cp, _ in assigned}


# ── Glyph SVGs ────────────────────────────────────────────────────────────────────────────

def local(tag: str) -> str:
    return tag.split("}")[-1] if isinstance(tag, str) else ""


def view_box(root: ET.Element):
    vb = root.get("viewBox")
    if not vb:
        return None
    try:
        parts = [float(x) for x in re.split(r"[\s,]+", vb.strip())]
    except ValueError:
        return None
    return tuple(parts) if len(parts) == 4 and parts[2] > 0 and parts[3] > 0 else None


def read_svg(path: Path):
    """(root element, viewBox tuple or None); raises ValueError for unreadable SVG."""
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as err:
        raise ValueError(f"{shown(path)}: not readable SVG ({err})") from None
    if local(root.tag) != "svg":
        raise ValueError(f"{shown(path)}: the root element is not <svg>")
    return root, view_box(root)


def inherited(node: ET.Element, ancestors: list, attr: str):
    """An SVG presentation attribute, looking up through the ancestors (style= included)."""
    for el in [node] + ancestors[::-1]:
        style = dict(p.split(":", 1) for p in (el.get("style") or "").split(";") if ":" in p)
        style = {k.strip(): v.strip() for k, v in style.items()}
        if attr in style:
            return style[attr]
        if el.get(attr) is not None:
            return el.get(attr)
    return None


def svg_shape_problems(path: Path, meta: dict, adv: int):
    """(errors, warnings) for one glyph SVG against the house shape: one filled <path>,
    no strokes, transforms or CSS, viewBox '0 0 <advance> <units_per_em>'. Bounds (inside
    the em box) need the outline parsed, which `font.py check` does with fontTools.

    CSS is refused outright: the checks read only style= and presentation attributes, and
    the font builder ignores stylesheets, so a stroke set through a <style> class would pass
    here and then build as a solid filled shape."""
    errors, warnings = [], []
    try:
        root, vb = read_svg(path)
    except ValueError as err:
        return [str(err)], []
    g = grid(meta)
    if vb is None:
        errors.append(f"{shown(path)}: no viewBox; give the <svg> viewBox=\"0 0 {adv} "
                      f"{g['units_per_em']}\"")
    elif (vb[0], vb[1], vb[3]) != (0, 0, g["units_per_em"]):
        errors.append(f"{shown(path)}: viewBox is {' '.join(f'{x:g}' for x in vb)}; it must "
                      f"be 0 0 <advance> {g['units_per_em']} (the em grid in [meta])")
    elif vb[2] != adv:
        warnings.append(f"{shown(path)}: viewBox width {vb[2]:g} differs from the glyph's "
                        f"advance {adv}; the font uses the advance")
    paths, stack = [], []

    def walk(el, ancestors):
        for child in el:
            name = local(child.tag)
            if name in DRAWING_TAGS:
                paths.append((name, child, ancestors + [el]))
            if name == "style":
                errors.append(f"{shown(path)}: a <style> element; inline the fill on the <path> "
                              f"(fill=\"currentColor\"): no CSS classes or stylesheets")
            if child.get("class") is not None:
                errors.append(f"{shown(path)}: <{name}> has class={child.get('class')!r}; inline "
                              f"the fill: no CSS classes")
            if child.get("transform"):
                errors.append(f"{shown(path)}: <{name}> has a transform; bake it into the "
                              f"coordinates")
            walk(child, ancestors + [el])
    if root.get("class") is not None:
        errors.append(f"{shown(path)}: <svg> has class={root.get('class')!r}; inline the fill: "
                      f"no CSS classes")
    walk(root, stack)
    shapes = [p for p in paths if p[0] != "path"]
    for name, _, _ in shapes:
        errors.append(f"{shown(path)}: <{name}> is not allowed; draw every glyph as one <path>")
    real = [p for p in paths if p[0] == "path"]
    if len(real) != 1:
        errors.append(f"{shown(path)}: {len(real)} <path> elements; a glyph is exactly one "
                      f"filled <path> (several outlines go in one d attribute)")
    for _, el, ancestors in real:
        if not (el.get("d") or "").strip():
            errors.append(f"{shown(path)}: the <path> has no d attribute")
        fill = inherited(el, ancestors, "fill")
        if fill is not None and fill.strip().lower() == "none":
            errors.append(f"{shown(path)}: fill=\"none\": glyphs are filled outlines, never "
                          f"strokes (use fill=\"currentColor\")")
        stroke = inherited(el, ancestors, "stroke")
        if stroke is not None and stroke.strip().lower() not in ("none", ""):
            errors.append(f"{shown(path)}: stroke={stroke!r}: a font cannot carry strokes; "
                          f"draw the stroke's outline as a filled shape")
        rule = inherited(el, ancestors, "fill-rule")
        if rule and rule.strip().lower() == "evenodd":
            warnings.append(f"{shown(path)}: fill-rule evenodd; fonts fill by non-zero winding, "
                            f"so draw holes in the opposite direction to their outline")
    return errors, warnings
