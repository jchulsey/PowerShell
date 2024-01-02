# The parameters get passed by a YAML template
param(
    $username = "",
    $password = "",
    $nginxInstanceNames = "",
    $nginxInstanceNumbers = "",
    $actionType = "",
    $nginxApiVersion = "",
    $nginxInstancePort = "",
    $serverGroup = ""
)

# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [NetSecurityProtocolType]::Tls12

$password   = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

$body     = ""
$report   = @()
$takeDownUrls = @()

if ($actionType -eq "Drain") {
    $body = '{"drain" : true}'
}

if ($actionType -eq "Online") {
    $body = '{"down" : false}'
}

######################
# Drain / Online nodes
######################

$url = ""

foreach ($instance in $nginxInstanceNames.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)) {
    foreach ($n in $nginxInstanceNumbers.Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)) {
        $url = "https`://$instance`:$nginxInstancePort/api/$nginxApiVersion/http/upstreams/$serverGroup/servers/" + $n

        if ($actionType -eq "drain") {
            $takeDownUrls += $url
        }

        Write-Host "Processing $url"
        Invoke-WebRequest -URI $url -Credential $basicCreds -Method Patch -ContentType 'application/json' -Body $body
    }
}

# Give traffic a minute to bleed off
Start-Sleep -s 60

# Take drained nodes down
foreach ($url in $takeDownUrls) {
    $httpQuery = $object = $null

    Write-Host "Processing $url"
    try {
        $httpQuery = Invoke-WebRequest -URI $url -Credential $basicCreds -Method Patch -ContentType 'application/json' -Body '{"down" : true}' | Select-Object statuscode,statusdescription,content   
        if ($httpQuery) {
            $object = New-Object PSObject -Property ([ordered] @{
                URL        = $url
                Status     = $httpQuery.statusdescription
                StatusCode = $httpQuery.statuscode 
                Content    = $httpQuery.content
            })
            $report += $object
        }
    }
    catch {
        $_.Exception.Message
        continue 
    }
}

# Report in grid view
$report | Format-Table
