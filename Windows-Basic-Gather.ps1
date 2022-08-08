# This script demonstrates some basic info gathering in PowerShell. 

$ComputerName = HOSTNAME.EXE
$Today = Get-Date -Format "yyyy-MM-dd"
$Drive = "C"
$StoppedServices = Get-Service | Where-Object Status -eq "Stopped" -erroraction 'silentlycontinue'
    $NumberOfStoppedServices = $StoppedServices.Count 
$RunningServices = Get-Service | Where-Object Status -eq "Running" -erroraction 'silentlycontinue'
    $NumberOfRunningServices = $RunningServices.Count
$SizeRemaining = Get-Volume -DriveLetter $Drive | Select-Object SizeRemaining 
    $SizeRemainingInt = $SizeRemaining.SizeRemaining
$SizeTotal = Get-Volume -DriveLetter $Drive | Select-Object Size
    $SizeTotalInt = $SizeTotal.Size
$SizeLargeFloat = $SizeRemainingInt / $SizeTotalInt
    $SizeFloat = [math]::Round($SizeLargeFloat, 2) 
    $SizeString = $SizeFloat.ToString("0.00")
$PercentageOfAvailableSpace = $SizeString.substring(2) + "%"
$log = "C:\Users\jConrad\log$Today.txt"

# This is an array of services to determine whether they are stopped or running. 
$Services = @(
    'Windows Audio'
    'Windows Search'
    'Windows Update'
)

"Today is " + $Today + "." | Out-File -FilePath $log
"There are " + $NumberOfRunningServices + " services running and " + $NumberOfStoppedServices + " services stopped on " + $ComputerName + `
"." | Out-File -FilePath $log -Append
foreach ($i in $Services) {
    if (Get-Service -Name $i | Where-Object Status -eq "Running") {
        $i + " is running." | Out-File -FilePath $log -Append
    }
    else {
        $i + " is stopped." | Out-File -FilePath $log -Append
    }
}
"There is " + $PercentageOfAvailableSpace + " of space available on the " + $Drive + " drive." | Out-File -Path $Log -Append
if ($SizeFloat -gt .10) {
    "Space is OK." | Out-File -FilePath $log -Append
}
else {
    "You should consider making space." | Out-File -FilePath $log -Append
}