#!/usr/bin/env bash
set -e

echo "Starting container..."

# Start SSH server if authorized_keys exists
if [ -f /root/.ssh/authorized_keys ]; then
    echo "SSH key found, starting SSH server..."
    
    # Generate host keys if they don't exist
    if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" -q
    fi
    if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
        ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" -q
    fi
    
    # Start SSH daemon
    /usr/sbin/sshd -D &
    SSH_PID=$!
    echo "SSH server started (PID: $SSH_PID)"
else
    echo "No SSH key found, SSH server disabled"
fi

# Keep container alive
echo "Container ready. Keeping alive..."

# If SSH is running, wait for it
if [ -n "$SSH_PID" ]; then
    wait $SSH_PID
else
    # Fallback: sleep infinity
    sleep infinity
fi
