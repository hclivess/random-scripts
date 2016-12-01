#SingleInstance

While true
{

~Break::
KeyWait, Break, D T3

InputBox, pwdinject, Global Password,, hide
if ErrorLevel or if pwdinject != myaccesscode
    {
    ExitApp
    }


else	
    

IfWinExist, Password 
{
    WinActivate
    Send, mypassword{ENTER}
}


return
}
