import os
import glob

files = (glob.glob("*.gif"))

for file in files:
    print(file)
    os.system(f"ffmpeg -f gif -i {file} {file.split('.')[-2]}.mp4")
