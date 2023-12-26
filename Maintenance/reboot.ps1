#The parameters get passed by a YAML template
param(
    $username = "",
    $password = "",
    $serverList = ""
)

$computers = $serverList.Split(",",[System.StringSplitOptions]::RemoveEmptyEntries)
$amount = $somputers.count 
$a = 0

$password = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

foreach ($computer in $computers) {
    $a++
    Write-Host "Restarting $computer"
    Invoke-Command -ComputerName $computer { shutdown.exe -r -f -t 0 } -credentials $basicCreds
    Write-Progress -Activity "Working ... " -CurrentOperation "$a Complete of $amount" -Status "Please wait. Restarting"
    Write-Host "Complete"
}