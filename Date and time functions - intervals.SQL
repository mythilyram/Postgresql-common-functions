Difference between timestamps
Great, let's move on. Our database can add and subtract dates. Take a look:

SELECT withdrawn_timestamp - launched_timestamp AS difference
FROM aircraft
WHERE withdrawn_timestamp IS NOT NULL;
The above query will calculate the difference between the columns withdrawn_timestamp and launched_timestamp. 
What will the result look like? Let's find out.

difference
2021 days 22:02:00
1673 days 23:16:00
-365 days
288 days 14:39:00
597 days 17:26:00

Intervals in PostgreSQL
The results are intervals, which tell us the difference between the two timestamps:

0 years 0 mons 1673 days 23 hours 16 mins 0.00 secs
PostgresSQL provides the interval data type. The simplest way to create an interval in with the syntax:

INTERVAL 'x field'
x is a number, its unit can be any of millennium, century, decade, year, month, week, day, hour, minute, second, millisecond, microsecond, or abbreviations (y, m, d, etc.) or plural forms (months, days, etc.). Example intervals can be:

INTERVAL '2 hours'
INTERVAL '3 days'
INTERVAL '5 months'
INTERVAL '1 year'
You can add such intervals to a date/timestamp:


SELECT
  id,
  launched_timestamp,
  launched_timestamp + INTERVAL '1 year' AS new_launched_timestamp
FROM aircraft;
The above query will add one year to each launched timestamp in the aircraft table.

Exercise
PerfectAir decided to use the withdrawn aircraft with ID of 3 once again. Show its original withdrawn timestamp and the withdrawn timestamp postponed by 6 months as the new_launched_timestamp column.
SELECT
	withdrawn_timestamp,
    withdrawn_timestamp + INTERVAL '6 months' AS new_launched_timestamp
FROM aircraft
WHERE id = 3

withdrawn_timestamp	new_launched_timestamp
2015-10-14 20:00:00	2016-04-14 20:00:00

INTERVAL with multiple fields
Okay! Let's use a few INTERVALs right away:

SELECT
  withdrawn_timestamp,
  withdrawn_timestamp
    + INTERVAL '1 year'
    - INTERVAL '3 month'
    AS new_launched_timestamp
FROM aircraft
WHERE id = 3;
The above query will add one year minus three months to the timestamp stored in the withdrawn_timestamp column. (Yes, you may simply add 9 months, this is just an example 😉)

You can also create an interval with multiple fields, using this syntax:

INTERVAL '1 year 2 months 3 days'
INTERVAL '2 weeks ago'
For example:

SELECT
  withdrawn_timestamp,
  withdrawn_timestamp
    + INTERVAL '1 year 3 months'
    AS new_launched_timestamp
FROM aircraft
WHERE id = 3;
Exercise
PerfectAir, due to unexpected work on the runway of Frankfurt airport (the FRA code). needs to reschedule all departing flights... Show the code, new departure and arrival times forwarded by 1 hour and 15 minutes (show these as new_departure_time and new_arrival_time columns).

SELECT
	code,
    departure_time + INTERVAL '1 HOUR 15 MINUTES' AS new_departure_time,
    arrival_time + INTERVAL '1 HOUR 15 MINUTES' AS new_arrival_time
FROM route
WHERE from_airport = 'FRA'
code	new_departure_time	new_arrival_time
PA2342	09:10:00	10:45:00
PA8542	03:25:00	15:00:00


INTERVAL with constant values
Good! You can also use intervals with a constant value which you provide on your own. There is, however, one catch.

SELECT '2015-01-01' + INTERVAL '5 day';

ERROR: invalid input syntax for type interval: "2015-01-01" Line: 1 Position in the line: 8

INTERVAL with constant values – continued
The addition failed because our database thinks that '2015-01-01' is a common text value (string) and it's not able to add an interval to a text field. What can we do then? We can explicitly convert '2015-01-01' to a date/timestamp:

SELECT '2015-01-01'::timestamp + INTERVAL '5 days';
PostgreSQL delivers the double colon operator (::) to convert one data type to another. On the left, we have the value to be converted to another data typem specified by the data type on the right. In this example, the string '2015-01-01' is converted to a timestamp data type. Now, it's possible to add an interval (5 days) to the date and time. In the same way, we can convert strings containing dates to date data type. Look at the another example:

SELECT '2015-01-01'::date + INTERVAL '5 day';
Let's see if it works.

Exercise
Run the new template to see if this query works.
SELECT '2015-01-01'::timestamp + INTERVAL '5 day' AS new_timestamp;

2015-01-06 00:00:00

Filtering with INTERVALs
Good! The query worked this time. Intervals are typically used with BETWEEN to select facts from a given day, month, year etc. Take a look:

SELECT id
FROM aircraft
WHERE produced_date >= '2010-01-01'
  AND produced_date <  '2010-01-01'::date + INTERVAL '1 year';
This query will look for aircraft produced in 2010. Note we needed to cast the string to date with the :: operator in order to add an interval.

Exercise
Show the id and the model for all the aircraft produced in 2014 and 2015.

SELECT id,
	model
FROM aircraft
WHERE produced_date BETWEEN '2014-01-01' AND '2014-01-01':: date + INTERVAL '2 years';

id	model
1	Airbus A321-200
2	Airbus A333-300
12	Vision SF50

Filtering with INTERVALs – practice
Good job! Interval arithmetic is often used with intervals when we want to find facts for a specific month. We no longer need to check whether a given month has 28, 29 (February), 30 or 31 days; the database will do that for us.

