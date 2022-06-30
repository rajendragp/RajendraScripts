SELECT
    o.name AS table_name,
    i.name AS index_name,
    tab.split_count,
    i.fill_factor
FROM (    SELECT 
            n.value('(value)[1]', 'bigint') AS alloc_unit_id,
            n.value('(@count)[1]', 'bigint') AS split_count
        FROM
        (SELECT CAST(target_data as XML) target_data
         FROM sys.dm_xe_sessions AS s 
         JOIN sys.dm_xe_session_targets t
             ON s.address = t.event_session_address
         WHERE s.name = 'TrackPageSplits'
          AND t.target_name = 'histogram' ) as tab
        CROSS APPLY target_data.nodes('HistogramTarget/Slot') as q(n)
) AS tab
JOIN sys.allocation_units AS au
    ON tab.alloc_unit_id = au.allocation_unit_id
JOIN sys.partitions AS p
    ON au.container_id = p.partition_id
JOIN sys.indexes AS i
    ON p.object_id = i.object_id
        AND p.index_id = i.index_id
JOIN sys.objects AS o
    ON p.object_id = o.object_id
WHERE o.is_ms_shipped = 0;
