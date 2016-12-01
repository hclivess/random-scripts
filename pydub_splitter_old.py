from pydub import AudioSegment
#from pydub.utils import mediainfo
from pydub.utils import make_chunks
import math

#lac_audio = AudioSegment.from_file("Kalimba.mp3", "mp3")
#flac_audio.export("audio.mp3", format="mp3")
myaudio = AudioSegment.from_file("Kalimba.mp3" , "mp3")
channel_count = myaudio.channels    #Get channels
sample_width = myaudio.sample_width #Get sample width
duration_in_sec = len(myaudio) / 1000#Length of audio in sec
sample_rate = myaudio.frame_rate

print "sample_width=", sample_width 
print "channel_count=", channel_count
print "duration_in_sec=", duration_in_sec 
print "frame_rate=", sample_rate
bit_rate =16  #assumption , you can extract from mediainfo("test.wav") dynamically


wav_file_size = (sample_rate * bit_rate * channel_count * duration_in_sec) / 8
print "wav_file_size = ",wav_file_size


file_split_size = 10000000  # 10Mb OR 10, 000, 000 bytes
total_chunks =  wav_file_size // file_split_size

#Get chunk size by following method #There are more than one ofcourse
#for  duration_in_sec (X) --&gt;  wav_file_size (Y)
#So   whats duration in sec  (K) --&gt; for file size of 10Mb
#  K = X * 10Mb / Y

chunk_length_in_sec = math.ceil((duration_in_sec * 10000000 ) /wav_file_size)   #in sec
chunk_length_ms = chunk_length_in_sec * 1000
chunks = make_chunks(myaudio, chunk_length_ms)

#Export all of the individual chunks as wav files

for i, chunk in enumerate(chunks):
    chunk_name = "chunk{0}.mp3".format(i)
    print "exporting", chunk_name
    chunk.export(chunk_name, format="mp3")
