
CREATE DATABASE TripService
 USE TripService
 DROP DATABASE TripService


CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20) NOT NULL,
	CountryCode	CHAR(2) NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(15,2)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(15,2) NOT NULL,
	Type	NVARCHAR(20) NOT NULL,
	Beds INT NOT NULL,
	HotelId	INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id),

)

CREATE TABLE Trips
(
	Id INT PRIMARY KEY IDENTITY,
	RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id),
	BookDate DATE NOT NULL,
	ArrivalDate	DATE NOT NULL,
	ReturnDate	DATE NOT NULL, 
	CancelDate	DATE,
	CHECK (BookDate<ArrivalDate),
	CHECK (ArrivalDate<ReturnDate)

)

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName	NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
	BirthDate DATE NOT NULL,
	Email VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE AccountsTrips
(
	AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts(Id),
	TripId INT NOT NULL FOREIGN KEY REFERENCES Trips(Id),
	Luggage INT NOT NULL CHECK(Luggage>=0),
	CONSTRAINT PK_Person PRIMARY KEY (AccountId,TripId)
)

--PO2

INSERT INTO Accounts
VALUES ('John','Smith','Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',2,'1844-10-15','f_nietzsche@softuni.bg')

INSERT INTO Trips
VALUES(101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULL)

--PO3

UPDATE Rooms
SET Price=Price+Price*0.14
WHERE HotelId IN (5,7,9)

--PO4

DELETE FROM AccountsTrips
WHERE AccountId=47

--PO5

SELECT a.FirstName,a.LastName,FORMAT(a.BirthDate,'MM-dd-yyyy'),c.Name,a.Email FROM Accounts a
JOIN Cities c ON a.CityId=c.Id
WHERE a.Email LIKE 'e%'
ORDER BY c.Name

--PO6

SELECT c.Name, COUNT(h.Id) as Hotels FROM Hotels h
JOIN Cities c ON h.CityId=C.Id
GROUP BY c.Name
ORDER BY COUNT(h.Id) DESC, c.Name

--PO7

SELECT * FROM Trips

SELECT a.Id,a.FirstName+' '+a.LastName as FullName,MAX(ABS(DATEDIFF(DAY,t.ReturnDate,t.ArrivalDate))) AS LongestTrip,
MIN(ABS(DATEDIFF(DAY,t.ReturnDate,t.ArrivalDate))) AS ShortestTrip
FROM Trips t
JOIN AccountsTrips at ON T.Id=at.TripId
JOIN Accounts a ON at.AccountId=a.Id
WHERE a.MiddleName IS NULL AND t.CancelDate IS NULL
GROUP BY a.Id,a.FirstName,a.LastName
ORDER BY MAX(ABS(DATEDIFF(DAY,t.ReturnDate,t.ArrivalDate))) DESC,MIN(ABS(DATEDIFF(DAY,t.ReturnDate,t.ArrivalDate)))

--PO8

SELECT TOP(10) c.Id,c.Name,c.CountryCode as Country,COUNT(a.Id) as Accounts FROM Accounts a
JOIN Cities c ON a.CityId=c.Id
GROUP BY c.Id,c.Name,c.CountryCode
ORDER BY COUNT(a.Id) DESC

--PO9

SELECT a.Id,a.Email,c.Name as City, COUNT(t.Id) as Trips FROM AccountsTrips at
JOIN Trips t ON at.TripId=t.Id
JOIN Accounts a ON at.AccountId=a.Id
JOIN Rooms r ON t.RoomId=r.Id
JOIN Hotels h ON r.HotelId=h.Id
JOIN Cities c ON h.CityId=c.Id
WHERE a.CityId=h.CityId
GROUP BY a.Id,a.Email,c.Name
ORDER BY COUNT(t.Id) DESC,a.Id

--PO10

select * from Rooms

