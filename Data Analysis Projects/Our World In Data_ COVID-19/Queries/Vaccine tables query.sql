SELECT * FROM owid_covid19.owid_covid_vaccination;

# Columns were recognised as varchar which can make issues during calculations so all of them converted to double

# I checked the output buy nested query to verify the numbers accuracy
# Vaccine table for visualization #
/*
SELECT
SUM(tbf.new_vaccination),
SUM(tbf.new_people_vaccinated),
SUM(tbf.new_people_fully_vaccinated),
SUM(tbf.new_boosters)
FROM(
*/
SELECT
tbm.iso_code, 
tbm.continent, 
tbm.location, 
tbm.`date`, 
tbm.total_population, 
tb1.new_population, 
tbm.total_vaccinations, 
tb2.new_vaccination,
tbm.people_vaccinated,
tb3.new_people_Vaccinated,
tbm.people_fully_vaccinated,
tb4.new_people_fully_vaccinated,
tbm.total_boosters,
tb5.new_boosters
FROM(
Select
iso_code, 
continent,
location,
`date`,
population AS total_population ,
convert(total_vaccinations, DOUBLE) AS total_vaccinations,
convert(people_vaccinated, DOUBLE) AS people_vaccinated,
convert(people_fully_vaccinated, DOUBLE) AS people_fully_vaccinated,
convert(total_boosters, DOUBLE) AS total_boosters
FROM owid_covid19.owid_covid_vaccination
WHERE continent IS NOT NULL
ORDER BY continent, location, `date`) as tbm
LEFT JOIN
(
SELECT 
    location,`date`,
    convert(population, double) - LAG(convert(population, double),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_population
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND population Is NOT NULL
    AND population != 0
ORDER BY continent, location, `date`
        )AS tb1
ON tbm.location = tb1.location
AND tbm.`date` = tb1.`date`
LEFT JOIN
(
SELECT 
    location,`date`,
    convert(total_vaccinations, double) - LAG((convert(total_vaccinations, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_vaccination
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND total_vaccinations Is NOT NULL
    AND total_vaccinations != 0
ORDER BY continent, location, `date`
        )AS tb2
        
ON tbm.location = tb2.location
AND tbm.`date` = tb2.`date`
LEFT JOIN
(
SELECT 
    location,`date`,
    convert(people_vaccinated, double) - LAG((convert(people_vaccinated, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_people_vaccinated
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND people_vaccinated Is NOT NULL
    AND People_Vaccinated != 0
ORDER BY continent, location, `date`
        )AS tb3
ON tbm.location = tb3.location
AND tbm.`date` = tb3.`date`
LEFT JOIN
(
SELECT 
    location,`date`,
    convert(people_fully_vaccinated, double) - LAG((convert(people_fully_vaccinated, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_people_fully_vaccinated
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND people_fully_vaccinated Is NOT NULL
    AND People_fully_Vaccinated != 0
ORDER BY continent, location, `date`
        )AS tb4
ON tbm.location = tb4.location
AND tbm.`date` = tb4.`date`
LEFT JOIN
(
SELECT 
    location,`date`,
    convert(total_boosters, double) - LAG((convert(total_boosters, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_boosters
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND total_boosters Is NOT NULL
    AND total_boosters != 0
ORDER BY continent, location, `date`
        )AS tb5
ON tbm.location = tb5.location
AND tbm.`date` = tb5.`date`
#) tbf
;

#--------------------------------------------------------------------------------------------------------------#        
# Getting Vaccinations by continent from location column is more accurate
#Also some rows categorized by income type or unions not continent so we will separate them
# I checked the output buy nested query to verify the numbers accuracy
##Select
##tb1.continent,
##SUM(tb1.new_vaccination),
##MAX(tb1.total_vaccinations)
##FROM(        
 SELECT 
    iso_code,location AS continent,`date`,
    MAX(population) As population,
    MAX(people_vaccinated) As people_vaccinated,
    MAX(people_fully_vaccinated) AS people_fully_vaccinated,
    MAX(convert(total_vaccinations, double)) AS total_vaccinations ,
    MAX(convert(total_vaccinations, double)) - LAG(MAX(convert(total_vaccinations, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_vaccination,
    MAX(convert(total_boosters, double)) AS total_boosters
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NULL
    AND location NOT LIKE '%income%'
    AND location NOT LIKE '%Union%'
    #AND people_vaccinated Is NOT NULL
    #AND people_fully_vaccinated Is NOT NULL
    # AND total_boosters !=0
    AND total_vaccinations Is NOT NULL
    AND total_vaccinations != 0
GROUP BY iso_code,location,`date`
ORDER BY location, `date`
 ##       )AS tb1
 ## WHERE tb1.continent = 'Africa'        
        ;        
# This will get the vaccination by income type        
SELECT 
    iso_code,location AS income_category,`date`,
    MAX(population) As population,
    MAX(people_vaccinated) As people_vaccinated,
    MAX(people_fully_vaccinated) AS people_fully_vaccinated,
    MAX(convert(total_vaccinations, double)) AS total_vaccinations ,
    MAX(convert(total_vaccinations, double)) - LAG(MAX(convert(total_vaccinations, double)),1,0) OVER(PARTITION BY location ORDER BY location, `date`)As new_vaccination,
    MAX(convert(total_boosters, double)) AS total_boosters
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NULL
    AND location LIKE '%income%'
    #AND people_vaccinated Is NOT NULL
    #AND people_fully_vaccinated Is NOT NULL
    #AND total_boosters Is NOT NULL
    AND total_vaccinations Is NOT NULL
    AND total_vaccinations != 0
GROUP BY iso_code,location,`date`
ORDER BY location, `date`
        ;        
#---------------------------------------------------------------------------------------        
SELECT
iso_code,continent,location,`date`,
    MAX(population) AS population,        
	MAX(convert(people_vaccinated, double)) AS people_vaccinated ,
    MAX(convert(people_fully_vaccinated, double)) AS people_fully_vaccinated 
    FROM owid_covid19.owid_covid_vaccination
    WHERE continent IS NOT NULL
    AND people_vaccinated Is NOT NULL
    AND people_fully_vaccinated Is NOT NULL
    #AND total_boosters Is NOT NULL
    #AND total_vaccinations Is NOT NULL
    #AND total_vaccinations != 0
GROUP BY iso_code,continent,location,`date`
ORDER BY continent, location, `date`
;
