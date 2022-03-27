@echo off

copy resources\GHMattiMySQL\settings_dev.xml resources\GHMattiMySQL\settings.xml

%~dp0\..\FXServer\FXServer.exe ^
+set sv_enforceGameBuild 2545 ^
+exec config\server_dev.cfg ^
+exec config\assets.cfg ^
+set onesync on ^
+set onesync_enableInfinity 1 ^
+set onesync_enableBeyond 1 ^
+set svgui_disable 1