param(
    [parameter(Position = 0, Mandatory = $false)] [string]	$SsisAssemblyVersion,
    [parameter(Position = 1, Mandatory = $false)] [string]	$SmoAssemblyVersion
) 

function loadSsisAssembly ([string] $Version) {
    if ($Version) {
        $assemblyName = "Microsoft.SqlServer.Management.IntegrationServices,Version=$Version,Culture=neutral,PublicKeyToken=89845dcd8080cc91,processorArchitecture=MSIL"
        try {
            $loadStatus = [System.Reflection.Assembly]::Load($assemblyName)
            Write-Verbose -Message "Successfully loaded SQL Server Integration Services assembly :$loadStatus"
        }
        catch {		 
            Write-Error -Message "Error while loading SQL Server Integration Services assembly, version : $Version error status : $loadStatus"
        }	
		
    }
    else {		
        $assemblyName = "Microsoft.SqlServer.Management.IntegrationServices"
        try {
            $loadStatus = [System.Reflection.Assembly]::LoadWithPartialName($assemblyName)
            Write-Verbose -Message "Successfully loaded SQL Server Integration Services assembly :$loadStatus"
        }
        catch {		 
            Write-Error -Message "Error while loading  SQL Server Integration Services assembly, error status : $loadStatus"
        }	
    }
}

function loadSmoAssembly([string] $Version) {
    if ($Version) {
        $assemblyName = "Microsoft.SqlServer.Smo,Version=$Version,Culture=neutral,PublicKeyToken=89845dcd8080cc91,processorArchitecture=MSIL"
        try {
            $loadStatus = [System.Reflection.Assembly]::Load($assemblyName)
            Write-Verbose -Message "Successfully SQL Server Management Object assembly :$loadStatus"
        }
        catch {		 
            Write-Error -Message "Error while loading  SQL Server Management Object, version : $Version error status : $loadStatus"
        }	
		
    }
    else {		
        $assemblyName = "Microsoft.SqlServer.Smo"
        try {
            $loadStatus = [System.Reflection.Assembly]::LoadWithPartialName($assemblyName)
            Write-Verbose -Message "Successfully loaded SQL Server Management Object assembly :$loadStatus"
        }
        catch {		 
            Write-Error -Message "Error while loading SQL Server Management Object, error status : $loadStatus"
        }	
    }
}
function New-SqlServerConnection {
    [OutputType([System.Data.SqlClient.SqlConnection])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [string] 
        $ServerName,

        [Parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [string] 
        $ConnectionString
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' {  
            $connString = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=SSPI;"
        }
        'ParamSet2' {
            $connString = $ConnectionString
        }
    }
	
    $props = @{TypeName = 'System.Data.SqlClient.SqlConnection';
        ArgumentList = $connString ;
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
			
    try {
        Write-Verbose "Creating SQL Server connection for connection string '$connString'"
        Write-Debug "Command properties : $($props | Out-String)"
        $sqlConnection = New-Object @props
    }	
    catch {
        Write-Error "Error creating connection to Server '$ServerName' : $ErrorVar"
    }
	
    return $sqlConnection
}
		
function Get-SsisCatalog {	
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.Catalog])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    $props = @{TypeName = 'Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices';
        ArgumentList = $SqlServerConnection ;
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }

			
    try {
        Write-Verbose "Getting default(SSISDB) Catalog for server '$($SqlServerConnection.DataSource)'"
        Write-Debug "Command properties : $($props | Out-String)"
        $integrationServices = New-Object @props
        $catalog1 = $integrationServices.Catalogs["SSISDB"]
    }
    catch {
        Write-Error "Error getting catalog from server : $ErrorVar"
    }

    return $catalog1
}

function Get-SmoServer {	
    [OutputType([Microsoft.SqlServer.Management.Smo.Server])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    $props = @{TypeName = 'Microsoft.SQLServer.Management.Smo.Server';
        ArgumentList = $SqlServerConnection ;
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
			
    try {
        Write-Verbose "Getting SMO Object for server '$($SqlServerConnection.DataSource)'"
        Write-Debug "Command properties : $($props | Out-String)"
        $server = New-Object @props
    }
    catch {
        Write-Error "Error getting SMO object for server '$($SqlServerConnection.DataSource)': $ErrorVar"
    }

    return $server
}

function Get-SsisCatalogExecution {	
    [OutputType([System.Data.DataRow])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true)]
        [int64] 
        $ExecutionId,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true)]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )	

    $catalogQuery = "SELECT * FROM SSISDB.catalog.executions WHERE execution_id = $ExecutionId"
	
    try {
        Write-Verbose "Getting details of execution '$ExecutionId' from SSISDB"		
        $dataSet = Invoke-SqlQuery -SqlQuery $catalogQuery -SqlServerConnection $SqlServerConnection        
        $result = $dataSet.Tables.Select()
    }
    catch {
        Write-Error "Error getting details of execution '$ExecutionId' from SSISDB: $_"
    }

    return $result
}

