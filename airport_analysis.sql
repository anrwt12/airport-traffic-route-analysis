CREATE DATABASE airport_data;
	
CREATE TABLE airportdata (
    PASSENGERS NUMERIC,
    FREIGHT NUMERIC,
    MAIL NUMERIC,
    DISTANCE NUMERIC,
    UNIQUE_CARRIER VARCHAR(10),
    AIRLINE_ID INTEGER,
    UNIQUE_CARRIER_NAME VARCHAR(200),
    UNIQUE_CARRIER_ENTITY VARCHAR(10),
    REGION VARCHAR(10),
    CARRIER VARCHAR(10),
    CARRIER_NAME VARCHAR(200),
    CARRIER_GROUP INTEGER,
    CARRIER_GROUP_NEW INTEGER,
    ORIGIN_AIRPORT_ID INTEGER,
    ORIGIN_AIRPORT_SEQ_ID INTEGER,
    ORIGIN_CITY_MARKET_ID INTEGER,
    ORIGIN VARCHAR(10),
    ORIGIN_CITY_NAME VARCHAR(100),
    ORIGIN_STATE_ABR VARCHAR(5),
    ORIGIN_STATE_FIPS VARCHAR(5),
    ORIGIN_STATE_NM VARCHAR(100),
    ORIGIN_WAC INTEGER,
    DEST_AIRPORT_ID INTEGER,
    DEST_AIRPORT_SEQ_ID INTEGER,
    DEST_CITY_MARKET_ID INTEGER,
    DEST VARCHAR(10),
    DEST_CITY_NAME VARCHAR(100),
    DEST_STATE_ABR VARCHAR(5),
    DEST_STATE_FIPS VARCHAR(5),
    DEST_STATE_NM VARCHAR(100),
    DEST_WAC INTEGER,
    YEAR INTEGER,
    QUARTER INTEGER,
    MONTH INTEGER,
    DISTANCE_GROUP INTEGER,
    CLASS VARCHAR(5)
);

SELECT* FROM airportdata;

-- 1. Analyze total passenger traffic per route and over time.
-- top 5 bussizest routes 

/* "Florida"	"Atlanta, GA"	626715.00
"Florida"	"New York, NY"	577970.00
"California"	"Las Vegas, NV"	512130.00
"Florida"	"Chicago, IL"	409179.00
"California"	"Denver, CO"	384494.00
*/

-- Query
--top 5 busiest routes 
SELECT origin_state_nm , dest_city_name ,
SUM(passengers)AS total_passengers FROM airportdata
GROUP BY 1,2
order BY total_passengers desc
limit 5
;
-- LEAST busiest routes
/*"Alaska"	"False Pass, AK"	1.00
"Massachusetts"	"Bridgeport, CT"	1.00
"Pennsylvania"	"Teterboro, NJ"	1.00
"Alabama"	"Long Beach, CA"	1.00
"Wisconsin"	"Fresno, CA"	1.00
*/

-- Query
SELECT origin_state_nm , dest_city_name ,
SUM(passengers)AS total_passengers 
FROM airportdata
GROUP BY 1,2
HAVING SUM(passengers) > 0
ORDER BY total_passengers 
LIMIT 5
;




-- 2. Determine average passengers per flight for various routes and airports.
SELECT* FROM airportdata;

-- FOR ROUTES
SELECT 
origin_state_nm , dest_city_name ,
ROUND(AVG(passengers),2) as AVG_pass
FROM airportdata
GROUP BY 1,2
ORDER BY AVG_pass DESC;

-- FOR airport
with outgoing_passengers as(
SELECT origin_airport_id,
AVG(passengers) AS avg_passengers
FROM airportdata
GROUP BY 1 
ORDER BY avg_passengers DESC),


 incomming_passengers AS (SELECT dest_airport_id,
AVG(passengers) AS avg_passengers
FROM airportdata
GROUP BY 1 
ORDER BY avg_passengers DESC),

all_airport_id as(
select distinct origin_airport_id AS airport_id
from airportdata
UNION
select distinct dest_airport_id AS airport_id
from airportdata)

select aa.airport_id,ROUND(ip.avg_passengers + op.avg_passengers,0) as Total_passengers
FROM all_airport_id as aa


LEFT JOIN  outgoing_passengers AS op
on aa.airport_id = op.origin_airport_id
LEFT JOIN  incomming_passengers AS ip
on aa.airport_id = ip.dest_airport_id
where ip.avg_passengers+ op.avg_passengers IS NOT NULL
order by Total_passengers DESC


-- 3. Assess flight frequency and identify high-traffic corridors

select   ORIGIN_CITY_NAME  , DEST_CITY_NAME , count( airline_id) as total_flights
 from airportdata
 group by 1,2
 order by total_flights desc limit 10

