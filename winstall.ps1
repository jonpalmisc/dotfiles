param(
    [Parameter(Mandatory, Position=0)]
    [ValidateSet("nvim", "subl", "smerge", "ps7", "winterm")]
    [string]$Target
)

$RepoRoot = $PSScriptRoot

function New-Junction {
    param([string]$LinkPath, [string]$TargetPath)

    if (Test-Path $LinkPath) {
        Remove-Item -Recurse -Force $LinkPath
    }

    New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
}

function New-FileSymbolicLink {
    param([string]$LinkPath, [string]$TargetPath)

    $LinkDirectory = Split-Path -Parent $LinkPath
    New-Item -ItemType Directory -Path $LinkDirectory -Force | Out-Null

    if (Test-Path $LinkPath) {
        Remove-Item -Force $LinkPath
    }

    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
}

switch ($Target) {
    "nvim" {
        New-Junction "$env:LOCALAPPDATA\nvim" "$RepoRoot\nvim"
    }
    "subl" {
        New-Junction "$env:APPDATA\Sublime Text\Packages\User" "$RepoRoot\subl"
    }
    "smerge" {
        New-Junction "$env:APPDATA\Sublime Merge\Packages\User" "$RepoRoot\smerge"
    }
    "ps7" {
        New-FileSymbolicLink "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" "$RepoRoot\ps7\Microsoft.PowerShell_profile.ps1"
    }
    "winterm" {
        New-FileSymbolicLink "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$RepoRoot\winterm\settings.json"
    }
}
