function Test-RegistryValue {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Value
    )

    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }

}

function Remove-FileItem {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path
    )

    try {
        Remove-Item `
            -Path $Path `
            -Recurse
        Write-Output `
            -InputObject "Remove $($Path)"
    
    }
    catch {
        Write-Output `
            -InputObject "Failed remove $($Path)"
    }

}

function Update-RegistryValue {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Name,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Value,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Type,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Message
    )

    try {
        Set-ItemProperty `
            -Path $Path `
            -Name $Name `
            -Value $Value
        Write-Output `
            -InputObject $Message
      
    
    }
    catch {
        New-ItemProperty `
            -Path $Path `
            -Name $Name`
            -PropertyType $Type `
            -Value $Value
        Write-Output `
            -InputObject $Message
    }

}

function Remove-DesktopIcons {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Name,
        [parameter(Mandatory = $false)]$Desktop
    )
    if(!$Desktop)  {
       $Desktop = 'All' 
    }
        if ($Desktop -eq 'All') {
            foreach ($User in Get-ChildItem -Path "C:\Users") {
                Remove-FileItem -Path "C:\users\$($User)\desktop\$($Name).lnk"
            }
            Remove-FileItem -Path "C:\Users\default\desktop\$($Name).lnk"
            Remove-FileItem -Path "C:\Users\Public\Desktop\$($Name).lnk"
        } elseif ($Desktop -eq 'Public') {

            Remove-FileItem -Path "C:\Users\Public\Desktop\$($Name).lnk"

        } elseif ($Desktop -eq 'Default') {

            Remove-FileItem -Path "C:\Users\Default\desktop\$($Name).lnk"

        }

}