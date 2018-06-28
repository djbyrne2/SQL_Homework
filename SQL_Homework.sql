USE sakila;

show tables;

SELECT first_name, last_name FROM actor;

SELECT concat(UPPER(first_name), " ", UPPER(last_name)) AS Actor_Name
FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE ('%GEN%');

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE ('%LI%')
ORDER BY last_name, first_name;

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor ADD middle_name VARCHAR(30) NULL AFTER first_name;

ALTER TABLE actor
MODIFY COLUMN middle_name BINARY(50);

ALTER TABLE actor
DROP COLUMN middle_name;

SELECT last_name, count(*) as NUM 
FROM actor
GROUP BY last_name;

SELECT last_name, count(*) as NUM 
FROM actor
GROUP BY last_name
HAVING NUM >= 2;

UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'Groucho' 
AND last_name = 'Williams';

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


 

 