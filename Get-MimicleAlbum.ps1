#Requires -Version 7
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        Position = 0,
        ParameterSetName = "LiteralPath",
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Token,
    [Parameter()]
    [string[]]
    $AlbumIds,
    [Parameter()]
    [switch]
    $WithMetadataFile,
    [Parameter()]
    [switch]
    $WithCoverFile,
    [Parameter()]
    [switch]
    $WithTempFile
)
para
function Get-UserAlbums(
    $UserToken
) {
    (Invoke-WebRequest -UseBasicParsing -Uri "https://mimicle.com/api/my/purchased/albums" `
        -Headers @{
        "authority"          = "mimicle.com"
        "method"             = "GET"
        "path"               = "/api/my/purchased/albums"
        "scheme"             = "https"
        "accept"             = "*/*"
        "accept-encoding"    = "gzip, deflate, br"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        "authorization"      = "Bearer $UserToken"
        "dnt"                = "1"
        "referer"            = "https://mimicle.com/my/purchased"
        "sec-ch-ua"          = "`"Microsoft Edge`";v=`"105`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"105`""
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "sec-fetch-dest"     = "empty"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-site"     = "same-origin"
    }).Content | ConvertFrom-Json
}

function Get-AlbumInfo(
    $AlbumId
) {
    (Invoke-WebRequest -UseBasicParsing -Uri "https://mimicle.com/api/album/nid/$AlbumId" `
        -Headers @{
        "authority"          = "mimicle.com"
        "method"             = "GET"
        "scheme"             = "https"
        "accept"             = "application/json, text/plain, */*"
        "accept-encoding"    = "gzip, deflate, br"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        "dnt"                = "1"
        "sec-ch-ua"          = "`"Microsoft Edge`";v=`"105`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"105`""
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "sec-fetch-dest"     = "empty"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-site"     = "same-origin"
    }).Content | ConvertFrom-Json
}

function Get-TrackDownloadToken(
    $TrackId,
    $UserToken
) {
    (Invoke-WebRequest -UseBasicParsing -Uri "https://mimicle.com/api/permission/generate/$TrackId" `
        -Headers @{
        "authority"          = "mimicle.com"
        "method"             = "GET"
        "scheme"             = "https"
        "accept"             = "*/*"
        "accept-encoding"    = "gzip, deflate, br"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        "authorization"      = "Bearer $UserToken"
        "dnt"                = "1"
        "sec-ch-ua"          = "`"Microsoft Edge`";v=`"105`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"105`""
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "sec-fetch-dest"     = "empty"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-site"     = "same-origin"
    }).Content | ConvertFrom-Json
}

function Get-ContentFromUrl(
    $ContentUrl,
    $ContentName,
    $StreamToken,
    $OutPath
) {
    Invoke-WebRequest -UseBasicParsing -Uri "$($ContentUrl)$($ContentName)" `
        -Headers @{
        "accept"             = "*/*"
        "accept-encoding"    = "gzip, deflate, br"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        "dnt"                = "1"
        "origin"             = "https://mimicle.com"
        "referer"            = "https://mimicle.com/"
        "sec-ch-ua"          = "`"Microsoft Edge`";v=`"105`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"105`""
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "sec-fetch-dest"     = "empty"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-site"     = "same-site"
        "x-stream-token"     = "$StreamToken"
    } -OutFile $OutPath
}

function Test-ContentFromUrl(
    $ContentUrl,
    $ContentName,
    $StreamToken,
    $OutPath
) {
    Invoke-WebRequest -UseBasicParsing -Uri "$($ContentUrl)$($ContentName)" `
        -Method Options `
        -Headers @{
        "accept"             = "*/*"
        "accept-encoding"    = "gzip, deflate, br"
        "accept-language"    = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
        "dnt"                = "1"
        "origin"             = "https://mimicle.com"
        "referer"            = "https://mimicle.com/"
        "sec-ch-ua"          = "`"Microsoft Edge`";v=`"105`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"105`""
        "sec-ch-ua-mobile"   = "?0"
        "sec-ch-ua-platform" = "`"Windows`""
        "sec-fetch-dest"     = "empty"
        "sec-fetch-mode"     = "cors"
        "sec-fetch-site"     = "same-site"
        "x-stream-token"     = "$StreamToken"
    } -OutFile $OutPath
}
$testContentFromUrl = ${function:Test-ContentFromUrl}.ToString()
$getContentFromUrl = ${function:Get-ContentFromUrl}.ToString()

