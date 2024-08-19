echo "Installing PSWindowsUpdate module..."
$Result = Install-Module -Name PSWindowsUpdate -Force
if (!$?) {
    echo "Install-Module failed. Script terminating."
    exit 1
}

echo "Importing PSWindowsUpdate module..."
Import-Module PSWindowsUpdate
if (!$?) {
    echo "Import-Module failed. Script terminating."
    exit 1
}

echo "Installing Windows Updates (if any available)..."
# Get-WindowsUpdate
# Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
# Single command that does both commands above
Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -AutoReboot

echo "We're done!"