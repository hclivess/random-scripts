n::
Loop, 15
{
WinWait, Videos - YouTube - Google Chrome, 
IfWinNotActive, Videos - YouTube - Google Chrome, , WinActivate, Videos - YouTube - Google Chrome, 
WinWaitActive, Videos - YouTube - Google Chrome, 
MouseClick, left,  515,  241
Sleep, 100
MouseClick, left,  586,  236
Sleep, 100
MouseClick, left,  582,  475
Sleep, 100
MouseClick, left,  1281,  615
Sleep, 5500
MouseClick, left,  1304,  616
Sleep, 100
Send, {F5}
Sleep, 2500
}
