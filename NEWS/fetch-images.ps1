$base = 'c:/Users/Hi/Documents/GitHub/Dung07-DT.github.io/NEWS'
$topics = @(
    @{query='Kylian Mbappé football'; name='mbappe.jpg'},
    @{query='Santiago Bernabéu Stadium'; name='real-madrid.jpg'},
    @{query='Anfield Stadium Liverpool'; name='anfield.jpg'},
    @{query='Old Trafford Manchester United'; name='old-trafford.jpg'},
    @{query='Camp Nou Barcelona stadium'; name='camp-nou.jpg'},
    @{query='Allianz Arena Munich'; name='allianz-arena.jpg'},
    @{query='Parc des Princes Paris Saint-Germain'; name='parc-des-princes.jpg'}
)

foreach ($t in $topics) {
    try {
        $searchUrl = 'https://commons.wikimedia.org/w/api.php?action=query&list=search&srsearch=' + [System.Uri]::EscapeDataString($t.query) + '&srnamespace=6&srlimit=1&format=json'
        $searchResp = Invoke-WebRequest -Uri $searchUrl -UseBasicParsing -ErrorAction Stop
        $searchJson = $searchResp.Content | ConvertFrom-Json
        
        if ($searchJson.query.search.Count -eq 0) {
            "NO RESULTS: $($t.name)" | Out-File -Append "$base/download.log"
            continue
        }
        
        $fileTitle = $searchJson.query.search[0].title
        $imageUrl = 'https://commons.wikimedia.org/w/api.php?action=query&titles=' + [System.Uri]::EscapeDataString($fileTitle) + '&prop=imageinfo&iiprop=url|size&format=json'
        $imageResp = Invoke-WebRequest -Uri $imageUrl -UseBasicParsing -ErrorAction Stop
        $imageJson = $imageResp.Content | ConvertFrom-Json
        
        $pages = $imageJson.query.pages
        $pageId = ($pages | Get-Member -MemberType NoteProperty | Select-Object -First 1).Name
        $imageInfo = $pages.$pageId.imageinfo[0]
        $directUrl = $imageInfo.url
        
        $outFile = Join-Path $base $t.name
        Invoke-WebRequest -Uri $directUrl -OutFile $outFile -ErrorAction Stop
        $size = (Get-Item $outFile).Length
        "SUCCESS: $($t.name) from $fileTitle - $size bytes" | Out-File -Append "$base/download.log"
    } catch {
        "FAILED: $($t.name) - $($_.Exception.Message)" | Out-File -Append "$base/download.log"
    }
}

