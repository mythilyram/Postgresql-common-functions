Introduction
Welcome to Part 5! In this part, we're going to learn about useful PostgreSQL functions that deal with NULLs. You're familiar with NULLs already, but this will extend your knowledge. 

The product table
Before we start, we'll introduce today's guest, Mr. Adams. He's the CEO of Home made yours, a company that sells furniture and home accessories.

He's agreed to show us a snippet of his company's product table. Let's see what's there.

Exercise
Select all columns from the product table and study its contents.

SELECT * FROM product

id	category	name	type	price	market1_price	market2_price	market3_price	launch_date	production_area	shipping_cost	description
1	bedroom	Vaatekaappi	wardrobe	276.19	278.23	301.60	299.99	2015-08-01	UE	0.00	Feel invited to take a journey around this spacious wardrobe. Vaatekaappi is the number one choice for every luxurious bedroom!
2	null	Spisebord	dining table	107.99	110.30	121.00	109.99	null	UE	0.00	Spisebord is a simple dining table which will fit in every living room. Its wooden pattern makes it ideal for every rustical home.
3	living room	Salongbord	coffee table	112.79	133.50	120.70	null	2016-01-01	China	5.99	Created by a group of French designers, this coffee table will make your life much easier. Be it your favorite drink during afternoon tea time or your legs after a long day at work – Salongbord will satisfy your needs.
4	kitchen	Tekanna	null	10.00	15.00	17.80	19.99	2015-02-25	UE	2.99	This amazing tea kettle is equipped with a number of LED lights. Thanks to it, you will never lose your way when you want a cup of tea at night.
5	kitchen	Haarukka	fork	2.50	1.99	1.99	null	2014-07-05	null	1.99	This award-winning fork has been with us for a long time. Feel the difference with our Haarukka. You will never get hungry again!
6	bathroom	Handduk	towel	2.99	8.99	7.00	9.99	null	China	1.99	Three times smaller than your usual towel, yet still as efficient. Try Handduk today!
7	null	Krus	null	8.00	15.68	16.00	12.99	2013-04-30	null	2.99	Resistance against hot temperatures makes this mug one of a kind.
8	hall	null	mirror	13.59	20.55	18.50	19.99	2013-01-01	China	2.99	Let's you see your true inner self.

A quick review of NULLs
Okay, now let's do a quick review of NULLs.

A NULL indicates that a value is unknown or missing. You might see a NULL in the last_name field of a client table if you don't have the client's last name (because you forgot to ask!). You may have a NULL in the launch_date field of a product table if that product hasn't been launched.

A NULL in a product_price field doesn't mean that the product is free, just that we don't know the price.

We use the operators IS NULL and IS NOT NULL to check if a value is NULL. IS NULL works like this:

SELECT *
FROM product
WHERE category IS NULL;
Exercise
Select name for all products whose launch_date isn't a NULL.

SELECT 
	name
FROM product
WHERE launch_date IS NOT NULL;

name
Vaatekaappi
Salongbord
Tekanna
Haarukka
Krus
null

The COALESCE() function
Next, let's look at how the COALESCE() function can help with NULLs. This is a standard SQL function also used in PostgreSQL.

The COALESCE(x, y) function returns the first value that is not NULL. Check out the example:

SELECT
  name,
  COALESCE(category, 'none') AS category
FROM product;
In this query, a product with an associated category will have its name and category shown. If there is a NULL in a product's category field, the query will show "none" instead of a category name.

If you're wondering what the word "coalesce" means, it basically means "to come together, to form one group or mass." You can use coalesce literally (ingredients can coalesce into bread) or figuratively (ideas can coalesce).

Exercise
Select the names and categories for all products. If any of these columns has a NULL, show 'n/a' instead. Rename the new columns to name and category.

SELECT
  COALESCE(name, 'n/a') AS name,
  COALESCE(category, 'n/a') AS category
FROM product;

name	category
Vaatekaappi	bedroom
Spisebord	n/a
Salongbord	living room
Tekanna	kitchen
Haarukka	kitchen
Handduk	bathroom
Krus	n/a
n/a	hall


Data types in COALESCE()
Excellent! It's good to remember that COALESCE() takes an argument of only one data type. For instance, the following works fine:

SELECT COALESCE(price, 0.00) AS price
FROM product;
The price column is of decimal data type; therefore we replace its 0.00 value which is the same data type. This function will return 0.00 in place of a NULL value in the price column.

Check it out yourself. Try to use the COALESCE() function to show the product name and the launch_date or 'no date' when the date is unknown.

Exercise
Run the template query. When you're done, click I'm done. Next exercise to continue.

ERROR: invalid input syntax for type date: "no date" Line: 3 Position in the line: 25

Using COALESCE() with other functions
Nice! You can also use COALESCE() with other functions and operations, such as concatenation, multiplication, etc. Take a look:

