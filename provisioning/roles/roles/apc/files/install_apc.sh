#!/bin/sh

expect -c "
spawn pecl install apc
expect \"Enable internal debugging in APC \[no\] :\"
send \"no\n\"
expect \"Enable per request file info about files used from the APC cache \[no\] :\"
send \"no\n\"
expect \"Enable spin locks (EXPERIMENTAL) \[no\] :\"
send \"no\n\"
expect \"Enable memory protection (EXPERIMENTAL) \[no\] :\"
send \"no\n\"
expect \"Enable pthread mutexes (default) \[no\] :\"
send \"yes\n\"
expect \"Enable pthread read/write locks (EXPERIMENTAL) \[yes\] :\"
send \"no\n\"
interact
"
exit

