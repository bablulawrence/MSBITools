---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SqlServerConnection

## SYNOPSIS
Creates a new connection object for the given SQL server instance. 

## SYNTAX

### ParamSet1
```
New-SqlServerConnection [-ServerName] <String> [<CommonParameters>]
```

### ParamSet2
```
New-SqlServerConnection [-ConnectionString] <String> [<CommonParameters>]
```

## DESCRIPTION
Creates a new SQL Server connection object. You can provide a target server instance name or connection string as input. 

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost'
```

Creates a new SQL Server connection object for the 'localhost' using server instance name

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ConnectionString "Data Source=localhost;Initial Catalog=master;Integrated Security=SSPI;"
```

Creates a new SQL Server connection object for the 'localhost' using connection string

## PARAMETERS

### -ConnectionString
SQL Server connection string

```yaml
Type: String
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServerName
SQL Server instance name

```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Data.SqlClient.SqlConnection

## NOTES

## RELATED LINKS
