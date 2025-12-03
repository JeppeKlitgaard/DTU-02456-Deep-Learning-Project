from pathlib import Path

from typstscribe.const import PROJECT_DIR

HUANG_DATASET_REPO_ID = "hoang-quoc-trung/fusion-image-to-latex-datasets"

DATASET_DIR = PROJECT_DIR / "dataset"
TEMP_DIR = DATASET_DIR / "temp"
DATA_DIR = DATASET_DIR / "data"

RAW_METADATA_PARQUET_FILE_PATH = TEMP_DIR / "raw_metadata.parquet"
METADATA_PARQUET_FILE_PATH = DATA_DIR / "metadata.parquet"
TEMP_DIR_OUTSIDE_REPO = Path.home() / "temp" / "typst-image-dataset"
