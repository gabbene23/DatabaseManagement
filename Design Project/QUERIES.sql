-- Gregory Abbene
-- Professor Labouseur
-- Design Project
-- Due: April 25th 2014

-- VIEWS start around line 625
-- REPORTS start around line 715
-- STORE PROCEDURES and TRIGGERS start around line 810

-- Drop All Views and Tables
-- Drop Children First, then Parent Tables

DROP VIEW IF EXISTS VendorContact;
DROP VIEW IF EXISTS CustomerContact;
DROP VIEW IF EXISTS DailyAccounting;
DROP VIEW IF EXISTS MarketingAreas;
DROP VIEW IF EXISTS DepartmentSalesHistory;
DROP VIEW IF EXISTS CategorySalesHistory;
DROP VIEW IF EXISTS ItemMargin;
DROP VIEW IF EXISTS DailySalesUPC;
DROP VIEW IF EXISTS ItemLookup;
DROP VIEW IF EXISTS ZeroSalesUPC;
DROP VIEW IF EXISTS VendorNew;
DROP VIEW IF EXISTS DailyATSales;

DROP TABLE IF EXISTS PeopleAddresses;
DROP TABLE IF EXISTS VendorAddresses;
DROP TABLE IF EXISTS PeoplePhone;
DROP TABLE IF EXISTS VendorPhone;
DROP TABLE IF EXISTS CategoryItems;
DROP TABLE IF EXISTS DepartmentCategories;
DROP TABLE IF EXISTS DepartmentItems;
DROP TABLE IF EXISTS VendorItems;
DROP TABLE IF EXISTS ItemPrice;
DROP TABLE IF EXISTS VendorCost;
DROP TABLE IF EXISTS ItemsPurchased;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS ZipCodes;
DROP TABLE IF EXISTS Regions;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS DailySales;
DROP TABLE IF EXISTS Item;

-- Create Statements

-- Item Table
CREATE TABLE Item(
-- Using Universal Price Code (UPC) as Unique Identifier/primary key
	UPC CHAR(12) NOT NULL,
	Name VARCHAR(35) NULL,
	Description TEXT NULL,
-- Checking  Tax Code for flexiably defined Tax Codes for items in particular regions
-- This is set by an additional application, but funtionally it is just to show different 
-- Tax Codes, and also setting Default to TaxCode A
	TaxCode CHAR(1) NOT NULL DEFAULT 'A' CHECK(TaxCode = 'A' OR TaxCode = 'B' OR TaxCode = 'C' 
	OR TaxCode = 'D' OR TaxCode = 'E' OR TaxCode = 'F'),
-- "Women Infant and Children" flag to see if it can be applied for state/region funded program
-- ...has default and check --> 0 = No and 1 = Yes (it can be applied)
	WIC CHAR(1)NOT NULL DEFAULT '0' CHECK(WIC = '0' OR WIC = '1'),
-- WICCVV and Foodstamp have same logic as WIC field
	WICCVV CHAR(1)NOT NULL DEFAULT '0' CHECK(WICCVV = '0' OR WICCVV = '1'),
	Foodstamp CHAR(1)NOT NULL DEFAULT '0' CHECK(Foodstamp = '0' OR Foodstamp = '1'),
	PRIMARY KEY (UPC)
); 

-- Categories Table
CREATE TABLE Categories(
-- Using Category Code (Category) as unique identifyer/primary key 
	Category INTEGER NOT NULL,
	Name VARCHAR(35) NULL,
	Description TEXT NULL,
	PRIMARY KEY (Category)
); 

-- Departments Table
CREATE TABLE Departments(
	dID INTEGER NOT NULL,
	Name VARCHAR(35) NULL,
	Description TEXT NULL,
	PRIMARY KEY (dID)
); 

-- Vendors Table
CREATE TABLE Vendors(
	vID INTEGER NOT NULL,
	Name VARCHAR(35) NULL,
	Description TEXT NULL,
	Email TEXT NULL,
	PRIMARY KEY (vID)
); 

-- People Table
CREATE TABLE People(
	pID INTEGER NOT NULL,
	LastName VARCHAR(35) NOT NULL,
	FirstName VARCHAR(35) NOT NULL,
	MiddleName VARCHAR(35) NULL,
	Email TEXT NULL,
-- Checking Gender, M = Male, F = Female, N = No Disclosure or Other
	Gender CHAR(1) NOT NULL CHECK(Gender = 'M' OR Gender = 'F' OR Gender = 'N'),
	BirthDate DATE NULL,
	PRIMARY KEY (pID)
); 

-- Customers Table
CREATE TABLE Customers(
	cID INTEGER REFERENCES People(pID),
-- The next four would most likely needed to be populated from an outside application
-- They are tracking curstomer spending and rewards points for thier entire account history
-- aswell as for the given "period" 
	PurchaseAmtToDate NUMERIC(10,2) NOT NULL,
	PurchaseAmtThisPeriod NUMERIC(10,2) NOT NULL,
	PointsToDate NUMERIC(8,2) NOT NULL,
	PointsThisPeriod NUMERIC(8,2) NOT NULL,
	PRIMARY KEY (cID)
); 

-- Employees Table
CREATE TABLE Employees(
	eID INTEGER REFERENCES People(pID),
	HourlyWages NUMERIC(4,2) NOT NULL,
	DateHired DATE NOT NULL,
-- Should add a check for all possible positons, but too many to simply track
-- Should make another tables as "Roles" and reference it with an integer
-- Decided to eliminate to narrow scope of project
	CurrentPosition TEXT NOT NULL,
	PRIMARY KEY (eID)
); 

--Category Items Table
CREATE TABLE CategoryItems(
	Category INTEGER REFERENCES Categories(Category),	
	UPC CHAR(12) REFERENCES Item(UPC),
	PRIMARY KEY (Category,UPC)
); 

