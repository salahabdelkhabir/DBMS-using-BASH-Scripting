#!/bin/bash

# ============================================================
# MENU SYSTEM - menus.sh
# Main menu and database menu functions with improved UX
# ============================================================

# Main Menu - Entry point of the application
main_menu() {
    while true; do
        # Show menu options
        choice=$(zenity --list \
            --title="Bash DBMS - Main Menu" \
            --text="Choose an operation:" \
            --column="No" \
            --column="Operation" \
            --width=$WINDOW_WIDTH \
            --height=$WINDOW_HEIGHT \
            --ok-label="Select" \
            --cancel-label="Exit Application" \
            "1" "Create Database" \
            "2" "List Databases" \
            "3" "Connect to Database" \
            "4" "Drop Database" 2>/dev/null)

        # Capture the exit code
        result=$?

        # If zenity was cancelled (exit code 1) or closed (exit code -1)
        if [ $result -ne 0 ]; then
            exit 0
        fi

        # If choice is empty (user clicked Select without selecting)
        if [ -z "$choice" ]; then
            zenity --warning \
                --title="Warning" \
                --text="Please select an option from the list!" \
                --width=400
            continue
        fi

        # Execute selected operation
        case $choice in
            "1") create_database ;;
            "2") list_databases ;;
            "3") connect_database ;;
            "4") drop_database ;;
        esac
    done
}

# Database Menu - Shown after connecting to a database
database_menu() {
    while true; do
        # Show database operations menu
        choice=$(zenity --list \
            --title="Database: $CURRENT_DB" \
            --text="Connected to: <b>$CURRENT_DB</b>\nChoose an operation:" \
            --column="No" \
            --column="Operation" \
            --width=$WINDOW_WIDTH \
            --height=$WINDOW_HEIGHT \
            --ok-label="Select" \
            --cancel-label="Back to Main Menu" \
            "1" "Create Table" \
            "2" "List Tables" \
            "3" "Drop Table" \
            "4" "Insert Record" \
            "5" "Select Records" \
            "6" "Delete Record" \
            "7" "Update Record" 2>/dev/null)

        # Capture exit code
        result=$?

        # If user clicked Back or X button - return immediately
        if [ $result -ne 0 ]; then
            CURRENT_DB=""
            return
        fi

        # If choice is empty (user clicked Select without selecting)
        if [ -z "$choice" ]; then
            zenity --warning \
                --title="Warning" \
                --text="Please select an option from the list!" \
                --width=400
            continue
        fi

        # Execute selected operation
        case $choice in
            "1") create_table ;;
            "2") list_tables ;;
            "3") drop_table ;;
            "4") insert_record ;;
            "5") select_records ;;
            "6") delete_record ;;
            "7") update_record ;;
        esac
    done
}
