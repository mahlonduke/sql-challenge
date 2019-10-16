-- Drop tables for a fresh testing start
DROP TABLE dept_emp;
DROP TABLE departments;
DROP TABLE dept_manager;
DROP TABLE salaries;
DROP TABLE titles;
DROP TABLE employees;


-- Creating the initial table schema, columns and data types

CREATE TABLE IF NOT EXISTS departments (
    "departments_id" SERIAL PRIMARY KEY NOT NULL,
	"dept_no" VARCHAR(10) NOT NULL,
    "dept_name" VARCHAR(100)   NOT NULL,
	UNIQUE (dept_no)
);

CREATE TABLE IF NOT EXISTS employees (
	employees_id SERIAL PRIMARY KEY NOT NULL,
	emp_no INT NOT NULL,
	birth_date DATE,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	gender VARCHAR(10),
	hire_date DATE,
	UNIQUE (emp_no)
	);
	
CREATE TABLE IF NOT EXISTS dept_manager (
	dept_manager_id SERIAL PRIMARY KEY NOT NULL,
	dept_no VARCHAR(10) NOT NULL,
	emp_no INT,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
	);

CREATE TABLE IF NOT EXISTS dept_emp (
	dept_emp_id SERIAL PRIMARY KEY,
	emp_no INT,
	dept_no VARCHAR(10),
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
	);

CREATE TABLE IF NOT EXISTS salaries (
	salaries_id SERIAL PRIMARY KEY NOT NULL,
	emp_no INT NOT NULL,
	salary DEC,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
	);
	
CREATE TABLE IF NOT EXISTS titles (
	titles_id SERIAL PRIMARY KEY NOT NULL,
	emp_no INT NOT NULL,
	title VARCHAR(100),
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
	);
	
	
-- Preview table content
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

	
/*
Data Analysis
1. List the following details of each employee: employee number, last name, first name, gender, and salary.
2. List employees who were hired in 1986.
3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
4. List the department of each employee with the following information: employee number, last name, first name, and department name.
5. List all employees whose first name is "Hercules" and last names begin with "B."
6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
*/

/*
List the following details of each employee: 
	employee number
	last name
	first name
	gender
	salary
*/
SELECT e.emp_no AS "Employee Number", e.last_name as "Last Name", e.gender as "Gender", s.salary AS "Salary"
    FROM employees e INNER JOIN salaries s ON (e.emp_no = s.emp_no);


-- List employees who were hired in 1986.
SELECT * 
	FROM employees
	WHERE hire_date >= '1986-01-01'
		AND hire_date < '1987-01-01';


/* 
List the manager of each department with the following information: 
	department number
	department name
	the manager's employee number
	last name
	first name
	start and end employment dates
*/
SELECT e.emp_no AS "Employee Number", e.first_name AS "First Name", e.last_name AS "Last Name", d.dept_no AS "Department Number", d.dept_name AS "Department Name", dm.from_date AS "Start Date", dm.to_date AS "End Date"
	FROM employees e INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
	INNER JOIN departments d ON dm.dept_no = d.dept_no;


/*
List the department of each employee with the following information: 
	employee number
	last name
	first name
	department name
*/
SELECT e.emp_no AS "Employee Number", e.first_name AS "First Name", e.last_name AS "Last Name", d.dept_name AS "Department Name"
	FROM employees e inner join dept_emp de on e.emp_no = de.emp_no
	INNER JOIN departments d on de.dept_no = d.dept_no;


-- List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * 
	FROM employees
	WHERE first_name = 'Hercules'
		AND last_name LIKE 'B%';
		
		
/*
List all employees in the Sales department, including their:
	employee number
	last name
	first name
	department name.
*/
SELECT e.emp_no AS "Employee Number", e.first_name AS "First Name", e.last_name AS "Last Name", d.dept_name AS "Department" 
FROM employees e INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';


/*
List all employees in the Sales and Development departments, including their:
	employee number
	last name
	first name
	department name
*/
SELECT e.emp_no AS "Employee Number", e.first_name AS "First Name", e.last_name AS "Last Name", d.dept_name AS "Department" 
FROM employees e INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';


/*
In descending order, list the frequency count of employee last names, i.e., 
	how many employees share each last name.
*/
SELECT
   last_name AS "Last Name",
   COUNT (last_name) AS "Count"
FROM
   employees
GROUP BY
   last_name
ORDER BY
	"Count" DESC;