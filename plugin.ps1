$METRICS = @(
    @("\SQLServer:General Statistics\Active Temp Tables", "MSSQL_ACTIVE_TEMP_TABLES", 1),
    @("\SQLServer:General Statistics\User Connections", "MSSQL_USER_CONNECTIONS", 1),
    @("\SQLServer:General Statistics\Logical Connections", "MSSQL_LOGICAL_CONNECTIONS", 1),
    @("\SQLServer:General Statistics\Transactions", "MSSQL_TRANSACTIONS", 1),
    @("\SQLServer:General Statistics\Processes blocked", "MSSQL_PROCESSES_BLOCKED", 1),
    @("\SQLServer:Locks(_total)\Lock Timeouts/sec", "MSSQL_LOCK_TIMEOUTS", 1),
    @("\SQLServer:Locks(_total)\Lock Waits/sec", "MSSQL_LOCK_WAITS", 1),
    @("\SQLServer:Locks(_total)\Lock Wait Time (ms)", "MSSQL_LOCK_WAIT_TIME_MS", 1),
    @("\SQLServer:Locks(_total)\Average Wait Time (ms)", "MSSQL_LOCK_AVERAGE_WAIT_TIME_MS", 1),
    @("\SQLServer:Locks(_total)\Lock Timeouts (timeout > 0)/sec", "MSSQL_LOCK_TIMEOUTS_GT0", 1),
    @("\SQLServer:Databases(_total)\Percent Log Used", "MSSQL_PERCENT_LOG_USED", 0.01),
    @("\SQLServer:Databases(_total)\Repl. Pending Xacts", "MSSQL_REPL_PENDING_XACTS", 1),
    @("\SQLServer:SQL Statistics\SQL Compilations/sec", "MSSQL_COMPILATIONS", 1),
    @("\SQLServer:Wait Statistics(_total)\Page IO latch waits", "MSSQL_PAGE_IO_LATCH_WAITS", 1)
)

$METRIC_COUNTERS = @()
$BOUNDARY_NAME_MAP = @{}

# First get the local server's name for each counter (the names are sometimes different
# than what we pass in, e.g. prepended with a server name).
foreach ($metric_info in $METRICS)
{
    $counter_name = $metric_info[0]
    $boundary_name = $metric_info[1]
    $scale = $metric_info[2]
    
    try
    {
	   $data = Get-Counter $counter_name -ErrorAction Stop
       # Write-Host ("{0} -> {1}" -f $data.CounterSamples[0].Path, $boundary_name)
       $METRIC_COUNTERS += $counter_name
       $BOUNDARY_NAME_MAP[$data.CounterSamples[0].Path] = $boundary_name, $scale
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
        Write-Host $item
        $boundary_name = $BOUNDARY_NAME_MAP[$item.Path][0]
        $value = $item.CookedValue * $BOUNDARY_NAME_MAP[$item.Path][1]
        Write-Host ("{0} {1}" -f $boundary_name, $value)
    }
}

while (1)
{
    outputMetrics
    sleep 1
}
