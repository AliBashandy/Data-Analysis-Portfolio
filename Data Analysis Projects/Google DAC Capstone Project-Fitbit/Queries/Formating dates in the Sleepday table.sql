update sleepday_merged
set SleepDay = str_to_date(SleepDay, '%m/%d/%Y %r')

update sleepday_merged 
set SleepDay = convert(sleepday, date)
