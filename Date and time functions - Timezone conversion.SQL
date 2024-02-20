AT TIME ZONE (Note: AT not ON and space b/w time And zone)
Nice work! Another thing we want to introduce is the conversion between various time zones. As you know, the route table provides the departure and arrival times in Central European Time. Let's see how we can show the same time in different timezones:

SELECT
  launched_timestamp AS original,
  launched_timestamp AT TIME ZONE 'Asia/Tokyo' AS tokyo
FROM aircraft;
As you can see, we need to write AT TIME ZONE followed by the timezone in apostrophes. In our database, we usually provide the time zone in the format Continent/City, but you need to watch out, because PostgreSQL has other conventions.

Exercise
For each aircraft that was withdrawn, show the model, and the same time in two time zones:

local time of Paris (Europe/Paris) – as the paris_time column.
Pacific Standard Time (PST) – as the pst column.

SELECT 
	model,
    withdrawn_timestamp AT TIME ZONE 'Europe/Paris' AS paris_time,
    withdrawn_timestamp AT TIME ZONE 'PST' AS pst
FROM aircraft
WHERE withdrawn_timestamp IS NOT NULL

model	paris_time	pst
Boeing 737-800	2015-10-14 18:00:00+00	2015-10-15 04:00:00+00
Boeing 737-800	2016-08-01 07:30:00+00	2016-08-01 17:30:00+00
Airbus A320	2013-01-05 20:38:00+00	2013-01-06 05:38:00+00
Boeing 777-300	2016-10-15 10:52:00+00	2016-10-15 20:52:00+00
Airbus A300-600	2015-10-13 22:19:00+00	2015-10-14 08:19:00+00

AT TIME ZONE – additional practice
All right! One more exercise with time zones and we'll move on.

Exercise
Narita airport (Tokyo) reported to us that they've had to withdraw an aircraft. We only know the time of the withdrawal: 2016-10-15 03:52 in their local time ('Asia/Tokyo').

Find the model of the aircraft that was withdrawn.

SELECT
	model
FROM aircraft
WHERE withdrawn_timestamp AT TIME ZONE 'Asia/Tokyo' = '2016-10-15 03:52'

model
Boeing 777-300

