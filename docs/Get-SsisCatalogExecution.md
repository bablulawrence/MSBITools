---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisCatalogExecution

## SYNOPSIS
Get instance of package execution object from SSIS catalog.executions table

## SYNTAX

```
Get-SsisCatalogExecution [-ExecutionId] <Int64> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Get instance of package execution object from SSIS catalog.executions table. Sql connection object and execution id can be provided as an input.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalogExecution -ExecutionId 10008
```

Get instance of package execution object with an input  of Execution Id as 10008 for sql connection object of 'localhost'.

## PARAMETERS

### -ExecutionId
unique exection id

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Int64
System.Data.SqlClient.SqlConnection

## OUTPUTS

### System.Data.DataRow

## NOTES

## RELATED LINKS
