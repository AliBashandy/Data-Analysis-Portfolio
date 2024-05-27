update
	hourlycalories_merged,
	hourlyintensities_merged,
	hourlysteps_merged
set
	hourlycalories_merged.ActivityHour = str_to_date(hourlycalories_merged.ActivityHour,
	'%m/%d/%Y %r'),
	hourlyintensities_merged.ActivityHour = str_to_date(hourlyintensities_merged.ActivityHour,
	'%m/%d/%Y %r'),
	hourlysteps_merged.ActivityHour = str_to_date(hourlysteps_merged.ActivityHour,
	'%m/%d/%Y %r')