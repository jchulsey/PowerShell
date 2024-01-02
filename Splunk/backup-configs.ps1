# Parameters are passed by Pipeline templates
param(
    $serverList = "",
    $username = "",
    $password = ""
)

$computers = $serverList.Split(",",[System.StringSplitOptions]::RemoveEmptyEntries)

$password = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer {
        $source = "%SPLUNK-HOME%\etc\*"
        $destination = "D:\SplunkBackup"
        $daysRetained = 3
        $CutoffDate = (Get-Date).AddDays(-$daysRetained)
        $timestamp = Get-Date -Format "yyyyMMdd"
        $backup = New-Item -ItemType Directory -Path $destination"\"$timestamp
        Copy-Item -Path $source -Destination $backup -Recurse -Force
        Get-ChildItem -Path $destination | Where-Object { $_.LastWriteTime -lt $CutoffDate } | Remove-Item -Force -Verbose -Recurse
    } -Credential $basicCreds
}
