#set document(title: "Replace with Research Note Title", author: "Replace with Author")
#set page(margin: (x: 1in, y: 1in))
#set text(size: 11pt, lang: "en")
#set heading(numbering: "1.")

#align(center)[
  #text(17pt, weight: "bold")[Replace with Research Note Title]

  #v(0.6em)
  Replace with Author \
  Replace with Affiliation \
  #link("https://github.com/REPLACE_WITH_USERNAME/REPLACE_WITH_REPO")[Project repository]
]

#v(1em)

#block(inset: 1em, stroke: 0.6pt + gray, radius: 3pt)[
  #text(weight: "bold")[Abstract.] Replace this paragraph with 3-5 sentences: what you tested, how you tested it, what you found, and what remains uncertain.
]

= Background and Motivation

Explain why this small experiment is worth doing. Keep the tone honest: this is a research note, not a finished conference paper.

= Experiment Design

Describe:

- prompts or tasks,
- models and versions,
- scoring dimensions,
- any human or model-assisted judging,
- data release details.

= Results

Put the main observations here. Prefer concrete tables, examples, and failure cases over broad claims.

#figure(
  table(
    columns: 4,
    [Model], [Warmth], [Caution], [Sycophancy],
    [Model A], [0.62], [0.71], [0.34],
    [Model B], [0.48], [0.83], [0.21],
  ),
  caption: [Example result table. Replace with real outputs.]
)

= Limitations

List what this note does *not* prove. Mention sample size, prompt bias, model version drift, scoring subjectivity, and any missing baselines.

= Discussion

Explain what seems interesting enough for other people to critique or extend.

= References

Add references in `refs.bib` and cite them here when needed.

