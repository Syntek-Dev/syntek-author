# Makefile — <%PROJECT_NAME%>
#
# The build entry point. Template-owned: `copier update` merges improvements into it, so
# keep project-only targets few and clearly commented. Run `make` (or `make help`) for
# every target with a one-line description.
#
<: if DOC_TYPE != 'business' -:>
# Pipeline: Markdown in <%CONTENT_LAYER%>/src/ → Pandoc (XeLaTeX) → build/*.pdf, .docx, .epub
# Print:    make tex → typeset/src/units/.base/ (Pandoc's words) → styled by hand with the house
#           class → make tex-check (the words still match) → make print → build/typeset/book.pdf
<: endif -:>
<: if DOC_TYPE == 'business' -:>
# Pipeline: one document at a time. FILE=*.tex → XeLaTeX (run twice so \ref resolves) →
#           build/*.pdf; FILE=*.md → Pandoc → build/*.pdf or build/*.docx
<: endif -:>
<: if INCLUDE_REFERENCES -:>
# References: tooling/references.db (SQLite master) → tooling/export_refs.py →
#             build/references.json (CSL-JSON) → Pandoc --citeproc + tooling/harvard.csl
<: endif -:>
# Compare:    standards/style/ledger/ (each section's record) → tooling/compare.py → Pandoc →
#             XeLaTeX → build/compare/<unit>.pdf, for the author and for disclosure, never issued
#
# Common use:
<: if DOC_TYPE != 'business' -:>
#   make pdf SCOPE=<%CONTENT_LAYER%>/src/01-example-chapter    # one unit, as a PDF proof
#   make book                                       # the whole work, .docx and .pdf
#   make tex SCOPE=<%CONTENT_LAYER%>/src/01-example-chapter    # its Pandoc base, for typesetting
#   make tex-check UNIT=01-example-chapter          # the styled chapter still has every word
#   make print                                      # the printed book, from typeset/src/book.tex
<: endif -:>
<: if DOC_TYPE == 'business' -:>
#   make pdf FILE=library/src/<family>/<file>.tex   # one document, as a PDF proof
#   make pdf FILE=… ISSUE=1                         # and a copy beside its source, for issue
#   make section-check FILE=….tex SECTION=<slug> DRAFT=<draft>.md   # a promoted section's words
<: endif -:>
#   make flags                                      # every open AUTHOR TO CONFIRM and VERIFY
#   make provenance                                 # the AI-disclosure table, per unit
#   make compare UNIT=<unit>                        # each section's original, AI edit and final
#
<: if DOC_TYPE != 'business' -:>
# What differs from one project to the next (logo folders, typefaces, extra open-item marks) is
# set in tooling/project.mk, the project's own file. No target here reads a file git ignores.
<: endif -:>
<: if DOC_TYPE == 'business' -:>
# What differs from one project to the next (logo folders, typefaces, extra open-item marks, the
# brand folders make flags reads, the Word converter, the statuses a document may be issued at)
# is set in tooling/project.mk, the project's own file. No target here reads a file git ignores.
<: endif :>
PY       := python3
BUILD    := build
DEFAULTS := tooling/defaults.yaml
CONTENT  := <%CONTENT_LAYER%>
STRICT   ?=

# ── Project settings ────────────────────────────────────────────────────────────────────
# tooling/project.mk is the project's own: written once, when the project was generated, and
# never touched by copier update. Each setting below is the default it can change; a value
# given on the command line wins over both. It may also hold project-only targets, which
# make help lists when they carry a ## description.
-include tooling/project.mk
LOGO_DIRS      ?=
FLAG_EXTRA_RE  ?=
MAINFONT       ?=
SANSFONT       ?=
MONOFONT       ?=
<: if DOC_TYPE == 'business' -:>
BRAND_DIRS     ?= standards/brand
DOCX_CONVERTER ?=
ISSUE_STATUSES ?= final
<: endif :>
# LOGO_DIRS go on TeX's search path ahead of everything else, so a logo is taken from the folder
# named there (the right resolution) before any other folder that holds a file of that name.
EMPTY          :=
SPACE          := $(EMPTY) $(EMPTY)
LOGO_TEXINPUTS  = $(subst $(SPACE),,$(addsuffix :,$(LOGO_DIRS)))

# Every PDF Pandoc makes: the project's typefaces (Pandoc's own when unset) and the symbol
# fallback, so a check mark, ballot box or box-drawing line the text font lacks is drawn by an
# installed font that has it instead of vanishing. MKTEXTFM=0 stops TeX trying to generate a
# bitmap font for a fallback font that is not installed.
PANDOC_FONTS = $(if $(strip $(MAINFONT)),-V 'mainfont=$(strip $(MAINFONT))') \
               $(if $(strip $(SANSFONT)),-V 'sansfont=$(strip $(SANSFONT))') \
               $(if $(strip $(MONOFONT)),-V 'monofont=$(strip $(MONOFONT))')
PANDOC_PDF   = $(PANDOC_FONTS) --include-in-header=tooling/latex/symbol-fallback.tex
TEX_ENV     := MKTEXTFM=0

