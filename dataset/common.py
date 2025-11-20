from pathlib import Path

HUANG_DATASET_REPO_ID = "hoang-quoc-trung/fusion-image-to-latex-datasets"

_THIS_FILE = Path(__file__).resolve()
PROJECT_FOLDER = _THIS_FILE.parent.parent.resolve()
DATASET_FOLDER = PROJECT_FOLDER / "dataset"
TEMP_FOLDER =  DATASET_FOLDER/ "temp"
DATA_FOLDER = DATASET_FOLDER/ "data"

RAW_METADATA_PARQUET_FILE_PATH = TEMP_FOLDER / "raw_metadata.parquet"
METADATA_PARQUET_FILE_PATH = DATA_FOLDER / "metadata.parquet"
TEMP_FOLDER_OUTSIDE_REPO = Path.home() / "temp" / "typst-image-dataset"
