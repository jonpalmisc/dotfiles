param(
    [Parameter(Mandatory, Position=0)]
    [ValidateSet("nvim", "subl", "smerge", "ps7", "winterm")]
    [string]$Target
)

$RepoRoot = $PSScriptRoot

function Remove-IfExists {
    param([string]$Path)

    if (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

function New-Junction {
    param([string]$LinkPath, [string]$TargetPath)

    Remove-IfExists $LinkPath
    New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
}

function New-FileLink {
    param([string]$LinkPath, [string]$TargetPath)

    $LinkDirectory = Split-Path -Parent $LinkPath
    New-Item -ItemType Directory -Path $LinkDirectory -Force | Out-Null

    Remove-IfExists $LinkPath
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
}

switch ($Target) {
    "nvim" {
        New-DirLink "$env:LOCALAPPDATA\nvim" "$RepoRoot\nvim"
    }
    "subl" {
        New-DirLink "$env:APPDATA\Sublime Text\Packages\User" "$RepoRoot\subl"
    }
    "smerge" {
        New-DirLink "$env:APPDATA\Sublime Merge\Packages\User" "$RepoRoot\smerge"
    }
    "ps7" {
        New-FileLink "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" "$RepoRoot\ps7\Microsoft.PowerShell_profile.ps1"
    }
    "winterm" {
        New-FileLink "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$RepoRoot\winterm\settings.json"
    }
}
