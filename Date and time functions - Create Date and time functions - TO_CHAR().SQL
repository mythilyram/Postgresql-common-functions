The TO_CHAR() function
Very good! We can also use the TO_CHAR() function to format dates and times. It has a structure which looks like this:

TO_CHAR(timestamp, format)
The first argument is the date and time that will be formatted, and the second is a string specifying the format. This function returns a string or, if there's a problem, a NULL. Let's look at an example:

SELECT
  flight_date,
  TO_CHAR(flight_date,'Day, DD Month YYYY')
FROM flight;
The default date format is YYYY-MM-DD; therefore, for the flight with ID of 1 the date is '2016-04-03'. However, if we apply the TO_CHAR() function and the 'Day, DD Month YYYY' format, the date will be displayed as 'Sunday, 3 April 2016'. The 'Day' specifier in this format denotes the name of the day of the week, DD is the digit day of the month, 'Month' is the name of the month, and YYYY is the four-digit year.

You may find more patterns in the PostgreSQL's documentation.
https://www.postgresql.org/docs/10/functions-formatting.html

Note that the database will align parts of the time into columns, like so:

 flight_date |           to_char            |
-------------+------------------------------+
 2016-04-03  | Sunday   , 03 April     2016 |
 2016-01-01  | Friday   , 01 January   2016 |
 2015-07-11  | Saturday , 11 July      2015 |
It's rather unwanted behavior, but you can change this by placing the FM modifier (which stands for fill mode, and it will suppress leading zeros and padding blanks) before each part that you don't want to have padding applied:

SELECT
  flight_date,
  TO_CHAR(flight_date,'FMDay, DD FMMonth YYYY')
FROM flight;
That will result in:

 flight_date |           to_char           |
-------------+-----------------------------+
 2016-04-03  | Sunday, 03 April 2016       |
 2016-01-01  | Friday, 01 January 2016     |
 2015-07-11  | Saturday, 11 July 2015      |
Don't worry – you won't be asked to do that in this course, but it's worth knowing.

Exercise
The company is using a new format for planned flight arrival times:

'HH.MI.SS AM'
HH is a two-digit hour, MI is the two-digits minute, SS is the two digit seconds, and AM is the meridiem indicator (without periods). New times will look like this:

'08.12.05 PM'
For all planned arriving flights, show the arrival_time in the old and new format. Name the new column formatted_arrival_time.

SELECT
	arrival_time,
    TO_CHAR(arrival_time,'HH.MI.SS AM') AS formatted_arrival_time
FROM route

arrival_time	formatted_arrival_time
09:30:00	09.30.00 AM
04:35:00	04.35.00 AM
22:50:00	10.50.00 PM
12:15:00	12.15.00 PM
00:55:00	12.55.00 AM
10:45:00	10.45.00 AM
18:35:00	06.35.00 PM
11:35:00	11.35.00 AM
15:50:00	03.50.00 PM
20:15:00	08.15.00 PM
20:40:00	08.40.00 PM
23:55:00	11.55.00 PM
13:45:00	01.45.00 PM
08:15:00	08.15.00 AM

The TO_CHAR() function – additional practice
Nice! Now we will learn more specifiers to convert the date to a new format. Let's look at this query below:

SELECT
  id,
  TO_CHAR(
    launched_timestamp,
    'DD Mon YY, HH12:MI:SS.US AM')
    AS formatted_launched_ts
FROM aircraft;
This query is for the aircraft with ID of 1 and a launched timestamp of '2014-06-10 07:55:0' and returns this date and time in new format:

10 Jun 14, 07:55:00.000000 AM
Consider the following format patterns:

Pattern	Description
DD	day of month (01-31)
Mon	abbreviated capitalized month name (3 chars in English, localized lengths vary)
YY	last 2 digits of year
HH
HH12	hour of day (01-12)
HH24	hour of day (00-23)
MI	minute (00-59)
SS	second (00-59)
US	microsecond (000000-999999)
AM, am,
PM, pm	meridiem indicator (without periods)
A.M., a.m.,
P.M., p.m.	meridiem indicator (with periods)
You will find more format patterns in the PostgreSQL documentation.
https://www.postgresql.org/docs/10/functions-formatting.html

Exercise
Let's show the code and the departure time for each route in a new format 'HH24.MI.SS', where:

HH24 is hour in the range 00-24.
MI is minute in the range 00-59.
SS is second in the range 00-59.
where the time components are separated by a dot. Name the new column formatted_departure_time.

SELECT
	code,
	TO_CHAR(departure_time,'HH24.MI.SS') as formatted_departure_time
FROM route

code	formatted_departure_time
PA2342	07.55.00
PA8793	13.20.00
PA5643	21.50.00
PA8744	10.25.00
PA2134	21.25.00
PA3424	08.00.00
PA7155	11.05.00
PA6851	16.55.00
PA3425	14.15.00
PA1269	18.05.00
PA7653	19.20.00
PA4097	23.15.00
PA8542	02.10.00
