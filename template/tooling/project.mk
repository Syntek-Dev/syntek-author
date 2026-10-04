# project.mk — build settings for <%PROJECT_NAME%>
#
# This project's own file: written once, when the project was generated, and never touched by
# `copier update`. The Makefile, which is the template's, reads it before anything else, so a
# setting that differs from one project to the next belongs here, never in the Makefile.
# A value given on the make command line still wins for that one run, for example:
#   make pdf FILE=… MAINFONT='An Installed Font'
#
# Make syntax: one `NAME = value` line per setting, with no quotes around the value. Inside a
# value write $ as $$ and # as \#, and never use a single quote; any other backslash is kept
# as written. An empty value keeps the default the comment above it names.
#
# Project-only targets may be added at the end of this file. `make help` lists each one that
# carries a `## description` after its colon, as the Makefile's own targets do.

# LOGO_DIRS: the folders TeX searches first for a logo or other image, ahead of the document's
# own folder and the rest of assets/, so the copy at the resolution you name is the one a
# document gets. Space-separated paths from the repository root, none containing a space; end
# one with // to search the folders beneath it too. Empty: no folder comes first.
# Example: LOGO_DIRS = assets/logos/print
LOGO_DIRS =

# FLAG_EXTRA_RE: this project's own marks for an open item, which `make flags` counts as one
# more kind beside AUTHOR TO CONFIRM and VERIFY (and STRICT=1 fails on). An extended regular
# expression, as grep -E reads it: \\ is one backslash, so \\fillme finds the LaTeX macro. A
# mark quoted in backticks, or inside a LaTeX % comment, is an example and is not counted.
# Empty: only the two flags are counted.<: if DOC_TYPE == 'business' :> Every pattern here also stops `make pdf ISSUE=1`.
# The default counts an unfilled field in both its forms: [AWAITING USER INPUT] in Markdown
# and \fillme, which prints it, in LaTeX.<: endif :>
# Example: FLAG_EXTRA_RE = \[AWAITING (USER INPUT|CONFIRMATION)\]|\\fillme
FLAG_EXTRA_RE =<: if DOC_TYPE == 'business' :> \[AWAITING USER INPUT\]|\\fillme<: endif :>

<: if DOC_TYPE == 'business' :># BRAND_DIRS: the folders holding the brand files (the brand guide, the brand voice and the
# disclaimers), which `make flags` reads besides each production layer's src/, because their
# open slots are flags until you complete them. Space-separated paths from the repository root,
# none containing a space. If the brand files live elsewhere (the 'Brand folder' row of
# .claude/rules/syntek-author/00-project.md ## Paths), name that folder here instead: the
# template's brand seeds in standards/brand/ come back on every update if deleted, and their
# open slots would otherwise be counted for ever. A file git ignores is never read, wherever
# it is. Empty: no brand folder is read.
# Example: BRAND_DIRS = docs/brand
BRAND_DIRS = standards/brand

<: endif :># MAINFONT, SANSFONT, MONOFONT: the typefaces of a PDF that Pandoc makes from Markdown
# (`make pdf`), each the name of a font installed on this machine, as fc-list prints it. A
# symbol the typeface lacks is drawn by tooling/latex/symbol-fallback.tex. Empty: Pandoc's
# default (Latin Modern).<: if DOC_TYPE != 'business' :> The printed book takes its typefaces from the class options
# recorded in typeset/src/page-design.md instead.<: endif :>
# Example: MAINFONT = TeX Gyre Pagella
MAINFONT =
SANSFONT =
MONOFONT =
<: if DOC_TYPE == 'business' :>
# DOCX_CONVERTER: the command `make docx FILE=….tex` runs, called as
# <command> input.tex output.docx. Set it only to a converter that keeps the house clause
# numbering and drafting notes. Empty: a .tex is refused a Word copy, because Pandoc's LaTeX
# reader loses both, and a lossy copy is worse than none.
DOCX_CONVERTER =

# ISSUE_STATUSES: the statuses at which `make pdf FILE=… ISSUE=1` may issue a document, read
# from the `% status:` line at the top of a .tex or the status key of a .md's frontmatter.
# Space-separated. Empty: final only.
ISSUE_STATUSES =
<: endif :>