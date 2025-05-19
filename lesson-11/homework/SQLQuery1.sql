-- Create the table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
);

-- Insert the data
INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'IT', 7000),
(3, 'Charlie', 'Sales', 6000),
(4, 'David', 'HR', 5500),
(5, 'Emma', 'IT', 7200);

--task 1.1
drop table #EmployeeTransfers
create table #EmployeeTransfers(
	EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
)

--task 1.2

select 
	Employees.name,
	case
		when Employees.Department='HR' then 'IT'
		when Employees.Department='IT' then 'Sales'
		when Employees.Department='Sales' then 'HR'
	end as NewDepartment
from Employees

--task 1.3


select 
	Employees.name,
	case
		when Employees.Department='HR' then 'IT'
		when Employees.Department='IT' then 'Sales'
		when Employees.Department='Sales' then 'HR'
	end as NewDepartment
	into #employeetransfers
from Employees

--task 1.4

select * from #EmployeeTransfers

--task 2.1

create table Orders_DB1(
	orderid int primary key,
	customername nvarchar(100),
	product nvarchar(100),
	quantity int not null
)

insert into Orders_DB1
values (101,'Alice','Laptop',1),
(102,'Bob','Phone',2),
(103,'Charlie','Tablet',1),
(104,'David','Monitor',1)

create table Orders_DB2(
	orderid int primary key,
	customername varchar(100),
	product varchar(100),
	quantity int not null
)

insert into Orders_DB2
values (101,'Alice','Laptop',1),
(103,'Charlie','Tablet',1)

;declare @missingOrders table  (
	orderid int primary key,
	customername nvarchar(100),
	product nvarchar(100),
	quantity int not null
)

--task 2.2

insert into @missingOrders
values (101,'Alice','Laptop',1),
(102,'Bob','Phone',2),
(103,'Charlie','Tablet',1),
(104,'David','Monitor',1)

--task 2.3

select o1.orderid,o1.customername,o1.product,o1.quantity from Orders_DB1 as o1
left join Orders_DB2 as o2
on o1.orderid=o2.orderid
where o2.orderid is null

--task 3.1

-- Create the table
CREATE TABLE EmployeeWorkLog (
    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    Department NVARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

-- Insert the data
INSERT INTO EmployeeWorkLog 
(EmployeeID, EmployeeName, Department, WorkDate, HoursWorked)
VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);


create view vw_MonthlyWorkSummary as
select
	EmployeeID,
    EmployeeName,
    Department,
	(select sum(hoursworked) from EmployeeWorkLog as ew2
	where ew2.EmployeeID=ew1.employeeid) as totalhours,
	(select sum(HoursWorked) from EmployeeWorkLog as ew2
	where ew2.Department=ew1.Department) as departmentHours,
	(select avg(HoursWorked) from EmployeeWorkLog as ew2
	where ew2.Department=ew1.Department) as AvgDepartmentHours
from employeeworklog ew1
group by EmployeeID, EmployeeName, Department;

select * from vw_MonthlyWorkSummary


