use seconddb

create table Employees(
	EmployeeID int primary key,
	name varchar(100),
	DepartmentID int foreign key references departments(departmentid),
	salary int not null
)

create table departments(
	DepartmentID int primary key,
	DepartmentName varchar(100)
)

drop table if exists Projects
create table Projects(
	ProjectID int primary key,
	ProjectName varchar(100),
	EmployeeID int foreign key references employees(employeeID)
)

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

select * from Employees

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

select * from departments

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

select * from Projects

--task 1

select employeeId, name, salary,DepartmentName 
from Employees as e
inner join departments as d
on e.Departmentid=d.DepartmentID

--task 2

select employeeId, name, salary,DepartmentName 
from Employees as e
left join departments as d
on e.Departmentid=d.DepartmentID

--task 3.1

select DepartmentName, employeeId, name, salary
from departments as d
left join Employees as e
on e.Departmentid=d.DepartmentID

--task 3.2

select DepartmentName,employeeId, name, salary
from Employees as e
right join departments as d
on e.Departmentid=d.DepartmentID

--task 4

select DepartmentName,employeeId, name, salary
from Employees as e
full outer join departments as d
on e.Departmentid=d.DepartmentID

--task 5

select distinct DepartmentName, sum(salary) over (partition by departmentname)
from Employees as e
left join departments as d
on e.Departmentid=d.DepartmentID
where departmentname is not null

--task 6

select DepartmentName,employeeId, name, salary
from Employees as e
cross join departments as d

--task 7

SELECT 
    e.Name, 
    e.Salary, 
    d.DepartmentName, 
    p.ProjectName
FROM Employees AS e
LEFT JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Projects AS p ON e.EmployeeID = p.EmployeeID;
