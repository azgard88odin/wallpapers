# This script requires admin rights to run
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 
}

# Running this function will set a random desktop wallpaper
function Set-DesktopWallpaper {
    $desktopImages = "$env:WALLPAPERS\Desktop"
    $newDesktopWallpaper = Get-ChildItem -Path $desktopImages | Get-Random

    Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@
    [Wallpaper]::SystemParametersInfo(20, 0, $newDesktopWallpaper.FullName, 3)
}

# Running this function will set a random lock screen wallpaper
function Set-LockScreenWallpaper {
    $lockScreenImages = "$env:WALLPAPERS\Lockscreen"
    $newLockScreenWallpaper = Get-ChildItem -Path $lockScreenImages | Get-Random
    
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
    if (!(Test-Path -Path $Key)) {
       New-Item -Path $Key -Force | Out-Null
    }
    Set-ItemProperty -Path $Key -Name LockScreenImagePath -Value $newLockScreenWallpaper.FullName
}

$envVarName = "WALLPAPERS"
$envVar = [System.Environment]::GetEnvironmentVariable($envVarName, "User")

# This is used for the first run of this script so that the it knows where to look for the wallpaper files
if (-not $envVar) {
    Write-Output "Environment variable 'WALLPAPERS' does not exist."
    Write-Output "Please confirm that creating this environment variable will not conflict with your system."
    Write-Output "Feel free to change the source code to suite your environment."
    Write-Output "This script defaults to creating a 'User' level environment variable"
    $confirmation = Read-Host "Press 'Y' to create it. Press 'N' to cancel'"

    if ($confirmation -match '^[Yy]$') {
        $path = Read-Host "Enter the full path to the directory"
        if (-not (Test-Path -Path $path -PathType Container)) {
            Write-Output "Environment variable not created. The Path '$path' does not exist"
            exit 1
        }

        # Create the environment variable (User)
        [System.Environment]::SetEnvironmentVariable($envVarName, "User")
        Write-Output "Environment Variable '$envVarName' set to '$path'"
    } else {
        Write-Output "Environment Variable '$envVarName' was not created"
    }
}

Set-DesktopWallpaper
Set-LockScreenWallpaper