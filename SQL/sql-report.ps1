#Parameters get passed by pipelines 
param(
    $username = "",
    $password = "",
    $sqlServer = "",
    $database = "",
    $reportPath = ""
)

$password   = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

$date  = Get-Date -Format MMyy

#####################################
#Insert your query between the quotes
#####################################
$query = ""

Invoke-Sqlcmd -ConnectionString "Data Source=$sqlServer;Initial Catalog=$database;Integrated Security=True" -Query $query | Format-Table | Out-File -FilePath $reportPath\Report-$date.txt 