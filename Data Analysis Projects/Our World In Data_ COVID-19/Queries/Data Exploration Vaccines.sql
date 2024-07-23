## Looking at Vaccination status 

SELECT * FROM owid_covid19.owid_covid_clone;
# Calculation of new vaccination from total_vaccination coulumn gave more accurate numbers
# Columns were recognised as varchar which can make issues during calculations so all of them converted to double
SELECT 
    location,
    YEAR(`date`) AS `year`,
    MONTH(`date`) AS `month`,
    MAX(convert(population, double)) AS population,
    MAX(convert(people_vaccinated, double)) AS people_vaccinated ,
    MAX(convert(people_fully_vaccinated, double)) AS people_fully_vaccinated ,
    MAX(convert(total_boosters, double)) AS total_boosters,
    MAX(convert(total_vaccinations, double)) AS total_vaccinations ,
    MAX(convert(total_vaccinations, double)) - LAG(MAX(convert(total_vaccinations, double)),1,0) OVER(PARTITION BY location ORDER BY location, YEAR(`date`), MONTH(`date`))As new_vaccination
    FROM owid_covid19.owid_covid_clone
    WHERE continent IS NOT NULL
    AND people_vaccinated Is NOT NULL
    #AND people_fully_vaccinated Is NOT NULL
    #AND total_boosters Is NOT NULL
    AND total_vaccinations Is NOT NULL
GROUP BY location , `year` , `month`
ORDER BY location , `year` , `month`
        ;