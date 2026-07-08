# Agent Brief: Start or Update a Research Note

This repository is a reusable template for lightweight research notes. Use it
for small AI experiments that should be more formal than a blog post but less
formal than a conference paper.

## What the user should provide

For a new project, ask the user for these inputs if they are not obvious from
the workspace:

1. Project title.
2. Short research idea or draft notes.
3. Source folder for code, data, figures, and results.
4. GitHub repository name.
5. Homepage PDF filename, for example `papers/my-note.pdf`.
6. Whether to publish now or only compile locally.

Do not ask for DOI at the start. Zenodo DOI comes after a GitHub Release.

## Files to edit

- `paper/main.typ`: main research note source.
- `paper/refs.bib`: references.
- `paper/figures/`: figures used by the note.
- `README.md`: public project summary and reproduction steps.
- `.zenodo.json`: Zenodo metadata before creating a release.
- `CITATION.cff`: citation metadata.
- `data/`, `code/`, `results/`: project artifacts.

## Local preview

For quick edits, do not publish. Compile and render only the page that changed:

```powershell
.\scripts\publish-note.ps1 -LocalOnly -RenderPages 2
```

Use `-RenderAll` only when layout changes affect many pages.

## Full publish

After the note looks correct locally:

```powershell
.\scripts\publish-note.ps1 -Message "Update research note" -RenderPages 2
```

The script will:

1. Compile `paper/main.typ` to `paper/main.pdf`.
2. Optionally render selected PDF pages to PNG under `.workbuddy/publish-render`.
3. Commit and push this repository.
4. Wait for GitHub Actions to verify the PDF build.
5. Copy the PDF into the homepage repository.
6. Commit and push the homepage repository.
7. Wait for GitHub Pages deployment.
8. Check the public PDF URL.

## Important workflow decision

GitHub Actions should validate the PDF build but should not commit generated PDF
files back to the repository. The PDF should be compiled locally and committed
with the source changes. This avoids bot commits and rebase noise.

## Typography notes

Chinese fonts are configured at the top of `paper/main.typ`:

```typst
#let zh-serif = ("Noto Serif SC", "Noto Serif CJK SC", "STSong", "SimSun")
#let zh-sans = ("Noto Sans SC", "Noto Sans CJK SC", "Microsoft YaHei")
```

Use `zh-serif` for paper-like body text and `zh-sans` for headings. If a user
wants a different Chinese style, update these two lines first.

## Formula caution

Avoid ambiguous Typst math such as:

```typst
1 / |P| sum_(p in P) s(m, p, d)
```

Write explicit fractions instead:

```typst
(sum_(p in P) s(m, p, d)) / abs(P)
```

Always render the page containing changed formulas before publishing.

## After GitHub Release

When the user wants a DOI:

1. Create a GitHub Release.
2. Confirm Zenodo archives the release.
3. Copy the Zenodo DOI into `README.md`, `CITATION.cff`, `.zenodo.json`, and the
   homepage publication record.
4. Re-run the publish script.

## Zenodo API draft

If the user provides a Zenodo personal access token, do not write it to any file.
Set it only in the current shell as `ZENODO_TOKEN`, then run:

```powershell
.\scripts\zenodo-draft.ps1
```

This creates an unpublished Zenodo draft, uploads `paper/main.pdf` plus a source
archive, and saves non-secret draft metadata to `zenodo-draft.json`. Use
`-Publish` only after explicit confirmation because published files and DOI
cannot be modified in-place.

Default policy:

- Ordinary edits should update GitHub and GitHub Pages only.
- Zenodo should be treated as a milestone archive, not as the working copy.
- It is acceptable to maintain an unpublished Zenodo draft with a reserved DOI
  while the work is still changing.
- Do not publish a Zenodo record unless the user explicitly says something like
  "正式发布", "publish to Zenodo", or "release v1".
- Once published, that version's files remain permanently available. Later work
  should continue in GitHub and become a new Zenodo version only at the next
  milestone.
