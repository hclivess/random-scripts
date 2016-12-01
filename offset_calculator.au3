#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>

GUICreate("Offset calculator", 300, 115, 100, 100)

$label_locations = GUICtrlCreateLabel("Locations:", 10, 10)
$label_frequency = GUICtrlCreateLabel("Frequency (m):", 10, 32)
$label_result = GUICtrlCreateLabel("Difference between runs (s):", 10, 62, 160)
$gui_locations = GUICtrlCreateInput("", 100, 10, 80)
$gui_frequency_minutes = GUICtrlCreateInput("", 100, 32, 80)
$gui_calculate = GUICtrlCreateButton("Calculate", 100, 80)
$gui_info = GUICtrlCreateList("1", 190, 10, 100, 100, BitOR($WS_BORDER, $WS_VSCROLL))

GUISetState(@SW_SHOW)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $gui_calculate
			;_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($gui_info))
			GUICtrlSetData($gui_info, "")
			GUICtrlSetData($gui_info, "1")

			$gui_locations_value = GUICtrlRead($gui_locations)
			$gui_frequency_minutes_value = GUICtrlRead($gui_frequency_minutes)
			$frequency_seconds_value = ($gui_frequency_minutes_value * 60)
			$result = Round($frequency_seconds_value / ($gui_locations_value + 1), 0)
			GUICtrlSetData($label_result, "Difference between runs (s): " & $result)

			$counter = 1
				While $counter < $gui_locations_value
					GUICtrlSetData($gui_info, ($result * $counter) + 1)
					$counter = $counter + 1
				WEnd


;### Tidy Error -> "endswitch" is closing previous "case" on line 20
		EndSwitch
;### Tidy Error -> "wend" is closing previous "switch" on line 19
	WEnd


;### Tidy Error -> while is never closed in your script.
