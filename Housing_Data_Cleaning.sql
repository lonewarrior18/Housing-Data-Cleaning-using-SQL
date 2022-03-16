create database portfolio;
use portfolio;
show tables;
delete from housing_data;

select count(*) from housing_data;  #total records in table

select * from housing_data limit 10;

select parcelid, Propertyaddress
from housing_data
group by parcelid;

select data1.parcelid, data1.propertyaddress, data2.parcelid, data2.propertyaddress
from housing_data data1 join housing_data data2
on data1.parcelid = data2.parcelid
and data1.uniqueid <> data2.uniqueid;

update housing_data h1 join
housing_data h2 on h1.parcelid = h2.parcelid
and h1.uniqueid <> h2.uniqueid
set h1.propertyaddress = h2.propertyaddress where h1.parcelid = h2.parcelid and h1.propertyaddress = 'null';

select * from housing_data;

select propertyaddress, substring(propertyaddress,1, position(',' in propertyaddress)-1) as address,
substring(propertyaddress, position(',' in propertyaddress)+1, char_length(propertyaddress)) as state
from housing_data;

alter table housing_data
add propertysplitaddress varchar(255);

update housing_data
set propertysplitaddress = substring(propertyaddress,1, position(',' in propertyaddress)-1);

alter table housing_data
add propertysplitcity varchar(255);

update housing_data
set propertysplitcity = substring(propertyaddress, position(',' in propertyaddress)+1, char_length(propertyaddress));

alter table housing_data
add ownersplitaddress varchar(255);

update housing_data
set ownersplitaddress = substring(owneraddress,1, position(',' in owneraddress)-1);

alter table housing_data
add ownersplitfurther varchar(255);

update housing_data
set ownersplitfurther = substring(owneraddress, position(',' in owneraddress)+1, char_length(owneraddress));

alter table housing_data
add ownersplitcity varchar(255),
add ownersplitstate varchar(255);

update housing_data
set ownersplitcity = substring(ownersplitfurther,1, position(',' in ownersplitfurther)-1);

update housing_data
set ownersplitstate = substring(ownersplitfurther, position(',' in ownersplitfurther)+1, char_length(ownersplitfurther));

select * from housing_data limit 10;

alter table housing_data
drop propertyaddress,
drop owneraddress,
drop ownersplitfurther;

select distinct(soldasvacant), count(soldasvacant)
from housing_data
group by soldasvacant;

UPDATE housing_data SET soldasvacant =  
CASE
WHEN soldasvacant = 'Y' THEN 'Yes'
WHEN soldasvacant = 'N' THEN 'No'
else soldasvacant
end;


select soldasvacant,
	case when soldasvacant = 'Y' then soldasvacant = 'Yes'
		when soldasvacant = 'N' then soldasvacant = 'No'
		else soldasvacant
		end as soldasvac
from housing_data
where soldasvacant = 'N';


delete from housing_data 
where uniqueid in (select uniqueid from (select *, row_number() over (
partition by parcelid,
			 propertysplitaddress,
             saleprice,
             saledate,
             legalreference
             order by uniqueid
             )  row_num
from housing_data) t1
where row_num > 1);

select * from (select *, row_number() over (
partition by parcelid,
			 propertysplitaddress,
             saleprice,
             saledate,
             legalreference
             order by uniqueid
             )  row_num
from housing_data) t1
where row_num > 1;

alter table housing_data
drop taxdistrict,
drop saledate;

select * from housing_data limit 10;