function Invoke-SqlQuery {
    [OutputType([System.Data.DataRow])]
    [CmdletBinding()] 
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName)]
        [string]
        $SqlQuery,
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline)]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    $props = @{TypeName = 'System.Data.SqlClient.SqlCommand';
        ArgumentList = ($SqlQuery, $SqlServerConnection)
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
    try {
        Write-Verbose "Creating SQL command"
        Write-Debug "Command properties : $($props | Out-String)"
        $sqlCommand = New-Object @props		
    }
    catch {
        Write-Error "Error creating SQL command : $ErrorVar"
    }

    $props = @{TypeName = 'System.Data.SqlClient.SqlDataAdapter';
        ArgumentList = ($sqlCommand)
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
    try {
        Write-Verbose "Creating SQL adapter"
        Write-Debug "Command properties : $($props | Out-String)"
        $sqlAdapter = New-Object @props		
    }
    catch {
        Write-Error "Error creating SQL adapater : $ErrorVar"
    }


    $props = @{TypeName = 'System.Data.DataSet';
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
    try {
        Write-Verbose "Creating data set"
        Write-Debug "Command properties : $($props | Out-String)"
        $dataSet = New-Object @props		
    }
    catch {
        Write-Error "Error creating data set : $ErrorVar"
    }

    try {
        Write-Verbose "Executing query"		
        $sqlAdapter.Fill($dataSet) | Out-Null            
    }
    catch {
        Write-Error "Error executing query :$_"
    }

    return $dataSet
}

function Get-SsisCatalogEventMessage {	
    [OutputType([System.Data.DataRow])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [long] 
        $OperationId,

        [parameter(Position = 1,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [long] 
        $EventMessageId,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 2,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )	

	
    if ($PSCmdlet.ParameterSetName -eq "ParamSet1") {
        $catalogQuery = "SELECT * FROM SSISDB.catalog.event_messages WHERE operation_id = $OperationId"
    }
    else {		
        $catalogQuery = "SELECT * FROM SSISDB.catalog.event_messages WHERE operation_id = $OperationId AND event_message_id = $EventMessageId"
    }
	
    try {
        Write-Verbose "Getting event messages from SSISDB"
        $dataSet = Invoke-SqlQuery -SqlQuery $catalogQuery -SqlServerConnection $SqlServerConnection	
        $result = $dataSet.Tables.select()
    }
    catch {
        Write-Error "Error getting event messages from SSISDB : $_"
    }

    return $result
}

function New-SqlServerAgentJob {	
    [OutputType([Microsoft.SqlServer.Management.Smo.Agent.Job])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true
           )]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection,
    [parameter(Position = 1,
        ValueFromPipelineByPropertyName = $true,
        Mandatory = $true)]
    [String] 
    $ParamFilePath
    )		
    try {
        $param = Get-Content $ParamFilePath | ConvertFrom-Json
	
		foreach ($job in $param.job) 
		{
            
             $JobName = $job.Name;
             $SqlServer = $SqlServerConnection.DataSource;
             $SqlJobServer = Get-SmoServer -SqlServerConnection $SqlServerConnection
                                   
             Write-Verbose "Creating new SQL Server agent job $JobName in server $SqlJobServer"
             Write-Debug "Command properties : $($props | Out-String)"
             $props = @{TypeName = 'Microsoft.SqlServer.Management.SMO.Agent.Job';
                ArgumentList = ($SqlJobServer.JobServer, $JobName) ;
                ErrorAction = 'Stop';
                ErrorVariable = 'ErrorVar'}
                 $sqljob = New-Object @props
                 $sqljob.OwnerLoginName = 'sa'
                 $sqljob.Create()
                
                
                 $count = $job.Step.Count
                 foreach ($step in $job.Step) {
                   
                    
                    $Command = '/ISSERVER "\"\SSISDB\' +$step.folder+'\'+ $step.project +'\'+ $step.package + '\"" /SERVER "\"'+$SqlServerConnection.DataSource+'\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'

                	$jobstepprops = @{TypeName = 'Microsoft.SqlServer.Management.SMO.Agent.JobStep';
                    ArgumentList = ($sqljob, $step.Name) ;
                
                    ErrorAction = 'Stop';
                    ErrorVariable = 'ErrorVar'
                	}
                    
                    try {
                        $SQLJobStep = New-Object @jobstepprops
                        if($count -eq 1)
                        {
                            $SQLJobStep.OnSuccessAction = [Microsoft.SqlServer.Management.Smo.Agent.StepCompletionAction]::QuitWithSuccess
                        }	
                        elseif ($count -gt 1) 
                        {
                            
                            $SQLJobStep.OnSuccessAction = [Microsoft.SqlServer.Management.Smo.Agent.StepCompletionAction]::GoToNextStep
                        }
                       
                        $SQLJobStep.OnFailAction = [Microsoft.SqlServer.Management.Smo.Agent.StepCompletionAction]::QuitWithFailure
                        $SQLJobStep.SubSystem = "SSIS"
                        $SQLJobStep.DatabaseName =  $SqlServerConnection.DataSource 
                        $SQLJobStep.Command = $Command
                        $SQLJobStep.Create() 
                        $count = $count - 1;     
                    }
                    catch {
                        Write-Error "Error creating job object '$JobName' : $ErrorVar"
                    }
                   
                }

                Set-Frequency -SqlServerConnection $SqlServerConnection -ParamFilePath $ParamFilePath  
                $sqljob.ApplyToTargetServer($SqlServerConnection.DataSource)
                $sqljob.Alter()
            }		
    }
    catch {
        Write-Error "Error creating job object '$JobName' : $_.Exception.Message"
    }
 
}

function Set-Frequency{
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true
           )]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection,
    [parameter(Position = 1,
        ValueFromPipelineByPropertyName = $true,
        Mandatory = $true)]
    [String] 
    $ParamFilePath
    )

    $param = Get-Content $ParamFilePath | ConvertFrom-Json
    $SQLJobSchedule = new-object Microsoft.SqlServer.Management.Smo.Agent.JobSchedule($sqljob, $job.Frequency.Name)
    foreach ($job in $param.job) 
    {
        $sqljob = Get-SqlServerAgentJob -SmoServer $SqlServer -JobName $Job.Name
        $SQLJobSchedule = new-object Microsoft.SqlServer.Management.Smo.Agent.JobSchedule($sqljob, $job.Frequency.Name) 
    switch ($job.Frequency.Type) { 
        'Daily'{

            $Type = $job.Frequency.Type

        $SQLJobSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.Smo.Agent.FrequencyTypes]::$Type
        $SubType = $job.Frequency.SubType
        $SQLJobSchedule.FrequencySubDayTypes = [Microsoft.SqlServer.Management.Smo.Agent.FrequencySubDayTypes]::$SubType
        $SQLJobSchedule.FrequencySubDayinterval = $job.Frequency.Interval

        $JobStartTime = $job.Frequency.StartTime
        $JobStartHour = $JobStartTime.ToString().Split(':')[0]
        $JobStartMinute = $JobStartTime.ToString().Split(':')[1]
        $JobStartSecond = $JobStartTime.ToString().Split(':')[2]

        $JobEndTime = $job.Frequency.Endtime
        $JobEndHour = $JobEndTime.ToString().Split(':')[0]
        $JobEndMinute = $JobEndTime.ToString().Split(':')[1]
        $JobEndSecond = $JobEndTime.ToString().Split(':')[2]


        $activestarttime = new-object System.TimeSpan($JobStartHour, $JobStartMinute, $JobStartSecond)
        $activeendtime = new-object System.TimeSpan($JobEndHour, $JobEndMinute, $JobEndSecond)
        
        $SQLJobSchedule.ActiveStartTimeOfDay = $activestarttime
        $SQLJobSchedule.ActiveEndTimeOfDay = $activeendtime
        
        $SQLJobSchedule.FrequencyInterval = 1
        

        $JobStartDate = $job.Frequency.StartDate

        $JobStartDateDay =  $JobStartDate.ToString().Split('/')[0]

        $JobStartDateMonth = $JobStartDate.ToString().Split('/')[1]

        $JobStartDateYear = $JobStartDate.ToString().Split('/')[2]
        $startdate = new-object System.DateTime($JobStartDateYear,  $JobStartDateMonth,  $JobStartDateDay)
        

        $JobEndDate = $job.Frequency.EndDate

        $JobEndDateDay =  $JobEndDate.ToString().Split('/')[0]

        $JobEndDateMonth = $JobEndDate.ToString().Split('/')[1]

        $JobEndDateYear = $JobEndDate.ToString().Split('/')[2]

        $enddate = new-object System.DateTime($JobEndDateYear,  $JobEndDateMonth,  $JobEndDateDay)

        $SQLJobSchedule.ActiveStartDate = $startdate
        $SQLJobSchedule.ActiveEndDate = $enddate
        $SQLJobSchedule.Create()
        }
        'Weekly'{
            $Type = $job.Frequency.Type

        $SQLJobSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.Smo.Agent.FrequencyTypes]::$Type
        #$SubType = $job.Frequency.SubType
        $SQLJobSchedule.FrequencyInterval = [Microsoft.SqlServer.Management.Smo.Agent.WeekDays]::$SubType
        $SQLJobSchedule.FrequencyRecurrenceFactor = $job.Frequency.Interval

        $JobStartTime = $job.Frequency.StartTime
        $JobStartHour = $JobStartTime.ToString().Split(':')[0]
        $JobStartMinute = $JobStartTime.ToString().Split(':')[1]
        $JobStartSecond = $JobStartTime.ToString().Split(':')[2]

        $JobEndTime = $job.Frequency.Endtime
        $JobEndHour = $JobEndTime.ToString().Split(':')[0]
        $JobEndMinute = $JobEndTime.ToString().Split(':')[1]
        $JobEndSecond = $JobEndTime.ToString().Split(':')[2]


        $activestarttime = new-object System.TimeSpan($JobStartHour, $JobStartMinute, $JobStartSecond)
        $activeendtime = new-object System.TimeSpan($JobEndHour, $JobEndMinute, $JobEndSecond)
        
        $SQLJobSchedule.ActiveStartTimeOfDay = $activestarttime
        $SQLJobSchedule.ActiveEndTimeOfDay = $activeendtime
        
        $SQLJobSchedule.FrequencyInterval = 1
        

        $JobStartDate = $job.Frequency.StartDate

        $JobStartDateDay =  $JobStartDate.ToString().Split('/')[0]

        $JobStartDateMonth = $JobStartDate.ToString().Split('/')[1]

        $JobStartDateYear = $JobStartDate.ToString().Split('/')[2]
        $startdate = new-object System.DateTime($JobStartDateYear,  $JobStartDateMonth,  $JobStartDateDay)
        

        $JobEndDate = $job.Frequency.EndDate

        $JobEndDateDay =  $JobEndDate.ToString().Split('/')[0]

        $JobEndDateMonth = $JobEndDate.ToString().Split('/')[1]

        $JobEndDateYear = $JobEndDate.ToString().Split('/')[2]

        $enddate = new-object System.DateTime($JobEndDateYear,  $JobEndDateMonth,  $JobEndDateDay)

        $SQLJobSchedule.ActiveStartDate = $startdate
        $SQLJobSchedule.ActiveEndDate = $enddate
        $SQLJobSchedule.Create()

        }
        'Monthly'{
            $Type = $job.Frequency.Type

            $SQLJobSchedule.FrequencyTypes = [Microsoft.SqlServer.Management.Smo.Agent.FrequencyTypes]::$Type
            $SubType = $job.Frequency.SubType
            $SQLJobSchedule.FrequencyInterval = [Microsoft.SqlServer.Management.Smo.Agent.MonthlyRelativeWeekDays]::$SubType
           $SQLJobSchedule.FrequencyRecurrenceFactor = $job.Frequency.Interval

        $JobStartTime = $job.Frequency.StartTime
        $JobStartHour = $JobStartTime.ToString().Split(':')[0]
        $JobStartMinute = $JobStartTime.ToString().Split(':')[1]
        $JobStartSecond = $JobStartTime.ToString().Split(':')[2]

        $JobEndTime = $job.Frequency.Endtime
        $JobEndHour = $JobEndTime.ToString().Split(':')[0]
        $JobEndMinute = $JobEndTime.ToString().Split(':')[1]
        $JobEndSecond = $JobEndTime.ToString().Split(':')[2]


        $activestarttime = new-object System.TimeSpan($JobStartHour, $JobStartMinute, $JobStartSecond)
        $activeendtime = new-object System.TimeSpan($JobEndHour, $JobEndMinute, $JobEndSecond)
        
        $SQLJobSchedule.ActiveStartTimeOfDay = $activestarttime
        $SQLJobSchedule.ActiveEndTimeOfDay = $activeendtime
        
        $SQLJobSchedule.FrequencyInterval = 1
        

        $JobStartDate = $job.Frequency.StartDate

        $JobStartDateDay =  $JobStartDate.ToString().Split('/')[0]

        $JobStartDateMonth = $JobStartDate.ToString().Split('/')[1]

        $JobStartDateYear = $JobStartDate.ToString().Split('/')[2]
        $startdate = new-object System.DateTime($JobStartDateYear,  $JobStartDateMonth,  $JobStartDateDay)
        

        $JobEndDate = $job.Frequency.EndDate

        $JobEndDateDay =  $JobEndDate.ToString().Split('/')[0]

        $JobEndDateMonth = $JobEndDate.ToString().Split('/')[1]

        $JobEndDateYear = $JobEndDate.ToString().Split('/')[2]

        $enddate = new-object System.DateTime($JobEndDateYear,  $JobEndDateMonth,  $JobEndDateDay)

        $SQLJobSchedule.ActiveStartDate = $startdate
        $SQLJobSchedule.ActiveEndDate = $enddate
        $SQLJobSchedule.Create()

        }
    }
    }
}

