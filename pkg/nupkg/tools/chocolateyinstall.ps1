﻿$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
& $toolsDir\root\install_context_menu_open_with_notepad.cmd
Install-BinFile -Name npp-menu -Path $toolsDir\root\install_context_menu_open_with_notepad.cmd
