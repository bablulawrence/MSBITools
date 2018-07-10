---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SqlServerAgentJob

## SYNOPSIS
Create a SQL agent job in SQL Server

## SYNTAX

```
New-SqlServerAgentJob [-SqlServerConnection] <SqlConnection> [-ParamFilePath] <String> [<CommonParameters>]
```

## DESCRIPTION
Create a SQL Agent job in a SQL server Instance. Parameters are added in json file.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SqlServerAgentJob -ParamFilePath '.\SQLJob.json'
```

Create SQL jobs based on values specified in the 'SQLJob.json' through the pipeline for sql server instance 'localhost'

## PARAMETERS

### -ParamFilePath
 Parameter file path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 0
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

### Microsoft.SqlServer.Management.Smo.Agent.Job

## NOTES

## RELATED LINKS
