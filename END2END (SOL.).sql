--1. List all customers 
	
	SELECT * FROM Customer

--2. List the first name, last name, and city of all customers 

	SELECT FirstName,LastName,City
	FROM Customer

--3. List the customers in Sweden. Remember it is "Sweden" and NOT "sweden" because filtering 
--value is case sensitive in Redshift.

	SELECT * FROM Customer
	WHERE Country = 'Sweden'

--4. Create a copy of Supplier table. Update the city to Sydney for supplier starting with letter P. 

	SELECT * INTO Supplier_copy  FROM Supplier  --COPY TABLE

	
	UPDATE Supplier_copy
	SET CITY = 'Sydney'
	WHERE ContactName LIKE 'P%'

--5. Create a copy of Products table and Delete all products with unit price higher than $50. 

	SELECT * INTO PRODUCT_COPY FROM Product

	SELECT * FROM PRODUCT_COPY

	DELETE FROM PRODUCT_COPY
	WHERE UnitPrice > 50;


--6. List the number of customers in each country 

	SELECT Country,
			COUNT(Country) AS No_Of_Customer
	FROM Customer
	GROUP BY Country

--7. List the number of customers in each country sorted high to low 

	SELECT Country,
			COUNT(Country) AS No_Of_Customer
	FROM Customer
	GROUP BY Country
	ORDER BY No_Of_Customer DESC

--8. List the total amount for items ordered by each customer 
	

	SELECT CONCAT(FirstName,LastName) AS Cust_Name,
			SUM(TotalAmount) as Total_Amount
	FROM Orders O
	LEFT JOIN Customer C
	ON O.CustomerId = C.Id
	GROUP BY  CONCAT(FirstName,LastName)
	
--9. List the number of customers in each country. Only include countries 
--with more than 10 customers. 

	SELECT Country,
			COUNT(Country) AS No_Of_Customer
	FROM Customer
	GROUP BY Country
	HAVING COUNT(Country)  > 10

--10. List the number of customers in each country, except the USA, sorted high to low. Only 
--include countries with 9 or more customers.

	SELECT Country,
			COUNT(Country) AS No_Of_Customer 
	FROM Customer
	WHERE Country <> 'USA'
	GROUP BY Country
	HAVING COUNT(Country)  >= 9

--11. List all customers whose first name or last name contains "ill".  

	SELECT * FROM Customer
	WHERE FirstName LIKE '%ill%'
				or
			lastname LIKE '%ill%';

--12. List all customers whose average of their total order amount is between $1000 and 
--$1200.Limit your output to 5 results.

	SELECT  CONCAT(FirstName,LastName) AS CUST_NAME,
			AVG(TotalAmount) AS AVERAGE_SPEND
	FROM Customer C
	LEFT JOIN Orders O 
	ON C.Id = O.CustomerId
	GROUP BY CONCAT(FirstName,LastName) 
	HAVING AVG(TotalAmount)  BETWEEN 1000 AND 1200

--13. List all suppliers in the 'USA', 'Japan', and 'Germany', ordered by country from A-Z, and then 
--by company name in reverse order.

	SELECT * FROM Supplier_copy
	WHERE Country IN ('USA','Japan','Germany')
	ORDER BY Country ASC , CompanyName DESC

--14. Show all orders, sorted by total amount (the largest amount first), within each year. 

	SELECT *,RANK() OVER(PARTITION by OrderDate ORDER BY TotalAmount desc) as Order_rank
	FROM Orders

--15. Products with UnitPrice greater than 50 are not selling despite promotions. You are asked to 
--discontinue products over $25. Write a query to relfelct this. Do this in the copy of the Product 
--table. DO NOT perform the update operation in the Product table.	

	 SELECT * 
	 FROM  PRODUCT_COPY

	 DELETE PRODUCT_COPY
	 WHERE  UnitPrice > 25
	
--16. List top 10 most expensive products 

	SELECT TOP 10
	 * FROM Product
	ORDER BY UnitPrice DESC

--17. Get all but the 10 most expensive products sorted by price 
	SELECT * FROM
				(		
				SELECT *,
						DENSE_RANK() OVER (ORDER BY UNITPRICE DESC) RANKS
				FROM Product) X
				WHERE RANKS >10

--18. Get the 10th to 15th most expensive products sorted by price 
	SELECT 
	 * FROM Product
	ORDER BY UnitPrice DESC
	OFFSET 9 ROWS  FETCH NEXT 6 ROWS ONLY;


--19. Write a query to get the number of supplier countries. Do not count duplicate values. 

	SELECT  DISTINCT Country,
				COUNT(Country) AS NO_OF_SUPPLIER
	FROM Supplier
	GROUP BY Country