# NOT_IGNORED filters a list of paths, one per line, to those git does not ignore, or that a
# negation pattern (!) re-includes; a tracked file is never ignored. Every scan here passes its
# file list through it, because ignored folders hold credentials and local-only material and
# flags and lint print the lines they match. Outside a git work tree the list passes unchanged.
# The paths go to git and come back separated by NUL, never quoted, so a name holding a quote
# or a backslash is still read: each answer is four fields (source, line, pattern, path), and a
# path is kept when no pattern matched it (an empty source) or the pattern is a negation.
NOT_IGNORED = | { if [ "$$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ]; then \
    sed '/^$$/d' | tr '\n' '\000' | git check-ignore -z --stdin --verbose --non-matching \
    | tr '\000' '\n' | awk 'NR % 4 == 1 { src = $$0 } NR % 4 == 3 { pat = $$0 } \
      NR % 4 == 0 && (src == "" || substr(pat, 1, 1) == "!") { print }'; \
    else cat; fi; }

# The house filter maps semantic Markdown (epigraphs, scene breaks, small capitals<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, words in
# a constructed language<: endif :>) to each output; every Pandoc run here passes through it.<: if DOC_TYPE != 'business' :> In a book, a
# horizontal rule is a scene break.<: endif :>
HOUSE_LUA    := tooling/pandoc/house.lua
PANDOC_HOUSE := --lua-filter=$(HOUSE_LUA)<: if DOC_TYPE != 'business' :> -M house-book=true<: endif :>

# SCOPE selects what a target reads. Its origin is captured before the default is applied,
# so `flags` and `lint` can tell "the author named a scope" from "use the default".
SCOPE_GIVEN := $(filter command line environment,$(origin SCOPE))
SCOPE ?= $(CONTENT)/src
SCOPE_PATH := $(patsubst %/,%,$(SCOPE))
# UNIT names one unit: the brief's filename without .md (03-the-ford), or a path that ends in it
# (manuscript/src/03-the-ford, planning/src/units/03-the-ford.md), read as its last part.
UNIT_NAME   = $(basename $(notdir $(patsubst %/,%,$(UNIT))))
<: if DOC_TYPE != 'business' :>
# SRC: the Markdown a build reads, sorted (numeric prefixes are the running order).
# Excluded: governance files (CONTEXT.md, CLAUDE.md), folder notes (README.md), anything
# under a drafts/ folder, so only promoted prose ever builds, and anything git ignores. An
# assembled file that already concatenates its siblings must live outside the folder it
# assembles, or a SCOPE build reads the same text twice; EXCLUDE='name.md other.md' drops
# further files by name if needed.
EXCLUDE ?=
FIND_MD = find $(1) -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md \
          $(foreach x,$(EXCLUDE),! -name '$(x)') ! -path '*/drafts/*' -print 2>/dev/null \
          $(NOT_IGNORED) | LC_ALL=C sort
SRC := $(shell $(call FIND_MD,$(SCOPE_PATH)))
OUT := $(BUILD)/$(subst /,__,$(patsubst %.md,%,$(SCOPE_PATH)))
# A recipe takes each path single-quoted (SH_QUOTE), so a name holding a quote, a backslash or
# a $ reaches Pandoc as written. Make itself splits a list at spaces: keep spaces out of names.
SH_QUOTE = $(foreach f,$(1),'$(subst ','\'',$(f))')
SRC_Q    = $(call SH_QUOTE,$(SRC))
<: endif :>
# Where lint and flags look when no SCOPE is given: every production layer's src/<: if DOC_TYPE == 'business' :>; flags
# also look in the brand folders, whose structures carry flags until the author completes them.
# BRAND_DIRS (tooling/project.mk) names them: standards/brand when project.mk does not set it,
# none when it is set empty. A folder that does not exist is skipped, and the files of one that
# does pass through NOT_IGNORED like every other, wherever it is<: endif :>.
# Without a SCOPE, flags also read the project brief and settings (.claude/CLAUDE.md and
# .claude/rules/syntek-author/00-project.md), whose open questions are flags like any other.
WORK_DIRS := $(wildcard */src)
FLAG_DIRS := $(WORK_DIRS)<: if DOC_TYPE == 'business' :> $(wildcard $(patsubst %/,%,$(BRAND_DIRS)))<: endif :>
LINT_IN    = $(or $(if $(SCOPE_GIVEN),$(SCOPE_PATH),$(WORK_DIRS)),.nothing-to-scan)
FLAGS_IN   = $(or $(if $(SCOPE_GIVEN),$(SCOPE_PATH),$(FLAG_DIRS)),.nothing-to-scan)
FLAG_FILES = $(if $(SCOPE_GIVEN),,$(wildcard .claude/CLAUDE.md .claude/rules/syntek-author/00-project.md))

# A flag is an HTML comment opening AUTHOR TO CONFIRM: or VERIFY: in Markdown, or a \dnote
# whose text opens the same way in LaTeX. A form quoted in backticks, or inside a LaTeX %
# comment, is an example, not a flag. FLAG_EXTRA_RE (tooling/project.mk) adds the project's
# own open-item marks, an extended regular expression counted as one more kind, read the same
# way<: if DOC_TYPE == 'business' :>; make pdf ISSUE=1 runs the same scans over the document it is asked to issue<: endif :>.
FLAG_RE := (^|[^`])(<!--[[:space:]]*|\\dnote\{)(AUTHOR TO CONFIRM|VERIFY):
FLAG_EXTRA_SCAN = scan '(^|[^`])($(strip $(FLAG_EXTRA_RE)))'

.DEFAULT_GOAL := help
.PHONY: help clean flags lint provenance compare docx pdf<: if DOC_TYPE != 'business' :> epub book tex tex-check print<: endif :><: if DOC_TYPE == 'business' :> section-check<: endif :><: if INCLUDE_REFERENCES :> init refs dump<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> lexicon derive coverage family glossary font script-sample<: endif :>

help: ## show every target with its description
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

# The rule that creates build/ also tells git to ignore everything in it, so no root
# .gitignore line is needed (and none can be forgotten).
$(BUILD)/.gitignore:
	@mkdir -p $(BUILD)
	@printf '*\n' > $@

<: if INCLUDE_REFERENCES -:>
# ── References ──────────────────────────────────────────────────────────────────────────
DB     := tooling/references.db
SCHEMA := tooling/schema.sql
DUMP   := tooling/references.dump.sql
REFS   := $(BUILD)/references.json

init: ## build tooling/references.db from schema.sql and every seed*.sql (never overwrites one)
	@if [ -f $(DB) ]; then echo "$(DB) already built; nothing to do (move it aside to rebuild it)"; exit 0; fi; \
	command -v sqlite3 >/dev/null || { echo "error: sqlite3 not found; install it, then run: make init"; exit 1; }; \
	echo "sqlite3 $(DB) < $(SCHEMA)"; sqlite3 $(DB) < $(SCHEMA) || exit 1; \
	for s in tooling/seed*.sql; do [ -f "$$s" ] && echo "applying $$s" && sqlite3 $(DB) < "$$s"; done; \
	echo "built $(DB); commit it, and run make dump after every change"

$(DB):
	@echo "error: $(DB) not found; run: make init"; exit 1

refs: | $(BUILD)/.gitignore $(DB) ## export the references to build/references.json (CSL-JSON)
	@$(PY) tooling/export_refs.py --db $(DB) --out $(REFS)
<: if DOC_TYPE == 'theology' :>	@printf "nocite: '@%s'\n" '<%BIBLE_TRANSLATION%>' > $(BUILD)/nocite.yaml
<: endif :>	@[ ! -f $(DUMP) ] || [ ! $(DB) -nt $(DUMP) ] || echo "note: $(DB) has changed since the last make dump"

dump: | $(DB) ## snapshot the database to tooling/references.dump.sql (text, diffable; commit it)
	@sqlite3 $(DB) .dump > $(DUMP)
	@echo "wrote $(DUMP); commit it alongside $(DB)"

<: endif -:>
<: if DOC_TYPE != 'business' -:>
# ── Proofs and the book ─────────────────────────────────────────────────────────────────
# Proofs are ungated: they build at any status and change nothing.
define need_src
@$(if $(strip $(SRC)),true,{ echo "error: no buildable .md files under $(SCOPE_PATH)"; exit 1; })
@echo "building from:"; printf '  %s\n' $(SRC_Q)
endef

docx: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to .docx, for editors and publishers
	$(need_src)
	pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(SRC_Q) -o $(OUT).docx
	@echo "wrote $(OUT).docx"

pdf: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to a .pdf proof (XeLaTeX)
	$(need_src)
	$(TEX_ENV) pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(PANDOC_PDF) --include-in-header=tooling/book.latex \
	  $(SRC_Q) -o $(OUT).pdf
	@echo "wrote $(OUT).pdf"

epub: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to .epub
	$(need_src)
	pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(SRC_Q) -o $(OUT).epub
	@echo "wrote $(OUT).epub"

book: ## build the whole work, .docx and .pdf
	@$(MAKE) --no-print-directory docx SCOPE=$(CONTENT)/src
	@$(MAKE) --no-print-directory pdf SCOPE=$(CONTENT)/src

# ── The printed book (typeset/) ──────────────────────────────────────────────────────────
# make tex writes Pandoc's own LaTeX for each chapter in SCOPE to typeset/src/units/.base/: the
# base, never hand-edited. It never touches the styled chapter beside it, which the typeset
# skill makes by copying a first base and adding house-class macros, and nothing else. When a
# base changes, the one it replaces is kept in build/typeset/ (the oldest unmerged one wins)
# and the git merge-file line that carries the styling onto the new words is printed.
# make tex-check proves a styled chapter carries exactly its Markdown's words; make print sets
# typeset/src/book.tex with XeLaTeX, twice, so the contents and cross-references resolve, then
# reports every character a font could not draw: XeLaTeX prints it as nothing.<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>
# Each script's font is built first, one language at a time; a font that fails to build is
# reported and the print goes on (make font is the strict check).<: endif :>
TYPESET  := typeset/src
UNITS    := $(TYPESET)/units
BASES    := $(UNITS)/.base
TEX_OPTS := --defaults=$(DEFAULTS) $(PANDOC_HOUSE) -M house-class=true \
            -M suppress-bibliography=true --top-level-division=chapter --wrap=preserve \
            --no-highlight -t latex
BOOK_MD   = $(shell $(call FIND_MD,$(CONTENT)/src))

tex: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## write the Pandoc base of each chapter in SCOPE to typeset/src/units/.base/
	$(need_src)
	@mkdir -p $(BASES) $(BUILD)/typeset
	@for f in $(SRC_Q); do \
	  u=$$(basename "$$f" .md); new=$(BUILD)/typeset/$$u.new-base.tex; base=$(BASES)/$$u.tex; \
	  old=$(BUILD)/typeset/$$u.old-base.tex; styled=$(UNITS)/$$u.tex; \
	  case "$$f" in */$$u/$$u.md) ;; *) echo "skip $$f: not a chapter file (NN-kebab-title/NN-kebab-title.md)"; continue ;; esac; \
	  pandoc $(TEX_OPTS) "$$f" -o "$$new" || exit 1; \
	  if [ ! -f "$$base" ]; then mv "$$new" "$$base"; echo "wrote $$base"; \
	  elif cmp -s "$$new" "$$base"; then rm -f "$$new"; echo "unchanged $$base"; \
	  else if [ -f "$$styled" ] && [ ! -f "$$old" ]; then cp "$$base" "$$old"; fi; mv "$$new" "$$base"; \
	    echo "updated $$base"; \
	    [ ! -f "$$styled" ] || echo "  next: git merge-file --diff3 -L styled -L old-base -L new-base $$styled $$old $$base"; \
	  fi; \
	  [ -f "$$styled" ] || echo "  not styled yet: cp $$base $$styled, then style the copy"; \
	done

