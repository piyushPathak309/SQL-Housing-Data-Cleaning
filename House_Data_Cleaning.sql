--Overall data Structure
select 
  * 
from 
  Nashville_Housing;
  
select 
  count(*) 
from 
  [dbo].[Nashville_Housing]; -- Total 56477 records

--First Requiremnet Standardize SaleDate Format Means Converting From Datetime Format To Date Format
select 
  SaleDate 
from 
  [dbo].[Nashville_Housing];


select 
  case when SaleDate is null then 'Null Values' else SaleDate end as Sale_Dat_Col 
from 
  [dbo].[Nashville_Housing];				

select 
  count(SaleDate) 
from 
  Nashville_Housing --No any Null Values In Date Column
select 
  Sale_Dat_Converted, 
  cast(SaleDate as Date) as Sal_Dat_Colm 
from 
  Nashville_Housing;


update 
  Nashville_Housing 
set 
  SaleDate = cast(SaleDate as Date);

alter table 
  [dbo].[Nashville_Housing] 
add 
  Sale_Dat_Converted Date;

update 
  Nashville_Housing 
set 
  Sale_Dat_Converted = cast(SaleDate as Date);
--Second Requiremnet Populate Property Address Data

select 
  PropertyAddress 
from 
  [dbo].[Nashville_Housing] 
where 
  PropertyAddress is null;  --Means Total 29 Null Values Means Only 56448 Values Available

select 
  count(distinct PropertyAddress) 
from 
  [Nashville_Housing];

select 
  count(PropertyAddress) 
from 
  [Nashville_Housing];

select 
  PropertyAddress 
from 
  [Nashville_Housing]

--Replace these Null values with 'Unknown'
Update 
  Nashville_Housing 
set 
  PropertyAddress = case when PropertyAddress is null then 'Unknown' else PropertyAddress end;
--Updated All Null Values

--Third Requiremnet Breaking Out Address Into Individual Columns (Address, City, State)
select 
  PropertyAddress 
from 
  Nashville_Housing;

select
  SUBSTRING(
    PropertyAddress, 
    1, 
    CHARINDEX(',', PropertyAddress)
  ) as Address, 
  SUBSTRING(
    PropertyAddress, 
    CHARINDEX(',', PropertyAddress)+ 1, 
    LEN(PropertyAddress)
  ) as City 
from 
  Nashville_Housing;

Alter table 
  Nashville_Housing 
add 
  PropertySplitAddress varchar(170);  --Add An Empty Col named PropertySplitAddress In Table

select 
  * 
from 
  Nashville_Housing;

update 
  Nashville_Housing 
set 
  PropertySplitAddress = SUBSTRING(
    PropertyAddress, 
    1, 
    CHARINDEX(',', PropertyAddress) -- Assigning Values in col which created above
    ) 

Alter table 
  Nashville_Housing 
add 
  PropertySplitCity varchar(60);  --Add An Empty Col named PropertySplitCity In Table
update 
  Nashville_Housing 
set 
  PropertySplitCity = SUBSTRING(
    PropertyAddress, 
    CHARINDEX(',', PropertyAddress)+ 1, 
    LEN(PropertyAddress) -- Assigning Values in col which created above
    )

--Fourth Requiremnet Breaking Out OwnerAddress Into Individual Columns (Address, City, State)
--But this time we will not do with substring will do with parsename function
select 
  OwnerAddress 
from 
  Nashville_Housing 
where 
  OwnerAddress is not null;

select 
  parsename(
    replace(OwnerAddress, ',', '.'), 
    3
  ) as City, 
  -- parsename Will Split The data from backside of string means in reverse form
  parsename(
    replace(OwnerAddress, ',', '.'), 
    2
  ) as Adress, 
  parsename(
    replace(OwnerAddress, ',', '.'), 
    1
  ) as State 
from 
  Nashville_Housing;

Alter table 
  Nashville_Housing 
add 
  City varchar(170);
--Add An Empty Col named City In Table

update 
  Nashville_Housing 
set 
  City = parsename(
    replace(OwnerAddress, ',', '.'), 
    3
  ) -- Assigning Values in col which created above

Alter table 
  Nashville_Housing 
add 
  Adress varchar(60);
--Add An Empty Col named Adress  In Table
update 
  Nashville_Housing 
set 
  Adress = parsename(
    replace(OwnerAddress, ',', '.'), 
    2
  );

--Assigning Values in col which created above
Alter table 
  Nashville_Housing 
add 
  State varchar(60);
--Add An Empty Col named State  In Table
update 
  Nashville_Housing 
set 
  State = parsename(
    replace(OwnerAddress, ',', '.'), 
    1
  );

-- Change Y and N to Yes and No in SoldasVacant

select 
  distinct SoldAsVacant, 
  Count(SoldAsVacant) 
from 
  Nashville_Housing 
group by 
  SoldAsVacant 
order by 
  2;

select 
  SoldAsVacant, 
  case when SoldAsVacant = 'Y' then 'Yes' when SoldAsVacant = 'N' then 'No' else SoldAsVacant end 
from 
  Nashville_Housing;

update 
  Nashville_Housing 
set 
  SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' when SoldAsVacant = 'N' then 'No' else SoldAsVacant end 
from 
  Nashville_Housing;

--Fifth Requiremnet Remove Duplicates Records


with cte1 as (
  select 
    * 
  from 
    (
      select 
        n.*, 
        ROW_NUMBER() over(
          partition by ParcelId, 
          PropertyAddress, 
          SalePrice, 
          SaleDate, 
          LegalReference 
          order by 
            UniqueId
        ) as rn 
      from 
        Nashville_Housing as n
    ) as x 
  where 
    x.rn = 1
) 
select 
  * 
from 
  cte1;
 --Delete from cte1;

--Sixth Requiremnet Remove Duplicates Columns


select 
  * 
from 
  Nashville_Housing;

alter table 
  Nashville_Housing 
drop 
  column OwnerAddress, 
  PropertyAddress ;

alter table 
  Nashville_Housing 
drop 
  column Taxdistrict, 
  SaleDate;

select 
  count(1) 
from 
  Nashville_Housing -- Now After cleaning whole we left only 56374



  


