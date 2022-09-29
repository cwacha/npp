param (
    [string]$rule = ""
)

$BASEDIR = $PSScriptRoot
#echo BASEDIR=$BASEDIR

function all {
    "# building: $app_pkgname"
    clean
    import
    zip
    nupkg
    checksums
}

function _init {
    $global:app_pkgid = "npp"
    $global:app_displayname = "Notepad++"
    $global:app_version = Get-ChildItem $BASEDIR\..\ext\*.zip | % { $_.Name -replace "npp.", "" -replace ".zip", "" -replace ".portable.*", "" }
    $global:app_revision = (git describe --tags --abbrev=0 | % { git log "$_..HEAD" --oneline }).count
    $global:app_build = git rev-parse --short HEAD

    $global:app_pkgname = "$app_pkgid-$app_version-$app_revision-$app_build"
}

function _template {
    param (
        [string] $inputfile
    )
    Get-Content $inputfile | % { $_ `
            -replace "%app_pkgid%", "$app_pkgid" `
            -replace "%app_displayname%", "$app_displayname" `
            -replace "%app_version%", "$app_version" `
            -replace "%app_revision%", "$app_revision" `
            -replace "%app_build%", "$app_build"
    }
}

function import {
    "# import ..."
    mkdir -fo BUILD/root *> $null
    
    Expand-Archive -Path $BASEDIR\..\ext\*.zip -DestinationPath BUILD/root
    cp -r -fo ..\src\* BUILD/root
    cp BUILD/root/stylers.model.xml BUILD/root/themes/default.xml
    cp BUILD/root/themes/Monokai_2.xml BUILD/root/stylers.model.xml
    rm BUILD/root/config.xml
}

function zip {
    "# packaging ZIP ..."
    mkdir -fo PKG/zip *> $null
    
    cd BUILD
    Compress-Archive -Path root\* -DestinationPath ..\PKG\$app_pkgname.zip
    cd ..
    "## created $BASEDIR\PKG\$app_pkgname.zip"
}

function nupkg {
    if (!(Get-Command "choco.exe" -ea SilentlyContinue)) {
        "## WARNING: cannot build chocolatey package, choco-client missing"
        return
    }
    "# packaging nupkg ..."
    mkdir -fo PKG *> $null

    cp -r -fo nupkg PKG
    cp -r -fo BUILD\* PKG\nupkg\tools
    _template nupkg\package.nuspec | Out-File -Encoding "UTF8" PKG\nupkg\$app_pkgid.nuspec
    rm PKG\nupkg\package.nuspec
    cd PKG\nupkg
    choco pack -outputdirectory $BASEDIR\PKG
    cd $BASEDIR
}

function checksums {
    "# checksums ..."
    mkdir -fo PKG *> $null
    cd PKG
    Get-FileHash *.zip, *.nupkg, *.msi | select Hash, @{l = "File"; e = { split-path $_.Path -leaf } } | % { "$($_.Hash) $($_.File)" } | Out-File -Encoding "UTF8" $app_pkgname-checksums-sha256.txt
    Get-Content $app_pkgname-checksums-sha256.txt
    cd ..
}

function clean {
    "# clean ..."
    rm -r -fo -ea SilentlyContinue PKG
    rm -r -fo -ea SilentlyContinue BUILD
}

$funcs = Select-String -Path $MyInvocation.MyCommand.Path -Pattern "^function ([^_]\S+) " | % { $_.Matches.Groups[1].Value }
if (! $funcs.contains($rule)) {
    "no such rule: '$rule'"
    ""
    "RULES"
    $funcs | % { "    $_" }
    exit 1
}

Push-Location
cd "$BASEDIR"
_init

"##### Executing rule '$rule'"
& $rule $args
"##### done"

Pop-Location
