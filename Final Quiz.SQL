Introduction
Revise string functions, Numerical and date functions.

We'll be working with data from an IQ society. But don't take this too seriously – the data is purely fictional.

Exercise
Select all data from the branch table. It contains the id of each branch, plus the country and city where that branch is located.

SELECT * FROM branch
Limit 2

id	country	city
1	Germany	Berlin
2	France	Paris

The person table
Okay, now let's take a look at the person table and learn a bit about our members.

Exercise
Select all the information from the person table. For each member, we have the following columns:

id
branch_id – branch ID (for the branch this person belongs to; only one branch per person is possible at a time).
first_name
middle_name
last_name
registration
iq
weight in kilograms. 1 kilogram (kg) is roughly equal to 2.2 pounds (lbs).
height in centimeters. 1 inch is equal 2.54 centimeter (cm).

id	branch_id	first_name	middle_name	last_name	registration	iq	weight	height
1	1	Manuel	Carson	Krupp	2014-11-21	155	79.03	171
2	1	Herschel	Maxwell	Woolwine	2013-06-17	156	81.96	173

Exercise 1
Here's the first exercise.

Exercise
Show the first, middle, and last name of each person together in one column (name this new column full_name). Format it like this:

First_name Middle_name LASTNAME
In other words, capitalize the first letter of the first and middle names, and show the last name uppercased.

Show this information only for people whose last names are at least 7 characters long. If a person has a NULL middle name, show an empty string for this middle name.

SELECT
  INITCAP(first_name)
    || ' '
    || COALESCE(INITCAP(middle_name), '')
    || ' '
    || UPPER(last_name)
    AS full_name
FROM person
WHERE LENGTH(last_name) >= 7;

full_name
Herschel Maxwell WOOLWINE
Ernest Valentin TERPSTRA
Weston Jarod SANTILLAN
Millard Jackie FRISCIA
---------------------------------------------------------------------------
Exercise 2
Excellent! Let's move on.

Exercise
The IQ society created a dating website for its members. We need to anonymize the user data before members go on their first date. For each person, show the following sentence:

XYZ lives in A and weighs B kilograms.
XYZ is the person's initials (XZ if a person has no middle name), A is the city where they live, and B is their weight, rounded to the nearest integer. Don't forget about the period at the end of the sentence!

SELECT
	SUBSTRING(first_name,1,1)
    || COALESCE(SUBSTRING(middle_name,1,1),'')
    || SUBSTRING(last_name,1,1)
    || ' lives in '
    || city
    || ' and weighs '
    || ROUND(weight)
    || ' kilograms.' AS sentence
FROM  person p
JOIN branch b
ON p.branch_id = b.id

sentence
EVT lives in Berlin and weighs 75 kilograms.
JGS lives in Berlin and weighs 98 kilograms.
HMW lives in Berlin and weighs 82 kilograms.

*********Solution given
SELECT
  CONCAT(
    UPPER(LEFT(first_name, 1)),
    UPPER(LEFT(middle_name, 1)),
    UPPER(LEFT(last_name, 1)),
    ' lives in ',
    city,
    ' and weighs ',
    ROUND(weight),
    ' kilograms.') AS sentence
FROM person
JOIN branch
  ON person.branch_id = branch.id;

  Great! You know two ways to concatenate values: the || operator and the CONCAT() function. What is the difference between them?

Think back to using the || operator. When there was a NULL value in one of the joining columns, what was returned? A NULL.

The CONCAT() function converts NULL to an empty string. Let us see this in an example. Remember, if any of the columns you work with can contain a NULL, use the CONCAT() function and not the || operator.
-------------------------------------------------------------------------------------
Exercise 3
Fantastic! Another exercise on its way...

Exercise
For each person, show their first and last name along with their precise weight, their weight rounded down (name this column weight_down) and their weight rounded up to the next integer (name this column weight_up).

SELECT
	first_name,
    last_name,
    weight,
    FLOOR(weight) as weight_down,
    CEIL(weight) AS weight_up
FROM person

first_name	last_name	weight	weight_down	weight_up
Manuel	Krupp	79.03	79	80
Herschel	Woolwine	81.96	81	82
Josef	Shorty	97.51	97	98
----------------------------------------------------------------
Exercise 4
Good job! Ready to try the fourth exercise?

Exercise
For each branch, show its ID, country, city, and the average IQ of its members, rounded to 2 decimal places as the avg_iq column.

SELECT
	b.id,
    country,
    city,
    ROUND(AVG(iq),2) AS avg_iq
FROM branch b
JOIN person p
ON b.id = p.branch_id
GROUP BY 1,2,3

