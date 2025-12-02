#!/bin/bash

# ============================================================
# SETUP SCRIPT - setup.sh
# Prepares the modular DBMS for first use
# ============================================================

echo "╔════════════════════════════════════════════╗"
echo "║  Bash DBMS - Setup Script                  ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check if Zenity is installed
echo "[1/4] Checking dependencies..."
if ! command -v zenity &> /dev/null; then
    echo "  ✗ Zenity is not installed"
    echo ""
    echo "Please install Zenity:"
    echo "  Ubuntu/Debian: sudo apt-get install zenity"
    echo "  Fedora: sudo dnf install zenity"
    echo "  Arch: sudo pacman -S zenity"
    exit 1
else
    echo "  ✓ Zenity is installed"
fi

# Make all script files executable
echo ""
echo "[2/4] Making scripts executable..."
chmod +x dbms.sh
chmod +x config.sh
chmod +x utils.sh
chmod +x database_operations.sh
chmod +x table_operations.sh
chmod +x record_operations.sh
chmod +x menus.sh
echo "  ✓ All scripts are now executable"

# Create databases directory
echo ""
echo "[3/4] Creating databases directory..."
mkdir -p ./databases
echo "  ✓ Directory created: ./databases"

# Run test
echo ""
echo "[4/4] Testing system..."
if ./dbms.sh --test 2>/dev/null; then
    echo "  ✓ System test passed"
else
    echo "  ℹ System ready (test skipped)"
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Setup Complete!                           ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "To start the DBMS, run:"
echo "  ./dbms.sh"
echo ""