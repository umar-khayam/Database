create database database_project
use database_project

--User gender
create table usergender
(
id_user_gender int identity(1,1) primary key,
usersex varchar(10) not null
)

--User signup table
create table managersignin
(
usernamefirst varchar(20) not null,
usernamesecond varchar(20) not null,
cnic bigint primary key check (len(cnic)<14),
email varchar(50) not null check (email like '%@%'),
userpassword varchar(100) not null, check (userpassword like '%[0-9]%' and userpassword like '%[A-Z]%' and userpassword like '%[!@#$%a^&*()-_+=.,;:"`~]%' and len(userpassword)>= 8),
mobnumber bigint check (len(mobnumber)<12),
city varchar(20) not null,
dateofbirth date not null,
usergender_id int foreign key references usergender(id_user_gender),
)

--company of mobile table
create table company
(
id int identity(1,1) primary key,
Companyname varchar(30) not null,
)

--mobile is sold or unsold
create table mobile_sold_status
(
id int identity(1,1) primary key,
mobile_sold_status_name varchar(10)
)

--User who want to sell mobile detail table
create table local_seller(
cnic bigint primary key,
name varchar(30) not null,
seller_address varchar(60) not null,
contact_number bigint not null, 
)

---Specification table
---
---ram mobile
create table ram(
ram_id int identity(1,1) primary key,
ram_storage varchar(10))

---rom mobile

create table rom(
rom_id int identity(1,1) primary key,
rom_storage varchar(10))

---front camera

create table front(
front_id int identity(1,1) primary key,
front_camera varchar(10))

---back camera

create table back(
back_id int identity(1,1) primary key,
back_camera varchar(10))

---color mobile

create table color_mobile(
color_id int identity(1,1) primary key,
color_name varchar(20))

---mobile details
create table mobile_details
(
fk_company_id int foreign key references company(id),
mobile_name varchar(20) not null,
serial_no int primary key,
fk_color int foreign key references color_mobile(color_id),
fk_ram_size int foreign key references ram(ram_id),
fk_rom_size int foreign key references rom(rom_id),
fk_front int foreign key references front(front_id),
fk_back int foreign key references back(back_id),
price_mobile money not null,
fk_cnic bigint foreign key references local_seller(cnic),
mobile_order_date datetime not null,
fk_mobile_sold_status int references mobile_sold_status(id)
)

--Mobile sold table
create table mobile_sold
(
mobile_sold_id int identity(1,1) primary key,
mobile_sold_serial int references mobile_details(serial_no),
date_of_sold datetime not null,
)
---admin table sold
create table mobile_imported_sold
(
mobile_sold_id int identity(1,1) primary key,
mobile_sold_serial int references admin_imported_products(imported_serial_no),
date_of_sold datetime not null,
)


--Buyer data
create table imported_buyer
(
buyer_cnic bigint primary key,
buyer_name varchar(30),
buyer_contatc bigint not null,
buyer_address varchar(max),
fk_mobile_sold_id int references mobile_imported_sold(mobile_sold_id),
)

---Table buyer
create table buyer
(
buyer_cnic bigint primary key,
buyer_name varchar(30),
buyer_contatc bigint not null,
buyer_address varchar(max),
fk_mobile_sold_id int references mobile_sold(mobile_sold_id),
)

--Admin products
create table admin_imported_products
(
fk_company_id_admin int foreign key references company(id),
mobile_name varchar(30) not null,
imported_serial_no int primary key,
fk_color int foreign key references color_mobile(color_id),
fk_ram_size int foreign key references ram(ram_id),
fk_rom_size int foreign key references rom(rom_id),
fk_front int foreign key references front(front_id),
fk_back int foreign key references back(back_id),
price_mobile money not null,
date_of_order datetime not null,
fk_mobile_sold_status int references mobile_sold_status(id),
)

---
---
---
---
---Insertion in table
insert into usergender
values
('Male'),
('Female')

insert into company
values
('Iphone'),('Samsung'),('Oppo'),('Nokia'),('Huawei'),('LG'),('QMobile')

insert into mobile_sold_status
values
('sold'),
('Unsold')

insert into ram 
values
('1GB'),
('2GB'),
('3GB'),
('4GB'),
('6GB'),
('8GB'),
('16GB')

insert into rom 
values
('4GB'),
('8GB'),
('16GB'),
('32GB'),
('64GB'),
('128GB'),
('256GB'),
('512GB')

insert into front
values

('1MP'),
('2MP'),
('4MP'),
('6MP'),
('8MP'),
('16MP')

insert into back
values
('4MP'),
('6MP'),
('8MP'),
('16MP'),
('32MP')

insert into color_mobile
values
('Black'),
('White'),
('Light Blue'),
('Red'),
('Light Green'),
('Golden'),
('Silver')

---
---
---
---
---Select query

select * from usergender
select * from managersignin
select * from company
select * from mobile_sold_status
select * from ram
select * from rom
select * from front
select * from back
select * from color_mobile
select * from mobile_sold
select * from mobile_imported_sold
select * from imported_buyer
select * from buyer
select * from local_seller
select * from mobile_details
select * from admin_imported_products

