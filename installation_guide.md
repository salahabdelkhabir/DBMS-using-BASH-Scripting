# Bash DBMS - Installation & Usage Guide

## 📦 Quick Installation

### Step 1: Create Project Directory
```bash
mkdir bash-dbms
cd bash-dbms
```

### Step 2: Create All Files

Save each file with the exact name shown:

1. **dbms.sh** - Main entry point
2. **config.sh** - Configuration
3. **utils.sh** - Utility functions
4. **database_operations.sh** - Database CRUD
5. **table_operations.sh** - Table CRUD
6. **record_operations.sh** - Record CRUD
7. **menus.sh** - Menu system
8. **setup.sh** - Setup script

### Step 3: Run Setup
```bash
chmod +x setup.sh
./setup.sh
```

### Step 4: Launch Application
```bash
./dbms.sh
```

---

## 🎯 Complete File Checklist

```
✓ dbms.sh                    (Main script)
✓ config.sh                  (Configuration)
✓ utils.sh                   (Utilities)
✓ database_operations.sh     (DB operations)
✓ table_operations.sh        (Table operations)
✓ record_operations.sh       (Record operations)
✓ menus.sh                   (Menu system)
✓ setup.sh                   (Setup script)
✓ README.md                  (Documentation - optional)
```

---

## 🚀 Usage Examples

### Example 1: Create Your First Database

1. Run `./dbms.sh`
2. Select **"1 - Create Database"**
3. Enter name: `MyFirstDB`
4. Click OK
5. Success! Database created

### Example 2: Create a Table

1. Select **"3 - Connect to Database"**
2. Choose `MyFirstDB`
3. Select **"1 - Create Table"**
4. Enter table name: `Students`
5. Enter number of columns: `3`
6. Define columns:
   - Column 1: `ID` (Int) - **Yes** for Primary Key
   - Column 2: `Name` (String)
   - Column 3: `Age` (Int)
7. Success! Table created

### Example 3: Insert Records

1. In database menu, select **"4 - Insert Record"**
2. Choose table: `Students`
3. Enter data:
   - ID: `1`
   - Name: `Ahmed`
   - Age: `20`
4. Click OK
5. Record inserted!

### Example 4: View Records

1. Select **"5 - Select Records"**
2. Choose table: `Students`
3. Select **"1 - Show All Records"**
4. View all data in table

### Example 5: Search by Primary Key

1. Select **"5 - Select Records"**
2. Choose table: `Students`
3. Select **"2 - Search by Primary Key"**
4. Enter ID: `1`
5. View specific record

---

## 📝 Complete Workflow Example

Let's create a simple **Employee Management System**:

### 1. Create Database
```
Main Menu → Create Database → "EmployeeDB"
```

### 2. Connect to Database
```
Main Menu → Connect to Database → "EmployeeDB"
```

### 3. Create Employees Table
```
Database Menu → Create Table
  Table Name: Employees
  Columns: 4
  
  Column 1: ID (Int) [Primary Key]
  Column 2: Name (String)
  Column 3: Department (String)
  Column 4: Salary (Int)
```

### 4. Insert Employees
```
Database Menu → Insert Record → Employees

Employee 1:
  ID: 1
  Name: Ahmed Ali
  Department: IT
  Salary: 5000

Employee 2:
  ID: 2
  Name: Sara Mohamed
  Department: HR
  Salary: 4500

Employee 3:
  ID: 3
  Name: Omar Hassan
  Department: Sales
  Salary: 4000
```

### 5. View All Employees
```
Database Menu → Select Records → Employees → Show All
```

Result:
```
ID                  Name                Department          Salary              
--------------------------------------------------------------------
1                   Ahmed Ali           IT                  5000                
2                   Sara Mohamed        HR                  4500                
3                   Omar Hassan         Sales               4000                
```

### 6. Update Salary
```
Database Menu → Update Record → Employees
  Enter ID: 1
  Select Column: 4 (Salary)
  New Value: 5500
```

### 7. Delete Record
```
Database Menu → Delete Record → Employees
  Enter ID: 3
  Confirm: Yes
```

### 8. Verify Changes
```
Database Menu → Select Records → Show All
```

---

## 🎓 Tutorial: Student Information System

### Complete Example Project

**Goal**: Create a student information system with courses

#### Step 1: Setup
```bash
./dbms.sh
```

#### Step 2: Create Database
```
Main Menu → 1 (Create Database)
Name: UniversityDB
```

#### Step 3: Create Students Table
```
Main Menu → 3 (Connect) → UniversityDB
Database Menu → 1 (Create Table)

Table: Students
Columns: 4
  - ID (Int) [PK]
  - Name (String)
  - Major (String)
  - GPA (Int) [use whole numbers: 3.5 → 35]
```

#### Step 4: Create Courses Table
```
Database Menu → 1 (Create Table)

Table: Courses
Columns: 3
  - CourseID (Int) [PK]
  - CourseName (String)
  - Credits (Int)
```

#### Step 5: Insert Student Data
```
Database Menu → 4 (Insert) → Students

Student 1: 1, Ahmed Mohamed, Computer Science, 35
Student 2: 2, Fatima Ali, Engineering, 38
Student 3: 3, Hassan Khalid, Medicine, 40
```

#### Step 6: Insert Course Data
```
Database Menu → 4 (Insert) → Courses

Course 1: 101, Programming, 3
Course 2: 102, Databases, 3
Course 3: 103, Networks, 4
```

#### Step 7: Query Data
```
Database Menu → 5 (Select) → Students → Show All
Database Menu → 5 (Select) → Courses → Show All
```

