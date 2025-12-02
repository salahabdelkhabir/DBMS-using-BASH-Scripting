#!/bin/bash

# ============================================================
# RECORD OPERATIONS - record_operations.sh
# Functions for inserting, selecting, updating, and deleting records
# ============================================================

# Select table helper function
# Returns selected table name or empty if cancelled
select_table() {
    local purpose="$1"  # e.g., "Insert", "Select", "Delete"
    
    local table_list=$(get_table_list)
    
    if [ -z "$table_list" ]; then
        show_error "No tables found!"
        return 1
    fi

    local table_name=$(echo "$table_list" | zenity --list \
        --title="$purpose Record" \
        --text="Select table:" \
        --column="Table Name" \
        --ok-label="Select" \
        --cancel-label="Cancel" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null)

    local exit_status=$?

    # If cancelled or no selection
    if [ $exit_status -ne 0 ] || [ -z "$table_name" ]; then
        return 1
    fi

    echo "$table_name"
    return 0
}

# Insert new record into table
insert_record() {
    # Select table
    local table_name=$(select_table "Insert")
    
    if [ $? -ne 0 ]; then
        return
    fi

    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"

    # Build form command
    local form_cmd="zenity --forms --title=\"Insert into $table_name\" --text=\"Enter data:\" --ok-label=\"Insert\" --cancel-label=\"Cancel\""
    
    while IFS=':' read -r col_name col_type col_pk; do
        form_cmd="$form_cmd --add-entry=\"$col_name ($col_type):\""
    done < "$meta_file"

    form_cmd="$form_cmd --width=400 2>/dev/null"

    # Get user input
    local result=$(eval $form_cmd)

    local exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        # User cancelled - just return without any message
        return
    fi

    # Process and validate input
    local col_num=1
    local pk_value=""
    local new_record=""
    
    IFS='|' read -ra VALUES <<< "$result"
    
    # Validate each field
    while IFS=':' read -r col_name col_type col_pk; do
        local value="${VALUES[$((col_num-1))]}"
        
        # Check if empty
        if [ -z "$value" ]; then
            show_error "Field '$col_name' cannot be empty!"
            return
        fi
        
        # Validate integer type
        if [ "$col_type" = "Int" ]; then
            if ! is_number "$value"; then
                show_error "Field '$col_name' must be a number!"
                return
            fi
        fi
        
        # Remember primary key value
        if [ "$col_pk" = "PK" ]; then
            pk_value="$value"
        fi
        
        # Build record string
        if [ $col_num -eq 1 ]; then
            new_record="$value"
        else
            new_record="$new_record|$value"
        fi
        
        ((col_num++))
    done < "$meta_file"

    # Check for duplicate primary key
    if [ -n "$pk_value" ] && [ -f "$data_file" ]; then
        while IFS='|' read -r line; do
            local first_field=$(echo "$line" | cut -d'|' -f1)
            if [ "$first_field" = "$pk_value" ]; then
                show_error "Primary Key '$pk_value' already exists!"
                return
            fi
        done < "$data_file"
    fi

    # Insert record
    echo "$new_record" >> "$data_file"
    show_info "Record inserted successfully!"
}

# Select and display records
select_records() {
    # Select table
    local table_name=$(select_table "Select")
    
    if [ $? -ne 0 ]; then
        return
    fi

    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"

    # Check if table is empty
    if [ ! -s "$data_file" ]; then
        show_info "Table '$table_name' is empty!"
        return
    fi

    # Ask for select mode
    local mode=$(zenity --list \
        --title="Select Mode" \
        --text="Choose option:" \
        --column="No" --column="Mode" \
        --ok-label="Select" \
        --cancel-label="Cancel" \
        --width=400 --height=250 \
        "1" "Show All Records" \
        "2" "Search by Primary Key" 2>/dev/null)

    local exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        return
    fi

    # Create temporary file for output
    local temp_file=$(mktemp)

    # Write column headers
    while IFS=':' read -r col_name col_type col_pk; do
        printf "%-20s" "$col_name" >> "$temp_file"
    done < "$meta_file"
    echo "" >> "$temp_file"

    # Write separator line
    while IFS=':' read -r col_name col_type col_pk; do
        printf "%-20s" "--------------------" >> "$temp_file"
    done < "$meta_file"
    echo "" >> "$temp_file"

    if [ "$mode" = "1" ]; then
        # Show all records
        while IFS='|' read -r line; do
            IFS='|' read -ra FIELDS <<< "$line"
            for field in "${FIELDS[@]}"; do
                printf "%-20s" "$field" >> "$temp_file"
            done
            echo "" >> "$temp_file"
        done < "$data_file"
        
    else
        # Search by primary key
        local pk_col=$(get_primary_key_column "$table_name")
        
        local pk_value=$(zenity --entry \
            --title="Search" \
            --text="Enter $pk_col value:" \
            --ok-label="Search" \
            --cancel-label="Cancel" \
            --width=400 2>/dev/null)

        exit_status=$?

        # Check if user cancelled
        if [ $exit_status -ne 0 ]; then
            rm -f "$temp_file"
            return
        fi

        # Check if value is empty
        if [ -z "$pk_value" ]; then
            rm -f "$temp_file"
            show_error "Search value cannot be empty!"
            return
        fi

        # Search for record
        local found=0
        while IFS='|' read -r line; do
            local first_field=$(echo "$line" | cut -d'|' -f1)
            
            if [ "$first_field" = "$pk_value" ]; then
                IFS='|' read -ra FIELDS <<< "$line"
                for field in "${FIELDS[@]}"; do
                    printf "%-20s" "$field" >> "$temp_file"
                done
                echo "" >> "$temp_file"
                found=1
                break
            fi
        done < "$data_file"

        if [ $found -eq 0 ]; then
            rm -f "$temp_file"
            show_error "No record found with $pk_col = $pk_value"
            return
        fi
    fi

    # Display results
    zenity --text-info \
        --title="Results from $table_name" \
        --ok-label="Close" \
        --width=$TEXT_WIDTH \
        --height=$TEXT_HEIGHT \
        --font="Monospace 10" \
        --filename="$temp_file" 2>/dev/null

    rm -f "$temp_file"
}

