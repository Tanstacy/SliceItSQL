CREATE database customer_target;
use customer_target;

create table customer_data(
	customer_name varchar(30),
	customer_id int,
	phone_no int
);
create table product_data(
	product_name varchar(30),
	product_id int,
	price decimal(10,2)
);
create table transaction_data(
	customer_name varchar(30),
	product_name varchar(30),
	transaction_id int,
	transaction_date date,
	quantity int
);

#-----------------alterations------------------
alter table customer_data modify phone_no varchar(15);
alter table product_data modify product_name varchar(50);
alter table transaction_data add constraint fk_customer_name
foreign key (customer_name) references customer_data(customer_name);
CREATE INDEX idx_customer_name on customer_data(customer_name);
DROP INDEX idx_product_name ON transaction_data;
create index idx_rpoduct_name on product_data(product_name);
CREATE INDEX idx_product_name ON transaction_data (product_name);
alter table transaction_data add constraint fk_product_name 
foreign key(product_name)references product_data(product_name);
alter table transaction_data modify transaction_id varchar(30);
alter table transaction_data drop foreign key fk_product_name;
alter table transaction_data modify product_name varchar(100);



 
#----------------------------------------------------------------------

#----------------importing values into tables
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql project b\\customer_datacsv.csv'
into table customer_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql project b\\product_datacsv.csv'
into table product_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql project b\\transaction_data_csvf.csv'
into table transaction_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows
(customer_name,product_name,transaction_id,@transaction_date,quantity)
set transaction_date=str_to_date(@transaction_date,'%d-%m-%Y');

select * from customer_data;
select * from product_data;
select * from transaction_data;

#--------------most selling months---------------
select monthname(transaction_date) as month,count(*) as sales
from transaction_data
group by monthname(transaction_date),month 
order by sales desc;
#------------------Ans:November - 151-------

#---------------popular products--------------------
select product_name,sum(quantity) as total_quantity
from transaction_data
group by product_name
order by total_quantity desc 
limit 10;
#----------------Ans:Ultrasonic Pest Repeller - 44---

#------------------customer spending most
select t.customer_name, sum(p.price *t.quantity) as total_spent
from transaction_data t
join product_data p on t.product_name=p.product_name
group by t.customer_name
order by total_spent desc
limit 10;
#-------------Ans:Jennifer Weaver - 84,04,000-------------


#---------------------------least spending people------------------

SELECT t.customer_name, SUM(p.price * t.quantity) AS Total_Spent
FROM transaction_data t
JOIN product_data p ON t.product_name = p.product_name
GROUP BY t.customer_name
ORDER BY Total_Spent asc
LIMIT 5;
#----------Ans:Infant Josuha - 1,08,000---------

#--------------------------people often buying costly products
select t.customer_name,avg(p.price) as Avg_spent
from transaction_data t
join product_data p on t.product_name=p.product_name
group by customer_name
order by Avg_spent desc
limit 10;
#-------------------Ans:Christopher Johnston - 11,607.45-----
#----------------------people often buying cheaper things
SELECT t.customer_name, AVG(p.price) AS Avg_Price
FROM transaction_data t
JOIN product_data p ON t.product_name = p.product_name
GROUP BY t.customer_name
ORDER BY Avg_Price ASC
LIMIT 5;
#--------------Ans:Mckenzie Howe - 3,863.12-------------------
#--------------------yearly revenue-----------------------
select year(transaction_date) as year,sum(p.price*t.quantity)as total_revenue
from transaction_data t
join product_data p on t.product_name=p.product_name
group by year(transaction_date),year 
order by total_revenue desc 
limit 10;
#-----------------Ans:2017 - 44,076,200--------------

#-------------------------monthly revenue-----------------
select monthname(transaction_date) as month,sum(p.price * t.quantity) as total_revenue
from transaction_data t
join product_data p on t.product_name =p.product_name
group by month(transaction_date),month 
order by total_revenue desc
limit 10;
#---------------Ans:November - 22,560,900

#----------------------------top consumers by quantity consumed-------------------------------
select customer_name, sum(quantity) as total_quantity
from transaction_data
group by customer_name
order by total_quantity desc
limit 10;
#--------------Ans:Paul Hammond - 174---

#-------------------------product generating the most revenue---------------
select p.product_name,sum(p.price * t.quantity) as product_revenue
from transaction_data t
join product_data p on t.product_name = p.product_name
group by p.product_name
order by product_revenue desc 
limit 10;
#----------------Ans:Induction cooktop - 68,82,000

#-------------------product generating minimum revenue------------
select p.product_name, sum(p.price * t.quantity) as product_revenue
from transaction_data t
join product_data p on t.product_name = p.product_name
group by p.product_name
order by product_revenue asc
limit 10;
#-------------Ans:Digital Bluetooth Kitchen Timer - 1,800

#-------------------------------------month specific transactions
select * from transaction_data
where month(transaction_date) in (1,2);

#------------------------------costly products
select distinct product_name,price
from product_data
where price > 50000
order by price desc
limit 10;
#--------------Ans:Smart Tv - 55,000-----------

#------------------------product sold in high quantity in specific month
select distinct product_name,sum(quantity) as total_quantity
from transaction_data
where month(transaction_date) in (10,11)
group by product_name
order by total_quantity desc
limit 20;
#-----------Ans:Ultrasonic Pest Repeller - 22-------------





















