Numbers can cause a headache. You need to fight them back!

Today, we're going to take a close look at how numbers work in PostgreSQL – specifically, we're going to focus on those small details that make a huge difference.

The table player
Let's introduce the table we'll use in this part of the course. The first table you will operate on is the player table. It contains details about each player:

id – identifier of the player.
first_name – first name of the player.
last_name – last name of the player.

Exercise
Select all data from the player table.

SELECT
	*
FROM player

id	first_name	last_name
1	Alan	Gilman
2	Kate	Friss
3	Anne	Birch
4	Adrian	Regos
5	Stephen	Colvin

Get to know the character table
Let's go to the second table. If you love MMORPG games, you'll love this table too. The table is named character, and it stores information about 
characters in an online role-playing game. Each player can have more than one character. Let us see what this table contains.

Exercise
Select all columns from the character table. Each character has its own unique id, and is associated with the ID of the player who created it (the player_id column). 
All characters have reached a certain level, belong to a certain class (e.g., 'wizard' or 'warrior'), and have some money (account_balance).

There are also stats like hp (health points), mp (mana points), strength, and wisdom. Due to various curses and blessings, characters'' statistics can be affected by 
the stat_modifier attribute, which can be positive or negative.

Finally, there is the height and weight of each character, expressed in meters and kilograms, respectively.

SELECT
	*
FROM character

id	player_id	name	level	class	account_balance	hp	mp	strength	wisdom	stat_modifier	weight	height
1	1	Kav	3	wizard	899.34	100	200	12	20	1	65	1.72
2	2	Gniok	5	warrior	423.83	170	80	20	23	4	101.4	2
3	1	Mnah	2	warrior	0.00	140	60	16	20	-1	80.3	1.93
4	2	Balryll	1	warrior	723.12	130	50	15	0	2	78.9	1.87
5	3	Mnadjaid	13	wizard	4321.93	171	37	86	-3	61	1.67	null
6	4	Duroso	24	wizard	7231.32	240	890	45	104	17	0.2	1
7	5	Rolamar	3	warrior	753.42	150	65	18	21	-29	91.3	1.85
8	5	Avealath	7	warrior	1023.00	190	95	28	29	17	95.2	1.9

First, a quick review
Before we continue, let us review what we already know about numbers. 

Integers are expressed in the following way: 1, 2, 43, -27, etc. 
Fractions are expressed with a dot (.): 12.45, -401.238, etc. 
Please note that in some languages, you use a comma instead of a dot, but not in SQL! For example, 12,45 is incorrect.

In PostgreSQL (and in most programming languages) there are three kinds of numbers:

Integer (integer): stores integers (e.g., -5, 0, 5, 42).
Floating-point (real, double precision): stores fractions by approximating them in binary.
Decimal (numeric): stores fractions in decimal format.

In this part, we'll discuss some of the differences between PostgreSQL's number data types.

Of course, you can use the four basic mathematical operations (add +, subtract -, multiply *, and divide /) with actual numbers in PostgreSQL. 
You can also use columns and constant numbers together. Take a look at the example below:

SELECT hp / 4 AS quarter_hp
FROM character;

quarter_hp
25
42
35
32
42
60
37
47

Exercise
For each character, display its name, level, and the sum of its hp and mp as the hmp column.

SELECT 
	name, 
    level, 
    hp+mp as hmp
FROM character;

name	level	hmp
Kav	3	300
Gniok	5	250
Mnah	2	200
Balryll	1	180
Mnadjaid	13	208
Duroso	24	1130
Rolamar	3	215
Avealath	7	285

Numeric functions: concatenation
Good! You can also join numbers and text values using the concatenation operator ||. Take a look:

SELECT 'Your character is at level ' || level AS level_info
FROM character;

level_info
Your character is at level 3
Your character is at level 5
Your character is at level 2
Your character is at level 1
Your character is at level 13
Your character is at level 24
Your character is at level 3
Your character is at level 7

Simple, right?

Exercise
For each character above level 1, show the following text:

The account balance for NAME is MONEY.
Where NAME is the name of the character and MONEY is the current account balance. Name the column account_info.


SELECT 
	'The account balance for ' || name || ' is ' || account_balance || '.' AS account_info
FROM character
WHERE level > 1;

account_info
The account balance for Kav is 899.34.
The account balance for Gniok is 423.83.
The account balance for Mnah is 0.00.
The account balance for Mnadjaid is 4321.93.
The account balance for Duroso is 7231.32.
The account balance for Rolamar is 753.42.
The account balance for Avealath is 1023.00.

Problems with subtraction
Great! In PostgreSQL, simple operations can get very tricky. Let us discuss some of them, starting with subtraction.

Exercise
For a character named 'Mnah', select the name, weight, height, and the result of the following calculation:

weight - height - weight + height AS zero
It should equal 0, right?

SELECT
	name, weight, height,
    weight - height - weight + height AS zero
FROM character
WHERE name = 'Mnah'

name	weight	height	zero
Mnah	80.3	1.93	-3.5762787e-07

Binary arithmetic is not exact
Oops... Something went wrong. Why did we get such an odd result?

