Introduction
In this part, we'll teach you some basic PostgreSQL string functions. They'll help you manipulate text values in your queries, and you'll learn how to:

Concatenate (combine) multiple text values into one.
Convert text to uppercase and lowercase.
Convert text to display characters in reverse order.
Select substrings and find their position in a string.
Find the length of a string.
Trim a string.
Replace parts of a string.
We'll work with data from a marketing agency. Let's go!

Exercise
Select all data from the item table. It contains the following columns:

id – item identifiers.
name – their names.
type – their descriptions.

Select * from item

id	name	type
1	WashPow(d)er	washing powder
2	riVer Flow	non-alcoholic cocktail
3	Vacum2000	vacuum cleaner
4	TripCare	backpack
5	Vacum2010	null

The copywriter table
Good! Now check out the next table.

Exercise
Select all data from the copywriter table. It has only three columns:

id – their identifier.
first_name – their first name.
last_name – their last name.

select * from copywriter

id	first_name	last_name
1	Olivier	Norris
2	Anne	Sharp
3	Kate	Gordon
4	Penelope	Stone
5	Mark	Ratliff
6	Alexander	Turner
7	Angela	Bowen
8	Patricia	Lawrence
9	null	Lawrence

The slogan table
Finally, let's look at the third table.

Exercise
Select all data from the slogan table. For each record, we have:

id – an identifier.
item_id – an ID of an advertised product.
type – the best medium for the slogan (e.g., TV, Internet, or newspapers).
text – the slogan itself.
copywriter_id – the ID of the copywriter who wrote that slogan.

select * from slogan

id	item_id	type	text	copywriter_id
1	1	tv commercial	Feel the difference. Feel the powder.	3
2	2	tv commercial	Get enthusiastic - even without alcohol.	6
3	3	tv commercial	Cleaning the apartment is a matter of seconds.	8
4	4	tv commercial	You'll simply love it.	4
5	1	Internet ad	Powderful experience.	2
6	3	Internet ad	Cleaning your house has never been so easy.	5
7	2	newspaper ad	Pleasure and responsibility come together.	7
8	4	newspaper ad	Each traveller's choice.	1
