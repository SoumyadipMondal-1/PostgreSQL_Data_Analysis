--PostgreSQL Practice Questions:

--Q1. List the first name and last name of all customers.
SELECT first_name, last_name FROM customer;

--Q2. Find all the movies that are currently rented out.
SELECT F.film_id, F.title FROM film F JOIN inventory I ON F.film_id = I.film_id
JOIN rental R ON R.inventory_id = I.inventory_id
WHERE R.return_date IS NULL; 

--Q3. Show the titles of all movies in the 'Action' category.
SELECT F.film_id, title FROM film F JOIN film_category FC ON F.film_id = FC.film_id
JOIN category C ON FC.category_id = C.category_id
WHERE C.name = 'Action';

--Q4. Count the number of films in each category.
SELECT name AS Category, COUNT(*) AS film_count 
FROM category JOIN film_category ON category.category_id = film_category.category_id
GROUP BY Category ORDER BY film_count;

--Q5. What is the total amount spent by each customer?
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name,
SUM(P.amount) AS Total_amount
FROM customer C JOIN payment P ON C.customer_id = P.customer_id 
GROUP BY C.customer_id, Customer_name ORDER BY Total_amount;

--Q6. Find the top 5 customers who spent the most.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name,
SUM(P.amount) AS Total_amount
FROM customer C JOIN payment P ON C.customer_id = P.customer_id 
GROUP BY C.customer_id, Customer_name ORDER BY Total_amount DESC LIMIT(5);

--Q7. Display the rental date and return date for each rental.
SELECT rental_id, rental_date, return_date FROM rental;

--Q8. List the names of staff members and the stores they manage.
SELECT S.staff_id, CONCAT(S.first_name, ' ', S.last_name) AS Staff_name, ST.store_id 
FROM staff S JOIN store ST 
ON S.staff_id = ST.manager_staff_id;

--Q9. Find all customers living in 'California'.
SELECT C.customer_id, CONCAT(C.first_name, ' ', last_name) AS Customer_name, A.district AS Living_in, A.city_id
FROM customer C JOIN address A ON C.address_id = A.address_id
WHERE A.district = 'California';

--Q10. Count how many customers are from each city.
SELECT CT.city_id, CT.city, COUNT(*) AS Total_customer 
FROM city CT JOIN address A
ON CT.city_id = A.city_id
JOIN customer C ON A.address_id = C.address_id
GROUP BY CT.city_id
ORDER BY Total_customer;

--Q11. Find the film(s) with the longest duration.
SELECT film_id, title, length FROM film 
WHERE length = (SELECT MAX(length) FROM film);

--Q12. Which actors appear in the film titled 'Alien Center'?
SELECT A.actor_id, CONCAT(A.first_name, ' ', A.last_name) AS Actor_name, F.title 
FROM actor A JOIN film_actor FA ON A.actor_id = FA.actor_id
JOIN film F ON FA.film_id = F.film_id
WHERE F.title = 'Alien Center';

--Q13. Find the number of rentals made each month.
SELECT TO_CHAR(rental_date,'MM') AS month, COUNT(*) AS Total_rentals 
FROM rental 
GROUP BY month 
ORDER BY month;

--Q14. Show all payments made by customer 'Mary Smith'.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name, P.payment_id, P.amount AS Payments 
FROM payment P JOIN customer C 
ON P.customer_id = C.customer_id
WHERE C.first_name = 'Mary' AND C.last_name = 'Smith';

--Q15. List all films that have never been rented.
SELECT F.film_id, F.title, F.description, R.rental_id FROM film F JOIN inventory I
ON F.film_id = I.film_id
LEFT JOIN rental R ON I.inventory_id = R.inventory_id
WHERE R.rental_id IS NULL;

--Q16. What is the average rental duration per category?
SELECT C.category_id, C.name AS Category, AVG(F.rental_duration) AS Avg_rental_duration 
FROM category C JOIN film_category FC 
ON C.category_id = FC.category_id
JOIN film F ON FC.film_id = F.film_id
GROUP BY Category, C.category_id
ORDER BY C.category_id;

--Q17. Which films were rented more than 50 times?
SELECT F.title, COUNT(*) AS Total_rented 
FROM film F JOIN inventory I
ON F.film_id = I.film_id
JOIN rental R ON I.inventory_id = R.inventory_id
GROUP BY F.title
HAVING COUNT(*) > 50;

--Q18. List all employees hired after the year 2005.
SELECT staff_id, CONCAT(first_name, ' ', last_name) AS Employee_name,
TO_CHAR(last_update, 'YYYY') AS hired_year
FROM staff WHERE last_update > '2005-12-31';
--As the 'hired year' field is not available in the database, we utilized the last_update column from the staff table and 
--labeled it as 'hired Date' in the output.

--Q19. Show the number of rentals processed by each staff member.
SELECT S.staff_id, CONCAT(S.first_name, ' ', S.last_name) AS Staff_name, COUNT(R.rental_id) AS Total_rentals
FROM staff S JOIN rental R
ON S.staff_id = R.staff_id
GROUP BY S.staff_id;

--Q20. Display all customers who have not made any payments.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name 
FROM customer C JOIN payment P
ON C.customer_id = P.payment_id
WHERE P.payment_id IS NULL;

--Q21. What is the most popular film (rented the most)?
SELECT F.film_id, F.title, COUNT(R.rental_id) AS Rental_count
FROM film F JOIN inventory I ON F.film_id = I.film_id
JOIN rental R ON I.inventory_id = R.inventory_id
GROUP BY F.film_id
ORDER BY Rental_count DESC
LIMIT(1);