SELECT id
FROM aircraft
WHERE produced_date >= '2010-01-01'
  AND produced_date <  '2010-01-01'::date + INTERVAL '1 month';
Check it out for yourself!

Exercise
Count the number of flights performed within 180 days from the beginning of August 2015. Name the column flights.


SELECT
	COUNT(id) AS flights
FROM flight
WHERE flight_date >= '2015-08-01' AND 
	flight_date <='2015-08-01'::date+INTERVAL '180 DAYS'
    
--not working BETWEEN-- WHERE flight_date BETWEEN '2015-08-01' AND '2015-08-01'::date+INTERVAL '180 DAYS'

flights
11

The OVERLAPS operator
Great! PostgreSQL has also another useful operator – OVERLAPS:

(start1, end1) OVERLAPS
(start2, end2)
As you may guess, it yields true when the two time periods (defined by their endpoints) overlap, and false when they don't.

The OVERLAPS operator works great with intervals too:

(start1, interval) OVERLAPS
(start2, interval)
Exercise
Let's see what aircraft were used while the Boeing 777-300 (ID of 8) was flying. In this exercise, just run the template query.

Note that you won't see aircraft that are still in use (those of NULL value in the withdrawn_timestamp column). We will learn how to show them in the next part of the course.

SELECT other.id, other.model
FROM aircraft other, aircraft boeing
WHERE boeing.id = 8
  AND other.id != 8
  AND (other.launched_timestamp,  other.withdrawn_timestamp) OVERLAPS
      (boeing.launched_timestamp, boeing.withdrawn_timestamp);

id	model	produced_date	registration_timestamp	launched_timestamp	withdrawn_timestamp
1	Airbus A321-200	2014-04-05	2014-04-15 00:00:00	2014-06-10 07:55:00	null
2	Airbus A333-300	2014-01-03	2014-01-13 00:00:00	2015-01-01 13:19:00	null
3	Boeing 737-800	2010-03-01	2010-03-11 00:00:00	2010-04-01 21:58:00	2015-10-14 20:00:00
4	Airbus A320	2008-04-06	2008-04-09 00:00:00	2014-01-01 21:19:00	null
5	Boeing 737-800	2009-12-31	2009-12-31 00:00:00	2012-01-01 10:14:00	2016-08-01 09:30:00
6	Airbus A320	2009-04-13	2009-04-19 00:00:00	2014-01-05 21:38:00	2013-01-05 21:38:00
7	Boeing 787-10	2011-01-01	2011-02-01 00:00:00	2011-11-17 11:17:00	null
8	Boeing 777-300	1993-08-26	1993-08-30 00:00:00	2015-12-31 22:13:00	2016-10-15 12:52:00
9	Airbus A300-600	2013-01-01	2013-01-11 00:00:00	2014-02-23 06:53:00	2015-10-14 00:19:00
10	Airbus A380-900	2007-10-25	2007-11-29 00:00:00	2014-12-31 15:15:00	null
11	Embraer 170	2012-12-31	2013-01-12 00:00:00	2013-01-01 16:52:00	null
12	Vision SF50	2015-01-01	2015-02-01 00:00:00	2016-01-01 09:31:00	null
13	Airbus A320	2016-06-06	2016-07-01 00:00:00	2016-08-28 10:35:00	null
14	Embraer 170	2016-08-10	2016-09-05 00:00:00	2016-09-20 16:23:00	null
15	Boeing 777-800	2010-03-01	2010-04-08 00:00:00	2012-01-01 10:14:00	null

The AGE() function
Great! Let's look at the AGE(start_timestamp) function. It takes only one date and returns the difference between the current date and time, and the one given as the argument. Look at the example below:

SELECT AGE(flight_date)
FROM flight;
This query returns the time duration between today and the flight date.

Exercise
For each aircraft show its ID and how much time has passed since withdrawing as the difference column.

SELECT
	id,
    AGE(withdrawn_timestamp) AS difference
FROM aircraft

id	difference
1	null
2	null
3	8 years 4 mons 4 days 04:00:00
4	null
5	7 years 6 mons 17 days 14:30:00
6	11 years 1 mon 13 days 02:22:00
7	null
8	7 years 4 mons 3 days 11:08:00
9	8 years 4 mons 4 days 23:41:00
The AGE() function – continued
Awesome! Sometimes we want to know, for example, how old a person was on the day of their death. We will use another syntax of the AGE() function:

AGE(end_timestamp, start_timestamp)
Note that the start_timestamp is counter-intuitively the second argument.

The query below returns an interval of time between withdrawn timestamp and launched timestamp:

SELECT AGE(withdrawn_timestamp, launched_timestamp)
FROM aircraft
WHERE id = 9;
age
1 years 7 mons 18 days 17 hours 26 mins 0.00 secs
The returned result is the actual difference between the time this aircraft was launched and the time it was withdrawn. The result of the AGE() is the interval.

Exercise
For each aircraft, select its ID and show the difference in years, months, and days between its registration and production date (as the difference column).
SELECT 
	id,
    AGE(registration_timestamp,produced_date) difference
FROM aircraft

id	difference
1	10 days
2	10 days
3	10 days
4	3 days
5	00:00:00
6	6 days
7	1 mon
8	4 days
9	10 days
10	1 mon 4 days
11	12 days
12	1 mon
13	25 days
14	26 days
15	1 mon 7 days


