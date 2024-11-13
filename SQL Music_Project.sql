Use Music_Project

1. Who is the senior most employee based on job title?

Select Top 1 first_name, last_name 
FROM employee
ORDER BY levels DESC

2. Which countries have the most Invoices?

Select TOP 1 billing_country as Country, COUNT(*) as No_of_Bills
FROM invoice
GROUP BY billing_country
ORDER BY Country DESC

3. What are top 3 values of total invoice?

Select TOP 3 ROUND(Total,2) as Total
FROM Invoice
ORDER BY Total DESC

4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

Select Top 1 billing_city as City, ROUND(SUM(total),2) as Total
From Invoice
GROUP BY billing_city
ORDER BY Total DESC

5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.

Select Top 1 C.first_name, C.last_name, C.customer_id, ROUND(SUM(I.total),2) as Total
FROM Customer as C
JOIN Invoice as I
ON C.customer_id = I.customer_id
GROUP BY C.first_name, C.last_name, C.customer_id
ORDER BY Total DESC

6. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A

WITH CTE AS
(Select customer.email, customer.first_name, customer.last_name, genre.name
FROM customer JOIN invoice
ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock')

Select email, first_name, last_name, name
FROM CTE
ORDER BY email 

7. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands.

Select * FROM track
Select * FROM album
Select * FROM artist

Select TOP 10 artist.name, count(artist.artist_id) as Number_of_songs
FROM artist JOIN album
ON artist.artist_id = album.artist_id
JOIN track ON track.album_id = album.album_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.name
ORDER BY Number_of_songs DESC

8. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

Select name, Milliseconds
FROM track 
WHERE milliseconds > (
Select AVG(milliseconds) as Average_Length
FROM track)
ORDER BY Milliseconds DESC

9. Find how much amount spent by each customer on artists?
Write a query to return customer name, artist name and total spent.

Select * FROM invoice_line

Select customer.first_name, customer.last_name, artist.name as Artist_Name, SUM(invoice_line.unit_price * invoice_line.quantity) as Total_Spent
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY customer.first_name, customer.last_name, artist.name
ORDER BY SUM(invoice_line.unit_price * invoice_line.quantity) DESC

10. We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top Genre.
For countries where the maximum number of purchases is shared return all genres.

With CTE AS
(
Select COUNT(invoice_line.quantity) as Purchases, customer.country, genre.name, genre.genre_id,
Row_Number() OVER(Partition BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) as RowNo
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY customer.country, genre.name, genre.genre_id
)

Select Purchases, Country, Name
FROM CTE
Where RowNo =1 
ORDER BY Purchases DESC

11. Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent.
For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH CTE AS(
Select customer.first_name, customer.last_name, invoice.billing_country as Country, invoice.customer_id, ROUND(SUM(invoice.total),2) as Total,
Row_Number() OVER (Partition BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) as RN
FROM customer 
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.first_name, customer.last_name, invoice.billing_country, invoice.customer_id)

Select customer_id, first_name, last_name, country, Total
FROM CTE
WHERE RN = 1



