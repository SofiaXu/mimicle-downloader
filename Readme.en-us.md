# Mimicle Downloader
[ [中文](Readme.md) | English ]

git init

## Requirement
PowerShell 7 or latest version.
Download `ffmpeg.exe` to your work directory.

## Usage
```
.\Get-MimicleAlbum [-Token] <string> [-AlbumIds <string[]>] [-WithMetadataFile] [-WithCoverFile] [-WithTempFile]
```

Token: User's token (Required). You can found it when you open mimicle with F12 dev tools. Search `profile` and click it.
`xxxx` in `authorization: Baerer xxxx` is the token.

AlbumIds: A list of album id. You can found it at the last part of the url of album. If you leave it blank, the tool will
let you choose one in your albums.

WithMetadataFile: Save metadata to `Metadata.json`.

WithCoverFile: Save cover to `Cover.json`.

WithTempFile: Leave temp files in `mimicle-temp` folder. (Include M3U8 File, Cover Image, Ffmpeg Log etc.)

Save Path: Work directory.

Save File Name: `Album\TrackNumber. Title.m4a`。