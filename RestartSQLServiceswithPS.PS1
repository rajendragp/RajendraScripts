$svc=Get-Service
$i=1
foreach($service in $svc)
{
if ($svc[$i].name -eq "MSSQLSERVER" -or
    $svc[$i].name -eq "SQLSERVERAGENT" -or
    $svc[$i].name -eq "SQLServerReportingServices" -or
    $svc[$i].name -eq "MsDtsServer150" )
    {
        if($svc[$i].status -eq "Stopped")
        {
            start-service -name $svc[$i].Name -PassThru
        }
        if($svc[$i].status -eq "Running")
        {    
            stop-service -name $svc[$i].Name -Force -PassThru
            start-service -name $svc[$i].Name -PassThru
        }
        }
$i++
}
Write-Output " "
Write-Output "SQL Services Successfully restarted."
