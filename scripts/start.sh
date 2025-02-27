#!/bin/bash
set -e

# detect which environment is being used
if [[ $RUNPOD_POD_ID ]]; then
    echo "Detected Runpod environment"
    exec /scripts/runpod_start.sh
else
    echo "Detected local environment"
    exec /scripts/local_start.sh
fi