--Q22. Show all films longer than 2 hours.
SELECT film_id, title, length FROM film 
WHERE length > 120
ORDER BY length;

--Q23. Find all rentals that were returned late.
SELECT R.rental_id, R.rental_date, R.return_date, F.rental_duration*INTERVAL '1 DAY' AS Duration
FROM rental R JOIN inventory I
ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE R.return_date > R.rental_date + F.rental_duration*INTERVAL '1 DAY';

--Q24. List customers and the number of films they rented.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name, COUNT(R.rental_id) AS Film_rented
FROM customer C JOIN rental R
ON C.customer_id = R.customer_id
GROUP BY C.customer_id
ORDER BY Film_rented;

--Q25. Write a query to show top 3 rented film categories.
SELECT C.category_id, C.name AS Film_category, COUNT(R.rental_id) AS Total_rented
FROM rental R JOIN inventory I
ON R.inventory_id = I.inventory_id
JOIN film_category FC
ON I.film_id = FC.film_id
JOIN category C 
ON FC.category_id = C.category_id
GROUP BY C.category_id
ORDER BY Total_rented DESC
LIMIT(3);

--Q26. Create a view that shows all customer names and their payment totals.
CREATE VIEW customer_payment_totals AS
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name, SUM(P.amount) AS Total_payment
FROM customer C JOIN payment P
ON C.customer_id = P.customer_id
GROUP BY C.customer_id
ORDER BY Total_payment;

--Q27. Update a customer's email address given their ID.
UPDATE customer 
SET email = 'newmail@gmail.com'
WHERE customer_id = '1';

--Q28. Insert a new actor into the actor table.
INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Tony', 'Stark', CURRENT_TIMESTAMP);

--Q29. Delete all records from the rentals table where return_date is NULL.
DELETE FROM rental
WHERE rental_date IS NULL;

--Q30. Add a new column 'age' to the customer table.
ALTER TABLE customer 
ADD COLUMN age INTEGER;

--Q31. Create an index on the 'title' column of the film table.
CREATE INDEX index_title 
ON film(title);

--Q32. Find the total revenue generated by each store.
SELECT ST.store_id, SUM(P.amount) AS Total_revenue
FROM store ST JOIN staff SF
ON ST.store_id = SF.store_id
JOIN payment P
ON SF.staff_id = P.staff_id
GROUP BY ST.store_id;

--Q33. What is the city with the highest number of rentals?
SELECT CI.city_id, CI.city,COUNT(R.rental_id) AS Highest_rental
FROM city CI JOIN address A
ON CI.city_id = A.city_id
JOIN customer C
ON A.address_id = C.address_id
JOIN rental R
ON C.customer_id = R.customer_id
GROUP BY CI.city_id
ORDER BY Highest_rental DESC
LIMIT(1);

--Q34. How many films belong to more than one category?
SELECT COUNT(*) AS multi_category_film FROM (
SELECT film_id FROM film_category 
GROUP BY film_id
HAVING COUNT(category_id) > 1); 

--Q35. List the top 10 actors by number of films they appeared in.
SELECT A.actor_id, CONCAT(A.first_name, ' ', A.last_name) AS Actor_name, COUNT(FA.film_id) AS Total_films
FROM actor A JOIN film_actor FA
ON A.actor_id = FA.actor_id
GROUP BY A.actor_id
ORDER BY Total_films DESC
LIMIT(10);

--Q36. Retrieve the email addresses of customers who rented 'Matrix Revolutions'.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name, C.email
FROM customer C JOIN rental R
ON C.customer_id = R.customer_id
JOIN inventory I
ON R.inventory_id = I.inventory_id
JOIN film F
ON I.film_id = F.film_id
WHERE F.title = 'Matrix Revolutions';

--Q37. Create a stored function to return customer payment total given their ID.
CREATE OR REPLACE FUNCTION get_customer_total_payment(Cid INTEGER)
RETURNS NUMERIC AS $$
BEGIN
RETURN (
SELECT SUM(amount) FROM payment WHERE customer_id = Cid);
END;
$$ LANGUAGE plpgsql;

--Q38. Begin a transaction that updates stock and inserts a rental record.
BEGIN;
UPDATE inventory 
SET last_update = CURRENT_TIMESTAMP
WHERE inventory_id = 1;
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, return_date)
VALUES (CURRENT_TIMESTAMP, 1, 1, 1, NULL);
COMMIT;

--Q39. Show the customers who rented films in both 'Action' and 'Comedy' categories.
SELECT C.customer_id, CONCAT(C.first_name, ' ', C.last_name) AS Customer_name
FROM customer C
WHERE EXISTS (
SELECT 1
FROM rental R JOIN inventory I
ON R.inventory_id = I.inventory_id
JOIN film_category FC
ON I.film_id = FC.film_id
JOIN category CA
ON FC.category_id = CA.category_id
WHERE CA.name = 'Action' AND C.customer_id = R.customer_id)
AND EXISTS (
SELECT 1
FROM rental R JOIN inventory I
ON R.inventory_id = I.inventory_id
JOIN film_category FC
ON I.film_id = FC.film_id
JOIN category CA
ON FC.category_id = CA.category_id
WHERE CA.name = 'Comedy' AND C.customer_id = R.customer_id)
ORDER BY C.customer_id;

--Q40. Find actors who have never acted in a film.
SELECT A.actor_id, CONCAT(A.first_name, ' ', A.last_name) AS Actor_name
FROM actor A LEFT JOIN film_actor FA
ON A.actor_id = FA.actor_id
WHERE FA.film_id IS NULL;
