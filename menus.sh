#!/bin/bash

# ============================================================
# MENU SYSTEM - menus.sh
# Main menu and database menu functions
# ============================================================

# Main Menu - Entry point of the application
main_menu() {
    while true; do
        # Show menu options
        local choice=$(zenity --list \
            --title="Bash DBMS - Main Menu" \
            --text="Choose an operation:" \
            --column="No" \
            --column="Operation" \
            --width=$WINDOW_WIDTH \
            --height=$WINDOW_HEIGHT \
            "1" "Create Database" \
            "2" "List Databases" \
            "3" "Connect to Database" \
            "4" "Drop Database" \
            "5" "Exit" 2>/dev/null)

        # Check if user clicked cancel or X button
        if [ $? -ne 0 ]; then
            show_question "Do you want to exit?"
            if [ $? -eq 0 ]; then
                exit 0
            fi
            continue
        fi

        # Execute selected operation
        case $choice in
            "1") create_database ;;
            "2") list_databases ;;
            "3") connect_database ;;
            "4") drop_database ;;
            "5") exit 0 ;;
        esac
    done
}

# Database Menu - Shown after connecting to a database
database_menu() {
    while true; do
        # Show database operations menu
        local choice=$(zenity --list \
            --title="Database: $CURRENT_DB" \
            --text="Choose an operation:" \
            --column="No" \
            --column="Operation" \
            --width=$WINDOW_WIDTH \
            --height=$WINDOW_HEIGHT \
            "1" "Create Table" \
            "2" "List Tables" \
            "3" "Drop Table" \
            "4" "Insert Record" \
            "5" "Select Records" \
            "6" "Delete Record" \
            "7" "Update Record" \
            "8" "Back to Main Menu" 2>/dev/null)

        # Check if user clicked cancel or X button
        if [ $? -ne 0 ]; then
            CURRENT_DB=""
            return
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
            "8") 
                CURRENT_DB=""
                return
                ;;
        esac
    done
}