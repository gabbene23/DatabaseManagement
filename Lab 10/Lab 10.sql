-- Greg Abbene
-- Professor Labouseur
-- April 15th 2014	
-- Lab 10	

-- 1) function PreReqsFor(courseNum) - Returns immediate prerequisites for the passed-in course number
CREATE OR REPLACE function PreReqsFor(INT, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	num_course INT       := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT preReqNum 
	FROM Prerequisites 
	  WHERE  courseNum = num_course;
  RETURN resultset;
END
$$ LANGUAGE plpgsql;

SELECT PreReqsFor(308, 'results');
FETCH ALL from results;

-- 2) function IsPreReqsFor(courseNum) - Returns the course for which the passed-in course
-- number is an immediate pre-requiste.

CREATE OR REPLACE function IsPreReqsFor(INT, refcursor) RETURNS 
refcursor AS $$
DECLARE 
	num_preReq INT       := $1;
	resultset refcursor  := $2;
BEGIN
	open resultset FOR
	SELECT courseNum 
	FROM Prerequisites 
	  WHERE  prereqnum = num_preReq;
  RETURN resultset;
END
$$ LANGUAGE plpgsql;

SELECT IsPreReqsFor(308, 'results');
FETCH ALL from results;