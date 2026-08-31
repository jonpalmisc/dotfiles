param(
    [Parameter(Mandatory, Position=0)]
    [ValidateSet("nvim", "subl", "smerge")]
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
}
