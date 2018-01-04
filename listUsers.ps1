Import-Module ActiveDirectory
$logFile = (Join-Path $ENV:USERPROFILE "Documents\listUsersLog.txt")

if (Test-Path $logFile)
{
    Remove-Item $logFile
}

Function LogMessage()
{
    [CmdletBinding()]
    param(
        [string] $message,
        [switch] $appendTime
    )

    if ($appendTime)
    {
        $message = ("[{0:HH:mm:ss}] $message" -f (Get-Date))
    }
    Write-Host $message	
	Add-Content $logFile $message
}

$lastRun = "Last run: " + (Get-Date -Format D)
LogMessage $lastRun
LogMessage "--------------------------------"
LogMessage ""

$groups = Get-ADGroup -Filter *

foreach ($group in $groups)
{
    $msg = $group.Name + " (" + $group.GroupCategory + ")"
    $members = Get-ADGroupMember -Identity $group

    LogMessage $msg
    foreach ($member in $members)
    {
        $msg = "    - " + $member.Name + " (" + $member.ObjectClass + ")" 
        LogMessage $msg
    }
    LogMessage ""
}
