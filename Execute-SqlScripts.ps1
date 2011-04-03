# Author: Noi.Narisak@gmail.com
# Date: 2010-09-27
# Name: Execute-SqlScripts.ps1
#
# http://powershell.com/cs/media/p/169.aspx

function Execute-SqlScripts {

	$scripts_path_in = "C:\_Projects\AdministrationSqlScripts\"
	$scripts_path_out = $scripts_path_in + "OUTPUT\"
	
	Write-Host "Entering..."
	Write-Host "scripts_path_in=" $scripts_path_in
	Write-Host "scripts_path_out=" $scripts_path_out
	Write-Debug $scripts_path_in 
	Write-Debug "hello"
	
	# Loop through the directory path, filter out only *.sql files and sort.
	foreach ($f in Get-ChildItem -path $scripts_path_in -Filter *.sql | sort-object -desc ) 
	{ 
	$out = $scripts_path_out + $f.name.split(".")[0] + ".txt" ; 
	##invoke-sqlcmd -InputFile $f.fullname | format-table | out-file -filePath $out 
	Write-Host "inside Foreach" $out
	}
	Write-Host "Exiting..."
}

# Call Functions 
Execute-SqlScripts

# To-Do
# 1. Validate