import-module au

$url                    = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
$checksumTypePackageMSP = "SHA512"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^\s*[$]*urlPackageMSP\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^\s*[$]*checksumPackageMSP\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
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
    
    $urlPackageMSP = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/$($urlVersion)/AcroRdrDCUpd$($urlVersion)_MUI.msp"

    return  @{ 
        URL32          = $urlPackageMSP;
        ChecksumType32 = $checksumTypePackageMSP;
        Version        = $version
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 3
}

update
