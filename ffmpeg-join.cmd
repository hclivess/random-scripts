(for %%i in (*.mp4) do @echo file '%%i') > mylist.txt
for %%* in (.) do set CurrDirName=%%~nx*
ffmpeg -f concat -safe 0 -i mylist.txt -c copy "%CurrDirName% - unabridged.mp4"
pause
