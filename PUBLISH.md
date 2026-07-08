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
6. Push to GitHub.
7. Wait for the **Build Typst PDF** workflow to produce `paper/main.pdf`.
8. Create a GitHub Release, for example `v0.1.0`.
9. Wait for Zenodo to archive the release and create a DOI.
10. Copy the PDF into your GitHub Pages repository under `papers/`.
11. Add a record to the homepage repository's `data/publications.json`.
12. Run `python scripts/build_publications.py` in the homepage repository.
13. Push the homepage repository.
14. Post the GitHub repository link in a discussion community such as LessWrong, Reddit r/MachineLearning, or Hugging Face.

## Notes

- Google Scholar indexing is not guaranteed. The homepage is only structured to make indexing easier.
- Zenodo is for preservation and DOI, not discussion.
- GitHub Discussions is the default discussion channel for feedback.

