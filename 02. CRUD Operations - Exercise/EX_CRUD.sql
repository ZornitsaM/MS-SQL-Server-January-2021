
USE SoftUni

SELECT * FROM Employees
WHERE JobTitle='Sales Representative'

--PO9

SELECT FirstName,LastName,JobTitle FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

--PO10

SELECT FirstName+' '+MiddleName+' '+LastName AS 'Full Name' FROM Employees
WHERE Salary=25000 OR Salary=14000 OR Salary=12500 OR Salary=23600 

--PO11

SELECT FirstName,LastName from Employees
WHERE ManagerID IS NULL

--PO12

SELECT FirstName,LastName,Salary FROM Employees
WHERE Salary>50000
ORDER BY Salary DESC

--PO13

SELECT TOP(5) FirstName,LastName FROM Employees
ORDER BY Salary DESC

--PO14

SELECT FirstName,LastName FROM Employees
WHERE DepartmentID !=4

--PO15

SELECT * FROM Employees
ORDER BY Salary DESC,FirstName ASC,LastName DESC,MiddleName ASC

--PO16
USE SoftUni

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName,LastName,Salary FROM Employees

--PO17

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName+' '+ISNULL(MiddleName,'')+' '+LastName AS [Full Name],JobTitle FROM Employees

--PO18

SELECT DISTINCT JobTitle FROM Employees

--PO19

SELECT TOP(10) ProjectID,[Name],[Description],StartDate,EndDate FROM Projects
ORDER BY StartDate,[Name]


SELECT * FROM Projects

--PO20

SELECT TOP(7) FirstName,LastName,HireDate FROM Employees
ORDER BY HireDate DESC

--PO21

UPDATE Employees
SET Salary+=Salary*0.12
WHERE DepartmentID IN (1,2,4,11)

SELECT Salary FROM Employees

--PO22

USE Geography

SELECT PeakName FROM Peaks
ORDER BY PeakName

--PO23

SELECT TOP(30) CountryName,Population FROM Countries
WHERE ContinentCode='EU'
ORDER BY Population DESC,CountryName

--PO24

SELECT * FROM Countries
SELECT CountryName,CountryCode, IIF(CurrencyCode='EUR','Euro','Not Euro') AS [Currency] FROM Countries
ORDER BY CountryName


--PO25

USE Diablo

SELECT [Name] FROM Characters
ORDER BY [Name]

