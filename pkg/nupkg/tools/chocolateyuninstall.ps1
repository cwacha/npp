function isAdmin() {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# & $toolsDir\control.cmd remove

if(isAdmin) {
	"Removing Right-click shell action"
	Remove-Item -Recurse -LiteralPath 'HKLM:\Software\Classes\*\shell\Edit with Notepad++'

	"Removing Start Menu entry"
	rm -fo -ea SilentlyContinue "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk"
}
