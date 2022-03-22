PRINT '--Profiler trace summary--'
SELECT traceid, property, CONVERT (VARCHAR(1024), value) AS value FROM :: fn_trace_getinfo(default)
GO
PRINT '--Trace event details--'
      SELECT trace_id,
            status,
            CASE WHEN row_number = 1 THEN path ELSE NULL end AS path,
            CASE WHEN row_number = 1 THEN max_size ELSE NULL end AS max_size,
            CASE WHEN row_number = 1 THEN start_time ELSE NULL end AS start_time,
            CASE WHEN row_number = 1 THEN stop_time ELSE NULL end AS stop_time,
            max_files, 
            is_rowset, 
            is_rollover,
            is_shutdown,
            is_default,
            buffer_count,
            buffer_size,
            last_event_time,
            event_count,
            trace_event_id, 
            trace_event_name, 
            trace_column_id,
            trace_column_name,
            expensive_event   
      FROM 
            (SELECT t.id AS trace_id, 
                  row_number() over (PARTITION BY t.id order by te.trace_event_id, tc.trace_column_id) AS row_number, 
                  t.status, 
                  t.path, 
                  t.max_size, 
                  t.start_time,
                  t.stop_time, 
                  t.max_files, 
                  t.is_rowset, 
                  t.is_rollover,
                  t.is_shutdown,
                  t.is_default,
                  t.buffer_count,
                  t.buffer_size,
                  t.last_event_time,
                  t.event_count,
                  te.trace_event_id, 
                  te.name AS trace_event_name, 
                  tc.trace_column_id,
                  tc.name AS trace_column_name,
                  CASE WHEN te.trace_event_id in (23, 24, 40, 41, 44, 45, 51, 52, 54, 68, 96, 97, 98, 113, 114, 122, 146, 180) 
                  THEN CAST(1 as bit) ELSE CAST(0 AS BIT) END AS expensive_event
            FROM sys.traces t 
                  CROSS APPLY ::fn_trace_geteventinfo(t .id) AS e 
                  JOIN sys.trace_events te ON te.trace_event_id = e.eventid 
                  JOIN sys.trace_columns tc ON e.columnid = trace_column_id) AS x
GO
PRINT '--XEvent Session Details--'
SELECT sess.NAME 'session_name', event_name,xe_event_name, trace_event_id,
CASE
 WHEN xemap.trace_event_id IN ( 23, 24, 40, 41, 44, 45, 51, 52, 54, 68, 96, 97, 98, 113, 114, 122, 146, 180 )
 THEN Cast(1 AS BIT) ELSE Cast(0 AS BIT)
END AS expensive_event
FROM sys.dm_xe_sessions sess
  JOIN sys.dm_xe_session_events evt
  ON sess.address = evt.event_session_address
INNER JOIN sys.trace_xe_event_map xemap
  ON evt.event_name = xemap.xe_event_name
GO
