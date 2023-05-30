
--PO1

USE SoftUni

CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS
   SELECT FirstName,LastName FROM Employees
   WHERE Salary>35000
GO

EXEC dbo.sp_GetEmployeesSalaryAbove35000

--PO2

CREATE PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18,4)
AS
  SELECT FirstName,LastName FROM Employees
  WHERE Salary>=@Number

--PO3

  CREATE PROC usp_GetTownsStartingWith (@Word NVARCHAR(50))
  AS
   SELECT Name AS Town FROM Towns
   WHERE LEFT(Name,LEN(@Word))=@Word

  GO

  EXEC usp_GetTownsStartingWith 'b'

--PO4

  CREATE PROC usp_GetEmployeesFromTown (@Name NVARCHAR(100))
  AS
  SELECT e.FirstName,e.LastName FROM Employees e
  JOIN Addresses a ON e.AddressID=a.AddressID
  JOIN Towns t ON t.TownID=a.TownID
  WHERE t.Name=@Name
  ORDER BY e.EmployeeID

--PO5

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(15)
AS
BEGIN
     
  IF(@salary<30000)
    RETURN 'Low'
  ELSE IF(@salary BETWEEN 30000 AND 50000)
    RETURN 'Average'

	RETURN 'High'
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) as 'Salary Level' FROM Employees

--PO6

CREATE PROC usp_EmployeesBySalaryLevel (@Level VARCHAR(15))
AS
   SELECT FirstName,LastName FROM Employees
   WHERE dbo.ufn_GetSalaryLevel(Salary)=@Level

 GO

EXEC usp_EmployeesBySalaryLevel 'low'

--PO7

CREATE FUNCTION ufn_IsWordComprised (@setOfLetters VARCHAR(100), @word VARCHAR(100))
RETURNS BIT
BEGIN
  DECLARE @count INT=1;
  WHILE(@count<=LEN(@word))
  BEGIN
    DECLARE @current CHAR(1)=SUBSTRING(@word,@count,1);
	IF(CHARINDEX(@current,@setOfLetters)=0)
	RETURN 0

	SET @count+=1;
  END
  
  RETURN 1

END

--PO9

USE Bank

CREATE PROC usp_GetHoldersFullName 
AS
SELECT ah.FirstName+' '+ah.LastName as [Full Name] FROM AccountHolders ah

EXEC dbo.usp_GetHoldersFullName

--PO10

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@Number DECIMAL(15,2))
AS

SELECT Firstname, Lastname FROM (
SELECT a.AccountHolderId, ah.Firstname,ah.Lastname FROM AccountHolders ah
JOIN Accounts a ON a.AccountHolderId=ah.Id
group by a.AccountHolderId,ah.Firstname,ah.Lastname
HAVING SUM(Balance)>=@Number
) AS AK
ORDER BY Firstname, Lastname


