Drop table if exists fitbit.UsersleepusageCategory;
Create table fitbit.UsersleepusageCategory
Select Id, Number_of_Days,
CASE
WHEN Number_Of_Days >=1 and Number_Of_Days < 15 THEN 'Less Than Half of Nights User'
WHEN Number_Of_Days >= 15 and Number_Of_Days < 31 THEN 'More Than Half of Nights User'
WHEN Number_Of_Days >= 31 THEN 'Every Night User'
Else 'No Data'
END AS 'User Category'
From(
Select Id,
count(CASE WHEN TotalMinutesAsleep != "NO DATA" then ActivityDate END) As 'Number_of_Days'
From sleepvsactive_minutes
Group BY Id
) As sleepdays
Group By Id
