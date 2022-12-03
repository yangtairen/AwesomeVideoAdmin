@echo off

:jpsap
title VID����Ӧ�÷���

:: ����������⵽��·��
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

:: �����⵽�����˳�����ͣ5��������
ping -n 5 127.0.0.1 >nul
cls

goto jpsap