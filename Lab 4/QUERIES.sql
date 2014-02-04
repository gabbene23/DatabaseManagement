-- Greg Abbene
-- Professor Labouseur
-- Lab 4

-- Query 1
-- Get the cities of agents booking an order for customer “Basics”

SELECT city	 	 
FROM agents
  WHERE aid IN (SELECT aid FROM orders 
    WHERE cid = 'c002');

-- Query 2 
-- Get the pids of products ordered through any agent who makes at least one order for a custamer in kyoto. (this is not the same as asking for pids of products ordered by a customer in kyoto.)

SELECT DISTINCT pid 
FROM orders WHERE aid IN 
   (SELECT aid 
   FROM orders 
     WHERE orders.cid IN
       (SELECT customers.cid 
       FROM customers 
         WHERE customers.city = 'Kyoto'));
         
-- Query 3
-- Find the cids and names of customers who never placed an order through agent a03.

SELECT DISTINCT cid, name  
FROM customers
  WHERE cid NOT IN 
    (SELECT cid
    FROM orders 
      WHERE aid=  'a03'); 

-- Query 4
-- Get the cids and names of customers who ordered both product p01 and p07.	

SELECT DISTINCT cid, name 
FROM customers
  WHERE cid IN 
    (SELECT cid 
    FROM orders 
      WHERE pid = 'p01')
      AND cid IN 
        (SELECT cid 
        FROM orders
          WHERE pid = 'p07');

-- Query 5
-- Get the pids of products ordered by any customers who ever placed an order through agent a03.	

SELECT DISTINCT pid
FROM products
  WHERE NOT EXISTS
  (SELECT *
  FROM agents
    WHERE aid = 'a03' AND
    NOT EXISTS 
      (SELECT *
      FROM orders
        WHERE orders.pid = products.pid AND
        orders.aid = agents.aid));

SELECT DISTINCT pid 
FROM Orders
  WHERE cid IN
    (SELECT cid
    FROM orders
      WHERE aid = 'a03');

-- Query 6
-- Get the names and discounts of all customers who place prders through agents in Dallas or Duluth

SELECT name, discount 
FROM customers
  WHERE cid IN 
    (SELECT cid 
    FROM orders
      WHERE aid IN
        (SELECT aid 
        FROM agents
          WHERE city = 'Dallas' OR
          city = 'Duluth'));
          
-- Query 7
-- Find all customers who have the same discount as that of any customers in Dallas or Kyoto

SELECT * 
FROM customers
  WHERE city <> 'Dallas' AND
  city <> 'Kyoto' AND
  discount IN 
    (SELECT discount 
    FROM customers
      WHERE city = 'Dallas' OR
      city = 'Kyoto');