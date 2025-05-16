$dir = "D:\Anwendungen\meins\cmds"
if ($args.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($args[0])) {
    $dir = $args[0]
}
if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
}
Get-ChildItem -Path "$PSScriptRoot" -Recurse -Force | Where-Object {
    -not ($_.FullName -like "*\.git*") -and
    ($_.FullName -notlike "*updateflipcmds.ps1*")
} | Copy-Item -Destination $dir -Recurse -Force