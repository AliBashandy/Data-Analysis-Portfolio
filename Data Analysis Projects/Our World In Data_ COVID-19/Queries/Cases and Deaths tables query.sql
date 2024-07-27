# Quering cases and deaths data for counries excluding continents and income rows which are located on the location column in the data set
SELECT * FROM owid_covid19.owid_covid_cases_deaths
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL;

#Quering cases and deaths data for continents from location column because its more accurate
SELECT iso_code, location AS Continent, population, `date`,total_cases,new_cases,total_deaths
FROM owid_covid19.owid_covid_cases_deaths
WHERE continent IS NULL
AND Location NOT LIKE '%income%'
AND total_cases IS NOT NULL
;

#Quering cases and deaths data for income category from location column
SELECT iso_code, location AS Continent, population, `date`,total_cases,new_cases,total_deaths
FROM owid_covid19.owid_covid_cases_deaths
WHERE continent IS NULL
AND Location LIKE '%income%'
AND total_cases IS NOT NULL
;