--Select all columns from tables
SELECT * FROM employees;
SELECT * FROM shops;
SELECT * FROM locations;
SELECT * FROM suppliers;

--Select some columns from table
SELECT
	employee_id, 
	first_name, 
	last_name
FROM employees;

--Select the employees who make more than 50k
SELECT *
FROM employees
WHERE salary > 50000;

--Select only the employees who work in Common Grounds coffeeshop
SELECT *
FROM employees
WHERE coffeeshop_id = 1;

--Select all employees who work in common grounds and make more than 50k
SELECT *
FROM employees
WHERE coffeeshop_id = 1
AND salary > 50000;

--Select all employees who work at Common Grounds or make more than 50k
SELECT *
FROM employees
WHERE coffeeshop_id = 1
OR salary > 50000;

--Select all the employees who work at Common Grounds, make more than 50k, and are male
SELECT employee_id, first_name, last_name, coffeeshop_name
FROM employees AS e
JOIN shops AS s
ON e.coffeeshop_id = s.coffeeshop_id
WHERE e.coffeeshop_id = 1
AND salary > 50000
AND gender = 'M';

--Select all the employees who work at Common Grounds or make more than 50k or are male
SELECT employee_id, first_name, last_name, coffeeshop_name
FROM employees AS e
JOIN shops AS s
ON e.coffeeshop_id = s.coffeeshop_id
WHERE e.coffeeshop_id = 1
OR salary > 50000
OR gender = 'M';

--Select all rows from the suppliers table where the supplier is Beans and Barley
SELECT *
FROM suppliers
WHERE supplier_name = 'Beans and Barley';

--Select all rows from the suppliers table where the supplier is not Beans and Barley
SELECT *
FROM suppliers
WHERE supplier_name <> 'Beans and Barley';

--Select all Robusta and Arabica coffee types
SELECT *
FROM suppliers
WHERE coffee_type IN('Arabica', 'Robusta');

SELECT *
FROM suppliers
WHERE coffee_type = 'Robusta'
OR coffee_type = 'Arabica';

--Select all coffee types that are not Robusta or Arabica
SELECT *
FROM suppliers
WHERE coffee_type NOT IN ('Robusta', 'Arabica');

--Select all employees where email is missing
SELECT *
FROM employees
WHERE email IS NULL;

--Select all employees who make between 35k and 50k
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 35000 AND 50000;

SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > 35000
AND salary < 50000;

--Order by Salary Ascending
SELECT 
	employee_id, 
	first_name, 
	last_name, 
	salary
FROM employees
ORDER BY salary;

--Order by salary descending
SELECT
	employee_id, 
	first_name, 
	last_name,
	salary
FROM employees
ORDER BY salary DESC;

--Select the top 10 highest paid employees
SELECT
	employee_id,
	first_name, 
	last_name,
	salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

--Select all unique coffeeshop ids
SELECT DISTINCT coffeeshop_id
FROM employees;

--Select all unique countries
SELECT DISTINCT country
FROM locations;

--Rename columns
SELECT
	email, 
	email AS email_address, 
	hire_date, 
	hire_date AS date_joined, 
	salary, 
	salary AS pay
FROM employees;

--extract date components
SELECT
	hire_date AS date, 
	EXTRACT(YEAR FROM hire_date) AS year, 
	EXTRACT(MONTH FROM hire_date) AS month,
	EXTRACT(DAY FROM hire_date) AS day
FROM employees;

--Select uppercase first and last names
SELECT
	first_name, 
	UPPER(first_name) AS first_name_upper, 
	last_name, 
	UPPER(last_name) AS last_name_upper
FROM employees;

--Select lowercase first and last name
SELECT
	first_name, 
	LOWER(first_name) AS first_name_lower, 
	last_name, 
	LOWER(last_name) AS last_name_lower
FROM employees;

--Select the email and length of email
SELECT
	email, 
	LENGTH(email) AS email_length
FROM employees;

--Trim
SELECT
	LENGTH('     Hello    ') AS hello_spaces, 
	LENGTH('Hello') AS hello_no_spaces, 
	LENGTH(TRIM('     Hello    ')) AS hello_trim;
	
--Concatenate first and last names to create full names
SELECT
	first_name, 
	last_name, 
	first_name||' '||last_name AS full_name
FROM employees;

--Concatenate columns to make a sentence
SELECT
	first_name||' '||last_name||' makes '||salary
FROM employees;

