# hyperledger-fabric-java-demo
Hyperledger fabric java sdk Demo

No TLS

```bash
# 登录到cli节点
$ docker exec -it sdk.jd.com bash

# 创建通道
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer channel create -o orderer.huawei.com:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# 加入通道
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer channel join -b mychannel.block

$ export CORE_PEER_ADDRESS=peer2.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer channel join -b mychannel.block

$ export CORE_PEER_ADDRESS=peer1.baidu.com:7051
$ export CORE_PEER_LOCALMSPID=baiduMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/baidu.com/users/Admin@baidu.com/msp
$ peer channel join -b mychannel.block

$ export CORE_PEER_ADDRESS=peer2.baidu.com:7051
$ export CORE_PEER_LOCALMSPID=baiduMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/baidu.com/users/Admin@baidu.com/msp
$ peer channel join -b mychannel.block

# 安装智能合约
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer chaincode install -n crud -v 1.0 -p github.com/crud/v1.0/go

$ export CORE_PEER_ADDRESS=peer2.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer chaincode install -n crud -v 1.0 -p github.com/crud/v1.0/go

$ export CORE_PEER_ADDRESS=peer1.baidu.com:7051
$ export CORE_PEER_LOCALMSPID=baiduMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/baidu.com/users/Admin@baidu.com/msp
$ peer chaincode install -n crud -v 1.0 -p github.com/crud/v1.0/go

$ export CORE_PEER_ADDRESS=peer2.baidu.com:7051
$ export CORE_PEER_LOCALMSPID=baiduMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/baidu.com/users/Admin@baidu.com/msp
$ peer chaincode install -n crud -v 1.0 -p github.com/crud/v1.0/go

# 检查智能合约是否安装成功
$ docker exec -it peer1.jd.com bash
$ ls /var/hyperledger/production/chaincodes/
crud.1.0

# 实例化智能合约
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer chaincode instantiate -o orderer.huawei.com:7050 -C mychannel -n crud -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P 'OR("jdMSP.member")'

# 如果智能合约初始化成功, 会启动一个新的容器, 名字叫做 dev-peer1.jd.com-crud-1.0
$ docker ps -a

# 执行智能合约
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer chaincode invoke -o orderer.huawei.com:7050 -C mychannel -n crud -c '{"Args":["rawInsert", "age", "80"]}'


# 查询智能合约
$ export CORE_PEER_ADDRESS=peer1.jd.com:7051
$ export CORE_PEER_LOCALMSPID=jdMSP
$ export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/jd.com/users/Admin@jd.com/msp
$ peer chaincode query -C mychannel -n crud -c '{"Args":["rawSelect", "age"]}'
```

TLS

```bash
$ peer channel create -o orderer.huawei.com:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/huawei.com/orderers/orderer.huawei.com/msp/tlscacerts/tlsca.huawei.com-cert.pem

```