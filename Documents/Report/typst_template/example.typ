#import "template.typ": abstract, course, names, style

#show: style  // Use template
#set document(title: "Template for Projects in 02456")

#course("02456 Deep Learning, DTU Compute, Fall 2025")

#title()

#names((
  "Anders Andersen (S123456)",
  "Bent Bentsen (S123457)",
  "Christian Christensen (S123458)",
  "Ditte Dittesen (S123459)"
))

#abstract[
The abstract should appear at the top of the left-hand column of text, about 0.5 inch (12 mm) below the title area and no more than 3.125 inches (80 mm) in length. Leave a 0.5 inch (12 mm) space between the end of the abstract and the beginning of the main text. The abstract should contain about 100 to 150 words, and should be identical to the abstract text submitted electronically along with the paper cover sheet. All manuscripts must be in English, printed in black ink.
]

= Introduction <sec:intro>
These guidelines include complete descriptions of the fonts, spacing, and related information for producing your proceedings manuscripts.

= Formatting your paper <sec:format>
All printed material, including text, illustrations, and charts, must be kept within a print area of 7 inches (178 mm) wide by 9 inches (229 mm) high. Do not write or print anything outside the print area. The top margin must be 1 inch (25 mm), except for the title page, and the left margin must be 0.75 inch (19 mm). All \emph{text} must be in a two-column format. Columns are to be 3.39 inches (86 mm) wide, with a 0.24 inch (6 mm) space between them. Text must be fully justified.


= Page title section <sec:pagestyle>
The paper title (on the first page) should begin 1.38 inches (35 mm) from the top edge of the page, centered, completely capitalized, and in Times 14-point, boldface type. The authors' name(s) and affiliation(s) appear below the title in capital and lower case letters. Papers with multiple authors and affiliations may require two or more lines for this information.

= Type-style and fonts <sec:typestyle>
We strongly encourage you to use Times-Roman font. In addition, this will give the proceedings a more uniform look. Use a font that is no smaller than ten point type throughout the paper, including figure captions.

This is a minimum spacing; 2.75 lines/cm (7 lines/inch) will make the paper much more readable. Larger type sizes require correspondingly larger vertical spacing. Please do not double-space your paper. True-Type 1 fonts are preferred.

The first paragraph in each section should not be indented, but all the following paragraphs within the section should be indented as these paragraphs demonstrate.

= Major headings <sec:majhead>
Major headings, for example, "1. Introduction", should appear in all capital letters, bold face if possible, centered in the column, with one blank line before, and one blank line after. Use a period (".") after the heading number, not a colon.

== Subheadings <ssec:subhead>
Subheadings should appear in lower case (initial word capitalized) in boldface. They should start at the left margin on a separate line.

=== Sub-subheadings <sssec:subsubhead>
Sub-subheadings, as in this paragraph, are discouraged. However, if you must use them, they should appear in lower case (initial word capitalized) and start at the left margin on a separate line, with paragraph text beginning on the following line. They should be in italics.


= Printing your paper <sec:print>
If the last page of your paper is only partially filled, arrange the columns so that they are evenly balanced if possible, rather than having one long column.

#pagebreak()

= Illustrations, graphs, and photographs <sec:illust>
Illustrations must appear within the designated margins. They may span the two columns. If possible, position illustrations at the top of columns, rather than in the middle or at the bottom. Caption and number every illustration.

#figure(
  //image("some_image.png"),
  rect(height: 4cm, width: 97%),
  caption: [Example of placing a figure with experimental results.],
) <fig:res>
#colbreak()

= Footnotes <sec:foot>
Use footnotes sparingly (or not at all!) and place them at the bottom of the column on the page on which they are referenced. Use Times 9-point type, single-spaced. To help your readers, avoid using footnotes altogether and include necessary peripheral observations in the text (within parentheses, if you prefer, as in this sentence).

= References <sec:ref>
List and number all bibliographical references at the end of the paper. References may be numbered (either alphabetically or in order of appearance) or follow the author–year citation style . If you use a numeric style, cite references using square brackets, e.g., @C2. If you use an author–year style, cite using round brackets.

#bibliography("template.bib", title: none)

#pagebreak()

= Declaration of use of generative AI <nonumber>
This declaration *must* be filled out and included as the *final page* of the document. The questions apply to all parts of the work, including research, project writing, and coding.

- I/we have used generative AI tools: [yes / no]

If you answered _yes_, please complete the following sections.
List the generative AI tools you have used:

-

Describe how the tools were used:

- *What did you use the tool(s) for?*
- *At what stage(s) of the process did you use the tool(s)?*
- *How did you use or incorporate the generated output?*