-- Department Categories  Table
CREATE TABLE DepartmentCategories(
	dID INTEGER REFERENCES Departments(dID),	
	Category INTEGER REFERENCES Categories(Category),
	PRIMARY KEY (dID,Category)
); 

-- Department Items Table
CREATE TABLE DepartmentItems(
	dID INTEGER REFERENCES Departments(dID),	
	UPC CHAR(12) REFERENCES Item(UPC),
	PRIMARY KEY (dID,UPC)
); 

-- Vendor Items Table
CREATE TABLE VendorItems(
	vID INTEGER REFERENCES Vendors(vID),	
	UPC CHAR(12) REFERENCES Item(UPC),
	PRIMARY KEY (vID,UPC)
); 

-- Items Purchased Table
CREATE TABLE ItemsPurchased(
	cID INTEGER REFERENCES Customers(cID),	
	UPC CHAR(12) REFERENCES Item(UPC),
-- Using date as part of Key since it tracks daily use. 
	Date DATE NOT NULL,
-- Assuming someone can't buy more than 99 of a given item...
	QtySold SMALLINT NOT NULL,
	PRIMARY KEY (cID,UPC,Date)
); 

-- Item Price Table
CREATE TABLE ItemPrice(
	UPC CHAR(12) REFERENCES Item(UPC),
	PriceUSD NUMERIC(6,2) NOT NULL,
	PRIMARY KEY (UPC,PriceUSD)
); 

-- Vendor Cost Table
CREATE TABLE VendorCost(
	vID INTEGER REFERENCES Vendors(vID),
	UPC CHAR(12) REFERENCES Item(UPC),
	CostUSD NUMERIC(6,2) NOT NULL,
-- Pack = Qty of UPCs supplied by Vendor
	Pack INTEGER NOT NULL,
	PRIMARY KEY (vID,UPC,CostUSD)
); 

-- Daily Sales Table
CREATE TABLE DailySales(
	UPC CHAR(12) REFERENCES Item(UPC),
	PriceUSD NUMERIC(6,2) NOT NULL,  
	CostUSD NUMERIC(6,2) NOT NULL, 
	Date DATE NOT NULL,
	QtySold SMALLINT NOT NULL,
-- Total amount of sales before tax in USD
	TotalAmtBTaxUSD NUMERIC(8,2) NOT NULL,
	PRIMARY KEY (UPC,PriceUSD,CostUSD,Date)
);

-- Region Table
-- Taking Place of State Table because of the data provided
CREATE TABLE Regions(
	RegionID INTEGER NOT NULL,
	Name VARCHAR(35) NOT NULL,
	PRIMARY KEY (RegionID)
);

-- Zip Code Table
CREATE TABLE ZipCodes(
	ZipCode CHAR(7) NOT NULL,
	RegionID INTEGER REFERENCES Regions(RegionID),
	PRIMARY KEY (ZipCode)
);

-- Addresses Table
CREATE TABLE Addresses(
	aID INTEGER NOT NULL, 
	ZipCode CHAR(7) REFERENCES ZipCodes(ZipCode),
	RegionID INTEGER REFERENCES Regions(RegionID),
	StreetNumber INTEGER NULL,
	StreetName VARCHAR(35) NOT NULL,
	PRIMARY KEY (aID)
);

-- People Addresses Table
CREATE TABLE PeopleAddresses(
	pID INTEGER REFERENCES People(pID),
	aID INTEGER REFERENCES Addresses(aID),
	PRIMARY KEY (pID,aID)
);

-- Vendor Addresses Table
CREATE TABLE VendorAddresses(
	vID INTEGER REFERENCES Vendors(vID),
	aID INTEGER REFERENCES Addresses(aID),
	PRIMARY KEY (vID,aID)
);

-- People Phone Table
CREATE TABLE PeoplePhone(
	pID INTEGER REFERENCES People(pID),
	Home TEXT NULL,
	Cell TEXT NULL,
	PRIMARY KEY (pID)
);

-- Vendor Phone Table
CREATE TABLE VendorPhone(
	vID INTEGER REFERENCES Vendors(vID),
	Frontend TEXT NULL,
	Manager TEXT NULL,
	PRIMARY KEY (vID)
);

-- Insert Statements

INSERT INTO Item (UPC,Name,Description,TaxCode,WIC,WICCVV,Foodstamp)
VALUES
('000000000001', 'Dornish Sour Red Wine', 'The finest sour red wine in all of Westeros', 'A', '1', '1', '1'), 
('000000000002', 'Dornish Sweet Red Wine', 'The finest Sweet red wine in all of Westeros', 'A', '1', '1', '1'),
('000000000003', 'Myrish Firewine', 'The finest red wine from the spice capital of Myr in Essos', 'A', '1', '1', '1'),
('000000000004', 'Wine of Courage', 'The wine of the Unsullied', 'A', '1', '1', '1'),
('000000000005', 'Dark Ale', 'Dark beer for the commons', 'B', '1', '1', '1'),
('000000000006', 'Light Ale', 'Light beer for the commons', 'B', '1', '1', '1'),
('000000004011', 'Bananas', 'Plain ole bananas', 'C', '0', '0', '1'), 
('000000004013', 'Naval Oranges', 'ORANGES!!!', 'C', '0', '0', '1'),
('000000004023', 'Red Grapes', 'Grapes(for wine)', 'C', '0', '0', '1'),
('939660019450', 'Roasted Chicken', 'From the local Inn', 'D', '1', '1', '0'),
('230060019590', 'Bacon', 'Cant have breakfast without bacon', 'D', '1', '1', '0'),
('209247942868', 'Crab', 'Freshly spiked from the Iron Islands', 'D', '1', '1', '0'),
('209243666568', 'Blackfish', 'Not the house but the food!', 'D', '1', '1', '0'),
('002348900023', 'Sausage', 'Mystery meat ground up', 'D', '1', '1', '0'),
('002008000888', 'Boiled Eggs', 'Common food', 'F', '1', '1', '1'),
('002008000899', 'Wheel of Cheese', 'Compliments every meal', 'F', '1', '1', '1'),
('000000444423', 'Sweet Biscuits', 'YUM!', 'E', '0', '0', '1'),
('000000432397', 'Black Bread', 'Sounds gross, tastes great!', 'E', '0', '0', '1');

