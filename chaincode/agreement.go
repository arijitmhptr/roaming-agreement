package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// ContractAgreement provides function for managing the Contract
type ContractAgreement struct {
	contractapi.Contract
}

// Agreement describes basic details of whats make up a sample agreement
type Agreement struct {
	ID 				string `json:"ID"`
	HomeNetwork 	string `json:"homenetwork"`
	PartnerNetwork 	string `json:"partnernetwork`
}

// InitLedger adds a base set of Agreement to the ledger
func (s *ContractAgreement) InitLedger(ctx contractapi.TransactionContextInterface) error {

	agreements := []Agreement{
		{ID: "VER24", HomeNetwork: "Verizon", PartnerNetwork: "Vodafone"},
		{ID: "VER25", HomeNetwork: "Verizon", PartnerNetwork: "Airtel"},
		{ID: "VER26", HomeNetwork: "Verizon", PartnerNetwork: "BSNL"},
		{ID: "VER27", HomeNetwork: "Verizon", PartnerNetwork: "Jio"},
	}

	for _, agreement := range agreements {

		agreementJSON, err := json.Marshal(agreement)

		if(err != nil){
			return err
		}	

		err = ctx.GetStub().PutState(agreement.ID, agreementJSON)

		if (err != nil) {
		fmt.Errorf("Failed to put to WorldState. %v", err)
		}
	}

	return nil

}

// CreateAgreement issues a new agreement to the world state with given details.
func (s *ContractAgreement) CreateAgreement(ctx contractapi.TransactionContextInterface, id string, homenetwork string, partnernetwork string) error {
	
	exists, err := s.AgreementExists(ctx, id)
	
	if err != nil {
		return err
	}

	if exists {
		return fmt.Errorf("The contract is already exists", id)
	}

	agreement := Agreement{
		ID: id,
		HomeNetwork: homenetwork,
		PartnerNetwork: partnernetwork,
	}

	agreementJSON, err := json.Marshal(agreement)

	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, agreementJSON)

}

// ReadAgreement returns the agreement stored in the world state with given id.
func (s *ContractAgreement) ReadAgreement(ctx contractapi.TransactionContextInterface, id string) (*Agreement, error) {

	agreementJSON, err := ctx.GetStub().GetState(id)

	if(err != nil) {
		return nil, err
	}

	if(agreementJSON == nil) {
		return nil, fmt.Errorf("The agreement doesn't exist", id)
	}

	var agreement Agreement

	err = json.Unmarshal(agreementJSON, &agreement)

	if(err != nil) {
		return nil, err
	}

	return &agreement, nil

}

// UpdateAgreement updates an existing agreement in the world state with provided parameters.
func (s *ContractAgreement) UpdateAgreement(ctx contractapi.TransactionContextInterface, id string, partnernetwork string) (string, error) {

	if(len(id) == 0) {
		return "", fmt.Errorf("Kindly pass the correct Agreement ID")
	}
	exists, err := s.AgreementExists(ctx, id)
	
	
	if err != nil {
		return "", fmt.Errorf("Failed to get the agreement data. %s", err.Error())
	}

	if (!exists) {
		return "", fmt.Errorf("%s does not exist", id)
	}

	agreementJSON, err := ctx.GetStub().GetState(id)
	var agreement Agreement

	err = json.Unmarshal(agreementJSON, &agreement)

	if(err != nil) {
		return "", err
	}

	agreement.PartnerNetwork = partnernetwork

	agreementBytes, err := json.Marshal(agreement)

	if err != nil {
		return "", fmt.Errorf("Failed while marshling car. %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(id, agreementBytes)

}

// DeleteAgreement deletes an given agreement from the world state.
func (s *ContractAgreement) DeleteAgreement(ctx contractapi.TransactionContextInterface, id string) error {
	
	exists, err := s.AgreementExists(ctx, id)

	if err != nil {
        return err
    }
    
	if !exists {
        return fmt.Errorf("the agreement %s does not exist", id)
    }

	return ctx.GetStub().DelState(id)
}

// GetAllAgreement returns all assets found in world state
func (s *ContractAgreement) GetAllAgreement(ctx contractapi.TransactionContextInterface) ([]*Agreement, error) {

	resultIterator, err := ctx.GetStub().GetStateByRange("","")

	if err != nil {
		return nil, err
	}

	defer resultIterator.Close()

	var agreements []*Agreement

	for resultIterator.HasNext(){

		queryresponse, err := resultIterator.Next()

		if err != nil {
			return nil, err
		}

		var agreement Agreement
		err = json.Unmarshal(queryresponse.Value, &agreement)

		if err != nil {
			return nil, err
		}

		agreements = append(agreements, &agreement)
	}

	return agreements, nil

}

// AgreementExists returns true when Contract with given ID exists in world state
func (s *ContractAgreement) AgreementExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
	
	contractjson, err := ctx.GetStub().GetState(id)

	if (err != nil) {
		return false, fmt.Errorf("Failed to read from worldstate. %v", err)
	}

	return contractjson != nil, nil

}

func main() {

	agreementChaincode, err := contractapi.NewChaincode(&ContractAgreement{})

	if err != nil {
		log.Panicf("Error creating agreement chaincode: %v", err)
	  }

	if err := agreementChaincode.Start(); err != nil {
		log.Panicf("Error starting agreement chaincode: %v", err)
	}

}