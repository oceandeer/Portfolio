SELECT * FROM Portfolio.nashvillehousing;

# standardize date format

SELECT saledate, STR_TO_DATE(saledate,'%Y-%m-%d') 
FROM Portfolio.nashvillehousing1;

Update portfolio.NashvilleHousing1
set SaleDate = STR_TO_DATE(saledate,'%Y-%m-%d');

#populate property address data

SELECT propertyaddress 
FROM Portfolio.nashvillehousing1
#where propertyaddress is null
order by parcelid;

SELECT a.parcelid, a.PropertyAddress, b.parcelid, b.PropertyAddress, ifnull(a.propertyaddress,b.propertyaddress)
FROM Portfolio.nashvillehousing1 a
join Portfolio.nashvillehousing1 b
on a.parcelid=b.parcelid and a.uniqueid <> b.uniqueid
where a.propertyaddress is null; 

#breaking out address into individual columns (address, city,state)

SELECT propertyaddress 
FROM Portfolio.nashvillehousing1;

select substring(propertyaddress,1,charindex (',',propertyaddress)-1) as address,
substring(propertyaddress,charindex (',',propertyaddress)+1,len(propertyaddress))as address
from portfolio.nashvillehousing1;

ALTER TABLE NashvilleHousing
Add propertysplitaddress nvarchar(255);

Update NashvilleHousing
SET propertysplitaddress = substring(propertyaddress,1,charindex (',',propertyaddress)-1);

ALTER TABLE NashvilleHousing
Add propertysplitcity nvarchar(255);

Update NashvilleHousing
SET propertysplitcity = substring(propertyaddress,charindex (',',propertyaddress)+1,len(propertyaddress));

select *
from profolio.nashvillehousing1;

select owneraddress
from portfolio.nashvillehousing1;

select parsename(replace(owneraddress,',','.'),3),
	parsename(replace(owneraddress,',','.'),2),
    parsename(replace(owneraddress,',','.'),1)
from portfolio.nashvillehousing1;

ALTER TABLE NashvilleHousing
Add ownersplitaddress nvarchar(255);

Update NashvilleHousing
SET ownersplitaddress = parsename(replace(owneraddress,',','.'),3);

ALTER TABLE NashvilleHousing
Add ownersplitcity nvarchar(255);

Update NashvilleHousing
SET ownersplitcity = parsename(replace(owneraddress,',','.'),2);

ALTER TABLE NashvilleHousing
Add ownersplitstate nvarchar(255);

Update NashvilleHousing
SET ownersplitstate = parsename(replace(owneraddress,',','.'),1);

#change y and n to yes and no in 'sold as vacant' field

select distinct(soldasvacant), count(soldasvacant)
from portfolio.nashvillehousing1
group by soldasvacant
order by 2;

select soldasvacant, 
	case when soldasvacant='Y' THEN 'Yes'
		when soldasvacant='N' THEN 'No'
        when soldasvacant='0' then 'No'
        when soldasvacant='No' THEN 'No'
        else 'YES'
        end
from portfolio.nashvillehousing1;

update portfolio.nashvillehousing1
set soldasvacant=case when soldasvacant='Y' THEN 'Yes'
		when soldasvacant='N' THEN 'No'
        when soldasvacant='0' then 'No'
        when soldasvacant='No' THEN 'No'
        else 'YES'
        end;

#remove duplicates

select *,
	row_number() over (
    partition by parcelid,
				propertyaddress,
                saleprice,
                saledate,
                legalreference
                order by
                uniqueid
                ) as row_num
from portfolio.nashvillehousing1;

#delete unused columns

select *
from portfolio.nashvillehousing1;

alter table portfolio.nashvillehousing1
drop column taxdistrict;

alter table portfolio.nashvillehousing1
drop column saledate;



