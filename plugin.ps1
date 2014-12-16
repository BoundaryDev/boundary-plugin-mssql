$METRICS = @(
    @("\SQLServer:General Statistics\Active Temp Tables", "MSSQL_ACTIVE_TEMP_TABLES"),
    @("\SQLServer:General Statistics\User Connections", "MSSQL_USER_CONNECTIONS"),
    @("\SQLServer:General Statistics\Logical Connections", "MSSQL_LOGICAL_CONNECTIONS"),
    @("\SQLServer:General Statistics\Transactions", "MSSQL_TRANSACTIONS"),
    @("\SQLServer:General Statistics\Processes blocked", "MSSQL_PROCESSES_BLOCKED"),
    @("\SQLServer:Locks(_total)\Lock Timeouts/sec", "MSSQL_LOCK_TIMEOUTS"),
    @("\SQLServer:Locks(_total)\Lock Waits/sec", "MSSQL_LOCK_WAITS"),
    @("\SQLServer:Locks(_total)\Lock Wait Time (ms)", "MSSQL_LOCK_WAIT_TIME_MS"),
    @("\SQLServer:Locks(_total)\Average Wait Time (ms)", "MSSQL_LOCK_AVERAGE_WAIT_TIME_MS"),
    @("\SQLServer:Locks(_total)\Lock Timeouts (timeout > 0)/sec", "MSSQL_LOCK_TIMEOUTS_GT0"),
    @("\SQLServer:Databases(_total)\Percent Log Used", "MSSQL_PERCENT_LOG_USED"),
    @("\SQLServer:Databases(_total)\Repl. Pending Xacts", "MSSQL_REPL_PENDING_XACTS"),
    @("\SQLServer:SQL Statistics\SQL Compilations/sec", "MSSQL_COMPILATIONS"),
    @("\SQLServer:Wait Statistics(_total)\Page IO latch waits", "MSSQL_PAGE_IO_LATCH_WAITS")
)

$METRIC_COUNTERS = @()
$BOUNDARY_NAME_MAP = @{}

# First get the local server's name for each counter (the names are sometimes different
# than what we pass in, e.g. prepended with a server name).
foreach ($metric_info in $METRICS)
{
    $counter_name = $metric_info[0]
    $boundary_name = $metric_info[1]
    
    try
    {
	   $data = Get-Counter $counter_name -ErrorAction Stop
       # Write-Host ("{0} -> {1}" -f $data.CounterSamples[0].Path, $boundary_name)
       $METRIC_COUNTERS += $counter_name
       $BOUNDARY_NAME_MAP[$data.CounterSamples[0].Path] = $boundary_name
    }
    catch
    {
        # If a counter is unavailable, ignore it and don't add it to the list so we never
        # try it to request it again.
    }
}

function outputMetrics
{
    $data = Get-Counter -Counter $METRIC_COUNTERS -EA SilentlyContinue
    
    foreach ($item in $data.counterSamples)
    {
        Write-Host ("{0} {1}" -f $BOUNDARY_NAME_MAP[$item.Path], $item.CookedValue)
    }
}

while (1)
{
    outputMetrics
    sleep 1
}
