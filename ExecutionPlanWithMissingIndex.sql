SELECT 
       qs_cpu.total_worker_time/1000 AS total_cpu_time_ms,
       q.[text],
       p.query_plan,
       qs_cpu.execution_count,
       q.dbid,
       q.objectid,
       q.encrypted AS text_encrypted
FROM
  (SELECT TOP 500 qs.plan_handle,
              qs.total_worker_time,
              qs.execution_count
   FROM sys.dm_exec_query_stats qs
   ORDER BY qs.total_worker_time DESC) AS qs_cpu 
   CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS q
   CROSS APPLY sys.dm_exec_query_plan (plan_handle) p
  WHERE p.query_plan.exist('declare namespace 
   qplan="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
        //qplan:MissingIndexes')=1
