;file loader start
$file = FileOpen("input.txt", 0)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open input.txt file.")
    Exit
EndIf

TCPStartup()

FileOpen ("output_closed.txt",2)
FileOpen ("output_open.txt",2)

While 1

Local $content_raw = FileReadLine ($file)
If @error = -1 Then ExitLoop

;file loader end


;parser start
$content = StringStripWS ($content_raw, 3)

$pos_port=StringInStr($content," ")
$pos_ip=StringLen($content)-$pos_port+1

$port=StringTrimLeft($content,$pos_port)
$ip=StringTrimRight($content,$pos_ip)

ConsoleWrite ($ip & @CRLF)
ConsoleWrite ($port & @CRLF)
;parser end

;port tester start

$testip = TCPConnect ($ip, $port)

ConsoleWrite ("status: " & $testip & @CRLF)

if $testip = -1 Then
	FileWrite ("output_closed.txt", $ip & " " & $port & @CRLF)
Else
	FileWrite ("output_open.txt", $ip & " " & $port & @CRLF)
EndIf

WEnd

FileClose ("output_closed.txt")
FileClose ("output_open.txt")
FileClose($file)

TCPShutdown()
;port tester end
