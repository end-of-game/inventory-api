#!/usr/bin/env bash

# Build images
docker image build -t tperelle/inventory-api ./inventory-api

# Deploy stack
docker stack deploy -c docker-compose.yml inventory
