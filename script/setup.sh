#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -ev

function main {

# 变量定义
CHANNEL_NAME=mychannel
ORDER_ORG_NAME=huawei
PEER_ORG_NAME_1=jd
PEER_ORG_NAME_2=baidu
CHAIN_CODE_NAME=crud
CHAIN_CODE_VERSION=1.0

# 创建通道
echo "create channel ${CHANNEL_NAME}"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer channel create -o orderer.${ORDER_ORG_NAME}.com:7050 -c ${CHANNEL_NAME} -f /etc/hyperledger/configtx/${CHANNEL_NAME}.tx

# 加入通道
echo "peer1.${PEER_ORG_NAME_1}.com join channel ${CHANNEL_NAME}"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer channel join -b ${CHANNEL_NAME}.block

echo "peer2.${PEER_ORG_NAME_1}.com join channel ${CHANNEL_NAME}"
export CORE_PEER_ADDRESS=peer2.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer channel join -b ${CHANNEL_NAME}.block

echo "peer1.${PEER_ORG_NAME_2}.com join channel ${CHANNEL_NAME}"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_2}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_2}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_2}.com/users/Admin@${PEER_ORG_NAME_2}.com/msp
peer channel join -b ${CHANNEL_NAME}.block

echo "peer2.${PEER_ORG_NAME_2}.com join channel ${CHANNEL_NAME}"
export CORE_PEER_ADDRESS=peer2.${PEER_ORG_NAME_2}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_2}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_2}.com/users/Admin@${PEER_ORG_NAME_2}.com/msp
peer channel join -b ${CHANNEL_NAME}.block

# 安装智能合约
echo "install chaincode ${CHAIN_CODE_NAME}(${CHAIN_CODE_VERSION}) on peer1.${PEER_ORG_NAME_1}.com"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer chaincode install -n ${CHAIN_CODE_NAME} -v ${CHAIN_CODE_VERSION} -p github.com/${CHAIN_CODE_NAME}/${CHAIN_CODE_VERSION}/go

echo "install chaincode ${CHAIN_CODE_NAME}(${CHAIN_CODE_VERSION}) on peer2.${PEER_ORG_NAME_1}.com"
export CORE_PEER_ADDRESS=peer2.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer chaincode install -n ${CHAIN_CODE_NAME} -v ${CHAIN_CODE_VERSION} -p github.com/${CHAIN_CODE_NAME}/${CHAIN_CODE_VERSION}/go

echo "install chaincode ${CHAIN_CODE_NAME}(${CHAIN_CODE_VERSION}) on peer1.${PEER_ORG_NAME_2}.com"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_2}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_2}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_2}.com/users/Admin@${PEER_ORG_NAME_2}.com/msp
peer chaincode install -n ${CHAIN_CODE_NAME} -v ${CHAIN_CODE_VERSION} -p github.com/${CHAIN_CODE_NAME}/${CHAIN_CODE_VERSION}/go

echo "install chaincode ${CHAIN_CODE_NAME}(${CHAIN_CODE_VERSION}) on peer2.${PEER_ORG_NAME_2}.com"
export CORE_PEER_ADDRESS=peer2.${PEER_ORG_NAME_2}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_2}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_2}.com/users/Admin@${PEER_ORG_NAME_2}.com/msp
peer chaincode install -n ${CHAIN_CODE_NAME} -v ${CHAIN_CODE_VERSION} -p github.com/${CHAIN_CODE_NAME}/${CHAIN_CODE_VERSION}/go

# 实例化智能合约
echo "instantiate chaincode ${CHAIN_CODE_NAME}(${CHAIN_CODE_VERSION})"
export CORE_PEER_ADDRESS=peer1.${PEER_ORG_NAME_1}.com:7051
export CORE_PEER_LOCALMSPID=${PEER_ORG_NAME_1}MSP
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEER_ORG_NAME_1}.com/users/Admin@${PEER_ORG_NAME_1}.com/msp
peer chaincode instantiate -o orderer.${ORDER_ORG_NAME}.com:7050 -C ${CHANNEL_NAME} -n ${CHAIN_CODE_NAME} -v ${CHAIN_CODE_VERSION} -c '{"Args":[""]}' -P "OR('${PEER_ORG_NAME_1}MSP.member', '${PEER_ORG_NAME_2}MSP.member')"

# 等待执行指令
sleep 100000000


}

main
