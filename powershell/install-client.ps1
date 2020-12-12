
# Install useful tools
Set-ExecutionPolicy Bypass -Scope Process -Force  #DevSkim: ignore DS113853

# Remove unneeded
Invoke-WebRequest -Uri  "https://raw.githubusercontent.com/fjacquet/Win10-Initial-Setup-Script/master/Win10.ps1"  -OutFile "Win10.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fjacquet/Win10-Initial-Setup-Script/master/Win10.psm1" -OutFile "Win10.psm1"
Invoke-WebRequest -Uri  "https://raw.githubusercontent.com/fjacquet/Win10-Initial-Setup-Script/master/Default.preset" -OutFile "Default.preset"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 -preset Default.preset

# Install needed using chocolatey
Write-Output "Installing latest nuget"
Install-PackageProvider -Name NuGet  -Force -Confirm:$false
Write-Output "Allow ps gallery"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Write-Output "Install chocolatey"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))#DevSkim: ignore DS104456
choco feature enable -n allowGlobalConfirmation
$values = ('googlechrome', 'sysinternals', '7zip.install', 'vscode', 'tailblazer', 'curl')
foreach ($value in $values) {
    Write-Output "installing $($value)"
    choco install $value -y
}


# Windows updates
Install-Module PSWindowsUpdate
Import-Module -Name PSWindowsUpdate
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot