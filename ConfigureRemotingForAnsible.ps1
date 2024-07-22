# Set the execution policy to allow running scripts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# Define paths and URLs
$scriptDirectory = "C:\temp"
$logFile = Join-Path -Path $scriptDirectory -ChildPath "script_execution.log"
$url = "https://raw.githubusercontent.com/ansible/ansible-documentation/ae8772176a5c645655c91328e93196bcf741732d/examples/scripts/ConfigureRemotingForAnsible.ps1"
$outputFile = Join-Path -Path $scriptDirectory -ChildPath "winrm.ps1"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $scriptDirectory -PathType Container)) {
    New-Item -Path $scriptDirectory -ItemType Directory | Out-Null
}

# Download the script file
try {
    Invoke-WebRequest -Uri $url -OutFile $outputFile -ErrorAction Stop
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Script downloaded successfully from $url." | Out-File -FilePath $logFile -Append
} catch {
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to download the script from $url. Error: $_" | Out-File -FilePath $logFile -Append
    exit 1
}

# Execute the downloaded script
try {
    & $outputFile
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Script executed successfully." | Out-File -FilePath $logFile -Append
} catch {
    Write-Error "Failed to execute the script: $_"
    Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to execute the script. Error: $_" | Out-File -FilePath $logFile -Append
    exit 1
}
