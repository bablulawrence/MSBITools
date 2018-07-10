---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SqlAgentJobEnvReference

## SYNOPSIS
Add environment reference to SQL job

## SYNTAX

### ParamSet1
```
New-SqlAgentJobEnvReference [-SqlServerConnection] <SqlConnection> [-JobName] <String> [-EnvName] <String>
 [-EnvFolderName] <String> [-ProjectName] <String> [-PackageName] <String> [<CommonParameters>]
```

### ParamSet2
```
New-SqlAgentJobEnvReference [-SqlServerConnection] <SqlConnection> [-ParamFilePath] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Add reference to environment value created in SSIS catalog folder to a step inside SQL Job.
SSIS enviornment folder name,SSIS project name,SSIS package name,SSIS environment name and SQL Server connection is provided as an input.

## EXAMPLES

### Example 1
```
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SqlAgentJobEnvReference -JobName 'myJob' -EnvName 'myEnvironment' -EnvFolderName 'myEnvironmentFolder'-ProjectName 'myProject' -PackageName 'Package.dtsx'
```

Creates reference of environment 'myEnvironment' in the Job 'myJob' provided through pipeline

### Example 2
```
PS C:\> New-SqlServerConnection -ServerName 'localhost' |New-SqlAgentJobEnvReference  -ParamFilePath '.\example1.json'
```

Creates reference based on values from example1.json through piepline

## PARAMETERS

### -EnvFolderName
SSIS Environment Folder Name

```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnvName
SSIS Environment Name

```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -JobName
SQL Job Name

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

### -PackageName
SQL Package Name

```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamFilePath
Param File Path

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

### -ProjectName
SSIS Project Name

```yaml
Type: String
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
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
