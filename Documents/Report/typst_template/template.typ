
// Style

/// Style a document by using this with a show rule
///
/// Usage:
/// ```
/// #show: style
/// ```
///
/// -> content
#let style(
  /// The document to style
  /// -> content
  doc
) = [
  #set page(
    columns: 2,
    paper: "us-letter",
    margin: (
      y: 25mm,
      x: 19mm,
    ),
    numbering: "1"
  )
  #set columns(gutter: 6mm)

  // Fonts
  #set text(font: "Times New Roman", size: 10pt)
  #set par(justify: true, first-line-indent: 2em, spacing: 0.8em, leading: 0.5em)
  #show raw: set text(font: "Courier New")

  // Headings
  #show heading: set text(size: 10pt, weight: "bold")
  #set heading(numbering: "1.1.1. ")
  #show heading.where(level: 1): set align(center)
  #show heading.where(level: 1): it => upper(it)
  #show heading.where(level: 2): set align(left)
  #show heading.where(level: 3): set text(style: "italic", weight: "regular")
  // Space around headings
  #show heading: set block(above: 1.5em, below: 1.5em)
  // Unnumbered headings, bit of a hack
  #show selector(<nonumber>): set heading(numbering: none)

  // Figure captions
  #show figure.where(kind: image): set figure(supplement: [Fig.])
  #show figure.where(kind: table): set figure(supplement: [Table])
  #show figure.caption: it => {
    text(it.supplement + " " + it.counter.display(it.numbering) + ". ", weight: "bold") + it.body
  }

  // Bibliography style
  #set bibliography(style: "ieee")

  // Title
  #show title: set text(size: 12pt, weight: "bold")
  #show title: it => {
    it = upper(it)
    it = v(15pt) + it + v(8pt)
    place(top + center, scope: "parent", float: true, it,)
  }

  #doc
]

// Utility functions

/// Formats an abstract section
///
/// ```example
/// #abstract[This is an abstract]
/// ```
///
/// -> content
#let abstract(
  /// The abstract body
  /// -> content
  body
) = [
  #show heading: set block(below: 1.0em)
  #heading[Abstract] <nonumber>
  #body
]

/// Formats course name at top left of first page
///
/// ```example
/// #course("02456 Deep Learning, DTU Compute, Fall 2025")
/// ```
///
/// -> content
#let course(
  /// The course name and time
  /// -> content
  c
) = {
  c = upper(c)
  c = text(size: 8pt, c)
  place(top + left, scope: "parent", float: true, c)
}

/// Formats the author names at the top of the page
///
/// ```example
/// #names((
///   "Anders Andersen (S123456)",
///   "Bent Bentsen (S123457)",
///   "Christian Christensen (S123458)",
///   "Ditte Dittesen (S123459)"
/// ))
/// ```
///
/// -> content
#let names(
  /// An array of author names including their student IDs
  /// -> array
  names
) = {
  let c = names
    .chunks(2)
    .map((chunk) => chunk.join(", "))
    .map((line) => line + "\n")
    .map(emph)
    .join()

  c = text(size: 12pt, c)
  c = c + v(20pt)

  place(top + center, scope: "parent", float: true, c)
}

