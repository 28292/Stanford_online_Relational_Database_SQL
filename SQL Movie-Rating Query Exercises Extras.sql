use rating;
-- Q1. Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from reviewer inner join rating on reviewer.rid = rating.rid
inner join movie on rating.mID = movie.mID
where title = 'Gone with the Wind'
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select name, title, stars
from reviewer inner join rating on reviewer.rID = rating.rID
inner join movie on rating.mId = movie.mID
and reviewer.name = movie.director
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Q3. Return all reviewer names and movie names together in a single list, alphabetized.
 (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
select name
from reviewer
union
select title 
from movie
order by name;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q4. Find the titles of all movies not reviewed by Chris Jackson.
select distinct title
from movie where mId not in
			(select mID from rating inner join reviewer on rating.rID = reviewer.rID 
			 and name = 'Chris Jackson');
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------      
       
/* Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers.
 Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
SELECT DISTINCT reviewer1.name, reviewer2.name
from rating r1, rating r2, reviewer reviewer1, reviewer reviewer2
where r1.mID = r2.mID
and r1.rID = reviewer1.rID
and r2.rID = reviewer2.rID
and reviewer1.name < reviewer2.name
order by reviewer1.name, reviewer2.name

 -- ----------------------------------------------------------------------------------------------------------------------------------------------------------------    
-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 

select name, title, stars
from movie join rating on movie.mID = rating.mID
			join reviewer on rating.rID = reviewer.rID
where stars = (select min(stars) from rating);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as avr_rating
from movie join rating on movie.mID = rating.mID
group by title
order by avr_rating desc, title;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
select name 
from reviewer join rating
on reviewer.rid = rating.rid
group by name
having count(rating.rID)>=3

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.
 (As an extra challenge, try writing the query both with and without COUNT.) */
select title, director
from movie
where director in
			(select director from movie 
			group by director
			having count(director)>1)
group by title
order by director

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 /* Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.
 (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */

select title, avg(stars)
from movie join rating on movie.mID = rating.mID
group by title
order by avg(stars) desc limit 1;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
 (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */ 

select title, avg(stars)
from movie join rating on movie.mID = rating.mID
group by title
order by avg(stars) asc limit 2;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Q12: For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
and the value of that rating. Ignore movies whose director is NULL. */

select director, title, max(stars)
from movie join rating on rating.mId = movie.mID
where director is not null
group by director
order by max(stars) desc;
