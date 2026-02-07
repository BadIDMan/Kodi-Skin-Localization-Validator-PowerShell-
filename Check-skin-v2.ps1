Clear-Host

# Ask for skin name
$skinName = Read-Host 'Type the skin name together with "skin" word, example: skin.xonfluence'

$xmlPath  = Join-Path (Get-Location) "xml"

if (-not (Test-Path $xmlPath)) {
    Write-Host "ERROR: XML folder not found: $xmlPath" -ForegroundColor Red
    exit 1
}



# Regex patterns
$reLocalize        = '\$LOCALIZE\[(\d+)\]'
$reAddon           = '\$ADDON\[' + [regex]::Escape($skinName) + '\s+(\d+)\]'
$inRange           = { param($n) $n -ge 31000 -and $n -le 31999 }

# Result containers (HashSet-like behavior)
$case1 = @{}
$case2 = @{}
$case3 = @{}
$case4 = @{}

Get-ChildItem -Path $xmlPath -Recurse -Filter *.xml | ForEach-Object {

    $file = $_.FullName
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue

    if ([string]::IsNullOrEmpty($content)) {
        return
    }

    # $LOCALIZE[x]
    foreach ($m in [regex]::Matches($content, $reLocalize)) {
        $id = [int]$m.Groups[1].Value
        if (& $inRange $id) {
            $case1[$file] = $true
        } else {
            $case2[$file] = $true
        }
    }

    # $ADDON[skin.name x]
    foreach ($m in [regex]::Matches($content, $reAddon)) {
        $id = [int]$m.Groups[1].Value
        if (& $inRange $id) {
            $case3[$file] = $true
        } else {
            $case4[$file] = $true
        }
    }
}

function Print-Result {
    param (
        [string]$Title,
        [hashtable]$Files,
        [bool]$MustBeZero
    )

    $count = $Files.Count

    if ($MustBeZero) {
        if ($count -eq 0) {
            Write-Host "${Title}: 0 files (OK)" -ForegroundColor Green
        } else {
            Write-Host "${Title}: $count file(s) FOUND (ERROR)" -ForegroundColor Red
            $Files.Keys | Sort-Object | ForEach-Object { Write-Host "  $_" }
        }
    } else {
        Write-Host "${Title}: $count file(s)" -ForegroundColor Yellow
        if ($count -gt 0) {
            $Files.Keys | Sort-Object | ForEach-Object { Write-Host "  $_" }
        }
    }

    Write-Host ""
}

Write-Host "===== SKIN STRING USAGE CHECK ====="
Write-Host ""

Print-Result '$LOCALIZE[x] with x inside 31000–31999 (EXPECTED ZERO)' $case1 $true
Print-Result '$LOCALIZE[x] with x outside 31000–31999 (ALLOWED)'       $case2 $false
Print-Result '$ADDON[skin.name x] with x inside 31000–31999 (ALLOWED)' $case3 $false
Print-Result '$ADDON[skin.name x] with x outside 31000–31999 (EXPECTED ZERO)' $case4 $true
