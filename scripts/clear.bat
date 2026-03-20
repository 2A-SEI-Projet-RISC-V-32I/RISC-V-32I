@echo off
echo NETTOYAGE DES FICHIERS DE SIMULATION

if exist "simulation\sim_data" (

    del /q "simulation\sim_data\*.vcd" 2>nul
    del /q "simulation\sim_data\*.out" 2>nul
)