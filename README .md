# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/Praveenl2102/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [netflix_titles](https://www.kaggle.com/code/ankish28/netflix-data-analysis/input?select=netflix_titles.csv)

## Schema

```sql
DROP TABLE IF EXISTS Movies;
CREATE TABLE Movies
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
Select type,Count(*) as total_content from netflix_titles group by type
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select type,rating from(
select type,rating,count(*)as content_count,rank() over(partition by type order by count(*)desc) as ranking
from netflix_titles group by type,rating )
as t1
where ranking = 1
order by 1,3 desc;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix_titles where type ='movie' and release_year=2019;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select top 5
      ltrim(rtrim(value)) as new_country,
	  count(show_id) as total_content
	  from netflix_titles
	  cross apply string_split(country, ',')
	  group by ltrim(rtrim(value))
	  order by total_content desc;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
 select * from netflix_titles where type = 'Movie' and duration = (select max(duration) from netflix_titles);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 10 Years

```sql
 select * from netflix_titles where
	  try_cast(date_added as date) >= DATEADD(year, -10, getdate());
```

**Objective:** Retrieve content added to Netflix in the last 10 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix_titles where director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
    select * from netflix_titles
	where
	type = 'TV show'
	and
	try_cast(left(duration, CHARINDEX(' ', duration + ' ' ) - 1)as int)> 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select
   trim(value) as genre,
   count(show_id) as total_content
   from netflix_titles
   cross apply string_split(listed_in, ',')
   where type = 'TV show'
   group by trim(value)
   order by 
   total_content desc;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
 select * from netflix_titles 
   where
   listed_in like '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix_titles where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 15 Years

```sql
select * from netflix_titles where cast like '%Salman Khan%'
   and
   release_year >= year(getdate()) - 15;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 15 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - M.Praveen kumar

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/madineni-praveen-kumar-350047286/)
