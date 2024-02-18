The POSITION() function
Great! Let's try another function.

There are times when you need to find a certain expression or set of characters in a string. Maybe you don't know what the whole string contains, but you know it has the letters 'br' in it somewhere.
To find the index location of this string, use the POSITION() function. It has two parameters: the character string you want to find, the keyword IN, and the string or field to be searched. 
Here is an example:

SELECT POSITION('br' IN 'abracadabra');
The text 'abracadabra' starts with the letter 'a' (index position 1). The first occurrence of the string 'br' will be at index 2. The position returned by this POSITION() function is indeed 2.

A similar POSITION() function is STRPOS() supported by PostgreSQL, but the arguments are in reverse order and without the keyword IN: first is a string to search in and second is a substring to search:

SELECT STRPOS('abracadabra', 'br');
This query returns 2.

Exercise
In the item table, show the position of the letter 'r' in all item names. Name the column r_index.

Note that POSITION() returns 0 if the pattern is not present in the searched string.

SELECT 
	POSITION('r' IN name) as r_index
FROM item

r_index
15
1
0
3
0

The REVERSE() function
Nice! The next text function we will try is REVERSE(). This takes a string as a parameter and returns its characters in reverse order.

Here we have a query that reverses the order of item names:

SELECT REVERSE(name)
FROM item;

As you can see, its a pretty simple function to use.

