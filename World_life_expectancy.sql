SELECT *
FROM world_life_expectancy;

--Looking for duplicates 

SELECT *
FROM(
SELECT Country, Year, concat(Country, Year), COUNT(concat(Country, Year)) as count
FROM world_life_expectancy
GROUP BY Country, Year, concat(Country, Year)) as tbl
WHERE count > 1 ;

SELECT Row_id
FROM(
SELECT Row_id,
concat(Country, Year),
ROW_NUMBER() OVER( PARTITION BY concat(Country, Year) ORDER BY concat(Country, Year)) as Row_num
FROM world_life_expectancy
) as tbl
WHERE Row_num > 1;

--Deleting duplicates
 
DELETE FROM world_life_expectancy
WHERE Row_id IN (
	SELECT Row_id
FROM(
	SELECT Row_id,
	concat(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY concat(Country, Year) ORDER BY concat(Country, Year)) as Row_num
	FROM world_life_expectancy
	) as tbl
	WHERE Row_num > 1);


--looking for blanks

SELECT *
FROM world_life_expectancy
WHERE Status = '';

--replacing blanks in status 

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
 ON t1.Country = t2.Country
SET T1.status = 'Developed'
WHERE T1.Status = ''
AND t2.status <> ''
AND t2.status = 'Developed'
;

--searching for blanks in `life expectancy` column

SELECT *
FROM world_life_expectancy
WHERE `life expectancy` = ''
;

--replacing blanks with average from previous and next year
SELECT 
t1.country, t1.Year, t1.`life expectancy`, 
t2.country, t2.Year, t2.`life expectancy`, 
t3.country, t3.Year, t3.`life expectancy`,
ROUND((t3.`life expectancy` + t2.`life expectancy`)/2,1)
FROM world_life_expectancy t1
	JOIN world_life_expectancy t2 
		ON t1.country = t2.country
		AND t1.year = t2.year - 1
	JOIN world_life_expectancy t3 
		ON t1.country = t3.country
		AND t1.year = t3.year + 1
WHERE t1.`life expectancy` = '';



UPDATE world_life_expectancy t1
	JOIN world_life_expectancy t2 
		ON t1.country = t2.country
		AND t1.year = t2.year - 1
	JOIN world_life_expectancy t3 
		ON t1.country = t3.country
		AND t1.year = t3.year + 1
SET T1.`life expectancy` = ROUND((t3.`life expectancy` + t2.`life expectancy`)/2,1)
WHERE T1.`life expectancy` = '';





SELECT *
FROM world_life_expectancy;

SELECT country, 
MIN(`life expectancy`), 
MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) as life_increase
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`life expectancy`) <> 0 AND MAX(`life expectancy`) <> 0
ORDER BY life_increase DESC;


SELECT YEAR, ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
WHERE `life expectancy` <> 0 
AND `life expectancy` <> 0
GROUP BY Year
ORDER BY Year desc
;

SELECT Country, ROUND(AVG(`life expectancy`),2) AS life_exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND GDP > 0
ORDER BY GDP;




SELECT 
SUM(CASE WHEN GDP >= 1500 THEN '1' ELSE '0' END) High_gdp_count,
round(AVG (CASE WHEN GDP >= 1500 THEN `life expectancy` ELSE NULL END),1) High_gdp_Life_exp,
SUM(CASE WHEN GDP <= 1500 THEN '1' ELSE '0' END) Low_gdp_count,
round(AVG (CASE WHEN GDP <= 1500 THEN `life expectancy` ELSE NULL END),1) Low_gdp_Life_exp
FROM world_life_expectancy;
    
    
SELECT avg(gdp)
FROM (
SELECT gdp
FROM world_life_expectancy
where gdp <> 0
) as avg_gdp;

SELECT Country, ROUND(AVG(`life expectancy`),2) AS life_exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND BMI > 0
ORDER BY BMI DESC;


SELECT country, 
year, 
`life expectancy`,
`adult mortality`,
SUM(`adult mortality`) OVER(PARTITION BY country ORDER BY year) as death_increase
FROM world_life_expectancy
WHERE country LIKE '%unite%';












