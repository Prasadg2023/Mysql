create database film;
use film;

select * from movies;

describe movies;

create database Movies;
use Movies;
select * from movie;

SELECT 
    SUM(CASE WHEN MyUnknownColumn = '' THEN 1 ELSE 0 END) AS MyUnknownColumn,
    SUM(CASE WHEN title_length IS NULL THEN 1 ELSE 0 END) AS title_length,
    SUM(CASE WHEN genre = '' THEN 1 ELSE 0 END) AS genre,
    SUM(CASE WHEN language = '' THEN 1 ELSE 0 END) AS language,
    SUM(CASE WHEN content_type = '' THEN 1 ELSE 0 END) AS content_type,
    
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year,
    SUM(CASE WHEN duration_min IS NULL THEN 1 ELSE 0 END) AS duration_min,
    SUM(CASE WHEN budget_million IS NULL THEN 1 ELSE 0 END) AS budget_million,
    SUM(CASE WHEN marketing_million IS NULL THEN 1 ELSE 0 END) AS marketing_million,
    SUM(CASE WHEN director_experience IS NULL THEN 1 ELSE 0 END) AS director_experience,
    
    SUM(CASE WHEN critic_rating IS NULL THEN 1 ELSE 0 END) AS critic_rating,
    SUM(CASE WHEN user_rating IS NULL THEN 1 ELSE 0 END) AS user_rating,
    
    SUM(CASE WHEN country = '' THEN 1 ELSE 0 END) AS country,
    SUM(CASE WHEN popular IS NULL THEN 1 ELSE 0 END) AS popular
FROM movies;
DESCRIBE movies;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM movies
WHERE  
    MyUnknownColumn IS NULL OR MyUnknownColumn = '' OR
    genre IS NULL OR genre = '' OR
    language IS NULL OR language = '' OR
    content_type IS NULL OR content_type = '' OR
    country IS NULL OR country = '' OR
    title_length IS NULL OR
    release_year IS NULL OR
    duration_min IS NULL OR
    budget_million IS NULL OR
    marketing_million IS NULL OR
    director_experience IS NULL OR
    critic_rating IS NULL OR
    user_rating IS NULL OR
    popular IS NULL;

SELECT DISTINCT genre FROM movies ORDER BY genre;
SELECT DISTINCT language FROM movies ORDER BY language;
SELECT DISTINCT country FROM movies ORDER BY country;

select * from movies;
ALTER TABLE movies
CHANGE MyUnknownColumn id INT;

-- 1.Total number of movies in the dataset

select count(*) as total_movies from movies;

-- 2. Count of movies by each genre

select genre,count(*) as total from movies
group by genre;


-- 3.Average budget of movies
select round(avg(budget_million),2) as Average_budget from movies;


-- 4.Top 5 movies with highest user_rating

select * from movies
order by user_rating desc
limit 5;

-- 5.Top 5 movies with highest critic_rating
select * from movies
order by critic_rating desc
limit 5;

-- 6.Count of popular vs non-popular movies

select
SUM(CASE WHEN popular = 1 THEN 1 ELSE 0 END) AS Popular,
SUM(CASE WHEN popular = 0 THEN 1 ELSE 0 END) AS Non_Popular
from movies;

select
SUM(popular = 1 ) AS Popular,
SUM(popular = 0 ) AS Non_Popular
from movies;

-- 7.Average marketing spend for popular movies
select avg(marketing_million) as Average_marketing_spend from movies
where popular = 1;

-- 8.Which genre has the highest average user rating?

select genre ,avg(user_rating) as avg_rating from movies
group by genre
order by avg_rating desc;

-- 9.Average duration of movies by content type (Movie vs Series)
select content_type ,avg(duration_min) as avg_duration from movies
group by content_type;

-- 10.Count of movies by director experience
select director_experience ,count(*) as total_movies from movies
group by director_experience;

-- 11.Which country produces the most popular movies?
select country,count(popular) as Popular_movies from movies
where popular = 1
group by country
order by Popular_movies desc;

-- 12.Average critic rating for each language
select language,avg(critic_rating) as critic_rating
from movies
group by language;


-- 13.Movies with budget above average budget.
select * from movies
where budget_million >
	(select avg(budget_million)from movies);
    
-- 14. Correlation-style question: 
-- Do higher budgets (> avg) lead to more popularity? (use counts/percentages)

select
case
	when budget_million > (select avg(budget_million)from movies)
    then "High budget"
    else "Low budget"
end as budget_group,

	sum( case when popular = 1 then 1 else 0 end) as Popular,
    sum(case when popular = 0 then 1 else 0 end) as Not_popular,

round(100.0 * sum( case when popular = 1 then 1 else 0 end) / count(*),2) as popular_percentage,
round(100.0 * sum( case when popular = 0 then 1 else 0 end) / count(*),2) as Not_popular_percentage

from movies
group by budget_group;


-- 15.Top 3 countries with highest average user ratings
select country , avg(user_rating) as avg_rating from movies
group by country
order by avg_rating desc
limit 3;