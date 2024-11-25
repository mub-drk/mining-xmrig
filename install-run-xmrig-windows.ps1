# Define URLs
$xmrigRepo = "https://github.com/xmrig/xmrig/releases/latest/download/xmrig-6.20.0-msvc-win64.zip"  # Update URL if necessary
$configRepo = "https://raw.githubusercontent.com/mub-drk/mining-xmrig/refs/heads/main/config.json"  # Replace with your GitHub raw file URL

# Set installation directory
$installPath = "$env:USERPROFILE\xmrig"
$configPath = "$installPath\config.json"

# Ensure necessary tools are available
Write-Host "Checking for required tools..."
if (-not (Get-Command "Expand-Archive" -ErrorAction SilentlyContinue)) {
    Write-Error "PowerShell 5.0 or later is required for this script."
    exit 1
}

# Create installation directory
Write-Host "Creating installation directory at $installPath..."
New-Item -ItemType Directory -Force -Path $installPath | Out-Null

# Download XMRig
Write-Host "Downloading XMRig..."
$xmrigZip = "$installPath\xmrig.zip"
Invoke-WebRequest -Uri $xmrigRepo -OutFile $xmrigZip -UseBasicParsing

# Extract XMRig
Write-Host "Extracting XMRig..."
Expand-Archive -Path $xmrigZip -DestinationPath $installPath -Force
Remove-Item $xmrigZip

# Download custom configuration file
Write-Host "Downloading custom configuration..."
Invoke-WebRequest -Uri $configRepo -OutFile $configPath -UseBasicParsing

# Set execution permissions (if needed)
Write-Host "Setting execution permissions..."
$xmrigExe = Get-ChildItem -Path "$installPath" -Recurse -Filter "xmrig.exe" | Select-Object -ExpandProperty FullName
if (-not $xmrigExe) {
    Write-Error "XMRig executable not found after extraction."
    exit 1
}

# Test XMRig setup
Write-Host "Testing XMRig setup..."
Start-Process -FilePath $xmrigExe -ArgumentList "--help" -NoNewWindow -Wait

Write-Host "XMRig installation and configuration completed successfully."
