Time in SQL
Our database can also store time data. At PerfectAir time columns are used in the route table to store planned departure and arrival times.

Let's see how time is represented in the database.

Exercise
Select the departure_time column from the route table.

departure_time
07:55:00
13:20:00
21:50:00
10:25:00
...

The TIME data type
PostgreSQL uses the time data type to store time data. Its range is '00:00:00' to '24:00:00' and for time with time zone from '00:00:00+1459' to '24:00:00-1459'. Time in PostgreSQL can contain also the number of fractional seconds. As you saw, the format for this data type is:

HH:MM:SS.n
Breaking this down, we see that:

HH stands for hours.
MM stands for minutes. Each minute is represented by two digits from 00 to 59.
SS stands for seconds. Each second is represented by two digits from 00 to 59.
.n stands for the number of fractional seconds. This optional value can range from 0 to 6 digits. By default, its value is 0.
So we have the time data type. Notice that time uses a 24-hour clock, so write 14:25 for 2:25 PM.

The precision of time depends on the database designer; in our database, we use the default zero precision.

Specifying a value in a column of time type requires you to put the value in single quotes:

SELECT
  code,
  departure_time
FROM route
WHERE arrival_time = '20:15:00';

Exercise
Show the code for the PerfectAir route arriving at 9:30 AM.

SELECT
	code
FROM route
WHERE arrival_time = '09:30:00';


code
PA2342

Using BETWEEN with time data
You can also use BETWEEN with time data:

SELECT
  code,
  departure_time
FROM route
WHERE arrival_time BETWEEN '12:00:00'
  AND '15:00:00';
Remember that BETWEEN is inclusive in the above query, routes that depart at 12:00 AM or 3:00 PM will be included in the results.

Exercise
Show the codes for all routes departing between 11:00 AM and 5:00 PM.

SELECT
	code
FROM route
WHERE departure_time BETWEEN '11:00:00' AND '17:00:00';

code
PA8793
PA7155
PA6851
PA3425

Comparing dates and times using operators
Well done! You can use the following operators to compare time data:

< – less than.
> – greater than.
<= – less than or equal to.
>= – greater than or equal to.
Look at this query:

SELECT
  code,
  arrival_time
FROM route
WHERE arrival_time >= '12:00:00'
  AND arrival_time <= '15:00:00';
It displays the codes and arrival times only for routes where the arrival time is at least 12:00:00 and not after 15:00:00.

SELECT
	code,
    departure_time
FROM route
WHERE departure_time > '14:00:00' AND departure_time <'23:00:00';

code	departure_time
PA5643	21:50:00
PA2134	21:25:00
PA6851	16:55:00
PA3425	14:15:00
..
Sorting by TIME columns
Good! You can also sort results by time:

SELECT
  code,
  arrival_time
FROM route
ORDER BY arrival_time DESC;
Have you noticed that time and date data work very similarly?

Exercise
Show the code and arrival_time of all routes that arrive before 4:00 PM. Order them by arrival time, with the earliest time first.

SELECT
  code,
  arrival_time
FROM route
WHERE arrival_time < '16:00:00'
ORDER BY arrival_time;

code	arrival_time
PA2134	00:55:00
PA8793	04:35:00
PA9073	08:15:00
PA2342	09:30:00

Exercise
Show the average distance of all routes departing after 8:00 AM. Name the column avg_distance.
SELECT
	AVG(distance) AS avg_distance
FROM route
WHERE departure_time > '08:00:00'

avg_distance
2665.6000000000000000



