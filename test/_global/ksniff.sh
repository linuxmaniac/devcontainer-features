#!/bin/bash

set -e
source dev-container-features-test-lib
check "ksniff" /bin/bash -c "kubectl sniff 2>&1| grep -q 'Error: not enough arguments'"

reportResults