---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Remove-SqlServerAgentJob

## SYNOPSIS
Remove a SQL Job from SQL server instance

## SYNTAX

### ParamSet1
```
Remove-SqlServerAgentJob [-SqlServerConnection] <SqlConnection> [-JobName] <String> [<CommonParameters>]
```

### ParamSet2
```
Remove-SqlServerAgentJob [-SqlServerConnection] <SqlConnection> [-ParamFilePath] <String> [<CommonParameters>]
```

## DESCRIPTION
Remove SQL Agent job from SQL server with an input as job name and sql connection object.
## EXAMPLES

### Example 1
```powershell
PS C:\>New-SqlServerConnection -ServerName 'localhost' | Remove-SqlServerAgentJob -ParamFilePath '.\SQLJob.json'
```

Remove SQL jobs based on values specified in the ParamFilePath  through the pipeline for sql server instance 'localhost'

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SqlServerAgentJob -JobName 'Project x'
```

Remove SQL jobs with the name specified for JobName parameter through the pipeline for sql server instance 'localhost'

## PARAMETERS

### -JobName
Job Name
```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamFilePath
 Parameter file path

```yaml
Type: String
Parameter Sets: ParamSet2
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

### System.Boolean

## NOTES

## RELATED LINKS
