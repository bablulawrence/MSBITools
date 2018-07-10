---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SqlServerAgentJob

## SYNOPSIS
Get an instance of SQL Server Agent Job

## SYNTAX

```
Get-SqlServerAgentJob [-JobName] <String> [-SmoServer] <Server> [<CommonParameters>]
```

## DESCRIPTION
Get an instance of SQL Sever Agent job. you can give job name and server name as input.

## EXAMPLES

### Example 1
```powershell
PS C:\> 
New-SqlServerConnection -ServerName 'localhost' | Get-SmoServer | Get-SqlServerAgentJob -JobName 'myjob'
```

Get an Instance of a job with name as 'myjob' from the SQL Server instance 'localhost' through pipeline

## PARAMETERS

### -JobName
Job Name

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

### -SmoServer
SQL Server Instance

```yaml
Type: Server
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

### System.String
Microsoft.SqlServer.Management.Smo.Server

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Agent.Job

## NOTES

## RELATED LINKS
