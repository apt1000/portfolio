DROP TABLE IF EXISTS bookings;

CREATE TABLE bookings (
	booking_id INT PRIMARY KEY, 
	listing_name VARCHAR, 
	host_id INT, 
	host_name VARCHAR(50), 
	neighborhood_group VARCHAR(30), 
	neighborhood VARCHAR(30), 
	latitude DECIMAL(11, 8), 
	longitude DECIMAL(11, 8), 
	room_type VARCHAR(30), 
	price INT, 
	minimum_nights INT, 
	num_of_reviews INT, 
	last_review DATE, 
	reviews_per_month DECIMAL(4, 2), 
	calculated_host_listings_count INT, 
	availability_365 INT
);

--SQL Command prompt
---- \COPY bookings FROM 'AB_NYC_2019.csv' DELIMITER ',' CSV HEADER ENCODING 'utf8'

--Average price with window function
SELECT 
	booking_id, 
	listing_name, 
	neighborhood_group, 
	AVG(price) OVER() AS avg_price
FROM bookings;

--Average, minimum, and maximum price
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	ROUND(AVG(price) OVER(), 2) AS avg_price, 
	MIN(price) OVER() AS min_price, 
	MAX(price) OVER() AS max_price
FROM bookings;

--Calculate the difference from the average price
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	price, 
	ROUND(AVG(price) OVER(), 2), 
	ROUND(price - (AVG(price) OVER()), 2) AS diff
FROM bookings;

--Caluculate the percentage of the average price
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	price, 
	ROUND(AVG(price) OVER(), 2), 
	ROUND(price / AVG(price) OVER() - 1, 2) AS percent_diff
FROM bookings;

--Partition by Neighborhood Group
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROUND(AVG(price) OVER(PARTITION BY neighborhood_group), 2) AS avg_neighborhood_price
FROM bookings;

--Partition by neighborhood group and neighborhood
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROUND(AVG(price) OVER(PARTITION BY neighborhood_group), 2) AS avg_price_group, 
	ROUND(AVG(price) OVER(PARTITION BY neighborhood_group, neighborhood), 2) AS avg_price_group_neigh
FROM bookings;

--average price differences by neighborhood and neighborhood group
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROUND(AVG(price) OVER(PARTITION BY neighborhood_group), 2) AS avg_price_group,
	ROUND(AVG(price) OVER(PARTITION BY neighborhood_group, neighborhood), 2) AS avg_price_group_neigh, 
	ROUND(price - AVG(price) OVER(PARTITION BY neighborhood_group), 2) AS price_diff_group, 
	ROUND(price - AVG(price) OVER(PARTITION BY neighborhood_group, neighborhood), 2) AS price_diff_group_neigh
FROM bookings;

--Rank the prices
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROW_NUMBER() OVER(ORDER BY price DESC) AS price_rank, 
	ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) AS price_rank_group
FROM bookings;

--Top 3 prices per neighborhood group
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROW_NUMBER() OVER(ORDER BY price DESC) AS price_rank, 
	ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) AS price_rank_group, 
	CASE 
		WHEN ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) < 4 THEN 'Yes'
		ELSE 'No'
	END AS top_3
FROM bookings;

--Rank the prices
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROW_NUMBER() OVER(ORDER BY price DESC) AS price_rank, 
	RANK() OVER(ORDER BY price DESC) AS price_rank_rank, 
	ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) AS rank_group, 
	RANK() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) AS price_rank_rank_group
FROM bookings;

--Dense rank
SELECT
	booking_id, 
	listing_name, 
	neighborhood_group, 
	neighborhood, 
	price, 
	ROW_NUMBER() OVER(ORDER BY price DESC) AS row_num, 
	RANK() OVER(ORDER BY price DESC) AS rank_num, 
	DENSE_RANK() OVER(ORDER BY price DESC) AS dense_rank_num
FROM bookings;

--Find the previous price
SELECT
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review, 
	LAG(price) OVER(PARTITION BY host_name ORDER BY last_review) AS previous_price
FROM bookings;

--Find the price from 2 bookings previously
SELECT
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review, 
	LAG(price, 2) OVER(PARTITION BY host_name ORDER BY last_review) AS previous_price
FROM bookings;

--Find the following price
SELECT
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review, 
	LEAD(price) OVER(PARTITION BY host_name ORDER BY last_review) AS next_price
FROM bookings;

--Find the price from the 2 following bookings
SELECT
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review, 
	LEAD(price, 2) OVER(PARTITION BY host_name ORDER BY last_review) AS next_price
FROM bookings;

--Select all top 3 bookings per price from neighborhood group
SELECT *
FROM (
	SELECT
		booking_id, 
		listing_name, 
		neighborhood_group, 
		neighborhood, 
		price, 
		ROW_NUMBER() OVER(ORDER BY price DESC) AS price_rank, 
		ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) AS price_rank_group, 
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY neighborhood_group ORDER BY price DESC) < 4 THEN 'Yes'
			ELSE 'No'
		END AS top_3
	FROM bookings
) AS a
WHERE top_3 = 'Yes';