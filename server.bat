@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot%\server.js

set xnssm=%mroot%\bin\nssm.exe

call :app_runtime


::�ⲿ����ģʽ
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" (
  call :app_%1
  goto :EOF
  exit
)


::��������̨ģʽ
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

title Webox.VMRun �������̨

echo.
:?
  cls && echo.
  set SPC=          -
  echo %SPC%----- Webox.VMRun �������̨ -----------------------------
  echo %SPC%-                                                       --
  echo %SPC%-    1.��װ����       2.��������       3.ж�ط���       --
  echo %SPC%-                                                       --
  echo %SPC%----------------------- By Http://www.anrip.com ----------
  set Step=?
:??
  echo.
  set /p Step="��ѡ��Ҫִ�еĲ���[1-3=>%Step%]: "
  if "%Step%"=="?" goto ?
  for /l %%i in (1,1,3) do (
    if "%Step%"=="%%i" (
      if %Step%==1 call :app_create
      if %Step%==2 call :app_reboot
      if %Step%==3 call :app_remove
      call :check_error
      echo. && echo �������,�Ժ󷵻ز˵�...
      ping 127.1 -n 3 >nul
      goto ?
    )
  )
  echo δ�������: %Step%
  goto ??

:check_error
  if %errorlevel% neq 0 (
    if "%1" == "" (
      echo. && echo ����ʧ��,��������������˵�...
      pause >nul && goto ?
    )
    echo %1
  )
  goto :EOF


::ģ������׼�ӿ�
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=Webox-VMRun
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: VMRun�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װVMRun����...
  %xnssm% install %scName% %mroot%\bin\node.exe
  %xnssm% set %scName% DisplayName "Webox VMRun Server" >nul
  %xnssm% set %scName% AppParameters %mconf% >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��VMRun����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������VMRun����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣVMRun����...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo ��������VMRun����...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��VMRun����...
  ping 127.0.0.1 -n 5 >nul
  tasklist | findstr node.exe >nul
  if %errorlevel% neq 0 (
    echo ����: VMRun����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  call %mroot%\node.exe -p %mroot% -c %mconf% -t
  goto :EOF