function Remove-SqlServerAgentJob {	
    [OutputType([bool])]
    [CmdletBinding()]
    param(
    [parameter(Position = 0,
    ValueFromPipeline = $true,
    Mandatory = $true
    )]
    [System.Data.SqlClient.SqlConnection] 
    $SqlServerConnection,
    [parameter(Position = 1,
    ValueFromPipelineByPropertyName = $true,
    Mandatory = $true,
    ParameterSetName = 'ParamSet1')]
    [String] 
    $JobName,
    [parameter(Position = 1,
    ValueFromPipelineByPropertyName = $true,
    Mandatory = $true,
    ParameterSetName = 'ParamSet2')]
    [String] 
    $ParamFilePath
    )

    $status = $true

   

    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            try {
                $SqlServer = $SqlServerConnection.DataSource;
                $SqlJobServer = new-object Microsoft.SqlServer.Management.Smo.Server($SqlServer)

                   
                $job = Get-SqlServerAgentJob -SmoServer $SqlJobServer -JobName $JobName 
                if ($job) {
                    try {
                        Write-Host "Removing SQL Server agent job $JobName from server '$($SmoServer.Name)'"
                        $job.Drop()
                    }
                    catch {
                        Write-Error "Error in removing job '$jobName' from server'$($SmoServer.Name)' : $_"
                        $status = $false
                    }
                }
                else {
                    Write-Error "Job '$JobName' does not exist in server $($SmoServer.Name)."
                    $status = $false
                }

            }
            catch {
                Write-Error "Error getting job '$jobName' : $ErrorVar"	
                $status = $false	
            }
            break
        }
        'ParamSet2' { 
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
	
		foreach ($job in $param.job) 
		{
            try {
                $JobName = $job.Name;
                $SqlServer = $SqlServerConnection.DataSource;
                $SqlJobServer = new-object Microsoft.SqlServer.Management.Smo.Server($SqlServer)
                    
                $job = Get-SqlServerAgentJob -SmoServer $SqlJobServer -JobName $JobName 
                if ($job) {
                    try {
                        Write-Verbose "Removing SQL Server agent job $JobName from server '$($SmoServer.Name)'"
                        $job.Drop()
                    }
                    catch {
                        Write-Error "Error in removing job '$jobName' from server'$($SmoServer.Name)' : $_"
                        $status = $false
                    }
                }
                else {
                    Write-Error "Job '$JobName' does not exist in server $($SmoServer.Name)."
                    $status = $false
                }

            }
            catch {
                Write-Error "Error getting job '$jobName' : $ErrorVar"	
                $status = $false	
            }
        }
            break
        }
    }

    
	
   	

    return $status	 
}




