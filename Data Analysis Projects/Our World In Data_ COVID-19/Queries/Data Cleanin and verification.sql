#+----------------------------------------------------------------------------------------------------------+#
# First Create clone table to work at
DROP TABLE IF Exists owid_covid_clone;
CREATE TABLE owid_covid_clone 
SELECT *
FROM owid_covid_data
;
#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#

# Check for duplicates and Drop them
With duplicate_checker AS(
SELECT
	*, ROW_NUMBER() 
	OVER(
		PARTITION BY iso_code, continent, location,
		`date`, total_cases, new_cases, new_cases_smoothed, total_deaths,
		new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million,
		new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million,
		new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million,
		hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
		weekly_hosp_admissions, weekly_hosp_admissions_per_million,
		total_tests, new_tests, total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed,
		new_tests_smoothed_per_thousand, positive_rate, tests_per_case,
		tests_units, total_vaccinations, people_vaccinated, people_fully_vaccinated,
		total_boosters, new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred,
		people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred,
		total_boosters_per_hundred, new_vaccinations_smoothed_per_million,
		new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred,
		stringency_index, population_density, median_age,
		aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate,
		diabetes_prevalence, female_smokers,
		male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy,
		human_development_index, population, excess_mortality_cumulative_absolute,
		excess_mortality_cumulative, excess_mortality, excess_mortality_cumulative_per_million
		)AS row_num
	FROM owid_covid_clone
	)
SELECT
	*
FROM
	duplicate_checker
where row_num > 1
;
# No rows returned so no duplicates found

#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#
# Format Date column
Select `date`,
str_to_date(`date`,'%Y-%m-%d')
FROM owid_covid_clone;

UPDATE owid_covid_clone
SET `date`= str_to_date(`date`,'%Y-%m-%d')
;
Alter TABLE owid_covid_clone
MODIFY COLUMN `date` DATE;
#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#
# To change the empty cells in continent columns to NULL
SELECT continent,
continent = NULL
FROM owid_covid_clone
WHERE continent is not NULL
AND length(continent) = 0 
;

UPDATE owid_covid_clone
SET continent = NULL
WHERE continent is not NULL
AND length(continent) = 0 
;
#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#
Select *
FROM owid_covid_clone;
#+----------------------------------------------------------------------------------------------------------+#
#+----------------------------------------------------------------------------------------------------------+#
# Due to late records of vaccines, all empty cells of vaccibe related columns will be filled with null

UPDATE owid_covid_clone 
SET 
    total_vaccinations = NULL,
    people_vaccinated = NULL,
    people_fully_vaccinated = NULL,
    total_boosters = NULL
WHERE
    LENGTH(total_vaccinations) = 0
AND LENGTH(people_vaccinated) = 0
AND LENGTH(people_fully_vaccinated) = 0
AND LENGTH(total_boosters) = 0
