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
--using count, groupby, and order by (order sorts)

--current employees that could leave count by department number 
SELECT de.dept_no,
	COUNT(ce.emp_no)
INTO emp_by_dept
FROM dept_emp as de
RIGHT JOIN current_emp as ce
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM emp_by_dept

--------------------------------------------------------------
--making additional needed lists:

--select text, command button, forward slash button comments things out


--1. Employee Information: A list of all current employees containing their 
--unique employee number, their last name, first name, gender, and salary

--this table has low salaries?

SELECT * FROM salaries
ORDER BY salaries.to_date DESC;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no) 
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info

--2. Management: A list of managers for each department, including 
--the department number, name, and the manager's employee number, 
--last name, first name, and the starting and ending employment dates

--this table is right and completed

SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN employees as e
		ON (dm.emp_no = e.emp_no)
WHERE to_date = ('9999-01-01')



--3. Department Retirees: An updated current_emp list that includes 
--everything it currently has, but also the employee's departments

--this table has more employees than before? 

SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	ce.to_date,
	d.dept_no
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
	ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
	ON (de.dept_no = d.dept_no)

select count(emp_no) from current_emp
--33118 current employees

select count(emp_no) from dept_info
--36619 employees? How did we get more employees when we used inner joins??????????
-------------------------------------------------------------------------------

--additional needed list for sales team: emp num, emp first, emp last, emp dept name
--everything in retirement_info table, but with sales team
--emp_no, first_name, last_name, dept_name

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_retirement_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON ri.emp_no = de.emp_no
	INNER JOIN departments as d
		ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'

SELECT * FROM retirement_info

--same list as above, but with people in sales and development departments
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_dev_retirement_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON ri.emp_no = de.emp_no
	INNER JOIN departments as d
		ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development') --says sales or development

SELECT * FROM sales_dev_retirement_info