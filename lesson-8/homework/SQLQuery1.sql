CREATE TABLE StepStatus (
    StepNumber INT,
    Status VARCHAR(10)
);

INSERT INTO StepStatus (StepNumber, Status)
VALUES
(1, 'Passed'),
(2, 'Passed'),
(3, 'Passed'),
(4, 'Passed'),
(5, 'Failed'),
(6, 'Failed'),
(7, 'Failed'),
(8, 'Failed'),
(9, 'Failed'),
(10, 'Passed'),
(11, 'Passed'),
(12, 'Passed');


CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
);

INSERT INTO [dbo].[EMPLOYEES_N] ([EMPLOYEE_ID], [FIRST_NAME], [HIRE_DATE])
VALUES 
(101, 'Alice', '2020-01-15'),
(102, 'Bob', '2019-07-23'),
(103, 'Charlie', '2021-03-10'),
(104, 'Diana', '2022-08-05'),
(105, 'Edward', '2018-11-30'),
(106, 'Fiona', '2023-02-18'),
(107, 'George', '2017-05-27'),
(108, 'Helen', '2020-12-01'),
(109, 'Ivan', '2016-09-14'),
(110, 'Julia', '2024-04-03');

--task1

WITH Numbered AS (
    SELECT 
        StepNumber,
        Status,
        ROW_NUMBER() OVER (ORDER BY StepNumber) AS rn
    FROM StepStatus
),
Grouped AS (
    SELECT 
        StepNumber,
        Status,
        rn - 
        ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StepNumber) AS grp
    FROM Numbered
),
Final AS (
    SELECT 
        MIN(StepNumber) AS [Min Step Number],
        MAX(StepNumber) AS [Max Step Number],
        Status,
        COUNT(*) AS [Consecutive Count]
    FROM Grouped
    GROUP BY Status, grp
)
SELECT *
FROM Final
ORDER BY [Min Step Number];

--task2

WITH DistinctYears AS (
    SELECT DISTINCT YEAR(HIRE_DATE) AS HireYear
    FROM [dbo].[EMPLOYEES_N]
),


GroupedYears AS (
    SELECT 
        HireYear,
        HireYear - ROW_NUMBER() OVER (ORDER BY HireYear) AS grp
    FROM DistinctYears
),

FinalRanges AS (
    SELECT 
        MIN(HireYear) AS StartYear,
        MAX(HireYear) AS EndYear
    FROM GroupedYears
    GROUP BY grp
)

SELECT 
    CONCAT(StartYear, ' - ', EndYear) AS [Years]
FROM FinalRanges
ORDER BY StartYear;
