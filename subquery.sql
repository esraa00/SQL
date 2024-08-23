-- **subquery: sql query placed inside sql query

-- Q: find employees who's salary is more than the average salary earned by all the employees

-- first: break the query into a few parts
-- 1. find the average salary earned by all the employees
-- 2. filter the employee who salary above that average

SELECT AVG(salary) FROM employees; -- =5791, aggregate functions will return one row

SELECT *
FROM employees
WHERE salary > 5791 -- replace the number with the query :)

-- scalar subquery
SELECT * --outer query
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees) -- subquery/inner query

-- to use the subquery with the where clause:
-- the join clause will return the returned value from subquery as a separate table
-- question: what is the default name of the table returned from the subquery?
-- scalar subquery
SELECT e.*
FROM employees e
JOIN (SELECT AVG(salary) as average_salary FROM employees) salary
on e.salary > salary.average_salary

-- different types of subqueries:
-- 1. Scalar subquery
-- 2. Multiple row subquery
-- 3. Correlated subquery

-- Scalar subquery: subquery which returns one row and one column

-- Multiple row subquery:
-- 1. subquery which returns multiple columns and multiple rows
-- 2. subquery which returns one columns and multiple rows

-- Q: find the employees who earn the highest salary in each department
-- first: break the query into a few parts:
-- 1. find the highest salary in each department
-- 2. filter the employee who earn the highest salary in each department
SELECT dept_name, MAX(salary) as max_salary
FROM test.employees
GROUP BY dept_name
-- multiple row, multiple column
SELECT e.emp_name, e.salary
FROM test.employees as e
JOIN ( SELECT dept_name, MAX(salary) as max_salary
FROM test.employees
GROUP BY dept_name ) as max_salaries
ON e.dept_name = max_salaries.dept_name AND e.salary = max_salaries.max_salary
-- multiple row, multiple column
SELECT *
FROM employees
WHERE (dept_name, salary) in (SELECT dept_name, MAX(salary) as max_salary
FROM test.employees
GROUP BY dept_name )

-- multiple rows, one column
-- Q: find department who do not have any employees
SELECT dept_name
FROM department
WHERE dept_name not in (
  SELECT DISTINCT dept_name FROM employees
)
