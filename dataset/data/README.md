---
license: apache-2.0
tags:
- math
- ocr
- typst
- latex
size_categories:
- 1M<n<10M
---

# Typst Image Dataset

This dataset was generated with a [fork](https://github.com/JeppeKlitgaard/tex2typ) of [tex2typ] and the [hoang-quoc-trung/fusion-image-to-latex-datasets] dataset, which itself is a compilation of LaTeX labels and images of equations.

The hoang-quoc-trung dataset is difficult to work with in that it has the image data stored in a large compressed RAR archive, which does not permit efficient random read access. Additionally, it appears to have a larger number of corrupted filenames inside the archive, which has been mended in this dataset.

This dataset instead opts to use a WebDataset for convenient and efficient storage of the image files and associated metadata.

The code used to generate this dataset can be found at here: https://github.com/JeppeKlitgaard/DTU-02456-Deep-Learning-Project (this is currently private but should be released after examination. If this is not the case prod me at `huggingface@jeppe.science`)

[tex2typ]: https://github.com/ParaN3xus/tex2typ
[hoang-quoc-trung/fusion-image-to-latex-datasets]: https://huggingface.co/datasets/hoang-quoc-trung/fusion-image-to-latex-datasets
