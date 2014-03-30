-- Greg Abbene
-- Professor Labouseur 
-- Lab 8

-- Dropping Tables on Inital Build or Update
DROP TABLE IF EXISTS MovieActors;
DROP TABLE IF EXISTS MovieDirectors;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS People;

-- Core Table for Reference for Actors and Directors
CREATE TABLE People (
pID INT NOT NULL,
LastName VARCHAR(35) NOT NULL,
FirstName VARCHAR(35) NOT NULL,
Address VARCHAR(60), --Added address for the Actors as well
Status CHAR(1) DEFAULT 'N' CHECK (Status='A' or Status='D' or Status='B' or Status='N'), 
-- Status is a check for what position the Person is...A = Actor, D = Director, B = Both, and N = Information not avaliable or None  
PRIMARY KEY (pID)
);

-- Movies Table
CREATE TABLE Movies (
mID INT NOT NULL,
Title VARCHAR(40) NOT NULL,
Year INT NOT NULL,
DomesticSalesMillionsUSD NUMERIC(10,2),
ForeignSalesMillionsUSD NUMERIC(10,2),
VideoSalesMillionsUSD NUMERIC(10,2),
PRIMARY KEY (mID)
);

-- Actors Table 
CREATE TABLE Actors (
aID INT REFERENCES people(pID),
BirthDate DATE,
HairColor VARCHAR(20),
EyeColor VARCHAR(20),
HeightInches INT,
WeightLbs INT,
SGuildAnniversary DATE,
PRIMARY KEY (aID)
);

-- Directors Table
CREATE TABLE Directors (
dID INT REFERENCES people(pID),
SchoolAttended VARCHAR(40),
DGuildAnniversary DATE,
PRIMARY KEY (dID)
);

-- Reference for Each Movie the Given Actors
CREATE TABLE MovieActors(
mID INT REFERENCES Movies(mID),
aID INT REFERENCES Actors(aID),
PRIMARY KEY (mID, aID)
);

--Referential Integrity for Each Movie a Director Directs....
CREATE TABLE MovieDirectors(
mID INT REFERENCES Movies(mID),
dID INT REFERENCES Directors(dID),
PRIMARY KEY (mID, dID)
);

-- Insert Statements
INSERT INTO People (pID,LastName,FirstName,Address,Status)
VALUES
(1, 'Moore', 'Roger', '111 Slow Kick Drive', 'A'),
(2, 'Seymour', 'Jane', '195 Let Drive', 'A'),
(3, 'Hamilton', 'Guy', '199 Let Drive', 'D'),
(4, 'Lee', 'Christopher', '44 Lee Lane', 'A'),
(5, 'Ekland', 'Britt', '44 Ekkkk Avenue', 'A'),
(6, 'Apted', 'Michael', '007 Not Enough Lane', 'D'),
(7, 'Brosnan', 'Pierce', '007 Bond James Estate', 'A'),
(8, 'Marchceau', 'Sophie', '007 Bond James Estate', 'A'),
(9, 'Campbell', 'Martin', '008 Eye Gold Lane', 'D'),
(10, 'Bean', 'Sean', '1 I Die In All My Movies Court', 'A'),
(11, 'Blackman', 'Honor', '69 Her Name Would Never Be Approved Now Lane', 'A'),
(12, 'Gilbert', 'Lewis', '111 Finger Gold Drive', 'D'),
(13, 'Dench', 'Judi', '007 M Estate', 'A'),
(14, 'Connery', 'Sean', '007 James Bond Estate', 'A'),
(15, 'Glen', 'John', '99 Has No Movies in DB Drive', 'D'),
(16, 'Hama', 'Mie', '2 Twice Drive', 'A'),
(17, 'Dor', 'Karin', '3 Trice Drive', 'A'),
(18, 'Young', 'Terence', '14 Mister No Drive', 'D'),
(19, 'Andress', 'Ursula', '0 Switzerland Drive', 'A');

