/*Display the first and last names of all actors from the table actor.*/

SELECT first_name, last_name
FROM actor;

/*Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.*/

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;

/*You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/

SELECT *
FROM actor
WHERE first_name LIKE 'Joe';

SELECT *
FROM actor
WHERE LOWER(first_name) = LOWER('Joe');

/*Find all actors whose last name contain the letters GEN*/

SELECT *
FROM actor
WHERE UPPER(last_name) LIKE '%GEN';

/*Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order*/

SELECT *
FROM actor
WHERE UPPER(last_name) LIKE '%LI%'
ORDER BY last_name, first_name;

/*Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China*/

SELECT  country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China'); 

/* You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).*/

ALTER TABLE actor
ADD COLUMN description BLOB;

/*Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column*/

ALTER TABLE actor
DROP COLUMN description;

/*List the last names of actors, as well as how many actors have that last name.*/

SELECT last_name, COUNT(*) actor_count
FROM actor
GROUP BY last_name
ORDER BY actor_count DESC, last_name;

/*List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/

SELECT last_name, COUNT(*) AS actor_count
FROM actor
GROUP BY last_name
HAVING actor_count > 1
ORDER BY actor_count DESC, last_name;

/*The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.*/

UPDATE actor
SET first_name = LOWER('HARPO')
WHERE first_name = LOWER('GOUCHO')
AND last_name = LOWER('WILLIAMS');

/*Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/

UPDATE actor
SET first_name = GOUCHO
WHERE first_name = HARPO
AND last_name = WILLIAMS;

/*You cannot locate the schema of the address table. Which query would you use to re-create it?*/

SHOW CREATE TABLE address;
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8


/*Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address*/

SELECT  S.first_name,
        S.last_name,
        AD.address,
        AD.district,
        AD.postal_code,
        AD.city_id
FROM staff AS S
INNER JOIN address AS AD ON AD.address_id = S.address_id; 

/* Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment*/

SELECT ST.first_name, ST.last_name, SUM(P.amount)
FROM payment AS P 
INNER JOIN staff AS ST ON ST.staff_id = P.staff_id
WHERE MONTH(P.payment_date) = 8
AND YEAR(P.payment_date) = 2005
GROUP BY ST.first_name, ST.last_name; 

/*List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.*/

SELECT 
FROM film AS f
INNER JOIN film_actor AS fa ON 
