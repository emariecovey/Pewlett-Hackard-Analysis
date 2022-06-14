# Pewlett-Hackard-Analysis

## Overview

The purpose of this analysis was to help the company prepare for the mass retirement of baby boomer employees who work at Pewlett Hackard (a "silver tsunami"). The company has several thousand employees and wanted to:

    1. Prepare retirement packages to qualifying retirees
    2. Find out which positions need to be filled in the near future

In this analysis, the names of retiring employees and the number of positions needed to be filled were found to help future-proof the company. 

Two tables were of particular interest:

    1. A table of the number of employees grouped by their most recent job title who are eligible to retire soon
    2. A list of the current employees who were born in 1965 with their title who could take part in a mentorship program to train incoming employees

Data was provided in six tables and included personal data about employees, their departments, their salaries, their titles, their dates of employment, and department managers. Data was uploaded into PostgreSQL and code was edited in pgAdmin. An Entity Relationships Diagram (ERD) was created to help determine relationships between variables in the data. Primary and foreign keys used in the analysis included a unique employee number and a unique department number. 

ERD:

![ERD](https://github.com/emariecovey/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

## Results: 

- Senior engineers and senior staff make up the bulk of who's leaving. Two of the nine managers will also be leaving. The company will need to see if current engineers and staff could be promoted to senior engineers, senior staff, and managers, or if outside hires should be made for higher level positions. 
- Knowledge comes with holding a senior position in a company. Many of the upcoming higher-level job vacancies indicate that a mentorship program would likely greatly benefit the company so that this knowledge is not lost. 
- 1549 employees were included in the list of who could be a part of the mentorship program, and many of them hold senior-level positions, making them ideal to train new employees. 
- The count of current employees eligible for retirement was 7245, over four times the number of people who could be mentors. If there is a mentorship program, each mentor will have at least four employees they are mentoring. If a smaller ratio is desired, the group of potential mentors could be expanded to more than just employees born in 1965. 

Table 1:

![retire_emp_by_job_title.png](https://github.com/emariecovey/Pewlett-Hackard-Analysis/blob/main/retire_emp_by_job_title.png)


## Summary: 

The following questions summarize the analysis: 
1. How many roles will need to be filled as the "silver tsunami" begins to make an impact?
    - 7,245 roles
2. Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
    - If the company is considering employees born in 1965 to be mentors for new employees, there would not be enough mentors among Pewlett Hackard employees, if a 1:1 mentorship ratio is desired. However, if each employee eligible for retirement (born between 1952-1955) mentored a new hire while working part-time for a period of time, there would be enough employees to mentor new employees. Additionally, this would free up potential mentors born in 1965 to do work instead of using their time to mentor. 

Two additional queries would be helpful to prepare for the upcoming "silver tsunami":
1. A count of potential mentors by department, to ensure that there are enough mentors for each department 
2. A table with employees who are current staff and engineers, and that have worked at the company for at least 20 years. This would give a list of employees who could potentially be promoted to senior staff and senior engineers. This could help determine how many lower level and how many senior level employees would need to be hired as older employees retired. 