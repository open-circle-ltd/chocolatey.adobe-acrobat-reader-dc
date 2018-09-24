# adobe-acrobat-reader-dc install

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackage          = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1801120063/AcroRdrDC1801120063_MUI.exe'
$checksumPackage     = '5a755228950a0a7e8b959a6390cbaf68d7d40cf5a003176be832ec09f9a5bd3666686092f2fb959913285aba792d903767a8a31a8d9e756cb2b4fb90d7b88f60'
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
