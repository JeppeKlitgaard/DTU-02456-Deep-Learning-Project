#set document(title: [02456 Deep Learning Synopsis])
#show link: set text(fill: blue)

#align(center, title())

*Project Title:* Mathematical Transcription Model for the Typst Markup Language

*Student:* Jeppe Klitgaard, `s250250@dtu.dk`\
*Superviser:* Jes Frellsen, `jefr@dtu.dk`

#line(length: 100%)

= Motivation
The area of transcription using deep learning techniques has developed significantly in recent years with both Large Language Models and smaller, specialised models offering fast and accurate transcription of rich text and complex mathematical notation into established markup languages such as Markdown and LaTeX, but support for smaller languages such as Typst remains poor.

We propose to implement an image-to-text transcription model for the mathematical typesetting syntax used within the rapidly evolving Typst language inspired by existing LaTeX-specific models such as TODO:REFS.

= Data

Training and Validation data will primarily be obtained from the `fusion-image-to-latex-datasets` TODO:REF dataset, in which the LaTeX labels will be translated to Typst by leveraging existing translation and formatting libraries TODO:REF (typstyle, mitex, typ2latex). Optionally, original Typst labels may be manually produced or secured from the Typst Discord channel and used for fine-tuning or validation of the model.

Additionally, the validity of generated Typst code may be trialed by using the Typst compiler. 

= Model

The exact model implementation is not yet known and is subject to change, but will be based around an image-to-text model and be based on an existing model of appropriate size which is subsequently fine-tuned on the data set. A prime candidate model to be investigated is Microsoft's TrOCR TODO:REF transformer model or the vision transformer model presented by Google Research in TODO:REF.


= Prior Art and Resources

- #link("https://github.com/NielsRogge/Transformers-Tutorials/tree/master/TrOCR", "Niels Rogge's Transformer Tutorials")
