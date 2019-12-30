@ECHO OFF

CD /D %~dp0

SET "PATH=bin;%PATH%"

CMD /k node server.js
