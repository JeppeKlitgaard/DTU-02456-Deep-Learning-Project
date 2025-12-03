default:
    just --list

start-jupyter-screen:
    ./bin/start_jupyter_screen.sh

start-tensorboard:
    uv run tensorboard --bind_all --logdir logs/tensorboard/

train:
    uv run papermill notebooks/TrOCR_test3.ipynb training_test_`date +"%Y_%m_%d__%H_%M"`.ipynb

train4:
    uv run papermill notebooks/TrOCR_test4_fine_tune.ipynb training_test_`date +"%Y_%m_%d__%H_%M"`.ipynb
