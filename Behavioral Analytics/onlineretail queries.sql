-- Data importing of Online Retail Gift Store  
-- Creating Multiple Tables of different Fields                    
create table sntm(
					serialnum INTEGER NOT NULL UNIQUE PRIMARY KEY,
                     timed time 
                     );
                     
create table sndt(
						serialnum INTEGER NOT NULL UNIQUE PRIMARY KEY,
                        dated date
                    );
                    
create table nonan(
						serialnum INTEGER NOT NULL UNIQUE PRIMARY KEY,
                    invoiceno VARCHAR(255) ,
                    stockcode VARCHAR(255) ,
                    quantity VARCHAR(255) ,
                    unitprice dec(10,2) ,
                    country VARCHAR(255)
                    );
                        

create table desid (
					serialnum INTEGER NOT NULL UNIQUE PRIMARY KEY,
                    customerid varchar(255) not null,
                    description varchar(255) not null
                    );
                    
-- loading data using load data infile statement in all tables 
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nonan.csv"
into table  nonan
FIELDS TERMINATED BY ','
ignore 1 rows;

-- retailonline table is created from combining all fields from tables

create table retailonline as
select desid.serialnum,customerid,description,timed,dated,invoiceno,stockcode,quantity,unitprice,country,quantity_updated 
from desid 
join sntm on desid.serialnum = sntm.serialnum
join sndt on sntm.serialnum = sndt.serialnum
join nonan on sndt.serialnum = nonan.serialnum;

SELECT * FROM onlineretail.retailonline;

-- Certain Values are Found Negative in quantity and unit price columns
-- adding a new Column 'Quantity_updated' based on Absolute function applied on quantity and unit Columns 

alter table  nonan
add column quantity_updated int(10);
update nonan
set quantity_updated = ABS(quantity);

alter table  nonan
add column unitprice_updated int(10);
update nonan
set unitprice_updated = ABS(unitprice);
-- Several Feilds are Found with unitprice = 0 Values
-- unit price 0 can be resolved by using description/stockcode matches

select * from retailonline where unitprice < 0;

-- here neccessary debt payments negative values remove from calculation 

select * from retailonline where unitprice = 0 group by stockcode order by quantity_updated desc;

select * from retailonline where stockcode = '79062D';

-- updating price of 80666num and description RETRO TIN ASHTRAYcommaREVOLUTIONARY, 0.290

update retailonline
set 
		description = 'RETRO TIN ASHTRAYcommaREVOLUTIONARY' , 
        unitprice = 0.290
where serialnum = 80666 and stockcode = '79062D';

select * from retailonline where stockcode = '84826';
update retailonline
set 
        unitprice = 0.850
where serialnum = 502123;

select * from retailonline where stockcode = '23005';
update retailonline
set 
        unitprice = '0.420'
where serialnum in(225530,225531) ;

-- similarly most unitprices are recovered 

delete 
from retailonline
where unitprice <= 0;

-- correct numeric invoiceno of 6 digits

alter table retailonline
add column new invoiceupdated

update retailonline
set 
			invoiceupdated = RIGHT(invoiceno,6);
            
		
-- updated  customer id and description
-- Its not necesary for analysis but can be updated like
 
 Select customerid, invoiceno from retailonline where customerid is null;
 -- copy  adjacent invoiceno 
  Select customerid, invoiceno from retailonline where invoiceno = 536365;
  -- now updating customerid
  update retailonline
  set 
			customerid = 17850
   where invoiceno = 536365;
   
-- update negative unit price 
alter table retailonline
add columns updated_unitprice dec(10,3) ;

update retailonline
set 
			updated_unitprice = ABS(unitprice);
            
alter table retailonline
add columns updated_quantity dec(10,3) ;

update retailonline
set 
			updated_quantity = ABS(quantity);           


-- look for duplicates  no duplicates based on invoiceno

SELECT invoiceno, COUNT(invoiceno)
FROM retailonline
GROUP BY invoiceno
HAVING COUNT(invoiceno) > 1;

-- finding duplicated based on invoiceno and dated

SELECT dated, invoiceno, COUNT(*)
FROM retailonline
GROUP BY invoiceno, dated
HAVING COUNT(*) > 1;

-- add sale price column 

alter table retailonline
add column sales int(10)

update retailonline
set
			sales = updatedquantity * unitpriceupdated
            
-- messed up dates corrected  importing issue

create table retailonlinev1 as
select retailonline.serialnum,customerid,description,timed,sndt.dated,invoiceno,stockcode,quantity,unitprice,country,quantity_updated 
from retailonline 
join sndt on retailonline.serialnum = sndt.serialnum

SELECT * FROM onlineretail.retailonlinev1;

select * from retailonlinev1 where unitprice =0;
 show variables like "secure_file_priv";
 
-- export dataframe in csv format 

TABLE retailonlinev1
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/outputFile.csv'
FIELDS TERMINATED BY ','
optionally enclosed by '"'
escaped by ''
LINES TERMINATED BY '\n';