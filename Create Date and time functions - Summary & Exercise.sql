Summary
Fantastic job! It's time to review what we know about date and time in PostgreSQL:

PostgreSQL uses dates ('2010-01-01'), times ('13:00:00'), and timestamps ('2010-01-01 13:00:00').
You can compare the above types with BETWEEN or basic operators like: <,<=,>,>=.
You can specify the resulting order with ORDER BY.
The TIMESTAMP data type allows you to save date and time data in your local time zone.
To get parts of a date or time, use the EXTRACT() or DATE_PART() functions.
Use the DATE_TRUNC(x, y) function to truncate the date and time (passed as y) to the given date or time part (passed as x).
Use the INTERVAL operator to add or subtract a period of date or time.
Use the operator :: to convert data types.
Use the AGE(x, y) function to return the difference between the current date or between two dates, x and y, specified as arguments.
Use converted time zones with AT TIME ZONE 'new_timezone'.
Use TO_CHAR(timestamp, format) to display the date in a given format.
To get the current date and time, use:
CURRENT_TIMESTAMP to get the timestamp with the time zone (or CURRENT_TIMESTAMP(p) where p is the precision of fractional seconds).
NOW() to get date and time with time zone.
CURRENT_DATE to get only the date.
CURRENT_TIME to get only the time with the time zone (or CURRENT_TIME(p) where p is the precision of fractional seconds).

Exercise
For all routes departing between 9:00 AM and 3:00 PM, show the route and both airport codes.

SELECT
	code,
    from_airport,
    to_airport
FROM route
WHERE departure_time BETWEEN '09:00:00' AND '15:00:00'

code	from_airport	to_airport
PA8793	MAD	NRT
PA8744	WMI	CRL
PA7155	JFK	CDG
PA3425	ARN	SXF

Exercise
For all flights that took place on July 11, 2015, show the departure and arrival airport, and the aircraft's model info.
  
  SELECT
	from_airport,
    to_airport ,
    model
FROM route
JOIN flight
  ON route.code = flight.route_code
JOIN aircraft
  ON flight.aircraft_id = aircraft.id
WHERE flight_date = '2015-07-11'

 Exercise
Calculate the average delay for all flights taking place in August (for all available years). Name the column avg_delay.

SELECT
	AVG(delay) avg_delay
FROM flight
WHERE DATE_PART('mONTH', flight_date) = 8

avg_delay
17.2000000000000000

Exercise
Find yearly delay averages. Show two columns: year extracted from the flight_date column, and avg_delay – the average delay in that year.

SELECT
	DATE_PART('YEAR',flight_date) AS year,
    AVG(delay) AS avg_delay
FROM flight
GROUP BY 1

Exercise
Find out how many aircraft were registered each week. Show two columns: week and count. The week column should have values like 2011-01-31 00:00:00.

SELECT
	DATE_TRUNC('WEEK',registration_timestamp) AS week,
    COUNT(ID) as count
FROM aircraft
GROUP BY 1         


week	count
2013-01-07 00:00:00	2
2007-11-26 00:00:00	1
2014-01-13 00:00:00	1
2010-03-08 00:00:00	1
2010-04-05 00:00:00	1

Exercise
For each aircraft, show its ID and the number of weeks that elapsed from the aircraft's registration date to the current day as difference_weeks.

  SELECT
	id,
    DATE_PART('day', CURRENT_TIMESTAMP - registration_timestamp) / 7 AS difference_weeks
FROM aircraft

  id	difference_weeks
1	514
2	527.1428571428571
3	727.7142857142857
4	827.8571428571429
5	737.7142857142857
6	774.2857142857143
7	681
8	1590.142857142857
9	579.5714285714286
10	846.7142857142857
11	579.4285714285714
12	472.2857142857143
13	398.57142857142856
14	389.14285714285717
15	723.7142857142857



