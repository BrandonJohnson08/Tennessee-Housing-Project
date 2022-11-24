--Use [Portfolio Project]

--Seeing Unclean Data

Select * 
From NashvilleHousing


-- Standardize Data Format

Select SaleDate
From NashvilleHousing

Update NashvilleHousing
Set Saledate = Convert (Date,SaleDate) 

Alter Table NashvilleHousing 
Add SalesDateConverted Date; 


Update NashvilleHousing
Set SaleDate = Convert (Date,SaleDate) 

--Once Table Added and Updated I went into the Columns File Deleted the Old Sale Date Column and Renamed the Created File SaleDate
-- I had some problems with Updating the Original Column 


--Populate Property Address Data

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

-- This Query was needed so we could find simlarity between ParcelID and PropertyAddress so we can adjust addresses when they are null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 



Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

--Once Figured out. I updated the address so that there are no more NULLS in Property Address. 
--Now I will go through the process of breking down the addresses into Individual Columns (Address,City,State)

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID





Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) AS Address
From NashvilleHousing


Alter Table NashvilleHousing 
Add StreetAddress Nvarchar(255); 

Update NashvilleHousing
Set StreetAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) 


Alter Table NashvilleHousing 
Add City Nvarchar(255); 


Update NashvilleHousing
Set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))



Select * 
From NashvilleHousing


-- Now you can see the organization of StressAddress and City of each home!!!! Very Appealing the to eye


--Now that we have fixed PropertyAddress We will now make Property Address just as appealing!!!!


Select OwnerAddress 
From NashvilleHousing


Select
PARSENAME (Replace(OwnerAddress,',', '.'), 3),
PARSENAME (Replace(OwnerAddress,',', '.'), 2),
PARSENAME (Replace(OwnerAddress,',', '.'), 1) 
From NashvilleHousing



Alter Table NashvilleHousing 
Add OwnerStreetAddress Nvarchar(255); 

Update NashvilleHousing
Set OwnerStreetAddress = PARSENAME (Replace(OwnerAddress,',', '.'), 3)


Alter Table NashvilleHousing 
Add OwnerCity Nvarchar(255); 


Update NashvilleHousing
Set OwnerCity = PARSENAME (Replace(OwnerAddress,',', '.'), 2)

Alter Table NashvilleHousing 
Add State Nvarchar(255); 

Update NashvilleHousing
Set State = PARSENAME (Replace(OwnerAddress,',', '.'), 1) 


Select *
From NashvilleHousing


--Chaning Yes to "Y" and No to "N"

Select Distinct (SoldasVacant), Count(SoldasVacant)
From  NashvilleHousing
Group by SoldAsVacant
Order By 2

Select SoldasVacant
, Case when SoldasVacant = 'Y' then 'Yes' 
	When SoldasVacant = 'N' then 'No'
	Else SoldasVacant 
	End
From  NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant =
Case when SoldasVacant = 'Y' then 'Yes' 
	When SoldasVacant = 'N' then 'No'
	Else SoldasVacant 
	End
From  NashvilleHousing


--Removing Duplicates

WITH RowNumCTE AS (
Select *,
ROW_NUMBER() Over (
	PARTITION By ParcelId, 
		PropertyAddress, 
		SalePrice, 
		SaleDate, 
		LegalReference
		Order By 
		UniqueID 
		)row_num
		
From NashvilleHousing
) 
Select * 
From RowNumCTE
Where Row_num > 1 
Order by PropertyAddress


--Delete  * 
--From RowNumCTE
--Where Row_num > 1 
--Order by PropertyAddress




Select *
From NashvilleHousing



Alter Table NashvilleHousing
Drop Column OwnerAddress, PropertyAddress




--


Select City, AVG(SalePrice) as AverageHomePrice
From NashvilleHousing
Where City is not null
Order by AverageHomePrice desc


Select *
From NashvilleHousing
Where city like '%unknown%' 


DELETE FROM NashvilleHousing WHERE [UniqueID ] ='46010'


--Views!!

Create View AverageHomePriceTN As
Select AVG(SalePrice) as AverageHomePrice
From NashvilleHousing

Create View AverageHomePricePerCity As
Select City, AVG(SalePrice) as AverageHomePrice
From NashvilleHousing
Where City is not null
Group By City