INSERT INTO Categories (Category,Name,Description)
VALUES
(1, 'Wine', 'In every chapter of the books'),
(2, 'Beer', 'A staple in every household'),
(3, 'Fruit', 'Gotta have something healthy'),
(4, 'Chicken', 'Organically raised!'),
(5, 'Pork', 'Oink Oink!'),
(6, 'Crustaceans', 'Peel off the shells!'),
(7, 'Fish', 'The Fish is fishy!'),
(8, 'Mystery Meat', 'Most common food'),
(9, 'Bread', 'Hearty Meal'),
(10, 'Cheese', 'Yummmm cheese'),
(11, 'Eggs', 'Yup, eggs!');

INSERT INTO CategoryItems (Category,UPC)
VALUES
(1, '000000000001'),
(1, '000000000002'),
(1, '000000000003'),
(1, '000000000004'),
(2, '000000000005'),
(2, '000000000006'),
(3, '000000004011'),
(3, '000000004013'),
(3, '000000004023'),
(4, '939660019450'),
(5, '230060019590'),
(6, '209247942868'),
(7, '209243666568'),
(8, '002348900023'),
(11, '002008000888'),
(10, '002008000899'),
(9, '000000444423'),
(9, '000000432397');


INSERT INTO Departments (dID,Name,Description)
VALUES
(1, 'Alcohol', 'Once again in every scene'),
(2, 'Produce', 'For your health!'),
(3, 'Meat', 'All Organic!'),
(4, 'Seafood', 'See food and eat it'),
(5, 'Bakery', 'Freshly made fluffy things'),
(6, 'Dairy', 'Creamy stuff');

INSERT INTO DepartmentCategories (dID,Category)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(3, 5),
(4, 6),
(4, 7),
(3, 8),
(5, 9),
(6, 10),
(6, 11);

INSERT INTO DepartmentItems (dID,UPC)
VALUES
(1, '000000000001'),
(1, '000000000002'),
(1, '000000000003'),
(1, '000000000004'),
(1, '000000000005'),
(1, '000000000006'),
(2, '000000004011'),
(2, '000000004013'),
(2, '000000004023'),
(3, '939660019450'),
(3, '230060019590'),
(4, '209247942868'),
(4, '209243666568'),
(3, '002348900023'),
(6, '002008000888'),
(6, '002008000899'),
(5, '000000444423'),
(5, '000000432397');

INSERT INTO Vendors (vID,Name,Description,Email)
VALUES
(1, 'Alcohol Smuggler', 'They get you all the alcohol you need!', 'DavosSeaworthy@gmail.com'),
(2, 'Blackwater Bay', 'Just watch out for chains', 'Wildfire@hotmail.com'),
(3, 'Farm of the NORTH!', 'Its in the north!', 'Knights Watch@aol.com'),
(4, 'Iron Islands Inc.', 'Fishy things', 'Kraken@yahoo.com'),
(5, 'Casterly Rock Inc.', 'The Google of Westeros', 'Alwayspaysoffdebt@lannister.com'),
(6, 'CrackJaw Point', 'Bay of Crabs', 'crablover@msn.com'),
(7, 'Crossroads Inn Farm', 'Middle Westeros local farm', 'farmer@farming.com');

INSERT INTO VendorItems (vID,UPC)
VALUES 
(1, '000000000001'),
(1, '000000000002'),
(1, '000000000003'),
(1, '000000000004'),
(1, '000000000005'),
(1, '000000000006'),
(3, '000000004011'),
(3, '000000004013'),
(7, '000000004023'),
(2, '939660019450'),
(2, '230060019590'),
(6, '209247942868'),
(4, '209243666568'),
(2, '002348900023'),
(5, '002008000888'),
(6, '002008000899'),
(5, '000000444423'),
(5, '000000432397');

INSERT INTO People (pID,LastName,FirstName, MiddleName, Email,Gender,BirthDate)
VALUES
(1, 'Lannister', 'Tyrion', 'S', 'dwarf@hotmail.com', 'M', '1980-04-13'),
(2, 'Lannister', 'Cersei', 'B', 'queen@forever.com', 'F', '1970-09-11'),
(3, 'Lannister', 'Jamie', 'I', 'kingsguard1@gmail.com', 'M', '1970-09-11'),
(4, 'Stark', 'Ned', 'D', 'fatherstark@aol.com', 'M', '1960-01-01'),
(5, 'Stark', 'Catelyn', 'D', 'cattulley@gmail.com', 'F', '1962-02-12'),
(6, 'Stark', 'Bran', 'D', 'worg@yahoo.com', 'M', '2000-02-22'),
(7, 'Stark', 'Sansa', 'R', 'redhead@gmail.com', 'F', '1996-05-22'),
(8, 'Stark', 'Arya', 'A', 'bravvosninja@revenge.com', 'F', '1998-05-04'),
(9, 'Stark', 'Robb', 'D', 'kingofthenorth@ouch.com', 'M', '1990-11-27'),
(10, 'Snow', 'Jon', 'K', 'watcherofthewall@gmail.com', 'M', '1985-07-17'),
(11, 'Targaryen', 'Daenerys', 'K', 'motherofdragons@hotmail.com', 'F', '1996-04-14'),
(12, 'Baratheon', 'Stannis', 'R', 'rightfulair@aol.com', 'M', '1966-09-09'),
(13, 'Baratheon', 'Renly', 'E', 'numberonestag@gmail.com', 'M', '1979-08-02');

