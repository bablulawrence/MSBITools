---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Set-SsisProjectParameterValue

## SYNOPSIS
Set parameters for SSIS Project

## SYNTAX

### ParamSet2
```
Set-SsisProjectParameterValue [-ParamName] <String> [-ParamValue] <String> [-ParamValueType] <String>
 [-FolderName] <String> [-ProjectName] <String> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
Set-SsisProjectParameterValue [-ParamName] <String> [-ParamValue] <String> [-ParamValueType] <String>
 [-Project] <ProjectInfo> [<CommonParameters>]
```

### ParamSet3
```
Set-SsisProjectParameterValue [-ParamFilePath] <String> [-SqlServerConnection] <SqlConnection>
 [<CommonParameters>]
```

## DESCRIPTION
Set parameters in SSIS project. You can use paramenter name, value and project info as input along with sql connection object.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

### Example 2
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Set-SsisProjectParameterValue -ParamFilePath '.\example1.json'
```

Create parameter based on example1.json file through the pipeline

## PARAMETERS

### -FolderName
SSIS Folder name

```yaml
Type: String
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamFilePath
Parameter file Path

```yaml
Type: String
Parameter Sets: ParamSet3
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamName
{{Fill ParamName Description}}

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamValue
{{Fill ParamValue Description}}

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamValueType
{{Fill ParamValueType Description}}

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Project
{{Fill Project Description}}

```yaml
Type: ProjectInfo
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProjectName
{{Fill ProjectName Description}}

```yaml
Type: String
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: ParamSet2, ParamSet3
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
Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo
System.Data.SqlClient.SqlConnection

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo

## NOTES

## RELATED LINKS
