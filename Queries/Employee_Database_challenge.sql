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