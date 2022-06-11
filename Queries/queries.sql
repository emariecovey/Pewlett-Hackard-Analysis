--------------------------------------------------------------
--Determining retirement eligibility (Names between 1952-55):
SELECT first_name, last_name 
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
--90,398 employees meet first condition
--10,710 employees meet both conditions

--count of employees, not just names 
SELECT COUNT(first_name)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
--41380

--retirement eligibility for just 1953:
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1953-01-01' AND '1953-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1985-12-31')
--22,857 employees born in this range
--2704 employees born in range and hired in range

--retirement eligibility for just 1954:
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'
--23,228 employees

--retirement eligibility for just 1955:
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'
--23,104 employees

--saving table to export:
SELECT first_name, last_name 
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

--looking at table
SELECT * FROM retirement_info 

---------------------------------------------------------
--joining tables to get retiring employees first/last names, emp number, department

--joining departments and dept_manager tables
SELECT d.dept_name, 
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no

--want employee number, employee first/last name, & if they're still working there
--left joining retirement_info with dep_emp on emp_no column
SELECT ri.emp_no, 
	ri.first_name, 
	ri.last_name, 
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de 
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01'); --date is like this because we're getting people who still work there


SELECT COUNT(emp_no) FROM current_emp;

SELECT * FROM current_emp

-------------------------------------------------------------