#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /mastermind-hub/tmp/pids/server.pid

# Now execute the command as specified in docker-compose.yml
exec "$@"
