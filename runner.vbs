' Werten abfragen
teamsN = InputBox("Geben Sie den Wert für 'teamsN' ein:", "Parameter abfragen")
playersMin = InputBox("Geben Sie den Wert für 'playersMin' ein:", "Parameter abfragen")
playersMax = InputBox("Geben Sie den Wert für 'playersMax' ein:", "Parameter abfragen")

' Den Befehl erstellen
command = "cmd /k dart run bin/mathsolve.dart " & teamsN & " " & playersMin & " " & playersMax

' Befehl ausführen
Set shell = CreateObject("WScript.Shell")
shell.Run command
