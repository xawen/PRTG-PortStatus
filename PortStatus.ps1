Param(
	[string]$PortCount,
	[string]$HostName,
	[string]$Community
)


function Get-ScriptDirectory
{
$Invocation = (Get-Variable MyInvocation -Scope 1).Value
Split-Path $Invocation.MyCommand.Path
}

$path = Join-Path (Get-ScriptDirectory) SnmpWalk.exe

$SNMPResults = cmd /c $path -q -c:$Community -r:$HostName -os:.1.3.6.1.2.1.2.2.1.8.0 -op:.1.3.6.1.2.1.2.2.1.8.$PortCount
$SNMPPortAdminStatus = cmd /c $path -q -c:$Community -r:$HostName -os:.1.3.6.1.2.1.2.2.1.7.0 -op:.1.3.6.1.2.1.2.2.1.7.$PortCount


Write-Host "<prtg>"

$LoopIndex = 1
foreach ($Result in $SNMPResults) {
	Write-Host "<result>"
	Write-Host ("<channel>Port " + $LoopIndex + "</channel>")
	If ($SNMPPortAdminStatus[$LoopIndex-1] -eq "1"){
		Write-Host ("<value>" + $Result + "</value>")
	} else {
		Write-Host ("<value>10</value>")
	}
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.SNMP.portstatus</valuelookup>"
	Write-Host "</result>"
	$LoopIndex++
}

Write-Host "</prtg>"