INSERT INTO Customers (cID,PurchaseAmtToDate,PurchaseAmtThisPeriod,PointsToDate,PointsThisPeriod)
VALUES
(1, 15528.44, 110.98, 200.00, 56.99),
(4, 19864.70, 0, 9932.35, 0),
(5, 13084.38, 0, 6542.19, 0),
(6, 288.44, 204.44, 144.22, 102.22),
(8, 473.72, 191.84, 236.86, 95.92),
(9, 199.72, 20.44, 99.86, 10.22),
-- Error In points here, later trigger will check and update this!
(12, 19400, 469.76, 9876.54, 234.88),
(13, 10106.64, 22.44, 5053.32, 11.22);

INSERT INTO Employees (eID,HourlyWages,DateHired,CurrentPosition)
VALUES
(11, 23.45, '2009-01-01', 'General Manager'),
(10, 22.45, '2009-01-01', 'Manager'),
(7, 8.59, '2013-09-12', 'Cashier'),
(2, 19.00, '2009-01-01', 'Pricing Manager'),
(3, 19.00, '2009-01-01', 'Stocker and Janitor');

INSERT INTO Regions (RegionID,Name)
VALUES
(1, 'Kings Landing'),
(2, 'Winterfell'),
(3, 'Iron Islands'),
(4, 'Braavos'),
(5, 'Casterly Rock'),
(6, 'Dorne'),
(7, 'The Twins'),
(8, 'The Vale of Arryn'),
(9, 'Pentos'),
(10, 'Meereen');

INSERT INTO ZipCodes (ZipCode,RegionID)
VALUES
(1111111, 1),
(2222222, 2),
(3333333, 3),
(4444444, 4),
(5555555, 5),
(6666666, 6),
(7777777, 7),
(8888888, 7),
(9999999, 9),
(1231239, 10);

INSERT INTO Addresses (aID,ZipCode,RegionID,StreetNumber,StreetName)
VALUES
(1, 1111111, 1, 2, 'Rich Lane'),
(2, 1111111, 1, 288, 'Poor Drive'),
(3, 2222222, 2, 1, 'Winter Wall Street'),
(4, 3333333, 3, 75, 'Blacktyde Lane'),
(5, 3333333, 3, 2999, 'Pyke Boulevard'),
(6, 4444444, 4, 987, 'Andalos Lane'),
(7, 5555555, 5, 007, 'Bond Street'),
(8, 5555555, 5, 1, 'Lannister Court'),
(9, 6666666, 6, 2423, 'Godsgrace Street'),
(10, 7777777, 7, 77, 'Seagard Lane'),
(11, 8888888, 8, 99999, 'Eyrie Cliff Court'),
(12, 9999999, 9, 500, 'Dothraki Street'),
(13, 1231239, 10, 8765, 'Dario Drive');

INSERT INTO PeopleAddresses (pID,aID)
VALUES
(1, 8),
(2, 1),
(3, 1),
(4, 3),
(5, 11),
(6, 7),
(7, 2),
(8, 6),
(9, 3),
(10, 7),
(11, 12),
(12, 13),
(13, 7);

INSERT INTO VendorAddresses (vID,aID)
VALUES
(1, 12),
(2, 10),
(3, 3),
(4, 5),
(5, 9),
(6, 5),
(7, 8);

INSERT INTO PeoplePhone (pID,Home,Cell)
VALUES
(1, '123-222-5332', '123-222-2342'),
(2, '234-222-6645', '234-888-8865'),
(3, '234-222-6643', '234-888-8863'),
(4, '111-111-2357', '111-111-8764'),
(5, '111-111-4323', '111-111-2874'),
(6, '111-111-3234', '111-111-4382'),
(7, '111-111-7373', '111-111-0756'),
(8, '111-111-3737', '111-111-2342'),
(9, '111-111-9864', '111-111-4264'),
(10, '111-111-5743', '111-111-2363'),
(11, '999-222-5332', '999-888-9876'),
(12, '222-324-7496', '222-324-7040'),
(13, '222-634-3234', '222-324-0001');

INSERT INTO VendorPhone (vID,Frontend,Manager)
VALUES
(1, '229-252-5332', '229-521-2342'),
(2, '326-211-1111', '326-888-2325'),
(3, '534-222-5332', '123-222-2342'),
(4, '007-532-5332', '007-324-3245'),
(5, '888-888-8868', '888-678-6524'),
(6, '007-222-5332', '007-222-3235'),
(7, '123-235-4324', '123-346-8945');

INSERT INTO ItemPrice (UPC,PriceUSD)
VALUES
('000000000001', 8.15),
('000000000002', 9.15),
('000000000003', 10.15),
('000000000004', 8.55),
('000000000005', 5.25),
('000000000006', 5.00),
('000000004011', 2.50),
('000000004013', 2.00),
('000000004023', 2.00),
('939660019450', 8.00),
('230060019590', 4.75),
('209247942868', 11.50),
('209243666568', 7.75),
('002348900023', 3.00),
('002008000888', 1.00),
('002008000899', 2.00),
('000000444423', 1.50),
('000000432397', 1.00);

