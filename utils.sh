#!/bin/bash

# ============================================================
# UTILITY FUNCTIONS - utils.sh
# Helper functions used throughout the application
# UPDATED WITH VALIDATION
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
    
    find "$db_path" -name "*.meta" -type f 2>/dev/null | while read -r meta_file; do
        basename "$meta_file" .meta
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

# ============================================================
# NEW: Validate table metadata structure
# ============================================================
# Parameters: database_name (optional), table_name
# Returns: 0 if valid, 1 if invalid
validate_table_metadata() {
    local db_name="${1:-$CURRENT_DB}"
    local table_name="$2"
    
    # If only one parameter, assume it's table name
    if [ -z "$table_name" ]; then
        table_name="$db_name"
        db_name="$CURRENT_DB"
    fi
    
    local meta_file="$DATABASES_DIR/$db_name/$table_name.meta"
    
    # Check if metadata file exists
    if [ ! -f "$meta_file" ]; then
        return 1
    fi
    
    # Check if metadata file is empty
    if [ ! -s "$meta_file" ]; then
        return 1
    fi
    
    # Check for empty column names (line starting with :)
    if grep -q "^:" "$meta_file"; then
        return 1
    fi
    
    # Check for proper format (must have colons)
    if ! grep -q ":" "$meta_file"; then
        return 1
    fi
    
    # Count primary keys
    local pk_count=$(grep -c ":PK" "$meta_file" 2>/dev/null)
    
    # Must have exactly one primary key
    if [ "$pk_count" -ne 1 ]; then
        return 1
    fi
    
    return 0
}

# ============================================================
# UPDATED: Check if table exists AND is valid
# ============================================================
# Parameter: table name
# Returns: 0 if exists and valid, 1 if not
table_exists() {
    local db_name=$1
    local table_name=$2
    
    # Check if files exist
    if [ ! -f "$DATABASES_DIR/$db_name/$table_name.meta" ]; then
        return 1
    fi
    if [ ! -f "$DATABASES_DIR/$db_name/$table_name.data" ]; then
        return 1
    fi
    
    # Validate table structure
    local meta_file="$DATABASES_DIR/$db_name/$table_name.meta"
    
    # Check if metadata file is empty
    if [ ! -s "$meta_file" ]; then
        return 1
    fi
    
    # Check for empty column names
    if grep -q "^:" "$meta_file"; then
        return 1
    fi
    
    # Check for proper format
    if ! grep -q ":" "$meta_file"; then
        return 1
    fi
    
    # Count primary keys - must be exactly 1
    local pk_count=$(grep -c ":PK" "$meta_file" 2>/dev/null)
    if [ "$pk_count" -ne 1 ]; then
        return 1
    fi
    
    return 0
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
