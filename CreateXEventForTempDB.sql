CREATE EVENT SESSION [TempDB] ON SERVER
ADD EVENT sqlserver.database_file_size_change(

ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.session_id,sqlserver.sql_text)),
ADD EVENT sqlserver.databases_log_file_used_size_changed(

ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.session_id,sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'C:\Temp\TempDB',max_rollover_files=(0))
WITH (STARTUP_STATE=ON)
GO
