$sqlConnection = New-SqlServerConnection -ServerName 'localhost'
New-SqlServerAgentJob -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json' 
New-SQLAgentJobEnvReference -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json'
