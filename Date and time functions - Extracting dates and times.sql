The DATE_PART() function
Super! Now, let's see how we can manipulate dates, times, and timestamps. 
PostgreSQL provides a special function:

DATE_PART(part, source)
Here part is one of the following: day, month, year, hour, minute, second, etc. , PART IN QUOTES LIKE 'day'
And source is one of the date and time data types.

Take a look:

SELECT DATE_PART('year', launched_timestamp) AS year
FROM aircraft
ORDER BY year;
The above query will extract the year from the column launched_timestamp for each aircraft and will show it in ascending order.

Exercise
For each aircraft show the id, the withdrawn_timestamp column and the withdrawn_month column (extracted month from the withdrawn_timestamp column).

SELECT 
	id,
    withdrawn_timestamp,
    DATE_PART('MONTH',withdrawn_timestamp) AS withdrawn_month
FROM aircraft
id	withdrawn_timestamp	withdrawn_month
1	null	null
2	null	null
3	2015-10-14 20:00:00	10
4	null	null
5	2016-08-01 09:30:00	8
6	2013-01-05 21:38:00	1
7	null	null
8	2016-10-15 12:52:00	10
9	2015-10-14 00:19:00	10

DATE_PART() – example
Great! How can we use this function? For instance, we can use it to change the way dates are shown. Take a look:

SELECT
  DATE_PART('day', launched_timestamp)
    || '-'
    || DATE_PART('month', launched_timestamp)
    || '-'
    || DATE_PART('year', launched_timestamp)
    AS launched_date
FROM aircraft;
As a result, we get dates like '10-03-2012' instead of '2012-03-10'. However PostgreSQL implements various functions to work with time and date to format them.

Exercise
For each route, show its code and the departure time in the following format: hh.mm, where hh is the hour and mm minutes. Name this new column departure_hour_minute.

SELECT
	code,
    DATE_PART('HOUR',departure_time)
    ||'.'||
    DATE_PART('MINUTE',departure_time) AS departure_hour_minute
FROM route    
code	departure_hour_minute
PA2342	7.55
PA8793	13.20
PA5643	21.50
PA8744	10.25
PA2134	21.25
PA3424	8.0
PA7155	11.5
PA6851	16.55
PA3425	14.15
PA1269	18.5
PA7653	19.20
PA4097	23.15
PA8542	2.10
PA9073	5.0

DATE_PART() with the wrong data type
All right! You may wonder what happens when you try to extract a field which is not present in the given type. Is it possible to extract a year from a time column? Let's find out.

Exercise
Run the template query which, for each route, tries to extract the year from the arrival_time column, and see what happens.

SELECT DATE_PART('year',  arrival_time) AS year
FROM route;
ERROR: "time" units "year" not recognized Line: 1 Position in the line: 1

DATE_PART() with the wrong data type – continued
Error! That's what you got, as you probably expected. It's not possible to extract part of date from a time column... But it's possible to extract a field of time from a date column. It will just provide a zero. Let's give it a try.

Exercise
For each flight, show its id, flight_date, and month extracted from the flight_date column as the month column.

SELECT
	id,
	flight_date, 
    DATE_PART('month',flight_date) as month
FROM flight    
id	flight_date	month
1	2016-04-03	4
2	2016-01-01	1
3	2015-07-11	7
4	2014-12-31	12
5	2015-08-13	8
....
The EXTRACT() function
Nice! Now observe that similar to the DATE_PART() function is EXTRACT(), which gets a the part of the date and time. Here's the syntax:

EXTRACT(part FROM source)
part is one part of the date and time like: second, minute, hour, day, month, year, etc. source is date and time (timestamp). As you noticed, this function requires the keyword FROM between part and source.

The query below returns the year of the produced_date of the aircraft:

SELECT EXTRACT(year FROM produced_date) AS produced_year
FROM aircraft;
Exercise
For each route show its code and the hour of the departure time (as departure_hour).
SELECT 
	code,
	EXTRACT(hour FROM departure_time) AS departure_hour
FROM route;
code	departure_hour
PA2342	7
PA8793	13
PA5643	21
PA8744	10
...
The DATE_TRUNC() function
Fantastic! Let's learn how to display the date truncated to the given part of the date and time. We'll need a new function:

DATE_TRUNC(field, source)
The source argument is timestamp or interval, and the field string argument indicates precision to truncate the input date or time. The field can contain these values: millisecond, second, minute, hour, day, week, month, quarter, year, etc.

SELECT
  produced_date,
  DATE_TRUNC('year', produced_date) AS truncated_produced_date
FROM aircraft
WHERE id = 1;
Result:

produced_date	truncated_produced_date
2014-04-05	2014-01-01 00:00:00.0
Notice that produced_date is truncated to the first day of the year. Only the year comes from the date, the remaining parts are changed to ones or zeros, as appropriate.

In a similar way you can display the first day of the week for the given date. You need only use the week field in the DATE_TRUNC() function: it returns the Monday for the week in question. For example:

SELECT DATE_TRUNC('week','2019-01-01');
The query above returns '2018-12-31', because it is Monday, while '2019-01-01' is Tuesday.

Exercise
Show the launched timestamp of the aircraft and the same date truncated to day (as the launched_day column).
SELECT 	
	launched_timestamp,
	DATE_TRUNC('day',launched_timestamp) AS launched_day
FROM aircraft
launched_timestamp	launched_day
2014-06-10 07:55:00	2014-06-10 00:00:00
2015-01-01 13:19:00	2015-01-01 00:00:00
2010-04-01 21:58:00	2010-04-01 00:00:00

The DATE_TRUNC() function – continued
Great! The DATE_TRUNC() function comes in handy when calculating yearly, monthly, weekly, and similar aggregates. Look at the query below:

SELECT
  DATE_TRUNC('month', produced_date) AS trunc_produced_date,
  COUNT(id) AS aircraft
FROM aircraft
GROUP BY trunc_produced_date;
trunc_produced_date	aircraft
1993-08-01 00:00:00+00	1
2016-06-01 00:00:00+00	1
2013-01-01 00:00:00+00	1
2016-08-01 00:00:00+00	1
2010-03-01 00:00:00+00	2
2015-01-01 00:00:00+00	1
2011-01-01 00:00:00+00	1
2009-04-01 00:00:00+00	1
2008-04-01 00:00:00+00	1
2012-12-01 00:00:00+00	1
2009-12-01 00:00:00+00	1
2014-01-01 00:00:00+00	1
2007-10-01 00:00:00+00	1
2014-04-01 00:00:00+00	1
This query displays produced_date truncated to year and month, and the number of aircraft produced during this time. For example, in the output there are two aircraft produced in March 2010.

Exercise
Let's find out how many aircraft were withdrawn in each week. In the first column show withdrawn_timestamp truncated to week (name the column week), and in the second show the count as withdrawn_count. Show this summary only for withdrawn aircraft.

SELECT
    DATE_TRUNC('week', withdrawn_timestamp) AS week,
  COUNT(id) AS withdrawn_count
FROM aircraft
WHERE withdrawn_timestamp IS NOT NULL
GROUP BY week;

week	withdrawn_count
2012-12-31 00:00:00	1
2015-10-12 00:00:00	2
2016-08-01 00:00:00	1
2016-10-10 00:00:00	1

