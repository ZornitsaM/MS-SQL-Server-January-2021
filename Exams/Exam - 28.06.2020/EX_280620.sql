
CREATE DATABASE ColonialJourney
DROP DATABASE ColonialJourney

USE ColonialJourney

CREATE TABLE Planets
(
 Id INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
 Id INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(50) NOT NULL,
 PlanetId INT FOREIGN KEY REFERENCES Planets(Id)
)

CREATE TABLE Spaceships
(
 Id INT PRIMARY KEY  IDENTITY,
 [Name] VARCHAR(50) NOT NULL,
 Manufacturer VARCHAR(30) NOT NULL,
 LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists
(
 Id INT PRIMARY KEY IDENTITY,
 FirstName VARCHAR(20) NOT NULL,
 LastName  VARCHAR(20) NOT NULL,
 Ucn VARCHAR(10) NOT NULL UNIQUE,
 BirthDate DATE NOT NULL
)

CREATE TABLE Journeys
(
 Id INT PRIMARY KEY IDENTITY,
 JourneyStart DATETIME NOT NULL,
 JourneyEnd DATETIME NOT NULL,
 Purpose VARCHAR(11) ,
 CONSTRAINT CHK_Purpose CHECK (Purpose IN('Medical', 'Technical', 'Educational', 'Military')),
 DestinationSpaceportId INT FOREIGN KEY REFERENCES Spaceports(Id),
 SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id),
 )


 CREATE TABLE TravelCards
(
 Id INT PRIMARY KEY IDENTITY,
 CardNumber CHAR(10) NOT NULL UNIQUE,
 JobDuringJourney VARCHAR(8),
 ColonistId INT FOREIGN KEY REFERENCES Colonists(Id),
 JourneyId INT FOREIGN KEY REFERENCES Journeys(Id),
 CONSTRAINT CHK_JobDuringJourney CHECK (JobDuringJourney IN('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'))
 )

 --2.	Insert

 INSERT INTO Planets
 VALUES ('Mars'),('Earth'),('Jupiter'),('Saturn')


 INSERT INTO Spaceships
 VALUES ('Golf','VW',3),('WakaWaka','Wakanda',4),('Falcon9','SpaceX',1),('Bed','Vidolov',6)

 --3.	Update

UPDATE Spaceships
SET LightSpeedRate = LightSpeedRate+1
WHERE Id BETWEEN 8 AND 12

--4.	Delete

--ALTER TABLE Journeys
--ADD CONSTRAINT FK_DestinationSpaceportId
--FOREIGN KEY (DestinationSpaceportId) REFERENCES Spaceports(Id);

--ALTER TABLE Journeys
--ADD CONSTRAINT FK_SpaceshipId
--FOREIGN KEY (SpaceshipId) REFERENCES Spaceships(Id);

ALTER TABLE TravelCards
   DROP CONSTRAINT [FK__TravelCar__Journ__34C8D9D1] 

ALTER TABLE TravelCards
ADD CONSTRAINT FK_JourneyId
FOREIGN KEY (JourneyId) REFERENCES Journeys(Id) ON DELETE CASCADE

DELETE FROM Journeys 
WHERE Id IN(1,2,3);

SELECT * FROM Journeys


--PO5

SELECT * FROM Journeys

SELECT Id, FORMAT(JourneyStart,'dd/MM/yyyy') AS JourneyStart, FORMAT(JourneyEnd,'dd/MM/yyyy') AS JourneyEnd FROM Journeys
WHERE Purpose='Military'
ORDER BY JourneyStart

--PO6

SELECT c.Id AS id ,c.FirstName+' '+ c.LastName AS 'full_name'  FROM Colonists c
JOIN TravelCards tc ON c.Id=tc.ColonistId
WHERE JobDuringJourney='Pilot'
ORDER BY c.Id

--PO7

SELECT COUNT(*) AS count FROM Colonists C
JOIN TravelCards tc ON C.Id=tc.ColonistId
JOIN Journeys j ON tc.JourneyId=j.Id
WHERE j.Id IN (5,15)


--PO8

SELECT s.Name, s.Manufacturer FROM Spaceships s
JOIN Journeys j ON s.Id=j.SpaceshipId
JOIN TravelCards tc ON tc.JourneyId=j.Id
JOIN Colonists cc ON cc.Id=tc.ColonistId
GROUP BY s.Name,s.Manufacturer
ORDER BY s.Name




--PO9


SELECT PlanetName, COUNT(PlanetName) AS JourneysCount FROM (SELECT p.Name PlanetName,j.JourneyStart as JourneysCount FROM Planets p
JOIN Spaceports sp ON p.Id=sp.PlanetId
JOIN Journeys j ON j.DestinationSpaceportId=SP.Id) AS M
GROUP BY PlanetName
ORDER BY JourneysCount DESC, PlanetName


SELECT p.Name, COUNT(j.JourneyStart) FROM Planets p
JOIN Spaceports sp ON p.Id=sp.PlanetId
JOIN Journeys j ON j.DestinationSpaceportId=SP.Id
GROUP BY p.Name
ORDER BY COUNT(j.JourneyStart) DESC,  p.Name

--PO10

SELECT JobDuringJourney,FullName,JobRank FROM( SELECT tc.JobDuringJourney as JobDuringJourney, c.FirstName+' '+c.LastName as FullName,c.BirthDate,
DENSE_RANK() OVER(PARTITION BY (JobDuringJourney) ORDER BY c.BirthDate) AS JobRank FROM Colonists c 
JOIN TravelCards tc ON c.Id=tc.ColonistId) AS K
WHERE JobRank=2
GROUP BY JobDuringJourney,FullName,JobRank


--PO11

CREATE FUNCTION udf_GetColonistsCount (@PlanetName VARCHAR(30))
RETURNS INT
AS 
BEGIN
DECLARE @Count INT= (SELECT COUNT(c.Id) FROM Planets p
JOIN Spaceports sp ON p.Id=sp.PlanetId
JOIN Journeys j ON sp.Id=j.DestinationSpaceportId
JOIN TravelCards tc ON j.Id=tc.JourneyId
JOIN Colonists c ON tc.ColonistId=c.Id
WHERE p.Name=@PlanetName
)
RETURN @Count
END

SELECT dbo.udf_GetColonistsCount('Otroyphus') 

--PO12

CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
BEGIN
DECLARE @ExistId INT = (SELECT Id FROM Journeys WHERE Id=@JourneyId)

DECLARE @ExistPurpose VARCHAR(11) = (SELECT Purpose FROM Journeys WHERE Id=@JourneyId and Purpose=@NewPurpose)

IF(@ExistId IS NULL)
	BEGIN
		THROW 50001,'The journey does not exist!',1
	END
IF(@ExistPurpose IS NOT NULL)
	BEGIN
		THROW 50002,'You cannot change the purpose!',1
	END

UPDATE Journeys
SET Purpose=@NewPurpose
WHERE Id=@JourneyId
END

EXEC usp_ChangeJourneyPurpose 4, 'Technical'
EXEC usp_ChangeJourneyPurpose 4, 'Technical'

EXEC usp_ChangeJourneyPurpose 2, 'Educational'