delete from mobile_sold
delete from buyer
delete from mobile_details
delete from admin_imported_products
delete from mobile_imported_sold
delete from imported_buyer
delete from local_seller
delete from managersignin

---
---
---
---
---Store Procedure
---
---Changing status to sold for local_seller_products
---

drop proc for_changing_status
create proc for_changing_status
@serial_no int,
@date date
as begin
select serial_no from mobile_details
update mobile_details
set fk_mobile_sold_status=1
where serial_no=@serial_no
insert into mobile_sold values(@serial_no,@date)
end

---
---Changing status to sold for admin_products
---

create proc for_imported_status
@imported_serial_no int,
@date date
as begin
select imported_serial_no from admin_imported_products
update admin_imported_products
set fk_mobile_sold_status=1
where imported_serial_no=@imported_serial_no
insert into mobile_imported_sold values(@imported_serial_no,@date)
end

---
---proc as view mobile details
---

drop proc mobile_view
create proc mobile_view
as begin
select Companyname,mobile_name,serial_no,color_name,ram_storage,rom_storage,front_camera,back_camera,price_mobile
from mobile_details
join company
on mobile_details.fk_company_id=company.id
join ram 
on ram.ram_id=mobile_details.fk_ram_size
join rom 
on rom.rom_id=mobile_details.fk_rom_size
join color_mobile 
on color_mobile.color_id=mobile_details.fk_color
join front
on front.front_id=mobile_details.fk_front
join back 
on back.back_id=mobile_details.fk_back
where fk_mobile_sold_status=2
end

---
---Admin products view
---

drop proc admin_view_products
create proc admin_view_products
as begin
select Companyname,mobile_name,imported_serial_no,color_name,ram_storage,rom_storage,front_camera,back_camera,price_mobile
from admin_imported_products
join company
on admin_imported_products.fk_company_id_admin=company.id
join ram 
on ram.ram_id=admin_imported_products.fk_ram_size
join rom 
on rom.rom_id=admin_imported_products.fk_rom_size
join color_mobile 
on color_mobile.color_id=admin_imported_products.fk_color
join front
on front.front_id=admin_imported_products.fk_front
join back 
on back.back_id=admin_imported_products.fk_back
where fk_mobile_sold_status=2
end
execute admin_view_products

---
---Buyers_details
---

drop proc buyers_details
create proc buyers_details
as begin
select buyer_name, buyer_address, buyer_cnic, buyer_contatc,Companyname,mobile_name,price_mobile,date_of_sold
from buyer
join mobile_sold
on buyer.fk_mobile_sold_id=mobile_sold.mobile_sold_id
join mobile_details
on mobile_sold.mobile_sold_serial=mobile_details.serial_no
join company
on company.id=mobile_details.fk_company_id
where fk_mobile_sold_status=1
end
execute buyers_details execute  buyers_imported


---
---buyer_imported
---

create proc buyers_imported
as begin
select buyer_name,buyer_address,buyer_cnic, buyer_contatc,Companyname,mobile_name,price_mobile,date_of_sold
from imported_buyer
join mobile_imported_sold
on imported_buyer.fk_mobile_sold_id=mobile_imported_sold.mobile_sold_id
join admin_imported_products
on mobile_imported_sold.mobile_sold_serial=admin_imported_products.imported_serial_no
join company
on company.id=admin_imported_products.fk_company_id_admin
where fk_mobile_sold_status=1
end
drop proc buyers_imported

---
---Seller details
---

create proc seller_details
as begin
select name,seller_address,contact_number,cnic,Companyname,mobile_name,mobile_order_date,price_mobile
from mobile_details
join local_seller
on local_seller.cnic=mobile_details.fk_cnic
join company
on company.id=mobile_details.fk_company_id
end

---
---
---
---
---Triggers 
---Increase in price of 500 after inserting local_seller_mobile
create trigger increas_price
on mobile_details
for insert
as begin 
update mobile_details
set price_mobile=price_mobile+500
end

---
---
---
---
---Constraint
---
---constraint for default gender
---
alter table managersignin
add constraint for_auto_gender
default 1 for usergender_id

---
---constraint for mobile_sold_status
---

alter table mobile_details
add constraint mob_sold_default
default 2 for fk_mobile_sold_status

alter table mobile_details
add constraint mob_front
default 1 for fk_front

alter table mobile_details
add constraint mob_back
default 1 for fk_back

alter table mobile_details
add constraint mob_ram
default 1 for fk_ram_size

alter table mobile_details
add constraint mob_rom
default 1 for fk_rom_size

alter table mobile_details
add constraint mob_back
default 1 for fk_back

alter table mobile_details
add constraint mob_coloor
default 1 for fk_color

---
---Admin products constraint
---

alter table admin_imported_products
add constraint mob_sold_default_admin
default 2 for fk_mobile_sold_status

alter table admin_imported_products
add constraint mob_front_admin
default 1 for fk_front

alter table admin_imported_products
add constraint mob_back_admin
default 1 for fk_back

alter table admin_imported_products
add constraint mob_ram_admin
default 1 for fk_ram_size

alter table admin_imported_products
add constraint mob_rom_admin
default 1 for fk_rom_size

alter table admin_imported_products
add constraint mob_color_admin
default 1 for fk_color


