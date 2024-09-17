# PowerShell script to change DNS settings to AdGuard's DoH address

# Function to update Chrome DNS settings
function Update-ChromeDNS {
    $chromePrefsPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences"
    if (Test-Path $chromePrefsPath) {
        $chromePrefs = Get-Content $chromePrefsPath -Raw | ConvertFrom-Json
        $chromePrefs.dns_over_https.mode = "secure"
        $chromePrefs.dns_over_https.templates = "https://dns.adguard.com/dns-query"
        $chromePrefs | ConvertTo-Json -Compress | Set-Content $chromePrefsPath
        Write-Host "Chrome DNS settings updated."
    } else {
        Write-Host "Chrome is not installed."
    }
}

# Function to update Edge DNS settings
function Update-EdgeDNS {
    $edgePrefsPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Preferences"
    if (Test-Path $edgePrefsPath) {
        $edgePrefs = Get-Content $edgePrefsPath -Raw | ConvertFrom-Json
        $edgePrefs.dns_over_https.mode = "secure"
        $edgePrefs.dns_over_https.templates = "https://dns.adguard.com/dns-query"
        $edgePrefs | ConvertTo-Json -Compress | Set-Content $edgePrefsPath
        Write-Host "Edge DNS settings updated."
    } else {
        Write-Host "Edge is not installed."
    }
}

# Function to update Firefox DNS settings
function Update-FirefoxDNS {
    $firefoxPrefsPath = "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\prefs.js"
    if (Test-Path $firefoxPrefsPath) {
        $firefoxPrefs = Get-Content $firefoxPrefsPath
        $firefoxPrefs = $firefoxPrefs -replace 'user_pref\("network.trr.mode", \d+\);', 'user_pref("network.trr.mode", 3);'
        $firefoxPrefs = $firefoxPrefs -replace 'user_pref\("network.trr.uri", ".*"\);', 'user_pref("network.trr.uri", "https://dns.adguard.com/dns-query");'
        $firefoxPrefs | Set-Content $firefoxPrefsPath
        Write-Host "Firefox DNS settings updated."
    } else {
        Write-Host "Firefox is not installed."
    }
}

# Update DNS settings for each browser
Update-ChromeDNS
Update-EdgeDNS
Update-FirefoxDNS

Write-Host "DNS settings update process completed."
