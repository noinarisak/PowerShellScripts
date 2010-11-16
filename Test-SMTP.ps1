#==========================================================================
#
# NAME: Test-SMTP.ps1
#
# AUTHOR: nnarisak
# EMAIL: noi.narisak@gmail.com
#
# COMMENT: 
# Test a remote smtp server
#
# You have a royalty-free right to use, modify, reproduce, and
# distribute this script file in any way you find useful, provided that
# you agree that the creator, owner above has no warranty, obligations,
# or liability for such use.
#
# VERSION HISTORY:
# 1.0 11/15/2010 - Initial release
#
# USAGE:
# 	./TEST-SMTP.ps1 -smtpserver mail.example.com -destaddress test@example.com
#
#==========================================================================
#
# Parameters #
#
Param (
	[string]$SMTPServer  = "192.168.1.1",
	[string]$destAddress = "postmaster@example.com",
	[string]$strBody     = "Subject: test`r`n`r`nSmall contents of some email.`r`n",
	[string]$serverName  = "test.example.com",
	[string]$SMTPPort    = "25",
	[string]$srcAddress  = "test@example.com",
	[Switch]$help        = $null
)

# stop executing the script on the first error
trap { break; }

# Functions Definition # 
#echo parameters to output
function e {
	$str = ""
	foreach ($arg in $args)
	{
		$str += $arg
	}
	Write-Host $str
}


# network write
function n-write([System.Net.Sockets.NetworkStream]$n, [String]$s){
	 e ">>> " $s
	 $s += "`r`n"
	 $arr = $s.ToCharArray()
	 
	 $n.Write($arr, 0, $arr.Length)
}

# network read, place input into $script:input
function n-read([System.IO.StreamReader]$n){
	 $script:input = $n.ReadLine()
	 e "<<< " $script:input
}

function test-ping ([string]$SMTPserver){
	 # if $SMTPserver doesn't resolve, we'd bomb without the 'trap' with a
	 # System.Net.NetworkInformation.PingException or System.Net.Sockets.SocketException
	 trap { return $false; }

	 $ping = New-Object System.Net.NetworkInformation.Ping
	 if ($ping)
	 {
		$rslt = $ping.Send($SMTPserver)
		if ($rslt -and ($rslt.Status.ToString() –eq “Success”))
		{
			$ping = $null
			return $true
		}
		$ping = $null
	}
	
	return $false
}

# Main #
if ($help.isPresent)
{
	 "
	 . $pwd\Test-SMTP.ps1 
	Which has the following parameters and defaults:
	 SMTPServer  = 192.168.1.1
	 destAddress = postmaster@example.com
	 strBody     = Subject: test\r\n\r\nSmall contents of some email.\r\n
	 serverName  = test.example.com
	 SMTPPort    = 25
	 srcAddress  = test@example.com
	 help        = not set
	"
	 return
}

# see if we can get to the server first...
if (!(test-ping $SMTPserver)){
	e "Error: cannot access " $SMTPserver
	return
}

$tcpServer = New-Object System.Net.Sockets.TcpClient($SMTPServer, $SMTPPort)
$netStream = $tcpServer.GetStream()
$streamRead = New-Object System.IO.StreamReader($tcpServer.GetStream())

e "SMTP connection initialized to $SMTPServer on TCP port $SMTPPort. Beginning SMTP conversation."

# get the startup message from the SMTP server
n-read  $streamRead

# say hello to the remote server
n-write $netStream ("HELO " + $serverName)
n-read  $streamRead

# tell the remote server who is sending e-mail
n-write $netStream ("MAIL FROM: <" + $srcAddress + ">")
n-read  $streamRead

# tell the remote who the mail is destined to
n-write $netStream ("RCPT TO: <" + $destAddress + ">")
n-read  $streamRead

# send the data
n-write $netStream "DATA"
n-read  $streamRead

n-write $netStream $strBody
n-write $netStream "."
n-read  $streamRead

# terminate the connection
n-write $netStream "QUIT"
n-read  $streamRead

e "Mail was sent successfully."

# be nice and clean up
$streamRead.Close()
$netStream.Close()
$tcpServer.Close()
