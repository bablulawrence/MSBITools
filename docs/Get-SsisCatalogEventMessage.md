---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisCatalogEventMessage

## SYNOPSIS
Get messages logged during ssis operation

## SYNTAX

### ParamSet2
```
Get-SsisCatalogEventMessage [-OperationId] <Int64> [-EventMessageId] <Int64>
 [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
Get-SsisCatalogEventMessage [-OperationId] <Int64> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Get messages logged during ssis operation. You can provide operation id, event message id and sql connection object as input.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalogEventMessage -OperationId 10008 -EventMessageId 2
```

Get the message logged with an input of 100008 as operation id and event message id as 2 for sql connection object of localhost

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalogEventMessage -OperationId 10008
```

Get the message from catalog.event_messages for an input of OperationId as '2' for sql connection object of 'localhost'.

## PARAMETERS

### -EventMessageId
unique message id

```yaml
Type: Int64
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OperationId
id for operation type from catalog.operations

```yaml
Type: Int64
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
Position: 2
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
