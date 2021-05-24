# パラメータとして、ファイルを保存するパス、ダウンロードファイル・リストのファイル名を宣言
Param([String]$path='%USERPROFILE%\AppData\Local\Temp\RTSP_Conversion_for_ONVIF', [String]$file='list.dat')

# ファイルをダウンロードするためのWebClientオブジェクトを生成
$cli = New-Object System.Net.WebClient
# ファイルリストから順にURLを抽出
foreach($url in Get-Content $file){
    # 取り出したURLからファイル名を取り出し、変数$fileにセット
  $uri = New-Object System.Uri($url)
  $file = Split-Path $uri.AbsolutePath -Leaf
    # 指定されたURLからファイルをダウンロードし、同名のファイル名で保存
  $cli.DownloadFile($uri, (Join-Path $path $file))
  $file + "をダウンロード完了しました。"
}


# 解凍する

Expand-Archive -Path $path CentOS-Userland-8-stream-aarch64-RaspberryPI-Minimal-4-sda.raw.xz -DestinationPath $path
Expand-Archive -Path $path Win32DiskImager-1.0.0-binary.zip -DestinationPath $path

#FAT32

$input = Read-Host "Drive_Letter input:" + :

Format /FS:FAT32 $input

#焼く

start $path Win32DiskImager.exe -"CentOS-Userland-8-stream-aarch64-RaspberryPI-Minimal-4-sda.raw"