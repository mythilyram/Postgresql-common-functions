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


