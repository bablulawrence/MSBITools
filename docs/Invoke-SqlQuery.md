---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Invoke-SqlQuery

## SYNOPSIS
Execute SQL Query

## SYNTAX

```
Invoke-SqlQuery [-SqlQuery] <String> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Execute SQL Query with an input of query and sql connection object

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Invoke-SqlQuery -SQLQuery 'SELECT * FROM SSISDB.catalog.event_messages'
```

Executes any sql query which is passed as a input

## PARAMETERS

### -SqlQuery
SQL Query

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Data.SqlClient.SqlConnection

## OUTPUTS

### System.Data.DataRow

## NOTES

## RELATED LINKS
