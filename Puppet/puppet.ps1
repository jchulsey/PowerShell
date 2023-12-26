param(
    $username = "",
    $password = "",
    $serverList = "",
    $action = ""
)

$serverList = $serverList.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)
$password   = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

$amount       = $computers.count
$a            = 0

foreach ($computer in $serverList) {
    $a++

    if ($action -eq "Enable") {
        Write-Host "Enabling Puppet on $computer"
        Invoke-Command -ComputerName $computer {
            puppet agent --enable 
        } -Credential $basicCreds
    }

    if ($action -eq "Disable") {
        Write-Host "Disabling Puppet on $computer"
        Invoke-Command -ComputerName $computer {
            puppet agent --disable 
        } -Credential $basicCreds
    }

    Write-Progress -Activity "Working..." -CurrentOperation "$a complete of $amount" -Status "Please wait"
    Write-Host "Complete"
}