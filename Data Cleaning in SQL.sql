
---Data Cleaning Using SQL
Select TOP 5 *
From Covid19_Project..NashvilleHousing

---Converting the date Formart
Select SaleDate, Convert(Date,SaleDate)
From Covid19_Project..NashvilleHousing

---Unfortunatly this query is exceuted by not affecting the rows
Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

---So lets try an alternative of Adding a new column


Alter Table NashvilleHousing
Add SaleDateConverted Date;

---So lets add the converted date to the new columns
Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

---Checking to see if the Date was added in the new column
select SaleDateConverted
From Covid19_Project..NashvilleHousing

---Then Dropping the old Date format
--Alter Table NashvilleHousing
--Drop Column SaleDate


---There are some rows where the propertyAddress is null but each property adress corresponds to a unique parcelID
Select  *
From Covid19_Project..NashvilleHousing
---Where PropertyAddress is  null

---So lets join these two columns together and populate the Property Adress
---since these are joined side by side together we can then use isnull to transfer infomation on the property adress where there is null
Select  a.ParcelID,b.PropertyAddress,b.ParcelID,a.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
From Covid19_Project..NashvilleHousing a
JOIN Covid19_Project..NashvilleHousing b
	on a.ParcelID = b.ParcelID and 
	a.[UniqueID ]<>b.[UniqueID ]
	---where PropertyAddress is null

---Then we need to update our PropertyAddress in the original table
Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From Covid19_Project..NashvilleHousing a
JOIN Covid19_Project..NashvilleHousing b
	on a.ParcelID = b.ParcelID and 
	a.[UniqueID ]<>b.[UniqueID ]

---Using substring
Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as location



FROM Covid19_Project..NashvilleHousing

---then we need to update the information on the table 
---WE first need to create new columns
ALTER TABLE Covid19_Project..NashvilleHousing
ADD Address Nvarchar(255);

ALTER TABLE Covid19_Project..NashvilleHousing
ADD Location Nvarchar(255);

--After that we update 
UPDATE  Covid19_Project..NashvilleHousing
SET Address = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

UPDATE  Covid19_Project..NashvilleHousing
SET Location = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

---Or we can use a simple approach of using Parsename and specifying the delimeter
select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as Adress
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)as City
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)as State
from Covid19_Project..NashvilleHousing


---Changing Y and N to yes and no under vacantsold column
---we first need to check the data 
Select distinct(SoldAsVacant), count(SoldAsVacant)
from Covid19_Project..NashvilleHousing
group by SoldAsVacant
order by 2

--Then we change the variables 
Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		END
from Covid19_Project..NashvilleHousing

--Thereafter we can update the SoldasVacant columns
UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		END
from Covid19_Project..NashvilleHousing




---Let remove duplicates rows in our data
--- We first had to create a CTE  so that we can query it and remove the duplicates
WITH RowNumCTE AS(
select*,
ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					LegalReference
					ORDER BY 
						UniqueID) row_num

from Covid19_Project..NashvilleHousing)
---Theb Deleting them after
DELETE
FROM RowNumCTE
WHERE row_num > 1
