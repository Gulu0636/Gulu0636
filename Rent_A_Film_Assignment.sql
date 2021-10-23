#1. We want to run an Email Campaigns for customers of Store 2 (First, Last name,and Email address of customers from Store 2)
Select First_Name, Last_Name, Email from Customer where store_id =2;

#2. List of the movies with a rental rate of 0.99$
Select Title from film where rental_rate =0.99;

#3. Your objective is to show the rental rate and how many movies are in each rental rate categories
Select Rental_Rate, count(title) as 'No. of Movies' from film group by rental_rate;

#4. Which rating do we have the most films in?
select Rating, count(*) as 'No. of Movies' from film group by rating order by 2 desc limit 1;

#5. Which rating is most prevalent in each store?
Select * from
(select *, row_number () over (partition by Store_ID order by MoviesCount desc) as 'RowNo' from 
(select Store_ID,Rating, Count(*) as 'MoviesCount' from film f 
inner join inventory i on f.film_id =i.film_id group by Store_ID, Rating) as XYZ) as ZYX where RowNo = 1;

#6. We want to mail the customers about the upcoming promotion
Select Customer_ID, First_Name, Last_Name, Email from customer;

#7. List of films by Film Name, Category, Language
Select Title as 'Film_Name', C. Name as 'Category', L. Name as 'Language' from film f, film_category fc, language l, category c 
where f.film_id=fc.film_id and f.language_id=l.language_id and c.category_id=fc.category_id
group by Title;

#8. How many times each movie has been rented out?
Select Title as 'Movie', Count(c.customer_id) as 'Rented Out (Count)' from film f, customer c, inventory i, rental r
where f.film_id=i.film_id and i.inventory_id=r.inventory_id and r.customer_id=c.customer_id
group by Title;

#9. What is the Revenue per Movie?
Select Title as 'Movie', Sum(P.amount) as 'Revenue' from film f, inventory i, rental r, payment p
where f.film_id=i.film_id and i.inventory_id=r.inventory_id and r.rental_id=p.rental_id
group by Title;

#10.Most Spending Customer so that we can send him/her rewards or debate points
Select c.Customer_ID, c.First_Name, c.Last_Name, Sum(Amount) from payment p inner join customer c on p.customer_id=c.customer_id
group by Customer_ID, First_Name, Last_Name order by sum(amount) desc limit 1;

#11. What Store has historically brought the most revenue?
Select f.Store_ID,Sum(p.amount) as 'Revenue' from store f, inventory i, rental r, payment p
where f.store_id=i.store_id and i.inventory_id=r.inventory_id and r.rental_id=p.rental_id
group by f.Store_ID;

#12.How many rentals do we have for each month?
Select month(rental_date) as 'Month',
Count(month(rental_date)) as 'No. of Rentals' from rental 
group by month(rental_date);

#13.Rentals per Month (such Jan => How much, etc)
Select monthname(rental_date) as 'Month',
Count(monthname(rental_date)) as 'No. of Rentals' from rental 
group by monthname(rental_date);

#14.Which date the first movie was rented out?
Select min(rental_date) as 'First Movie Rented Date' from rental;

#15.Which date the last movie was rented out?
Select max(rental_date) as 'Last Movie Rented Date' from rental;

#16.For each movie, when was the first time and last time it was rented out?
Select title as 'Movie', min(rental_date) as 'First Rented Date', max(rental_date) as 'Last Rented Date' from rental r, inventory i, film f
where i.inventory_id=r.inventory_id and i.film_id=f.film_id
group by title;

#17.What is the Last Rental Date of every customer?
Select c.customer_id, c.First_Name, max(rental_date) as 'Last Rental Date' from rental r, customer c
where r.customer_id=c.customer_id
group by c.customer_id, c.First_Name;

#18.What is our Revenue Per Month?
Select month(payment_date) as 'Month', sum(amount) as 'Revenue' from payment group by month(payment_date);

#19.How many distinct Renters do we have per month?
Select month(payment_date) as 'Month', count(distinct customer_id) as 'No. of Renters' from payment group by month(payment_date);

#20.Show the Number of Distinct Film Rented Each Month
Select month(rental_date) as 'Month', count(distinct film_id) as 'No.of Distinct film' from rental r, inventory i
where r.inventory_id=i.inventory_id group by month(rental_date);

#21.Number of Rentals in Comedy, Sports, and Family
Select c.Name, count(rental_id) as 'Rentals' from category c, film_category fc, inventory i, rental r
where fc.category_id=c.category_id and fc.film_id=i.film_id and r.inventory_id=i.inventory_id and
c.Name in ('Comedy','Sports','Family') group by c.Name;

#22.Users who have been rented at least 3 times
Select c.Customer_ID, c.First_Name, count(rental_id) as 'Rented Count' from customer c, rental r
where c.customer_id=r.customer_id group by c.Customer_ID, c.First_Name
having count(rental_id)>2 order by count(rental_id) asc;

#23.How much revenue has one single store made over PG13 and R-rated films?
Select s.Store_ID, sum(amount) as 'Revenue' from film f, inventory i, rental r, payment p, store s
where f.film_id=i.film_id and i.store_id=s.store_id
and i.inventory_id=r.inventory_id and p.rental_id=r.rental_id
and rating in ('PG13','R') group by store_id order by store_id;

#24.Active User where active = 1
Select First_Name, Last_Name, Active from customer where active = 1;

#25.Reward Users: who has rented at least 30 times
Select *, 'Rewarded' from (Select c.Customer_ID, c.First_Name, count(Rental_ID) as 'Rented Count' from customer c, rental r
where c.customer_id=r.customer_id group by c.Customer_ID, c.First_Name
having count(Rental_ID)>29 order by count(Rental_ID) asc)t;

#26.Reward Users who are also active
Select First_Name, Last_name, Active, 'Rewarded' from customer where active>0;