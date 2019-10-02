function isAdmin() {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
& $toolsDir\root\install_context_menu_open_with_notepad.cmd
Install-BinFile -Name npp-menu -Path $toolsDir\root\install_context_menu_open_with_notepad.cmd

# ensure configs are saved to users AppData folder to enable use for non-admin users
if(isAdmin) {
	rm $toolsDir\root\doLocalConf.xml
}
