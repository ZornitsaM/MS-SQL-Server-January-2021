
USE SoftUni

-------

SELECT * FROM Employees
SELECT * FROM Addresses

SELECT TOP(50)  e.FirstName,e.LastName,t.Name AS [Town],a.AddressText FROM Employees e
LEFT JOIN Addresses a ON e.AddressID=a.AddressID
LEFT JOIN Towns t ON t.TownID=a.TownID
ORDER BY e.FirstName, e.LastName



-------

SELECT * FROM Employees e
JOIN Departments d ON e.DepartmentID=d.DepartmentID
WHERE e.HireDate >'1999-01-01' AND (d.Name ='Sales' OR d.Name ='Finance')

-------



SELECT TOP(1)
  (SELECT AVG(Salary) FROM Employees WHERE DepartmentID=Departments.DepartmentID) AS AvgSalary
FROM Departments
ORDER BY AvgSalary 



--PO1
USE SoftUni

SELECT TOP(5) e.EmployeeID,e.JobTitle,a.AddressID,a.AddressText FROM Employees e
JOIN Addresses a ON e.AddressID=a.AddressID
ORDER BY a.AddressID


--PO2

SELECT * FROM Addresses
SELECT * FROM Towns

SELECT TOP(50) FirstName,LastName, t.Name as [Town], a.AddressText FROM Employees e
JOIN Addresses a ON e.AddressID=a.AddressID
JOIN Towns t ON a.TownID=t.TownID
ORDER BY FirstName, LastName

--PO3

SELECT EmployeeID,FirstName,LastName,d.Name FROM Employees e
JOIN Departments d ON e.DepartmentID=d.DepartmentID
WHERE d.Name='Sales'
ORDER BY EmployeeID

--PO4

SELECT TOP(5) e.EmployeeID,e.FirstName, e.Salary,d.Name FROM Employees e 
JOIN Departments d ON e.DepartmentID=d.DepartmentID
WHERE e.Salary>15000
ORDER BY d.DepartmentID


--PO5

SELECT TOP(3) e.EmployeeID,e.FirstName FROM Employees e
LEFT JOIN EmployeesProjects ep ON e.EmployeeID=ep.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID



--PO6

SELECT e.FirstName,e.LastName,e.HireDate,d.Name FROM Employees e
JOIN Departments d ON e.DepartmentID=d.DepartmentID
WHERE HireDate>'1999-01-01' AND d.Name IN('Finance','Sales')
ORDER BY e.HireDate

--PO7


SELECT TOP(5) e.EmployeeID,e.FirstName,p.Name FROM Employees e
JOIN EmployeesProjects ep ON e.EmployeeID=ep.EmployeeID
JOIN Projects p ON ep.ProjectID=p.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID


--PO8

SELECT e.EmployeeID,e.FirstName, IIF(p.StartDate>='2005-01-01',NULL,p.Name) as ProjectName FROM Employees e
JOIN EmployeesProjects ep ON e.EmployeeID=ep.EmployeeID --AND e.EmployeeID=24
JOIN Projects p ON ep.ProjectID=p.ProjectID
WHERE e.EmployeeID=24


--PO9

SELECT e2.EmployeeID,e2.FirstName,e2.ManagerID,e1.FirstName AS ManagerName FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID=e2.ManagerID
WHERE e2.ManagerID IN (3,7)
ORDER BY e2.EmployeeID

--PO10

SELECT TOP(50) e2.EmployeeID,e2.FirstName+' '+ E2.LastName AS EmployeeName,e1.FirstName+' '+e1.LastName AS ManagerName,d.Name AS DepartmentName FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID=e2.ManagerID
JOIN Departments d ON e2.DepartmentID=d.DepartmentID
ORDER BY e2.EmployeeID

--PO11
USE SoftUni

SELECT TOP(1) AVG(Salary) AS MinAverageSalary FROM Employees
GROUP BY DepartmentID
ORDER BY AVG(Salary)


--PO12

USE Geography

SELECT C.CountryCode,m.MountainRange,p.PeakName,p.Elevation FROM Countries c
JOIN MountainsCountries mc ON c.CountryCode=mc.CountryCode
JOIN Mountains m ON mc.MountainId=m.Id
JOIN Peaks p ON m.Id=p.MountainId
WHERE c.CountryName='Bulgaria' AND p.Elevation>2835
ORDER BY p.Elevation DESC

--PO13

SELECT C.CountryCode, COUNT(*) AS MountainRanges FROM Countries c
JOIN MountainsCountries mc ON c.CountryCode=mc.CountryCode
JOIN Mountains m ON mc.MountainId=m.Id
WHERE c.CountryCode IN ('BG','RU','US')
GROUP BY c.CountryCode

--PO14



SELECT TOP(5) c.CountryName,r.RiverName FROM Countries c
LEFT JOIN CountriesRivers cr ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers r ON cr.RiverId=r.Id
WHERE C.ContinentCode='AF'
ORDER BY c.CountryName


--PO15


SELECT ContinentCode, CurrencyCode,CurrencyUsage FROM (SELECT ContinentCode,CurrencyCode,COUNT(CurrencyCode) AS CurrencyUsage, 
DENSE_RANK() OVER (PARTITION BY ContinentCode
ORDER BY COUNT(CurrencyCode) DESC) AS Ranked FROM Countries 
GROUP BY ContinentCode,CurrencyCode
) AS K
WHERE Ranked=1 AND CurrencyUsage>1
ORDER BY ContinentCode

--PO16

USE Geography

SELECT COUNT(*) FROM Countries c
LEFT JOIN MountainsCountries mc ON c.CountryCode=mc.CountryCode
LEFT JOIN Mountains m ON mc.MountainId=m.Id
WHERE m.Id IS NULL


--PO17


SELECT TOP(5) c.CountryName, MAX(p.Elevation) as HighestPeakElevation, MAX(r.Length) as LongestRiverLength FROM Countries c
LEFT JOIN MountainsCountries mc ON c.CountryCode=mc.CountryCode
LEFT JOIN Mountains m ON mc.MountainId=m.Id
LEFT JOIN Peaks p ON m.Id=p.MountainId
LEFT JOIN CountriesRivers cr ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers r ON cr.RiverId=r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC,LongestRiverLength DESC,c.CountryName


---------
