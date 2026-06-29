#!/usr/bin/env bash
cat > "$INPUT_FILE" <<EOF
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
alice:x:1001:1001:Alice Smith:/home/alice:/bin/${TARGET_SHELL}
bob:x:1002:1002:Bob Jones:/home/bob:/bin/bash
carol:x:1003:1003:Carol White:/home/carol:/bin/${TARGET_SHELL}
dave:x:1004:1004:Dave Brown:/home/dave:/bin/sh
eve:x:1005:1005:Eve Black:/home/eve:/bin/${TARGET_SHELL}
frank:x:1006:1006:Frank Green:/home/frank:/sbin/nologin
grace:x:1007:1007:Grace Lee:/home/grace:/bin/bash
EOF
rm -f "$OUTPUT_USERS" "$OUTPUT_NAMES"
