package main

import (
	"encoding/json"
	"fmt"
	
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

const (
	ParamsErrorCode = "403"
	QueryErrorCode  = "402"
)

type RawHistory struct {
	TxIdss   string `json:"txidss"`
	Key      string `json:"key"`
	Value    string `json:"value"`
	IsDelete bool   `json:"isdelete"`
}

type Raw struct {
	Key   string `json:"key"`
	Value string `json:"value"`
}

type CommonChaincode struct {
}

func main() {
	err := shim.Start(new(CommonChaincode))
	if err != nil {
		fmt.Printf("Error starting common chaincode: %s", err)
	}
}

// Init initializes chaincode
// ===========================
func (t *CommonChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

// Invoke - Our entry point for Invocations
// ========================================
func (t *CommonChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fn, params := stub.GetFunctionAndParameters()
	
	fmt.Println("Enter,", "fn", fn, "params", params)
	
	switch fn {
	case "rawInsert":
		return rawInsert(stub, params)
	case "rawListInsert":
		return rawListInsert(stub, params)
	case "rawUpdate":
		return rawUpdate(stub, params)
	case "rawDelete":
		return rawDelete(stub, params)
	case "rawSelect":
		return rawSelect(stub, params)
	case "rawListSelect":
		return rawListSelect(stub, params)
	case "rawHistory":
		return rawHistory(stub, params)
	}
	
	return shim.Success(nil)
}

func rawInsert(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) != 2 {
		return shim.Error(ParamsErrorCode)
	}
	
	stub.PutState(params[0], []byte(params[1]))
	return shim.Success(nil)
}

func rawListInsert(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) < 2 || len(params)%2 != 0 {
		return shim.Error(ParamsErrorCode)
	}
	
	for i := 0; i < len(params); i = i + 2 {
		stub.PutState(params[i], []byte(params[i+1]))
	}
	
	return shim.Success(nil)
}

func rawUpdate(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) != 2 {
		return shim.Error(ParamsErrorCode)
	}
	
	stub.PutState(params[0], []byte(params[1]))
	
	return shim.Success(nil)
}

func rawDelete(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) != 1 {
		return shim.Error(ParamsErrorCode)
	}
	
	stub.DelState(params[0])
	
	return shim.Success(nil)
}

func rawSelect(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) != 1 {
		return shim.Error(ParamsErrorCode)
	}
	
	blob, err := stub.GetState(params[0])
	if err != nil {
		return shim.Error(QueryErrorCode)
	}
	return shim.Success(blob)
}

func rawListSelect(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) < 1 {
		return shim.Error(ParamsErrorCode)
	}
	
	var raws []*Raw
	for i := 0; i < len(params); i++ {
		blob, err := stub.GetState(params[i])
		if err != nil {
			raws = append(raws, &Raw{Key: params[i]})
			continue
		}
		
		raws = append(raws, &Raw{Key: params[i], Value: string(blob)})
	}
	
	rawBytes, err := json.Marshal(raws)
	if err != nil {
		return shim.Error(err.Error()[:10])
	}
	
	fmt.Println("rawListSelect", rawBytes)
	
	return shim.Success(rawBytes)
}

func rawHistory(stub shim.ChaincodeStubInterface, params []string) pb.Response {
	if len(params) != 1 {
		return shim.Error(ParamsErrorCode)
	}
	
	iter, err := stub.GetHistoryForKey(params[0])
	if err != nil {
		return shim.Error(QueryErrorCode)
	}
	defer iter.Close()
	
	var rawHistorys []*RawHistory
	for ; iter.HasNext(); {
		keyModify, err := iter.Next()
		
		if err != nil {
			rawHistorys = append(rawHistorys, &RawHistory{})
			continue
		}
		
		rawHis := &RawHistory{TxIdss: keyModify.TxId, Key: params[0], Value: string(keyModify.Value), IsDelete: keyModify.IsDelete}
		rawHistorys = append(rawHistorys, rawHis)
		
	}
	
	result, err := json.Marshal(rawHistorys)
	if err != nil {
		return shim.Error(err.Error()[:10])
	}
	
	fmt.Println("rawHistory", string(result))
	
	return shim.Success(result)
}
