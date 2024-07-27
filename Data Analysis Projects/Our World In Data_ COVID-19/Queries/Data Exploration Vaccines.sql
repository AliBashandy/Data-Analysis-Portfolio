SELECT * 
FROM owid_covid19.owid_covid_clone
;
#________________________________________________________________________#
#01_Checking total vaccination

## Checking the total from new_vaccinations_smoothed column
#---------------------------------------------------- 
SELECT sum(convert(new_vaccinations_smoothed,double))
 FROM owid_covid19.owid_covid_clone
 WHERE continent is not null
 
 union
 
 ## Checking the total from total_vaccinations column
 #----------------------------------------------------
 SELECT SUM(tb1.vac)
 FROM(
SELECT ## Checking the total from total_vaccinations column 
MAX(convert(total_vaccinations,double)) vac
FROM owid_covid19.owid_covid_clone
WHERE continent is not null
GROUP BY location) tb1
;
## The results are not the same so i will make new smooth column from total_vaccinations column
#________________________________________________________________________# 
 
#02_Checking people vaccinated

Select SUM(tb1.ppl_vac)
FROM(
 SELECT location, MAX(convert(people_vaccinated,double)) AS ppl_vac
 FROM owid_covid19.owid_covid_clone
 WHERE continent is not null
 GROUP BY location) tb1
 
 UNION
 
 SELECT sum(convert(new_people_vaccinated_smoothed,double))
 FROM owid_covid19.owid_covid_clone
 WHERE continent is not null;
 ## The results are not the same so i will make new smooth column from people_vaccinated column
 
 SELECT SUM(tb1.ful_vac)
 FROM(
 SELECT MAX(convert(people_fully_vaccinated,double)) ful_vac
 FROM owid_covid19.owid_covid_clone
 WHERE continent is not null
 GROUP BY location)tb1
 ;
 # There is no smothed values column for this so it will be created for reporting usage
 
 #03_Checking total boosters
 SELECT SUM(tb1.t_boost)
 FROM(
 SELECT MAX(convert(total_boosters,double)) t_boost
 FROM owid_covid19.owid_covid_clone
 WHERE continent is not null
 GROUP BY location)tb1
 ;
# There is no smothed values column for this so it will be created for reporting usage
 