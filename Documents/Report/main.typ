#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#import "typst_template/template.typ": abstract, course, names, style

#show: codly-init.with() // Setup Codly
#show: style  // Use template

#show raw.where(block: true): set text(size: 0.9em) // More spacing for code blocks
#codly(inset: (top: 0.2em, bottom: 0.2em))

#set document(title: "Transcription of Mathematical Expressions into Typst Syntax using a Vision-Encoder-Decoder Architecture")

#course("02456 Deep Learning, DTU Compute, Fall 2025")

#title()

#names((
  "Jeppe Klitgaard (S250250)",
))

#abstract[
The abstract should appear at the top of the left-hand column of text, about 0.5 inch (12 mm) below the title area and no more than 3.125 inches (80 mm) in length. Leave a 0.5 inch (12 mm) space between the end of the abstract and the beginning of the main text. The abstract should contain about 100 to 150 words, and should be identical to the abstract text submitted electronically along with the paper cover sheet. All manuscripts must be in English, printed in black ink.
]

= Introduction <sec:intro>
This report describes the motivation and implementation of a deep learning model for transcription of mathematical expressions from images into the Typst markup language
These guidelines include complete descriptions of the fonts, spacing, and related information for producing your proceedings manuscripts.

= The Typst Language <sec:typst>

The Typst~@typst markup language is a modern alternative to established typesetting systems such as TeX/LaTeX as well as document processors such as Microsoft Word and Google Docs. It places a strong emphasis on usability and performance while maintaining the highest standards of typographic quality. Additionally, Typst offers modern features such as online collaboration, accessibility support, native scripting, and extensibility through packages.

#let typst_sample = read("typst_sample.typ")
#let typst_render = [
  #set text(size: 8pt)
  #eval(typst_sample)
]

#let latex_sample = read("latex_sample.tex")
#let latex_render = context image("latex_sample.svg", height: measure(typst_render).height, width: measure(typst_render).width)

As an example of a mathematical expression typeset in Typst, consider @fig:typst_sample:
#figure(
  raw(typst_sample, lang: "Typst", block: true),
  caption: [Mathematical expression typeset in Typst.],
) <fig:typst_sample>

With the LaTeX equivalent seen in @fig:latex_sample:
#figure(
  raw(latex_sample, lang: "LaTeX", block: true),
  caption: [Mathematical expression typeset in LaTeX.],
) <fig:latex_sample>

#figure(
  table(
    columns: (1fr, 1fr),
    align: center,
    table.header([*Typst*], [*LaTeX*]),
    typst_render, latex_render,
  ),
  caption: [Side-by-side comparison of the Typst and LaTeX renderings of @fig:typst_sample and @fig:latex_sample respectively.],
)

Notable differences between the two systems include the improved ergonomics of the Typst syntax as well as a features such as automatic fractions, delimiter sizing, and ligatures. Additionally, the Typst syntax in @fig:typst_sample
compiles as-is, whereas the LaTeX equivalent requires use of the `amsmath` package as well as additional boilerplate code as seen in @app:latexcode.

TODO: Maybe upright differential?

= Data <sec:data>

Due to the relative recency of the Typst language, there exists only very limited publicly available datasets, which are unlikely to be suitable or sufficient for training a deep learning transcription model. In light of this, we generate a dataset by leveraging the `tex2typ` program developed by Typst community member `ParaN3xus`~@tex2typ, which is capable of generating Typst expression from LaTeX input. With this, we are able to construct a dataset of Typst expressions and associated images by conversion of the data found in the `fusion-image-to-latex-datasets` dataset~@hoangDataset to produce a dataset of 3.3 million image-label pairs which is publically available at @jkDataset. In order to facilitate efficient random-access loading during training, the dataset is made available in the `WebDataset` format as opposed to the original RAR archival format.

= Vision-Encoder-Decoder Model <sec:model>

The model architecture used in this project is based on the TrOCR model developed by Microsoft~@trocr, which has been shown to work for both classic text recognition as well as transcription into markup @stanfordpaper, @latexocr, @pix2text with varying degrees of success.

We leverage a pre-trained model, `microsoft/trocr-small-stage1`~@trocr, whose architecture is depicted in @fig:trocr_architecture. It is comprised of a DeIT Vision Transformer~@deit which we tersely summarise as a model which encodes images into a sequence of embeddings by first resizing them into a $H×W = 384×384$ pixel image and subsequently splitting them into $P×P = 16×16$ patches, which are then flattened and linearly projected into the $D=384$-dimensional embedding space alongside positional embeddings which describe the patch positions in the full, resized image. This sequence of embeddings alongside a classification token `[CLS]` and a destillation token `[DIST]` is then passed through 12 layers of hidden size $D$ made up of a 6-head self-attention block and a fully-connected feed-forward network
wherein the embeddings are expanded onto a $4D=1536$-dimensional space prior to activation using a GELU activation function before being projected back down to the original $D$-dimensional space. Additionally, the model features residual connections and layer normalisations as described in @deit.

Rather than the classification heads used in the original DeIT model, we pass the embeddings from the vision encoder into a pretrained MiniLM Transformer described in @minilm, to which an encoder-decoder cross-attention mechanism enabling the retrieval of information from the image embeddings from queries through the decoder is added. This cross-attention mechanism is placed between the standard 8-head self-attention and the feed-forward network blocks that make up the 6 layers of the decoder. Lastly, the hidden states from the decoder are projected onto a vocabulary of size $V=4096$ over which probabilities are computed using a softmax function, which in turn enables the generation of output sequences using beam search. Generation of the vocabulary and tokenisation is described further in @sec:token.

