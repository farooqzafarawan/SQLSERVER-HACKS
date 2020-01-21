# Procedures in a Database
Get list of Procedures in a database

```sql
SELECT SPECIFIC_CATALOG, SPECIFIC_SCHEMA, Routine_Name, ROUTINE_TYPE, ROUTINE_DEFINITION,
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
```

# Functions
Get list of Scalar Functions in a database
```sql
with functions(routine_name) as 
(
	SELECT ROUTINE_NAME FROM information_schema.routines WHERE routine_type = 'function'
)
select routine_name  ,OBJECT_DEFINITION(OBJECT_ID(routine_name)) AS [Object Definition] 
from   functions
```
