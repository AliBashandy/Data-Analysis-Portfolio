CREATE TABLE minutesactivity_merged SELECT A.Id,
    A.ActivityMinute,
    A.Calories,
    B.Intensity,
    I.Steps,
    E.METs FROM
    fitbit.minutecaloriesnarrow_merged A
        LEFT JOIN
    fitbit.minuteintensitiesnarrow_merged B ON A.Id = B.Id
        AND A.ActivityMinute = B.ActivityMinute
        LEFT JOIN
    fitbit.minutestepsnarrow_merged I ON A.Id = I.Id
        AND A.ActivityMinute = I.ActivityMinute
        LEFT JOIN
    fitbit.minutemetsnarrow_merged E ON A.Id = E.Id
        AND A.ActivityMinute = E.ActivityMinute