--SELECT t.Id,IIF(a.MiddleName IS NULL,a.FirstName+' '+a.LastName,a.FirstName+' '+ a.MiddleName+' '+a.LastName) AS 'Full Name',c.Name as [From],cc.Name as [To],
--IIF(t.CancelDate IS NOT NULL,'Canceled', CONVERT(VARCHAR(20),ABS(DATEDIFF(day,t.ReturnDate,t.ArrivalDate)))+' days') AS Duration
--FROM AccountsTrips at
--JOIN Trips t ON at.TripId=t.Id
--JOIN Accounts a ON at.AccountId=a.Id
--JOIN Cities c on c.Id=a.CityId
--JOIN Rooms r ON t.RoomId=r.Id
--JOIN Hotels h ON h.Id=r.HotelId
--JOIN Cities cc ON cc.Id=h.CityId
--ORDER BY  [Full Name], t.Id

SELECT t.Id,a.FirstName+' '+ISNULL(a.MiddleName+' ','')+a.LastName AS 'Full Name',c.Name as [From],cc.Name as [To],
IIF(t.CancelDate IS NOT NULL,'Canceled', CONVERT(VARCHAR(20),ABS(DATEDIFF(day,t.ReturnDate,t.ArrivalDate)))+' days') AS Duration
FROM AccountsTrips at
JOIN Trips t ON at.TripId=t.Id
JOIN Accounts a ON at.AccountId=a.Id
JOIN Cities c on c.Id=a.CityId
JOIN Rooms r ON t.RoomId=r.Id
JOIN Hotels h ON h.Id=r.HotelId
JOIN Cities cc ON cc.Id=h.CityId
ORDER BY  [Full Name], t.Id

--PO11

CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @FoundRooms INT = (SELECT TOP(1) r.Id FROM Hotels h
JOIN Rooms r ON r.HotelId=h.Id
JOIN Trips t ON t.RoomId=r.Id
WHERE h.Id=@HotelId
AND @Date NOT BETWEEN t.ArrivalDate AND t.ReturnDate
AND t.CancelDate IS NULL
AND r.Beds>=@People
AND YEAR(@Date) = YEAR(t.ArrivalDate)
ORDER BY r.Price DESC)


IF(@FoundRooms IS NULL)
RETURN 'No rooms available'

DECLARE @RoompPrise DECIMAL(15,2) = (SELECT Price FROM Rooms WHERE Id=@FoundRooms)

DECLARE @RoomType VARCHAR(50) =(SELECT Type FROM Rooms WHERE Id=@FoundRooms)

DECLARE @BedsCount INT = (SELECT Beds FROM Rooms WHERE Id=@FoundRooms)

DECLARE @BaseRate DECIMAL(15,2) = (SELECT BaseRate FROM Hotels WHERE Id=@HotelId)

DECLARE @TotalCount DECIMAL(15,2) = (@BaseRate+@RoompPrise)*@People

RETURN CONCAT('Room ', @FoundRooms, ': ',@RoomType, ' (',@BedsCount, ' beds', ') - $',@TotalCount)

END
SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)

--PO12

CREATE PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS

DECLARE @FirstHotelName INT = (SELECT h.Id FROM Trips t
										JOIN Rooms r ON t.RoomId=r.Id
										JOIN Hotels h ON h.Id=r.HotelId
										WHERE t.Id=@TripId)

DECLARE @SecondHotelName INT = (SELECT HotelId FROM Rooms WHERE Id=@TargetRoomId)

DECLARE @SumBeds INT = (SELECT Beds FROM Rooms WHERE Id=@TargetRoomId)
DECLARE @TripsAccounts INT = (SELECT COUNT(*) FROM AccountsTrips WHERE TripId=@TripId)

IF(@FirstHotelName!=@SecondHotelName)
THROW 50001,'Target room is in another hotel!',1

IF(@SumBeds<@TripsAccounts)
THROW 50002,'Not enough beds in target room!',1

UPDATE Trips
SET RoomId=@TargetRoomId
WHERE Id=@TripId

EXEC usp_SwitchRoom 10, 8

