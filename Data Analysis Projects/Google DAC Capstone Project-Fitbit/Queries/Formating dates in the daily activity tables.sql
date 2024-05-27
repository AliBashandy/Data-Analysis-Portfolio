UPDATE dailyactivity_merged,
    dailycalories_merged,
    dailyintensities_merged,
    dailysteps_merged 
SET 
    dailyactivity_merged.ActivityDate = STR_TO_DATE(dailyactivity_merged.ActivityDate,
            '%m/%d/%Y'),
    dailycalories_merged.ActivityDay = STR_TO_DATE(dailycalories_merged.ActivityDay,
            '%m/%d/%Y'),
    dailyintensities_merged.ActivityDay = STR_TO_DATE(dailyintensities_merged.ActivityDay,
            '%m/%d/%Y'),
    dailysteps_merged.ActivityDay = STR_TO_DATE(dailysteps_merged.ActivityDay,
            '%m/%d/%Y')
