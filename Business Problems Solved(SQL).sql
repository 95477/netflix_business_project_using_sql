--Business Problems solved

--1. Count the number of Movies vs TV Shows
SELECT 
	type,count(*)
FROM
	netflix
GROUP BY 
	type;
	

--2. Find the most common rating for movies and TV shows
select * from netflix;--Take a look on the table 

select 
	type,rating
from	
(SELECT
	type,rating,COUNT(*) as most_common_rating,
	RANK() OVER(partition by type order by COUNT(*) desc) as ranking
FROM
 	netflix
GROUP BY
	1,2)
	as t1
where ranking = 1;



--3.List all movies released in a specific year (e.g., 2020)
select title as movie_released_in_2020
from netflix
where type = 'Movie' and release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
select * from netflix;

select UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,count(show_id)
from netflix
group by new_country
order by 2 desc
limit 5;


--5. Identify the longest movie
select * from
netflix where type = 'Movie'
and duration = (select max(duration) from netflix);

--6. Find content added in the last 5 years
select * from netflix;

select * from netflix
where
   TO_DATE(date_added,'Month DD,YYYY') >=current_date-interval '5 years';


--7.Find all the movies/TV shows by director 'Rajiv Chilaka'.
select * from netflix
where director LIKE '%Rajiv Chilaka%';

--8.List all TV shows with more than 5 seasons
select *
from netflix
	where type = 'TV Show'
	AND SPLIT_PART(duration,' ',1)::numeric > 5; -- Here "::" is used to cast varchar to numeric.

--9.Count the number of content items in each genre
select UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS new_genre,count(show_id) as count_of_genre
from netflix
group by new_genre
order by count(show_id) desc;

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release.
select * from netflix;

select 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) as year_added,
	count(*) as yearly_content,
	ROUND(count(*)/(select count(*) from netflix where country = 'India')::numeric*100,2) as avg_content 
from netflix
where country = 'India'
group by year_added;

--11. List all movies that are documentaries
select * from netflix
where listed_in ILIKE '%documentaries' and type = 'Movie';

--12.Find all content without a director
select * from netflix
where director is null;

--13.Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where casts ILIKE '%Salman Khan%'
and release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;

--14.Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS individual_cast,
	count(*) as total_content
from netflix
where country ILIKE '%India%'
Group by individual_cast
order by count(*) desc
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

with cte
as(
	select *,
	CASE WHEN
	description ILIKE '%kill%'
	OR
	description ILIKE '%violence%'
	THEN 'Bad Content'
	ELSE 'Good Content'
	END Category
from netflix
	
)
select category,count(show_id)
from cte group by category;





