# Export Table in CSV Format
Use PowerShell to Export table data in CSV format

```PowerShell
#Requires -Module SqlServer

Invoke-Sqlcmd -Query "SELECT * FROM DimEmp;" -Database AdventureWorksDW2012  -Server localhost |
Export-Csv -NoTypeInformation -Path "DimEmp.csv" -Encoding UTF8
```

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
