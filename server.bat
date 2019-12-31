@echo off

::设置内部变量
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot%\server.js

set xnssm=%mroot%\bin\nssm.exe

call :app_runtime


::外部调用模式
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" (
  call :app_%1
  goto :EOF
  exit
)


::独立控制台模式
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

title Webox.VMRun 服务控制台

echo.
:?
  cls && echo.
  set SPC=          -
  echo %SPC%----- Webox.VMRun 服务控制台 -----------------------------
  echo %SPC%-                                                       --
  echo %SPC%-    1.安装服务       2.重启服务       3.卸载服务       --
  echo %SPC%-                                                       --
  echo %SPC%----------------------- By Http://www.anrip.com ----------
  set Step=?
:??
  echo.
  set /p Step="请选择要执行的操作[1-3=>%Step%]: "
  if "%Step%"=="?" goto ?
  for /l %%i in (1,1,3) do (
    if "%Step%"=="%%i" (
      if %Step%==1 call :app_create
      if %Step%==2 call :app_reboot
      if %Step%==3 call :app_remove
      call :check_error
      echo. && echo 操作完毕,稍后返回菜单...
      ping 127.1 -n 3 >nul
      goto ?
    )
  )
  echo 未定义操作: %Step%
  goto ??

:check_error
  if %errorlevel% neq 0 (
    if "%1" == "" (
      echo. && echo 操作失败,按任意键返回主菜单...
      pause >nul && goto ?
    )
    echo %1
  )
  goto :EOF


::模块管理标准接口
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=Webox-VMRun
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo 错误: VMRun配置文件不存在...
    goto :EOF
  )
  echo. && echo 正在安装VMRun服务...
  %xnssm% install %scName% %mroot%\bin\node.exe
  %xnssm% set %scName% DisplayName "Webox VMRun Server" >nul
  %xnssm% set %scName% AppParameters %mconf% >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo 正在卸载VMRun服务...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo 正在启动VMRun服务...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo 正在停止VMRun服务...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo 正在重启VMRun服务...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo 正在检查VMRun进程...
  ping 127.0.0.1 -n 5 >nul
  tasklist | findstr node.exe >nul
  if %errorlevel% neq 0 (
    echo 错误: VMRun启动失败
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  call %mroot%\node.exe -p %mroot% -c %mconf% -t
  goto :EOF
