$PSReadLineProfilePath=Join-Path -Path  "$PSScriptRoot" -ChildPath "PSReadLineProfile.ps1"
if (!(Test-Path "$PSReadLineProfilePath")) {
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PowerShell/PSReadLine/master/PSReadLine/SamplePSReadLineProfile.ps1" -OutFile "$PSReadLineProfilePath"
}

if (!(Get-Module -ListAvailable -Name z)) {
 start-process -wait -verb runAs -argumentlist "Install-Module -AllowClobber -Name z"
}

if (powershell.exe -File  (Join-Path -Path  "$PSScriptRoot" -ChildPath "eink.ps1")) {
  $env:eink_screen=1
}
