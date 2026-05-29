CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2)
);

INSERT INTO employees (emp_name, department, salary)
VALUES
('Amit', 'HR', 50000),
('Neha', 'HR', 52000),
('Rahul', 'IT', 70000),
('Sneha', 'IT', 75000),
('Priya', 'Finance', 65000),
('Karan', 'Finance', 68000),
('John', 'IT', 72000),
('Meera', 'HR', 51000),
('David', 'Finance', 69000),
('Anjali', 'IT', 71000);

SELECT * FROM employees;

CREATE ROLE hrr_user LOGIN PASSWORD 'hr123';

CREATE ROLE it_user LOGIN PASSWORD 'it123';

CREATE ROLE finance_user LOGIN PASSWORD 'fin123';

GRANT SELECT ON employees TO hrr_user;
GRANT SELECT ON employees TO it_user;
GRANT SELECT ON employees TO finance_user;

CREATE TABLE user_department (
    username TEXT,
    department TEXT
);

INSERT INTO user_department (username, department)
VALUES
('hrr_user', 'HR'),
('it_user', 'IT'),
('finance_user', 'Finance');
select * from user_department;

--enable rls
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

CREATE POLICY employee_policy
ON employees
FOR SELECT
TO PUBLIC
USING (
    department =
    (
        SELECT department
        FROM user_department
        WHERE username = current_user
    )
);

GRANT SELECT ON user_department TO hrr_user;
GRANT SELECT ON user_department TO it_user;
GRANT SELECT ON user_department TO finance_user;

SET ROLE hrr_user;
SELECT * FROM employees;
RESET ROLE;

SET ROLE it_user;
SELECT * FROM employees;
RESET ROLE;

SET ROLE finance_user;
SELECT * FROM employees;
RESET ROLE;

--all policies created on the table.
SELECT *
FROM pg_policies
WHERE tablename = 'employees';

-- to disable RLS
ALTER TABLE employees DISABLE ROW LEVEL SECURITY;

--another easy but long way
CREATE POLICY hr_policy
ON employees
FOR SELECT
TO hrr_user
USING (department = 'HR');