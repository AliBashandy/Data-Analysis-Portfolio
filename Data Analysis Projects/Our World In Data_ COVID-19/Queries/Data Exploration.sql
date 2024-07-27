SELECT * FROM owid_covid19.owid_covid_clone;

#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#
# Looking at number of Cases and deaths and population by location
# Continent names have been found in the location columns during exploring the dataset.
# The numbers of thaose rows are tend to be more accurate than if the numbers in continent been aggregated by checking the numbers. 
SELECT 
    location, date, total_cases, total_deaths, population
FROM
    owid_covid_clone
ORDER BY 1 , 2
;
#-------------------------------------------------------------------#
# Percentage of total deaths to total cases per location per year
SELECT 
    location,
    YEAR(`date`) AS `year`,
    MONTHNAME(`date`) AS `month`,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_Deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS deaths_percentage,
    (SUM(new_cases) / SUM(population)) * 100 AS cases_percentage
FROM
    owid_covid_clone
WHERE
    continent IS NOT NULL
GROUP BY location , `year` , `month`
ORDER BY location , `year` , FIELD(`month`,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December')
;

#-------------------------------------------------------------------#
# Highest and Lowest infection rates
SELECT 
    continent,
    location,
    YEAR(`date`) AS `year`,
    MONTHNAME(`date`) AS `month`,
    MAX(total_cases) AS total_cases,
    MAX(population) AS population,
    MAX((total_cases / population) * 100) AS infection_percentage
FROM
    owid_covid_clone
WHERE
    continent IS NOT NULL
GROUP BY continent , location , `year` , `month`
ORDER BY continent , location , `year` , FIELD(`month`,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December')
;

#-------------------------------------------------------------------#
# Highest and Lowest deaths rates
SELECT 
    continent,
    location,
    YEAR(`date`) AS `year`,
    MONTHNAME(`date`) AS `month`,
    MAX(population) AS population,
    MAX(total_deaths) AS total_deaths,
    MAX((total_deaths / population) * 100) AS deaths_percentage
FROM
    owid_covid_clone
WHERE
    continent IS NOT NULL
GROUP BY continent , location , `year` , `month`
ORDER BY continent , location , `year` , FIELD(`month`,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December')
;

#--------------------------------------------------------#
#Numbers per Continent
SELECT 
    location AS continent,
    YEAR(`date`) AS `year`,
    MONTHNAME(`date`) AS `month`,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths
FROM
    owid_covid_clone
WHERE
    continent IS NULL
        AND location NOT LIKE '%income%'
GROUP BY location , `year` , `month`
ORDER BY location , `year` , FIELD(`month`,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December')
        ;
    
    #Numbers by Income
SELECT 
    location AS Income,
    YEAR(`date`) AS `year`,
    MONTHNAME(`date`) AS `month`,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths
FROM
    owid_covid_clone
WHERE
    continent IS NULL
        AND location LIKE '%income%'
GROUP BY location , `year` , `month`
ORDER BY location , `year` , FIELD(`month`,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December')
;




SELECT 
	MAX(total_cases),
    SUM(total_deaths),
    MAX(total_cases),
    MAX(total_deaths),
    SUM(new_cases),
    SUM(new_deaths)
FROM
    owid_covid_clone
WHERE
    continent IS NOT NULL
;

