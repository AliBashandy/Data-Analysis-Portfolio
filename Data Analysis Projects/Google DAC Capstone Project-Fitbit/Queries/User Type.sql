create table user_type
select Id,
count(ActivityDate) as number_days,
case
	when count(ActivityDate) > 20 then "high usage"
	when count(ActivityDate) > 10
	and count(ActivityDate) <= 20 then "moderate usage"
	when count(ActivityDate) >= 1
	and count(ActivityDate) <= 10 then "low usage"
	end as user_category
from
		dailyactivity_merged
group by
	Id

#determine user type based on daily usage