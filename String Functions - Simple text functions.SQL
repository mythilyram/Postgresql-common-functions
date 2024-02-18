The LENGTH() function
Well done! Now that we know about concatenation, let's learn some string functions. We'll start with a simple one.

The LENGTH() function shows the length of a string column. For example:

SELECT
  first_name,
  LENGTH(first_name) AS len
FROM copywriter;


first_name	len
Olivier	7
Anne	4
Kate	4
Penelope	8
Mark	4
Alexander	9
Angela	6
Patricia	8
null	null

Suppose that first_name has a value of 'Anne'. LENGTH() will return 4 because 'Anne' has 4 letters. Simple, right?

Exercise
Show the id, text, and string length for every slogan (text) in the slogan table. Name the last column len.

SELECT
	id,
    text,
    LENGTH(text) AS len
FROM slogan

id	text	len
1	Feel the difference. Feel the powder.	37
2	Get enthusiastic - even without alcohol.	40
3	Cleaning the apartment is a matter of seconds.	46
4	You'll simply love it.	22
5	Powderful experience.	21
6	Cleaning your house has never been so easy.	43
7	Pleasure and responsibility come together.	42
8	Each traveller's choice.	24

Practicing LENGTH()
Good job! Remember, you are not limited to using the LENGTH() or other text functions in the SELECT clause only. You can use text functions in WHERE too! This allows you to select only rows with text of length greater or smaller than some value. For instance:

SELECT
  id,
  text
FROM slogan
WHERE LENGTH(text) > 45;

id	text
3	Cleaning the apartment is a matter of seconds.

The above query will select only those slogans whose length is greater than 45 characters.

Exercise
Show the IDs of all items with a name longer than 8 characters.

SELECT
	id
FROM ITEM    
WHERE LENGTH(name) >8

id
1
2
3
4
5

The LOWER() and UPPER() functions
Right! Let us move on to another text function: LOWER().

Whatever is passed as an argument to LOWER() will be written in small (lowercase) letters:

SELECT LOWER(last_name) AS lower_name
FROM copywriter;
LOWER() returns 'turner' for 'Turner'.

If there is a function for lowercase letters, there must be a function for capital (uppercase) letters too. 
There is! It is called UPPER() and works in a similar way:

SELECT UPPER(last_name) AS upper_name
FROM copywriter;
UPPER() returns 'TURNER' for the last name 'Turner'.

Let's try this in an exercise!

Exercise
The boss of the marketing agency said that it's very trendy to write Internet and newspaper ads in all lowercase letters. We don't want to reenter all of our slogans; let's use LOWER() instead.

For every slogan of the type 'newspaper ad' or 'Internet ad', show the slogan ID and its text in all lowercase. Name the last column trendy_slogan.

SELECT
	id,
	LOWER(text) as trendy_slogan
from slogan
where type = 'newspaper ad' 
	or type = 'Internet ad'

id	trendy_slogan
5	powderful experience.
6	cleaning your house has never been so easy.
7	pleasure and responsibility come together.
8	each traveller''s choice.

The INITCAP() function
Nice! Yet another function is INITCAP(), which will change the first letter of each word of text to upper case and the rest of the characters to lower. This is also called "title case". For instance, if someone mistakenly inserted first name as 'olivier' and last name with caps lock as 'sMITH', the query:

SELECT INITCAP(first_name || ' ' || last_name)
FROM copywriter;
will show 'Olivier Smith'. That is usually a convenient way to show names in a proper way.

Exercise
The boss wants you to update the names of all the items so that they are title cased. Show the id of each item together with its original name (as old_name) and the new name (as new_name).

SELECT
	ID,
    name AS old_name,
    INITCAP(name) AS new_name
FROM item

id	old_name	new_name
1	WashPow(d)er	Washpow(D)Er
2	riVer Flow	River Flow
3	Vacum2000	Vacum2000
4	TripCare	Tripcare
5	Vacum2010	Vacum2010

The LTRIM() and RTRIM() functions
Great! Let us look at functions that remove leading or trailing spaces from a string.

One of these is LTRIM(). It removes the leading (left) spaces from a string.

SELECT LTRIM(' Sophie ');
This query returns 'Sophie '. The leading space was removed.

The RTRIM() function removes the trailing (right) spaces from a string. It works in a similar way:

SELECT RTRIM(' Sophie ');
This returns ' Sophie'. There is a leading space, but no trailing space.

Exercise
Some of the item names in the item table have leading spaces. Show two columns:

The item name.
Prefix the value with 'No trim:' to see the leading spaces.
Name the column before_ltrim.
The item name without leading spaces.
Prefix the value with 'Trim:' to make sure the spaces have been removed.
Name the column after_ltrim.

SELECT
	'No trim:' ||name as before_ltrim,
    'Trim:'  || LTRIM(name) as after_ltrim
FROM item

before_ltrim	after_ltrim
No trim: WashPow(d)er	Trim:WashPow(d)er
No trim:riVer Flow	Trim:riVer Flow
No trim: Vacum2000	Trim:Vacum2000
No trim: TripCare	Trim:TripCare
No trim:Vacum2010	Trim:Vacum2010

The TRIM() function
You now know two functions that remove either leading or trailing spaces. 
Sometimes you need to remove both leading and trailing spaces. 
With PostgreSQL, you can do this with the TRIM() function. 
It only requires one parameter. Take a look:

SELECT TRIM(' Martin Smith      from England   .   ');
After calling this function, you get:

'Martin Smith      from England   .'
Exercise
Remove all leading and trailing spaces from the item names in the item table. For each item, show the original item name (name the column before_trim) and the item name without leading and trailing spaces (name the column after_trim). In order to see the difference, put asterisks (*) on both sides of the value (using the concatenation operator).

SELECT
  '*' || name || '*' AS before_trim,
  '*' || TRIM(name) || '*' AS after_trim
FROM item;

before_trim	after_trim
* WashPow(d)er*	*WashPow(d)er*
*riVer Flow *	*riVer Flow*
* Vacum2000 *	*Vacum2000*
* TripCare *	*TripCare*
*Vacum2010*	*Vacum2010*



