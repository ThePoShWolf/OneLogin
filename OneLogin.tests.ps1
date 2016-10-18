$ModulePath = $PSScriptRoot
$ModuleName = (Get-Item $ModulePath).Name
$ManifestPath   = "$ModulePath\$ModuleName.psd1"

Import-Module $ManifestPath

# test the module manifest - exports the right functions, processes the right formats, and is generally correct
Describe "Manifest" {
    
    $ManifestHash = Invoke-Expression (Get-Content $ManifestPath -Raw)

    It "has a valid manifest" {
        {
            $null = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should Not Throw
    }

    It "has a valid root module" {
        $ManifestHash.RootModule | Should Be "$ModuleName.psm1"
    }

    It "has a valid Description" {
        $ManifestHash.Description | Should Not BeNullOrEmpty
    }

    It "has a valid guid" {
        $ManifestHash.Guid | Should Be "87e0e33a-1747-4ff2-a812-890565b4f0d1"
    }

    It "has a valid version" {
        $ManifestHash.ModuleVersion -as [Version] | Should Not BeNullOrEmpty
    }

    It "has a valid copyright" {
        $ManifestHash.CopyRight | Should Not BeNullOrEmpty
    }

    It 'processes all existing format files' {
        $FormatFiles = Get-ChildItem "$ModulePath\formats\" -Filter *.ps1xml | Select-Object -ExpandProperty fullname
        $ExportedFormats = $ManifestHash.FormatsToProcess | foreach {"$ModulePath\$_"}
        $ExportedFormats | Should Be $FormatFiles
    }
    
    It 'has a valid license Uri' {
        $ManifestHash.PrivateData.Values.LicenseUri | Should Be 'http://opensource.org/licenses/MIT'
    }
    
    It 'has a valid project Uri' {
        $ManifestHash.PrivateData.Values.ProjectUri | Should Be 'https://github.com/mattmcnabb/OneLogin'
    }

    It "gallery tags don't contain spaces" {
        foreach ($Tag in $ManifestHash.PrivateData.Values.tags)
        {
            $Tag | Should Not Match '\s'
        }
    }
}

Describe "Functions" {
    InModuleScope -ModuleName $ModuleName {
        
        Context "New-OneLoginToken" {
            $TokenResponse = [PSCustomObject]@{
                access_token  = "f2ebc4de50b04ed894e4ed12ae65f89f72ebea733454e2158eaccc56dcbc2395"
                account_id    = 57435
                created_at    = "10/2/2016 9:53:17 PM"
                expires_in    = 36000
                expires_at    = "10/3/2016 7:53:17 AM"
                refresh_token = "ab1da949439d461dbffeb969024131693e9c2c23c758de48e53bfd64505a29c2"
                token_type    = "bearer"
            }
            $Credential = [PSCredential]::new("OneLoginUser", (ConvertTo-SecureString -String '1234568' -AsPlainText -Force))
            Mock -CommandName Invoke-OneLoginRestMethod -MockWith $TokenResponse
            $Script:Token = New-OneLoginToken -Region us -Credential $Credential

            It "outputs a OneLoginToken object" {
                $Token | Should BeOfType "OneLoginToken"
            }
            
        }

        Context "Invoke-OneLoginRestMethod" {
            $Token = 

            It "returns all pages" {
                Invoke-OneLoginRestMethod | Should Be "Something"
            }
        }


        Context "Get-BoundParameter" {
            $BoundParameters = @{
                Param1              = "Value1"
                Param2              = "Value2"
                Verbose             = $true
                Debug               = $true
                ErrorAction         = "Continue"
                WarningAction       = "Continue"
                InformationAction   = "Continue"
                ErrorVariable       = "E"
                WarningVariable     = "W"
                InformationVariable = "I"
                OutVariable         = "O"
                OutBuffer           = $true
                PipelineVariable    = "P"

            }

            $Common = @(
                "Verbose",
                "Debug",
                "ErrorAction",
                "WarningAction",
                "InformationAction",
                "ErrorVariable",
                "WarningVariable",
                "InformationVariable",
                "OutVariable",
                "OutBuffer",
                "PipelineVariable"
            )

            It "removes common parameters" {
                (Get-BoundParameter -BoundParameters $BoundParameters).GetEnumerator() | Where-Object {
                    $_.Name -in $Common
                }  | Should Be $null
            }

            It "removes excluded parameters" {
                $Bound = (Get-BoundParameter -BoundParameters $BoundParameters -ExcludedParameters "Param2").GetEnumerator()
                $Bound.Name | Should Be "Param1"

            }
        }
    }
}