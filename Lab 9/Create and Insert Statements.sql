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
DROP TABLE IF EXISTS Spacecrafts;
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
CREATE TABLE Spacecrafts (
Sid INTEGER NOT NULL,
Name TEXT NOT NULL,
TailNumber VARCHAR(35) NOT NULL,
WgtTons BIGINT NOT NULL,
Fuel CHAR(1) NOT NULL DEFAULT 'S' CHECK(Fuel='S'or Fuel='B' or Fuel='A'), -- Defaults to "SOlid-Fuel" 
--type as "S" and checks for either biopropellant("B") or Air-Breathing("A")
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
Name TEXT NOT NULL,
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
Sid INTEGER REFERENCES Spacecrafts(Sid), 
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
Sid INTEGER REFERENCES Spacecrafts(Sid),
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

INSERT INTO Spacecrafts (Sid,Name,TailNumber,WgtTons,Fuel,CrewCapacity)
VALUES
(1, 'Braavos', 'Z2398571', 75, 'A', 5), 
(2, 'Winterfell', 'SS22031', 100, 'S', 7), 
(3, 'Kings Landing', 'LSM85931', 150, 'B', 10), 
(4, 'Iron Islands', 'K784012', 90, 'S', 7); 

INSERT INTO Flights(Fid,Sid)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 3);

INSERT INTO Systems(SysID,Name,Description)
VALUES
(1, 'Dothraki', 'A Primitive System'),
(2, 'Riverrun', 'Black Fish System..the Sky is the Limit'),
(3, 'Khalessi', 'Dragon System!!'),
(4, 'Knights Watch', 'The Watcher of the Wall...and Best System');

INSERT INTO Parts(PartID,Name,Description)
VALUES
(1, 'Arakh', 'Orbiter'),
(2, 'Gold', 'Orbiter'),
(3, 'Valyrian', 'Orbiter'),
(4, 'Fish', 'External Tank'),
(5, 'Dragon', 'External Tank'),
(6, 'White Walker', 'External Tank'),
(7, 'Earth', 'Booster'),
(8, 'Fire', 'Booster'),
(9, 'Ice', 'Booster');


INSERT INTO Suppliers(SupID,Name,Address,PmtTerms)
VALUES
(1, 'Dorne', '2 South Bay', '10 days'),
(2, 'Lanisport', '1 Casterly Rock', '2 days'),
(3, 'Blackwater', '14 Broken Bay', '60 days');

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

INSERT INTO Crew (Fid,Pid)
VALUES
(1, 3),
(1, 6),
(1, 9),
(2, 3),
(2, 5),
(2, 7),
(3, 1),
(3, 2),
(3, 4),
(3, 9),
(4, 2),
(4, 5),
(4, 8),
(5, 1),
(5, 2),
(5, 6),
(5, 7);

INSERT INTO Internal (Sid,SysID)
VALUES
(1, 2),
(1, 3),
(2, 4),
(3, 1),
(4, 4);

INSERT INTO SystemDetails (SysID,PartID)
VALUES
(1, 1),
(1, 4),
(1, 7),
(2, 3),
(2, 4),
(2, 9),
(3, 2),
(3, 5),
(3, 8),
(4, 3),
(4, 6),
(4, 9);

INSERT INTO Catalog (Cid,SupID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 3),
(5, 2),
(6, 2),
(7, 2),
(8, 3),
(9, 1);

SELECT * FROM
People
--Engineer
--Astronaut
--Operator
--Internal
--Crew
--Flights
--Systems
--Spacecrafts