--Determine whehter employee makes less than 50k
SELECT 
	first_name||' '||last_name AS full_name, 
	(salary < 50000) AS less_than_50k
FROM employees;

--Determine whether employee makes less than 50k and is female
SELECT
	first_name||' '||last_name AS full_name, 
	(salary < 50000 AND gender = 'F') AS less_than_50k_female
FROM employees;

--Determine if email contains '.com'
SELECT 
	email, 
	email LIKE('%.com%') AS dotcom
FROM employees;

--Determine if email contains '.gov'
SELECT
	email, 
	email LIKE('%.gov%') AS dotgov
FROM employees;

--Select only government employees
SELECT
	first_name||' '||last_name AS full_name, 
	email AS gov_email
FROM employees
WHERE email LIKE '%.gov%';

--Select the email from the 5th character onward
SELECT
	email, 
	SUBSTRING(email FROM 5)
FROM employees;

--Find the position of the '@' in the email
SELECT
	email, 
	POSITION('@' IN email)
FROM employees;

--Use substring and position to find the email client
SELECT
	email, 
	SUBSTRING(email, POSITION('@' IN email) + 1) AS email_client
FROM employees;

--use coalesce to find the missing emails with customs values
SELECT 
	email, 
	COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees;

--Select the minimum salary
SELECT MIN(salary) AS min_sal
FROM employees;

--Select the maximum salary
SELECT MAX(salary) AS max_sal
FROM employees;

--Select the difference between maximum and minimum salary
SELECT MAX(salary) - MIN(salary) AS sal_diff
FROM employees;

--Select the average salary
SELECT ROUND(AVG(salary)) AS avg_sal
FROM employees;

--Sum the salaries
SELECT SUM(salary) AS total_sal
FROM employees;

--Count the number of entries
SELECT COUNT(*) AS total_entries
FROM employees;

SELECT COUNT(salary) AS total_sal
FROM employees;

SELECT COUNT(email) AS total_email
FROM employees;

--Summary
SELECT
	MIN(salary) AS min_sal, 
	MAX(salary) AS max_sal, 
	MAX(salary) - MIN(salary) AS sal_diff, 
	ROUND(AVG(salary)) AS avg_sal, 
	SUM(salary) AS total_sal, 
	COUNT(*) AS total_emp
FROM employees;

--Return the number of employees for each coffeeshop
SELECT
	coffeeshop_id, 
	COUNT(employee_id) AS total_emp
FROM employees
GROUP BY coffeeshop_id;

--Return the total salary by coffeshop
SELECT
	SUM(salary) AS total_sal, 
	s.coffeeshop_name
FROM employees AS e
INNER JOIN shops AS s
ON e.coffeeshop_id = s.coffeeshop_id
GROUP BY s.coffeeshop_name;

--Return the number of employees, the average, min, max, and total salaries for each coffeeshop
SELECT 
	coffeeshop_id, 
	COUNT(*) AS total_emp, 
	ROUND(AVG(salary)) AS avg_sal, 
	MIN(salary) AS min_sal, 
	MAX(salary) AS max_sal, 
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
ORDER BY total_emp DESC;

--Select the coffeeshops with more than 200 employees
SELECT
	coffeeshop_id, 
	COUNT(*) AS total_emp, 
	ROUND(AVG(salary)) AS avg_sal, 
	MIN(salary) AS min_sal, 
	MAX(salary) AS max_sal, 
	SUM(salary) AS total_salary
FROM employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200
ORDER BY total_emp DESC;

--Select coffeeshops with a minimum salary of less than 10k
SELECT
	coffeeshop_id, 
	COUNT(*) AS total_emp, 
	ROUND(AVG(salary)) AS avg_sal, 
	MIN(salary) AS min_sal, 
	MAX(salary) AS max_sal, 
	SUM(salary) AS total_sal 
FROM employees
GROUP BY coffeeshop_id
HAVING MIN(salary) < 10000;

--If pay is less than 50k, then low pay, otherwise high pay
SELECT
	first_name||' ' ||last_name AS full_name, 
	salary, 
	CASE
		WHEN salary < 50000 THEN 'low pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary DESC;

--If pay is less than 20k, then low pay, if between 20k-50k then medium pay, otherwise high pay
SELECT
	employee_id, 
	first_name||' '||last_name AS full_name, 
	salary,
	CASE 
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END AS pay_category
FROM employees
ORDER BY salary DESC;

