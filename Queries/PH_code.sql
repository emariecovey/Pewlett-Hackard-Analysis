--Creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL, --not null says that no null fields will be allowed when importing data
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no), 
	UNIQUE (dept_name)
);

CREATE TABLE employees(
	emp_no int NOT NULL,
	birth_date date NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	gender varchar NOT NULL,
	hire_date date NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
	

CREATE TABLE salaries (
	emp_no int NOT NULL,
	salary int NOT NULL,
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_NO)
);

CREATE TABLE dept_emp(
	emp_no int NOT NULL,
	dept_no varchar (4) NOT NULL,
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles(
	emp_no int NOT NULL,
	title varchar NOT NULL,
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no,title,from_date)
);

--dropped tables when trying to figure out error
DROP TABLE dept_manager CASCADE;

--all tables imported successfully after adjusting primary keys
SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles


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
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

--looking at table
SELECT * FROM retirement_info 

DROP TABLE retirement_info; 

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

--fixed this table so that only employees current department is there
--table is correct and should be good to go

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
WHERE (de.to_date = '9999-01-01') --this gets people who are currently in the department 

select count(emp_no) from current_emp
--33118 current employees

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
	AND (de.to_date = '9999-01-01')

SELECT * FROM sales_retirement_info

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
WHERE (d.dept_name IN ('Sales', 'Development')) --says sales or development
	AND (de.to_date = '9999-01-01') --puts only people currently in the department in this table

select * from retirement_info

----------------------------------------------------------------------------------

--CHALLENGE CODE



--INSTRUCTIONS:
--Number of retiring employees by titles
--create a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955. 
--Because some employees may have multiple titles in the database—for example, due to promotions—you’ll need to use the DISTINCT ON statement to create a table that contains the most recent title of each employee. 
--Then, use the COUNT() function to create a table that has the number of retirement-age employees by most recent job title. 
--Finally, because we want to include only current employees in our analysis, be sure to exclude those employees who have already left the company.


--employees eligible for retirement with their titles (still includes multiple titles per employee, and employees who have already retired)
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date, 
	ti.to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN titles AS ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no

SELECT * FROM retirement_titles


--employees eligible for retirement with their titles 
SELECT DISTINCT ON (ti.emp_no) 
	e.emp_no,
	e.first_name,
	e.last_name,
	ti.title
INTO unique_titles
FROM employees AS e
	INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND to_date = ('9999-01-01')
ORDER BY ti.emp_no, ti.to_date DESC;


--count of retirement-age employees by most recent job title
SELECT COUNT(emp_no), title 
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) desc;


--MORE INSTRUCTIONS:
--create a mentorship-eligibility table that holds:
--the current employees who were born between January 1, 1965 and December 31, 1965.
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	ti.from_date,
	ti.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as e
	INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND to_date = '9999-01-01'
ORDER BY e.emp_no, ti.title

SELECT * FROM mentorship_eligibility


