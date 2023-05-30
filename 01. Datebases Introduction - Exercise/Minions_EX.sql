
CREATE DATABASE Minions

--Minions add table Minions (Id, Name, Age). Then add new table Towns (Id, Name). 

CREATE TABLE Minions
(
Id INT PRIMARY KEY,
[Name] VARCHAR(30),
Age INT
)

CREATE TABLE Towns
(
 Id INT PRIMARY KEY,
[Name] VARCHAR(50),
)

ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

INSERT INTO Towns (Id,[Name])
VALUES (1, 'Sofia'), (2, 'Plovdiv'), (3, 'Varna')

INSERT INTO Minions (Id,[Name],Age, TownId)
VALUES (1, 'Kevin', 22, 1), (2, 'Bob', 15, 3), (3, 'Steward', NULL, 2)

DELETE FROM Minions

DROP TABLE Minions
DROP TABLE Towns

--PO7
CREATE TABLE People
(
 Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 [Name] NVARCHAR(200) NOT NULL,
 Picture VARBINARY(MAX),
 Height FLOAT(2),
 [Weight] FLOAT(2),
 Gender CHAR(1) NOT NULL,
 Birthdate DATE NOT NULL,
 Biography NVARCHAR(MAX)
)

INSERT INTO People
VALUES ('Ivan',456,2.1,65.2,'m','1996-10-10','Nice person'),('Mimi',16165165,1.56,55.5,'f','1998-09-10','Real person'),
('Stefi',15616,2.1,45.2,'f','1999-10-10','Pleasant person'), ('Stoyan',1665,2.3,65.7,'m','1996-10-12','Nice person'),
('Mario',15165,1.75,75.6,'m','1989-10-10','Nice person')

--PO8

CREATE TABLE Users
(
 Id BIGINT PRIMARY KEY IDENTITY(1,1),
 Username VARCHAR(30) UNIQUE NOT NULL,
 [Password] VARCHAR(26) NOT NULL,
 ProfilePicture VARBINARY(900),
 LastLoginTime DATETIME,
 IsDeleted BIT,
)
INSERT INTO Users
VALUES ('Mimi','cdjashbc',56565454,'2010-10-10 23:59:59',0),
('Ivan','vjkv',5611,'2011-10-10 21:59:59',1),('Stoyan','fdvfvv',6516,'2020-10-10 20:59:59',0),
('Koko','vfvdv',262,'2015-10-10 23:59:59',1), ('Krasi','vdfvd',65161,'2016-10-10 23:59:59',1)

--PO9

ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC07790F83F9

ALTER TABLE Users
ADD CONSTRAINT PK_User PRIMARY KEY (Id, Username)

--PO13

CREATE DATABASE Movies
 
CREATE TABLE Directors
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 DirectorName NVARCHAR(30) NOT NULL,
 Notes NVARCHAR(200),
)

CREATE TABLE Genres
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 GenreName NVARCHAR(30) NOT NULL,
 Notes NVARCHAR(200),
 )
 
CREATE TABLE Categories
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 CategoryName NVARCHAR(30) NOT NULL,
 Notes NVARCHAR(200),
)

CREATE TABLE Movies
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 Title NVARCHAR(30),
 DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
 CopyrightYear DATE NOT NULL,
 [Length] TIME NOT NULL,
 GenreId INT FOREIGN KEY REFERENCES Genres(Id),
 CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
 Rating FLOAT(1),
  Notes NVARCHAR(200),
)

INSERT INTO Directors
VALUES('Ivan','Good person'), ('Svetla','Beautiful person'), ('Momi','Nice person'), ('Sisi','Good person'), ('Bobi','Awful person')

INSERT INTO Genres
VALUES('Koko','Smile person'), ('Niki','Niksman'), ('Hohi','Stars'), ('Loli','Good person'), ('Bobi','Awful person')

INSERT INTO Categories
VALUES('Comedy','Smile'), ('Romantic','Love story'), ('Tragedy','Tires'), ('Axtion','Fast and Furious'), ('TV Shows','Movie of 20')

INSERT INTO Movies
VALUES ('20th centuries',1,'2020-10-09', '01:30:31', 2,1,4.5,'Amazing Story'),
('Titanik',1,'2010-10-09', '01:30:31', 2,1,4.5,'Amazing Story'),
('Rose',1,'2020-10-09', '01:30:31', 2,1,4.5,'Amazing Story'),
('The Wedding',1,'2020-10-09', '01:30:31', 2,1,4.5,'Amazing Story'),
('Fast and Furious',1,'2020-10-09', '01:30:31', 2,1,4.5,'Amazing Story')

--P014

CREATE DATABASE CarRental 

USE CarRental

CREATE TABLE Categories
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 CategoryName NVARCHAR(30) NOT NULL,
 DailyRate FLOAT(2) NOT NULL,
 WeeklyRate FLOAT(2) NOT NULL,
 MonthlyRate FLOAT(2) NOT NULL,
 WeekendRate FLOAT(2) NOT NULL
)

