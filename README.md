 
<img src="netflix.gif" alt="Demo GIF" width="1300" height = "200"/>

# Data Analysis
Data Analysis using Postgres SQL

## Overview
This project presents a comprehensive analysis of Netflix's extensive catalog of movies and TV shows using postgreSQL. The primary goal is to extract actionable insights and answer a series of business questions by analyzing key attributes in the dataset. By leveraging SQL queries and aggregating relevant metrics, the project aims to inform strategic decisions, identify trends, and generate meaningful conclusions about the platform's content library.

## Objectives
The analysis is structured around answering the following key objectives:

1. Content Distribution: Analyze the proportion of movies vs. TV shows and evaluate how content is distributed across various genres, release years, and regions.


2. Trend Analysis: Identify patterns in Netflix’s content catalog over the years, including trends in content production, popular genres, and emerging markets.


3. Regional Focus: Investigate how Netflix’s content strategy varies across different countries, with a focus on content localization and popular genres in specific regions.


4.  Ratings and Audience Targeting: Examine how content ratings (e.g., PG, R) and audience demographics (e.g., kids vs. adult content) shape the Netflix library.


5.  Content Lifecycle: Explore how long content tends to stay on the platform, including trends in content removal and whether certain types of shows/movies have longer lifespans.

## Dataset
The dataset for this project is accessed from Kaggle dataset:
- [Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Business Problems are listed below:
Below are the 15 business problems that are resolved using SQL:
1. Total number of Content based on type (Movies vs TV Shows)
2.  Most common ratings for each type
3.  List of movies released in 2021
4.  Top 5 countries with most viewed content.
5.  Movie that has longest duration.
6.  Content that has been added in the last 5 year in Netflix.
7.  List of movies/TV shows directed by 'Rajiv Chilaka'.
8.  TV shows list with more than 3 seasons
9.  Total number of content items in each genre.
10.  Top 5 average number of contents released in India.
11.  List all the content that categorised as Documentaries.
12.  List of Content without director.
13.  List of movies actor 'Salman Khan' acted in last 10 years.
14.  Top 10 actors who have acted in the highest number of movies produced in India.
15.  Categorize Content as 'Adult' or 'Non-Adult' based on 'Kill' and 'Violence' keywords.

## Data Preparation:
* Named the database as Netflix_DB.
* Created the table 'netflix' with the schema.


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
* Then, imported the downloaded dataset into postgresql.
* Once, it is successfully imported. Follow the next step i.e. data profiling

## Data Exploration
* Data exploration using PostgreSQL involves querying the database to summarize, visualize, and understand patterns in the data. It typically includes tasks like descriptive statistics, identifying missing values, and generating insights through SQL queries.

* In this project case, the dataset is clean. So, we try to explore the number of records in this dataset.
* To find the number of records in the 'netflix' dataset using the following query:

        select count(*) from netflix;
    
* To find the number of categorise in each type using distinct keyword as follows:

        select distinct(type) from netflix;
* It displays, two type of content one is Movie and the other is TV Shows.
* Now lets move on to the solution part which solves the business problems.

## Solutions for the problems are listed below:
1. Total number of Content based on type (Movies vs TV Shows):

       select type, count(*) as total_content from netflix group by 1;

#### Objective: Determine the distribution of content on dataset.
2. Most common ratings for each type:


        select type, rating from 
        	(select type, rating, count(*),
        		rank() over(partition by type order by count(*) desc) as ranking
        		from netflix group by 1,2) as t1 where ranking = 1;

#### Objective: Identify the most frequent rating given for each content type.
3.  List of movies released in 2021:


           select type,title,director,release_year from netflix where type = 'Movie' and release_year = '2021';

#### Objective: Retrieves all movies released in 2021 
4.  Top 5 countries with most viewed content:

          select 
          	unnest(string_to_array(country, ',')) as new_country, 
          	count(show_id)as content from netflix 
          group by 1
          order by 2 desc
          limit 5;

#### Objective: Identified the top 5 countries with highest number of content.
5.  Movie that has longest duration:

          select * from netflix
          where type = 'Movie' and 
          		duration = (select max(duration) from netflix);

#### Objective: Retrieved the movie that has longest duration.
6.  Content that has been added in the last 5 year in Netflix:

         select *	
        	from netflix 
        	where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';

#### Objective: Identified the content added to Netflix in last 5 years.
7.  List of movies/TV shows directed by 'Rajiv Chilaka':

        select * from netflix where director like '%Rajiv Chilaka%';

#### Objective: Retrieved the list of movies/TV shows directed by 'Rajiv Chilaka'
8.  TV shows list with more than 3 seasons:

        select * from netflix 
         	where type = 'TV Show' and split_part(duration, ' ', 1):: numeric > 3;

#### Objective: Identified the TV Shows with more than 3 seasons.
9.  Total number of content items in each genre:

        select unnest(string_to_array(listed_in, ',')) as genre,
        	count(show_id)
          from netflix group by 1 order by 2 desc;

#### Objective: Retrieved the total number of content items in each genre.
10.  Top 5 average number of contents released by India:

          select extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
          count(*) as yearly_content,
          round(count(*) :: numeric / (select count(*) from netflix where country like '%India%') *100,2) :: numeric 
          as avg_content_per_year
          from netflix
          where country like '%India%'
          group by 1

#### Objective: With the extract, round functions calculated the rank years by the average number of content released by India.
11.  List all the content that categorised as Documentaries:

          select * from netflix where 
          type = 'Movie' and listed_in ilike '%documentaries'

#### Objective: Extracted all the movies that is categorised as 'Documentaries'
12.  List of Content without director:

          select * from netflix where director is null

#### Objective: Retrieved the list of content without director.
13.  List of movies actor 'Salman Khan' acted in last 10 years.

          select * from netflix where casts ilike '%Salman Khan%' and
          	release_year > extract (year from current_date ) - 10

#### Objective: Extracted list of movies acted by 'Salman Khan' in last 10 years using ilike and extract functions.
14.  Top 10 actors who have acted in the highest number of movies produced in India.

          select count(*), unnest(string_to_array(casts, ',')) as actors from netflix 
          where type = 'Movie' and country ilike '%India%' group by 2 order by count(*) desc 
          limit 10;

#### Objective: Identified the top 10 actors who acted in the highest number of movies produced by India.
15.  Categorize Content as 'Adult' or 'Non-Adult' based on 'Kill' and 'Violence' keywords.

          select category, count(*) as content_count from 
          (select case 
          	when description ilike '%kill%' or description ilike '%violence%' or description ilike '%sex%'
          	then 'Adult'
          	else 'Non-Adult'
          	end as category
           from netflix
           ) as categorized_content group by category; 

#### Objective: Extracted the content based on keywords like 'Kill' or 'Violence' as 'Adult' or 'Non-Adult' using CASE expression.

# Findings and Conclusion:
* Content Distribution: The dataset showcases a diverse mix of movies and TV shows, spanning various genres and ratings. This provides a broad view of the content available on Netflix.

* Audience Targeting Through Ratings: Analyzing the most common content ratings offers valuable insights into Netflix’s audience segmentation, highlighting the platform’s focus on specific viewer demographics.

* Geographical Insights: By identifying the leading content-producing countries and examining the volume of releases, particularly from regions like India, we gain a deeper understanding of Netflix’s regional content strategy.

* Content Categorization: Grouping titles by key themes and keywords reveals the dominant types of content available, shedding light on Netflix’s programming focus and genre diversity.

This analysis offers a holistic perspective on Netflix’s content library, helping to inform strategic decisions around content development and acquisition.


### Contact:
For any queries or inquiries, please contact [revathigangadaran@gmail.com].
