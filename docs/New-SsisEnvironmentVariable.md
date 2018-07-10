---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SsisEnvironmentVariable

## SYNOPSIS
Creates SSIS environment variable 

## SYNTAX

### ParamSet2
```
New-SsisEnvironmentVariable [-VarName] <String> [-VarValue] <Object> [-EnvName] <String> [-FolderName] <String>
 -SqlServerConnection <SqlConnection> [-VarDescription <String>] [[-VarType] <TypeCode>]
 [-VarSensitive <Boolean>] [<CommonParameters>]
```

### ParamSet1
```
New-SsisEnvironmentVariable [-VarName] <String> [-VarValue] <Object> [-Environment] <EnvironmentInfo>
 [-VarDescription <String>] [[-VarType] <TypeCode>] [-VarSensitive <Boolean>] [<CommonParameters>]
```

### ParamSet3
```
New-SsisEnvironmentVariable [-ParamFilePath] <String> -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Created SSIS environment variable in the given environment with an input of SSIS environment object or folder name, environment name and SQL Server connection.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Get-SsisEnvironment -EnvName 'myEnvironment' |
             New-SsisEnvironmentVariable -VarName 'myVar' -VarType String -VarValue 'my value' -VarSensitive $false -VarDescription 'my value description'
```

Creates variable 'myVar' in the environment provided through pipeline

### Example 2
```powershell
PS C:\> $SqlServerConn = New-SqlServerConnection -ServerName 'localhost'
PS C:\> New-SsisEnvironmentVariable -VarName 'myVar' -VarType String -VarValue 'my value' -VarSensitive $false -VarDescription 'my value description' `
>> -EnvName 'myEnvironment' -FolderName 'myFolder' -SqlServerConnection $SqlServerConn
```

Creates variable 'myVar' in environment 'myEnvironment' in folder 'myFolder' in SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisEnvironment -ParamFilePath '.\example1.json'
```

Creates variable(s) specified in parameter file 'example1.json'

## PARAMETERS

### -EnvName
SSIS environment name

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

### -Environment
SSIS environment object

```yaml
Type: EnvironmentInfo
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FolderName
SSIS catalog folder name 

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

### -VarDescription
SSIS environment variable description

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VarName
SSIS environment variable name

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

### -VarSensitive
SSIS environment variable sensitive flag

```yaml
Type: Boolean
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VarType
SSIS environment variable type 

```yaml
Type: TypeCode
Parameter Sets: ParamSet2, ParamSet1
Aliases:
Accepted values: Empty, Object, DBNull, Boolean, Char, SByte, Byte, Int16, UInt16, Int32, UInt32, Int64, UInt64, Single, Double, Decimal, DateTime, String

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VarValue
SSIS environment variable value

```yaml
Type: Object
Parameter Sets: ParamSet2, ParamSet1
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
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: SqlConnection
Parameter Sets: ParamSet3
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.TypeCode
System.Object
Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo
System.Boolean

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.EnvironmentVariable

## NOTES

## RELATED LINKS
