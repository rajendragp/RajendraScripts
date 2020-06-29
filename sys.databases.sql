Select * from sys.databases where name not in('tempdb','master',',model','msdb');
Go
sp_helpdb
