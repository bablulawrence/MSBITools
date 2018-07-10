---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SmoServer

## SYNOPSIS
Get an instance of an object representing SQL server

## SYNTAX

```
Get-SmoServer [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Get an instance of an object representing SQL server

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SmoServer
```

Get an instance of SQL Server object for the given instance named 'localhost' through pipeline

## PARAMETERS

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.SqlClient.SqlConnection

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Server

## NOTES

## RELATED LINKS
