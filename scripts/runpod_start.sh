#!/bin/bash
source /scripts/common_functions.sh

echo "===== Starting Runpod Initialization ====="
date

start_nginx
setup_ssh
start_jupyter

echo "===== Runpod Initialization Complete ====="
date

if [ -n "$TOKEN" ]; then
    echo "Your Jupyter token is: $TOKEN"
    echo "Jupyter Server URL: http://${RUNPOD_PUBLIC_IP:-localhost}:8888/?token=$TOKEN"
else
    echo "WARNING: No Jupyter token available"
fi

echo "Runpod start script finished, pod is ready to use."

sleep infinity
