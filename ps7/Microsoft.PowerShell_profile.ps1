Set-Alias ll ls

Set-Alias g git

function touch {
    param($File)

    if (Test-Path $File) {
        (Get-Item $File).LastWriteTime = Get-Date
    }
    else {
        New-Item -ItemType File -Path $File
    }
}