id	country	city	avg_iq
2	France	Paris	152.00
4	USA	New York	153.00
5	Brazil	Rio de Janeiro	151.00

-----------------------------------------------------------------------
Exercise 5
Fantastic! How about this one?

Exercise
For each person who registered in the last 3 months, show their first_name, last_name and the interval showing how long they've been a member (subtract the registration from CURRENT_DATE) as the member_for column.

SELECT
	first_name,
    last_name,
    CURRENT_DATE - registration::DATE  AS member_for
FROM person
WHERE registration BETWEEN CURRENT_DATE -  INTERVAL '3 MONTHS' AND CURRENT_DATE

Solution given:
SELECT
  first_name,
  last_name,
  CURRENT_DATE - registration AS member_for
FROM person
WHERE registration > CURRENT_DATE - INTERVAL '3 month';

first_name	last_name	member_for
Modesta	Hout	31
Gerry	Yanez	62
--------------------------------------------------
Exercise 6
You're doing well – just a few more to go!

Exercise
Count the number of people who registered in each month of 2015. Show two columns: month and count. You don't need to show months without registrations.

SELECT
	DATE_PART('month',registration) AS month,
    COUNT(id) as count
FROM person
WHERE DATE_PART('YEAR',registration) = '2015'
GROUP BY 1

month	count
3	1
6	1
7	1

Solution given:
SELECT
  EXTRACT(MONTH FROM registration) AS month,
  COUNT(id) AS count
FROM person
WHERE registration BETWEEN '2015-01-01' AND CAST('2015-01-01' AS DATE) + INTERVAL '1 year'
GROUP BY EXTRACT(MONTH FROM registration);
---------------------------------------------------
Exercise 7
Keep it up!

Exercise
For each city, show the average weight of branch members. Present the average as a decimal value with one decimal place. Name the column average_weight.

WITHOUT (weight::NUMERIC) GIVES,
ERROR: function round(double precision, integer) does not exist Hint: No function matches the given name and argument types. You might need to add explicit type casts. Line: 3 Position in the line: 5 Make corrections and try again

SELECT
	city,
    ROUND(AVG(weight::NUMERIC),1) AS average_weight
FROM person
JOIN branch
  ON person.branch_id = branch.id
GROUP BY 1;

Solution given:
SELECT
  city,
  ROUND(CAST(AVG(weight) AS numeric), 1) AS average_weight
FROM person
JOIN branch
  ON branch.id = person.branch_id
GROUP BY city;

 city	average_weight
Rio de Janeiro	84.5
Paris	77.6
New York	72.6
Berlin	83.4
Warsaw	74.2
---------------------------------------------------------------
Exercise 8
Great job! Let's move on.

Exercise
For each person, show their first name, their last name, and using the TO_CHAR() function their date of registration as the new_registration column in the following format:

Day, d Month YYYY

SELECT
	first_name,
    last_name,
    TO_CHAR(registration,'Day, d Month YYYY') AS new_registration
FROM person

first_name	last_name	new_registration
Manuel	Krupp	Friday , 6 November 2014
Herschel	Woolwine	Monday , 2 June 2013
Josef	Shorty	Tuesday , 3 July 2013
-----------------------------------------------------------------
Exercise 9
Fantastic! Are you ready for the next-to-last exercise?

Exercise
Show the truncated registration date by month as the year_month column, and display the count of people who register in the given year-month as the count column. Sort the result in ascending order according to the registration date.

SELECT
	DATE_TRUNC('Month',registration) AS year_month,
    COUNT(id)
FROM person
GROUP BY 1
ORDER BY 1

year_month	count
2012-05-01 00:00:00+00	1
2012-06-01 00:00:00+00	2
2012-12-01 00:00:00+00	1
2013-06-01 00:00:00+00	1
----------------------------------------------------
Exercise 10
Awesome! This is the last one!

Exercise
Let's see what aircraft were used while the Boeing 777-300 (ID of 8) was flying. You may remember that query from the exercise from the Date and Time functions part. Back then, we weren't able to show aircraft that were still flying, because of NULLs in the withdrawn_timestamp column. This time we want to see them too.

SELECT other.id, other.model
FROM aircraft other, aircraft boeing
WHERE boeing.id = 8
  AND other.id != 8
  AND (other.launched_timestamp,COALESCE(other.withdrawn_timestamp,CURRENT_TIMESTAMP)) OVERLAPS
      (boeing.launched_timestamp, boeing.withdrawn_timestamp);

  id	model
1	Airbus A321-200
2	Airbus A333-300
4	Airbus A320
5	Boeing 737-800
7	Boeing 787-10
10	Airbus A380-900
11	Embraer 170
12	Vision SF50
13	Airbus A320
14	Embraer 170
15	Boeing 777-800

