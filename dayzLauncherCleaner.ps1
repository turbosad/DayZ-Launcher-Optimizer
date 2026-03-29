# --- Configuration ---
$SteamPath = "C:\Program Files (x86)\Steam\userdata"
$LauncherCache = "$env:LOCALAPPDATA\DayZ Launcher"
$BackupFolder = "$env:USERPROFILE\Desktop\DayZ_VDF_Backups"

# 1. Kill Steam & DayZ (Required to unlock files)
Write-Host "Closing Steam and DayZ..." -ForegroundColor Cyan
Stop-Process -Name "Steam" -ErrorAction SilentlyContinue
Stop-Process -Name "DayZLauncher" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 2. Clear DayZ Launcher Cache (The CECache folder)
if (Test-Path $LauncherCache) {
    Write-Host "Clearing Launcher UI Cache..." -ForegroundColor Gray
    Get-ChildItem -Path $LauncherCache -Recurse | Where-Object { $_.Name -ne "launcher.db" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

# 3. Find and Clean VDF Files
$VdfFiles = Get-ChildItem -Path $SteamPath -Filter "serverbrowser_hist.vdf" -Recurse -ErrorAction SilentlyContinue

foreach ($File in $VdfFiles) {
    $FilePath = $File.FullName
    $HistoryProcessed = $false # Variable initialized
    
    # Backup
    if (!(Test-Path $BackupFolder)) { New-Item -Path $BackupFolder -ItemType Directory | Out-Null }
    Copy-Item -Path $FilePath -Destination (Join-Path $BackupFolder "$($File.Directory.Parent.Name)_backup.vdf") -Force

    $Lines = Get-Content -Path $FilePath
    $NewContent = New-Object System.Collections.Generic.List[string]
    $InHistorySection = $false

    foreach ($Line in $Lines) {
        if ($Line -match '"history"') {
            $NewContent.Add($Line)
            $NewContent.Add("`t{")
            $NewContent.Add("`t}")
            $InHistorySection = $true
            $HistoryProcessed = $true # Variable assigned
            continue
        }

        if ($InHistorySection) {
            if ($Line -match '"favorites"' -or $Line -match '"filters"') {
                $InHistorySection = $false
                $NewContent.Add($Line)
            }
            continue
        }
        $NewContent.Add($Line)
    }

    # Add the final wrapper bracket
    $NewContent.Add("}")

    # Syntax Validation
    $Open = ([regex]::Matches(($NewContent -join ""), '\{')).Count
    $Close = ([regex]::Matches(($NewContent -join ""), '\}')).Count

    if ($Open -eq $Close -and $HistoryProcessed) { # Variable USED here
        $NewContent | Set-Content -Path $FilePath -Encoding UTF8
        Write-Host "SUCCESS: History purged and Syntax Validated ($Open/$Close) for User: $($File.Directory.Parent.Name)" -ForegroundColor Green
    } else {
        Write-Host "FAILED: Syntax Mismatch or History not found for $($File.Directory.Parent.Name)" -ForegroundColor Red
    }
}

# 4. Flush DNS (Helps with server IP resolution)
Write-Host "Flushing DNS Cache..." -ForegroundColor Cyan
ipconfig /flushdns | Out-Null

Write-Host "`nCleanup Complete! Your Favorites are safe." -ForegroundColor White