--Return the count of employees in each category
SELECT 
	COUNT(employee_id) AS num_emp,
	CASE
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END AS pay_category
FROM employees
GROUP BY pay_category;

SELECT a.pay_category, COUNT(*)
FROM(
	SELECT
	employee_id, 
	first_name||' '||last_name AS full_name, 
	salary,
	CASE 
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 AND 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END AS pay_category
FROM employees
ORDER BY salary DESC
) AS a
GROUP BY a.pay_category;

--Count the number of employees in each category
SELECT
	SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS low_pay, 
	SUM(CASE WHEN salary BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END) AS medium_pay, 
	SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) AS high_pay
FROM employees;

-- Inserting values just for JOIN exercises
INSERT INTO locations VALUES(4, 'Paris', 'France');
INSERT INTO shops VALUES(6, 'Happy Brew', NULL);

--Check to make sure values were inserted correctly
SELECT *
FROM locations;

SELECT *
FROM shops;

--INNER JOIN/JOIN
--Select the cofeeshops and their locations
SELECT
	s.coffeeshop_id, 
	l.city, 
	l.country
FROM shops AS s
INNER JOIN locations AS l
ON s.city_id = l.city_id;

--Left Join
--Keep all the values from the shops table and corresponding values from the locations table
SELECT 
	s.coffeeshop_id, 
	l.city, 
	l.country
FROM shops AS s
LEFT JOIN locations AS l
ON s.city_id = l.city_id;

--Right Join
--Keep all values from the locations table and all corresponding vlaues from the shops table
SELECT
	s.coffeeshop_id, 
	l.city, 
	l.country
FROM shops AS s
RIGHT JOIN locations AS l
ON s.city_id = l.city_id;

--Full outer join
--Keep all values form both tables
SELECT
	s.coffeeshop_id, 
	l.city, 
	l.country
FROM shops AS s
FULL OUTER JOIN locations AS l
ON s.city_id = l.city_id;

--Union
--Select all cities and countries
SELECT city
FROM locations
UNION
SELECT country
FROM locations;

--Union removes duplicates
SELECT city
FROM locations
UNION
SELECT city
FROM locations;

--Union All keeps duplicates
SELECT city
FROM locations
UNION ALL
SELECT city
FROM locations;

--Select all coffeeshop names, cities, and countries
SELECT 
	coffeeshop_name
FROM shops
UNION
SELECT
	city
FROM locations
UNION
SELECT
	country
FROM locations;

--Subqueries in the FROM clause
--Select employees at certain coffeshops
SELECT *
FROM(
	SELECT *
	FROM employees
	WHERE coffeeshop_id IN(3,4)
) AS a;

SELECT
	a.employee_id, 
	a.first_name, 
	a.last_name
FROM(
	SELECT *
	FROM employees
	WHERE coffeeshop_id IN (3, 4)
) AS a;

--Subqueries in the SELECT clause
--Select the employee with the highest salary
SELECT
	first_name,
	last_name,
	salary, 
	(
		SELECT MAX(salary)
		FROM employees
		LIMIT 1
	) AS max_sal
FROM employees;

SELECT
	first_name,
	last_name, 
	salary, 
	(
		SELECT ROUND(AVG(salary))
		FROM employees
		LIMIT 1
	) AS avg_sal
FROM employees;

SELECT 
	first_name,
	last_name,
	salary,
	salary - (
		SELECT ROUND(AVG(salary))
		FROM employees
	) AS sal_diff
FROM employees;

--Subqueries in the WHERE clause
--Select all US coffeeshops
SELECT *
FROM shops
WHERE city_id IN (
	SELECT 
		city_id
	FROM locations
	WHERE country = 'United States'
);

--Select all employees in US coffeeshops
SELECT *
FROM employees
WHERE coffeeshop_id IN (
	SELECT coffeeshop_id
	FROM shops
	WHERE city_id IN (
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
);

--Select all employees who make over 35k and work in US coffeeshops
SELECT *
FROM employees
WHERE coffeeshop_id IN (
	SELECT coffeeshop_id
	FROM shops
	WHERE city_id IN (
		SELECT city_id
		FROM locations
		WHERE country = 'United States'
	)
AND salary > 35000
);

--30 day moving salary sum
SELECT
	hire_date, 
	salary, 
	(
		SELECT
			SUM(salary)
		FROM employees AS e2
		WHERE e2.hire_date BETWEEN e1.hire_date - 30 AND e2.hire_date
	) AS pay_pattern
	FROM employees AS e1
	ORDER BY hire_date;