
--PO1

CREATE DATABASE WMS
drop database WMS
USE WMS

CREATE TABLE Clients
(
 ClientId SMALLINT PRIMARY KEY IDENTITY,
 FirstName VARCHAR(50),
 LastName VARCHAR(50),
 Phone CHAR(12) NOT NULL
)

CREATE TABLE Mechanics
(
MechanicId	SMALLINT PRIMARY KEY IDENTITY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Address	 VARCHAR(255),
)

CREATE TABLE Models
(
ModelId	SMALLINT PRIMARY KEY IDENTITY,
Name VARCHAR(50) UNIQUE
)

CREATE TABLE Jobs
(
JobId SMALLINT PRIMARY KEY IDENTITY,
ModelId	SMALLINT FOREIGN KEY REFERENCES Models(ModelId),
Status	VARCHAR(11) DEFAULT 'Pending',
ClientId SMALLINT FOREIGN KEY REFERENCES Clients(ClientId),
MechanicId SMALLINT FOREIGN KEY REFERENCES Mechanics(MechanicId),      --Can be NULL
IssueDate	DATE NOT NULL,
FinishDate	DATE,
CONSTRAINT CHK_Status CHECK (Status='Pending' OR Status='In Progress' OR Status='Finished')
)

CREATE TABLE Orders
(
	OrderId SMALLINT PRIMARY KEY IDENTITY,
	JobId SMALLINT FOREIGN KEY REFERENCES Jobs(JobId),
	IssueDate DATE,
	Delivered BIT DEFAULT 0,
)

CREATE TABLE Vendors
(
	VendorId SMALLINT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) UNIQUE
)

CREATE TABLE Parts
(
	PartId	SMALLINT PRIMARY KEY IDENTITY,
	SerialNumber VARCHAR(50) UNIQUE,
	Description	VARCHAR(255),
	Price DECIMAL(6,2) CHECK(Price>0), 
	VendorId SMALLINT FOREIGN KEY REFERENCES Vendors(VendorId),
	StockQty SMALLINT DEFAULT 0 CHECK (StockQty>=0)
)

CREATE TABLE OrderParts
(
	OrderId	SMALLINT FOREIGN KEY REFERENCES Orders(OrderId),
	PartId	SMALLINT FOREIGN KEY REFERENCES Parts(PartId),
	Quantity SMALLINT DEFAULT 1 CHECK(Quantity>=1),
	CONSTRAINT PK_Part PRIMARY KEY (OrderId,PartId)
)

CREATE TABLE PartsNeeded
(
	JobId SMALLINT FOREIGN KEY REFERENCES Jobs(JobId),
	PartId	SMALLINT FOREIGN KEY REFERENCES Parts(PartId),
	Quantity SMALLINT DEFAULT 1 CHECK(Quantity>=1),
	CONSTRAINT PK_Need PRIMARY KEY (JobId,PartId)
)

--PO2

INSERT INTO Clients(FirstName,LastName,Phone)
VALUES('Teri','Ennaco','570-889-5187'),('Merlyn','Lawler','201-588-7810'),('Georgene','Montezuma','925-615-5185')
,('Jettie','Mconnell','908-802-3564'),('Lemuel','Latzke','631-748-6479'),('Melodie','Knipp','805-690-1682'),('Candida','Corbley','908-275-8357')

INSERT INTO Parts (SerialNumber,Description,Price,VendorId)
VALUES ('WP8182119','Door Boot Seal',117.86,2),('W10780048','Suspension Rod',42.81,1),
('W10841140','Silicone Adhesive ',6.77,4),('WPY055980','High Temperature Adhesive',13.94,3)

--PO3

UPDATE Jobs
SET Status='In Progress', MechanicId=3
WHERE Status='Pending'

--PO4

DELETE FROM OrderParts
WHERE OrderId=19
DELETE FROM Orders
WHERE OrderId=19

--PO5

SELECT m.FirstName+' '+m.LastName as Mechanic,j.Status,j.IssueDate FROM Mechanics m
JOIN Jobs j ON m.MechanicId=J.MechanicId
ORDER BY m.MechanicId,j.IssueDate,j.JobId

--PO6

SELECT * FROM Clients

SELECT c.FirstName+' '+c.LastName as Client, ABS(DATEDIFF(day,'2017-04-24',j.IssueDate)) as 'Days going',j.Status FROM Jobs j
JOIN Clients c ON j.ClientId=c.ClientId
where j.Status != 'Finished'
ORDER BY ABS(DATEDIFF(day,'2017-04-24',j.IssueDate)) DESC,c.ClientId

--PO7