SELECT
  COALESCE(category, 'unknown category')
    || ': '
    || COALESCE(type, 'unknown type')
    AS category_type
FROM product;

  category_type
bedroom: wardrobe
unknown category: dining table
living room: coffee table
kitchen: unknown type
kitchen: fork
bathroom: towel
unknown category: unknown type
hall: mirror

In the above query fragment, a NULL category or type value is replaced with an appropriate message, but we can still see the type when the category is NULL (and vice versa).

Exercise
Show the following sentence:

Product X is made in Y.
X is the product name and Y is the production area. If the product name is not provided, display 'unknown name' instead. If the production area is not provided, substitute 'unknown area'. Name the column origin.

SELECT
  'Product ' || COALESCE(name, 'unknown name') 
  || ' is made in ' || 
  COALESCE(production_area, 'unknown area')
  || '.' as origin
    
FROM product;

origin
Product Vaatekaappi is made in UE.
Product Spisebord is made in UE.
Product Salongbord is made in China.
Product Tekanna is made in UE.
Product Haarukka is made in unknown area.
Product Handduk is made in China.
Product Krus is made in unknown area.
Product unknown name is made in China.

Using COALESCE() in calculations
Awesome! You can also use COALESCE() in calculations:

SELECT COALESCE(price, 0) * 1.05
FROM product;
This will return each product's price times 1.05 (if there's a price value) or a zero if the price is NULL.

Exercise
The company is giving a 10% discount on all prices for in its first market shop. Show the names of all products, their current price (market1_price), and the new discounted price. Name the new column new_market1_price. If there is no price, show 0.0.

 SELECT 
	name,
    market1_price,
    COALESCE(market1_price,0.0)*.9 AS New_market1_price
FROM product;

  name	market1_price	new_market1_price
Vaatekaappi	278.23	250.407
Spisebord	110.30	99.270
Salongbord	133.50	120.150
Tekanna	15.00	13.500
Haarukka	1.99	1.791
Handduk	8.99	8.091
Krus	15.68	14.112
null	20.55	18.495

  Using COALESCE() with multiple parameters
Good job! The last thing you should know about COALESCE() is that it can take more than two arguments. It will simply look for the first non-NULL value in the list and return it.

SELECT COALESCE(name, id::char, 'n/a')
FROM product;
The above function will show a product name. If the name is unknown, it will show the product id instead. If both the name and id are unknown, it will simply show 'n/a'.

Exercise
Show each product's name and type. When the type is unknown, show the category. If the category is missing too, show 'No clue what that is'. Name the column type.

  SELECT 
	name,
    COALESCE(type, category, 'No clue what that is') as type
FROM product;
name	type
Vaatekaappi	wardrobe
Spisebord	dining table
Salongbord	coffee table
Tekanna	kitchen
Haarukka	fork
Handduk	towel
Krus	No clue what that is
null	mirror


-------------------------------------------------------------------------------------

The GREATEST() function
Great! The next function you'll get to know is GREATEST(), used to select the largest value among values given as arguments. Look at the first example of the function GREATEST():

SELECT
  id,
  GREATEST(market1_price, market2_price) AS largest_price
FROM product;
How does it work? In our database, each product has three different prices in three different shops (columns: market1_price, market2_price, market3_price). For each product, the query above displays, the largest price between shop 1 and shop 2.

Don't consider using the MAX() function, as it's a not good solution. Why? The MAX() function is an aggregate function. It returns only one value – the greatest value in a column and it collapses all the rows. The GREATEST() function finds the largest value from a list of expressions. It can select a different value for each row.

Exercise
Find the largest price for each product among all three shops. Select ID, the name of the product and the largest price as the largest_price column.

SELECT
  id,
  name,
  GREATEST(market1_price, market2_price, market3_price) AS largest_price
FROM product;

id	name	largest_price
1	Vaatekaappi	301.60
2	Spisebord	121.00
3	Salongbord	133.50
4	Tekanna	19.99
5	Haarukka	1.99
6	Handduk	9.99
7	Krus	16.00
8	null	20.55

  
The LEAST() function
Similar to the GREATEST() function there is the LEAST() function. Here is the query using it:

SELECT
  id,
  LEAST(market1_price, market2_price) AS smallest_price
FROM product;
This query returns the lowest price between shop 1 and shop 2.

Exercise
Find the smallest price of each product among prices in all three shops. Select ID, the name of the product, and the smallest price as the smallest_price column.

  SELECT
  id,
  name,
  LEAST(market1_price, market2_price, market3_price) AS smallest_price
FROM product;

  id	name	smallest_price
1	Vaatekaappi	278.23
2	Spisebord	109.99
3	Salongbord	120.70
4	Tekanna	15.00
5	Haarukka	1.99
6	Handduk	7.00
7	Krus	12.99
8	null	18.50

  The GREATEST() and the LEAST() with NULL