INSERT INTO VendorCost (vID,UPC,CostUSD,Pack)
VALUES
(1, '000000000001', 2.50, 12),
(1, '000000000002', 3.55, 12),
(1, '000000000003', 4.15, 12),
(1, '000000000004', 2.75, 12),
(1, '000000000005', 1.25, 12),
(1, '000000000006', 2.00, 12),
(3, '000000004011', 1.50, 20),
(3, '000000004013', 0.50, 20),
(7, '000000004023', 0.75, 20),
(2, '939660019450', 3.00, 10),
(2, '230060019590', 1.75, 10),
(6, '209247942868', 4.50, 10),
(4, '209243666568', 2.75, 10),
(2, '002348900023', 0.25, 25),
(5, '002008000888', 0.25, 25),
(6, '002008000899', 0.75, 20),
(5, '000000444423', 0.50, 40),
(5, '000000432397', 0.50, 40);

INSERT INTO ItemsPurchased (cID,UPC,Date,QtySold)
VALUES
-- This is intended to only account for two days (2014-04-15 & 2014-04-16)
(1, '000000000001', '2014-04-16', 4),   
(1, '000000000002', '2014-04-16', 2), 
(1, '209247942868', '2014-04-15', 5),
(6, '000000004011', '2014-04-16', 20),
(6, '002008000899', '2014-04-16', 20),
(6, '002348900023', '2014-04-16', 15),
(6, '000000444423', '2014-04-15', 30),
(6, '000000432397', '2014-04-15', 15),
(8, '000000444423', '2014-04-16', 50),
(8, '230060019590', '2014-04-16', 10),
(8, '000000004013', '2014-04-15', 15),
(8, '939660019450', '2014-04-15', 5),
(9, '002008000888', '2014-04-16', 10),
(9, '000000432397', '2014-04-15', 10),
(12, '000000000001', '2014-04-16', 10),   
(12, '000000000003', '2014-04-16', 10), 
(12, '209247942868', '2014-04-16', 10),
(12, '939660019450', '2014-04-16', 10),
(12, '209243666568', '2014-04-15', 5),
(12, '230060019590', '2014-04-15', 15),
(13, '002348900023', '2014-04-15', 4),
(13, '000000000001', '2014-04-15', 1);

INSERT INTO DailySales (UPC,PriceUSD,CostUSD,Date,QtySold,TotalAmtBTaxUSD)
VALUES
-- Meant to be for the days of '2014-04-16' and '2014-04-15' 
('000000000001', 8.15, 2.50, '2014-04-16', 14, 79.10),
('000000000002', 9.15, 3.55, '2014-04-16', 2, 11.20),
('000000000003', 10.15, 4.15, '2014-04-16', 10, 60.00),
('000000000004', 8.55, 2.75, '2014-04-16', 0, 0.00),
('000000000005', 5.25, 1.25, '2014-04-16', 0, 0.00),
('000000000006', 5.00, 2.00, '2014-04-16', 0, 0.00),
('000000004011', 2.50, 1.50, '2014-04-16', 20, 20.00),
('000000004013', 2.00, 0.50, '2014-04-16', 0, 0.00),
('000000004023', 2.00, 0.75, '2014-04-16', 0, 0.00),
('939660019450', 8.00, 3.00, '2014-04-16', 10, 50.00),
('230060019590', 4.75, 1.75, '2014-04-16', 10, 30.00),
('209247942868', 11.50, 4.50, '2014-04-16', 10, 70.00),
('209243666568', 7.75, 2.75, '2014-04-16', 0, 0.00),
('002348900023', 3.00, 0.25, '2014-04-16', 15, 41.25),
('002008000888', 1.00, 0.25, '2014-04-16', 10, 7.50),
('002008000899', 2.00, 0.75, '2014-04-16', 20, 25.00),
('000000444423', 1.50, 0.50, '2014-04-16', 50, 50.00),
('000000432397', 1.00, 0.50, '2014-04-16', 0, 0.00),
('000000000001', 8.15, 2.50, '2014-04-15', 1, 5.65),
('000000000002', 9.15, 3.55, '2014-04-15', 0, 0.00),
('000000000003', 10.15, 4.15, '2014-04-15', 0, 0.00),
('000000000004', 8.55, 2.75, '2014-04-15', 0, 0.00),
('000000000005', 5.25, 1.25, '2014-04-15', 0, 0.00),
('000000000006', 5.00, 2.00, '2014-04-15', 0, 0.00),
('000000004011', 2.50, 1.50, '2014-04-15', 0, 0.00),
('000000004013', 2.00, 0.50, '2014-04-15', 15, 15.00),
('000000004023', 2.00, 0.75, '2014-04-15', 0, 0.00),
('939660019450', 8.00, 3.00, '2014-04-15', 5, 25.00),
('230060019590', 4.75, 1.75, '2014-04-15', 15, 45.00),
('209247942868', 11.50, 4.50, '2014-04-15', 15, 105.00),
('209243666568', 7.75, 2.75, '2014-04-15', 5, 25.00),
('002348900023', 3.00, 0.25, '2014-04-15', 4, 11.00),
('002008000888', 1.00, 0.25, '2014-04-15', 0, 0.00),
('002008000899', 2.00, 0.75, '2014-04-15', 0, 0.00),
('000000444423', 1.50, 0.50, '2014-04-15', 30, 30.00),
('000000432397', 1.00, 0.50, '2014-04-15', 25, 12.50);

SELECT * FROM PeopleAddresses; SELECT * FROM VendorAddresses; SELECT * FROM PeoplePhone;
SELECT * FROM VendorPhone; SELECT * FROM CategoryItems; SELECT * FROM DepartmentCategories;
SELECT * FROM DepartmentItems; SELECT * FROM VendorItems; SELECT * FROM ItemPrice;
SELECT * FROM VendorCost; SELECT * FROM ItemsPurchased; SELECT * FROM Customers;
SELECT * FROM Employees; SELECT * FROM Addresses; SELECT * FROM ZipCodes;
SELECT * FROM Regions; SELECT * FROM DailySales; SELECT * FROM Categories;
SELECT * FROM Departments; SELECT * FROM Vendors; SELECT * FROM People; SELECT * FROM Item;

