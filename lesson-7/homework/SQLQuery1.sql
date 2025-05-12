use lesson7

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

-- Insert sample customers
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Carol White');

-- Insert sample products
INSERT INTO Products (ProductID, ProductName, Category) VALUES
(1, 'Apple Juice', 'Beverages'),
(2, 'Banana', 'Fruits'),
(3, 'Chocolate Bar', 'Snacks'),
(4, 'Milk', 'Dairy'),
(5, 'Bread', 'Bakery');

-- Insert sample orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(101, 1, '2025-05-01'),
(102, 2, '2025-05-02'),
(103, 1, '2025-05-03');

-- Insert sample order details
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) VALUES
(1001, 101, 1, 2, 2.50),  -- 2 Apple Juices
(1002, 101, 3, 1, 1.20),  -- 1 Chocolate Bar
(1003, 102, 2, 6, 0.30),  -- 6 Bananas
(1004, 103, 4, 1, 1.00),  -- 1 Milk
(1005, 103, 5, 2, 1.50);  -- 2 Breads

--task1 

select 
	c.customerName,
	o.orderid,
	o.orderdate
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID

-- task2

select 
	c.customerName
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
where o.OrderID is null

--task3

select 
	p.ProductName,
	o.quantity
from Products as p
left join OrderDetails as o
on p.productid=o.ProductID

--task4


select top 1
	c.customerName,
	count(o.orderid) as NumberOfOrders
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
group by Customername
order by NumberOfOrders desc

--task5

select top 1
	p.productname,
	od.price*od.quantity as Expense
from Products as p 
join OrderDetails as od 
on p.ProductID=od.ProductID
order by Expense desc

--task6

select 
	c.customerName,
	o.orderid,
	max(o.orderdate)
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
group by CustomerName,OrderID

--task 7

select
	c.customerName,
	p.category
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
left join OrderDetails as od
on od.OrderID=o.OrderID
left join Products as p
on p.ProductID=od.ProductID
where p.Category='Electronic'

--task8

select 
	c.customerName,
	p.category
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
left join OrderDetails as od
on od.OrderID=o.OrderID
left join Products as p
on p.ProductID=od.ProductID
where p.Category='Stationery'

--task9

select 
	c.customerName,
	sum(od.price*od.quantity) as SpentMoney
from customers as c
left join orders as o
on c.CustomerID=o.CustomerID
left join OrderDetails as od
on od.OrderID=o.OrderID
group by CustomerName