function Get-SqlServerAgentJob {	
    [OutputType([Microsoft.SqlServer.Management.Smo.Agent.Job])]
    [CmdletBinding()]
    param(
        [parameter(Position = 1,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true)]
        [String] 
        $JobName,

        [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true)]
        [Microsoft.SqlServer.Management.Smo.Server] 
        $SmoServer
    )
			
    try {
        Write-Verbose "Getting SQL Server agent job $JobName from server '$($SmoServer.Name)'"
        $job = $SmoServer.JobServer.Jobs[$JobName]
	}
	
    catch {
        Write-Error Write-Error "Error getting folder '$JobName' : $_"
    }
	 
    return $job
}

function New-SsisCatalogFolder {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,	

        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet3')]
        [string]		
        $ParamFilePath,

        [Parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.Catalog]
        $Catalog,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    $folder = @()	
    switch ($PSCmdlet.ParameterSetName) {		
        'ParamSet1' { 
            $catalog1 = $Catalog
            break
        }
        'ParamSet2' { 
            $catalog1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection
            break
        }
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder += New-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog1
            }

            return $folder
        }
    }

    $props = @{TypeName = "Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder";
        ArgumentList = ($catalog1, $FolderName, $FolderName);
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }

			
    try {
        Write-Verbose "Creating folder '$FolderName' in catalog '$($catalog1.Name)'"
        Write-Debug "Command properties : $($props | Out-String)"
        $folder = New-Object @props
    }
    catch {
        Write-Error "Error creating folder object '$FolderName' : $ErrorVar"
    }
	
    try {
        $folder.Create()
    }
    catch {
        Write-Error "Error creating folder '$FolderName' in catalog '$($catalog1.Name)' : $_"
    }
    return $folder
}

function Remove-SsisCatalogFolder {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,	

        [parameter(Position = 0,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet3')]
        [string]		
        $ParamFilePath,

        [Parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.Catalog]
        $Catalog,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    $status = $true
    switch ($PSCmdlet.ParameterSetName) {		
        'ParamSet1' { 
            $catalog1 = $Catalog
            break
        }
        'ParamSet2' { 
            $catalog1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection
            break
        }
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $status = $status -and $(Remove-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog1) 
            }

            return $status
        }
    }

    try {
        $folder = Get-SsisCatalogFolder -FolderName $FolderName -Catalog $catalog1
    }
    catch {
        Write-Error "Error getting folder object '$FolderName' : $ErrorVar"	
        $status = $false	
    }	
		
    if ($folder) {	
        try {
            Write-Verbose "Removing folder '$FolderName' from catalog '$($catalog1.Name)'"
            $folder.Drop()
        }
        catch {
            Write-Error "Error in removing folder '$FolderName' from catalog '$($catalog1.Name)' : $_"
            $status = $false
        }
    }
    else {
        Write-Error "Folder '$FolderName' does not exist."
        $status = $false
    }

    return $status
}

function Get-SsisCatalogFolder {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder])]	
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]
        $FolderName,

        [parameter(Position = 1,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.Catalog] 
        $Catalog,
		
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    if ($PSCmdlet.ParameterSetName -eq 'ParamSet1') {
        $catalog1 = $Catalog
    }
    else {
        $catalog1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection
    }

	
    try {		
        Write-Verbose "Getting folder '$FolderName' in catalog '$($catalog1.Name)'"		
        $folder = $catalog1.Folders[$FolderName]
    }
    catch {
        Write-Error "Error getting folder '$FolderName' : $_"
    }	

    return $folder
}

function New-SsisProject {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]				
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectName,

        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		 
        [string]		
        $ParamFilePath,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectFilePath,

        [parameter(Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [string]		
        $ProjectFilePathPrefix = '',

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 2,				
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]		 
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    $project = @()	
    switch ($PSCmdlet.ParameterSetName) {		
        'ParamSet1' { 
            $folder1 = $Folder
            break
        }
        'ParamSet2' { 
            $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection |	Get-SsisCatalogFolder -FolderName $FolderName
        }		
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection
			
            foreach ($fldr in $param.Catalog.Folder) {
                $folder1 = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog			
                foreach ($proj in $fldr.Project) {
                    $project += New-SsisProject -ProjectName $proj.Name -ProjectFilePath ($ProjectFilePathPrefix + $proj.FilePath) -Folder $folder1  
                } 
            }

            return $project
        }
    }		
	
    try {
        [byte[]] $projectFileContent = [System.IO.File]::ReadAllBytes($ProjectFilePath)
    }
    catch {
        Write-Error "Error in reading Ssis project file from path '$ProjectFilePath' : $_"
    }
	
	
    try {
        Write-Verbose "Deploying project '$ProjectName' in folder '$($folder.Name)'"
        [void] $folder.DeployProject($ProjectName, $projectFileContent)
    }
    catch {
        Write-Error "Error in deploying Ssis project '$ProjectName' in folder '$($folder1.Name)' : $_"
    }	

    return $Folder.Projects[$ProjectName]	
}

