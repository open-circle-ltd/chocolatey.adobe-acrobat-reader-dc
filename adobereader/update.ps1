import-module au

$url                 = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
$checksumTypePackage = "SHA512"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^\s*[$]*urlPackage\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^\s*[$]*checksumPackage\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*[$]*checksumTypePackage\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }; 
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive

    $reLatestbuild = "(.*>DC.*)"
    $download_page.RawContent -imatch $reLatestbuild
    $latestbuild   = $Matches[0]

    $reVersion   = "(\d+)(.)(\d+)(.)(\d+)"
    $latestbuild -imatch $reVersion
    $version     = "20$($Matches[0])"
    $urlVersion  = $Matches[0].Replace(".", "")
    
    $urlPackage = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/$($urlVersion)/AcroRdrDC$($urlVersion)_MUI.exe"

    return  @{ 
        URL32          = $urlPackage;
        ChecksumType32 = $checksumTypePackage;
        Version        = $version
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 3
}

update