tex-check: <: if INCLUDE_REFERENCES :>refs <: endif :>## prove each styled chapter carries exactly its Markdown's words (UNIT= narrows it)
	@units="$(if $(UNIT),$(UNIT_NAME))"; \
	[ -n "$$units" ] || units=$$(for f in $(UNITS)/*.tex; do [ ! -f "$$f" ] || printf '%s\n' "$$f"; done \
	  $(NOT_IGNORED) | sed 's|^.*/||; s|\.tex$$||'); \
	if [ -z "$$units" ]; then echo "tex-check: no styled chapters in $(UNITS)/ yet"; exit 0; fi; \
	status=0; \
	for u in $$units; do \
	  tex=$(UNITS)/$$u.tex; md=$(CONTENT)/src/$$u/$$u.md; \
	  if [ ! -f "$$tex" ]; then echo "error: $$tex not found (make tex, then style a copy of the base)"; status=2; continue; fi; \
	  if [ ! -f "$$md" ]; then echo "error: $$md not found, so $$tex has no source to check against"; status=2; continue; fi; \
	  $(PY) tooling/texcheck.py "$$tex" "$$md" --filter $(HOUSE_LUA) --defaults $(DEFAULTS) || \
	    { r=$$?; [ $$status -ge $$r ] || status=$$r; }; \
	done; \
	exit $$status

print: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## set typeset/src/book.tex with XeLaTeX, twice, into build/typeset/book.pdf
	@test -f $(TYPESET)/book.tex || { echo "error: $(TYPESET)/book.tex not found"; exit 1; }
	@command -v xelatex >/dev/null || { echo "error: xelatex not found; make print needs TeX Live with XeLaTeX"; exit 1; }
	@mkdir -p $(BUILD)/typeset
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>	@if [ -z "$(SCRIPT_DIRS)" ]; then true; \
	elif ! command -v uv >/dev/null; then \
	  echo "warning: uv not found, so no script font was built; native-script words print with a font from an earlier build, or in romanised italic"; \
	else for d in $(SCRIPT_DIRS); do s=$$(basename "$$d"); uv run tooling/font.py build "$$s" || \
	  echo "warning: no font for $$s (see above); its native-script words print with build/fonts/$$s.otf from an earlier build if it exists, otherwise in romanised italic"; \
	done; fi
<: endif :><: if INCLUDE_REFERENCES :>	@rm -f $(BUILD)/typeset/references.tex
	$(if $(BOOK_MD),@pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) -M house-class=true \
	  -M house-refs-only=true -t latex $(call SH_QUOTE,$(BOOK_MD)) -o $(BUILD)/typeset/references.tex)
	@[ ! -f $(BUILD)/typeset/references.tex ] || grep -q '[^[:space:]]' $(BUILD)/typeset/references.tex \
	  || rm -f $(BUILD)/typeset/references.tex
