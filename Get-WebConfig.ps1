#==========================================================================
#
# NAME: Get-WebConfig.ps1
#
# AUTHOR: nnarisak
# EMAIL: noi.narisak@gmail.com
#
# COMMENT: 
#
# You have a royalty-free right to use, modify, reproduce, and
# distribute this script file in any way you find useful, provided that
# you agree that the creator, owner above has no warranty, obligations,
# or liability for such use.
#
# VERSION HISTORY:
# 1.0 12/21/2011 - Initial release
#
# USAGE:
#	.\Get-WebConfig.ps1 -help 
#	.\Get-WebConfig.ps1 -optionalparam1 example 
#
#==========================================================================
#
# Parameters # 
Param ( 
	# Declare parameter(s)
	# [string] $optionalparam1, #an optional parameter with no default value 
    	# [string] $optionalparam2 = "default", #an optional parameter with a default value 
     	[string] $configfile = $(throw "requiredparam required."), #throw exception if no value provided 
    	# [string] $user = $(Read-Host -prompt "User"), #prompt user for value if none provided 
    	# [switch] $switchparam; #an optional "switch parameter" (ie, a flag) 
   	# or 
   	# [parameter(Mandatory = $true)]
   	# [string] $requiredparam = $(throw "requiredparam required."), #throw exception if no value provided
    	[Switch]$help = $null 
)
# Functions Definition # 
Function Get-WebConfig {
		Write-Host "To date is 12/21/2011, be happy it's not the last."
		Write-Host "configFile =" $configfile
		$webConfigPath = (Resolve-Path $configfile).Path
		
		Write-Host "webConfigPath =" $webConfigPath

                # Get the content of the config file and cast it as Xml and save a backup copy labeled '.bak'.
		$xml = [xml](Get-Content $webConfigPath)

		# Save a backup copy if requested
		#if ($backup) {$xml.Save($backup)}

		$root = $xml.get_DocumentElement();
		$output = $root.connectionStrings.add.GetValue(0).connectionString

		Write-Host "output =" $output
                                



}

# Main # 
if ($help.isPresent) 
{ 
	 " 
	 . $pwd\Get-WebConfig.ps1 
   Which has the following parameters and defaults:
	 optionalparam1 = 192.168.1.1 
	 optionalparam2 = postmaster@example.com 
	 help        = not set 
	" 
	 return 
} 
# Call Functions 
Get-WebConfig

