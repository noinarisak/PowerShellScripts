#==========================================================================
#
# NAME: Psh-Zip.ps1
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
# 1.0 10/6/2011 - Initial release
#
#==========================================================================

# Functions Definition # 

# Create a new Zip
Function New-Zip {
	Param(
		[string]$zipfilename,
		[switch]$help=$true
	)
	
	# Call Pre-Init routine
	PreInit
	
	# Main
	Set-Content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
	(Get-ChildItem $zipfilename).IsReadOnly = $false
	
	# Write-Host "To date is 10/6/2011, be happy it's not the last."
}

# Add files to a zip via a pipeline
Function Add-Zip
{
	Param(
		[string]$zipfilename
	)

	# Call Pre-Init routine
	PreInit
	
	# Main
	if(-not (Test-Path($zipfilename)))
	{
		Set-Content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
		(Get-ChildItem $zipfilename).IsReadOnly = $false	
	}
	
	$shellApplication = New-Object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)
	
	foreach($file in $input) 
	{ 
            $zipPackage.CopyHere($file.FullName)
            Start-Sleep -milliseconds 500
	}
}

# List the files in a zip file.
Function Get-Zip
{
	Param(
		[string]$zipfilename
	)
	
	# Call Pre-Init routine
	PreInit
	
	# Main
	if(Test-Path($zipfilename))
	{
		$shellApplication = New-Object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$zipPackage.Items() | Select Path
	}
}
# usage: Get-Zip c:\demo\myzip.zip

# Extract the files form the zip
Function Extract-Zip
{
	Param(
		[string]$zipfilename, 
		[string] $destination
	)
	
	# Call Pre-Init routine
	PreInit
	
	if(Test-Path($zipfilename))
	{	
		$shellApplication = New-Object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$destinationFolder = $shellApplication.NameSpace($destination)
		$destinationFolder.CopyHere($zipPackage.Items())
	}
}

# Helpers #
Function PreInit {
	# HELP CONTENT # 
	if ($help.isPresent) { 
			ShowHelp
			return
	} 		
}

# Prints help information
Function ShowHelp {
@"

Psh-Zip v0.1 - description, by Noi Narisak, 2011.

Usage:
(powershell) New-Zip.ps1 [-ZipFileName] [-help] [-?]

Example:
1. Creating new zip
(powershell) New-Zip.ps1  c:\demo\myzip.zip

2. Add files to a zip via a pipeline
(powershell) dir c:\demo\files\*.* -Recurse | Add-Zip c:\demo\myzip.zip

3. List the files in a zip file.
(powershell) Get-Zip c:\demo\myzip.zip

*Extract the files form the zip
(powershell) Extract-Zip c:\demo\myzip.zip c:\demo\destination

"@		
}

