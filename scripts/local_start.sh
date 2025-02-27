#!/bin/bash
source /scripts/common_functions.sh

echo "===== Starting Local Initialization ====="
date

# enable Jupyter in local mode
export LOCAL_JUPYTER_ENABLE="true"

start_nginx

if [[ $ENABLE_LOCAL_SSH ]]; then
    setup_ssh
fi

start_jupyter

echo "===== Local Initialization Complete ====="
date

if [ -n "$TOKEN" ]; then
    echo "Your Jupyter token is: $TOKEN"
    echo "Jupyter Server URL: http://localhost:8888/?token=$TOKEN"
else
    echo "WARNING: No Jupyter token available"
fi

echo "Local start script finished, environment is ready to use."

sleep infinity