-- Views

-- View for Manager that displays Vendor Contact Info
CREATE OR REPLACE VIEW VendorContact AS
	SELECT v.vID,
	       v.Name as "Vendor Name",
	       v.Email, 
	       vc.Frontend as "Front-End Phone Number",
	       vc.Manager as "Manager's Phone Number",
	       (a.StreetNumber || ' ' || a.StreetName) as "Address",
	       a.ZipCode,
	       r.Name as "Region Name"
	FROM Vendors v,
	     VendorPhone vc,
	     VendorAddresses va,
	     Regions r,
	     ZipCodes z,
	     Addresses a
	     WHERE v.vID = vc.vID AND
		   v.vID = va.vID AND
		   va.aID = a.aID AND
		   a.ZipCode = z.ZipCode AND
		   r.RegionID = z.RegionID
	ORDER BY v.vID ASC;
	
-- Customer Contact View
CREATE OR REPLACE VIEW CustomerContact AS
	SELECT c.cID,
	       (p.FirstName || ' ' || p.LastName) as "Customer Name",
	       p.email,
	       pc.Home as "Home Phone Number",
	       pc.Cell as "Cell Phone Number",
	       (a.StreetNumber || ' ' || a.StreetName) as "Address",
	       a.ZipCode,
	       r.Name as "Region Name"
	FROM Customers c,
	     PeoplePhone pc,
	     PeopleAddresses pa,
	     People p,
	     Regions r,
	     ZipCodes z,
	     Addresses a
	     WHERE c.cID = pc.pID AND
		   c.cID = pa.pID AND
		   c.cID = p.pID AND
		   pa.aID = a.aID AND
		   r.RegionID = z.RegionID AND
		   r.RegionID = a.RegionID AND
		   z.ZipCode = a.ZipCode
         ORDER BY c.cID ASC;

-- Daily Accounting View
CREATE OR REPLACE VIEW DailyAccounting AS
	SELECT Date AS "Sales Date",
	       sum(totalAmtBTaxUSD) AS "Total Sales"
	FROM DailySales
	GROUP BY Date
	ORDER BY Date DESC;

-- Marketing ZipCode Historical Sales View
-- Not using stored sales data, but historically archived within 
-- "PurchaseAmtToDate" field
CREATE OR REPLACE VIEW MarketingAreas AS
	SELECT a.ZipCode,
	       sum(c.PurchaseAmtToDate) as "Total Sales History"
	FROM Customers c, 
	     People p,
	     PeopleAddresses pa,
	     Addresses a
		WHERE c.cID = p.pID AND
		      p.pID = pa.pID AND
		      pa.aID = a.aID
	GROUP BY a.ZipCode, c.PurchaseAmtToDate
	ORDER BY c.PurchaseAmtToDate DESC;
         
		 
-- Reports
-- Department Sales History Report
CREATE OR REPLACE VIEW DepartmentSalesHistory AS
	SELECT d.dID as "Department",
	       dep.Name as "Department Name",
	       sum(sale.totalAmtBTaxUSD) AS "Total Sales"
	FROM DepartmentItems d,
	     Departments dep,
	     DailySales sale
		WHERE d.dID = dep.dID AND
		      d.UPC = sale.UPC 
	GROUP BY d.dID, dep.dID
	ORDER BY d.dID ASC;

-- Category Sales History Report
CREATE OR REPLACE VIEW CategorySalesHistory AS
	SELECT c.Category,
	       cat.Name as "Category Name",
	       sum(sale.totalAmtBTaxUSD) AS "Total Sales"
	FROM CategoryItems c,
	     Categories cat,
	     DailySales sale
		WHERE c.Category = cat.Category AND
		      c.UPC = sale.UPC
	GROUP BY c.Category, cat.Category 
	ORDER BY c.Category ASC;

-- Item Margin Report
CREATE OR REPLACE VIEW ItemMargin AS
	SELECT sale.UPC,
	       sum(PriceUSD - CostUSD) AS "Item Margin"
	FROM DailySales sale 
	GROUP BY sale.UPC
	ORDER BY "Item Margin" DESC;
		      
-- Daily UPC Sales Report
CREATE OR REPLACE VIEW DailySalesUPC AS
	SELECT sale.UPC,
	       sale.Date as "Sales Date",
	       SUM(sale.QtySold) as "Total Quantity Sold"
	FROM DailySales sale
		WHERE sale.QtySold > 0 AND
		      EXTRACT(MONTH FROM current_date) = 
		      EXTRACT(MONTH FROM sale.date) 
	GROUP BY sale.UPC, sale.Date   
	ORDER BY sale.UPC;

-- Item Lookup (Remove Zero Sellers) Report
CREATE OR REPLACE VIEW ItemLookup AS
	SELECT i.UPC,
	       i.Name as "Item Name",
	       cateye.Category,
	       di.dID AS "Department",
	       p.PriceUSD,
	       sum(sale.totalAmtBTaxUSD) AS "Total Sales"
	FROM Item i,
	     ItemPrice p,
	     CategoryItems cateye,
	     DepartmentItems di,
	     DailySales sale
		WHERE i.UPC = p.UPC AND
		      i.UPC = sale.UPC AND 
		      i.UPC = cateye.UPC AND 
		      i.UPC = di.UPC  
	GROUP BY i.UPC, cateye.Category, di.dID, p.PriceUSD
		HAVING (sum(sale.totalAmtBTaxUSD) > 0.00)
	ORDER BY i.UPC ASC;

