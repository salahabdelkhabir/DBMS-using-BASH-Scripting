#!/bin/bash

# ============================================================
# TABLE OPERATIONS - table_operations.sh
# Functions for creating, listing, and deleting tables
# ============================================================

# Create new table
create_table() {
    # Ask for table name
    local table_name=$(zenity --entry \
        --title="Create Table" \
        --text="Enter table name:" \
        --width=400 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$table_name" ]; then
        return
    fi

    # Check if table already exists
    if table_exists "$table_name"; then
        show_error "Table '$table_name' already exists!"
        return
    fi

    # Ask for number of columns
    local num_cols=$(zenity --entry \
        --title="Create Table" \
        --text="How many columns?" \
        --width=400 2>/dev/null)

    if [ $? -ne 0 ]; then
        return
    fi

    # Validate number
    if ! is_number "$num_cols" || [ "$num_cols" -le 0 ]; then
        show_error "Please enter a valid number!"
        return
    fi

    # Create table files
    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"
    
    > "$meta_file"
    > "$data_file"

    # Track if primary key is set
    local pk_set=0

    # Get information for each column
    for ((i=1; i<=num_cols; i++)); do
        # Ask for column name and type
        local col_info=$(zenity --forms \
            --title="Column $i of $num_cols" \
            --text="Define column $i:" \
            --add-entry="Column Name:" \
            --add-combo="Data Type:" \
            --combo-values="Int|String" \
            --width=400 2>/dev/null)

        # If user cancelled, delete table files and exit
        if [ $? -ne 0 ]; then
            rm -f "$meta_file" "$data_file"
            show_error "Table creation cancelled!"
            return
        fi

        # Extract column name and type
        local col_name=$(echo "$col_info" | cut -d'|' -f1)
        local col_type=$(echo "$col_info" | cut -d'|' -f2)

        # Validate column name
        if [ -z "$col_name" ]; then
            show_error "Column name cannot be empty!"
            ((i--))  # Repeat this column
            continue
        fi

        # Ask about primary key (only if not set yet)
        local is_pk="N"
        if [ $pk_set -eq 0 ]; then
            show_question "Is '$col_name' the Primary Key?"
            if [ $? -eq 0 ]; then
                is_pk="PK"
                pk_set=1
            fi
        fi

        # Save column metadata (format: name:type:pk_flag)
        echo "$col_name:$col_type:$is_pk" >> "$meta_file"
    done

    show_info "Table '$table_name' created with $num_cols columns!"
}

# List all tables in current database
list_tables() {
    local db_path="$DATABASES_DIR/$CURRENT_DB"
    
    # Get list of tables
    local table_list=$(get_table_list)
    
    # Check if there are any tables
    if [ -z "$table_list" ]; then
        show_info "No tables in database '$CURRENT_DB'!"
        return
    fi

    # Build output with table structure
    local output=""
    
    while IFS= read -r table; do
        output="$output\nTABLE: $table\n"
        output="$output----------------------------------------\n"
        
        # Read metadata and show columns
        local meta_file="$db_path/$table.meta"
        while IFS=':' read -r col_name col_type col_pk; do
            if [ "$col_pk" = "PK" ]; then
                output="$output  - $col_name ($col_type) [PRIMARY KEY]\n"
            else
                output="$output  - $col_name ($col_type)\n"
            fi
        done < "$meta_file"
        
        output="$output\n"
    done <<< "$table_list"

    # Display tables
    echo -e "$output" | zenity --text-info \
        --title="Tables in $CURRENT_DB" \
        --width=600 \
        --height=$WINDOW_HEIGHT 2>/dev/null
}

# Delete table
drop_table() {
    local db_path="$DATABASES_DIR/$CURRENT_DB"
    
    # Get list of tables
    local table_list=$(get_table_list)
    
    # Check if there are any tables
    if [ -z "$table_list" ]; then
        show_error "No tables found!"
        return
    fi

    # Show selection dialog
    local selected=$(echo "$table_list" | zenity --list \
        --title="Drop Table" \
        --text="Select table to delete:" \
        --column="Table Name" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null)

    # If table selected
    if [ $? -eq 0 ] && [ -n "$selected" ]; then
        # Ask for confirmation
        show_question "Delete table '$selected'?\n\nAll data will be lost!"
        
        # If confirmed, delete table
        if [ $? -eq 0 ]; then
            rm -f "$db_path/$selected.meta"
            rm -f "$db_path/$selected.data"
            show_info "Table '$selected' deleted!"
        fi
    fi
}