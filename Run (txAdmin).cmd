@echo off

copy resources\GHMattiMySQL\settings_default.xml resources\GHMattiMySQL\settings.xml

%~dp0\..\FXServer\FXServer.exe +set serverProfile 2.0 +set txAdminPort 30130