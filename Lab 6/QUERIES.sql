--------------------

-- Gregory Abbene
-- February 14th 2013
-- Lab 6
-- Professor Labouseur

------------------

-- Query 1
-- Get the name and city of customers who live in A city where the MOST number of	
-- products are made.	

SELECT name, city
FROM customers
  WHERE city IN
    (SELECT products.city
    FROM products 
      GROUP BY products.city
        ORDER BY COUNT(*) DESC 
          LIMIT 1);

-- Query 2
-- Get the name and city of customers who live in ANY city where the MOST number of	
-- products are made.

SELECT name, city
FROM customers
  WHERE city IN 
    (SELECT products.city
      FROM products
        GROUP BY city 
          HAVING COUNT(*) = 
            (SELECT COUNT(*)
            FROM products
              GROUP BY city 
                ORDER BY COUNT(*) DESC 
		  LIMIT 1)
   );
   
-- Query 3
-- List the products whose priceUSD is above the average priceUSD.

SELECT name, pid
FROM products
  WHERE priceUSD > 
    (SELECT AVG(priceUSD)
    FROM products)
ORDER BY name ASC;

-- Query 4
-- Show the customer name, pid ordered, and the dollars for all customer orders, 
-- sorted by dollars from high to low.

SELECT customers.name, orders.pid, orders.dollars
FROM orders, customers
  WHERE orders.cid = customers.cid
ORDER BY orders.dollars DESC;

-- Query 5
-- Show all customer names (in order) and their total ordered, and nothing more. 
-- Use coalesce to avoid showing NULLs. 

SELECT c.name, COALESCE(sum(qty),0) as "Total Ordered"
FROM customers c LEFT OUTER JOIN
     orders o
  ON c.cid = o.cid   
    GROUP BY c.name
ORDER BY c.name ASC;

-- Query 6
-- Write a query to check the accuracy of the dollars column in the Orders table. 
-- This means calculating Orders.dollars from other data in other tables and then 
-- comparing those values to the values in Orders.dollars.

SELECT *
FROM orders o,
     customers c,
     products p
  WHERE o.cid = c.cid AND
    o.pid = p.pid AND
      o.dollars != ( p.priceusd * o.qty * ((100 - c.discount) / 100)) AND
          o.dollars IS NOT NULL;

-- Query 7
-- Create an error in the dollars column of the Orders table so that you can 
-- verify your accuracy checking query.

UPDATE orders
  SET dollars = 2014 -- It was initially 1104
    WHERE ordno = 1015;

-- Returns Orders database to CAP2 Form
UPDATE orders
  SET dollars = 1104 
    WHERE ordno = 1015;