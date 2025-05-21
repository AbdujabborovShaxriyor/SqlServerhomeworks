DECLARE @InputDate DATE = '2025-05-01';  -- User input date

-- Determine the first and last day of the month
DECLARE @FirstOfMonth DATE = DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1);
DECLARE @LastOfMonth DATE = EOMONTH(@FirstOfMonth);

-- Determine the calendar grid start date (Sunday on or before the first day)
DECLARE @CalendarStart DATE = DATEADD(DAY, - (DATEPART(WEEKDAY, @FirstOfMonth) - 1), @FirstOfMonth);

-- Determine the calendar grid end date (Saturday on or after the last day)
DECLARE @CalendarEnd DATE = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @LastOfMonth), @LastOfMonth);

-- Generate all dates in the full calendar range
WITH CalendarDates AS (
    SELECT @CalendarStart AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM CalendarDates
    WHERE CalendarDate < @CalendarEnd
),
CalendarWithMetadata AS (
    SELECT
        CalendarDate,
        (DATEDIFF(DAY, @CalendarStart, CalendarDate) / 7) + 1 AS WeekNumber,
        DATEPART(WEEKDAY, CalendarDate) AS WeekDay,
        -- Only show the day number if it belongs to the target month, else NULL
        CASE 
            WHEN MONTH(CalendarDate) = MONTH(@FirstOfMonth) THEN DAY(CalendarDate)
            ELSE NULL
        END AS DayNumber
    FROM CalendarDates
)
-- Pivot into calendar table with Sunday to Saturday columns
SELECT
    MAX(CASE WHEN WeekDay = 1 THEN DayNumber END) AS Sunday,
    MAX(CASE WHEN WeekDay = 2 THEN DayNumber END) AS Monday,
    MAX(CASE WHEN WeekDay = 3 THEN DayNumber END) AS Tuesday,
    MAX(CASE WHEN WeekDay = 4 THEN DayNumber END) AS Wednesday,
    MAX(CASE WHEN WeekDay = 5 THEN DayNumber END) AS Thursday,
    MAX(CASE WHEN WeekDay = 6 THEN DayNumber END) AS Friday,
    MAX(CASE WHEN WeekDay = 7 THEN DayNumber END) AS Saturday
FROM CalendarWithMetadata
GROUP BY WeekNumber
ORDER BY WeekNumber
OPTION (MAXRECURSION 1000);
