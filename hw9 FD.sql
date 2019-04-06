-- use sakita database
USE sakila;

-- 1a.	Display the first and last names of all actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b.	Display the first and last name of each actor in a single column in upper case letters. Name the column 
-- 		Actor Name.
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor;
       
-- 2a.	You need to find the ID number, first name, and last name of an actor, of whom you know only the first 
-- 		name, "Joe." What is one query would you use to obtain this information?
SELECT 
    actor_id 'ID number', first_name 'first name', last_name 'last name'
FROM
    actor
WHERE
    first_name = 'Joe';

-- 2b.	Find all actors whose last name contain the letters GEN:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c.	Find all actors whose last names contain the letters LI. This time, order the rows by last name and 
-- 		first name, in that order:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d.	Using IN, display the country_id and country columns of the following countries: Afghanistan, 
-- 		Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    
-- 3a.	You want to keep a description of each actor. You don't think you will be performing queries on a 
-- 		description, so create a column in the table actor named description and use the data type BLOB (Make 
-- 		sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;  -- null after 'last update'
-- SELECT * FROM actor;

-- 3b.	Very quickly you realize that entering descriptions for each actor is too much effort. Delete the 
-- 		description column.
ALTER TABLE actor
DROP COLUMN description;
-- SELECT * FROM actor;

-- 4a.	List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(*) AS count
FROM
    actor
GROUP BY last_name
ORDER BY count DESC;

-- 4b.	List last names of actors and the number of actors who have that last name, but only for names that are 
-- 	shared by at least two actors
SELECT 
    last_name,
    COUNT(last_name) AS 'number of actors with same last name'
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c.	The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query 
-- 		to fix the record.
-- SELECT * FROM actor WHERE first_name = 'GROUCHO';
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
    
-- 4d.	Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name 
-- 		after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';

-- 5a.	You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a.	Use JOIN to display the first and last names, as well as the address, of each staff member. Use the 
-- 		tables staff and address: 
-- join showing staff members with an address
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        INNER JOIN
    address ON staff.address_id = address.address_id;
-- join showing staff members with an address if available
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        LEFT JOIN
    address ON staff.address_id = address.address_id;

-- 6b.	Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff 
-- 		and payment.
SELECT 
    staff.first_name, staff.last_name, SUM(payment.amount)
FROM
    payment
        INNER JOIN
    staff ON payment.staff_id = staff.staff_id
WHERE
    DATE(payment_date) BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.first_name , staff.last_name;

-- 6c.	List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- 		Use inner join.
SELECT 
    film.title, COUNT(*) AS 'number of actors'
FROM
    film_actor
        INNER JOIN
    film ON film_actor.film_id = film.film_id
GROUP BY film_actor.film_id
ORDER BY film.title;

-- 6d.	How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(*) AS 'copies of the film Hunchback Impossible'
FROM
    inventory
        INNER JOIN
    film ON inventory.film_id = film.film_id
WHERE
    film.title = 'Hunchback Impossible'
GROUP BY inventory.film_id;

-- 6e.	Using the tables payment and customer and the JOIN command, list the total paid by each customer. List 
-- 		the customers alphabetically by last name:
SELECT 
    customer.last_name'last name',
    customer.first_name'first name',
    SUM(payment.amount)'total paid'
FROM
    customer
        INNER JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a.	The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- 		films starting with the letters K and Q have also soared in popularity. Use subqueries to display the 
-- 		titles of movies starting with the letters K and Q whose language is English.
SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id = (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English');

-- 7b.	Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    actor.last_name, actor.first_name
FROM
    film_actor
        INNER JOIN
    actor ON film_actor.actor_id = actor.actor_id
WHERE
    film_actor.film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Alone Trip')
ORDER BY actor.last_name , actor.first_name;

-- 7c.	You want to run an email marketing campaign in Canada, for which you will need the names and email 
-- 		addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
    customer.first_name 'first name',
    customer.last_name 'last name',
    customer.email 'email'
FROM
    customer
        INNER JOIN
    address ON customer.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id
WHERE
    country.country = 'Canada'
ORDER BY customer.last_name , customer.first_name;
-- same outcome through subqueries
SELECT 
    customer.first_name 'first name',
    customer.last_name 'last name',
    customer.email 'email'
FROM
    customer
        INNER JOIN
    address ON customer.address_id = address.address_id
WHERE
    address.city_id IN (SELECT 
            city_id
        FROM
            city
        WHERE
            city.country_id = (SELECT 
                    country_id
                FROM
                    country
                WHERE
                    country = 'Canada'))
ORDER BY customer.last_name , customer.first_name;

-- 7d.	Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- 		Identify all movies categorized as family films.
SELECT 
    film.title
FROM
    film
        INNER JOIN
    film_category ON film.film_id = film_category.film_id
WHERE
    film_category.category_id = (SELECT 
            category_id
        FROM
            category
        WHERE
            name = 'Family')
ORDER BY film.title;

-- 7e.	Display the most frequently rented movies in descending order.
SELECT 
    film.title, COUNT(rental_id) AS 'most frequently rented movies'
FROM
    rental
        INNER JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        INNER JOIN
    film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;

-- 7f.	Write a query to display how much business, in dollars, each store brought in.
SELECT 
    store.store_id 'store ID',
    SUM(payment.amount) 'business, in dollars'
FROM
    store
        INNER JOIN
    staff ON store.store_id = staff.store_id
        INNER JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 7g.	Write a query to display for each store its store ID, city, and country.
SELECT 
    store.store_id 'store ID',
    city.city 'city',
    country.country 'country'
FROM
    store
        INNER JOIN
    address ON store.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id;

-- 7h.	List the top five genres in gross revenue in descending order. (Hint: you may need to use the following 
-- 		tables: category, film_category, inventory, payment, and rental.)
-- > to do: sort does not work
SELECT 
    category.name 'top five genres',
    SUM(payment.amount) 'gross revenue'
FROM
    category
        INNER JOIN
    film_category ON category.category_id = film_category.category_id
        INNER JOIN
    inventory ON film_category.film_id = inventory.film_id
        INNER JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        INNER JOIN
    payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC
LIMIT 5;

-- 8a.	In your new role as an executive, you would like to have an easy way of viewing the Top five genres by 
-- 		gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you 
-- 		can substitute another query to create a view.
-- > to do: update after finalizing 7h
CREATE VIEW 8a_v AS
    SELECT 
        category.name 'top five genres',
        SUM(payment.amount) 'gross revenue'
    FROM
        category
            INNER JOIN
        film_category ON category.category_id = film_category.category_id
            INNER JOIN
        inventory ON film_category.film_id = inventory.film_id
            INNER JOIN
        rental ON inventory.inventory_id = rental.inventory_id
            INNER JOIN
        payment ON rental.rental_id = payment.rental_id
    GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC
    LIMIT 5;

-- 8b.	How would you display the view that you created in 8a?
SELECT 
    *
FROM
    8a_v;

-- 8c.	You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS 
	8a_v;