reverse
re)d(woPhsaW
wolF reVir
0002mucaV
eraCpirT
0102mucaV

Exercise
The marketing agency is organizing a costume party for all the copywriters. Each copywriter will be given a name tag with their first name spelled backward.

Let's reverse the first name of each copywriter whose ID is less than five. Show the copywriter's real first name and their "reversed" first name as the nickname column.

SELECT 
	first_name,
    REVERSE(first_name) AS nickname
FROM copywriter
WHERE id < 5;

first_name	nickname
Olivier	reivilO
Anne	ennA
Kate	etaK
Penelope	epoleneP

The REPLACE() function
Great! You can also replace parts of a string with anything you want using the REPLACE() function. 
It works like this:

REPLACE(string, substring_to_change, new_substring)
This searches string and, if it finds the substring_to_change, replaces substring_to_change with the text in new_substring. Let us try it!

SELECT REPLACE('young man', 'young', 'old');
In the above example, the function will look for 'young' in the string 'young man' and will replace it with 'old'. 
As a result, we will get 'old man'. Of course, you can provide a column name instead of an actual text.

Let us practice using this function!

Exercise
For the slogan with an ID of 1, replace the word 'Feel' with 'Touch'. Show the slogan''s original text and the updated text as the updated_text column.

SELECT
	text,
	REPLACE(text,'Feel', 'Touch') as updated_text
FROM slogan
WHERE id = 1

text	                                          updated_text
Feel the difference. Feel the powder.	    Touch the difference. Touch the powder.

The TRANSLATE() function
PostgreSQL provides another function similar to REPLACE(). It is TRANSLATE(), and it looks like this:

TRANSLATE(string_to_search, old_characters, new_characters)
This function searches string_to_search, which can be an actual string or a field in the database, for the characters in old_characters.
When it finds them, they're replaced with the corresponding characters in the new_characters. Here's how it looks:

SELECT
  id,
  text,
  TRANSLATE(text, ' .', '*!') AS translated_text
FROM slogan;
This will change the text of the slogans in the slogan table. The characters we are replacing are ' .' – spaces and periods.
We want to translate them to '*!': all spaces are replaced with the asterisks and all dots are replaced with the exclamation marks. Look at the result:

id	text	translated_text
1	Feel the difference. Feel the powder.	Feel*the*difference!*Feel*the*powder!
2	Get enthusiastic - even without alcohol.	Get*enthusiastic*-*even*without*alcohol!

Exercise
The marketing boss wants to make some of the slogans more original by replacing exclamation marks (!) with periods (.) and spaces ( ) with underscores (_). 
Do this for copywriters with an ID of 1, 2, 3, or 4. 
Show the new slogan text and the first and last name of the copywriter. Name the first column new_slogan.

SELECT
  TRANSLATE(text, '! ', '._') AS new_slogan,
  first_name,
  last_name
FROM slogan s
JOIN copywriter c
ON s.copywriter_id = c.id
WHERE c.id IN (1,2,3,4)

new_slogan      	                    first_name	      last_name
Feel_the_difference._Feel_the_powder.	  Kate	          Gordon
You will_simply_love_it.	              Penelope	        Stone
Powderful_experience.	                  Anne	          Sharp
Each_traveller's_choice.            	Olivier	          Norris

The REPEAT() function
Fantastic! The last function in this section is REPEAT(). It repeats a string (given in the first parameter) however many times specified by the second parameter.
Here's an example:

SELECT REPEAT('.', 3) || name
FROM item;
This query returns the item name with three periods in front of it. Let's try this function out!

?column?
... WashPow(d)er
...riVer Flow
... Vacum2000
... TripCare
...Vacum2010

Exercise
Slogans with multiple star and dot characters (e.g., SLOGAN *.*.*.*.*.) are fashionable this season. 
The marketing agency management has decided to change all slogans'' texts to add at the end a space and a chain of five '.**.'. Name the column fashionable_text.

SELECT  
	text || ' ' || REPEAT('.**.', 5) AS fashionable_text
FROM slogan;

fashionable_text
Feel the difference. Feel the powder. .**..**..**..**..**.
Get enthusiastic - even without alcohol. .**..**..**..**..**.
Cleaning the apartment is a matter of seconds. .**..**..**..**..**.
You'll simply love it. .**..**..**..**..**.
Powderful experience. .**..**..**..**..**.
Cleaning your house has never been so easy. .**..**..**..**..**.
Pleasure and responsibility come together. .**..**..**..**..**.
Each traveller's choice. .**..**..**..**..**.

Summary
Good!

That's it for this section! Before we move on, let's review what we've learned:

|| is the concatenation operator. The || operator and the CONCAT() function are the concatenation functions. Both merge multiple strings into one.
LENGTH(s) returns the length of a string.
LOWER() and UPPER() functions change all letters in a string to lowercase or uppercase.
INITCAP(t) changes the first letter of each word of string t to title case.
LTRIM(s), RTRIM(s), and TRIM(s) return a string after removing spaces from the left, right, or both sides of a given string s.
LTRIM(s, 'set'), RTRIM(s, 'set'), and TRIM(s, 'set') return a string after removing custom set of characters from the left, right, or both sides of a given string s.
SUBSTRING(s, x, y) returns part of string s, starting from position x and returning the number of characters defined by y.
LEFT(s, n) returns the first n characters as the substring from the left side (beginning of the string).
RIGHT(s, n) returns the last n characters as the substring from the right side (end of the string).
POSITION(c IN s) finds the first occurance (index) of string c in string s.
STRPOS(s, c) does the same as the POSITION() function but has a different syntax.
REVERSE() returns text with all the characters in reverse order.
REPLACE(string, from, to) will replace from with to in the string string.
TRANSLATE(string, from, to) will make replacements in string based on the sets passed as strings into the from and to parameters.
REPEAT(x, n) will return the x string repeated n times.

Exercise
Show the ID of each item, its name uppercased (as the upper_case column), and its reversed name (as the reversed column).

	SELECT
    	id,
        UPPER(name) AS 	upper_case,
        REVERSE(name) AS reversed
   FROM
   item

id	upper_case	reversed
1	WASHPOW(D)ER	re)d(woPhsaW
2	RIVER FLOW	wolF reVir
3	VACUM2000	0002mucaV
4	TRIPCARE	eraCpirT
5	VACUM2010	0102mucaV

Exercise
For each slogan longer than 20 characters, show a 20-character substring starting from the fifth position. Name the column sub_text.

SELECT 
	SUBSTRING(text,5,20) AS sub_text
FROM slogan
WHERE LENGTH(text) > 20

sub_text
the difference. Fee
enthusiastic - even
ning the apartment i
ll simply love it.
erful experience.
ning your house has
sure and responsibil
traveller''s choice.

Exercise
For each 'tv commercial' slogan, show the item name, its type, and the slogan with each period (.) replaced with 
three exclamation marks (!!!) as the explosive_text column.
SELECT
	name,
    i.type,
    REPLACE(text,'.','!!!') AS explosive_text
FROM item i
JOIN slogan s
ON i.id = s.item_id
WHERE s.type = 'tv commercial'
