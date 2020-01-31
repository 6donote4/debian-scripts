#A simple shell script - let's call it index-html.sh - to turn a list of file names into html links:
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#!/bin/bash

echo '<html><body>'
sed 's/^.*/<a href="&">&<\/a><br\/>/'
echo '</body></html>'
#Example use:
#ls | ../index-html.sh > index.html
