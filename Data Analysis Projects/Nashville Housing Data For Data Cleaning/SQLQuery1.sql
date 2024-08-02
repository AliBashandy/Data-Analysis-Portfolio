SELECT *
FROM nashville_housing_raw;


-- Make a clone table to work on
SELECT * 
INTO dbo.nashville_housing_clone
FROM dbo.nashville_housing_raw
;
--------------------------------------------------------------------------------------------------------------
-- Format the DATE to mm-dd-yyyy --
SELECT SaleDate,
CONVERT(date, SaleDate)
FROM dbo.nashville_housing_clone
;
-- The query below is not updating the table
UPDATE dbo.nashville_housing_clone
SET SaleDate = CONVERT(date, SaleDate)
;
-- After researching i found out the most effwctive way is to us the query below
ALTER TABLE dbo.nashville_housing_clone
ALTER COLUMN SaleDate DATE
;
-----------------------------------------------------------------------------------------------------------------
-- Clean Property and Owner Addresses
---- I Noticed that some Property Address are missing
---- Some ParcelID are duplicated one have property address and one doesnt
---- So what im gonna do is look for same ParcelID and populate the property address using join
SELECT tb1.ParcelID, tb1.PropertyAddress, tb2.PropertyAddress , ISNULL(tb1.PropertyAddress, tb2.PropertyAddress)
FROM 
dbo.nashville_housing_clone AS tb1
JOIN
dbo.nashville_housing_clone AS tb2
ON
tb1.[UniqueID ]<> tb2.[UniqueID ]
AND
tb1.ParcelID = tb2.ParcelID
WHERE tb1.PropertyAddress is NULL

---- Now Lets Update the table
UPDATE tb1
SET PropertyAddress = ISNULL(tb1.PropertyAddress, tb2.PropertyAddress)
FROM 
dbo.nashville_housing_clone AS tb1
JOIN
dbo.nashville_housing_clone AS tb2
ON
tb1.[UniqueID ]<> tb2.[UniqueID ]
AND
tb1.ParcelID = tb2.ParcelID
WHERE tb1.PropertyAddress is NULL

---- Perfect now all done
SELECT *
FROM nashville_housing_clone
WHERE PropertyAddress IS NULL
ORDER BY ParcelID
;
---- Now lets break the address into Address, City, State)
SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1), -- -1 is added to get rid of the comma at the end of the query
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
FROM nashville_housing_clone;

ALTER TABLE dbo.nashville_housing_clone
ADD PropertyCity VARCHAR(255)
;

UPDATE dbo.nashville_housing_clone
SET
PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
;

ALTER TABLE dbo.nashville_housing_clone
ADD PropertyAddressSplit VARCHAR(255)
;

UPDATE dbo.nashville_housing_clone
SET
PropertyAddressSplit = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)
;

SELECT PropertyAddress, PropertyAddressSplit, PropertyCity
FROM nashville_housing_clone;
;

/*
SELECT PropertyAddressSplit,
SUBSTRING(PropertyAddressSplit,1,CHARINDEX(' ', PropertyAddressSplit)), SUBSTRING(PropertyAddressSplit,LEN(SUBSTRING(PropertyAddressSplit,1,CHARINDEX(' ', PropertyAddressSplit)))+1,CHARINDEX(' ', PropertyAddressSplit))
-- -1 is added to get rid of the comma at the end of the query
--SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
FROM nashville_housing_clone;
*/

SELECT 
OwnerAddress, 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM nashville_housing_clone;
;

UPDATE dbo.nashville_housing_clone
SET
OwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
;

ALTER TABLE dbo.nashville_housing_clone
ADD OwnerCity VARCHAR(255)
;

UPDATE dbo.nashville_housing_clone
SET
OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
;

ALTER TABLE dbo.nashville_housing_clone
ADD OwnerState VARCHAR(255)
;

UPDATE dbo.nashville_housing_clone
SET
OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
;

SELECT *
FROM dbo.nashville_housing_clone;

--------------------------------------------------------------------------------
-- Sold As Vacant column
SELECT DISTINCT(SoldAsVacant)
FROM dbo.nashville_housing_clone;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' Then 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END
FROM dbo.nashville_housing_clone;

UPDATE dbo.nashville_housing_clone
SET
SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' Then 'Yes'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END
;

SELECT DISTINCT(SoldAsVacant)
FROM dbo.nashville_housing_clone;
---- Now all even 'Yes' or 'No'
------------------------------------------------------------------

-- Delete Duplicates

WITH duplicate_checker AS(
SELECT *, ROW_NUMBER()OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, LegalReference ORDER BY ParcelID) AS row_num 
FROM dbo.nashville_housing_clone
)
SELECT *
FROM duplicate_checker
WHERE row_num > 1
ORDER BY ParcelID
;
-- There Are 104 duplicate rows
-- This will delete the duplicate rows in the database table
WITH duplicate_checker AS(
							SELECT *, ROW_NUMBER()OVER(PARTITION BY ParcelID, 
										PropertyAddress, 
										SaleDate, 
										LegalReference 
										ORDER BY ParcelID
										) AS row_num 
							FROM dbo.nashville_housing_clone
						)
DELETE
FROM duplicate_checker
WHERE row_num > 1
;
----------------------------------------------------------------------------------------------------------------------------

