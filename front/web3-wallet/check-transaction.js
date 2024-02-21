const express = require('express');
const Web3 = require('web3');

const app = express();
const port = 3000;

// Initialize Web3 with provider from MetaMask
const web3 = new Web3(window.ethereum);

app.get('/balance', async (req, res) => {
    try {
        // Request account access
        const accounts = await web3.eth.requestAccounts();
        const selectedAddress = accounts[0];

        // Get the balance of the connected account
        const balance = await web3.eth.getBalance(selectedAddress);

        res.send(`Connected to MetaMask. Your address is: ${selectedAddress}. Your balance is: ${web3.utils.fromWei(balance, 'ether')} ETH`);
    } catch (error) {
        res.status(500).send(`Error connecting to MetaMask: ${error.message}`);
    }
});

app.post('/sendTransaction', async (req, res) => {
    try {
        // Request account access
        const accounts = await web3.eth.requestAccounts();
        const selectedAddress = accounts[0];

        // Create a transaction object
        const txObject = {
            from: selectedAddress,
            to: req.body.toAddress, // Receiver's address
            value: web3.utils.toWei(req.body.amount, 'ether') // Amount in Wei
        };

        // Sign and send the transaction
        const txHash = await web3.eth.sendTransaction(txObject);

        res.send(`Transaction sent. Transaction hash: ${txHash}`);
    } catch (error) {
        res.status(500).send(`Error sending transaction: ${error.message}`);
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
