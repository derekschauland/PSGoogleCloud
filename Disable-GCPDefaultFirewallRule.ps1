<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.156
	 Created on:   	1/13/2019 5:03 PM
	 Created by:   	 Derek
	 Organization: 	 
	 Filename:     	Disable-GCPDefaultFirewallRule.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Function Disable-GCPDefaultFirewallRule
{
    [cmdletbinding()]
    Param (
        [string]$Project,
        [string]$Network
    )
    
    BEGIN 
    {
        If ($Project -ne $null)
        {
            $projects = Get-GcpProject
        }
        Else
        {
            $projects = $project
        }
    }
    Process
    {
        ForEach ($item In $projects)
        {
            gcloud config set project $item
            
            #check for status of rule - if disabled check date in file and delete 
            If ()
            {
                
            }
            gcloud compute firewall-rules update default-allow-rdp --disabled
            #write file with project name, rule-name, date to bucket in gcp
            
            #check for file in bucket - if file exists, read file - if project and rule listed and date is older than 7 days from get date
            #delete rule
            
            gcloud compute firewall-rules update default-allow-ssh --disabled
            #write file with project name, rule-name, date to bucket in gcp
            
            #check for file in bucket - if file exists, read file - if project and rule listed and date is older than 7 days from get date
            #delete rule
            
        }
    }
    END
    {
    	#write log that rule was disabled or deleted
    }
}
