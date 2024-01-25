--Create a joined table
SELECT *
FROM attendance AS a
LEFT JOIN compensation AS c
ON a.ID = c.ID
LEFT JOIN reasons AS r
ON a.Reason_for_absence = r.Number;

--Finding the healthiest employees
SELECT *
FROM attendance
WHERE Social_drinker = 0
	AND Social_smoker = 0
	AND Body_mass_index < 25
	AND Absenteeism_time_in_hours < (
		SELECT AVG(Absenteeism_time_in_hours)
		FROM attendance
	);

--Count nonsmokers
SELECT COUNT(*) AS nonsmokers
FROM attendance
WHERE Social_smoker = 0;

--Create a joined table
SELECT a.ID, 
	r.Reason, 
	CASE WHEN a.Month_of_absence IN(12, 1, 2) THEN 'Winter'
		WHEN a.Month_of_absence IN(3, 4, 5) THEN 'Spring'
		WHEN a.Month_of_absence IN(6, 7, 8) THEN 'Summer'
		WHEN a.Month_of_absence IN(9, 10, 11) THEN 'Fall'
		ELSE 'Unknown' END AS Season, 
	CASE WHEN a.Body_mass_index BETWEEN 0 AND 18.5 THEN 'Underweight'
		WHEN a.Body_mass_index < 25 THEN 'Healthy'
		WHEN a.Body_mass_index < 30 THEN 'Overweight'
		WHEN a.Body_mass_index > 30 THEN 'Obese'
		ELSE 'Unknown' END AS BMI_category, 
	a.Month_of_absence, 
	a.Day_of_the_week, 
	a.Transportation_expense, 
	a.Education, 
	a.Son, 
	a.Social_drinker, 
	a.Social_smoker, 
	a.Pet, 
	a.Disciplinary_failure, 
	a.Age, 
	a.Work_load_Average_day, 
	a.Absenteeism_time_in_hours
FROM attendance AS a
LEFT JOIN compensation AS c
ON a.ID = c.ID
LEFT JOIN reasons AS r
ON a.Reason_for_absence = r.Number;
