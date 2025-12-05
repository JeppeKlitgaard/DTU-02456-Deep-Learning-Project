from pathlib import Path

MODULE_DIR = Path(__file__).resolve().parent  # project/typstscribe
PROJECT_DIR = MODULE_DIR.parent  # project
DATA_DIR = PROJECT_DIR / "data"  # project/data
LOGS_DIR = PROJECT_DIR / "logs"  # project/logs
CONFIGS_DIR = PROJECT_DIR / "configs"  # project/configs
MODELS_DIR = PROJECT_DIR / "models"  # project/models
TOKENS_DIR = PROJECT_DIR / "tokens"  # project/tokens
TOKENIZER_MODELS_DIR = MODELS_DIR / "tokenizers"  # project/models/tokenizers
