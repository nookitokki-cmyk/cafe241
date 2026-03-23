@echo off
chcp 65001 >nul 2>&1
title 카페24 FTP 접속

echo.
echo ==========================================
echo   카페24 FTP 접속
echo ==========================================
echo.

set /p SHOP_ID="쇼핑몰 ID를 입력하세요: "
if "%SHOP_ID%"=="" (
    echo 오류: 쇼핑몰 ID가 필요합니다.
    pause
    exit /b 1
)

set FTP_HOST=%SHOP_ID%.cafe24.com
set /p FTP_USER="FTP 아이디 (보통 쇼핑몰 ID와 동일): "
set /p FTP_PASS="FTP 비밀번호: "

echo.
echo ==========================================
echo   접속 중: %FTP_HOST%
echo ==========================================
echo.
echo 스킨 파일 경로 안내:
echo   HTML  : /skin/layout/, /skin/product/ 등
echo   CSS   : /skin/css/
echo   JS    : /skin/js/
echo   이미지 : /skin/images/
echo.
echo 로그인 후 skin 폴더로 이동됩니다.
echo FTP 명령어: ls(목록), get(다운), put(업로드), bye(종료)
echo.

:: FTP 명령 파일 생성 (로그인 + skin 이동까지만)
> "%TEMP%\cafe24ftp.txt" (
    echo open %FTP_HOST%
    echo user %FTP_USER% %FTP_PASS%
    echo binary
    echo cd web/skin
    echo ls
)

:: FTP 접속
ftp -n -s:"%TEMP%\cafe24ftp.txt"

:: 임시 파일 삭제 (비밀번호 포함)
del "%TEMP%\cafe24ftp.txt" >nul 2>&1

echo.
echo FTP 접속이 종료되었습니다.
pause
