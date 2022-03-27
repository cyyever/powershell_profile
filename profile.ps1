$PSReadLineProfilePath = Join-Path -Path  "$PSScriptRoot" -ChildPath "PSReadLineProfile.ps1"
if (!(Test-Path "$PSReadLineProfilePath")) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PowerShell/PSReadLine/master/PSReadLine/SamplePSReadLineProfile.ps1" -OutFile "$PSReadLineProfilePath"
}

if ((Test-Path "$PSReadLineProfilePath")) {
    . "$PSReadLineProfilePath"
}

$env:Path = "${HOME}/opt/bin;" + $env:Path

if (!$env:eink_screen) {
  function Decode {
    If ($args[0] -is [System.Array]) {
      return  [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    return ""
  }
#"""Get-WmiObject Win32_DesktopMonitor
  ForEach ($Monitor in Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorId) {
    if ((Decode $Monitor.UserFriendlyName -notmatch 0).contains("Paperlike")) {
      $env:eink_screen = 1
        break
    }
  }
}

if ($env:eink_screen) {
    'Comment', 'Keyword', 'String', 'Operator', 'Variable', 'Command', 'Parameter', 'Type', 'Number', 'Member' | foreach-object { Set-PSReadLineOption -Colors @{ $_ = [ConsoleColor]::Black } }
}

$ms_terminal_profile = "$env:LocalAppData\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
if ((Test-Path $ms_terminal_profile)) {
    $old_scheme = 'eink'
    $new_scheme = 'Gruvbox Dark'
    if ($env:eink_screen   ) {
        $old_scheme = 'Gruvbox Dark'
        $new_scheme = 'eink'
    }
    if (!( Select-String -Path $ms_terminal_profile -Pattern "^(.*colorScheme.*:.*)${new_scheme}(.*)$")) {
        $tmp = New-TemporaryFile
        Get-Content $ms_terminal_profile | foreach-object { $_ -replace "^(.*colorScheme.*:.*)${old_scheme}(.*)$", ('$1' + $new_scheme + '$2') } | Out-File -Encoding utf8  -FilePath $tmp.FullName
        cp -Force  $tmp.FullName $ms_terminal_profile
        Remove-Variable tmp
    }
}

if ((Get-Command nvim -ErrorAction SilentlyContinue)) {
    Set-Alias -Name vim -Value nvim
}

if ((Get-Command git -ErrorAction SilentlyContinue)) {
    function gitclone {
        git clone --recursive @args
    }
    function gitsubmoduleupdate {
        git submodule update --remote --merge
    }
    function gitpull {
        git pull
        gitsubmoduleupdate
    }
    git config --global core.autocrlf true
    Import-Module posh-git
}

if ((Get-Command lua5.1.exe -ErrorAction SilentlyContinue)) {
    if ((Test-Path "${HOME}/opt/z.lua")) {
        iex ($(lua5.1.exe "${HOME}/opt/z.lua/z.lua" --init powershell) -join "`n")
    }
}

if ((Get-Command ssh -ErrorAction SilentlyContinue)) {
    function sshmine {
        ssh -o SendEnv=eink_screen @args
    }
}

function pyinstall {
    python setup.py build_ext --inplace
    python setup.py install --force
}

function pytest {
    if (Test-Path $home/opt/cli_tool_configs/coveragerc -PathType leaf) {
        coverage run --concurrency=multiprocessing --rcfile=$home/opt/cli_tool_configs/coveragerc -m pytest
    }
    else {
        coverage run --concurrency=multiprocessing -m pytest
    }
}


function pycoverage_run {
    if (Test-Path $home/opt/cli_tool_configs/coveragerc -PathType leaf) {
        coverage run --concurrency=multiprocessing --rcfile=$home/opt/cli_tool_configs/coveragerc -m pytest --capture=tee-sys
    }
    else {
        coverage run --concurrency=multiprocessing -m pytest --capture=tee-sys
    }
    coverage combine
    coverage report
    coverage html
}


if (Test-Path C:\texlive\2022\bin\win32) {
  $env:Path = "C:/texlive/2022/bin/win32;" + $env:Path
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler  -Chord  Ctrl+RightArrow  -Function AcceptNextSuggestionWord
