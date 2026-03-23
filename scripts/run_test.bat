@echo off
set MODULE=%1

if "%MODULE%"=="" (
    echo [ERREUR] Quel module veux-tu tester ?
    exit /b 1
)

echo Test de : %MODULE%

:: Trouver automatiquement le fichier RTL
set RTL_FILE=
if exist "rtl\core\%MODULE%.sv" set RTL_FILE=rtl\core\%MODULE%.sv
if exist "rtl\memory\%MODULE%.sv" set RTL_FILE=rtl\memory\%MODULE%.sv
if exist "rtl\top\%MODULE%.sv" set RTL_FILE=rtl\top\%MODULE%.sv

if "%RTL_FILE%"=="" (
    echo [ERREUR] Impossible de trouver %MODULE%.sv dans core memory ou top
    exit /b 1
)

:: Compilation
iverilog -g2012 -I "rtl\core" -o "simulation\sim_data\%MODULE%.out" "%RTL_FILE%" "simulation\testbench\%MODULE%_tb.sv"

:: Verifie si la compilation a reussi
if %ERRORLEVEL% NEQ 0 (
    echo [ECHEC] Erreur de syntaxe ou fichier testbench introuvable.
    exit /b %ERRORLEVEL%
)

:: Simulation
echo Lancement de la simulation

cd simulation\sim_data
vvp %MODULE%.out

:: GTKwave
echo Ouverture GTKwave

set VCD_FOUND=0
for %%f in (*.vcd) do (
    gtkwave "%%f"
    set VCD_FOUND=1
)


cd ..\..