The weight and height columns have a real data type, which is a floating point number. The internal representation is binary arithmetic, which means not all decimals can be represented precisely. Therefore, any computations are not performed exactly, as we can see.

What can be done about it? Nothing! That is the way binary arithmetic works.

If you need exact computations, use decimal, numeric and money (for currency) data types. When dealing with money values, always use decimal, numeric or money data types. Floating point numbers are for "scientific" computations on various measurements, like weight and height.

Problems with division
Good job!

Now you know that subtraction can be tricky. What about division?

How much is 1 / 4? Let us check that.

SELECT 1 / 4 AS result;

result
0

Integer division
Wait... what? We got a 0? After being taught it's 0.25? Has someone deceived us?

Not really.

What happened here is called integer division. This occurs when both the dividend and the divisor are integers. Since they are integers, PostgreSQL wants to return an integer result to match the operand types. In other words, it brutally cuts off the decimal part, which is .25 in our case. The zero (0) is the only thing left.

So, how can we make sure that the result includes the decimal part? One way is to change the type of one of the values to a decimal (e.g., 1 / 4.0 instead of 1 / 4). In this course, we will always change the type of the denominator.

Exercise
Run another example query to see what happens when you use a decimal number.

SELECT 1 / 4.0 AS result;

result
0.25000000000000000000

Casting values to other types
Hah! It worked this time, didn't it? That's how you can force the desired result in PostgreSQL.

There is one problem with this method: What if both numbers are given as columns, like hp / level? 
We need to use another trick: explicitly converting one column to another data type. This procedure is called casting, and it uses the structure shown below:

SELECT (hp::numeric) / level AS result
FROM character;
The structure column::type changes the column to the specified type.

result
33.3333333333333333
34.0000000000000000
70.0000000000000000
130.0000000000000000
13.1538461538461538
10.0000000000000000
50.0000000000000000
27.1428571428571429
 
You can do this also by using the CAST() function:

SELECT CAST(hp AS numeric) / level AS result
FROM character;

This function takes the name of the column to convert, the keyword AS, and the new data type.

result
33.3333333333333333
34.0000000000000000
70.0000000000000000
130.0000000000000000
13.1538461538461538
10.0000000000000000
50.0000000000000000
27.1428571428571429

In PostgreSQL, there are three kinds of number data types:

Integer data types with names like smallint, integer, bigint, etc.
Exact number data types (i.e., decimal types) with names like numeric, decimal, money.
Inexact number data types with names like real, double precision.
When dividing two integers in this course, we always cast the numerator to a numeric data type. 
In a real world application, you may need a different precision and a different casting (e.g., casting both numbers to real).

Exercise
For each character, show its name, level, and the health points divided by the mana points as the ratio column.

Cast hp to the numeric data type to get a precise result.

SELECT 
	name, 
    level, 
    CAST(HP AS numeric)/mp AS ratio
FROM character;

name	level	ratio
Kav	3	0.50000000000000000000
Gniok	5	2.1250000000000000
Mnah	2	2.3333333333333333
Balryll	1	2.6000000000000000
Mnadjaid	13	4.6216216216216216
Duroso	24	0.26966292134831460674
Rolamar	3	2.3076923076923077
Avealath	7	2.0000000000000000

Division by zero, part one
Okay, let's discuss the division problem further. As you know, there is one thing that you can never do: divide by zero. Let's see what happens when we follow the path of mathematical darkness and divide by zero...

SELECT 5 / 0 AS result;

ERROR: division by zero Line: 1 Position in the line: 1

Division by zero, part two
Now let's see what happens if you have many rows, of which only one contains division by 0.

Exercise
Warriors get their first wisdom points at Level 2 and we have one warrior at Level 1 with 0 Wisdom points. Let's see what happens.

For each character, divides their mana points by their wisdom points. 

SELECT
  name,
  mp::numeric / wisdom AS ratio
FROM character;

ERROR: division by zero Line: 1 Position in the line: 1


Getting rid of division by zero
Oops! As you can see, the error occurs even if there is only a single row with a zero value in the denominator. 
How can we deal with this? There are a few ways to solve the problem. For now, you can use the good old WHERE clause to filter out any rows that contain a zero:

WHERE column_name != 0
We'll discuss other methods of dealing with division by zero later in our course.

Exercise
In the template you can find the query from the previous exercise. Filter out rows with 0 wisdom points.

SELECT
  name,
  mp::numeric / wisdom AS ratio
FROM character
WHERE wisdom != 0;

The modulo operator (%)
Okay. There's one more useful operator related to division: the modulo operator (%). It returns the remainder of one number divided by another number, like this:

x % y
For instance, 9 % 7 will return 2, because 9 / 7 is 1 with 2 as the remainder. This operator works with integer and decimal numbers.

Exercise
In our game, you can increase your strength by 1 if you sacrifice 7 HP. For each character, show its name and calculate how many health points will be left if the player decides to sacrifice the maximum number of HP. Name the column hp_left.

SELECT
	name,
    hp % 7 AS hp_left
FROM character

name	hp_left
Kav	2
Gniok	2
Mnah	0
Balryll	4
Mnadjaid	3
Duroso	2
Rolamar	3
Avealath	1






