Dates in PostgreSQL
Our database can store dates. Let's see how they're represented in PostgreSQL.

Exercise
Select the produced_date column from the aircraft table and look at how the date is formatted.

SELECT
	produced_date
FROM aircraft

produced_date
2014-04-05
2014-01-03
2010-03-01
.....

The DATE data type
Good. As you saw, dates are shown in the following format, which is the recommended PostgreSQL format:

YYYY-MM-DD
First we have the year, then the month, and finally the day.

In PostgreSQL, the date data type is the default way to store date information. This data type has a range of '4713-01-01 BC' to '5874897-12-31 AD'. If we want to use dates in our queries, we need to enclose them with single quotes, like this:

SELECT
  id,
  model
FROM aircraft
WHERE produced_date = '2014-04-05';
This query will return the id and model for all aircraft produced on April 5, 2014.
id	model
1	Airbus A321-200

Exercise
Select the following columns: id, route_code, delay and flight_date for flights made on January 1, 2016 or April 3, 2016.

SELECT
  f.id,
  route_code, 
  delay,
  flight_date
FROM flight f
WHERE flight_date = '2016-01-01'
	OR flight_date = '2016-04-03';

id	route_code	delay	flight_date
1	PA2342	0	2016-04-03
2	PA2342	15	2016-01-01
7	PA5643	8	2016-01-01
18	PA8793	45	2016-04-03

Using comparison operators with dates
Well done! It is also quite easy to use dates with other comparison operators. Take a look at the following example:

SELECT
  id,
  model,
  produced_date
FROM aircraft
WHERE produced_date > '2010-12-31';
In PostgreSQL, a date that is "greater than" (>) 2010-12-31 means "all the dates after December 31, 2010" (i.e., from 2011-01-01 to today). Similarly, the "less than" sign (<) will show all dates before the given date.

Exercise
Select the id, route_code, and flight_date columns for all flights after December 31, 2014.

SELECT
	id, 
    route_code,
    flight_date
FROM flight
WHERE flight_date > '2014-12-31'

id	route_code	flight_date
1	PA2342	2016-04-03
2	PA2342	2016-01-01
3	PA8793	2015-07-11
5	PA5643	2015-08-13
....

Using BETWEEN with dates
You can also use the BETWEEN operator to return certain dates. In this way, you can select a range of dates. The following query selects information based on production dates for the year 2010:

SELECT
  id,
  model,
  produced_date
FROM aircraft
WHERE produced_date BETWEEN '2010-01-01'
  AND '2010-12-31';
This will find all the aircraft produced between January 1, 2010 and December 31, 2010, including the starting and ending dates.

Exercise
Select the id and flight_date of all flights which did not take place in 2015.

SELECT
	id,
    flight_date
FROM flight
WHERE flight_date NOT BETWEEN '2015-01-01' AND '2015-12-31'

id	flight_date
1	2016-04-03
2	2016-01-01
4	2014-12-31
7	2016-01-01
....

Dates with ORDER BY
Nice job! You can also sort rows by date using ORDER BY:

SELECT
  id,
  model,
  produced_date
FROM aircraft
WHERE produced_date BETWEEN '2009-01-01'
AND '2010-12-31'
ORDER BY produced_date;
As usual, you can define the sort order by adding ASC (the default sort order) or DESC at the end of the ORDER BY clause.

Exercise
Show the ID and date of all flights in 2015, so the most recent flights are first.

SELECT
	id,
    flight_date
FROM flight
WHERE flight_date BETWEEN '2015-01-01'
				AND '2015-12-31'
ORDER BY flight_date DESC;

id	flight_date
14	2015-12-31
12	2015-12-30
10	2015-10-10
15	2015-08-31
11	2015-08-14
...

Exercise
For every aircraft produced in 2010, show its ID, production date, and the route codes for all the distinct routes it flies.