<: endif :>	@for pass in 1 2; do \
	  TEXINPUTS="$(LOGO_TEXINPUTS)$(TYPESET)/:tooling/latex/:" xelatex -interaction=nonstopmode -halt-on-error \
	    -output-directory=$(BUILD)/typeset $(TYPESET)/book.tex >/dev/null \
	  || { echo "error: xelatex failed on pass $$pass; see $(BUILD)/typeset/book.log"; \
	       grep -m1 -A2 '^!' $(BUILD)/typeset/book.log | sed 's/^/  /'; exit 1; }; \
	done
	@grep -E '^(Class housebook|LaTeX|Package fontspec) Warning' $(BUILD)/typeset/book.log | LC_ALL=C sort -u | sed 's/^/  /' || true
	@n=$$(grep -c '^Missing character' $(BUILD)/typeset/book.log || true); \
	if [ "$$n" -gt 0 ]; then \
	  echo "warning: $$n missing character(s): the font has no glyph, so each prints as nothing (first lines of $(BUILD)/typeset/book.log):"; \
	  grep '^Missing character' $(BUILD)/typeset/book.log | LC_ALL=C sort -u | head -n 5 | sed 's/^/  /'; \
	fi
	@echo "wrote $(BUILD)/typeset/book.pdf"

<: endif -:>
<: if DOC_TYPE == 'business' -:>
# ── Documents, one at a time ────────────────────────────────────────────────────────────
# FILE names the document. A .tex renders with XeLaTeX LATEX_PASSES times (two, so every
# \ref resolves; three for a contents page or a question map), finding logos in LOGO_DIRS
# first, then the house preamble in tooling/latex/ and anything else in assets/. The output's
# name is the path with each / turned into __ (and a leading dot into dot-, which TeX refuses).
FILE           ?=
LATEX_PASSES   ?= 2
FILE_STEM       = $(subst /,__,$(patsubst .%,dot-%,$(basename $(patsubst ./%,%,$(FILE)))))
TEXINPUTS_HOUSE = $(LOGO_TEXINPUTS)$(dir $(FILE)):tooling/latex//:assets//:
MD_REFS         = <: if INCLUDE_REFERENCES :>$(MAKE) --no-print-directory refs && <: endif :>

define need_file
@test -n "$(FILE)" || { echo "error: name the document: make $@ FILE=library/src/<family>/<file>.tex"; exit 1; }
@test -f "$(FILE)" || { echo "error: $(FILE) not found"; exit 1; }
endef

# ISSUE=1 also copies the PDF beside its source, where it is committed as the issued copy;
# otherwise it stays in build/. It issues only a document whose status is one of
# ISSUE_STATUSES (tooling/project.mk; final unless the project says otherwise) and that holds no
# open item (the scan make flags runs: AUTHOR TO CONFIRM, VERIFY and FLAG_EXTRA_RE, outside %
# comments), and it never replaces an issued copy: an issued document is a record, and a new
# issue is a new version under its own name. FORCE=1 replaces one on purpose, and overrides
# nothing else. All of it is checked before anything is built.
# ISSUE and FORCE are switches: 1, yes or true turns one on, and empty leaves it off. Any other
# value is refused, so ISSUE=0 can never issue and FORCE=0 can never replace.
ISSUE      ?=
FORCE      ?=
SWITCH      = $(if $(strip $($(1))),$(if $(and $(filter 1,$(words $($(1)))),$(filter 1 yes true,$($(1)))),on,bad))
ISSUE_ON    = $(filter on,$(call SWITCH,ISSUE))
FORCE_ON    = $(filter on,$(call SWITCH,FORCE))
ISSUE_OK    = $(or $(strip $(ISSUE_STATUSES)),final)
ISSUE_COPY  = $(basename $(FILE)).pdf

