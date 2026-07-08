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

For the full local-to-GitHub-to-homepage flow, run:

```powershell
.\scripts\publish-note.ps1 -Message "Update research note" -RenderPages 2
```

For a quick local check without publishing:

```powershell
.\scripts\publish-note.ps1 -LocalOnly -RenderPages 2
```

Put experiment code in `code/`, small datasets or dataset cards in `data/`, and outputs in `results/`.

If `typst` is not on your PATH on Windows after installation, open a new terminal or call the installed executable directly.

The template is intentionally editable: replace `paper/figures/stance-profiles.svg`
with a real chart, replace the example tables with CSV-derived results, and update
`paper/refs.bib` when you cite related work.

## Chinese Fonts

Chinese fonts are set near the top of `paper/main.typ`:

```typst
#let zh-serif = ("Noto Serif SC", "Noto Serif CJK SC", "STSong", "SimSun")
#let zh-sans = ("Noto Sans SC", "Noto Sans CJK SC", "Microsoft YaHei")
```

Use `zh-serif` for paper-like body text and `zh-sans` for headings. On GitHub
Actions, the workflow installs Noto CJK fonts so the PDF can render Chinese
without depending on Windows-only fonts.

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
