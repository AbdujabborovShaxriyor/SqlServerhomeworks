use MyFirstDatabase;

-- Task 1

create table student(
	id int ,
	name nvarchar(255) not null,
	age int not null
)

alter table student
add unique(id);

-- Task2

create table my_product(
	product_id  int unique,
	product_name nvarchar(255),
	price decimal
)

alter table my_product
drop constraint UQ__my_produ__47027DF4591BF84E;

alter table my_product
add constraint UQ__first__constraint unique(product_id);


insert into my_product
values(1,'phone',999.9),(1,'pc',1000.99)

alter table my_product
add constraint UQ__second__constraint unique(product_id,product_name)

--Task 3

create table orders (
	order_id int primary key,
	customer_name varchar(100),
	order_date date
)

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'orders' AND CONSTRAINT_TYPE = 'primary key';


alter table orders
drop constraint PK__orders__46596229C67B0DAD;

--Task4

create table category(
	category_id int primary key,
	category_name varchar(100)
)

create table item(
	item_id  int primary key,
	item_name  varchar(100),
	category_id int foreign key references category(category_id)
)


alter table item
add constraint FK__first foreign key (item_id) references category(category_id)

--task 5

create table account (
	account_id int primary key,
	balance  decimal check(balance>=0),
	account_type varchar(100) check(account_type='Saving' or account_type='Checking')
)

alter table account
drop constraint CK__account__account__48CFD27E,CK__account__balance__47DBAE45

alter table account 
add check(balance>=0),check(account_type='Saving' or account_type='Checking')

--task 6

create table customer (
	customer_id int primary key,
	customer_name varchar(100),
	city varchar(100) default 'unknown'
)

alter table customer 
drop constraint DF__customer__city__4D94879B;

alter table customer
add default 'unknown' for city

--task 7

create table invoice (
	invoice_id int identity	,
	amount decimal (10,2)
)

insert into invoice
values(100.0),(99.9),(77.3),(11.2),(87.76)

set identity_insert invoice on;

insert into invoice (invoice_id, amount)
values(100,200.12)

set identity_insert invoice off;

--task 8

create table books(
	book_id int primary key identity,
	title varchar(100) not null,
	price decimal (10,2) check(price>0),
	genre varchar(100) default 'unknown'	
)

insert into books
values('hello world',990.99, 'romantic')

insert into books 
values (997.98,'jsdfh')

--task 9

create table Book(
	book_id int primary key,
	title varchar(100),
	author varchar (100),
	published_year int
)

create table Member1(
	member_id int primary key,
	name varchar(100),
	email varchar(100),
	phone_number varchar(100)
)

create table loan(
	loan_id int primary key identity,
	book_id int foreign key references Book(book_id),
	member_id int foreign key references Member1(member_id),
	loan_date date not null,
	return_date date
)
