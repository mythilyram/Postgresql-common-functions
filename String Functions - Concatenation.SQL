The concatenation || operator
Okay, let's begin. First, we'll need a new operator: ||. These two vertical bars are the concatenation operator, i.e., they join two or more text values (or strings, which is another name for text). 
If you write the following:

SELECT first_name || last_name
FROM copywriter;
The result for first_name = 'Kate' and last_name = 'Gordon' will be KateGordon, all in a single column. Quite simple, right?

Of course we want the first and last name separated with a space. Here is how you do it:

SELECT first_name || ' ' || last_name
FROM copywriter;
Note that you use apostrophes for specific constant text values (a space in our example: ' '), but you don''t use apostrophes for column names (first_name, last_name). 
The operator || can be used as many times as you need in a single query.

Exercise
For each item, select its name, type, and in the third column named slogan_type both values joined by a dash ('-'):

name-type
Observe that if the name or type is NULL, then the slogan_type is also NULL.

Select
	name,
    type,
    name || '-' || type as slogan_type
from item

    name	type	slogan_type
WashPow(d)er	washing powder	WashPow(d)er- washing powder
riVer Flow	non-alcoholic cocktail	riVer Flow -non-alcoholic cocktail
Vacum2000	vacuum cleaner	Vacum2000 - vacuum cleaner
TripCare	backpack	TripCare -backpack
Vacum2010	null	null

The CONCAT() function
Excellent! You can use the || operator to concatenate string values, but it is not the only way. PostgreSQL also provides the CONCAT() function. Here is how to use CONCAT() to join a slogan's id, type, and copywriter_id:

SELECT CONCAT(id, ' ', type, ' ', copywriter_id) AS slogan
FROM slogan;

slogan
1 tv commercial 3
2 tv commercial 6
3 tv commercial 8
4 tv commercial 4
5 Internet ad 2
6 Internet ad 5
7 newspaper ad 7
8 newspaper ad 1

Notice that we included spaces as constant values here as well.

Exercise
For each item, show the following sentence:

ID X is Y.
Where X is the id of the item and Y is its name. Name the new column item_name.

Select
	CONCAT('ID ',id,' is ',name,'.') as item_name 
from item

item_name
ID 1 is WashPow(d)er.
ID 2 is riVer Flow .
ID 3 is Vacum2000 .
ID 4 is TripCare .
ID 5 is Vacum2010.

The || operator vs the CONCAT() function
Great! You know two ways to concatenate values: the || operator and the CONCAT() function. What is the difference between them?

Think back to using the || operator. When there was a NULL value in one of the joining columns, what was returned? A NULL.

The CONCAT() function converts NULL to an empty string. Let's see this in an example. Remember, if any of the columns you work with can contain a NULL, use the CONCAT() function and not the || operator.

Exercise
In this exercise, just look at the result.
You see Vacum2010 as the product name, although there was a NULL value in the type column.

SELECT
  name,
  type,
  CONCAT(name, type) AS product
FROM item;

name	type	product
WashPow(d)er	washing powder	WashPow(d)er washing powder
riVer Flow	non-alcoholic cocktail	riVer Flow non-alcoholic cocktail
Vacum2000	vacuum cleaner	Vacum2000 vacuum cleaner
TripCare	backpack	TripCare backpack
Vacum2010	null	Vacum2010
