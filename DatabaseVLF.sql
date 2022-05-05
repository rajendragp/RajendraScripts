WITH DatbaseVLF AS(
SELECT 
DB_ID(dbs.[name]) AS DatabaseID,
dbs.[name] AS dbName, 
CONVERT(DECIMAL(18,2), p2.cntr_value/1024.0) AS [Log Size (MB)],
CONVERT(DECIMAL(18,2), p1.cntr_value/1024.0) AS [Log Size Used (MB)]
FROM sys.databases AS dbs WITH (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS p1  WITH (NOLOCK) ON dbs.name = p1.instance_name
INNER JOIN sys.dm_os_performance_counters AS p2 WITH (NOLOCK) ON dbs.name = p2.instance_name
WHERE p1.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND p2.counter_name LIKE N'Log File(s) Size (KB)%'
AND p2.cntr_value > 0 
)
SELECT	[dbName],
		[Log Size (MB)], 
		[Log Size Used (MB)], 
		[Log Size (MB)]-[Log Size Used (MB)] [Log Free (MB)], 
		cast([Log Size Used (MB)]/[Log Size (MB)]*100 as decimal(10,2)) [Log Space Used %],
		COUNT(b.database_id) AS [Number of VLFs] ,
		sum(case when b.vlf_status = 0 then 1 else 0 end) as Free,
		sum(case when b.vlf_status != 0 then 1 else 0 end) as InUse		
FROM DatbaseVLF AS vlf  
CROSS APPLY sys.dm_db_log_info(vlf.DatabaseID) b
GROUP BY dbName, [Log Size (MB)],[Log Size Used (MB)]
