@echo off
setlocal enabledelayedexpansion

echo --- Minimal Scilab-C Gateway Build and Run ---

:: --- Configuration ---
:: Adjust these paths if your Scilab/MinGW installations differ
set SCILAB_ROOT=C:\Program Files\scilab-2024.0.0
set MINGW_PATH=C:\msys64\mingw64\bin
:: Adjust SCILAB_VERSION if needed, used for output info only here
set SCILAB_VERSION=2024.0.0

:: --- Environment Setup ---
echo Setting up PATH...
set PATH=%MINGW_PATH%;%PATH%
echo Checking for compiler...
where gcc > nul 2>&1
if errorlevel 1 (
    echo ERROR: gcc not found in PATH. Ensure MinGW path is correct: %MINGW_PATH%
    goto :eof
)
echo Checking for Scilab...
if not exist "%SCILAB_ROOT%\bin\WScilex-cli.exe" (
   echo ERROR: Scilab CLI not found. Ensure Scilab path is correct: %SCILAB_ROOT%
   goto :eof
)

:: --- Build Paths ---
set SOURCE_DIR=%~dp0src
set INCLUDE_DIR=%~dp0includes
set OUTPUT_DLL=%~dp0minimal_toolbox.dll

:: --- Compiler/Linker Flags ---
echo Setting compiler/linker flags...
:: Include paths: Scilab internal headers, local dummy headers, local C source headers
set INCLUDES=-I"%SCILAB_ROOT%\modules\api_scilab\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\core\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\output_stream\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\ast"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\types"
set INCLUDES=%INCLUDES% -I"%INCLUDE_DIR%"
set INCLUDES=%INCLUDES% -I"%SOURCE_DIR%"

:: Compiler flags
set CFLAGS_COMMON=-Wall -Wextra -O2 -fpermissive -fcommon
set CFLAGS_C=-c %CFLAGS_COMMON%
set CFLAGS_CPP=-c %CFLAGS_COMMON%

:: Library paths and libraries needed for linking
set LDFLAGS=-L"%SCILAB_ROOT%\bin"
set LDFLAGS=%LDFLAGS% -lapi_scilab -lcore -loutput_stream -last

:: --- Cleaning Old Artifacts ---
echo Cleaning previous build artifacts...
del /F /Q "%SOURCE_DIR%\*.o" "%OUTPUT_DLL%" > nul 2>&1

:: --- Compilation ---
echo Compiling C library (minimal_lib.c)...
gcc %CFLAGS_C% %INCLUDES% "%SOURCE_DIR%\minimal_lib.c" -o "%SOURCE_DIR%\minimal_lib.o"
if errorlevel 1 (
    echo ERROR: Failed to compile minimal_lib.c
    goto :eof
)

echo Compiling C++ gateway (minimal_gateway.cpp)...
g++ %CFLAGS_CPP% %INCLUDES% "%SOURCE_DIR%\minimal_gateway.cpp" -o "%SOURCE_DIR%\minimal_gateway.o"
if errorlevel 1 (
    echo ERROR: Failed to compile minimal_gateway.cpp
    goto :eof
)

:: --- Linking ---
echo Linking DLL (%OUTPUT_DLL%)...
g++ -shared -o "%OUTPUT_DLL%" "%SOURCE_DIR%\minimal_lib.o" "%SOURCE_DIR%\minimal_gateway.o" %LDFLAGS% -Wl,--subsystem,windows
if errorlevel 1 (
    echo ERROR: Failed to link %OUTPUT_DLL%
    goto :eof
)

echo BUILD SUCCESSFUL: %OUTPUT_DLL% created.

:: Running Scilab Test ---
echo Running Scilab script (scilab_scripts\run_example.sce)...
:: Replace -nwni with -cli
"%SCILAB_ROOT%\bin\WScilex-cli.exe" -cli -f "%~dp0scilab_scripts\run_example.sce" -quit
if errorlevel 1 (
    echo ERROR: Scilab script execution failed.
    goto :eof
)

echo --- Script Finished ---

endlocal
goto :eof

:error_exit
echo An error occurred. Exiting.
endlocal
exit /b 1