SELECT Mechanic,[Average Days] FROM(
SELECT m.MechanicId, m.FirstName+' '+m.LastName as Mechanic,AVG(ABS(DATEDIFF(day,j.FinishDate,j.IssueDate))) as [Average Days] FROM Jobs j
JOIN Mechanics m ON j.MechanicId=m.MechanicId
GROUP BY  m.MechanicId, m.FirstName,m.LastName
) AS K

--PO8

SELECT m.FirstName+' '+m.LastName as Available FROM Mechanics AS m
LEFT JOIN Jobs j ON m.MechanicId=j.MechanicId
WHERE j.Status='Finished' or j.Status IS NULL
GROUP BY m.FirstName+' '+m.LastName,m.MechanicId
ORDER BY m.MechanicId

--SECOND DECISION--> MUCH BETTER
SELECT m.FirstName+' '+m.LastName as Available,J.Status FROM Mechanics AS m
LEFT JOIN Jobs j ON m.MechanicId=j.MechanicId
WHERE j.Status IS NULL OR 'Finished'=ALL(SELECT j.Status FROM Jobs J 
											WHERE j.MechanicId=m.MechanicId)
GROUP BY m.FirstName+' '+m.LastName,m.MechanicId
ORDER BY m.MechanicId

--PO9

SELECT j.JobId, ISNULL(SUM(p.Price*op.Quantity),0) AS Total FROM Jobs j
JOIN Orders o ON j.JobId=o.JobId
JOIN OrderParts op ON o.OrderId=op.OrderId
JOIN Parts p ON op.PartId=p.PartId
WHERE j.Status='Finished'
GROUP BY j.JobId
ORDER BY SUM(p.Price*op.Quantity) DESC,j.JobId

--PO10

SELECT p.PartId,p.Description,pn.Quantity as Required,p.StockQty as 'In Stock',IIF(o.Delivered=0,op.Quantity,0) as Ordered FROM Parts p
LEFT JOIN PartsNeeded pn ON p.PartId=pn.PartId
LEFT JOIN OrderParts op ON pn.PartId=op.PartId
LEFT JOIN Jobs j ON pn.JobId=j.JobId
LEFT JOIN Orders o ON o.JobId=j.JobId
WHERE j.Status!='Finished' AND p.StockQty +IIF(o.Delivered=0,op.Quantity,0)<pn.Quantity
ORDER BY p.PartId

--PO11

CREATE PROC usp_PlaceOrder (@JobId INT,@SerialNumber VARCHAR(50),@QTY INT) 
AS

DECLARE @status VARCHAR(10)= (SELECT * FROM Jobs WHERE JobId=@JobId)
DECLARE @partId VARCHAR(10)= (SELECT * FROM Parts WHERE SerialNumber=@SerialNumber)

IF(@status='Finished')
THROW 50011,'This job is not active!',1
ELSE IF(@QTY<=0)
THROW 50012,'Part quantity must be more than zero!',1
ELSE IF(@status IS NULL)
THROW 50013,'Job not found!',1
ELSE IF(@partId IS NULL)
THROW 50014,'Part not found!',1

DECLARE @doesOrderExist INT = (SELECT OrderId FROM Orders WHERE JobId=@JobId)
IF(@doesOrderExist IS NULL)
BEGIN

	INSERT INTO Orders(JobId,IssueDate)
	VALUES(@JobId,NULL)
	
	SET @doesOrderExist = (SELECT OrderId FROM Orders WHERE JobId=@JobId)
	
	INSERT INTO OrderParts(OrderId,PartId,Quantity)
	VALUES(@doesOrderExist,@partId,@QTY)

END
ELSE
BEGIN
	DECLARE @issueDate DATE = (SELECT IssueDate FROM Orders WHERE OrderId=@doesOrderExist)
	IF(@issueDate IS NULL)
		INSERT INTO OrderParts(OrderId,PartId,Quantity)
		VALUES(@doesOrderExist,@partId,@QTY)
	ELSE 
		UPDATE OrderParts
		SET Quantity+=@QTY
		WHERE OrderId=@doesOrderExist and PartId=@partId
END

--PO12

CREATE FUNCTION udf_GetCost(@JobId INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
DECLARE @Result DECIMAL(15,2);
SET @Result=(SELECT SUM(p.Price*op.Quantity) AS Result FROM Jobs j
LEFT JOIN Orders o ON j.JobId=o.JobId
JOIN OrderParts op ON o.OrderId=op.OrderId
LEFT JOIN Parts p ON op.PartId=p.PartId
WHERE j.JobId=@JobId
GROUP BY j.JobId)

IF(@Result IS NULL)
SET @Result=0

RETURN @Result
END


