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

The code used to generate this dataset can be found at here: https://github.com/JeppeKlitgaard/DTU-02456-Deep-Learning-Project (this is currently private but should be released after examination. If this is not the case prod me at `huggingface@jeppe.science`).

Note that the data follows the WebDataset convention, but notably does not follow it's suggestions when it comes to image file extensions (or file extensions in general) inside the archive. This is due to the way in which HuggingFace's `datasets` library implements
WebDatasets, which makes it difficult to rejoin the image columns without going through a needlessly expensive `map` call.

As a result, however, `datasets` is not able to automatically detect the feature types, instead we may define them explicitly:
```
features = Features(
    {
        "input_image": Image(),
        "latex": Value("string"),
        "typst": Value("string"),
        "typst_image": Image(),
        "metadata.json": {
            "image_type": ClassLabel(names=["handwritten", "printed"]),
            "image_extension": ClassLabel(names=["png", "jpg", "bmp", "dvi"]),
        }
    }
)
```

Note that `typst_image` is an image of the `typst` string that has been rendered using Typst 0.14 in the PNG format with 120.0 ppi using template and default fonts:
```typ
#set page(width: auto, height: auto, margin: 0pt)
$
{typst_code}
$
```

These are included such that a cost function (such as intersection-over-union) can be used in training by rendering the predicted Typst source and comparing it to the known good picture. If the Typst version and `ppi` setting is kept the same, any equivalent source code should produce exactly the same pixels.

[tex2typ]: https://github.com/ParaN3xus/tex2typ
[hoang-quoc-trung/fusion-image-to-latex-datasets]: https://huggingface.co/datasets/hoang-quoc-trung/fusion-image-to-latex-datasets
