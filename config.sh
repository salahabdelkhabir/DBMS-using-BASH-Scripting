#!/bin/bash

# ============================================================
# UTILITY FUNCTIONS - utils.sh
# Helper functions used throughout the application
# ============================================================

# Check if Zenity is installed
check_zenity() {
    if ! command -v zenity &> /dev/null; then
        echo "ERROR: Zenity is not installed"
        echo "Please install it: sudo apt-get install zenity"
        exit 1
    fi
}

# Show error message to user
show_error() {
    zenity --error \
        --title="Error" \
        --text="$1" \
        --width=400
}

# Show success message to user
show_info() {
    zenity --info \
        --title="Success" \
        --text="$1" \
        --width=400
}

# Ask yes/no question
# Returns 0 if yes, 1 if no
show_question() {
    zenity --question \
        --title="Confirm" \
        --text="$1" \
        --width=400
    return $?
}

# Check if value is a number
# Returns 0 if number, 1 if not
is_number() {
    if [ "$1" -eq "$1" ] 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Get list of databases
# Returns: list of database names (one per line)
get_database_list() {
    ls -1 "$DATABASES_DIR" 2>/dev/null
}

# Get list of tables in current database
# Returns: list of table names (one per line)
get_table_list() {
    local db_path="$DATABASES_DIR/$CURRENT_DB"
    
    for meta_file in "$db_path"/*.meta 2>/dev/null; do
        if [ -f "$meta_file" ]; then
            basename "$meta_file" .meta
        fi
    done
}

# Check if database exists
# Parameter: database name
# Returns: 0 if exists, 1 if not
database_exists() {
    if [ -d "$DATABASES_DIR/$1" ]; then
        return 0
    else
        return 1
    fi
}

# Check if table exists in current database
# Parameter: table name
# Returns: 0 if exists, 1 if not
table_exists() {
    if [ -f "$DATABASES_DIR/$CURRENT_DB/$1.meta" ]; then
        return 0
    else
        return 1
    fi
}

# Get primary key column name from table metadata
# Parameter: table name
# Returns: primary key column name
get_primary_key_column() {
    local table_name="$1"
    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    
    grep ":PK" "$meta_file" | cut -d':' -f1
}

# Get primary key column type from table metadata
# Parameter: table name
# Returns: primary key column type (Int or String)
get_primary_key_type() {
    local table_name="$1"
    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    
    grep ":PK" "$meta_file" | cut -d':' -f2
}