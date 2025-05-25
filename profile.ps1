$env:Path = "${HOME}/opt/bin;${HOME}/.cargo/bin;" + $env:Path

if (!$env:eink_screen) {
    function Decode {
        If ($args[0] -is [System.Array]) {
            return [System.Text.Encoding]::ASCII.GetString($args[0])
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
    'ContinuationPrompt', 'Emphasis', 'Error', 'Selection', 'Default', 'Comment', 'Keyword', 'String', 'Operator', 'Variable', 'Command', 'Parameter', 'Type', 'Number', 'Member', 'InlinePrediction', 'ListPrediction', 'ListPredictionSelected' | ForEach-Object { Set-PSReadLineOption -Colors @{ $_ = [ConsoleColor]::Black } }
}
else {
    if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/peru.omp.json" | Invoke-Expression
    }
}

$ms_terminal_profile = "$env:LocalAppData\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
if ((Test-Path $ms_terminal_profile)) {
    $old_scheme = 'eink'
    $new_scheme = 'Gruvbox Dark'
    if ($env:eink_screen) {
        $old_scheme = 'Gruvbox Dark'
        $new_scheme = 'eink'
    }
    if (!( Select-String -Path $ms_terminal_profile -Pattern "^(.*colorScheme.*:.*)${new_scheme}(.*)$")) {
        $tmp = New-TemporaryFile
        Get-Content $ms_terminal_profile | ForEach-Object { $_ -replace "^(.*colorScheme.*:.*)${old_scheme}(.*)$", ('$1' + $new_scheme + '$2') } | Out-File -Encoding utf8  -FilePath $tmp.FullName
        cp -Force  $tmp.FullName $ms_terminal_profile
        Remove-Variable tmp
    }
}

if ((Get-Command nvim -ErrorAction SilentlyContinue)) {
    Set-Alias -Name vim -Value nvim
    $env:EDITOR=nvim
}

#if ((Get-Command git -ErrorAction SilentlyContinue)) {
#    #Import-Module posh-git
#}

if ((Get-Command lua5.1.exe -ErrorAction SilentlyContinue)) {
    if ((Test-Path "${HOME}/opt/z.lua")) {
        iex ($(lua5.1.exe "${HOME}/opt/z.lua/z.lua" --init powershell) -join "`n")
    }
}

function pyinstall {
    if ((Test-Path pyproject.toml)) {
        python -m pip install --no-build-isolation . --user --force
    }
    else {
        python setup.py build_ext --inplace
        python setup.py install --force --user
    }
}

function pytest {
    python -m pytest
}


function pycoverage_run {
    if (Test-Path $home/opt/cli_tool_configs/coveragerc -PathType leaf) {
        python -m coverage run --concurrency=multiprocessing --rcfile=$home/opt/cli_tool_configs/coveragerc -m pytest --capture=tee-sys
    }
    else {
        python -m coverage run --concurrency=multiprocessing -m pytest --capture=tee-sys
    }
    python -m coverage combine
    python -m coverage report
    python -m coverage html
}


if (Test-Path C:\texlive\2025\bin\win32) {
    $env:Path = "C:/texlive/2025/bin/win32;" + $env:Path
}

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function AcceptNextSuggestionWord
