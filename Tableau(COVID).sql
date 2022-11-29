-- Quiries for Tableau Visualizations

-- Table 1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From COVID.CovidDeaths;

-- Table 2

Select Continent, SUM(cast(new_deaths as signed)) AS TotalDeathCount
From COVID.CovidDeaths
where continent is not null 
GROUP BY continent
order by TotalDeathCount desc;

-- Table 3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From COVID.CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- Table 4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From COVID.CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc;