--20. Find the total sales cost in each month of the year 2013. 
	
	SELECT MONTH(OrderDate) AS MONTH,DATENAME(MONTH,OrderDate) AS MONTH_NAME
				,SUM(TotalAmount) AS TOTAL_AMOUNT
	FROM Orders
	WHERE YEAR(OrderDate)= 2013
	GROUP BY MONTH(OrderDate),DATENAME(MONTH,OrderDate) 

--21. List all products with names that start with 'Ca'. 

	SELECT * FROM Product
	WHERE ProductName LIKE 'Ca%'

--22. List all products that start with 'Cha' or 'Chan' and have one more character. 

	SELECT * FROM Product
	WHERE ProductName LIKE 'Cha%'
				or
			ProductName LIKE 'Chan%'

--**23. Your manager notices there are some suppliers without fax numbers. He seeks your help to get 
--a list of suppliers with remark as "No fax number" for suppliers who do not have fax numbers 
--(fax numbers might be null or blank).Also, Fax number should be displayed for customer with fax numbers.

	SELECT * FROM Supplier
		UPDATE Supplier
		SET FAX = 'No fax number'
		WHERE Fax IS NULL


--24. List all orders, their orderDates with product names, quantities, and prices. 

	SELECT *
	FROM Orders O
	LEFT JOIN Product P
	ON O.Id =P.;

--25. List all customers who have not placed any Orders. 

	SELECT *
	FROM Customer C
	LEFT JOIN Orders O
	ON C.Id =O.CustomerId
	WHERE O.Id IS NULL

--26. List suppliers that have no customers in their country, and customers that have no suppliers 
--in their country, and customers and suppliers that are from the same country. 
	
	SELECT FirstName,LastName,C.Country,S.Country,CompanyName
	FROM Customer C
	RIGHT JOIN Supplier S
	ON C.Country = S.Country
	WHERE C.ID IS NULL
			UNION
	SELECT FirstName,LastName,C.Country,S.Country,CompanyName
	FROM Customer C
	LEFT JOIN Supplier S
	ON C.Country =S.Country
	WHERE S.ID IS NULL
			UNION
	SELECT FirstName,LastName,C.Country,S.Country,CompanyName
	FROM Customer C
	INNER JOIN Supplier S
	ON C.Country =S.Country


--27. Match customers that are from the same city and country. That is you are asked to give a list 
--of customers that are from same country and city.  Display firstname, lastname, city and 
--coutntry of such customers. 

SELECT T1.FirstName AS FIRSTNAME1 , T1.LastName AS LASTNAME1,
			T2.FirstName AS FIRSTNAME2 , T2.LastName AS LASTNAME2,
			T1.City AS CITY, T1.Country AS COUNTRY 
FROM Customer T1
INNER JOIN Customer T2
ON T1.Country = T2.COUNTRY
      AND 
	  T1.City = T2.City
WHERE T1.FirstName <> T2.FirstName
				AND
		T1.LastName <> T2.LastName;


--28. List all Suppliers and Customers. Give a Label in a separate column as 'Suppliers' if he is a 
--supplier and 'Customer' if he is a customer accordingly. Also, do not display firstname and 
-- lastname as twoi fields; Display Full name of customer or supplier. 

	SELECT 
    CONCAT(FirstName, ' ', LastName) AS ContactName,
    City,Country,Phone,
    'Customer' AS Type
FROM Customer

UNION ALL

SELECT 
    ContactName,City,Country,Phone,
    'Supplier' AS Type
FROM Supplier;

-- 29. Create a copy of orders table. In this copy table, now add a column city of type varchar (40). 
--Update this city column using the city info in customers table.

	SELECT * INTO ORDERS_COPY FROM Orders

	SELECT * FROM ORDERS_COPY
	
ALTER TABLE ORDERS_COPY
ADD city varchar (40)

	UPDATE OC
	SET OC.ID = C.City
	FROM ORDERS_COPY OC
	JOIN Customer C
	ON C.Id = OC.CustomerId

--30. Suppose you would like to see the last OrderID and the OrderDate for this last order that 
--was shipped to 'Paris'. Along with that information, say you would also like to see the 
--OrderDate for the last order shipped regardless of the Shipping City. In addition to this, you 
--would also like to calculate the difference in days between these two OrderDates that you get. 
--Write a single query which performs this
 
 select * , DATEDIFF(DAY,LastParisOrder,LastOrderDate) as  diff
 from 
	(select  top 1 o.id as ID , OrderDate as LastParisOrder, 
	(select top 1 OrderDate from Orders order by  OrderDate  desc) as LastOrderDate
	from Customer c
	inner join Orders o
	on o.CustomerId = c.Id
	where c.City = 'Paris'
	order by OrderDate desc) x


