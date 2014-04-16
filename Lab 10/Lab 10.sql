-- Greg Abbene
-- Professor Labouseur
-- April 15th 2014	
-- Lab 10	

-- 1) function PreReqsFor(courseNum) - Returns immediate prerequisites for the passed-in course number
CREATE OR REPLACE function PreReqsFor(integer, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	courseNum INTEGER := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT p.preReqNum as "Prerequisite Number"
	FROM Prerequisites p
	WHERE  p.num = $1;
  RETURN resultset;
END
$$ LANGUAGE plpgsql;

SELECT PreReqsFor(308);

-- 2) function IsPreReqsFor(courseNum) - Returns the course for which the psased-in course
-- number is an immediate pre-requiste.

CREATE OR REPLACE function IsPreReqsFor(integer, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	courseNum INTEGER := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT p.num as "Course Number"
	FROM Prerequisites p
	WHERE  p.preReqNum = $1;
  RETURN resultset;
END
$$ LANGUAGE plpgsql;

SELECT IsPreReqsFor(308);