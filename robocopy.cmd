@echo off

setlocal enabledelayedexpansion

:: Configuracion Inicial

title Robocopy hecho por Ian (@ArtiicKx)
color 0B

:: Preguntas

set /p "ruta_origen=Ingrese la ruta de origen: "
set /p "ruta_destino=Ingrese la ruta de destino: "

:: Verificar si las rutas existen

if not exist "%ruta_origen%" (
    echo Error: La ruta de origen no existe. Por favor verifica que esté escrita correctamente.
    pause
    exit /b 1
)

if not exist "%ruta_destino%" (
    echo Error: La ruta de destino no existe. Por favor verifica que esté escrita correctamente.
    pause
    exit /b 1
)


:: Opciones avanzadas

echo.
echo [1/6] ¿Incluir subcarpetas? (S/N)
choice /C SN /N

if errorlevel 2 set "subcarpetas=" & set "desc_subcarpetas=NO" 
if errorlevel 1 set "subcarpetas=/E" & set "desc_subcarpetas=Sí (todas)"

echo.
echo [2/6] ¿Modo espejo? (Elimina en destino lo que no está en origen) (S/N)
choice /C SN /N
if errorlevel 2 set "mirror=" & set "desc_mirror=NO"
if errorlevel 1 set "mirror=/MIR" & set "desc_mirror=Sí (/MIR)"

echo.
echo [3/6] ¿Reintentar ante errores? (S/N)
choice /C SN /N
if errorlevel 2 set "reintentos=" & set "desc_reintentos=NO"
if errorlevel 1 (
   set "reintentos=/R:3 /W:5"
   set "desc_reintentos=3 reintentos (5s espera)"
)

echo.
echo [4/6] ¿Usar multihilo para velocidad? (S/N)
choice /C SN /N
if errorlevel 2 set "multihilo=" & set "desc_multihilo=NO"
if errorlevel 1 (
   set "multihilo=/MT:8"
   set "desc_multihilo=8 hilos (/MT:8)"
)

echo.
echo [5/6] ¿Generar archivo de log? (S/N)
choice /C SN /N
if errorlevel 2 set "log=" & set "desc_log=NO"
if errorlevel 1 (
  set "hora=!time: =0!"
  set "log=/LOG+:Robocopy_Log_!date:~-10,4!-!date:~-5,2!-!date:~-2,2!_!hora:~0,2!h!hora:~3,2!.log"
   set "desc_log=Sí (en misma carpeta del script)"
)

:: Resumen de la configuracion
cls 
echo.
echo ===== CONFIGURACIÓN SELECCIONADA =====
echo Origen    : !ruta_origen!
echo Destino   : !ruta_destino!
echo Subcarpetas: !desc_subcarpetas!
echo Modo espejo: !desc_mirror!
echo Reintentos: !desc_reintentos!
echo Multihilo : !desc_multihilo!
echo Log       : !desc_log!
echo.
echo ¿Ejecutar con esta configuración? (S/N)
choice /C SN /N
if errorlevel 2 exit /b

:: Ejecutar Robocopy

robocopy !ruta_origen! !ruta_destino! !subcarpetas! !mirror! !reintentos! !multihilo! !log!

:: Fin del script

echo.
echo Operación completada. Presiona cualquier tecla para salir...
pause >nul