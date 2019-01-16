<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.156
	 Created on:   	1/10/2019 11:03 AM
	 Created by:   	dschauland
	 Organization: 	
	 Filename:     	Set-JMGCPStorageLogging.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


Import-Module GoogleCloud
function Set-JMGCPStorageLogging
{
	[cmdletbinding()]
	param (
		[string]$project,
		[switch]$logonly,
	[switch]$disable
		
	)
	
	BEGIN
	{
		if ([string]::IsNullOrEmpty($project))
		{
			$projects = Get-GcpProject
		}
		else
		{
			$projects = $project
		}
		
		
	}
	PROCESS
	{
		foreach ($project in $projects)
		{
			$logobj = New-Object -TypeName System.Management.Automation.PSObject
			$LogFilePath = "C:\temp\$project-log.json"
			
			gsutil acl ch -g cloud-storage-analytics@google.com:W "gs://$project-logs"
			
			gsutil mb -l us-central1 "gs://$project-logs"
			$buckets = gsutil ls -p $project
			
			foreach ($bucket in $buckets)
			{
				
				if (!$disable)
				{
					#check for logging enablement 
					if ((get-gcsbucket $bucket.substring(5, $($bucket.length - 6))).logging.logbucket -eq "$project-logs")
					{
						If ($logonly)
						{
							$logging = $(gsutil logging set on -b "gs://$project-logs" -o AccessLogs $bucket)
							$logging | Out-Null 
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been enabled"}
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
							
							#("{0} - {1}" -f @((Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)) | Out-File -FilePath $LogFilePath -Encoding utf8 -Append
							
							
						}
						Else
						{
							gsutil logging set on -b "gs://$project-logs" -o AccessLogs $bucket
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been enabled" }
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
						}
						
						
						
					} 
					Else
					{
						If ($logonly)
						{
							$logging = $(gsutil logging set on -b "gs://$project-logs" -o AccessLogs $bucket)
							$logging | Out-Null
							
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been enabled" }
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
						}
						Else
						{
							gsutil logging set on -b "gs://$project-logs" -o AccessLogs $bucket
							
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been enabled" }
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
							#gsutil logging set on -b "gs://$project-logs" -o AccessLogs $bucket
						}
					} #done checking for existing bucket
					
				} #done checking for not disabled switch
				Else
				{
					If ((get-gcsbucket $bucket.substring(5, $($bucket.length - 6))).logging.logbucket -eq "$project-logs")
					{
						If ($logonly)
						{
							$logging = $(gsutil logging set off -b "gs://$project-logs" -o AccessLogs $bucket)
							$logging | out-null
							
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been disabled" }
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
						}
						Else
						{
							gsutil logging set off -b "gs://$project-logs" -o AccessLogs $bucket
							
							$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging has been disabled" }
							
							$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
							
							$logobj | ConvertTo-Json | Out-File $LogFilePath
							
							#gsutil logging set off -b "gs://$project-logs" -o AccessLogs $bucket
						}
					}
					Else
					{
						$logdata = @{ "Time" = $(Get-Date -Format "yyyy-Mm-dd HH:mm:ss"); "Message" = "Logging already disabled - no new action taken" }
						
						$logobj | Add-Member -Type NoteProperty -Name $bucket -Value $logdata
						
						$logobj | ConvertTo-Json | Out-File $LogFilePath
					}
				}
			}
		}
	}
	End
	{
		#Done 
		#gsutil cp "C:\temp\$project-log.txt" "gs://$project-logs"
		
		If ((gsutil ls -b gs://$project-logs) -eq "$project-logs")
		{
			
			gsutil cp "C:\temp\$Project-log.json" "gs://$project-logs"
		}
		Else
		{
			gsutil mb -l us-central1 "gs://$project-logs"
			gsutil cp "C:\temp\$Project-log.json" "gs://$project-logs"
		}
		
	}
}