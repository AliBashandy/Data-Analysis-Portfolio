DROP TABLE IF exists hourlyactivity_merged;

CREATE TABLE hourlyactivity_merged;

select
	A.Id,
	A.ActivityHour,
	A.Calories,
	B.TotalIntensity,
	B.AverageIntensity,
	I.StepTotal
from
	`hourlycalories_merged` A
left join
 `hourlyintensities_merged` B
on
	A.Id = B.Id
	and
 A.ActivityHour = B.ActivityHour
left join
 `hourlysteps_merged` I
on
	A.Id = I.Id
	and
 A.ActivityHour = I.ActivityHour
