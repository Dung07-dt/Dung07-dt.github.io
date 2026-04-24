$base = 'c:/Users/Hi/Documents/GitHub/Dung07-DT.github.io/NEWS'
$images = @(
    @{url='https://upload.wikimedia.org/wikipedia/commons/0/05/Kylian_Mbapp%C3%A9_2018.jpg'; name='mbappe.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/1/1f/Santiago_Bernab%C3%A9u_Stadium.jpg'; name='real-madrid.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/0/02/Anfield_Stadium%2C_Liverpool.jpg'; name='anfield.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/5/53/Old_Trafford_inside_20060726_1.jpg'; name='old-trafford.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/5/5c/Camp_Nou_aerial_%28cropped%29.jpg'; name='camp-nou.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/8/8a/Allianz_Arena_Munich.jpg'; name='allianz-arena.jpg'},
    @{url='https://upload.wikimedia.org/wikipedia/commons/8/88/Parc_des_Princes.jpg'; name='parc-des-princes.jpg'}
)

foreach ($img in $images) {
    $outFile = Join-Path $base $img.name
    try {
        Invoke-WebRequest -Uri $img.url -OutFile $outFile -ErrorAction Stop
        $size = (Get-Item $outFile).Length
        Write-Host "SUCCESS: $($img.name) - $size bytes"
    } catch {
        Write-Host "FAILED: $($img.name)"
    }
}

