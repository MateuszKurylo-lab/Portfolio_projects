SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

-- DATA CLEANING


-- Loking for duplicates

SELECT id, count(id)
FROM us_household_income
GROUP BY id
HAVING count(id) > 1;


-- deleting duplicates 

DELETE FROM us_household_income
WHERE row_id IN(
	SELECT row_id
	FROM
		(SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income) as duplicates
	WHERE row_num > 1);
    
-- standardizing State names

Select State_name, COUNT(state_name)
FROM us_household_income
GROUP BY state_name;

-- fixing misspelled Georgia
UPDATE us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia';

-- looking for nulls in place column

SELECT *
FROM us_household_income
WHERE place is null;

-- standardzing it

SELECT county, city, place
FROM us_household_income
WHERE county = 'Autauga County' AND city = 'Vinemont';

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE county = 'Autauga County'
AND city = 'Vinemont';

-- Standardizing type column

SELECT type, COUNT(type)
FROM us_household_income
group BY type
order by 1;

-- correcting typo

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';

-- making sure everything else is okey

SELECT Aland, AWater
FROM us_household_income
WHERE (Aland = 0 OR Aland = '' OR Aland IS NULL)
AND (AWater = 0 OR AWater = '' OR AWater IS NULL);

-- looking for incorrect data in statistics table 


-- DATA CLEANED 

-- EDA

-- top 10 states by land 

SELECT State_Name, SUM(Aland), SUM(Awater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 desc
LIMIT 10;

-- top 10 states by water

SELECT State_Name, SUM(Aland), SUM(Awater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 desc
LIMIT 10;

-- TOP 10 states by highiest AVG Mean

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 2 desc
LIMIT 10;

-- TOP 10 states by highiest AVG Median

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 3 desc
LIMIT 10;

-- comparing types and thier Mean

SELECT u.type, ROUND(AVG(Mean),1), ROUND(AVG(Median),1), COUNT(type) as quantity
FROM us_household_income u
JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE mean <> 0
GROUP BY u.type
ORDER BY 3 desc
;

-- now only for higher volume types
SELECT u.type, ROUND(AVG(Mean),1), ROUND(AVG(Median),1), COUNT(type) as quantity
FROM us_household_income u
JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE mean <> 0
GROUP BY u.type
HAVING count(Type) > 100
ORDER BY 3 desc
;

-- Comapring salaries by State and City
 
SELECT u.State_Name, City, round(avg(mean),1)
FROM us_household_income u
JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE mean <> 0
GROUP BY u.State_Name, City
ORDER BY 3 desc
limit 10