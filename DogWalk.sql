-- Create tables for each entity.
CREATE TABLE Neighborhood (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL
);

CREATE TABLE [Owner] (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	NeighborhoodId INTEGER,
	Phone VARCHAR(55) NOT NULL,
	CONSTRAINT FK_Owner_Neighborhood FOREIGN KEY (NeighborhoodId) REFERENCES Neighborhood(Id)
);

CREATE TABLE Dog (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	OwnerId INTEGER NOT NULL,
	Breed VARCHAR(55) NOT NULL,
	Notes VARCHAR(255),
	CONSTRAINT FK_Dog_Owner FOREIGN KEY (OwnerId) REFERENCES [Owner](Id)
);

CREATE TABLE Walker (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	NeighborhoodId INTEGER,
	CONSTRAINT FK_Walker_Neighborhood FOREIGN KEY (NeighborhoodId) REFERENCES Neighborhood(Id)
);

CREATE TABLE Walks (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Date] DATETIME NOT NULL,
	Duration INTEGER NOT NULL,
	WalkerId INTEGER NOT NULL,
	DogId INTEGER NOT NULL,
	CONSTRAINT FK_Walks_Walker FOREIGN KEY (WalkerId) REFERENCES Walker(Id),
	CONSTRAINT FK_Walks_Dog FOREIGN KEY (DogId) REFERENCES Dog(Id)
);

-- Populate each table with data. You should have 2-3 neighborhoods, 5-10 dogs, 4-8 owners, 2-5 walkers and each walker should have 1-2 walks recorded.
INSERT INTO Neighborhood ([Name]) VALUES ('Aberdale');
INSERT INTO Neighborhood ([Name]) VALUES ('Aron City');
INSERT INTO Neighborhood ([Name]) VALUES ('Bayport');

INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('John Sanchez', '355 Main St', 1, '(615)-553-2456');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Patricia Young', '233 Washington St', 2, '(615)-448-5521');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Robert Brown', '145 Sixth Ave', 3, '(615)-323-7711');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Jennifer Wilson', '495 Cedar Rd', 1, '(615)-919-8944');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Michael Moore', '88 Oak St', 2, '(615)-556-7273');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Linda Green', '53 Lake Cir', 3, '(615)-339-4488');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('William Anderson', '223 Hill St', 1, '(615)-232-6768');

INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Ninni', 1, 'Rottweiler');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Kuma', 1, 'Rottweiler');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Remy', 2, 'Greyhound');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Xyla', 3, 'Dalmation');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Chewy', 3, 'Beagle');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Groucho', 4, 'Dalmation');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Finley', 5, 'Golden Retriever');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Casper', 6, 'Golden Retriever');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Bubba', 7, 'English Bulldog');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Zeus', 7, 'Schnauzer');

INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Paul Thompson', 1);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Margaret Phillips', 1);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Anthony Gray', 2);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Melissa Perez', 3);

INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-17 17:30:00', 1200, 1, 11);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-17 17:30:00', 1200, 1, 12);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-15 16:00:00', 900, 2, 19);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-18 08:30:00', 1800, 2, 16);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-15 12:00:00', 1750, 3, 13);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-19 09:00:00', 1275, 3, 17);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-16 13:30:00', 2000, 4, 14);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-16 13:30:00', 2000, 4, 15);

-- Write a query to return all owners names and the name of their neighborhood.
SELECT o.[Name], n.[Name]
FROM [Owner] o
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id

-- Write a query to return the name and neighborhood of a single owner (can be any Id).
SELECT o.[Name], n.[Name]
FROM [Owner] o
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id
WHERE o.Id = 1

-- Write a query to return all walkers ordered by their name.
SELECT *
FROM Walker
ORDER BY [Name] ASC

-- Write a query to return a list of unique dog breeds.
SELECT DISTINCT Breed
FROM Dog

-- Write a query to return a list of all dog's names along with their owner's name and what neighborhood they live in.
SELECT d.[Name] AS [Dog's Name], o.[Name], n.[Name] AS Neighborhood
FROM Dog d
LEFT JOIN [Owner] o ON d.OwnerId = o.Id
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id

-- Return a list of owners along with a count of how many dogs they have.
SELECT o.[Name], COUNT(d.OwnerId) AS Dogs
FROM Dog d
LEFT JOIN [Owner] o ON d.OwnerId = o.Id
GROUP BY o.[Name]

-- Return a list of walkers along with the amount of walks they've recorded.
SELECT wr.[Name], COUNT(ws.WalkerId) AS Walks
FROM Walks ws
LEFT JOIN Walker wr ON ws.WalkerId = wr.Id
GROUP BY wr.[Name]

-- Return a list of all neighborhoods with a count of how many walkers are in each, but do not show neighborhoods that don't have any walkers.
-- Added a neighborhood to my database that doesn't have any walkers:
INSERT INTO Neighborhood ([Name]) VALUES ('Varrock');

SELECT n.[Name] AS Neighborhood, COUNT(w.NeighborhoodId) AS Walkers
FROM Walker w
LEFT JOIN Neighborhood n ON w.NeighborhoodId = n.Id
GROUP BY n.[Name]

-- Return a list of dogs that have been walked in the past week.
SELECT * 
FROM Walks
WHERE [Date] BETWEEN '2020-03-12 00:00:00' AND GETDATE();

-- Return a list of dogs that have not been on a walk.
SELECT d.[Name], d.Breed
FROM Dog d
LEFT JOIN Walks w ON d.Id = w.DogId
WHERE w.Id IS NULL
GROUP BY d.[Name], d.Breed