function Remove-SsisProject {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]				
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectName,

        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [string]		
        $ParamFilePath,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectFilePath,		

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection		
    )
	
    $status = $true
    switch ($PSCmdlet.ParameterSetName) {		
        'ParamSet1' { 
            $folder1 = $Folder
            break
        }
        'ParamSet2' { 
            $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection |	Get-SsisCatalogFolder -FolderName $FolderName
        }
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection			

            foreach ($fldr in $param.Catalog.Folder) {
                $folder1 = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog			
                foreach ($proj in $fldr.Project) {			
                    $status = $status -and $(Remove-SsisProject -ProjectName $proj.Name -ProjectFilePath $proj.FilePath -Folder $folder1)
                } 
            }

            return $status
        }
    }		
	
    try {
        $project = Get-SsisProject -ProjectName $ProjectName -folder $folder1
    }
    catch {
        Write-Error "Error getting project object '$ProjectName' : $ErrorVar"
        $status = $false
    }
		
    if ($project) {	
        try {
            Write-Verbose "Removing project '$ProjectName' from folder '$($folder1.Name)'"
            $project.Drop()
        }
        catch {
            Write-Error "Error in removing project '$ProjecName' from folder '$($folder1.Name)' : $_"
            $status = $false
        }
    }
    else {
        Write-Error "Project '$ProjectName' does not exist."
        $status = $false
    }

    return $status
}


function Get-SsisProject {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string]		
        $ProjectName,		

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection		
    )
	
    if ($PSCmdlet.ParameterSetName -eq 'ParamSet1') {
        $folder1 = $Folder
    }
    else {
        $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName
    }	

	
    try {
        Write-Verbose "Getting project '$ProjectName' in folder '$($folder1.Name)'"	
        $project = $folder1.Projects[$ProjectName];
    }
    catch {		
        Write-Error "Error getting project '$ProjectName' : $_"
    }

    return $project
}

function New-SsisEnvironment {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo])]	
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [string]		
        $EnvName,		

        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [string]		
        $ParamFilePath,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    $environment = @()
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            $folder1 = $Folder
            break
        }
        'ParamSet2' {
            $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection |	Get-SsisCatalogFolder -FolderName $FolderName
            break
        }
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder1 = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog
                foreach ($envr in $fldr.Environment) {
                    $environment += New-SsisEnvironment -EnvName $envr.Name -Folder $folder1
                }
            }

            return $environment
        }
    }
	
    $props = @{TypeName = "Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo";
        ArgumentList = ($folder1, $EnvName, $EnvName);
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
	
			
    try {
        Write-Verbose "Creating environment '$EnvName' in folder '$($folder1.Name)'"
        Write-Debug "Command properties : $($props | Out-String)"
        $environment = New-Object @props
    }
    catch {
        Write-Error "Error creating environment object '$EnvName' : $ErrorVar"
    }
	
    try {
        $environment.Create()
    }
    catch {
        Write-Error "Error creating environment '$EnvName' in folder '$($folder1.Name)' : $_"
    }
    return $environment
}


function Remove-SsisEnvironment {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [string]		
        $EnvName,		

        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [string]		
        $ParamFilePath,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    $status = $true
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            $folder1 = $Folder
            break
        }
        'ParamSet2' {
            $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection |	Get-SsisCatalogFolder -FolderName $FolderName
            break
        }
        'ParamSet3' {
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder1 = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog
                foreach ($envr in $fldr.Environment) {
                    $status = $status -and $(Remove-SsisEnvironment -EnvName $envr.Name -Folder $folder1)
                }
            }

            return $status
        }
    }
		
    try {
        $environment = Get-SsisEnvironment -EnvName $EnvName -folder $folder1
    }
    catch {
        Write-Error "Error getting environment object '$EnvName' : $ErrorVar"
        $status = $false
    }
	
	
    if ($environment) {	
        try {
            Write-Verbose "Removing environment '$EnvName' from folder '$($folder1.Name)'"
            $environment.Drop()
        }
        catch {
            Write-Error "Error in removing environment '$EnvName' from folder '$($folder1.Name)' : $_"
            $status = $false
        }
    }
    else {
        Write-Error "Project '$EnvName' does not exist."
        $status = $false
    }

    return $status
}

function Get-SsisEnvironment {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo])]	
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]		
        [string]		
        $EnvName,		

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]		
        $Folder,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,		

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )

    if ($PSCmdlet.ParameterSetName -eq 'ParamSet1') {
        $folder1 = $Folder
    }
    else {
        $folder1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName
    }
	
	
    try {
        Write-Verbose "Getting environment '$EnvName' in folder '$($folder1.Name)'"
        $environment = $folder1.Environments[$EnvName]
    }
    catch {
        Write-Error "Error getting folder '$EnvName' : $_"
    }
	
    return $environment
}

function New-SsisProjectEnvReference {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $EnvName,
	
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [string]		
        $EnvFolderName,	
		
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [string]		
        $ParamFilePath,		
		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo]		
        $Project,
		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectName,		

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    $reference = @()
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            $project1 = $Project
            break
        }
        'ParamSet2' { 
            $project1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName |	Get-SsisProject -ProjectName $ProjectName
            break		
        }
        'ParamSet3' { 
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog
                foreach ($proj in $fldr.Project) {
                    $project1 = Get-SsisProject -ProjectName $proj.Name -Folder $folder
                    foreach ($ref in $proj.Reference) {
                        $reference += New-SsisProjectEnvReference -EnvName $ref.EnvName -EnvFolderName $ref.EnvFolderName -Project  $project1
                    }
                }
            }	

            return $reference
        }
    }
	
    try {
        Write-Verbose "Adding reference ( environment : '$EnvName', folder : '$EnvFolderName' ) to project '$($project1.Name)'"
        $project1.References.Add($EnvName, $EnvFolderName)
    }
    catch {
        Write-Error "Error in adding reference ( environment : '$EnvName', folder : '$EnvFolderName' ) to project '$($project1.Name)' : $_"
    }
	
    try {
        $project1.Alter()
    }
    catch {
        Write-Error "Error in altering projct project '$($project1.Name)'  to add reference ( environment : '$EnvName', folder : '$EnvFolderName' ) : $_"
    }

    return $project1.References.Item($EnvName, $EnvFolderName)
}


