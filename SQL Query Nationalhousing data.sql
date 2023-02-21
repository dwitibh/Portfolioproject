SELECT *
FROM sqlPortfolioProject.dbo.Nationalhousing


--changing date to standard format


SELECT Saledateconverted ,convert(date,saledate)
FROM sqlPortfolioProject.dbo.Nationalhousing

update Nationalhousing
SET saledate= convert(date,saledate)

Alter table Nationalhousing
Add Saledateconverted Date 

update Nationalhousing
SET Saledateconverted= convert(date,saledate)

--Populate property Address data


SELECT *
FROM sqlPortfolioProject.dbo.Nationalhousing
--where PropertyAddress is null
Order By parcelId

SELECT a.parcelId,a.propertyAddress,b.parcelId,b.propertyAddress,a.UniqueID,b.uniqueId,ISNULL(a.propertyAddress,b.propertyAddress)
FROM sqlPortfolioProject.dbo.Nationalhousing a
JOIN sqlPortfolioProject.dbo.Nationalhousing b
ON a.parcelId=b.parcelId
AND a.UniqueID<> b.UniqueID
Where a.propertyAddress is null

Update a
SET PropertyAddress= ISNULL(a.propertyAddress,b.propertyAddress)
FROM sqlPortfolioProject.dbo.Nationalhousing a
JOIN sqlPortfolioProject.dbo.Nationalhousing b
ON a.parcelId=b.parcelId
AND a.UniqueID<> b.UniqueID
Where a.propertyAddress is null


--saprete adress in to Address,city,state


SELECT PropertyAddress
FROM sqlPortfolioProject.dbo.Nationalhousing

SELECT 
substring(propertyAddress,1,CHARINDEX(',',propertyAddress)-1)as Address,
substring(propertyAddress,CHARINDEX (',',propertyAddress)+1,LEN(propertyAddress)) as Address
FROM sqlPortfolioProject.dbo.Nationalhousing

Alter table Nationalhousing
Add PropertysplitAddress nvarchar(255)

update Nationalhousing
SET PropertysplitAddress= substring(propertyAddress,1,CHARINDEX(',',propertyAddress)-1)

Alter table Nationalhousing
Add Propertysplitcity nvarchar(255)

update Nationalhousing
SET Propertysplitcity= substring(propertyAddress,CHARINDEX (',',propertyAddress)+1,LEN(propertyAddress))

Select *
From sqlPortfolioProject.dbo.nationalhousing



Select owneraddress
From sqlPortfolioProject.dbo.nationalhousing

Select PARSENAME(Replace(owneraddress,',','.'),3),
PARSENAME(Replace(owneraddress,',','.'),2),
PARSENAME(Replace(owneraddress,',','.'),1)
From sqlPortfolioProject.dbo.nationalhousing

Alter table Nationalhousing
Add OwnersplitAddress nvarchar(255)

update Nationalhousing
SET OwnersplitAddress= PARSENAME(Replace(owneraddress,',','.'),3)

Alter table Nationalhousing
Add OwnersplitCity nvarchar(255)

update Nationalhousing
SET OwnersplitCity= PARSENAME(Replace(owneraddress,',','.'),2)


Alter table Nationalhousing
Add OwnersplitState nvarchar(255)

update Nationalhousing
SET OwnersplitState= PARSENAME(Replace(owneraddress,',','.'),1)

select *
From sqlPortfolioProject.dbo.nationalhousing


--symetric colume slodvacant by yes and No instead (y,n,yes,No)


select Distinct(SoldAsVacant),count(SoldAsVacant)
From sqlPortfolioProject.dbo.nationalhousing
Group by SoldAsVacant
Order by 2


select SoldAsVacant,
Case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
Else SoldAsVacant
End
From sqlPortfolioProject.dbo.nationalhousing


update nationalhousing
Set SoldAsVacant=Case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
Else SoldAsVacant
End

select Distinct(SoldAsVacant),count(SoldAsVacant)
From sqlPortfolioProject.dbo.nationalhousing
Group by SoldAsVacant
Order by 2


--remove duplicate
--if parcel id,property adress,saledate,legalrefrence all are same then its duplicate data here

with Row_numCTE
as 
(select *,
ROW_NUMBER() over (
Partition by ParcelID,
            propertyAddress,
			saleprice,
			saledate,
			LegalReference
			order by uniqueID)row_num





From sqlPortfolioProject.dbo.nationalhousing
--order by parcelid
)


Select *
from Row_numCTE
where row_num>1
order by propertyaddress

--delete colums

select *
From sqlPortfolioProject.dbo.Nationalhousing

alter table sqlPortfolioProject.dbo.Nationalhousing
drop column SaleDate

