-- Greg Abbene
-- Professor Labouseur
-- April 15th 2014	
-- Lab 10	

-- Store Procedures and Trigger
-- LOOK @ Some PostgreSQL stored procs on site for template

-- Create and INstert --> Adds 4 courses and has preReq chains...

-- 1) Takes Parameter of Course (say 308) and write query to find out preReqs for course
	-- @ one level back --> Should get closest preReq **should be 120

-- Template
CREATE OR REPLACE function test(int, refcursor) returns 
refcursor as
$$
DECLARE 
	creditnum INT  := $1;
	resultset refcursor := $2;
BEGIN
	open resultset FOR
	SELECT * 
	FROM courses 
	WHERE  credits > creditnum; 
  RETURN resultset;
END;
$$ 
LANGUAGE plpgsql;

select test(2)
-- 2) Say course (220) tells you what it is a preReq for @ 1 level back
	-- It is preReq for 221