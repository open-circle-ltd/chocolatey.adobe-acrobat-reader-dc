# Chocolatey Package: Adobe Acrobat Reader DC

[![Build Status](https://img.shields.io/travis/itigoag/chocolatey.adobe-acrobat-reader-dc?style=flat-square)](https://travis-ci.org/itigoag/chocolatey.adobe-acrobat-reader-dc) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=popout-square)](licence) [![Chocolatey](https://img.shields.io/chocolatey/v/adobereader?label=package%20version)](https://chocolatey.org/packages/adobereader) [![Chocolatey](https://img.shields.io/chocolatey/dt/adobereader?label=package%20downloads&style=flat-square)](https://chocolatey.org/packages/adobereader)

## Description

Adobe Acrobat Reader DC software is the free, trusted global standard for viewing, printing, signing, sharing, and annotating PDFs. It's the only PDF viewer that can open and interact with all types of PDF content – including forms and multimedia. And now, it’s connected to Adobe Document Cloud – so you can work with PDFs on computers and mobile devices.

This package installs/upgrades the Multi-lingual ("MUI") release. In some cases, this package will be able to install over the top of a language-specific installation. Otherwise, this package will exit and require a manual uninstall of the language specific installation.

## Note

If the package fails on Windows 8.1 or earlier, this might be due to the installation of kb2919355 (which is a dependency of this package) if your system is not up-to-date. This KB requires a reboot of the system before the adobereader package installs successfully.

## Package installation defaults

By default, **installation** of this package:

- Will _NOT_ install a desktop icon.
- Will _NOT_ install the Adobe Reader and Acrobat Manager ("ARM") service.
- Will configure Reader to only **check for updates manually** with confirmation for install.

However, **upgrades** to Adobe Reader via this package:

- Will _NOT_ remove an existing desktop icon or add one when there isn't.
- Will _NOT_ install the AdobeARM service.
- Will _NOT_ remove the AdobeARM service (though it will disable it unless enabled by parameters).
- Will _NOT_ re-enable updates (if disabled via package parameter)

## Package Parameters

- `/DesktopIcon` - The Desktop icon will be installed to the common desktop. (Install only.)
- `/NoUpdates` - No updates via internal mechanisms (including manual checks). Only downloading from Adobe and running installers or updates (or updating this package) will advance the version of Reader. Once set, only uninstalling this package will remove this update block.
- `/EnableUpdateService` - Install the AdobeARM service. (Does not override `/NoUpdates`.)
- `/UpdateMode:#` - Sets the update mode (below). (Does not override `/NoUpdates`.)

### Update Modes

- `0` - Manually check for and install updates. (Default and reset on every update)
- `1` - Same as `0`.
- `2` - Download updates for me, but let me choose when to install them. (Appears to be no different than `0`.)
- `3` - Install updates automatically (via task scheduler or ARM service if enabled).
- `4` - Notify me, but let me choose when to download and install updates.

These parameters can be passed to the installer with the use of `-params`.
For example :
`choco install adobereader -params '"/DesktopIcon /UpdateMode:4"'`

## Installation

installation without parameters.

```ps1
choco install adobereader
```

installation with parameters.

```powershell
 choco install adobereader --params="'/RemoveDesktopIcons'"
```

## Disclaimer

These Chocolatey Packages only contain installation routines. The software itself is downloaded from the official sources of the software developer. ITIGO AG has no affilation with the software developer.

## Author

- [Simon Bärlocher](https://sbaerlocher.ch)
- [ITIGO AG](https://www.itigo.ch)

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file for the full license text.

## Copyright

(c) 2019, ITIGO AG
