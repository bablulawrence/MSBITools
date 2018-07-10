---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisCatalog

## SYNOPSIS
Gets SSIS Catalog 

## SYNTAX

```
Get-SsisCatalog -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Gets SSIS catalog object for default(SSISDB) catalog.  

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog
```

Gets SSISDB catalog object for the given SQL Server connection

## PARAMETERS

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Data.SqlClient.SqlConnection
System.String

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.Catalog

## NOTES

## RELATED LINKS
