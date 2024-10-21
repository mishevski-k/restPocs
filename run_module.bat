@echo off
setlocal

:: Check if a module name is provided
if "%~1"=="" (
    echo Usage: %0 {nonrest|rest|evolution|links}
    exit /b 1
)

set MODULE=%~1
echo Module specified: %MODULE%

:: Define the allowed modules
set ALLOWED_MODULES=nonrest rest evolution links

:: Check if the provided module is valid
echo Validating module...
echo %ALLOWED_MODULES% | findstr /i "%MODULE%" >nul
if errorlevel 1 (
    echo Invalid module name. Allowed values are: %ALLOWED_MODULES%
    exit /b 1
)

:: Clean and build the specified module
echo Building module: %MODULE%...
call mvn clean install -pl %MODULE% -am

:: Check the exit code of the last command
if errorlevel 1 (
    echo Maven build failed for module: %MODULE%
    exit /b 1
)

:: Run the specified module
echo Starting module: %MODULE%...

:: Navigate to the module directory
cd %MODULE%
if errorlevel 1 (
    echo Failed to change directory to %MODULE%.
    exit /b 1
)

:: Use a wildcard to find the JAR file
for /f %%i in ('dir /b target\%MODULE%-*.jar') do set JAR_FILE=%%i

:: Check if the JAR file was found
if defined JAR_FILE (
    echo Found JAR file: %JAR_FILE%
    echo Running %JAR_FILE%...
    java -jar target\%JAR_FILE%
    if errorlevel 1 (
        echo Failed to run %JAR_FILE%.
        exit /b 1
    )
) else (
    echo No JAR file found for module %MODULE%.
    exit /b 1
)

endlocal