# Delete record from table
delete_record() {
    # Select table
    local table_name=$(select_table "Delete")
    
    if [ $? -ne 0 ]; then
        return
    fi

    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"

    # Get primary key information
    local pk_col=$(get_primary_key_column "$table_name")

    # Ask for primary key value
    local pk_value=$(zenity --entry \
        --title="Delete Record" \
        --text="Enter $pk_col value to delete:" \
        --ok-label="Delete" \
        --cancel-label="Cancel" \
        --width=400 2>/dev/null)

    local exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        return
    fi

    # Check if value is empty
    if [ -z "$pk_value" ]; then
        show_error "Value cannot be empty!"
        return
    fi

    # Check if record exists
    local found=0
    while IFS='|' read -r line; do
        local first_field=$(echo "$line" | cut -d'|' -f1)
        if [ "$first_field" = "$pk_value" ]; then
            found=1
            break
        fi
    done < "$data_file"

    if [ $found -eq 0 ]; then
        show_error "No record found with $pk_col = $pk_value"
        return
    fi

    # Confirm deletion
    show_question "Delete record with $pk_col = $pk_value?"
    
    if [ $? -eq 0 ]; then
        # Delete record
        grep -v "^$pk_value|" "$data_file" > "$data_file.tmp"
        mv "$data_file.tmp" "$data_file"
        show_info "Record deleted successfully!"
    fi
}

# Update record in table
update_record() {
    # Select table
    local table_name=$(select_table "Update")
    
    if [ $? -ne 0 ]; then
        return
    fi

    local meta_file="$DATABASES_DIR/$CURRENT_DB/$table_name.meta"
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"

    # Get primary key information
    local pk_col=$(get_primary_key_column "$table_name")

    # Ask for primary key value
    local pk_value=$(zenity --entry \
        --title="Update Record" \
        --text="Enter $pk_col value:" \
        --ok-label="Next" \
        --cancel-label="Cancel" \
        --width=400 2>/dev/null)

    local exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        return
    fi

    # Check if value is empty
    if [ -z "$pk_value" ]; then
        show_error "Value cannot be empty!"
        return
    fi

    # Check if record exists
    local found=0
    while IFS='|' read -r line; do
        local first_field=$(echo "$line" | cut -d'|' -f1)
        if [ "$first_field" = "$pk_value" ]; then
            found=1
            break
        fi
    done < "$data_file"

    if [ $found -eq 0 ]; then
        show_error "No record found with $pk_col = $pk_value"
        return
    fi

    # Build column selection list
    local col_list=""
    local col_num=1
    
    while IFS=':' read -r col_name col_type col_pk; do
        if [ -z "$col_list" ]; then
            col_list="$col_num\n$col_name"
        else
            col_list="$col_list\n$col_num\n$col_name"
        fi
        ((col_num++))
    done < "$meta_file"

    # Select column to update
    local col_choice=$(echo -e "$col_list" | zenity --list \
        --title="Select Column" \
        --text="Choose column to update:" \
        --column="No" --column="Column" \
        --ok-label="Select" \
        --cancel-label="Cancel" \
        --width=400 \
        --height=$LIST_HEIGHT 2>/dev/null)

    exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        return
    fi

    # Check if selection is empty
    if [ -z "$col_choice" ]; then
        return
    fi

    # Get column information
    local col_info=$(sed -n "${col_choice}p" "$meta_file")
    local col_name=$(echo "$col_info" | cut -d':' -f1)
    local col_type=$(echo "$col_info" | cut -d':' -f2)

    # Get new value
    local new_value=$(zenity --entry \
        --title="New Value" \
        --text="Enter new value for $col_name ($col_type):" \
        --ok-label="Update" \
        --cancel-label="Cancel" \
        --width=400 2>/dev/null)

    exit_status=$?

    # Check if user cancelled
    if [ $exit_status -ne 0 ]; then
        return
    fi

    # Validate new value
    if [ -z "$new_value" ]; then
        show_error "Value cannot be empty!"
        return
    fi

    if [ "$col_type" = "Int" ]; then
        if ! is_number "$new_value"; then
            show_error "Value must be a number!"
            return
        fi
    fi

    # Update record using awk
    awk -F'|' -v pk="$pk_value" -v col="$col_choice" -v val="$new_value" \
        'BEGIN{OFS="|"} {if($1 == pk) {$col = val} print}' "$data_file" > "$data_file.tmp"
    mv "$data_file.tmp" "$data_file"

    show_info "Record updated successfully!"
}
