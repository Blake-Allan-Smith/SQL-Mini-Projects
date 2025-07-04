## Used World Life Expectancy CSV

SELECT * 
FROM worldlifeexpectancy;


#Deleting duplicates from dataset
SELECT Country, Year, COUNT(CONCAT(Country, Year))
FROM worldlifeexpectancy
GROUP BY Country, Year
HAVING COUNT(CONCAT(Country, Year)) > 1;

SELECT *
FROM
	(SELECT Row_ID, 
	CONCAT(Country, Year), ROW_NUMBER() OVER(PARTITION BY CONCAT(	Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM worldlifeexpectancy) as row_table 
WHERE row_num > 1;

DELETE FROM worldlifeexpectancy
WHERE Row_ID IN (
	SELECT Row_ID
FROM
	(SELECT Row_ID, 
	CONCAT(Country, Year), ROW_NUMBER() OVER(PARTITION BY CONCAT(	Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM worldlifeexpectancy) as row_table 
WHERE row_num > 1);

SELECT *
FROM worldlifeexpectancy
WHERE status = '';

#Filling in missing values with data           
UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developing';

UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developed';

SELECT *
FROM worldlifeexpectancy
WHERE status = '';

SELECT *
FROM worldlifeexpectancy;

#Taking Averages of preious year and future year to create an average for missing life expectancies
SELECT * 
FROM worldlifeexpectancy
WHERE `Life expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
	t2.Country, t2.Year, t2.`Life expectancy`,
	t3.Country, t3.Year, t3.`Life expectancy`,
	ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) AS avg_age
	FROM worldlifeexpectancy t1
	JOIN worldlifeexpectancy t2
		ON t1.Country = t2.Country
		AND t1.Year = t2.Year - 1
	JOIN worldlifeexpectancy t3
		ON t1.Country = t3.Country
		AND t1.Year = t3.Year + 1
	WHERE t1.`Life expectancy` = '';
    
UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) 
WHERE t1.`Life expectancy` = '';

SELECT *
FROM worldlifeexpectancy;
