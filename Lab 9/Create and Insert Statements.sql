-- Greg Abbene
-- Professor Labouseur
-- Lab 9

-- Dropping Tables on Inital Build or Update
-- Drop Children First, then Parent Tables

DROP TABLE IF EXISTS Engineer;
DROP TABLE IF EXISTS Astronaut;
DROP TABLE IF EXISTS Operator;
DROP TABLE IF EXISTS Crew;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Internal;
DROP TABLE IF EXISTS SystemDetails;
DROP TABLE IF EXISTS Catalog;
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS Spacecraft;
DROP TABLE IF EXISTS Systems;
DROP TABLE IF EXISTS Parts;
DROP TABLE IF EXISTS Suppliers;

-- Create Statements and Brief Data Examples

-- Core Table for Reference for All Jobs 
CREATE TABLE People (
Pid INTEGER NOT NULL,
LastName VARCHAR(35) NOT NULL,
FirstName VARCHAR(35) NOT NULL,
Age INTEGER NULL,
PRIMARY KEY (Pid)
);

-- Core Table for Reference for Spacecraft details
CREATE TABLE Spacecraft (
Sid INTEGER NOT NULL,
Name TEXT NOT NULL,
TailNumber VARCHAR(35) NOT NULL,
WgtTons BIGINT NULL,
Fue BIGINT NULL,
CrewCapacity INTEGER NULL,
PRIMARY KEY (Sid)
); 

-- Core Table for Reference of Parts 
CREATE TABLE Systems (
SysID INTEGER NOT NULL,
Name TEXT NOT NULL,
Description TEXT NULL,
PRIMARY KEY (SysID)
); 

-- Core Table for Reference of Catalog
CREATE TABLE Parts (
PartID INTEGER NOT NULL,
Name TEXT NOT NULL,
Description TEXT NULL,
PRIMARY KEY (PartID)
); 

-- Core Table for Reference of Catalog
CREATE TABLE Suppliers (
SupID INTEGER NOT NULL,
Address VARCHAR(60) NOT NULL,
PmtTerms TEXT NOT NULL,
PRIMARY KEY (SupID)
); 

-- Engineer Table
CREATE TABLE Engineer (
Eid INTEGER REFERENCES People(Pid),
Degree TEXT NOT NULL,
FavoriteVG VARCHAR(60) NULL,
PRIMARY KEY (Eid)
); 

-- Astronaut Table
CREATE TABLE Astronaut (
Aid INTEGER REFERENCES People(Pid),
YearsFlying INTEGER NOT NULL,
GolfHC VARCHAR(5) NULL,
PRIMARY KEY (Aid)
); 

-- Operator Table
CREATE TABLE Operator (
Oid INTEGER REFERENCES People(Pid),
ChairPref TEXT NOT NULL,  --Add Check constraint here with default as None?
DrinkPref TEXT NULL, --And maybe here??
PRIMARY KEY (Oid)
); 

-- Flights Table
CREATE TABLE Flights (
Fid INTEGER NOT NULL UNIQUE,
Sid INTEGER REFERENCES Spacecraft(Sid), 
PRIMARY KEY (Fid,Sid)
); 

-- Crew Table
CREATE TABLE Crew (
Fid INTEGER REFERENCES Flights(Fid),
Pid INTEGER REFERENCES People(Pid), 
PRIMARY KEY (Fid,Pid)
); 

-- Internal Table
CREATE TABLE Internal (
Sid INTEGER REFERENCES Spacecraft(Sid),
SysID INTEGER REFERENCES Systems(SysID), 
PRIMARY KEY (Sid,SysID)
); 

-- SystemDetails Table
CREATE TABLE SystemDetails (
SysID INTEGER REFERENCES Systems(SysID),
PartID INTEGER REFERENCES Parts(PartID), 
PRIMARY KEY (SysID,PartID)
); 

-- Catalog Table
CREATE TABLE Catalog (
Cid INTEGER REFERENCES Parts(PartID),
SupID INTEGER REFERENCES Suppliers(SupID), 
PRIMARY KEY (Cid ,SupID)
); 

-- SAMPLE DATA FOR INSERT STATEMENTS
INSERT INTO People (Pid,LastName,FirstName,Age)
VALUES
(1, 'Lannister', 'Cersei', 40), --Engineer
(2, 'Lannister', 'Jamie', 40), --Engineer
(3, 'Lannister', 'Tyrion', 30), --Engineer
(4, 'Stark', 'Sansa', 14), -- Operator
(5, 'Stark', 'Bran', 10), -- Operator
(6, 'Stark', 'Arya', 12), -- Operator
(7, 'Aldridge', 'Buzz', 82), -- Astronaut
(8, 'Armstrong', 'Neil', 82), --Astronaut
(9, 'Sean', 'Connery', 83); --Astronaut

INSERT INTO Engineer (Eid,Degree,FavoriteVG)
VALUES
(1, 'Bachelor of Engineering in Chemical Engineering', 'Grand Theft Auto'), -- Cersei 
(2, 'Master of Sciene in Electrical Engineering', 'Skyrim'), -- Jamie
(3, 'Doctor of Philosophy in Strategy', 'Risk'); -- Tyrion

INSERT INTO Operator (Oid,ChairPref,DrinkPref)
VALUES
(4, 'Guidance Procedures Officer', 'Ginger Ale'), -- Sansa 
(5, 'Flight Director', 'Water'), -- Bran
(6, 'Spacecraft Communicator', 'Dornish Wine'); -- Arya

INSERT INTO Astronaut (Aid,YearsFlying,GolfHC)
VALUES
(7, 45, '-1'), -- Buzz 
(8, 45, '-1'), -- Neil
(9, 80, '+99'); --Sean

SELECT * FROM OPERATOR