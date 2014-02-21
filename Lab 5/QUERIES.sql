-- Greg Abbene
-- Professor Labouseur
-- Lab 5

-- Query 1:
-- Get the cities of agents booking an order for customer "Basics". 
-- This time use joins; no subqueries

SELECT agents.city
FROM agents INNER JOIN
  orders ON
    orders.aid = agents.aid AND
      orders.cid = 'c002'
ORDER BY city ASC; 

-- Query 2:
-- Get the pids	of products ordered through any	agent who makes at least one order for	
-- a customer in Kyoto. Use joins this time; no subqueries.	

SELECT DISTINCT o.pid 
FROM orders INNER JOIN
  customers ON
    customers.cid = orders.cid AND
      customers. city = 'Kyoto' FULL JOIN
        orders o ON
          o.aid = orders.aid WHERE
            orders.ordno IS NOT NULL
ORDER BY o.pid ASC;

-- Query 3:
-- Get the names of customers who have never placed an order. Use a subquery.

SELECT DISTINCT name 
FROM customers WHERE
  NOT cid IN 
    (SELECT cid 
    FROM orders)
ORDER BY name ASC;

-- Query 4:
-- Get the names of customers who have never placed an order. Use an outer join.

-- using DISTINCT
SELECT DISTINCT name 
FROM customers LEFT OUTER JOIN 
  orders ON
    customers.cid = orders.cid WHERE
      orders.cid IS NULL
ORDER BY name ASC;

-- NOT using DISTINCT 
SELECT name 
FROM customers LEFT OUTER JOIN 
  orders ON
    customers.cid = orders.cid WHERE
      orders.cid IS NULL
ORDER BY name ASC;

-- Query 5:
-- Get the names of customers who placed at least one order through an agent in their	
-- city, along with those agent(s’) names.

SELECT DISTINCT customers.name AS CustomerName, agents.name As AgentName
FROM customers, agents, orders WHERE
  customers.city = agents.city AND
    orders.aid = agents.aid AND
      orders.cid = customers.cid
ORDER BY CustomerName ASC;

-- Query 6:
-- Get the names of customers and agents in the same city, along with the name of the	
-- city, regardless of whether or not the customer has ever placed an order with that agent

SELECT DISTINCT customers.name AS CustomerName, agents.name As AgentName
FROM customers, agents, orders WHERE
  customers.city = agents.city
ORDER BY CustomerName ASC;

-- Query 7:
-- Get the name and city of customers who live in the city where the least number of
-- products are made.

-- WORKS, PLEASE GRADE THIS ONE!
SELECT DISTINCT customers.name, customers.city 
FROM customers WHERE
   customers.city IN 
     (SELECT city 
     FROM products
       GROUP BY city
         ORDER BY SUM(quantity) ASC
           LIMIT 1)
ORDER BY customers.name ASC; 

-- Example In Class...not working properly

SELECT DISTINCT customers.name, customers.city 
FROM customers WHERE
   customers.city IN
   (SELECT SUM(quantity) as "sq"
   FROM products
     GROUP BY city
       ORDER BY SUM(quantity) ASC
         LIMIT 1)
ORDER BY customers.name ASC;
