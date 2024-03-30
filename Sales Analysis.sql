/*

Cleaning Data in SQL Queries

*/
select * 
from Nashville



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate
from Nashville

--update Nashville
--set SaleDate=CONVERT(date,SaleDate) 


-- If it doesn't Update properly
--Alter table Nashville
--Alter COLUMN SaleDate Date;

select SaleDate
from Nashville

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
Select *
From Nashville
Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a
join Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a
join Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Select *
From Nashville
order by ParcelID

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Nashville
order by ParcelID

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address,
		SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,1000) City
From Nashville

Select LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1) Address,
		Right(PropertyAddress,LEN(PropertyAddress)- CHARINDEX(',',PropertyAddress)) City
From Nashville

ALTER TABLE Nashville
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville
SET PropertySplitAddress = LEFT(PropertyAddress,CHARINDEX(',',PropertyAddress)-1)

Update Nashville
SET PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,100)


Select PropertyAddress, PropertySplitAddress ,PropertySplitCity
From Nashville
order by ParcelID

Select OwnerAddress
From Nashville
order by ParcelID

Select PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville
order by ParcelID



ALTER TABLE Nashville
Add OwnerSplitAddress Nvarchar(255);


ALTER TABLE Nashville
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE Nashville
Add OwnerSplitState Nvarchar(255);


Update Nashville
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select OwnerAddress,OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
From Nashville
order by ParcelID



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant, 
CASE When SoldAsVacant = 'y' Then 'Yes'
When SoldAsVacant ='n' Then 'No'
ELSE SoldAsVacant 
END newSoldAsVacant 
From Nashville
order by ParcelID

Update Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'y' Then 'Yes'
When SoldAsVacant ='n' Then 'No'
ELSE SoldAsVacant 
END

Select SoldAsVacant
From Nashville
WHERE SoldAsVacant='y' or SoldAsVacant='n'
order by ParcelID

Select SoldAsVacant
From Nashville
order by SoldAsVacant

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference,
				 OwnerName,
				 OwnerAddress
				 ORDER BY
					UniqueID
					) row_num

From Nashville
)
--DELETE 
Select *
From RowNumCTE
--Where row_num > 1
Order by PropertyAddress



Select *
From Nashville






---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
INTO #TempTable
FROM Nashville;


Select *
FROM #TempTable

ALTER TABLE #TempTable
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
FROM #TempTable

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
















