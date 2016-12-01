from pydub import AudioSegment
from pydub.silence import split_on_silence

sound = AudioSegment.from_file("mysong.mp3", format="mp3")
print "splitting"
chunks = split_on_silence(
    sound,

    # split on silences longer than 1000ms (1 sec)
    min_silence_len=500,

    # anything under -16 dBFS is considered silence
    silence_thresh=-48, 

    # keep 200 ms of leading/trailing silence
    keep_silence=200
)

# now recombine the chunks so that the parts are at least 90 sec long
#target_length = 90 * 1000
target_length = 900 * 1000

output_chunks = [chunks[0]]
print len(chunks)
for chunk in chunks[1:]:
    print "going through chunks and appending"
    if len(output_chunks[-1]) < target_length:
        output_chunks[-1] += chunk
    else:
        # if the last output chunk is longer than the target length,
        # we can start a new one     
        output_chunks.append(chunk)
        print "chunk finished"

# now your have chunks that are bigger than 90 seconds (except, possibly the last one)

for i, chunk in enumerate(output_chunks):
    output_chunk_name = "chunk{0}.mp3".format(i)
    print "exporting", output_chunk_name
    chunk.export(output_chunk_name, format="mp3")
