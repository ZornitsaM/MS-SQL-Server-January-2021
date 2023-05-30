

--PO1

USE Gringotts

SELECT COUNT(*) AS Count FROM WizzardDeposits

--PO2
SELECT TOP(1) MagicWandSize AS LongestMagicWand FROM WizzardDeposits
ORDER BY MagicWandSize DESC

--PO3

SELECT DepositGroup,MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
GROUP BY DepositGroup

--PO4

SELECT TOP(2) DepositGroup FROM(
SELECT DepositGroup, AVG(MagicWandSize) AS LowerMagicWand  FROM WizzardDeposits
GROUP BY DepositGroup) AS K
ORDER BY LowerMagicWand


SELECT TOP(2) DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--PO5

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
GROUP BY DepositGroup

--PO6

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup

--PO7

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount)<150000
ORDER BY SUM(DepositAmount) DESC

--PO8

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup,MagicWandCreator
ORDER BY MagicWandCreator,DepositGroup

--PO9

SELECT AgeGroup,COUNT(*) AS WizardCount FROM(
SELECT
CASE
    WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
    WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
    WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
    ELSE '[61+]'
END AS AgeGroup
FROM WizzardDeposits) as K
GROUP BY AgeGroup 

--PO10

SELECT LEFT(FirstName,1) FROM WizzardDeposits
WHERE DepositGroup='Troll Chest'
GROUP BY LEFT(FirstName,1)
ORDER BY LEFT(FirstName,1)

--PO11

SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE DepositStartDate>'1985-01-01'
GROUP BY DepositGroup,IsDepositExpired
ORDER BY DepositGroup DESC,IsDepositExpired 

--PO13

USE SoftUni

SELECT DepartmentID,SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--PO14

SELECT DepartmentID, MIN(Salary) AS MinimumSalary FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate>'2000-01-01'
GROUP BY DepartmentID

--PO15

SELECT * FROM Employees
WHERE Salary>30000

SELECT *
INTO NewTable
FROM Employees
WHERE Salary>30000

DELETE FROM NewTable 
WHERE ManagerID=42

UPDATE NewTable
SET Salary = Salary+5000
WHERE DepartmentID=1

SELECT DepartmentID,AVG(Salary) AS AverageSalary FROM NewTable
GROUP BY DepartmentID

--PO16

SELECT DepartmentID,MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--PO17

SELECT COUNT(Salary) as Count FROM Employees
WHERE ManagerID IS NULL

--PO18

USE SoftUni

SELECT DepartmentID, Salary FROM
   (SELECT DepartmentID, Salary, DENSE_RANK() OVER   
   (PARTITION BY DepartmentID ORDER BY Salary DESC) as SalaryRanked FROM Employees
GROUP BY DepartmentID,Salary
   ) AS K
WHERE SalaryRanked=3

  