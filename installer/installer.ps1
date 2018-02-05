Import-Module "C:\src\PowerShellToolsPro\PowerShellToolsPro.Cmdlets\bin\Debug\net462\PowerShellProTools.psd1"

$AppRoot = Join-Path $PSScriptRoot "..\app"

function New-InstallerContents {
    param([System.IO.DirectoryInfo]$RootDirectory) 

    New-InstallerDirectory -DirectoryName $RootDirectory.Name -Content {
        $Children = Get-ChildItem $RootDirectory.FullName
        foreach($child in $Children) {
            if ($Child.PsIsContainer) {
                New-InstallerContents $Child 
            }
            else {
                if ($Child.Name -eq "electron.exe") {
                    New-InstallerFile -Source $Child -Id "main_app"
                }
                else {
                    New-InstallerFile -Source $Child
                }
            }
        }
    }
}

$UserInterface = New-InstallerUserInterface -Eula (Join-Path $PSScriptRoot 'eula.rtf') -TopBanner (Join-Path $PSScriptRoot "banner.png") -Welcome (Join-Path $PSScriptRoot "welcome.png")

New-Installer -Product "Chuck Norris Jokes" -UpgradeCode '1a73a1be-50e6-4e92-af03-586f4a9d9e82' -Content {
    New-InstallerDirectory -PredefinedDirectory "LocalAppDataFolder" -Content {
        New-InstallerDirectory -DirectoryName "Chuck Norris Jokes" -Configurable -Content {
            New-InstallerContents -RootDirectory $AppRoot
        }
    }
    New-InstallerDirectory -PredefinedDirectory "DesktopFolder" -Content {
        New-InstallerShortcut -Name "Chuck Norris Jokes" -FileId "main_app" -IconPath (Join-Path $PSScriptRoot "app.ico")
    }
} -AddRemoveProgramsIcon (Join-Path $PSScriptRoot "app.ico") -UserInterface $UserInterface -Output (Join-Path $PSScriptRoot "output")