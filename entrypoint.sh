#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /mastermind-hub/tmp/pids/server.pid

# Run the setup script
bash ./mastermind-hub/bin/setup

# Now execute the command as specified in docker-compose.yml
exec "$@"
