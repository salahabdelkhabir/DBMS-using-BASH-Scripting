#!/bin/bash

# ============================================================
# DATABASE OPERATIONS - database_operations.sh
# Functions for creating, listing, and deleting databases
# ============================================================

# Create new database
create_database() {
    # Ask user for database name
    db_name=$(zenity --entry \
        --title="Create Database" \
        --text="Enter database name:" \
        --ok-label="Create" \
        --cancel-label="Cancel" \
        --width=400 2>/dev/null)

    # Capture exit status
    result=$?

    # If user cancelled, return silently
    if [ $result -ne 0 ]; then
        return
    fi

    # If name is empty (user clicked OK with empty field)
    if [ -z "$db_name" ]; then
        show_error "Database name cannot be empty!"
        return
    fi

    # Validate: database must not already exist
    if database_exists "$db_name"; then
        show_error "Database '$db_name' already exists!"
        return
    fi

    # Create database directory
    mkdir -p "$DATABASES_DIR/$db_name"
    
    # Show success message
    show_info "Database '$db_name' created successfully!"
}

# List all databases
list_databases() {
    # Get list of databases
    db_list=$(get_database_list)
    
    # Check if there are any databases
    if [ -z "$db_list" ]; then
        show_info "No databases found!"
        return
    fi

    # Format list with numbers
    formatted_list=$(echo "$db_list" | nl)
    
    # Display in text window
    echo "$formatted_list" | zenity --text-info \
        --title="Databases List" \
        --ok-label="Close" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null
}

# Connect to existing database
connect_database() {
    # Get list of databases
    db_list=$(get_database_list)
    
    # Check if there are any databases
    if [ -z "$db_list" ]; then
        show_error "No databases available!"
        return
    fi

    # Show selection dialog
    CURRENT_DB=$(echo "$db_list" | zenity --list \
        --title="Connect to Database" \
        --text="Select a database:" \
        --column="Database Name" \
        --ok-label="Connect" \
        --cancel-label="Cancel" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null)

    # Capture exit status
    result=$?

    # If user cancelled, return silently
    if [ $result -ne 0 ]; then
        return
    fi

    # If user selected a database, show database menu
    if [ -n "$CURRENT_DB" ]; then
        database_menu
    fi
}

# Delete database
drop_database() {
    # Get list of databases
    db_list=$(get_database_list)
    
    # Check if there are any databases
    if [ -z "$db_list" ]; then
        show_error "No databases found!"
        return
    fi

    # Show selection dialog
    db_name=$(echo "$db_list" | zenity --list \
        --title="Drop Database" \
        --text="Select database to delete:" \
        --column="Database Name" \
        --ok-label="Select" \
        --cancel-label="Cancel" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null)

    # Capture exit status
    result=$?

    # If user cancelled, return silently
    if [ $result -ne 0 ]; then
        return
    fi

    # If no database selected, return
    if [ -z "$db_name" ]; then
        return
    fi

    # Ask for confirmation
    show_question "Are you sure you want to delete '$db_name'?\n\nThis cannot be undone!"
    
    # If confirmed, delete database
    if [ $? -eq 0 ]; then
        rm -rf "$DATABASES_DIR/$db_name"
        show_info "Database '$db_name' deleted successfully!"
    fi
}
