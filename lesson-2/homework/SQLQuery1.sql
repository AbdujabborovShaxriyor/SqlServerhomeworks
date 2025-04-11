use MyFirstDatabase

--task 1

create table test_identity(
	identity_id int identity(1,1),
	identity_name varchar(100)
)

insert into test_identity
values ('hello'),('bankai'),('tensa zangetsu')

insert into test_identity
values ('nagato'),('hashirama')

select * from test_identity

delete from test_identity

truncate table test_identity

drop table test_identity

--task 2

create table data_types_demo(
	id int primary key identity,
	name1 varchar(100) not null,
	price decimal(10,2),
)

insert into data_types_demo
values ('ichigo',99.99),('ichigo',74.43)

select * from data_types_demo

--task3

create table photoes(
	id int primary key identity,
	photo varbinary(max)
)

insert into photoes(photo)
select 'cover_bleach.jpg', 'ichigo.jpg', 'white_ichigo.jpg', * from openrowset(bulk N'C:\Images',single_blob) as hello;

--task 4

create table student1 (
	classes int not null,
	tuition_per_class decimal (10,2),
	total_tuition as classes*tuition_per_class
)

insert into student1(classes,tuition_per_class)
values (10,1000),(5,100),(8,125)

select * from student1

--task 5

create table worker(
	student_id int primary key identity,
	student_name varchar(100),
	classes int not null,
	tuition_per_class int,
	total_tuition as classes*tuition_per_class
)

bulk insert worker 
from 'C:\Users\user\Downloads\students_data.csv'
with (
	firstrow=1,
	fieldterminator = ',',
	rowterminator ='\n'
)