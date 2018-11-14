# Chocolatey Package: Adobe Acrobat Reader DC

## Description

More powerful than other PDF software, Adobe Acrobat Reader DC is the free, trusted standard for viewing, printing, and annotating PDFs. And now, it’s connected to Adobe Document Cloud — so it’s easier than ever to work with PDFs on computers and mobile devices.

## Note

If the package fails on Windows 8.1 or earlier, this might be due to the installation of kb2919355 (which is a dependency of this package) if your system is not up-to-date. This KB requires a reboot of the system before the adobereader package installs successfully.

## Package Parameters

* `/RemoveDesktopIcons` Removes the desktop icon from Adobe Acrobat Reader DC.
* `/EnableAutoUpdate` This parameter activates the Auto Update function of Adobe Acrobat Reader.

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

* [Simon Bärlocher](https://sbaerlocher.ch)
* [ITIGO AG](https://www.itigo.ch)

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file for the full license text.

## Copyright

(c) 2018, ITIGO AG