-- Zero Sales UPC Report
CREATE OR REPLACE VIEW ZeroSalesUPC AS
	SELECT i.UPC,
	       i.Name as "Item Name",
	       cateye.Category,
	       di.dID AS "Department",
	       p.PriceUSD,
	       sum(sale.totalAmtBTaxUSD) AS "Total Sales"
	FROM Item i,
	     ItemPrice p,
	     CategoryItems cateye,
	     DepartmentItems di,
	     DailySales sale
		WHERE i.UPC = p.UPC AND
		      i.UPC = sale.UPC AND 
		      i.UPC = cateye.UPC AND 
		      i.UPC = di.UPC  
	GROUP BY i.UPC, cateye.Category, di.dID, p.PriceUSD
		HAVING (sum(sale.totalAmtBTaxUSD) <= 0.00)
	ORDER BY i.UPC ASC;

SELECT * FROM VendorContact; SELECT * FROM CustomerContact; 
SELECT * FROM DailyAccounting; SELECT * FROM MarketingAreas;
SELECT * FROM ItemMargin; SELECT * FROM DepartmentSalesHistory; 
SELECT * FROM CategorySalesHistory; SELECT * FROM DailySalesUPC;

	

-- Stored Procedure/Function to check if Points 
-- are correct for customers!
CREATE OR REPLACE FUNCTION PointCheck(INTEGER, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	Customer_ID INT      := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT *
	FROM Customers c
	  WHERE Customer_ID = c.cID AND
	      c.PointsThisPeriod != ( c.PurchaseAmtThisPeriod / 2) AND
              c.PointsThisPeriod IS NOT NULL;
  RETURN resultset;
   
END
$$ LANGUAGE plpgsql;

-- SELECTING THE BAD ROW AS IDENTIFIED BY THE FUNCTION
-- Since I cannot figure out how to do select all cID 
-- from the table as a check
SELECT PointCheck(1, 'results');
	FETCH ALL from results;

SELECT PointCheck(12, 'results');
	FETCH ALL from results;

-- Same, but checking PointsToDate
CREATE OR REPLACE FUNCTION PointCheckDate(INTEGER, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	Customer_ID INT      := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT *
	FROM Customers c
	  WHERE Customer_ID = c.cID AND
	      c.PointsToDate != ( c.PurchaseAmtToDate / 2) AND
              c.PointsToDate IS NOT NULL;
  RETURN resultset;
   
END
$$ LANGUAGE plpgsql;

-- Will work for cID 1 or 12
SELECT PointCheckDate(12, 'results');
	FETCH ALL from results;

SELECT PointCheckDate(1, 'results');
	FETCH ALL from results;

SELECT PointCheckDate(13, 'results');
	FETCH ALL from results;
	
-- Stored Procedure to fix the identified wrong PointsToPeriod
-- row. NOTE THIS IS IN T-SQL and not postgressql since it was
-- easier for me to comprehend
CREATE OR REPLACE FUNCTION PointFixPeriod() RETURNS 
	void AS '
	UPDATE Customers  
	SET PointsThisPeriod = ( PurchaseAmtThisPeriod / 2) 
		WHERE PointsThisPeriod != ( PurchaseAmtThisPeriod / 2) AND
		      PointsThisPeriod IS NOT NULL;   
' LANGUAGE SQL;

SELECT PointFixPeriod();
SELECT * FROM Customers ORDER BY cID ASC;

--Same, but for Date
-- Note it will fix cID 1 and cID 12!
CREATE OR REPLACE FUNCTION PointFixDate() RETURNS 
	void AS '
	UPDATE Customers  
	SET PointsToDate = ( PurchaseAmtToDate / 2) 
		WHERE PointsToDate != ( PurchaseAmtToDate / 2) AND
		      PointsToDate IS NOT NULL;   
' LANGUAGE SQL;
SELECT PointFixDate();
SELECT * FROM Customers ORDER BY cID ASC;


-- Same Store Procs, but using triggers
DROP FUNCTION IF EXISTS trigPointFixPeriod();
CREATE OR REPLACE FUNCTION trigPointFixPeriod() RETURNS 
	TRIGGER AS $$
BEGIN
	UPDATE Customers  
	SET PointsThisPeriod = ( PurchaseAmtThisPeriod / 2) 
		WHERE PointsThisPeriod != ( PurchaseAmtThisPeriod / 2) AND
		      PointsThisPeriod IS NOT NULL;  
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER fix_points_period
AFTER UPDATE ON Customers
FOR EACH ROW
EXECUTE PROCEDURE trigPointFixPeriod();


DROP FUNCTION IF EXISTS trigPointFixDate();
CREATE OR REPLACE FUNCTION trigPointFixDate() RETURNS 
	TRIGGER AS $$
BEGIN
	UPDATE Customers  
	SET PointsToDate = ( PurchaseAmtToDate / 2) 
		WHERE PointsToDate != ( PurchaseAmtToDate / 2) AND
		      PointsToDate IS NOT NULL;  
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER fix_points_date
AFTER UPDATE ON Customers
FOR EACH ROW
EXECUTE PROCEDURE trigPointFixDate();

-- Security Roles
--Creating Role
CREATE ROLE DatabaseAdmin;
--Granting Access
GRANT SELECT,INSERT,UPDATE 
ON ALL TABLES IN SCHEMA public
TO DatabaseAdmin;

--Creating PricingManager Role
CREATE ROLE PricingManager;
--Granting Access
GRANT SELECT,INSERT,UPDATE 
ON ALL TABLES IN SCHEMA public
TO PricingManager;
--Revoking certain Pricing Manager Privileges
REVOKE ALL PRIVILEGES  
ON Employees 
FROM PricingManager;

--Creating NonManager Role
CREATE ROLE NonManager;
--Granting Select Only Access
GRANT SELECT
ON Item 
TO NonManager;
GRANT SELECT
ON Vendors 
TO NonManager;



-- FAILED TRIGGERS!!!
-- Everytime a Customer Purchases the item, it will go into DailySales 
-- for that date. 
	
--CREATE OR REPLACE FUNCTION UpdateItemsPurchased() RETURNS 
--	TRIGGER AS $updateDailySales$
--	BEGIN
--		INSERT INTO DailySales (UPC, priceUSD, costUSD, date, QtySold, TotalAmtBTaxUSD)
--		VALUES
--		(New.UPC, priceUSD, costUSD, current_date, QtySold, TotalAmtBTaxUSD);
--		RETURN NEW;
--	END;
--$updateDailySales$ LANGUAGE plpgsql;
--
--CREATE TRIGGER trigDailySales AFTER INSERT OR UPDATE 
--	ON ItemsPurchased
--	FOR EACH ROW 
--	EXECUTE PROCEDURE UpdateItemsPurchased();
--
--INSERT INTO ItemsPurchased (cID,UPC,Date,QtySold)
--VALUES
--(1,'000000000002', '2014-04-22', 1);
--
-- SELECT trigDailySales;
-- SELECT * FROM ItemsPurchased ORDER BY Date DESC;

-- Added Vendor Trigger
-- Creating testing View for permissions and what not
-- CREATE OR REPLACE VIEW VendorNew AS
-- 	SELECT * FROM Vendors;
-- 
-- Using PL/PG SQL function for this trigger function
-- Updating, Inserting, Deleting from View when base table
-- is changed.....	
-- THIS TRIGGER DOES BASICALLY NOTHING! 
--CREATE OR REPLACE FUNCTION update_vendor_view() RETURNS 
-- TRIGGER AS $$
--    BEGIN
--        IF (TG_OP = 'DELETE') THEN
--            DELETE FROM Vendors WHERE vID = OLD.vID;
--            IF NOT FOUND 
--		THEN RETURN NULL; 
--        END IF;
--
--        ELSIF (TG_OP = 'UPDATE') THEN
--            UPDATE Vendors SET Name = NEW.Name,
--			      Description = NEW.Description,
--			      Email = NEW.Email
--            WHERE vID = OLD.vID;
--            IF NOT FOUND THEN RETURN NULL; 
--        END IF;
--
--        ELSIF (TG_OP = 'INSERT') THEN
--            INSERT INTO Vendors VALUES(NEW.vID, NEW.Name, NEW.Description, NEW.Email);
--
--        RETURN NEW;
--        END IF;
--    END;
--$$ LANGUAGE plpgsql;
--
--CREATE TRIGGER trg_vend
--INSTEAD OF INSERT OR UPDATE OR DELETE ON VendorNew
--    FOR EACH ROW 
--    EXECUTE PROCEDURE update_vendor_view();
--
--INSERT INTO Vendors (vID, Name, Description, Email)
--VALUES
--(10,'test','testing', 'testme@testingthis.com');
-- This trigger for the vendor will automatically insert
-- update, or delete the view when the base table is altered
-- kind of pointles, but I am struggling with the whole trigger
-- thing as you see below. 

--SELECT * FROM VendorNew;
--SELECT * FROM Vendors;

-- This my attempt at a more complex Store Procedure
-- And Trigger and it results in recursion and bombing 
-- out. I am curious as to how this work, if you have
-- the chance can you please let me know what I did wrong?

-- This will Update the Faulty PointsToDate row
-- Please note cID 1 will be changed from 200 to 
-- the proper value
-- DROP TRIGGER IF EXISTS customer_point_date_update ON Customers CASCADE; 
--DROP FUNCTION IF EXISTS PointFixDate();
--CREATE FUNCTION PointFixDate() RETURNS 
--	TRIGGER AS $Point_Date$
--BEGIN
--UPDATE Customers
--	SET PointsToDate = (PurchaseAmtToDate / 2)
--		WHERE PointsToDate != ( PurchaseAmtToDate / 2) AND
--		      PointsToDate IS NOT NULL;	
--RETURN NULL;
--END
--$Point_Date$  LANGUAGE plpgsql;
--CREATE TRIGGER customer_point_date_update
--    BEFORE UPDATE ON Customers
--    FOR EACH STATEMENT
--    EXECUTE PROCEDURE PointFixDate();

-- Run Select All to See Results
--SELECT * FROM Customers ORDER BY cID ASC;	
		      
-- Return to Bad Customer data will cause recursion since
-- it goes against rule/trigger
-- UPDATE Customers
-- SET PointsToDate = 56.99
-- 	WHERE cID = 1;

-- Take 2ish
-- Creating Alt Vendor View to
	
--CREATE FUNCTION addedVendor()RETURNS 
--	TRIGGER AS 
--	$vendor_trig$
--BEGIN
--	IF NEW.vID IS NULL THEN 
--		RAISE EXCEPTION 'vID cannot be NULL';
--	END IF;
--	IF NEW.Name IS NULL THEN 
--		RAISE EXCEPTION 'Name cannot be NULL', NEW.vID;
--	END IF;
----
--	IF NEW.vID = OLD.vID THEN
--		RAISE EXCEPTION 'Stop violating 
--		the Primary Key you fool', NEW.vID;
--	END IF;
--	RETURN NEW;
--END;
--$vendor_trig$ LANGUAGE plpgsql;
--	
--CREATE TRIGGER ze_Trigger
--    BEFORE INSERT OR UPDATE ON Vendors 
--    FOR EACH ROW 
--    EXECUTE PROCEDURE addedVendor();

