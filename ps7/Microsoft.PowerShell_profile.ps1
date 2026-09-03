Set-PSReadLineOption -EditMode Emacs

Set-Alias ll ls

Set-Alias g git

function prompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation;

    $out = ""

    # Communicates the working directory to Windows Terminal so that inheriting
    # the previous directory when duplicating tabs works correctly.
    if ($loc.Provider.Name -eq "FileSystem") {
        $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }

    $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";

    return $out
}

function touch {
    param($File)

    if (Test-Path $File) {
        (Get-Item $File).LastWriteTime = Get-Date
    }
    else {
        New-Item -ItemType File -Path $File
    }
}
