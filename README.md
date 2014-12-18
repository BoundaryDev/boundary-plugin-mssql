Boundary Microsoft SQL Server Plugin
------------------------------------
Collects metrics from Microsoft SQL Server instance.

### Platforms
Only Windows is supported.

### Prerequisites
- SQL Server 2008, 2012 or 2014.

Multiple instances of SQL Server running on the same machine are supported: each instance will show up as a
separate source on your Boundary dashboard.

### Plugin Configuration Fields

The plugin will collect data from the default SQL Server Instance installed on the machine, and requires
no configuration.

### Metrics Collected

The metrics collected are a subset of the SQL Server counters available using Windows Performance Counters. 