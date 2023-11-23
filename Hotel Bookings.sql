/*Create new table by combining existing tables containing dat for each year*/
SELECT *
INTO bookings
FROM dbo.[2018]
UNION
SELECT *
FROM dbo.[2019]
UNION
SELECT *
FROM dbo.[2020];

/*Conduct exploratory data analysis to determine f yearly revenue is increasing*/
SELECT hotel, arrival_date_year, ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights) * adr), 0) AS revenue
FROM bookings
GROUP BY hotel, arrival_date_year
ORDER BY hotel, arrival_date_year;

/*Write SQL query to be used for Power BI Query*/
SELECT *
FROM bookings AS b
LEFT JOIN dbo.market_segment AS ms
ON b.market_segment = ms.market_segment
LEFT JOIN dbo.meal_cost AS mc
ON b.meal = mc.meal;