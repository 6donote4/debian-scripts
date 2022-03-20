#!/bin/bash
$(pwd)/loadDisk.sh
$(pwd)/Btsync/btsync --config $(pwd)/Btsync/btsync.conf
exit 0
