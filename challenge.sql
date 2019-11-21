-- Create tables of Employees born in 1965
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   tt.title,
	   de.from_date,
	   s.salary
into number_of_titles_retiring
FROM employees as e
RIGHT JOIN titles AS tt
ON (e.emp_no = tt.emp_no)
RIGHT JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
RIGHT JOIN salaries AS s
ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	 AND (de.to_date = '9999-01-01');

-- create table without duplicates
SELECT emp_no,
	   first_name,
	   last_name,
	   title,
	   from_date,
	   salary
into ret_no_dup
FROM (SELECT emp_no,
	   first_name,
	   last_name,
	   title,
	   from_date,
	   salary,
     ROW_NUMBER() OVER (PARTITION BY (first_name, last_name) ORDER BY from_date DESC) rn
   FROM number_of_titles_retiring
  ) tmp WHERE rn = 1;


-- List of mentors that are currently employed

SELECT 
	rnd.emp_no,
	rnd.first_name,
	rnd.last_name,
	rnd.title,
	rnd.from_date,
	de.to_date
FROM ret_no_dup AS rnd
LEFT JOIN dept_emp AS de
ON (rnd.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01');