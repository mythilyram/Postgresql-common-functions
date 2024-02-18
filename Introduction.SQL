Introduction
Hello and welcome to the Common Functions in PostgreSQL course! This course introduces basic PostgreSQL functions which process different types of data. It focuses on the most used and most useful standard PostgreSQL functions, including:

PostgreSQL text functions.
PostgreSQL numeric functions.
PostgreSQL date and time functions.
PostgreSQL functions dealing with NULL.
This course is intended for intermediate users. For a general idea of what you should already know about SQL, we'll start with a short quiz. It consists of five questions that become progressively more difficult, and it's assumed you know how to:

Query a single table.
Query multiple tables using JOIN.
Sort and group rows.
Use the HAVING statement.

Exercise 1
Before we start, let's look at the tables we'll be working with.

We use two simple tables from an art gallery database. On the right side of the screen, there is a button named DATABASE. Click on it to study the structure of the tables.

The artist table includes:

An identifier for each artist (the id column).
The artist's first and last name (first_name, last_name).
The exact dates of the artist's birth and death (birth_date, death_date).
The artist's nationality (nationality).
The painting table includes:

A unique identifier for each painting (the id column).
The ID of its artist (artist_id).
The title of the painting (title).
The year it was created (painted).
A rating for that painting, given by local experts (rating).
Now let's start the first exercise.

Exercise
For each painting created after 1800, show its title and the year it was painted. Include paintings for which the creation date is unknown.

select
	title,painted
from Painting
where painted > 1800 or painted isnull

title	painted
Portrait of Artist''s Mother	1888
Portrait of Patience Escalier	1888
Self-Portrait	1889
Impression, Sunrise	null
The Woman in the Green Dress	1886
Old Woman	1901
Femme au café	1901
La Vie	1903

Exercise
For each painting, show its title and the first and last name of the painter. Only show results for Dutch and Flemish painters.

Select
	title,
    first_name,
    last_name
from painting p
join artist a
on p.artist_id = a.id
where nationality = 'Dutch' or nationality = 'Flemish'

title	first_name	last_name
Portrait of Artist''s Mother	Vincent	Van Gogh
Portrait of Patience Escalier	Vincent	Van Gogh
Self-Portrait	Vincent	Van Gogh
The Fall of Phaeton	Peter	Rubens
Portrait of a Young Scholar	Peter	Rubens
Descent from the Cross	Peter	Rubens
The Three Graces	Peter	Rubens

Exercise
Show the number of paintings (as number_of_paintings column) created in, or after, 1888.

Select 
	count(title) as number_of_paintings
from painting
where painted >=1888

number_of_paintings
6

Exercise
For each painter, show their first and last name, together with their total number of paintings (as number_of_paintings column).

Select
	first_name,
    last_name,
    count(title) as number_of_paintings
from artist a
join painting p
on a.id = p.artist_id
group by 1,2

first_name	last_name	number_of_paintings
Claude	Monet	2
Pablo	Picasso	3
Leonardo	Da Vinci	1
Peter	Rubens	4
Vincent	Van Gogh	3

Exercise
For each artist, show their first and last name and the minimum, average, and maximum scores of their paintings (as min_rating, avg_rating, max_rating columns). Only show artists with more than two paintings.

Select
	first_name,
    last_name,
    min(rating) as min_rating, 
    avg(rating) as avg_rating, 
    max(rating) as max_rating
from artist a
join painting p
on a.id = p.artist_id
group by 1,2
having count(title) > 2

first_name	last_name	min_rating	avg_rating	max_rating
Pablo	Picasso	7	8.0000000000000000	9
Peter	Rubens	8	8.5000000000000000	9
Vincent	Van Gogh	6	7.0000000000000000	8


