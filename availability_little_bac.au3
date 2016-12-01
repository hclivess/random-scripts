#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>

Local $query, $row
Local $gui_name, $gui_ip, $item2, $gui_customer, $gui_port, $gui_status, $gui_enabled, $gui_id

GUICreate("lilbac", 1200, 600, 100, 100)

;lines
$line1 = GUICtrlCreateLabel ("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------", 10,390)
;

;
$gui_server_id = GUICtrlCreateLabel ("Server ID:", 10, 320, 60, 20)
$gui_server_id_input = GUICtrlCreateInput ("", 65, 320, 60, 20)
$gui_delete = GUICtrlCreateButton ("Delete", 130, 320, 50, 20)
;

$gui_insert_name = GUICtrlCreateInput ("", 60, 410, 300)
$gui_insert_customer = GUICtrlCreateInput ("", 60, 430, 300, 20)
$gui_insert_ip = GUICtrlCreateInput ("", 60, 450, 300, 20)
$gui_insert_port = GUICtrlCreateInput ("", 60, 470, 300, 20)
$gui_label_name = GUICtrlCreateLabel ("Name", 10,410)
$gui_label_customer = GUICtrlCreateLabel ("Customer", 10,430)
$gui_label_ip = GUICtrlCreateLabel ("IP", 10,450)
$gui_label_port = GUICtrlCreateLabel ("Port", 10,470)
$gui_add = GUICtrlCreateButton ("Add new server", 10,500)


$reports_gui_server_id_input = GUICtrlCreateLabel ("Enter server ID:", 610, 320, 50, 25)
$reports_gui_server_id = GUICtrlCreateInput ("", 700, 320, 150, 25)
$reports_gui_samples = GUICtrlCreateLabel ("Samples:", 610, 270, 100)
$reports_gui_availability = GUICtrlCreateLabel ("Total Availability: not yet implemented", 610, 290, 100)
$reports_gui_listview = GUICtrlCreateListView("ID|timestamp|time intervals|change", 610, 10, 580, 250)
$reports_gui_start = GUICtrlCreateButton ("Fetch", 960, 320, 50, 25)

$gui_listview = GUICtrlCreateListView("ID|name|customer|IP|PORT|currently|enabled", 10, 10, 580, 250)

$gui_start = GUICtrlCreateButton ("Update", 10, 270)

GUISetState(@SW_SHOW)


While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit

Case $reports_gui_start

 GuiCtrlDelete ($reports_gui_listview)
 $reports_gui_listview = GUICtrlCreateListView("ID|timestamp|time intervals|change", 610, 10, 580, 250,$LVS_EX_FULLROWSELECT)
 $reports_gui_server_id_value = GUICtrlRead ($reports_gui_server_id)
Local $count_timestamp
Local $count_timestamp_fetched

_SQLite_Startup()
_SQLite_Open(@ScriptDir & "\sqlite.db")

_SQLite_Query(-1, "SELECT COUNT (*) FROM calendar", $count_timestamp)
While _SQLite_FetchData($count_timestamp, $count_timestamp_fetched) = $SQLITE_OK
$cal_count = $count_timestamp_fetched[0]
GUICtrlSetData ($reports_gui_samples, "Samples: " & $cal_count)
WEnd



_SQLite_Query(-1, "SELECT ROWID, * FROM '" & $reports_gui_server_id_value & "' ORDER BY ROWID;", $query) ;main
_SQLite_FetchNames($query, $row)
While _SQLite_FetchData($query, $row) = $SQLITE_OK
$reports_gui_id = GUICtrlCreateListViewItem("", $reports_gui_listview)



Local $year = StringMid ($row[1], 1, 4)
Local $month = StringMid ($row[1], 5, 2)
Local $day = StringMid ($row[1], 7, 2)
Local $hour = StringMid ($row[1], 9, 2)
Local $min = StringMid ($row[1], 11, 2)
Local $sec = StringMid ($row[1], 13, 2)

