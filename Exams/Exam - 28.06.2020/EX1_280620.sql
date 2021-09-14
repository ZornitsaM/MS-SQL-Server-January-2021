

CREATE DATABASE ColonialJourney
USE ColonialJourney
DROP DATABASE ColonialJourney

CREATE TABLE Planets
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PlanetId INT FOREIGN KEY REFERENCES Planets(Id)
)


CREATE TABLE Spaceships
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20) NOT NULL,	
	LastName VARCHAR(20) NOT NULL,
	Ucn	 VARCHAR(10) NOT NULL UNIQUE,
	BirthDate DATE NOT NULL	
)

CREATE TABLE Journeys
(
	Id INT PRIMARY KEY IDENTITY,
	JourneyStart DATETIME NOT NULL,	
	JourneyEnd DATETIME NOT NULL,	
	Purpose	VARCHAR(11) CHECK(Purpose IN('Medical','Technical','Educational','Military')),
	DestinationSpaceportId	INT FOREIGN KEY REFERENCES Spaceports(Id),
	SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id)
)


CREATE TABLE TravelCards
(
	Id INT PRIMARY KEY IDENTITY,
	CardNumber	CHAR(10) NOT NULL UNIQUE,
	JobDuringJourney VARCHAR(8)	CHECK(JobDuringJourney IN ('Pilot','Engineer','Trooper','Cleaner','Cook')),
	ColonistId INT FOREIGN KEY REFERENCES Colonists(Id),
	JourneyId INT FOREIGN KEY REFERENCES Journeys(Id),
)

--PO2

INSERT INTO Planets
VALUES ('Mars'),('Earth'),('Jupiter'),('Saturn')

INSERT INTO Spaceships
VALUES ('Golf','VW',3),('WakaWaka','Wakanda',4),('Falcon9','SpaceX',1),('Bed','Vidolov',6)


--PO3

UPDATE Spaceships
SET LightSpeedRate+=1
WHERE Id BETWEEN 8 AND 12

SELECT * FROM Journeys


ALTER TABLE Journeys
ADD CONSTRAINT FK__Journeys__Destin__2F10007BCascade
   FOREIGN KEY (DestinationSpaceportId) REFERENCES Spaceports(Id) ON DELETE CASCADE


ALTER TABLE Journeys
ADD CONSTRAINT FK__Journeys__Spaces__300424B4Cascade
   FOREIGN KEY (SpaceshipId) REFERENCES Spaceships(Id) ON DELETE CASCADE


ALTER TABLE TravelCards
ADD CONSTRAINT FK__TravelCar__Colon__34C8D9D1Cascade
   FOREIGN KEY (JourneyId) REFERENCES Journeys(Id) ON DELETE CASCADE

DELETE FROM Journeys
WHERE Id BETWEEN 1 AND 3


--PO5

SELECT Id,FORMAT(JourneyStart,'dd/MM/yyyy') as JourneyStart,FORMAT(JourneyEnd,'dd/MM/yyyy') as JourneyEnd FROM Journeys
WHERE Purpose='Military'
ORDER BY JourneyStart

--PO6

SELECT c.Id,c.FirstName+' '+c.LastName as 'full_name' FROM Colonists c
JOIN TravelCards tc ON c.Id=tc.ColonistId
WHERE tc.JobDuringJourney='Pilot'
ORDER BY c.Id

--PO7


SELECT COUNT(c.Id) as count FROM Colonists c
JOIN TravelCards tc ON c.Id=tc.ColonistId
JOIN Journeys j ON tc.JourneyId=j.Id
WHERE j.Purpose='Technical'

--PO8

select * from Colonists
ORDER BY Name

SELECT s.Name,
       s.Manufacturer FROM Spaceships s
JOIN Journeys j ON s.Id=j.SpaceshipId
JOIN TravelCards tc ON tc.JourneyId=j.Id
JOIN Colonists c on TC.ColonistId=c.Id
WHERE tc.JobDuringJourney='Pilot' AND DATEDIFF(YEAR,c.BirthDate,'01/01/2019') < 30
ORDER BY s.Name



SELECT sp.Name as 'Name',sp.Manufacturer as Manufacturer FROM Colonists c
JOIN TravelCards tc ON c.Id=tc.ColonistId
JOIN Journeys j ON j.Id=tc.JourneyId
JOIN Spaceships sp ON sp.Id=j.SpaceshipId
WHERE DATEDIFF(year,c.BirthDate,'01/01/2019') <=30 and tc.JobDuringJourney='Pilot'
GROUP BY sp.Name,sp.Manufacturer 
ORDER BY sp.Name

--PO9

SELECT * FROM Journeys
SELECT * FROM Spaceports

SELECT p.Name as PlanetName, COUNT(j.Id) as JourneysCount FROM Planets p
JOIN Spaceports sp ON p.Id=sp.PlanetId
JOIN Journeys j on sp.Id=j.DestinationSpaceportId
GROUP BY p.Name
ORDER BY COUNT(j.Id) DESC,p.Name

--PO10

select * from Colonists
select * from TravelCards


SELECT JobDuringJourney, FullName, JobRank FROM (
SELECT tc.JobDuringJourney AS JobDuringJourney, c.FirstName+' '+c.LastName as FullName, DENSE_RANK() OVER   
    (PARTITION BY JobDuringJourney ORDER BY BirthDate ASC) AS JobRank FROM Colonists c
JOIN TravelCards tc ON c.Id=tc.ColonistId) AS K
WHERE JobRank=2


--PO11

select * from Journeys

CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
BEGIN
DECLARE @Count INT = (SELECT COUNT(c.Id) FROM Colonists c
JOIN TravelCards tc ON  c.Id=tc.ColonistId
JOIN Journeys j ON tc.JourneyId=j.Id
JOIN Spaceports sp ON j.DestinationSpaceportId=sp.Id
JOIN Planets p on sp.PlanetId=p.Id
WHERE p.Name=@PlanetName)

RETURN @Count
END

--PO12

SELECT * FROM Journeys

CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(30))
AS

DECLARE @CurrentJourneyId INT = (SELECT Id FROM Journeys WHERE Id=@JourneyId)

IF(@CurrentJourneyId IS NULL)
THROW 50001,'The journey does not exist!',1;
DECLARE @CurrentJourneyIdSamePurpose VARCHAR(30) = (SELECT Purpose FROM Journeys WHERE Id=@JourneyId)
IF(@CurrentJourneyIdSamePurpose=@NewPurpose)
THROW 50002,'You cannot change the purpose!',1;

SELECT Id FROM Journeys WHERE Id=@JourneyId

UPDATE Journeys
SET Purpose=@NewPurpose
WHERE Id=@JourneyId


