@echo off
setlocal

set "ROOT=%~dp0"
set "INFRA=%ROOT%base580-infra"
set "BACKEND=%ROOT%base580-backend"
set "FRONTEND=%ROOT%base580-frontend"
set "COMPOSE=docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.local.yml"

echo ========================================
echo       Base580 - Ambiente local
echo ========================================
echo.

if exist "C:\Program Files\Java\jdk-24\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-24"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

where docker >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker no esta disponible en PATH.
    exit /b 1
)

where java >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java no esta disponible en PATH.
    exit /b 1
)

for /f "tokens=3" %%V in ('java -version 2^>^&1 ^| findstr /i /c:"version"') do set "JAVA_VERSION=%%~V"
for /f "tokens=1 delims=." %%V in ("%JAVA_VERSION%") do set "JAVA_MAJOR=%%V"
if not "%JAVA_MAJOR%"=="24" (
    echo ERROR: El backend requiere Java 24. Version detectada: %JAVA_VERSION%
    exit /b 1
)

where npm >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node/npm no esta disponible en PATH.
    exit /b 1
)

if not exist "%INFRA%\.env.local" (
    echo ERROR: Falta base580-infra\.env.local.
    echo Crea una copia de env.local.example con ese nombre.
    exit /b 1
)

echo Validando Compose local...
pushd "%INFRA%"
%COMPOSE% config --quiet
if errorlevel 1 (
    echo ERROR: La configuracion local de Compose no es valida.
    popd
    exit /b 1
)

echo Levantando MongoDB local...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c = Get-NetTCPConnection -LocalPort 27017 -State Listen -ErrorAction SilentlyContinue; if ($c) { $p = Get-Process -Id $c[0].OwningProcess -ErrorAction SilentlyContinue; if ($p.ProcessName -eq 'mongod') { exit 0 } }; exit 1"
if errorlevel 1 (
    %COMPOSE% up -d mongo
    if errorlevel 1 (
        echo ERROR: No se pudo levantar MongoDB.
        popd
        exit /b 1
    )
) else (
    echo MongoDB nativo detectado en el puerto 27017; se reutilizara.
)
popd

echo Abriendo backend...
start "Base580 Backend" /D "%BACKEND%" cmd /k "set JAVA_HOME=C:\Program Files\Java\jdk-24 && set PATH=C:\Program Files\Java\jdk-24\bin;%%PATH%% && set MONGODB_URI=mongodb://localhost:27017/base580 && mvnw.cmd spring-boot:run"

echo Abriendo frontend...
start "Base580 Frontend" /D "%FRONTEND%" cmd /k "npm start"

echo.
echo.
echo ========================================
echo     Estado del proyecto  base580
echo ========================================
echo.

REM --- leer ultimos cambios del PRD ---
set "PRD=%INFRA%\wiki\PRD Base580.md"
if exist "%PRD%" (
    echo [PRD] Ultimas entradas en Registro de cambios:
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$lineas = Get-Content '%PRD%' -Encoding UTF8; $inicio = ($lineas | Select-String '## 9. Registro' | Select-Object -First 1).LineNumber; if ($inicio) { $bloque = $lineas[$inicio..([Math]::Min($inicio+25,$lineas.Count-1))]; $bloque | ForEach-Object { Write-Host $_ } }"
    echo.
) else (
    echo [PRD] No se encontro PRD Base580.md en %PRD%
)

REM --- hallazgos IA abiertos ---
if exist "%PRD%" (
    echo [Mejoras IA] Hallazgos abiertos:
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$lineas = Get-Content '%PRD%' -Encoding UTF8; $lineas | Select-String 'IA-\d+.*Abierto' | ForEach-Object { Write-Host '  ' $_.Line.Substring(0,[Math]::Min(120,$_.Line.Length)) }"
    echo.
)


echo Ambiente local iniciado.
echo Frontend: http://localhost:4200
echo Backend:  http://localhost:8080/actuator/health
echo MongoDB:  mongodb://localhost:27017/base580
echo.
echo Cierra las ventanas de backend y frontend para detenerlos.
echo Para detener MongoDB usa:
echo   cd base580-infra
echo   docker compose --env-file .env.local -f docker-compose.yml -f docker-compose.local.yml stop mongo
echo.
pause