function New-SqlAgentJobEnvReference {
    [OutputType([bool])]
        [CmdletBinding()]
            param(
            [parameter(Position = 0,
            ValueFromPipeline = $true,
            Mandatory = $true
            )]
            [System.Data.SqlClient.SqlConnection] 
            $SqlServerConnection,
            [parameter(Position = 1,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
            [String] 
            $JobName,
            [parameter(Position = 2,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
            [String] 
            $EnvName,
            [parameter(Position = 3,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
            [String] 
            $EnvFolderName,
            [parameter(Position = 3,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet1')]
            [String] 
            $ProjectName,
            [parameter(Position = 1,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
            [String] 
            $ParamFilePath
        )

	
   
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
         $SmoServer=   Get-SmoServer -SqlServerConnection $SqlServerConnection
            $job = $SmoServer.JobServer.Jobs[$JobName]
            foreach($step in $job.JobSteps)
            {
                $steparr = $step.Command.Split('/')[1];
                $arr = $steparr.Split('\');
                $stepproject = $arr[4];
                $steppackage = $arr[5];

                #$environmentReference = $SqlServerConnection | Get-SsisEnvironment -EnvName $EnvName -FolderName $EnvFolderName
                #$environmentReferenceid =  $environmentReference.EnvironmentId
                $proj =  $SqlServerConnection | Get-SsisProject -ProjectName $ProjectName -FolderName $EnvFolderName
                $environmentReference = $proj.References[$EnvName,$EnvFolderName]
                $environmentReference.Refresh()
                $environmentReferenceid = $environmentReference.ReferenceId; 
                $Command = '/ISSERVER "\"\SSISDB\'+$EnvFolderName+'\'+$stepproject+'\'+$steppackage+'\"" /SERVER "\"'+$SqlServerConnection.DataSource+'\"" /ENVREFERENCE '+$environmentReferenceid+' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'
                $Step.Command  = $command
                $step.Alter()
            }
           
            break
        }
        'ParamSet2' { 
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            
            foreach ($job in $param.job) 
		    {

             $JobName = $job.Name;
             $SqlServer = $SqlServerConnection.DataSource;
             $SqlJobServer = Get-SmoServer -SqlServerConnection $SqlServerConnection
             $jobStatus = Get-SqlServerAgentJob -SmoServer $SqlServer -JobName $JobName
             $SmoServer=   Get-SmoServer -SqlServerConnection $SqlServerConnection
             $jobInstance = $SmoServer.JobServer.Jobs[$JobName]
               
             if($jobStatus)
			    {
                foreach($stepfromjson in $job.Step)
                    {

                    foreach ($step in $jobInstance.JobSteps) 
                        {

                        if($stepfromjson.Name -eq $step.Name)
                            {
                  
                                $environmentReference = $SqlServerConnection | Get-SsisEnvironment -EnvName $stepfromjson.Environment.Name -FolderName $stepfromjson.Environment.Folder
                                $environmentReferenceid =  $environmentReference.Environment
                                $environmentReference.Refresh()
                                $environmentReferenceid =  $environmentReference.EnvironmentId
                                $Command = '/ISSERVER "\"\SSISDB\'+$stepfromjson.Folder+'\'+$stepfromjson.Project+'\'+$stepfromjson.Package+'\"" /SERVER "\"'+$SqlServerConnection.DataSource+'\"" /ENVREFERENCE '+$environmentReferenceid+' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'
                                $Command = $Command.Replace("[REFERENCEID]", $environmentReferenceid)  
                                $Command = $Command.Replace("[FOLDER]", $stepfromjson.Folder)
                                $Command = $Command.Replace("[PROJECT]",$stepfromjson.Project)
                                $Command = $Command.Replace("[PACKAGE]",$stepfromjson.Package)
                                $Command = $Command.Replace("[INSTANCE]",  $SqlServerConnection.DataSource )
                                $step.Command  = $command
                                $step.Alter()
                            }           

                        }
                    }
                }

            }
        }
     
    }
}




function Get-SsisPackage {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.PackageInfo])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $PackageName,
	
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo]		
        $Project,
				 
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [string]		
        $FolderName,			 
		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectName,		

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]		
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    if ($PSCmdlet.ParameterSetName -eq 'ParamSet1') {
        $project1 = $Project		
    }
    else {
        $project1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName |	Get-SsisProject -ProjectName $ProjectName
    }		

    try {
        Write-Verbose "Getting package '$PackageName' in project '$($Project.Name)'"	
        $package = $project1.Packages["$PackageName"];
    }
    catch {		
        Write-Error "Error getting project '$PackageName' : $_"
    }

    return $package
}

function Invoke-SsisPackage2 {
    [OutputType([System.Int64])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [Microsoft.SqlServer.Management.IntegrationServices.PackageInfo]		
        $Package,		 
		
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $PackageName,	

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference]	
        $EnvReference,		 
		 
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $EnvName,	

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $EnvFolderName,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $ProjectName,			

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $ProjectFolderName,
		 
        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 5,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet4')]	
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection,

        [parameter(Position = 2,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]	
        [parameter(Position = 3,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]	
        [parameter(Position = 4,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 6,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]	
        [bool]		
        $use32RuntimeOn64 = $false,

        [switch]		
        $Synchronized
    )
	
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' {  
            $package1 = $Package
            $envReference1 = $EnvReference
        }
        'ParamSet2' {  
            $package1 = $Package
            $envReference1 = $null
        }
        'ParamSet3' {  
            $package1 = Get-SsisPackage -PackageName $PackageName -ProjectName $ProjectName -FolderName  $ProjectFolderName -SqlServerConnection $SqlServerConnection
            $envReference1 = $null
        }
        'ParamSet4' {  
            $project = Get-SsisProject -ProjectName $ProjectName -FolderName $ProjectFolderName -SqlServerConnection $SqlServerConnection
            $package1 = Get-SsisPackage -PackageName $PackageName -Project $project
            $envReference1 = $project.References[$EnvName, $EnvFolderName]	
        }
    }
		
    $props = @{TypeName = 'System.Collections.ObjectModel.Collection[Microsoft.SqlServer.Management.IntegrationServices.PackageInfo+ExecutionValueParameterSet]';
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }
    try {
        Write-Verbose "Creating execution value parameter set collection for package '$($package1.Name)'"
        Write-Debug "Command properties : $($props | Out-String)"
        $execValParmsColn = New-Object @props		
    }
    catch {
        Write-Error "Error creating execution value parameter set collection for package '$($package1.Name)' : $ErrorVar"
    }

    if ($Synchronized) {

        $props = @{TypeName = 'Microsoft.SqlServer.Management.IntegrationServices.PackageInfo+ExecutionValueParameterSet';
            ErrorAction = 'Stop';
            ErrorVariable = 'ErrorVar'
        }
        try {
            Write-Verbose "Creating execution value parameter set for executing package '$($package1.Name)' synchronously"
            Write-Debug "Command properties : $($props | Out-String)"
            $execValParms = New-Object 'Microsoft.SqlServer.Management.IntegrationServices.PackageInfo+ExecutionValueParameterSet';
            $execValParms.ObjectType = 50;
            $execValParms.ParameterName = "SYNCHRONIZED";
            $execValParms.ParameterValue = 1;
        }
        catch {
            Write-Error "Error creating execution value parameter set for package '$($package1.Name)' : $ErrorVar"
        }
        try {
            Write-Verbose "Adding execution value parameter set to collection for package '$($package1.Name)'"		
            $execValParmsColn.Add($execValParms);   
        }
        catch {
            Write-Error "Error adding execution value parameter set to collection for package '$($package1.Name)' : $ErrorVar"
        }
		
    }

    try {
        Write-Verbose "Executing package '$($package1.Name)'"	
        $execId = $package1.Execute($use32RuntimeOn64, $envReference1, $execValParmsColn); 
    }
    catch {		
        Write-Error "Error executing package '$($package1.Name)' : $_"
    }	

    return $execId
}
function Invoke-SsisPackage {
    [OutputType([System.Int64])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [Microsoft.SqlServer.Management.IntegrationServices.PackageInfo]		
        $Package,		 
		
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $PackageName,	

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference]	
        $EnvReference,		 
		 
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $EnvName,	

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $EnvFolderName,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $ProjectName,			

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]
        [string]		
        $ProjectFolderName,
		 
        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 5,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet4')]	
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection,

        [parameter(Position = 2,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]	
        [parameter(Position = 3,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]	
        [parameter(Position = 4,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 6,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]	
        [bool]		
        $use32RuntimeOn64 = $false,

        [parameter(Position = 3,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]	
        [parameter(Position = 4,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]	
        [parameter(Position = 5,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [parameter(Position = 7,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet4')]	
        [int32]		
        $TimeOutInSeconds = 300,

        [switch]		
        $Synchronized
    )
	
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' {  
            $package1 = $Package
            $envReference1 = $EnvReference
        }
        'ParamSet2' {  
            $package1 = $Package
            $envReference1 = $null
        }
        'ParamSet3' {  
            $package1 = Get-SsisPackage -PackageName $PackageName -ProjectName $ProjectName -FolderName  $ProjectFolderName -SqlServerConnection $SqlServerConnection
            $envReference1 = $null
        }
        'ParamSet4' {  
            $project = Get-SsisProject -ProjectName $ProjectName -FolderName $ProjectFolderName -SqlServerConnection $SqlServerConnection
            $package1 = Get-SsisPackage -PackageName $PackageName -Project $project
            $envReference1 = $project.References[$EnvName, $EnvFolderName]	
        }
    }
	
    $sqlCmdText = "[SSISDB].[catalog].[create_execution]"
    $props = @{TypeName = ' System.Data.SqlClient.SqlCommand';
        ArgumentList = ($SqlCmdText, $SqlServerConnection)
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }

    try {
        Write-Verbose "Creating SQL command for creating package execution"
        Write-Debug "Command properties : $($props | Out-String)"
        $sqlCommand = New-Object @props		
    }
    catch {
        Write-Error "Error creating SQL command for creating package execution : $ErrorVar"
    }

    try {
        Write-Verbose "Creating package execution '$($package1.Name)'"
        $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
        $sqlCommand.CommandTimeout = $TimeOutInSeconds
        $sqlCommand.Parameters.AddWithValue("package_name", $package1.Name) | Out-Null
        $sqlCommand.Parameters.AddWithValue("project_name", $package1.Parent.Name) | Out-Null
        $sqlCommand.Parameters.AddWithValue("folder_name", $package1.Parent.Parent.Name) | Out-Null
        if ($envReference1) {
            $sqlCommand.Parameters.Add("reference_id", $envReference1.ReferenceId) | Out-Null	
        }
        if ($use32RuntimeOn64) {
            $sqlCommand.Parameters.Add("use32bitruntime", [System.Data.SqlDbType]::Bit).Value = $RunIn32Bit.IsPresent			
        }
        $sqlCommand.Parameters.Add("execution_id", [System.Data.SqlDbType]::BigInt).Direction = [System.Data.ParameterDirection]::Output

        $sqlCommand.ExecuteNonQuery() | Out-Null
        [int64]$execId = $sqlCommand.Parameters["execution_id"].Value
    } 
    catch {		
        Write-Error "Error creating package execution '$($package1.Name)' : $_"
    }

    if ($Synchronized) {    
        $sqlCmdText = "[SSISDB].[catalog].[set_execution_parameter_value]"
        $props = @{TypeName = ' System.Data.SqlClient.SqlCommand';
            ArgumentList = ($SqlCmdText, $SqlServerConnection)
            ErrorAction = 'Stop';
            ErrorVariable = 'ErrorVar'
        }

        try {
            Write-Verbose "Creating SQL command for creating parameter set for synchronous package execution"
            Write-Debug "Command properties : $($props | Out-String)"
            $sqlCommand = New-Object @props		
        }
        catch {
            Write-Error "Error creating SQL command for creating parameter set for synchronous package execution : $ErrorVar"
        }

        try {			
            Write-Verbose "Creating parameter set for executing package '$($package1.Name)' synchronously"
            $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
            $sqlCommand.CommandTimeout = $TimeOutInSeconds
            $sqlCommand.Parameters.AddWithValue("execution_id", $execId) | Out-Null
            $sqlCommand.Parameters.AddWithValue("object_type", 50) | Out-Null
            $sqlCommand.Parameters.AddWithValue("parameter_name", "SYNCHRONIZED") | Out-Null
            $sqlCommand.Parameters.AddWithValue("parameter_value", 1) | Out-Null
            $sqlCommand.ExecuteNonQuery() | Out-Null
        }
        catch {
            Write-Error "Error creating parameter set for executing package '$($package1.Name)' synchronously : $_"
        }
    }

    $sqlCmdText = "[SSISDB].[catalog].[start_execution]"
    $props = @{TypeName = ' System.Data.SqlClient.SqlCommand';
        ArgumentList = ($SqlCmdText, $SqlServerConnection)
        ErrorAction = 'Stop';
        ErrorVariable = 'ErrorVar'
    }

    try {
        Write-Verbose "Creating SQL command for starting package execution"
        Write-Debug "Command properties : $($props | Out-String)"
        $sqlCommand = New-Object @props		
    }
    catch {
        Write-Error "Error creating SQL command for starting package execution: $ErrorVar"
    }

    try {		
        Write-Verbose "Starting execution of package '$($package1.Name)' "	
        $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
        $sqlCommand.CommandTimeout = $TimeOutInSeconds
        $sqlCommand.Parameters.AddWithValue("execution_id", $execId) | Out-Null
        $sqlCommand.ExecuteNonQuery() | Out-Null
    }
    catch {
        Write-Error "Error executing package '$($package1.Name)' : $_"
    }

    return $execId
}


function Set-SsisProjectParameterValue {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ParamName,

        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ParamValue,

        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ParamValueType,		
		
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]		
        [string]		
        $ParamFilePath,		
		
        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo]		
        $Project,

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [string]		
        $FolderName,	
		
        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $ProjectName,		

        [parameter(Position = 5,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet2')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection
    )
	
    $parameter = @()
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            $project1 = $Project
            break
        }
        'ParamSet2' { 
            $project1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName |	Get-SsisProject -ProjectName $ProjectName
            break		
        }
        'ParamSet3' { 
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog
                foreach ($proj in $fldr.Project) {
                    $project1 = Get-SsisProject -ProjectName $proj.Name -Folder $folder
                    foreach ($param in $proj.Parameter) {
						
                        if ($param.ValueType) {
                            $valueType = $param.ValueType
                        }
                        else {
                            $valueType = 'Referenced'							
                        }

                        $parameter += Set-SsisProjectParameterValue -ParamName $param.Name -ParamValue $param.Value -ParamValueType $valueType -Project $project1
                    }
                }
            }	

            return $parameter
        }
    }
	
    try {
        Write-Verbose "Setting value of parameter '$ParamName' in project '$($project1.Name)'"

        if ($ParamValueType -eq 'Literal') {
            $project1.Parameters[$ParamName].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Literal, $ParamValue)
			
        }
        elseif ($ParamValueType -eq 'Referenced') {
            $project1.Parameters[$ParamName].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $ParamValue)
			
        }
        else {
            Write-Error "Invalid parameter value type '$ParamValueType' for parameter '$ParamName' in project '$($project1.Name)', please use 'Literal or 'Referenced'."
        }

    }
    catch {
        Write-Error "Error in setting value for parameter '$ParamName' in project '$($project1.Name)' : $_"
    }
	
    try {
        $project1.Alter()
    }
    catch {
        Write-Error "Error in altering project '$($project1.Name)'  to set value of parameter '$ParamName' : $_"
    }

    return $parameter
}

function New-SsisEnvironmentVariable {
    [OutputType([Microsoft.SqlServer.Management.IntegrationServices.EnvironmentVariable])]
    [CmdletBinding()]
    param(				
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $VarName,				
		
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [System.Object]		
        $VarValue,		
		
        [parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet3')]
        [String]
        $ParamFilePath,
		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet1')]
        [Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo]		
        $Environment,
		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $EnvName,	

        [parameter(Position = 3,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $FolderName,
		
        [parameter(Position = 4,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]		
        [parameter(Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'ParamSet3')]		
        [System.Data.SqlClient.SqlConnection] 
        $SqlServerConnection,

        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [string]		
        $VarDescription = '',

        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [System.TypeCode]		
        $VarType = 'String',

        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet1')]
        [parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParamSet2')]
        [bool]		
        $VarSensitive = $false		
    )

    $variable = @()
    switch ($PSCmdlet.ParameterSetName) {
        'ParamSet1' { 
            $environment1 = $Environment
            break
        }
        'ParamSet2' { 
            $environment1 = Get-SsisCatalog -SqlServerConnection $SqlServerConnection | Get-SsisCatalogFolder -FolderName $FolderName |	Get-SsisEnvironment -EnvName $EnvName
            break		
        }
        'ParamSet3' { 
            $param = Get-Content $ParamFilePath | ConvertFrom-Json
            $catalog = Get-SsisCatalog -SqlServerConnection $SqlServerConnection

            foreach ($fldr in $param.Catalog.Folder) {
                $folder = Get-SsisCatalogFolder -FolderName $fldr.Name -Catalog $catalog
                foreach ($envr in $fldr.Environment) {
                    $environment1 = Get-SsisEnvironment -EnvName $envr.Name -Folder $folder

                    foreach ($var in $envr.Variable) {						
                        $parms = @{}						
                        $parms.Add('VarName', $var.Name)
                        $parms.Add('VarValue', $var.Value)
                        if ($var.Description) {
                            $parms.Add('VarDescription', $var.Description)
                        }
                        if ($var.Type) {
                            $parms.Add('VarType', $var.Type)
                        }	
                        if ($var.Sensitive) {
                            $parms.Add('VarSensitive', $var.Sensitive)
                        }										

                        $variable += New-SsisEnvironmentVariable @parms -Environment $environment1
                    }
                }
            }	

            return $variable
        }
    }
	
	
    try {	
        Write-Verbose "Adding variable '$VarName' to environment '$($environment1.Name)'"
        $environment1.Variables.Add($VarName, $VarType, $VarValue, $VarSensitive, $VarDescription)
    }
    catch {
        Write-Error "Error in adding variable '$VarName' to environment '$($environment1.Name)' : $_"
    }

    try {	
        $environment1.Alter()
    }
    catch {
        Write-Error "Error in altering environment '$($environment1.Name)' to add variable '$VarName' : $_"
    }

    return $environment1.Variables.Item($VarName)
}


$ErrorActionPreference = 'Stop'
# Load the IntegrationServices assembly
loadSsisAssembly -Version $SsisAssemblyVersion

# Load the SQL Service Management Object Assembly
loadSmoAssembly -Version $SmoAssemblyVersion