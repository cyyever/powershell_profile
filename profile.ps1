# Add custom paths
# Install tools: winget install Starship.Starship
$env:Path = "${HOME}/opt/bin;${HOME}/.cargo/bin;$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Starship.Starship_Microsoft.Winget.Source_8wekyb3d8bbwe;" + $env:Path

# Starship prompt - Config: ~/.config/starship.toml
Invoke-Expression (&starship init powershell)

# Aliases
Set-Alias -Name vim -Value nvim


function pyinstall {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv pip install --no-build-isolation . --force-reinstall
    } elseif (Test-Path pyproject.toml) {
        python -m pip install --no-build-isolation . --user --force
    } else {
        python setup.py build_ext --inplace
        python setup.py install --force --user
    }
}

function pytest { python -m pytest $args }

function pycoverage_run {
    $rcfile = "$home/opt/cli_tool_configs/coveragerc"
    $rcflag = if (Test-Path $rcfile) { "--rcfile=$rcfile" } else { "" }
    python -m coverage run --concurrency=multiprocessing $rcflag -m pytest --capture=tee-sys
    python -m coverage combine
    python -m coverage report
    python -m coverage html
}

# Fish-like PSReadLine settings
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Fish-like keybindings
Set-PSReadLineKeyHandler -Chord RightArrow -Function ForwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord Alt+d -Function DeleteWord
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine
