$ErrorActionPreference = 'Stop'

$DisplayName = 'Adobe Acrobat Reader DC MUI'

$MUIurl            = 'https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500720033/AcroRdrDC1500720033_MUI.exe'
$MUIchecksum       = 'dfc4b3c70b7ecaeb40414c9d6591d8952131a5fffa0c0f5964324af7154f8111'
$MUImspURL = 'http://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1902120056/AcroRdrDCUpd1902120056_MUI.msp'
$MUImspChecksum = '149c70260a30d7b1fe4d02504ff346b9abdf51f4d79c3ab082f82d35f468adca478f175d8582fa40380dced162df92e069af736ce0f5d015c93cd0815b0e98fc'

$MUIinstalled = $false
$UpdateOnly = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $DisplayName.replace(' MUI','*')

if ($key.Count -eq 1) {
   $InstalledVersion = $key[0].DisplayVersion.replace('.','')
   $InstallerVersion = $MUIurl.split('/')[-2]
   if ($key[0].DisplayName -notmatch 'MUI') {
      if ($InstalledVersion -ge $InstallerVersion) {
         Write-Warning "The currently installed $($key[0].DisplayName) is a single-language install."
         Write-Warning 'This multi-language (MUI) package cannot overwrite it at this time.'
         Write-Warning "You will need to uninstall $($key[0].DisplayName) first."
         Throw 'Installation halted.'
      } else {
         Write-Warning "The currently installed $($key[0].DisplayName) is a single-language install."
         Write-Warning  'This package will replace it with the multi-language (MUI) release.'
      }
   } else {
      $MUIinstalled = $true
      $UpdaterVersion = $MUImspURL.split('/')[-2]
      if ($InstalledVersion -eq $UpdaterVersion) {
         Write-Verbose 'Currently installed version is the same as this package.  Nothing further to do.'
         Return
      } elseif ($InstalledVersion -gt $UpdaterVersion) {
         Write-Warning "$($key[0].DisplayName) v20$($key[0].DisplayVersion) installed."
         Write-Warning "This package installs v$env:ChocolateyPackageVersion and cannot replace a newer version."
         Throw 'Installation halted.'
      } elseif (($InstalledVersion -ge $InstallerVersion) -and ($InstalledVersion -lt $UpdaterVersion)) {
         $UpdateOnly = $true
      }
   }
} elseif ($key.count -gt 1) {
   Write-Warning "$($key.Count) matching installs of Adobe Acrobat Reader DC found!"
   Write-Warning 'To prevent accidental data loss, this install will be aborted.'
   Write-Warning 'The following installs were found:'
   $key | ForEach-Object {Write-Warning "- $($_.DisplayName)`t$($_.DisplayVersion)"}
   Throw 'Installation halted.'
}


$PackageParameters   = Get-PackageParameters
# Reference: https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/properties.html#command-line-example
$options = ' DISABLEDESKTOPSHORTCUT=1'
if ($PackageParameters.DesktopIcon) {
   $options += ''
   Write-Host 'You requested a desktop icon.' -ForegroundColor Cyan
}

