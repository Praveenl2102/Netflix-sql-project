---Netflix project---
Create database Movies;
Drop table if exists Movies;
CREATE TABLE Movies(
  show_id VARCHAR(6),
  type	VARCHAR(10),
  title	VARCHAR(50),
  director VARCHAR(50),	
  casts	VARCHAR(50),
  country  VARCHAR(50),
  date_added VARCHAR(50),
  release_year	INT,
  rating	VARCHAR(10),
  duration	VARCHAR(15),
  listed_in VARCHAR(25),
  description VARCHAR(50)
  );
 select * from Movies;
 select * from netflix_titles;
 Select count(*) as total_comntent from netflix_titles;
 Select distinct type from netflix_titles;
 --- 15 Business Problems
--- 1. Count the number of Movies vs and TV shows
Select type,Count(*) as total_content from netflix_titles group by type
--- 2. Find the most common rating for movies and TV shows
select type,rating from(
select type,rating,count(*)as content_count,rank() over(partition by type order by count(*)desc) as ranking
from netflix_titles group by type,rating )
AS t1
where ranking = 1
---order by 1, 3 desc;
---3.List all movies released in a specific year(e.g., 2020)
--filter 2019
-- moies
select * from netflix_titles where type ='movie' and release_year=2019
---4. Find the top  5 countries with the most content on Netflix
 select top 5
      ltrim(rtrim(value)) as new_country,
	  count(show_id) as total_content
	  from netflix_titles
	  cross apply string_split(country, ',')
	  group by ltrim(rtrim(value))
	  order by total_content desc;
---5 Identify the longest movie?
     select * from netflix_titles where type = 'Movie' and duration = (select max(duration) from netflix_titles)
---6. Find the content added in the last 10 years
      select * from netflix_titles where
	  try_cast(date_added as date) >= DATEADD(year, -10, getdate());
---7. Find all the movies/TV shows by director 'Rajiv Chilak'!
      select * from netflix_titles where director like '%Rajiv Chilaka%';
---8.List all TV shows with more than 5 seasons
    select * from netflix_titles
	where
	type = 'TV show'
	and
	try_cast(left(duration, CHARINDEX(' ', duration + ' ' ) - 1)as int)> 5;
---9. count thr number of content items in each genre
   select
   trim(value) as genre,
   count(show_id) as total_content
   from netflix_titles
   cross apply string_split(listed_in, ',')
   where type = 'TV show'
   group by trim(value)
   order by 
   total_content desc;
---10. Find each year and the average numbers of content release by India on netflix. 
---return top 5 years with highest avg content release !
   select
   year(cast(date_added as date)) as release_year,
   count(*) as yearly_content,
   ROUND(
   count(*)* 1.0/(select count(distinct year(cast(date_added as date))) from netflix_titles where country = 'India'),2) as avg_content_per_year
   from netflix_titles
   where country = 'India'
   and date_added is not null
   group by 
   year(cast(date_added as date))
   order by
   avg_content_per_year desc
   offset 0 rows fetch next 5 rows only;
---11.list all the movies that are documentaries
   select * from netflix_titles 
   where
   listed_in like '%documentaries%'
---12.Find all content without a director.
   select * from netflix_titles where director is null
---13. Find how many movies actor 'Salman Khan' appeared in last 15 year!
   select * from netflix_titles where cast like '%Salman Khan%'
   and
   release_year >= year(getdate()) - 15;
---14 Find the top 10 actors who have appeared in the highest number of movies produced in India.
   select top 10
   trim(value) as actor,
   count(*) as total_content
   from
   netflix_titles
   cross apply
   string_split(cast, ',')
   where
   lower(country) like '%india%'
   group by
   trim(value)
   order by
   total_content desc;
---15. Categorize Content Based on the Presence of 'Kill' and 'Violence' in the
---description field.Label content containing these keywords as 'bad' and all other content as 'good'.
---count how many items fail into each category.
   select
       category,
	   count(*) as content_count
	   from(
	      select
	          case
	              when description like '%kill%' or description like '%violence%' then 'Bad'
			else 'Good'
		end as category
		from netflix_titles
		) as categorized_content
		group by category;
