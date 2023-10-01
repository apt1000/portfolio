CREATE VIEW percent_vaxxed AS
	SELECT death.continent, death.location, death.date, population, new_people_vaccinated_smoothed,
		SUM(new_people_vaccinated_smoothed) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS cumulative_vaccinations
	FROM CovidDeaths death
	JOIN CovidVaccinations vax
		ON death.location = vax.location
		AND death.date = vax.date
	WHERE death.continent IS NOT NULL;