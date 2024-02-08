﻿
--Queries used for visualizations in Tableau

-- 1. 

Select 
  SUM(new_cases) as total_cases, 
  SUM(cast(new_deaths as int)) as total_deaths, 
  SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From 
  my-project-19297-401423.covid_data.covid_deaths
where 
  continent is not null 
order by 
  total_cases, total_deaths;

-- 2. 

-- Looking only at the continents
--Excluded names that were not continents

Select 
  location, 
  SUM(cast(new_deaths as int)) as TotalDeathCount
From 
  my-project-19297-401423.covid_data.covid_deaths
Where 
  continent is null 
and 
  location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by 
  location
order by 
  TotalDeathCount desc;


-- 3.

Select 
  Location, 
  Population, 
  MAX(total_cases) as HighestInfectionCount,  
  Max((total_cases/population))*100 as PercentPopulationInfected
From 
  my-project-19297-401423.covid_data.covid_deaths
 Where 
  continent IS NOT NULL
Group by 
  Location, 
  Population
order by 
  PercentPopulationInfected desc;


-- 4.


Select 
  Location, 
   Population,
   date,
   MAX(total_cases) as HighestInfectionCount,  
   Max((total_cases/population))*100 as PercentPopulationInfected
From 
  my-project-19297-401423.covid_data.covid_deaths
Where 
  continent IS NOT NULL
Group by 
  Location, 
  Population, 
  date
order by 
  PercentPopulationInfected desc;