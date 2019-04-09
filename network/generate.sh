#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

set -ev

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*
if [ ! -d config ]; then
    mkdir config
fi

# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
configtxgen -profile OrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile MyChannel -outputCreateChannelTx ./config/mychannel.tx -channelID mychannel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile MyChannel -outputAnchorPeersUpdate ./config/baiduMSPanchors.tx -channelID mychannel -asOrg baiduMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for baiduMSP..."
  exit 1
fi

configtxgen -profile MyChannel -outputAnchorPeersUpdate ./config/jdMSPanchors.tx -channelID mychannel -asOrg jdMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for jdMSP..."
  exit 1
fi