# A document's status: in a .tex, the `% status:` line of its leading block of % lines; in a
# .md, the top-level status key of its frontmatter (quotes and a trailing comment dropped).
define STATUS_AWK
{ sub(/\r$$/, "") }
FNR == 1 { tex = (FILENAME ~ /\.tex$$/); fm = 0 }
tex && !/^%/ { exit }
tex && /^%[[:space:]]*status:/ { v = $$0; sub(/^%[[:space:]]*status:[[:space:]]*/, "", v); sub(/[[:space:]]+$$/, "", v); print v; exit }
!tex && FNR == 1 { if ($$0 ~ /^---[[:space:]]*$$/) { fm = 1; next } else exit }
!tex && /^(---|\.\.\.)[[:space:]]*$$/ { exit }
!tex && /^status:/ { v = $$0; sub(/^status:[[:space:]]*/, "", v); sub(/[[:space:]]+#.*$$/, "", v); gsub(/["\047]/, "", v); sub(/[[:space:]]+$$/, "", v); print v; exit }
endef
export STATUS_AWK

define need_issuable
@case '$(call SWITCH,ISSUE)' in bad) echo "error: ISSUE takes 1, yes or true; leave it out to build the proof only"; exit 1 ;; esac
@case '$(call SWITCH,FORCE)' in bad) echo "error: FORCE takes 1, yes or true; leave it out to keep an issued copy"; exit 1 ;; esac
@if [ -n "$(ISSUE_ON)" ]; then \
  st=$$(awk "$$STATUS_AWK" "$(FILE)"); \
  case " $(ISSUE_OK) " in *" $$st "*) [ -n "$$st" ] ;; *) false ;; esac || { \
    echo "error: $(FILE) is at status '$${st:-none}', and ISSUE=1 issues only at: $(ISSUE_OK)"; \
    echo "       (ISSUE_STATUSES in tooling/project.mk). Without ISSUE=1 the proof still builds."; exit 1; }; \
  files="$(FILE)"; $(SCAN_FN) \
  open=$$( { scan '$(FLAG_RE)'; $(if $(strip $(FLAG_EXTRA_RE)),$(FLAG_EXTRA_SCAN);) } | LC_ALL=C sort -u); \
  if [ -n "$$open" ]; then \
    echo "error: $(FILE) holds $$(printf '%s\n' "$$open" | grep -c .) open item(s), and ISSUE=1 never issues a document with one:"; \
    printf '%s\n' "$$open" | sed 's/^/  /'; \
    echo "       clear the open items first (make flags SCOPE=$(FILE)). FORCE=1 does not override this."; exit 1; \
  fi; \
  if [ -e "$(ISSUE_COPY)" ] && [ -z "$(FORCE_ON)" ]; then \
    echo "error: $(ISSUE_COPY) is already issued, and ISSUE=1 never replaces an issued copy."; \
    echo "       Issue a new version under its own name, or add FORCE=1 to replace this one on purpose."; exit 1; \
  fi; \
fi
endef

pdf: | $(BUILD)/.gitignore ## render FILE=….tex (XeLaTeX, twice) or FILE=….md (Pandoc) to PDF; ISSUE=1 to issue
	$(need_file)
	$(need_issuable)
	@mkdir -p $(BUILD)/latex
	@case "$(FILE)" in \
	  *.tex) for pass in $$(seq $(LATEX_PASSES)); do \
	           $(TEX_ENV) TEXINPUTS="$(TEXINPUTS_HOUSE)" xelatex -interaction=nonstopmode -halt-on-error \
	             -output-directory=$(BUILD)/latex -jobname=$(FILE_STEM) "$(FILE)" >/dev/null \
	           || { echo "error: xelatex failed on pass $$pass; see $(BUILD)/latex/$(FILE_STEM).log"; exit 1; }; \
	         done; \
	         cp $(BUILD)/latex/$(FILE_STEM).pdf $(BUILD)/$(FILE_STEM).pdf ;; \
	  *.md)  $(MD_REFS)$(TEX_ENV) pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(PANDOC_PDF) "$(FILE)" \
	           -o $(BUILD)/$(FILE_STEM).pdf || exit 1 ;; \
	  *)     echo "error: FILE must be a .tex or .md document"; exit 1 ;; \
	esac
	@echo "wrote $(BUILD)/$(FILE_STEM).pdf"
	@if [ -n "$(ISSUE_ON)" ]; then \
	  if [ -e "$(ISSUE_COPY)" ]; then verb=replaced; else verb=issued; fi; \
	  cp $(BUILD)/$(FILE_STEM).pdf "$(ISSUE_COPY)" && echo "$$verb $(ISSUE_COPY) (commit it with its source)"; fi

docx: | $(BUILD)/.gitignore ## FILE=….md to .docx (Pandoc); a .tex needs DOCX_CONVERTER (no lossy conversion)
	$(need_file)
	@case "$(FILE)" in \
	  *.md)  $(MD_REFS)pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) "$(FILE)" -o $(BUILD)/$(FILE_STEM).docx || exit 1 ;; \
	  *.tex) if [ -z "$(DOCX_CONVERTER)" ]; then \
	           echo "error: no lossless LaTeX-to-Word converter is configured. Pandoc's LaTeX reader"; \
	           echo "       drops the house clause numbering and drafting notes, and a lossy .docx is"; \
	           echo "       worse than none. Send the PDF, or set DOCX_CONVERTER in tooling/project.mk"; \
	           echo "       (or run: make docx FILE=… DOCX_CONVERTER='<command>'); the command is called"; \
	           echo "       as: <command> input.tex output.docx"; exit 1; \
	         fi; \
	         $(DOCX_CONVERTER) "$(FILE)" $(BUILD)/$(FILE_STEM).docx || exit 1 ;; \
	  *)     echo "error: FILE must be a .md or .tex document"; exit 1 ;; \
	esac
	@echo "wrote $(BUILD)/$(FILE_STEM).docx"

# A section is converted into its .tex by hand, between `% section: <slug>` and
# `% end section: <slug>`, so promote-section proves the words before it writes the ledger:
# the text between the pair against the promoted Markdown draft (tooling/texcheck.py --section).
section-check: ## prove FILE=….tex carries a promoted section's exact words: SECTION=<slug> DRAFT=<draft>.md
	$(need_file)
	@case "$(FILE)" in *.tex) ;; *) echo "error: FILE must be the .tex document (a Markdown deliverable is not converted)"; exit 2 ;; esac
	@test -n "$(SECTION)" || { echo "error: name the section: make section-check FILE=$(FILE) SECTION=<slug> DRAFT=<draft>.md"; exit 2; }
	@test -f "$(DRAFT)" || { echo "error: name the section's promoted draft: DRAFT=library/src/<family>/drafts/<unit-slug>/<NN>-<slug>.md"; exit 2; }
	@$(MD_REFS)$(PY) tooling/texcheck.py "$(FILE)" "$(DRAFT)" --section "$(SECTION)" --filter $(HOUSE_LUA) --defaults $(DEFAULTS)

