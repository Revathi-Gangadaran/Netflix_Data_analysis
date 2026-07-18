--Netflix Project
drop table if exists netflix;

Create table netflix
(
	show_id varchar(7),
	type varchar(20),
	title varchar(120),
	director varchar(250),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(20),
	duration varchar(20),
	listed_in varchar(100),
	description varchar(250)
);

select count(*) from netflix;

select distinct(type) from netflix;

--15 business problems & solutions
-- 1.	Count the number of movies & TV shows
select type, count(*) as total_content from netflix group by 1;

-- 2. Find the most common rating for movies and TV shows 
select type, rating from 
	(select type, rating, count(*),
		rank() over(partition by type order by count(*) desc) as ranking
		from netflix group by 1,2) as t1 where ranking = 1;

-- 3. List all movies released in a specific year (e.g: 2021)
select type,title,director,release_year from netflix where type = 'Movie' and release_year = '2021';

-- 4. Find the top 5 countries with the most content on Netflix
select 
	unnest(string_to_array(country, ',')) as new_country, 
	count(show_id)as content from netflix 
group by 1
order by 2 desc
limit 5;

-- 5. Identify the longest movies or TV show duration
select * from netflix
where type = 'Movie' and 
		duration = (select max(duration) from netflix);

-- 6. Find the content added in the last 5 years
select *	
	from netflix 
	where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';

select current_date - interval '5 years'

-- 7. Find all the movies/TV shows by director "Rajiv Chilaka"
select * from netflix where director like '%Rajiv Chilaka%';

select distinct(director) from netflix order by 1 asc;
 ''
-- 8. List all TV shows with more than 3 seasons
 select * from netflix 
 	where type = 'TV Show' and split_part(duration, ' ', 1):: numeric > 3;

-- 9. Count the number of content items in each genre
select unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id)
  from netflix group by 1 order by 2 desc;


-- 10. Find each year and the average numbers of content release
--  in India on netflix. Return top 5 year with highest avg content release

select extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
count(*) as yearly_content,
round(count(*) :: numeric / (select count(*) from netflix where country like '%India%') *100,2) :: numeric 
as avg_content_per_year
from netflix
where country like '%India%'
group by 1

-- 11. List all movies that are documentaries
select * from netflix where 
type = 'Movie' and listed_in ilike '%documentaries'

-- 12. Find all content without director
select * from netflix where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
-- select * from netflix where casts ilike '%Salman Khan%' and
-- 	to_date(date_added, 'Month DD,YYYY') >= current_date - interval '10 years'

select * from netflix where casts ilike '%Salman Khan%' and
	release_year > extract (year from current_date ) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies 
-- produced in India
select count(*), unnest(string_to_array(casts, ',')) as actors from netflix 
where type = 'Movie' and country ilike '%India%' group by 2 order by count(*) desc 
limit 10;

-- 15. Categorise content based on the presence of 'Kill' and 'Violence' keywords. 
select category, count(*) as content_count from 
(select case 
	when description ilike '%kill%' or description ilike '%violence%' or description ilike '%sex%'
	then 'Adult'
	else 'Non-Adult'
	end as category
 from netflix
 ) as categorized_content group by category; 


