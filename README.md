# PostgreSQL Row-Level Security (RLS) Demo

## Overview

This project demonstrates how to implement **Row-Level Security (RLS)** in PostgreSQL using:

* Roles/Users
* Dynamic security policies
* User-to-department mapping
* `current_user`
* RLS policies with `USING`

The example ensures that users can only view rows belonging to their assigned department.

---

# Project Scenario

An `employees` table contains employee data from multiple departments:

* HR
* IT
* Finance

Different database users should only be able to see rows related to their own department.

---

# Features Implemented

* Create employee table
* Insert sample employee data
* Create PostgreSQL roles/users
* Grant table permissions
* Enable Row-Level Security
* Create dynamic RLS policy using `current_user`
* User-to-department mapping table
* Test role-based row filtering
* View active RLS policies
* Disable RLS if needed

---

# Database Schema

## Employees Table

| Column     | Data Type          |
| ---------- | ------------------ |
| emp_id     | SERIAL PRIMARY KEY |
| emp_name   | VARCHAR(100)       |
| department | VARCHAR(50)        |
| salary     | NUMERIC(10,2)      |

---

## User Department Mapping Table

| Column     | Data Type |
| ---------- | --------- |
| username   | TEXT      |
| department | TEXT      |

This table maps database users to their departments.

---

# Roles Created

| Role         | Department Access |
| ------------ | ----------------- |
| hrr_user     | HR                |
| it_user      | IT                |
| finance_user | Finance           |

---

# Row-Level Security Logic

The project uses a dynamic RLS policy:

```sql
USING (
    department =
    (
        SELECT department
        FROM user_department
        WHERE username = current_user
    )
)
```

## How It Works

When a user queries the `employees` table:

1. PostgreSQL checks the currently logged-in user using `current_user`
2. Finds the user's department from `user_department`
3. Automatically filters rows based on department
4. Returns only authorized rows

---

# Example

## Logged-in User

```sql
SET ROLE it_user;
```

## Query

```sql
SELECT * FROM employees;
```

## Result

Only employees from the `IT` department are returned.

---

# SQL Concepts Used

* `CREATE TABLE`
* `INSERT`
* `CREATE ROLE`
* `GRANT`
* `ALTER TABLE`
* `ENABLE ROW LEVEL SECURITY`
* `CREATE POLICY`
* `current_user`
* `SET ROLE`
* `RESET ROLE`

---

# Steps to Run

## 1. Create Tables

Run:

* `employees` table creation
* `user_department` table creation

---

## 2. Insert Sample Data

Insert:

* employee records
* user-department mappings

---

## 3. Create Roles

Create:

* `hrr_user`
* `it_user`
* `finance_user`

---

## 4. Grant Permissions

Grant `SELECT` access on:

* `employees`
* `user_department`

---

## 5. Enable RLS

```sql
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
```

---

## 6. Create RLS Policy

Create the dynamic `employee_policy`.

---

## 7. Test Access

Example:

```sql
SET ROLE hrr_user;
SELECT * FROM employees;
RESET ROLE;
```

---

# Viewing Existing Policies

```sql
SELECT *
FROM pg_policies
WHERE tablename = 'employees';
```

---

# Disable RLS

```sql
ALTER TABLE employees DISABLE ROW LEVEL SECURITY;
```

---

# Real-World Use Cases

Row-Level Security is commonly used in:

* Banking applications
* HR systems
* SaaS multi-tenant applications
* Healthcare systems
* Power BI DirectQuery security
* Region/Department-based dashboards

---

# Learning Outcome

This project helps understand:

* Practical PostgreSQL security
* Real-world RLS implementation
* Dynamic access control
* Role-based data visibility
* Policy-driven filtering

---

# Author

Tejal  
