/*
[API Pagination: Making Billions of Products Scrolling Possible](https://youtu.be/14K_a2kKTxU?si=LNH4dpMutkxRF1bu)
[SQL Server 2012 ：分頁處理：認識 OFFSET 和 FETCH 子句](https://sharedderrick.blogspot.com/2012/06/t-sql-offset-fetch.html)

https://learn.microsoft.com/sql/t-sql/queries/select-order-by-clause-transact-sql#syntax
https://learn.microsoft.com/sql/t-sql/functions/rand-transact-sql

----------------------------------------

ORDER BY order_by_expression
    [ COLLATE collation_name ]
    [ ASC | DESC ]
    [ , ...n ]
[ <offset_fetch> ]

<offset_fetch> ::=
{
    OFFSET { integer_constant | offset_row_count_expression } { ROW | ROWS }
    [
      FETCH { FIRST | NEXT } { integer_constant | fetch_row_count_expression } { ROW | ROWS } ONLY
    ]
}
*/

-- 查詢資料表的內容
SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders];
GO

-- 使用 TOP 子句：查詢最近的 50 筆訂單記錄
SELECT TOP 50 OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC;
GO

-- 使用 OFFSET 和 FETCH 子句：查詢最近的 50 筆訂單記錄
SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC
	OFFSET 0 ROWS
	FETCH FIRST 50 ROWS ONLY;
GO

-- 使用 OFFSET 和 FETCH 子句：依據日期排序，但是跳過前 10 筆資料列
SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC
	OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
GO
-- 使用 OFFSET 和 FETCH 子句：依據日期排序，但是跳過前 10 筆資料列
SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC;
GO

-- 使用 OFFSET 和 FETCH
-- 依據日期排序，但是跳過前 10 筆資料列，再取 10 筆資料列；也就是說：依據日期排序，但僅查詢第 11 到 20 筆的資料列。
DECLARE @OFFSET tinyint =10, @FETCH tinyint =10

SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC
	OFFSET @OFFSET ROWS
	FETCH NEXT @FETCH ROWS ONLY;
GO

-- 使用 ROW_NUMBER() 函數
-- 傳回結果集資料分割內某資料列的序號，序號從 1 開始，每個資料分割第一個資料列的序號是 1。
DECLARE @begin tinyint =11, @end tinyint =20

SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM
(
	SELECT ROW_NUMBER() OVER (ORDER BY OrderDate DESC) rid, OrderID, CustomerID, EmployeeID, OrderDate
	FROM [Northwind].[dbo].[Orders]
) rktb
WHERE rid BETWEEN @begin AND @end
GO

-- 依據日期排序，跳過前 10 筆資料列，利用亂數 RAND() 函數，隨機查詢前 0 ~ 99 筆資料列。
DECLARE @OFFSET tinyint =10

SELECT OrderID, CustomerID, EmployeeID, OrderDate
FROM [Northwind].[dbo].[Orders]
ORDER BY OrderDate DESC
	OFFSET @OFFSET ROWS
	FETCH NEXT (SELECT CAST(RAND()*100 AS tinyint)) ROWS ONLY;
GO
