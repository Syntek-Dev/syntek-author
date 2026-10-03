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

PY       := python3
BUILD    := build
DEFAULTS := tooling/defaults.yaml
CONTENT  := <%CONTENT_LAYER%>
STRICT   ?=

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

# SRC: the Markdown a build reads, sorted (numeric prefixes are the running order).
# Excluded: governance files (CONTEXT.md, CLAUDE.md), folder notes (README.md) and anything
# under a drafts/ folder, so only promoted prose ever builds. An assembled file that already
# concatenates its siblings must live outside the folder it assembles, or a SCOPE build reads
# the same text twice; EXCLUDE='name.md other.md' drops further files by name if needed.
EXCLUDE ?=
FIND_MD = find $(1) -name '*.md' ! -name CONTEXT.md ! -name CLAUDE.md ! -name README.md \
          $(foreach x,$(EXCLUDE),! -name '$(x)') ! -path '*/drafts/*' 2>/dev/null | LC_ALL=C sort
SRC := $(shell $(call FIND_MD,$(SCOPE_PATH)))
OUT := $(BUILD)/$(subst /,__,$(patsubst %.md,%,$(SCOPE_PATH)))

# Where lint and flags look when no SCOPE is given: every production layer's src/<: if DOC_TYPE == 'business' :>; flags
# also look in standards/brand/, whose structures carry flags until the author completes them<: endif :>.
# Without a SCOPE, flags also read the project brief, .claude/CLAUDE.md, whose open questions
# (a subtitle, the near-term goal) are flags like any other.
WORK_DIRS := $(wildcard */src)
FLAG_DIRS := $(WORK_DIRS)<: if DOC_TYPE == 'business' :> $(wildcard standards/brand)<: endif :>
LINT_IN    = $(or $(if $(SCOPE_GIVEN),$(SCOPE_PATH),$(WORK_DIRS)),.nothing-to-scan)
FLAGS_IN   = $(or $(if $(SCOPE_GIVEN),$(SCOPE_PATH),$(FLAG_DIRS)),.nothing-to-scan)
FLAG_FILES = $(if $(SCOPE_GIVEN),,$(wildcard .claude/CLAUDE.md))

# A flag is an HTML comment opening AUTHOR TO CONFIRM: or VERIFY: in Markdown, or a \dnote
# whose text opens the same way in LaTeX. A form quoted in backticks, or inside a LaTeX %
# comment, is an example, not a flag.
FLAG_RE := (^|[^`])(<!--[[:space:]]*|\\dnote\{)(AUTHOR TO CONFIRM|VERIFY):

.DEFAULT_GOAL := help
.PHONY: help clean flags lint provenance docx pdf<: if DOC_TYPE != 'business' :> epub book tex tex-check print<: endif :><: if DOC_TYPE == 'business' :> section-check<: endif :><: if INCLUDE_REFERENCES :> init refs dump<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> lexicon derive coverage family glossary font script-sample<: endif :>

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
@test -n "$(strip $(SRC))" || { echo "error: no buildable .md files under $(SCOPE_PATH)"; exit 1; }
@echo "building from:"; printf '  %s\n' $(SRC)
endef

docx: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to .docx, for editors and publishers
	$(need_src)
	pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(SRC) -o $(OUT).docx
	@echo "wrote $(OUT).docx"

pdf: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to a .pdf proof (XeLaTeX)
	$(need_src)
	pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) --include-in-header=tooling/book.latex $(SRC) -o $(OUT).pdf
	@echo "wrote $(OUT).pdf"

epub: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## build SCOPE to .epub
	$(need_src)
	pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) $(SRC) -o $(OUT).epub
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
UNIT_NAME = $(basename $(notdir $(patsubst %/,%,$(UNIT))))
BOOK_MD   = $(shell $(call FIND_MD,$(CONTENT)/src))

tex: <: if INCLUDE_REFERENCES :>refs <: endif :>| $(BUILD)/.gitignore ## write the Pandoc base of each chapter in SCOPE to typeset/src/units/.base/
	$(need_src)
	@mkdir -p $(BASES) $(BUILD)/typeset
	@for f in $(SRC); do \
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
	@units="$(if $(UNIT),$(UNIT_NAME),$(notdir $(basename $(wildcard $(UNITS)/*.tex))))"; \
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
	  -M house-refs-only=true -t latex $(BOOK_MD) -o $(BUILD)/typeset/references.tex)
	@[ ! -f $(BUILD)/typeset/references.tex ] || grep -q '[^[:space:]]' $(BUILD)/typeset/references.tex \
	  || rm -f $(BUILD)/typeset/references.tex
<: endif :>	@for pass in 1 2; do \
	  TEXINPUTS="$(TYPESET)/:tooling/latex/:" xelatex -interaction=nonstopmode -halt-on-error \
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
# \ref resolves; three for a contents page or a question map), finding the house preamble
# in tooling/latex/ and logos in assets/. ISSUE=1 also copies the PDF beside its source,
# where it is committed as the issued copy; otherwise it stays in build/.
FILE           ?=
ISSUE          ?=
LATEX_PASSES   ?= 2
DOCX_CONVERTER ?=
FILE_STEM       = $(subst /,__,$(basename $(FILE)))
TEXINPUTS_HOUSE = $(dir $(FILE)):tooling/latex//:assets//:
MD_REFS         = <: if INCLUDE_REFERENCES :>$(MAKE) --no-print-directory refs && <: endif :>

define need_file
@test -n "$(FILE)" || { echo "error: name the document: make $@ FILE=library/src/<family>/<file>.tex"; exit 1; }
@test -f "$(FILE)" || { echo "error: $(FILE) not found"; exit 1; }
endef

pdf: | $(BUILD)/.gitignore ## render FILE=….tex (XeLaTeX, twice) or FILE=….md (Pandoc) to PDF; ISSUE=1 to issue
	$(need_file)
	@mkdir -p $(BUILD)/latex
	@case "$(FILE)" in \
	  *.tex) for pass in $$(seq $(LATEX_PASSES)); do \
	           TEXINPUTS="$(TEXINPUTS_HOUSE)" xelatex -interaction=nonstopmode -halt-on-error \
	             -output-directory=$(BUILD)/latex -jobname=$(FILE_STEM) "$(FILE)" >/dev/null \
	           || { echo "error: xelatex failed on pass $$pass; see $(BUILD)/latex/$(FILE_STEM).log"; exit 1; }; \
	         done; \
	         cp $(BUILD)/latex/$(FILE_STEM).pdf $(BUILD)/$(FILE_STEM).pdf ;; \
	  *.md)  $(MD_REFS)pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) "$(FILE)" -o $(BUILD)/$(FILE_STEM).pdf || exit 1 ;; \
	  *)     echo "error: FILE must be a .tex or .md document"; exit 1 ;; \
	esac
	@echo "wrote $(BUILD)/$(FILE_STEM).pdf"
	@if [ -n "$(ISSUE)" ]; then cp $(BUILD)/$(FILE_STEM).pdf "$(basename $(FILE)).pdf" && \
	  echo "issued $(basename $(FILE)).pdf (commit it with its source)"; fi

docx: | $(BUILD)/.gitignore ## FILE=….md to .docx (Pandoc); a .tex needs DOCX_CONVERTER (no lossy conversion)
	$(need_file)
	@case "$(FILE)" in \
	  *.md)  $(MD_REFS)pandoc --defaults=$(DEFAULTS) $(PANDOC_HOUSE) "$(FILE)" -o $(BUILD)/$(FILE_STEM).docx || exit 1 ;; \
	  *.tex) if [ -z "$(DOCX_CONVERTER)" ]; then \
	           echo "error: no lossless LaTeX-to-Word converter is configured. Pandoc's LaTeX reader"; \
	           echo "       drops the house clause numbering and drafting notes, and a lossy .docx is"; \
	           echo "       worse than none. Send the PDF, or run: make docx FILE=… DOCX_CONVERTER='<command>'"; \
	           echo "       (the command is called as: <command> input.tex output.docx)"; exit 1; \
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

flags: ## list every AUTHOR TO CONFIRM and VERIFY flag (SCOPE= narrows it); final needs none
	@hits=$$( { find $(FLAGS_IN) -type f \( -name '*.md' -o -name '*.tex' \) ! -name CONTEXT.md \
	    ! -name CLAUDE.md ! -name README.md ! -path '*/.base/*' $(NOT_COPIES) -exec grep -nHE '$(FLAG_RE)' {} + 2>/dev/null; \
	    $(if $(FLAG_FILES),grep -nHE '$(FLAG_RE)' $(FLAG_FILES);) } \
	    | grep -vE '^[^:]+\.tex:[0-9]+:[[:space:]]*%' | LC_ALL=C sort); \
	total=0; \
	for kind in 'AUTHOR TO CONFIRM' 'VERIFY'; do \
	  found=$$(printf '%s\n' "$$hits" | grep -E "(<!--[[:space:]]*|dnote\{)$$kind:" || true); \
	  n=$$(printf '%s' "$$found" | grep -c . || true); total=$$((total + n)); \
	  echo "$$kind: $$n"; [ -z "$$found" ] || printf '%s\n' "$$found" | sed 's/^/  /'; \
	done; \
<: if INCLUDE_REFERENCES -:>
	if [ -z "$(SCOPE_GIVEN)" ] && [ -f tooling/seed-refs.sql ]; then \
	  rows=$$(grep -n '^-- VERIFY:' tooling/seed-refs.sql || true); \
	  n=$$(printf '%s' "$$rows" | grep -c . || true); \
	  echo "Incomplete seed reference rows: $$n"; \
	  [ -z "$$rows" ] || printf '%s\n' "$$rows" | sed 's|^|  tooling/seed-refs.sql:|'; \
	fi; \
<: endif -:>
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
	@files=$$(find $(LINT_IN) -type f \( -name '*.md' -o -name '*.tex' \) ! -name CONTEXT.md \
	    ! -name CLAUDE.md ! -name README.md ! -path '*/.base/*' $(NOT_COPIES) 2>/dev/null | LC_ALL=C sort); \
	if [ -z "$$files" ]; then echo "lint: nothing to check under $(LINT_IN)"; exit 0; fi; \
	total=0; \
	report() { n=$$(printf '%s' "$$2" | grep -c . || true); total=$$((total + n)); \
	  echo "$$1: $$n"; [ -z "$$2" ] || printf '%s\n' "$$2" | sed 's/^/  /'; }; \
	found=$$(awk -v two='$(LINT_TWO)' -v us='^($(EN_US))$$' -v ize='$(LINT_IZE)' \
	  <: if DOC_TYPE == 'business' :>-v dash=1 -v dashin='$(if $(SCOPE_GIVEN),,$(CONTENT)/src/)' <: endif :>"$$LINT_AWK" $$files); \
	report "Lines holding more than one sentence" "$$(printf '%s\n' "$$found" | sed -n 's/^two://p')"; \
	report "en_US spellings" "$$(printf '%s\n' "$$found" | sed -n 's/^us://p')"; \
<: if DOC_TYPE == 'business' -:>
	report "Em dashes in client-facing copy (must be none)" "$$(printf '%s\n' "$$found" | sed -n 's/^dash://p')"; \
<: endif -:>
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG -:>
	prose=$$(printf '%s\n' $$files | grep '^$(CONTENT)/src/.*\.md$$' || true); \
	dense=$$([ -z "$$prose" ] || $(CONLANG) tooling/lexicon.py density $$prose | grep -E '^[^:]+:[0-9]+:' || true); \
	report "Paragraphs with more than three unglossed conlang words" "$$dense"; \
<: endif -:>
	if [ -n "$(STRICT)" ] && [ "$$total" -gt 0 ]; then exit 1; fi

# ── Provenance ──────────────────────────────────────────────────────────────────────────
provenance: ## print the per-unit AI-disclosure table from standards/style/ledger/ (UNIT= narrows it)
	@$(PY) tooling/provenance.py table $(if $(UNIT),--unit $(UNIT))

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG -:>
# ── Constructed languages ───────────────────────────────────────────────────────────────
# LANG names a folder in world/src/languages/. LANG is also the locale variable every shell
# inherits, so only a LANG given on the make command line counts. Without one, the checks run on
# every language (derive on every daughter, font on every language with a script), and
# script-sample uses the only language with a script; with several, make asks which.
LANGS       := world/src/languages
LANG_DIRS   := $(patsubst %/lexicon.toml,%,$(wildcard $(LANGS)/*/lexicon.toml))
LANG_GIVEN  := $(filter command line,$(origin LANG))
LANG_ARG    := $(if $(LANG_GIVEN),$(LANG))
SCRIPT_DIRS := $(patsubst %/script/glyphs.toml,%,$(wildcard $(LANGS)/*/script/glyphs.toml))
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
