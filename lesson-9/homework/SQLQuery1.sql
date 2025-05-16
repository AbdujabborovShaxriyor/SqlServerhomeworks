
CREATE TABLE Employee
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employee (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

--task 1
WITH EmployeeHierarchy AS (
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS Depth
    FROM Employee
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        eh.Depth + 1
    FROM Employee e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY Depth, EmployeeID;




--task 2

DECLARE @max INT = 10;

WITH FactorialCTE (num, factorial) AS (
    SELECT 1 AS num, 1 AS factorial
    UNION ALL
    SELECT num + 1, factorial * (num + 1)
    FROM FactorialCTE
    WHERE num < @max
)
SELECT * FROM FactorialCTE;

--task 3

declare @max int = 10

;with fibonacci_cte(n,fibonacci_current,fib_previous) as(
	select 1,1,0
	union all
	select n+1,fibonacci_current+fib_previous, fibonacci_current
	from fibonacci_cte
	where n<@max
)
SELECT n, fibonacci_current AS fibonacci_number
FROM fibonacci_cte;