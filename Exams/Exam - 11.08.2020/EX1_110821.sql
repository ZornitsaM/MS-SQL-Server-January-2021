

CREATE DATABASE Bakery
USE Bakery
DROP DATABASE Bakery

CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(25),
	LastName NVARCHAR(25),
	Gender CHAR(1)  CHECK(Gender IN('M','F')),
	Age INT,
	PhoneNumber CHAR(10),
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(25) NOT NULL UNIQUE,
	Description NVARCHAR(250),	
	Recipe NVARCHAR(MAX),	
	Price DECIMAL(18,2) CHECK(Price>=0)
)

CREATE TABLE Feedbacks
(
	Id INT PRIMARY KEY IDENTITY,
	Description NVARCHAR(255),
	Rate DECIMAL(4,2) CHECK(Rate BETWEEN 0 AND 10),
	ProductId  INT FOREIGN KEY REFERENCES Products(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
)

CREATE TABLE Distributors
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(25) NOT NULL UNIQUE,
	AddressText NVARCHAR(30),
	Summary	 NVARCHAR(200),
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Ingredients
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30),
	Description NVARCHAR(200),
	OriginCountryId INT FOREIGN KEY REFERENCES Countries(Id),
	DistributorId INT FOREIGN KEY REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients
(
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id),
	PRIMARY KEY(ProductId,IngredientId)
)

--PO2

INSERT INTO Distributors (Name,CountryId,AddressText,Summary)
VALUES('Deloitte & Touche',2,'6 Arch St #9757','Customizable neutral traveling'),
('Congress Title',13,'58 Hancock St','Customer loyalty'),
('Kitchen People',1,'3 E 31st St #77','Triple-buffered stable delivery'),
('General Color Co Inc',21,'6185 Bohn St #72','Focus group'),
('Beck Corporation',23,'21 E 64th Ave','Quality-focused 4th generation hardware')

INSERT INTO Customers (FirstName,LastName,Age,Gender,PhoneNumber,CountryId)
VALUES('Francoise',	'Rautenstrauch',15,	'M','0195698399',5),
('Kendra',	'Loud',22,	'F','0063631526',11),
('Lourdes',	'Bauswell',50,	'M','0139037043',8),
('Hannah',	'Edmison',18,	'F','0195698399',1),
('Tom',	'Loeza',31,	'M','0144876096',23),
('Queenie',	'Kramarczyk',30,	'F','0064215793',29),
('Hiu',	'Portaro',25,	'M','0068277755',16),
('Josefa',	'Opitz',43,	'F','0197887645',17)

--PO3

SELECT * FROM Ingredients
SELECT * FROM Distributors
ORDER BY Name

UPDATE Ingredients
SET DistributorId=35
WHERE Name IN ('Bay Leaf', 'Paprika','Poppy')

UPDATE Ingredients
SET OriginCountryId=14
WHERE OriginCountryId=8

--PO4

DELETE FROM Feedbacks
WHERE CustomerId=14 OR ProductId=5

--PO5

SELECT Name,Price,Description FROM Products
ORDER BY Price DESC,Name

--PO6

SELECT f.ProductId,f.Rate,f.Description,c.Id,c.Age,c.Gender FROM Feedbacks f
JOIN Customers c ON f.CustomerId=c.Id
WHERE f.Rate<5
ORDER BY f.ProductId DESC,f.Rate

--PO7

SELECT CONCAT(c.FirstName,' ',c.LastName) CustomerName,c.PhoneNumber,c.Gender FROM Feedbacks f
FULL JOIN Customers c ON c.Id=f.CustomerId
WHERE f.CustomerId IS NULL
ORDER BY c.Id

--PO8

SELECT cc.FirstName,cc.Age,cc.PhoneNumber FROM Customers cc
JOIN Countries c ON cc.CountryId=c.Id
WHERE Age>=21 AND FirstName LIKE '%an%'
OR PhoneNumber LIKE '%38'
AND c.Name !='Greece'
ORDER BY cc.FirstName,cc.Age DESC

--PO9

SELECT * FROM (

SELECT d.Name as DistributorName,i.Name as IngredientName,p.Name as ProductName,AVG(f.Rate) as AverageRate FROM ProductsIngredients pi
JOIN Ingredients i ON pi.IngredientId=i.Id
JOIN Products p ON p.Id=pi.ProductId
JOIN Distributors d ON i.DistributorId=d.Id
JOIN Feedbacks f ON P.Id=F.ProductId
GROUP BY d.Name,i.Name,p.Name
HAVING AVG(f.Rate) BETWEEN 5 AND 8
ORDER BY DistributorName,IngredientName,ProductName
) AS K
WHERE AverageRate BETWEEN 5 AND 8

--PO10

SELECT CountryName,DisributorName FROM (
SELECT c.Name AS CountryName, d.Name AS DisributorName, COUNT(i.Id) CountOfIngredients,DENSE_RANK() OVER   
    (PARTITION BY c.Name ORDER BY COUNT(i.Id) DESC) AS Rank   FROM Ingredients i
JOIN Distributors d ON i.DistributorId=d.Id
JOIN Countries c ON c.Id=d.CountryId
GROUP BY d.Id,d.Name,c.Name) AS K
WHERE Rank=1
ORDER BY CountryName,DisributorName

--PO11

CREATE VIEW v_UserWithCountries 
AS
SELECT c.FirstName+' '+c.LastName as CustomerName,c.Age,c.Gender,cc.Name as CountryName FROM Customers c
JOIN Countries cc ON c.CountryId=cc.Id
