# ⚠️ Disclaimer
**This is NOT an official tool by Bohemia Interactive.** This is a community-made utility. Use this script at your own risk. The author is not responsible for any loss of data or configuration, although the script is designed to create backups automatically.

**Performance Note:** While this script is designed to reduce UI lag and browser "stutter," **overall game or browser performance may not improve** depending on your hardware, network conditions, or Steam's internal API limits. This tool fixes specific file-bloat issues; it is not a "magic fix" for low FPS or poor internet connection.

---

# DayZ Server Browser & Launcher Optimizer

A surgical PowerShell utility to fix DayZ Launcher lag and slow server browser loading without losing your **Favorites**.

## ✨ What it does
* **Clears Server History**: Removes thousands of "seen" servers that bloat Steam's metadata.
* **Preserves Favorites**: Specifically skips the `favorites` and `filters` blocks in your VDF files.
* **Validates Syntax**: Ensures the `.vdf` file remains correctly formatted with balanced brackets.
* **Launcher Cleanup**: Wipes the `CECache` folder (a major cause of Launcher UI lag).
* **DNS Refresh**: Flushes your Windows DNS to improve server IP resolution and ping accuracy.

## 🚀 How to Use
1. Save `ClearDayZ.ps1` to your computer.
2. **Right-click** the file and select **Run with PowerShell**.
3. *Note: The script will automatically close Steam and DayZ to unlock the necessary files.*

## 📂 How to Restore a Backup
If your favorites disappear or the file becomes corrupted, follow these steps to restore your data:

1. **Close Steam** completely.
2. Navigate to the **DayZ_VDF_Backups** folder on your **Desktop**.
3. Find the `.vdf` file corresponding to your Steam ID (e.g., `12345678_backup.vdf`).
4. **Rename** that file to exactly `serverbrowser_hist.vdf`.
5. Copy the renamed file.
6. Navigate to your Steam userdata folder:  
   `C:\Program Files (x86)\Steam\userdata\<YourSteamID>\7\remote\`
7. **Paste and Overwrite** the existing file in that folder.
8. Restart Steam.

## 🛡️ Safety Features
* **Automatic Backups**: Every time the script runs, a copy of your original file is saved to your Desktop.
* **Syntax Guard**: The script performs a "Brace Count" validation. It will refuse to save the changes if the file structure isn't 100% mathematically balanced, preventing file corruption.

## ⚖️ License
MIT - Open source community tool.