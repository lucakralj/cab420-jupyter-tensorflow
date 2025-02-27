#!/bin/bash
set -e

start_nginx() {
    echo "DEBUG: Starting Nginx service..."
    service nginx start
    echo "DEBUG: Nginx status:"
    service nginx status || true
}

execute_script() {
    local script_path=$1
    local script_msg=$2
    if [[ -f ${script_path} ]]; then
        echo "DEBUG: ${script_msg}"
        echo "DEBUG: Script contents:"
        head -n 5 ${script_path} || true
        bash -x ${script_path}  # debug mode for script execution
    else
        echo "DEBUG: Script not found: ${script_path}"
    fi
}

setup_ssh() {
    if [[ $PUBLIC_KEY ]]; then
        echo "DEBUG: Setting up SSH..."
        mkdir -p ~/.ssh
        echo "$PUBLIC_KEY" >> ~/.ssh/authorized_keys
        chmod 700 -R ~/.ssh

        echo "DEBUG: SSH authorized keys:"
        cat ~/.ssh/authorized_keys || true

        for key_type in rsa dsa ecdsa ed25519; do
            key_path="/etc/ssh/ssh_host_${key_type}_key"
            if [ ! -f ${key_path} ]; then
                echo "DEBUG: Generating ${key_type} host key..."
                ssh-keygen -t ${key_type} -f ${key_path} -q -N ''
            fi
            echo "DEBUG: ${key_type} key fingerprint:"
            ssh-keygen -lf ${key_path}.pub || true
        done

        service ssh start
        echo "DEBUG: SSH service status:"
        service ssh status || true
    else
        echo "DEBUG: No PUBLIC_KEY found, skipping SSH setup"
    fi
}

start_jupyter() {
    # always start in local mode if not on Runpod
    if [[ $RUNPOD_POD_ID ]] || [[ $LOCAL_JUPYTER_ENABLE == "true" ]]; then
        echo "DEBUG: Starting Jupyter Lab..."
        
        # for local install, generate token if not specified
        if [[ -z $JUPYTER_PASSWORD && -z $RUNPOD_POD_ID ]]; then
            echo "DEBUG: Generating random Jupyter token for local instance..."
            JUPYTER_PASSWORD=$(openssl rand -hex 21)
            export JUPYTER_PASSWORD
        fi

        local jupyter_token=${JUPYTER_PASSWORD:-""}
        local jupyter_ip=${RUNPOD_PUBLIC_IP:-'0.0.0.0'}
	
        nohup jupyter lab --allow-root \
            --no-browser \
            --port=8888 \
            --ip="$jupyter_ip" \
            --FileContentsManager.delete_to_trash=False \
            --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
            --ServerApp.token="$jupyter_token" \
            --ServerApp.allow_origin=* \
            --ServerApp.preferred_dir=/workspace &> /jupyter.log &
        
        echo "DEBUG: Jupyter Lab starting in background"
        echo "DEBUG: Jupyter log file contents:"
        tail -f /jupyter.log &
        
        # wait for server to start and get token
        local max_retries=5
        local wait_time=5
        for ((i=1; i<=max_retries; i++)); do
            echo "DEBUG: Checking Jupyter server status (attempt $i/$max_retries)..."
            TOKEN=$(jupyter server list 2>&1 | grep -oP '(?<=token=)[^ ]+' || true)
            
            if [ -n "$TOKEN" ]; then
                echo "DEBUG: Jupyter server detected"
                break
            fi
            
            sleep $wait_time
        done

        if [ -z "$TOKEN" ]; then
            echo "WARNING: Failed to retrieve Jupyter token after $max_retries attempts"
            echo "DEBUG: Jupyter server list output:"
            jupyter server list || true
        fi
    else
        echo "DEBUG: Jupyter startup disabled for local environment"
    fi
}
