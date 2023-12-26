#Parameters get passed by pipelines 
param(
    $username = "",
    $password = "",
    $sqlServer = "",
    $database = ""
)

$password   = ConvertTo-SecureString $password -AsPlainText -Force
$basicCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList($username, $password)

$year  = Get-Date -Format yyyy
$date  = Get-Date -Format MMyy

#####################################
#Insert your query between the quotes
#####################################
$query = ""