INSERT INTO Movies (mID,Title,Year,DomesticSalesMillionsUSD,ForeignSalesMillionsUSD,VideoSalesMillionsUSD)
VALUES
(1, 'Live and Let Die', 1973, 35.4, 91.0, 56.9),
(2, 'The Man With the Golden Gun', 1974, 21.0, 76.6, 45.5),
(3, 'The World is Not Enough', 1999, 126.9, 212.6, 156.9),
(4, 'GoldenEye', 1995, 106.4, 250.9, 106.8),
(5, 'Goldfinger', 1964, 51.1, 73.8, 79.1),
(6, 'You Only Live Twice', 1967, 43.1, 68.5, 69.5),
(7, 'Dr.No', 1962, 16.1, 43.5, 30.2);

INSERT INTO Actors (aID,BirthDate,HairColor,EyeColor,HeightInches,WeightLbs,SGuildAnniversary)
VALUES
(1, '1927-10-14', 'Black', 'Green', 73, 185, '1947-10-3'),
(2, '1951-2-15', 'Red', 'Hazel', 64, 110, '1971-1-11'),
(4, '1922-5-27', 'Black', 'Brown', 77, 195, '1941-2-18'),
(5, '1942-10-6', 'Blond', 'Green', 65, 115, '1962-9-9'),
(7, '1953-5-16', 'Black', 'Blue', 73, 185, '1975-5-16'),
(8, '1966-10-17', 'Auburn', 'Green', 68, 120, '1986-11-12'),
(10, '1959-4-17', 'Blond', 'Blue', 71, 185, '1980-6-9'),
(11, '1934-12-9', 'Blond', 'Blue', 61, 100, '1955-2-19'),
(13, '1930-8-25', 'Black', 'Brown', 74, 190, '1955-5-11'),
(14, '1925-8-22', 'Blond', 'Blue', 66, 120, '1945-7-22'),
(16, '1943-10-20', 'Black', 'Hazel', 65, 120, '1963-12-2'),
(17, '1938-2-22', 'Blond', 'Brown', 65, 120, '1959-11-11'),
(19, '1936-3-19', 'Blond', 'Blue', 65, 120, '1956-7-7');

INSERT INTO Directors (dID,SchoolAttended,DGuildAnniversary)
VALUES
(3, 'La Femis', '1945-6-23'),
(6, 'London Film Academy', '1966-9-9'),
(9, 'American Film Institute', '1964-5-4'),
(12, 'New York University', '1948-8-8'),
(15, 'London Film Academy', '1955-11-5'),
(18, 'University of Cambridge', '1937-8-8');

INSERT INTO MovieActors (mID,aID)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 4),
(2, 5),
(3, 7),
(3, 8),
(4, 7),
(4, 10),
(4, 13),
(5, 14),
(5, 11),
(6, 14), 
(6, 16),
(6, 17),
(7, 14),
(7, 19);

INSERT INTO MovieDirectors (mID,dID)
VALUES
(1, 3),
(2, 3),
(3, 6),
(4, 9),
(5, 3),
(6, 12),
(7, 18);

-- Just to check all data in each table...
SELECT * 
FROM People;
SELECT * 
FROM Movies;
SELECT *
FROM Actors;
SELECT *
FROM Directors;
SELECT *
FROM MovieActors;
SELECT *
FROM MovieDirectors;

-- Selects all of the Directors with whom have Worked with Sean Connery
SELECT DISTINCT d.dID, p.LastName, p.FirstName
FROM People p,
     Movies m,
     Directors d,
     MovieDirectors md
	WHERE md.dID = d.dID AND 
              m.mID = md.mID AND 
              d.dID = p.pID AND 
              md.mid IN 
		(SELECT m.mid
		FROM People p,
		     Actors a,
		     Movies m,
		     MovieActors ma
			WHERE p.pID = a.aID AND 
			      m.mID = ma.mID AND 
			      a.aID = ma.aID AND 
			      p.LastName = 'Connery' AND 
			      p.FirstName = 'Sean'
);