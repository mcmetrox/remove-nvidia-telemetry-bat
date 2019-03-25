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
echo [33m[removing dir][0m %dir%
RMDIR /S /Q "%cd%\%dir%" >NUL  2>NUL

set file=NvContainer\NvContainerTelemetryApi.nvi
echo [33m[removing file][0m %file%
DEL /Q /S "%cd%\%file%" >NUL  2>NUL

set file=NvContainer\x86\NvContainerTelemetryApi.dll
echo [33m[removing file][0m %file%
DEL /Q /S "%cd%\%file%" >NUL  2>NUL

set file=NvContainer\x86_64\NvContainerTelemetryApi.dll
echo [33m[removing file][0m %file%
DEL /Q /S "%cd%\%file%" >NUL  2>NUL

set file=Update.Core\UpdateCore.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --delete "/nvi/manifest/file[starts-with(@name,'NvTm') and contains(@name,'.exe')]" "%cd%\%file%"

%xmlstarlet_exe% ed --inplace --delete "/nvi/phases/standard[@phase='copyx86BackendBinaries']/copyFile[starts-with(@target,'NvTm') and contains(@target,'.exe')]" "%cd%\%file%"

%xmlstarlet_exe% ed --inplace --delete "/nvi/phases/standard[starts-with(@phase,'scheduleNvTm') and scheduleTask[@action='create']]" "%cd%\%file%"

set file=Display.Driver\DisplayDriver.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

%xmlstarlet_exe% ed --inplace --update "//exe[contains(@condition,'Global:EnableTelemetry')]/arg[contains(@value,'-enableTelemetry:true')]" --value "-enableTelemetry:false" "%cd%\%file%"

set file=DisplayDriverCrashAnalyzer\DisplayDriverCrashAnalyzer.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

set file=GFExperience.NvStreamSrv\GFExperience.NvStreamSrv.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

set file=nodejs\nodejs.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

set file=NvBackend\NvBackend.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

%xmlstarlet_exe% ed --inplace --delete "/nvi/dependencies/package[@package='NvTelemetry']" "%cd%\%file%"

set file=NvCamera\NvCamera.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --update "/nvi/properties/bool[@name='UsesNvTelemetry']/@value" --value "false" "%cd%\%file%"

set file=NvAbHub\NvAbHub.nvi
echo [33m[updating file][0m %file%
%xmlstarlet_exe% ed --inplace --delete "/nvi/dependencies/package[@package='NvTelemetry']" "%cd%\%file%"

echo.
echo [32m[DONE][0m
echo.