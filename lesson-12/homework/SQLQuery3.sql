--task1

DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @dbName NVARCHAR(255);

-- Cursor to loop through all user databases
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql += '
    SELECT 
        ''' + @dbName + ''' AS database_name,
        s.name AS schema_name,
        t.name AS table_name,
        c.name AS column_name,
        ty.name AS data_type
    FROM [' + @dbName + '].sys.columns AS c
    INNER JOIN [' + @dbName + '].sys.tables AS t ON c.object_id = t.object_id
    INNER JOIN [' + @dbName + '].sys.schemas AS s ON t.schema_id = s.schema_id
    INNER JOIN [' + @dbName + '].sys.types AS ty ON c.user_type_id = ty.user_type_id
    WHERE t.is_ms_shipped = 0
    UNION ALL
    ';
    
    FETCH NEXT FROM db_cursor INTO @dbName;
END

-- Remove the last UNION ALL
SET @sql = LEFT(@sql, LEN(@sql) - 10);

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- Execute the dynamically built query
EXEC sp_executesql @sql;

--task 2

CREATE PROCEDURE sp_ListRoutinesWithParams
    @DatabaseName SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = '';
    DECLARE @dbName SYSNAME;

    -- If a specific database is provided
    IF @DatabaseName IS NOT NULL
    BEGIN
        IF DB_ID(@DatabaseName) IS NULL
        BEGIN
            RAISERROR('Database "%s" does not exist.', 16, 1, @DatabaseName);
            RETURN;
        END

        SET @sql = '
        SELECT 
            ''' + @DatabaseName + ''' AS database_name,
            s.name AS schema_name,
            o.name AS routine_name,
            p.name AS parameter_name,
            t.name AS data_type,
            p.max_length
        FROM [' + @DatabaseName + '].sys.objects o
        INNER JOIN [' + @DatabaseName + '].sys.schemas s ON o.schema_id = s.schema_id
        LEFT JOIN [' + @DatabaseName + '].sys.parameters p ON o.object_id = p.object_id
        LEFT JOIN [' + @DatabaseName + '].sys.types t ON p.user_type_id = t.user_type_id
        WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'') -- Stored procs and functions
        ORDER BY schema_name, routine_name';
        
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        -- If no database is specified, loop through all user databases
        DECLARE db_cursor CURSOR FOR
        SELECT name FROM sys.databases
        WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') AND state_desc = 'ONLINE';

        OPEN db_cursor;
        FETCH NEXT FROM db_cursor INTO @dbName;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql += '
            SELECT 
                ''' + @dbName + ''' AS database_name,
                s.name AS schema_name,
                o.name AS routine_name,
                p.name AS parameter_name,
                t.name AS data_type,
                p.max_length
            FROM [' + @dbName + '].sys.objects o
            INNER JOIN [' + @dbName + '].sys.schemas s ON o.schema_id = s.schema_id
            LEFT JOIN [' + @dbName + '].sys.parameters p ON o.object_id = p.object_id
            LEFT JOIN [' + @dbName + '].sys.types t ON p.user_type_id = t.user_type_id
            WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'') -- Stored procs and functions
            UNION ALL
            ';

            FETCH NEXT FROM db_cursor INTO @dbName;
        END

        CLOSE db_cursor;
        DEALLOCATE db_cursor;

        -- Remove trailing UNION ALL
        SET @sql = LEFT(@sql, LEN(@sql) - 10);

        EXEC sp_executesql @sql;
    END
END;
