SELECT  
SERVERPROPERTY('servername'),
SERVERPROPERTY('ProductVersion ') AS ProductVersion,  
SERVERPROPERTY('ProductLevel') AS ProductLevel,  
SERVERPROPERTY('ResourceVersion') AS ResourceVersion,  
SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime,  
SERVERPROPERTY('Collation') AS Collation; 