# I wanted to organize my downloads by file extension so I wrote this script
$folders = (Get-ChildItem -Path .\ -File *.*).Extension

foreach ($folder in $folders) {
    if (Test-Path .\$folder) {
        Write-Host "Folder exists."
    } else {
        New-Item -Path .\ -Name $folder -ItemType "directory"
    }
}

$files = Get-ChildItem -Path .\ -File *.*

foreach ($file in $files) {
    $destination = $file.Extension
    Move-Item -Path .\$file -Destination .\$destination
}