use social;

-- Q1. Find the names of all students who are friends with someone named Gabriel.
select h1.name
from highschooler h1
	join friend f on h1.id = f.id1
	join highschooler h2 on h2.id = f.id2
where h2.name= 'Gabriel';

-- --------------------------------------------------------------------------------------------------------------
-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
select * 

select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1
	join likes l on h1.id = l.id1
	join highschooler h2 on h2.id = l.id2
where h1.grade - h2.grade >= 2

-- --------------------------------------------------------------------------------------------------------------

-- Q3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

select distinct h1.name, h1.grade, h2.name, h2.grade
from highschooler h1
join likes l1, likes l2, highschooler h2
where l1.id1 = l2.id2
and l2.id1 = l1.id2
and h1.id = l1.id1
and h2.id = l2.id1
and h1.name < h2.name

-- --------------------------------------------------------------------------------------------------------------

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

select distinct name, grade
from highschooler
where Id not in (select Id1 from likes union select Id2 from likes)
order by  grade, name

-- --------------------------------------------------------------------------------------------------------------
-- Q5: For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select distinct h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l1, likes l2
where h1.id = l1.id1
and h2.id = l2.id2
and l1.id1 = l2.id1
and l2.id2 not in (select id1 from likes)
and h1.name <> h2.name


-- --------------------------------------------------------------------------------------------------------------

-- Q6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

select name, grade from highschooler h
where id not in (select id1 from highschooler h1, highschooler h2,friend f
				 where h1.id = f.id1
				 and h2.id = f.id2=
				 and h1.grade <> h2.grade)
				order by grade,name
                
-- --------------------------------------------------------------------------------------------------------------		
-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Likes, Highschooler H2, Highschooler H3,Friend F1,Friend F2
WHERE H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and
  H2.ID not in (select ID2 from Friend where ID1 = H1.ID) and
  H1.ID = F1.ID1 and F1.ID2 = H3.ID and
  H3.ID = F2.ID1 and F2.ID2 = H2.ID
  
-- --------------------------------------------------------------------------------------------------------------		
-- Q8. Find the difference between the number of students in the school and the number of different first names.
select distinct h.name, h.grade
from highschooler h
inner join likes l on h.ID = l.ID2 
where h.ID in (select ID2 from likes group by ID2 having count(Id2) > 1);


