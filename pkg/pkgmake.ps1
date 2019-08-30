param (
	[string]$rule = ""
)

$BASEDIR=$PSScriptRoot
#echo BASEDIR=$BASEDIR

function all {
	clean
	import
	pkg
}

function init {
	$global:app_name = "npp"
	$global:app_version = Get-ChildItem $BASEDIR\..\ext\*.zip | %{$_.Name -replace "npp.", "" -replace ".zip", "" -replace ".bin.", "-"}
	$global:app_pkgname = "$app_name-$app_version"
}

function import {
	"# import ..."
	mkdir BUILD/root -ea SilentlyContinue *> $null
	
	Expand-Archive -Path ..\ext\*.zip -DestinationPath BUILD/root
	cp -r -fo ..\src\* BUILD/root
    cp BUILD/root/stylers.model.xml BUILD/root/themes/default.xml
    cp BUILD/root/themes/Monokai_2.xml BUILD/root/stylers.model.xml
}

function pkg {
	"# packaging ..."
	mkdir PKG > $null
	
	cd BUILD
	Compress-Archive -Path root\* -DestinationPath ..\PKG\$app_pkgname.zip
	cd ..
	"## created $BASEDIR\PKG\$app_pkgname.zip"
}

function clean {
	"# clean ..."
	rm -r -fo -ea SilentlyContinue PKG
	rm -r -fo -ea SilentlyContinue BUILD
}

$funcs = Select-String -Path $MyInvocation.MyCommand.Path -Pattern "^function (\S+) " | %{$_.Matches.Groups[1].Value}
if(! $funcs.contains($rule)) {
	"no such rule: '$rule'"
	""
	"RULES"
	$funcs | %{"    $_"}
	exit 1
}

cd "$BASEDIR"
init

"##### Executing rule '$rule'"
& $rule $args
"##### done"

