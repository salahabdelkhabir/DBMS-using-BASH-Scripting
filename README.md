# Bash DBMS - Modular Architecture

A simple, beginner-friendly Database Management System written in Bash with a modular architecture.

## 📁 Project Structure

```
bash-dbms/
├── dbms.sh                      # Main entry point
├── config.sh                    # Configuration and global variables
├── utils.sh                     # Utility helper functions
├── database_operations.sh       # Database CRUD operations
├── table_operations.sh          # Table CRUD operations
├── record_operations.sh         # Record CRUD operations
├── menus.sh                     # Menu system
├── setup.sh                     # Setup and installation script
├── README.md                    # This file
└── databases/                   # Database storage directory
    ├── database1/
    │   ├── table1.meta         # Table metadata
    │   ├── table1.data         # Table data
    │   └── ...
    └── database2/
        └── ...
```

---

## 🚀 Quick Start

### Installation

1. **Download all files** to a directory
2. **Run setup script**:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
3. **Start the DBMS**:
   ```bash
   ./dbms.sh
   ```

### Manual Setup

If you prefer manual setup:
```bash
# Make scripts executable
chmod +x *.sh

# Create databases directory
mkdir -p databases

# Run the application
./dbms.sh
```

---

## 📚 Module Descriptions

### 1. **dbms.sh** - Main Script
- **Purpose**: Entry point of the application
- **What it does**:
  - Sources all module files
  - Initializes the system
  - Starts the main menu
- **Key Concepts**: `source` command, script organization

### 2. **config.sh** - Configuration
- **Purpose**: Central configuration file
- **Contains**:
  - Global variables (DATABASES_DIR, CURRENT_DB)
  - Window size settings
  - System initialization function
- **Key Concepts**: Variables, directory management

### 3. **utils.sh** - Utilities
- **Purpose**: Reusable helper functions
- **Functions**:
  - `show_error()` - Display error messages
  - `show_info()` - Display success messages
  - `show_question()` - Ask yes/no questions
  - `is_number()` - Validate numeric input
  - `get_database_list()` - Get list of databases
  - `get_table_list()` - Get list of tables
  - `database_exists()` - Check if database exists
  - `table_exists()` - Check if table exists
  - `get_primary_key_column()` - Get PK column name
  - `get_primary_key_type()` - Get PK column type
- **Key Concepts**: Functions, return values, file tests

### 4. **database_operations.sh** - Database Operations
- **Purpose**: Manage databases
- **Functions**:
  - `create_database()` - Create new database
  - `list_databases()` - Show all databases
  - `connect_database()` - Connect to database
  - `drop_database()` - Delete database
- **Key Concepts**: Directory operations, user input validation

### 5. **table_operations.sh** - Table Operations
- **Purpose**: Manage tables within databases
- **Functions**:
  - `create_table()` - Create new table with columns
  - `list_tables()` - Show all tables and their structure
  - `drop_table()` - Delete table
- **Key Concepts**: File operations, loops, metadata management

### 6. **record_operations.sh** - Record Operations
- **Purpose**: Manage data records in tables
- **Functions**:
  - `select_table()` - Helper to choose a table
  - `insert_record()` - Add new record
  - `select_records()` - View records (all or by PK)
  - `delete_record()` - Remove record
  - `update_record()` - Modify record
- **Key Concepts**: Data validation, file reading/writing, awk

### 7. **menus.sh** - Menu System
- **Purpose**: User interface menus
- **Functions**:
  - `main_menu()` - Main application menu
  - `database_menu()` - Database-specific menu
- **Key Concepts**: While loops, case statements, zenity dialogs

---

## 🔄 Data Flow

### Example: Inserting a Record

```
User → main_menu() → database_menu() → insert_record()
                                            ↓
                                    select_table()
                                            ↓
                                    Show form (zenity)
                                            ↓
                                    Validate data
                                            ↓
                                    Check PK uniqueness
                                            ↓
                                    Write to .data file
                                            ↓
                                    show_info()
```

---

## 🎓 Learning Path

### For Beginners
Start by understanding these files in order:

1. **config.sh** - Learn about variables
2. **utils.sh** - Learn about functions
3. **menus.sh** - Learn about loops and case statements
4. **database_operations.sh** - Learn about file operations
5. **table_operations.sh** - Learn about complex loops
6. **record_operations.sh** - Learn about data processing
7. **dbms.sh** - Learn about modular programming

### Key Concepts by Module

| Module | Concepts |
|--------|----------|
| config.sh | Variables, initialization |
| utils.sh | Functions, return values, file tests |
| database_operations.sh | Directory operations, validation |
| table_operations.sh | Loops, file I/O, metadata |
| record_operations.sh | Data validation, string processing, awk |
| menus.sh | While loops, case statements, UI |
| dbms.sh | Source command, modular design |

---

## 🔧 How Modules Communicate

### 1. Shared Variables
```bash
# config.sh
CURRENT_DB="mydb"

# Any other module can access it
echo "Current database: $CURRENT_DB"
```

### 2. Function Calls
```bash
# utils.sh defines
show_error() {
    zenity --error --text="$1"
}

# database_operations.sh uses it
if [ -z "$db_name" ]; then
    show_error "Name cannot be empty!"
fi
```

### 3. Return Values
```bash
# utils.sh
database_exists() {
    if [ -d "$DATABASES_DIR/$1" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Usage in database_operations.sh
if database_exists "$db_name"; then
    show_error "Already exists!"
fi
```

---

## 📂 File Formats

### Metadata File (.meta)
Stores table structure:
```
column_name:data_type:primary_key_flag

Example:
ID:Int:PK
Name:String:N
Age:Int:N
```

### Data File (.data)
Stores actual records:
```
value1|value2|value3

Example:
1|John|25
2|Sara|30
```

---

## ✨ Benefits of Modular Design

### 1. **Organization**
- Each file has a single, clear purpose
- Easy to find where functionality is implemented

### 2. **Maintainability**
- Fix bugs in one module without affecting others
- Easy to add new features

### 3. **Readability**
- Smaller files are easier to understand
- Clear function names explain what code does

### 4. **Reusability**
- Utility functions can be used anywhere
- Don't repeat code

### 5. **Testing**
- Test each module independently
- Easier to isolate problems

---

## 🛠️ Extending the System

### Adding a New Feature

1. **Decide which module** the feature belongs to
2. **Create the function** in that module
3. **Add menu option** in menus.sh
4. **Update README** with new feature

### Example: Add "Count Records" Feature

```bash
# 1. Add to record_operations.sh
count_records() {
    local table_name=$(select_table "Count")
    if [ -z "$table_name" ]; then
        return
    fi
    
    local data_file="$DATABASES_DIR/$CURRENT_DB/$table_name.data"
    local count=$(wc -l < "$data_file")
    
    show_info "Table '$table_name' has $count records"
}

# 2. Add to menus.sh database_menu()
"8" "Count Records"

# 3. Add case in database_menu()
"8") count_records ;;
```

---

## 🐛 Troubleshooting

### Module Not Found Error
```bash
./dbms.sh: line 10: config.sh: No such file or directory
```
**Solution**: Make sure all .sh files are in the same directory

### Permission Denied
```bash
bash: ./dbms.sh: Permission denied
```
**Solution**: Run `chmod +x *.sh`

### Zenity Not Found
```bash
zenity: command not found
```
**Solution**: Install zenity using your package manager

---

## 📖 Related Lab Concepts

### Lab 1 (sed/awk)
- **Used in**: record_operations.sh for data manipulation
- **Functions**: `update_record()` uses awk

### Lab 2 (Basic Scripts)
- **Used in**: All modules
- **Concepts**: Variables, functions, file tests, arguments

### Lab 3 (Advanced Scripts)
- **Used in**: menus.sh, table_operations.sh
- **Concepts**: Loops, case statements, arrays

---

## 💡 Tips for Understanding

1. **Start with dbms.sh** - See how modules are loaded
2. **Read config.sh** - Understand the variables
3. **Check utils.sh** - Learn the helper functions
4. **Follow the flow** - Trace execution from main_menu()
5. **Add echo statements** - Print variables to understand flow
6. **Test each module** - Source and test functions individually

---

## 🎯 Design Principles

### 1. Single Responsibility
Each module handles one aspect:
- database_operations.sh → Only database operations
- table_operations.sh → Only table operations

### 2. DRY (Don't Repeat Yourself)
Common code goes in utils.sh:
- show_error() used everywhere
- No duplicate code

### 3. Separation of Concerns
- UI (menus.sh) separate from logic
- Data operations separate from validation

### 4. Clear Naming
- Functions named by action: create_database()
- Variables explain purpose: CURRENT_DB

---

## 📝 Summary

This modular architecture provides:
- ✅ Clear organization
- ✅ Easy to understand
- ✅ Simple to extend
- ✅ Uses beginner concepts only
- ✅ Well-documented
- ✅ Production-ready structure

Each module is independent but works together to create a complete DBMS system!