---The advanced sql master class udemy excercises
--- Here i got to analyse data from microsoft AdventureWorks Sample Database

---Exercise 1
SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID

go

---Exercise 2
---Enhance your query from Exercise 1 by adding a derived column called
---"AvgPriceByCategory " that returns the average ListPrice for the product category in each given row.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[AvgPriceByCategory]= AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name])


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID

---Exercise 3
---Enhance your query from Exercise 2 by adding a derived column called
---"AvgPriceByCategoryAndSubcategory" that returns the average ListPrice for the product category AND subcategory in each given row.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[AvgPriceByCategory]= AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name])
,[AvgPriceByCategoryAndSubcategory]= AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name],b.[Name])


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID

GO
---Exercise 4
---Enhance your query from Exercise 3 by adding a derived column called
---"ProductVsCategoryDelta" that returns the result of the following calculation:
---A product's list price, MINUS the average ListPrice for that product’s category.
SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[AvgPriceByCategory]= AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name])
,[AvgPriceByCategoryAndSubcategory]= AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name],b.[Name])
,[ProductVsCategoryDelta]= a.[ListPrice] -AVG(a.[ListPrice]) OVER(PARTITION BY c.[Name])


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID





----ROW_NUMBER /RANKING
---Exercise 1
SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID

---Exercise 2
---Enhance your query from Exercise 1 by adding a derived column called
---"Price Rank " that ranks all records in the dataset by ListPrice,
---in descending order. That is to say, the product with 
---the most expensive price should have a rank of 1, and the product with the
---least expensive price should have a rank equal to the number of records in the dataset.
SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[Price Rank]= ROW_NUMBER() OVER( ORDER BY a.[ListPrice] DESC)

FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID
GO

---Exercise 3
---Enhance your query from Exercise 2 by adding a derived column called
---"Category Price Rank" that ranks all products by ListPrice – within each category
--- in descending order. In other words, every product within a given category should 
---be ranked relative to other products in the same category.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[Price Rank]= ROW_NUMBER() OVER( ORDER BY a.[ListPrice] DESC)
,[Category Price Rank] = ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID
GO

---Exercise 4
---Enhance your query from Exercise 3 by adding a derived column called
---"Top 5 Price In Category" that returns the string “Yes” if a product has one of the top 5
---list prices in its product category, and “No” if it does not. You can try incorporating 
---your logic from Exercise 3 into a CASE statement to make this work.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[Price Rank]= ROW_NUMBER() OVER( ORDER BY a.[ListPrice] DESC)
,[Category Price Rank] = ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)
,[Top 5 Price In Category]= 
CASE 
	WHEN ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)<= 5 THEN 'Yes'
	ELSE  'No'
END
FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID
GO

--RANKING
---Exercise 1
---Using your solution query to Exercise 4 from the ROW_NUMBER exercises as a staring point, add a derived 
---column called “Category Price Rank With Rank” that uses the RANK function to rank all products
---by ListPrice – within each category - in descending order. Observe the differences between the 
---“Category Price Rank” and “Category Price Rank With Rank” fields.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[Price Rank]= ROW_NUMBER() OVER( ORDER BY a.[ListPrice] DESC)
,[Category Price Rank] = ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)
,[Top 5 Price In Category]= 
CASE 
	WHEN ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)<= 5 THEN 'Yes'
	ELSE  'No'
END
,[Category Price Rank With Rank]= RANK () OVER(PARTITION  BY c.[Name] ORDER BY a.[ListPrice] DESC)


FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID
GO

---Exercise 2

---Modify your query from Exercise 2 by adding a derived column called "Category Price Rank With
---Dense Rank" that that uses the DENSE_RANK function to rank all products by ListPrice – within 
---each category - in descending order. Observe the differences among the “Category Price Rank”,
---“Category Price Rank With Rank”, and “Category Price Rank With Dense Rank” fields.

SELECT a.[Name] AS ProductName
,a.[ListPrice]
,b.[Name] AS ProductSubcategory
,c.[Name] AS ProductCategory
,[Price Rank]= ROW_NUMBER() OVER( ORDER BY a.[ListPrice] DESC)
,[Category Price Rank] = ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)
,[Top 5 Price In Category]= 
CASE 
	WHEN ROW_NUMBER() OVER (PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)<= 5 THEN 'Yes'
	ELSE  'No'
END
,[Category Price Rank With Rank]= RANK () OVER(PARTITION  BY c.[Name] ORDER BY a.[ListPrice] DESC)
,[Category Price Rank With Dense Rank]= DENSE_RANK() OVER(PARTITION BY c.[Name] ORDER BY a.[ListPrice] DESC)

