# Pandoc bases

`make tex` writes each chapter's Pandoc LaTeX here as `NN-kebab-title.tex`. Never edit a base:
it is the ancestor `git merge-file` uses to carry styling onto a chapter's new words. Commit it
with its styled file in `typeset/src/units/`.
