# Export Table in CSV Format
Use PowerShell to Export table data in CSV format

```PowerShell
#Requires -Module SqlServer

Invoke-Sqlcmd -Query "SELECT * FROM DimDate;" -Database AdventureWorksDW2012  -Server localhost |
Export-Csv -NoTypeInformation -Path "DimDate.csv" -Encoding UTF8
```
