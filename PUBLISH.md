# Publish Checklist

This project is meant for lightweight research notes: more formal than a blog post, less formal than a conference paper.

## One-time setup

1. Create a repository from this template.
2. In GitHub repository settings, enable **Discussions**.
3. In Zenodo, connect your GitHub account and enable this repository.
4. Confirm GitHub Actions are enabled.
5. Confirm the repository is public before releasing.

## Per-note workflow

1. Put code in `code/`, data notes or small data files in `data/`, and outputs in `results/`.
2. Edit `paper/main.typ`.
3. Edit `paper/refs.bib` if references are needed.
4. Edit `README.md` with the abstract and reproduction steps.
5. Edit `.zenodo.json` title, description, creators, and keywords.
6. Run the publish script:

```powershell
.\scripts\publish-note.ps1 -Message "Update research note" -RenderPages 2
```

The script compiles `paper/main.typ`, optionally renders selected pages for visual
checking, commits and pushes the template repository, waits for GitHub Actions,
copies the PDF into the homepage repository, pushes the homepage, waits for Pages,
and checks the public PDF URL.

7. Create a GitHub Release, for example `v0.1.0`, when you want a Zenodo DOI.
8. Wait for Zenodo to archive the release and create a DOI.
9. Post the GitHub repository link in a discussion community such as LessWrong, Reddit r/MachineLearning, or Hugging Face.

## Quick local preview

For small edits, do not publish every time. Compile locally and render only the
page you touched:

```powershell
.\scripts\publish-note.ps1 -LocalOnly -RenderPages 2
```

For continuous editing, use Typst watch:

```powershell
typst watch paper/main.typ paper/main.pdf
```

## Zenodo API draft

If you want to reserve a Zenodo DOI without using the GitHub repository toggle,
create a Zenodo personal access token with `deposit:write` and `deposit:actions`,
then set it only in your shell:

```powershell
$env:ZENODO_TOKEN="..."
.\scripts\zenodo-draft.ps1
```

This creates an unpublished Zenodo draft, uploads `paper/main.pdf` and a source
archive, and writes the draft id/URL/reserved DOI to `zenodo-draft.json`.

Publishing is intentionally separate:

```powershell
.\scripts\zenodo-draft.ps1 -Publish
```

Only publish when the metadata and files are ready. After publishing, files and
the persistent identifier cannot be modified in-place; use a new version instead.

## Notes

- Google Scholar indexing is not guaranteed. The homepage is only structured to make indexing easier.
- Zenodo is for preservation and DOI, not discussion.
- GitHub Discussions is the default discussion channel for feedback.
- Typst compiles the whole PDF, but it is usually fast. The expensive part is
  rendering and publishing, so the script lets you render only selected pages and
  skip publishing with `-LocalOnly`.