#figure(
  image("assets/trocr_architecture.png"),
  caption: [
    The TrOCR model architecture showing the Vision Transformer encoder and Transformer decoder components. Figure adapted from @trocr under CC BY-NC-SA 4.0.
  ]
) <fig:trocr_architecture>

== Comparison with other architectures <ssec:arch_comp>
Alternative model architectures include a combination of Convolutional and Recurrent Neural Networks (CNN, RNN), which may be used in a similar encoder-decoder configuration as the TrOCR model described above, as proposed in @crnn. We theorise that such architectures are ill-suited for transcription into rigid markup languages such as Typst due to their limited ability to capture long-range dependencies required by the syntax structure of such languages. As a example, the opening and closing parenthesis of the `cases` element in @fig:typst_sample are not reflected readily in the visual representation of the expression. This may in part be mitigated through the addition of attention mechanisms or LSTM networks, the discussion of which is beyond the scope of this report.

= Tokenisation <sec:token>

The default vocabulary and associated tokenisation scheme used in the TrOCR architecture is based on the Byte-Pair Encoding (BPE) @bpe and SentencePiece @sentencepiece algorithms with a vocabulary size of $V=64044$. We propose that a significantly smaller vocabulary specifically tailored to the Typst language may yield efficiency and and performance benefits due to the constrained syntax of the language and the intended application of the model. To this end, we construct a custom BPE tokenizer with a vocabulary size of $V=4096$ using the `tokenizers` library by HuggingFace. Given the limited number of symbols in the Typst Language, the tokenizer is initialised with a base vocabulary consisting of the functions exposed in its math-mode syntax as documented on the website~@typstDocsMath as well as the `sym.txt` table of the Codex project~@typstCodex which contains ASCII mappings to a vast number of unicode symbols.

Additionally, we employ a pre-tokenisation step in which individual digits of a number are split into separate tokens in order to encourage the model to learn the appropropriate semantic structure rather than the memorisation of specific numbers.


#let typst_tokenizer_example = json("typst_tokenizer_example.json")
#let default_tokenizer_example = json("default_tokenizer_example.json")
#let tokenizer_example_max_len = calc.max(
  typst_tokenizer_example.len(),
  default_tokenizer_example.len(),
)

#let tokenize(text) = box(strong(raw(text)), fill: gray.transparentize(50%), inset: 2pt)
Lastly, the custom tokenizer is trained on the corpus of 3.3 million Typst expression found in the dataset described in @sec:data using a BPE training procedure with the target vocabulary size of $4096$. To visualise the difference in tokenisation between our custom Typst tokenizer and the default TrOCR tokenizer, we tokenize the expression `underbrace(f(theta), "obj")` using both tokenizers to produce:\
Ours: #typst_tokenizer_example.map(tokenize).join(" ")\
Default: #default_tokenizer_example.map(tokenize).join(" ")

Coincidentally, both methods produce sequence lengths of $13$. However, our tokenizer offers much higher semantic coherence despite a smaller vocabulary. By encoding Typst keywords as atomic tokens, we imbue the model with a stronger inductive bias and disambiguate the output. As an example of this, we note that the default tokenizer cleaves the `underbrace` function into 3 tokens: `under`, `b`, `race`, which may lead the model to generate invalid syntax in situations of uncertainty. Similarly, the smaller vocabulary size reflects the much smaller active corpus of the Typst language compared to general natural language text, introducing further structural consistency and lessens the training required.

TODO Available on HuggingFace

= Model Training



TODO: Split training, frozen encoder, yada yada
TODO: Loss

= Evaluation Metrics

In order to evaluate the performance of the model, we employ the familiar Character Error Rate (CER) in addition to two custom metrics, the first of which is the fraction of evaluated predictions that successfully compile using the Typst compiler. Alone, this is a rather poor metric, but it offers observability into the training process.

Additionally, since both the label and prediction are sequences of Typst code, we may render both expressions and compare them using either a Structural Similarity Index Measure (SSIM) or Intersection-over-Union (IoU) metric. While the latter may generally be considered a difficult metric, it is well-suited here given its ability to express the _semantic_ similarity between Typst expressions, which will produce a score of unity for equivalent expressions. As such, it pairs well with CER, which captures the _syntactic_ similarity between the sequences.


pytypst...

= Model Performance

= Conclusion and Future Work

#pagebreak()
= References <sec:ref>
#bibliography("references.bib", title: none)

#pagebreak()
= Declaration of use of generative AI <nonumber>
This declaration *must* be filled out and included as the *final  page* of the document. The questions apply to all parts of the work, including research, project writing, and coding.

- I/we have used generative AI tools: [yes / no]

If you answered _yes_, please complete the following sections.
List the generative AI tools you have used:

-

Describe how the tools were used:

- *What did you use the tool(s) for?*
- *At what stage(s) of the process did you use the tool(s)?*
- *How did you use or incorporate the generated output?*

#pagebreak()

#counter(heading).update(0)
#set heading(numbering: "A.1.")
#set heading(supplement: "Appendix")
= Appendix

== Full LaTeX Sample Code <app:latexcode>

#raw(read("latex_sample_overleaf.tex"), lang: "LaTeX", block: true)

