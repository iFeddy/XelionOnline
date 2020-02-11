start %~dp0\Account\"Account Release.exe"
start %~dp0\AccountLog\"AccountLog Release.exe"
start %~dp0\Character\"Character Release.exe"
start %~dp0\GameLog\"GameLog Release.exe"
start %~dp0\Login\3LoginServer2.exe
start %~dp0\WorldManager\WorldManager.exe
SC CREATE "_GamigoZR" binpath= "%~dp0GamigoZR\GamigoZR.exe"
start %~dp0\Zone00\5ZoneServer2.exe
start %~dp0\Zone01\5ZoneServer2.exe
start %~dp0\Zone02\5ZoneServer2.exe
start %~dp0\Zone03\5ZoneServer2.exe
start %~dp0\Zone04\5ZoneServer2.exe