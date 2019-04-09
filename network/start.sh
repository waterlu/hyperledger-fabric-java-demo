#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

docker-compose -f docker-compose.yaml down
docker rm $(docker ps -aq)
docker-compose -f docker-compose.yaml up