Select * from sys.databases where name not in('tempdb','master',',model','msdb');
Go
sp_helpdb
GO
SELECT 
  SERVERPROPERTY('BuildClrVersion') AS BuildClrVersion,
  SERVERPROPERTY('ProductLevel') AS ProductLevel,
  SERVERPROPERTY('ProductVersion') AS ProductVersion; 
