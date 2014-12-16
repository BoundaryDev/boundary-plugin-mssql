$METRICS = @(
    @("\SQLServer:General Statistics\Active Temp Tables", "MSSQL_ACTIVE_TEMP_TABLES"),
    @("\SQLServer:General Statistics\User Connections", "MSSQL_USER_CONNECTIONS"),
    @("\SQLServer:General Statistics\Logical Connections", "MSSQL_LOGICAL_CONNECTIONS"),
    @("\SQLServer:General Statistics\Transactions", "MSSQL_TRANSACTIONS"),
    @("\SQLServer:General Statistics\Processes blocked", "MSSQL_PROCESSES_BLOCKED"),
    @("\SQLServer:Locks(*)\Lock Timeouts/sec", "MSSQL_LOCK_TIMEOUTS"),
    @("\SQLServer:Locks(*)\Lock Waits/sec", "MSSQL_LOCK_WAITS"),
    @("\SQLServer:Locks(*)\Lock Wait Time (ms)", "MSSQL_LOCK_WAIT_TIME_MS"),
    @("\SQLServer:Locks(*)\Average Wait Time (ms)", "MSSQL_LOCK_AVERAGE_WAIT_TIME_MS"),
    @("\SQLServer:Locks(*)\Lock Timeouts (timeout > 0)/sec", "MSSQL_LOCK_TIMEOUTS_GT0"),
    @("\SQLServer:Databases(*)\Percent Log Used", "MSSQL_PERCENT_LOG_USED"),
    @("\SQLServer:Databases(*)\Repl. Pending Xacts", "MSSQL_REPL_PENDING_XACTS"),
    @("\SQLServer:SQL Statistics\SQL Compilations/sec", "MSSQL_COMPILATIONS"),
    @("\SQLServer:Wait Statistics(*)\Page IO latch waits", "MSSQL_PAGE_IO_LATCH_WAITS")
)

function outputMetrics
{
    foreach ($metric_info in $METRICS)
    {
        $counter_name = $metric_info[0]
        $boundary_name = $metric_info[1]

        try
        {
    	   $data = Get-Counter $counter_name -ErrorAction Stop
           "{0} {1}" -f $boundary_name, $data.CounterSamples[0].CookedValue
        }
        catch
        {
            # If a counter is unavailable (either temporarily or permanently),
            # ignore it and simply don't report a value for this counter to the
            # Boundary relay.
        }
    }
}

while (1)
{
    outputMetrics
    sleep 1
}
