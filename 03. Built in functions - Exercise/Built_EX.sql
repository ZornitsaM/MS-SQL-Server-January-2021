
USE SoftUni

--PO1
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

--PO2

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'

--PO3

SELECT FirstName FROM Employees
WHERE DepartmentID=3 OR DepartmentID=10 
AND YEAR(HireDate)>=1995 AND YEAR(HireDate)<=2015

--PO4

SELECT FirstName,LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--PO5

SELECT [Name] FROM Towns
WHERE LEN([Name])=5 OR LEN([Name])=6
ORDER BY [Name]

--PO6

SELECT * FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--PO7


SELECT * FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

--PO8

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE YEAR(HireDate)>2000


--PO9

SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName)=5

--PO10


SELECT EmployeeID, FirstName,LastName,Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS 'Rank' FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--PO11


SELECT * 
FROM
(SELECT EmployeeID, FirstName,LastName,Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank FROM Employees
WHERE Salary BETWEEN 10000 AND 50000) AS MyTable
WHERE Rank=2
ORDER BY Salary DESC


--PO12 

USE Geography

SELECT CountryName,IsoCode FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode


--PO13


SELECT PeakName,RiverName, LOWER(CONCAT(PeakName,'',SUBSTRING(RiverName,2,LEN(RiverName)))) AS 'Mix' FROM Peaks, Rivers
WHERE RIGHT(PeakName,1)=LEFT(RiverName,1)
ORDER BY Mix

--PO14

USE Diablo

SELECT TOP(50) [Name],FORMAT(Start,'yyyy-MM-dd') AS Start FROM Games
WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY Start, [Name]

--PO15

SELECT Username, SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)) AS [Email Provider] FROM Users
ORDER BY [Email Provider],Username

--PO16
USE Diablo

SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username


--PO17


SELECT 
Name,

CASE
 WHEN DATEPART(hh,Start)>=0 AND DATEPART(hh,Start) <12  THEN 'Morning'
 WHEN DATEPART(hh,Start)>=12 AND DATEPART(hh,Start) <18  THEN 'Afternoon'
 WHEN DATEPART(hh,Start)>=18 AND DATEPART(hh,Start) <24  THEN 'Evening'
END AS 'Part of the Day',

CASE
 WHEN Duration<=3 THEN 'Extra Short'
 WHEN Duration>=4 and Duration<=6 THEN 'Short'
 WHEN Duration>6 THEN 'Long'
 ELSE 'Extra Long'
END AS 'Duration'

FROM Games
ORDER BY [Name], Duration,'Part of the Day'



--PO18

USE Orders

SELECT ProductName,OrderDate,DATEADD(day,3,OrderDate) AS 'Pay Due', DATEADD(month,1,OrderDate) AS 'Deliver Due' FROM Orders