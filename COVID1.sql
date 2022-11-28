-- Source: Our World DATA (https://ourworldindata.org/coronavirus#coronavirus-country-profiles)

-- Data Exploration

-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

use COVID;

select * from COVID.coviddeaths;

select location, date, total_cases, new_cases, total_deaths, population
from COVID.coviddeaths;

-- Total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from COVID.coviddeaths;

-- United Staes

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from COVID.coviddeaths
where location = 'United States';

-- Total cases vs Population (United States)

select location, date, total_cases, population, (total_deaths/population)*100 as Cases_Population_Percentage
from COVID.coviddeaths
where location = 'United States';

-- Countries with highest infection rates (Andora)

select location, population, MAX(total_cases)as highest_Infection_Count, MAX((total_cases/population))*100 as Population_Infected_Percentage
from COVID.coviddeaths
group by location, population
order by Population_Infected_Percentage desc;

-- Countries with highest death rates (Hungary)

select location, population, MAX(total_deaths)as highest_death_count, MAX((total_deaths/population))*100 as Population_Infected_Percentage
from COVID.coviddeaths
group by location, population
order by Population_Infected_Percentage desc;


-- Max death count per location 

select location, MAX(total_deaths)as total_death_count
from COVID.coviddeaths
group by location
order by total_death_count desc;

-- (Convert data to integer)

select location, MAX(cast(total_deaths as signed))as total_death_count
from COVID.coviddeaths
group by location
order by total_death_count desc;

select location, MAX(cast(total_deaths as signed))as total_death_count
from COVID.coviddeaths
where continent is not null
group by location
order by total_death_count desc;

-- Continents with highest death count

select location, MAX(cast(total_deaths as signed)) as total_death_count
from COVID.coviddeaths
where continent is not null
group by location
order by total_death_count desc;

-- GLOBAL NUMBERS

select date, SUM(new_cases), SUM(new_deaths)
from COVID.coviddeaths
group by date;

-- Convert to integer

select date, SUM(new_cases), SUM(cast(new_deaths as signed)) as total_new_deaths
from COVID.coviddeaths
group by date;

-- GLOBAL NUMBER CONT.

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from COVID.coviddeaths
group by date;

-- Total cases

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_new_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from COVID.coviddeaths;

-- Vaccination data

select * from COVID.covidvaccinations;

-- Join tables

select *
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date;
 
-- Total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date;
 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date;
 
 -- Identify how man people vaccinated per country (USE CTE)
 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
 , (rolling_vaccinations/population) -- error use cte
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date;
 
 -- CTE to perform Calculation on Partition 
 
 With PopvsVac (continent, location, data, population, new_vaccinations, rolling_vaccinations)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
 -- , (rolling_vaccinations/population)
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date
 )
 select *, (rolling_vaccinations/population)
 from PopvsVac;
 
 -- Temp Table to perform Calculation on Partition By in previous query
 
 Drop Table if exists #percent_population_vaccinated
 Create Table #percent_population_vaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccinations numeric,
 rolling_vaccinations numeric
 )
 
 insert into percent_population_vaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
 -- , (rolling_vaccinations/population)
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date
 
  select *, (rolling_vaccinations/population)
 from #percent_population_vaccinated;
 
 
 
 -- Creating view for data visualizations
Create view percent_population_vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from COVID.coviddeaths as dea
join COVID.covidvaccinations as vac
 on dea.location = vac.location 
 and dea.date = vac.date;
 
 