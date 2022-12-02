-- Data cleaning, exploration, and analysis

SELECT * FROM Movies.movies;

-- Order in desc to get alphabetically

SELECT * 
FROM Movies.movies
order by name asc;

-- Check for Nulls

SELECT * 
FROM Movies.movies
where budget and gross is null;


-- New Column (Total Profit%) also convert to int

SELECT name, cast(budget as signed), cast(gross as signed), cast(gross/budget as signed)*100 as total_profit_percentage
FROM Movies.movies
-- where total_profit_percentage is not null
order by total_profit_percentage desc;

-- Paranormal Activity had the highest total Profit (1289000%)

-- Who has the highest grossing film? (change to int)

SELECT Name, cast(Gross/100 as unsigned)*100 as highest_grossing
FROM Movies.movies
order by highest_grossing desc;

-- Avatar has highest grossing($2,847,246,200)

-- Budget vs gross

SELECT Name, budget, cast(Gross/100 as unsigned)*100 as highest_grossing
FROM Movies.movies
order by highest_grossing desc;

-- Comparing top 10 highest grossing movies with their budget

SELECT Name, budget, cast(Gross/100 as unsigned)*100 as highest_grossing
FROM Movies.movies
where gross >= 1450026900
order by highest_grossing desc;

-- Who had the highest profit %?

SELECT Name, budget,Gross,cast(gross/budget as signed)*100 as total_profit_percentage
FROM Movies.movies
where gross >= 1450026900
order by total_profit_percentage desc;

-- Avater with a %1200

-- Who was the highest grossing from 1980-1999?

SELECT Name, year, cast(Gross/100 as unsigned)*100 as highest_grossing
FROM Movies.movies
where year<2000
order by highest_grossing desc;

-- Titanic $2,201,647,300

-- Oldest movie on the data

select name, year, released
FROM Movies.movies
where year = 1980
order by released desc;

-- Window & Just tell me what you want

-- Newest movie in the data

select name, year, released
FROM Movies.movies
where year = 2020
order by released desc;

-- Bad Boys for lIFE & Dolittle

-- Most popular genre

select genre, count(*) as total_genre
FROM Movies.movies
group by genre;

-- Action(1,703)


