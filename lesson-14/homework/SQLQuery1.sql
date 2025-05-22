DECLARE @HTML NVARCHAR(MAX);

-- Build the HTML table
SET @HTML = 
N'<html>
<head>
  <style>
    table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }
    th, td { border: 1px solid #dddddd; text-align: left; padding: 8px; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
  </style>
</head>
<body>
  <h2>SQL Server Index Metadata Report</h2>
  <table>
    <tr>
      <th>Table Name</th>
      <th>Index Name</th>
      <th>Index Type</th>
      <th>Column Name</th>
      <th>Column Type</th>
    </tr>';

-- Append rows
SELECT @HTML = @HTML +
  N'<tr><td>' + s.name + '.' + t.name + 
  N'</td><td>' + i.name + 
  N'</td><td>' + i.type_desc + 
  N'</td><td>' + c.name + 
  N'</td><td>' + ty.name + 
  N'</td></tr>'
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE i.is_hypothetical = 0 AND t.is_ms_shipped = 0
ORDER BY s.name, t.name, i.name, ic.key_ordinal;

-- Close the HTML
SET @HTML = @HTML + N'</table></body></html>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'YourMailProfileName',  -- Replace with your Database Mail profile
    @recipients = 'recipient@example.com',  -- Replace with real email
    @subject = 'SQL Server Index Metadata Report',
    @body = @HTML,
    @body_format = 'HTML';
