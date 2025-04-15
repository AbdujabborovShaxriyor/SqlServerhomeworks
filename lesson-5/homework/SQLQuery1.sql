use MyFirstDatabase

create table Employees2(
	EmployeeID  int primary key,
	Name VARCHAR(50),
	Department VARCHAR(50),
	Salary DECIMAL(10,2),
	HireDate DATE
)

INSERT INTO Employees2 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'Alice Johnson', 'HR', 52000.00, '2019-03-15'),
(2, 'Bob Smith', 'IT', 75000.00, '2020-06-01'),
(3, 'Clara Davis', 'Finance', 68000.00, '2018-11-22'),
(4, 'David Wilson', 'Marketing', 60000.00, '2021-01-05'),
(5, 'Eva Brown', 'IT', 80000.00, '2022-04-12'),
(6, 'Frank Taylor', 'Finance', 71000.00, '2017-07-19'),
(7, 'Grace Lee', 'HR', 54000.00, '2020-09-30'),
(8, 'Henry Martin', 'Marketing', 63000.00, '2016-08-14'),
(9, 'Ivy Scott', 'Sales', 58000.00, '2021-12-01'),
(10, 'Jack Turner', 'IT', 85000.00, '2023-02-18'),
(11, 'Karen Phillips', 'Finance', 69000.00, '2019-10-25'),
(12, 'Leo Harris', 'Sales', 62000.00, '2020-03-03'),
(13, 'Mia Clark', 'HR', 50000.00, '2022-06-20'),
(14, 'Nathan Walker', 'Marketing', 64000.00, '2018-05-10'),
(15, 'Olivia Young', 'Finance', 72000.00, '2017-12-29'),
(16, 'Peter Allen', 'IT', 78000.00, '2019-08-11'),
(17, 'Quinn Wright', 'Sales', 61000.00, '2021-07-07'),
(18, 'Rachel King', 'HR', 53000.00, '2023-01-09'),
(19, 'Samuel Green', 'Marketing', 66000.00, '2020-10-15'),
(20, 'Tina Baker', 'Sales', 59000.00, '2016-04-26');

--task 1

select 
	*,
	ROW_NUMBER() over(order by salary desc) as Rank
from Employees

--task2

select 
	*,
	DENSE_RANK() over(order by salary desc) as Same
from Employees

--task3

select * from 
(
	select *, ROW_NUMBER() over( partition by department order by salary desc) as salary_rank from Employees2
)
AS ranked
where salary_rank<=2

--task 4

select * from 
(
	select *,row_number() over(partition by department order by salary ) as salary_rank from Employees2
)
as ranked 
where Salary_rank=1

--task 5

select 
	*,
	sum(salary) over(partition by department order by salary) as running_salary 
from Employees2
	
-- task 6

select 
	*,
	sum(salary) over(partition by department) as running_salary 
from Employees2

-- task 7

select 
	*,
	avg(salary) over(partition by department) as running_salary 
from Employees2

--task 8

select 
	*,
	salary - avg(salary) over(partition by department) as running_salary 
from Employees2

--task 9

select
	*,
	avg(salary) over(order by salary rows between 1 preceding and 1 following ) as moving_avg 
from employees2

-- task 10

select 
	*,
	sum(salary) over() 
from(
	select
	*,
	ROW_NUMBER() over(order by hireDate) as date_hire from employees2
)
as hiring
where date_hire<=3

--task11

select 
	*,
	sum(salary) over(order by salary rows between unbounded preceding and 0 following) 
from(
	select
	*,
	ROW_NUMBER() over(order by hireDate) as date_hire from employees2
)
as hiring

--task 12

select 
	*,
	max(salary) over (order by salary rows between 2 preceding and 2 following) as moving_window 
from Employees2

--task 13

select 
	*,
	cast(
	salary*100 / sum(salary) over (partition by department) 
	as decimal(5,2)
	)  AS percent_of_department_salary
from Employees2