#### Step 8: Find Specific Student
```
Database Menu → 5 (Select) → Students → Search by PK
Enter ID: 2
```

#### Step 9: Update Student GPA
```
Database Menu → 7 (Update) → Students
Enter ID: 1
Select Column: 4 (GPA)
New Value: 37
```

#### Step 10: List All Tables
```
Database Menu → 2 (List Tables)
```

---

## 🛠️ Common Tasks

### Check What Databases Exist
```
Main Menu → 2 (List Databases)
```

### Check What Tables Are in Database
```
Main Menu → 3 (Connect to DB)
Database Menu → 2 (List Tables)
```

### Backup Database (Manual)
```bash
# In terminal:
cp -r databases/MyDB databases/MyDB_backup_$(date +%Y%m%d)
```

### Delete Everything and Start Fresh
```bash
# In terminal:
rm -rf databases/*
./dbms.sh
```

### View Raw Data Files
```bash
# View table structure
cat databases/MyDB/MyTable.meta

# View table data
cat databases/MyDB/MyTable.data
```

---

## ⚠️ Important Notes

### Data Types
- **Int**: Only positive whole numbers (1, 2, 100, 9999)
- **String**: Any text (names, descriptions, etc.)

### Primary Key Rules
- Must be unique
- Cannot be empty
- Only one per table
- Usually the first column (ID)

### Best Practices
1. **Always set a Primary Key** - Use ID as first column
2. **Use meaningful names** - `Students` not `Table1`
3. **Plan your columns** - Think before creating table
4. **Regular backups** - Copy databases folder
5. **Test with small data** - Try a few records first

---

## 🐛 Troubleshooting

### "Permission denied" Error
```bash
chmod +x *.sh
./dbms.sh
```

### "Zenity not found" Error
```bash
# Ubuntu/Debian
sudo apt-get install zenity

# Fedora
sudo dnf install zenity

# Arch
sudo pacman -S zenity
```

### "Module not found" Error
Make sure all .sh files are in the same directory:
```bash
ls -l *.sh
```

### Dialog Doesn't Appear
Check if Zenity is working:
```bash
zenity --info --text="Test"
```

### Table Not Found
1. Make sure you're connected to correct database
2. Check table exists: Database Menu → List Tables
3. Check file system: `ls databases/DBNAME/`

---

## 📊 Sample Data Sets

### Example 1: Simple Contacts
```
Table: Contacts
ID | Name          | Phone
1  | Ahmed Ali     | 0123456789
2  | Sara Hassan   | 0198765432
3  | Omar Khalid   | 0155555555
```

### Example 2: Products Inventory
```
Table: Products
ID | Name          | Price | Stock
1  | Laptop        | 15000 | 10
2  | Mouse         | 100   | 50
3  | Keyboard      | 300   | 30
```

### Example 3: Book Library
```
Table: Books
ID | Title               | Author        | Year
1  | The Great Gatsby    | Fitzgerald    | 1925
2  | To Kill Mockingbird | Harper Lee    | 1960
3  | 1984                | Orwell        | 1949
```

---

## 🎯 Project Ideas

Practice by creating these systems:

### Beginner Projects
1. **Contact Manager** - Store names and phone numbers
2. **To-Do List** - Track tasks and priorities
3. **Shopping List** - Items and quantities

### Intermediate Projects
4. **Library System** - Books, authors, and borrowers
5. **Inventory System** - Products, stock, and prices
6. **Grade Tracker** - Students, courses, and grades

### Advanced Projects
7. **HR System** - Employees, departments, salaries
8. **Hospital Records** - Patients, doctors, appointments
9. **E-commerce** - Products, customers, orders

---

## 📚 Learning Path

### Week 1: Basics
- Create databases
- Create simple tables (2-3 columns)
- Insert a few records
- View all records

### Week 2: Operations
- Search by primary key
- Update records
- Delete records
- List tables

### Week 3: Real Projects
- Design multi-table database
- Practice data validation
- Handle errors gracefully
- Create useful reports

---

## 🎓 Understanding the Code

### Start Here
1. Read `config.sh` - Understand variables
2. Read `utils.sh` - Learn helper functions
3. Read `menus.sh` - See the flow
4. Pick one operations file and study it

### Add Your Own Function
```bash
# In utils.sh, add:
say_hello() {
    show_info "Hello from my function!"
}

# In menus.sh, add to database_menu:
"9") say_hello ;;

# Test it!
```

---

## 💡 Tips for Success

1. **Start Small** - Create simple tables first
2. **Use Simple Names** - Avoid spaces and special characters
3. **Test Often** - Insert and view data frequently
4. **Learn from Errors** - Error messages help you learn
5. **Experiment** - Try different data types and structures
6. **Read the Code** - Understanding how it works helps a lot

---

## 📞 Quick Reference Card

```
MAIN MENU
1 - Create Database
2 - List Databases
3 - Connect to Database
4 - Drop Database
5 - Exit

DATABASE MENU (after connecting)
1 - Create Table
2 - List Tables
3 - Drop Table
4 - Insert Record
5 - Select Records
6 - Delete Record
7 - Update Record
8 - Back to Main Menu
```

---

## ✅ Success Checklist

- [ ] Setup.sh executed successfully
- [ ] Created first database
- [ ] Created first table with PK
- [ ] Inserted first record
- [ ] Viewed records successfully
- [ ] Updated a record
- [ ] Deleted a record
- [ ] Searched by primary key
- [ ] Created second table
- [ ] Built a complete project

**Congratulations!** You now have a working Database Management System! 🎉