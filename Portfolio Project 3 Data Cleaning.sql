-- Cleaning Data in SQL Queries
Select*
From portfolioproject.dbo.NashvilleHousing


--Standardize Date Format
Select saledate, CONVERT(date, saledate)
From portfolioproject.dbo.NashvilleHousing

ALTER TABLE portfolioproject.dbo.NashvilleHousing
ADD Sale_Date_Converted_NEW Date

ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP COLUMN Sale_Date_Converted

ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP COLUMN SaleDateConverted 

UPDATE portfolioproject.dbo.NashvilleHousing
SET Sale_Date_Converted_NEW = CONVERT(date, saledate)







--Populate Property Address Data
Select *
From portfolioproject.dbo.NashvilleHousing
where propertyaddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out address into Individual Columns
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Property_Split_Address Nvarchar(255)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Property_Split_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add Property_Split_Address_City Nvarchar(255)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Property_Split_Address_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3)
,Parsename(Replace(OwnerAddress, ',', '.'), 2)
,Parsename(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add Owner_Splt_Address Nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set Owner_Splt_Address = Parsename(Replace(OwnerAddress, ',', '.'), 3)


Alter Table PortfolioProject.dbo.NashvilleHousing
Add Owner_Splt_City Nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set Owner_Splt_City = Parsename(Replace(OwnerAddress, ',', '.'), 2)


Alter Table PortfolioProject.dbo.NashvilleHousing
Add Owner_Splt_State Nvarchar(255)

Update PortfolioProject.dbo.NashvilleHousing
Set Owner_Splt_State = Parsename(Replace(OwnerAddress, ',', '.'), 1)


--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant
, CASE WHEN SoldASVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.NashvilleHousing
	
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldASVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

Select SaleDate, Convert(Date, Saledate)
From PortfolioProject.dbo.NashvilleHousing

Update  PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(Date, Saledate)


--Remove Duplicates


Select *
From PortfolioProject.dbo.NashvilleHousing


WITH ROWNUMCTE AS (
Select*,
ROW_NUMBER() OVER(
    PARTITION BY  ParcelID,
	              Propertyaddress,
		          SalePrice,
				  Saledate,
				  LegalReference
				  Order by
				  UniqueID) as Row_num
From PortfolioProject.dbo.NashvilleHousing
)

Delete 
FROM RowNUMCTE
Where Row_num >1




-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate