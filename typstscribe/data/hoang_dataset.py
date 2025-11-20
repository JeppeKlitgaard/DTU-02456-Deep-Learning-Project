from datasets import load_dataset
from huggingface_hub import hf_hub_download

from pathlib import Path

from typstscribe.const import DATA_DIR

DATASET_REPO_ID = "hoang-quoc-trung/fusion-image-to-latex-datasets"

def get_raw_hoang_dataset():
    dataset = load_dataset(DATASET_REPO_ID)
    return dataset


def ensure_hoang_dataset_downloaded():
    # Download images
    images_rar_path = Path(hf_hub_download(
        repo_id=DATASET_REPO_ID,
        filename="root.rar",
        repo_type="dataset"
    )).resolve()

    assert images_rar_path.exists(), f"Downloaded file not found: {images_rar_path}"

    # Ensure it has been decompressed
    dataset_dir = DATA_DIR / "hoang-dataset"
    is_decompressed = (dataset_dir / "am_fully_decompressed.txt").exists()

    if not is_decompressed:
        patool.extract_archive(images_rar_path, outdir=dataset_dir / "images")
