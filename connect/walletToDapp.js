const Web3 = require('web3');
const contractABI = require('./contractABI.json');

const contractAddress = 'contract_address';

const web3 = new Web3('network_address');

async function connectToWallet() {
    try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });

        const contract = new web3.eth.Contract(contractABI, contractAddress);
        const contractState = await contract.methods.getState().call();
        await contract.methods.someFunction(parameters).send({ from: userAddress });
    } catch (error) {
        console.error('Error connecting to wallet:', error);
    }
}

connectToWallet();