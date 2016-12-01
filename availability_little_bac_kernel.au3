#include <SQLite.au3>
#include <SQLite.dll.au3>


Local $query, $row, $changed, $error, $hQuery, $aRow, $sMsg, $tcp_status, $timestamp

While 1
	_SQLite_Startup()
	_SQLite_Open(@ScriptDir & "\sqlite.db")


	_SQLite_Query(-1, "SELECT ROWID, * FROM customer1 ORDER BY ROWID;", $query)
	_SQLite_FetchNames($query, $row)

	ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s", $row[0]) & @CRLF)

	Local $i = 0
	While _SQLite_FetchData($query, $row) = $SQLITE_OK
		ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s", $row[0], $row[1], $row[2], $row[3], $row[4], $row[5], $row[6]) & @CRLF)

		$i = $i + 1

		$ip = $row[3]
		$port = $row[4]
		$status = $row[5]
		$enabled = $row[6]
		$timestamp = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC

		;MsgBox (0,0,$timestamp)

		TCPStartup()
		$testip = TCPConnect($ip, $port)
		TCPShutdown()

		ConsoleWrite("status: " & $testip & @CRLF)

		If $testip = -1 Then
			$tcp_status_i = "ERROR"
		Else
			$tcp_status_i = "OK"
		EndIf
		;

		If $tcp_status_i = $status Then
			;MsgBox (0,0,"not changed")
		ElseIf $tcp_status_i <> $status And $tcp_status_i = "ERROR" Then
			_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS '" & $i & "' (timestamp,status,enabled);")
			_SQLite_Exec(-1, "UPDATE customer1 SET status='ERROR' where ROWID=" & $i & ";")
			_SQLite_Exec(-1, "INSERT INTO '" & $i & "' (timestamp,status,enabled) VALUES ('" & $timestamp & "','" & $tcp_status_i & "','" & $enabled & "');")
		ElseIf $tcp_status_i <> $status And $tcp_status_i = "OK" Then
			_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS '" & $i & "' (timestamp,status,enabled);")
			_SQLite_Exec(-1, "UPDATE customer1 SET status='OK' where ROWID=" & $i & ";")
			_SQLite_Exec(-1, "INSERT INTO '" & $i & "' (timestamp,status,enabled) VALUES ('" & $timestamp & "','" & $tcp_status_i & "','" & $enabled & "');")
		EndIf



		;


	WEnd

	;calendar
	_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS calendar (timestamp);")
	_SQLite_Exec(-1, "INSERT INTO calendar (timestamp) VALUES ('" & $timestamp & "');")
	;


	_SQLite_QueryFinalize($query)
	_SQLite_Close()
	_SQLite_Shutdown()

	Sleep(1000)
WEnd
