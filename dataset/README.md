# Typst Dataset

This directory contains code to generate the Typst dataset primarily from [huang_dataset] using [paranexus_typstyle] and [typsyle].

## Setup

To run `1_compile_metadata.ipynb` and thus generate `data/metadata.parquet` you must have the following installed:
- `node` (`sudo apt install nodejs`)
- `npm` (`sudo apt install npm`)
- `corepack` (`sudo npm install -g corepack`)

To install `tex2typ` enter `vendored/tex2typ` (which must be hydrated via `git submodule update --init --recursive`) and run `npm run build`

## Uploading to HF

```
hf upload --repo-type dataset JeppeKlitgaard/typst-image-dataset data/ .
```

[huang_dataset]: 
