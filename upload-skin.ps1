# 카페24 스킨 파일 FTP 업로드 스크립트 (Windows PowerShell)
# 사용법: .\upload-skin.ps1
# skin 폴더의 파일을 카페24 FTP 서버에 업로드합니다.

param(
    [string]$ShopId,
    [string]$Username,
    [string]$Password
)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  카페24 스킨 FTP 업로드" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 접속 정보 입력
if (-not $ShopId) {
    $ShopId = Read-Host "쇼핑몰 ID"
}
if (-not $Username) {
    $Username = Read-Host "FTP 아이디"
}
if (-not $Password) {
    $SecPass = Read-Host "FTP 비밀번호" -AsSecureString
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)
    )
}

$FtpHost = "ftp://$ShopId.cafe24.com"
$SkinPath = Join-Path $PSScriptRoot "skin"

if (-not (Test-Path $SkinPath)) {
    Write-Host "오류: skin 폴더를 찾을 수 없습니다: $SkinPath" -ForegroundColor Red
    exit 1
}

# FTP 업로드 함수
function Upload-FtpFile {
    param(
        [string]$LocalFile,
        [string]$RemotePath
    )

    try {
        $uri = New-Object System.Uri("$FtpHost$RemotePath")
        $ftp = [System.Net.FtpWebRequest]::Create($uri)
        $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
        $ftp.UseBinary = $true
        $ftp.UsePassive = $true

        $content = [System.IO.File]::ReadAllBytes($LocalFile)
        $ftp.ContentLength = $content.Length

        $stream = $ftp.GetRequestStream()
        $stream.Write($content, 0, $content.Length)
        $stream.Close()

        $response = $ftp.GetResponse()
        $response.Close()

        return $true
    }
    catch {
        Write-Host "  실패: $_" -ForegroundColor Red
        return $false
    }
}

# skin 폴더 내 파일 목록
$files = Get-ChildItem -Path $SkinPath -Recurse -File
$total = $files.Count
$uploaded = 0
$failed = 0

Write-Host ""
Write-Host "업로드할 파일: $total 개" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($SkinPath.Length).Replace("\", "/")
    $remotePath = "/skin$relativePath"

    Write-Host "  [$($uploaded + $failed + 1)/$total] $remotePath ... " -NoNewline

    if (Upload-FtpFile -LocalFile $file.FullName -RemotePath $remotePath) {
        Write-Host "OK" -ForegroundColor Green
        $uploaded++
    }
    else {
        $failed++
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  업로드 완료" -ForegroundColor Cyan
Write-Host "  성공: $uploaded / 실패: $failed / 전체: $total" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Yellow" })
Write-Host "==========================================" -ForegroundColor Cyan