if ($AlbumIds.Count -eq 0) {
    $albums = (Get-UserAlbums($Token)).items
    $AlbumIds = ($albums | Out-GridView -PassThru).nid
}
foreach ($albumId in $AlbumIds) {
    $albumInfo = Get-AlbumInfo($albumId)
    $albumName = $albumInfo.title
    if (-not (Test-Path "./$albumName")) {
        [void](New-Item -ItemType Directory "./$albumName")
    }
    if ($WithMetadataFile.IsPresent) {
        $albumInfo | ConvertTo-Json -Depth 9 | Out-File "./$albumName/Metadata.json" 
    }
    $tracks = $albumInfo.tracks
    # Download Cover to temp
    $coverPath = "./mimicle-temp"
    if (-not (Test-Path -Path $coverPath)) {
        [void](New-Item -ItemType Directory $coverPath)
    }
    $coverPath += "/$($albumInfo.id).webp"
    Invoke-WebRequest $albumInfo.coverArt.path -OutFile $coverPath
    # Create Audio Metadata
    $metadataHeader = ";FFMETADATA1"
    $artist = "artist=$([string]::Join(" / ", ($albumInfo.castTags | Where-Object {$_.attributeType -eq "voiceActor"}).tag.castName))"
    $albumArtist = "album_$artist"
    $genre = "genre=asmr"
    $date = "date=$($albumInfo.publishAt.Year)"
    $album = "album=$($albumInfo.title)"
    foreach ($track in $tracks) {
        $trackToken = Get-TrackDownloadToken -TrackId $track.id -UserToken $Token
        $trackPath = (($track.file.formats | ConvertTo-Json | ConvertFrom-Json -AsHashtable).getenumerator() | Where-Object { $_.value["type"] -eq "stream" } | Sort-Object { [int]::Parse($_.Value["bitRate"].Replace("k", "")) } -Descending)[0].Value["filePath"]
        $trackFileName = [System.IO.Path]::GetFileName($trackPath)
        $downloadPath = "./mimicle-temp/$($track.id)"
        if (-not (Test-Path -Path $downloadPath)) {
            [void](New-Item -ItemType Directory $downloadPath)
        }
        # Get M3U8
        Test-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath -StreamToken $trackToken.token -OutPath "$downloadPath/$trackFileName"
        Get-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath -StreamToken $trackToken.token -OutPath "$downloadPath/$trackFileName"
        # Get Key
        Test-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath.Replace($trackFileName, "stream") -StreamToken $trackToken.token -OutPath "$downloadPath/stream"
        Get-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath.Replace($trackFileName, "stream") -StreamToken $trackToken.token -OutPath "$downloadPath/stream"
        $m3u8 = Get-Content "$downloadPath/$trackFileName"
        $m3u8 | Foreach-Object -ThrottleLimit 16 -Parallel {
            $line = $_;
            if ($line.StartsWith("#")) {
                return;
            }
            if ([string]::IsNullOrWhiteSpace($line)) {
                return;
            }
            ${function:Test-ContentFromUrl} = $using:testContentFromUrl
            ${function:Get-ContentFromUrl} = $using:getContentFromUrl
            $trackToken = $using:trackToken
            $trackPath = $using:trackPath
            $trackFileName = $using:trackFileName
            $downloadPath = $using:downloadPath
            while ($true) {
                try {
                    Test-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath.Replace($trackFileName, $line) -StreamToken $trackToken.token -OutPath "$downloadPath/$line"
                    Get-ContentFromUrl -ContentUrl $trackToken.contentPath -ContentName $trackPath.Replace($trackFileName, $line) -StreamToken $trackToken.token -OutPath "$downloadPath/$line"
                    return;
                }
                catch {
                    continue;
                }
            }
        }
        [string]::Join("`n", @($metadataHeader, $artist, $albumArtist, $genre, $date, $album, "title=$($track.title)", "track=$($track.trackNumber)/$($tracks.Count)")) > "$downloadPath/metadata.txt"
        .\ffmpeg -allowed_extensions ALL -i "$downloadPath/$trackFileName" -i $coverPath -i "$downloadPath/metadata.txt" -map_metadata 2 -c copy -map 0 -map 1 -disposition:v:0 attached_pic "./$($albumName)/$($track.trackNumber.ToString("00")). $($track.title).m4a" *> "$downloadPath/ffmpeg.log"
        if (-not $WithTempFile.IsPresent) {
            Remove-Item -Force -Recurse $downloadPath
        }
    }
    if ($WithCoverFile.IsPresent) {
        Copy-Item $coverPath "./$($albumName)/Cover.webp" -Force
    }
    if (-not $WithTempFile.IsPresent) {
        Remove-Item -Force $coverPath
    }
}
if (-not $WithTempFile.IsPresent) {
    Remove-Item -Force -Recurse "./mimicle-temp"
}