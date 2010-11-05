# NAME: New-PshScript.ps1
#
# AUTHOR: noi narisak
# EMAIL: noi.narisak@gmail.com
# COMMENT: 
# Create new PSH scripts templates.
# 
# You have a royalty-free right to use, modify, reproduce, and 
# distribute this script file in any way you find useful, provided that
# you agree that the creator, owner above has no warranty, obligations,
# or liability for such use.
#
# VERSION HISTORY:
# 1.0 2010-10-03 - Initial release
#
# Functions Definition
Function New-Script {
$strName = $env:username
$date = get-date -format d
$name = Read-Host "Filename"
$email = Read-Host "eMail Address"
$file = New-Item -type file "c:\_Script\$name.ps1" -force
add-content $file "#=========================================================================="
add-content $file "#"
add-content $file "# NAME: $name.ps1"
add-content $file "#"
add-content $file "# AUTHOR: $strName"
add-content $file "# EMAIL: $email"
add-content $file "#"
add-content $file "# COMMENT: "
add-content $file "#"
add-content $file "# You have a royalty-free right to use, modify, reproduce, and"
add-content $file "# distribute this script file in any way you find useful, provided that"
add-content $file "# you agree that the creator, owner above has no warranty, obligations,"
add-content $file "# or liability for such use."
add-content $file "#"
add-content $file "# VERSION HISTORY:"
add-content $file "# 1.0 $date - Initial release"
add-content $file "#"
add-content $file "#=========================================================================="
add-content $file "#"
add-content $file "# Parameters "
add-content $file "Param ( "
add-content $file "		# Declare parameter(s)"
add-content $file "		# [string] `$optionalparam1, #an optional parameter with no default value "
add-content $file "    	# [string] `$optionalparam2 = `"default`", #an optional parameter with a default value "
add-content $file "    	# [string] `$requiredparam = `$(throw `"requiredparam required.`"), #throw exception if no value provided "
add-content $file "    	# [string] `$user = `$(Read-Host -prompt `"User`"), #prompt user for value if none provided "
add-content $file "    	# [switch] `$switchparam; #an optional `"switch parameter`" (ie, a flag) "
add-content $file "	   	# or "
add-content $file "	   	# [parameter(Mandatory = `$true)]"
add-content $file "	   	# [string] `$requiredparam = `$(throw `"requiredparam required.`"), #throw exception if no value provided"
add-content $file ")"
add-content $file "# Functions Definition "
add-content $file "Function $name {"
add-content $file "		Write-Host `"To date is $date, be happy it's not the last.`""
add-content $file "}"
add-content $file ""
add-content $file "# Call Functions "
add-content $file "$name"
add-content $file ""
ii $file
}

# Call Function
New-Script