import re
import requests

# set header
hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}
# set header

request = requests.get("https://en.wiktionary.org/wiki/Special:Random", headers=hdr)
geturl_readable = request.text
word = re.findall('\<title\>(.*) \-', geturl_readable)
word = word[0].encode("utf-8")
link = re.findall ('\"canonical\" href\=\"(.*)', geturl_readable)
link = link[0].encode("utf-8")

print link.decode("utf-8")
print word.decode("utf-8").title()
