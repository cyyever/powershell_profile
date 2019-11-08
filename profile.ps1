$PSReadLineProfilePath=Join-Path -Path  "$PSScriptRoot" -ChildPath "PSReadLineProfile.ps1"
if (!(Test-Path "$PSReadLineProfilePath")) {
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PowerShell/PSReadLine/master/PSReadLine/SamplePSReadLineProfile.ps1" -OutFile "$PSReadLineProfilePath"
}

if ((Test-Path "$PSReadLineProfilePath")) {
  . "$PSReadLineProfilePath"
}

if (!(Get-Module -ListAvailable -Name z)) {
  Install-Module -AllowClobber -Scope CurrentUser -Name z
}

$env:Path += ";${HOME}/opt/bin"
powershell.exe -NoProfile -File (Join-Path -Path "$PSScriptRoot" -ChildPath "eink.ps1")
if($?) {
  $env:eink_screen=1
}
if ((Get-Command nvim)) {
  Set-Alias -Name vim -Value nvim
}

if ((Test-Path "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json")) {
  if($env:eink_screen) {
    Get-Content $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json | %{$_ -replace "^(.*colorScheme.*:.*)eink(.*)$", '$1black$2'} | Out-File -Encoding utf8 $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json
  } else {
    Get-Content $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json | %{$_ -replace "^(.*colorScheme.*:.*)black(.*)$", '$1eink$2'} | Out-File -Encoding utf8 $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\profiles.json
  }
}
