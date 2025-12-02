# Bash DBMS - Architecture Diagram

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         USER                                │
│                    (Zenity GUI)                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      dbms.sh                                │
│                   (Main Entry Point)                        │
│                                                             │
│  • Loads all modules                                        │
│  • Initializes system                                       │
│  • Starts main_menu()                                       │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │         source command         │
         └───────────────┬───────────────┘
                         │
    ┌────────────────────┼────────────────────┐
    │                    │                    │
    ▼                    ▼                    ▼
┌─────────┐       ┌──────────┐        ┌──────────┐
│config.sh│       │utils.sh  │        │menus.sh  │
└────┬────┘       └────┬─────┘        └────┬─────┘
     │                 │                    │
     │                 │                    │
     ▼                 ▼                    ▼
┌─────────────────────────────────────────────────┐
│           SHARED RESOURCES                       │
│  • Variables (DATABASES_DIR, CURRENT_DB)        │
│  • Helper Functions (show_error, is_number)     │
│  • Menu System (main_menu, database_menu)       │
└────────────────────┬────────────────────────────┘
                     │
      ┌──────────────┼──────────────┐
      │              │              │
      ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│database_ │  │table_    │  │record_   │
│operations│  │operations│  │operations│
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │              │
     └─────────────┼──────────────┘
                   │
                   ▼
        ┌──────────────────┐
        │   FILE SYSTEM    │
        │                  │
        │  databases/      │
        │  ├── db1/        │
        │  │   ├── t1.meta │
        │  │   └── t1.data │
        │  └── db2/        │
        │      └── ...     │
        └──────────────────┘
```

---

## 🔄 Module Dependency Map

```
                    dbms.sh
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
    config.sh      utils.sh      menus.sh
        │              │              │
        │              │              ├─────────┐
        │              │              │         │
        └──────┬───────┴──────┬───────┘         │
               │              │                 │
               ▼              ▼                 ▼
        database_ops    table_ops         record_ops
               │              │                 │
               └──────────────┴─────────────────┘
                              │
                              ▼
                        File System
```

### Legend
- **Solid lines**: Direct dependencies
- **Module uses**: Functions/variables from another module

---

## 📦 Module Responsibilities

```
┌────────────────────────────────────────────────────────┐
│                     config.sh                          │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • DATABASES_DIR         - Storage location            │
│  • CURRENT_DB           - Active database              │
│  • Window sizes         - UI dimensions                │
│  • init_system()        - Setup function               │
│                                                        │
│ DEPENDENCIES: None                                     │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│                     utils.sh                           │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • show_error()         - Error dialogs                │
│  • show_info()          - Success messages             │
│  • show_question()      - Yes/No prompts               │
│  • is_number()          - Number validation            │
│  • get_database_list()  - List databases               │
│  • get_table_list()     - List tables                  │
│  • database_exists()    - Check DB existence           │
│  • table_exists()       - Check table existence        │
│  • get_primary_key_*()  - PK information               │
│                                                        │
│ DEPENDENCIES: config.sh                                │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│                     menus.sh                           │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • main_menu()          - Main application menu        │
│  • database_menu()      - Database operations menu     │
│                                                        │
│ DEPENDENCIES: config.sh, utils.sh,                     │
│               database_operations.sh,                  │
│               table_operations.sh,                     │
│               record_operations.sh                     │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│              database_operations.sh                    │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • create_database()    - Create new DB                │
│  • list_databases()     - Show all DBs                 │
│  • connect_database()   - Connect to DB                │
│  • drop_database()      - Delete DB                    │
│                                                        │
│ DEPENDENCIES: config.sh, utils.sh, menus.sh            │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│               table_operations.sh                      │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • create_table()       - Create new table             │
│  • list_tables()        - Show all tables              │
│  • drop_table()         - Delete table                 │
│                                                        │
│ DEPENDENCIES: config.sh, utils.sh                      │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│               record_operations.sh                     │
├────────────────────────────────────────────────────────┤
│ PROVIDES:                                              │
│  • select_table()       - Helper for table selection   │
│  • insert_record()      - Add new record               │
│  • select_records()     - View records                 │
│  • delete_record()      - Remove record                │
│  • update_record()      - Modify record                │
│                                                        │
│ DEPENDENCIES: config.sh, utils.sh                      │
└────────────────────────────────────────────────────────┘
```

---

## 🔀 Function Call Flow

### Creating a Database

```
User clicks "Create Database"
         │
         ▼
    main_menu() ──────────────┐
         │                    │ (menus.sh)
         │ case "1"           │
         ▼                    │
create_database() ────────────┘
         │                    (database_operations.sh)
         ├─→ zenity --entry   (Get DB name)
         │
         ├─→ database_exists() (Check if exists)
         │        │            (utils.sh)
         │        └─→ [ -d ... ]
         │
         ├─→ mkdir -p         (Create directory)
         │
         └─→ show_info()      (Success message)
                  │            (utils.sh)
                  └─→ zenity --info
```

### Inserting a Record

```
User clicks "Insert Record"
         │
         ▼
database_menu() ──────────────┐
         │                    │ (menus.sh)
         │ case "4"           │
         ▼                    │
insert_record() ──────────────┘
         │                    (record_operations.sh)
         ├─→ select_table()   (Choose table)
         │        │
         │        └─→ get_table_list() (utils.sh)
         │
         ├─→ zenity --forms   (Get values)
         │
         ├─→ is_number()      (Validate Int fields)
         │        │            (utils.sh)
         │        └─→ [ "$1" -eq "$1" ]
         │
         ├─→ Check PK unique  (Read .data file)
         │
         ├─→ echo >> file     (Write record)
         │
         └─→ show_info()      (Success message)
                  │            (utils.sh)
                  └─→ zenity --info
```

---

## 📂 File System Structure

```
Project Root
│
├── dbms.sh                    ← START HERE
├── config.sh                  ← Read SECOND
├── utils.sh                   ← Read THIRD
├── menus.sh                   ← Read FOURTH
├── database_operations.sh     ← Then these...
├── table_operations.sh        ← ...in any order
├── record_operations.sh       ← ...you prefer
├── setup.sh                   ← Run FIRST (setup)
├── README.md                  ← Documentation
│
└── databases/                 ← Created by system
    ├── TestDB/
    │   ├── Users.meta        ← Table structure
    │   ├── Users.data        ← Table records
    │   ├── Products.meta
    │   └── Products.data
    │
    └── ProductionDB/
        └── ...
```

---

## 🎯 Data Flow: Complete Example

### Scenario: User updates a record

```
┌──────────┐
│   USER   │ Clicks "Update Record"
└────┬─────┘
     │
     ▼
┌─────────────────┐
│  database_menu  │ Shows menu, waits for choice
│   (menus.sh)    │
└────┬────────────┘
     │ User selects "7"
     ▼
┌─────────────────┐
│ update_record() │ Orchestrates the update
│ (record_ops.sh) │
└────┬────────────┘
     │
     ├─→ select_table() ──→ get_table_list() ──→ File System
     │                          (utils.sh)
     │   Returns: "Users"
     │
     ├─→ get_primary_key_column("Users") ──→ grep ":PK" Users.meta
     │   Returns: "ID"
     │
     ├─→ zenity --entry "Enter ID:"
     │   User enters: "5"
     │
     ├─→ Check if record exists ──→ Read Users.data
     │   Found: "5|John|Developer|5000"
     │
     ├─→ Show columns ──→ Read Users.meta
     │   Display: 1.ID  2.Name  3.Role  4.Salary
     │
     ├─→ User selects: "4" (Salary)
     │
     ├─→ zenity --entry "New salary:"
     │   User enters: "6000"
     │
     ├─→ is_number("6000") ──→ Validates
     │                (utils.sh)
     │   Returns: 0 (valid)
     │
     ├─→ awk command ──→ Update Users.data
     │   Changes: "5|John|Developer|5000"
     │   To:      "5|John|Developer|6000"
     │
     └─→ show_info("Success!") ──→ zenity --info
                  (utils.sh)
```

---

## 🧩 Module Interaction Patterns

### Pattern 1: Utils as Foundation
```
Every module uses utils.sh:

database_operations.sh  ┐
table_operations.sh     ├──→ utils.sh
record_operations.sh    ┘       │
                               └──→ show_error()
                               └──→ show_info()
                               └──→ is_number()
```

### Pattern 2: Menu as Controller
```
menus.sh calls operations:

main_menu() ──┬──→ create_database()
              ├──→ list_databases()
              ├──→ connect_database()
              └──→ drop_database()

database_menu() ──┬──→ create_table()
                  ├──→ insert_record()
                  └──→ etc...
```

### Pattern 3: Config as Global State
```
All modules read from config.sh:

database_operations.sh ┐
table_operations.sh    ├──→ config.sh
record_operations.sh   ┘       │
menus.sh                       ├──→ DATABASES_DIR
                               └──→ CURRENT_DB
```

---

## 🎓 Learning Exercise

### Trace This User Action

**User wants to insert a record into "Products" table:**

1. **Start**: `dbms.sh` runs → sources all modules → calls `main_menu()`
2. **Main Menu**: User selects "3" (Connect) → `connect_database()` called
3. **Connect**: Shows DB list → User selects "Shop" → Sets `CURRENT_DB="Shop"`
4. **DB Menu**: `database_menu()` shows options
5. **Insert**: User selects "4" → `insert_record()` called
6. **Select Table**: `select_table()` → `get_table_list()` → Shows "Products"
7. **Get Data**: Form shows (Name, Price, Stock)
8. **Validate**: Each field validated by type
9. **Check PK**: Reads Products.data, checks for duplicates
10. **Write**: Appends new line to Products.data
11. **Success**: `show_info()` displays success message
12. **Return**: Back to `database_menu()`

**Challenge**: Write down which file each step happens in!

---

## 💡 Design Benefits

### Why This Structure?

1. **Easy to Debug**
   - Problem with database creation? → Check database_operations.sh
   - Problem with validation? → Check utils.sh

2. **Easy to Extend**
   - Want to add "export table"? → Add to record_operations.sh
   - Want to add new menu? → Add to menus.sh

3. **Easy to Learn**
   - Each file is small (~100-200 lines)
   - Clear purpose for each module
   - Can learn one module at a time

4. **Professional Structure**
   - Same pattern used in large projects
   - Follows software engineering principles
   - Good practice for real-world coding

---

## 🔧 Customization Guide

### Want to Add a Feature?

**Step-by-step process:**

1. **Identify where it belongs**
   - Database operation? → database_operations.sh
   - Table operation? → table_operations.sh
   - Record operation? → record_operations.sh
   - New utility? → utils.sh

2. **Write the function**
   ```bash
   my_new_feature() {
       # Your code here
   }
   ```

3. **Add to menu**
   - Edit menus.sh
   - Add option in appropriate menu
   - Add case statement

4. **Test**
   - Run dbms.sh
   - Try your new feature

5. **Document**
   - Update README.md
   - Add comments in code

---

This modular architecture makes the DBMS professional, maintainable, and easy to understand!