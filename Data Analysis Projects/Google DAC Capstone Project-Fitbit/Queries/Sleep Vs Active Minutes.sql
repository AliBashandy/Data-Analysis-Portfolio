create table fitbit.SleepVSactive_minutes
select 
A.Id,
A.ActivityDate,
IFNULL(B.TotalMinutesAsleep,"NO DATA") as TotalMinutesAsleep,
IFNULL(B.TotalTimeInBed, "NO DATA") as TotalMinutesInBed,
IFNULL(B.TotalTimeInBed - B.TotalMinutesAsleep, "No DATA") as MinutesToSleep,
C.active_minutes as ActiveMinutes
from dailyactivity_merged A
left join
sleepday_merged B
on
A.Id = B.Id
and 
A.ActivityDate = B.SleepDay
left join
dailyusage_user C
on
A.Id = C.Id
and 
A.ActivityDate = C.ActivityDate 

