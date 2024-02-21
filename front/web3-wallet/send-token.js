const Web3 = require('web3');
const { ethers } = require('ethers');

// Infura endpoint (replace with your own Infura endpoint)
const infuraEndpoint = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID';

// Initialize Web3 with the Infura provider
const web3 = new Web3(new Web3.providers.HttpProvider(infuraEndpoint));

// ERC20 token contract address
const tokenAddress = '0xTOKEN_CONTRACT_ADDRESS';

// ERC20 token contract ABI (replace with the ABI of your ERC20 token contract)
const tokenABI = [
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transfer",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

// Ethereum account address and private key for sending the transaction
const senderAddress = '0xYOUR_SENDER_ACCOUNT_ADDRESS';
const senderPrivateKey = 'YOUR_SENDER_ACCOUNT_PRIVATE_KEY';

// Recipient address and the amount of tokens to send
const recipientAddress = '0xRECIPIENT_ACCOUNT_ADDRESS';
const amount = '100'; // Amount in token units (e.g., Wei)

// Function to send ERC20 tokens
async function sendTokens() {
    try {
        // Create a new instance of the ERC20 token contract
        const tokenContract = new web3.eth.Contract(tokenABI, tokenAddress);

        // Construct the transaction data for the token transfer
        const txData = tokenContract.methods.transfer(recipientAddress, amount).encodeABI();

        // Create a new transaction object
        const txObject = {
            from: senderAddress,
            to: tokenAddress,
            gas: 200000, // Gas limit
            data: txData
        };

        // Sign the transaction with the sender's private key
        const signedTx = await web3.eth.accounts.signTransaction(txObject, senderPrivateKey);

        // Send the signed transaction
        const txReceipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

        console.log('Transaction sent:', txReceipt);
    } catch (error) {
        console.error('Error sending transaction:', error);
    }
}

// Call the function to send ERC20 tokens
sendTokens();