if ($PackageParameters.NoUpdates) {
   $RegRoot = 'HKLM:\SOFTWARE\Policies'
   $RegSubFolders = ('Adobe\Acrobat Reader\DC\FeatureLockDown').split('\')
   for ($i=0; $i -lt $RegSubFolders.count; $i++) {
      $RegPath = "$RegRoot\$($RegSubFolders[0..$i] -join '\')"
      if (-not (Test-Path $RegPath)) {
         $null = New-Item -Path $RegPath.TrimEnd($RegSubFolders[$i]) -Name $RegSubFolders[$i]
      }
   }
   $RegPath = "$RegRoot\$($RegSubFolders -join '\')"
   if (Test-Path $RegPath) {
      $null = New-ItemProperty -Path $RegPath -Name 'bUpdater' -PropertyType DWORD -Value 0 -Force
   }
   Write-Host 'You requested no Adobe updates.' -ForegroundColor Cyan
}

if ($PackageParameters.EnableUpdateService) {
   Write-Host 'You requested to enable the auto-update service.' -ForegroundColor Cyan
   if ($MUIinstalled) {
      if (Get-Service -Name 'AdobeARMservice' -ErrorAction SilentlyContinue) {
         $null = Set-Service -Name 'AdobeARMservice' -StartupType Automatic
         $null = Start-Service -Name 'AdobeARMservice'
      } else {
         Write-Warning 'The Adobe ARM update service is not available and is not installed on updates.'
      }
   }
} else {
   $options += ' DISABLE_ARM_SERVICE_INSTALL=1'
   if (Get-Service -Name 'AdobeARMservice' -ErrorAction SilentlyContinue) {
      $null = Stop-Service -Name 'AdobeARMservice' -Force
      $null = Set-Service -Name 'AdobeARMservice' -StartupType Disabled
   }
}

if (-not $PackageParameters.UpdateMode) {
   $UpdateMode = 0
} else {$UpdateMode = $PackageParameters.UpdateMode}

if ((0..4) -contains $UpdateMode) {
   Switch ($UpdateMode) {
      0 { Write-Host 'Configuring manual update checks and installs.' -ForegroundColor Cyan }
      1 { Write-Host 'You requested manual update checks and installs.' -ForegroundColor Cyan }
      2 { Write-Host 'You requested automatic update downloads and manual installs.' -ForegroundColor Cyan }
      3 { Write-Host 'You requested scheduled, automatic updates.' -ForegroundColor Cyan }
      4 { Write-Host 'You requested notifications but manual updates.' -ForegroundColor Cyan }
   }
   if ($MUIinstalled) {
      # This is the official setting based on the reference URL.
      $RegPath1 = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM\'
      if (Test-Path $RegPath1) {
         $null = New-ItemProperty -Path $RegPath1 -Name 'iCheckReader' -Value $UpdateMode -force
      }
      $GUID = '{' + $key[0].UninstallString.split('{')[-1]
      # This is the setting that actually causes a change in behavior.
      $RegPath2 = "HKLM:\SOFTWARE\Wow6432Node\Adobe\Adobe ARM\Legacy\Reader\$GUID"
      if (Test-Path $RegPath2) {
         $null = New-ItemProperty -Path $RegPath2 -Name 'Mode' -Value $UpdateMode -force
      }
   } else {
      $options += " UPDATE_MODE=$UpdateMode"
   }
}


$DownloadArgs = @{
  packageName    = "$env:ChocolateyPackageName (update)"
  FileFullPath   = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.msp"
  url            = $MUImspURL
  checksum       = $MUImspChecksum
  checksumType   = 'SHA512'
  GetOriginalFileName = $true
}
$mspPath = Get-ChocolateyWebFile @DownloadArgs

if ($UpdateOnly){
   $UpdateArgs = @{
      Statements     = "/p `"$mspPath`" /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES $options" +
                           " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Update.log`""
      ExetoRun       = 'msiexec.exe'
      validExitCodes = @(0, 1603)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @UpdateArgs

   if ($exitCode -eq 1603) {
      Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
      Write-Warning 'The update log should provide more details about the encountered issue:'
      Write-Warning "   $env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Update.log"
      Throw "Patching of $env:ChocolateyPackageName to the latest version was unsuccessful."
   }
}
else {
   $DownloadArgs = @{
      packageName    = $env:ChocolateyPackageName
      FileFullPath   = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.installer.exe"
      url            = $MUIurl
      checksum       = $MUIchecksum
      checksumType   = 'SHA256'
      GetOriginalFileName = $true
   }
   $MUIexePath = Get-ChocolateyWebFile @DownloadArgs

   $packageArgsEXE = @{
      packageName    = "$env:ChocolateyPackageName (installer)"
      fileType       = 'EXE'
      File            = $MUIexePath
      checksumType   = 'SHA256'
      silentArgs     = "/sAll /msi /norestart /quiet PATCH=`"$mspPath`" ALLUSERS=1 EULA_ACCEPT=YES $options" +
                        " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Install.log`""
      validExitCodes = @(0, 1000, 1101, 1603)
   }
   $exitCode = Install-ChocolateyInstallPackage @packageArgsEXE

   if ($exitCode -eq 1603) {
      Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
      Write-Warning 'The install log should provide more details about the encountered issue:'
      Write-Warning "   $env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Install.log"
      Throw "Installation of $env:ChocolateyPackageName was unsuccessful."
   }
}
