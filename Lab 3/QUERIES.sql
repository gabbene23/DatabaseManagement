-- Greg Abbene
-- Professor Labouseur
-- Lab 3

-- Query 1

SELECT name,city 
FROM agents
  WHERE name = 'Smith';

-- Query 2

SELECT pid,name,quantity
FROM products
  WHERE priceusd > 1.25;

-- Query 3

SELECT ordno,aid
FROM orders;

-- Query 4

SELECT name,city
FROM customers
  WHERE city = 'Dallas';    

-- Query 5

SELECT name
FROM agents
  WHERE city <> 'New York' AND 
  city <> 'Newark';

-- Query 6

SELECT *
FROM products
  WHERE city <> 'New York' AND
  city <> 'Newark' AND
  priceusd >= 1;

-- Query 7

SELECT *
FROM orders
  WHERE mon = 'jan' OR
  mon = 'mar';

-- Query 8

SELECT * 
FROM orders
  WHERE mon = 'feb' AND
  dollars < 100;

-- Query 9

SELECT cid,ordno
FROM orders
  WHERE cid = 'c001';  -- Displaying cid in Query because I am not sure 

