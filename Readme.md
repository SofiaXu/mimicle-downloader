# Mimicle Downloader
[ 中文 | [English](Readme.en-us.md) ]

用于下载 mimicle 上付费音声的小工具

## 系统需求
安装 PowerShell 7 及以上版本。
在要下载的目录下放置 `ffmpeg.exe`。

## 用法
```
.\Get-MimicleAlbum [-Token] <string> [-AlbumIds <string[]>] [-WithMetadataFile] [-WithCoverFile] [-WithTempFile]
```

Token：用户的 Token，字符串类型（写法 `"xxxx"`），此项必填不然没法下载，可在打开 mimicle 的浏览器页面里按 F12 
并在网络选项卡中搜索并找到 `profile` 名称的一行，点进去下拉翻到 `authorization: Baerer xxxx`，其中 xxxx 即是 Token。

AlbumIds：专辑的 Id，字符串数组类型（写法 `"xxxx","yyyy"`），此项选填，可以在打开相应页面后在浏览器地址栏最后几位就是，不填的话会展示提示框让你从最近购买的10个中选择。

WithMetadataFile：下载专辑的元数据的开关，开关类型，此项选填，填上会在下载的文件夹出现 `Metadata.json`。不填音频文件
也会写入元数据。

WithCoverFile：下载专辑的封面的开关，开关类型，此项选填，填上会在下载的文件夹出现 `Cover.webp`。不填音频文件
也会写入封面。

WithTempFile：保留下载生成的文件的开关，开关类型，此项选填，填上会将 `mimicle-temp` 文件夹保留，其中含有封面、元数据、m3u8、原始分段音频、日志等。

保存位置：当前运行目录下。

保存格式：`专辑名\轨道号（两位数字）. 轨道名.m4a`。