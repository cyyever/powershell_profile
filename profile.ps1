$PSReadLineProfilePath = Join-Path -Path  "$PSScriptRoot" -ChildPath "PSReadLineProfile.ps1"
if (!(Test-Path "$PSReadLineProfilePath")) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PowerShell/PSReadLine/master/PSReadLine/SamplePSReadLineProfile.ps1" -OutFile "$PSReadLineProfilePath"
}

if ((Test-Path "$PSReadLineProfilePath")) {
    . "$PSReadLineProfilePath"
}

$env:Path = "${HOME}/opt/bin;" + $env:Path
powershell.exe -NoProfile -File (Join-Path -Path "$PSScriptRoot" -ChildPath "eink.ps1")
if ($?) {
    $env:eink_screen = 1
}

if ($env:eink_screen) {
    'Comment', 'Keyword', 'String', 'Operator', 'Variable', 'Command', 'Parameter', 'Type', 'Number', 'Member' | foreach { Set-PSReadLineOption -Colors @{ $_ = [ConsoleColor]::Black } }
}

$ms_terminal_profile = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if ((Test-Path $ms_terminal_profile)) {
    $old_scheme = 'eink'
    $new_scheme = 'dark'
    if ($env:eink_screen   ) {
        $old_scheme = 'dark'
        $new_scheme = 'eink'
    }
    if (!( Select-String -Path $ms_terminal_profile -Pattern "^(.*colorScheme.*:.*)${new_scheme}(.*)$")) {
        $tmp = New-TemporaryFile
        Get-Content $ms_terminal_profile | % { $_ -replace "^(.*colorScheme.*:.*)${old_scheme}(.*)$", ('$1' + $new_scheme + '$2') } | Out-File -Encoding utf8  -FilePath $tmp.FullName
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

if ((Get-Command openconnect -ErrorAction SilentlyContinue)) {
    function connect-ntu-vpn {
        openconnect --protocol=pulse https://ntuvpn.ntu.edu.sg -u yuanyuan.chen --form-entry pulse_realm_choice:realm_choice=Staff -b
    }
}

if ((Get-Command ssh -ErrorAction SilentlyContinue)) {
    function sshmine {
        ssh -o SendEnv=eink_screen @args
    }
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler  -Chord  RightArrow -Function AcceptSuggestion
Set-PSReadLineKeyHandler  -Chord  Ctrl+RightArrow  -Function AcceptNextSuggestionWord