CREATE TABLE Cars
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 PlateNumber NVARCHAR(10) NOT NULL,
 Manufacturer NVARCHAR(30) NOT NULL,
 Model NVARCHAR(30) NOT NULL,
 CarYear DATE NOT NULL,
 CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
 Doors TINYINT NOT NULL,
 Picture VARBINARY(MAX),
 Condition NVARCHAR(20),
 Available BIT NOT NULL
)

CREATE TABLE Employees
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 FirstName NVARCHAR(10),
 LastName NVARCHAR(30),
 Title NVARCHAR(100) NOT NULL,
 Notes NVARCHAR(300)
)

CREATE TABLE Customers
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 DriverLicenceNumber NVARCHAR(30),
 FullName NVARCHAR(50) NOT NULL,
 Address NVARCHAR(100),
 City NVARCHAR(100) NOT NULL,
 ZIPCode TINYINT,
 Notes NVARCHAR(300)
)

CREATE TABLE RentalOrders
(
 Id INT PRIMARY KEY IDENTITY NOT NULL,
 EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
 CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
 CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
 TankLevel FLOAT(2),
 KilometrageStart INT,
 KilometrageEnd INT NOT NULL,
 TotalKilometrage INT NOT NULL,
 StartDate DATE NOT NULL,
 EndDate DATE NOT NULL,
 TotalDays DATE NOT NULL,
 RateApplied FLOAT(2) NOT NULL,
 TaxRate FLOAT(2) NOT NULL,
 OrderStatus NVARCHAR(15) NOT NULL,
 Notes NVARCHAR(15) NOT NULL,

)
--•	Categories (Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
--•	Cars (Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
--•	Employees (Id, FirstName, LastName, Title, Notes)
--•	Customers (Id, DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
--•	RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)

INSERT INTO Categories
VALUES ('Cars', 20, 100, 400, 30), ('Vagoon', 20, 100, 400, 30), ('Motor', 20, 100, 400, 30)

ALTER TABLE Cars
DROP COLUMN Available 

ALTER TABLE Cars
ADD Available CHAR(10)

INSERT INTO Cars
VALUES ('CA1884CV', 'VW','Audi','2000',1,4,6561651,'new','yes'), ('CA1854CV', 'VW','VW','1996',1,4,65498651,'new','yes'),
('CA4584CV', 'VW','BWM','2005',1,4,56565165,'old','NO')

INSERT INTO Employees
VALUES ('Ivan','Petrov','Manager','Nice person'), ('Stoyan','Petrov','Assistant','Nice person'), 
('Miro','Petrov','Manager','Awful person')

ALTER TABLE Customers
DROP COLUMN ZIPCode


ALTER TABLE Customers
ADD ZIPCode CHAR(15)

INSERT INTO Customers
VALUES ('FDVDFVDFV', 'Ivan Ivanov','23 street','Plovdiv','4589','Nice'),
('dfdfbdf', 'Stoyan Ivanov','26 street','Sofia','5623','Nice'),
('dbdfb', 'Miro Ivanov','30 street','Burgas','5231','Nice')

ALTER TABLE RentalOrders
DROP COLUMN TotalDays

ALTER TABLE RentalOrders
ADD TotalDays INT NOT NULL

INSERT INTO RentalOrders
VALUES (1,2,3,0.25,15,20000,20015,'2000-10-01','2005-10-10',0.22,0.55,'bought','Perfect',200),
(1,3,2,0.25,15,20000,20015,'2000-10-01','2005-10-10',0.22,0.55,'bought','Perfect',200),
(1,2,2,0.25,15,20000,20015,'2000-10-01','2005-10-10',0.22,0.55,'bought','Perfect',200)

SELECT * FROM RentalOrders

--PO15

CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Title VARCHAR(50),
Notes VARCHAR(MAX)
)
 
INSERT INTO Employees
VALUES
('Velizar', 'Velikov', 'Receptionist', 'Nice customer'),
('Ivan', 'Ivanov', 'Concierge', 'Nice one'),
('Elisaveta', 'Bagriana', 'Cleaner', 'Poetesa')
 
CREATE TABLE Customers(
Id INT PRIMARY KEY IDENTITY NOT NULL,
AccountNumber BIGINT,
FirstName VARCHAR(50),
LastName VARCHAR(50),
PhoneNumber VARCHAR(15),
EmergencyName VARCHAR(150),
EmergencyNumber VARCHAR(15),
Notes VARCHAR(100)
)
 
INSERT INTO Customers
VALUES
(123456789, 'Ginka', 'Shikerova', '359888777888', 'Sistry mi', '7708315342', 'Kinky'),
(123480933, 'Chaika', 'Stavreva', '359888777888', 'Sistry mi', '7708315342', 'Lawer'),
(123454432, 'Mladen', 'Isaev', '359888777888', 'Sistry mi', '7708315342', 'Wants a call girl')
 
CREATE TABLE RoomStatus(
Id INT PRIMARY KEY IDENTITY NOT NULL,
RoomStatus BIT,
Notes VARCHAR(MAX)
)
 
INSERT INTO RoomStatus(RoomStatus, Notes)
VALUES
(1,'Refill the minibar'),
(2,'Check the towels'),
(3,'Move the bed for couple')
 
CREATE TABLE RoomTypes(
RoomType VARCHAR(50) PRIMARY KEY,
Notes VARCHAR(MAX)
)
 
INSERT INTO RoomTypes (RoomType, Notes)
VALUES
('Suite', 'Two beds'),
('Wedding suite', 'One king size bed'),
('Apartment', 'Up to 3 adults and 2 children')
 
CREATE TABLE BedTypes(
BedType VARCHAR(50) PRIMARY KEY,
Notes VARCHAR(MAX)
)
 
INSERT INTO BedTypes
VALUES
('Double', 'One adult and one child'),
('King size', 'Two adults'),
('Couch', 'One child')
 
CREATE TABLE Rooms (
RoomNumber INT PRIMARY KEY IDENTITY NOT NULL,
RoomType VARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType),
BedType VARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType),
Rate DECIMAL(6,2),
RoomStatus NVARCHAR(50),
Notes NVARCHAR(MAX)
)
 
