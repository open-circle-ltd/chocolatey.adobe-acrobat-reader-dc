# adobe-acrobat-reader-dc install

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820071/AcroRdrDC1900820071_MUI.exe'
$checksumPackage     = '0fea79f1fe7fa407846e6253c10f8739cbb6532b7181a7f8d3c2538ead8d6fbb97faa72334df7d2af9e058d1b15c7ced5e57a36733cf8678de959081cbbd0727'
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
