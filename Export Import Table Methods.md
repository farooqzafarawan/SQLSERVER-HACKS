# Export Table in CSV Format
Use PowerShell to Export table data in CSV format

```PowerShell
# Does not requires -Module SqlServer in SQL Server 2016 onward

$usr = "guest"
$pwd = "guest"
$instanceName = "localhost"
$databaseName = "AdventureWorks"
$filename = "C:\Emp.csv"
$delimiter = ","

$ExportQry = "SELECT * from [dbo].[Employee]" 

Invoke-SqlCmd -Query $ExportQry -ServerInstance $instanceName -Database $databaseName -Username $usr -Password $pwd  |
Export-Csv -Delimiter $delimiter -NoType $fileName
```

# Bulk Insert from CSV File
```Sql
BULK INSERT DimEmployee
    FROM 'C:\CSVData\Employee.csv'
    WITH
    (
      FIRSTROW = 2,
      FIELDTERMINATOR = ',',  --CSV field delimiter
      ROWTERMINATOR = '\n',   --Use to shift the control to next row
      ERRORFILE = 'C:\CSVDATA\EmployeeErrorRows.csv',
      TABLOCK
    )
```
