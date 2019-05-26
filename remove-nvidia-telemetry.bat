@echo off

set cwd=%cd%
set batchpath=%~dp0

:: set executable
set xmlstarlet_exe="%batchpath%\xmlstarlet-1.6.1\xml.exe"
for %%p in (%xmlstarlet_exe%) do (
    if not exist %%p (
        echo [91m[?] exe not found:[0m %%p
        pause
        goto :eof
    )
)

set dir=NvTelemetry
if exist "%cwd%\%dir%\" (
    echo [33m[removing dir][0m %dir%
    RMDIR /S /Q "%cwd%\%dir%" >NUL  2>NUL
)

set file=NvContainer\NvContainerTelemetryApi.nvi
if exist "%cwd%\%file%" (
    echo [33m[removing file][0m %file%
    DEL /Q /S "%cwd%\%file%" >NUL  2>NUL
)

set file=NvContainer\x86\NvContainerTelemetryApi.dll
if exist "%cwd%\%file%" (
    echo [33m[removing file][0m %file%
    DEL /Q /S "%cwd%\%file%" >NUL  2>NUL
)

set file=NvContainer\x86_64\NvContainerTelemetryApi.dll
if exist "%cwd%\%file%" (
    echo [33m[removing file][0m %file%
    DEL /Q /S "%cwd%\%file%" >NUL  2>NUL
)

set file=Update.Core\UpdateCore.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --delete "/nvi/manifest/file[starts-with(@name,'NvTm') and contains(@name,'.exe')]" "%cwd%\%file%"
    %xmlstarlet_exe% ed --inplace --delete "/nvi/phases/standard[@phase='copyx86BackendBinaries']/copyFile[starts-with(@target,'NvTm') and contains(@target,'.exe')]" "%cwd%\%file%"
    %xmlstarlet_exe% ed --inplace --delete "/nvi/phases/standard[starts-with(@phase,'scheduleNvTm') and scheduleTask[@action='create']]" "%cwd%\%file%"
)

set file=Display.Driver\DisplayDriver.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
    %xmlstarlet_exe% ed --inplace --update "//exe[contains(@condition,'Global:EnableTelemetry')]/arg[contains(@value,'-enableTelemetry:true')]" --value "-enableTelemetry:false" "%cwd%\%file%"
)

set file=DisplayDriverCrashAnalyzer\DisplayDriverCrashAnalyzer.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
)

set file=GFExperience.NvStreamSrv\GFExperience.NvStreamSrv.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
)

set file=nodejs\nodejs.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
)

set file=NvBackend\NvBackend.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
    %xmlstarlet_exe% ed --inplace --delete "/nvi/dependencies/package[@package='NvTelemetry']" "%cwd%\%file%"
)

set file=NvCamera\NvCamera.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cwd%\%file%"
)

set file=NvAbHub\NvAbHub.nvi
if exist "%cwd%\%file%" (
    echo [33m[updating file][0m %file%
    %xmlstarlet_exe% ed --inplace --delete "/nvi/dependencies/package[@package='NvTelemetry']" "%cwd%\%file%"
)

echo.
echo [32m[DONE][0m
echo.