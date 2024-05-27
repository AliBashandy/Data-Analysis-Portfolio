UPDATE fitbit.minuteintensitiesnarrow_merged
SET ActivityMinute = str_to_date(ActivityMinute, '%m/%d/%Y %r');

UPDATE fitbit.minutecaloriesnarrow_merged
SET ActivityMinute = str_to_date(ActivityMinute, '%m/%d/%Y %r');

UPDATE fitbit.minutestepsnarrow_merged
SET ActivityMinute = str_to_date(ActivityMinute, '%m/%d/%Y %r');

UPDATE fitbit.minutemetsnarrow_merged
SET ActivityMinute = str_to_date(ActivityMinute, '%m/%d/%Y %r');