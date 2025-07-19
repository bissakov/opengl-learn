@echo off
setlocal enabledelayedexpansion

call vcvarsall.bat x64 > nul 2>&1

set CWD=%cd%
set SRC=%CWD%\src
set TESTS=%CWD%\tests
set LIB_DIR=%CWD%\lib
set INCLUDE_DIR=%CWD%\include
set DEBUG_DIR=%CWD%\build\debug
set RELEASE_DIR=%CWD%\build\release

set EXE=opengl_learn.exe

set SOURCES=%SRC%\main.cpp %SRC%\glad.c
set INCLUDES=/I%INCLUDE_DIR% /I%INCLUDE_DIR%\GLFW /I%INCLUDE_DIR%\glad /I%INCLUDE_DIR%\KHR
set FLAGS=/std:c++17 /nologo /W4 /WX /wd4100 /DUNICODE /DWIN32 /Oid /GR- /EHs /MT /MP /Gm- /FC /Zi %INCLUDES% %SOURCES%
set LIBS=%LIB_DIR%\glfw3_mt.lib opengl32.lib user32.lib gdi32.lib shell32.lib 

>compile_flags.txt (
  for %%F in (%FLAGS%) do echo %%F
)

mkdir %DEBUG_DIR% > nul 2>&1
mkdir %RELEASE_DIR% > nul 2>&1
pushd %DEBUG_DIR%

del /q "%DEBUG_DIR%\*.*"
for /d %%D in ("%DEBUG_DIR%\*") do rd /s /q "%%D"

cl -Fe: %EXE% %FLAGS% -Fm: opengl_learn.map %LIBS% /link -opt:ref

if errorlevel 1 del %EXE% && echo Build failed...

popd
endlocal
echo:
