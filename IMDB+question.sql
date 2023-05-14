USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

-- with information schema we can get all details related to all tables from a database.


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_NULL,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_NULL,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DatePublished_NULL,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Duration_NULL,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Country_NULL,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS WorldWide_NULL,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_NULL,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULL
FROM movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year(date_published) as published_year, count(title) as number_of_movies from movie 
group by year(date_published) 
order by year(date_published);

select month(date_published) as published_month, count(title) as number_of_movies from movie 
group by month(date_published) 
order by month(date_published) ;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
  
  
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select year(date_published), count(title) 
from movie 
where year(date_published)=2019 and (country like '%USA%' or country like '%India%');

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/




-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */




-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre, count(movie_id) from genre 
group by genre 
order by count(movie_id) DESC limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/




-- Q7. How many movies belong to only one genre?
-- Type your code below:
with total_count as
(select movie_id, count(genre) from genre group by movie_id having count(genre)=1)
select count(movie_id) from total_count;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 





Now, let's find out the possible duration of RSVP Movies’ next project.*/
-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre.genre, round(avg(movie.duration)) as average_duration from genre 
join movie on genre.movie_id = movie.id group by genre.genre order by round(avg(movie.duration)) desc;

-- Action genre has the highest average duration which is 113 mins.



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with ct_movieRank as
(
select genre, count(movie_id) as movie_count, 
rank() over(order by count(movie_id) desc) as movie_rank 
from genre 
group by genre)
select * from ct_movieRank where genre='thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies



 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, 
min(total_votes) as min_total_votes, max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating, max(median_rating) as max_median_ratian 
from ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 



Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with ct_movieRank as
(
select movie.title, ratings.avg_rating, dense_rank() over (order by ratings.avg_rating desc) movie_rank from ratings 
join movie 
on movie.id = ratings.movie_id)
select * from ct_movieRank where movie_rank <= 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
Fan movie comes in 4th rank and in first rank it is Kriket.




So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
 
 select median_rating, count(movie_id) as movie_count from ratings
 group by median_rating order by count(movie_id);

/* Movies with a median rating of 7 is highest in number.





 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
select movie.production_company, count(ratings.movie_id) as movie_count, 
dense_rank() over (order by count(ratings.movie_id) desc) as prod_company_rank
from movie 
join ratings 
on movie.id = ratings.movie_id 
where ratings.avg_rating > 8.0  and movie.production_company is not null group by movie.production_company limit 5;
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both




-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre.genre, count(movie.id) as movie_count
from genre 
join movie 
on genre.movie_id = movie.id 
join ratings
on movie.id = ratings.movie_id
where year(date_published) = 2017 and 
	  month(date_published) = 3 and 
      country like '%USA%' and 
      total_votes > 1000
group by genre.genre
order by count(movie.id) desc;

-- highes movie released in Drama genre on the march 2017 in the USA had more than 1,000 votes.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select movie.title, ratings.avg_rating, genre.genre
from ratings 
join movie 
on movie.id = ratings.movie_id 
join genre 
on genre.movie_id = movie.id
where movie.title like 'The%' and
      ratings.avg_rating > 8.0
order by ratings.avg_rating desc;

-- Highest rated movie is from genre drama which is rated with 9.5 named The Brighton Miracle.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(movie.id) as movie_count
from movie 
join ratings 
on movie.id = ratings.movie_id 
where movie.date_published between '2018-04-01' and '2019-04-01'
	  and ratings.median_rating = 8;

-- 361 movies released in total from 1st April 2018 to 1st April 2019 which are having median rating of 8.



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select movie.country, sum(ratings.total_votes) as Total_Votes from movie 
join ratings 
on movie.id = ratings.movie_id 
where movie.country = 'Germany' 
	or 
    movie.country = 'Italy'
group by movie.country;

-- Answer is Yes German movies get more votes than Italian movie.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
Select 
	sum(case when name is null then 1 else 0 end) as name_nulls,
    sum(case when height is null then 1 else 0 end) as height_nulls,
    sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_null
from names;

/* There are no Null value in the column 'name'.




The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_genre
as
(
select
genre.genre,
count(genre.movie_id) as movie_count
from genre
join ratings
on genre.movie_id = ratings.movie_id
where avg_rating>8
group by genre
order by movie_count desc
limit 3
),
top_director
as
(
select
names.name as director_name,
count(director_mapping.movie_id) as movie_count,
rank() over(order by COUNT(director_mapping.movie_id) desc) director_rank
from names 
join director_mapping 
on names.id = director_mapping.name_id
join ratings 
on ratings.movie_id = director_mapping.movie_id
join genre
on genre.movie_id = director_mapping.movie_id,
top_genre
where ratings.avg_rating > 8 and genre.genre in (top_genre.genre)
group by names.name
order by movie_count desc
)
select director_name,
movie_count
from top_director
where director_rank <= 3
limit 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/




-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select names.name as actor_name, count(ratings.movie_id) as movie_count from ratings 
join role_mapping
on ratings.movie_id = role_mapping.movie_id
join names 
on names.id=role_mapping.name_id
where role_mapping.category='actor' 
      and ratings.median_rating >= 8 
group by names.name 
order by count(ratings.movie_id) desc limit 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
-- Mohanlal comes on top 2 movies with movie count 5.




RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select movie.production_company, sum(ratings.total_votes) as vote_count, 
dense_rank() over (order by sum(ratings.total_votes) desc) as prod_comp_rank
from movie
join ratings 
on movie.id = ratings.movie_id group by movie.production_company limit 3;

/*Yes Marvel Studios rules the movie world.
1. Marvel Studios
2. Twentieth Century Fox
3. Warner Bros.
So, these are the top three production houses based on the number of votes received by the movies they have produced.




Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/





-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
names.name AS actor_name,
ratings.total_votes as total_votes,
COUNT(ratings.movie_id) as movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating, rank() over(order by ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) desc) as actor_rank
from names 
join role_mapping 
on names.id = role_mapping.name_id
join ratings 
on role_mapping.movie_id = ratings.movie_id
join movie 
on movie.id = ratings.movie_id
where role_mapping.category="actor" and movie.country="India"
group by names.name
having COUNT(ratings.movie_id) >= 5;

-- Top actor is Vijay Sethupathi





-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
names.name as actor_name,
ratings.total_votes as total_votes,
COUNT(ratings.movie_id) as movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating, rank() over(order by ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) desc) as actor_rank
from names 
join role_mapping 
on names.id = role_mapping.name_id
join ratings 
on role_mapping.movie_id = ratings.movie_id
join movie 
on movie.id = ratings.movie_id
where role_mapping.category="actress" and movie.languages like '%hindi%' and movie.country='india'
group by names.name
having COUNT(ratings.movie_id) >= 3;

/* Taapsee Pannu tops with average rating 7.74. 





Now let us divide all the thriller movies in the following categories and find out their numbers.*/
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select movie.title, ratings.avg_rating,
case
when avg_rating > 8 then 'Superhit movies'
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating between 5 and 7 then 'One-time-watch movies'
else 'Flop movies'
end as rating_category
from movie
join ratings 
on movie.id = ratings.movie_id
join genre
on movie.id = genre.movie_id
where genre = 'thriller'
order by ratings.avg_rating desc;
-- the highest rating from superhit movies is 9.5




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre.genre, round(avg(movie.duration),2) as avg_duration,
sum(round(avg(movie.duration),2)) over(order by genre.genre) as running_total_duration,
avg(avg(movie.duration)) over(order by genre.genre) as moving_avg_duration
from movie
join ratings
on movie.id = ratings.movie_id
join genre
on movie.id = genre.movie_id
group by genre.genre;

