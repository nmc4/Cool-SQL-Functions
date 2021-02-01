SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[RegexMatches](@Text NVARCHAR(255), @RegexConvention NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN

DECLARE @MatchText AS NVARCHAR(255)
DECLARE @MatchText_Final AS NVARCHAR(255)
DECLARE @MatchIndex AS INT
DECLARE @Counter AS INT = 0

SET @MatchText_Final = ''
SET @MatchText = SUBSTRING(@Text, PATINDEX('' + @RegexConvention + '', @Text), LEN(@RegexConvention))
SET @MatchIndex = PATINDEX('' + @RegexConvention + '', @Text)

WHILE @MatchIndex > 0 AND @Counter < 50
BEGIN
    SET @Counter = @Counter + 1
	SET @MatchText_Final = @MatchText
	SET @MatchText = SUBSTRING(@MatchText, 0, LEN(@MatchText))
	SET @MatchIndex = PATINDEX('' + @RegexConvention + '', @MatchText)
END

RETURN @MatchText_Final
END
GO