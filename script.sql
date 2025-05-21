CREATE PROCEDURE salaryHistogram
    @intervals INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @minSalary FLOAT;
    DECLARE @maxSalary FLOAT;
    DECLARE @intervalSize FLOAT;
    DECLARE @i INT = 0;

    SELECT @minSalary = MIN(salary), @maxSalary = MAX(salary)
    FROM instructor;

    SET @intervalSize = (@maxSalary - @minSalary) / @intervals;

    CREATE TABLE #Histogram (
        valorMinimo FLOAT,
        valorMaximo FLOAT,
        total INT
    );

    WHILE @i < @intervals
    BEGIN
        DECLARE @low FLOAT = @minSalary + (@intervalSize * @i);
        DECLARE @high FLOAT = @low + @intervalSize;

        INSERT INTO #Histogram (valorMinimo, valorMaximo, total)
        SELECT 
            @low,
            @high,
            COUNT(*) 
        FROM instructor
        WHERE salary >= @low AND salary < @high;

        SET @i = @i + 1;
    END

    UPDATE #Histogram
    SET valorMaximo = @maxSalary
    WHERE valorMaximo = (SELECT MAX(valorMaximo) FROM #Histogram);

    SELECT * FROM #Histogram;

    DROP TABLE #Histogram;
END;