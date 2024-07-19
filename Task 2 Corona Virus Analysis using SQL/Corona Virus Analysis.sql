
-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT * FROM [Corona Virus Dataset]
WHERE Province IS NULL OR 
      Country_Region IS NULL OR 
      Latitude IS NULL OR 
      Longitude IS NULL OR 
      Date IS NULL OR 
      Confirmed IS NULL OR 
      Deaths IS NULL OR 
      Recovered IS NULL;

-- Q2. If NULL values are present, update them with zeros for all columns.
-- Since there are no values present, we do not need to update the columns with zeros.

-- Q3. check total number of rows
SELECT COUNT(*) AS Total_Rows FROM [Corona Virus Dataset]; 

-- Q4. Check what is start_date and end_date
SELECT MIN(Date) AS Start_Date, MAX(Date) AS End_Date
FROM [Corona Virus Dataset];

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT CONCAT(Year(Date),' ',Month(Date))) 
AS Total_Months FROM [Corona Virus Dataset]

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT DATEPART(YEAR,Date) AS Year,
DATEPART(MONTH,Date) AS Month_count, DATENAME(MONTH,Date) AS Month_name,
AVG(Confirmed) AS Average_confirmed_case,
AVG(Deaths) AS Average_deaths_case,
AVG(Recovered) AS Average_Recovered_case FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR,Date) , DATEPART(MONTH,Date),
DATENAME(MONTH,Date)
ORDER BY Year ,Month_count;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
WITH CTE AS (
    SELECT
        DATEPART(YEAR,Date) AS Year,
        DATEPART(MONTH,Date) AS Month_count, 
		DATENAME(MONTH,Date) AS Month_name,
        Confirmed, Deaths, Recovered,
        RANK() OVER (PARTITION BY DATEPART(YEAR,Date), DATEPART(MONTH,Date), DATEPART(MONTH,Date) ORDER BY Confirmed DESC) AS RANK_Confirmed,
        RANK() OVER (PARTITION BY DATEPART(YEAR,Date), DATEPART(MONTH,Date), DATEPART(MONTH,Date) ORDER BY Deaths DESC) AS RANK_Deaths,
        RANK() OVER (PARTITION BY DATEPART(YEAR,Date), DATEPART(MONTH,Date), DATEPART(MONTH,Date) ORDER BY Recovered DESC) AS RANK_Recovered
    FROM [Corona Virus Dataset]
)
SELECT
    Year, Month_count, Month_name,
    MAX(CASE WHEN RANK_Confirmed = 1 THEN Confirmed END) AS Most_Frequent_Confirmed,
    MAX(CASE WHEN RANK_Deaths = 1 THEN Deaths END) AS Most_Frequent_Deaths,
    MAX(CASE WHEN RANK_Recovered = 1 THEN Recovered END) AS Most_Frequent_Recovered
FROM CTE
GROUP BY Year, Month_count, Month_name
ORDER BY Year, Month_count, Month_name;


-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT DATEPART(YEAR,Date) AS Year, 
MIN(Confirmed) AS Minimum_Confirmed,
MIN(Deaths) AS Minimum_Deaths,
MIN(Recovered) AS Minimum_Recovered 
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR,Date)


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT DATEPART(YEAR,Date) AS Year, 
MAX(Confirmed) AS Maximum_Confirmed,
MAX(Deaths) AS Maximum_Deaths,
MAX(Recovered) AS Maximum_Recovered 
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR,Date);


-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT DATEPART(YEAR,Date) AS Year, 
DATEPART(MONTH,Date) AS Month_Count, 
DATENAME(MONTH,Date) AS Month_Name,
SUM(Confirmed) AS Total_Confirmed,
SUM(Deaths) AS Total_Deaths,
SUM(Recovered) AS Total_Recovered
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR,Date),DATEPART(MONTH,Date),DATENAME(MONTH,Date)
ORDER BY Year,Month_Count;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT SUM(Confirmed) AS Total_Confirmed,
AVG(Confirmed) AS Avearge_Confirmed,
VAR(Confirmed) AS Variance_Confirmed,
STDEV(Confirmed) AS STDEV_Confirmed
FROM [Corona Virus Dataset];


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT DATEPART(YEAR,Date) AS Year, 
DATEPART(MONTH,Date) AS Month_Count, 
DATENAME(MONTH,Date) AS Month_Name,
SUM(Deaths) AS Total_Deaths,
ROUND(AVG(Deaths), 3) AS Avearge_Deaths,
ROUND(VAR(Deaths), 3) AS Variance_Deaths,
ROUND(STDEV(Deaths), 3) AS STDEV_DeathsDeaths
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR,Date),DATEPART(MONTH,Date),DATENAME(MONTH,Date)
ORDER BY Year,Month_Count;


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT SUM(Recovered) AS Total_Recovered,
ROUND(AVG(Recovered), 3) AS Avearge_Recovered,
ROUND(VAR(Recovered), 3) AS Variance_Recovered,
ROUND(STDEV(Recovered), 3) AS STDEV_Recovered
FROM [Corona Virus Dataset];


-- Q14. Find Country having highest number of the Confirmed case
WITH CTE AS (SELECT Country_Region AS Country,
	SUM(Confirmed) AS Total_Confirmed FROM [Corona Virus Dataset]
	GROUP BY Country_Region),

Max_Confirmed AS (SELECT MAX(Total_Confirmed) AS Max_Total_Confirmed FROM CTE)
SELECT CTE.Country, CTE.Total_Confirmed FROM CTE
JOIN Max_Confirmed AS mc ON CTE.Total_Confirmed = mc.Max_Total_Confirmed
ORDER BY CTE.Country;


-- Q15. Find Country having lowest number of the death case
WITH CTE AS (SELECT Country_Region AS Country,
	SUM(Deaths) AS Total_Deaths FROM [Corona Virus Dataset]
	GROUP BY Country_Region),

Min_Deaths AS (SELECT MIN(Total_Deaths) AS Min_Total_Deaths FROM CTE)
SELECT CTE.Country, CTE.Total_Deaths FROM CTE
JOIN Min_Deaths AS md ON CTE.Total_Deaths = md.Min_Total_Deaths
ORDER BY CTE.Country;



-- Q16. Find top 5 countries having highest recovered case
SELECT TOP 5 Country_Region AS Country,
SUM(Recovered) AS Highest_Recovered
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY Highest_Recovered DESC;
