function Get-Steam64Id {
    param (
        [string]$profileLink
    )
    if($profileLink -match '^\d{17}$') {
        return $profileLink
    }
    if ($profileLink -match '^(https://)?steamcommunity\.com/(id|profiles)/.+$') {
        return Get-Steam64IdFromSteam $profileLink
    } elseif ($profileLink -match '^(https://)?(csstats\.gg/player|leetify\.com/app/profile|faceitfinder\.com/profile)/\d{17}$') {
        return $profileLink.Split('/')[-1]
    } elseif ($profileLink -match '^(https://)?www\.faceit\.com/en/players/.+$')  {
        Write-Debug "Faceit link detected"
        return Get-Steam64IdFromFaceit $profileLink
    } else {
        Get-Steam64IdFromSteam $profileLink
    }
}

function Get-Steam64IdFromSteam {
    param (
        [string]$profileLink
    )
    try {
        $res = Invoke-WebRequest -Uri "https://steamid.xyz/$profileLink"
    } catch {
        Write-Output "Steam profile link is most likely invalid or steamid.xyz is down"
        exit 2
    }

    $index = $res.Content.IndexOf('<tr><td>Steam64 ID</td><td class="value" title="click to copy">')
    if ($index -eq -1) {
        Write-Output "Steam64 ID not found in the response."
        exit 3
    }

    return $res.Content.Substring($index + 63, 17)
}

function Get-Faceit {
    param (
        [string]$steam64id
    )
    try {
        $res = Invoke-WebRequest -Uri "https://faceitfinder.com/profile/$steam64id"
        $startIndex = $res.Content.IndexOf('https://www.faceit.com/en/players/')
        if ($startIndex -eq -1) {
            return "No Faceit link found"
        }

        $endIndex = $res.Content.IndexOf('"', $startIndex)
        return $res.Content.Substring($startIndex, $endIndex - $startIndex)
    }
    catch {
        return "No Faceit link found"
    }
}

function Get-Steam64IdFromFaceit {
    param (
        [string]$faceit
    )
    $link = "https://www.faceit.com/api/users/v1/nicknames/$faceit"
    if ($faceit -match '^(https://)?www\.faceit\.com/en/players/.+$')  {
        $faceit = $faceit.Split('/')[-1]
        $link = "https://www.faceit.com/api/users/v1/nicknames/$faceit"
    }
    try {
        $res = ConvertFrom-Json (Invoke-WebRequest -Uri $link)
        return $res.payload.platforms.steam.id64
    } catch {
        Write-Output "faceit profile link or name is invalid or faceit is down"
        exit 4
    }
    if ($res.errors) {
        Write-Output "faceit profile link or name is invalid"
        exit 4
    }
}

$res = ""
if ($args.Count -eq 0) {
    Write-Output "Usage: getLinksFromSteam.ps1 <steam profile link>"
    exit 1
}
$steam64id = Get-Steam64Id -profileLink $args[0]
Write-Debug "Steam64 ID: $steam64id"
$faceitLink = Get-Faceit -steam64id $steam64id

Write-Output "Steam: https://steamcommunity.com/profiles/$steam64id" "steamid: https://steamid.xyz/$steam64id" "csstats: https://csstats.gg/player/$steam64id" "leetify: https://leetify.com/app/profile/$steam64id" "facitfinder: https://faceitfinder.com/profile/$steam64id" "faceit: $faceitLink"
