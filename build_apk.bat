@echo off
chcp 65001 > nul
echo =======================================================
echo       وصّلني | WASSLNI - أداة بناء ملفات الـ APK
echo =======================================================
echo.

where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [!] تحذير: Flutter SDK غير مثبت في مسار النظام (PATH).
    echo [i] لبناء الـ APK محلياً:
    echo     1. قم بتحميل Flutter من https://docs.flutter.dev/get-started/install/windows
    echo     2. فك الضغط وأضف مجلد bin إلى متغيرات البيئة PATH.
    echo.
    echo [i] بديل فوري بدون أي تثبيت:
    echo     يمكنك تجربة التطبيق مباشرة على هاتفك الآن بمسح رمز QR عبر:
    echo     http://192.168.1.3:5000/install.html
    echo.
    pause
    exit /b 1
)

echo [+] جاري بناء تطبيق الزبون (Rider App)...
cd /d "%~dp0apps\rider-app"
call flutter pub get
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo [OK] تم بناء تطبيق الزبون بنجاح:
    echo      apps\rider-app\build\app\outputs\flutter-apk\app-release.apk
)

echo.
echo [+] جاري بناء تطبيق السائق (Driver App)...
cd /d "%~dp0apps\driver-app"
call flutter pub get
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo [OK] تم بناء تطبيق السائق بنجاح:
    echo      apps\driver-app\build\app\outputs\flutter-apk\app-release.apk
)

echo.
echo =======================================================
echo اكتملت العملية بنجاح! يمكنك نقل ملفات APK لهاتفك وتثبيتها.
echo =======================================================
pause

