# Kodi Skin Localization Validator (PowerShell)

A PowerShell troubleshooting and validation script for Kodi skins, designed to verify correct usage of $LOCALIZE[] and $ADDON[] string references.<br/>
The script helps skin developers clean up legacy or incorrect localization usage and ensure full compatibility with Kodi 22 and newer.<br/>
This script was used to successfully clean and modernize the Xonfluence skin.<br/>

## What this script checks
The script scans all XML files in the skin’s xml directory and validates four localization rules:

1. $LOCALIZE[x] with x in range 31000–31999
Expected result: -> ZERO files.<br/>
These IDs belong to the skin namespace and must not be accessed via $LOCALIZE[].

3. $LOCALIZE[x] with x outside range 31000–31999
Expected result: can be lines with such references -> Allowed.<br/>
These usually refer to Kodi core strings and are valid.

5. $ADDON[skin.name x] with x in range 31000–31999
Expected result: can be lines with such references -> Allowed.<br/>
This is the correct and required way to reference skin strings in Kodi 22+.

7. $ADDON[skin.name x] with x outside range 31000–31999
Expected result: -> ZERO files.<br/>
Referencing non-skin IDs via $ADDON[] is invalid.

## Why this script is useful
Detects Kodi 22 incompatibilities<br/>
Finds mixed or legacy localization usage<br/>
Prevents silent UI failures caused by invalid string resolution<br/>
Ensures strict compliance with Kodi skin string rules<br/>
Lists each affected XML file only once per rule<br/>

## Requirements
Windows with PowerShell 5.1 or newer<br/>
Kodi skin source files<br/>
No external modules required.<br/>

## How to use
**1. Place the script**<br/>
Copy Check-skin.ps1 into the root directory of your skin, at the same level where addon.xml is present<br/>

**2. Run the script**<br/>
Open PowerShell in the skin root folder and run:<br/>
.\Check-skin.ps1<br/>

**3. Enter the skin name when prompted**<br/>
Type the skin name together with "skin" word, (example: skin.xonfluence)<br/>

## Output
The script prints four clearly separated sections:<br/>
Green → rule satisfied<br/>
Yellow → allowed usage (informational)<br/>
Red → violations that must be fixed<br/>
Each reported file is printed with its full path, making fixes fast and reliable.<br/>

## Example output
###### ===== SKIN STRING USAGE CHECK =====
###### 
###### $LOCALIZE[x] with x inside 31000–31999 (EXPECTED ZERO): 0 files (OK)
###### 
###### $LOCALIZE[x] with x outside 31000–31999 (ALLOWED): 83 file(s)
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\Includes.xml
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\Settings.xml
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\SkinSettings.xml
###### [...]
###### 
###### $ADDON[skin.xonfluence x] with x inside 31000–31999 (ALLOWED): 78 file(s)
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\DialogAddonInfo.xml
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\IncludesHomeWidget.xml
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\Settings.xml
######   C:\...Roaming\Kodi\addons\skin.xonfluence\xml\SkinSettings.xml
###### [...]
######
###### $ADDON[skin.xonfluence x] with x outside 31000–31999 (EXPECTED ZERO): 0 files (OK)

## Notes
The script assumes it is run from the skin’s root directory<br/>
Each XML file is listed once per rule, even if multiple matches exist<br/>
Safe against empty or unreadable XML files<br/>
No special characters or Unicode symbols are used (console-safe)<br/>

## Credits
Developed during real-world cleanup and modernization of the Xonfluence skin for Kodi 22 compatibility.
