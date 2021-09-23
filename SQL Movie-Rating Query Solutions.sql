use rating;
-- 1. Find the titles of all movies directed by Steven Spielberg.
select title
from Movie
where director = 'Steven Spielberg'

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select distinct year from movie,  rating 
where movie.mID = rating.mID
and stars in (4,5)
order by year;

-- 3. Find the titles of all movies that have no ratings.

select title from movie  
where mID not in (select mID from rating);

/*Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.*/
select name
from reviewer, rating
where reviewer.rID = Rating.rID
and ratingDate is null;

/*5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data,
 first by reviewer name, then by movie title,
 and lastly by number of stars. */
 
select r3.name as reviewer_name, r1.title as movie_title, r2.stars as stars, r2.ratingDate
from Rating as r2
join Movie as r1
on r2.mID = r1.mID
join Reviewer as r3
on r2.rID = r3.rID
order by r3.Name, r1.title, r2.stars

-- 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
 
select name, title
from movie
inner join rating r1 using (mID)
inner join rating r2 using (mID) 
inner join reviewer using (rID)
where r1.rID = r2.rID
and r1.ratingDate < r2.ratingDate
and r1.stars < r2.stars;

-- . For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from movie
inner join rating
where movie.mID = rating.mID
group by title
having count(stars) >=1;

-- 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select title, max(stars)-min(stars) as rating_spread
  from movie
  inner join rating
  where movie.mId = rating.mID
  group by title
  order by rating_spread desc, title;
  
/*9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)*/
select avg(before1980.avg) - avg(after1980.avg)
from (select avg(stars) as avg from rating inner join movie where rating.mID = movie.mID
	  and year < 1980
	 group by movie.mID) as before1980, 
	 (select avg(stars) as avg from rating inner join movie where rating.mID = movie.mID
	  and year > 1980
	  group by movie.mID) as after1980;
  