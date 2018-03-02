(for %%i in (*.mkv) do @echo file '%%i') > mylist.txt
ffmpeg -f concat -safe 0 -i mylist.txt -c copy output.mkv