--31. Find those customer countries who do not have suppliers. This might help you provide 
--better delivery time to customers by adding suppliers to these countires. Use SubQueries.

select distinct Country as coustomer_country_with_no_supplieer from Customer 
where Country not in (select Country from Supplier_copy)

--32. Suppose a company would like to do some targeted marketing where it would contact 
--customers in the country with the fewest number of orders. It is hoped that this targeted 
--marketing will increase the overall sales in the targeted country. You are asked to write a query 
--to get all details of such customers from top 5 countries with fewest numbers of orders. Use 
--Subqueries.

SELECT * FROM Customer
WHERE Country  IN (SELECT TOP 5 Country--,COUNT(Country) AS COUNT_OF_ORDERS
FROM Customer C
LEFT JOIN ORDERS_COPY O
ON C.Id= O.CustomerId
GROUP BY Country
ORDER BY COUNT(Country))

-- 33. Let's say you want report of all distinct "OrderIDs" where the customer did not
-- purchase more than 10% of the average quantity sold for a given product. This way
-- you could review these orders, and possibly contact the customers, to help 
-- determine if there was a reason for the low quantity order. Write a query to report 
-- such orderIDs.
SELECT Distinct o.OrderId
from OrderItem o 
LEFT JOIN (
			 select ProductId, 
			 AVG( CAST(Quantity as float) ) AS [Average Qty for Prod] 
             from OrderItem GROUP BY ProductId
		   ) AS q1 
on o.ProductId = q1.ProductId
WHERE o.Quantity  < q1.[Average Qty for Prod] * 0.1

-- 34. Find Customers whose total orderitem amount is greater than 7500$ for the year 2013. The 
-- total order item amount for 1 order for a customer is calculated using the formula UnitPrice * 
-- Quantity * (1 - Discount). DO NOT consider the total amount column from 'Order' table to 
-- calculate the total orderItem for a customer.

SELECT CustomerId, CONCAT(FirstName, ' ', LastName) AS CUST_NAME,
SUM( UnitPrice * Quantity * (1 - Discount) ) AS TOT_ORD_ITEM_AMT 
FROM Customer AS C
INNER JOIN  Orders AS O
ON C.Id = O.CustomerId
INNER JOIN OrderItem AS OI
ON O.Id = OI.OrderId
WHERE YEAR(OrderDate) = 2013
GROUP BY CustomerId, CONCAT(FirstName, ' ', LastName)
HAVING SUM( UnitPrice * Quantity * (1 - Discount) ) > 7500

-- 35. Display the top two customers, based on the total dollar amount associated with their 
-- orders, per country. The dollar amount is calculated as OI.unitprice * OI.Quantity * (1 -
-- OI.Discount). You might want to perform a query like this so you can reward these customers, 
-- since they buy the most per country. 
-- Please note: if you receive the error message for this question "This type of correlated subquery 
-- pattern is not supported yet", that is totally fine.

SELECT * 
FROM ( 
		SELECT DENSE_RANK() OVER(PARTITION BY Country ORDER BY TOT_ORD_ITEM_AMT DESC) AS RANKS, *
		FROM (
				SELECT CustomerId, CONCAT(FirstName, ' ', LastName) AS CUST_NAME, C.Country,
				SUM( UnitPrice * Quantity * (1 - Discount) ) AS TOT_ORD_ITEM_AMT
				FROM Customer AS C
				INNER JOIN  Orders AS O
				ON C.Id = O.CustomerId
				INNER JOIN OrderItem AS OI
				ON O.Id = OI.OrderId
				GROUP BY CustomerId, CONCAT(FirstName, ' ', LastName), C.Country
			) AS X
	) AS FINAL
WHERE RANKS <= 2

-- 36. Create a View of Products whose unit price is above average Price.


CREATE VIEW  PROD_PRICE_ABOVE_AVERAGE
AS
	SELECT * FROM Product
	WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Product)
		
SELECT * FROM PROD_PRICE_ABOVE_AVERAGE;

-- 37. Write a store procedure that performs the following action:
-- Check if Product_copy table (this is a copy of Product table) is present. If table exists, the 
-- procedure should drop this table first and recreated.
-- Add a column Supplier_name in this copy table. Update this column with that of 
-- 'CompanyName' column from Supplier table.

CREATE PROCEDURE Q37
AS
	if 'PRODUCT_COPY' IN (select TABLE_NAME from  INFORMATION_SCHEMA.TABLES)
	begin 
		drop TABLE PRODUCT_COPY

		select p.*, s.CompanyName into PRODUCT_COPY2
		from Product p 
		LEFT JOIN Supplier s 
		on p.SupplierId = s.Id 
	END

EXEC Q37

SELECT * FROM PRODUCT_COPY2
SELECT * FROM PRODUCT


