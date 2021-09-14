

CREATE DATABASE Bakery
USE Bakery
DROP DATABASE Bakery

CREATE TABLE Countries
(
 Id INT PRIMARY KEY IDENTITY,
 [Name] NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(25) NOT NULL,
	LastName NVARCHAR(25) NOT NULL,
	Gender	CHAR(1) CHECK(Gender IN('M','F')) NOT NULL,
	Age INT NOT NULL,
	PhoneNumber CHAR(10) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(25) NOT NULL UNIQUE,
	Description NVARCHAR(250),
	Recipe NVARCHAR(MAX),
	Price DECIMAL(15,2)  CHECK(Price>=0)
)

CREATE TABLE Feedbacks
(
	Id INT PRIMARY KEY IDENTITY,
	Description NVARCHAR(255),
	Rate DECIMAL(3,2) CHECK(Rate BETWEEN 0 AND 10) NOT NULL,
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id)
)


CREATE TABLE Distributors
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(25) NOT NULL UNIQUE,
	AddressText NVARCHAR(30) NOT NULL,	
	Summary	NVARCHAR(200) NOT NULL,	
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)


CREATE TABLE Ingredients
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	Description NVARCHAR(200),
	OriginCountryId INT FOREIGN KEY REFERENCES Countries(Id),
	DistributorId INT FOREIGN KEY REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients
(
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id),
	CONSTRAINT PK_ProductsIngredients PRIMARY KEY(ProductId,IngredientId)
)

--PO2

USE Bakery

INSERT INTO Distributors (Name, CountryId,AddressText,Summary)
VALUES('Deloitte & Touche',	2,'6 Arch St #9757','Customizable neutral traveling'),
('Congress Title',13,'58 Hancock St','Customer loyalty'),
('Kitchen People',1,'3 E 31st St #77','Triple-buffered stable delivery'),
('General Color Co Inc',21,'6185 Bohn St #72','Focus group'),
('Beck Corporation',23,'21 E 64th Ave','Quality-focused 4th generation hardware')

INSERT INTO Customers (FirstName,LastName,Age,Gender,PhoneNumber,CountryId)
VALUES ('Francoise','Rautenstrauch',15,	'M','0195698399',5),
('Kendra','Loud',22,'F','0063631526',11),
('Lourdes','Bauswell',50,'M','0139037043',8),
('Hannah','Edmison',18,'F','0043343686',1),
('Tom','Loeza',31,'M','0144876096',23),
('Queenie','Kramarczyk',30,	'F','0064215793',29),
('Hiu','Portaro',25,'M','0068277755',16),
('Josefa','Opitz',43,'F','0197887645',17)


--PO3
    
UPDATE Ingredients
SET DistributorId=35
WHERE Name IN ('Poppy','Paprika','Bay Leaf')

UPDATE Ingredients
SET OriginCountryId=14
WHERE OriginCountryId=8

--PO4

DELETE FROM Feedbacks
WHERE CustomerId=14 or ProductId=5
DELETE FROM Products
WHERE Id=5
DELETE FROM Customers
WHERE Id=14

--PO5

SELECT Name,Price,Description FROM Products
ORDER BY Price DESC,Name

--PO6


SELECT f.ProductId,f.Rate,f.Description,c.Id,c.Age,c.Gender FROM Feedbacks f
JOIN Customers c ON f.CustomerId=c.Id
WHERE f.Rate<5.0
ORDER BY f.ProductId DESC,f.Rate


--PO7

SELECT CONCAT(c.FirstName,' ',c.LastName) as CustomerName,c.PhoneNumber,c.Gender FROM Feedbacks f
RIGHT JOIN Customers c ON f.CustomerId=c.Id
WHERE f.CustomerId IS NULL
ORDER BY c.Id

--PO8

SELECT c.FirstName,c.Age,c.PhoneNumber FROM Customers c
JOIN Countries cc ON c.CountryId=cc.Id
WHERE Age>=21 AND FirstName LIKE '%an%' and cc.Name! ='Greece' 
OR PhoneNumber LIKE '%38'
ORDER BY c.FirstName,c.Age DESC

--PO9

SELECT * FROM (
SELECT d.Name AS DistributorName,i.Name as IngredientName,p.Name AS ProductName,AVG(f.Rate) as AverageRate FROM Ingredients i
JOIN ProductsIngredients pi ON I.Id=PI.IngredientId
JOIN Feedbacks f ON pi.ProductId=f.ProductId
JOIN Products p ON f.ProductId=p.Id
JOIN Distributors d ON i.DistributorId=d.Id
GROUP BY i.Name,d.Name,p.Name) AS K
WHERE AverageRate BETWEEN 5 AND 8
ORDER BY DistributorName,IngredientName,ProductName


--PO10

SELECT CountryName, DisributorName FROM (
SELECT c.Name AS CountryName, d.Name AS DisributorName, COUNT(i.Id) as CountIngredienst,
DENSE_RANK() OVER   
    (PARTITION BY c.Name ORDER BY COUNT(i.Id) DESC) AS Rank FROM Ingredients i
JOIN Distributors d ON i.DistributorId=d.Id
JOIN Countries c ON c.Id=d.CountryId
GROUP BY d.Name,c.Name) AS K
WHERE Rank=1
ORDER BY CountryName,DisributorName

--PO11

CREATE VIEW v_UserWithCountries 
AS
SELECT cc.FirstName+' '+cc.LastName as CustomerName,cc.Age,cc.Gender,c.Name FROM Customers cc
JOIN Countries c ON cc.CountryId=c.Id

--PO12


