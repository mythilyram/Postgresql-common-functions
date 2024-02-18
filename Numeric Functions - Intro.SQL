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
Let's go to the second table. If you love MMORPG games, you'll love this table too. The table is named character, and it stores information about characters in an online role-playing game. 
Each player can have more than one character. Let us see what this table contains.

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



