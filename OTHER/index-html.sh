#A simple shell script - let's call it index-html.sh - to turn a list of file names into html links:
#!/bin/sh

echo '<html><body>'
sed 's/^.*/<a href="&">&<\/a><br\/>/'
echo '</body></html>'
#Example use:
#ls | ../index-html.sh > index.html