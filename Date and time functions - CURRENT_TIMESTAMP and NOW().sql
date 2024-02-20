The CURRENT_TIMESTAMP and NOW() functions
Now we'll learn how to get the current date and time.

PostgreSQL actually has several functions you can use to get the current date and time. 
Each function returns different details.

Let's start with the simplest function: NOW(). 
  It returns the current date and time with time zone. Here's how you use it:

SELECT NOW();

  It's very simple, right?

The CURRENT_TIMESTAMP function works exactly like NOW(). 
  You don't need parentheses with this function, just the name will do:

SELECT CURRENT_TIMESTAMP;
  
This returns a date and time with fractional seconds and includes the time zone information.

Why do we have two functions that do the same thing? 
  CURRENT_TIMESTAMP follows the ANSI SQL standard; NOW() is the PostgreSQL version.

Exercise
Run the template query to check the current date and time with the time zone.

SELECT CURRENT_TIMESTAMP AS current_date_time;
2024-02-20 20:23:35.035134+00

The CURRENT_DATE and CURRENT_TIME functions
Good job! You can individually pull the local time or the local date with the CURRENT_DATE and CURRENT_TIME functions. The query below gets the current date and time:

SELECT CURRENT_DATE, CURRENT_TIME;
It returns the current date and time (with the time zone and full precision of fractional seconds), respectively.

Exercise
Do you know how long until our flights arrive in hours? Check the difference between the current and arrival time of the routes. Select the route code and the difference of time between the arrival and now. Name this column difference_hours.

SELECT
	code,
    DATE_PART('hour',CURRENT_TIME) - DATE_PART('hour',arrival_time) AS difference_hours
FROM route

code	difference_hours
PA2342	11
PA8793	16
PA5643	-2
PA8744	8
PA2134	20
PA3424	10
PA7155	2
PA6851	9
PA3425	5
PA1269	0
PA7653	0
PA4097	-3
PA8542	7
PA9073	12

Current date and time with intervals – additional practice
Great! Let's do one more exercise.

Exercise
Find the code of all the routes which normally depart within three hours from the current time.

SELECT
	code
FROM route
WHERE departure_time BETWEEN CURRENT_TIME AND CURRENT_TIME + INTERVAL '3 hours';
--WHERE DATE_PART('hour',departure_time) - DATE_PART('hour',CURRENT_TIME) < 3 -- NOT CORRECT


code
PA5643
PA2134
PA4097
