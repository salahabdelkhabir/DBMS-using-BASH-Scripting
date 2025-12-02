#!/bin/bash

# ============================================================
# MAIN SCRIPT - dbms.sh
# Simple Modular Bash DBMS
# ============================================================

# Get the directory where script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source (import) all module files
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/database_operations.sh"
source "$SCRIPT_DIR/table_operations.sh"
source "$SCRIPT_DIR/record_operations.sh"
source "$SCRIPT_DIR/menus.sh"

# ============================================================
# MAIN EXECUTION
# ============================================================

# Initialize system
init_system

# Check dependencies
check_zenity

# Start main menu
main_menu

# End of script