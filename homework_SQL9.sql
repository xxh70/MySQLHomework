-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
from sakila.actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT_WS(" ", `first_name`, `last_name`) AS `Full_Name`
from sakila.actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from sakila.actor
where first_name ='Joe';
-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name
from sakila.actor
where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, last_name, first_name
from sakila.actor
where last_name like '%LI%';
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from sakila.country
where country in ('Afghanistan', 'Bangladesh', 'China');
-- 3a create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table sakila.actor
add column description BLOB;
-- 3b Delete the description column.
alter table sakila.actor
drop description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(actor_id)
from sakila.actor
group by(last_name);
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(actor_id) as 'Total appearence'
from sakila.actor
group by last_name having count(actor_id) >=2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update sakila.actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
-- 4d if the first name of the actor is currently HARPO, change it to GROUCHO.
update sakila.actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name ='WILLIAMS';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table sakila.address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select sakila.staff.first_name, sakila.staff.last_name, sakila.address.address
from sakila.staff
inner join sakila.address on
sakila.staff.address_id = sakila.address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select sakila.staff.staff_id, sakila.staff.first_name, sakila.staff.last_name, sum(sakila.payment.amount), sakila.payment.payment_date like '2005-08%'
from sakila.staff
inner join sakila.payment on
sakila.staff.staff_id = sakila.payment.staff_id
group by sakila.staff.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select sakila.film.title as 'Film Title', count(sakila.film_actor.actor_id) as 'Number of Actors'
from sakila.film
innner join sakila.film_actor on
sakila.film.film_id=sakila.film_actor.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select sakila.film.title, count(sakila.inventory.film_id) as 'copies'
from sakila.film
inner join sakila.inventory on
sakila.film.film_id = sakila.inventory.film_id
WHERE title = 'Hunchback Impossible'
group by title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select sakila.customer.last_name, sakila.customer.first_name,  sum(sakila.payment.amount) 
from sakila.customer
inner join sakila.payment on
sakila.customer.customer_id= sakila.payment.customer_id
group by sakila.customer.last_name;
-- 7a Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from sakila.film 
where title 
like 'K%' or 'Q%'
and language_id in
(select language_id 
from film
where language_id=1);
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from sakila.actor
where actor_id in
(select actor_id 
from sakila.film_actor
where film_id in
(select film_id 
from film
where title ='Alone Trip'));
-- 7c you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select sakila.customer.first_name, sakila.customer.last_name, sakila.customer.email
from sakila.customer
inner join address on
sakila.customer.address_id = sakila.address.address_id
inner join city on
sakila.address.city_id=sakila.city.city_id
inner join country on
sakila.city.country_id=sakila.country.country_id;
-- 7d  Identify all movies categorized as family films.
select title 
from sakila.film
where film_id in
(select film_id 
from film_category
where category_id in
(select category_id 
from category
where name='Family'));
-- 7e. Display the most frequently rented movies in descending order.
select sakila.film.title, count(sakila.rental.rental_id) as 'frenquency'
from sakila.rental
inner join sakila.inventory on
sakila.rental.inventory_id=sakila.inventory.inventory_id
inner join sakila.film on
sakila.inventory.film_id=sakila.film.film_id
group by title
order by frenquency desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select sakila.store.store_id, sum(sakila.payment.amount) as 'total amount'
from sakila.store
inner join inventory on
sakila.store.store_id=sakila.inventory.store_id
inner join rental on
sakila.inventory.inventory_id=sakila.rental.inventory_id
inner join payment on
sakila.rental.rental_id= sakila.payment.rental_id
group by store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
select sakila.store.store_id, sakila.city.city, sakila.country.country
from store
inner join address on
sakila.store.address_id = sakila.address.address_id
inner join city on
sakila.address.city_id = sakila.city.city_id
inner join country on
sakila.city.country_id = sakila.country.country_id;
-- 7h. List the top five genres in gross revenue in descending order.
select sakila.category.name, sum(sakila.payment.amount) as "Gross_Revernue"
from sakila.category 
inner join sakila.film_category on
sakila.category.category_id = sakila.film_category.category_id
inner join sakila.inventory on
sakila.film_category.film_id = sakila.inventory.film_id
inner join sakila.rental on
sakila.inventory.inventory_id = sakila.rental.inventory_id
inner join sakila.payment on
sakila.rental.customer_id = sakila.payment.customer_id
group by sakila.category.name
order by Gross_Revernue DESC;
-- 8a. Use the solution from the problem above to create a view. 
create view Top_Movie as 
select sakila.category.name as 'Movie_Genres', sum(sakila.payment.amount) as 'Gross_Revernue'
from sakila.category 
inner join sakila.film_category on
sakila.category.category_id = sakila.film_category.category_id
inner join sakila.inventory on
sakila.film_category.film_id = sakila.inventory.film_id
inner join sakila.rental on
sakila.inventory.inventory_id = sakila.rental.inventory_id
inner join sakila.payment on
sakila.rental.customer_id = sakila.payment.customer_id
group by sakila.category.name
order by Gross_Revernue DESC;

-- 8b. How would you display the view that you created in 8a?
select * from Top_Movie
limit 5;
-- 8c. Write a query to delete it.
drop view Top_Movie;



