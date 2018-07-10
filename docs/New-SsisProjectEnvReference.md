---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SsisProjectEnvReference

## SYNOPSIS
Creates environment reference to a SSIS Project

## SYNTAX

### ParamSet2
```
New-SsisProjectEnvReference [-EnvName] <String> [-EnvFolderName] <String> [-ProjectName] <String>
 [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
New-SsisProjectEnvReference [-EnvName] <String> [-EnvFolderName] <String> [-Project] <ProjectInfo>
 [<CommonParameters>]
```

### ParamSet3
```
New-SsisProjectEnvReference [-ParamFilePath] <String> [-SqlServerConnection] <SqlConnection>
 [<CommonParameters>]
```

## DESCRIPTION
Creates environment reference to the given SSIS project with an input of SSIS project object or folder name, project name and SQL Server connection object.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Get-SsisProject -ProjectName 'myProject' |
             New-SsisProjectEnvReference -EnvName 'myEnvironment' -EnvFolderName 'myFolder'
```

Creates reference of environment 'myEnvironment' in the project provided through pipeline

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisProjectEnvReference -EnvName 'myEnvironment' -EnvFolderName 'myFolder' -ProjectName 'myProject'
```

Creates reference of environment 'myEnvironment' to project 'myProject' in folder 'myFolder' in SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisProjectEnvReference -ParamFilePath '.\example1.json'
```

Creates reference based on values from example1.json through piepline

## PARAMETERS

### -EnvFolderName

SSIS environment folder name

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

### -EnvName
SSIS environment name

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

### -ParamFilePath
Parameter file path

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

### -Project
SSIS project object

```yaml
Type: ProjectInfo
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProjectName
SSIS project name

```yaml
Type: String
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 2
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

### Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference

## NOTES

## RELATED LINKS
