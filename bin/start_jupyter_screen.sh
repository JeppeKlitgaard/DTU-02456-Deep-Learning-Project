#!/bin/bash

# Get the directory where this script is located to ensure we find the .env file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
SESSION_NAME="typstscribe-jupyter"

# 1. Load .env file
if [ -f "$ENV_FILE" ]; then
    # Export variables from .env
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "❌ Error: .env file not found at $ENV_FILE"
    echo "   Please create it with content: JUPYTER_TOKEN=your_token"
    exit 1
fi

# 2. Check if Token is set
if [ -z "$JUPYTER_TOKEN" ]; then
    echo "❌ Error: JUPYTER_TOKEN is not set in .env file."
    exit 1
fi

# Set default port if not in .env
PORT="${PORT:-8888}"

# 3. Check if session exists
if screen -list | grep -q "\.$SESSION_NAME"; then
    echo "❌ Session '$SESSION_NAME' is already running."
    echo "   Attach with: screen -r $SESSION_NAME"
    echo ""
    echo "   Current Connection Info:"
    uv run jupyter server list
    exit 1
fi

# 4. Start Jupyter in detached screen
echo "🚀 Starting Jupyter Server via uv..."
# Pass the token explicitly using the variable loaded from .env
screen -dmS "$SESSION_NAME" bash -c "uv run jupyter lab --no-browser --ip=0.0.0.0 --port=$PORT --allow-root --ServerApp.token='$JUPYTER_TOKEN'"

# 5. Wait for server to boot
echo "⏳ Waiting for server to initialize..."
sleep 3

# 6. Get Local IP
IP_ADDR=$(hostname -I | awk '{print $1}')

# 7. Print Connection Info for VS Code
echo "--------------------------------------------------"
echo "✅ Jupyter Server is running!"
echo "   Screen Session: $SESSION_NAME"
echo "   Machine IP:     $IP_ADDR"
echo "   Port:           $PORT"
echo "--------------------------------------------------"
echo "👇 COPY THIS URL into VS Code:"
echo ""
echo "http://$IP_ADDR:$PORT/lab?token=$JUPYTER_TOKEN"
echo ""
echo "--------------------------------------------------"