INSERT INTO Rooms (Rate, Notes)
VALUES
(12,'Free'),
(15, 'Free'),
(23, 'Clean it')
 
CREATE TABLE Payments(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
PaymentDate DATE,
AccountNumber BIGINT,
FirstDateOccupied DATE,
LastDateOccupied DATE,
TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
AmountCharged DECIMAL(14,2),
TaxRate DECIMAL(8, 2),
TaxAmount DECIMAL(8, 2),
PaymentTotal DECIMAL(15, 2),
Notes VARCHAR(MAX)
)
 
INSERT INTO Payments (EmployeeId, PaymentDate, AmountCharged)
VALUES
(1, '12/12/2018', 2000.40),
(2, '12/12/2018', 1500.40),
(3, '12/12/2018', 1000.40)
 
CREATE TABLE Occupancies(
Id  INT PRIMARY KEY IDENTITY NOT NULL,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
DateOccupied DATE,
AccountNumber BIGINT,
RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
RateApplied DECIMAL(6,2),
PhoneCharge DECIMAL(6,2),
Notes VARCHAR(MAX)
)
 
INSERT INTO Occupancies (EmployeeId, RateApplied, Notes) VALUES
(1, 55.55, 'too'),
(2, 15.55, 'much'),
(3, 35.55, 'typing')

--PO16

CREATE DATABASE SoftUni
USE SoftUni

--•	Towns (Id, Name)
--•	Addresses (Id, AddressText, TownId)
--•	Departments (Id, Name)
--•	Employees (Id, FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)

CREATE TABLE Towns
(
 Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 [Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE Addresses
(
 Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 AddressText NVARCHAR(100) NOT NULL,
 TownId INT FOREIGN KEY REFERENCES Towns(Id)

)
CREATE TABLE Departments
(
 Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 [Name] NVARCHAR(50) NOT NULL,

)
CREATE TABLE Employees
(
 Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 FirstName NVARCHAR(30) NOT NULL,
 MiddleName NVARCHAR(30),
 LastName NVARCHAR(30) NOT NULL,
 JobTitle NVARCHAR(30) NOT NULL,
 DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
 HireDate DATE NOT NULL,
 Salary DECIMAL (7,2),
 AddressId INT FOREIGN KEY REFERENCES Addresses(Id),

)

INSERT INTO Towns
VALUES('Sofia'),('Plovdiv'),('Varna'),('Burgas')
INSERT INTO Departments
VALUES ('Engineering'), ('Sales'), ('Marketing'), ('Software Development'), ('Quality Assurance')

INSERT INTO Employees (FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES ('Ivan','Ivanov','Ivanov','.NET Developer',4,'2013-02-01',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02',4000.00),
('Maria','Petrova','Ivanova','Intern',5,'2016-08-28',525.25),
('Georgi','Teziev','Ivanov','CEO',2,'2007-12-09',3000.00),
('Peter','Pan','Pan','Intern',3,'2016-08-28',599.88)

--PO20

SELECT * FROM Towns
ORDER BY [Name] ASC

SELECT * FROM Departments
ORDER BY [Name] ASC

SELECT * FROM Employees
ORDER BY Salary DESC

--PO21

SELECT [Name] FROM Towns
ORDER BY [Name]

SELECT [Name] FROM Departments
ORDER BY [Name]

SELECT FirstName,LastName,JobTitle,Salary FROM Employees
ORDER BY Salary DESC

--PO22

UPDATE Employees
SET Salary+=Salary*0.10

SELECT Salary FROM Employees

--PO23

USE Hotel

UPDATE Payments
SET TaxRate-=TaxRate*0.03

SELECT TaxRate FROM Payments

--PO24

DELETE FROM Occupancies