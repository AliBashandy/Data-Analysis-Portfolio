create table fitbit.dailyusage_user
select
	Id,
	ActivityDate ,
	active_minutes,
	case
		when (active_minutes/ 1440)* 100 = 100 then "All day user"
		when (active_minutes / 1440)* 100 < 100
		and (active_minutes / 1440)* 100 >= 50 then "Half day user"
		else "Less than hald day user"
	end as type_user
from
	(
	select
		Id,
		ActivityDate,
		VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes as active_minutes
	from
		fitbit.dailyactivity_merged
) as activeminutes