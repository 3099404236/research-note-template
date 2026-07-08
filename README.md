# Research Note Template

This repository is a template for small, reproducible research notes. It uses the
[`preprintx`](https://typst.app/universe/package/preprintx/) Typst template, so
the PDF looks closer to a lightweight preprint than a plain blog post.

The example note includes:

- a two-column preprint-style layout,
- a title block, abstract, author affiliation, keywords, and correspondence,
- an actual figure slot with a replaceable SVG chart,
- equations for simple scoring definitions,
- wide multi-column result tables,
- qualitative example tables.

**PDF:** [`paper/main.pdf`](paper/main.pdf)  
**DOI:** _Add the Zenodo DOI badge after the first release_  
**Discussion:** _Enable GitHub Discussions, then link it here_

## Abstract

Replace this section with a short 3-5 sentence summary:

- what you tested,
- how you tested it,
- what you found,
- what the limitations are.

## Reproduce

```powershell
typst compile paper/main.typ paper/main.pdf
```

Put experiment code in `code/`, small datasets or dataset cards in `data/`, and outputs in `results/`.

If `typst` is not on your PATH on Windows after installation, open a new terminal or call the installed executable directly.

The template is intentionally editable: replace `paper/figures/stance-profiles.svg`
with a real chart, replace the example tables with CSV-derived results, and update
`paper/refs.bib` when you cite related work.

## Citation

Replace this section after Zenodo creates a DOI.

```bibtex
@misc{replace_with_key,
  title  = {Replace with Title},
  author = {Replace with Author},
  year   = {2026},
  doi    = {Replace with DOI},
  url    = {Replace with URL}
}
```
