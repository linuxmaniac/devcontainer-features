#!/bin/bash

set -e
source dev-container-features-test-lib
check "talos with specific version" /bin/bash -c "talosctl version --client | grep 'v1.4.7'"

reportResults