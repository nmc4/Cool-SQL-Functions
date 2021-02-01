SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UTCtoEST](@YourDate DATETIME)
RETURNS DATETIME 
AS   
BEGIN
DECLARE @DateTime DATETIME
DECLARE @YearStart AS DATETIME = DATEADD(yy, DATEDIFF(yy, 0, @YourDate), 0)
​​
SELECT @DateTime = CASE WHEN @YourDate >= DATEADD(HOUR, 7, a.[DST Start Date]) AND @YourDate < DATEADD(HOUR, 6, b.[DST End Date])
                        THEN DATEADD(HOUR,-4,@YourDate) 
			            ELSE DATEADD(HOUR,-5,@YourDate) END
FROM (
	SELECT DISTINCT TOP 1 DATEADD(WEEK, 1, DATEADD(DAY, /**/ CASE WHEN DATEPART(WEEKDAY ,DATEADD(MONTH, 2, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0))) = 1 THEN 0 ELSE 8 - DATEPART(WEEKDAY ,DATEADD(MONTH, 2, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0))) END, /**/ DATEADD(MONTH, 2, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0)))) AS 'DST Start Date') AS a
INNER JOIN (
	SELECT DISTINCT TOP 1 DATEADD(DAY, /**/ CASE WHEN DATEPART(WEEKDAY ,DATEADD(MONTH, 10, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0))) = 1 THEN 0 ELSE 8 - DATEPART(WEEKDAY ,DATEADD(MONTH, 10, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0))) END, /**/ DATEADD(MONTH, 10, DATEADD(yy, DATEDIFF(yy, 0, @YearStart), 0))) AS 'DST End Date') AS b
ON DATEPART(YEAR, a.[DST Start Date]) = DATEPART(YEAR, b.[DST End Date])
WHERE DATEPART(YEAR, a.[DST Start Date]) =  DATEPART(YEAR, @YourDate)
​
RETURN @DateTime
END
GO