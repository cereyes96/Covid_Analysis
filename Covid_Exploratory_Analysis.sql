SELECT *
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
Order by 
  location, date;

-- SELECT *
-- FROM `my-project-19297-401423.covid_data.covid_vaccinations` 
-- Order by 
--   location, date;

--Selecting the data that I'm going to be working with

SELECT
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
ORDER BY
  location, date;

--Total Cases vs Total Deaths

SELECT
  location,
  date,
  total_cases,
  total_deaths,
  ((total_deaths/total_cases) * 100) AS cases_vs_deaths_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
ORDER BY
  location, date;

--Death percentage in the country I live in

SELECT
  location,
  date,
  total_cases,
  total_deaths,
  ((total_deaths/total_cases) * 100) AS cases_vs_deaths_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  location = "Honduras"
AND
  continent is not null
ORDER BY
  cases_vs_deaths_percentage DESC;

--Total Cases vs Population
--Shows the percentage of the population who got Covid

SELECT
  location,
  date,
  population,
  total_cases,
  ((total_cases/population) * 100) AS cases_vs_population_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  location = "Honduras"
AND
  continent is not null
ORDER BY
  date;

--Countries with highest infection rate per population

SELECT
  location,
  population,
  MAX(total_cases) AS highest_infection_count,
  ((MAX(total_cases/population)) * 100) AS highest_infection_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
Group by
  location, 
  population
ORDER BY
  highest_infection_percentage DESC;

--Countries with the highest death count per population

SELECT
  location,
  population,
  MAX(total_deaths) AS highest_death_count,
  ((MAX(total_deaths/population)) * 100) AS highest_death_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
Group by
  location, 
  population
ORDER BY
  highest_death_count DESC;

--Highest death count per continent

SELECT
  continent,
  MAX(total_deaths) AS highest_death_count,
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
Group by
  continent
ORDER BY
  highest_death_count DESC;

--Global Numbers

--Total cases and totals deaths globally

SELECT
  SUM(new_cases) AS total_cases,
  Sum(new_deaths) AS total_deaths,
  (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
AND
  new_cases <> 0;

--Total cases and totals deaths globally per day
SELECT
  date,
  SUM(new_cases) AS total_cases,
  Sum(new_deaths) AS total_deaths,
  (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_percentage
FROM 
  my-project-19297-401423.covid_data.covid_deaths
WHERE
  continent is not null
AND
  new_cases <> 0
GROUP BY
  date
ORDER BY
  date;

--Joining covid_deaths and covid_vaccinations tables
--Total population vs vaccinations per day

SELECT 
  deaths.continent,
  deaths.location, 
  deaths.date,
  deaths.population,
  vaccinations.new_vaccinations,
  SUM(vaccinations.new_vaccinations) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS total_vaccinations
FROM
  my-project-19297-401423.covid_data.covid_deaths AS deaths
JOIN
  my-project-19297-401423.covid_data.covid_vaccinations AS vaccinations
ON
  deaths.location = vaccinations.location
AND
  deaths.date = vaccinations.date
WHERE
  deaths.continent is not null
ORDER BY
  deaths.location,
  deaths.date;

--Temp Table

WITH pop_vs_vac AS
 (SELECT 
  deaths.continent,
  deaths.location, 
  deaths.date,
  deaths.population,
  vaccinations.new_vaccinations,
  SUM(vaccinations.new_vaccinations) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS total_vaccinations
FROM
  my-project-19297-401423.covid_data.covid_deaths AS deaths
JOIN
  my-project-19297-401423.covid_data.covid_vaccinations AS vaccinations
ON
  deaths.location = vaccinations.location
AND
  deaths.date = vaccinations.date
WHERE
  deaths.continent is not null
 )
SELECT *, (total_vaccinations/population) * 100 AS vaccination_percentage
FROM
  pop_vs_vac;

--Creating a view for further visualization

Drop view if exists `my-project-19297-401423.covid_data.pop_vs_vac`;

CREATE VIEW my-project-19297-401423.covid_data.pop_vs_vac AS
 SELECT 
  deaths.continent,
  deaths.location, 
  deaths.date,
  deaths.population,
  vaccinations.new_vaccinations,
  SUM(vaccinations.new_vaccinations) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS total_vaccinations
FROM
  my-project-19297-401423.covid_data.covid_deaths AS deaths
JOIN
  my-project-19297-401423.covid_data.covid_vaccinations AS vaccinations
ON
  deaths.location = vaccinations.location
AND
  deaths.date = vaccinations.date
WHERE
  deaths.continent is not null;