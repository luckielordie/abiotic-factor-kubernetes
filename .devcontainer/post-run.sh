#!/bin/bash
set -euxo pipefail
# This script runs after the container is created.

# Authenticate GitHub CLI
echo $GITHUB_PAT | gh auth login --with-token

# Authenticate Docker CLI
echo $DOCKER_PAT | docker login -u $DOCKER_USERNAME --password-stdin