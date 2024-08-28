@echo off

set BUILD_TYPE=Debug
set MINGW_CXX_COMPILER_PATH=C:/msys64/mingw64/bin/x86_64-w64-mingw32-g++.exe
set MINGW_C_COMPILER_PATH=C:/msys64/mingw64/bin/x86_64-w64-mingw32-gcc.exe

mkdir build

cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=%BUILD_TYPE% -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_C_COMPILER:FILEPATH=%MINGW_C_COMPILER_PATH% -DCMAKE_CXX_COMPILER:FILEPATH=%MINGW_CXX_COMPILER_PATH% -S . -B ./build -G "MinGW Makefiles"

cd build

cmake --build . --config %BUILD_TYPE% --target all -j 32 --

if %errorlevel% equ 0 (
    echo Build successful. Running the executable...
    "%~dp0\build\application\application.exe"
) else (
    echo Build failed.
)