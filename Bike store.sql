--create data base
create database bikestore1
drop database if exists bikestore
--use
use bikestore1

--create shemas
--production
create schema production
go
drop schema if exists production

--sales
create schema sales
go

drop schema if exists sales

-- 1 create catagory table into production schema
create table production.catagories(
category_id int identity(1,1) primary key,
category_name varchar(255) not null)
 
 --show
 select *from production.catagories

--insert dta into catagory table
insert into production.catagories(category_name)
values
('children bicycles'),
('comfort bicycles'),
('cruisers  bicycles'),
('cyclocross bicycles'),
('electric bikes'),
('mountain bikes'),
('road bikes')

--2 create brand table in production schema
create table production.brands(
brand_id int identity(1,1) primary key,
brand_name varchar(255) not null)
 
 --show
 select *from production.brands
 --
 drop table if exists production.brands
 --
 --insert values into production.brands table
 insert into production.brands(brand_name)
 values
     ('electra'),
	  ('haro'), 
	  ('heller'), 
	  ('pure cycles'),
	  ('ritchey'),
	  ('strider'), 
	  ('sun bycycles'), 
	  ('surly'),
	  ('trek')
--3
 create table production.products(
 products_id int identity(1,1) primary key,
 products_name varchar (255) not null,
 brand_id int not null,
 category_id int not null,
 model_year smallint not null,
 list_price dec(10,2) not null,
 foreign key(category_id) references production.catagories(category_id) 
 on delete cascade on update cascade, --agar main table me delet or update to refrenced me be dlt update
 foreign key(brand_id) references production.brands(brand_id)
 on delete cascade on update cascade)
--show
select* from production.products

--pull data

bulk insert production.products
from 'C:\Users\sanskriti\Desktop\sql\products.csv'
with(
fieldterminator  = ',',
rowterminator = '\n',
firstrow = 2)

--4 create customers table in sales schema
--pull directly  and apply the requirements on wizard

--5 create  stores table in sales schema
create table sales.stores(
store_id int identity(1,1) primary key,
store_name varchar(255) not null,
phone varchar(25),
email varchar(255),
street varchar(255),
city varchar(255),
state varchar(10),
zip_code varchar(5))

select* from sales.stores
drop table if exists sales.stores

--insert data into sales.stores table
insert into sales.stores(store_name , phone ,email , street , city , state , zip_code)
values('bhopal rockers bikes','(831) 476-4321','bhopalrockers@bikes.shop','3700 VIP drive','bhopal','MP',95060),
('gopal bikes','(516) 379-8888','gopal@bikes.shop','4200 old mall','mumbai','MH',11432),
('rowlett bikes','(972) 530-5555','rowlett@bikes.shop','8000 fairway avenue','gujrat','GU',75088)

--6 create table of production schema
create table production.stocks(
store_id int,
products_id int,
quantity int,
primary key( store_id ,products_id),
foreign key(store_id) references sales.stores(store_id) 
 on delete cascade on update cascade, --agar main table me delet or update to refrenced me be dlt update
 foreign key(products_id) references production.products(products_id)
 on delete cascade on update cascade)
 -- pull data
 bulk insert production.stocks
from 'C:\Users\sanskriti\Desktop\sql\stocks.csv'
with(
fieldterminator  = ',',
rowterminator = '\n',
firstrow = 2)
--show
select*from production.stocks

--7 create table of production schema
create table sales.staffs(
staff_id int identity(1,1) primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(255) not null unique,
phone varchar(25),
active tinyint not null,
store_id int not null,
manager_id int,
foreign key(store_id) references sales.stores(store_id) 
 on delete cascade on update cascade, --agar main table me delet or update to refrenced me be dlt update
 foreign key(manager_id) references sales.staffs(staff_id)
 on delete no action on update no action)

 select*from  sales.staffs
 

 insert into sales.staffs(first_name , last_name , email , phone, active , store_id , manager_id)
 values
 ('abhishek' , 'patil','abhishek.patil@bikes.shop' , '(831) 555-5554' , 1 ,1 ,null),
 ('palak' , 'tiwari','palak.tiwari@bikes.shop' , '(831) 555-5555' , 1 ,1 ,1),
 ('ganesh' , 'sharma','ganesh.sharma@bikes.shop' , '(831) 555-5556',  1 ,1 ,2),
 ('vivek' , 'patel','vivek.patel@bikes.shop' , '(831) 555-5557' , 1 ,1 ,2),
 ('jannette' , 'david','jannette.david@bikes.shop' , '(516) 379-4444' , 1 ,2 ,1),
 ('mahesh' , 'gupta','mahesh.gupta@bikes.shop' , '(516) 379-4445' , 1 ,2 ,5),
 ('vinita' , 'daniel','vinita.daniel@bikes.shop' , '(516) 379-4446' , 1 ,2 ,5),
 ('kapil' , 'vargas','kapil.vargas@bikes.shop' , '(972) 530-5555' , 1 ,3 ,1),
 ('layla' , 'terrell','layla.terrell@bikes.shop' , '(972) 530-5556',  1 ,3 ,7),
 ('bhagat' , 'pal','bhagat.pal@bikes.shop' , '(972) 530-5557' , 1 ,3 ,7)

--8
 create table sales.orders(
 order_id int identity(1,1) primary key ,
 customer_id int ,
 order_status tinyint not null,
 --order status:1 = pending; 2= processing ; 3= rejected ; 4= completed
 order_date date not null,
 required_date date not null,
 shipped_date date,
 store_id int not null,
 staff_id int not null,
 foreign key(customer_id) references sales.customers(customer_id) 
 on delete cascade on update cascade, --agar main table me delet or update to refrenced me be dlt update
 foreign key(store_id) references sales.stores(store_id)
 on delete cascade on update cascade,
 foreign key(staff_id) references sales.staffs(staff_id) 
 on delete no action on update no action) --agar main table me delet or update to refrenced me be dlt update nhi  hoga
 
  select*from sales.orders

--pull dta
bulk insert sales.orders
from 'C:\Users\sanskriti\Desktop\sql\orders.csv'
with(
fieldterminator  = ',',
rowterminator = '\n',
firstrow = 2)
--9 crreate table
 create table sales.order_items (
 order_id int , 
 item_id int , 
 products_id int not null,
 quantity int not null,
 list_price dec(10,2) not null,
 discount dec(4,2) not null default 0,
  primary key(order_id , item_id),
  foreign key(order_id) references sales.orders (order_id) on delete cascade on update cascade,
  foreign key(products_id) references production.products (products_id) on delete cascade on update cascade)

  --pull dta
bulk insert sales.order_items
from 'C:\Users\sanskriti\Desktop\sql\orders_items.csv'
with(
fieldterminator  = ',',
rowterminator = '\n',
firstrow = 2)

  select*from sales.order_items
--drop tables
 
 drop table if exists production.catagories
 drop table if exists sales.order_items

