USE sakila;

show tables;

#1a

SELECT first_name, last_name FROM actor;

#1b

SELECT concat(UPPER(first_name), " ", UPPER(last_name)) AS Actor_Name
FROM actor;

#2a

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

#2b

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE ('%GEN%');

#2c

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE ('%LI%')
ORDER BY last_name, first_name;

#2d

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a

ALTER TABLE actor ADD middle_name VARCHAR(30) NULL AFTER first_name;

#3b

ALTER TABLE actor
MODIFY COLUMN middle_name BINARY(50);

#3c

ALTER TABLE actor
DROP COLUMN middle_name;

#4a

SELECT last_name, count(*) as NUM 
FROM actor
GROUP BY last_name;

#4b

SELECT last_name, count(*) as NUM 
FROM actor
GROUP BY last_name
HAVING NUM >= 2;

#4c

UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'Groucho' 
AND last_name = 'Williams';

#4d

UPDATE actor
SET first_name = IF(first_name = 'HARPO' , 'GROUCHO','MUCHO GORUCHO')
WHERE actor_id = 172;

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.first_name, staff.last_name, address.address, address.address2
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id;

# Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment

USE sakila;

SELECT staff.staff_id, staff.first_name, staff.last_name, payment.amount,
SUM(payment.amount) AS Total_Amount
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment_date BETWEEN '2005-08-01' and '2005-08-31';


#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT film.title, film.film_id, COUNT(film_actor.actor_id) as Number_Actors
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id, film.title
ORDER by film.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film.title, film.film_id, COUNT(inventory.inventory_id)
FROM film
INNER JOIN Inventory
ON film.film_id = inventory.film_id
AND film.title = 'Hunchback Impossible'
GROUP BY film.film_id, film.title
ORDER BY film.title;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, customer.customer_id, SUM(payment.amount) AS Total_Payment_Amount
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id, customer.last_name
ORDER BY customer.last_name ASC; 

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT film.film_id , film.title
FROM film
INNER JOIN language 
ON film.language_id = language.language_id
AND language.name = 'English'
AND (film.title LIKE 'k%' or film.title LIKE 'q%');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id IN
		(SELECT film.film_id
		FROM film 
        WHERE film.title = 'Alone Trip');

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information

SELECT customer.first_name, customer.last_name, customer.email, customer.address_id
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
and country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT film.film_id, film.title, film_category.category_id, category.name
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON category.category_id = film_category.category_id
AND category.name = 'Family';

#7e. Display the most frequently rented movies in descending order.

SELECT film.film_id , film.title, COUNT(rental.inventory_id) as Number_Rentals
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film 
ON inventory.film_id = film.film_id
GROUP BY film.film_id, film.title
ORDER BY COUNT(rental.inventory_id) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, address.address, SUM(payment.amount)
FROM store
INNER JOIN customer
ON store.store_id = customer.store_id
INNER JOIN payment
ON customer.customer_id = payment.customer_id
INNER JOIN address
ON store.address_id = address.address_id
GROUP BY store.store_id, address.address
ORDER BY store.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address 
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name, SUM(payment.amount) AS Gross_Revenue
FROM payment 
INNER JOIN rental
ON payment.rental_id = rental.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category
ON inventory.film_id = film_category.film_id
INNER JOIN category 
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_Genre_Revenue AS
SELECT category.name, SUM(payment.amount) AS Gross_Revenue
FROM payment 
INNER JOIN rental
ON payment.rental_id = rental.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category
ON inventory.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8b. How would you display the view that you created in 8a?

SELECT * FROM Top_Genre_Revenue;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_Genre_Revenue;

 

 