package main

import (
	"fmt"
	"log"
	"math/big"
	"strings"
	"time"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/ethclient"
)

const key = `<<json object from keystore>>`

func main() {
	// Create an IPC based RPC connection to a remote node and an authorized transactor
	conn, err := ethclient.Dial("/home/go-ethereum/goerli/geth.ipc")
	if err != nil {
		log.Fatalf("Failed to connect to the Ethereum client: %v", err)
	}
	auth, err := bind.NewTransactor(strings.NewReader(key), "<<strong_password>>")
	if err != nil {
		log.Fatalf("Failed to create authorized transactor: %v", err)
	}

	// Deploy the contract passing the newly created `auth` and `conn` vars
	address, tx, instance, err := DeployStorage(auth, conn, new(big.Int), "Storage contract in Go!", "Go!")
	if err != nil {
		log.Fatalf("Failed to deploy new storage contract: %v", err)
	}

	fmt.Printf("Contract pending deploy: 0x%x\n", address)
	fmt.Printf("Transaction waiting to be mined: 0x%x\n\n", tx.Hash())

	time.Sleep(250 * time.Millisecond) // Allow it to be processed by the local node :P

	// function call on `instance`. Retrieves pending name
	name, err := instance.Name(&bind.CallOpts{Pending: true})
	if err != nil {
		log.Fatalf("Failed to retrieve pending name: %v", err)
	}

	fmt.Println("Pending name:", name)
}
