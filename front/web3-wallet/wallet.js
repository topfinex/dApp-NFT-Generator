const express = require('express');
const Web3 = require('web3');

const app = express();
const port = 3000;

// Initialize Web3 with provider from MetaMask
const web3 = new Web3(window.ethereum);

app.get('/', async (req, res) => {
    try {
        // Request account access
        const accounts = await web3.eth.requestAccounts();
        const selectedAddress = accounts[0];

        res.send(`Connected to MetaMask. Your address is: ${selectedAddress}`);
    } catch (error) {
        res.status(500).send(`Error connecting to MetaMask: ${error.message}`);
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
