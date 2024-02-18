Date and time
Apart from just the date or time, PostgreSQL databases can also store dates with exact times, meaning both the date and the time. Let's see what this data looks like.

Exercise
Select the launched_timestamp and registration_timestamp columns from the aircraft table.

Note how the date and time data is displayed.

SELECT
	launched_timestamp,
    registration_timestamp 
FROM aircraft

launched_timestamp	registration_timestamp
2014-06-10 07:55:00	2014-04-15 00:00:00
2015-01-01 13:19:00	2014-01-13 00:00:00
2010-04-01 21:58:00	2010-03-11 00:00:00
2014-01-01 21:19:00	2008-04-09 00:00:00
...
Date and time data types in PostgreSQL
Good! Did you notice the format? Here it is again:

2014-06-10 07:55:00.125
Let Us analyze it. In PostgreSQL the date and time data type is timestamp. 
It contains both date and time parts. The first part is the date and the second part is the time, reported to fractions of a second.
The fractional value in both date and time data types, if given, must be in the range of 0 to 6 digits. 
The default precision for these data types is 6 digits.

The supported range in timestamp is '4713-01-01 BC' to '294276-12-31 AD'. Note that the upper value for timestamp is different than for date (which is '5874897-12-31 AD').

timestamp can also contain time zone:

'2018-05-23 07:55:12.534211+02'
The '+02' refers to the timezone – in this case it means that we are two hours ahead of UTC. Time zone is optional. 
The timestamp data type without time zone stores date and time in the local time of the database server (in our database it is UTC).

Now, let's look at a query:

SELECT id
FROM aircraft
WHERE withdrawn_timestamp < launched_timestamp;

id
6

The above query checks for typos in our table; we can make sure no aircraft was removed from service before it was launched.

Exercise
Run the example query and find out for yourself if there are errors in the aircraft table.

Using date and time with constant values
Did you spot the mistake in the table? The timestamp data type is very precise in defining a point in time. This is why using the equal sign (=) with this data type isn't a good idea. Two of these values may differ by a single nanosecond, which means the equality condition wouldn't be satisfied.

Nevertheless, you can use comparisons (e.g., >, <, !=, etc.) with timestamp data. This will work when you're comparing two columns or when you're comparing one column against a constant value.

Do we have to be precise when providing a constant value? Not really. Take a look:

SELECT id,
  launched_timestamp
FROM aircraft
WHERE launched_timestamp > '2015-01-01';
As you can see, we compared a timestamp with a simple date. How is this possible? Well, our database converted the date we provided to a timestamp by adding as many zeros as necessary. For instance, '2015-01-01' will become '2015-01-01 00:00:00' and '2014-02-12 12:00' will become '2014-02-12 12:00:00'. Convenient, isn't it?

Exercise
Find the ID number and withdrawn date for all aircraft discontinued after October 14, 2015.

SELECT
	id,
    withdrawn_timestamp
FROM aircraft
WHERE withdrawn_timestamp >= '2015-10-15 '

id	withdrawn_timestamp
5	2016-08-01 09:30:00
8	2016-10-15 12:52:00

NOTE: WHERE withdrawn_timestamp > '2015-10-14' WILL NOT WORK HERE. 
tHIS CONDITION COMPARES WITH TIME AFTER 12am ON THIS DAY.

id	withdrawn_timestamp
3	2015-10-14 20:00:00
5	2016-08-01 09:30:00
8	2016-10-15 12:52:00
9	2015-10-14 00:19:00

Using operators to compare timestamps
Well done! Next, let's see what kind of operators we can use to compare timestamp data. This query ...

SELECT
  id,
  registration_timestamp
FROM aircraft
WHERE registration_timestamp >= '2010-01-01';
  AND registration_timestamp <  '2016-01-01'
... displays the ID of aircraft where the registration date is within the years 2010 – 2015. Briefly, these are the operators you can use with date and time data:

< – less than.
> – greater than.
<= – less than or equal to.
>= – greater than or equal to.
NOTE: 
Remember that because of the high precision of timestamp data, it's a bad idea to use an equality operator (=).

Exercise
Show the id and launched_timestamp columns for aircraft where the launched_timestamp is more than '2010-12-31 23:00:00' and less than '2015-01-01 12:00:00'.

SELECT
	id,
    launched_timestamp
FROM aircraft 
WHERE launched_timestamp > '2010-12-31 23:00:00' AND
		launched_timestamp < '2015-01-01 12:00:00'

id	launched_timestamp
1	2014-06-10 07:55:00
4	2014-01-01 21:19:00
5	2012-01-01 10:14:00
6	2014-01-05 21:38:00
...

Sorting timestamp data
Excellent! The last thing you should know about timestamp data is that you can sort with ORDER BY:

SELECT id, registration_timestamp
FROM aircraft
ORDER BY registration_timestamp;
Exercise
Show the id and launched_timestamp data for all aircraft launched in 2013 or 2014. Sort by launched_timestamp, going from the newest dates to the oldest.

SELECT
	id,
    launched_timestamp
FROM aircraft 
WHERE launched_timestamp BETWEEN '2013-01-01' AND '2015-01-01'
ORDER BY launched_timestamp DESC

id	launched_timestamp
10	2014-12-31 15:15:00
1	2014-06-10 07:55:00
9	2014-02-23 06:53:00
6	2014-01-05 21:38:00
4	2014-01-01 21:19:00
11	2013-01-01 16:52:00

Exercise
For each aircraft, show its ID number (as aircraft_id) and calculate the average distance covered on all its routes, and name it avg_distance. Only show data for aircraft that were launched before January 1, 2014, and took more than one flight.

SELECT
	a.id AS aircraft_id,
    AVG(distance) AS avg_distance
FROM aircraft a
JOIN flight f
ON a.id = f.aircraft_id 
JOIN route r
ON f.route_code = r.code
WHERE launched_timestamp < '2014-01-01'
GROUP BY a.id
HAVING COUNT(a.id)>1

aircraft_id	avg_distance
3	387.1428571428571429
5	4929.0000000000000000
7	5413.6666666666666667



