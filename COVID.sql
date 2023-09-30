SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

--Looking at total cases vs total deaths
--The likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases*100, 2) AS death_rate
FROM CovidDeaths
WHERE location LIKE '%states%'
	AND continent IS NOT NULL
ORDER BY 1, 2;

--Shows what percentage of population has contracted COVID
SELECT location, date, total_cases, population, total_deaths, ROUND(total_cases/population*100, 2) AS percent_contracted
FROM CovidDeaths
WHERE location LIKE '%states%'
	AND continent IS NOT NULL
ORDER BY 1, 2;

--Countries with the highest infection rates
SELECT location, population, MAX(total_cases) AS highest_infection_count, ROUND((MAX(total_cases)/population*100), 2) AS percent_pop_infected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_pop_infected DESC;

--Countries with the highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

--Death counts by continent
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;

--Global counts
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, ROUND((SUM(new_deaths)/SUM(total_cases))*100, 2) AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY 1, 2;

--Total Population vs Vacciantions using CTE
WITH GlobalVax(continent, location, date, population, new_people_vaccinated_smoothed, cumulative_vaccinations)
AS (

	SELECT death.continent, death.location, death.date, population, new_people_vaccinated_smoothed,
		SUM(new_people_vaccinated_smoothed) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS cumulative_vaccinations
	FROM CovidDeaths death
	JOIN CovidVaccinations vax
		ON death.location = vax.location
		AND death.date = vax.date
	WHERE death.continent IS NOT NULL

)

SELECT *, (cumulative_vaccinations/population)*100 AS percent_vaxxed
FROM GlobalVax
ORDER BY 2, 3;

--Total Population vs Vacciantions Using Temp Table
DROP TABLE IF EXISTS #GlobalVax
CREATE TABLE #GlobalVax(
	continent NVARCHAR(50), 
	location NVARCHAR(50), 
	date DATE, 
	population FLOAT, 
	new_people_vaccinated_smoothed FLOAT, 
	cumulative_vaccinations FLOAT
)

INSERT INTO #GlobalVax 
	SELECT death.continent, death.location, death.date, population, new_people_vaccinated_smoothed,
		SUM(new_people_vaccinated_smoothed) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS cumulative_vaccinations
	FROM CovidDeaths death
	JOIN CovidVaccinations vax
		ON death.location = vax.location
		AND death.date = vax.date
	WHERE death.continent IS NOT NULL

SELECT *, (cumulative_vaccinations/population)*100 AS percent_vaxxed
FROM #GlobalVax
ORDER BY 2, 3;

--Select view created with above query
SELECT *
FROM percent_vaxxed;