const Web3 = require('web3');
const { createAlchemyWeb3 } = require('@alch/alchemy-web3');
const tokenABI = require('./tokenABI.json'); // Assuming you have the ABI saved in a JSON file

// Initialize Web3 with your preferred provider (e.g., Alchemy)
const web3 = createAlchemyWeb3('YOUR_ALCHEMY_API_KEY');

// Set the contract address of the ERC20 token
const tokenAddress = 'TOKEN_CONTRACT_ADDRESS';

// Create contract instance
const tokenContract = new web3.eth.Contract(tokenABI, tokenAddress);

// Account with which you want to send the tokens
const fromAddress = 'YOUR_SENDER_ADDRESS';

// Recipient address
const toAddress = 'RECIPIENT_ADDRESS';

// Amount of tokens to transfer (in the smallest denomination, e.g., wei for Ethereum)
const amount = 'AMOUNT_IN_WEI';

// Function to transfer tokens
async function transferTokens() {
    try {
        // Encode the transfer function with the recipient and amount
        const data = tokenContract.methods.transfer(toAddress, amount).encodeABI();

        // Get the transaction count to use as the nonce
        const nonce = await web3.eth.getTransactionCount(fromAddress, 'latest');

        // Build the transaction object
        const txObject = {
            nonce: nonce,
            from: fromAddress,
            to: tokenAddress,
            gas: web3.utils.toHex(800000), // Adjust gas limit as needed
            gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei')), // Set gas price
            data: data
        };

        // Sign the transaction with your private key
        const signedTx = await web3.eth.accounts.signTransaction(txObject, 'YOUR_PRIVATE_KEY');

        // Send the signed transaction
        const tx = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
        console.log('Transaction hash:', tx.transactionHash);
    } catch (error) {
        console.error('Error transferring tokens:', error);
    }
}

// Call the function to transfer the tokens
transferTokens();