Okay. But what if a value in the list of arguments in GREATEST() or LEAST() functions is NULL? They omit NULL and return the largest or the least values for those different than NULL. The query looks like this:

SELECT
  id,
  LEAST(market2_price, market3_price) AS smallest_price
FROM product;
For the product with ID of 5 it returns 1.99. This comes from the market2_price column because the market3_price stores NULL; therefore it is ignored.

NULL is returned only if all arguments are NULL.

Exercise
For the product with ID of 3 show its name and the largest_price in all three shops.

  SELECT
  name,
  GREATEST(market1_price, market2_price, market3_price) AS largest_price
FROM product
WHERE id = 3;
  name	largest_price
Salongbord	133.50
  -----------------------------------------------------------------------------------
  The NULLIF() function
Another useful function, albeit one that's less frequently applied, is NULLIF(x, y).

It returns a NULL if both x and y are equal. Otherwise, it returns the first argument. For example, NULLIF(5, 4) returns 5, while NULLIF(5, 5) returns NULL.

Why would you use this function? Because it helps you avoid division by zero. Consider this example:

We have $10,000 and want to give an equal amount to a number of people. There's a number stored in the all_people column. However, some people are rich and don't need the money, and their number is stored in the rich_people column. Now, if we want to decide how much a single 'not-rich' person should receive, we could write:

10000 / (all_people - rich_people)
This query works fine, unless all the people are rich. We will then get a 0 in the denominator.

As you know, we can't divide by zero, so the database will return an error. We can use the NULLIF() function to solve this problem:

10000 / NULLIF(all_people - rich_people, 0)
NULLIF() checks if the subtraction equals 0. If it does equal 0, the function returns a NULL; otherwise it just gives the result of the subtraction.

Dividing by zero is illegal in PostgreSQL, but dividing by NULL will just give a NULL. In this way, we can prevent our database from producing an error.

Exercise
Today, Home made yours has a special offer: the price of each product has decreased by $1.99. This means some products may be free!

A customer has $1,000.00 and would like to know how many of each product he could buy. Show the name of each product and the quantity he could buy (i.e., divide 1000.00 by the new price of each product).

In case of division by zero, return a NULL. Most products will have a decimal part, but don't worry about it.

SELECT
	name,
    1000/NULLIF(price-1.99,0) AS quantity
FROM product

name	quantity
Vaatekaappi	3.6469730123997082
Spisebord	9.4339622641509434
Salongbord	9.0252707581227437
Tekanna	124.8439450686641698
Haarukka	1960.7843137254901961
Handduk	1000.0000000000000000
Krus	166.3893510815307820
null	86.2068965517241379

Practice NULLIF() – 1
Good! Let's do another exercise to practice the use of the NULLIF() function.

Exercise
Show the name of each product and the ratio column calculated in the following way: the price of each product in relation to its shipping_cost in percent, rounded to an integer value (e.g., 31).

If the shipping cost is 0.00, show NULL instead.

SELECT
	name,
    round(price/NULLIF(shipping_cost,0)*100) AS ratio
FROM product

name	ratio
Vaatekaappi	null
Spisebord	null
Salongbord	1883
Tekanna	334
Haarukka	126
Handduk	150
Krus	268
null	455

Exercise
Mr. Adams wants to launch a new promotion: Each customer who orders a product and picks it up (i.e., no shipping required) can buy it at a special price: the initial price minus the shipping_cost! If the shipping_cost is greater than the price itself, then the customer just pays the difference (i.e., the absolute value of price - shipping_cost).

A customer has $1,000.00 and wants to know how many of each product she could buy. Show each product name with the quantity column (which calculates the number of products she can buy for $1,000). Get rid of the decimal part. If you get a price of 0.00, show NULL instead.

SELECT
	name,
    FLOOR(1000/NULLIF(ABS(price - shipping_cost),0)) AS quantity
FROM product

name	quantity
Vaatekaappi	3
Spisebord	9
Salongbord	9
Tekanna	142
Haarukka	1960
Handduk	1000
Krus	199
null	94
---------------------------------------------------
Summary
Nicely done! Now it's time to review what we've learned:

The IS NULL operator checks if a column value is NULL.
The IS NOT NULL operator checks if a column value is not NULL.
COALESCE(x, y, ...) returns the first non-NULL argument or replaces a NULL with the value given in the second argument.
The GREATEST() and LEAST() functions return the largest and the smallest value among values in the argument list, respectively.
The NULLIF(x, y) function returns NULL if x = y. Otherwise, it returns x.

------------------------------------------------
Exercise 1
Okay, let's see how much you remember. Exercise 1 is waiting for you!

Exercise
Show all product names and the 3rd market shop's prices (casted to char). If the price is NULL, display 'unknown'. The price column should be named price.
