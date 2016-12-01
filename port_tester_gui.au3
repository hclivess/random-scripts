#include <GUIConstantsEx.au3>
#include <ListboxConstants.au3>
Opt("TCPTimeout", 100) ;100 milliseconds
Local $count_closed
Local $count_open

GUICreate("Popelka", 700, 500, 100, 100)
$gui_list_open = GuiCtrlCreateList("", 100, 0, 550, 250)
$gui_list_closed = GuiCtrlCreateList("", 100, 240, 550, 250)
$gui_start = GUICtrlCreateButton ("Start testing", 0, 0, 100, 50)
$gui_input = GUICtrlCreateButton ("Open input file", 0, 80, 100, 50)
$gui_open = GUICtrlCreateButton ("OK log", 0, 130, 100, 50)
$gui_closed = GUICtrlCreateButton ("Error log", 0, 180, 100, 50)
$gui_exit = GUICtrlCreateButton ("Exit", 0, 430, 100, 50)
$gui_about = GUICtrlCreateButton ("About", 0, 480, 100, 20)
$gui_status = GUICtrlCreateLabel ("Status: standby...",110,482,200,30)
$gui_count_open = GUICtrlCreateLabel ("Open:" & $count_open, 655, 100, 50, 50)
$gui_count_closed = GUICtrlCreateLabel ("Closed:" & $count_closed, 655, 350, 50 ,50)
GUISetState(@SW_SHOW)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $gui_open
			ShellExecute("output_open.txt", "", @ScriptDir, "open")
		Case $gui_closed
			ShellExecute("output_closed.txt", "", @ScriptDir, "open")
		Case $gui_exit
			Exit
		Case $gui_input
			ShellExecute("input.txt", "", @ScriptDir, "open")
		Case $gui_about
			MsgBox(0,"about","Made by Jesus Industries. One Jesus, one thread." & @CRLF & "© 2012 v.1.0")
		Case $gui_start ;the whole script
			GUICtrlSetData ($gui_status, "Status: busy...")
			GUICtrlSetData ($gui_list_closed, "") ;empty
			GUICtrlSetData ($gui_list_open, "") ;empty
			GUICtrlSetState ($gui_start, $GUI_DISABLE)
			GUICtrlSetState ($gui_input, $GUI_DISABLE)
			GUICtrlSetState ($gui_open, $GUI_DISABLE)
			GUICtrlSetState ($gui_closed, $GUI_DISABLE)

;file loader start
$file = FileOpen("input.txt", 0)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open input.txt file.")
    Exit
EndIf

TCPStartup()

FileOpen ("output_closed.txt",2)
FileOpen ("output_open.txt",2)

Local $line = 1
$count_closed = 0
$count_open = 0

While 1

$linesize = Stringlen ($line)
If $linesize = 1 Then
	$line = "000" & $line
ElseIf $linesize = 2 Then
	$line = "00" & $line
ElseIf $linesize = 3 Then
	$line = "0" & $line
	EndIf

Local $content_raw = FileReadLine ($file)
If @error = -1 Then ExitLoop
;file loader end


;parser start
$content = StringStripWS ($content_raw, 3) ; trim all lines.

$pos_port=StringInStr($content," ")
$pos_ip=StringLen($content)-$pos_port+1

$port=StringTrimLeft($content,$pos_port)
$ip=StringTrimRight($content,$pos_ip)

ConsoleWrite ($ip & @CRLF)
ConsoleWrite ($port & @CRLF)


;parser end

;port tester start

Local $begin = TimerInit()
$testip = TCPConnect ($ip, $port)
Local $dif = TimerDiff($begin)
$dif = $dif/1000
$dif = Round ($dif, 2)
If $dif < 5 Then
	$cause = "Probable cause: service not running."
ElseIf $dif >= 5 Then
	$cause = "Probable cause: firewall not opened."
EndIf


ConsoleWrite ("status: " & $testip & @CRLF)

if $testip = -1 Then
	FileWrite ("output_closed.txt", $ip & " " & $port & @CRLF)
	GUICtrlSetData ($gui_list_closed, "Line " & $line & ": IP: '" & $ip & "' Port: '" & $port & "' --- ERROR --- in " & $dif & " seconds. " & $cause)
	$count_closed = $count_closed + 1
	GUICtrlSetData ($gui_count_closed, "Closed:" & @CRLF & $count_closed)

Else
	FileWrite ("output_open.txt", $ip & " " & $port & @CRLF)
	GUICtrlSetData ($gui_list_open, "Line " & $line & ": IP: '" & $ip & "' Port: '" & $port &"' --- OK --- in " & $dif & " seconds. ")
	$count_open = $count_open + 1
	GUICtrlSetData ($gui_count_open, "Open:" & @CRLF & $count_open)

EndIf

$line = $line + 1
WEnd

FileClose ("output_closed.txt")
FileClose ("output_open.txt")
FileClose($file)

TCPShutdown()

GUICtrlSetState ($gui_start, $GUI_ENABLE)
GUICtrlSetState ($gui_input, $GUI_ENABLE)
GUICtrlSetState ($gui_open, $GUI_ENABLE)
GUICtrlSetState ($gui_closed, $GUI_ENABLE)

GUICtrlSetData ($gui_status, "Status: standby... Lines tested: " & $line - 1)
EndSwitch
WEnd


;port tester end
