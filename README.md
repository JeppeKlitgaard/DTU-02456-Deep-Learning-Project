# Typstscribe

A vision encoder-decoder model for transcription of typeset math into Typst math content.

## Project Structure

- `dataset/`
    - This does not contain the actual dataset used for training or inference, but rather the tooling required to generate the dataset, which is then uploaded to HuggingFace: https://huggingface.co/datasets/JeppeKlitgaard/typst-image-dataset
    - Notebooks should be run in ascending order of their numeric prefix. If the prefix is the same, they can be run in arbitrary order
    - The reasoning behind this split of the dataset generation and preprocessing away from the main part of the project was to produce a dataset that would be useful for others and guarantee reproducibility of the results by making the used dataset publicly available.
    - The full dataset is about 54 GB, but smaller subsets may be used. The dataset is available in the WebDataset format.
    - The dataset contains both handwritten and printed samples, but can easily be filtered.

