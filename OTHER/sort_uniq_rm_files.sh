#!/bin/bash
# search duplicated files
find . -maxdepth 9 -iname '*.sh' -print0|xargs -0 -I[] md5sum -b [] > md5.report
cat md5.report |sort|awk '{print $1}'|uniq -c|grep -v 1 | awk '{print $2}' > rm.report
cat md5.report |sort|grep -f rm.report | awk -F* '{print $2}'
#rm md5.report rm.report
exit 0