-- Round is good to have and not a must have; Same thing applies to sorting



-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_3_genre
as
( 
select genre, count(movie_id)
from genre
group by genre
order by count(movie_id) desc
limit 3
),

top_5_movie
as
(
select genre.genre, movie.year, movie.title as movie_name, movie.worlwide_gross_income as worldwide_gross_income, 
dense_rank() over(partition by movie.year order by movie.worlwide_gross_income desc) as movie_rank
from movie
join genre 
on movie.id = genre.movie_id
where genre in (select genre from top_3_genre)
)

select * from top_5_movie where movie_rank<=5 order by movie_rank;

/* top 3 movies with rank 1 are 
1. Shatamanam Bhavati
2. The Villain
3. Prescience */



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select movie.production_company, count(movie.id) as movie_count, 
dense_rank() over(order by count(movie.id) desc) as prod_comp_rank
from movie
join ratings
on movie.id = ratings.movie_id
where ratings.median_rating >=8
	and
    movie.languages like '%,%'
    and
    movie.production_company is not null
group by movie.production_company limit 2;

-- top 2 cinemas are Star Cinema and Twentieth Century Fox

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language



-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select names.name as actress_name, ratings.total_votes, count(role_mapping.movie_id) as movie_count,
ratings.avg_rating AS actress_avg_rating, dense_rank() over(order by count(ratings.movie_id) desc) as actress_rank
from movie
join ratings
on movie.id = ratings.movie_id
join genre
on movie.id = genre.movie_id
join role_mapping
on movie.id = role_mapping.movie_id
join names
on role_mapping.name_id = names.id
where ratings.avg_rating > 8
	and
    genre = 'drama'
    and 
    category = 'actress'
group by names.name limit 3;

/* top 3 actresses are 
1. Parvathy Thiruvothu
2. Susan Brown
3. Amanda Lawrence
they all have done best movies in drama genre. */ 




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with date_diff as
(
select director_mapping.name_id,
names.name,
director_mapping.movie_id,
movie.duration,
ratings.avg_rating,
ratings.total_votes,
movie.date_published,
Lead(date_published,1) over(partition by director_mapping.name_id order by date_published,movie_id ) as next_date_published
from director_mapping
join names on names.id = director_mapping.name_id
join movie on movie.id = director_mapping.movie_id
INNER JOIN ratings on ratings.movie_id = movie.id ),
top_director as
(
select *,
Datediff(next_date_published, date_published) as date_difference
from date_diff
)
select name_id as director_id,
name as director_name,
COUNT(movie_id) as number_of_movies,
round(avg(date_difference),2) as avg_inter_movie_days,
round(avg(avg_rating),2) as avg_rating,
sum(total_votes) as total_votes,
min(avg_rating) as min_rating,
max(avg_rating) as max_rating,
sum(duration) as total_duration
from top_director
group by director_id
order by COUNT(movie_id) desc
limit 9;
