#!/bin/bash

# ============================================================
# CONFIGURATION - config.sh
# Global variables and system initialization
# ============================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Database storage directory
DATABASES_DIR="$SCRIPT_DIR/databases"

# Current database (empty initially)
CURRENT_DB=""

# Window size settings for zenity dialogs
WINDOW_WIDTH=500
WINDOW_HEIGHT=400
LIST_HEIGHT=300
TEXT_WIDTH=800
TEXT_HEIGHT=500

# Initialize the system
init_system() {
    # Create databases directory if it doesn't exist
    if [ ! -d "$DATABASES_DIR" ]; then
        mkdir -p "$DATABASES_DIR"
    fi
}
