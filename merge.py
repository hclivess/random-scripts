import glob
merger = open("merged.txt", 'w')
filenames = glob.glob("*.ini")
for fname in filenames:
    with open(fname) as infile:
        for line in infile:
                    merger.write(str(line))
merger.close()

lines_file = open('merged.txt', 'r')
lines = lines_file.readlines()
lines_set = set(lines)
out  = open('merged.txt', 'w')
for line in lines_set:
    out.write(line)
lines_file.close()
