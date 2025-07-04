#!/bin/bash

export COMPOSE_FILE=docker-compose.yml
export COMPOSE_PROJECT_NAME=search-engine

# The network created by docker-compose will be called ${COMPOSE_PROJECT_NAME}_test as we have the network test in docker-compose
docker network create search_engine
docker-compose down --remove-orphans ; docker-compose up -d