<: endif -:>
# ── Checks ──────────────────────────────────────────────────────────────────────────────
# Copies that are not the author's text are never checked: an ingested original's reading copy
# (<name>.reading.md) and a Drive copy saved beside a tracked file (<name>.drive-DD-MM-YYYY.<ext>).
NOT_COPIES := ! -name '*.reading.md' ! -name '*.drive-[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].*'

# What flags and lint read under $(1): Markdown and LaTeX, never a governance file, a folder
# note, a Pandoc base or a copy. Each target then drops what git ignores (NOT_IGNORED) and says
# how many files that left unread, so an ignored folder can never pass for a clean one.
SCAN_FIND   = find $(1) -type f \( -name '*.md' -o -name '*.tex' \) ! -name CONTEXT.md ! -name CLAUDE.md \
              ! -name README.md ! -path '*/.base/*' $(NOT_COPIES) -print 2>/dev/null
UNREAD_NOTE = unread=$$(( $$(printf '%s' "$$all" | grep -c . || true) - $$(printf '%s' "$$files" | grep -c . || true) )); \
              [ "$$unread" -eq 0 ] || echo "Not read: $$unread file(s) git ignores (ignored folders hold local-only material)";
# scan PATTERN: every line of the files read that matches, as file:line:text, never one in a
# LaTeX % comment.
SCAN_FN     = scan() { [ -z "$$files" ] || printf '%s\n' "$$files" | tr '\n' '\000' \
                | xargs -0 grep -nHE -e "$$1" 2>/dev/null | grep -vE '^[^:]+\.tex:[0-9]+:[[:space:]]*%' \
                | LC_ALL=C sort; };
REPORT_FN   = report() { n=$$(printf '%s' "$$2" | grep -c . || true); total=$$((total + n)); \
                echo "$$1: $$n"; [ -z "$$2" ] || printf '%s\n' "$$2" | sed 's/^/  /'; };

