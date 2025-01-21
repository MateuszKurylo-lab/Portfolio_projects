SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(Id)
FROM us_household_income_statistics;

SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;


SELECT id
FROM (
SELECT id, COUNT(id) AS counted, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS num
FROM us_household_income
GROUP BY id) tbl
WHERE counted > 1;


SELECT row_id, id
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
FROM us_household_income
) dupili
WHERE row_num > 0;

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
		FROM us_household_income
		) dupili
	WHERE row_num > 1);
    
SELECT state_name, COUNT(state_name)
FROM us_household_income
GROUP BY State_Name
ORDER BY State_Name ASC;

UPDATE us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama';

SELECT DISTINCT State_ab, State_name
FROM us_household_income;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County';


UPDATE us_household_income
SET place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';


SELECT type, COUNT(type)
FROM us_household_income
GROUP BY Type
ORDER BY type ; 

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';


SELECT state_name,SUM(Awater), SUM(Aland)
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC 
;

SELECT *
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

SELECT u.state_name, County, Type, `Primary`, Mean, Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

SELECT u.state_name,ROUND(AVG(Mean),2) AS AVG_Mean, ROUND(AVG(Median),2) AS AVG_Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY AVG_Median DESC
LIMIT 5;

SELECT type,ROUND(AVG(Mean),2) AS AVG_Mean, ROUND(AVG(Median),2) AS AVG_Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.type
ORDER BY AVG_MEAN DESC
;

SELECT 
type,
COUNT(Type),
ROUND(AVG(Mean),2) AS AVG_Mean, 
ROUND(AVG(Median),2) AS AVG_Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.type
HAVING COUNT(Type) > 100
ORDER BY 3 DESC
;

SELECT u.State_Name, City,COUNT(City), ROUND(AVG(Mean),1) as AVG_money
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
HAVING AVG_money <> 0 
ORDER BY 4 DESC;
    
