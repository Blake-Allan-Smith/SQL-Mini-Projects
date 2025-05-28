SELECT *
FROM worldlifeexpectancy;

#High and Low Life Expectancies
SELECT Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM worldlifeexpectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) > 0
AND MAX(`Life expectancy`) > 0
ORDER BY Country DESC;

#Difference Between High and Low Life Expectancies
SELECT Country, ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS expectancy_gap
FROM worldlifeexpectancy
GROUP BY Country
ORDER BY MAX(`Life expectancy`) - MIN(`Life expectancy`) DESC;

#Country Life Expectancies
SELECT Year, ROUND(AVG(`Life expectancy`), 2)
FROM worldlifeexpectancy
GROUP BY Year
ORDER BY Year; 

#Life Expectancy and Average GPD
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_EXP, ROUND(AVG(GDP),1) AS GDP
FROM worldlifeexpectancy
GROUP BY Country
HAVING GDP > 0
AND Life_EXP > 0
ORDER BY GDP;


#Correlation with GDP and Life Expectancy
SELECT
	SUM(CASE
			WHEN GDP >= 1500 THEN 1
			ELSE 0
			END) High_GDP_Count,
	AVG(CASE
			WHEN GDP >= 1500 THEN `life expectancy` 
            ELSE NULL END) High_GDP_Life_Expectancy,
	SUM(CASE
				WHEN GDP <= 1500 THEN 1
				ELSE 0
				END) Low_GDP_Count,
	AVG(CASE
			WHEN GDP <= 1500 THEN `life expectancy` 
            ELSE NULL END) Low_GDP_Life_Expectancy
FROM worldlifeexpectancy;

#Correlation Between Status and Life Expectancy
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy
GROUP BY Status;

#Correlation Between Status and Development Status
SELECT Status, COUNT(DISTINCT(Country))
FROM worldlifeexpectancy
GROUP BY Status;

#Correlation Between BMI and Life Expectancy
SELECT Country, ROUND(AVG(BMI),1) AS BMI, ROUND(AVG(`Life expectancy`),1) AS Life_EXP 
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_EXP > 0
AND BMI > 0
ORDER BY BMI DESC;

#Rolling Total of Country Adult Mortalities
SELECT Country, Year, `Life expectancy`, `Adult Mortality`, ROUND(SUM(`Life expectancy`) OVER(PARTITION BY Country ORDER BY Year),1) AS rolling_total
FROM worldlifeexpectancy
;
