SELECT [eventdata].[event_data].[value]('(event/action[@name="session_id"]/value)[1]', 'INT') AS [SessionID],
[eventdata].[event_data].[value]('(event/action[@name="client_hostname"]/value)[1]', 'VARCHAR(100)') AS [ClientHostName],
DB_NAME([eventdata].[event_data].[value]('(event/action[@name="database_id"]/value)[1]', 'BIGINT')) AS [GrowthDB],
[eventdata].[event_data].[value]('(event/data[@name="file_name"]/value)[1]', 'VARCHAR(200)') AS [GrowthFile],
[eventdata].[event_data].[value]('(event/data[@name="file_type"]/text)[1]', 'VARCHAR(200)') AS [DBFileType],
[eventdata].[event_data].[value]('(event/@name)[1]', 'VARCHAR(MAX)') AS [EventName],
[eventdata].[event_data].[value]('(event/data[@name="size_change_kb"]/value)[1]', 'BIGINT') AS [SizeChangedKb],
[eventdata].[event_data].[value]('(event/data[@name="total_size_kb"]/value)[1]', 'BIGINT') AS [TotalSizeKb],
[eventdata].[event_data].[value]('(event/data[@name="duration"]/value)[1]', 'BIGINT') AS [DurationInMS],
[eventdata].[event_data].[value]('(event/@timestamp)[1]', 'VARCHAR(MAX)') AS [GrowthTime],
[eventdata].[event_data].[value]('(event/action[@name="sql_text"]/value)[1]', 'VARCHAR(MAX)') AS [QueryText]
FROM
(
SELECT CAST([event_data] AS XML) AS [TargetData]
FROM [sys].[fn_xe_file_target_read_file]('C:\TEMP\TempDB*.xel', NULL, NULL, NULL)
) AS [eventdata]([event_data])
WHERE [eventdata].[event_data].[value]('(event/@name)[1]', 'VARCHAR(100)') = 'database_file_size_change'
OR [eventdata].[event_data].[value]('(event/@name)[1]', 'VARCHAR(100)') = 'databases_log_file_used_size_changed'
AND [eventdata].[event_data].[value]('(event/@name)[1]', 'VARCHAR(MAX)') <> 'databases_log_file_used_size_changed'
ORDER BY [GrowthTime] ASC;
