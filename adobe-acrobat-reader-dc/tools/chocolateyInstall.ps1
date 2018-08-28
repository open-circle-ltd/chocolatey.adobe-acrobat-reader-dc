# adobe-acrobat-reader-dc install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1801120058/AcroRdrDC1801120058_de_DE.exe'
$checksumPackage     = 'f8092d1a8b25637940d25603403e422ecbdd124d2867b2497070f7511000d49e25a1875a6dee4bb74191c36b30b1926e2e3976bc7c21a869041dd8287dee2fa3'
$checksumTypePackage = 'SHA512'

Import-Module -Name "$($toolsDir)\helpers.ps1"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = $urlPackage
    checksum       = $checksumPackage
    checksumType   = $checksumTypePackage
	silentArgs     = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
    validExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyPackage @packageArgs

if ($PackageParameters.RemoveDesktopIcons) {
    Remove-DesktopIcons -Name "Acrobat Reader DC" -Desktop "Public"
}
