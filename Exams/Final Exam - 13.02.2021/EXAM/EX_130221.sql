
CREATE DATABASE Bitbucket
USE Bitbucket
DROP DATABASE Bitbucket

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	Password VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
	Id INT PRIMARY KEY IDENTITY,
	Name  VARCHAR(50) NOT NULL,
)

CREATE TABLE RepositoriesContributors
(
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	ContributorId INT FOREIGN KEY REFERENCES Users(Id),
	PRIMARY KEY(RepositoryId,ContributorId)
)

CREATE TABLE Issues
(
	Id INT PRIMARY KEY IDENTITY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus	 CHAR(6) NOT NULL,
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id),
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id),
)

CREATE TABLE Commits
(
	Id INT PRIMARY KEY IDENTITY,
	Message	VARCHAR(255) NOT NULL,
	IssueId	INT FOREIGN KEY REFERENCES Issues(Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL, 
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
)

CREATE TABLE Files
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(100) NOT NULL,	
	Size DECIMAL(15,2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id),

)

--PO2

INSERT INTO Files
VALUES ('Trade.idk',2598.0,1,1),
('menu.net',9238.31,2,2),
('Administrate.soshy',	1246.93,	3,	3),
('Controller.php',7353.15,	4,	4),
('Find.java',9957.86,	5,	5),
('Controller.json',	14034.87,	3,	6),
('Operate.xix',	7662.92,	7,	7)

INSERT INTO Issues
VALUES('Critical Problem with HomeController.cs file','open',	1,	4),
('Typo fix in Judge.html','open',	4,	3),
('Implement documentation for UsersService.cs','closed',	8,	2),
('Unreachable code in Index.cs','open',	9,	8)

--PO3

UPDATE Issues
SET IssueStatus='closed'
WHERE AssigneeId=6

--PO4

DELETE FROM RepositoriesContributors
WHERE RepositoryId= (SELECT TOP(1) r.Id FROM RepositoriesContributors rr
JOIN Repositories r ON rr.RepositoryId=r.Id
WHERE r.Name='Softuni-Teamwork')

SELECT * FROM RepositoriesContributors
WHERE RepositoryId = (SELECT TOP(1) r.Id FROM RepositoriesContributors rr
JOIN Repositories r ON rr.RepositoryId=r.Id
WHERE r.Name='Softuni-Teamwork')


SELECT * FROM Repositories
WHERE Id=3

DELETE FROM Issues
WHERE RepositoryId = (SELECT Id FROM Repositories WHERE Name='Softuni-Teamwork')

--PO5

SELECT Id,Message,RepositoryId,ContributorId FROM Commits
ORDER BY Id,Message,RepositoryId,ContributorId

--PO6

SELECT Id,Name,Size FROM Files
WHERE Size>1000 AND Name LIKE '%html%'
ORDER BY Size DESC,Id,Name

--PO7

SELECT i.Id,u.Username+' : '+i.Title as IssueAssignee FROM Issues i
JOIN Users u ON i.AssigneeId=u.Id
ORDER BY i.Id DESC,i.AssigneeId

--PO8

SELECT Id,Name, CONVERT(VARCHAR(30),Size)+'KB' AS Size FROM Files f
WHERE f.Id NOT IN (
    SELECT DISTINCT ParentId 
    FROM Files WHERE ParentId IS NOT NULL)

SELECT * FROM Files
ORDER BY ParentId

--PO9

SELECT TOP(5) r.Id, r.Name, COUNT(c.Id) as Commits FROM RepositoriesContributors rc
JOIN Repositories r ON rc.RepositoryId=r.Id
JOIN Commits c ON c.RepositoryId=r.Id
GROUP BY r.Id, r.Name
ORDER BY COUNT(c.Id) DESC,r.Id,r.Name

--PO10
 
SELECT u.Username, AVG(f.Size) AS Size FROM Users u
JOIN Commits c ON u.Id=c.ContributorId
JOIN Files f ON c.Id=f.CommitId
GROUP BY u.Username
ORDER BY AVG(f.Size) DESC,u.Username

--PO11

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30)) 
RETURNS INT
AS
BEGIN
DECLARE @OutputCount INT = (SELECT Output FROM (SELECT COUNT(*) as Output FROM Users u
JOIN Commits cc ON u.Id=cc.ContributorId
WHERE u.Username=@username) AS K)

RETURN @OutputCount
END

SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

--PO12

CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(20))
AS
SELECT Id,Name,CONVERT(VARCHAR(50),Size)+'KB' AS Size FROM Files
WHERE RIGHT(Name,LEN(@fileExtension))=@fileExtension
ORDER BY Id,Name,Size DESC

EXEC usp_SearchForFiles 'txt'
