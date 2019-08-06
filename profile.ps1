$PSReadLineProfilePath=Join-Path -Path  "$PSScriptRoot" -ChildPath "PSReadLineProfile.ps1"
if (!(Test-Path "$PSReadLineProfilePath")) {
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1" -OutFile "$PSReadLineProfilePath"
}
