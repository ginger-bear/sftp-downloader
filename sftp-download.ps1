# Set the variables for the sFTP connection
$sftpHost = "<add sFTP host here>"
$sftpUser = "<add username here>"
$sftpPassword = "<add password here>"

# Set the variables for the sFTP remote and local directories
$sftpRemoteDir = "/remote/folder/path"
$localDir = "C:\local\folder\path"

# Set the variables for the file to download
$fileName = "<add filename here>"
$localFilePath = "$localDir\$fileName"

# Set the variable for the sFTP server fingerprint, example:
# $sftpFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
$sftpFingerprint = "ssh-rsa <add fingerprint here>"





# Configure required WinSCP dll and exe
$directoryPath = "$($env:ProgramFiles)\WindowsPowerShell\Modules\WinSCP\"

# Check if the directory exists, if not create and copy files
if (!(Test-Path $directoryPath -PathType Container)) {
    # Create the directory if it does not exist
    New-Item -ItemType Directory -Path $directoryPath | Out-Null
    Write-Host "Directory created: $directoryPath"

    $dllFile = "WinSCPnet.dll"
    $exeFile = "WinSCP.exe"
    
    # Copy required files
    Copy-Item $dllFile $directoryPath -Force
    Copy-Item $exeFile $directoryPath -Force
}

# Set up session options for WinSCP
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = $sftpHost
    UserName = $sftpUser
    Password = $sftpPassword
    SshHostKeyFingerprint = $sftpFingerprint
}

# Create a session object for WinSCP
$session = New-Object WinSCP.Session

try {
    # Connect to the SFTP server
    $session.Open($sessionOptions)

    # Navigate to the remote directory
    # $session.ChangeDirectory($sftpRemoteDir)

    # Download the file to the local directory
    $session.GetFiles("$sftpRemoteDir\$fileName", $localFilePath).Check()

    Write-Host "File downloaded successfully."
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
finally {
    # Disconnect from the SFTP server
    $session.Dispose()
}