GUICtrlSetData ($reports_gui_id, $row[0] & "|" & $row[1] & "|" & $day & "/" & $month & "/" & $year & " " & $hour & ":" & $min & ":" & $sec & "|"& $row[2])

_GUICtrlListView_SetColumnWidth ($reports_gui_listview,0,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($reports_gui_listview,1,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($reports_gui_listview,2,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($reports_gui_listview,3,$LVSCW_AUTOSIZE)


WEnd

_SQLite_QueryFinalize($query)
_SQLite_Close()
_SQLite_Shutdown()












		Case $gui_server_id_input
			 $gui_server_id_value = GUICtrlRead ($gui_server_id_input)
			 _SQLite_Startup()
			 _SQLite_Open(@ScriptDir & "\sqlite.db")
			 _SQLite_Exec(-1, "DELETE FROM customer1 WHERE ROWID='" & $gui_server_id_value & "';")
			 _SQLite_Exec(-1, "DROP TABLE IF EXISTS '" & $gui_server_id_value & "';")
			 _SQLite_Close()
			 _SQLite_Shutdown()
		Case $gui_add

			$gui_insert_name_value = GUICtrlRead ($gui_insert_name)
			$gui_insert_customer_value = GUICtrlRead ($gui_insert_customer)
			$gui_insert_ip_value = GUICtrlRead ($gui_insert_ip)
			$gui_insert_port_value = GUICtrlRead ($gui_insert_port)

			_SQLite_Startup()

				_SQLite_Open(@ScriptDir & "\sqlite.db")
				_SQLite_Exec(-1, "CREATE TABLE IF NOT EXISTS customer1 (name,category,ip,port,status,enabled);")

			_SQLite_Exec(-1, "INSERT INTO customer1 (name,category,ip,port,status,enabled) VALUES ('"& $gui_insert_name_value &"','"& $gui_insert_customer_value &"','"& $gui_insert_ip_value &"','"& $gui_insert_port_value &"','N/A','1');")

			_SQLite_Close()
			_SQLite_Shutdown()

		Case $gui_start

;
$gui_kernel_status = GUICtrlCreateLabel ("Kernel status:", 130, 280, 200, 20)
If ProcessExists ( "lilbac_kernel.exe" ) Then
GUICtrlSetData ($gui_kernel_status, "Kernel status: RUNNING")
Else
GUICtrlSetData ($gui_kernel_status, "Kernel status: NOT RUNNING")
EndIf
;


 GuiCtrlDelete ($gui_listview)
 $gui_listview = GUICtrlCreateListView("ID|name|customer|IP|PORT|currently|enabled", 10, 10, 580, 250,$LVS_EX_FULLROWSELECT)

_SQLite_Startup()
_SQLite_Open(@ScriptDir & "\sqlite.db")

_SQLite_Query(-1, "SELECT ROWID, * FROM customer1 ORDER BY ROWID;", $query)
_SQLite_FetchNames($query, $row)

ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s", $row[0]) & @CRLF)
While _SQLite_FetchData($query, $row) = $SQLITE_OK
ConsoleWrite(StringFormat(" %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s" , $row[0], $row[1], $row[2], $row[3], $row[4], $row[5], $row[6]) & @CRLF)

$gui_id = GUICtrlCreateListViewItem("", $gui_listview)
GUICtrlSetData ($gui_id, $row[0] & "|" & $row[1] & "|" & $row[2] & "|" & $row[3] & "|" & $row[4] & "|" & $row[5] & "|" & $row[6])

_GUICtrlListView_SetColumnWidth ($gui_listview,0,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($gui_listview,1,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($gui_listview,2,$LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($gui_listview,3,$LVSCW_AUTOSIZE)
WEnd

_SQLite_QueryFinalize($query)
_SQLite_Close()
_SQLite_Shutdown()

Sleep (1000)



EndSwitch
WEnd
