# adobe-acrobat-reader-dc install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1801120058/AcroRdrDC1801120058_MUI.exe'
$checksumPackage     = '541aa7093854aed8067d9bbe6658c6e68df542f029f8a2cb7d7cb65ee5a17277f63f046978497a94f2646b72fb986d15d710b1f1ec8d2520e67c2910e50a4abe'
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
