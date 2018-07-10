$sqlConnection = New-SqlServerConnection -ServerName 'localhost'
New-SsisCatalogFolder -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisProject -ParamFilePath '.\ImportToCSV.param.json' -ProjectFilePathPrefix "$pwd\" -SqlServerConnection $sqlConnection 
New-SsisEnvironment -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisProjectEnvReference -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisEnvironmentVariable -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection