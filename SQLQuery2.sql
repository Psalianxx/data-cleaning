--Cleaning Queries
select*
from Portfolioproject..Nashvillehousing
---------------------------------------------------------------------------------------------

--Standardize date format

select SaleDateConverted12, CONVERT(date, SaleDate)
from Portfolioproject..Nashvillehousing
ALter table Nashvillehousing
ADD SaleDateConverted12 date;
update Nashvillehousing
set saleDateConverted12 = CONVERT(date, SaleDate)

---------------------------------------------------------------------------------------------


-- populate Property Address Data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject..Nashvillehousing a
join Portfolioproject..Nashvillehousing b
on a.parcelID = b.ParcelID
And a.UniqueID <> b.[UniqueID ]
where a.PropertyAddress is Null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject..Nashvillehousing a
join Portfolioproject..Nashvillehousing b
on a.parcelID = b.ParcelID
And a.UniqueID <> b.[UniqueID ]
where a.PropertyAddress is Null
---------------------------------------------------------------------------------------------
--Brealing out address into Individual Columns(address,city,state)

select PropertyAddress
from Portfolioproject..Nashvillehousing


select
SUBSTRING(PropertyAddress , 1,CHARINDEX(',' , PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress ,CHARINDEX(',' , PropertyAddress)+1,LEN(propertyAddress)) as city

from Portfolioproject..Nashvillehousing

ALter table Nashvillehousing
ADD PropertySplitAdd nvarchar(255);

update Nashvillehousing
set PropertySplitAdd = SUBSTRING(PropertyAddress , 1,CHARINDEX(',' , PropertyAddress)-1)

ALter table Nashvillehousing
ADD PropertySplitCity nvarchar(255);

update Nashvillehousing
set PropertySplitCity = SUBSTRING(PropertyAddress ,CHARINDEX(',' , PropertyAddress)+1,LEN(propertyAddress)) 

select *
from Portfolioproject..Nashvillehousing
---------------------------------------------------------------------------------------------


--change Y and N to yes adn no in "Sold and Vacant"



select distinct(SoldAsVacant),COUNT(SoldAsVacant)
From Portfolioproject..Nashvillehousing
group by SoldAsVacant
order by 2




select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
		WHEN SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
From Portfolioproject..Nashvillehousing


update Nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		WHEN SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

----------------------------------------------------------------------------------------

-- remove dublicates

with rownumcte as (
select*, 
	ROW_NUMBER()over(
	partition by parcelID,
					propertyaddress,
					saleprice,
					saledate,
					legalreference
					order by 
					uniqueiD
					)row_num
From Portfolioproject..Nashvillehousing
--order by ParcelID
)

select*
From rownumcte
where row_num > 1

---------------------------------------------------------------------------------------------
--- DELETE UNSUED COLUMNS


select *
From Portfolioproject..Nashvillehousing

alter table Portfolioproject..Nashvillehousing
drop column taxdistrict,propertyaddress, saledate

alter table Portfolioproject..Nashvillehousing
drop column  saledate

-----------------------------------------------------------------------------------------------------

