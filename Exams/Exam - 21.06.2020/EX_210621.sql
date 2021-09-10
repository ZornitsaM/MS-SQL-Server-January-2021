CREATE DATABASE TripService
DROP DATABASE TripService

USE TripService

CREATE TABLE Cities 
(
 Id INT PRIMARY KEY IDENTITY,
 Name NVARCHAR(20) NOT NULL,
 CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels  
(
 Id INT PRIMARY KEY IDENTITY,
 Name NVARCHAR(30) NOT NULL,
 CityId INT FOREIGN KEY REFERENCES Cities(Id),
 EmployeeCount INT NOT NULL,
 BaseRate DECIMAL(10,2)
)


CREATE TABLE Rooms   
(
 Id INT PRIMARY KEY IDENTITY,
 Price DECIMAL(10,2) NOT NULL,
 Type NVARCHAR(20) NOT NULL,
 Beds INT NOT NULL,
 HotelId INT FOREIGN KEY REFERENCES Hotels(Id)
)

CREATE TABLE Trips    
(
 Id INT PRIMARY KEY IDENTITY,
 RoomId INT FOREIGN KEY REFERENCES Rooms(Id),
 BookDate DATE NOT NULL,
 ArrivalDate DATE NOT NULL,
 ReturnDate DATE NOT NULL,
 CancelDate DATE,
 CONSTRAINT CHK_Person CHECK (BookDate<ArrivalDate AND ArrivalDate<ReturnDate)
)

CREATE TABLE Accounts    
(
 Id INT PRIMARY KEY IDENTITY,
 FirstName NVARCHAR(50) NOT NULL,
 MiddleName NVARCHAR(20),
 LastName NVARCHAR(50) NOT NULL,
 CityId INT FOREIGN KEY REFERENCES Cities(Id),
 BirthDate DATE NOT NULL,
 Email NVARCHAR(50) NOT NULL UNIQUE
)


CREATE TABLE AccountsTrips    
(
 AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
 TripId INT FOREIGN KEY REFERENCES Trips(Id),
 Luggage int NOT NULL,
 CONSTRAINT PK_Person PRIMARY KEY (AccountId,TripId)
)

--PO2

INSERT INTO Accounts
VALUES
('John', 'Smith',	'Smith',34,	'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',	11,	'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',	59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',	2,'1844-10-15',	'f_nietzsche@softuni.bg')

INSERT INTO Trips
VALUES (101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULL)

--PO3

SELECT * FROM Rooms
UPDATE Rooms
SET Price = Price + Price*0.14
WHERE HotelId IN(5,7,9)

--PO4

SELECT * FROM AccountsTrips

DELETE FROM AccountsTrips
WHERE AccountId=47

--PO5

select * from Accounts 

SELECT FirstName,LastName,FORMAT(BirthDate,'MM-dd-yyyy') AS BirthDate, c.Name, Email FROM Accounts a
JOIN Cities c ON c.Id=a.CityId
WHERE Email LIKE 'e%'
ORDER BY c.Name

--PO6

select City,COUNT(*) AS Hotels from(
SELECT c.Name as City, h.Id as CountHotel from Hotels h
JOIN Cities c ON h.CityId=c.Id
GROUP BY c.Name,h.Id) as K
GROUP BY City
ORDER BY COUNT(*) DESC, City


--PO7


SELECT AccountId,FullName, MAX(DayDuration) AS LongestTrip, MIN(DayDuration) AS ShortestTrip FROM(
SELECT AccountId,a.FirstName+' '+a.LastName as FullName,t.ArrivalDate,t.ReturnDate,ABS(DATEDIFF(day,t.ReturnDate,t.ArrivalDate)) AS DayDuration FROM AccountsTrips at
JOIN Trips t ON at.TripId=t.Id
JOIN Accounts a ON a.Id=at.AccountId
WHERE t.CancelDate IS NULL and A.MiddleName IS NULL) AS K
GROUP BY AccountId,FullName
ORDER BY LongestTrip DESC,ShortestTrip


--PO8


SELECT TOP(10) c.Id,c.Name,c.CountryCode,COUNT(a.Id) as Accounts FROM Accounts a
JOIN Cities c ON a.CityId=c.Id
GROUP BY c.Id,c.Name,c.CountryCode
ORDER BY COUNT(a.Id) DESC


--PO9

--select * from Accounts
--select * from Trips
--select * from Hotels
--select * from Rooms

SELECT  a.Id,a.Email,c.Name AS City, COUNT(*) AS Trips FROM AccountsTrips at
JOIN Accounts a ON at.AccountId=a.Id
JOIN Trips t ON t.Id=at.TripId
JOIN Rooms r ON r.Id=t.RoomId
JOIN Hotels h ON h.Id=r.HotelId
JOIN Cities c ON c.Id=h.CityId
WHERE a.CityId=h.CityId
GROUP BY a.Id,a.Email,c.Name
ORDER BY Trips DESC,a.Id

--PO10

SELECT t.Id, IIF(a.MiddleName IS NULL,a.FirstName+' '+a.LastName,a.FirstName+' '+ a.MiddleName+' '+a.LastName) AS 'FullName', cc.Name [From],
c.Name AS [To], IIF(t.CancelDate IS NOT NULL,'Canceled',  CONVERT(VARCHAR(10),ABS(DATEDIFF(day,t.ReturnDate,t.ArrivalDate)))+' '+'days') AS Duration FROM AccountsTrips at
JOIN Accounts a ON at.AccountId=a.Id
JOIN Cities cc ON cc.Id=a.CityId
JOIN Trips t ON t.Id=at.TripId
JOIN Rooms r ON r.Id=t.RoomId
JOIN Hotels h ON h.Id=r.HotelId
JOIN Cities c ON c.Id=h.CityId
ORDER BY FullName,t.Id


--PO11


SELECT * FROM Trips
SELECT * FROM Rooms
SELECT * FROM Hotels


CREATE FUNCTION udf_GetAvailableRoom (@HotelId INT, @Date DATE, @People INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @RoomId INT = (SELECT TOP(1) r.Id FROM Hotels h
JOIN Rooms r ON h.Id=r.HotelId
JOIN Trips t ON r.Id=t.RoomId
WHERE h.Id=@HotelId AND @Date NOT BETWEEN t.ArrivalDate AND t.ReturnDate
AND t.CancelDate IS NULL
AND r.Beds>=@People
ORDER BY r.Price DESC)

IF @RoomId IS NULL
      RETURN 'No rooms available'

DECLARE @RoomdType NVARCHAR(20) = (SELECT Type FROM Rooms
                      WHERE Id=@RoomId)
DECLARE @Beds INT =  (SELECT Beds FROM Rooms
                      WHERE Id=@RoomId)
DECLARE @BedPrice INT =  (SELECT Price FROM Rooms
             WHERE Id=@RoomId)

DECLARE @BaseRate DECIMAL(10,2) = (SELECT BaseRate FROM Hotels WHERE Id=@HotelId)

DECLARE @TotalSum DECIMAL(10,2)= (@BaseRate+@BedPrice)*@People

RETURN CONCAT('Room ', @RoomId, ': ', @RoomdType, ' (', @Beds, ' beds', ') - $', @TotalSum)

END


--PO12

SELECT * FROM Trips
SELECT * FROM Rooms
SELECT * FROM Hotels


CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
DECLARE @TripHotelId INT  = (SELECT h.Id FROM Trips t
							JOIN Rooms r ON t.RoomId=R.Id
							JOIN Hotels h ON r.HotelId=h.Id
							WHERE t.Id=@TripId)
DECLARE @HotelId INT = (SELECT HotelId FROM Rooms WHERE Id=@TargetRoomId)

IF(@TripHotelId!=@HotelId)
THROW 50001, 'Target room is in another hotel!', 1

IF((SELECT Beds FROM Rooms
WHERE Id = @TargetRoomId) < (SELECT COUNT(*) FROM AccountsTrips WHERE TripId=@TripId))
THROW 50002, 'Not enough beds in target room!', 1

UPDATE Trips
SET RoomId=@TargetRoomId
WHERE Id=@TripId

EXEC usp_SwitchRoom 10, 8