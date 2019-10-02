function isAdmin() {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
& $toolsDir\root\install_context_menu_open_with_notepad.cmd
Install-BinFile -Name npp-menu -Path $toolsDir\root\install_context_menu_open_with_notepad.cmd


if(isAdmin) {
	# ensure configs are saved to users AppData folder to enable use for non-admin users
	"Removing doLocalConf.xml"
	rm $toolsDir\root\doLocalConf.xml
	
	# create start menu entry
	"Creating Start Menu entry"
	Install-ChocolateyShortcut `
		-ShortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk"`
		-TargetPath "$toolsDir\root\notepad++.exe"
}
