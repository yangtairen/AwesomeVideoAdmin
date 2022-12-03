@echo off

:jpsap
title VID基础应用服务

:: 引入依赖类库到类路径
set CLASSPATH=.
FOR %%F IN (*.jar) DO call :updateClassPath %%F
goto :startjava
:updateClassPath
set CLASSPATH=%CLASSPATH%;%1

FOR %%F IN (lib/*.jar) DO call :updateClassPath %%F
goto :startjava
:updateClassPath
set CLASSPATH=%CLASSPATH%;lib/%1
goto :eof

:startjava

java -Xmn256m -Xms1024m -Xmx1024m -classpath %CLASSPATH% com.moli.moli.app.MoliApplication

:: 如果检测到进程退出，暂停5秒再重启
ping -n 5 127.0.0.1 >nul
cls

goto jpsap