FROM Production.Product a
INNER JOIN Production. ProductSubcategory b
	ON a.ProductSubcategoryID = b.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
	on c.ProductCategoryID = b.ProductCategoryID
GO

---USING LEAD LAG
---Create a query with the following columns:
---“PurchaseOrderID” from the Purchasing.PurchaseOrderHeader table
---“OrderDate” from the Purchasing.PurchaseOrderHeader table
---“TotalDue” from the Purchasing.PurchaseOrderHeader table
---“Name” from the Purchasing.Vendor table, which can be aliased as “VendorName”*
---*Join Purchasing.Vendor to Purchasing.PurchaseOrderHeader on BusinessEntityID = VendorID

SELECT 
d.[PurchaseOrderID]
,d.[OrderDate]
,d.[TotalDue]
,e.[Name] as VendorName

FROM Purchasing.PurchaseOrderHeader d
INNER JOIN Purchasing.Vendor e
	ON e.BusinessEntityID = d.VendorID
GO
---Exercise 1
---Apply the following criteria to the query:
---Order must have taken place on or after 2013
---TotalDue must be greater than $500

SELECT 
d.[PurchaseOrderID]
,d.[OrderDate]
,d.[TotalDue]
,e.[Name] as VendorName


FROM Purchasing.PurchaseOrderHeader d
INNER JOIN Purchasing.Vendor e
	ON e.BusinessEntityID = d.VendorID
 WHERE YEAR(OrderDate) >= 2013
	AND TotalDue > 500
GO



---Exercise 2
--Modify your query from Exercise 1 by adding a derived column called
---"PrevOrderFromVendorAmt", that returns the “previous” TotalDue value (relative to the current row)
---within the group of all orders with the same vendor ID. We are defining “previous” based on order date.

SELECT 
d.[PurchaseOrderID]
,d.[OrderDate]
,d.[TotalDue]
,e.[Name] as VendorName
,[PrevOrderFromVendorAmt] = LAG(d.[TotalDue],1) OVER (PARTITION BY d.VendorID ORDER BY d.[OrderDate])


FROM Purchasing.PurchaseOrderHeader d
INNER JOIN Purchasing.Vendor e
	ON e.BusinessEntityID = d.VendorID
WHERE YEAR(OrderDate) >= 2013
	AND TotalDue > 500
GO



---Exercise 3
---Modify your query from Exercise 2 by adding a derived column called
---"NextOrderByEmployeeVendor", that returns the “next” vendor name (the “name” field from Purchasing.Vendor)
---within the group of all orders that have the same EmployeeID value in Purchasing.PurchaseOrderHeader.
---Similar to the last exercise, we are defining “next” based on order date.
SELECT 
d.[PurchaseOrderID]
,d.[OrderDate]
,d.[TotalDue]
,e.[Name] as VendorName
,[PrevOrderFromVendorAmt] = LAG(d.[TotalDue],1) OVER (PARTITION BY d.VendorID ORDER BY d.[OrderDate])
,[NextOrderByEmployeeVendor] = LEAD(e.[Name],1) OVER (PARTITION BY d.EmployeeID ORDER BY d.[PurchaseOrderID])



FROM Purchasing.PurchaseOrderHeader d
INNER JOIN Purchasing.Vendor e
	ON e.BusinessEntityID = d.VendorID
 WHERE YEAR(OrderDate) >= 2013
	AND TotalDue > 500
GO

---Exercise 4
---Modify your query from Exercise 3 by adding a derived column called "Next2OrderByEmployeeVendor" that returns,
---within the group of all orders that have the same EmployeeID, the vendor name offset TWO orders into the “future” 
---relative to the order in the current row. The code should be very similar to Exercise 3, but with an extra argument
---passed to the Window Function used.


SELECT 
d.[PurchaseOrderID]
,d.[OrderDate]
,d.[TotalDue]
,e.[Name] as VendorName
,[PrevOrderFromVendorAmt] = LAG(d.[TotalDue],1) OVER (PARTITION BY d.VendorID ORDER BY d.[OrderDate])
,[NextOrderByEmployeeVendor] = LEAD(e.[Name],1) OVER (PARTITION BY d.EmployeeID ORDER BY d.[PurchaseOrderID])
,[Next2OrderByEmployeeVendor] = LEAD(e.[Name],2) OVER (PARTITION BY d.EmployeeID ORDER BY d.[PurchaseOrderID])


FROM Purchasing.PurchaseOrderHeader d
INNER JOIN Purchasing.Vendor e
	ON e.BusinessEntityID = d.VendorID
 WHERE YEAR(OrderDate) >= 2013
	AND TotalDue > 500
GO


