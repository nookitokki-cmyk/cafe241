# 카페24 FTP 접속 스크립트 (Windows PowerShell)
# 사용법: .\connect-ftp.ps1

param(
    [string]$ShopId
)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  카페24 FTP 접속 스크립트 (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 쇼핑몰 ID 입력
if (-not $ShopId) {
    $ShopId = Read-Host "쇼핑몰 ID를 입력하세요"
}

if (-not $ShopId) {
    Write-Host "오류: 쇼핑몰 ID가 필요합니다." -ForegroundColor Red
    Write-Host "사용법: .\connect-ftp.ps1 -ShopId [쇼핑몰ID]"
    exit 1
}

$FtpHost = "$ShopId.cafe24.com"
$FtpUser = Read-Host "FTP 아이디를 입력하세요 (보통 쇼핑몰 ID와 동일)"
$FtpPass = Read-Host "FTP 비밀번호를 입력하세요" -AsSecureString
$FtpPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($FtpPass)
)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "  접속 중: $FtpHost" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "스킨 파일 경로 안내:" -ForegroundColor Yellow
Write-Host "  HTML  : /skin/layout/, /skin/product/ 등"
Write-Host "  CSS   : /skin/css/"
Write-Host "  JS    : /skin/js/"
Write-Host "  이미지 : /skin/images/"
Write-Host ""

# Windows 기본 FTP 클라이언트로 접속
$ftpCommands = @"
open $FtpHost
$FtpUser
$FtpPassPlain
cd skin
dir
"@

$ftpCommands | ftp -n -i

Write-Host ""
Write-Host "FTP 접속이 종료되었습니다." -ForegroundColor Cyan