flags: ## list every open flag: AUTHOR TO CONFIRM, VERIFY and FLAG_EXTRA_RE (SCOPE= narrows it); final needs none
	@all=$$( { $(call SCAN_FIND,$(FLAGS_IN)); $(if $(FLAG_FILES),printf '%s\n' $(FLAG_FILES);) } | LC_ALL=C sort -u); \
	files=$$(printf '%s\n' "$$all" $(NOT_IGNORED)); \
	total=0; $(SCAN_FN) $(REPORT_FN) \
	hits=$$(scan '$(FLAG_RE)'); \
	for kind in 'AUTHOR TO CONFIRM' 'VERIFY'; do \
	  report "$$kind" "$$(printf '%s\n' "$$hits" | grep -E "(<!--[[:space:]]*|dnote\{)$$kind:" || true)"; \
	done; \
	$(if $(strip $(FLAG_EXTRA_RE)),report 'Other open items (FLAG_EXTRA_RE in tooling/project.mk)' \
	  "$$($(FLAG_EXTRA_SCAN))";) \
<: if INCLUDE_REFERENCES -:>
	if [ -z "$(SCOPE_GIVEN)" ] && [ -f tooling/seed-refs.sql ]; then \
	  rows=$$(grep -n '^-- VERIFY:' tooling/seed-refs.sql || true); \
	  n=$$(printf '%s' "$$rows" | grep -c . || true); \
	  echo "Incomplete seed reference rows: $$n"; \
	  [ -z "$$rows" ] || printf '%s\n' "$$rows" | sed 's|^|  tooling/seed-refs.sql:|'; \
	fi; \
<: endif -:>
	$(UNREAD_NOTE) \
	if [ -n "$(STRICT)" ] && [ "$$total" -gt 0 ]; then exit 1; fi

# lint: one sentence per line in src/ artefacts (reflow a paragraph only when you edit it,
# never the whole file) and en_US spellings<: if DOC_TYPE == 'business' :>; and no em dash in client-facing copy<: endif :>.
# A report, not a gate: STRICT=1 makes it fail on any finding.
EN_US := colors?|colored|coloring|colorful|favors?|favored|favorites?|favorable|honors?|honored|honorable|behaviors?|behavioral|labors?|labored|neighbors?|neighborhoods?|harbors?|humors?|flavors?|rumors?|centers?|centered|theaters?|fibers?|liters?|calibers?|defense|offense|pretense|catalogs?|grays?|traveled|traveling|travelers?|canceled|canceling|modeled|modeling|labeled|labeling|leveled|leveling|jewelry|aluminum|plow|cozy|skeptic|skeptical|skepticism|fulfill|fulfills|enroll|enrolls|installment

# lint reads every file through this awk program, which first leaves out what is not the
# author's prose, keeping line numbers: HTML comments (across lines), the metadata header, a
# seed's stub banner (its first quoted block, before any '## ' heading, naming a stub), and in
# a .tex file every command and environment name (\begin{itemize} is not a spelling). Then it
# prints 'two:', 'us:' or 'dash:' and file:line: for each finding. A list number is no sentence,
# and under a Sources or References heading each line is one reference, not one sentence.
define LINT_AWK
FNR == 1 { c = 0; h = 0; b = 0; bd = 0; r = 0; tex = (FILENAME ~ /\.tex$$/) }
{
  s = $$0; t = ""
  while (s != "") {
    if (c) { p = index(s, "-->"); if (p) { s = substr(s, p + 3); c = 0 } else s = "" }
    else { p = index(s, "<!--"); if (p) { t = t substr(s, 1, p - 1) " "; s = substr(s, p + 4); c = 1 } else { t = t s; s = "" } }
  }
  if ($$0 ~ /^## /) h = 1
  if ($$0 ~ /^#+ /) r = (tolower($$0) ~ /^#+ +(sources|references|bibliography|works cited|further reading)/)
  if (b && t !~ /^[[:space:]]*>/) b = 0
  if (!h && !bd && t ~ /^[[:space:]]*>.*stub/) { b = 1; bd = 1 }
  if (b || t ~ /^[[:space:]]*\*\*Last Updated\*\*/) next
  if (tex) { gsub(/\\(begin|end)[[:space:]]*\{[^}]*\}/, " ", t); gsub(/\\[[:alpha:]]+/, " ", t) }
  where = FILENAME ":" FNR ":"
  m = t; sub(/^[[:space:]]*[0-9]+[.)][[:space:]]/, " ", m)
  if (!r && t !~ /^[[:space:]]*([|#%]|---)/ && m ~ two) print "two:" where $$0
  n = split(tolower(t), w, /[^[:alpha:]]+/)
  for (i = 1; i <= n; i++)
    if (w[i] ~ us || (w[i] ~ ize && w[i] !~ /siz(e|es|ed|ing|er|ers)$$/)) print "us:" where w[i]
  if (dash && (dashin == "" || index(FILENAME, dashin) == 1) && t !~ /^[[:space:]]*[#%]/ \
      && (index(t, "—") || (tex && t ~ /(^|[^-])---([^-]|$$)/))) print "dash:" where $$0
}
endef
export LINT_AWK
LINT_TWO := [^[:space:].][.!?][\047’\042)]*[[:space:]]+[\047‘\042(]*[[:upper:]]
LINT_IZE := ^[[:alpha:]][[:alpha:]][[:alpha:]]+(iz|yz)(e|es|ed|ing|er|ers|ation|ations)$$

lint: ## report lines holding two sentences and en_US spellings<: if DOC_TYPE == 'business' :>, and em dashes<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, and dense conlang<: endif :> (SCOPE= narrows it)
	@all=$$($(call SCAN_FIND,$(LINT_IN)) | LC_ALL=C sort); \
	files=$$(printf '%s\n' "$$all" $(NOT_IGNORED)); \
	if [ -z "$$files" ]; then echo "lint: nothing to check under $(LINT_IN)"; $(UNREAD_NOTE) exit 0; fi; \
	total=0; $(REPORT_FN) \
	found=$$(printf '%s\n' "$$files" | tr '\n' '\000' | xargs -0 awk -v two='$(LINT_TWO)' -v us='^($(EN_US))$$' \
	  -v ize='$(LINT_IZE)' <: if DOC_TYPE == 'business' :>-v dash=1 -v dashin='$(if $(SCOPE_GIVEN),,$(CONTENT)/src/)' <: endif :>"$$LINT_AWK"); \
	report "Lines holding more than one sentence" "$$(printf '%s\n' "$$found" | sed -n 's/^two://p')"; \
	report "en_US spellings" "$$(printf '%s\n' "$$found" | sed -n 's/^us://p')"; \
<: if DOC_TYPE == 'business' -:>
	report "Em dashes in client-facing copy (must be none)" "$$(printf '%s\n' "$$found" | sed -n 's/^dash://p')"; \
<: endif -:>
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG -:>
	prose=$$(printf '%s\n' "$$files" | grep '^$(CONTENT)/src/.*\.md$$' || true); \
	dense=$$([ -z "$$prose" ] || printf '%s\n' "$$prose" | tr '\n' '\000' | xargs -0 env $(CONLANG) tooling/lexicon.py density \
	  | grep -E '^[^:]+:[0-9]+:' || true); \
	report "Paragraphs with more than three unglossed conlang words" "$$dense"; \
<: endif -:>
	$(UNREAD_NOTE) \
	if [ -n "$(STRICT)" ] && [ "$$total" -gt 0 ]; then exit 1; fi

# ── Provenance ──────────────────────────────────────────────────────────────────────────
provenance: ## print the per-unit AI-disclosure table from standards/style/ledger/ (UNIT= narrows it)
	@$(PY) tooling/provenance.py table $(if $(UNIT),--unit $(UNIT_NAME))

# make compare prints the ledger's record of how each section moved: every unit with entries,
# one PDF each; UNIT= one unit; SECTION=<slug> one section of it, which needs UNIT.
# tooling/compare.py writes a Pandoc document for each; Pandoc sets it through the house filter,
# tooling/compare.yaml read after the project's defaults and tooling/latex/compare.tex in its
# preamble; XeLaTeX runs twice and every character a font could not draw is reported. FORMAT=tex
# stops at the LaTeX; FORMAT counts only from the make command line, so one the shell happens to
# export changes nothing. A unit that fails is named and the rest are still written; make then
# fails. Working files stay in build/compare/<unit>/. Ungated, like a proof: the
# output prints draft states from the ledger, never a drafts/ file, and is never issued,
# committed or synced.
COMPARE        := $(BUILD)/compare
COMPARE_TO     := $(if $(filter command line,$(origin FORMAT)),$(FORMAT),pdf)
COMPARE_PANDOC  = --defaults=$(DEFAULTS) --defaults=tooling/compare.yaml $(PANDOC_HOUSE) $(PANDOC_PDF) \
                  --include-in-header=tooling/latex/compare.tex -f json -s -t latex

compare: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## each section's original, AI edit and final, from the ledger, to build/compare/<unit>.pdf (UNIT=, SECTION=, FORMAT=tex)
	@test -z "$(SECTION)" || test -n "$(UNIT)" || { echo "error: SECTION= needs its unit: make compare UNIT=<unit> SECTION=<slug>"; exit 2; }
	@case "$(COMPARE_TO)" in pdf|tex) ;; *) echo "error: FORMAT takes pdf, or tex for the LaTeX alone"; exit 2 ;; esac
	@units="$(if $(UNIT),$(UNIT_NAME))"; \
	[ -n "$$units" ] || units=$$($(PY) tooling/compare.py units) || exit $$?; \
	if [ -z "$$units" ]; then echo "No sections to compare yet."; exit 0; fi; \
	command -v pandoc >/dev/null || { echo "error: pandoc not found; make compare needs Pandoc"; exit 1; }; \
	[ "$(COMPARE_TO)" = tex ] || command -v xelatex >/dev/null || { \
	  echo "error: xelatex not found; make compare needs TeX Live with XeLaTeX (FORMAT=tex writes the LaTeX alone)"; exit 1; }; \
	status=0; \
	for u in $$units; do \
	  name=$$u$(if $(SECTION),--$(SECTION)); dir=$(COMPARE)/$$u; \
	  $(PY) tooling/compare.py ast --unit "$$u" $(if $(SECTION),--section '$(SECTION)') \
	    $(addprefix --pandoc-arg=,$(PANDOC_HOUSE)) -o "$$dir/$$name.json"; r=$$?; \
	  if [ $$r -gt 1 ]; then echo "error: $$u: no comparison written"; status=$$r; continue; fi; \
	  [ $$r -eq 0 ] || status=1; \
	  pandoc $(COMPARE_PANDOC) "$$dir/$$name.json" -o "$$dir/$$name.tex" \
	  || { echo "error: $$u: pandoc could not write the LaTeX"; status=2; continue; }; \
	  if [ "$(COMPARE_TO)" = tex ]; then echo "wrote $$dir/$$name.tex"; continue; fi; \
	  for pass in 1 2; do \
	    $(TEX_ENV) xelatex -interaction=nonstopmode -halt-on-error -output-directory="$$dir" "$$dir/$$name.tex" >/dev/null \
	    || { echo "error: $$u: xelatex failed on pass $$pass; see $$dir/$$name.log"; \
	         grep -m1 -A2 '^!' "$$dir/$$name.log" | sed 's/^/  /'; status=2; continue 2; }; \
	  done; \
	  n=$$(grep -c '^Missing character' "$$dir/$$name.log" || true); \
	  if [ "$$n" -gt 0 ]; then \
	    echo "warning: $$n missing character(s): the font has no glyph, so each prints as nothing (first lines of $$dir/$$name.log):"; \
	    grep '^Missing character' "$$dir/$$name.log" | LC_ALL=C sort -u | head -n 5 | sed 's/^/  /'; \
	    echo "  a typeface that has them, set as MAINFONT in tooling/project.mk, prints them"; \
	  fi; \
	  cp "$$dir/$$name.pdf" "$(COMPARE)/$$name.pdf" && echo "wrote $(COMPARE)/$$name.pdf"; \
	done; \
	exit $$status

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG -:>
# ── Constructed languages ───────────────────────────────────────────────────────────────
# LANG names a folder in world/src/languages/. LANG is also the locale variable every shell
# inherits, so only a LANG given on the make command line counts. Without one, the checks run on
# every language (derive on every daughter, font on every language with a script), and
# script-sample uses the only language with a script; with several, make asks which. A language
# folder git ignores is never found, as in the tooling (tooling/conlang_common.py).
LANGS       := world/src/languages
LANG_DIRS   := $(patsubst %/lexicon.toml,%,$(shell printf '%s\n' $(wildcard $(LANGS)/*/lexicon.toml) $(NOT_IGNORED)))
LANG_GIVEN  := $(filter command line,$(origin LANG))
LANG_ARG    := $(if $(LANG_GIVEN),$(LANG))
SCRIPT_DIRS := $(patsubst %/script/glyphs.toml,%,$(shell printf '%s\n' $(wildcard $(LANGS)/*/script/glyphs.toml) $(NOT_IGNORED)))
LANG_SLUG   := $(if $(LANG_GIVEN),$(LANG),$(if $(filter 1,$(words $(SCRIPT_DIRS))),$(notdir $(SCRIPT_DIRS)),$(if $(filter 1,$(words $(LANG_DIRS))),$(notdir $(LANG_DIRS)))))
CONLANG      = PYTHONUTF8=1 $(PY)

define need_lang
@test -n "$(LANG_SLUG)" || { echo "error: name the language: make $@ LANG=<slug> (found: $(or $(notdir $(LANG_DIRS)),none))"; exit 1; }
endef

lexicon: ## check every language's lexicon, and the names register against them (LANG=<slug> for one)
	$(CONLANG) tooling/lexicon.py check $(LANG_ARG)
	$(CONLANG) tooling/lexicon.py names $(LANG_ARG)

derive: ## re-derive each daughter language from its parent through its sound changes (LANG=<slug> for one)
	$(CONLANG) tooling/lexicon.py derive $(LANG_ARG)

coverage: ## list the core concepts and pronouns each language has no word for yet (LANG=<slug> for one)
	$(CONLANG) tooling/lexicon.py coverage $(LANG_ARG)

family: ## print every language family tree, with each branch's real-world models
	$(CONLANG) tooling/lexicon.py family

glossary: | $(BUILD)/.gitignore ## write build/glossary-<slug>.md (glossary and pronunciation guide) for each language
	$(CONLANG) tooling/lexicon.py glossary $(LANG_ARG) --out-dir $(BUILD)

font: | $(BUILD)/.gitignore ## build each script's font into build/fonts/<slug>.otf with uv run (LANG=<slug> for one)
	@command -v uv >/dev/null || { echo "error: uv not found; tooling/font.py runs with uv run, which fetches fontTools for that run only"; exit 1; }
	uv run tooling/font.py build $(LANG_ARG)

script-sample: | $(BUILD)/.gitignore ## render TEXT in the language's script to build/script-sample-<slug>.svg: LANG=<slug> TEXT="…"
	$(need_lang)
	@$(if $(TEXT),$(CONLANG) tooling/script.py transliterate $(LANG_SLUG) "$(TEXT)",true)
	$(CONLANG) tooling/script.py render $(LANG_SLUG) $(if $(TEXT),"$(TEXT)",--sample) --out $(BUILD)/script-sample-$(LANG_SLUG).svg

<: endif -:>
clean: ## remove build/ (never touches a source, the ledger or the reference database)
	rm -rf $(BUILD)
