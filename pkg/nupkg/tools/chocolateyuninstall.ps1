function isAdmin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$startmenudir = "$env:AppData"
$shellmenudir = "HKCU:"

if(isAdmin) {
    $shellmenudir = "HKLM:"
    $startmenudir = "$env:ProgramData"
}

"Removing Right-click shell action"
Remove-Item -Recurse -LiteralPath "$shellmenudir\Software\Classes\*\shell\Edit with Notepad++"

"Removing Start Menu entry"
rm -fo -ea SilentlyContinue "$startmenudir\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk"
