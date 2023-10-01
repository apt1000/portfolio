--Standaradize the date format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE;

SELECT SaleDate
FROM NashvilleHousing;

--Private property address data

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT nh1.ParcelID, nh1.PropertyAddress, nh2.ParcelID, nh2.PropertyAddress, ISNULL(nh1.PropertyAddress, nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.UniqueID <> nh2.UniqueID
--WHERE nh1.PropertyAddress IS NULL
ORDER BY nh1.ParcelID;

UPDATE nh1
SET PropertyAddress = ISNULL(nh1.PropertyAddress, nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.UniqueID <> nh2.UniqueID
WHERE nh1.PropertyAddress IS NULL

--Breaking address elements to individual columns

SELECT PropertyAddress
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD address NVARCHAR(50);

ALTER TABLE NashvilleHousing
ADD city NVARCHAR(50);

UPDATE NashvilleHousing
	SET address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) 
UPDATE NashvilleHousing
	SET city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT PropertyAddress, address, city
FROM NashvilleHousing;

SELECT OwnerAddress
FROM NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3), 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerState NVARCHAR(50);

ALTER TABLE NashvilleHousing
ADD OwnerCity NVARCHAR(50);

UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

UPDATE NashvilleHousing
SET OwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

SELECT OwnerAddress, OwnerCity, OwnerState
FROM NashvilleHousing;

--Change Y and N to Yes and No in SoldAsVacant field

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant);

SELECT 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant);

--Remove Duplicate Rows

WITH RowNumCTE AS (
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
				PropertyAddress, 
				SalePrice, 
				SaleDate, 
				LegalReference
				ORDER BY ParcelID) AS row_num
FROM NashvilleHousing)

--DELETE
--FROM RowNumCTE
--WHERE row_num > 1;

SELECT *
FROM RowNumCTE
WHERE row_num > 1;

--Remove Duplicate columns

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress;

SELECT TOP 10 *
FROM NashvilleHousing;